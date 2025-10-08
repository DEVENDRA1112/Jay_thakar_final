using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace Form_redirect_session_masterpage
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        String s = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        SqlConnection con;//Connection
        SqlDataAdapter da;//Container
        DataSet ds;//Run time container
        SqlCommand cmd;//insert update delete
        //string fnm;

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();

        }


        void clear()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (btnSubmit.Text == "Create account")
            {
                if (string.IsNullOrWhiteSpace(txtName.Text) ||
                    string.IsNullOrWhiteSpace(txtEmail.Text) ||
                    string.IsNullOrWhiteSpace(txtPassword.Text))
                {
                    lblMsg.Text = "Please fill Name, Email, and Password.";
                    lblMsg.CssClass = "text-danger";
                    return;
                }

                try
                {
                    getcon();

                   
                    cmd = new SqlCommand("SELECT COUNT(1) FROM dbo.Users WHERE Email=@Email", con);
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    int exists = Convert.ToInt32(cmd.ExecuteScalar());
                    if (exists > 0)
                    {
                        lblMsg.Text = "Email already registered.";
                        lblMsg.CssClass = "text-danger";
                        return;
                    }

                    cmd = new SqlCommand(
                        "INSERT INTO dbo.Users (Name, Email, Password) VALUES (@Name, @Email, @Password)", con);
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text); 
                    cmd.ExecuteNonQuery();

                    clear();
                    lblMsg.Text = "Account created. You can sign in now.";
                    lblMsg.CssClass = "text-success";
                   
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "Error: " + ex.Message;
                    lblMsg.CssClass = "text-danger";
                }
            }
        }
    }
}