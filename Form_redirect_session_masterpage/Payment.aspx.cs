using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace Form_redirect_session_masterpage
{
    // Data class for menu cart items
    public class CartItem
    {
      
        public int ItemID { get; set; }
        public string ItemName { get; set; }
        public string Category { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public decimal Total { get { return Price * Quantity; } }
    }

    public partial class Payment : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        ReportDocument crystalReport = new ReportDocument();

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
                LoadMenu();
                BindCart(); // Shows any menu items already selected
                UpdateFullTotal(); // Updates combined total
                btnMakePayment.Text = $"Make Payment - ₹{GetFullTotal():F2}";
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
                <strong style='color: green; font-size: 1.2em;'>Booking Amount: ₹{Session["BookingTotalAmount"]}</strong>";
            ltBookingSummary.Text = summary;
        }

        private void LoadMenu()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ItemID, Category, ItemName, Price FROM MenuItems";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvMenu.DataSource = dt;
                gvMenu.DataBind();
            }
        }

        protected void gvMenu_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddMenu")
            {
                int itemID = Convert.ToInt32(e.CommandArgument);
                var row = ((System.Web.UI.WebControls.Button)e.CommandSource).NamingContainer as System.Web.UI.WebControls.GridViewRow;
                System.Web.UI.WebControls.TextBox txtQty = (System.Web.UI.WebControls.TextBox)row.FindControl("txtQty");
                int qty = int.TryParse(txtQty.Text, out int val) ? val : 1;

                // Get menu item details from GridView row
                string itemName = row.Cells[0].Text;
                string category = row.Cells[1].Text;
                decimal price = decimal.Parse(row.Cells[2].Text);

                // Add to cart stored in session
                List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();

                // Update quantity if already in cart
                var existing = cart.Find(x => x.ItemID == itemID);
                if (existing != null)
                    existing.Quantity += qty;
                else
                    cart.Add(new CartItem { ItemID = itemID, ItemName = itemName, Category = category, Price = price, Quantity = qty });

                Session["Cart"] = cart;
                BindCart();
                UpdateFullTotal();
            }
        }

        private void BindCart()
        {
            List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();
            rptCart.DataSource = cart;
            rptCart.DataBind();
            lblMenuTotal.Text = cart.Count > 0 ? $"Menu Total: ₹{cart.Sum(x => x.Total):F2}" : "";
        }

        private decimal GetFullTotal()
        {
            decimal booking = 0;
            decimal.TryParse(Session["BookingTotalAmount"]?.ToString(), out booking);
            List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();
            decimal menuTotal = cart.Sum(x => x.Total);
            return booking + menuTotal;
        }

        private void UpdateFullTotal()
        {
            lblFullTotal.Text = $"Total Amount: ₹{GetFullTotal():F2}";
            btnMakePayment.Text = $"Make Payment - ₹{GetFullTotal():F2}";
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

                decimal bookingAmount;
                if (!decimal.TryParse(totalAmountStr, out bookingAmount))
                    bookingAmount = 500; // Default amount

                // Add menu total
                List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();
                decimal menuTotal = cart.Sum(x => x.Total);
                decimal totalAmount = bookingAmount + menuTotal;

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

                    bool hasTotalAmountColumn = CheckIfColumnExists(con, "Bookings", "TotalAmount");

                    int bookingId;
                    if (hasTotalAmountColumn)
                    {
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

                        bookingId = (int)cmd.ExecuteScalar();
                    }
                    else
                    {
                        string query = @"
                            INSERT INTO Bookings (TableID, CustomerName, BookingDateTime, DurationHours, Status, PaymentStatus)
                            OUTPUT INSERTED.BookingID
                            VALUES (@TableID, @CustomerName, @BookingDateTime, @DurationHours, 'Confirmed', 'Completed')";

                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@TableID", tableId);
                        cmd.Parameters.AddWithValue("@CustomerName", customerName);
                        cmd.Parameters.AddWithValue("@BookingDateTime", bookingDateTime);
                        cmd.Parameters.AddWithValue("@DurationHours", duration);

                        bookingId = (int)cmd.ExecuteScalar();
                    }

                    // Insert payment record
                    string paymentQuery = @"
                        INSERT INTO Payments (BookingID, PaymentStatus, PaymentDate)
                        VALUES (@BookingID, 'Completed', GETDATE())";

                    SqlCommand paymentCmd = new SqlCommand(paymentQuery, con);
                    paymentCmd.Parameters.AddWithValue("@BookingID", bookingId);
                    paymentCmd.ExecuteNonQuery();

                    // Insert menu items to BookingMenus (or similar table)
                    foreach (CartItem item in cart)
                    {
                        string menuInsertQuery = @"
                            INSERT INTO BookingMenus (BookingID, MenuItemID, Quantity, ItemTotal)
                            VALUES (@BookingID, @MenuItemID, @Quantity, @ItemTotal)";
                        SqlCommand menuCmd = new SqlCommand(menuInsertQuery, con);
                        menuCmd.Parameters.AddWithValue("@BookingID", bookingId);
                        menuCmd.Parameters.AddWithValue("@MenuItemID", item.ItemID);
                        menuCmd.Parameters.AddWithValue("@Quantity", item.Quantity);
                        menuCmd.Parameters.AddWithValue("@ItemTotal", item.Total);
                        menuCmd.ExecuteNonQuery();
                    }
                }

                ClearBookingSession();
                Session.Remove("Cart");

                lblMessage.Text = "✅ Payment successful! Your table and menu are booked. Redirecting to dashboard...";
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

        protected void Button1_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = "SELECT PaymentID, BookingID, PaymentStatus, PaymentDate FROM Payments";
                DataSet ds = new DataSet();
                SqlDataAdapter adp = new SqlDataAdapter(sql, con);
                adp.Fill(ds);

                crystalReport.Load(Server.MapPath("~/CRPayments.rpt"));
                crystalReport.SetDataSource(ds.Tables[0]);

                crystalReport.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, "Payments_Crystal_Report");
                crystalReport.Close();
                crystalReport.Dispose();
                Response.End();
            }
        }
    }
}
