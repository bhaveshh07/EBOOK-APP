<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Contact Us - Ebook Management System</title>
            <%@include file="all_component/allCss.jsp" %>

                <style>
                    /* =========================
   PAGE BACKGROUND
========================= */

                    body {
                        background: #f7f7f7;
                    }

                    /* =========================
   LAYOUT
========================= */

                    .contact-wrapper {
                        min-height: 70vh;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        gap: 60px;
                        padding: 40px 0;
                        flex-wrap: wrap;
                    }

                    /* =========================
   CONTACT CARD
========================= */

                    .contact-card {
                        width: 400px;
                        background: #fff;
                        padding: 35px 30px;
                        border-radius: 18px;
                        text-align: center;
                        box-shadow: 0 15px 40px rgba(0, 0, 0, .12);
                        transition: .4s;
                    }

                    .contact-card:hover {
                        transform: translateY(-6px);
                    }

                    /* =========================
   ICON
========================= */

                    .contact-icon {
                        width: 85px;
                        height: 85px;
                        background: linear-gradient(135deg, #4e73df, #224abe);
                        color: #fff;
                        font-size: 38px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: auto;
                        margin-bottom: 15px;
                    }

                    /* =========================
   TEXT
========================= */

                    .contact-title {
                        font-size: 26px;
                        font-weight: 700;
                        color: #222;
                    }

                    .contact-subtitle {
                        color: #666;
                        margin-bottom: 25px;
                    }

                    /* =========================
   ROWS
========================= */

                    .contact-row {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                        background: #f6f8ff;
                        padding: 14px 18px;
                        border-radius: 12px;
                        margin-bottom: 15px;
                        transition: .3s;
                    }

                    .contact-row:hover {
                        background: #eef2ff;
                        transform: scale(1.02);
                    }

                    .row-icon {
                        width: 42px;
                        height: 42px;
                        background: #4e73df;
                        color: #fff;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .row-text {
                        text-align: left;
                    }

                    .row-label {
                        font-size: 13px;
                        color: #777;
                    }

                    .row-value {
                        font-size: 15px;
                        font-weight: 600;
                        color: #222;
                    }

                    /* =========================
   FORM
========================= */

                    .contact-form-title {
                        margin-top: 25px;
                        margin-bottom: 10px;
                        font-weight: 600;
                    }

                    .mini-form input,
                    .mini-form textarea {
                        width: 100%;
                        padding: 12px;
                        border-radius: 10px;
                        border: 1px solid #ccc;
                        margin-bottom: 12px;
                    }

                    .mini-form textarea {
                        height: 90px;
                        resize: none;
                    }

                    .send-btn {
                        width: 100%;
                        border: none;
                        padding: 12px;
                        border-radius: 12px;
                        background: linear-gradient(135deg, #4e73df, #224abe);
                        color: white;
                        font-weight: 600;
                    }

                    .send-btn:hover {
                        transform: translateY(-2px);
                    }

                    /* =========================
   SUCCESS MSG
========================= */

                    .success-msg {
                        display: none;
                        margin-top: 15px;
                        background: #e6fffa;
                        color: #047857;
                        padding: 12px;
                        border-radius: 10px;
                    }

                    /* =========================
   MAP
========================= */

                    .map-wrapper {
                        width: 460px;
                    }

                    .map-title {
                        font-weight: 600;
                        margin-bottom: 10px;
                    }

                    .map-box {
                        width: 100%;
                        height: 300px;
                        border-radius: 22px;
                        overflow: hidden;
                        box-shadow: 0 12px 30px rgba(0, 0, 0, .12);
                    }

                    .map-box iframe {
                        width: 100%;
                        height: 100%;
                        border: 0;
                    }

                    /* =========================
   ANIMATION
========================= */

                    .animate-in {
                        opacity: 0;
                        transform: translateY(40px);
                        animation: slideFade .9s ease forwards;
                    }

                    @keyframes slideFade {
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    /* =========================
   RESPONSIVE
========================= */

                    @media(max-width:900px) {
                        .contact-wrapper {
                            flex-direction: column;
                            align-items: center;
                        }
                    }
                </style>

        </head>

        <body>

            <%@include file="all_component/navbar.jsp" %>

                <div id="content">
                    <div class="container">

                        <div class="contact-wrapper">

                            <!-- LEFT CARD -->
                            <div class="contact-card animate-in">

                                <div class="contact-icon">
                                    <i class="fa-solid fa-headset"></i>
                                </div>

                                <div class="contact-title">Contact Us</div>
                                <div class="contact-subtitle">We are here to assist you</div>

                                <div class="contact-row">
                                    <div class="row-icon"><i class="fa-solid fa-envelope"></i></div>
                                    <div class="row-text">
                                        <div class="row-label">Email</div>
                                        <div class="row-value">support@ebookmanagement.com</div>
                                    </div>
                                </div>

                                <div class="contact-row">
                                    <div class="row-icon"><i class="fa-solid fa-phone"></i></div>
                                    <div class="row-text">
                                        <div class="row-label">Phone</div>
                                        <div class="row-value">+91 9875623014</div>
                                    </div>
                                </div>

                                <div class="contact-row">
                                    <div class="row-icon"><i class="fa-brands fa-discord"></i></div>
                                    <div class="row-text">
                                        <div class="row-label">Discord</div>
                                        <div class="row-value">discord.gg/ebooksupport</div>
                                    </div>
                                </div>

                                <div class="contact-form-title">Send us a quick message</div>

                                <form class="mini-form" action="contactMessage" method="post">
                                    <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">
                                    <input type="text" name="name" placeholder="Your Name" required>
                                    <input type="email" name="email" placeholder="Your Email" required>
                                    <textarea name="message" placeholder="Type your message..." required></textarea>
                                    <button class="send-btn">Send Message</button>
                                </form>

                                <div id="successMsg" class="success-msg">
                                    <i class="fa-solid fa-circle-check"></i>
                                    Message sent successfully!
                                </div>

                            </div>

                            <!-- RIGHT MAP -->
                            <div class="map-wrapper animate-in">

                                <div class="map-title">Our Location</div>

                                <div class="map-box">
                                    <iframe
                                        src="https://www.google.com/maps?q=PVRG+X6Q,+Nanda+Nagar,+Indore,+Madhya+Pradesh+452011&output=embed"
                                        loading="lazy">
                                    </iframe>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>
                <%@include file="all_component/footer.jsp" %>

                    <!-- =========================
   SCRIPTS
========================= -->

                    <script>

                        const params = new URLSearchParams(window.location.search);
                        if (params.get("success") === "1") {
                            document.getElementById("successMsg").style.display = "block";
                        }
                    </script>

        </body>

        </html>