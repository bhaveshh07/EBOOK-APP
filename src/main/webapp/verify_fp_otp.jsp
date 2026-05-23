<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Verify OTP</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>

    <body class="bg-light">
        <div id="content">
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-5">

                        <div class="card p-4 shadow">
                            <h3 class="text-center mb-3">Verify OTP</h3>

                            <% if(session.getAttribute("failedMsg")!=null){ %>
                                <p class="text-danger text-center">
                                    <%=session.getAttribute("failedMsg")%>
                                </p>
                                <% session.removeAttribute("failedMsg"); } %>

                                    <% if(session.getAttribute("succMsg")!=null){ %>
                                        <p class="text-success text-center">
                                            <%=session.getAttribute("succMsg")%>
                                        </p>
                                        <% session.removeAttribute("succMsg"); } %>

                                            <!-- VERIFY OTP FORM -->
                                            <form action="verifyForgotOtp" method="post">
                                                <input type="hidden" name="csrf_token"
                                                    value="${sessionScope.CSRF_TOKEN}">

                                                <div class="mb-3">
                                                    <label>Enter OTP</label>
                                                    <input type="text" name="otp" class="form-control" required>
                                                </div>

                                                <p class="text-center text-muted">
                                                    OTP expires in <span id="timer">05:00</span>
                                                </p>

                                                <button class="btn btn-success w-100">
                                                    Verify OTP
                                                </button>

                                            </form>

                                            <hr>

                                            <!-- RESEND OTP FORM -->
                                            <form action="resendForgotOtp" method="post" class="text-center">
                                                <input type="hidden" name="csrf_token"
                                                    value="${sessionScope.CSRF_TOKEN}">

                                                <button type="submit" class="btn btn-link">
                                                    Resend OTP
                                                </button>
                                            </form>

                        </div>

                    </div>
                </div>
            </div>
        </div>
        <script>
            let time = 300;
            setInterval(() => {
                let min = Math.floor(time / 60);
                let sec = time % 60;
                document.getElementById("timer").innerHTML =
                    String(min).padStart(2, '0') + ":" + String(sec).padStart(2, '0');
                time--;
            }, 1000);
        </script>

    </body>

    </html>