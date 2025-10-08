<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="menu.aspx.cs" Inherits="Form_redirect_session_masterpage.menu" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <title>Restoran - Bootstrap Restaurant Template</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="keywords" />
    <meta content="" name="description" />

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon" />

    <!-- Google Web Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&family=Pacifico&display=swap" rel="stylesheet" />

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet" />
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet" />

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet" />

    <!-- INLINE ORDER BUTTON CSS -->
    <style>
        .order-btn {
            background: #28a745;
            color: #fff;
            border: none;
            padding: 8px 20px;
            border-radius: 8px;
            margin-top: 7px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-xxl bg-white p-0">

            <!-- Navbar & Hero Start -->
            <div class="container-xxl position-relative p-0">
                <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 px-lg-5 py-3 py-lg-0">
                    <a href="index.aspx" class="navbar-brand p-0">
                        <h1 class="text-primary m-0"><i class="fa fa-utensils me-3"></i>Jay Thakar</h1>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                        <span class="fa fa-bars"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarCollapse">
                        <div class="navbar-nav ms-auto py-0 pe-4">
                            <a href="index.aspx" class="nav-item nav-link">Home</a>
                            <a href="About.aspx" class="nav-item nav-link">About</a>
                            <a href="service.aspx" class="nav-item nav-link">Service</a>
                            <a href="menu.aspx" class="nav-item nav-link active">Menu</a>
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                                <div class="dropdown-menu m-0">
                                    <a href="Tbooking.aspx" class="dropdown-item">Booking</a>
                                    <a href="team.aspx" class="dropdown-item">Our Team</a>
                                    <a href="testimonial.aspx" class="dropdown-item">Testimonial</a>
                                </div>
                            </div>
                            <a href="contact.aspx" class="nav-item nav-link">Contact</a>
                        </div>

                        <asp:PlaceHolder ID="phLogin" runat="server">
                            <a href="WebForm3.aspx" class="btn btn-primary py-2 px-4">Login</a>
                        </asp:PlaceHolder>

                        <asp:Literal ID="litUserName" runat="server" Visible="false" />
                    </div>
                </nav>

                <div class="container-xxl py-5 bg-dark hero-header mb-5">
                    <div class="container text-center my-5 pt-5 pb-4">
                        <h1 class="display-3 text-white mb-3 animated slideInDown">Food Menu</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb justify-content-center text-uppercase">
                                <li class="breadcrumb-item"><a href="#">Home</a></li>
                                <li class="breadcrumb-item"><a href="#">Pages</a></li>
                                <li class="breadcrumb-item text-white active" aria-current="page">Menu</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <!-- Navbar & Hero End -->

            <!-- Menu Start -->
            <div class="container-xxl py-5">
                <div class="container">
                    <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                        <h5 class="section-title ff-secondary text-center text-primary fw-normal">Food Menu</h5>
                        <h1 class="mb-5">Most Popular Items</h1>
                    </div>
                    <div class="tab-class text-center wow fadeInUp" data-wow-delay="0.1s">
                        <ul class="nav nav-pills d-inline-flex justify-content-center border-bottom mb-5">
                            <li class="nav-item">
                                <a class="d-flex align-items-center text-start mx-3 ms-0 pb-3 active" data-bs-toggle="pill" href="#tab-1">
                                    <i class="fa fa-coffee fa-2x text-primary"></i>
                                    <div class="ps-3">
                                        <small class="text-body">Popular</small>
                                        <h6 class="mt-n1 mb-0">Breakfast</h6>
                                    </div>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="d-flex align-items-center text-start mx-3 pb-3" data-bs-toggle="pill" href="#tab-2">
                                    <i class="fa fa-hamburger fa-2x text-primary"></i>
                                    <div class="ps-3">
                                        <small class="text-body">Special</small>
                                        <h6 class="mt-n1 mb-0">Lunch</h6>
                                    </div>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="d-flex align-items-center text-start mx-3 me-0 pb-3" data-bs-toggle="pill" href="#tab-3">
                                    <i class="fa fa-utensils fa-2x text-primary"></i>
                                    <div class="ps-3">
                                        <small class="text-body">Lovely</small>
                                        <h6 class="mt-n1 mb-0">Dinner</h6>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <!-- BREAKFAST TAB -->
                            <div id="tab-1" class="tab-pane fade show p-0 active">
                                <div class="row g-4">
                                    <asp:Repeater ID="rptBreakfast" runat="server">
                                        <ItemTemplate>
                                            <div class="col-lg-6">
                                                <div class="d-flex align-items-center">
                                                    <img class="flex-shrink-0 img-fluid rounded" src='<%# Eval("ImageUrl") %>' alt="" style="width: 80px;" />
                                                    <div class="w-100 d-flex flex-column text-start ps-4">
                                                        <h5 class="d-flex justify-content-between border-bottom pb-2">
                                                            <span><%# Eval("ItemName") %></span>
                                                            <span class="text-primary">₹<%# Eval("Price") %></span>
                                                        </h5>
                                                        <small class="fst-italic"><%# Eval("Description") %></small>
                                                        <asp:Button runat="server" Text="Add" CssClass="order-btn" />
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                            <!-- LUNCH TAB -->
                            <div id="tab-2" class="tab-pane fade show p-0">
                                <div class="row g-4">
                                    <asp:Repeater ID="rptLunch" runat="server">
                                        <ItemTemplate>
                                            <div class="col-lg-6">
                                                <div class="d-flex align-items-center">
                                                    <img class="flex-shrink-0 img-fluid rounded" src='<%# Eval("ImageUrl") %>' alt="" style="width: 80px;" />
                                                    <div class="w-100 d-flex flex-column text-start ps-4">
                                                        <h5 class="d-flex justify-content-between border-bottom pb-2">
                                                            <span><%# Eval("ItemName") %></span>
                                                            <span class="text-primary">₹<%# Eval("Price") %></span>
                                                        </h5>
                                                        <small class="fst-italic"><%# Eval("Description") %></small>
                                                        <asp:Button runat="server" Text="Add" CssClass="order-btn" />
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                            <!-- DINNER TAB -->
                            <div id="tab-3" class="tab-pane fade show p-0">
                                <div class="row g-4">
                                    <asp:Repeater ID="rptDinner" runat="server">
                                        <ItemTemplate>
                                            <div class="col-lg-6">
                                                <div class="d-flex align-items-center">
                                                    <img class="flex-shrink-0 img-fluid rounded" src='<%# Eval("ImageUrl") %>' alt="" style="width: 80px;" />
                                                    <div class="w-100 d-flex flex-column text-start ps-4">
                                                        <h5 class="d-flex justify-content-between border-bottom pb-2">
                                                            <span><%# Eval("ItemName") %></span>
                                                            <span class="text-primary">₹<%# Eval("Price") %></span>
                                                        </h5>
                                                        <small class="fst-italic"><%# Eval("Description") %></small>
                                                        <asp:Button runat="server" Text="Add" CssClass="order-btn" />
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Menu End -->

            <!-- Footer Start -->
            <!-- ...Your footer and scripts unchanged... -->
            <!-- Footer End -->
        </div>
    </form>
    <!-- Javascript files -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="lib/wow/wow.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/waypoints/waypoints.min.js"></script>
    <script src="lib/counterup/counterup.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="lib/tempusdominus/js/moment.min.js"></script>
    <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
    <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>
    <script src="js/main.js"></script>
</body>
</html>
