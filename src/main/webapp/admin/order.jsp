<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<%@ taglib prefix="c" uri="jakarta.tags.core" %>

		<%@page isELIgnored="false" %>

			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>Admin : Orders</title>

				<%@include file="allCss.jsp" %>

			</head>

			<body style="background-color:#f7f7f7;">
				<c:if test="${empty userobj}">
					<c:redirect url="../login.jsp"></c:redirect>
				</c:if>

				<%@ include file="admin-layout.jsp" %>


					<c:if test="${param.success eq 'true'}">
						<script>
							Swal.fire({
								icon: 'success',
								title: 'Order Updated!',
								timer: 1500,
								showConfirmButton: false
							});
						</script>
					</c:if>


					<div class="container-fluid px-4 mt-4">
						<div class="row">
							<div class="col-md-12">
								<div class="d-flex justify-content-between align-items-center mb-4">
									<h4 class="fw-semibold mb-0">Order Management</h4>

									<input type="text" id="searchInput" class="form-control w-25"
										placeholder="Search Orders...">
								</div>

								<div class="row mb-3">
									<div class="col-md-3">
										<input type="date" id="fromDate" class="form-control">
									</div>
									<div class="col-md-3">
										<input type="date" id="toDate" class="form-control">
									</div>
									<div class="col-md-2">
										<button class="btn btn-primary" onclick="filterRevenue()">Filter</button>
									</div>
								</div>

								<!-- Revenue Summary -->
								<div class="alert alert-light shadow-sm mb-4">
									<strong>Total Revenue:</strong>
									<span id="revenueValue"> ₹ ${totalRevenue} </span>
								</div>


								<div class="card p-3 mb-4">
									<h6>Revenue Trend</h6>
									<canvas id="ordersRevenueChart"></canvas>
								</div>

								<!-- Export Button -->
								<a href="${pageContext.request.contextPath}/admin/export-revenue"
									class="btn btn-outline-primary mb-3">
									Download Revenue Report
								</a>


								<select id="statusFilter" class="form-select w-25 mb-3">
									<option value="">All</option>
									<option value="PLACED">Placed</option>
									<option value="SHIPPED">Shipped</option>
									<option value="DELIVERED">Delivered</option>
									<option value="REFUNDED">Refunded</option>
								</select>

								<!-- Table Scroll -->
								<div class="table-responsive" style="max-height: 550px; overflow-y: auto;">


									<table class="table table-hover align-middle" id="ordersTable">


										<thead class="table-light">
											<tr>
												<th>ID</th>
												<th>Order ID</th>
												<th>User</th>
												<th>Book</th>
												<th>Price</th>
												<th>Qty</th>
												<th>Payment</th>
												<th>Details</th>
												<th>Status</th>
												<th>Change Status</th>
												<th>Return Action</th>
											</tr>
										</thead>

										<tbody>

											<c:forEach var="b" items="${orderList}">
												<tr class="${param.updatedId == b.id ? 'table-success' : ''}">
													<td>${b.id}</td>
													<td>${b.orderId}</td>
													<td>${b.userName}</td>
													<td>${b.bookName}</td>
													<td>${b.price}</td>
													<td>${b.quantity}</td>
													<td>
														<c:choose>
															<c:when test="${not empty b.paymentMethod}">
																${b.paymentMethod}
																<c:if test="${not empty b.paymentStatus}">
																	(${b.paymentStatus})
																</c:if>
															</c:when>
															<c:otherwise>
																<span class="badge bg-secondary">N/A</span>
															</c:otherwise>
														</c:choose>
													</td>


													<td>
														<button class="btn btn-sm btn-info shadow-sm"
															data-bs-toggle="modal" data-bs-target="#orderModal"
															data-id="${b.orderId}" data-user="${b.userName}"
															data-book="${b.bookName}" data-price="${b.price}"
															data-qty="${b.quantity}"
															data-payment="${b.paymentMethod} (${b.paymentStatus})">
															View
														</button>
													</td>



													<td>
														<c:choose>
															<c:when test="${b.status eq 'PLACED'}">
																<span class="badge badge-pending">Placed</span>
															</c:when>
															<c:when test="${b.status eq 'SHIPPED'}">
																<span class="badge badge-approved">Shipped</span>
															</c:when>
															<c:when test="${b.status eq 'DELIVERED'}">
																<span class="badge badge-approved">Delivered</span>
															</c:when>
															<c:when test="${b.status eq 'REFUNDED'}">
																<span class="badge badge-refunded">Refunded</span>
															</c:when>
															<c:otherwise>
																<span class="badge badge-rejected">${b.status}</span>
															</c:otherwise>
														</c:choose>

													</td>

													<td>

														<c:choose>


															<c:when test="${b.status eq 'REFUNDED'}">
																<span class="badge badge-refunded">Refunded</span>
															</c:when>


															<c:when test="${b.status eq 'CANCELLED'}">
																<span class="badge bg-secondary">Cancelled</span>
															</c:when>
															<c:when test="${b.status eq 'DELIVERED'}">
																<span class="badge bg-info">Delivered</span>
															</c:when>

															<c:when test="${b.returnStatus eq 'REQUESTED'
                or b.returnStatus eq 'APPROVED'
                or b.returnStatus eq 'REJECTED'}">
																<span class="badge badge-rejected">Locked</span>
															</c:when>


															<c:otherwise>

																<form
																	action="${pageContext.request.contextPath}/admin/update_order_status"
																	method="post"
																	class="d-flex align-items-center gap-2">

																	<input type="hidden" name="csrf_token"
																		value="${sessionScope.CSRF_TOKEN}">

																	<input type="hidden" name="id" value="${b.id}">

																	<select name="status"
																		class="form-select form-select-sm"
																		style="width:130px;">

																		<option ${b.status=='PLACED' ?'selected':''}>
																			PLACED</option>
																		<option ${b.status=='SHIPPED' ?'selected':''}>
																			SHIPPED</option>
																		<option ${b.status=='DELIVERED' ?'selected':''}>
																			DELIVERED</option>

																	</select>

																	<button
																		class="btn btn-sm btn-primary">Update</button>
																</form>

															</c:otherwise>

														</c:choose>

													</td>


													<td>

														<c:choose>


															<c:when test="${b.returnStatus eq 'REQUESTED'}">

																<form id="approveForm${b.id}"
																	style="display:inline-block;margin-right:6px;"
																	action="${pageContext.request.contextPath}/admin/approve_return"
																	method="post"
																	onsubmit="return confirmApprove('approveForm${b.id}')">
																	<input type="hidden" name="csrf_token"
																		value="${sessionScope.CSRF_TOKEN}">

																	<input type="hidden" name="id" value="${b.id}">

																	<button type="submit"
																		class="btn btn-success btn-sm shadow-sm">Approve
																	</button>

																</form>



																<form id="rejectForm${b.id}"
																	style="display:inline-block;"
																	action="${pageContext.request.contextPath}/admin/reject_return"
																	method="post"
																	onsubmit="return confirmReject('rejectForm${b.id}')">
																	<input type="hidden" name="csrf_token"
																		value="${sessionScope.CSRF_TOKEN}">


																	<input type="hidden" name="id" value="${b.id}">

																	<button type="submit"
																		class="btn btn-warning btn-sm shadow-sm">
																		Reject
																	</button>

																</form>


															</c:when>


															<c:when
																test="${b.returnStatus eq 'APPROVED' && b.status ne 'REFUNDED'}">


																<span class="badge bg-success">Return
																	Approved</span>

																<form id="refundForm${b.id}"
																	action="${pageContext.request.contextPath}/admin/refund_order"
																	method="post" style="display:inline;"
																	onsubmit="return confirmRefund('refundForm${b.id}')">

																	<input type="hidden" name="csrf_token"
																		value="${sessionScope.CSRF_TOKEN}">

																	<input type="hidden" name="id" value="${b.id}">
																	<input type="hidden" name="userId"
																		value="${b.userId}">
																	<input type="hidden" name="amount"
																		value="${b.price * b.quantity}">


																	<button type="submit"
																		class="btn btn-warning btn-sm">
																		Refund
																	</button>

																</form>

															</c:when>

															<c:when test="${b.status eq 'REFUNDED'}">
																<span class="badge bg-primary">Refunded</span>
															</c:when>


															<c:when test="${b.returnStatus eq 'REJECTED'}">
																<span class="badge bg-danger">Return Rejected</span>
															</c:when>


															<c:otherwise>
																<span class="badge bg-secondary">No Return</span>
															</c:otherwise>

														</c:choose>

													</td>

												</tr>
											</c:forEach>

										</tbody>

									</table>
									<div class="d-flex justify-content-between mt-3">
										<button class="btn btn-outline-secondary btn-sm"
											onclick="prevPage()">Prev</button>
										<span id="pageInfo"></span>
										<button class="btn btn-outline-secondary btn-sm"
											onclick="nextPage()">Next</button>
									</div>

								</div>

							</div>
						</div>
					</div>

					</div> <!-- close main-content -->
					</div> <!-- close wrapper -->
					<!-- Order Details Modal -->
					<div class="modal fade" id="orderModal">
						<div class="modal-dialog">
							<div class="modal-content p-4">
								<h5 class="mb-3">Order Details</h5>

								<p><strong>Order ID:</strong> <span id="modalOrderId"></span></p>
								<p><strong>User:</strong> <span id="modalUser"></span></p>
								<p><strong>Book:</strong> <span id="modalBook"></span></p>
								<p><strong>Price:</strong> ₹ <span id="modalPrice"></span></p>
								<p><strong>Quantity:</strong> <span id="modalQty"></span></p>
								<p><strong>Payment:</strong> <span id="modalPayment"></span></p>
							</div>
						</div>
					</div>

					<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


					<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


					<script>
						function confirmApprove(formId) {
							Swal.fire({
								title: "Approve Return?",
								icon: "question",
								showCancelButton: true,
								confirmButtonText: "Approve",
								cancelButtonText: "Cancel"
							}).then((result) => {
								if (result.isConfirmed) {
									document.getElementById(formId).submit();
								}
							});
							return false;
						}

						function confirmReject(formId) {
							Swal.fire({
								title: "Reject Return?",
								icon: "warning",
								showCancelButton: true,
								confirmButtonText: "Reject",
								cancelButtonText: "Cancel"
							}).then((result) => {
								if (result.isConfirmed) {
									document.getElementById(formId).submit();
								}
							});
							return false;
						}
						function confirmRefund(formId) {
							Swal.fire({
								title: "Process Refund?",
								icon: "warning",
								showCancelButton: true,
								confirmButtonText: "Refund"
							}).then((r) => {
								if (r.isConfirmed) {
									document.getElementById(formId).submit();
								}
							});
							return false;
						}
					</script>

					<script>
						document.querySelectorAll("#ordersTable th").forEach((header, index) => {
							header.addEventListener("click", () => {

								const rows = Array.from(document.querySelectorAll("#ordersTable tbody tr"));
								const asc = header.classList.toggle("asc");

								rows.sort((a, b) => {
									const cellA = a.children[index].innerText;
									const cellB = b.children[index].innerText;

									return asc
										? cellA.localeCompare(cellB, undefined, { numeric: true })
										: cellB.localeCompare(cellA, undefined, { numeric: true });
								});

								const tbody = document.querySelector("#ordersTable tbody");
								rows.forEach(row => tbody.appendChild(row));

								currentPage = 1;
								renderTable();
							});
						});


					</script>
					<script>
						function exportTableToCSV() {
							let csv = [];
							let rows = document.querySelectorAll("#ordersTable tbody tr");

							rows.forEach(row => {
								let cols = row.querySelectorAll("td");
								let rowData = [];

								cols.forEach((col, index) => {
									if (index !== 8 && index !== 9) { // skip form columns if needed
										rowData.push(col.innerText.trim());
									}
								});

								csv.push(rowData.join(","));
							});

							let csvFile = new Blob([csv.join("\n")], { type: "text/csv" });
							let downloadLink = document.createElement("a");
							downloadLink.download = "orders.csv";
							downloadLink.href = window.URL.createObjectURL(csvFile);
							downloadLink.click();
						}

					</script>
					<script>
						let currentPage = 1;
						const rowsPerPage = 5;

						function getFilteredRows() {

							const searchValue = document.getElementById("searchInput").value.toLowerCase();
							const statusValue = document.getElementById("statusFilter").value.toLowerCase();

							const allRows = Array.from(document.querySelectorAll("#ordersTable tbody tr"));

							return allRows.filter(row => {

								const matchesSearch = row.innerText.toLowerCase().includes(searchValue);

								//  Get ONLY status column text (column index 8)
								const statusCell = row.children[8].innerText.toLowerCase();

								const matchesStatus =
									statusValue === "" || statusCell.includes(statusValue);

								return matchesSearch && matchesStatus;
							});
						}


						function renderTable() {
							const filteredRows = getFilteredRows();
							const totalPages = Math.max(1, Math.ceil(filteredRows.length / rowsPerPage));

							if (currentPage > totalPages) currentPage = totalPages;

							document.querySelectorAll("#ordersTable tbody tr")
								.forEach(row => row.style.display = "none");

							filteredRows.forEach((row, index) => {
								if (
									index >= (currentPage - 1) * rowsPerPage &&
									index < currentPage * rowsPerPage
								) {
									row.style.display = "";
								}
							});

							document.getElementById("pageInfo").innerText =
								`Page ${currentPage} of ${totalPages}`;
						}

						function nextPage() {
							const totalPages = Math.max(1, Math.ceil(getFilteredRows().length / rowsPerPage));
							if (currentPage < totalPages) {
								currentPage++;
								renderTable();
							}
						}

						function prevPage() {
							if (currentPage > 1) {
								currentPage--;
								renderTable();
							}
						}

						document.getElementById("searchInput").addEventListener("keyup", () => {
							currentPage = 1;
							renderTable();
						});

						document.getElementById("statusFilter").addEventListener("change", () => {
							currentPage = 1;
							renderTable();
						});

						document.addEventListener("DOMContentLoaded", renderTable);


					</script>
					<script>
						function filterRevenue() {

							const from = document.getElementById("fromDate").value;
							const to = document.getElementById("toDate").value;

							console.log("FROM:", from);
							console.log("TO:", to);

							if (!from || !to) {
								alert("Please select both dates");
								return;
							}

							fetch("${pageContext.request.contextPath}/admin/revenue-by-date?from=" + from + "&to=" + to)
								.then(res => res.json())
								.then(data => {
									console.log("Revenue Response:", data);
									document.getElementById("revenueValue").innerText =
										" ₹ " + data.totalRevenue;
								})
								.catch(err => console.error("Revenue Fetch Error:", err));
						}

						fetch("${pageContext.request.contextPath}/admin/home-data")
							.then(res => res.json())
							.then(data => {
								if (data.revenueChartData && data.revenueChartData.length === 12) {
									new Chart(document.getElementById("ordersRevenueChart"), {
										type: "line",
										data: {
											labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
												"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
											datasets: [{
												label: "Revenue",
												data: data.revenueChartData,
												borderColor: "#4CAF50",
												tension: 0.3
											}]
										}
									});
								}
							});

					</script>
					<script>
						document.getElementById('orderModal')
							.addEventListener('show.bs.modal', function (event) {

								const btn = event.relatedTarget;

								document.getElementById('modalOrderId').innerText = btn.getAttribute('data-id');
								document.getElementById('modalUser').innerText = btn.getAttribute('data-user');
								document.getElementById('modalBook').innerText = btn.getAttribute('data-book');
								document.getElementById('modalPrice').innerText = btn.getAttribute('data-price');
								document.getElementById('modalQty').innerText = btn.getAttribute('data-qty');
								document.getElementById('modalPayment').innerText = btn.getAttribute('data-payment');
							});

					</script>


			</body>

			</html>