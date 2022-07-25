package com.kkk.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.kkk.dao.OrderDao;
import com.kkk.entity.Orders;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.List;

@Service
@Slf4j
public class OrderService {

	@Autowired
	private OrderDao orderDao;

	@Transactional
	public void deleteOrder(Integer id) {
		try{
			orderDao.deleteOrder(id);
		}catch (Exception e){
			log.error("删除失败", e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
	}

	public List<Orders> selectOrders(Orders o){
		return orderDao.selectOrders(o);
	}

	public void insertOrder(Orders order) {
		orderDao.insertOrder(order);
	}

}

