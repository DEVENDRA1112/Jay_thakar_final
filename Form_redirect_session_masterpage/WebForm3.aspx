<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm3.aspx.cs" Inherits="Form_redirect_session_masterpage.WebForm3" %>

<!doctype html>
<html lang="en">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login</title>
  <link rel="preconnect" href="https://cdn.jsdelivr.net" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    :root { --bg:#0b0e14; --panel:#121722; --muted:#8b93a7; --text:#e8ecf3; --accent:#ffb116; }
    html,body{height:100%}
    body{margin:0; background:var(--bg); color:var(--text); font-feature-settings:"ss01" 1;}
    .wrap{min-height:100%; display:grid; place-items:center; padding:24px}
    .card-auth{ width:min(94vw, 460px); background:var(--panel); border:1px solid #1e2430; border-radius:16px; box-shadow:0 20px 60px rgba(0,0,0,.5); }
    .pad{padding:28px}
    .brand{font-weight:800; letter-spacing:.3px}
    .accent{color:var(--accent)}
    .btn-accent{background:var(--accent); color:#111; border:0;}
    .btn-accent:hover{background:#e09d11; color:#111}
    .form-control{background:#0b0e14; border-color:#2a3243; color:#fff;}
    .form-control::placeholder{color:#6c7384}
    .form-control:focus{border-color:var(--accent); box-shadow:0 0 0 .2rem rgba(255,177,22,.25)}
    .help{color:var(--muted)}
    a.link {color:#cfd6e5; text-decoration:none}
    a.link:hover{color:var(--accent)}
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <div class="wrap">
      <div class="card-auth">
        <div class="pad">
          <div class="mb-3 text-center brand">Restoran<span class="accent">.</span></div>
          <h1 class="h4 fw-bold mb-1">Sign in</h1>
          <p class="help mb-4">Access reservations and orders.</p>

          <asp:Label ID="lblMsg" runat="server" CssClass="mb-2 d-block"></asp:Label>

          <div class="mb-3">
            <label class="form-label small">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-4">
            <label class="form-label small">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
          </div>

          <asp:Button ID="btnSubmit" runat="server" Text="Sign in" CssClass="btn btn-accent w-100 py-2 fw-semibold" OnClick="btnSubmit_Click" />

          <hr class="my-4 border-secondary" />
          <p class="mb-0 text-center">
            New here?
            <a class="link-light" href="WebForm4.aspx">Create account</a>
          </p>
        </div>
      </div>
    </div>
  </form>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>