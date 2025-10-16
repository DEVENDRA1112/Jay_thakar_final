<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="booked_tables_admin.aspx.cs" Inherits="Form_redirect_session_masterpage.booked_tables_admin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Booked Tables - Admin Panel</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,700" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="css_admin/bootstrap.min.css" />
    <link rel="stylesheet" href="css_admin/templatemo-style.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar copied from admin_dashboard.aspx -->
        <nav class="navbar navbar-expand-xl">
            <div class="container h-100">
                <a class="navbar-brand d-flex align-items-center" href="admin_dashboard.aspx">
                    <i class="fas fa-cube fa-lg mr-2" style="color: #ffa500;"></i>
                    <h1 class="tm-site-title mb-0" style="font-size: 1.7rem;">Product Admin</h1>
                </a>
                <button class="navbar-toggler ml-auto mr-0" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
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
                            <a class="nav-link dropdown-toggle active" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="far fa-file-alt fa-lg"></i>
                                <span class="ml-2">Reports <i class="fas fa-angle-down"></i>
                                </span>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item active" href="booked_tables_admin.aspx">Booked Tables</a>
                                <a class="dropdown-item" href="#">Weekly Report</a>
                                <a class="dropdown-item" href="#">Yearly Report</a>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="products_admin.aspx">
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
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-cog fa-lg"></i>
                                <span class="ml-2">Settings <i class="fas fa-angle-down"></i>
                                </span>
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

        <!-- Booked Tables Section -->
        <div class="container py-5">
            <h2 class="mb-4">Booked Tables</h2>
            <asp:Label ID="lblBookedMessage" runat="server" CssClass="status-message"></asp:Label>

            <asp:GridView ID="gvBookedTables" runat="server"
                AutoGenerateColumns="False"
                CssClass="table table-bordered table-striped"
                DataKeyNames="BookingID"
                OnRowDeleting="gvBookedTables_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="BookingID" HeaderText="Booking ID" ReadOnly="True" />
                    <asp:BoundField DataField="TableName" HeaderText="Table Name" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                    <asp:BoundField DataField="BookingDateTime" HeaderText="Booking Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="DurationHours" HeaderText="Duration (Hours)" />
                    <asp:CommandField ShowDeleteButton="True" DeleteText="Delete" />
                </Columns>
            </asp:GridView>
        </div>
    </form>

    <script src="js_admin/jquery-3.3.1.min.js"></script>
    <script src="js_admin/bootstrap.min.js"></script>
</body>
</html>
