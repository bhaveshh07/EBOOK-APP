<%@page import="com.entity.BookDtls"%>
<%@page import="com.entity.User"%>
<%@page import="com.entity.BookDtls"%>
<%@page import="java.util.List"%>
<%@page import="com.DAO.BookDAOImpl"%>
<%@ page import="com.DBMS.DBConnect"%>
<%@ page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head> 
<meta charset="UTF-8">
<title>User:Old Books</title>
<%@include file="all_component/allCss.jsp"%>
</head>
<body>
	<%@include file="all_component/navbar.jsp"%>

	<c:if test="${not empty succMsg}">
		<div class="alert alert-success text-center">${succMsg}</div>
		<c:remove var="succMsg" scope="session"></c:remove>
	</c:if>

	<c:if test="${not empty failedMsg}">
		<div class="alert alert-danger text-center">${failedMsg}</div>
		<c:remove var="failedMsg" scope="session"></c:remove>
	</c:if>

	<div id="content">
		<div class="container p-5">
			<table
				class="table table-light table-striped table-hover table-bordered  border-dark mt-3">
				<thead class="table-dark">
					<tr>

						<th scope="col">Book Name</th>
						<th scope="col">Author</th>
						<th scope="col">Price</th>
						<th scope="col">Category</th>
						<th scope="col">Action</th>
					</tr>
				</thead>
				<tbody class="table-group-divider">
					<%
					User u = (User) session.getAttribute("userobj");
					String email = u.getEmail();

					BookDAOImpl dao = new BookDAOImpl(DBConnect.getConn());
					List<BookDtls> list = dao.getBookByOld(email, "Old");
					for (BookDtls b : list) {
					%>
					<tr>
						<td><%=b.getBookName()%></td>
						<td><%=b.getAuthor()%></td>
						<td><%=b.getPrice()%></td>
						<td><%=b.getBookCategory()%></td>
						<td><a
							href="delete_old_book?em=<%=email%>&&id=<%=b.getBookId()%>"
							class="btn btn-sm btn-outline-danger">Delete</a></td>
					</tr>
					<%
					}
					%>


				</tbody>
			</table>


		</div>
	</div>
	<%@include file="all_component/footer.jsp"%>
</body>
</html>