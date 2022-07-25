<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table class="table table-border table-bordered table-bg">
    <thead>
    <tr class="text-c">
       	<!-- <th><input type="checkbox" id="checkAllOrder"/></th> -->
       	<th>用户ID</th>
       	<th>用户名称</th>
        <th>登录账号</th>
        <th>用户状态</th>
        <th>用户级别</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
	    <c:forEach items="${merchants}" var="member" >
				<tr class="text-c">
					<td>${member.id }</td>
					<td>${member.userName}</td>
					<td>${member.account}</td>
					<td>
						<c:if test="${member.status==1}">
							正常
						</c:if>
						<c:if test="${member.status==2}">
							禁用
						</c:if>
					</td>
					<td>
						<c:choose>
							<c:when test="${member.roleId == 1}">
								超管
							</c:when>
							<c:when test="${member.roleId == 2}">
								代理商
							</c:when>
							<c:otherwise>
								${member.roleId}
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<div class="layui-form" style="text-align: left;">
							<button onclick="reSetPWD('${member.id}')" class="layui-btn layui-btn-xs layui-btn-danger">重置密码</button>
							<c:if test="${member.status==1}">
								<button onclick="changeStatus('${member.id}',2)" class="layui-btn layui-btn-xs layui-btn-warm">禁用</button>
							</c:if>
							<c:if test="${member.status==2}">
								<button onclick="changeStatus('${member.id}',1)" class="layui-btn layui-btn-xs">启用</button>
							</c:if>
							<c:if test="${currentUser.id!=member.id}">
								<button onclick="deleteUser('${member.id}')" class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
							</c:if>
						</div>
					</td>
				</tr>
	    </c:forEach>
	    <c:if test="${empty merchants}">
	    	<tr class="text-c">
	            <td colspan="15" style="text-align: center;">暂无数据！</td>
	        </tr>
	    </c:if>
    </tbody>
</table>
   <input type="hidden" id="totalCount" value="${paging.totalCount}"/>
   <input type="hidden" id="currentPage" value="${paging.currentPage}"/>
<script type="text/javascript">
	var currentPage=$("#currentPage").val();
	function reSetPWD(id){
		layer.confirm('确认要重置该用户的密码吗？', {
            btn : [ '确定', '取消' ]//按钮
        }, function(index) {
        	layer.close(index);
        	$.ajax({
	            type: "GET",
	            url: "/user/reSetPWD",
	            async: false, //同步执行
	            data: {"id": id},
	            success: function (data) {
	            	if(data.code==200){
						layer.alert("新密码：<span style='color: red;'>"+data.msg+"</span>", {icon: 1},function(index){
							paging(currentPage);
							layer.closeAll();
							layer.close(index);
						});
					}else{
						layer.alert(data.msg, {icon: 4},function(index){
							paging(currentPage);
							layer.closeAll();
							layer.close(index);
						});
					}

	            }
	        });
        });
	}

	function changeStatus(id,status){
		if(status==1){
			layer.confirm('确认要禁用该用户吗？', {
	            btn : [ '确定', '取消' ]//按钮
	        }, function(index) {
	        	layer.close(index);
				$.ajax({
		            type: "GET",
		            url: "/user/changeStatus",
		            async: false, //同步执行
		            data: {"id": id,"status":1},
		            success: function (data) {
		            	layer.alert("已禁用", {icon: 1},function(index){
                            paging(currentPage);
                            layer.close(index);
	                     });
		            }
		        });
	        });
		}else{
			layer.confirm('确认要启用该用户吗？', {
	            btn : [ '确定', '取消' ]//按钮
	        }, function(index) {
	        	layer.close(index);
				$.ajax({
		            type: "GET",
		            url: "/user/changeStatus",
		            async: false, //同步执行
		            data: {"id": id,"status":2},
		            success: function (data) {
		            	layer.alert("已启用", {icon: 1},function(index){
                            paging(currentPage);
		            		layer.close(index);
	                     });
		            }
		        });
	        });
		}
	}

	function deleteUser(id) {
		layer.confirm('确认删除该用户吗？', {
			btn : [ '确定', '取消' ]//按钮
		}, function(index) {
			layer.close(index);
			$.ajax({
				type: "POST",
				url: "/user/deleteUser",
				async: false, //同步执行
				data: {"id": id},
				success: function (data) {
					if(data.code==200){
						layer.alert("删除成功", {icon: 1},function(index){
                            paging(currentPage);
							layer.closeAll();
						});
					}else{
						layer.alert("删除出错", {icon: 5},function(index){
							layer.closeAll();
						});
					}

				}
			});
		});
	}

	function showCoder(id){
        layer.open({
            type: 2,
            area: ['600px', '500px'],
            fix: false, //不固定
            maxmin: true,
            maxmin: true,
            shade:0.4,
            title: "绑定码商",
            content: "member/showCoder.html?id="+id
        });
	}
    function  showTestUrl2(id) {
        $.ajax({
            type: "post",
            url: "/member/createTestUrl2.json",
            async: false, //同步执行
            data: {"id": id},
            success: function (data) {
                layer.open({
                    title: '您的测试地址',
                    area: '450px',
                    content: data.url+"/member/payIn.html?mchid="+data.merchantId+"&cTime="+data.cTime+"&sign="+data.sign
                });
            }
        });
    }

    function mixedChannel(id){
        layer.open({
            type: 2,
            area: ['480px', '450px'],
            fix: false, //不固定
            maxmin: true,
            shade:0.4,
            title: "收款账号",
            content: "member/toMixedChannel.html?memberId="+id,
            success:function(){
                $(":focus").blur();
            }
        });
    }

	function changeWhite(id,status){
		var msg = "";
		if(status=='open') {
			msg = "确认要开启白名单验证吗？";
		}else{
			msg = "确认要关闭白名单验证吗？";
		}
		layer.confirm(msg, {
			btn : [ '确定', '取消' ]//按钮
		}, function(index) {
			layer.close(index);
			$.ajax({
				type: "POST",
				url: "/member/changeWhite.json",
				async: false, //同步执行
				data: {"id": id,"status":status},
				success: function (data) {
					layer.msg(data.msg, { time: 1000 }, function(){
						paging(currentPage);
						layer.close(index);
					});
				}
			});
		})
	}

</script>
