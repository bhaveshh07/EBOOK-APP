<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>Dashboard</title>
			<%@include file="all_component/allCss.jsp" %>
				<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

				<style>
					.dashboard-wrapper {
						padding: 30px 20px;
					}

					.mode-switcher {
						display: flex;
						justify-content: center;
						margin-bottom: 30px;
					}

					.mode-btn {
						border: none;
						padding: 10px 25px;
						margin: 0 5px;
						border-radius: 30px;
						font-weight: 500;
						background: #e9ecef;
						transition: 0.3s;
					}

					.mode-btn.active {
						background: linear-gradient(135deg, #4f46e5, #7c3aed);
						color: white;
					}

					.dashboard-container {
						display: flex;
						gap: 20px;
						flex-wrap: wrap;
					}

					.sidebar {
						width: 250px;
						background: white;
						padding: 25px;
						border-radius: 18px;
						box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06);
					}

					.sidebar h6 {
						font-weight: 600;
						margin-bottom: 20px;
					}

					.sidebar a {
						display: block;
						padding: 10px;
						border-radius: 10px;
						text-decoration: none;
						color: #333;
						margin-bottom: 10px;
						transition: 0.3s;
					}

					.sidebar a:hover {
						background: #f1f3f5;
						padding-left: 15px;
					}

					.main-content {
						flex: 1;
						min-width: 300px;
					}

					.hero {
						padding: 30px;
						border-radius: 18px;
						color: white;
						margin-bottom: 25px;
					}

					.user-hero {
						background: linear-gradient(135deg, #2563eb, #4f46e5);
					}

					.seller-hero {
						background: linear-gradient(135deg, #4f46e5, #7c3aed);
					}

					.stat-card {
						background: white;
						padding: 25px;
						border-radius: 18px;
						text-align: center;
						box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06);
						transition: 0.3s;
					}

					.stat-card:hover {
						transform: translateY(-8px);
						box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
					}
				</style>
		</head>

		<body style="background:#f7f7f7">

			<c:if test="${empty userobj}">
				<c:redirect url="login.jsp" />
			</c:if>

			<%@include file="all_component/navbar.jsp" %>
				<div id="content">
					<div class="dashboard-wrapper container">

						<h2 class="text-center mb-4">Welcome, ${userobj.name}</h2>

						<div class="mode-switcher">
							<button class="mode-btn" onclick="switchMode('user')">User Mode</button>
							<button class="mode-btn" onclick="switchMode('seller')">Seller Mode</button>
						</div>

						<div class="dashboard-container">
							<div class="sidebar" id="sidebar"></div>
							<div class="main-content" id="mainContent"></div>
						</div>

					</div>
				</div>
				<%@include file="all_component/footer.jsp" %>

					<script>

						function switchMode(mode) {

							document.querySelectorAll('.mode-btn').forEach(btn => {
								btn.classList.remove('active');
							});

							if (mode === 'user') {
								document.querySelectorAll('.mode-btn')[0].classList.add('active');
								loadUserDashboard();
							} else {
								document.querySelectorAll('.mode-btn')[1].classList.add('active');
								loadSellerDashboard();
							}

							localStorage.setItem("dashboardMode", mode);
						}

						function animateCount(el, target) {
							let start = 0;
							let duration = 800;
							let increment = target / (duration / 16);

							function update() {
								start += increment;
								if (start >= target) {
									el.innerText = target;
									return;
								}
								el.innerText = Math.floor(start);
								requestAnimationFrame(update);
							}
							update();
						}

						function triggerCounts() {
							document.querySelectorAll('.count').forEach(el => {
								let val = parseInt(el.getAttribute("data-value"));
								if (isNaN(val)) val = 0;
								animateCount(el, val);
							});
						}

						/* USER DASHBOARD */
						function loadUserDashboard() {

							document.getElementById("sidebar").innerHTML =
								'<h6><i class="fa-solid fa-user me-2"></i>User Panel</h6>' +
								'<a href="my_orders"><i class="fa-solid fa-box me-2"></i>My Orders</a>' +
								'<a href="wallet.jsp"><i class="fa-solid fa-wallet me-2"></i>My Wallet</a>' +
								'<a href="edit_profile.jsp"><i class="fa-solid fa-shield-halved me-2"></i>Login & Security</a>' +
								'<a href="helpline.jsp"><i class="fa-solid fa-headset me-2"></i>Help Center</a>';

							document.getElementById("mainContent").innerHTML =
								'<div class="hero user-hero">' +
								'<h4>Buyer Dashboard</h4>' +
								'<p>Manage your orders, wallet & security settings</p>' +
								'</div>' +

								'<div class="row g-4">' +
								'<div class="col-md-4"><div class="stat-card">' +
								'<h4 class="count" data-value="${empty totalOrders ? 0 : totalOrders}">0</h4>' +
								'<p>Total Orders</p>' +
								'</div></div>' +

								'<div class="col-md-4"><div class="stat-card">' +
								'<h4 class="count" data-value="${empty walletBalance ? 0 : walletBalance}">0</h4>' +
								'<p>Wallet Balance (₹)</p>' +
								'</div></div>' +

								'<div class="col-md-4"><div class="stat-card">' +
								'<h4 class="count" data-value="${empty activeOrders ? 0 : activeOrders}">0</h4>' +
								'<p>Active Orders</p>' +
								'</div></div>' +
								'</div>';

							triggerCounts();
						}

						/* SELLER DASHBOARD */
						function loadSellerDashboard() {

							document.getElementById("sidebar").innerHTML =
								'<h6><i class="fa-solid fa-store me-2"></i>Seller Studio</h6>' +
								'<a href="add_old_book"><i class="fa-solid fa-plus me-2"></i>Add New Book</a>' +
								'<a href="old_book.jsp"><i class="fa-solid fa-book me-2"></i>My Listings</a>' +
								'<a href="seller_wallet"><i class="fa-solid fa-wallet me-2"></i>Seller Wallet</a>';


							document.getElementById("mainContent").innerHTML =
								'<div class="hero seller-hero">' +
								'<h4>Seller Dashboard</h4>' +
								'<p>Manage listings & track your earnings</p>' +
								'</div>' +

								'<div class="row g-4">' +

								'<div class="col-md-4"><div class="stat-card">' +
								'<h4 class="count" data-value="${empty totalListings ? 0 : totalListings}">0</h4>' +
								'<p>Total Listings</p>' +
								'</div></div>' +

								'<div class="col-md-4"><div class="stat-card">' +
								'<h4 class="count" data-value="${empty totalEarnings ? 0 : totalEarnings}">0</h4>' +
								'<p>Total Earnings (₹)</p>' +
								'</div></div>' +

								'<div class="col-md-4"><div class="stat-card">' +
								'<h4 class="count" data-value="${empty booksSold ? 0 : booksSold}">0</h4>' +
								'<p>Books Sold</p>' +
								'</div></div>' +

								'</div>' +

								'<div class="card mt-4 p-4 shadow-sm rounded-4">' +
								'<h5 class="mb-3">Sales Analytics</h5>' +
								'<canvas id="sellerChart" height="100"></canvas>' +
								'</div>';


							triggerCounts();
							setTimeout(() => {

								const ctx = document.getElementById('sellerChart');

								if (!ctx) return;
								if (window.sellerChartInstance) {
									window.sellerChartInstance.destroy();
								}

								window.sellerChartInstance = new Chart(ctx, {
									type: 'line',
									data: {
										labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
										datasets: [{
											label: 'Monthly Revenue',
											data: [
												<c:forEach var="m" items="${monthlyRevenue}" varStatus="s">
													${m}<c:if test="${!s.last}">,</c:if>
												</c:forEach>
											],

											borderColor: '#4f46e5',
											backgroundColor: 'rgba(79,70,229,0.1)',
											tension: 0.4,
											fill: true
										}]
									},
									options: {
										responsive: true,
										plugins: {
											legend: { display: true }
										}
									}
								});


							}, 200);

						}

						window.onload = function () {
							const savedMode = localStorage.getItem("dashboardMode");
							if (savedMode === "seller") { switchMode("seller"); }
							else { switchMode("user"); }
						};

					</script>

		</body>

		</html>