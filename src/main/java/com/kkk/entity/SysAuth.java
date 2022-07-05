package com.kkk.entity;

import lombok.Data;

import java.util.Date;

@Data
public class SysAuth {
    private Long authId;

    private String authName;

    private String authAction;

    private String authSeq;

    private Long pid;

    private Date createdTime;

    private Date updatedTime;

    private Long isEffective;

    private Integer authType;


}