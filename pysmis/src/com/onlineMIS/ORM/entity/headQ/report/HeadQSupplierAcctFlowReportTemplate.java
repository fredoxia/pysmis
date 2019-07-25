package com.onlineMIS.ORM.entity.headQ.report;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import com.onlineMIS.ORM.entity.headQ.custMgmt.HeadQCust;
import com.onlineMIS.ORM.entity.headQ.finance.ChainAcctFlowReportItem;

import com.onlineMIS.common.Common_util;
import com.onlineMIS.common.ExcelTemplate;

/**
 * 连锁店acct flow report
 * @author Administrator
 *
 */
public class HeadQSupplierAcctFlowReportTemplate extends ExcelTemplate{
	private final static String TEMPLATE_FILE_NAME = "HeadQSupplierAcctFlowReportTemplate.xls";
	private List<HeadQSupplierAcctFlowReportItem> items = new ArrayList<HeadQSupplierAcctFlowReportItem>();

	
	private Date startDate = null;
	private Date endDate = null;
	protected int data_row = 5;

	protected final int INDEX = 0;
	protected final int SUPPLIER_NAME = 1;
	protected final int LAST_ACCT_BALANCE = 2;
	protected final int PURCHASE_Q = 3;
	protected final int PURCHASE_AMT = 4;
	protected final int RETURN_Q =5;
	protected final int RETURN_AMT =6;
	protected final int NET_Q =7;
	protected final int NET_AMT =8;
	protected final int CURRENT_PAY =9;
	protected final int ACCT_BALANCE_END = 10;	

    public HeadQSupplierAcctFlowReportTemplate(File file) throws IOException{
    	super(file);
    }
	
	public HeadQSupplierAcctFlowReportTemplate(List<HeadQSupplierAcctFlowReportItem> items, String templateWorkbookPath, Date startDate, Date endDate) throws IOException{
		super(templateWorkbookPath + "\\" + TEMPLATE_FILE_NAME);	
		this.items = items;
		this.startDate = startDate;
		this.endDate = endDate;
	}
	
	/**
	 *  
	 * @return
	 */
	public HSSFWorkbook process(){
		HSSFSheet sheet = templateWorkbook.getSheetAt(0);
		
		Row dateRow = sheet.getRow(1);
		dateRow.createCell(1).setCellValue(Common_util.dateFormat.format(startDate));
		dateRow.createCell(3).setCellValue(Common_util.dateFormat.format(endDate));

		
		Row reportDateRow = sheet.getRow(2);
		reportDateRow.createCell(1).setCellValue(Common_util.dateFormat_f.format(Common_util.getToday()));

		//write cust infmration
		int totalDataRow = items.size();

		for (int i = 0; i < totalDataRow; i++){
			Row row = sheet.createRow(data_row + i);

			HeadQSupplierAcctFlowReportItem item = items.get(i);
			
			row.createCell(INDEX).setCellValue(i + 1);
			row.createCell(SUPPLIER_NAME).setCellValue(item.getSupplier().getName());
			row.createCell(LAST_ACCT_BALANCE).setCellValue(item.getLastAcctBalance());
			row.createCell(PURCHASE_Q).setCellValue(item.getPurchaseQ());
			row.createCell(PURCHASE_AMT).setCellValue(item.getPurchaseAmt());
			row.createCell(RETURN_Q).setCellValue(item.getReturnQ());
			row.createCell(RETURN_AMT).setCellValue(item.getReturnAmt());
			row.createCell(NET_Q).setCellValue(item.getNetQ());
			row.createCell(NET_AMT).setCellValue(item.getNetAmt());
			row.createCell(ACCT_BALANCE_END).setCellValue(item.getAcctBalanceEnd());
			row.createCell(CURRENT_PAY).setCellValue(item.getCurrentPay());
		}

		return templateWorkbook;
	}
	
}
