<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="Form_redirect_session_masterpage.UserDashboard" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>User Dashboard - Restaurant</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 900px; margin: auto; padding: 20px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn {
            padding: 7px 15px;
            border: none;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            border-radius: 5px;
            margin-right: 10px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-cancel {
            background-color: #dc3545;
        }
        .btn:hover { opacity: 0.9; }
        .message {
            margin-bottom: 20px;
            font-size: 1em;
            color: green;
        }
        .no-bookings {
            font-style: italic;
            color: gray;
        }
    </style>
</head>
<body>
     <form id="form1" runat="server">
    <h1>Welcome, <asp:Literal ID="litUserName" runat="server" />!</h1>

    <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

    <asp:Repeater ID="rptBookings" runat="server" OnItemCommand="rptBookings_ItemCommand">
        <HeaderTemplate>
            <table>
                <tr>
                    <th>Table Name</th>
                    <th>Booking Date &amp; Time</th>
                    <th>Customer Name</th>
                    <th>Total Price</th>
                    <th>Action</th>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
                <tr>
                    <td><%# Eval("TableName") %></td>
                    <td><%# Eval("BookingDateTime", "{0:MMM dd, yyyy hh:mm tt}") %></td>
                    <td><%# Eval("CustomerName") %></td>
                    <td><%# Eval("TotalPrice", "{0:C}") %></td>
                    <td>
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="CancelBooking" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-cancel" OnClientClick="return confirm('Are you sure you want to cancel this booking?');" />
                    </td>
                </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>

    <asp:Label ID="lblNoBookings" runat="server" Text="No bookings found." Visible="false" CssClass="no-bookings" />

    <div>
        <a href="Index.aspx" class="btn">Go to Home</a>
        <a href="Tbooking.aspx" class="btn">Book a Table</a>
    </div>
         </form>
</body>
</html>
