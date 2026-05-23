<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Seller Wallet</title>
            <%@include file="all_component/allCss.jsp" %>

                <style>
                    body {
                        background: #f3f4f6;
                    }

                    .wallet-header {
                        background: linear-gradient(135deg, #4f46e5, #7c3aed);
                        color: white;
                        border-radius: 18px;
                        padding: 35px;
                        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                    }

                    .balance-amount {
                        font-size: 36px;
                        font-weight: 700;
                    }

                    .wallet-card {
                        background: white;
                        border-radius: 18px;
                        padding: 25px;
                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06);
                    }

                    .section-title {
                        font-weight: 600;
                        margin-bottom: 20px;
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

                    .credit-badge {
                        background: #16a34a;
                    }

                    .debit-badge {
                        background: #dc2626;
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
                            <i class="fa-solid fa-wallet me-2"></i>Seller Wallet Dashboard
                        </h3>

                        <!-- ALERTS -->
                        <c:if test="${not empty sessionScope.payoutError}">
                            <div class="alert alert-danger">${sessionScope.payoutError}</div>
                            <c:remove var="payoutError" scope="session" />
                        </c:if>

                        <c:if test="${not empty sessionScope.payoutSuccess}">
                            <div class="alert alert-success">${sessionScope.payoutSuccess}</div>
                            <c:remove var="payoutSuccess" scope="session" />
                        </c:if>

                        <!-- BALANCE HEADER -->
                        <div class="wallet-header mb-4">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <div>Available Balance</div>
                                    <div class="balance-amount">
                                        ₹ ${empty sellerBalance ? 0 : sellerBalance}
                                    </div>
                                    <small>Withdraw your earnings anytime</small>
                                </div>

                                <div class="col-md-4 text-end">
                                    <button class="btn btn-light fw-bold" data-bs-toggle="modal"
                                        data-bs-target="#payoutModal">
                                        Request Payout
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="row g-4">

                            <!-- TOTAL EARNINGS -->
                            <div class="col-md-4">
                                <div class="wallet-card text-center">
                                    <h6>Total Earnings</h6>
                                    <h4>₹ ${empty totalEarnings ? 0 : totalEarnings}</h4>
                                    <small class="text-muted">From delivered orders</small>
                                </div>
                            </div>

                            <!-- PAYOUT HISTORY -->
                            <div class="col-md-8">
                                <div class="wallet-card">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="section-title">
                                            <i class="fa-solid fa-clock-rotate-left me-2"></i>Payout History
                                        </div>

                                        <a href="seller_payout_history" class="btn btn-sm btn-outline-dark">
                                            View Full History
                                        </a>
                                    </div>


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
                                                        No payout requests yet
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                        </div>

                        <!-- WALLET TRANSACTIONS -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="wallet-card">

                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5>
                                            <i class="fa-solid fa-money-bill-transfer me-2"></i>
                                            Wallet Transactions
                                        </h5>

                                        <a href="seller_transaction_history" class="btn btn-sm btn-outline-dark">
                                            View Full History
                                        </a>

                                    </div>

                                    <table class="table table-bordered table-hover text-center" id="transactionTable">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Description</th>
                                                <th>Type</th>
                                                <th>Amount</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="t" items="${transactions}">
                                                <tr data-type="${t.type}">
                                                    <td>${t.id}</td>
                                                    <td>${t.description}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${t.type eq 'CREDIT'}">
                                                                <span class="badge bg-success">CREDIT</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">DEBIT</span>
                                                            </c:otherwise>

                                                        </c:choose>
                                                    </td>
                                                    <td>₹ ${t.amount}</td>
                                                    <td>${t.createdAt}</td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty transactions}">
                                                <tr>
                                                    <td colspan="5" class="text-muted">
                                                        No transactions available
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>

                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- PAYOUT MODAL -->
                    <div class="modal fade" id="payoutModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">

                                <form action="request_payout" method="post">

                                    <!-- ✅ CSRF TOKEN FIX -->
                                    <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

                                    <div class="modal-header">
                                        <h5 class="modal-title">Request Payout</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>

                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">Amount (₹)</label>
                                            <input type="number" name="amount" class="form-control" required min="1"
                                                max="${sellerBalance}" step="0.01">
                                            <small class="text-muted">
                                                Maximum available: ₹ ${sellerBalance}
                                            </small>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-primary w-100">
                                            Submit Request
                                        </button>
                                    </div>

                                </form>

                            </div>
                        </div>
                    </div>
                </div>
                <!-- FILTER SCRIPT -->
                <script>
                    function filterTransactions(type) {
                        const rows = document.querySelectorAll("#transactionTable tbody tr");

                        rows.forEach(row => {
                            if (type === "ALL") {
                                row.style.display = "";
                                return;
                            }

                            const rowType = row.getAttribute("data-type");

                            if (rowType === type) {
                                row.style.display = "";
                            } else {
                                row.style.display = "none";
                            }
                        });
                    }
                </script>

                <%@include file="all_component/footer.jsp" %>

        </body>

        </html>