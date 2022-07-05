package com.kkk.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.kkk.common.Constants;
import com.kkk.entity.SysAuth;
import com.kkk.entity.KUser;
import com.kkk.entity.SysRoleAuth;
import com.kkk.entity.bo.ReturnData;
import com.kkk.service.AuthService;
import com.kkk.service.RoleAuthService;
import com.kkk.service.UserService;
import com.kkk.utils.*;
import com.kkk.utils.Verify.ImageCodeUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("/admin")
@CrossOrigin
@Tag(name = "首页")
public class AdminController extends BaseController{

    @Autowired
    UserService userService;
    @Autowired
    private RoleAuthService roleAuthService;
    @Autowired
    private AuthService authService;

    @Value("${redis.flag}")
    private int flag;

    @Operation(summary = "登录",description = "登录接口")
    @RequestMapping(value = "/login")
    public String login(HttpServletRequest req, String googleCode, String imgVerify, String imgKey) {
        req.setAttribute("imgKey",UUID.randomUUID().toString());
        req.setAttribute("loginInfo", "");
        KUser user = getCurrentUser(req);
        Map<String,String> params = this.requestTOMap(req);
        String account = params.get("account");
        String pwd = params.get("password");
        if(user!=null){
            return "redirect:/admin/index";
        }
        if(StringUtils.isBlank(account)||StringUtils.isBlank(pwd)){
            return "page/login";
        }
        KUser currentUser = userService.getUserByAccount(account);
        Map<String,Object> msgMap = getUserMsg(currentUser);
        req.setAttribute("google",msgMap.get("google"));

        if(flag == 1){
            ReturnData data = getImgVerity(imgVerify,imgKey);
            if(data.getCode()!=200){
                req.setAttribute("loginInfo", data.getMsg());
                return "page/login";
            }
        }

        if(null==currentUser){
            req.setAttribute("account",account);
            req.setAttribute("loginInfo","请填写账号！");
            return "page/login";
        }else{
            if(currentUser.getStatus() != 1){
                Integer status = currentUser.getStatus();
                req.setAttribute("account",account);
                req.setAttribute("loginInfo","此账户暂无法登陆,请联系管理员！");
                return "page/login";
            }
            //验证谷歌验证码
            if("ok".equals(msgMap.get("google"))){
                if(CheckNum.checkNum(googleCode)&&googleCode.length()==6){
                    Boolean aBoolean = GoogleAuthenticator.check_code(currentUser.getGoogleSecretKey(), Integer.parseInt(googleCode), System.currentTimeMillis());
                    if (!aBoolean) {
                        req.setAttribute("account",account);
                        req.setAttribute("loginInfo","谷歌验证码不正确");
                        return "page/login";
                    }
                }else{
                    req.setAttribute("account",account);
                    req.setAttribute("loginInfo","请检查，谷歌验证码必须为6位数字！");
                    return "page/login";
                }
            }

            String password = currentUser.getPassword();
            String md5PWD = new PwdUtils().encryption(pwd,account);
            if(md5PWD.equals(password)){
                HttpSession session = req.getSession();
                session.setAttribute("currentUser", currentUser);
                Map<String,Object> param = new HashMap<>();
                param.put("sessionId",req.getSession().getId());
                param.put("userId",currentUser.getId());
                param.put("lastLoginIp", PCAddress.getIpAddress(req));
                return "redirect:/admin/index";
            }else{
                req.setAttribute("account",account);
                req.setAttribute("loginInfo","用户名和密码错误！");
                return "page/login";
            }
        }
    }

    @RequestMapping("getVerifyCode")
    @ResponseBody
    public void getVerifiCode(HttpServletRequest request, HttpServletResponse response, String captchaId) throws IOException {
        /*
             1.生成验证码
             2.把验证码上的文本存在session中
             3.把验证码图片发送给客户端
             */
        if(StringUtils.isNotBlank(captchaId)){
            ImageCodeUtil ivc = new ImageCodeUtil();     //用我们的验证码类，生成验证码类对象
            String image = ivc.generateVerifyCode(4);  //获取验证码
            redisUtils.setEXFixedDB(captchaId,image,15*60, Constants.FIXED_DB);
            ivc.outputImage(200,80, response.getOutputStream(),image);//将验证码图片响应给客户端
        }
    }

    @Operation(summary = "跳转页面")
    @GetMapping(value = "/index")
    public String transfer(HttpServletRequest req) {
        KUser user = getCurrentUser(req);
        if(user == null){
            return "login";
        }else{
            Map<String, Object> params = new HashMap<>();
            params.put("isEffective", 1);
            if(user.getRoleId()!=1) {
                List<SysRoleAuth> relations = roleAuthService.selectRelationByRoleId(user.getRoleId());
                List<Integer> authIds = new ArrayList<>();
                for (SysRoleAuth sysRoleAuth : relations) {
                    authIds.add(sysRoleAuth.getAuthId());
                }
                if(authIds.size()==0) {
                    authIds.add(-1);
                }
                params.put("authIds", authIds);
            }
            List<SysAuth> sysSysAuths = authService.getAuthByParams(params);
            req.setAttribute("leftMeau", sysSysAuths);
            req.setAttribute("currentUser",user);
            return "page/index";
        }
    }

    @GetMapping(value = "/welcome")
    public String welcome(HttpServletRequest req) {
        KUser user = getCurrentUser(req);
        req.setAttribute("user",user);
        return "page/common/welcome";
    }


}
