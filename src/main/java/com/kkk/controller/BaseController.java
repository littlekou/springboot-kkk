package com.kkk.controller;

import com.kkk.common.Constants;
import com.kkk.entity.KUser;
import com.kkk.entity.Paging;
import com.kkk.entity.bo.ReturnData;
import com.kkk.utils.RedisUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

public class BaseController {

    @Autowired
    public RedisUtils redisUtils;

    public BaseController() {
    }

    /**
     * 请求对象转 MAP
     * @param request 请求对象
     * @return 返回Map 对象
     */
    public Map requestTOMap(HttpServletRequest request){
        Map<String,String[]> rmap =request.getParameterMap();
        Map rparameters = new TreeMap();
        for(String key:rmap.keySet()) {
            rparameters.put(key,rmap.get(key)[0]);
        }
        return rparameters;
    }


    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
    }


    private String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cs = request.getCookies();
        if(cs != null) {
            Cookie[] arr$ = cs;
            int len$ = cs.length;

            for(int i$ = 0; i$ < len$; ++i$) {
                Cookie c = arr$[i$];
                if(c.getName().equals(name)) {
                    return c.getValue();
                }
            }
        }
        return null;
    }
    /**
     * 获得paging对象用于分页
     * @param request
     * @return
     */
    public Paging getPaging(HttpServletRequest request) {
        if(request == null) {
            return null;
        } else {
            Paging paging = new Paging();
            String pagesize = request.getParameter("pageSize");
            if (StringUtils.isNotEmpty(pagesize)) {
                paging.setPageSize(Integer.parseInt(pagesize));
            }
            String currentPage = request.getParameter("currentPage");
            if (StringUtils.isNotEmpty(currentPage)) {
                paging.setCurrentPage(Integer.parseInt(currentPage));
            }
            return paging;
        }
    }

    public KUser getCurrentUser(HttpServletRequest req){
        return (KUser) req.getSession().getAttribute("currentUser");
    }

    public Map<String,Object> getUserMsg(KUser user){
        Map<String,Object> map = new HashMap<>();
        if(user!=null){
            if(org.apache.commons.lang3.StringUtils.isNotEmpty(user.getGoogleSecretKey())){
                map.put("google","ok");
            }else{
                map.put("google","no");
            }
        }
        return map;
    }

    public ReturnData getImgVerity(String imgVerify, String imgKey){
        String img = redisUtils.getFixedDB(imgKey, Constants.FIXED_DB);
        if (StringUtils.isNotBlank(imgVerify)) {
            if(StringUtils.isNotBlank(img)) {
                if (!imgVerify.equalsIgnoreCase(img)) {
                    return new ReturnData(400, "图片验证码不正确");
                }
            }else {
                return new ReturnData(400,"请发送验证码");
            }
        } else {
            return new ReturnData(400,"请输入图片验证码");
        }
        return new ReturnData(200,"");
    }

}
