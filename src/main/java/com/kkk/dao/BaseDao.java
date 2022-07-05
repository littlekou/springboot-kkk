package com.kkk.dao;

import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BaseDao<T> {

	Integer save(T t);

	Integer delete(T t);

	T get(T t);

	List<T> getList(T t);

	Integer update(T t);

	int count(T t);
	
	List<T> getPagin(T t);
	
	Integer getCount(T t);
}