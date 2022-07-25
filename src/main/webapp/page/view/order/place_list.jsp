<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html>
<head>
	<jsp:include page="/page/common/static.jsp"></jsp:include>
	<jsp:include page="/page/common/static-js.jsp"></jsp:include>
	<title>下单列表</title>
</head>
<body>
<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 订单管理 <span class="c-gray en">&gt;</span> 下单申请<a class="btn btn-success radius r" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" ><i class="Hui-iconfont">&#xe68f;</i></a></nav>
<div class="page-container">
	<div class="text-c">
		<form class="layui-form" action="" >
			<table class="layui-table"  lay-skin="line">
				<tr>
					<td width="60px">名称:</td>
					<td colspan="2" width="600px"><input required  lay-verify="required" type="text" maxlength="40" id="productName"   value="${bankAccount.productName}" placeholder="您输入名称" class="layui-input"></td>
				</tr>
				<tr>
					<td width="60px">金额:</td>
					<td colspan="2" width="600px"><input type="text" onmouseleave="addMoney()" id="orderPrice" placeholder="输入金额" class="layui-input"></td>
				</tr>
				<tr>
					<td></td><td style="text-align: left;"><button type="button" id="placeOrder"  class="layui-btn layui-btn-danger">申请下单</button></td>
				</tr>
			</table>
		</form>
	</div>
</div>

<script type="text/javascript">

	var pageSize;
	var form;
	$(function () {
		layui.use(['form','laypage', 'layer','laydate'], function(){
			layer = layui.layer,
			form = layui.form;
			//以下将以jquery.ajax为例，演示一个异步分页
			pageSize = 10;
		});

		$("#placeOrder").click(function(){
			var orderPrice = $("#orderPrice").val();
			if(orderPrice==""){
				layer.alert("请输入金额！", {icon: 4},function(index){
					layer.close(index);
				});
				return;
			}
			doPlaceOrder(orderPrice);
		});


	})

	function addMoney(){
		var orderPrice = $("#orderPrice").val();
		var reg = /^(\-?)\d+(\.\d{0,2})?$/;
		if(orderPrice!=null && orderPrice!="") {
			if (!reg.test(orderPrice)) {
				$("#orderPrice").val("");
				layer.msg("充值金额必须为数字且最多有两位小数",{time: 1500}, {icon: 5},function(index){
					layer.close(index);
				});
				return;
			}
		}
	}

	function doPlaceOrder(orderPrice) {
		$.ajax({
			type: "POST",
			url: "/order/placeOrder",
			async: false, //同步执行
			data: {"orderPrice": orderPrice,"productName": $("#productName").val()},
			success: function (data) {
				console.log(data)
				if(data.code==200){
					layer.alert(data.msg, {icon: 1},function(index){
						location.reload();
					});
				}else{
					layer.alert(data.msg, {icon: 5});
				}
			}
		});
	}


</script>


</body>
</html>
