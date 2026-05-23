<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Order Success</title>
            <%@include file="all_component/allCss.jsp" %>

                <style>
                    .page-container {
                        display: flex;
                        flex-direction: column;
                        min-height: 100vh;
                    }

                    .content-wrapper {
                        flex: 1;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        padding: 40px 20px;
                    }


                    .success-container {
                        background-color: #ffffff;
                        padding: 40px;
                        border-radius: 12px;
                        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15);
                        max-width: 450px;
                        width: 100%;
                        text-align: center;
                    }

                    .success-message {
                        text-align: center;
                    }

                    .btn-container {
                        display: flex;
                        justify-content: center;
                        gap: 15px;
                        margin-top: 25px;
                    }


                    .success-icon {
                        font-size: 80px;
                        color: #28a745;
                        margin-bottom: 20px;
                    }

                    .success-message h1 {
                        font-size: 36px;
                        font-weight: bold;
                        color: #333;
                    }

                    .success-message h2 {
                        font-size: 24px;
                        color: #555;
                    }

                    .success-message h5 {
                        font-size: 18px;
                        color: #777;
                        margin-top: 10px;
                    }



                    .success-container {
                        animation: pop 0.4s ease;
                    }

                    @keyframes pop {
                        from {
                            transform: scale(0.8);
                            opacity: 0;
                        }

                        to {
                            transform: scale(1);
                            opacity: 1;
                        }
                    }
                </style>
        </head>

        <body class="page-container bg-light">
            <%@include file="all_component/navbar.jsp" %>
            <div id="content">
                <div class="content-wrapper">
                    <div class="success-container">
                        <i class="fa-solid fa-circle-check success-icon d-block mx-auto"></i>

                        <div class="success-message">
                            <h1>Thank You</h1>
                            <h2>Your order has been placed successfully!</h2>
                            <h5>Your order will be delivered within 5-7 days to your address.</h5>
                        </div>
                        <div class="btn-container">
                            <a href="index.jsp" class="btn btn-outline-success btn-lg">Home</a>
                            <a href="my_orders" class="btn btn-outline-danger btn-lg">View Orders</a>

                        </div>
                    </div>
                </div>
                </div>
                <%@include file="all_component/footer.jsp" %>

        </body>

        </html>