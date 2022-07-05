<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
    <%@ include file="common/global.jsp" %>
    <style type="text/css">
        .formLogin{
            margin-left:auto;
            margin-right: auto;
            width:375px;
            border:1px #ddd solid;
            padding:20px;
        }
    </style>
</head>
<body style="background:url('/static/img/login_page.jpg') no-repeat center;background-size: cover">
<div>
    <div align="center" class="center">
        <form class="form formLogin" action="login" method="get">
            <div class="zc_input1">
                账号：
                <input id="account" name="account" type="text" placeholder="账户" maxlength="20" class="login_input1">
            </div>
            <div class="zc_input1">
                密码：
                <input id="password" name="password" type="password" placeholder="密码" autocomplete="new-password" maxlength="20" class="login_input1">
            </div>
            <div class="zc_input1">
                谷歌验证码：
                <input type="text" id="googleCode" name="googleCode" placeholder="请输入谷歌验证码"  maxlength="18" >
            </div>
            <div class="row cl">
                <div class="formControls col-xs-8 col-xs-offset-3">
                    <input type="submit" class="loginbtn1" value="&nbsp;登&nbsp;&nbsp;&nbsp;&nbsp;录&nbsp;">
                </div>
            </div>
        </form>
    </div>
</div>
<jsp:include page="common/static-js.jsp"></jsp:include>
<script type="text/javascript">
    var loginFlag = 0;
    $(function() {
        $(document).keydown(function(event){
            if(event.keyCode==13){
                var account = $("#account").val();
                var pwd = $("#password").val();
                if(account!=null&&pwd!=null){
                    if(loginFlag==0){
                        $(".loginbtn1").val("正在登录...");
                        loginFlag = 1;
                        $("form").submit();
                    }
                }
            }
        });
    });
    document.onkeydown = function(event) {
        var e = event || window.event || arguments.callee.caller.arguments[0];
        if (e.keyCode == 13) {
            login();
            return false;
        }
    };
</script>
</body>

</html>
