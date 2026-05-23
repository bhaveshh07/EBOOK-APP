<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ page import="java.util.*" %>
            <%@ page import="com.entity.*" %>
                <%@ page import="com.DAO.*" %>
                    <%@ page import="com.DBMS.DBConnect" %>

                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <title>My Wallet</title>
                            <%@include file="all_component/allCss.jsp" %>

                                <style>
                                    .wallet-hero {
                                        background: linear-gradient(135deg, #4f46e5, #7c3aed);
                                        color: white;
                                        border-radius: 20px;
                                        padding: 40px;
                                        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                                    }

                                    .balance-amount {
                                        font-size: 48px;
                                        font-weight: 700;
                                    }

                                    .txn-table {
                                        background: white;
                                        border-radius: 18px;
                                        overflow: hidden;
                                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                                    }

                                    .badge-credit {
                                        background: #16a34a;
                                    }

                                    .badge-debit {
                                        background: #dc2626;
                                    }
                                </style>
                        </head>

                        <body style="background:#f7f7f7">

                            <%@include file="all_component/navbar.jsp" %>

                                <c:if test="${empty userobj}">
                                    <c:redirect url="login.jsp" />
                                </c:if>

                                <% User u=(User) session.getAttribute("userobj");WalletDAOImpl walletDao=new
                                    WalletDAOImpl(DBConnect.getConn()); double
                                    walletBalance=walletDao.getBalanceByUser(u.getId()); // TRUE BALANCE
                                    List<WalletTransaction> list = walletDao.getByUser(u.getId());
                                    %>
                                    <div id="content">
                                        <div class="container mt-5">

                                            <!-- Wallet Hero -->
                                            <div class="wallet-hero text-center mb-5">
                                                <h2>My Wallet</h2>
                                                <div class="balance-amount">
                                                    ₹ <span id="walletCounter">
                                                        <%= walletBalance %>
                                                    </span>
                                                </div>
                                                <p class="mt-2">Available Balance</p>
                                            </div>

                                            <!-- Transaction History -->
                                            <div class="txn-table p-4">
                                                <h4 class="mb-4">Transaction History</h4>

                                                <table class="table table-hover align-middle">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Amount</th>
                                                            <th>Type</th>
                                                            <th>Description</th>
                                                            <th>Date</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>

                                                        <% if(list==null || list.isEmpty()) { %>
                                                            <tr>
                                                                <td colspan="4" class="text-center text-muted">
                                                                    No transactions yet
                                                                </td>
                                                            </tr>
                                                            <% } else { for(WalletTransaction w : list) { boolean
                                                                isDebit="DEBIT" .equalsIgnoreCase(w.getType()); %>

                                                                <tr>
                                                                    <td class="<%= isDebit ? " text-danger"
                                                                        : "text-success" %>">
                                                                        ₹ <%= w.getAmount() %>
                                                                    </td>

                                                                    <td>
                                                                        <span class="badge <%= isDebit ? " badge-debit"
                                                                            : "badge-credit" %>">
                                                                            <%= w.getType() %>
                                                                        </span>
                                                                    </td>

                                                                    <td>
                                                                        <%= w.getDescription() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= w.getCreatedAt() %>
                                                                    </td>
                                                                </tr>

                                                                <% } } %>

                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>
                                    </div>
                                    <%@include file="all_component/footer.jsp" %>

                                        <script>
                                            // Smooth balance animation
                                            const counter = document.getElementById("walletCounter");
                                            let target = parseFloat(counter.innerText);
                                            let start = 0;
                                            let duration = 800;
                                            let increment = target / (duration / 16);

                                            function animate() {
                                                start += increment;
                                                if (start >= target) {
                                                    counter.innerText = target.toFixed(2);
                                                    return;
                                                }
                                                counter.innerText = start.toFixed(2);
                                                requestAnimationFrame(animate);
                                            }

                                            counter.innerText = "0.00";
                                            animate();
                                        </script>

                        </body>

                        </html>