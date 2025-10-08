<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login_admin.aspx.cs" Inherits="Form_redirect_session_masterpage.login_admin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Login Page - Product Admin Template</title>
    <!-- CDN Font Awesome: use this for all icons! -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,700" />
    <link rel="stylesheet" href="css_admin/bootstrap.min.css" />
    <link rel="stylesheet" href="css_admin/templatemo-style.css" />

</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar navbar-expand-xl">
            <div class="container h-100">
                <a class="navbar-brand d-flex align-items-center" href="admin_dashboard.aspx">
                    <i class="fas fa-cube fa-lg mr-2" style="color: #ffa500;"></i>
                    <h1 class="tm-site-title mb-0" style="font-size: 1.7rem;">PRODUCT ADMIN</h1>
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
                            <a class="nav-link active" href="admin_dashboard.aspx">
                                <i class="fas fa-tachometer-alt fa-lg"></i>
                                <span class="ml-2">Dashboard</span>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#"
                               id="navbarDropdown" role="button"
                               data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false">
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
                            <a class="nav-link" href="accounts_admin.aspx">
                                <i class="far fa-user fa-lg"></i>
                                <span class="ml-2">Accounts</span>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#"
                               id="navbarDropdown" role="button"
                               data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false">
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
        <div class="container tm-mt-big tm-mb-big">
            <div class="row">
                <div class="col-12 mx-auto tm-login-col">
                    <div class="tm-bg-primary-dark tm-block tm-block-h-auto">
                        <div class="row">
                            <div class="col-12 text-center">
                                <h2 class="tm-block-title mb-4">Welcome to Dashboard, Login</h2>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-12">
                                <asp:Panel ID="pnlLogin" runat="server" CssClass="tm-login-form">
                                    <div class="form-group">
                                        <label for="txtUsername">Username</label>
                                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control validate" required="true"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" ErrorMessage="*" ForeColor="Red" Display="Static" />
                                    </div>
                                    <div class="form-group mt-3">
                                        <label for="txtPassword">Password</label>
                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control validate" required="true"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" ErrorMessage="*" ForeColor="Red" Display="Static" />
                                    </div>
                                    <div class="form-group mt-4">
                                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary btn-block text-uppercase" OnClick="btnLogin_Click" />
                                    </div>
                                    <asp:Button ID="btnForgot" runat="server" Text="Forgot your password?" CssClass="mt-5 btn btn-primary btn-block text-uppercase" />
                                </asp:Panel>
                                <%--<asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <footer class="tm-footer row tm-mt-small">
            <div class="col-12 font-weight-light">
                <p class="text-center text-white mb-0 px-4 small">
                    Copyright &copy; <b>2018</b> All rights reserved.
                    Design: <a rel="nofollow noopener" href="https://templatemo.com" class="tm-footer-link">Template Mo</a>
                </p>
            </div>
        </footer>
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </form>
</body>
</html>
