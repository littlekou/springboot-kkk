package com.kkk.dao;

import com.kkk.entity.SysAuth;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository
public interface AuthDao {
    List<SysAuth> selectAuth(Map<String, Object> params);
}
