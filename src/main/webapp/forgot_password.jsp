<%@ page language="java" contentType="text/html; charset=UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  </head>

  <body class="bg-light">

    <div class="container mt-5">
      <div class="row justify-content-center">
        <div class="col-md-5">

          <div class="card shadow p-4">
            <h3 class="text-center mb-3">Forgot Password</h3>

            <% if(session.getAttribute("failedMsg")!=null){ %>
              <p class="text-danger text-center">
                <%=session.getAttribute("failedMsg")%>
              </p>
              <% session.removeAttribute("failedMsg"); } %>

                <form action="forgotPassword" method="post">
                  <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

                  <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                  </div>

                  <button class="btn btn-primary w-100">
                    Send OTP
                  </button>
                </form>
          </div>

        </div>
      </div>
    </div>
  
  </body>

  </html>