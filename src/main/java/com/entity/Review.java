package com.entity;

public class Review {

    private int reviewId;
    private int bookId;
    private int userId;
    private int rating;
    private String reviewText;
    private String userName;
    private int helpfulCount;
    private String image;


    // No-arg constructor
    public Review() {
        super();
    }

    // Getters and Setters

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
    public int getHelpfulCount() {
    return helpfulCount;
}

public void setHelpfulCount(int helpfulCount) {
    this.helpfulCount = helpfulCount;
}
public String getImage() {
    return image;
}

public void setImage(String image) {
    this.image = image;
}

}
