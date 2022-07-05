package com.kkk.interceptor;

import com.kkk.common.Constants;
import com.kkk.controller.BaseController;
import com.kkk.utils.RedisUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CheckLoginInterceptor extends BaseController implements HandlerInterceptor {

	private String [] noLoginUrls = {"/admin/login", "/template/page/login","/error","/admin/welcome"};

	@Autowired
	private RedisUtils redisUtils;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String servletPath = request.getServletPath();
		for (String url:noLoginUrls) {
			if(request.getServletPath().startsWith(url)){
				return true;
			}
		}
		Object userSession =request.getSession().getAttribute("currentUser");
		if(userSession != null){
			return true;
		}
		response.sendRedirect(request.getContextPath() + noLoginUrls[0]);
		return false;
	}
	@Override
	public void postHandle(HttpServletRequest request,
                           HttpServletResponse response, Object handler, ModelAndView modelAndView){
		this.beforeFormHander(request.getServletPath(),request.getRequestedSessionId(),request);
	}
	@Override
	public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response, Object handler, Exception ex){
		// TODO Auto-generated method stub
//		request.setAttribute("staticUrl", Constants.STATIC_URL);
	}

	/**
	 * 表单重复提交处理
	 * true 表示正常；false 表示重复提交表单。
	 */
	public void beforeFormHander(String url,String sessionId, HttpServletRequest request){
		if(url.contains(Constants.toForm)){
			String stoke = System.currentTimeMillis()+"";
			redisUtils.setEXFixedDB(url.replace(Constants.toForm,sessionId).replace(".html",""),stoke,60*10, Constants.FIXED_DB);
			request.setAttribute(Constants.stoken,stoke);
		}
	}

}
