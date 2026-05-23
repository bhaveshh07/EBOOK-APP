<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Payment Failed</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>

    <body class="bg-light">
        <div id="content">
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow-sm text-center">
                            <div class="card-body">
                                <h3 class="text-danger mb-3">❌ Payment Failed</h3>

                                <p class="text-muted">
                                    Your payment could not be completed or was cancelled.
                                </p>

                                <p class="text-muted">
                                    If any amount was deducted, it will be refunded
                                    automatically within <b>5–7 working days</b>.
                                </p>

                                <div class="mt-4">
                                    <a href="my_orders" class="btn btn-secondary me-2">
                                        View Orders
                                    </a>
                                    <a href="index.jsp" class="btn btn-primary">
                                        Continue Shopping
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

    </html>