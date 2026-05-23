<%@ taglib prefix="c" uri="jakarta.tags.core" %>

	<%@page import="com.entity.User" %>
		<%@page import="com.entity.BookDtls" %>
			<%@page import="java.util.List" %>
				<%@page import="com.DAO.BookDAOImpl" %>
					<%@ page import="com.DBMS.DBConnect" %>
						<%@ page import="java.sql.Connection" %>
							<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
								<!DOCTYPE html>
								<html>

								<head>
									<meta charset="UTF-8">
									<title>Ebook: Index</title>
									<%@include file="all_component/allCss.jsp" %>
										<style type="text/css">
											.back-img {
												background: url("<%= request.getContextPath() %>/img/t.jpg");
												height: 80vh;
												width: 100%;
												background-repeat: no-repeat;
												background-size: cover;
											}

											/* Overlay FIXED */
											.overlay {
												position: absolute;
												top: 0;
												left: 0;
												width: 100%;
												height: 100%;
												display: flex;
												justify-content: center;
												align-items: center;
												background: rgba(255, 255, 255, .8);
												opacity: 0;

												pointer-events: none;
											}

											.details:hover .overlay {
												opacity: 1;
												pointer-events: auto;
											}

											/* Icon */
											.overlay .icon {
												font-size: 26px;
												display: flex;
												justify-content: center;
												align-items: center;
												margin: 0 8px;
												cursor: pointer;
												background: #fff;
												border: 1px solid #ddd;
												width: 55px;
												height: 53px;
												box-shadow: 0 3px 8px rgba(0, 0, 0, .2);

											}

											.overlay .icon a {
												color: black;
												text-decoration: none;
											}

											.overlay .icon:hover {
												background: black;
											}

											.overlay .icon:hover a {
												color: white;
											}
										</style>
								</head>

								<body style="background-color: #f7f7f7">


									<% User u=(User)session.getAttribute("userobj"); %>




										<%@include file="all_component/navbar.jsp" %>
											<div id="content">
												<div class="container-fluid back-img">
													<h2 class="text-center">
														Welcome to Your Ultimate Ebook Hub!
													</h2>
												</div>


												<!-- Starting of trending book -->

												<div class="container">
													<h3 class="text-center mb-4">🔥 Trending This Week</h3>

													<div class="row">

														<% BookDAOImpl dao2=new BookDAOImpl(DBConnect.getConn());
															List<BookDtls> list2 = dao2.getTrendingBooks(4);

															for (BookDtls b : list2) {
															%>

															<div class="col-md-3 mb-4">
																<div class="card h-100 shadow-sm">
																	<div class="card-body text-center">

																		<div class="details position-relative">

																			<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																				style="width:200px;height:275px;object-fit:cover;"
																				class="img-fluid">

																			<div class="overlay">

																				<% if(u==null){ %>
																					<div class="icon">
																						<a
																							href="${pageContext.request.contextPath}/login.jsp">
																							<i
																								class="fa-solid fa-cart-shopping"></i>
																						</a>
																					</div>
																					<% } else { %>
																						<div class="icon">
																							<a href="javascript:void(0)"
																								data-bid="<%= b.getBookId() %>"
																								onclick="addToCart(this)">
																								<i
																									class="fa-solid fa-cart-shopping"></i>
																							</a>
																						</div>
																						<% } %>

																							<div class="icon">
																								<a
																									href="${pageContext.request.contextPath}/view_books.jsp?bid=<%=b.getBookId()%>">
																									<i
																										class="fa-solid fa-eye"></i>
																								</a>
																							</div>

																			</div>
																		</div>

																		<h6 class="mt-3"><b>
																				<%=b.getBookName()%>
																			</b></h6>
																		<p>
																			<%=b.getAuthor()%>
																		</p>
																		<p class="text-success fw-bold">₹
																			<%=b.getPrice()%>
																		</p>

																	</div>
																</div>
															</div>

															<% } %>

													</div>
												</div>


												<div class="text-center mt-1">
													<a href="${pageContext.request.contextPath}/books/filter"
														class="btn btn-outline-dark btn-sm ">View
														All</a>
												</div>
											
											<!-- Ending of trending book -->
											<br>

											<!-- Starting of New Book -->
											<div class="container">
												<h3 class="text-center">New Books</h3>
												<div class="row">
													<% BookDAOImpl dao=new BookDAOImpl(DBConnect.getConn());
														List<BookDtls> list = dao.getNewBooks();
														for (BookDtls b : list) {
														%>
														<div class="col-md-3">
															<div class="card">
																<div class="card-body text-center">
																	<div class="details">
																		<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																			style="width: 200px; height: 275px;"
																			class="img-thumblin" alt="error">
																		<div class="overlay">

																			<% if (u==null){ %>
																				<div class="icon">
																					<a
																						href="${pageContext.request.contextPath}/login.jsp">
																						<i
																							class="fa-solid fa-cart-shopping"></i>
																					</a>
																				</div>
																				<% } else{ %>
																					<div class="icon">
																						<a href="javascript:void(0)"
																							data-bid="<%= b.getBookId() %>"
																							onclick="addToCart(this)">

																							<i
																								class="fa-solid fa-cart-shopping"></i>
																						</a>
																					</div>
																					<%} %>
																						<div class="icon">
																							<a
																								href="${pageContext.request.contextPath}/view_books.jsp?bid=<%=b.getBookId() %>"><i
																									class="fa-solid fa-eye"></i></a>
																						</div>

																		</div>
																		<p class="para1">
																			<b class="mt-2">
																				<%=b.getBookName()%>
																			</b><br>
																			<%=b.getAuthor()%><br>Category: <%=
																					b.getBookCategory()==null ? "N/A" :
																					b.getBookCategory() %>
																					<br>Rs.
																					<%=b.getPrice()%>/-
																		</p>
																	</div>


																</div>
															</div>
														</div>
														<% } %>


															<div class="text-center mt-1">
																<a href="${pageContext.request.contextPath}/all_new_book.jsp"
																	class="btn btn-outline-dark btn-sm ">View
																	All</a>
															</div>
												</div>
											</div>
											<!-- End of New book -->
											<br>
											<!-- Start of old books -->

											<div class="container">
												<h3 class="text-center">Old Books</h3>
												<div class="row">

													<% BookDAOImpl dao3=new BookDAOImpl(DBConnect.getConn());
														List<BookDtls> list3 = dao3.getOldBooks();
														for (BookDtls b : list3) {
														%>
														<div class="col-md-3">
															<div class="card">
																<div class="card-body text-center">
																	<div class="details">
																		<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																			style="width: 200px; height: 275px;"
																			class="img-thumblin" alt="error">
																		<div class="overlay">

																			<div class="icon">
																				<a
																					href="${pageContext.request.contextPath}/view_books.jsp?bid=<%=b.getBookId() %>"><i
																						class="fa-solid fa-eye"></i></a>
																			</div>

																		</div>
																		<p class="para1">
																			<b class="mt-2">
																				<%=b.getBookName()%>
																			</b><br>
																			<%=b.getAuthor()%><br>Category:
																				<%=b.getBookCategory()%><br>Rs.
																					<%=b.getPrice()%>/-
																		</p>
																	</div>


																</div>
															</div>
														</div>
														<% } %>


												</div>

												<div class="text-center mt-1">
													<a href="${pageContext.request.contextPath}/all_old_book.jsp"
														class="btn btn-outline-dark btn-sm ">View
														All</a>
												</div>
											</div>
											</div>
											<!-- end of old book -->
											<%@include file="all_component/footer.jsp" %>
												<script>

													function addToCart(element) {

														const bookId = element.getAttribute("data-bid");

														fetch("cart", {
															method: "POST",
															headers: {
																"Content-Type": "application/x-www-form-urlencoded",
																"X-CSRF-TOKEN": CSRF_TOKEN
															},
															body: "bid=" + bookId
														})
															.then(res => res.text())
															.then(data => {

																if (data === "ok") {
																	showToast("Book added to cart", "success");
																	refreshCartCount();
																}
																else if (data.includes("Stock")) {
																	showToast(data, "warn");
																}
																else {
																	showToast("Add to cart failed", "error");
																}

															})
															.catch(() => showToast("Server error", "error"));
													}

												</script>



								</body>

								</html>