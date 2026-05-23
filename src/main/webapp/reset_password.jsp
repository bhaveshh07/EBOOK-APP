<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Reset Password</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>

    <body class="bg-light">
        <div id="content">
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-5">

                        <div class="card p-4 shadow">
                            <h3 class="text-center mb-3">Set New Password</h3>
                            <% if(session.getAttribute("failedMsg")!=null){ %>
                                <p class="text-danger text-center">
                                    <%=session.getAttribute("failedMsg")%>
                                </p>
                                <% session.removeAttribute("failedMsg"); } %>

                                    <form action="resetPassword" method="post">
                                        <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

                                        <div class="mb-3">
                                            <label>New Password</label>
                                            <input type="password" id="pass" name="password" class="form-control"
                                                onkeyup="checkStrength()">

                                            <small id="strengthMsg"></small>

                                            <script>
                                                function checkStrength() {
                                                    let p = document.getElementById("pass").value;
                                                    let msg = document.getElementById("strengthMsg");

                                                    if (p.length < 6) {
                                                        msg.innerHTML = "Weak";
                                                        msg.style.color = "red";
                                                    }
                                                    else if (/[A-Z]/.test(p) && /[0-9]/.test(p)) {
                                                        msg.innerHTML = "Strong";
                                                        msg.style.color = "green";
                                                    }
                                                    else {
                                                        msg.innerHTML = "Medium";
                                                        msg.style.color = "orange";
                                                    }
                                                }
                                            </script>

                                        </div>

                                        <button class="btn btn-warning w-100">
                                            Update Password
                                        </button>

                                    </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>