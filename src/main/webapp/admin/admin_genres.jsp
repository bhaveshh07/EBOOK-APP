<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ page import="java.util.List" %>
        <%@ page import="com.entity.Genre" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Admin - Manage Genres</title>
                <%@include file="allCss.jsp" %>
                    <style>
                        .table thead th {
                            color: #000 !important;
                        }
                    </style>
            </head>

            <body class="bg-light">
                <%@ include file="admin-layout.jsp" %>
                    <div class="container mt-4">

                        <!-- ================= SUCCESS MESSAGE ================= -->
                        <% String succMsg=(String) session.getAttribute("succMsg"); if (succMsg !=null) { %>
                            <div class="alert alert-success alert-dismissible fade show">
                                <%= succMsg %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <% session.removeAttribute("succMsg"); } %>

                                <!-- ================= ERROR MESSAGE ================= -->
                                <% String errorMsg=(String) session.getAttribute("errorMsg"); if (errorMsg !=null) { %>
                                    <div class="alert alert-danger alert-dismissible fade show">
                                        <%= errorMsg %>
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <% session.removeAttribute("errorMsg"); } %>

                                        <!-- ================= ADD GENRE CARD ================= -->
                                        <div class="card shadow p-4 mb-4">
                                            <h4 class="mb-3">Add Genre</h4>

                                            <form action="add-genre" method="post">
                                                <% String csrfToken=(String) session.getAttribute("CSRF_TOKEN"); %>

                                                    <input type="hidden" name="csrf_token"
                                                        value='<%= session.getAttribute("CSRF_TOKEN") %>'>


                                                    <input type="text" name="name" placeholder="Genre Name"
                                                        class="form-control mb-2" required>

                                                    <textarea name="description" class="form-control mb-2"
                                                        placeholder="Description"></textarea>

                                                    <button class="btn btn-primary">Add Genre</button>
                                            </form>

                                        </div>

                                        <!-- ================= GENRE TABLE ================= -->
                                        <div class="card shadow p-4">
                                            <h4 class="mb-3">All Genres</h4>

                                            <table class="table table-hover align-middle">
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th>Name</th>
                                                        <th>Slug</th>
                                                        <th>Books</th>
                                                        <th>Featured</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>

                                                <tbody>
                                                    <% List<Genre> list = (List<Genre>)
                                                            request.getAttribute("genreList");

                                                            if (list != null && !list.isEmpty()) {
                                                            for (Genre g : list) {
                                                            %>
                                                            <tr>
                                                                <td>
                                                                    <%= g.getName() %>
                                                                </td>

                                                                <td>
                                                                    <%= g.getSlug() %>
                                                                </td>

                                                                <td>
                                                                    <span class="badge bg-info">
                                                                        <%= g.getTotalBooks() %>
                                                                    </span>
                                                                </td>

                                                                <td>
                                                                    <% if (g.isFeatured()) { %>
                                                                        <span class="badge bg-success">Yes</span>
                                                                        <% } else { %>
                                                                            <span class="badge bg-secondary">No</span>
                                                                            <% } %>
                                                                </td>

                                                                <td>
                                                                    <% if (g.isActive()) { %>
                                                                        <span class="badge bg-primary">Active</span>
                                                                        <% } else { %>
                                                                            <span
                                                                                class="badge bg-danger">Inactive</span>
                                                                            <% } %>
                                                                </td>

                                                                <td>
                                                                    <a href="toggle-genre?id=<%= g.getId() %>"
                                                                        class="btn btn-sm btn-warning">
                                                                        Toggle
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                            <% } } else { %>
                                                                <tr>
                                                                    <td colspan="6" class="text-center text-muted">
                                                                        No genres found.
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                </tbody>
                                            </table>
                                        </div>

                    </div>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

            </body>

            </html>