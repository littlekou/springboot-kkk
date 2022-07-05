package com.kkk.utils.Verify;


import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.Date;

public class ValidateCodeUtil {

    /**
     * @param type 验证类型
     * @param request
     * @return
     */
    public static ValidateCode createVerifyCode(String type, HttpServletRequest request) {
        return createVerifyCode(200, 80, 4, type, request);
    }

    /**
     * @param width 验证码宽
     * @param height 验证码高
     * @param length 验证码长度（几位）
     * @param type 验证类型
     * @param request
     * @return
     */
    public static ValidateCode createVerifyCode(int width, int height, int length, String type, HttpServletRequest request) {
        ValidateCode dto = new ValidateCode();
        boolean flag = false;
        try {
            String codeParentPath ="uploadFile/verifyCode/"+ DateFormatUtils.format(new Date(), "yyyyMMdd");
            String realPath = request.getSession().getServletContext().getRealPath("/")+codeParentPath;
            String newFileName = System.currentTimeMillis() + ".jpg";// 新文件名
            File dir = new File(realPath);
            File file = new File(dir,newFileName);
            String verifyCode = ImageCodeUtil.generateVerifyCode(length);
            ImageCodeUtil.outputImage(width, height, file, verifyCode);
            ValidateCode validateCode = new ValidateCode();
            validateCode.setCode(verifyCode);
            validateCode.setVerifyTimes(VerifyUtil.VERIFY_MAX_TIMES);//验证码存入session
            request.getSession().setAttribute(type,validateCode);
            dto.setCodePath(codeParentPath+"/"+newFileName);//验证码路径
            flag = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        dto.setSuccess(flag);
        return dto;
    }


    /**
     * 验证验证码是否正确
     * @param request
     * @param verifyCode
     * @param type 验证的类型
     * @return
     */
    public static ValidateCode verifyCode(HttpServletRequest request, String verifyCode, String type) {
        Boolean flag = false;
        String message = "";
        HttpSession session = request.getSession();
        ValidateCode verifyVal = (ValidateCode) session.getAttribute(type);
        if (verifyVal != null) {
                String code = verifyVal.getCode();
                if (code != null && verifyCode.toLowerCase().equals(code.toLowerCase())) {
                    int times = verifyVal.getVerifyTimes();//验证次数
                    if (times > 0) {
                        verifyVal.setVerifyTimes(times-1);
                        session.setAttribute(type, verifyVal);
                        flag = true;
                    } else {
                        message = "验证码已过期请重新刷新验证码！";
                    }
                }else {
                    message = "验证码错误！";
                }
        } else {
            message = "请发送验证码！";
        }
        ValidateCode result = new ValidateCode();
        result.setSuccess(flag);
        result.setMsg(message);
        return result;
    }


    /**
     * 验证图片验证码
     * @param request
     * @param verifyCode
     * @param type
     * @return
     */
    public static ValidateCode validateImgCode(HttpServletRequest request, String verifyCode, String type) {
        ValidateCode validateCode;
        if (StringUtils.isNotEmpty(verifyCode) && StringUtils.isNotEmpty(type)) {
            if ("reg".equals(type)) {
                type = VerifyUtil.ImgVerifyType.REGISTER.getVal();
            } else {
                type = VerifyUtil.ImgVerifyType.RETRIEVE_PASSWORD.getVal();
            }
            validateCode = ValidateCodeUtil.verifyCode(request, verifyCode, type);
        } else {
            validateCode = new ValidateCode();
            validateCode.setSuccess(false);
            validateCode.setMsg("验证码错误");
        }
        return validateCode;
    }
}