<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="testimonial_admin.aspx.cs" Inherits="Form_redirect_session_masterpage.testimonial_admin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin - Testimonials</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,700" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <link rel="stylesheet" href="css_admin/bootstrap.min.css" />
    <link rel="stylesheet" href="css_admin/templatemo-style.css" />
</head>
<body id="reportsPage">
    <form id="form1" runat="server">
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
                            <a class="nav-link dropdown-toggle active" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false">
                                <i class="far fa-file-alt fa-lg"></i>
                                <span class="ml-2">Reports <i class="fas fa-angle-down"></i></span>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="booked_tables_admin.aspx">Booked Tables</a>
                                <a class="dropdown-item active" href="testimonial_admin.aspx">Reviews</a>
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
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
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
        <!-- Main content for reviews -->
        <div class="container py-5">
            <h2 class="mb-4">All Reviews</h2>
            <asp:GridView ID="gvTestimonials" runat="server" 
                        CssClass="table table-bordered table-striped" 
                        AutoGenerateColumns="False"
                        HeaderStyle-CssClass="thead-dark">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="ID" />
                    <asp:BoundField DataField="Name" HeaderText="Name" />
                    <asp:BoundField DataField="Profession" HeaderText="Profession" />
                    <asp:BoundField DataField="Review" HeaderText="Review" />
                </Columns>
            </asp:GridView>
        </div>
    </form>
    <footer class="tm-footer row tm-mt-small">
        <div class="col-12 font-weight-light">
            <p class="text-center text-white mb-0 px-4 small">
                Copyright &copy; <b>2018</b> All rights reserved.
                Design: <a rel="nofollow noopener" href="https://templatemo.com" class="tm-footer-link">Template Mo</a>
            </p>
        </div>
    </footer>
    <script src="js_admin/jquery-3.3.1.min.js"></script>
    <script src="js_admin/moment.min.js"></script>
    <script src="js_admin/Chart.min.js"></script>
    <script src="js_admin/bootstrap.min.js"></script>
    <script src="js_admin/tooplate-scripts.js"></script>
</body>
</html>
