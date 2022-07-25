<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html>
<head>
	<jsp:include page="/page/common/static.jsp"></jsp:include>
	<jsp:include page="/page/common/static-js.jsp"></jsp:include>
	<title>订单列表</title>
</head>
<body>
<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 支付管理 <span class="c-gray en">&gt;</span> 订单列表<a class="btn btn-success radius r" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" ><i class="Hui-iconfont">&#xe68f;</i></a></nav>
<div class="page-container">

	<div class="text-c">
		<form class="gformc" action="" >
			<div class="gformccontent">
				<label class="gformctitle">添加时间:</label><div class="gformcvalue"><input type="text" readonly name="addTime" id="addTime" autocomplete="off" class="layui-input" style="width: 50%;display: inline;" placeholder="开始时间"><input type="text" name="endTime" id="endTime" autocomplete="off" class="layui-input" style="width: 50%;display: inline;" placeholder="结束时间"></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">商户编号:</label><div class="gformcvalue"><input type="text"name="merchantId" id="merchantId" class="layui-input" ></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">订单号:</label><div class="gformcvalue"><input type="text" name="orderNo" id="orderNo" class="layui-input" ></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">状态:</label><div class="gformcvalue">
				<select id="state" name = "state" lay-verify="required" lay-search="">
					<option value="">全部</option>
					<option value="1">下单成功</option>
					<option value="2">转账完成</option>
				</select>
			</div>
			</div>
			<div class="layui-btn-group" style="float: left;">
				<button type="button" class="layui-btn" id="search"><i class="Hui-iconfont"></i>搜索</button>
			</div>
			<div style="clear: both;content: ' ';display: block;"></div>
		</form>
	</div>
	<div id="dataMsg"></div>
	<div id="orderPager"></div>
</div>
<script type="text/javascript">
	var pageSize;
	var laypage;
	var laydate;
	var paging;
	$(function () {
		layui.use(['form','laypage', 'layer','laydate'], function(){
			laypage = layui.laypage;
			layer = layui.layer,
			laydate = layui.laydate;
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
					url: "/order/pageList",
					data: {
						merchantId:$("#merchantId").val(),
						orderNo:$("#orderNo").val(),
						state:$("#state").val(),
						startTime:$("#addTime").val(),
						endTime:$("#endTime").val(),
						currentPage :curr || 1,
						pageSize : pageSize
					},
					success: function(data){
						$("#dataMsg").html(data);
						var totalCount = $("#totalCount").val();
						//显示分页
						laypage.render({
							elem: 'orderPager', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
							count: totalCount, //通过后台拿到的总页数
							curr: curr || 1, //当前页
							//groups: 5 ,//连续显示分页数
							first: 1,
							last: totalCount,
							limit: pageSize,
							limits:[10,20,30],
							layout: ['count', 'prev', 'page', 'next', 'limit', 'refresh', 'skip'],
							jump: function(obj, first){ //触发分页后的回调
								if(!first){ //点击跳页触发函数自身，并传递当前页：obj.curr
									pageSize=obj.limit;
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
</script>

</body>
</html>
