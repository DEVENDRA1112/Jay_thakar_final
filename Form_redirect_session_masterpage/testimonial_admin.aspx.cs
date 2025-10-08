using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Form_redirect_session_masterpage
{
    public partial class testimonial_admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTestimonials();
            }
        }

        private void BindTestimonials()
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["constr"].ConnectionString))
            {
                string query = "SELECT Id, Name, Profession, Review FROM Testimonials ORDER BY Id DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(dr);
                        gvTestimonials.DataSource = dt;
                        gvTestimonials.DataBind();
                    }
                }
            }
        }
    }
}
