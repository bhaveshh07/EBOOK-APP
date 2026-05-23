<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>User Management</title>
                <%@include file="allCss.jsp" %>

                    <style>
                        body {
                            background: #f4f6f9;
                        }

                        .card-wrapper {
                            background: white;
                            border-radius: 18px;
                            padding: 30px;
                            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.05);
                        }

                        .table tbody tr {
                            transition: 0.2s ease;
                        }

                        .table tbody tr:hover {
                            background: #f9fbff;
                        }

                        .status-pill {
                            padding: 6px 14px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 600;
                        }

                        .active-pill {
                            background: #e6f7ee;
                            color: #1e7e34;
                        }

                        .frozen-pill {
                            background: #fff3cd;
                            color: #856404;
                        }

                        .terminated-pill {
                            background: #fde2e2;
                            color: #b02a37;
                        }

                        .role-pill {
                            padding: 5px 12px;
                            font-size: 11px;
                            border-radius: 14px;
                            font-weight: 600;
                        }

                        .role-admin {
                            background: #111827;
                            color: white;
                        }

                        .role-user {
                            background: #0d6efd;
                            color: white;
                        }

                        .action-btns button {
                            min-width: 90px;
                        }
                    </style>
            </head>

            <body>

                <%@ include file="admin-layout.jsp" %>

                    <div class="container-fluid p-4">

                        <div class="card-wrapper">

                            <h5 class="mb-4 fw-semibold">User & Seller Management</h5>

                            <table class="table align-middle">

                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>User</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Revenue</th>
                                        <th>Activity</th>
                                        <th>Created</th>
                                        <th>Last Login</th>
                                        <th width="220">Actions</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach var="u" items="${userList}">
                                        <tr>

                                            <td>${u.id}</td>

                                            <td>
                                                <div class="fw-semibold">${u.name}</div>
                                                <div class="text-muted small">${u.email}</div>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.role=='ADMIN'}">
                                                        <span class="role-pill role-admin">ADMIN</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="role-pill role-user">USER</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.accountStatus=='ACTIVE'}">
                                                        <span class="status-pill active-pill">ACTIVE</span>
                                                    </c:when>
                                                    <c:when test="${u.accountStatus=='FROZEN'}">
                                                        <span class="status-pill frozen-pill">FROZEN</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill terminated-pill">TERMINATED</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.role=='SELLER'}">
                                                        ₹ ${u.revenue}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>${u.activityCount}</td>

                                            <td>
                                                <fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy" />
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.lastLogin != null}">
                                                        <fmt:formatDate value="${u.lastLogin}"
                                                            pattern="dd MMM yyyy HH:mm" />
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="action-btns">

                                                <!-- Freeze / Activate -->
                                                <form class="d-inline"
                                                    action="${pageContext.request.contextPath}/admin/update-user-status"
                                                    method="post">
                                                    <input type="hidden" name="csrf_token"
                                                        value="${sessionScope.CSRF_TOKEN}">
                                                    <input type="hidden" name="id" value="${u.id}">
                                                    <input type="hidden" name="status"
                                                        value="${u.accountStatus=='ACTIVE'?'FROZEN':'ACTIVE'}">

                                                    <button class="btn btn-sm 
                                    ${u.accountStatus=='ACTIVE'?'btn-warning':'btn-success'}">
                                                        ${u.accountStatus=='ACTIVE'?'Freeze':'Activate'}
                                                    </button>
                                                </form>

                                                <!-- Terminate Button -->
                                                <button class="btn btn-sm btn-danger ms-2"
                                                    onclick="openTerminateModal(${u.id}, '${u.name}')">
                                                    Terminate
                                                </button>

                                            </td>

                                        </tr>
                                    </c:forEach>

                                </tbody>
                            </table>

                        </div>

                    </div>


                    <!-- 🔥 TERMINATE MODAL -->
                    <div class="modal fade" id="terminateModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">

                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title">Confirm Termination</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body">
                                    <p class="mb-2">⚠ This action is permanent.</p>
                                    <p id="terminateText" class="fw-bold text-danger"></p>
                                </div>

                                <div class="modal-footer">
                                    <button class="btn btn-secondary" data-bs-dismiss="modal">
                                        Cancel
                                    </button>

                                    <form id="terminateForm"
                                        action="${pageContext.request.contextPath}/admin/update-user-status"
                                        method="post">
                                        <input type="hidden" name="csrf_token" value="${sessionScope.CSRF_TOKEN}">
                                        <input type="hidden" name="id" id="terminateUserId">
                                        <input type="hidden" name="status" value="TERMINATED">

                                        <button class="btn btn-danger">
                                            Yes, Terminate
                                        </button>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <script>
                        function openTerminateModal(userId, userName) {
                            document.getElementById("terminateUserId").value = userId;
                            document.getElementById("terminateText").innerText =
                                "Terminate account of " + userName + "?";

                            new bootstrap.Modal(
                                document.getElementById('terminateModal')
                            ).show();
                        }
                    </script>

            </body>

            </html>