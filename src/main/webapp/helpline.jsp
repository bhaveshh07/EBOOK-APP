<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>User Helpline</title>

            <%@include file="all_component/allCss.jsp" %>

                <style>
                    /* =========================
   PAGE BACKGROUND
========================= */

                    body {
                        background: #f7f7f7;
                        font-family: Arial, sans-serif;
                    }

                    /* =========================
   CENTER LAYOUT
========================= */

                    .helpline-wrapper {
                        min-height: 70vh;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }

                    /* =========================
   CARD
========================= */

                    .helpline-card {
                        width: 380px;
                        background: white;
                        border-radius: 18px;
                        padding: 35px 30px;
                        text-align: center;
                        box-shadow: 0 15px 40px rgba(0, 0, 0, .12);
                        transition: .4s;
                    }

                    .helpline-card:hover {
                        transform: translateY(-6px);
                    }

                    /* =========================
   ICON
========================= */

                    .helpline-icon {
                        width: 90px;
                        height: 90px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #22c55e, #16a34a);
                        color: white;
                        font-size: 42px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: auto;
                        margin-bottom: 15px;
                    }

                    /* =========================
   TEXT
========================= */

                    .helpline-title {
                        font-size: 26px;
                        font-weight: 700;
                        color: #222;
                    }

                    .helpline-subtitle {
                        font-size: 16px;
                        color: #666;
                        margin-bottom: 20px;
                    }

                    .helpline-number {
                        font-size: 20px;
                        font-weight: 600;
                        color: #2563eb;
                        margin-bottom: 25px;
                    }

                    /* =========================
   BUTTONS
========================= */

                    .btn-box {
                        display: flex;
                        gap: 15px;
                        justify-content: center;
                    }

                    .btn-call {
                        background: #22c55e;
                        color: white;
                        padding: 10px 25px;
                        border-radius: 10px;
                        text-decoration: none;
                        font-weight: 600;
                    }

                    .btn-call:hover {
                        background: #16a34a;
                        color: white;
                    }

                    .btn-home {
                        background: #eef2ff;
                        color: #2563eb;
                        padding: 10px 25px;
                        border-radius: 10px;
                        text-decoration: none;
                        font-weight: 600;
                    }

                    .btn-home:hover {
                        background: #e0e7ff;
                    }

                    /* =========================
   RESPONSIVE
========================= */

                    @media(max-width:500px) {
                        .helpline-card {
                            width: 92%;
                        }
                    }
                </style>

        </head>

        <body>

            <%@include file="all_component/navbar.jsp" %>

                <div id="content">

                    <div class="helpline-wrapper">

                        <div class="helpline-card">

                            <div class="helpline-icon">
                                <i class="fa-solid fa-phone-volume"></i>
                            </div>

                            <div class="helpline-title">24/7 Helpline</div>

                            <div class="helpline-subtitle">
                                We are always here to assist you
                            </div>

                            <div class="helpline-number">
                                +91 9875623014
                            </div>

                            <div class="btn-box">
                                <a href="index.jsp" class="btn-home">Home</a>
                                <a href="tel:+919875623014" class="btn-call">Call Now</a>
                            </div>

                        </div>

                    </div>

                </div>

                <%@include file="all_component/footer.jsp" %>

        </body>

        </html>