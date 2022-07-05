<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<base href="<%=basePath%>">
<jsp:include page="../common/static.jsp"></jsp:include>
<style>
    .s-content{}
    .s-lay{float: left;width:19.2%;text-align: center;box-sizing: border-box;border: 1px solid #ddd;}
    .kx{float: left;width:1%;min-height:5px;}
    .s-lay-money{height:200px;color:#FFF;padding-top:50px;box-sizing: border-box;}
    .s-lay-money i{  width: 60px;
        height: 60px;
        position: relative;
        vertical-align: top;
        background-image: url(/images/sprite.png);
        display: block;
        margin-left: auto;
        margin-right: auto;margin-bottom: 20px;}
    .s-lay-money img{display: block;width:45px;margin: 0px auto 25px;}
    .jrjyl{background-color: #ff5e5e;}
    .jrjye{background-color: #1E9FFF;}
    .zhye{background-color: #5ad2d3;}
    .ktxj{background-color: #87d317;}
    .djxj{background-color: #f6aa32;}
    .s-desc{padding: 10px;box-sizing: border-box;}
    .s-content:after{display: block;content: '';clear: both;}
</style>
<div data-options="region:'center',title:'欢迎页面'">
    <div class="page-container s-content">
          <div class="s-lay">
              <div class="s-lay-money jrjyl">
                  <i style="background-position: -280px -140px;"></i>
                  ${nowOrderStatistic.orderTotal}笔
              </div>
              <div class="s-desc">今日总代付订单量</div>
          </div>
          <div class="kx"></div>
          <div class="s-lay">
              <div class="s-lay-money jrjye">
                  <i style="background-position: 0 -140px;"></i>
                  ${nowOrderStatistic.priceTotal}元
              </div>
              <div class="s-desc">今日总代付额</div>
          </div>
          <div class="kx"></div>
          <div class="s-lay">
              <div class="s-lay-money zhye"><i style="background-position:-70px -140px;"></i>
                  ${nowOrderStatistic.payTotal}元
              </div>
              <div class="s-desc">今日成功代付额</div>
          </div>
          <div class="kx"></div>
          <div class="s-lay">
              <div class="s-lay-money ktxj"><i style="background-position:-140px -140px;"></i>
                  ${nowOrderStatistic.amountTotal}元
              </div>
              <div class="s-desc">今日代付手续费</div>
          </div>
          <div class="kx"></div>
          <div class="s-lay">
              <div class="s-lay-money djxj"><i style="background-position:-210px -140px;"></i>
                  ${nowOrderStatistic.balance}元
              </div>
              <div class="s-desc">账户余额</div>
          </div>
    </div>
    </div>
</div>
