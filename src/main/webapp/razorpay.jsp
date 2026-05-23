<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Secure Payment</title>
        <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    </head>

    <body>

        <% String key=(String) request.getAttribute("razorpayKey"); String rpOrderId=(String)
            request.getAttribute("razorpayOrderId"); String orderId=(String) request.getAttribute("orderId"); Integer
            amount=(Integer) request.getAttribute("amount"); if (rpOrderId==null || orderId==null || amount==null) {
            response.sendRedirect("order.jsp"); return; } %>

            <input type="hidden" id="rzpKey" value="<%= key %>">
            <input type="hidden" id="rzpOrderId" value="<%= rpOrderId %>">
            <input type="hidden" id="orderId" value="<%= orderId %>">
            <input type="hidden" id="amount" value="<%= amount %>">

            <button id="payBtn" style="display:none;"></button>

            <script>
                var razorpayKey = document.getElementById("rzpKey").value;
                var razorpayOrderId = document.getElementById("rzpOrderId").value;
                var orderId = document.getElementById("orderId").value;
                var amount = parseInt(document.getElementById("amount").value);

                if (!razorpayKey || !razorpayOrderId || !orderId || isNaN(amount)) {
                    alert("Payment initialization failed");
                    throw new Error("Invalid Razorpay data");
                }

                var options = {
                    key: razorpayKey,
                    amount: amount,
                    currency: "INR",
                    order_id: razorpayOrderId,
                    name: "Ebook Store",
                    description: "Book Purchase",

                    handler: function (response) {
                        window.location.href =
                            "<%=request.getContextPath()%>/payment/verify" +
                            "?orderId=" + encodeURIComponent(orderId) +
                            "&razorpay_payment_id=" + encodeURIComponent(response.razorpay_payment_id) +
                            "&razorpay_order_id=" + encodeURIComponent(response.razorpay_order_id) +
                            "&razorpay_signature=" + encodeURIComponent(response.razorpay_signature);
                    }
                };

                var rzp = new Razorpay(options);
                window.onload = function () {
                    document.getElementById("payBtn").click();
                };

                document.getElementById("payBtn").onclick = function () {
                    rzp.open();
                };
            </script>

    </body>

    </html>