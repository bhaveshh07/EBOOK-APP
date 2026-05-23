<%@ page import="java.util.List" %>
    <%@ page import="java.util.ArrayList" %>
        <%@ page import="com.entity.BookDtls" %>
            <%@ page contentType="text/html; charset=UTF-8" %>

                <!DOCTYPE html>
                <html>

                <head>
                    <title>Admin Search Analytics</title>
                    <%@ include file="/admin/allCss.jsp" %>
                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                        <style>
                            .card-box {
                                background: white;
                                padding: 20px;
                                border-radius: 12px;
                                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                                height: 100%;
                            }

                            .card-box ul {
                                padding-left: 18px;
                            }

                            .card-box li {
                                margin-bottom: 6px;
                            }
                        </style>
                </head>

                <body style="background:#f7f7f7">

                    <%@ include file="/admin/admin-layout.jsp" %>

                        <% List<String[]> topSearches =
                            (List<String[]>) request.getAttribute("topSearches");
                                if (topSearches == null) {
                                topSearches = new ArrayList<>();
                                    }

                                    List<BookDtls> mostViewed =
                                        (List<BookDtls>) request.getAttribute("mostViewed");
                                            if (mostViewed == null) {
                                            mostViewed = new ArrayList<>();
                                                }

                                                List<BookDtls> mostPurchased =
                                                    (List<BookDtls>) request.getAttribute("mostPurchased");
                                                        if (mostPurchased == null) {
                                                        mostPurchased = new ArrayList<>();
                                                            }
                                                            %>

                                                            <div class="container mt-4">

                                                                <h3 class="mb-4">🔎 Search Intelligence Dashboard</h3>

                                                                <div class="row">

                                                                    <!-- Top Searches -->
                                                                    <div class="col-md-4 mb-4">
                                                                        <div class="card-box">
                                                                            <h5>🔥 Top Searched Keywords</h5>

                                                                            <ul>
                                                                                <% if (topSearches.isEmpty()) { %>
                                                                                    <li>No data available</li>
                                                                                    <% } else { for (String[] row :
                                                                                        topSearches) { %>
                                                                                        <li>
                                                                                            <b>
                                                                                                <%= row[0] %>
                                                                                            </b> — <%= row[1] %>
                                                                                                searches
                                                                                        </li>
                                                                                        <% } } %>
                                                                            </ul>

                                                                            <canvas id="topSearchChart"></canvas>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Most Viewed -->
                                                                    <div class="col-md-4 mb-4">
                                                                        <div class="card-box">
                                                                            <h5>👁 Most Viewed Books</h5>

                                                                            <ul>
                                                                                <% if (mostViewed.isEmpty()) { %>
                                                                                    <li>No data available</li>
                                                                                    <% } else { for (BookDtls b :
                                                                                        mostViewed) { %>
                                                                                        <li>
                                                                                            <%= b.getBookName() %> —
                                                                                                <%= b.getViews() %>
                                                                                                    views
                                                                                        </li>
                                                                                        <% } } %>
                                                                            </ul>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Most Purchased -->
                                                                    <div class="col-md-4 mb-4">
                                                                        <div class="card-box">
                                                                            <h5>💰 Most Purchased Books</h5>

                                                                            <ul>
                                                                                <% if (mostPurchased.isEmpty()) { %>
                                                                                    <li>No data available</li>
                                                                                    <% } else { for (BookDtls b :
                                                                                        mostPurchased) { %>
                                                                                        <li>
                                                                                            <%= b.getBookName() %> —
                                                                                                <%= b.getPurchases() %>
                                                                                                    purchases
                                                                                        </li>
                                                                                        <% } } %>
                                                                            </ul>
                                                                        </div>
                                                                    </div>

                                                                </div>
                                                            </div>

                                                          <%
    // Build safe JSON for Chart
    StringBuilder labelsJson = new StringBuilder("[");
    StringBuilder valuesJson = new StringBuilder("[");

    for (int i = 0; i < topSearches.size(); i++) {

        String keyword = topSearches.get(i)[0];
        int count = 0;

        try {
            count = Integer.parseInt(topSearches.get(i)[1]);
        } catch (Exception e) {
            count = 0;
        }

        keyword = keyword.replace("\"", "\\\"");

        labelsJson.append("\"").append(keyword).append("\"");
        valuesJson.append(count);

        if (i < topSearches.size() - 1) {
            labelsJson.append(",");
            valuesJson.append(",");
        }
    }

    labelsJson.append("]");
    valuesJson.append("]");
%>
                                                                <script>
                                                                    const labels = <%= labelsJson.toString() %>;
                                                                    const dataValues = <%= valuesJson.toString() %>;

                                                                    const ctx = document.getElementById('topSearchChart');

                                                                    if (labels && labels.length > 0 && ctx) {
                                                                        new Chart(ctx, {
                                                                            type: 'bar',
                                                                            data: {
                                                                                labels: labels,
                                                                                datasets: [{
                                                                                    label: 'Search Count',
                                                                                    data: dataValues,
                                                                                    borderWidth: 1
                                                                                }]
                                                                            },
                                                                            options: {
                                                                                responsive: true,
                                                                                plugins: {
                                                                                    legend: { display: false }
                                                                                }
                                                                            }
                                                                        });
                                                                    }
                                                                </script>

                </body>

                </html>