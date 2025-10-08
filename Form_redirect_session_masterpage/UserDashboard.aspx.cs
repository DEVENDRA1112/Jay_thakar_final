using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Form_redirect_session_masterpage
{
    public partial class UserDashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Name"] == null)
                {
                    Response.Redirect("WebForm3.aspx");
                }

                litUserName.Text = Session["Name"].ToString();
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            string customerName = Session["Name"].ToString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Get booking statistics
                string statsQuery = @"
                    SELECT 
                        COUNT(*) as TotalBookings,
                        SUM(CASE WHEN Status = 'Confirmed' THEN 1 ELSE 0 END) as ConfirmedBookings,
                        SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) as PendingBookings,
                        SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) as CancelledBookings
                    FROM Bookings 
                    WHERE CustomerName = @CustomerName";

                SqlCommand statsCmd = new SqlCommand(statsQuery, con);
                statsCmd.Parameters.AddWithValue("@CustomerName", customerName);

                con.Open();
                SqlDataReader reader = statsCmd.ExecuteReader();
                if (reader.Read())
                {
                    litTotalBookings.Text = reader["TotalBookings"].ToString();
                    litConfirmedBookings.Text = reader["ConfirmedBookings"].ToString();
                    litPendingBookings.Text = reader["PendingBookings"].ToString();
                    litCancelledBookings.Text = reader["CancelledBookings"].ToString();
                }
                reader.Close();

                // Get booking history
                string historyQuery = @"
                    SELECT 
                        b.BookingID,
                        b.TableID,
                        b.CustomerName,
                        b.BookingDateTime,
                        b.DurationHours,
                        b.Status,
                        b.PaymentStatus,
                        t.TableName,
                        CASE 
                            WHEN b.Status = 'Confirmed' THEN 'confirmed'
                            WHEN b.Status = 'Pending' THEN 'pending'
                            WHEN b.Status = 'Cancelled' THEN 'cancelled'
                            ELSE 'pending'
                        END as StatusClass,
                        CASE 
                            WHEN b.PaymentStatus = 'Completed' THEN 'confirmed'
                            WHEN b.PaymentStatus = 'Pending' THEN 'pending'
                            WHEN b.PaymentStatus = 'Failed' THEN 'cancelled'
                            ELSE 'pending'
                        END as PaymentStatusClass
                    FROM Bookings b
                    INNER JOIN RestaurantTables t ON b.TableID = t.TableID
                    WHERE b.CustomerName = @CustomerName
                    ORDER BY b.BookingDateTime DESC";

                SqlDataAdapter da = new SqlDataAdapter(historyQuery, con);
                da.SelectCommand.Parameters.AddWithValue("@CustomerName", customerName);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptBookings.DataSource = dt;
                    rptBookings.DataBind();
                    lblNoBookings.Visible = false;
                }
                else
                {
                    rptBookings.Visible = false;
                    lblNoBookings.Visible = true;
                }
            }
        }

        // This method is called from the ASPX page
        public string GetActionButton(object dataItem)
        {
            if (dataItem == null)
                return "<span class='text-muted'>No actions</span>";

            try
            {
                DataRowView row = (DataRowView)dataItem;
                string status = row["Status"]?.ToString() ?? "";
                string paymentStatus = row["PaymentStatus"]?.ToString() ?? "";
                string bookingId = row["BookingID"]?.ToString() ?? "";

                if (string.IsNullOrEmpty(bookingId))
                    return "<span class='text-muted'>No actions</span>";

                if (status == "Confirmed")
                {
                    return $"<button class='btn-sm btn-warning' onclick='cancelBooking({bookingId})'>Cancel</button>";
                }
                else if (status == "Pending" && paymentStatus == "Pending")
                {
                    return $"<button class='btn-sm btn-success' onclick='payNow({bookingId})'>Pay Now</button>";
                }
                else if (status == "Cancelled")
                {
                    return "<span class='text-muted'>Cancelled</span>";
                }

                return "<span class='text-muted'>No actions</span>";
            }
            catch (Exception ex)
            {
                return "<span class='text-muted'>Error</span>";
            }
        }

        protected void rptBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // This can be used if you switch to Button controls with CommandName
        }
    }
}