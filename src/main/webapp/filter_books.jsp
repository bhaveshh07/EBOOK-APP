<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ page isELIgnored="false" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>Filtered Books</title>
                    <style>
                        .filter-card {
                            position: sticky;
                            top: 20px;
                        }


                        .book-card {
                            transition: 0.3s ease;
                        }

                        .book-card:hover {
                            transform: translateY(-6px);
                        }


                        .filter-card {
                            position: sticky;
                            top: 20px;
                            transition: 0.3s ease;
                        }

                        .filter-card:hover {
                            transform: translateY(-3px);
                            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
                        }

                        @media (max-width: 768px) {
                            .filter-card {
                                position: static;
                            }
                        }

                        .details {
                            position: relative;
                            display: inline-block;
                        }

                        .book-img {
                            width: 200px;
                            height: 301px;
                            object-fit: cover;
                            border-radius: 6px;
                        }


                        /* Overlay FIXED */
                        .overlay {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            background: rgba(255, 255, 255, .8);
                            opacity: 0;

                            pointer-events: none;
                        }

                        .details:hover .overlay {
                            opacity: 1;
                            pointer-events: auto;
                        }

                        /* Icon */
                        .overlay .icon {
                            font-size: 26px;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            margin: 0 8px;
                            cursor: pointer;
                            background: #fff;
                            border: 1px solid #ddd;
                            width: 55px;
                            height: 53px;
                            box-shadow: 0 3px 8px rgba(0, 0, 0, .2);

                        }

                        .overlay .icon a {
                            color: black;
                            text-decoration: none;
                        }

                        .overlay .icon:hover {
                            background: black;
                        }

                        .overlay .icon:hover a {
                            color: white;
                        }

                        .badge {
                            font-size: 11px;
                        }
                    </style>
                    <%@ include file="all_component/allCss.jsp" %>
                </head>

                <body style="background-color:#f7f7f7;">
                    <%@ include file="all_component/navbar.jsp" %>
                        <div id="content">
                            <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">
                            <input type="hidden" id="isLoggedIn" value="${not empty userobj}">
                            <input type="hidden" id="currentPageHidden" value="${currentPage}">
                            <input type="hidden" id="totalPagesHidden" value="${totalPages}">

                            <div class="container-fluid mt-4">
                                <div class="row">

                                    <!-- SIDEBAR -->
                                    <div class="col-md-3 mb-3">
                                        <div class="card shadow-sm p-3">

                                            <h5 class="mb-3">
                                                <i class="fa-solid fa-filter"></i> Filter
                                            </h5>

                                            <form id="filterForm" method="get"
                                                action="${pageContext.request.contextPath}/books/filter">

                                                <!-- SORT -->
                                                <div class="mb-3">
                                                    <label class="form-label">Sort By</label>
                                                    <select class="form-select" name="sort" id="sortSelect">
                                                        <option value="">Default</option>
                                                        <option value="price_asc" ${param.sort=="price_asc"
                                                            ?"selected":""}>
                                                            Price: Low to High</option>
                                                        <option value="price_desc" ${param.sort=="price_desc"
                                                            ?"selected":""}>Price: High to Low</option>
                                                        <option value="newest" ${param.sort=="newest" ?"selected":""}>
                                                            Newest
                                                            First</option>
                                                        <option value="rating_desc" ${param.sort=="rating_desc"
                                                            ?"selected":""}>Top Rated</option>
                                                        <option value="rating_asc" ${param.sort=="rating_asc"
                                                            ?"selected":""}>Lowest Rated</option>
                                                    </select>
                                                </div>

                                                <!-- PRICE -->
                                                <div class="mb-3">
                                                    <label class="form-label">Price Range</label>
                                                    <div class="d-flex gap-2">
                                                        <input type="number" name="minPrice" class="form-control"
                                                            placeholder="Min" value="${param.minPrice}">
                                                        <input type="number" name="maxPrice" class="form-control"
                                                            placeholder="Max" value="${param.maxPrice}">
                                                    </div>
                                                </div>

                                                <div class="text-center">
                                                    <button type="button" class="btn btn-dark w-75"
                                                        onclick="submitFilter(1)">Apply Filters</button>
                                                </div>

                                                <c:forEach var="g" items="${genreList}">
                                                    <div class="form-check mt-2">
                                                        <input class="form-check-input genreCheck" type="checkbox"
                                                            value="${g.id}"
                                                            ${selectedGenres.contains(g.id)?"checked":""}>
                                                        <label class="form-check-label">${g.name}</label>
                                                    </div>
                                                </c:forEach>

                                                <input type="hidden" name="genres" id="genresInput">

                                            </form>
                                        </div>
                                    </div>

                                    <!-- BOOK GRID -->
                                    <div class="col-md-9">

                                        <h6 class="mb-3">${totalBooks} results found</h6>

                                        <div class="row" id="bookGrid">

                                            <c:forEach var="b" items="${bookList}">
                                                <div class="col-md-4 mb-4">
                                                    <div class="card shadow-sm text-center">
                                                        <div class="card-body">
                                                            <div class="details">

                                                                <img src="${pageContext.request.contextPath}/uploads/book/${b.photoName}"
                                                                    class="book-img">

                                                                <div class="overlay">

                                                                    <c:if test="${empty userobj}">
                                                                        <div class="icon">
                                                                            <a
                                                                                href="${pageContext.request.contextPath}/login.jsp">
                                                                                <i
                                                                                    class="fa-solid fa-cart-shopping"></i>
                                                                            </a>
                                                                        </div>
                                                                    </c:if>

                                                                    <c:if test="${not empty userobj}">
                                                                        <div class="icon">
                                                                            <a href="javascript:void(0)"
                                                                                onclick="addToCart(${b.bookId})">
                                                                                <i
                                                                                    class="fa-solid fa-cart-shopping"></i>
                                                                            </a>
                                                                        </div>
                                                                    </c:if>

                                                                    <div class="icon">
                                                                        <a
                                                                            href="${pageContext.request.contextPath}/view_books.jsp?bid=${b.bookId}">
                                                                            <i class="fa-solid fa-eye"></i>
                                                                        </a>
                                                                    </div>

                                                                </div>

                                                            </div>


                                                            <h6 class="mt-3">${b.bookName}</h6>
                                                            <p>${b.author}</p>

                                                            <div>
                                                                <i class="fa-solid fa-star text-warning"></i>
                                                                ${fn:substring(b.avgRating,0,3)}
                                                                <small>(${b.totalReviews})</small>
                                                                <br>
                                                                <span class="badge bg-dark">
                                                                    <i class="fa-solid fa-trophy"></i>
                                                                    ${fn:substring(b.weightedRating,0,4)}
                                                                </span>
                                                            </div>

                                                            <p class="text-success fw-bold mt-2">₹ ${b.price}</p>

                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>

                                        </div>

                                        <!-- PAGINATION (FULL SERVLET VERSION) -->
                                        <c:if test="${totalPages > 1}">
                                            <nav>
                                                <ul class="pagination justify-content-center">

                                                    <li class="page-item ${currentPage==1?'disabled':''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/books/filter?page=${currentPage-1}&genres=${param.genres}&sort=${param.sort}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                                            Previous
                                                        </a>
                                                    </li>

                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${currentPage==i?'active':''}">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/books/filter?page=${i}&genres=${param.genres}&sort=${param.sort}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                                                ${i}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <li class="page-item ${currentPage==totalPages?'disabled':''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/books/filter?page=${currentPage+1}&genres=${param.genres}&sort=${param.sort}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">
                                                            Next
                                                        </a>
                                                    </li>

                                                </ul>
                                            </nav>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <%@ include file="all_component/footer.jsp" %>

                            <script>
                                const contextPath = document.getElementById("contextPath").value;

                                function submitFilter(page) {

                                    let selected = [];
                                    document.querySelectorAll(".genreCheck:checked")
                                        .forEach(el => selected.push(el.value));

                                    let sort = document.getElementById("sortSelect").value;
                                    let min = document.querySelector("input[name='minPrice']").value;
                                    let max = document.querySelector("input[name='maxPrice']").value;

                                    let genresString = selected.join(",");

                                    document.getElementById("genresInput").value = genresString;

                                    /*  IMPORTANT: Update URL so pagination works */
                                    let newUrl = contextPath + "/books/filter?page=" + page
                                        + "&genres=" + encodeURIComponent(genresString)
                                        + "&sort=" + encodeURIComponent(sort || "")
                                        + "&minPrice=" + encodeURIComponent(min || "")
                                        + "&maxPrice=" + encodeURIComponent(max || "");

                                    window.location.href = newUrl;
                                }
                            </script>

                </body>

                </html>