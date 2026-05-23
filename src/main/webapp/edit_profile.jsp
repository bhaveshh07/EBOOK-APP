<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@page isELIgnored="false" %>
			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>Edit User Profile</title>
				<%@include file="all_component/allCss.jsp" %>
			</head>

			<body style="background-color: #f7f7f7">
				<%@include file="all_component/navbar.jsp" %>
					<div id="content">
						<div class="container p-2">
							<div class="row p-4">
								<div class="col-md-4 offset-md-4">
									<div class="card">
										<div class="card-body">
											<h3 class="text-center">Edit Personal Details</h3>

											<c:if test="${not empty succMsg}">
												<p class="text-center text-success">${succMsg}</p>
												<c:remove var="succMsg" scope="session"></c:remove>
											</c:if>
											<c:if test="${not empty failedMsg}">
												<p class="text-center text-danger">${failedMsg}</p>
												<c:remove var="failedMsg" scope="session"></c:remove>
											</c:if>
											<form action="update_profile" method="post">
												<input type="hidden" name="csrf_token"
													value="${sessionScope.CSRF_TOKEN}">
												<input type="hidden" value="${userobj.id}" name="id">

												<!-- NAME -->
												<div class="mb-3">
													<label for="name" class="form-label">Enter Name</label>
													<input type="text" class="form-control" id="name" name="fname"
														placeholder="Enter name" required value="${userobj.name}">
												</div>

												<!-- EMAIL -->
												<div class="mb-3">
													<label for="email" class="form-label">Email Address</label>
													<input type="email" class="form-control" id="email" name="email"
														placeholder="Enter email" required value="${userobj.email}">
												</div>

												<!-- PHONE -->
												<div class="mb-3">
													<label for="phone" class="form-label">Phone No.</label>
													<input type="text" class="form-control" id="phone" name="phno"
														placeholder="Enter phone no." required value="${userobj.phno}">
												</div>

												<!-- PASSWORD -->
												<div class="mb-3">
													<label for="password" class="form-label">Password</label>

													<div class="input-group">
														<input type="password" id="passwordField" name="password"
															class="form-control" placeholder="Enter Password" required>
														<button type="button" class="btn btn-outline-secondary"
															onclick="togglePassword()">
															👁
														</button>
													</div>

												</div>

												<div class="text-center">
													<button type="submit" class="btn btn-outline-dark">Update</button>
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					</div>
					<%@include file="all_component/footer.jsp" %>
						<script>
							function togglePassword() {
								const p = document.getElementById("passwordField");
								p.type = (p.type === "password") ? "text" : "password";
							}
						</script>


			</body>

			</html>