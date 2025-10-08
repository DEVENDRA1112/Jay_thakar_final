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
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.Fill(dt);
            }
            gvBookedTables.DataSource = dt;
            gvBookedTables.DataBind();
            lblBookedMessage.Text = "Total Bookings: " + dt.Rows.Count.ToString();
        }
    }
}