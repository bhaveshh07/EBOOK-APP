<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Audit Logs - Admin</title>
            <%@ include file="allCss.jsp" %>
        </head>

        <body>

            <c:if test="${empty userobj}">
                <c:redirect url="../login.jsp" />
            </c:if>

            <%@ include file="admin-layout.jsp" %>

                <div class="container-fluid p-4">

                    <div class="dashboard-card">
                        <h5 class="mb-4 fw-semibold">Audit Monitoring</h5>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle">

                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>User ID</th>
                                        <th>Role</th>
                                        <th>Action</th>
                                        <th>Entity</th>
                                        <th>Description</th>
                                        <th>IP</th>
                                        <th>Time</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach var="log" items="${logs}">
                                        <tr>
                                            <td>${log.id}</td>
                                            <td>${log.userId}</td>

                                            <td>
                                                <span class="badge 
                                    ${log.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'}">
                                                    ${log.role}
                                                </span>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${log.actionType == 'SUSPICIOUS_ACTIVITY'}">
                                                        <span class="badge bg-warning text-dark">
                                                            ${log.actionType}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${log.actionType}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>${log.entity}</td>
                                            <td>${log.description}</td>
                                            <td>${log.ipAddress}</td>
                                            <td>${log.createdAt}</td>
                                        </tr>
                                    </c:forEach>

                                </tbody>

                            </table>
                        </div>

                    </div>

                </div>

        </body>

        </html>