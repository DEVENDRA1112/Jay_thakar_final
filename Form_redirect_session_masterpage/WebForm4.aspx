<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm4.aspx.cs" Inherits="Form_redirect_session_masterpage.WebForm4" %>

<!doctype html>
<html lang="en">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Register</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-dark text-light">
  <form id="form1" runat="server">
    <div class="container d-flex justify-content-center align-items-center" style="min-height:100vh">
      <div class="card border-0 shadow" style="max-width:520px; width:100%">
        <div class="card-body p-4">
          <h1 class="h4 fw-bold mb-1 text-dark">Create account</h1>
          <asp:Label ID="lblMsg" runat="server" CssClass="mb-3 d-block"></asp:Label>

          <div class="mb-3">
            <label class="form-label">Name</label>
            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
          </div>

          <div class="mb-3">
            <label class="form-label">Email address</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
          </div>

          <div class="mb-4">
            <label class="form-label">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
          </div>

          <asp:Button ID="btnSubmit" runat="server" Text="Create account" CssClass="btn btn-warning w-100" OnClick="btnSubmit_Click" />

          <hr class="my-4" />
          <p class="mb-0 text-center text-secondary">
            Already have an account?
            <a href="WebForm3.aspx" class="text-decoration-none">Sign in</a>
          </p>
        </div>
      </div>
    </div>
  </form>
</body>
</html>