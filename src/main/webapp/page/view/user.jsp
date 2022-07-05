<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE HTML>
<html>
<head>
	<jsp:include page="../common/static.jsp"></jsp:include>
	<jsp:include page="../common/static-js.jsp"></jsp:include>
</head>
<body>
<nav class="breadcrumb"><i class="Hui-iconfont">&#xe67f;</i> 首页 <span class="c-gray en">&gt;</span> 商户管理 <span class="c-gray en">&gt;</span> 商户列表<a class="btn btn-success radius r" style="line-height:1.6em;margin-top:3px" href="javascript:location.replace(location.href);" title="刷新" ><i class="Hui-iconfont">&#xe68f;</i></a></nav>
<div class="page-container">

	<div class="text-c">
		<form class="layui-form gformc" action="" >
			<div class="gformccontent">
				<label class="gformctitle">用户ID:</label><div class="gformcvalue"><input type="text" oninput="value=value.replace(/[^\d]/g,'')" maxlength="9" name="merchantId" id="merchantId" class="layui-input" ></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">登录账号:</label><div class="gformcvalue"><input type="text" name="cname" id="mobile" class="layui-input" ></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">用户名称:</label><div class="gformcvalue"><input type="text" name="cname" id="cname" class="layui-input" ></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">注册时间:</label><div class="gformcvalue"><input type="text" readonly name="addTime" id="addTime" autocomplete="off" class="layui-input" style="width: 50%;display: inline;" placeholder="开始时间"><input type="text" name="endTime" id="endTime" autocomplete="off" class="layui-input" style="width: 50%;display: inline;" placeholder="结束时间"></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">代理ID:</label><div class="gformcvalue"><input type="text" oninput="value=value.replace(/[^\d]/g,'')" maxlength="9" name="agentId" id="agentId" class="layui-input" ></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">用户状态:</label><div class="gformcvalue">
				<select id="status" lay-verify="required" lay-search="">
					<option value="">全部</option>
					<option value="1">待审核</option>
					<option value="2">正常</option>
					<option value="3">禁用</option>
				</select></div>
			</div>
			<div class="gformccontent">
				<label class="gformctitle">用户角色:</label><div class="gformcvalue">
				<select id="roleId" lay-verify="required" lay-search="">
					<option value="">全部</option>
					<c:forEach items="${role}" var="role">
						<c:if test="${role.sysRoleId!=1}">
							<option value="${role.sysRoleId}">${role.roleName}</option>
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


		<table id="dataMsg" class="table table-border table-bordered">
			<thead>
			<tr class="text-c">
				<th>用户ID</th>
				<th>代理ID</th>
				<th>用户名称</th>
				<th>登录账号</th>
				<th>注册时间</th>
				<th>可提现(元)</th>
				<th>用户状态</th>
				<th>用户级别</th>
				<th>操作</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${merchants}" var="member" >
				<c:if test="${currentUser.id!=member.id}">
					<tr class="text-c">
						<td><a style="color: #0000FF;" href="javascript:showDetail('${member.returnUrl}','${member.notifyUrl}','${member.id}')">${member.id }</a></td>
						<td>
								${member.agentId}
						</td>
						<td>${member.cname}</td>
						<td>${member.mobile}</td>
						<td><fmt:formatDate value="${member.addTime }"   pattern="yy/MM/dd HH:mm:ss" type="date" dateStyle="long" /></td>
						<td>${member.balance}</td>
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
								<c:choose>
									<c:when test="${member.roleId == 2}">
										<c:if test="${currentUser.roleId==1||currentUser.roleId==11}">
											<button onclick="recharge('${member.id}','${member.cname}')" class="layui-btn layui-btn-xs layui-btn-normal">充值</button>
										</c:if>
									</c:when>
									<c:when test="${member.roleId == 5}">
										<c:if test="${currentUser.roleId==1||currentUser.roleId==11}">
											<button onclick="recharge('${member.id}','${member.cname}')" class="layui-btn layui-btn-xs layui-btn-normal">充值</button>
										</c:if>
										<c:if test="${currentUser.roleId==1||currentUser.roleId==2||currentUser.roleId==11}">
											<button onclick="modifyBankCard('${member.id}')" class="layui-btn layui-btn-xs layui-btn-normal">绑定银行卡</button>
										</c:if>
									</c:when>
									<c:when test="${member.roleId == 7}">
									</c:when>
									<c:otherwise>
										<c:if test="${currentUser.roleId==1||currentUser.roleId==11}">
											<button onclick="recharge('${member.id}','${member.cname}')" class="layui-btn layui-btn-xs layui-btn-normal">充值</button>
											<c:if test="${member.roleId==4}">
												<button onclick="mixedChannel('${member.id}')" class="layui-btn layui-btn-xs layui-btn-primary">设置混合通道</button>
												<button onclick="showCoder('${member.id}')" class="layui-btn layui-btn-xs layui-btn-normal">绑定码商</button>
											</c:if>
										</c:if>
										<c:if test="${currentUser.roleId==1||currentUser.roleId==2||currentUser.roleId==11}">
											<button onclick="modifyBankCard('${member.id}')" class="layui-btn layui-btn-xs layui-btn-normal">绑定银行卡</button>
										</c:if>
										<c:if test="${member.roleId==4}">
											<button onclick="showTestUrl2('${member.id}')" class="layui-btn layui-btn-xs layui-btn-primary">测试地址2</button>
										</c:if>
									</c:otherwise>
								</c:choose>
								<c:if test="${currentUser.roleId==1||currentUser.roleId==11}">
									<c:if test="${member.status==2}">
										<button onclick="modifyPayPass('${member.id}')" class="layui-btn layui-btn-xs layui-btn-danger">重置提现密码</button>
										<button onclick="updateGoogleSecretKey('${member.id}')" class="layui-btn layui-btn-xs layui-btn-danger">清除谷歌验证</button>
									</c:if>
									<c:if test="${'open'!=member.whiteStatus}">
										<button onclick="changeWhite('${member.id}','open')" class="layui-btn layui-btn-xs layui-btn-warm">开启白名单验证</button>
									</c:if>
								</c:if>
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
				</c:if>
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
</div>
<script type="text/javascript">

	var pageSize;
	var laypage;
	var laydate;
	var paging;

	layui.use(['table', 'dropdown'], function(){
		var table = layui.table;
		var dropdown = layui.dropdown;

		table.render({
			elem: '#dataMsg'
			,url:'user/pageList'
			,cellMinWidth: 80
			,totalRow: true // 开启合计行
			,page: true
			,cols: [[
				{type: 'checkbox', fixed: 'left'}
				,{field:'id', fixed: 'left', width:80, title: 'ID', sort: true, totalRowText: '合计：'}
				,{field:'userName', width:80, title: '用户'}
				,{fixed: 'right', title:'操作', width: 125, minWidth: 125, toolbar: '#barDemo'}
			]]
			,error: function(res, msg){
				console.log(res, msg)
			}
		});

		// 工具栏事件
		table.on('toolbar(test)', function(obj){
			var id = obj.config.id;
			var checkStatus = table.checkStatus(id);
			var othis = lay(this);
			switch(obj.event){
				case 'getCheckData':
					var data = checkStatus.data;
					layer.alert(layui.util.escape(JSON.stringify(data)));
					break;
				case 'getData':
					var getData = table.getData(id);
					console.log(getData);
					layer.alert(layui.util.escape(JSON.stringify(getData)));
					break;
				case 'isAll':
					layer.msg(checkStatus.isAll ? '全选': '未全选')
					break;
				case 'multi-row':
					table.reload('test', {
						// 设置行样式，此处以设置多行高度为例。若为单行，则没必要设置改参数 - 注：v2.7.0 新增
						lineStyle: 'height: 95px;'
					});
					layer.msg('即通过设置 lineStyle 参数可开启多行');
					break;
				case 'default-row':
					table.reload('test', {
						lineStyle: null // 恢复单行
					});
					layer.msg('已设为单行');
					break;
				case 'LAYTABLE_TIPS':
					layer.alert('Table for layui-v'+ layui.v);
					break;
			};
		});

		//触发单元格工具事件
		table.on('tool(test)', function(obj){ // 双击 toolDouble
			var data = obj.data;
			//console.log(obj)
			if(obj.event === 'del'){
				layer.confirm('真的删除行么', function(index){
					obj.del();
					layer.close(index);
				});
			} else if(obj.event === 'edit'){
				layer.open({
					title: '编辑',
					type: 1,
					area: ['80%','80%'],
					content: '<div style="padding: 16px;">自定义表单元素</div>'
				});
			}
		});

		//触发表格复选框选择
		table.on('checkbox(test)', function(obj){
			console.log(obj)
		});

		//触发表格单选框选择
		table.on('radio(test)', function(obj){
			console.log(obj)
		});

		// 行单击事件
		table.on('row(test)', function(obj){
			//console.log(obj);
			//layer.closeAll('tips');
		});
		// 行双击事件
		table.on('rowDouble(test)', function(obj){
			console.log(obj);
		});

		// 单元格编辑事件
		table.on('edit(test)', function(obj){
			var field = obj.field //得到字段
					,value = obj.value //得到修改后的值
					,data = obj.data; //得到所在行所有键值

			var update = {};
			update[field] = value;
			obj.update(update);
		});
	});

	$(function () {
		layui.use(['form','laypage', 'layer','laydate'], function(){
			laypage = layui.laypage;
			layer = layui.layer
					,laydate = layui.laydate;
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
			//以下将以jquery.ajax为例，演示一个异步分页
			pageSize = 10;
			paging = function(curr){
				$.ajax({
					type: "POST",
					url: "/member/pageList.html",
					data: {
						merchantId:$("#merchantId").val(),
						agentId:$("#agentId").val(),
						status:$("#status").val(),
						startTime:$("#addTime").val(),
						endTime:$("#endTime").val(),
						mobile:$("#mobile").val(),
						cname:$("#cname").val(),
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
							//groups: 5 ,//连续显示分页数
							first: 1,
							last: totalCount,
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
