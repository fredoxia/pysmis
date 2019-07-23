package com.onlineMIS.ORM.DAO.headQ.supplier.supplierMgmt;


import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.onlineMIS.ORM.DAO.BaseDAO;
import com.onlineMIS.ORM.entity.chainS.user.ChainStore;
import com.onlineMIS.ORM.entity.headQ.custMgmt.HeadQCust;
import com.onlineMIS.ORM.entity.headQ.supplier.supplierMgmt.HeadQSupplier;

@Repository
public class HeadQSupplierDaoImpl extends BaseDAO<HeadQSupplier>{

	/**
	 * 生成一个所有供应商的对象	
	 * @return
	 */
	public HeadQSupplier getAllSupplierObj() {
		HeadQSupplier supplier = new HeadQSupplier();
		supplier.setId(0);
		supplier.setName("所有供应商");
		return supplier;
	}
	
	/**
	 * 获取所有还在运营供应商的client id
	 * @return
	 */
	public Set<Integer> getAllSupplierIds(){
		DetachedCriteria criteria = DetachedCriteria.forClass(HeadQSupplier.class);
		criteria.add(Restrictions.ne("status", HeadQSupplier.CustStatusEnum.DELETED.getKey()));
		
		List<HeadQSupplier> suppliers = getByCritera(criteria, true);
		Set<Integer> supplierIds = new HashSet<Integer>();
		for (HeadQSupplier store : suppliers){
			supplierIds.add(store.getId());
		}
		
		return supplierIds;
	}

	public List<HeadQSupplier> getAllSuppliers() {
		DetachedCriteria criteria = DetachedCriteria.forClass(HeadQSupplier.class);
		criteria.add(Restrictions.ne("status", HeadQSupplier.CustStatusEnum.DELETED.getKey()));
		
		return getByCritera(criteria, true);
	}

}
