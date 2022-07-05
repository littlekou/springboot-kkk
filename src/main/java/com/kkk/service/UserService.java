package com.kkk.service;

import com.kkk.dao.UserDao;
import com.kkk.entity.KUser;
import com.kkk.entity.SysRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class UserService {

	@Autowired
	private UserDao userDao;

	public KUser getUserByAccount(String account){
		KUser user = new KUser();
		user.setAccount(account);
		return userDao.selectOne(user);
	}


	public List<KUser> getUserList(KUser map) {
		return userDao.selectByMap(map);
	}

	public List<SysRole> getRole() {
		return userDao.selectRole();
	}
}

