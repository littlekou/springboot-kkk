package com.kkk.service;

import com.kkk.dao.RoleAuthDao;
import com.kkk.entity.SysRoleAuth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class RoleAuthService {

	@Autowired
	private RoleAuthDao roleAuthDao;

	public List<SysRoleAuth> selectRelationByRoleId(Integer roleId) {
		Map<String,Object> map = new HashMap<>();
		map.put("roleId",roleId);
		return roleAuthDao.selectByMap(map);
	}


}

