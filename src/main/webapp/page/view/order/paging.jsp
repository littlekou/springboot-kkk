<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table class="table table-border table-bordered">
	<thead>
	<tr><th colspan="14" style="color:#5eb95e;"><c:if test="${!empty smap}">交易额：${smap.orderPrice}元</c:if></th></tr>
	<tr class="text-c">
		<th>商户编号-名称</th>
		<th>客户订单号</th>
		<th>交易金额</th>
		<th>状态</th>
		<th>添加/修改时间</th>
		<th>描述</th>
		<th>操作</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach items="${orders}" var="_list" >
		<tr class="text-c">
			<td>${_list.merchantId }-${_list.userName }</td>
			<td>${_list.orderNo}</td>
			<td>${_list.orderPrice}</td>
			<td>
				<c:if test="${_list.state == 1}"><span style="color:#009688;">待转账</span></c:if>
				<c:if test="${_list.state == 2}">转账完成</c:if>
			</td>
			<td>
				<fmt:formatDate value="${_list.addTime }"   pattern="yy/MM/dd HH:mm:ss" type="date" dateStyle="long" />
				<p><fmt:formatDate value="${_list.payTime }"   pattern="yy/MM/dd HH:mm:ss" type="date" dateStyle="long" /></p>
			</td>
			<td>${_list.productName}</td>
			<td>
				<c:if test="${_list.state == 1}">
					<button type="button"  class="layui-btn layui-btn-xs layui-btn-normal"  onclick="settlement('${_list.id}','${_list.orderNo}',1)" >补单</button>
				</c:if>
				<c:if test="${_list.state == 2 || _list.state == 256}">
					<button type="button"  class="layui-btn layui-btn-xs layui-btn-danger"  onclick="settlement('${_list.id}','${_list.orderNo}',2)">发送通知</button>
					<button type="button"  class="layui-btn layui-btn-xs layui-btn-normal"  onclick="detail('${_list.id}',2)" >查看详情</button>
				</c:if>
			</td>
	</c:forEach>
	<c:if test="${empty orders}">
		<tr class="text-c">
			<td colspan="15" style="text-align: center;">暂无订单！</td>
		</tr>
	</c:if>
	</tbody>
</table>
<input type="hidden" id="totalCount" value="${paging.totalCount}"/>
<input type="hidden" id="currentPage" value="${paging.currentPage}"/>
<script type="text/javascript">
	$(function () {
		//全选与全不选
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
	});



	function locking(id,flag){
		$.ajax({
			type: "POST",
			url: "transfer/statusTransfer.json",
			data: {"id": id,"status":3},
			success: function (data) {
				if(data.code==200){
					paging($("#currentPage").val());
					layer.open({
						type: 2,
						area: ['460px', '80%'],
						fix: false, //不固定
						maxmin: true,
						shade:0.4,
						title: "锁定并打款",
						content: "transfer/toAudit.html?id="+id+"&flag="+flag,
						success:function(){
							$(":focus").blur();
						}
					});
				}else{
					layer.open({
						title:'警告',
						content: data.msg,
						scrollbar: false
					});
					paging($("#currentPage").val());
				}
			}
		});
	}
	var ctime = 0;
	//单个结算
	function settlement(id,orderNo,status){
		if(new Date().getTime()-ctime>3000){
			ctime = new Date().getTime();
			var cinfo = "";
			if(status==2){
				cinfo = "您确定发送吗？";
			}
			layer.open( {title:['提示'],
				content:cinfo,
				btn : [ '确定', '取消' ]//按钮
				,yes:function(index) {
					layer.close(index);
					$.ajax({
						type: "POST",
						url: "/order/notifySettlement",
						async: false, //同步执行
						data: {"id": id,orderNo:orderNo},
						success: function (data) {
							if(data.code==200||data.code==202){
								layer.msg(data.msg, { time: 1000 }, function(){
									paging($("#currentPage").val());
								});
							}else if(data.code==300){
								layer.msg(data.msg, { time: 1000 }, function(){
									paging($("#currentPage").val());
								});
							}else if(data.code==201){
								var  html="<span style='color: red'>操作成功，通知失败！</span><br>";
								html+="<div style='text-align: left;' >";
								html+="回调地址："+data.obj+"<br>";
								html+="回调信息："+data.msg+"<br>";
								html+="处理方式：<br>";
								html+="1、请联系商户检查回调地址填写是否正确。<br>2、请联系商户技术人员回调IP是否添加到白名单。<br>3、请联系商户技术检查程序是否收到回调通知<br>";
								html+="</div>";
								layer.open({
									content: html
									,btn: '关闭'
								});
							}else{
								var  html="<span style='color: red'>操作失败！</span><br>";
								html+="<div style='text-align: left;' >";
								html+="回调地址："+data.obj+"<br>";
								html+="回调信息："+data.msg+"<br>";
								html+="处理方式：<br>";
								html+="1、请联系商户检查回调地址填写是否正确。<br>2、请联系商户技术人员回调IP是否添加到白名单。<br>3、请联系商户技术检查程序是否收到回调通知<br>";
								html+="</div>";
								layer.open({
									content: html
									,btn: '关闭'
								});
							}
							paging($("#currentPage").val());
						},
						error:function(data){
							layer.open({
								content: "连接失败"
								,time: 5
								,btn: '关闭'
							});
						}
					});
				}
			});
		}
	};

	function unlock(id){
		$.ajax({
			type: "POST",
			url: "/transfer/statusTransfer.json",
			data: {"id": id,"status":1},
			success: function (data) {
				paging($("#currentPage").val());
			}
		});
	}

	function detail(id,flag){
		layer.open({
			type: 2,
			area: ['460px', '80%'],
			fix: false, //不固定
			maxmin: true,
			shade:0.4,
			title: "查看订单详情",
			content: "transfer/toAudit.html?id="+id+"&flag="+ flag,
			success:function(){
				$(":focus").blur();
			}
		});
	}

	function updateTab(s){
		$.ajax({
			url:"/transfer/updateTab.json",
			type:"post",
			data:{"orderNo":s,"dDesc":$("\."+s).text()},
			success:function(data){
				if (data.code!=200){
					layer.alert("编辑出错");
				}
			}
		});
	}
</script>


