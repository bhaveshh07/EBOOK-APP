<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page isELIgnored="false" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <title>Admin Payouts</title>
                    <meta charset="UTF-8">

                    <%@ include file="/admin/allCss.jsp" %>

                        <style>
                            .table thead th {
                                color: #000 !important;
                            }

                            body {
                                background: #f4f6f9;
                            }

                            .card-wrapper {
                                background: #fff;
                                padding: 30px;
                                border-radius: 16px;
                                box-shadow: 0 10px 35px rgba(0, 0, 0, 0.06);
                            }

                            .status-badge {
                                padding: 6px 14px;
                                border-radius: 20px;
                                font-size: 12px;
                                font-weight: 600;
                            }

                            .status-pending {
                                background: #fff3cd;
                                color: #856404;
                            }

                            .status-approved {
                                background: #d4edda;
                                color: #155724;
                            }

                            .status-rejected {
                                background: #e2e3e5;
                                color: #383d41;
                            }

                            .status-insufficient {
                                background: #f8d7da;
                                color: #721c24;
                            }

                            .status-processing {
                                background: #cce5ff;
                                color: #004085;
                            }

                            .status-settled {
                                background: #d4edda;
                                color: #155724;
                            }

                            .action-btns form {
                                display: inline-block;
                                margin: 2px;
                            }
                        </style>
                </head>

                <body>

                    <%@ include file="/admin/admin-layout.jsp" %>

                        <div class="container-fluid p-4">
                            <div class="card-wrapper">

                                <h5 class="mb-4">
                                    <i class="fa-solid fa-money-bill-transfer"></i>
                                    Seller Payout Requests
                                </h5>

                                <table class="table table-bordered table-hover align-middle text-center">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Seller</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                            <th width="240">Action</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <c:forEach var="p" items="${payoutList}">
                                            <tr>

                                                <td>${p.id}</td>

                                                <td>
                                                    <div class="fw-semibold">${p.sellerName}</div>
                                                    <div class="text-muted small">${p.sellerEmail}</div>
                                                </td>

                                                <td><strong>&#8377; ${p.amount}</strong></td>

                                                <td>
                                                    <c:choose>

                                                        <c:when test="${p.status eq 'INSUFFICIENT'}">
                                                            <span
                                                                class="status-badge status-insufficient">Insufficient</span>
                                                        </c:when>

                                                        <c:when test="${p.status eq 'PENDING'}">
                                                            <span class="status-badge status-pending">Pending</span>
                                                        </c:when>

                                                        <c:when test="${p.status eq 'APPROVED'}">
                                                            <span class="status-badge status-approved">Approved</span>
                                                        </c:when>

                                                        <c:when test="${p.status eq 'PROCESSING'}">
                                                            <span
                                                                class="status-badge status-processing">Processing</span>
                                                        </c:when>

                                                        <c:when test="${p.status eq 'SETTLED'}">
                                                            <span class="status-badge status-settled">Settled</span>
                                                        </c:when>

                                                        <c:when test="${p.status eq 'REJECTED'}">
                                                            <span class="status-badge status-rejected">Rejected</span>
                                                        </c:when>

                                                        <c:otherwise>
                                                            ${p.status}
                                                        </c:otherwise>

                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <fmt:formatDate value="${p.createdAt}"
                                                        pattern="dd MMM yyyy HH:mm" />
                                                </td>

                                                <td class="action-btns">

                                                    <c:choose>

                                                        <c:when test="${p.status eq 'PENDING'}">

                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/approve_payout"
                                                                method="post">
                                                                <input type="hidden" name="id" value="${p.id}">
                                                                <button class="btn btn-sm btn-success">Approve</button>
                                                            </form>

                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/reject_payout"
                                                                method="post">
                                                                <input type="hidden" name="id" value="${p.id}">
                                                                <button class="btn btn-sm btn-danger">Reject</button>
                                                            </form>

                                                        </c:when>

                                                        <c:when test="${p.status eq 'PROCESSING'}">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/settle_payout"
                                                                method="post">
                                                                <input type="hidden" name="id" value="${p.id}">
                                                                <button class="btn btn-sm btn-dark">Mark
                                                                    Settled</button>
                                                            </form>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <span class="text-muted">No Action</span>
                                                        </c:otherwise>

                                                    </c:choose>

                                                </td>

                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty payoutList}">
                                            <tr>
                                                <td colspan="6" class="text-muted">No payout requests found</td>
                                            </tr>
                                        </c:if>

                                    </tbody>
                                </table>

                            </div>
                        </div>

                </body>

                </html>