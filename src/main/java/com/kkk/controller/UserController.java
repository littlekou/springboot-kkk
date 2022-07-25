package com.kkk.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.kkk.entity.KUser;
import com.kkk.entity.Paging;
import com.kkk.entity.SysRole;
import com.kkk.entity.bo.ReturnData;
import com.kkk.service.UserService;
import com.kkk.utils.PwdUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
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
	@GetMapping(value = "/reSetPWD", produces = "application/json;charset=utf-8")
	@ResponseBody
	public ReturnData reSetPWD(int id) {
		KUser kUser= userService.getUserByColumn("id",String.valueOf(id));
		String md5PWD = new PwdUtils().encryption("123456",kUser.getAccount());
		kUser.setPassword(md5PWD);
		kUser.setUpdateTime(new Date());
		userService.updateUser(kUser);
		return new ReturnData(200,"修改成功");
	}

	@GetMapping(value = "/changeStatus", produces = "application/json;charset=utf-8")
	@ResponseBody
	public ReturnData changeStatus(int id,int status) {
		KUser kUser= new KUser();
		kUser.setId(id);
		kUser.setStatus(status);
		userService.updateUser(kUser);
		return new ReturnData(200,"修改成功");
	}

	@RequestMapping(value="/toAddUser")
	public ModelAndView toAddUser(ModelAndView model) {
		List<SysRole> role = userService.getRole();
        model.getModel().put("roles",role);
		model.getModel().put("curOpt","add");
		model.setViewName("page/view/user/modify_user");
		return model;
	}

	@RequestMapping(value = "/modifyUser", produces = "application/json;charset=utf-8")
	@ResponseBody
	public ReturnData modifyMember(HttpServletRequest request,Integer id,String account,String userName,
											Integer roleId) {
    	KUser kUser = getCurrentUser(request);
		KUser user = new KUser();
		user.setAccount(account);
		user.setUserName(userName);
		if(roleId==null){
			return ReturnData.getReturn(100,"请将信息填写完整");
		}
		user.setRoleId(roleId);
		if(id!=null) {
			//为修改
			user.setId(id);
			user.setUpdateTime(new Date());
			userService.updateUser(user);
			return ReturnData.getReturn(200,"修改成功");
		}else {
//			//为新增
			KUser m = userService.getUserByColumn("account",account);
			if(m!=null){
				return ReturnData.getReturn(100,"登录账号重复，请修改");
			}
			user.setAddTime(new Date());
			user.setStatus(1);
            String md5PWD = new PwdUtils().encryption("123456",account);
			user.setPassword(md5PWD);
			user.setCreateBy(kUser.getId());
			userService.insertUser(user);
			return ReturnData.getReturn(200, "添加成功");
		}
	}

	@RequestMapping(value = "/deleteUser", produces = "application/json;charset=utf-8")
	@ResponseBody
	public ReturnData deleteUser(Integer id) {
		userService.deleteUser(id);
		return ReturnData.getReturn(200, "添加成功");
	}

}
