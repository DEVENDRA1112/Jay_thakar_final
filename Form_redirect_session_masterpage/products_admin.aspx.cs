using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

namespace Form_redirect_session_masterpage
{
    public partial class product_admin : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMenuItems();
                LoadMenuItemsGrid();
            }
        }

        private void LoadMenuItems()
        {
            ddlMenuItems.Items.Clear();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ItemID, ItemName FROM MenuItems ORDER BY ItemName";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                var reader = cmd.ExecuteReader();
                ddlMenuItems.DataSource = reader;
                ddlMenuItems.DataTextField = "ItemName";
                ddlMenuItems.DataValueField = "ItemID";
                ddlMenuItems.DataBind();
                con.Close();
            }
            ddlMenuItems.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Item --", "0"));
        }

        private void LoadMenuItemsGrid()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ItemID, Category, ItemName, Price, Description, ImageUrl FROM MenuItems ORDER BY ItemName";
                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                var reader = cmd.ExecuteReader();
                gvMenuItems.DataSource = reader;
                gvMenuItems.DataBind();
                con.Close();
            }
        }

        protected void btnAddItem_Click(object sender, EventArgs e)
        {
            lblAddStatus.Text = "";
            string category = ddlCategory.SelectedValue;
            string name = txtItemName.Text.Trim();
            string desc = txtDescription.Text.Trim();
            decimal price;

            if (string.IsNullOrEmpty(category) || string.IsNullOrEmpty(name) ||
                string.IsNullOrEmpty(desc) || !decimal.TryParse(txtPrice.Text.Trim(), out price))
            {
                lblAddStatus.Text = "Please complete all fields with valid data.";
                return;
            }

            if (!fuImage.HasFile)
            {
                lblAddStatus.Text = "Please select an image file to upload.";
                return;
            }

            string imageFolder = Server.MapPath("~/images/menu/");
            if (!Directory.Exists(imageFolder))
            {
                Directory.CreateDirectory(imageFolder);
            }

            string imageFileName = Path.GetFileName(fuImage.PostedFile.FileName);
            string savePath = Path.Combine(imageFolder, imageFileName);

            try
            {
                fuImage.SaveAs(savePath);
            }
            catch (Exception ex)
            {
                lblAddStatus.Text = "Image upload failed: " + ex.Message;
                return;
            }

            string img = "images/menu/" + imageFileName;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO MenuItems (Category, ItemName, Price, Description, ImageUrl)
                                 VALUES (@Category, @ItemName, @Price, @Description, @ImageUrl)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@ItemName", name);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@Description", desc);
                cmd.Parameters.AddWithValue("@ImageUrl", img);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            lblAddStatus.ForeColor = System.Drawing.Color.Green;
            lblAddStatus.Text = "Menu item added successfully.";

            // Reset fields
            ddlCategory.SelectedIndex = 0;
            txtItemName.Text = "";
            txtPrice.Text = "";
            txtDescription.Text = "";

            LoadMenuItems();
            LoadMenuItemsGrid();
        }

        protected void btnDeleteItem_Click(object sender, EventArgs e)
        {
            lblDeleteStatus.Text = "";
            int itemId;
            if (!int.TryParse(ddlMenuItems.SelectedValue, out itemId) || itemId == 0)
            {
                lblDeleteStatus.Text = "Please select a valid menu item to delete.";
                return;
            }
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM MenuItems WHERE ItemID = @ItemID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ItemID", itemId);

                con.Open();
                int rows = cmd.ExecuteNonQuery();
                con.Close();

                if (rows > 0)
                {
                    lblDeleteStatus.ForeColor = System.Drawing.Color.Green;
                    lblDeleteStatus.Text = "Item deleted successfully.";
                }
                else
                {
                    lblDeleteStatus.Text = "Item not found or already deleted.";
                }
            }

            LoadMenuItems();
            LoadMenuItemsGrid();
        }
    }
}
