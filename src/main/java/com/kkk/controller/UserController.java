package com.kkk.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.kkk.entity.KUser;
import com.kkk.entity.Paging;
import com.kkk.entity.SysRole;
import com.kkk.service.UserService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/user")
public class UserController extends BaseController {

    @Autowired
    private UserService userService;

    @RequestMapping(value="/page")
    public ModelAndView page(ModelAndView model) {
		List<SysRole> role = userService.getRole();
		model.getModel().put("role",role);
		model.setViewName("page/view/user/user_list");
    	return model;
    }

    @RequestMapping(value = "/pageList")
	public ModelAndView pageList(HttpServletRequest request, ModelAndView mav,
								 @Param("id") Integer id,@Param("account") String account, @Param("userName") String userName,
								 @Param("roleId") Integer roleId) {
		// 判断是否登录
		KUser user= getCurrentUser(request);
		if (null != user) {
			// 分页
			Paging paging = super.getPaging(request);
			Page<Object> page =  PageHelper.startPage(paging.getCurrentPage(), paging.getPageSize());
			KUser kUser = new KUser();
			kUser.setAccount(account);
			kUser.setRoleId(roleId);
			kUser.setId(id);

			kUser.setUserName(userName);
			List<KUser> merchants = userService.getUserList(kUser);
			paging.setTotalCount(page.getTotal());
			mav.getModel().put("merchants", merchants);
			mav.getModel().put("currentUser", user);
			mav.getModel().put("paging", paging);
			mav.setViewName("page/view/user/paging");
			return mav;
		}else{
			request.setAttribute("loginInfo", "用户未登录");
			mav.setViewName("login");
			return mav;
		}

	}



}
