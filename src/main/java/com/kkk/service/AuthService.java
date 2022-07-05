package com.kkk.service;

import com.kkk.dao.AuthDao;
import com.kkk.entity.SysAuth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


@Service
public class AuthService {

	@Autowired
	private AuthDao sysAuthDao;

	public List<SysAuth> getAuthByParams(Map<String, Object> params) {
		return sysAuthDao.selectAuth(params);
	}
}

