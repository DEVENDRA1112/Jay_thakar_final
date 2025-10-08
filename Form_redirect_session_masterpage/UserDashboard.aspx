<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="Form_redirect_session_masterpage.UserDashboard" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>User Dashboard - Restaurant</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <!-- Include all your existing CSS and JS links -->
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            border-left: 4px solid #007bff;
        }
        
        .stat-card.success { border-left-color: #28a745; }
        .stat-card.warning { border-left-color: #ffc107; }
        .stat-card.danger { border-left-color: #dc3545; }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin: 10px 0;
            color: #333;
        }
        
        .stat-card i {
            color: #666;
        }
        
        .booking-history {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .booking-item {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
        }
        
        .booking-item:hover {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .booking-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.9em;
            margin: 2px;
        }
        
        .status-confirmed { background: #d4edda; color: #155724; }
        .status-completed { background: #cce7ff; color: #004085; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .status-pending { background: #fff3cd; color: #856404; }
        
        .no-bookings {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .booking-details {
            flex: 1;
        }
        
        .booking-actions {
            margin-left: 20px;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 0.875rem;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            border: none;
            cursor: pointer;
        }
        
        .btn-warning { background: #ffc107; color: #212529; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        
        .text-muted { color: #6c757d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-container">
            <div class="welcome-section">
                <h1>Welcome back, <asp:Literal ID="litUserName" runat="server" />! 👋</h1>
                <p>Here's your booking dashboard</p>
            </div>
            
            <div class="stats-cards">
                <div class="stat-card">
                    <i class="fas fa-calendar-check fa-2x"></i>
                    <div class="stat-number"><asp:Literal ID="litTotalBookings" runat="server" /></div>
                    <div>Total Bookings</div>
                </div>
                <div class="stat-card success">
                    <i class="fas fa-check-circle fa-2x"></i>
                    <div class="stat-number"><asp:Literal ID="litConfirmedBookings" runat="server" /></div>
                    <div>Confirmed</div>
                </div>
                <div class="stat-card warning">
                    <i class="fas fa-clock fa-2x"></i>
                    <div class="stat-number"><asp:Literal ID="litPendingBookings" runat="server" /></div>
                    <div>Pending</div>
                </div>
                <div class="stat-card danger">
                    <i class="fas fa-times-circle fa-2x"></i>
                    <div class="stat-number"><asp:Literal ID="litCancelledBookings" runat="server" /></div>
                    <div>Cancelled</div>
                </div>
            </div>
            
            <div class="booking-history">
                <h3>📅 Your Booking History</h3>
                <asp:Repeater ID="rptBookings" runat="server">
                    <ItemTemplate>
                        <div class="booking-item">
                            <div class="booking-details">
                                <strong>Table <%# Eval("TableName") %></strong><br />
                                <small>Booking ID: <%# Eval("BookingID") %></small><br />
                                Date: <%# Eval("BookingDateTime", "{0:MMM dd, yyyy hh:mm tt}") %><br />
                                Duration: <%# Eval("DurationHours") %> hours<br />
                                Status: <span class='booking-status status-<%# Eval("StatusClass") %>'><%# Eval("Status") %></span>
                                Payment: <span class='booking-status status-<%# Eval("PaymentStatusClass") %>'><%# Eval("PaymentStatus") %></span>
                            </div>
                            <div class="booking-actions">
                                <%# GetActionButton(Container.DataItem) %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Label ID="lblNoBookings" runat="server" Text="No bookings found." Visible="false" CssClass="no-bookings" />
            </div>
            
            <div style="text-align: center; margin-top: 30px;">
                <a href="Tbooking.aspx" class="btn btn-primary btn-lg">Book New Table</a>
            </div>
        </div>
    </form>

    <script>
        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel this booking?')) {
                // Redirect to cancellation page
                window.location.href = 'CancelBooking.aspx?bookingId=' + bookingId;
            }
        }

        function payNow(bookingId) {
            window.location.href = 'Payment.aspx?bookingId=' + bookingId;
        }
    </script>
</body>
</html>