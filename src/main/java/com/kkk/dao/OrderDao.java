package com.kkk.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kkk.entity.Orders;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderDao extends BaseMapper<Orders> {
    void insertOrder(Orders order);

    void deleteOrder(Integer id);

    List<Orders> selectOrders(Orders o);
}
