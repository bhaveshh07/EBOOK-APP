package com.entity;

import java.sql.Timestamp;

public class LoginAttempt {

    private int userId;
    private int attemptCount;
    private Timestamp lockUntil;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAttemptCount() {
        return attemptCount;
    }

    public void setAttemptCount(int attemptCount) {
        this.attemptCount = attemptCount;
    }

    public Timestamp getLockUntil() {
        return lockUntil;
    }

    public void setLockUntil(Timestamp lockUntil) {
        this.lockUntil = lockUntil;
    }
}
