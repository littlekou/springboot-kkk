package com.kkk.utils.Verify;

import lombok.Data;

@Data
public class ValidateCode {

    private boolean isSuccess;

    private String code;

    private String codePath;

    private String msg;

    private int verifyTimes;//验证次数

}
