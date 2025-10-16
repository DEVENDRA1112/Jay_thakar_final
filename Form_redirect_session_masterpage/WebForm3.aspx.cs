using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;

namespace Form_redirect_session_masterpage
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        SqlConnection con;
        SqlCommand cmd;
        ReportDocument crystalReport = new ReportDocument();
        //SqlConnection con = new SqlConnection();

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        void clear()
        {
            txtEmail.Text = "";
            txtPassword.Text = "";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Clear session on fresh page load
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEmail.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                lblMsg.Text = "Enter email and password.";
                lblMsg.CssClass = "text-danger";
                return;
            }
            if (txtEmail.Text.Trim().Equals("admin123@gmail.com", StringComparison.OrdinalIgnoreCase)
        && txtPassword.Text == "123")
            {
                // Redirect to admin dashboard
                Response.Redirect("admin_dashboard.aspx");
                return;
            }
            try
            {
                getcon();


                cmd = new SqlCommand("SELECT Id, Name FROM dbo.Users WHERE Email=@Email AND Password=@Password", con);
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {

                        Session["UserId"] = rdr.GetInt32(0);
                        Session["Name"] = rdr.GetString(1);
                        Session["Email"] = txtEmail.Text.Trim();


                        Response.Redirect("index.aspx");
                    }
                    else
                    {
                        lblMsg.Text = "Invalid email or password.";
                        lblMsg.CssClass = "text-danger";
                    }
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "text-danger";
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = "SELECT Id, Name, Email, Password FROM Users";
                DataSet ds = new DataSet();
                SqlDataAdapter adp = new SqlDataAdapter(sql, con);
                adp.Fill(ds);

                crystalReport.Load(Server.MapPath("~/CRUsers.rpt"));
                crystalReport.SetDataSource(ds.Tables[0]);

                

                crystalReport.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, "Users_Crystal_Report");
                crystalReport.Close();
                crystalReport.Dispose();
                Response.End();
            }
        }
    }
}
