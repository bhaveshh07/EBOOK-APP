<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <title>My Orders</title>
            <%@include file="all_component/allCss.jsp" %>

                <style>
                    .order-card {
                        background: white;
                        border-radius: 18px;
                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06);
                        margin-bottom: 25px;
                        overflow: hidden;
                        transition: 0.3s;
                    }

                    .order-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                    }

                    .order-header {
                        background: #f8f9fa;
                        padding: 15px 20px;
                        font-weight: 600;
                        display: flex;
                        justify-content: space-between;
                        flex-wrap: wrap;
                    }

                    .order-body {
                        padding: 20px;
                    }

                    .track {
                        display: flex;
                        justify-content: space-between;
                        margin-top: 15px;
                    }

                    .step {
                        text-align: center;
                        flex: 1;
                    }

                    .step span {
                        width: 30px;
                        height: 30px;
                        border-radius: 50%;
                        background: #ccc;
                        display: inline-block;
                        line-height: 30px;
                        color: white;
                        font-size: 14px;
                    }

                    .step.active span {
                        background: #28a745;
                    }

                    .cancelled-text {
                        color: red;
                        font-weight: 600;
                    }
                </style>
        </head>

        <body style="background:#f7f7f7">

            <%@include file="all_component/navbar.jsp" %>
                <div id="content">
                    <c:if test="${empty userobj}">
                        <c:redirect url="login.jsp" />
                    </c:if>

                    <div class="container mt-4">
                        <h3 class="text-center mb-4">My Orders</h3>

                        <c:forEach var="b" items="${orderList}">

                            <div class="order-card">

                                <!-- HEADER -->
                                <div class="order-header">
                                    <div>
                                        Order ID: <strong>${b.orderId}</strong>
                                    </div>
                                    <div>
                                        Total: ₹ ${b.totalAmount}
                                    </div>
                                </div>

                                <!-- BODY -->
                                <div class="order-body">

                                    <div class="row">
                                        <div class="col-md-4">
                                            <strong>Book:</strong> ${b.bookName}<br>
                                            <strong>Price:</strong> ₹ ${b.price}
                                        </div>

                                        <div class="col-md-4">
                                            <!-- PAYMENT STATUS -->
                                            <c:choose>
                                                <c:when test="${b.paymentStatus == 'FAILED'}">
                                                    <a href="${pageContext.request.contextPath}/payment/initiate?orderId=${b.orderId}"
                                                        class="btn btn-warning btn-sm">
                                                        Retry Payment
                                                    </a>
                                                </c:when>

                                                <c:when test="${b.paymentStatus == 'INITIATED'}">
                                                    <span class="badge bg-warning">Payment Pending</span>
                                                </c:when>

                                                <c:when test="${b.paymentStatus == 'PAID'}">
                                                    <span class="badge bg-success">Paid</span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${b.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="col-md-4 text-end">

                                            <!-- ACTIONS -->
                                            <c:choose>

                                                <c:when test="${b.status eq 'REFUNDED'}">
                                                    <span class="badge bg-primary">Refunded</span>
                                                </c:when>

                                                <c:when test="${b.status eq 'PLACED'}">
                                                    <form action="cancel_order" method="post" style="display:inline;">
                                                        <input type="hidden" name="csrf_token"
                                                            value="${sessionScope.CSRF_TOKEN}">
                                                        <input type="hidden" name="orderId" value="${b.id}">
                                                        <button class="btn btn-danger btn-sm">Cancel</button>
                                                    </form>
                                                </c:when>

                                                <c:when test="${b.status eq 'DELIVERED' and b.returnStatus eq 'NONE'}">
                                                    <form action="return_order" method="post" style="display:inline;">
                                                        <input type="hidden" name="csrf_token"
                                                            value="${sessionScope.CSRF_TOKEN}">
                                                        <input type="hidden" name="id" value="${b.id}">
                                                        <button class="btn btn-warning btn-sm">Return</button>
                                                    </form>
                                                </c:when>

                                                <c:otherwise>
                                                    <button class="btn btn-secondary btn-sm" disabled>
                                                        Not Available
                                                    </button>
                                                </c:otherwise>

                                            </c:choose>

                                            <c:if test="${b.status ne 'PAYMENT_PENDING' and b.status ne 'CANCELLED'}">

                                                <button class="btn btn-primary btn-sm ms-2"
                                                    onclick="viewOrder('${b.orderId}')">
                                                    View Order
                                                </button>

                                                <a href="invoice?id=${b.id}" class="btn btn-success btn-sm ms-2">
                                                    Download Invoice
                                                </a>

                                            </c:if>

                                        </div>
                                    </div>

                                    <!-- TRACKING -->
                                    <c:if test="${b.status ne 'PAYMENT_PENDING' and b.status ne 'CANCELLED'}">

                                        <div class="track mt-4">

                                            <div class="step ${b.status eq 'PLACED' or b.status eq 'PROCESSING'
                                or b.status eq 'SHIPPED'
                                or b.status eq 'DELIVERED' ? 'active' : ''}">
                                                <span>1</span>
                                                <div>Placed</div>
                                            </div>

                                            <div class="step ${b.status eq 'SHIPPED'
                                or b.status eq 'DELIVERED' ? 'active' : ''}">
                                                <span>2</span>
                                                <div>Shipped</div>
                                            </div>

                                            <div class="step ${b.status eq 'DELIVERED' ? 'active' : ''}">
                                                <span>3</span>
                                                <div>Delivered</div>
                                            </div>

                                        </div>

                                    </c:if>

                                    <c:if test="${b.status eq 'CANCELLED'}">
                                        <div class="mt-3 cancelled-text">Order Cancelled</div>
                                    </c:if>

                                </div>
                            </div>

                        </c:forEach>

                    </div>

                    <!-- ORDER DETAILS MODAL -->
                    <div class="modal fade" id="orderModal" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">

                                <div class="modal-header">
                                    <h5 class="modal-title">Order Details</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body">

                                    <!-- ORDER META SECTION -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <h6 class="fw-bold">Shipping Address</h6>
                                            <div id="modalShippingAddress" class="text-muted small"></div>
                                        </div>

                                        <div class="col-md-6">
                                            <h6 class="fw-bold">Payment Details</h6>
                                            <div class="small">
                                                <div>Method: <span id="modalPaymentMethod"></span></div>
                                                <div>Status: <span id="modalPaymentStatus"></span></div>
                                                <div>Order Date: <span id="modalOrderDate"></span></div>
                                                <div>Razorpay Order ID: <span id="modalRazorpayOrder"></span></div>
                                                <div>Razorpay Payment ID: <span id="modalRazorpayPayment"></span></div>
                                            </div>
                                        </div>
                                    </div>

                                    <hr>

                                    <!-- ITEMS -->
                                    <div id="orderItemsContainer"></div>

                                    <hr>

                                    <div class="text-end">
                                        <div>Items Total: ₹ <span id="itemsTotal"></span></div>
                                        <div>Delivery Charges: ₹ <span id="deliveryCharge"></span></div>
                                        <div class="fw-bold fs-5 mt-2">
                                            Grand Total: ₹ <span id="grandTotal"></span>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
                <%@include file="all_component/footer.jsp" %>

                    <script>
                        function viewOrder(orderId) {

                            var url = "<%= request.getContextPath() %>/order_items_details?orderId=" + orderId;

                            fetch(url)
                                .then(function (res) {
                                    return res.json();
                                })
                                .then(function (data) {

                                    console.log("ORDER DATA:", data);

                                    /* ---------- META ---------- */

                                    document.getElementById("modalShippingAddress").innerText =
                                        data.shippingAddress ? data.shippingAddress : "N/A";

                                    document.getElementById("modalPaymentMethod").innerText =
                                        data.paymentMethod ? data.paymentMethod : "N/A";

                                    document.getElementById("modalPaymentStatus").innerText =
                                        data.paymentStatus ? data.paymentStatus : "N/A";

                                    document.getElementById("modalOrderDate").innerText =
                                        data.orderDate ? new Date(data.orderDate).toLocaleString() : "N/A";

                                    document.getElementById("modalRazorpayOrder").innerText =
                                        data.razorpayOrderId ? data.razorpayOrderId : "N/A";

                                    document.getElementById("modalRazorpayPayment").innerText =
                                        data.razorpayPaymentId ? data.razorpayPaymentId : "N/A";


                                    /* ---------- ITEMS ---------- */

                                    var container = document.getElementById("orderItemsContainer");
                                    container.innerHTML = "";

                                    if (!data.items || data.items.length === 0) {
                                        container.innerHTML =
                                            "<div class='text-center text-muted'>No items found</div>";
                                    } else {

                                        for (var i = 0; i < data.items.length; i++) {

                                            var item = data.items[i];

                                            var bookName = item.bookName ? item.bookName : "-";
                                            var author = item.author ? item.author : "-";
                                            var price = item.price ? item.price : 0;
                                            var qty = item.quantity ? item.quantity : 0;
                                            var total = item.totalPrice ? item.totalPrice : 0;

                                            container.innerHTML +=
                                                "<div class='border rounded p-3 mb-3'>" +
                                                "<div class='row'>" +

                                                "<div class='col-md-5'>" +
                                                "<div class='fw-bold'>" + bookName + "</div>" +
                                                "<div class='text-muted small'>by " + author + "</div>" +
                                                "</div>" +

                                                "<div class='col-md-2 text-center'>₹ " + price + "</div>" +

                                                "<div class='col-md-2 text-center'>Qty: " + qty + "</div>" +

                                                "<div class='col-md-3 text-end fw-bold'>₹ " + total + "</div>" +

                                                "</div>" +
                                                "</div>";
                                        }
                                    }

                                    /* ---------- TOTALS ---------- */

                                    document.getElementById("itemsTotal").innerText =
                                        data.itemsTotal ? data.itemsTotal : 0;

                                    document.getElementById("deliveryCharge").innerText =
                                        data.deliveryCharge ? data.deliveryCharge : 0;

                                    document.getElementById("grandTotal").innerText =
                                        data.grandTotal ? data.grandTotal : 0;

                                    var modal = new bootstrap.Modal(document.getElementById("orderModal"));
                                    modal.show();

                                })
                                .catch(function (err) {
                                    console.log(err);
                                    alert("Unable to load order details");
                                });
                        }
                    </script>

        </body>

        </html>