using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace Form_redirect_session_masterpage
{
    public partial class Tbooking : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        ReportDocument crystalReport = new ReportDocument();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Prefill customer name if logged in
                if (Session["Name"] != null)
                {
                    txtCustomerName.Text = Session["Name"].ToString();
                    phLogin.Visible = false;
                    litUserName.Visible = true;
                    litUserName.Text = $"<span class='btn btn-success py-2 px-4'>Welcome, {Session["Name"]}</span> " +
                                       "<a href='WebForm3.aspx' class='btn btn-danger py-2 px-4 ml-2'>Logout</a>";
                }
                else
                {
                    phLogin.Visible = true;
                    litUserName.Visible = false;
                }

                LoadTableLayout();
            }
        }

        private void LoadTableLayout()
        {
            DateTime selectedDateTime;
            bool dateParsed = DateTime.TryParse(txtBookingDateTime.Text, out selectedDateTime);
            if (!dateParsed && !string.IsNullOrEmpty(txtBookingDateTime.Text))
            {
                lblMessage.Text = "⚠️ Please select a valid date/time.";
                lblMessage.CssClass = "error";
                return;
            }

            int duration;
            if (!int.TryParse(txtDuration.Text, out duration) || duration <= 0)
                duration = 1;

            DataTable dtTables = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT t.TableID, t.TableName, t.Capacity, t.Status,
                CASE WHEN EXISTS(
                    SELECT 1 FROM Bookings b
                    WHERE b.TableID = t.TableID
                    AND b.BookingDateTime < DATEADD(hour,@Duration,@DT)
                    AND @DT < DATEADD(hour,b.DurationHours,b.BookingDateTime)
                    AND b.Status != 'Cancelled'
                ) THEN 1 ELSE 0 END AS IsBooked
            FROM RestaurantTables t
            WHERE t.Status = 'Available'";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Duration", duration);

                if (dateParsed)
                    cmd.Parameters.AddWithValue("@DT", selectedDateTime);
                else
                    cmd.Parameters.AddWithValue("@DT", DateTime.Now);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtTables);
            }

            StringBuilder sb = new StringBuilder("<div class='table-layout'>");
            foreach (DataRow row in dtTables.Rows)
            {
                string tableId = row["TableID"].ToString();
                string tableName = HttpUtility.HtmlEncode(row["TableName"].ToString());
                int capacity = Convert.ToInt32(row["Capacity"]);
                bool isBooked = Convert.ToInt32(row["IsBooked"]) == 1;
                string tableStatus = row["Status"].ToString();

                // Calculate price based on capacity
                int basePrice = 500;
                double capacityMultiplier = Math.Max(1, capacity / 2.0);
                int tablePrice = (int)Math.Round(basePrice * capacityMultiplier);

                string cssClass = (isBooked || tableStatus != "Available") ? "table booked" : "table available";
                string onclick = (isBooked || tableStatus != "Available") ? "" : $"onclick=\"openBookingModal('{tableId}', '{tableName}', {capacity})\"";

                sb.Append($@"
            <div class='{cssClass}' {onclick}>
                <div class='table-name'>{tableName}</div>
                <div class='table-capacity'>Capacity: {capacity} people</div>
                <div class='table-price'>₹{tablePrice}/hour</div>
                <div class='table-status'>{(isBooked || tableStatus != "Available" ? "Not Available" : "Available")}</div>
            </div>");
            }
            sb.Append("</div>");
            ltlTableLayout.Text = sb.ToString();
        }

        protected void BtnViewAvailability_Click(object sender, EventArgs e)
        {
            LoadTableLayout();
        }

        protected void BtnBookTable_Click(object sender, EventArgs e)
        {
            // Optional if booking directly without payment
            if (string.IsNullOrEmpty(hdnTableId.Value))
            {
                lblMessage.Text = "⚠️ Please select a table first.";
                lblMessage.CssClass = "error";
                return;
            }

            int tableId = int.Parse(hdnTableId.Value);
            string customerName = txtCustomerName.Text.Trim();

            if (!DateTime.TryParse(txtBookingDateTime.Text, out DateTime bookingDateTime))
            {
                lblMessage.Text = "⚠️ Please select a valid booking date/time.";
                lblMessage.CssClass = "error";
                return;
            }

            if (!int.TryParse(txtDuration.Text, out int duration) || duration <= 0)
                duration = 1;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    // Check overlapping bookings
                    SqlCommand checkCmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM Bookings
                        WHERE TableID=@TableID
                        AND BookingDateTime < DATEADD(hour,@Dur,@DT)
                        AND @DT < DATEADD(hour,DurationHours,BookingDateTime)", con, tran);

                    checkCmd.Parameters.AddWithValue("@TableID", tableId);
                    checkCmd.Parameters.AddWithValue("@DT", bookingDateTime);
                    checkCmd.Parameters.AddWithValue("@Dur", duration);

                    int exists = (int)checkCmd.ExecuteScalar();
                    if (exists > 0)
                    {
                        lblMessage.Text = "❌ This table is already booked for that time.";
                        lblMessage.CssClass = "error";
                        tran.Rollback();
                        return;
                    }

                    SqlCommand insertCmd = new SqlCommand(@"
                        INSERT INTO Bookings (TableID, CustomerName, BookingDateTime, DurationHours)
                        VALUES (@TableID,@CustomerName,@DT,@Dur)", con, tran);

                    insertCmd.Parameters.AddWithValue("@TableID", tableId);
                    insertCmd.Parameters.AddWithValue("@CustomerName", customerName);
                    insertCmd.Parameters.AddWithValue("@DT", bookingDateTime);
                    insertCmd.Parameters.AddWithValue("@Dur", duration);

                    insertCmd.ExecuteNonQuery();
                    tran.Commit();

                    lblMessage.Text = "✅ Table booked successfully!";
                    lblMessage.CssClass = "success";
                }
                catch
                {
                    tran.Rollback();
                    lblMessage.Text = "⚠️ Something went wrong. Please try again.";
                    lblMessage.CssClass = "error";
                }
            }

            LoadTableLayout();
        }

        protected void BtnProceedPayment_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hdnTableId.Value))
            {
                lblMessage.Text = "⚠️ Please select a table first.";
                return;
            }

            if (string.IsNullOrEmpty(txtCustomerName.Text) || string.IsNullOrEmpty(txtPhone.Text))
            {
                lblMessage.Text = "⚠️ Please fill in your name and phone number.";
                return;
            }

            // Calculate total amount dynamically (not stored in database)
            int duration;
            if (!int.TryParse(txtDuration.Text, out duration) || duration <= 0)
                duration = 1;

            // Get table capacity to calculate price (you might need to query this)
            int basePrice = 500;
            int estimatedTotal = basePrice * duration; // Simplified calculation

            // Store booking details in session for payment page
            Session["BookingTableId"] = hdnTableId.Value;
            Session["BookingCustomerName"] = txtCustomerName.Text;
            Session["BookingPhone"] = txtPhone.Text;
            Session["BookingDateTime"] = txtBookingDateTime.Text;
            Session["BookingDuration"] = txtDuration.Text;
            Session["BookingTotalAmount"] = estimatedTotal.ToString();

            Response.Redirect("Payment.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = "SELECT BookingID, TableID, CustomerName, BookingDateTime, DurationHours, Status, PaymentStatus, BookingStatus, Phone, TotalAmount FROM Bookings";
                DataSet ds = new DataSet();
                SqlDataAdapter adp = new SqlDataAdapter(sql, con);
                adp.Fill(ds);

                crystalReport.Load(Server.MapPath("~/CRBooking.rpt"));
                crystalReport.SetDataSource(ds.Tables[0]);

                crystalReport.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, "Booking_Crystal_Report");
                crystalReport.Close();
                crystalReport.Dispose();
                Response.End();
            }
        }
    }
}