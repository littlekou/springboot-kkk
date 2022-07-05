package com.kkk.entity;

import lombok.Data;

import java.util.Date;

@Data
public class SysRole {
    private int roleId;

    private String roleName;

    private Date updatedTime;

    private Date createdTime;

    private Long createdBy;

    private Long updatedBy;

    private Long isEffective;

}
