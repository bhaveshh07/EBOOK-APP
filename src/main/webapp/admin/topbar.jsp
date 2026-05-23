<div class="topbar">
    <div>
        <h5 class="mb-0">Admin Dashboard</h5>
    </div>

    <div class="admin-name">
        <c:if test="${not empty userobj}">
            <span><i class="fa-solid fa-user"></i> ${userobj.name}</span>
            <button class="btn btn-sm btn-outline-danger ms-3" data-bs-toggle="modal" data-bs-target="#logoutModal">
                Logout
            </button>

        </c:if>
    </div>
</div>