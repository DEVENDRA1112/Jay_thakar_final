using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Form_redirect_session_masterpage
{
    public partial class booked_tables_admin : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBookedTables();
            }
        }

        private void LoadBookedTables()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT 
                                    b.BookingID,
                                    t.TableName,
                                    b.CustomerName,
                                    b.BookingDateTime,
                                    b.DurationHours
                                 FROM Bookings b
                                 INNER JOIN RestaurantTables t ON b.TableID = t.TableID
                                 ORDER BY b.BookingDateTime ASC";
                using (SqlDataAdapter da = new SqlDataAdapter(query, con))
                {
                    da.Fill(dt);
                }
            }

            gvBookedTables.DataSource = dt;
            gvBookedTables.DataBind();
            lblBookedMessage.Text = "Total Bookings: " + dt.Rows.Count.ToString();
        }

        protected void gvBookedTables_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            // Get BookingID from DataKeys
            int bookingId = Convert.ToInt32(gvBookedTables.DataKeys[e.RowIndex].Value);

            int rows;
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("DELETE FROM Bookings WHERE BookingID = @BookingID", con))
            {
                cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingId;
                con.Open();
                rows = cmd.ExecuteNonQuery();
            }

            if (rows > 0)
            {
                lblBookedMessage.Text = "Booking deleted successfully. ID: " + bookingId.ToString();
            }
            else
            {
                lblBookedMessage.Text = "Delete failed or booking not found. ID: " + bookingId.ToString();
            }

            // Rebind updated data
            LoadBookedTables();

            // Prevent GridView from trying default data-source delete
            e.Cancel = true;
        }
    }
}
