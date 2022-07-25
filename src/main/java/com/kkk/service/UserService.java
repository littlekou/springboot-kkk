package com.kkk.service;

import com.kkk.dao.UserDao;
import com.kkk.entity.KUser;
import com.kkk.entity.SysRole;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
@Slf4j
public class UserService {

	@Autowired
	private UserDao userDao;

	public List<KUser> getUserList(KUser map) {
		return userDao.selectByMap(map);
	}

	public List<SysRole> getRole() {
		return userDao.selectRole();
	}

	public KUser getUserByColumn(String key, String value) {
		return userDao.getUserByColumn(key,value);
	}

	public void updateUser(KUser kUser) {
		userDao.updateUser(kUser);
	}

	public void insertUser(KUser m) {
		userDao.insertUser(m);
	}

	@Transactional
	public void deleteUser(Integer id) {
		try{
			userDao.deleteUser(id);
		}catch (Exception e){
			log.error("删除失败", e);
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
	}
}

