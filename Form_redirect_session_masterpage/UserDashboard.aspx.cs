using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
                LoadBookings();
            }
        }

        private void LoadBookings()
        {
            string customerName = Session["Name"].ToString();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        b.BookingID,
                        t.TableName,
                        b.BookingDateTime,
                        b.CustomerName,
                        ISNULL(SUM(bm.ItemTotal), 0) AS TotalPrice
                    FROM Bookings b
                    INNER JOIN RestaurantTables t ON b.TableID = t.TableID
                    LEFT JOIN BookingMenus bm ON b.BookingID = bm.BookingID
                    WHERE b.CustomerName = @CustomerName
                    GROUP BY b.BookingID, t.TableName, b.BookingDateTime, b.CustomerName
                    ORDER BY b.BookingDateTime DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CustomerName", customerName);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                con.Open();
                da.Fill(dt);
                con.Close();

                if (dt.Rows.Count > 0)
                {
                    rptBookings.DataSource = dt;
                    rptBookings.DataBind();
                    rptBookings.Visible = true;
                    lblNoBookings.Visible = false;
                }
                else
                {
                    rptBookings.Visible = false;
                    lblNoBookings.Visible = true;
                }

                lblMessage.Visible = false; // Hide message on load
            }
        }

        protected void rptBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CancelBooking")
            {
                int bookingId;
                if (int.TryParse(e.CommandArgument.ToString(), out bookingId))
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        // 1. Delete from Payments table
                        string deletePayments = "DELETE FROM Payments WHERE BookingID = @BookingID";
                        SqlCommand cmdDeletePayments = new SqlCommand(deletePayments, con);
                        cmdDeletePayments.Parameters.AddWithValue("@BookingID", bookingId);

                        // 2. Delete from BookingMenus
                        string deleteMenusQuery = "DELETE FROM BookingMenus WHERE BookingID = @BookingID";
                        SqlCommand cmdDeleteMenus = new SqlCommand(deleteMenusQuery, con);
                        cmdDeleteMenus.Parameters.AddWithValue("@BookingID", bookingId);

                        // 3. Delete from Bookings table
                        string deleteBookingQuery = "DELETE FROM Bookings WHERE BookingID = @BookingID";
                        SqlCommand cmdDeleteBooking = new SqlCommand(deleteBookingQuery, con);
                        cmdDeleteBooking.Parameters.AddWithValue("@BookingID", bookingId);

                        con.Open();
                        cmdDeletePayments.ExecuteNonQuery();
                        cmdDeleteMenus.ExecuteNonQuery();
                        cmdDeleteBooking.ExecuteNonQuery();
                        con.Close();
                    }


                    lblMessage.Text = "Booking cancelled successfully.";
                    lblMessage.Visible = true;

                    LoadBookings(); // Refresh list to update UI
                }
            }
        }
    }
}
