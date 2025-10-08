using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Form_redirect_session_masterpage
{
    public partial class testimonial : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Name"] != null)
                {
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
                BindReviews();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(tbName.Text) && !string.IsNullOrWhiteSpace(tbReview.Text))
            {
                using (SqlConnection con = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["constr"].ConnectionString))
                {
                    string query = "INSERT INTO Testimonials (Name, Profession, Review) VALUES (@Name, @Profession, @Review)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Name", tbName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Profession", string.IsNullOrEmpty(tbProfession.Text) ? "Visitor" : tbProfession.Text.Trim());
                        cmd.Parameters.AddWithValue("@Review", tbReview.Text.Trim());
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                lblMsg.Text = "Thank you for your review!";
                tbName.Text = "";
                tbProfession.Text = "";
                tbReview.Text = "";
                BindReviews();
            }
            else
            {
                lblMsg.Text = "Name and review are required!";
            }
        }

        private void BindReviews()
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["constr"].ConnectionString))
            {
                string query = "SELECT Name, Profession, Review FROM Testimonials ORDER BY Id DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(dr);
                        rptReviews.DataSource = dt;
                        rptReviews.DataBind();
                    }
                }
            }
        }
    }
}
