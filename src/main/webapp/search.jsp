<%@page import="com.entity.User" %>
	<%@page import="com.entity.BookDtls" %>
		<%@page import="java.util.List" %>
			<%@page import="java.sql.Connection" %>
				<%@page import="com.DBMS.DBConnect" %>
					<%@page import="com.DAO.BookDAOImpl" %>
						<%@ page contentType="text/html; charset=UTF-8" %>
							<%@ taglib prefix="c" uri="jakarta.tags.core" %>
								<!DOCTYPE html>
								<html>

								<head>
									<title>Search Results</title>
									<%@include file="all_component/allCss.jsp" %>

										<style>
											.details {
												position: relative;
											}

											.overlay {
												position: absolute;
												top: 0;
												left: 0;
												width: 100%;
												height: 100%;
												background: rgba(255, 255, 255, .85);
												display: flex;
												justify-content: center;
												align-items: center;
												gap: 10px;
												opacity: 0;
												transition: .3s;
											}

											.details:hover .overlay {
												opacity: 1;
											}

											.overlay .icon {
												width: 50px;
												height: 50px;
												background: white;
												display: flex;
												justify-content: center;
												align-items: center;
												border: 1px solid #ddd;
												font-size: 20px;
												cursor: pointer;
												transition: .3s;
											}

											.overlay .icon:hover {
												background: black;
											}

											.overlay .icon:hover i {
												color: white;
											}

											.filter-box {
												background: white;
												padding: 20px;
												border-radius: 12px;
												box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
											}

											.search-card {
												border: none;
												border-radius: 15px;
												box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
												transition: .3s;
											}

											.search-card:hover {
												transform: translateY(-5px);
												box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
											}

											.highlight {
												background: yellow;
											}

											.overlay .icon a {
												color: black;
												text-decoration: none;
											}
										</style>
								</head>

								<body style="background:#f7f7f7">
									<%@include file="all_component/navbar.jsp" %>

										<% User u=(User)session.getAttribute("userobj"); String
											ch=request.getParameter("ch"); if(ch==null) ch="" ; if(ch.trim().isEmpty()){
											response.sendRedirect("index.jsp"); return; } String
											sort=request.getParameter("sort"); if(sort==null) sort="relevance" ; String
											category=request.getParameter("category"); if(category==null) category="" ;
											double minPrice=0, maxPrice=999999; if(request.getParameter("min")!=null)
											minPrice=Double.parseDouble(request.getParameter("min"));
											if(request.getParameter("max")!=null)
											maxPrice=Double.parseDouble(request.getParameter("max")); int pageNo=1; int
											limit=6; if(request.getParameter("page")!=null)
											pageNo=Integer.parseInt(request.getParameter("page")); int
											start=(pageNo-1)*limit; Connection conn=null; List<BookDtls> list=null;
											int totalResults=0;

											try{
											conn=DBConnect.getConn();
											BookDAOImpl dao=new BookDAOImpl(conn);
											Integer userId = null;
											if(u != null) userId = u.getId();

											list = dao.getBookBySearch(
											ch,
											sort,
											category,
											minPrice,
											maxPrice,
											start,
											limit,
											userId);
											totalResults=dao.getSearchCount(ch,category,minPrice,maxPrice);
											}catch(Exception e){ e.printStackTrace(); }
											finally{ if(conn!=null) try{conn.close();}catch(Exception e){} }

											int totalPages=(int)Math.ceil(totalResults/(double)limit);
											%>
											<div id="content">
												<div class="container mt-4">
													<div class="row">

														<!-- 🔎 FILTER SIDEBAR -->
														<div class="col-md-3">
															<div class="filter-box">
																<h5>Filters</h5>

																<form method="get">

																	<input type="hidden" name="ch" value="<%=ch%>">

																	<label>Category</label>
																	<select name="category" class="form-control">
																		<option value="">All</option>
																		<option
																			<%=category.equals("New")?"selected":""%>
																			>New
																		</option>
																		<option
																			<%=category.equals("Old")?"selected":""%>
																			>Old
																		</option>
																	</select>

																	<label class="mt-2">Min Price</label>
																	<input type="number" name="min"
																		class="form-control">

																	<label class="mt-2">Max Price</label>
																	<input type="number" name="max"
																		class="form-control">

																	<button
																		class="btn btn-dark mt-3 w-100">Apply</button>
																</form>
															</div>
														</div>

														<!--  RESULTS SECTION -->
														<div class="col-md-9">

															<div
																class="d-flex justify-content-between align-items-center mb-3">
																<h5>

																	<%=totalResults%> results for "<%=ch%>"
																</h5>

																<form method="get">
																	<input type="hidden" name="ch" value="<%=ch%>">
																	<input type="hidden" name="category"
																		value="<%=category%>">
																	<input type="hidden" name="min"
																		value="<%=minPrice%>">
																	<input type="hidden" name="max"
																		value="<%=maxPrice%>">

																	<select name="sort" onchange="this.form.submit()">
																		<option value="relevance"
																			<%=sort.equals("relevance")?"selected":""%>
																			>Relevance</option>
																		<option value="price_low"
																			<%=sort.equals("price_low")?"selected":""%>
																			>Price:
																			Low</option>
																		<option value="price_high"
																			<%=sort.equals("price_high")?"selected":""%>
																			>Price:
																			High</option>
																		<option value="rating"
																			<%=sort.equals("rating")?"selected":""%>
																			>Rating
																		</option>
																	</select>
																</form>
															</div>

															<div class="row">
																<% if(list==null || list.isEmpty()){ %>

																	<div class="col-12 text-center">
																		<h4>No books found 😕</h4>
																	</div>

																	<% } else { for(BookDtls b:list){ String
																		title=b.getBookName().replaceAll("(?i)"+ch, "<span class='highlight'>"
																		+ch+"</span>");
																		%>

																		<div class="col-md-4 mb-4">
																			<div class="card search-card">
																				<div class="card-body text-center">

																					<div
																						class="details position-relative">

																						<img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
																							style="height:230px;object-fit:contain;width:100%;">

																						<!-- OVERLAY -->
																						<div class="overlay">

																							<% if(u==null){ %>
																								<div class="icon">
																									<a href="login.jsp">
																										<i
																											class="fa-solid fa-cart-shopping"></i>
																									</a>
																								</div>
																								<% } else { %>
																									<div class="icon">
																										<a href="javascript:void(0)"
																											onclick="addToCart(<%=b.getBookId()%>)">
																											<i
																												class="fa-solid fa-cart-shopping"></i>
																										</a>
																									</div>
																									<% } %>

																										<div
																											class="icon">
																											<a
																												href="${pageContext.request.contextPath}/view_books.jsp?bid=<%=b.getBookId()%>">
																												<i
																													class="fa-solid fa-eye"></i>
																											</a>
																										</div>

																						</div>

																					</div>

																					<h6 class="mt-3">
																						<%=title%>
																					</h6>

																					<p class="text-muted small mb-1">
																						<%=b.getAuthor()%>
																					</p>

																					<p class="fw-bold">
																						₹ <%=b.getPrice()%>
																					</p>

																				</div>
																			</div>
																		</div>

																		<% } } %>
															</div>

															<!--  PAGINATION -->
															<% if(totalPages>1){ %>
																<div class="text-center mt-3">
																	<% for(int i=1;i<=totalPages;i++){ %>
																		<a href="?ch=<%=ch%>
&sort=<%=sort%>
&category=<%=category%>
&min=<%=minPrice%>
&max=<%=maxPrice%>
&page=<%=i%>" class="btn btn-sm <%=i==pageNo?" btn-primary":"btn-outline-primary"%>">
																			<%=i%>
																		</a>
																		<% } %>
																</div>
																<% } %>

														</div>
													</div>
												</div>
											</div>
											<%@include file="all_component/footer.jsp" %>
								</body>

								</html>