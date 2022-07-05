package com.kkk.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class KUser {
    private Integer id;
    private String account;
    private String userName;
    private String password;
    private Integer roleId;
    private Integer status;
    private Date addTime;
    private Date updateTime;
    private String googleSecretKey;
    public KUser() {

    }

    public KUser(int id, String account, String password, Integer roleId, Integer status, Date addTime, Date updateTime, String googleSecretKey) {
        this.id = id;
        this.account = account;
        this.password = password;
        this.roleId = roleId;
        this.status = status;
        this.addTime = addTime;
        this.updateTime = updateTime;
        this.googleSecretKey = googleSecretKey;
    }
}
