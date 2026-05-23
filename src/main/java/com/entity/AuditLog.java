package com.entity;

import java.sql.Timestamp;

public class AuditLog {

    private int id;
    private Integer userId;
    private String role;
    private String actionType;
    private String entity;
    private String entityId;
    private String description;
    private String ipAddress;
    private Timestamp createdAt;

    public void setId(int id) {
        this.id = id;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public void setEntity(String entity) {
        this.entity = entity;
    }

    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getRole() {
        return role;
    }

    public String getActionType() {
        return actionType;
    }

    public String getEntity() {
        return entity;
    }

    public String getEntityId() {
        return entityId;
    }

    public String getDescription() {
        return description;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

}
