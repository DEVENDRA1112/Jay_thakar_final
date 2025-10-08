<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="accounts_admin.aspx.cs" Inherits="Form_redirect_session_masterpage.accounts_admin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Accounts - Product Admin Template</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,700" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="css_admin/bootstrap.min.css" />
    <link rel="stylesheet" href="css_admin/templatemo-style.css" />
</head>
<body id="reportsPage">
    <form id="form1" runat="server">
        <div id="home">
            <nav class="navbar navbar-expand-xl">
                <div class="container h-100">
                    <a class="navbar-brand d-flex align-items-center" href="admin_dashboard.aspx">
                        <i class="fas fa-cube fa-lg mr-2" style="color: #ffa500;"></i>
                        <h1 class="tm-site-title mb-0" style="font-size: 1.7rem;">Product Admin</h1>
                    </a>
                    <button class="navbar-toggler ml-auto mr-0"
                            type="button"
                            data-toggle="collapse"
                            data-target="#navbarSupportedContent"
                            aria-controls="navbarSupportedContent"
                            aria-expanded="false"
                            aria-label="Toggle navigation">
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
                                    <span class="ml-2">
                                        Reports <i class="fas fa-angle-down"></i>
                                    </span>
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <a class="dropdown-item" href="#">Daily Report</a>
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
                                <a class="nav-link active" href="accounts_admin.aspx">
                                    <i class="far fa-user fa-lg"></i>
                                    <span class="ml-2">Accounts</span>
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
                                    <i class="fas fa-cog fa-lg"></i>
                                    <span class="ml-2">
                                        Settings <i class="fas fa-angle-down"></i>
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
            <div class="container mt-5">
                <div class="row tm-content-row">
                    <div class="col-12 tm-block-col">
                        <div class="tm-bg-primary-dark tm-block tm-block-h-auto">
                            <h2 class="tm-block-title">List of Accounts</h2>
                            <p class="text-white">Accounts</p>
                            <asp:DropDownList ID="ddlAccounts" runat="server" CssClass="custom-select">
                                <asp:ListItem Value="0">Select account</asp:ListItem>
                                <asp:ListItem Value="1">Admin</asp:ListItem>
                                <asp:ListItem Value="2">Editor</asp:ListItem>
                                <asp:ListItem Value="3">Merchant</asp:ListItem>
                                <asp:ListItem Value="4">Customer</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <!-- row -->
                <div class="row tm-content-row">
                    <div class="tm-block-col tm-col-avatar">
                        <div class="tm-bg-primary-dark tm-block tm-block-avatar">
                            <h2 class="tm-block-title">Change Avatar</h2>
                            <div class="tm-avatar-container">
                                <asp:Image ID="imgAvatar" runat="server" ImageUrl="img/avatar.png" AlternateText="Avatar" CssClass="tm-avatar img-fluid mb-4" />
                                <a href="#" class="tm-avatar-delete-link">
                                    <i class="far fa-trash-alt tm-product-delete-icon"></i>
                                </a>
                            </div>
                            <asp:Button ID="btnUploadPhoto" runat="server" CssClass="btn btn-primary btn-block text-uppercase" Text="Upload New Photo" />
                        </div>
                    </div>
                    <div class="tm-block-col tm-col-account-settings">
                        <div class="tm-bg-primary-dark tm-block tm-block-settings">
                            <h2 class="tm-block-title">Account Settings</h2>
                            <asp:Panel ID="pnlAccountSettings" runat="server">
                                <div class="row tm-signup-form">
                                    <div class="form-group col-lg-6">
                                        <label for="txtAccountName">Account Name</label>
                                        <asp:TextBox ID="txtAccountName" runat="server" CssClass="form-control validate" />
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label for="txtAccountEmail">Account Email</label>
                                        <asp:TextBox ID="txtAccountEmail" runat="server" CssClass="form-control validate" TextMode="Email" />
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label for="txtPassword">Password</label>
                                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control validate" TextMode="Password" />
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label for="txtReEnterPassword">Re-enter Password</label>
                                        <asp:TextBox ID="txtReEnterPassword" runat="server" CssClass="form-control validate" TextMode="Password" />
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label for="txtPhone">Phone</label>
                                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control validate" TextMode="Phone" />
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label class="tm-hide-sm">&nbsp;</label>
                                        <asp:Button ID="btnUpdateProfile" runat="server" CssClass="btn btn-primary btn-block text-uppercase" Text="Update Your Profile" />
                                    </div>
                                    <div class="col-12">
                                        <asp:Button ID="btnDeleteAccount" runat="server" CssClass="btn btn-primary btn-block text-uppercase" Text="Delete Your Account" />
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
            <footer class="tm-footer row tm-mt-small">
                <div class="col-12 font-weight-light">
                    <p class="text-center text-white mb-0 px-4 small">
                        Copyright &copy; <b>2018</b> All rights reserved.
                        Design:
                        <a rel="nofollow noopener"
                           href="https://templatemo.com"
                           class="tm-footer-link">Template Mo</a>
                    </p>
                </div>
            </footer>
        </div>
    </form>
    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
