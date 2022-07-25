<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html><!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>添加用户</title>
    <jsp:include page="/page/common/static.jsp"></jsp:include>
    <jsp:include page="/page/common/static-js.jsp"></jsp:include>
    <style>
        .users_menu li {
            width: 100%;
            height: 35px;
            line-height: 35px;
            border-bottom: 1px solid #eee;
        }

        .users_menu li a {
            margin-left: 20px;
        }

        .layui-input {
            width: 300px;
        }

        .layui-form-item {
            margin-bottom: 10px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div id="container">
    <form class="layui-form" action="/user/modifyUser" style="border:solid 1px #FFF;">
        <input type="hidden" id="id" name="id" value="${users.id }">
        <div class="layui-form-item">
            <label class="layui-form-label"><span class="c-red">*</span>用户名称:</label>
            <div class="layui-input-inline">
                <input type="text" required lay-verify="required" value="${users.userName}" id="userName"
                       name="userName" placeholder="请输入用户名称!" maxlength="15" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"><span class="c-red">*</span>登录账号:</label>
            <div class="layui-input-inline">
                        <input type="text" required lay-verify="required"
                               onKeyUp="value=value.replace(/[^\w\.\/]/ig,'')" value="${users.account}" id="account" maxlength="15"
                               name="account" placeholder="请输入登录账号!" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-mid layui-word-aux"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"> <span class="c-red">*</span>用户角色:</label>
            <div class="layui-input-inline">
                <select id="roleId" name="roleId" lay-filter="roleId">
                    <c:if test="${curOpt == 'add'}">
                        <option value="">全部</option>
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.roleId}" >${role.roleName}</option>
                        </c:forEach>
                    </c:if>
                    <c:if test="${curOpt == 'update'}">
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.roleId}" <c:if test="${users.roleId eq role.roleId}">selected</c:if>>${role.roleName}</option>
                        </c:forEach>
                    </c:if>
                </select>
            </div>
            <div class="layui-form-mid layui-word-aux"></div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" type="button" id="modifyUsers" lay-submit lay-filter="modifyUsers"
                        style="margin-left: 240px;">保存
                </button>
            </div>
        </div>
    </form>
</div>
<script>
    layui.use(['layedit', 'form'], function () {
        var form = layui.form;
        form.render();
        form.on('select(roleId)', function (data) {
            var id = $("#roleId").val();
            if (id == 7) {
                $(".fl").hide();
            } else {
                $(".fl").show();
            }
        });
        form.on('submit(modifyUsers)', function (data) {
            $.ajax({
                url: data.form.action,
                type: data.form.method,
                data: $(data.form).serialize(),
                success: function (data) {
                    if (data.code == 100) {
                        layer.msg(data.msg);
                    } else {
                        layer.alert(data.msg, {icon: 1}, function () {
                            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                            parent.paging(parent.currentPage);
                            parent.layer.close(index); //再执行关闭
                        });
                    }
                },
                error: function (data) {
                    layer.msg("对不起，您检测到数据被修改");
                }
            });

        });
    });
</script>
</body>
</html>
