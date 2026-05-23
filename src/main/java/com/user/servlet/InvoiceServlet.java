package com.user.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;

import com.DAO.BookOrderImpl;
import com.DBMS.DBConnect;
import com.entity.Book_Order;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        BookOrderImpl dao = new BookOrderImpl(DBConnect.getConn());
        Book_Order o = dao.getOrderById(id);
        if (o == null) {
            resp.sendRedirect("my_orders");
            return;
        }

        if (o == null ||
                "CANCELLED".equalsIgnoreCase(o.getStatus()) ||
                "REFUNDED".equalsIgnoreCase(o.getStatus())) {

            resp.setContentType("text/html");
            resp.getWriter().println("<h3>Invoice not available for cancelled/refunded orders.</h3>");
            return;
        }

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition",
                "attachment; filename=Invoice_" + o.getOrderId() + ".pdf");

        Document document = new Document();
        PdfWriter.getInstance(document, resp.getOutputStream());
        document.open();

        Font textFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Font subFont = FontFactory.getFont(FontFactory.HELVETICA, 11);

        Paragraph app = new Paragraph("EBOOKS", headerFont);
        app.setAlignment(Element.ALIGN_CENTER);
        document.add(app);

        Paragraph tag = new Paragraph("Online Book Store", subFont);
        tag.setAlignment(Element.ALIGN_CENTER);
        document.add(tag);

        Paragraph addr = new Paragraph(
                "123, Knowledge Street, Indore, MP - 452001\n" +
                        "Email: support@ebooks.com | Phone: +91-90000-00000",
                subFont);
        addr.setAlignment(Element.ALIGN_CENTER);
        document.add(addr);

        document.add(new Paragraph("----------------------------------------------------"));

        document.add(new Paragraph(" "));
        document.add(new Paragraph("Order ID: " + o.getOrderId(), textFont));
        document.add(new Paragraph("Customer: " + o.getUserName(), textFont));
        document.add(new Paragraph("Email: " + o.getEmail(), textFont));
        document.add(new Paragraph(" "));

        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        PdfPCell c1 = new PdfPCell(new Phrase("Book"));
        PdfPCell c2 = new PdfPCell(new Phrase("Price"));
        PdfPCell c3 = new PdfPCell(new Phrase("Qty"));
        PdfPCell c4 = new PdfPCell(new Phrase("Total"));

        table.addCell(c1);
        table.addCell(c2);
        table.addCell(c3);
        table.addCell(c4);

        table.addCell(o.getBookName());
        table.addCell("Rs." + o.getPrice());
        table.addCell(String.valueOf(o.getQuantity()));
        table.addCell(String.valueOf(o.getPrice() * o.getQuantity()));

        document.add(table);
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Payment: "
                + o.getPaymentMethod()
                + " (" + o.getPaymentStatus() + ")"));
        document.add(new Paragraph("Status: " + o.getStatus()));
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
        document.add(new Paragraph("Date: " + sdf.format(o.getOrderDate())));

        document.add(new Paragraph("\nThank you for shopping with Ebook App!"));

        document.close();
    }
}
