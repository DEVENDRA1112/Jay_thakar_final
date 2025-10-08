<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="product_admin.aspx.cs" Inherits="Form_redirect_session_masterpage.product_admin" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Menu Admin</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="css_admin/bootstrap.min.css" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <!-- Templatemo CSS for admin panel styling -->
    <link rel="stylesheet" href="css_admin/templatemo-style.css"/>
    <style>
        /* Simple professional form styling - light colors, no dark backgrounds */
        .form-section {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 30px 40px;
            margin: 30px 0;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        }

            .form-section h4 {
                font-weight: 600;
                margin-bottom: 20px;
                color: #333;
                border-bottom: 2px solid #f4a261;
                padding-bottom: 10px;
                letter-spacing: 0.05em;
            }

        .form-group label {
            font-weight: 500;
            color: #555;
            margin-bottom: 6px;
            display: block;
        }

        .form-control, .form-control-file {
            border-radius: 4px;
            border: 1px solid #ccc;
            padding: 10px 15px;
            font-size: 16px;
            box-shadow: none;
            transition: border-color 0.3s ease;
        }

            .form-control:focus, .form-control-file:focus {
                border-color: #f4a261;
                outline: none;
                box-shadow: 0 0 5px rgba(244, 162, 97, 0.6);
            }

        .btn-submit {
            background-color: #f4a261;
            border-color: #f4a261;
            color: #fff;
            font-weight: 600;
            padding: 12px 25px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease;
            border-style: solid;
            border-width: 1.5px;
            cursor: pointer;
        }

            .btn-submit:hover {
                background-color: #e07b40;
                border-color: #e07b40;
            }

        #lblAddStatus, #lblDeleteStatus {
            font-size: 14px;
            margin-top: 12px;
            display: block;
            color: #d9534f; /* Bootstrap danger red */
        }

        .table img {
            max-width: 100px;
            max-height: 80px;
            border-radius: 6px;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!-- Admin Dashboard Navbar -->
        <nav class="navbar navbar-expand-xl">
            <div class="container h-100">
                <a class="navbar-brand d-flex align-items-center" href="admin_dashboard.aspx">
                    <i class="fas fa-cube fa-lg mr-2" style="color: #ffa500;"></i>
                    <h1 class="tm-site-title mb-0" style="font-size: 1.7rem;">Product Admin</h1>
                </a>
                <button class="navbar-toggler ml-auto mr-0" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <i class="fas fa-bars tm-nav-icon"></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav mx-auto h-100">
                        <li class="nav-item">
                            <a class="nav-link" href="admin_dashboard.aspx">
                                <i class="fas fa-tachometer-alt fa-lg"></i>
                                <span class="ml-2">Dashboard</span>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                               <a class="nav-link dropdown-toggle"
                                href="#"
                                id="navbarDropdown"
                                role="button"
                                data-toggle="dropdown"
                                aria-haspopup="true"
                                aria-expanded="false">
                                <i class="far fa-file-alt fa-lg"></i>
                                <span class="ml-2">Reports <i class="fas fa-angle-down"></i>
                                </span>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="booked_tables_admin.aspx">Booked Tables</a>
                                <a class="dropdown-item" href="#">Weekly Report</a>
                                <a class="dropdown-item" href="#">Yearly Report</a>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="products_admin.aspx">
                                <i class="fas fa-shopping-cart fa-lg"></i>
                                <span class="ml-2">Products</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="accounts_admin.aspx">
                                <i class="far fa-user fa-lg"></i>
                                <span class="ml-2">Accounts</span>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                data-toggle="dropdown"
                                aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-cog fa-lg"></i>
                                <span class="ml-2">Settings <i class="fas fa-angle-down"></i></span>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="#">Profile</a>
                                <a class="dropdown-item" href="#">Billing</a>
                                <a class="dropdown-item" href="#">Customize</a>
                            </div>
                        </li>
                    </ul>
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link d-block" href="login_admin.aspx">
                                <i class="fas fa-user-shield fa-lg"></i>
                                <span class="ml-2">Admin, <b>Logout</b></span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Page Content -->
        <div class="container mt-4">
            <h2>Manage Menu Items</h2>
            <!-- Add Menu Item Section -->
            <div class="form-section">
                <h4>Add Menu Item</h4>
                <asp:Label ID="lblAddStatus" runat="server" ForeColor="Red"></asp:Label>
                <div class="form-group">
                    <asp:Label ID="Label1" runat="server" Text="Category:" AssociatedControlID="ddlCategory" />
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Value="Breakfast">Breakfast</asp:ListItem>
                        <asp:ListItem Value="Lunch">Lunch</asp:ListItem>
                        <asp:ListItem Value="Dinner">Dinner</asp:ListItem>
                        <asp:ListItem Value="Snacks">Snacks</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <asp:Label ID="Label2" runat="server" Text="Item Name:" AssociatedControlID="txtItemName" />
                    <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <asp:Label ID="Label3" runat="server" Text="Price:" AssociatedControlID="txtPrice" />
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <asp:Label ID="Label4" runat="server" Text="Description:" AssociatedControlID="txtDescription" />
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                </div>
                <div class="form-group">
                    <asp:Label ID="Label5" runat="server" Text="Upload Image:" AssociatedControlID="fuImage" />
                    <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control-file" />
                </div>
                <asp:Button ID="btnAddItem" runat="server" Text="Add Menu Item" CssClass="btn btn-success btn-submit" OnClick="btnAddItem_Click" />
            </div>

            <!-- Delete Menu Item Section -->
            <div class="form-section">
                <h4>Delete Menu Item</h4>
                <asp:Label ID="lblDeleteStatus" runat="server" ForeColor="Red"></asp:Label>
                <div class="form-group">
                    <asp:DropDownList ID="ddlMenuItems" runat="server" CssClass="form-control" />
                </div>
                <asp:Button ID="btnDeleteItem" runat="server" Text="Delete Selected Item" CssClass="btn btn-danger" OnClick="btnDeleteItem_Click" />
            </div>

            <!-- Display all menu items -->
            <div class="form-section">
                <h4>All Menu Items</h4>
                <asp:GridView ID="gvMenuItems" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-hover">
                    <Columns>
                        <asp:BoundField DataField="ItemID" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="ItemName" HeaderText="Item Name" />
                        <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:ImageField DataImageUrlField="ImageUrl" HeaderText="Image" ControlStyle-Width="100px" ControlStyle-Height="80px" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
