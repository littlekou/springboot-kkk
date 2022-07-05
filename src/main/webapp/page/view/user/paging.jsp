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
						<c:if test="${member.status==2}">
							正常
						</c:if>
						<c:if test="${member.status==3}">
							禁用
						</c:if>
						<c:if test="${member.status==5}">
							停止轮询
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
							<c:when test="${member.roleId == 3}">
								员工
							</c:when>
							<c:when test="${member.roleId == 4}">
								商户
							</c:when>
							<c:when test="${member.roleId == 5}">
								码商
							</c:when>
							<c:when test="${member.roleId == 6}">
								代付商
							</c:when>
							<c:when test="${member.roleId == 7}">
								操作员
							</c:when>
							<c:when test="${member.roleId == 10}">
								数据代理商
							</c:when>
							<c:when test="${member.roleId == 11}">
								副管理
							</c:when>
							<c:otherwise>
								${member.roleId}
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<div class="layui-form" style="text-align: left;">
							<button onclick="reSetPWD('${member.id}')" class="layui-btn layui-btn-xs layui-btn-danger" style="margin: 2px 0px;">重置密码</button>
							<c:if test="${member.status==2&&currentUser.id!=member.id}">
								<button onclick="changeStatus('${member.id}',2)" class="layui-btn layui-btn-xs layui-btn-warm">禁用</button>
							</c:if>
							<c:if test="${member.status==3&&currentUser.id!=member.id}">
								<button onclick="changeStatus('${member.id}',3)" class="layui-btn layui-btn-xs">启用</button>
							</c:if>
							<c:if test="${currentUser.id!=member.id}">
								<c:if test="${member.roleId!=1}"><button onclick="modifyMember('${member.id}')" class="layui-btn layui-btn-xs layui-btn-danger">修改</button></c:if>
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
    $(function () {
        $(".orderBack").click(function () {
            var orderId = $(this).attr("orderId");
            orderBack(orderId);
        });
        //
        $("#checkAllOrder").click(function () {
            if ($(this).prop("checked")) {
                $("input[name=checkbox]:checkbox").each(function () {
                    $(this).prop("checked", true);
                });
            } else {
                $("input[name=checkbox]:checkbox").each(function () {
                    $(this).prop("checked", false);
                });
            }
        });

        $("#settlement").click(function(){
        	layer.confirm('确认要结算吗？', {
                btn : [ '确定', '取消' ]//按钮
            }, function(index) {
                layer.close(index);
	        	var ids = "";
	        	$("input[name=checkbox]:checked").each(function (){
	        		ids += $(this).val() + ",";
	        	});
	        	ids = ids.substring(0,ids.length-1);
	        	$.ajax({
	                type: "POST",
	                url: "/stockOrders/settlement.json",
	                async: false, //同步执行
	                data: {"ids": ids},
	                success: function (data) {
	                     if(data.status){
		                     layer.alert(data.msg, {icon: 1},function(index){
                                 paging(currentPage);
			            		 layer.close(index);
		                     });
	                     }else{
	                    	 layer.alert(data.msg, {icon: 5});
	                     }
	                }
	            });
            });
        });


    });

    function recharge(id,cname){
        layer.confirm('确认为该用户充值金额吗？', {
            btn : [ '确定', '取消' ]//按钮
        }, function(index) {
            layer.close(index);
            layer.open({
                type: 2,
                area: ['480px', '350px'],
                fix: false, //不固定
                maxmin: true,
                shade:0.4,
                title: "正在"+cname+"为充值...",
                content: "member/toRecharge.html?memberId="+id
            });
        });
    }


    function showDetail(returnUrl,notifyUrl,id){
    	var rateJson = "";
    	$.ajax({
            type: "POST",
            url: "/member/getRateById.json",
            async: false, //同步执行
            data: {"id": id},
            success: function (data) {
                 rateJson = data.rate;
            }
        });
    	var rate = JSON.parse(rateJson);
    	var re ="";
			for(var key in rate){
					if (key != rate.length - 1) {
						re += "<li><b>" + key + "</b>: &nbsp;" + rate[key] + "‰</li>";
					} else {
						re += "<li><b>" + key + "</b>: &nbsp;" + rate[key] + "‰</li></ul>";
					}
			}
       	layer.open({
       		  title: '用户信息',
       		  area: '450px',
       		  content: "<ul>"+
       		  "<li><b>跳转地址</b>: &nbsp;"+returnUrl+"</li>"+
       		  "<li><b>回调地址</b>: &nbsp;"+notifyUrl+"</li>"+
       		  re
       	});
	};

	function upgradeToAgent(id){
		layer.confirm('确认升级该用户为代理商吗？', {
            btn : [ '确定', '取消' ]//按钮
        }, function(index) {
        	layer.close(index);
        	$.ajax({
	            type: "POST",
	            url: "member/upgradeToAgent.json",
	            async: false, //同步执行
	            data: {"id": id},
	            success: function (data) {
	            	layer.alert("已升级", {icon: 1},function(index){
                        paging(currentPage);
	            		layer.close(index);
                     });
	            }
	        });
        });
	}

    function modifyPayPass(id) {
        layer.confirm('确认重置提现密码吗？', {
            btn : [ '确定', '取消' ]//按钮
        }, function(index) {
            layer.close(index);
            $.ajax({
                type: "POST",
                url: "member/modifyPayPass.json",
                async: false, //同步执行
                data: {"id": id},
                success: function (data) {
                    console.log(data)
                    if(data.code==200){
                        layer.alert("提现密码："+data.obj, {icon: 1},function(index){
                            paging(currentPage);
                            layer.closeAll();
                        });
                    }else{
                        layer.alert(data.msg, {icon: 5},function(index){
                            paging(currentPage);
                            layer.closeAll();
                        });
                    }

                }
            });
        });
    }

	function reSetPWD(id){
		layer.confirm('确认要重置该用户的密码吗？', {
            btn : [ '确定', '取消' ]//按钮
        }, function(index) {
        	layer.close(index);
        	$.ajax({
	            type: "POST",
	            url: "member/reSetPWD.json",
	            async: false, //同步执行
	            data: {"id": id},
	            success: function (data) {
	            	if(data.status){
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

	function updateGoogleSecretKey(id) {
		layer.confirm('确认清除谷歌验证器吗？', {
			btn : [ '确定', '取消' ]//按钮
		}, function(index) {
			layer.close(index);
			$.ajax({
				type: "POST",
				url: "/member/updateGoogleSecretKey.json",
				async: false, //同步执行
				data: {"id": id,"googleSecretKey":"admin",code:1},
				success: function (data) {
					if(data.code==200){
						layer.alert("清除成功", {icon: 1},function(index){
							layer.closeAll();
						});
					}else{
						layer.alert(data.msg, {icon: 5},function(index){
							layer.closeAll();
						});
					}

				}
			});
		});
	}
	function changeStatus(id,status){
		if(status==2){
			layer.confirm('确认要禁用该用户吗？', {
	            btn : [ '确定', '取消' ]//按钮
	        }, function(index) {
	        	layer.close(index);
				$.ajax({
		            type: "POST",
		            url: "/member/changeStatus.json",
		            async: false, //同步执行
		            data: {"id": id,"status":3},
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
		            type: "POST",
		            url: "/member/changeStatus.json",
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

	function modifyMember(id){
    	layer.open({
    		type: 2,
            area: ['520px', '510px'],
    		fix: false, //不固定
    		maxmin: true,
    		shade:0.4,
    		title: "修改用户",
    		content: "member/toModifyMember.html?id="+id,
            success:function(){
                $(":focus").blur();
            }
    	});
	}

	function modifyBankAccount(id){
    	layer.open({
    		type: 2,
    		area: ['480px', '450px'],
    		fix: false, //不固定
    		maxmin: true,
    		shade:0.4,
    		title: "收款账号",
    		content: "member/toModifyBankAccount.html?memberId="+id,
            success:function(){
                $(":focus").blur();
            }
    	});
	}

	function modifyAliAccount(id){
    	layer.open({
    		type: 2,
    		area: ['480px', '450px'],
    		fix: false, //不固定
    		maxmin: true,
    		shade:0.4,
    		title: "收款账号",
    		content: "member/toModifyAliAccount.html?memberId="+id,
            success:function(){
                $(":focus").blur();
            }
    	});
	}

    function modifyBankCard(id){
        layer.open({
            type: 2,
            area: ['480px', '450px'],
            fix: false, //不固定
            maxmin: true,
            shade:0.4,
            title: "银行卡",
            content: "member/toModifyBankCard.html?memberId="+id,
            success:function(){
                $(":focus").blur();
            }
        });
    }

	function deleteUser(id) {
		layer.confirm('确认删除该用户吗？', {
			btn : [ '确定', '取消' ]//按钮
		}, function(index) {
			layer.close(index);
			$.ajax({
				type: "POST",
				url: "/member/deleteUser.json",
				async: false, //同步执行
				data: {"id": id},
				success: function (data) {
					if(data.status){
						layer.alert("已删除该用户", {icon: 1},function(index){
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
