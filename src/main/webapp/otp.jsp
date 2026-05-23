<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Verify OTP</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

        <style>
            body {
                background: linear-gradient(120deg, #6a11cb, #2575fc);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .card {
                width: 420px;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0px 0px 25px rgba(0, 0, 0, 0.2);
            }

            .otp-box input {
                font-size: 26px;
                text-align: center;
                letter-spacing: 8px;
            }
        </style>

    </head>

    <body>
        <div id="content">
            <div class="card">

                <h3 class="text-center mb-3">Email Verification</h3>

                <p class="text-center text-muted">
                    Enter the 6-digit OTP sent to your email
                </p>

                <!-- Success -->
                <% String succMsg=(String) session.getAttribute("succMsg"); String failedMsg=(String)
                    session.getAttribute("failedMsg"); %>

                    <% if(succMsg!=null){ %>
                        <div class="alert alert-success">
                            <%=succMsg%>
                        </div>
                        <% session.removeAttribute("succMsg"); %>
                            <% } %>

                                <% if(failedMsg!=null){ %>
                                    <div class="alert alert-danger">
                                        <%=failedMsg%>
                                    </div>
                                    <% session.removeAttribute("failedMsg"); %>
                                        <% } %>

                                            <form action="verifyOtp" method="post">
                                                <input type="hidden" name="csrf_token"
                                                    value="${sessionScope.CSRF_TOKEN}">

                                                <div class="mb-3 otp-box">
                                                    <input type="text" name="otp" class="form-control"
                                                        placeholder="Enter OTP" maxlength="6" required>
                                                </div>

                                                <button class="btn btn-primary w-100">
                                                    Verify OTP
                                                </button>

                                            </form>

                                            <p class="text-center mt-3 text-muted">
                                                OTP valid for 5 minutes
                                            </p>

            </div>
        </div>
    </body>

    </html>