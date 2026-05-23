<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>

		<%@page isELIgnored="false" %>
			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>Sell Book</title>
				<%@include file="all_component/allCss.jsp" %>
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

			<body style="background-color: #f7f7f7">
				<c:if test="${empty userobj}">
					<c:redirect url="login.jsp"></c:redirect>
				</c:if>
				<%@include file="all_component/navbar.jsp" %>
					<div id="content">

						<div class="container">
							<div class="row p-4">
								<div class="col-md-4 offset-md-4">
									<div class="card">
										<div class="card-body">
											<h3 class="text-center">Sell Old Reads</h3>

											<!-- Image size error (hidden by default) -->
											<div id="imageError" class="alert alert-danger mt-3 text-center"
												style="display:none;">
											</div>

											<c:if test="${not empty succMsg }">
												<p class="text-center text-success">${succMsg }</p>
												<c:remove var="succMsg" scope="session" />
											</c:if>

											<c:if test="${not empty failedMsg }">
												<p class="text-center text-danger">${failedMsg }</p>
												<c:remove var="failedMsg" scope="session" />
											</c:if>

											<form action="add_old_book" method="post" enctype="multipart/form-data">
												<input type="hidden" name="csrf_token"
													value="${sessionScope.CSRF_TOKEN}">

												<div class="form-group">
													<label for="bookName">Book Name*</label> <input name="bname"
														type="text" class="form-control" id="bookName"
														placeholder="Enter book name" required="required">
												</div>

												<div class="form-group">
													<label for="authorName">Author Name*</label> <input name="author"
														type="text" class="form-control" id="authorName"
														placeholder="Enter author name" required="required">
												</div>

												<div class="form-group">
													<label for="price">Price*</label> <input name="price" type="text"
														class="form-control" id="price" placeholder="Enter price"
														required="required">
												</div>

												<div class="form-group">
													<label>Stock*</label>
													<input type="number" name="stock" class="form-control"
														placeholder="Enter stock quantity" min="1" required>
												</div>


												<div class="form-group">
													<label for="bookDescription">Book Description</label>
													<textarea id="bookDescription" name="description"
														class="form-control" rows="4" required="required"></textarea>
												</div>

												<!-- Genres -->
												<div class="form-group">
													<label>Genres</label>

													<div class="border p-2 rounded"
														style="max-height:120px; overflow:auto; font-size:13px;">

														<c:forEach var="g" items="${genreList}">
															<div class="form-check">
																<input class="form-check-input" type="checkbox"
																	name="genreIds" value="${g.id}">
																<label class="form-check-label">
																	${g.name}
																</label>
															</div>
														</c:forEach>

													</div>
												</div>


												<div class="form-group">
													<label for="uploadPhoto" class="d-block">Upload Photo</label> <input
														name="bimg" type="file" class="form-control-file"
														id="uploadPhoto" required="required" accept="image/*"
														onchange="validateImageSize(this)">
												</div>

												<div class="text-center">
													<button type="submit" class="btn btn-outline-dark"
														style="height:28px; width:80px;">Sell Now</button>
												</div>

											</form>

										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<%@include file="all_component/footer.jsp" %>
						<script>
							function validateImageSize(input) {
								const errorDiv = document.getElementById("imageError");
								errorDiv.style.display = "none"; // reset

								const file = input.files[0];

								if (file && file.size > 5 * 1024 * 1024) {
									errorDiv.innerText = "Image must be less than 5MB";
									errorDiv.style.display = "block";

									input.value = ""; // reset file input
									return false;
								}
								return true;
							}
						</script>


			</body>

			</html>