<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ page import="java.sql.Connection" %>
		<%@ taglib prefix="c" uri="jakarta.tags.core" %>
			<%@page isELIgnored="false" %>
				<!DOCTYPE html>
				<html>

				<head>
					<meta charset="UTF-8">
					<title>Admin: All Books</title>
					<%@ include file="allCss.jsp" %>
						<style>
							.fa-pen {
								font-size: 20px;
							}

							.fa-trash-can {
								font-size: 20px;
							}
						</style>
				</head>

				<body style="background-color: #f7f7f7;">
					<%@ include file="admin-layout.jsp" %>


						<c:if test="${empty userobj}">
							<c:redirect url="../login.jsp"></c:redirect>
						</c:if>

						<h3 class="text-center">Hello, Admin</h3>

						<c:if test="${not empty succMsg }">
							<h5 class="text-center text-success">${succMsg }</h5>
							<c:remove var="succMsg" scope="session" />
						</c:if>

						<c:if test="${not empty failedMsg }">
							<h5 class="text-center text-danger">${failedMsg }</h5>
							<c:remove var="failedMsg" scope="session" />
						</c:if>





						<table class="table table-hover align-middle" id="booksTable">
							<thead class="table-light">
								<tr>
									<th scope="col">ID</th>
									<th scope="col">Image</th>
									<th scope="col">Book Name</th>
									<th scope="col">Author</th>
									<th scope="col">Price</th>
									<th scope="col">Category</th>
									<th scope="col">Status</th>
									<th scope="col">Action</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="b" items="${bookList}">
									<tr>
										<td>${b.bookId}</td>
										<td>
											<img src="${pageContext.request.contextPath}/uploads/book/${b.photoName}"
												style="width:50px;height:50px;">
										</td>
										<td>${b.bookName}</td>
										<td>${b.author}</td>
										<td>${b.price}</td>
										<td>${b.bookCategory}</td>
										<td>${b.status}</td>
										<td>
											<a href="${pageContext.request.contextPath}/admin/edit-book?id=${b.bookId}"
												class="btn btn-sm btn-outline-primary">
												<i class="fa-solid fa-pen"></i>
											</a>


											<a href="${pageContext.request.contextPath}/admin/delete-book?id=${b.bookId}"
												class="btn btn-sm btn-outline-danger">
												<i class="fa-solid fa-trash-can"></i>
											</a>
										</td>
									</tr>
								</c:forEach>
							</tbody>

						</table>


				</body>

				</html>