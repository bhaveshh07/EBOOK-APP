<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ page isELIgnored="false" %>

        <c:if test="${empty userobj}">
            <c:redirect url="../login.jsp" />
        </c:if>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admin-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <div class="admin-wrapper">

            <jsp:include page="sidebar.jsp" />

            <div class="main-content">
                <jsp:include page="topbar.jsp" />
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <!-- Logout Modal -->
                <div class="modal fade" id="logoutModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">

                            <div class="modal-header">
                                <h5 class="modal-title">Confirm Logout</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body text-center">
                                <p>Are you sure you want to logout?</p>
                            </div>

                            <div class="modal-footer justify-content-center">
                                <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
                            </div>

                        </div>
                    </div>
                </div>