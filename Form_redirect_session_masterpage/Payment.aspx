<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="Form_redirect_session_masterpage.Payment" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Payment - Restaurant</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <!-- Include all your existing CSS and JS links -->
    <style>
        .payment-container {
            max-width: 600px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .booking-summary {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
        }

        .payment-methods {
            display: flex;
            gap: 15px;
            margin: 20px 0;
        }

        .payment-method {
            flex: 1;
            text-align: center;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }

            .payment-method.selected {
                border-color: #28a745;
                background-color: #f8fff9;
            }

        .payment-form {
            display: none;
        }

        .form-group {
            margin-bottom: 15px;
        }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- MENU SELECTION CART -->
        <div class="payment-container" style="margin-bottom: 30px;">
            <h3>🗒️ Add Menu Items</h3>
            <asp:GridView ID="gvMenu" runat="server" AutoGenerateColumns="False" OnRowCommand="gvMenu_RowCommand">
                <Columns>
                    <asp:BoundField DataField="ItemName" HeaderText="Item Name" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="Price" HeaderText="Price (₹)" DataFormatString="{0:F2}" />
                    <asp:TemplateField HeaderText="Qty">
                        <ItemTemplate>
                            <asp:TextBox ID="txtQty" runat="server" Text="1" Width="35px" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnAddMenu" runat="server" Text="Add" CommandName="AddMenu" CommandArgument='<%# Eval("ItemID") %>' CssClass="btn btn-primary btn-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <h5>Selected Menu Items:</h5>
            <asp:Repeater ID="rptCart" runat="server">
                <HeaderTemplate>
                    <table class="table" style="font-size: 0.95em">
                        <tr>
                            <th>Item</th>
                            <th>Qty</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("ItemName") %></td>
                        <td><%# Eval("Quantity") %></td>
                        <td>₹<%# Eval("Price", "{0:F2}") %></td>
                        <td>₹<%# Eval("Total", "{0:F2}") %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate></table></FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="lblMenuTotal" runat="server" Style="font-weight: bold;" />
        </div>
        <!-- END MENU SELECTION -->

        <div class="payment-container">
            <h2>💳 Complete Your Payment</h2>

            <div class="booking-summary">
                <h4>Booking Summary</h4>
                <asp:Literal ID="ltBookingSummary" runat="server" />
                <asp:Label ID="lblFullTotal" runat="server" Style="font-weight: bold; color: green; font-size: 1.2em;" />
            </div>


            <div class="payment-methods">
                <div class="payment-method" onclick="selectPaymentMethod('card')">
                    <i class="fas fa-credit-card fa-2x"></i>
                    <div>Credit/Debit Card</div>
                </div>
                <div class="payment-method" onclick="selectPaymentMethod('upi')">
                    <i class="fas fa-mobile-alt fa-2x"></i>
                    <div>UPI</div>
                </div>
                <div class="payment-method" onclick="selectPaymentMethod('netbanking')">
                    <i class="fas fa-university fa-2x"></i>
                    <div>Net Banking</div>
                </div>
            </div>

            <asp:HiddenField ID="hdnPaymentMethod" runat="server" />

            <!-- Card Payment Form -->
            <div id="cardForm" class="payment-form">
                <div class="form-group">
                    <label>Card Number</label>
                    <asp:TextBox ID="txtCardNumber" runat="server" placeholder="1234 5678 9012 3456" MaxLength="19" />
                </div>
                <div class="form-group">
                    <label>Card Holder Name</label>
                    <asp:TextBox ID="txtCardHolder" runat="server" placeholder="John Doe" />
                </div>
                <div class="form-group" style="display: flex; gap: 15px;">
                    <div style="flex: 1;">
                        <label>Expiry Date</label>
                        <asp:TextBox ID="txtExpiry" runat="server" placeholder="MM/YY" MaxLength="5" />
                    </div>
                    <div style="flex: 1;">
                        <label>CVV</label>
                        <asp:TextBox ID="txtCVV" runat="server" placeholder="123" MaxLength="3" TextMode="Password" />
                    </div>
                </div>
            </div>

            <!-- UPI Payment Form -->
            <div id="upiForm" class="payment-form">
                <div class="form-group">
                    <label>UPI ID</label>
                    <asp:TextBox ID="txtUPI" runat="server" placeholder="yourname@upi" />
                </div>
            </div>

            <!-- Net Banking Form -->
            <div id="netbankingForm" class="payment-form">
                <div class="form-group">
                    <label>Select Bank</label>
                    <asp:DropDownList ID="ddlBank" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">Select Bank</asp:ListItem>
                        <asp:ListItem Value="sbi">State Bank of India</asp:ListItem>
                        <asp:ListItem Value="hdfc">HDFC Bank</asp:ListItem>
                        <asp:ListItem Value="icici">ICICI Bank</asp:ListItem>
                        <asp:ListItem Value="axis">Axis Bank</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <asp:Button ID="btnMakePayment" runat="server" Text="Make Payment"
                CssClass="btn btn-success btn-lg" OnClick="btnMakePayment_Click"
                Enabled="false" />

            <asp:Label ID="lblMessage" runat="server" CssClass="message" />
        </div>
        <p>
            <asp:Button ID="Button1" runat="server" Text="Payment Crystal Report" OnClick="Button1_Click" /></p>
    </form>

    <script>
        function selectPaymentMethod(method) {
            // Remove selected class from all methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });

            // Add selected class to clicked method
            event.target.closest('.payment-method').classList.add('selected');

            // Hide all forms
            document.getElementById('cardForm').style.display = 'none';
            document.getElementById('upiForm').style.display = 'none';
            document.getElementById('netbankingForm').style.display = 'none';

            // Show selected form
            if (method === 'card') {
                document.getElementById('cardForm').style.display = 'block';
            } else if (method === 'upi') {
                document.getElementById('upiForm').style.display = 'block';
            } else if (method === 'netbanking') {
                document.getElementById('netbankingForm').style.display = 'block';
            }

            // Enable payment button
            document.getElementById('<%= btnMakePayment.ClientID %>').disabled = false;
            document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = method;
        }

        // Format card number
        document.getElementById('<%= txtCardNumber.ClientID %>')?.addEventListener('input', function (e) {
            var value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
            var matches = value.match(/\d{4,16}/g);
            var match = matches && matches[0] || '';
            var parts = [];

            for (var i = 0, len = match.length; i < len; i += 4) {
                parts.push(match.substring(i, i + 4));
            }

            if (parts.length) {
                e.target.value = parts.join(' ');
            } else {
                e.target.value = value;
            }
        });

        // Format expiry date
        document.getElementById('<%= txtExpiry.ClientID %>')?.addEventListener('input', function (e) {
            var value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                e.target.value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
        });
    </script>
</body>
</html>
