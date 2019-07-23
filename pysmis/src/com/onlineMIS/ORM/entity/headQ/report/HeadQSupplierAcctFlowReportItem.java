package com.onlineMIS.ORM.entity.headQ.report;

import com.onlineMIS.ORM.entity.chainS.user.ChainStore;
import com.onlineMIS.ORM.entity.headQ.custMgmt.HeadQCust;
import com.onlineMIS.ORM.entity.headQ.supplier.supplierMgmt.HeadQSupplier;

public class HeadQSupplierAcctFlowReportItem {
	private HeadQSupplier supplier ;

	//上期欠款
	private double lastAcctBalance = 0; 
	
	//本期付款
	private double currentPay = 0;
	
	//期末欠款
	private double acctBalanceEnd = 0;
			
	//本期折让
	private double currentDiscount = 0;
	
	//入库数量
	private int purchaseQ = 0;	
	
	//入库金额
	private double purchaseAmt = 0;
	
	//退货数量
	private int returnQ = 0;
	
	//退货金额
	private double returnAmt = 0;
	
	//净采购数量
	private int netQ = 0;
	
	//净采购金额
	private double netAmt = 0;
	
	
	
	public HeadQSupplierAcctFlowReportItem(){
		
	}
	
	public HeadQSupplierAcctFlowReportItem(Double lastAcctBalance, Double currentPay, Double acctBalanceEnd, Integer purchaseQ, Double purchaseAmt, Integer returnQ, Double returnAmt){
		if (lastAcctBalance == null)
			this.lastAcctBalance = 0;
		else 
			this.lastAcctBalance = lastAcctBalance;
		
		if (currentPay == null)
			this.currentPay = 0;
		else 
			this.currentPay = currentPay;
		
		if (acctBalanceEnd == null)
			this.acctBalanceEnd = 0;
		else 
			this.acctBalanceEnd = acctBalanceEnd;
		
		if (purchaseQ == null)
			this.purchaseQ = 0;
		else 
			this.purchaseQ = purchaseQ;
		
		if (purchaseAmt == null)
			this.purchaseAmt = 0;
		else 
			this.purchaseAmt = purchaseAmt;
		
		if (returnQ == null)
			this.returnQ = 0;
		else 
			this.returnQ = returnQ;
		
		if (returnAmt == null)
			this.returnAmt = 0;
		else 
			this.returnAmt = returnAmt;
		
		this.netQ = this.purchaseQ - this.returnQ;
		this.netAmt = this.purchaseAmt - this.returnAmt;
	}


	public HeadQSupplier getSupplier() {
		return supplier;
	}

	public void setSupplier(HeadQSupplier supplier) {
		this.supplier = supplier;
	}

	public double getLastAcctBalance() {
		return lastAcctBalance;
	}

	public void setLastAcctBalance(double lastAcctBalance) {
		this.lastAcctBalance = lastAcctBalance;
	}

	public double getCurrentPay() {
		return currentPay;
	}

	public void setCurrentPay(double currentPay) {
		this.currentPay = currentPay;
	}

	public double getAcctBalanceEnd() {
		return acctBalanceEnd;
	}

	public void setAcctBalanceEnd(double acctBalanceEnd) {
		this.acctBalanceEnd = acctBalanceEnd;
	}

	public double getCurrentDiscount() {
		return currentDiscount;
	}

	public void setCurrentDiscount(double currentDiscount) {
		this.currentDiscount = currentDiscount;
	}

	public int getPurchaseQ() {
		return purchaseQ;
	}

	public void setPurchaseQ(int purchaseQ) {
		this.purchaseQ = purchaseQ;
	}

	public double getPurchaseAmt() {
		return purchaseAmt;
	}

	public void setPurchaseAmt(double purchaseAmt) {
		this.purchaseAmt = purchaseAmt;
	}

	public int getReturnQ() {
		return returnQ;
	}

	public void setReturnQ(int returnQ) {
		this.returnQ = returnQ;
	}

	public double getReturnAmt() {
		return returnAmt;
	}

	public void setReturnAmt(double returnAmt) {
		this.returnAmt = returnAmt;
	}

	public int getNetQ() {
		return netQ;
	}

	public void setNetQ(int netQ) {
		this.netQ = netQ;
	}

	public double getNetAmt() {
		return netAmt;
	}

	public void setNetAmt(double netAmt) {
		this.netAmt = netAmt;
	}
	
	
	
}
