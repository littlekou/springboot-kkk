package com.kkk.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.kkk.dao.OrderDao;
import com.kkk.entity.KUser;
import com.kkk.entity.Orders;
import com.kkk.entity.Paging;
import com.kkk.entity.bo.ReturnData;
import com.kkk.entity.bo.SnowFlake;
import com.kkk.service.OrderService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/order")
@ResponseBody
@CrossOrigin
public class OrderController extends BaseController {

    @Autowired
    private OrderService orderService;

    SnowFlake snowFlake = new SnowFlake();

	@RequestMapping(value="/placePage")
	public ModelAndView placePpage(ModelAndView model) {
		model.setViewName("page/view/order/place_list");
		return model;
	}
	@RequestMapping(value="/placeOrder")
	public ReturnData placeOrder(HttpServletRequest request, @Param("orderPrice") BigDecimal orderPrice, @Param("productName") String productName) {
		Orders order = new Orders();
		KUser currentUser = getCurrentUser(request);
		order.setId(snowFlake.nextId());
		order.setOrderPrice(orderPrice);
		order.setProductName(productName);
		order.setMerchantId(currentUser.getId());
		order.setAddTime(new Date());
		order.setState(1);
		order.setOrderNo("T"+System.currentTimeMillis());
		order.setPayType(1);
		orderService.insertOrder(order);
		return ReturnData.getReturn(200, "下单成功");
	}

    @RequestMapping(value="/page")
    public ModelAndView page(ModelAndView model) {
		model.setViewName("page/view/order/order_list");
    	return model;
    }

    @RequestMapping(value = "/pageList")
	public ModelAndView pageList(HttpServletRequest request, ModelAndView mav,
								Orders order){
		// 判断是否登录
		KUser user= getCurrentUser(request);
		if (null != user) {
			// 分页
			Paging paging = super.getPaging(request);
			Page<Object> page =  PageHelper.startPage(paging.getCurrentPage(), paging.getPageSize());
			List<Orders> orders = orderService.selectOrders(order);
			paging.setTotalCount(page.getTotal());
			mav.getModel().put("orders", orders);
			mav.getModel().put("currentUser", user);
			mav.getModel().put("paging", paging);
			mav.setViewName("page/view/order/paging");
			return mav;
		}else{
			request.setAttribute("loginInfo", "用户未登录");
			mav.setViewName("login");
			return mav;
		}
	}

	@RequestMapping("/notifySettlement")
	public ReturnData notify(HttpServletRequest request,String id,String orderNo){
		KUser currentUser = getCurrentUser(request);


		return new ReturnData(200,"成功");
	}




}
