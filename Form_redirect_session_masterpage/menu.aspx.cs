using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using System.Configuration;
namespace Form_redirect_session_masterpage
{
    public partial class menu : System.Web.UI.Page
    {
        private const string CacheKey = "MenuItemsTable";
        ReportDocument crystalReport = new ReportDocument();
        SqlConnection con = new SqlConnection();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Name"] == null)
            {
                // Not logged in, redirect to login page
                Response.Redirect("WebForm3.aspx");
                return;
            }

            if (!IsPostBack)
            {
                EnsureMenuData();
                BindMenusFiltered(); // initial bind (no filters)
                HandleLoginUI();
            }
        }

        private void EnsureMenuData()
        {
            if (Session[CacheKey] == null)
            {
                string constr = @"Data Source = (LocalDB)\MSSQLLocalDB; AttachDbFilename = C:\Users\DEVENDRA\source\repos\Form_redirect_session_masterpage (2)\Form_redirect_session_masterpage\Form_redirect_session_masterpage\App_Data\Database1.mdf; Integrated Security = True";
                using (SqlConnection con = new SqlConnection(constr))
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM MenuItems", con))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    Session[CacheKey] = dt;
                }
            }
        }

        private DataTable GetMenuTable()
        {
            EnsureMenuData();
            return (DataTable)Session[CacheKey];
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            BindMenusFiltered();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlCategory.ClearSelection();
            ddlCategory.Items[0].Selected = true; // All
            BindMenusFiltered();
        }

        private void BindMenusFiltered()
        {
            var dt = GetMenuTable();
            var dv = new DataView(dt);

            string search = (txtSearch.Text ?? "").Trim();
            string category = ddlCategory.SelectedValue ?? "";

            // Build RowFilter safely: escape single quotes by doubling them
            string filter = "";

            if (!string.IsNullOrEmpty(search))
            {
                string term = search.Replace("'", "''");
                // Search in ItemName and Description with LIKE
                filter += $"(ItemName LIKE '%{term}%' OR Description LIKE '%{term}%')";
            }

            if (!string.IsNullOrEmpty(category))
            {
                string cat = category.Replace("'", "''");
                if (!string.IsNullOrEmpty(filter)) filter += " AND ";
                filter += $"(Category = '{cat}')";
            }

            dv.RowFilter = filter; // applies both search and category [web:10][web:13]

            // Now split dv to three category-specific views for tabs
            DataView dvBreakfast = new DataView(dv.ToTable());
            dvBreakfast.RowFilter = "Category = 'Breakfast'";

            DataView dvLunch = new DataView(dv.ToTable());
            dvLunch.RowFilter = "Category = 'Lunch'";

            DataView dvDinner = new DataView(dv.ToTable());
            dvDinner.RowFilter = "Category = 'Dinner'";

            rptBreakfast.DataSource = dvBreakfast;
            rptBreakfast.DataBind();

            rptLunch.DataSource = dvLunch;
            rptLunch.DataBind();

            rptDinner.DataSource = dvDinner;
            rptDinner.DataBind();
        }

        private void HandleLoginUI()
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
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = "SELECT ItemID, Category, ItemName, Price, Description, ImageUrl FROM MenuItems";
                DataSet ds = new DataSet();
                SqlDataAdapter adp = new SqlDataAdapter(sql, con);
                adp.Fill(ds);

                crystalReport.Load(Server.MapPath("~/CRMenuItems.rpt"));
                crystalReport.SetDataSource(ds.Tables[0]);

                // Set logon information for each table in the report to prevent login failed error
                //foreach (CrystalDecisions.CrystalReports.Engine.Table table in crystalReport.Database.Tables)
                //{
                //    CrystalDecisions.Shared.TableLogOnInfo logOnInfo = table.LogOnInfo;
                //    logOnInfo.ConnectionInfo.ServerName = "";  // Leave blank or set if needed
                //    logOnInfo.ConnectionInfo.DatabaseName = ""; // Leave blank or set if needed
                //    logOnInfo.ConnectionInfo.UserID = "";
                //    logOnInfo.ConnectionInfo.Password = "";
                //    table.ApplyLogOnInfo(logOnInfo);
                //}
                
                crystalReport.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, "MenuItems_Crystal_Report");
                crystalReport.Close();
                crystalReport.Dispose();
                Response.End();
            }
        }

    }
}
