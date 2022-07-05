package com.kkk.common.exception;

import lombok.Data;

import java.util.Map;

/**
 * @Author: kkk
 * @Date: Created in 18:05 2022/6/7
 */
@Data
public class ExceptionResult {

    private int code;
    private String msg;
    private String data;

    public ExceptionResult(int code, String msg, String data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }
}
