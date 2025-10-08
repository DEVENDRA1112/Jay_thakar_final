using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Form_redirect_session_masterpage
{
    public partial class Payment : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["BookingTotalAmount"] == null || Session["BookingCustomerName"] == null)
                {
                    Response.Redirect("Tbooking.aspx");
                    return;
                }

                DisplayBookingSummary();
                btnMakePayment.Text = $"Make Payment - ₹{Session["BookingTotalAmount"]}";
            }
        }

        private void DisplayBookingSummary()
        {
            string summary = $@"
                <strong>Booking Details:</strong><br />
                Customer: {Session["BookingCustomerName"]}<br />
                Phone: {Session["BookingPhone"]}<br />
                Date & Time: {Session["BookingDateTime"]}<br />
                Duration: {Session["BookingDuration"]} hours<br />
                <strong style='color: green; font-size: 1.2em;'>Total Amount: ₹{Session["BookingTotalAmount"]}</strong>";

            ltBookingSummary.Text = summary;
        }

        protected void btnMakePayment_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate payment method selected
                if (string.IsNullOrEmpty(hdnPaymentMethod.Value))
                {
                    lblMessage.Text = "⚠️ Please select a payment method.";
                    lblMessage.CssClass = "error";
                    return;
                }

                // Get session values
                string tableId = Session["BookingTableId"]?.ToString();
                string customerName = Session["BookingCustomerName"]?.ToString();
                string phone = Session["BookingPhone"]?.ToString();
                string bookingDateTimeStr = Session["BookingDateTime"]?.ToString();
                string durationStr = Session["BookingDuration"]?.ToString();
                string totalAmountStr = Session["BookingTotalAmount"]?.ToString();

                if (string.IsNullOrEmpty(tableId) || string.IsNullOrEmpty(customerName))
                {
                    lblMessage.Text = "⚠️ Missing booking information. Please start over.";
                    lblMessage.CssClass = "error";
                    return;
                }

                // Parse values
                DateTime bookingDateTime;
                if (!DateTime.TryParse(bookingDateTimeStr, out bookingDateTime))
                {
                    lblMessage.Text = "⚠️ Invalid booking date/time.";
                    lblMessage.CssClass = "error";
                    return;
                }

                int duration;
                if (!int.TryParse(durationStr, out duration) || duration <= 0)
                    duration = 1;

                decimal totalAmount;
                if (!decimal.TryParse(totalAmountStr, out totalAmount))
                    totalAmount = 500; // Default amount

                // Save to database
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // First check if table is available
                    string checkQuery = @"
                        SELECT COUNT(*) FROM Bookings 
                        WHERE TableID = @TableID 
                        AND BookingDateTime = @BookingDateTime 
                        AND Status != 'Cancelled'";

                    SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                    checkCmd.Parameters.AddWithValue("@TableID", tableId);
                    checkCmd.Parameters.AddWithValue("@BookingDateTime", bookingDateTime);

                    int existingBookings = (int)checkCmd.ExecuteScalar();

                    if (existingBookings > 0)
                    {
                        lblMessage.Text = "⚠️ This table is no longer available for the selected time.";
                        lblMessage.CssClass = "error";
                        return;
                    }

                    // FIRST: Check if TotalAmount column exists
                    bool hasTotalAmountColumn = CheckIfColumnExists(con, "Bookings", "TotalAmount");

                    if (hasTotalAmountColumn)
                    {
                        // Insert booking WITH TotalAmount column
                        string query = @"
                            INSERT INTO Bookings (TableID, CustomerName, BookingDateTime, DurationHours, Status, PaymentStatus, TotalAmount)
                            OUTPUT INSERTED.BookingID
                            VALUES (@TableID, @CustomerName, @BookingDateTime, @DurationHours, 'Confirmed', 'Completed', @TotalAmount)";

                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@TableID", tableId);
                        cmd.Parameters.AddWithValue("@CustomerName", customerName);
                        cmd.Parameters.AddWithValue("@BookingDateTime", bookingDateTime);
                        cmd.Parameters.AddWithValue("@DurationHours", duration);
                        cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);

                        int bookingId = (int)cmd.ExecuteScalar();

                        // Insert payment record
                        string paymentQuery = @"
                            INSERT INTO Payments (BookingID, PaymentStatus, PaymentDate)
                            VALUES (@BookingID, 'Completed', GETDATE())";

                        SqlCommand paymentCmd = new SqlCommand(paymentQuery, con);
                        paymentCmd.Parameters.AddWithValue("@BookingID", bookingId);
                        paymentCmd.ExecuteNonQuery();
                    }
                    else
                    {
                        // Insert booking WITHOUT TotalAmount column
                        string query = @"
                            INSERT INTO Bookings (TableID, CustomerName, BookingDateTime, DurationHours, Status, PaymentStatus)
                            OUTPUT INSERTED.BookingID
                            VALUES (@TableID, @CustomerName, @BookingDateTime, @DurationHours, 'Confirmed', 'Completed')";

                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@TableID", tableId);
                        cmd.Parameters.AddWithValue("@CustomerName", customerName);
                        cmd.Parameters.AddWithValue("@BookingDateTime", bookingDateTime);
                        cmd.Parameters.AddWithValue("@DurationHours", duration);

                        int bookingId = (int)cmd.ExecuteScalar();

                        // Insert payment record
                        string paymentQuery = @"
                            INSERT INTO Payments (BookingID, PaymentStatus, PaymentDate)
                            VALUES (@BookingID, 'Completed', GETDATE())";

                        SqlCommand paymentCmd = new SqlCommand(paymentQuery, con);
                        paymentCmd.Parameters.AddWithValue("@BookingID", bookingId);
                        paymentCmd.ExecuteNonQuery();
                    }
                }

                // Success
                ClearBookingSession();

                lblMessage.Text = "✅ Payment successful! Your table has been booked. Redirecting to dashboard...";
                lblMessage.CssClass = "success";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect",
                    "setTimeout(function(){ window.location.href = 'UserDashboard.aspx'; }, 2000);", true);
            }
            catch (SqlException sqlEx)
            {
                lblMessage.Text = $"❌ Database error: {sqlEx.Message}";
                lblMessage.CssClass = "error";
            }
            catch (Exception ex)
            {
                lblMessage.Text = $"❌ Payment failed: {ex.Message}";
                lblMessage.CssClass = "error";
            }
        }

        // Helper method to check if a column exists in a table
        private bool CheckIfColumnExists(SqlConnection con, string tableName, string columnName)
        {
            try
            {
                string checkColumnQuery = @"
                    SELECT COUNT(*) 
                    FROM INFORMATION_SCHEMA.COLUMNS 
                    WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName";

                SqlCommand checkColumnCmd = new SqlCommand(checkColumnQuery, con);
                checkColumnCmd.Parameters.AddWithValue("@TableName", tableName);
                checkColumnCmd.Parameters.AddWithValue("@ColumnName", columnName);

                int columnExists = (int)checkColumnCmd.ExecuteScalar();
                return columnExists > 0;
            }
            catch
            {
                return false;
            }
        }

        private void ClearBookingSession()
        {
            string[] sessionKeys = {
                "BookingTableId", "BookingCustomerName", "BookingPhone",
                "BookingDateTime", "BookingDuration", "BookingTotalAmount"
            };

            foreach (string key in sessionKeys)
            {
                Session.Remove(key);
            }
        }
    }
}