<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html>
<head>
	<jsp:include page="/page/common/static.jsp"></jsp:include>
	<title>用户列表</title>
</head>
<body>
<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 用户管理 <span class="c-gray en">&gt;</span> 商户列表<a class="btn btn-success radius r" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" ><i class="Hui-iconfont">&#xe68f;</i></a></nav>
<div class="page-container">
	<div class="text-c">
		<form class="gformc" action="" >
		<div class="gformccontent">
			<label class="gformctitle">用户ID:</label><div class="gformcvalue"><input type="text" oninput="value=value.replace(/[^\d]/g,'')" maxlength="9" name="id" id="id" class="layui-input" ></div>
		</div>
        <div class="gformccontent">
            <label class="gformctitle">登录账号:</label><div class="gformcvalue"><input type="text" name="account" id="account" class="layui-input" ></div>
        </div>
		<div class="gformccontent">
			<label class="gformctitle">用户名称:</label><div class="gformcvalue"><input type="text" name="userName" id="userName" class="layui-input" ></div>
		</div>
		<div class="gformccontent">
			<label class="gformctitle">注册时间:</label><div class="gformcvalue"><input type="text" readonly name="addTime" id="addTime" autocomplete="off" class="layui-input" style="width: 100%;display: inline;" placeholder="开始时间"><input type="text" name="endTime" id="endTime" autocomplete="off" class="layui-input" style="width: 100%;display: inline;" placeholder="结束时间"></div>
		</div>
		<div class="gformccontent">
			<label class="gformctitle">用户角色:</label><div class="gformcvalue">
			<select id="roleId" lay-verify="required" lay-search="">
				<option value="">全部</option>
				<c:forEach items="${role}" var="role">
					<c:if test="${role.roleId!=1}">
						<option value="${role.roleId}">${role.roleName}</option>
					</c:if>
				</c:forEach>
			</select>
		</div>
		</div>
			<div class="layui-btn-group" style="float: left;">
				<button type="button"  class="layui-btn" name="" id="search" ><i class="Hui-iconfont">&#xe665;</i>搜索</button>
				<button type="button"  class="layui-btn" name="" id="addMember" onclick="toAddMember()" >+添加</button>
			</div>
		</form>
	</div>


	<div id="dataMsg"></div>
	<div id="merchantsPager"></div>
</div>
<jsp:include page="/page/common/static-js.jsp"></jsp:include>

<script type="text/javascript" src="/static/plugins/layui-v2.2.45/layui.js"></script>
<script type="text/javascript">
    var pageSize;
    var laypage;
    var layer;
    var paging;
    var form;
    $(function () {
        layui.use(['form','laypage', 'layer','laydate'], function(){
            laypage = layui.laypage;
			layer = layui.layer;
			form = layui.form;
			var laydate = layui.laydate;
			laydate.render({
				elem: '#addTime'
				,format: 'yyyy-MM-dd'
				,type: 'datetime'
			});
			laydate.render({
				elem: '#endTime'
				,format: 'yyyy-MM-dd'
				,type: 'datetime'
			});
            pageSize = 10;
            paging = function(curr){
                $.ajax({
                    type: "POST",
                    url: "/user/pageList",
                    data: {
						id:$("#id").val(),
						account:$("#account").val(),
						userName:$("#userName").val(),
						roleId:$("#roleId").val(),
                        currentPage :curr || 1,
                        pageSize : pageSize
                    },
                    success: function(data){
                        $("#dataMsg").html(data);
                        var totalCount = $("#totalCount").val();
                        //显示分页
                        laypage.render({
                            elem: 'merchantsPager', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                            count: totalCount, //通过后台拿到的总页数
                            curr: curr || 1, //当前页
                            first: 1,
                            last: totalCount,
							layout: ['count', 'prev', 'page', 'next', 'limit', 'refresh', 'skip'],
                            jump: function(obj, first){ //触发分页后的回调
                                if(!first){ //点击跳页触发函数自身，并传递当前页：obj.curr
                                    paging(obj.curr);
                                }
                            }
                        });
                    }
                });
            };
            //运行
            paging();
            $("#search").click(function () {
                paging();
            });
        });
    })

	function toAddMember(){
    	layer.open({
    		type: 2,
    		area: ['520px', '510px'],
    		fix: false, //不固定
    		maxmin: true,
    		shade:0.4,
    		title: "添加用户",
    		content: "member/toAddMember.html",
            success:function(){
                $(":focus").blur();
            }
    	});
	}

</script>


</body>
</html>
