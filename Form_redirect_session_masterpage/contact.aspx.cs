using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Form_redirect_session_masterpage
{
    public partial class contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                {
                    if (Session["Name"] != null)
                    {
                       
                        phLogin.Visible = false;

                   
                        litUserName.Visible = true;
                        litUserName.Text = $"<span class='btn btn-success py-2 px-4'>Welcome, {Session["Name"]}</span> " +
                                           "<a href='Logout.aspx' class='btn btn-danger py-2 px-4 ml-2'>Logout</a>";
                    }
                    else
                    {
                        
                        phLogin.Visible = true;
                        litUserName.Visible = false;
                    }
                }
            }
        }
    }
}