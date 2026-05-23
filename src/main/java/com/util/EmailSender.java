package com.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailSender {

    public static boolean sendEmail(String to, String subject, String otp) {

        final String from = "advacneproject@gmail.com";
        final String password = "iish cjdn ddvj hlbs";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });

        try {

            String body = "Hello User,<br><br>"
                    + "Your OTP is:<br><br>"
                    + "<h2 style='text-align:center;color:#2ecc71'>" + otp + "</h2>"
                    + "<br>This OTP is valid for 5 minutes.";

            String html = buildTemplate("OTP Verification", body);

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            msg.setSubject(subject);
            msg.setContent(html, "text/html");

            Transport.send(msg);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendOrderDeliveredEmail(String to,
            String userName,
            String orderId,
            String bookName) {

        final String from = "advacneproject@gmail.com";
        final String password = "iish cjdn ddvj hlbs";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });

        try {

            String body = "Hello <b>" + userName + "</b>,<br><br>"
                    + "Your order has been <b>DELIVERED successfully</b> !!<br><br>"
                    + "<b>Order ID:</b> " + orderId + "<br>"
                    + "<b>Book:</b> " + bookName + "<br><br>"
                    + "We hope you enjoy reading!";

            String html = buildTemplate("Order Delivered", body);

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            msg.setSubject("Your Order Has Been Delivered");
            msg.setContent(html, "text/html");

            Transport.send(msg);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------ ORDER PLACED ------------------
    public static boolean sendOrderPlacedEmail(String to, String name, String orderId) {
        return sendSimpleMail(to, "Order Placed Successfully",
                "Hello " + name +
                        "<br>Your order <b>" + orderId + "</b> has been placed successfully.");
    }

    // ------------------ SHIPPED ------------------
    public static boolean sendOrderShippedEmail(String to, String name, String orderId) {
        return sendSimpleMail(to, "Order Shipped",
                "Hello " + name +
                        "<br>Your order <b>" + orderId + "</b> has been shipped.");
    }

    // ------------------ CANCELLED ------------------
    public static boolean sendOrderCancelledEmail(String to, String name, String orderId) {
        return sendSimpleMail(to, "Order Cancelled",
                "Hello " + name +
                        "<br>Your order <b>" + orderId + "</b> has been cancelled.");
    }

    // ------------------ RETURN REQUESTED ------------------
    public static boolean sendReturnRequestedEmail(String to, String name, String orderId) {
        return sendSimpleMail(to, "Return Requested",
                "Hello " + name +
                        "<br>Return requested for Order <b>" + orderId + "</b>.");
    }

    // ------------------ RETURN APPROVED ------------------
    public static boolean sendReturnApprovedEmail(String to, String name, String orderId) {
        return sendSimpleMail(to, "Return Approved",
                "Hello " + name +
                        "<br>Your return request for Order <b>" + orderId + "</b> is approved.");
    }

    // ------------------ RETURN REJECTED ------------------
    public static boolean sendReturnRejectedEmail(String to, String name, String orderId) {
        return sendSimpleMail(to, "Return Rejected",
                "Hello " + name +
                        "<br>Your return request for Order <b>" + orderId + "</b> is rejected.");
    }

    // ------------------ REFUND SUCCESS ------------------
    public static boolean sendRefundEmail(String to, String name, String orderId, double amount) {
        return sendSimpleMail(to, "Refund Processed",
                "Hello " + name +
                        "<br>Refund of Rs." + amount +
                        " processed for Order <b>" + orderId + "</b>.");
    }

    // ================= COMMON HELPER =================
    public static boolean sendSimpleMail(String to, String subject, String body) {

        final String from = "advacneproject@gmail.com";
        final String password = "iish cjdn ddvj hlbs";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });

        try {

            String html = buildTemplate(subject, body);

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            msg.setSubject(subject);
            msg.setContent(html, "text/html");

            Transport.send(msg);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String buildTemplate(String title, String message) {

        return "<div style='font-family:Segoe UI,Arial;background:#f2f4f6;padding:30px'>"
                + "<div style='max-width:600px;margin:auto;background:white;"
                + "border-radius:12px;overflow:hidden;box-shadow:0 0 12px rgba(0,0,0,0.1)'>"

                // Header
                + "<div style='background:#6a1b9a;padding:18px;text-align:center'>"
                + "<h2 style='color:white;margin:0'>EBOOK HUB</h2>"
                + "</div>"

                // Body
                + "<div style='padding:25px'>"
                + "<h3 style='color:#333'>" + title + "</h3>"
                + "<p style='font-size:15px;color:#555'>" + message + "</p>"
                + "<br>"

                // Footer
                + "<p style='font-size:13px;color:gray'>"
                + "Need help? Contact support@ebookhub.com"
                + "</p>"

                + "</div>"

                // Footer Bar
                + "<div style='background:#eee;text-align:center;padding:10px;"
                + "font-size:12px;color:#777'>"
                + "@2026 Ebook Hub"
                + "</div>"

                + "</div></div>";
    }

    // ------------------ CONTACT MESSAGE ------------------
    public static boolean sendContactMessageEmail(
            String name,
            String userEmail,
            String messageText) {

        String body = "New Contact Message Received<br><br>" +
                "<b>Name:</b> " + name + "<br>" +
                "<b>Email:</b> " + userEmail + "<br><br>" +
                "<b>Message:</b><br>" +
                messageText;

        return sendSimpleMail(
                "advacneproject@gmail.com", // YOU receive message
                "New Contact Message",
                body);
    }

    // ---------------- AUTO REPLY ----------------
    public static boolean sendAutoReply(String to, String name) {

        String body = "Hello " + name + ",<br><br>" +
                "Thank you for contacting Ebook Hub.<br>" +
                "We have received your message and our team will get back to you shortly.<br><br>" +
                "Regards,<br>Ebook Hub Team";

        return sendSimpleMail(
                to,
                "We received your message",
                body);
    }

}
