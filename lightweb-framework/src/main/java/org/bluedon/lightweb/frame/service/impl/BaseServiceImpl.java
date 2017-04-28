package org.bluedon.lightweb.frame.service.impl;

import java.io.Serializable;

import javax.annotation.Resource;

import org.bluedon.lightweb.frame.dao.impl.BaseDao;
import org.bluedon.lightweb.frame.service.IBaseService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("baseService")
@Transactional
public class BaseServiceImpl<T> implements IBaseService<T>{

	@Resource(name="baseDao")
	protected BaseDao<T> dao;
	
	public Serializable save(T o) {
		return dao.save(o);
	}

	public void delete(T o) {
		dao.delete(o);
	}

	public void update(T o) {
		dao.update(o);
	}

	public void saveOrUpdate(T o) {
		dao.saveOrUpdate(o);
	}

}