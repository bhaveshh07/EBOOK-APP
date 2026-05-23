<%@page import="com.entity.User" %>
	<%@page import="java.util.List" %>
		<%@page import="com.entity.BookDtls" %>
			<%@page import="java.sql.Connection" %>
				<%@page import="com.DBMS.DBConnect" %>
					<%@page import="com.DAO.BookDAOImpl" %>
						<%@page import="com.DAO.ReviewDAOImpl" %>
							<%@page import="com.entity.Review" %>
								<%@ taglib prefix="c" uri="jakarta.tags.core" %>
									<%@ page contentType="text/html; charset=UTF-8" %>


										<!DOCTYPE html>
										<html>

										<head>
											<title>View Book</title>
											<%@include file="all_component/allCss.jsp" %>

												<style>
													.book-split {
														border-right: 2px solid #e0e0e0;
													}



													.overlay-icons {
														position: absolute;
														inset: 0;
														display: flex;
														align-items: center;
														justify-content: center;
														background: rgba(0, 0, 0, 0.6);
														opacity: 0;
														transition: 0.4s;
													}

													.book-price {
														font-size: 26px;
														font-weight: 700;
														color: #198754;
													}

													/* Quantity Box */
													.qty-box {
														display: flex;
														align-items: center;
														border: 1px solid #ccc;
														border-radius: 8px;
														overflow: hidden;
														width: 130px;
													}

													.qty-btn {
														width: 40px;
														height: 40px;
														border: none;
														background: #f1f1f1;
														font-size: 20px;
														cursor: pointer;
													}

													.qty-btn:hover {
														background: #ddd;
													}

													.qty-box input {
														width: 50px;
														text-align: center;
														border: none;
														font-size: 16px;
														outline: none;
													}


													.reco-card:hover .overlay-icons {
														opacity: 1;
													}

													.overlay-icons i {
														background: #fff;
														padding: 14px;
														border-radius: 50%;
														font-size: 20px;
														color: #000;
													}

													.section-divider {
														border-top: 2px solid #e0e0e0;
														margin: 60px 0;
													}

													.book-view-card {
														background: #fff;
														border-radius: 18px;
														padding: 40px;
														box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
													}

													.book-view-img {
														max-width: 260px;
														transition: 0.4s;
													}

													.book-view-img:hover {
														transform: scale(1.05);
													}

													.main-book-img {
														max-width: 220px;
														height: auto;
														object-fit: contain
													}

													.review-box {
														border: 1px solid #ddd;
														padding: 12px;
														border-radius: 6px;
														margin-bottom: 12px
													}

													.star {
														color: #ffc107
													}

													.review-img {
														width: 120px;
														height: 120px;
														object-fit: cover;
														border-radius: 5px;
														margin-top: 5px
													}

													.review-section {
														background: #ffffff;
														padding: 30px;
														border-radius: 12px;
														box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
														margin-top: 40px;
													}

													.reco-card {
														display: flex;
														flex-direction: column;
														border: none;
														border-radius: 15px;
														overflow: hidden;
														transition: 0.4s;
														box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
													}

													.reco-card:hover {
														transform: translateY(-10px);
														box-shadow: 0 14px 30px rgba(0, 0, 0, 0.15);
													}

													.skeleton {
														background: linear-gradient(90deg,
																#eee 25%,
																#f5f5f5 37%,
																#eee 63%);
														background-size: 400% 100%;
														animation: shimmer 1.4s infinite;
														border-radius: 8px;
													}

													@keyframes shimmer {
														0% {
															background-position: 100% 0
														}

														100% {
															background-position: -100% 0
														}
													}

													.skel-img {
														height: 180px;
													}

													.skel-title {
														height: 18px;
														width: 70%;
														margin: 10px auto;
													}

													.skel-text {
														height: 14px;
														width: 50%;
														margin: 6px auto;
													}

													.toast {
														position: fixed;
														bottom: 30px;
														right: 30px;
														background: #333;
														color: white;
														padding: 12px 20px;
														border-radius: 6px;
														opacity: 0;
														pointer-events: none;
														transition: 0.4s;
														z-index: 9999;
													}

													.toast.show {
														opacity: 1;
													}

													.toast.success {
														background: #28a745;
													}

													.toast.error {
														background: #dc3545;
													}

													.toast.warn {
														background: #ffc107;
														color: black;
													}

													.reco-card img {
														width: auto;
														max-width: 100%;
														height: 180px;
														object-fit: contain;
														display: block;
														margin: 0 auto;
														background: #f8f8f8;
														padding: 10px;
													}

													.reco-card:hover img {
														transform: scale(1.04);
														transition: 0.4s;
													}

													.reco-card .card-body {
														padding: 16px;
														flex-grow: 1;
														text-align: center;
													}


													.reco-title {
														font-weight: 600;
													}

													.reco-price {
														color: #198754;
														font-weight: 600;
													}

													.rstar {
														font-size: 26px;
														cursor: pointer;
														color: #ccc;
													}

													.buy-box {
														display: flex;
														flex-direction: column;
														align-items: center;
														gap: 14px;
														margin-top: 8px;
													}

													.price-pill {
														background: #198754;
														color: white;
														padding: 10px 60px;
														border-radius: 8px;
														font-size: 18px;
														font-weight: 600;
														min-width: 220px;
														text-align: center;
													}

													.addcart-btn {
														background: #ffc107;
														color: #000;
														padding: 12px 60px;
														border-radius: 8px;
														font-size: 17px;
														font-weight: 600;
														min-width: 220px;
														transition: 0.3s;
													}

													.addcart-btn:hover {
														background: #e0a800;
														transform: translateY(-2px);
													}


													.rstar.active {
														color: #ffc107;
													}

													.book-info {
														display: flex;
														flex-direction: column;
														justify-content: center;
														height: 100%;
													}

													.delivery-benefits {
														display: flex;
														flex-direction: column;
														gap: 10px;
														margin: 10px 0;
													}

													.benefit-item {
														display: flex;
														align-items: center;
														gap: 10px;
														font-size: 15px;
														font-weight: 500;
														color: #444;
													}

													.benefit-item i {
														color: #198754;
														font-size: 18px;
													}
												</style>

												<script>
													function toggleEdit(id) {
														document.getElementById("text-" + id).style.display = "none";
														document.getElementById("form-" + id).style.display = "block";
													}

													function saveReview(id) {

														let form = document.getElementById("form-" + id);

														fetch("editReview", {
															method: "POST",
															headers: { "X-CSRF-TOKEN": document.getElementById("csrfToken").value },
															body: new FormData(form)
														})

															.then(res => res.text())
															.then(data => {

																data = data.trim();

																if (data === "ok") {
																	showToast("Review updated successfully", "success");

																	setTimeout(() => {
																		location.reload();
																	}, 1200);

																} else {
																	//  show backend error message
																	showToast(data, "error");
																}
															})
															.catch(() => {
																showToast("Something went wrong", "error");
															});
													}


													function markHelpful(rid) {
														let bid = document.getElementById("bookIdHidden").value;
														fetch("helpfulReview?rid=" + rid + "&bid=" + bid)
															.then(res => res.text())
															.then(count => {
																document.getElementById("help-count-" + rid).innerText = count;
															});
													}
												</script>
										</head>

										<body style="background:#f7f7f7">
											<%@include file="all_component/navbar.jsp" %>

												<% User u=(User)session.getAttribute("userobj"); int bid=0;
													if(request.getParameter("bid")!=null){
													bid=Integer.parseInt(request.getParameter("bid")); } Connection
													conn=null; BookDAOImpl dao=null; ReviewDAOImpl rdao=null; BookDtls
													b=null; try { conn=DBConnect.getConn(); dao=new BookDAOImpl(conn);
													rdao=new ReviewDAOImpl(conn); b=dao.getBookById(bid); Integer
													userId=null; if (u !=null) { userId=u.getId(); }
													dao.logBookView(userId, bid);} catch(Exception e){
													e.printStackTrace(); } String sort=request.getParameter("sort");
													if(sort==null) sort="latest" ; /* Pagination */ int pageNo=1; int
													limit=3; if(request.getParameter("page") !=null){
													pageNo=Integer.parseInt(request.getParameter("page")); } int
													start=(pageNo - 1) * limit; List<Review> reviews =
													rdao.getReviewsSortedPaged(bid, sort, start, limit);
													double avgRating=rdao.getAverageRating(bid);
													int totalReviews = rdao.countReviews(bid);
													int[] ratingDist = rdao.getRatingDistribution(bid);
													List<BookDtls> recList =dao.getSmartRecommendations(b.getBookId(),
														b.getBookCategory());
														int totalDist = 0;
														for(int i=0;i<5;i++){ totalDist +=ratingDist[i]; } %>

															<input type="hidden" id="bookIdHidden" value="<%=bid%>">

															<input type="hidden" id="csrfToken"
																value="${sessionScope.CSRF_TOKEN}">
															<div id="content">
																<!-- ================= BOOK DETAILS ================= -->
																<div class="container mt-5 p-3 book-view-card">
																	<div class="row">

																		<div
																			class="col-md-6 bg-white p-4 text-center book-split">

																			<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																				class="main-book-img book-view-img">
																			<div class="book-meta">
																				<h3>
																					<%=b.getBookName()%>
																				</h3>
																				<h5>Author : <%=b.getAuthor()%>
																				</h5>

																				<p>
																					<% for(int i=1;i<=5;i++){ %>
																						<% if(i<=avgRating){ %>
																							<i
																								class="fa-solid fa-star star"></i>
																							<% } else { %>
																								<i
																									class="fa-regular fa-star"></i>
																								<% } %>
																									<% } %>
																				</p>

																				<h6>Category : <%=b.getBookCategory()%>
																				</h6>
																			</div>
																		</div>
																		<div
																			class="col-md-6 bg-white p-4 text-center book-info">

																			<h2>
																				<%=b.getBookName()%>
																			</h2>
																			<p>
																				<%=b.getDescription()%>
																			</p>

																			<div class="buy-box">
																				<div class="delivery-benefits">

																					<div class="benefit-item">
																						<i
																							class="fa-solid fa-money-bill-wave"></i>
																						<span>Cash on Delivery
																							Available</span>
																					</div>

																					<div class="benefit-item">
																						<i
																							class="fa-solid fa-rotate-left"></i>
																						<span>Easy 7-Day Return</span>
																					</div>

																					<div class="benefit-item">
																						<i
																							class="fa-solid fa-truck-fast"></i>
																						<span>Free Delivery</span>
																					</div>

																				</div>

																				<!-- Price -->
																				<div class="book-price">
																					₹ <%=b.getPrice()%>
																				</div>



																				<button class="btn addcart-btn"
																					onclick="addToCart(<%=b.getBookId()%>)">
																					Add To Cart
																				</button>






																			</div>

																		</div>
																	</div>

																</div>

																<div class="section-divider"></div>
																<!--  RATING BREAKDOWN BLOCK HERE -->
																<div class="container mt-4">
																	<div class="row">
																		<div class="col-md-4 text-center">
																			<h2>
																				<%=String.format("%.1f", avgRating)%>
																			</h2>
																			<p>
																				<% for(int i=1;i<=5;i++){ %>
																					<% if(i <=avgRating){ %>
																						<i
																							class="fa-solid fa-star star"></i>
																						<% } else { %>
																							<i
																								class="fa-regular fa-star"></i>
																							<% } %>
																								<% } %>
																			</p>
																			<p>
																				<%=totalReviews%> Reviews
																			</p>
																		</div>

																		<div class="col-md-8">

																			<% for(int i=5;i>=1;i--){
																				int count = ratingDist[i-1];
																				int percent = totalReviews == 0 ? 0 :
																				(count
																				*
																				100)
																				/ totalReviews;
																				%>

																				<div
																					class="d-flex align-items-center mb-2">
																					<div style="width:60px;">
																						<%=i%> ★
																					</div>

																					<div class="progress flex-grow-1 me-2"
																						style="height:8px;">
																						<div class="progress-bar bg-warning"
																							style="width:<%=percent%>%">
																						</div>
																					</div>

																					<div style="width:40px;">
																						<%=count%>
																					</div>
																				</div>

																				<% } %>

																		</div>
																	</div>
																</div>

																<div class="section-divider"></div>

																<!-- ================= WRITE REVIEW ================= -->
																<div class="container">
																	<c:if test="${not empty failedMsg}">
																		<div class="alert alert-danger mt-2">
																			${failedMsg}
																		</div>
																		<c:remove var="failedMsg" scope="session" />
																	</c:if>

																	<c:if test="${not empty succMsg}">
																		<div class="alert alert-success mt-2">
																			${succMsg}
																		</div>
																		<c:remove var="succMsg" scope="session" />
																	</c:if>

																	<h4>Write Review</h4>

																	<% if(u==null){ %>
																		<p><a href="login.jsp">Login</a> to write review
																		</p>
																		<% }else
																			if(rdao.hasUserReviewed(bid,u.getId())){ %>
																			<p class="text-success">You already reviewed
																			</p>
																			<% }else{ %>

																				<form action="addReview" method="post"
																					enctype="multipart/form-data">
																					<input type="hidden"
																						name="csrf_token"
																						value="${sessionScope.CSRF_TOKEN}">

																					<input type="hidden" name="bookId"
																						value="<%=bid%>">
																					<input type="hidden" name="userId"
																						value="<%=u.getId()%>">

																					<input type="hidden" name="rating"
																						id="ratingValue">

																					<div class="rating-stars mb-2">
																						<i class="fa-regular fa-star rstar"
																							data-val="1"></i>
																						<i class="fa-regular fa-star rstar"
																							data-val="2"></i>
																						<i class="fa-regular fa-star rstar"
																							data-val="3"></i>
																						<i class="fa-regular fa-star rstar"
																							data-val="4"></i>
																						<i class="fa-regular fa-star rstar"
																							data-val="5"></i>
																					</div>


																					<textarea name="reviewText"
																						class="form-control mt-2"
																						required></textarea>
																					<input type="file"
																						name="reviewImage"
																						class="form-control mt-2">

																					<button
																						class="btn btn-primary mt-2">Submit</button>
																				</form>

																				<% } %>
																</div>

																<div class="section-divider"></div>


																<!-- ================= REVIEWS HEADER ================= -->
																<div
																	class="container d-flex justify-content-between align-items-center">
																	<h4>User Reviews (<%=totalReviews%>)</h4>

																	<form method="get">
																		<input type="hidden" name="bid"
																			value="<%=bid%>">
																		<select name="sort"
																			onchange="this.form.submit()">

																			<option value="latest"
																				<%=sort.equals("latest") ? "selected"
																				: "" %>>
																				Latest
																			</option>

																			<option value="high" <%=sort.equals("high")
																				? "selected" : "" %>>
																				Highest
																			</option>

																			<option value="low" <%=sort.equals("low")
																				? "selected" : "" %>>
																				Lowest
																			</option>

																			<option value="helpful"
																				<%=sort.equals("helpful") ? "selected"
																				: "" %>>
																				Most Helpful
																			</option>

																		</select>

																	</form>
																</div>

																<!-- ================= SHOW REVIEWS ================= -->
																<div class=" container review-section">

																	<% for(Review rv:reviews){ %>
																		<div class="review-box">

																			<b>
																				<%=rv.getUserName()%>
																			</b>

																			<p>
																				<% for(int i=1;i<=5;i++){ %>
																					<% if(i<=rv.getRating()){ %>
																						<i
																							class="fa-solid fa-star star"></i>
																						<% } else { %>
																							<i
																								class="fa-regular fa-star"></i>
																							<% } %>

																								<% } %>
																			</p>

																			<p id="text-<%=rv.getReviewId()%>">
																				<%=rv.getReviewText()%>
																			</p>

																			<% if(rv.getImage()!=null){ %>
																				<img src="<%=request.getContextPath()%>/uploads/reviews/<%=rv.getImage()%>"
																					class="review-img" alt="error">

																				<% } %>

																					<% if(u!=null){ %>
																						<button
																							class="btn btn-sm btn-outline-secondary"
																							onclick="markHelpful('<%=rv.getReviewId()%>')">
																							👍 Helpful (<span
																								id="help-count-<%=rv.getReviewId()%>">
																								<%=rv.getHelpfulCount()%>
																							</span>)
																						</button>
																						<% } %>


																							<% if(u!=null &&
																								rv.getUserName().equals(u.getName())){
																								%>

																								<button type="button"
																									class="btn btn-sm btn-info"
																									onclick="toggleEdit('<%=rv.getReviewId()%>')">
																									Edit
																								</button>

																								<a href="deleteReview?rid=<%=rv.getReviewId()%>&bid=<%=bid%>"
																									class="btn btn-sm btn-danger">
																									Delete
																								</a>

																								<form
																									id="form-<%=rv.getReviewId()%>"
																									method="post"
																									enctype="multipart/form-data"
																									style="display:none">
																									<input type="hidden"
																										name="csrf_token"
																										value="${sessionScope.CSRF_TOKEN}">


																									<!-- REQUIRED -->
																									<input type="hidden"
																										name="reviewId"
																										value="<%=rv.getReviewId()%>">

																									<!-- TEXT -->
																									<textarea
																										name="reviewText"
																										class="form-control"
																										required><%=rv.getReviewText()%></textarea>

																									<!-- RATING -->
																									<select
																										name="rating"
																										class="form-control mt-2">
																										<option
																											value="1">1
																											Star
																										</option>
																										<option
																											value="2">2
																											Stars
																										</option>
																										<option
																											value="3">3
																											Stars
																										</option>
																										<option
																											value="4">4
																											Stars
																										</option>
																										<option
																											value="5">5
																											Stars
																										</option>
																									</select>

																									<!-- IMAGE -->
																									<input type="file"
																										name="reviewImage"
																										class="form-control mt-2">

																									<button
																										type="button"
																										class="btn btn-success btn-sm mt-2"
																										onclick="saveReview('<%=rv.getReviewId()%>')">
																										Save
																									</button>

																								</form>



																								<% } %>


																		</div>
																		<% } %>

																</div>

																<!-- ================= PAGINATION ================= -->
																<% int pages=(int)Math.ceil(totalReviews/(double)limit);
																	if(pages>
																	1){
																	%>

																	<div class="container text-center mt-3">

																		<c:forEach var="i" begin="1" end="${pages}">
																			<a href="view_books.jsp?bid=${bid}&page=${i}&sort=${sort}"
																				class="btn btn-sm ${i == pageNo ? 'btn-primary' : 'btn-outline-primary'}">
																				${i}
																			</a>
																		</c:forEach>




																	</div>


																	<% } %>


																		<div class="section-divider"></div>


																		<!-- ================= SMART RECOMMENDATION ================= -->
																		<h3 class="text-center">Recommended For You</h3>
																		<div class="container">
																			<!-- Skeleton loaders FIRST -->
																			<div id="skeletonArea" class="row">

																				<% for(int i=0;i<4;i++){ %>
																					<div class="col-md-3 mb-3">
																						<div class="card reco-card p-3">
																							<div
																								class="skeleton skel-img">
																							</div>
																							<div
																								class="skeleton skel-title">
																							</div>
																							<div
																								class="skeleton skel-text">
																							</div>
																						</div>
																					</div>
																					<% } %>

																			</div>
																			<div class="row">

																				<% for(BookDtls rb:recList){ %>
																					<div class="col-md-3 mb-3">
																						<a href="view_books.jsp?bid=<%=rb.getBookId()%>"
																							class="text-decoration-none text-dark">
																							<div class="card reco-card">

																								<div
																									class="position-relative">
																									<img
																										src="<%=request.getContextPath()%>/uploads/book/<%=rb.getPhotoName()%>">

																									<div
																										class="overlay-icons">
																										<a
																											href="view_books.jsp?bid=<%=rb.getBookId()%>">
																											<i
																												class="fa-solid fa-eye"></i>
																										</a>
																									</div>
																								</div>

																								<div
																									class="card-body text-center">
																									<b
																										class="reco-title">
																										<%=rb.getBookName()%>
																									</b>
																									<p>
																										<%=rb.getAuthor()%>
																									</p>
																									<p
																										class="reco-price">
																										₹
																										<%=rb.getPrice()%>
																									</p>
																								</div>
																							</div>
																						</a>

																					</div>
																					<% } %>
																			</div>
																		</div>

																		<div id="toast" class="toast"></div>
																		<% if(conn !=null){ try{ conn.close(); }
																			catch(Exception e){ e.printStackTrace(); } }
																			%>
															</div>
															<%@include file="all_component/footer.jsp" %>
																<script>
																	document.querySelectorAll(".rstar").forEach((star, i) => {
																		star.onclick = () => {
																			document.getElementById("ratingValue").value = i + 1;
																			document.querySelectorAll(".rstar").forEach(s => s.classList.remove("active"));
																			for (let j = 0; j <= i; j++) {
																				document.querySelectorAll(".rstar")[j].classList.add("active");
																			}
																		}
																	});
																	window.onload = function () {
																		document.getElementById("skeletonArea").style.display = "none";
																	}
																	function markHelpful(rid) {

																		let uidInput = document.getElementById("userIdHidden");
																		if (!uidInput) {
																			showToast("Login required", "warn");
																			return;
																		}
																		let uid = uidInput.value;


																		fetch("helpfulReview?rid=" + rid + "&uid=" + uid)
																			.then(res => res.text())
																			.then(count => {
																				document.getElementById("help-count-" + rid).innerText = count;
																			});
																	}
																	function showToast(msg, type) {
																		let t = document.getElementById("toast");
																		t.className = "toast show " + type;
																		t.innerText = msg;

																		setTimeout(() => {
																			t.className = "toast";
																		}, 2000);
																	}

																	function addToCart(bid) {

																		let uidInput = document.getElementById("userIdHidden");

																		if (!uidInput) {
																			showToast("Please login to add items to cart", "warn");
																			return;
																		}

																		fetch("cart", {
																			method: "POST",
																			headers: {
																				"Content-Type": "application/x-www-form-urlencoded",
																				"X-CSRF-TOKEN": CSRF_TOKEN
																			},
																			body: "bid=" + bid
																		})
																			.then(res => {
																				if (res.status === 403) throw "csrf";
																				return res.text();
																			})
																			.then(data => {
																				if (data === "ok") {
																					showToast("Added to cart", "success");
																				} else {
																					showToast(data, "error");
																				}
																			})
																			.catch(err => {
																				if (err === "csrf") {
																					showToast("Security error. Refresh page.", "error");
																				} else {
																					showToast("Failed to add", "error");
																				}
																			});
																	}



																</script>

										</body>

										</html>