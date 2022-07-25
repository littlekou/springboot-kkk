package com.kkk.handler;

import com.kkk.common.exception.ExceptionResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * @Author: kkk
 * @Date: Created in 17:57 2022/6/7
 */

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    @ResponseBody
    @ResponseStatus(code = HttpStatus.ACCEPTED)
    public ExceptionResult exceptionHandler(HttpServletRequest request, Exception exception) {
        String method = request.getMethod();
        String msg = exception.getMessage();
        log.info("出现异常:"+method+" "+request.getRequestURI()+msg);
        exception.printStackTrace();
        return new ExceptionResult(500,"出现异常:"+method+" "+request.getRequestURI(),msg);
    }
}
