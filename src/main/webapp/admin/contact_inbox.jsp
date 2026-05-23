<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>


        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Contact Messages</title>
            <%@include file="../all_component/allCss.jsp" %>

                <style>
                    /* ======================
FULL PAGE LAYOUT FIX
====================== */

                    .layout-body {
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                    }

                    /* ======================
BREADCRUMB BAR FIX
====================== */



                    /* Grey strip */
                    .breadcrumb-bar {
                        background: #f1f1f1;
                        padding: 12px 25px;
                        margin-bottom: 30px;
                        border-radius: 0;
                    }

                    /* Home link */
                    .breadcrumb-bar a {
                        color: #333;
                        font-size: 15px;
                        text-decoration: none;
                    }

                    .breadcrumb-bar i {
                        margin-right: 6px;
                    }

                    .layout-wrapper {
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                    }

                    .layout-content {
                        flex: 1;
                    }

                    /* ============================
PAGE LAYOUT
============================ */

                    body {
                        background: #f7f7f7;
                    }

                    .page-wrapper {
                        padding: 30px 0;
                    }


                    .page-title {
                        text-align: center;
                        font-size: 28px;
                        font-weight: 600;
                        margin-bottom: 30px;
                        margin-top: 10px;
                    }

                    /* ============================
CARD CONTAINER
============================ */

                    .inbox-card {
                        background: #ffffff;
                        border-radius: 12px;
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
                        padding: 20px;
                    }

                    /* ============================
TABLE
============================ */

                    table {
                        width: 100%;
                        border-collapse: collapse;
                        background: #ffffff;
                    }

                    th {
                        background: #f1f1f1;
                        padding: 12px;
                        font-weight: 600;
                        text-align: left;
                    }

                    td {
                        padding: 12px;
                        border-top: 1px solid #e0e0e0;
                        color: #333;
                    }

                    tr:hover {
                        background: #fafafa;
                    }

                    /* ============================
EMAIL BADGE
============================ */

                    .email-badge {
                        background: #0d6efd;
                        color: white;
                        padding: 4px 10px;
                        border-radius: 20px;
                        font-size: 13px;
                    }

                    /* ============================
MESSAGE COLUMN
============================ */

                    .msg-box {
                        max-width: 350px;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    /* ============================
MOBILE
============================ */

                    @media(max-width:768px) {
                        .msg-box {
                            max-width: 180px;
                        }
                    }
                </style>

        </head>

        <body class="layout-body">




            <%@ include file="admin-layout.jsp" %>



                <div class="container-fluid p-4">
                    <div class="dashboard-card">


                        <div class="container page-wrapper">

                            <!-- TITLE -->
                            <div class="page-title">
                                Contact Messages
                            </div>

                            <!-- CARD -->
                            <div class="inbox-card">

                                <table>

                                    <tr>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Message</th>
                                        <th>Date</th>
                                    </tr>

                                    <c:forEach var="c" items="${contactList}">
                                        <tr>
                                            <td>${c.name}</td>
                                            <td><span class="email-badge">${c.email}</span></td>
                                            <td class="msg-box">${c.message}</td>
                                            <td>${c.date}</td>
                                        </tr>
                                    </c:forEach>


                                </table>

                            </div>

                        </div>
                    </div>
                </div>






        </body>

        </html>