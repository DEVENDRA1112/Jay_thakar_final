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
    public partial class WebForm2 : System.Web.UI.Page
    {
        String s = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        SqlConnection con;//Connection
        SqlDataAdapter da;//Container
        DataSet ds;//Run time container
        SqlCommand cmd;//insert update delete
        //string fnm;

        protected void Page_Load(object sender, EventArgs e)
        {
            getcon();
            //fillgrid();
            if (!IsPostBack)
            {
                {
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
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();

        }
        void clear()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtDateTime.Text = "";
            ddlPeople.Text = "";
            txtMessage.Text = "";


        }

        //void fillgrid()
        //{
        //    getcon();
        //    da = new SqlDataAdapter("select * from TableBooking", con);
        //    ds = new DataSet();
        //    da.Fill(ds);
        //    GridView1.DataSource = ds;
        //    GridView1.DataBind();


        //}
        void select()
        {
            getcon();
            da = new SqlDataAdapter("select * from TableBooking where Id='" + ViewState["id"] + "'", con);
            ds = new DataSet();
            da.Fill(ds);
            //pairing
            txtName.Text = ds.Tables[0].Rows[0][1].ToString();
            txtEmail.Text = ds.Tables[0].Rows[0][2].ToString();
            txtDateTime.Text = ds.Tables[0].Rows[0][3].ToString();
            ddlPeople.SelectedValue = ds.Tables[0].Rows[0][4].ToString();
            txtMessage.Text = ds.Tables[0].Rows[0][5].ToString();
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (btnSubmit.Text == "Book Now")
            {
                getcon();
                //fillgrid();
                cmd = new SqlCommand("insert into TableBooking(Name,Email,DateTime,People,Message)" + " Values('" + txtName.Text + "','" + txtEmail.Text + "','" + txtDateTime.Text + "','" + ddlPeople.Text + "','" + txtMessage.Text + "')", con);

                cmd.ExecuteNonQuery();
                clear();
            }
            
        }
    }
}