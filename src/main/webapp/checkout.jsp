<%@page import="com.entity.Cart" %>
	<%@page import="com.entity.User" %>
		<%@page import="java.util.List" %>
			<%@page import="com.DAO.CartDAOImpl" %>
				<%@page import="com.DAO.WalletDAOImpl" %>
					<%@page import="com.DBMS.DBConnect" %>

						<%@ page language="java" contentType="text/html; charset=UTF-8" %>
							<%@ taglib prefix="c" uri="jakarta.tags.core" %>
								<%@page isELIgnored="false" %>

									<!DOCTYPE html>
									<html>

									<head>
										<meta charset="UTF-8">
										<title>Checkout</title>
										<%@include file="all_component/allCss.jsp" %>
									</head>

									<body style="background:#f7f7f7">

										<%@include file="all_component/navbar.jsp" %>
											<div id="content">
												<c:if test="${empty userobj}">
													<c:redirect url="login.jsp" />
												</c:if>

												<% User u=(User)session.getAttribute("userobj"); CartDAOImpl cartDao=new
													CartDAOImpl(DBConnect.getConn()); List<Cart> cart =
													cartDao.getBookByUser(u.getId());

													double subtotal = 0;
													for(Cart c : cart){
													subtotal += c.getTotalPrice();
													}

													WalletDAOImpl walletDao = new WalletDAOImpl(DBConnect.getConn());
													double walletBalance = walletDao.getBalanceByUser(u.getId());
													%>

													<div class="container mt-4">
														<div class="row">

															<!-- ================= LEFT SIDE ================= -->
															<div class="col-md-6">
																<div class="card mb-3">
																	<div class="card-body">

																		<h4 class="text-success text-center">Your
																			Selected
																			Items</h4>

																		<table class="table table-striped">
																			<thead>
																				<tr>
																					<th>Book</th>
																					<th>Author</th>
																					<th>Price</th>
																					<th>Qty</th>
																					<th>Action</th>
																				</tr>
																			</thead>
																			<tbody>

																				<% for(Cart c : cart){ %>
																					<tr>
																						<td>
																							<%=c.getBookName()%>
																						</td>
																						<td>
																							<%=c.getAuthor()%>
																						</td>
																						<td>₹ <%=c.getPrice()%>
																						</td>

																						<td>
																							<div
																								class="d-flex align-items-center gap-2">

																								<button type="button"
																									class="btn btn-sm btn-secondary minus-btn"
																									<%=c.getQuantity()==1
																									? "disabled" : "" %>
																									data-cid="<%=
																										c.getCid() %>"
																										onclick="decreaseQty(this)">
																										-
																								</button>

																								<span
																									id="q<%=c.getCid()%>"
																									class="fw-bold">
																									<%=c.getQuantity()%>
																								</span>

																								<button type="button"
																									class="btn btn-sm btn-secondary"
																									data-cid="<%=c.getCid()%>"
																									onclick="increaseQty(this)">
																									+
																								</button>

																							</div>
																						</td>

																						<td>
																							<a href="remove_book?cid=<%=c.getCid()%>"
																								class="btn btn-sm btn-outline-danger">Remove</a>
																						</td>
																					</tr>
																					<% } %>

																						<tr>
																							<td colspan="4">Subtotal
																							</td>
																							<td id="subtotal">
																								<%=subtotal%>
																							</td>
																						</tr>

																						<tr>
																							<td colspan="4">Delivery
																							</td>
																							<td id="delivery">40</td>
																						</tr>

																						<tr>
																							<td colspan="4">Discount
																							</td>
																							<td id="discount">0</td>
																						</tr>

																						<tr>
																							<td colspan="4"><b>Grand
																									Total</b></td>
																							<td id="grandTotal">
																								<%=subtotal+40%>
																							</td>
																						</tr>

																			</tbody>
																		</table>
																	</div>
																</div>

																<!-- Offers -->
																<div class="card mb-3">
																	<div class="card-body">
																		<h6>Available Offers</h6>
																		<div class="border p-2 mb-2"><b>SAVE100</b> –
																			₹100
																			off above ₹599</div>
																		<div class="border p-2 mb-2"><b>SAVE10</b> – 10%
																			off
																			above ₹399</div>
																		<div class="border p-2 mb-2"><b>BIG20</b> – 20%
																			off
																			above ₹999</div>
																	</div>
																</div>

															</div>

															<!-- ================= RIGHT SIDE ================= -->
															<div class="col-md-6">
																<div class="card">
																	<div class="card-body">

																		<h4 class="text-success text-center">Order
																			Details
																		</h4>

																		<form action="order" method="post">

																			<input type="hidden" name="csrf_token"
																				value="${sessionScope.CSRF_TOKEN}">
																			<input type="hidden" name="coupon"
																				id="finalCoupon">

																			<input class="form-control mb-2"
																				name="username" value="${userobj.name}"
																				required autocomplete="name">

																			<input class="form-control mb-2"
																				name="email" value="${userobj.email}"
																				required autocomplete="email">

																			<input class="form-control mb-2" name="phno"
																				value="${userobj.phno}" required
																				autocomplete="tel">

																			<input class="form-control mb-2"
																				name="address" placeholder="Address"
																				required autocomplete="street-address">

																			<input class="form-control mb-2"
																				name="landmark" placeholder="Landmark"
																				required>

																			<input class="form-control mb-2" name="city"
																				placeholder="City" required
																				autocomplete="address-level2">

																			<input class="form-control mb-2"
																				name="state" placeholder="State"
																				required autocomplete="address-level1">

																			<input class="form-control mb-3"
																				name="pincode" placeholder="Pincode"
																				required autocomplete="postal-code">

																			<!-- Coupon -->
																			<div class="input-group mb-2">
																				<input class="form-control"
																					id="couponInput"
																					placeholder="Coupon code">
																				<button type="button"
																					class="btn btn-dark"
																					onclick="applyCoupon()">Apply</button>
																			</div>
																			<small id="couponMsg"></small>

																			<!-- Payment -->
																			<div class="card p-3 mt-3">
																				<label class="fw-bold">Payment
																					Mode</label>

																				<div class="form-check mt-2">
																					<input class="form-check-input"
																						type="radio" name="payment"
																						value="WALLET"
																						id="walletOption">
																					<label class="form-check-label">
																						Wallet (₹ <%=walletBalance%>)
																							<span
																								id="walletStatusText"></span>
																					</label>
																				</div>

																				<div class="form-check mt-2">
																					<input class="form-check-input"
																						type="radio" name="payment"
																						value="COD">
																					<label class="form-check-label">Cash
																						on
																						Delivery</label>
																				</div>

																				<div class="form-check mt-2">
																					<input class="form-check-input"
																						type="radio" name="payment"
																						value="ONLINE">
																					<label
																						class="form-check-label">Online
																						Payment</label>
																				</div>
																			</div>

																			<div class="text-center mt-3">
																				<button class="btn btn-success">Place
																					Order</button>
																			</div>

																		</form>
																	</div>
																</div>
															</div>

														</div>
													</div>
													<div id="customToast">
													</div>
											</div>
											<%@include file="all_component/footer.jsp" %>

												<script>

													const WALLET_BALANCE = Number("<%= walletBalance %>");

													function showToast(msg, type = "success") {

														const toast = document.getElementById("customToast");

														toast.innerText = msg;
														toast.style.display = "block";
														toast.style.opacity = "1";

														toast.style.position = "fixed";
														toast.style.bottom = "30px";
														toast.style.right = "30px";
														toast.style.padding = "12px 20px";
														toast.style.borderRadius = "8px";
														toast.style.zIndex = "9999";
														toast.style.fontWeight = "500";

														// reset colors
														toast.style.color = "#fff";

														if (type === "success") {
															toast.style.background = "#28a745";
														}
														else if (type === "error") {
															toast.style.background = "#dc3545";
														}
														else {
															toast.style.background = "#ffc107";
															toast.style.color = "#000";
														}

														setTimeout(() => {
															toast.style.opacity = "0";
															setTimeout(() => {
																toast.style.display = "none";
																toast.style.opacity = "1";
															}, 300);
														}, 2000);
													}

													function changeQty(cid, newQty) {

														if (newQty < 1) return;

														fetch("updateCartQty", {
															method: "POST",
															headers: {
																"Content-Type": "application/x-www-form-urlencoded",
																"X-CSRF-TOKEN": CSRF_TOKEN
															},
															body: "cid=" + cid + "&qty=" + newQty
														})
															.then(res => res.json())
															.then(data => {

																if (data.status === "ok") {

																	document.getElementById("q" + cid).innerText = newQty;

																	document.getElementById("subtotal").innerText = data.subtotal;
																	document.getElementById("grandTotal").innerText = data.grandTotal;

																	showToast("Quantity updated", "success");

																	// Disable minus button if qty == 1
																	const minusBtn = document.querySelector(
																		"button[data-cid='" + cid + "'].minus-btn"
																	);
																	if (minusBtn) minusBtn.disabled = (newQty <= 1);

																	updateWalletEligibility();

																} else if (data.status === "stock") {

																	showToast("Only " + data.available + " left in stock", "warn");

																} else {

																	showToast("Update failed", "error");

																}

															})
															.catch(() => showToast("Server error", "error"));
													}

													function increaseQty(btn) {
														const cid = btn.dataset.cid.trim();
														const current = parseInt(document.getElementById("q" + cid).innerText);
														changeQty(cid, current + 1);
													}

													function decreaseQty(btn) {
														const cid = btn.dataset.cid.trim();
														const current = parseInt(document.getElementById("q" + cid).innerText);
														if (current > 1) {
															changeQty(cid, current - 1);
														}
													}

													function applyCoupon() {

														const code = document.getElementById("couponInput").value.trim().toUpperCase();
														const subtotal = parseFloat(document.getElementById("subtotal").innerText);
														let discount = 0;

														if (code === "SAVE100" && subtotal >= 599) {
															discount = 100;
														} else if (code === "SAVE10" && subtotal >= 399) {
															discount = subtotal * 0.10;
														} else if (code === "BIG20" && subtotal >= 999) {
															discount = subtotal * 0.20;
														} else {
															showToast("Invalid coupon or minimum not met", "error");
															return;
														}

														document.getElementById("discount").innerText = discount.toFixed(2);
														document.getElementById("grandTotal").innerText =
															(subtotal - discount + 40).toFixed(2);

														document.getElementById("finalCoupon").value = code;

														showToast("Coupon applied", "success");

														updateWalletEligibility();
													}

													function updateWalletEligibility() {

														const walletRadio = document.getElementById("walletOption");
														const walletStatus = document.getElementById("walletStatusText");
														const total = parseFloat(document.getElementById("grandTotal").innerText);

														if (WALLET_BALANCE >= total) {
															walletRadio.disabled = false;
															walletStatus.innerHTML =
																"<span class='text-success'>(Available)</span>";
														} else {
															walletRadio.checked = false;
															walletRadio.disabled = true;
															walletStatus.innerHTML =
																"<span class='text-danger'>(Insufficient)</span>";
														}
													}

													window.onload = updateWalletEligibility;

												</script>

									</body>

									</html>