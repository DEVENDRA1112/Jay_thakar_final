using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Form_redirect_session_masterpage
{
    public partial class menu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindMenus();

                if (Session["Name"] != null)
                {
                    // Hide login link
                    phLogin.Visible = false;

                    // Show username instead
                    litUserName.Visible = true;
                    litUserName.Text = $"<span class='btn btn-success py-2 px-4'>Welcome, {Session["Name"]}</span> " +
                                       "<a href='WebForm3.aspx' class='btn btn-danger py-2 px-4 ml-2'>Logout</a>";
                }
                else
                {
                    // Show login button
                    phLogin.Visible = true;
                    litUserName.Visible = false;
                }
            }
        }

        private void BindMenus()
        {
            string constr = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=""C:\Users\DEVENDRA\source\repos\Form_redirect_session_masterpage (2)\Form_redirect_session_masterpage\Form_redirect_session_masterpage\App_Data\Database1.mdf"";Integrated Security=True"; // Corrected connection string
            using (SqlConnection con = new SqlConnection(constr))
            {
                string query = "SELECT * FROM MenuItems";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                DataView dvBreakfast = new DataView(dt);
                dvBreakfast.RowFilter = "Category = 'Breakfast'";
                rptBreakfast.DataSource = dvBreakfast;
                rptBreakfast.DataBind();

                DataView dvLunch = new DataView(dt);
                dvLunch.RowFilter = "Category = 'Lunch'";
                rptLunch.DataSource = dvLunch;
                rptLunch.DataBind();

                DataView dvDinner = new DataView(dt);
                dvDinner.RowFilter = "Category = 'Dinner'";
                rptDinner.DataSource = dvDinner;
                rptDinner.DataBind();
            }
        }
    }
}
