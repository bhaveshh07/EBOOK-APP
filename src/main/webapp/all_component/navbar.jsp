<%@ page isELIgnored="false" %>

	<c:if test="${not empty sessionScope.CSRF_TOKEN}">
		<meta name="csrf-token" content="${sessionScope.CSRF_TOKEN}">
	</c:if>

	<script>
		const CSRF_TOKEN =
			document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
	</script>

	<c:if test="${not empty sessionScope.userobj}">
		<input type="hidden" id="userIdHidden" value="${sessionScope.userobj.id}">
	</c:if>

	<div class="container-fluid p-3">
		<div class="row align-items-center g-2">

			<!-- Logo -->
			<div class="col-12 col-md-3 text-center text-md-start">
				<h3 class="mb-0">
					<i class="fa-solid fa-book-open-reader"></i> Ebooks
				</h3>
			</div>

			<!-- Search -->
			<div class="col-12 col-md-6">
				<form class="d-flex position-relative" action="${pageContext.request.contextPath}/search.jsp"
					method="get">

					<input class="form-control me-2" type="search" placeholder="Search" id="searchInput" name="ch"
						autocomplete="off">

					<div id="suggestionsBox" class="list-group position-absolute w-100" style="top:100%; z-index:1000;">
					</div>

					<button class="btn btn-outline-dark flex-shrink-0" type="submit">
						<i class="fa-solid fa-magnifying-glass"></i>
					</button>
				</form>
			</div>

			<!-- Right Buttons -->
			<div class="col-12 col-md-3">
				<div class="d-flex justify-content-center justify-content-md-end align-items-center gap-2 flex-nowrap">

					<c:choose>

						<c:when test="${not empty sessionScope.userobj}">

							<!-- Cart -->
							<a href="${pageContext.request.contextPath}/checkout.jsp"
								class="btn btn-outline-dark position-relative flex-shrink-0">

								<i class="fa-solid fa-cart-shopping"></i>

								<span id="cartCount"
									class="badge bg-danger position-absolute top-0 start-100 translate-middle">
									0
								</span>
							</a>

							<!-- Dashboard -->
							<a href="${pageContext.request.contextPath}/dashboard"
								class="btn btn-outline-dark text-truncate" style="max-width:150px;">
								<i class="fa-solid fa-user"></i>
								${sessionScope.userobj.name}
							</a>

							<!-- Logout -->
							<a href="${pageContext.request.contextPath}/logout"
								class="btn btn-outline-dark flex-shrink-0">
								<i class="fa-solid fa-right-to-bracket"></i>
								Logout
							</a>

						</c:when>

						<c:otherwise>

							<a href="${pageContext.request.contextPath}/Register.jsp"
								class="btn btn-outline-dark flex-shrink-0">
								<i class="fa-solid fa-right-to-bracket"></i>
								Register
							</a>

							<a href="${pageContext.request.contextPath}/login.jsp"
								class="btn btn-outline-dark flex-shrink-0">
								<i class="fa-solid fa-user"></i>
								Login
							</a>

						</c:otherwise>

					</c:choose>

				</div>
			</div>

		</div>
	</div>
	<nav class="navbar navbar-expand-lg bg-custom">
		<div class="container-fluid">
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
				data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item active"><a class="nav-link"
							href="${pageContext.request.contextPath}/index.jsp"><i class="fa-solid fa-house"></i>
							Home</a></li>
					<li class="nav-item active"><a class="nav-link"
							href="${pageContext.request.contextPath}/books/filter"><i class="fa-solid fa-book-open"></i>
							Categories</a></li>
					<li class="nav-item active"><a class="nav-link"
							href="${pageContext.request.contextPath}/all_new_book.jsp"><i
								class="fa-solid fa-book-open"></i>
							New Book</a></li>
					<li class="nav-item active"><a class="nav-link"
							href="${pageContext.request.contextPath}/all_old_book.jsp"><i
								class="fa-solid fa-book-open"></i>
							Old Book</a></li>
				</ul>
				<form class="d-flex" role="search">
					<a href="${pageContext.request.contextPath}/dashboard" class="btn" type="submit"> <i
							class="fa-solid fa-gear"></i>
					</a>

					<a href="${pageContext.request.contextPath}/contact.jsp" class="btn" type="submit">
						<i class="fa-solid fa-phone"></i>
					</a>
				</form>
			</div>
		</div>
	</nav>
	<script>
		const CONTEXT_PATH = "${pageContext.request.contextPath}";
	</script>
	<script>
		let timer;

		document.getElementById("searchInput").addEventListener("keyup", function () {

			clearTimeout(timer);
			let value = this.value;

			if (value.length < 2) {
				document.getElementById("suggestionsBox").innerHTML = "";
				return;
			}

			timer = setTimeout(() => {

				fetch("search-suggest?term=" + value)
					.then(res => res.json())
					.then(data => {

						let box = document.getElementById("suggestionsBox");
						box.innerHTML = "";

						data.forEach(item => {
							box.innerHTML +=
								`<a href="search.jsp?ch=${item}" 
                       class="list-group-item list-group-item-action">
                       ${item}
                     </a>`;
						});

					});

			}, 300); // debounce 300ms
		});
	</script>
	<script src="${pageContext.request.contextPath}/all_component/cart.js"></script>