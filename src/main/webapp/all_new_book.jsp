<%@page import="com.entity.User" %>
    <%@page import="com.entity.BookDtls" %>
        <%@page import="java.util.List" %>
            <%@page import="com.DBMS.DBConnect" %>
                <%@page import="com.DAO.BookDAOImpl" %>
                    <%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
                        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

                            <%@page isELIgnored="false" %>
                                <!DOCTYPE html>
                                <html>

                                <head>
                                    <meta charset="UTF-8">
                                    <title>All New Book</title>
                                    <%@include file="all_component/allCss.jsp" %>

                                        <!-- Custom Toast Styles -->
                                        <style type="text/css">
                                            #toast {
                                                min-width: 300px;
                                                position: fixed;
                                                bottom: 80px;
                                                /* Position it above the footer */
                                                left: 50%;
                                                transform: translateX(-50%);
                                                background-color: #333;
                                                padding: 10px;
                                                color: white;
                                                text-align: center;
                                                z-index: 1050;
                                                font-size: 18px;
                                                visibility: hidden;
                                                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
                                                border-radius: 5px;
                                            }

                                            #toast.show {
                                                visibility: visible;
                                                animation: fadeIn 0.5s, fadeOut 0.5s 3s;
                                                /* Increased time for fadeOut */
                                            }

                                            @keyframes fadeIn {
                                                from {
                                                    opacity: 0;
                                                }

                                                to {
                                                    opacity: 1;
                                                }
                                            }

                                            @keyframes fadeOut {
                                                from {
                                                    opacity: 1;
                                                }

                                                to {
                                                    opacity: 0;
                                                }
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
                                        </style>

                                </head>

                                <body style="background-color: #f7f7f7">
                                    <% User u=(User) session.getAttribute("userobj"); %>

                                        <!-- Toast Notification Element -->
                                        <div id="toast"></div>

                                        <!-- Include Navbar and Content -->
                                        <%@include file="all_component/navbar.jsp" %>

                                            <div id="content">
                                                <div class="container-fluid">
                                                    <div class="row p-3">
                                                        <% BookDAOImpl dao2=new BookDAOImpl(DBConnect.getConn());
                                                            List<BookDtls> list2 = dao2.AllNewBooks();
                                                            for (BookDtls b : list2) {
                                                            %>
                                                            <div class="col-md-3">
                                                                <div class="card mt-2">
                                                                    <div class="card-body text-center">
                                                                        <div class="details">
                                                                            <img src="<%=request.getContextPath()%>/uploads/book/<%=b.getPhotoName()%>"
                                                                                style="width: 200px; height: 275px;"
                                                                                class="img-thumblin" alt="error">

                                                                            <p class="para1"
                                                                                style="margin: 0; padding: 0;">
                                                                                <b class="mt-2">
                                                                                    <%=b.getBookName()%>
                                                                                </b><br>
                                                                                <%=b.getAuthor()%><br>Category:
                                                                                    <%=b.getBookCategory()%>
                                                                                        <br>Rs.<%=b.getPrice()%>/-
                                                                            </p>
                                                                            
                                                                                <div class="overlay">
                                                                                    <% if (u==null) { %>
                                                                                        <div class="icon">
                                                                                            <a
                                                                                                href="${pageContext.request.contextPath}/login.jsp"><i
                                                                                                    class="fa-solid fa-cart-shopping"></i></a>
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

                                                                                                <div class="icon">
                                                                                                    <a
                                                                                                        href="${pageContext.request.contextPath}/view_books.jsp?bid=<%=b.getBookId() %>"><i
                                                                                                            class="fa-solid fa-eye"></i></a>
                                                                                                </div>

                                                                                </div>
                                                                            
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <% } %>
                                                    </div>
                                                </div>
                                            </div>

                                            <%@include file="all_component/footer.jsp" %>

                                                <!-- Custom Toast JavaScript -->
                                                <script type="text/javascript">
                                                    function showToast(content) {
                                                        var toast = document.getElementById('toast');
                                                        toast.innerHTML = content;  // Set the message inside the toast
                                                        toast.classList.add('show'); // Make the toast visible

                                                        // Hide the toast after 3.5 seconds (including 0.5s fade-out)
                                                        setTimeout(function () {
                                                            toast.classList.remove('show'); // Remove the 'show' class
                                                        }, 3500); // 3.5 seconds
                                                    }
                                                </script>
                                                <script>
                                                    // Show the toast if the session has the message
                                                    const addCartMessage = "${sessionScope.addCart}";

                                                    if (addCartMessage && addCartMessage.trim().length > 0) {
                                                        showToast(addCartMessage.trim(), "success");
                                                    }
                                                </script>

                                                <c:remove var="addCart" scope="session" />
                                                </script>




                                </body>

                                </html>