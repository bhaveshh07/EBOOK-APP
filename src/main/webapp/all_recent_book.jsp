<%@page import="com.entity.User" %>
	<%@page import="com.entity.BookDtls" %>
		<%@page import="java.util.List" %>
			<%@page import="com.DBMS.DBConnect" %>
				<%@page import="com.DAO.BookDAOImpl" %>
					<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
						<%@ taglib prefix="c" uri="jakarta.tags.core" %>
							<!DOCTYPE html>
							<html>

							<head>
								<meta charset="UTF-8">
								<title>All Recent Book</title>
								<%@include file="all_component/allCss.jsp" %>
							</head>

							<body style="background-color: #f7f7f7">

								<% User u=(User) session.getAttribute("userobj"); %>

									<%@include file="all_component/navbar.jsp" %>
										<div id="content">
											<div class="container-fluid">
												<div class="row p-3">

													<% List<BookDtls> list2 = (List<BookDtls>)
															request.getAttribute("bookList");

															if (list2 == null) {
															BookDAOImpl dao2 = new BookDAOImpl(DBConnect.getConn());
															list2 = dao2.AllRecentBooks();
															}

															for (BookDtls b : list2) {
															%>

															<div class="col-md-3">
																<div class="card mt-2">
																	<div class="card-body text-center">
																		<div class="details">
																			<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																				style="width: 200px; height: 275px;"
																				class="img-thumblin" alt="error">

																			<p class="para1">
																				<b>
																					<%=b.getBookName()%>
																				</b><br>
																				<%=b.getAuthor()%><br>Category:
																					<%=b.getBookCategory()%>
																						<br>Rs.<%=b.getPrice()%>/-
																			</p>
																			<div class="overlay">

																				<% if
																					(b.getBookCategory().equals("Old"))
																					{ %>
																					<div class="icon">
																						<a
																							href="view_books.jsp?bid=<%=b.getBookId() %>"><i
																								class="fa-solid fa-eye"></i></a>
																					</div>

																					<% } else { %>
																						<div class="overlay">
																							<% if (u==null) { %>
																								<div class="icon">
																									<a href="login.jsp"><i
																											class="fa-solid fa-cart-shopping"></i></a>
																								</div>
																								<% } else { %>
																									<div class="icon">
																										<a href="javascript:void(0)"
																											class="add-cart-btn"
																											data-bookid="<%=b.getBookId()%>">
																											<i
																												class="fa-solid fa-cart-shopping"></i>
																										</a>
																									</div>
																									<% } %>
																										<div
																											class="icon">
																											<a
																												href="view_books.jsp?bid=<%=b.getBookId() %>"><i
																													class="fa-solid fa-eye"></i></a>
																										</div>

																						</div>
																						<% } %>
																			</div>


																		</div>


																	</div>
																</div>
															</div>
															<% } %>


												</div>
											</div>
										</div>
										<%@include file="all_component/footer.jsp" %>
											<script>document.addEventListener("click", function (e) {
													if (e.target.closest(".add-cart-btn")) {
														const id = e.target.closest(".add-cart-btn").dataset.bookid;
														addToCart(id);
													}
												});
											</script>
							</body>

							</html>