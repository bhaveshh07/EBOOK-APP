<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <title>Transaction History</title>
            <%@include file="all_component/allCss.jsp" %>
        </head>

        <body>

            <c:if test="${empty userobj}">
                <c:redirect url="login.jsp" />
            </c:if>

            <%@include file="all_component/navbar.jsp" %>
                <div id="content">
                    <div class="container mt-5 mb-5">

                        <h3 class="text-center mb-4">Full Wallet Transactions</h3>

                        <!-- FILTER -->
                        <form method="get" action="seller_transaction_history" class="row g-3 mb-4">

                            <div class="col-md-3">
                                <select name="type" class="form-select">
                                    <option value="">All Types</option>
                                    <option value="CREDIT" ${typeFilter=='CREDIT' ?'selected':''}>Credit</option>
                                    <option value="DEBIT" ${typeFilter=='DEBIT' ?'selected':''}>Debit</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <input type="date" name="fromDate" value="${fromDate}" class="form-control">
                            </div>

                            <div class="col-md-3">
                                <input type="date" name="toDate" value="${toDate}" class="form-control">
                            </div>

                            <div class="col-md-3">
                                <button class="btn btn-dark w-100">Apply Filters</button>
                            </div>

                        </form>

                        <table class="table table-bordered table-hover text-center">
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

                                <c:forEach var="t" items="${transactionList}">
                                    <tr>
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

                                        <td>
                                            <c:choose>
                                                <c:when test="${t.type eq 'CREDIT'}">
                                                    <span class="text-success fw-bold">+ ₹ ${t.amount}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger fw-bold">- ₹ ${t.amount}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${t.createdAt}</td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty transactionList}">
                                    <tr>
                                        <td colspan="5">No transactions found</td>
                                    </tr>
                                </c:if>

                            </tbody>
                        </table>

                        <!-- PAGINATION -->
                        <ul class="pagination justify-content-center">

                            <li class="page-item ${currentPage==1?'disabled':''}">
                                <a class="page-link"
                                    href="seller_transaction_history?page=${currentPage-1}&type=${typeFilter}&fromDate=${fromDate}&toDate=${toDate}">
                                    Previous
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i==currentPage?'active':''}">
                                    <a class="page-link"
                                        href="seller_transaction_history?page=${i}&type=${typeFilter}&fromDate=${fromDate}&toDate=${toDate}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage==totalPages?'disabled':''}">
                                <a class="page-link"
                                    href="seller_transaction_history?page=${currentPage+1}&type=${typeFilter}&fromDate=${fromDate}&toDate=${toDate}">
                                    Next
                                </a>
                            </li>

                        </ul>

                    </div>
                </div>
                <%@include file="all_component/footer.jsp" %>

        </body>

        </html>