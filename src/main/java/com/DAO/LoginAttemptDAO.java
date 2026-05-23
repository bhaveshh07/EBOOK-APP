package com.DAO;

import com.entity.LoginAttempt;

public interface LoginAttemptDAO {

    LoginAttempt getByUserId(int userId);

    void createIfNotExists(int userId);

    void increaseAttempt(int userId);

    void resetAttempts(int userId);

    boolean isAccountLocked(int userId);
}
