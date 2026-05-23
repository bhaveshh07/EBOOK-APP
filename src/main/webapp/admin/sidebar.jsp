<div class="sidebar">
    <h4><i class="fa-solid fa-book-open-reader"></i> Admin</h4>

    <a href="${pageContext.request.contextPath}/admin/home"
        class="${pageContext.request.requestURI.endsWith('home.jsp') ? 'active' : ''}">
        <i class="fa-solid fa-chart-line"></i>  Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/admin_orders">
        <i class="fa-solid fa-cart-shopping"></i>  Orders
    </a>

    <a href="${pageContext.request.contextPath}/admin/books">
        <i class="fa-solid fa-book"></i>  Books
    </a>

    <a href="${pageContext.request.contextPath}/admin/add-book">
        <i class="fa-solid fa-plus"></i>  Add Book
    </a>

    <a href="${pageContext.request.contextPath}/admin/audit">
        <i class="fa-solid fa-clipboard-list"></i>  Audit Logs
    </a>

    <a href="${pageContext.request.contextPath}/admin/contact">
        <i class="fa-solid fa-envelope"></i> Contact Inbox
    </a>
    <a href="${pageContext.request.contextPath}/admin/genres">
        <i class="fa-solid fa-layer-group"></i>  Add / View Genres
    </a>
    <a href="${pageContext.request.contextPath}/admin_payouts">
        <i class="fa-solid fa-money-bill-transfer me-2"></i>
         Payout Requests
    </a>
    <a href="${pageContext.request.contextPath}/admin/users">
        <i class="fa-regular fa-user me-2"></i>
        Users
    </a>


<a href="${pageContext.request.contextPath}/admin/search-dashboard">
        <i class="fa-solid fa-magnifying-glass-chart"></i>
        Search Dashboard
    </a>
</div>