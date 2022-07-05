<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- left -->
	<aside class="Hui-aside">
	<input runat="server" id="divScrollValue" type="hidden" value="" />
	<div class="menu_dropdown bk_2">
		<c:forEach items="${leftMeau}" var="sysAuth" >
			<c:if test="${sysAuth.pid==0}">
				<dl id="menu-member">
					<dt>
							<%--<i class="Hui-iconfont"></i>--%>
							${sysAuth.authName }<i class="Hui-iconfont menu_dropdown-arrow"></i></dt>
					<dd style="">
						<c:forEach items="${leftMeau}" var="item" >
							<c:if test="${(item.pid!=0)and(sysAuth.authId==item.pid)}">
								<ul>
									<li><a data-href="${item.authAction}" data-title="${item.authName }" href="javascript:void(0)">${item.authName }</a></li>
								</ul>
							</c:if>
						</c:forEach>
					</dd>
				</dl>
			</c:if>
		</c:forEach>
	</div>
</aside>
