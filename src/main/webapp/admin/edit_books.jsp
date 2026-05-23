<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ page isELIgnored="false" %>
			<%@ page import="com.DAO.BookDAOImpl" %>
				<%@ page import="com.DBMS.DBConnect" %>
					<%@ page import="com.entity.BookDtls" %>

						<!DOCTYPE html>
						<html>

						<head>
							<meta charset="UTF-8">
							<title>Admin Edit Books</title>
							<%@include file="allCss.jsp" %>
								<style>
									body,
									html {
										height: 100%;
										margin: 0;
									}

									.center-container {
										display: flex;
										justify-content: center;
										align-items: center;
										height: 100vh;
										background-color: #f5f5f5;
									}

									.card {
										padding: 8px;
										border-radius: 4px;
										box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
										max-width: 400px;
										width: 100%;
										background: #fff;
									}

									.card-body {
										padding: 8px;
									}

									.card h4 {
										margin-bottom: 12px;
										font-size: 18px;
										font-weight: bold;
										text-align: center;
									}

									.form-group {
										margin-bottom: 8px;
									}

									.form-group:last-of-type {
										margin-bottom: 2px;
									}

									.form-control,
									.form-control-file {
										height: 34px;
										font-size: 14px;
									}

									.btn {
										font-size: 14px;
										padding: 4px 8px;
									}

									.btn:hover {
										background-color: #343a40;
										color: white;
									}
								</style>
						</head>

						<body style="background-color: #f7f7f7;">


							<c:if test="${empty userobj}">
								<c:redirect url="../login.jsp" />
							</c:if>

							<%@ include file="admin-layout.jsp" %>

								<div class="container-fluid p-4">
									<div class="dashboard-card" style="max-width:600px;margin:auto;">

										<h5 class="mb-4">Edit Book</h5>

										<form action="${pageContext.request.contextPath}/admin/edit-book" method="post"
											enctype="multipart/form-data">

											<input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

											<input type="hidden" name="id" value="${book.bookId}">

											<div class="mb-3">
												<label>Book Name</label>
												<input type="text" name="bname" class="form-control"
													value="${book.bookName}" required>
											</div>

											<div class="mb-3">
												<label>Author</label>
												<input type="text" name="author" class="form-control"
													value="${book.author}" required>
											</div>

											<div class="mb-3">
												<label>Price</label>
												<input type="number" name="price" class="form-control"
													value="${book.price}" required>
											</div>

											<div class="mb-3">
												<label class="form-label">Genres</label>

												<div class="border rounded p-2"
													style="max-height:150px; overflow-y:auto;">

													<c:forEach var="g" items="${genreList}">
														<div class="form-check">

															<input class="form-check-input" type="checkbox"
																name="genreIds" value="${g.id}" ${selectedGenres !=null
																&& selectedGenres.contains(g.id) ? 'checked' : '' }>

															<label class="form-check-label">
																${g.name}
															</label>

														</div>
													</c:forEach>

												</div>
											</div>




											<div class="mb-3">
												<label>Current Image</label><br>
												<img src="${pageContext.request.contextPath}/uploads/book/${book.photoName}"
													style="width:80px;height:80px;">
											</div>

											<div class="mb-3">
												<label>Update Image (Optional)</label>
												<input type="file" name="bimg" class="form-control">
											</div>

											<div class="mb-3">
												<label>Status</label>
												<select name="status" class="form-select" required>
													<option value="Active" ${book.status=='Active' ? 'selected' : '' }>
														Active
													</option>
													<option value="Inactive" ${book.status=='Inactive' ? 'selected' : ''
														}>
														Inactive
													</option>
												</select>
											</div>

											<button class="btn btn-primary w-100">
												Update Book
											</button>

										</form>

									</div>
								</div>

						</body>

						</html>