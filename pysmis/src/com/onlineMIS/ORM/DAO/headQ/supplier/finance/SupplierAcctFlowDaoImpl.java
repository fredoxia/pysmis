package com.onlineMIS.ORM.DAO.headQ.supplier.finance;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import com.onlineMIS.ORM.DAO.BaseDAO;
import com.onlineMIS.ORM.entity.chainS.inventoryFlow.ChainInOutStock;
import com.onlineMIS.ORM.entity.headQ.finance.HeadQAcctFlow;
import com.onlineMIS.ORM.entity.headQ.supplier.finance.SupplierAcctFlow;
import com.onlineMIS.common.Common_util;

@Repository
public class SupplierAcctFlowDaoImpl  extends BaseDAO<SupplierAcctFlow> {
	/**
	 * get the accumulate acct flow
	 * @return
	 */
	public double getAccumulateAcctFlow(int supplierId){
		DetachedCriteria criteria = DetachedCriteria.forClass(SupplierAcctFlow.class);

		criteria.add(Restrictions.eq("supplierId", supplierId));
		
		criteria.setProjection(Projections.sum("acctAmt"));
		
		List<Object> result = getByCriteriaProjection(criteria, true);

        return Common_util.getProjectionDoubleValue(result);
	}
	
	/**
	 * get the accumulate acct flow
	 * @return
	 */
	public double getAccumulateAcctFlowBefore(int supplierId, Date date){
		DetachedCriteria criteria = DetachedCriteria.forClass(SupplierAcctFlow.class);

		criteria.add(Restrictions.eq("supplierId", supplierId));
		
		criteria.add(Restrictions.lt("date", date));
		
		criteria.setProjection(Projections.sum("acctAmt"));
		
		List<Object> result = getByCriteriaProjection(criteria, true);

        return Common_util.getProjectionDoubleValue(result);
	}
	
	/**
	 * 获取客户在某个日期前的欠款
	 * @param clientIds
	 * @param date
	 * @return
	 */
	public Map<Integer, Double> getAccumulateAcctFlowBefore(Set<Integer> supplierIds, Date date){
		DetachedCriteria criteria = DetachedCriteria.forClass(SupplierAcctFlow.class);
		
		criteria.add(Restrictions.in("supplierId", supplierIds));
		criteria.add(Restrictions.lt("date", date));
		
		ProjectionList projList = Projections.projectionList();
		projList.add(Projections.groupProperty("supplierId"));
		projList.add(Projections.sum("acctAmt"));
		criteria.setProjection(projList);
		
		List<Object> result = getByCriteriaProjection(criteria, false);
		Map<Integer, Double> stockMap = new HashMap<Integer, Double>();
		
		//1. to put the result to stock map
		for (Object object : result)
		  if (object != null){
			Object[] recordResult = (Object[])object;
			int clientId = Common_util.getInt(recordResult[0]);
			double acctBalance =  Common_util.getDouble(recordResult[1]);
			stockMap.put(clientId, acctBalance);
		  } 

		return stockMap;
	}
}
