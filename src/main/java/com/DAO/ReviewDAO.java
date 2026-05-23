package com.DAO;

import java.util.List;
import com.entity.Review;

public interface ReviewDAO {

    boolean addReview(Review r);

    List<Review> getReviewsByBook(int bookId);

    boolean hasUserReviewed(int bookId, int userId);

    double getAverageRating(int bookId);
}
