using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Form_redirect_session_masterpage
{
    public partial class CancelBooking : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["Name"] == null)
                {
                    Response.Redirect("WebForm3.aspx?returnUrl=" + Server.UrlEncode(Request.Url.ToString()));
                    return;
                }

                // Get booking ID from query string
                string bookingId = Request.QueryString["bookingId"];

                if (!string.IsNullOrEmpty(bookingId))
                {
                    // Validate booking ID format
                    if (int.TryParse(bookingId, out int validBookingId))
                    {
                        CancelBooking1(validBookingId);
                    }
                    else
                    {
                        ShowMessage("❌ Invalid booking ID format.", "error");
                    }
                }
                else
                {
                    ShowMessage("❌ No booking ID provided.", "error");
                }
            }
        }

        private void CancelBooking1(int bookingId)
        {
            try
            {
                string customerName = Session["Name"]?.ToString();

                if (string.IsNullOrEmpty(customerName))
                {
                    ShowMessage("❌ User session expired. Please login again.", "error");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "redirectToLogin",
                        "setTimeout(function(){ window.location.href = 'WebForm3.aspx'; }, 2000);", true);
                    return;
                }

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // First, check if the booking exists and belongs to the user
                    string checkQuery = @"
                        SELECT BookingID, Status, PaymentStatus 
                        FROM Bookings 
                        WHERE BookingID = @BookingID AND CustomerName = @CustomerName";

                    SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                    checkCmd.Parameters.AddWithValue("@BookingID", bookingId);
                    checkCmd.Parameters.AddWithValue("@CustomerName", customerName);

                    using (var reader = checkCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string currentStatus = reader["Status"]?.ToString();
                            string paymentStatus = reader["PaymentStatus"]?.ToString();

                            reader.Close();

                            // Check if booking can be cancelled
                            if (currentStatus == "Cancelled")
                            {
                                ShowMessage("⚠️ This booking is already cancelled.", "error");
                                return;
                            }

                            // Update the booking
                            string updateQuery = @"
                                UPDATE Bookings 
                                SET Status = 'Cancelled', 
                                    PaymentStatus = CASE 
                                        WHEN @CurrentPaymentStatus = 'Completed' THEN 'Refunded' 
                                        ELSE 'Cancelled' 
                                    END
                                WHERE BookingID = @BookingID AND CustomerName = @CustomerName";

                            SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                            updateCmd.Parameters.AddWithValue("@BookingID", bookingId);
                            updateCmd.Parameters.AddWithValue("@CustomerName", customerName);
                            updateCmd.Parameters.AddWithValue("@CurrentPaymentStatus", paymentStatus);

                            int affected = updateCmd.ExecuteNonQuery();

                            if (affected > 0)
                            {
                                ShowMessage("✅ Booking cancelled successfully! Redirecting to dashboard...", "success");

                                // Redirect to dashboard after 2 seconds
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect",
                                    "setTimeout(function(){ window.location.href = 'UserDashboard.aspx'; }, 2000);", true);
                            }
                            else
                            {
                                ShowMessage("❌ Failed to cancel booking. Please try again.", "error");
                            }
                        }
                        else
                        {
                            ShowMessage("❌ Booking not found or you don't have permission to cancel it.", "error");
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                // Log the SQL exception (you can add logging here)
                ShowMessage($"❌ Database error: Please try again later. Error: {sqlEx.Message}", "error");
            }
            catch (Exception ex)
            {
                // Log the general exception
                ShowMessage($"❌ An unexpected error occurred: {ex.Message}", "error");
            }
        }

        private void ShowMessage(string message, string cssClass)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "message " + cssClass;
        }
    }
}