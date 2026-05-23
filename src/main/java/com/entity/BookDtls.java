// TEST123

package com.entity;

import java.util.List;

public class BookDtls {

    private int bookId;
    private String bookName;
    private String author;
    private String price;
    private String bookCategory;
    private String status;
    private String photoName;
    private String email;
    private String description;
    private int stock;
    private List<String> genres;
    private double avgRating;
    private int totalReviews;
    private double weightedRating;
    private int views;
    private int purchases;

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public int getPurchases() {
        return purchases;
    }

    public void setPurchases(int purchases) {
        this.purchases = purchases;
    }

    public double getWeightedRating() {
        return weightedRating;
    }

    public void setWeightedRating(double weightedRating) {
        this.weightedRating = weightedRating;
    }

    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public List<String> getGenres() {
        return genres;
    }

    public void setGenres(List<String> genres) {
        this.genres = genres;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    // ✅ No-argument constructor
    public BookDtls() {
        super();
    }

    // ✅ Parameterized constructor
    public BookDtls(String bookName, String author, String price,
            String bookCategory, String status,
            String photoName, String email, String description) {

        this.bookName = bookName;
        this.author = author;
        this.price = price;
        this.bookCategory = bookCategory;
        this.status = status;
        this.photoName = photoName;
        this.email = email;
        this.description = description;
    }

    // ✅ Getters & Setters

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getBookCategory() {
        return bookCategory;
    }

    public void setBookCategory(String bookCategory) {
        this.bookCategory = bookCategory;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPhotoName() {
        return photoName;
    }

    public void setPhotoName(String photoName) {
        this.photoName = photoName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    //  DESCRIPTION

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    //  toString

    @Override
    public String toString() {
        return "BookDtls [bookId=" + bookId +
                ", bookName=" + bookName +
                ", author=" + author +
                ", price=" + price +
                ", bookCategory=" + bookCategory +
                ", status=" + status +
                ", photoName=" + photoName +
                ", email=" + email +
                ", description=" + description + "]";
    }
}
