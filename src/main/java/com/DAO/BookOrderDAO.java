package com.DAO;

import java.util.List;

import com.entity.Book_Order;

public interface BookOrderDAO {

	public List<Book_Order> getBook(String email);

	public List<Book_Order> getAllOrder();

	public boolean saveOrder(Book_Order order);

	public List<Book_Order> getOrdersByUser(int userId);

	public boolean updateOrderStatus(int id, String status);

	public List<Book_Order> getAllOrders();

	public int getTotalOrdersByUser(int userId);

	public int getActiveOrdersByUser(int userId);

}
