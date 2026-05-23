<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Payout History</title>
            <%@include file="all_component/allCss.jsp" %>

                <style>
                    body {
                        background: #f3f4f6;
                    }

                    .wallet-card {
                        background: white;
                        border-radius: 18px;
                        padding: 25px;
                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06);
                    }

                    .status-badge {
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                    }

                    .pending {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .approved {
                        background: #d4edda;
                        color: #155724;
                    }

                    .rejected {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .table thead {
                        background: #111827;
                        color: white;
                    }
                </style>
        </head>

        <body>

            <c:if test="${empty userobj}">
                <c:redirect url="login.jsp" />
            </c:if>

            <%@include file="all_component/navbar.jsp" %>
                <div id="content">
                    <div class="container mt-5 mb-5">

                        <h3 class="text-center mb-4">
                            <i class="fa-solid fa-clock-rotate-left me-2"></i>Full Payout History
                        </h3>

                        <div class="wallet-card">
                            <form method="get" action="seller_payout_history" class="row g-3 mb-4">

                                <div class="col-md-3">
                                    <select name="status" class="form-select">
                                        <option value="">All Status</option>
                                        <option value="PENDING" ${statusFilter=='PENDING' ?'selected':''}>Pending
                                        </option>
                                        <option value="APPROVED" ${statusFilter=='APPROVED' ?'selected':''}>Approved
                                        </option>
                                        <option value="REJECTED" ${statusFilter=='REJECTED' ?'selected':''}>Rejected
                                        </option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <input type="date" name="fromDate" value="${fromDate}" class="form-control">
                                </div>

                                <div class="col-md-3">
                                    <input type="date" name="toDate" value="${toDate}" class="form-control">
                                </div>

                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-dark w-100">Apply Filters</button>
                                </div>

                            </form>

                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <c:forEach var="p" items="${payoutList}">
                                        <tr>
                                            <td>${p.id}</td>
                                            <td>₹ ${p.amount}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status eq 'PENDING'}">
                                                        <span class="status-badge pending">Pending</span>
                                                    </c:when>
                                                    <c:when test="${p.status eq 'APPROVED'}">
                                                        <span class="status-badge approved">Approved</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge rejected">Rejected</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${p.createdAt}</td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty payoutList}">
                                        <tr>
                                            <td colspan="4" class="text-center text-muted">
                                                No payout requests found
                                            </td>
                                        </tr>
                                    </c:if>

                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <div class="d-flex justify-content-center mt-4">

                                <ul class="pagination">

                                    <!-- Previous -->
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="seller_payout_history?page=${currentPage-1}&status=${statusFilter}&fromDate=${fromDate}&toDate=${toDate}">
                                            Previous
                                        </a>
                                    </li>

                                    <!-- Page Numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                                href="seller_payout_history?page=${i}&status=${statusFilter}&fromDate=${fromDate}&toDate=${toDate}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <!-- Next -->
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="seller_payout_history?page=${currentPage+1}&status=${statusFilter}&fromDate=${fromDate}&toDate=${toDate}">
                                            Next
                                        </a>
                                    </li>

                                </ul>

                            </div>


                        </div>

                    </div>
                </div>
                <%@include file="all_component/footer.jsp" %>

        </body>

        </html>