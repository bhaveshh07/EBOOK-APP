<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <%@ page isELIgnored="false" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Ebook: Login</title>
                <%@include file="all_component/allCss.jsp" %>
                    <style>
                        a {
                            text-decoration: none;
                            color: #000;
                            /* Black */
                            font-weight: 500;
                        }

                        a:hover {
                            color: #444;
                            /* Dark gray on hover */
                            text-decoration: none;
                        }

                        .login-actions {
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            position: relative;
                        }

                        .login-actions .forgot-link {
                            position: absolute;
                            right: 0;
                            font-size: 14px;
                            color: #000;
                            text-decoration: none;
                        }

                        .login-actions .forgot-link:hover {
                            text-decoration: none;
                        }

                        .register-link {
                            color: #000;
                            font-weight: 600;
                            text-align: center;
                        }

                        .register-link:hover {
                            color: #444;
                        }
                    </style>
            </head>

            <body style="background-color:#f7f7f7;">

                <%@include file="all_component/navbar.jsp" %>
                 <div id="content">

                        <div class="container mt-5">
                            <div class="row">
                                <div class="col-md-4 offset-md-4">

                                    <div class="card">
                                        <div class="card-body">

                                            <h3 class="text-center">Login</h3>

                                            <!-- Success -->
                                            <c:if test="${not empty succMsg}">
                                                <p class="text-center text-success">${succMsg}</p>
                                                <c:remove var="succMsg" scope="session" />
                                            </c:if>

                                            <!-- Error -->
                                            <c:if test="${not empty failedMsg}">
                                                <p class="text-center text-danger">${failedMsg}</p>
                                                <c:remove var="failedMsg" scope="session" />
                                            </c:if>

                                            <c:if test="${not empty lockSeconds}">
                                                <div class="alert alert-warning text-center">
                                                    Try again in <span id="timer"></span>
                                                </div>

                                                <script>
                                                    let seconds = Number("${lockSeconds}");

                                                    function startTimer() {

                                                        let min = Math.floor(seconds / 60);
                                                        let sec = seconds % 60;

                                                        document.getElementById("timer")
                                                            .innerHTML = min + "m " + sec + "s";

                                                        if (seconds <= 0) {
                                                            location.reload();
                                                        }

                                                        seconds--;
                                                    }

                                                    setInterval(startTimer, 1000);
                                                    startTimer();
                                                </script>

                                                <c:remove var="lockSeconds" scope="session" />
                                            </c:if>


                                            <form action="login" method="post">
                                                <input type="hidden" name="csrf_token"
                                                    value="${sessionScope.CSRF_TOKEN}">

                                                <div class="mb-3">
                                                    <label>Email Address</label>
                                                    <input type="email" class="form-control" name="email" required>
                                                </div>

                                                <div class="mb-3">
                                                    <label>Password</label>
                                                    <input type="password" class="form-control" name="password"
                                                        required>
                                                </div>

                                                <div class="login-actions">
                                                    <button type="submit" class="btn btn-outline-dark">Login</button>
                                                    <a href="<%=request.getContextPath()%>/forgot_password.jsp"
                                                        class="forgot-link">Forgot
                                                        Password?</a>
                                                </div>

                                                <br>

                                                <div class="text-center">
                                                    Don't have account?
                                                    <a href="${pageContext.request.contextPath}/Register.jsp" class="register-link">Register</a>
                                                </div>

                                            </form>


                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <%@include file="all_component/footer.jsp" %>

            </body>

            </html>