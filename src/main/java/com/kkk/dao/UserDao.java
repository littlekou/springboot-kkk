package com.kkk.dao;

import com.kkk.entity.KUser;
import com.kkk.entity.SysRole;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserDao{
    KUser selectOne(KUser user);

    List<KUser> selectByMap(KUser user);

    List<SysRole> selectRole();
}
