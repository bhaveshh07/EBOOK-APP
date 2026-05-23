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
							<title>All Old Book</title>
							<%@include file="all_component/allCss.jsp" %>
								<style>
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
							<%@include file="all_component/navbar.jsp" %>
								<div id="content">
									<div class="container-fluid">
										<div class="row p-3">

											<% BookDAOImpl dao2=new BookDAOImpl(DBConnect.getConn()); List<BookDtls>
												list2 = dao2.AllOldBooks();
												for (BookDtls b : list2) {
												%>
												<div class="col-md-3 mb-4">

													<div class="card mt-2">
														<div class="card-body text-center">
															<div class="details">
																<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																	style="width: 200px; height: 275px;"
																	class="img-thumblin" alt="error">

																<p class="para1" style="margin: 0; padding: 0;">
																	<b clas="mt-2">
																		<%=b.getBookName()%>
																	</b><br>
																	<%=b.getAuthor()%><br>Category:
																		<%=b.getBookCategory()%>
																			<br>Rs.<%=b.getPrice()%>/-
																</p>
																<div class="overlay">
																	<div class="icon">
																		<a href="view_books.jsp?bid=<%=b.getBookId()%>"><i
																				class="fa-solid fa-eye"></i></a>
																	</div>
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
						</body>

						</html>