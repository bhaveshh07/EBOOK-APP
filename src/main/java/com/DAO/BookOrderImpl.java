package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.Book_Order;
import com.entity.Cart;

public class BookOrderImpl implements BookOrderDAO {

	private Connection conn;

	public BookOrderImpl(Connection conn) {
		super();
		this.conn = conn;
	}

	@Override
	public List<Book_Order> getBook(String email) {
		List<Book_Order> list = new ArrayList<Book_Order>();
		Book_Order o = null;

		try {
			String sql = "select * from book_order where email=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				o = new Book_Order();
				o.setId(rs.getInt(1));
				o.setOrderId(rs.getString(2));
				o.setUserName(rs.getString(3));
				o.setEmail(rs.getString(4));
				o.setFullAdd(rs.getString(5));
				o.setPhno(rs.getString(6));
				o.setBookName(rs.getString(7));
				o.setAuthor(rs.getString(8));
				o.setPrice(rs.getDouble(9));
				o.setPaymentType(rs.getString(10));

				list.add(o);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List<Book_Order> getAllOrder() {

		List<Book_Order> list = new ArrayList<>();

		try {
			String sql = "SELECT * FROM book_order";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Book_Order o = new Book_Order();

				o.setId(rs.getInt("id"));
				o.setOrderId(rs.getString("order_id"));
				o.setUserId(rs.getInt("user_id"));
				o.setUserName(rs.getString("user_name"));
				o.setEmail(rs.getString("email"));
				o.setFullAdd(rs.getString("address"));
				o.setPhno(rs.getString("phone"));
				o.setBookName(rs.getString("book_name"));
				o.setAuthor(rs.getString("author"));
				o.setPrice(rs.getDouble("price"));
				o.setQuantity(rs.getInt("quantity"));
				o.setPaymentMethod(rs.getString("payment_method"));
				o.setPaymentStatus(rs.getString("payment_status"));
				o.setStatus(rs.getString("status"));

				list.add(o);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public boolean saveOrder(Book_Order o) {

		boolean success = false;

		try {
			String sql = "INSERT INTO book_order (" +
					"order_id, user_id, user_name, email, address, phone, " +
					"book_id, book_name, author, price, quantity, total_amount, " +
					"payment, status, payment_method, payment_status" +
					") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, o.getOrderId());
			ps.setInt(2, o.getUserId());
			ps.setString(3, o.getUserName());
			ps.setString(4, o.getEmail());
			ps.setString(5, o.getFullAdd());
			ps.setString(6, o.getPhno());
			ps.setInt(7, o.getBookId());
			ps.setString(8, o.getBookName());
			ps.setString(9, o.getAuthor());
			ps.setDouble(10, o.getPrice());
			ps.setInt(11, o.getQuantity());
			ps.setDouble(12, o.getTotalAmount());

			// legacy + new payment fields
			ps.setString(13, o.getPaymentType()); // payment
			ps.setString(14, o.getStatus()); // order status
			ps.setString(15, o.getPaymentMethod()); // COD / ONLINE
			ps.setString(16, o.getPaymentStatus()); // PENDING / INITIATED

			success = ps.executeUpdate() == 1;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return success;
	}

	// ===================== READ METHODS (UNCHANGED, SAFE) =====================

	@Override
	public List<Book_Order> getOrdersByUser(int userId) {
		List<Book_Order> list = new ArrayList<>();

		try {
			String sql = "SELECT * FROM book_order WHERE user_id=? ORDER BY order_date DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Book_Order o = new Book_Order();
				o.setId(rs.getInt("id"));
				o.setOrderId(rs.getString("order_id"));
				o.setUserId(rs.getInt("user_id"));
				o.setUserName(rs.getString("user_name"));
				o.setEmail(rs.getString("email"));
				o.setPhno(rs.getString("phone"));
				o.setFullAdd(rs.getString("address"));
				o.setBookName(rs.getString("book_name"));
				o.setAuthor(rs.getString("author"));
				o.setPrice(rs.getDouble("price"));
				o.setQuantity(rs.getInt("quantity"));
				o.setTotalAmount(rs.getDouble("total_amount"));
				o.setPaymentType(rs.getString("payment"));
				o.setPaymentMethod(rs.getString("payment_method"));
				o.setPaymentStatus(rs.getString("payment_status"));
				o.setStatus(rs.getString("status"));
				o.setOrderDate(rs.getTimestamp("order_date"));
				o.setReturnStatus(rs.getString("return_status"));
				list.add(o);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public boolean updateOrderStatus(int id, String status) {

		boolean success = false;

		try {

			conn.setAutoCommit(false);

			// Update order status
			String sql = "UPDATE book_order SET status=? WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ps.setInt(2, id);

			int updated = ps.executeUpdate();

			if (updated != 1) {
				conn.rollback();
				return false;
			}

			// If DELIVERED → Credit Seller
			if ("DELIVERED".equalsIgnoreCase(status)) {
				// Mark COD as PAID
				String paySql = "UPDATE book_order SET payment_status='PAID' WHERE id=? AND payment_method='COD'";
				PreparedStatement psPay = conn.prepareStatement(paySql);
				psPay.setInt(1, id);
				psPay.executeUpdate();
				// Get order code
				String orderSql = "SELECT order_id FROM book_order WHERE id=?";
				PreparedStatement psOrder = conn.prepareStatement(orderSql);
				psOrder.setInt(1, id);
				ResultSet rsOrder = psOrder.executeQuery();

				if (rsOrder.next()) {

					String orderCode = rsOrder.getString("order_id");

					// Get all items
					String itemSql = "SELECT book_id, quantity, price FROM order_items WHERE order_id=?";
					PreparedStatement psItems = conn.prepareStatement(itemSql);
					psItems.setString(1, orderCode);
					ResultSet rsItems = psItems.executeQuery();

					while (rsItems.next()) {

						int bookId = rsItems.getInt("book_id");
						int qty = rsItems.getInt("quantity");
						double price = rsItems.getDouble("price");

						// Get seller email
						String bookSql = "SELECT userEmail FROM book_dtls WHERE bookId=?";
						PreparedStatement psBook = conn.prepareStatement(bookSql);
						psBook.setInt(1, bookId);
						ResultSet rsBook = psBook.executeQuery();

						if (rsBook.next()) {

							String sellerEmail = rsBook.getString("userEmail");

							// Get seller ID
							String userSql = "SELECT id FROM user WHERE email=?";
							PreparedStatement psUser = conn.prepareStatement(userSql);
							psUser.setString(1, sellerEmail);
							ResultSet rsUser = psUser.executeQuery();

							if (rsUser.next()) {

								int sellerId = rsUser.getInt("id");
								double earning = price * qty;

								// Insert seller earning
								String walletSql = "INSERT INTO seller_wallet_transactions "
										+ "(seller_id, amount, type, description) "
										+ "VALUES (?, ?, 'CREDIT', ?)";

								PreparedStatement psWallet = conn.prepareStatement(walletSql);
								psWallet.setInt(1, sellerId);
								psWallet.setDouble(2, earning);
								psWallet.setString(3, "Earning from Order " + orderCode);
								psWallet.executeUpdate();
							}
						}
					}
				}

				if (rsOrder.next()) {

					String orderCode = rsOrder.getString("order_id");

					String itemSql = "SELECT book_id, quantity FROM order_items WHERE order_id=?";
					PreparedStatement psItems = conn.prepareStatement(itemSql);
					psItems.setString(1, orderCode);

					ResultSet rsItems = psItems.executeQuery();

					while (rsItems.next()) {

						int bookId = rsItems.getInt("book_id");
						int qty = rsItems.getInt("quantity");

						String popSql = "INSERT INTO book_popularity(book_id, purchases) VALUES(?, ?) " +
								"ON DUPLICATE KEY UPDATE purchases = purchases + ?";

						PreparedStatement psPop = conn.prepareStatement(popSql);
						psPop.setInt(1, bookId);
						psPop.setInt(2, qty);
						psPop.setInt(3, qty);

						psPop.executeUpdate();
					}
				}
			}

			conn.commit();
			success = true;

		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (Exception ex) {
			}
			e.printStackTrace();
		}

		return success;
	}

	@Override
	public List<Book_Order> getAllOrders() {

		List<Book_Order> list = new ArrayList<>();

		try {

			String sql = "select * from book_order order by order_date desc";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Book_Order o = new Book_Order();

				o.setId(rs.getInt("id"));
				o.setOrderId(rs.getString("order_id"));

				o.setUserId(rs.getInt("user_id"));

				o.setUserName(rs.getString("user_name"));
				o.setBookName(rs.getString("book_name"));
				o.setAuthor(rs.getString("author"));
				o.setPrice(rs.getDouble("price"));
				o.setQuantity(rs.getInt("quantity"));

				o.setTotalAmount(rs.getDouble("total_amount"));

				// ADD THESE TWO LINES
				o.setPaymentMethod(rs.getString("payment_method"));
				o.setPaymentStatus(rs.getString("payment_status"));
				o.setStatus(rs.getString("status"));
				o.setOrderDate(rs.getTimestamp("order_date"));
				o.setReturnStatus(rs.getString("return_status"));

				list.add(o);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public Book_Order getOrderById(int id) {

		Book_Order o = null;

		try {

			String sql = "SELECT * FROM book_order WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				o = new Book_Order();

				o.setId(rs.getInt("id"));
				o.setOrderId(rs.getString("order_id"));
				o.setUserName(rs.getString("user_name"));
				o.setEmail(rs.getString("email"));
				o.setBookName(rs.getString("book_name"));
				o.setPrice(rs.getDouble("price"));
				o.setQuantity(rs.getInt("quantity"));
				o.setPaymentMethod(rs.getString("payment_method"));
				o.setPaymentStatus(rs.getString("payment_status"));
				o.setStatus(rs.getString("status"));
				o.setOrderDate(rs.getTimestamp("order_date"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return o;
	}

	public boolean updateStatus(String orderId, String status) {

		boolean success = false;

		try {

			conn.setAutoCommit(false);

			// 1️⃣ Update order status
			String sql = "UPDATE book_order SET status=? WHERE order_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ps.setString(2, orderId);

			int updated = ps.executeUpdate();

			if (updated != 1) {
				conn.rollback();
				return false;
			}

			// 2️⃣ If DELIVERED → Credit Seller
			if ("DELIVERED".equalsIgnoreCase(status)) {

				String itemSql = "SELECT b.userEmail, oi.book_id, oi.quantity, oi.price " +
						"FROM order_items oi " +
						"JOIN book_dtls b ON oi.book_id = b.bookId " +
						"WHERE oi.order_id=?";

				PreparedStatement psItems = conn.prepareStatement(itemSql);
				psItems.setString(1, orderId);

				ResultSet rs = psItems.executeQuery();

				while (rs.next()) {

					String sellerEmail = rs.getString("userEmail");
					int qty = rs.getInt("quantity");
					double price = rs.getDouble("price");

					int sellerId = getUserIdByEmail(sellerEmail);

					double sellerAmount = price * qty;

					String walletSql = "INSERT INTO seller_wallet_transactions " +
							"(seller_id, amount, type, description) " +
							"VALUES (?, ?, 'CREDIT', ?)";

					PreparedStatement psWallet = conn.prepareStatement(walletSql);
					psWallet.setInt(1, sellerId);
					psWallet.setDouble(2, sellerAmount);
					psWallet.setString(3, "Sale Earnings - Order " + orderId);

					psWallet.executeUpdate();
				}
			}

			conn.commit();
			success = true;

		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (Exception ex) {
			}
			e.printStackTrace();
		}

		return success;
	}

	private int getUserIdByEmail(String email) throws Exception {

		String sql = "SELECT id FROM user WHERE email=?";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, email);

		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
			return rs.getInt("id");
		}

		return 0;
	}

	public boolean updateReturnStatus(String orderId, String status) {

		boolean f = false;

		try {
			String sql = "update book_order set return_status=? where order_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ps.setString(2, orderId);
			f = ps.executeUpdate() == 1;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public boolean updateReturnStatusById(int id, String status) {

		boolean f = false;

		try {
			String sql = "UPDATE book_order SET return_status=? WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ps.setInt(2, id);
			f = ps.executeUpdate() == 1;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public boolean processRefund(int orderId) {

		boolean f = false;

		try {
			String sql = "UPDATE book_order SET refund_amount=price*quantity, status='REFUNDED' WHERE id=?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderId);

			f = ps.executeUpdate() == 1;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return f;
	}

	public boolean cancelOrderAndRestoreStock(int orderId) {

		boolean success = false;

		try {

			// Lock order row
			String fetchSql = "SELECT order_id, user_id, total_amount, payment_status, status " +
					"FROM book_order WHERE id=? FOR UPDATE";

			PreparedStatement ps1 = conn.prepareStatement(fetchSql);
			ps1.setInt(1, orderId);

			ResultSet rs = ps1.executeQuery();

			if (!rs.next()) {
				return false;
			}

			String orderCode = rs.getString("order_id");
			int userId = rs.getInt("user_id");
			double amount = rs.getDouble("total_amount");
			String paymentStatus = rs.getString("payment_status");
			String status = rs.getString("status");

			// Prevent double cancel
			if ("CANCELLED".equals(status)) {
				return false;
			}

			// ================= RESTORE STOCK =================
			String itemsSql = "SELECT book_id, quantity FROM order_items WHERE order_id=?";
			PreparedStatement psItems = conn.prepareStatement(itemsSql);
			psItems.setString(1, orderCode);

			ResultSet rsItems = psItems.executeQuery();

			while (rsItems.next()) {

				int itemBookId = rsItems.getInt("book_id");
				int itemQty = rsItems.getInt("quantity");

				String restoreSql = "UPDATE book_dtls SET stock = stock + ? WHERE bookId=?";
				PreparedStatement psRestore = conn.prepareStatement(restoreSql);
				psRestore.setInt(1, itemQty);
				psRestore.setInt(2, itemBookId);
				psRestore.executeUpdate();
			}

			// ================= REFUND IF PAID =================
			if ("PAID".equals(paymentStatus)) {

				String walletTxnSql = "INSERT INTO wallet_transactions (user_id, amount, type, description) " +
						"VALUES (?, ?, 'CREDIT', ?)";

				PreparedStatement psWalletTxn = conn.prepareStatement(walletTxnSql);
				psWalletTxn.setInt(1, userId);
				psWalletTxn.setDouble(2, amount);
				psWalletTxn.setString(3, "Refund for Order ID: " + orderCode);
				psWalletTxn.executeUpdate();

				String refundSql = "UPDATE book_order SET refund_amount=? WHERE id=?";
				PreparedStatement psRefund = conn.prepareStatement(refundSql);
				psRefund.setDouble(1, amount);
				psRefund.setInt(2, orderId);
				psRefund.executeUpdate();
			}

			// ================= MARK CANCELLED =================
			String statusSql = "UPDATE book_order SET status='CANCELLED' WHERE id=?";
			PreparedStatement ps3 = conn.prepareStatement(statusSql);
			ps3.setInt(1, orderId);
			ps3.executeUpdate();

			success = true;

		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e); // let servlet handle rollback
		}

		return success;
	}

	public Book_Order getOrderByOrderId(String orderId) {

		Book_Order o = null;

		try {
			String sql = "SELECT * FROM book_order WHERE order_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, orderId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				o = new Book_Order();

				o.setId(rs.getInt("id"));
				o.setOrderId(rs.getString("order_id"));
				o.setUserId(rs.getInt("user_id"));
				o.setUserName(rs.getString("user_name"));
				o.setEmail(rs.getString("email"));
				o.setPhno(rs.getString("phone"));
				o.setFullAdd(rs.getString("address"));

				o.setBookName(rs.getString("book_name"));
				o.setAuthor(rs.getString("author"));
				o.setPrice(rs.getDouble("price"));
				o.setQuantity(rs.getInt("quantity"));
				o.setTotalAmount(rs.getDouble("total_amount"));

				o.setPaymentMethod(rs.getString("payment_method"));
				o.setPaymentStatus(rs.getString("payment_status"));
				o.setStatus(rs.getString("status"));
				o.setOrderDate(rs.getTimestamp("order_date"));
				o.setReturnStatus(rs.getString("return_status"));

				o.setRazorpayOrderId(rs.getString("razorpay_order_id"));
				o.setRazorpayPaymentId(rs.getString("razorpay_payment_id"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return o;
	}

	public boolean updateRazorpayOrderId(int id, String rpOrderId) {
		try {
			String sql = "UPDATE book_order SET razorpay_order_id=? WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, rpOrderId);
			ps.setInt(2, id);
			return ps.executeUpdate() == 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updatePaymentSuccess(int id, String paymentId) {
		try {
			String sql = "UPDATE book_order SET payment_status='PAID', razorpay_payment_id=? WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, paymentId);
			ps.setInt(2, id);
			return ps.executeUpdate() == 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updatePaymentFailure(int id) {
		try {
			String sql = "UPDATE book_order SET payment_status='FAILED' WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			return ps.executeUpdate() == 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean placeSingleOrderWithStock(Book_Order order, List<Cart> cartList) {

		boolean success = false;

		try {

			// ================= 1. LOCK + CHECK STOCK =================
			for (Cart c : cartList) {

				String stockSql = "SELECT stock FROM book_dtls WHERE bookId=?";

				PreparedStatement ps = conn.prepareStatement(stockSql);
				ps.setInt(1, c.getBid());

				ResultSet rs = ps.executeQuery();

				if (!rs.next() || rs.getInt("stock") < c.getQuantity()) {

					return false; // any item out of stock
				}
			}

			// ================= 2. INSERT SINGLE ORDER =================
			String orderSql = "INSERT INTO book_order (" +
					"order_id, user_id, user_name, email, address, phone, " +
					"book_id, book_name, author, price, quantity, total_amount, " +
					"payment, status, payment_method, payment_status" +
					") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			PreparedStatement psOrder = conn.prepareStatement(orderSql);

			psOrder.setString(1, order.getOrderId());
			psOrder.setInt(2, order.getUserId());
			psOrder.setString(3, order.getUserName());
			psOrder.setString(4, order.getEmail());
			psOrder.setString(5, order.getFullAdd());
			psOrder.setString(6, order.getPhno());

			psOrder.setInt(7, 0); // book_id not applicable (multiple)
			psOrder.setString(8, "Multiple Items");
			psOrder.setString(9, "-");

			psOrder.setDouble(10, order.getTotalAmount());
			psOrder.setInt(11, order.getQuantity());
			psOrder.setDouble(12, order.getTotalAmount());

			psOrder.setString(13, order.getPaymentType());
			psOrder.setString(14, order.getStatus());
			psOrder.setString(15, order.getPaymentMethod());
			psOrder.setString(16, order.getPaymentStatus());

			psOrder.executeUpdate();
			// ================= UPDATE POPULARITY =================
			String popSql = "INSERT INTO book_popularity(book_id, purchases) VALUES(?, ?) " +
					"ON DUPLICATE KEY UPDATE purchases = purchases + ?";

			PreparedStatement psPop = conn.prepareStatement(popSql);

			for (Cart c : cartList) {
				psPop.setInt(1, c.getBid());
				psPop.setInt(2, c.getQuantity());
				psPop.setInt(3, c.getQuantity());
				psPop.addBatch();
			}

			psPop.executeBatch();
			// ================= 3. REDUCE STOCK =================
			for (Cart c : cartList) {

				String reduceSql = "UPDATE book_dtls SET stock = stock - ? WHERE bookId=?";

				PreparedStatement psReduce = conn.prepareStatement(reduceSql);
				psReduce.setInt(1, c.getQuantity());
				psReduce.setInt(2, c.getBid());
				psReduce.executeUpdate();
			}

			success = true;

		} catch (Exception e) {
			try {

			} catch (Exception ex) {
			}
			e.printStackTrace();
		}

		return success;
	}

	public boolean markPaymentPaid(int id, String paymentId, String signature) {
		try {

			conn.setAutoCommit(false);

			// Mark order paid
			String sql = "UPDATE book_order " +
					"SET payment_status='PAID', " +
					"    status='PLACED', " +
					"    razorpay_payment_id=?, " +
					"    razorpay_signature=? " +
					"WHERE id=?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, paymentId);
			ps.setString(2, signature);
			ps.setInt(3, id);

			int updated = ps.executeUpdate();

			if (updated != 1) {
				conn.rollback();
				return false;
			}

			// Get order_id
			String getOrderSql = "SELECT order_id FROM book_order WHERE id=?";
			PreparedStatement psOrder = conn.prepareStatement(getOrderSql);
			psOrder.setInt(1, id);

			ResultSet rsOrder = psOrder.executeQuery();

			if (rsOrder.next()) {

				String orderCode = rsOrder.getString("order_id");

				// Get all items
				String itemSql = "SELECT book_id, quantity FROM order_items WHERE order_id=?";
				PreparedStatement psItems = conn.prepareStatement(itemSql);
				psItems.setString(1, orderCode);

				ResultSet rsItems = psItems.executeQuery();

				while (rsItems.next()) {

					int bookId = rsItems.getInt("book_id");
					int qty = rsItems.getInt("quantity");

					// Update purchases
					String popSql = "INSERT INTO book_popularity(book_id, purchases) VALUES(?, ?) " +
							"ON DUPLICATE KEY UPDATE purchases = purchases + ?";

					PreparedStatement psPop = conn.prepareStatement(popSql);
					psPop.setInt(1, bookId);
					psPop.setInt(2, qty);
					psPop.setInt(3, qty);

					psPop.executeUpdate();
				}
			}

			conn.commit();
			return true;

		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (Exception ex) {
			}
			e.printStackTrace();
		}

		return false;
	}

	public boolean resetPaymentToInitiated(int id) {
		try {
			String sql = "UPDATE book_order SET payment_status='INITIATED', razorpay_payment_id=NULL WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			return ps.executeUpdate() == 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean insertOrderItems(String orderId, List<Cart> cartList) {

		try {
			String sql = "INSERT INTO order_items " +
					"(order_id, book_id, book_name, author, price, quantity, total) " +
					"VALUES (?,?,?,?,?,?,?)";

			PreparedStatement ps = conn.prepareStatement(sql);

			for (Cart c : cartList) {
				ps.setString(1, orderId);
				ps.setInt(2, c.getBid());
				ps.setString(3, c.getBookName());
				ps.setString(4, c.getAuthor());
				ps.setDouble(5, c.getPrice());
				ps.setInt(6, c.getQuantity());
				ps.setDouble(7, c.getTotalPrice());
				ps.addBatch();
			}

			ps.executeBatch();
			return true;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	public List<Cart> getOrderItems(String orderId) {

		List<Cart> list = new ArrayList<>();

		try {

			String sql = "SELECT book_id, book_name, author, price, quantity, total " +
					"FROM order_items WHERE order_id=?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, orderId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Cart c = new Cart();

				c.setBid(rs.getInt("book_id"));
				c.setBookName(rs.getString("book_name"));
				c.setAuthor(rs.getString("author"));
				c.setPrice(rs.getDouble("price"));
				c.setQuantity(rs.getInt("quantity"));
				c.setTotalPrice(rs.getDouble("total"));

				list.add(c);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public int countOrders() {
		int count = 0;

		try {
			String sql = "SELECT COUNT(*) FROM book_order";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	public int countByStatus(String status) {
		int count = 0;
		try {
			String sql = "SELECT COUNT(*) FROM book_order WHERE status=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}

	public double getTotalPaidRevenue() {
		double total = 0;
		try {
			String sql = "SELECT IFNULL(SUM(total_amount),0) FROM book_order WHERE payment_status='PAID'";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				total = rs.getDouble(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	@Override
	public int getTotalOrdersByUser(int userId) {

		int count = 0;

		try {
			String sql = "SELECT COUNT(*) FROM book_order WHERE user_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

	@Override
	public int getActiveOrdersByUser(int userId) {

		int count = 0;

		try {
			String sql = "SELECT COUNT(*) FROM book_order WHERE user_id=? AND status NOT IN ('DELIVERED','CANCELLED','REFUNDED')";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				count = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return count;
	}

}
