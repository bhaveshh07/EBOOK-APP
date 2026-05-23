<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>

		<%@page isELIgnored="false" %>
			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>Admin : Home</title>
				<%@include file="allCss.jsp" %>
					<style>
						.table thead th {
							position: sticky;
							top: 0;
							background: white;
							z-index: 5;
						}

						/* Reset anchor */
						a {
							text-decoration: none;
							color: inherit;
						}

						/* Page Background */
						body {
							background-color: #f7f7f7;
						}

						/* Dashboard Title */
						.dashboard-title {
							font-weight: 600;
							letter-spacing: 0.5px;
						}

						/* Card Container */
						.admin-card {
							height: 230px;
							border-radius: 14px;
							border: none;
							background: #ffffff;
							box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
							transition: all 0.3s ease;
							cursor: pointer;
						}

						.admin-card:hover {
							transform: translateY(-8px);
							box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
						}

						/* Card Body Centering */
						.admin-card .card-body {
							height: 100%;
							display: flex;
							flex-direction: column;
							justify-content: center;
							align-items: center;
						}

						/* Icon Circle */
						.icon-box {
							width: 70px;
							height: 70px;
							border-radius: 50%;
							display: flex;
							align-items: center;
							justify-content: center;
							font-size: 32px;
							color: white;
							margin-bottom: 15px;
						}

						/* Icon Colors */
						.bg-blue {
							background: #007bff;
						}

						.bg-red {
							background: #dc3545;
						}

						.bg-yellow {
							background: #ffc107;
						}

						.bg-green {
							background: #28a745;
						}

						.bg-purple {
							background: #6366f1;
						}

						/* Card Title */
						.admin-card h4 {
							font-size: 18px;
							font-weight: 600;
							margin: 0;
						}

						/* Underline */
						.underline {
							width: 60px;
							height: 3px;
							background: #ddd;
							margin-top: 12px;
							border-radius: 10px;
						}
					</style>

			</head>

			<body style="background-color:#f7f7f7">


				<c:if test="${empty userobj}">
					<c:redirect url="../login.jsp"></c:redirect>
				</c:if>



				<%@ include file="admin-layout.jsp" %>

					<div class="container-fluid p-4">

						<h4 class="mb-4">Welcome Back, Admin</h4>

						<div class="row g-4">

							<div class="col-md-3">
								<div class="dashboard-card" style="border-left:5px solid #7F8CFF;">
									<h6>Total Books</h6>
									<div class="metric-number" id="booksCount">
										${empty totalBooks ? 0 : totalBooks}
									</div>

								</div>
							</div>

							<div class="col-md-3">
								<div class="dashboard-card" style="border-left:5px solid #F2C94C;">
									<h6>Total Orders</h6>
									<div class="metric-number" id="ordersCount">
										${empty totalOrders ? 0 : totalOrders}
									</div>
								</div>
							</div>

							<div class="col-md-3">
								<div class="dashboard-card" style="border-left:5px solid #6FCF97;">
									<h6>Total Revenue</h6>
									<div class="metric-number">₹ ${totalRevenue}</div>
								</div>
							</div>

							<div class="col-md-3">
								<div class="dashboard-card" style="border-left:5px solid #EB5757;">
									<h6>Pending Returns</h6>
									<div class="metric-number">${pendingReturns}</div>
								</div>
							</div>

						</div>
						<div class="row mt-5">

							<div class="col-md-6">
								<div class="dashboard-card">
									<h6>Orders Per Month</h6>
									<canvas id="ordersChart"></canvas>
								</div>
							</div>

							<div class="col-md-6">
								<div class="dashboard-card">
									<h6>Revenue Trend</h6>
									<canvas id="revenueChart"></canvas>
								</div>
							</div>
							<div class="col-md-6 mt-4">
								<div class="dashboard-card">
									<h6>Order Status Distribution</h6>
									<canvas id="statusChart"></canvas>
								</div>
							</div>

						</div>

					</div>

					</div> <!-- close main-content -->
					</div> <!-- close wrapper -->

					<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
					<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

					<script>
						/* ================== SAFE VALUES FROM SERVER ================== */
						const placed = Number("${empty placedCount ? 0 : placedCount}");
						const shipped = Number("${empty shippedCount ? 0 : shippedCount}");
						const delivered = Number("${empty deliveredCount ? 0 : deliveredCount}");
						const refunded = Number("${empty refundedCount ? 0 : refundedCount}");

						const totalBooks = Number("${empty totalBooks ? 0 : totalBooks}");
						const totalOrders = Number("${empty totalOrders ? 0 : totalOrders}");
					</script>

					<script>
						/* ================== ORDERS BAR CHART ================== */
						const ordersData = [
							<c:forEach var="val" items="${orderChartData}" varStatus="loop">
								${val}<c:if test="${!loop.last}">,</c:if>
							</c:forEach>
						];

						new Chart(document.getElementById('ordersChart'), {
							type: 'bar',
							data: {
								labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
								datasets: [{
									label: 'Orders',
									data: ordersData,
									backgroundColor: '#7F8CFF'
								}]
							}
						});
					</script>

					<script>
						/* ================== REVENUE LINE CHART ================== */
						const revenueData = [
							<c:forEach var="val" items="${revenueChartData}" varStatus="loop">
								${val}<c:if test="${!loop.last}">,</c:if>
							</c:forEach>
						];

						new Chart(document.getElementById('revenueChart'), {
							type: 'line',
							data: {
								labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
								datasets: [{
									label: 'Revenue',
									data: revenueData,
									borderColor: '#6FCF97',
									fill: false,
									tension: 0.3
								}]
							}
						});
					</script>

					<script>
						/* ================== STATUS PIE CHART ================== */
						new Chart(document.getElementById('statusChart'), {
							type: 'pie',
							data: {
								labels: ['Placed', 'Shipped', 'Delivered', 'Refunded'],
								datasets: [{
									data: [placed, shipped, delivered, refunded],
									backgroundColor: ['#F2C94C', '#7F8CFF', '#6FCF97', '#EB5757']
								}]
							}
						});
					</script>

					<script>

						function animateValue(el, end) {
							let start = 0;
							let duration = 800;
							let startTime = null;

							function step(timestamp) {
								if (!startTime) startTime = timestamp;
								const progress = timestamp - startTime;
								const value = Math.min(
									Math.floor((progress / duration) * end),
									end
								);
								el.innerText = value;

								if (progress < duration) {
									requestAnimationFrame(step);
								}
							}

							requestAnimationFrame(step);
						}


					</script>

					<script>
						/* ================== LIVE UPDATE (NO RELOAD) ================== */
						setInterval(() => {
							fetch("${pageContext.request.contextPath}/admin/home-data")
								.then(res => res.json())
								.then(data => {

									document.getElementById("booksCount").innerText = data.totalBooks;
									document.getElementById("ordersCount").innerText = data.totalOrders;

									document.querySelectorAll(".metric-number")[2].innerText = "₹ " + data.totalRevenue;
									document.querySelectorAll(".metric-number")[3].innerText = data.pendingReturns;

								});
						}, 15000);

					</script>


			</body>

			</html>