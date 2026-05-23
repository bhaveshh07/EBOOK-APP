<!-- ================= AMAZON STYLE FOOTER ================= -->

<style>
	/* Top Back to Top Bar */
	.footer-top {
		background: #cfcfcf;
		text-align: center;
		padding: 12px;
		cursor: pointer;
		font-weight: 500;
		transition: 0.3s;
	}

	.footer-top:hover {
		background: #bdbdbd;
	}

	/* Main Footer */
	.footer-main {
		background: #e3e3e3;
		padding: 50px 0;
	}

	.footer-main h6 {
		font-weight: 600;
		margin-bottom: 15px;
	}

	.footer-main a {
		display: block;
		text-decoration: none;
		color: #333;
		font-size: 14px;
		margin-bottom: 8px;
		transition: 0.3s;
	}

	.footer-main a:hover {
		color: #000;
		padding-left: 5px;
	}

	/* Bottom Section */
	.footer-bottom {
		background: #d5d5d5;
		padding: 20px 0;
		font-size: 14px;
	}

	/* Logo */
	.footer-logo {
		font-size: 22px;
		font-weight: 600;
	}

	/* Responsive */
	@media (max-width: 768px) {
		.footer-main {
			text-align: center;
		}
	}
</style>

<!-- Back to Top -->
<div class="footer-top" onclick="window.scrollTo({top:0, behavior:'smooth'})">
	Back to top
</div>

<!-- Main Footer -->
<footer class="footer-main">
	<div class="container">
		<div class="row gy-4">

			<div class="col-6 col-md-3">
				<h6>Get to Know Us</h6>
				<a href="#">About Us</a>
				<a href="#">Careers</a>
				<a href="#">Press Releases</a>
				<a href="#">Ebooks Science</a>
			</div>

			<div class="col-6 col-md-3">
				<h6>Connect with Us</h6>
				<a href="#"><i class="fa-brands fa-facebook me-2"></i>Facebook</a>
				<a href="#"><i class="fa-brands fa-instagram me-2"></i>Instagram</a>
				<a href="#"><i class="fa-brands fa-x-twitter me-2"></i>Twitter</a>
			</div>

			<div class="col-6 col-md-3">
				<h6>Make Money with Us</h6>
				<a href="${pageContext.request.contextPath}/sell_book.jsp">Sell on Ebooks</a>
				<a href="${pageContext.request.contextPath}/setting.jsp">Seller Dashboard</a>
				<a href="#">Affiliate Program</a>
				<a href="#">Advertise Your Books</a>
			</div>

			<div class="col-6 col-md-3">
				<h6>Let Us Help You</h6>
				<a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
				<a href="${pageContext.request.contextPath}/setting.jsp">Your Account</a>
				<a href="${pageContext.request.contextPath}/my_orders">Returns Centre</a>
				<a href="${pageContext.request.contextPath}/helpline.jsp">Help</a>
			</div>

		</div>
	</div>
</footer>

<!-- Bottom Copyright -->
<div class="footer-bottom text-center">
	<div class="container">
		<div class="footer-logo mb-2">
			<i class="fa-solid fa-book-open me-2"></i> Ebooks
		</div>
		© <span id="dynamicYear"></span> Ebooks.com | All Rights Reserved
	</div>
</div>

<script>
	document.getElementById("dynamicYear").textContent = new Date().getFullYear();
</script>

<!-- ================= END FOOTER ================= -->