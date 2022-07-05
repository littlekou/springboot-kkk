package com.kkk.common.exception;

import lombok.Data;

/**
 * @Author: kkk
 * @Date: Created in 18:07 2022/6/7
 */
@Data
public class ExceptionUnify {
    private int code;
    private String msg;
    private String data;
}
