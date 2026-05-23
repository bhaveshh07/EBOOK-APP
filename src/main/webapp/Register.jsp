<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<%@page isELIgnored="false" %>
			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>Ebook: Register</title>
				<%@include file="all_component/allCss.jsp" %>
			</head>

			<body style="background-color: #f7f7f7;">
				<%@include file="all_component/navbar.jsp" %>
					<div id="content">
						<div class="container p-2">
							<div class="row">
								<div class="col-md-4 offset-md-4">
									<div class="card mt-2">
										<div class="card-body">
											<h4 class="text-center">Register Now</h4>

											<c:if test="${not empty succMsg }">
												<p class="text-center text-success">${succMsg}</p>
												<c:remove var="succMsg" scope="session" />
											</c:if>

											<c:if test="${not empty failedMsg}">
												<p class="text-center text-danger">${failedMsg}</p>
												<c:remove var="failedMsg" scope="session" />
											</c:if>

											<form action="Register" method="post">
												<input type="hidden" name="csrf_token"
													value="${sessionScope.CSRF_TOKEN}">

												<div class="mb-3">
													<label for="exampleInputName" class="form-label">Enter
														Name</label> <input type="text" class="form-control"
														id="exampleInputName1" aria-describedby="emailHelp"
														placeholder="enter name" required name="fname"
														required="required">
												</div>

												<div class="mb-3">
													<label for="exampleInputEmail1" class="form-label">Email
														Address</label> <input type="email" class="form-control"
														id="exampleInputEmail1" aria-describedby="emailHelp"
														placeholder="enter email" required name="email"
														required="required">
												</div>

												<div class="mb-3">
													<label for="exampleInputEmail1" class="form-label">Phone
														No.</label> <input type="text" class="form-control"
														pattern="[6789][0-9]{9}" id="exampleInputNumber1"
														aria-describedby="emailHelp" placeholder="enter phone no."
														required name="phno" required="required">
												</div>


												<div class="mb-3">
													<label for="exampleInputPassword1"
														class="form-label">Password</label>
													<input type="password" class="form-control"
														id="exampleInputPassword1" placeholder="enter password"
														required="required" name="password">
												</div>

												<div class="mb-3 form-check">
													<input type="checkbox" class="form-check-input" id="exampleCheck1"
														name="check"> <label class="form-check-label"
														for="exampleCheck1">Agree
														Terms and Conditions</label>
												</div>
												<div class="text-center" style="padding: 0px;">
													<button type="submit" class="btn btn-outline-dark">Register</button>
												</div>
											</form>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<%@include file="all_component/footer.jsp" %>
			</body>

			</html>