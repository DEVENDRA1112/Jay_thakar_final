using System;
using System.Web.UI;

namespace Form_redirect_session_masterpage
{
    public partial class login_admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure page-level setting in case the directive is edited later
            this.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (txtUsername.Text == "agida881@rku.ac.in" && txtPassword.Text == "123")
            {
                Response.Redirect("admin_dashboard.aspx");
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Wrong Admin Id Password');", true);
            }
        }
    }
}
