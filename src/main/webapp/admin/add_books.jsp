<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@ page isELIgnored="false" %>

			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>Admin Add Books</title>
				<%@include file="allCss.jsp" %>

					<style>
						body {
							background-color: #f7f7f7;
						}

						.dashboard-card {
							background: #fff;
							padding: 25px;
							border-radius: 12px;
							box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
						}
					</style>
			</head>

			<body>

				<c:if test="${empty userobj}">
					<c:redirect url="../login.jsp" />
				</c:if>

				<%@ include file="admin-layout.jsp" %>

					<div class="container-fluid p-4">
						<div class="dashboard-card" style="max-width:650px;margin:auto;">
							<h4 class="mb-4 text-center">Add New Book</h4>

							<form action="${pageContext.request.contextPath}/admin/add-book" method="post"
								enctype="multipart/form-data">

								<input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">

								<!-- Book Name -->
								<div class="mb-3">
									<label class="form-label">Book Name</label>
									<input type="text" name="bname" class="form-control" required>
								</div>

								<!-- Author -->
								<div class="mb-3">
									<label class="form-label">Author</label>
									<input type="text" name="author" class="form-control" required>
								</div>

								<!-- Price -->
								<div class="mb-3">
									<label class="form-label">Price</label>
									<input type="number" name="price" class="form-control" step="0.01" min="0" required>
								</div>

								<!-- Stock -->
								<div class="mb-3">
									<label class="form-label">Stock</label>
									<input type="number" name="stock" class="form-control" min="0" required>
								</div>

								<!-- Category -->
								<div class="mb-3">
									<label class="form-label">Category</label>
									<select name="category" class="form-select" required>
										<option value="New">New</option>
										<option value="Old">Old</option>
									</select>
								</div>

								<!-- Status -->
								<div class="mb-3">
									<label class="form-label">Status</label>
									<select name="status" class="form-select" required>
										<option value="Active">Active</option>
										<option value="Inactive">Inactive</option>
									</select>
								</div>

								<!-- Description -->
								<div class="mb-3">
									<label class="form-label">Description</label>
									<textarea name="description" class="form-control" rows="3"></textarea>
								</div>
								<!-- Genres -->
								<div class="mb-3">
									<label class="form-label">Genres</label>
									<div class="border p-2 rounded" style="max-height:150px; overflow:auto;">

										<c:forEach var="g" items="${genreList}">
											<div class="form-check">
												<input class="form-check-input" type="checkbox" name="genreIds"
													value="${g.id}">
												<label class="form-check-label">
													${g.name}
												</label>
											</div>
										</c:forEach>

									</div>
								</div>

								<!-- Image -->
								<div class="mb-4">
									<label class="form-label">Upload Image</label>
									<input type="file" name="bimg" accept="image/*" class="form-control" required>
								</div>

								<button class="btn btn-primary w-100">
									Add Book
								</button>

							</form>
						</div>
					</div>

			</body>

			</html>