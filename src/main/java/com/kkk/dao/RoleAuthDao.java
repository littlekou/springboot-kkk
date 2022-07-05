package com.kkk.dao;

import com.kkk.entity.SysRoleAuth;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository
public interface RoleAuthDao{
    List<SysRoleAuth> selectByMap(Map<String, Object> map);
}
