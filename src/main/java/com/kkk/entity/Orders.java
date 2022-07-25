package com.kkk.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class Orders {
    private Long id;
    private Integer merchantId;
    private String orderNo;
    private String tradeNo;
    private Integer payType;
    private BigDecimal orderPrice;
    private String productName;
    private Date addTime;
    private Date payTime;
    private Integer state;
    private String remark;
    private String codeUrl;
    private String returnUrl;
    private String notifyUrl;
    private String startTime;
    private String endTime;
    private String userName;

}
