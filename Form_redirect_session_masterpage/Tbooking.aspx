<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tbooking.aspx.cs" Inherits="Form_redirect_session_masterpage.Tbooking" %>

<!DOCTYPE html>
<html>
    <meta charset="utf-8">
    <title>Restoran - Bootstrap Restaurant Template</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&family=Pacifico&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
    <title>Table Booking</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f3f9ff;
            margin: 0;
            padding: 0;
        }
.navbar {
    position: sticky;
    top: 0;
    z-index: 9999;
    background-color: #1c1c1c !important; /* Dark background */
}

.navbar-brand h1 {
    font-size: 1.5rem;
    font-weight: bold;
    color: orange !important;
    font-family: 'Poppins', sans-serif;
}

.navbar-nav .nav-link {
    color: white !important;
    font-weight: 500;
    padding: 0.5rem 1rem;
    transition: color 0.3s ease;
}

.navbar-nav .nav-link.active {
    color: orange !important;
}

.navbar-nav .nav-link:hover {
    color: orange !important;
}

.btn-primary {
    background-color: orange;
    border-color: orange;
    font-weight: bold;
    transition: background-color 0.3s ease;
}

.btn-primary:hover {
    background-color: #e28a00;
    border-color: #e28a00;
}

html {
    scroll-behavior: smooth;
}



        .container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #00224e;
            margin-bottom: 25px;
        }

        .input-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        input, select, button {
            padding: 8px 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #f99b0c;
            color: white;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background-color: #e28a00;
        }

        .table-layout {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            text-align: center;
        }

        .table {
            padding: 15px;
            border-radius: 10px;
            border: 2px solid #007b3e;
            cursor: pointer;
            transition: 0.3s;
        }

        .table.available {
            background-color: #e6ffe6;
        }

        .table.booked {
            background-color: #ffdddd;
            border-color: #c00;
            cursor: not-allowed;
        }

        .table:hover {
            transform: scale(1.05);
        }

        .table-name {
            font-size: 18px;
            font-weight: bold;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.6);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            width: 350px;
            text-align: center;
            position: relative;
        }

        .close-btn {
            position: absolute;
            right: 15px;
            top: 10px;
            font-size: 20px;
            cursor: pointer;
            color: #333;
        }

        #lblMessage {
            text-align: center;
            display: block;
            color: #e33;
            font-weight: 600;
            margin-top: 15px;
        }

        .success {
            color: green;
        
            }
         .table-price {
            font-weight: bold;
            color: #e67e22;
            margin-top: 5px;
        }
        
        .payment-summary {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            border-left: 4px solid #28a745;
        }
    </style>

    <script>
        // Function called when a table is clicked
        function openBookingModal(tableId, tableName) {
            document.getElementById('hdnTableId').value = tableId;
            document.getElementById('modalTableName').innerText = tableName;
            document.getElementById('bookingModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('bookingModal').style.display = 'none';
        }
    </script>
</head>


<body>
    

      <div class="container-xxl bg-white p-0">
        <!-- Spinner Start -->
        <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
        <!-- Spinner End -->


      <!-- Navbar & Hero Start -->

<div class="container-xxl position-relative p-0">
   <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 px-lg-5 py-3 py-lg-0">
        <a href="index.aspx" class="navbar-brand p-0">
            <h1 class="m-0">
                <i class="fa fa-utensils me-3"></i>
                Jay Thakar
            </h1>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="fa fa-bars"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <div class="navbar-nav ms-auto py-0 pe-4">
                <a href="index.aspx" class="nav-item nav-link">Home</a>
                <a href="About.aspx" class="nav-item nav-link active">About</a>
                <a href="service.aspx" class="nav-item nav-link">Service</a>
                <a href="menu.aspx" class="nav-item nav-link">Menu</a>
                <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                    <div class="dropdown-menu m-0">
                        <a href="Tbooking.aspx" class="dropdown-item">Booking</a>
                        <a href="team.aspx" class="dropdown-item">Our Team</a>
                        <a href="UserDashboard.aspx" class="dropdown-item">UserDashboard</a>
                        <a href="testimonial.aspx" class="dropdown-item">Testimonial</a>
                    </div>
                </div>
                <a href="contact.aspx" class="nav-item nav-link">Contact</a>
            </div>

            <!-- Login / Username -->
            <asp:PlaceHolder ID="phLogin" runat="server">
                <a href="WebForm3.aspx" class="btn btn-primary py-2 px-4">Login</a>
            </asp:PlaceHolder>

            <asp:Literal ID="litUserName" runat="server" Visible="false" />
        </div>
    </nav>
</div>
    <form id="form1" runat="server">
        <div class="container">
            <h2>🍽️ Select Your Table</h2>

            <div class="input-group">
                <asp:TextBox ID="txtBookingDateTime" runat="server" TextMode="DateTimeLocal" />
                <asp:TextBox ID="txtDuration" runat="server" Placeholder="Duration (Hours)" Width="150px" />
                <asp:Button ID="BtnViewAvailability" runat="server" Text="View Availability" CssClass="btn" OnClick="BtnViewAvailability_Click" />
            </div>

            <asp:Label ID="lblMessage" runat="server" />

            <asp:Literal ID="ltlTableLayout" runat="server" />

            <asp:HiddenField ID="hdnTableId" runat="server" />
            <asp:HiddenField ID="hdnTablePrice" runat="server" />
            <asp:HiddenField ID="hdnTotalAmount" runat="server" />

            <!-- Modal for Booking -->
            <div id="bookingModal" class="modal">
                <div class="modal-content">
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                    <h3>Book Table: <span id="modalTableName"></span></h3>
                    
                    <div class="payment-summary">
                        <strong>Booking Summary:</strong><br />
                        Table: <span id="modalTableNameSummary"></span><br />
                        Price per hour: ₹<span id="modalTablePrice"></span><br />
                        Duration: <span id="modalDuration"></span> hours<br />
                        <strong>Total Amount: ₹<span id="modalTotalAmount"></span></strong>
                    </div>

                    <asp:TextBox ID="txtCustomerName" runat="server" Placeholder="Your Name" Width="90%" /><br /><br />
                    <asp:TextBox ID="txtPhone" runat="server" Placeholder="Phone Number" Width="90%" /><br /><br />

                    <asp:Button ID="BtnProceedPayment" runat="server" Text="Proceed to Payment" OnClick="BtnProceedPayment_Click" CssClass="btn btn-success" />
                </div>
            </div>
        </div>
    </form>

<script>
    function openBookingModal(tableId, tableName, tablePrice) {
        var duration = document.getElementById('<%= txtDuration.ClientID %>').value || 1;
            var totalAmount = tablePrice * duration;
            
            document.getElementById('hdnTableId').value = tableId;
            document.getElementById('hdnTablePrice').value = tablePrice;
            document.getElementById('hdnTotalAmount').value = totalAmount;
            
            document.getElementById('modalTableName').innerText = tableName;
            document.getElementById('modalTableNameSummary').innerText = tableName;
            document.getElementById('modalTablePrice').innerText = tablePrice;
            document.getElementById('modalDuration').innerText = duration;
            document.getElementById('modalTotalAmount').innerText = totalAmount;
            
            document.getElementById('bookingModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('bookingModal').style.display = 'none';
        }

        // Update total amount when duration changes
        document.getElementById('<%= txtDuration.ClientID %>').addEventListener('change', function () {
        var tablePrice = document.getElementById('hdnTablePrice').value;
        var duration = this.value || 1;
        var totalAmount = tablePrice * duration;

        document.getElementById('modalDuration').innerText = duration;
        document.getElementById('modalTotalAmount').innerText = totalAmount;
        document.getElementById('hdnTotalAmount').value = totalAmount;
    });
</script>
              <!-- JavaScript Libraries -->
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

  <!-- Template Javascript -->
  <script src="js/main.js"></script>
</body>
</html>
