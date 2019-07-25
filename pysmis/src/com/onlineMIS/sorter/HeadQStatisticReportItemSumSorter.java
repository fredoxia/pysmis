package com.onlineMIS.sorter;

import java.util.Comparator;

import com.onlineMIS.ORM.entity.chainS.report.ChainReportItemVO;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Brand;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Product;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.ProductBarcode;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Quarter;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Year;
import com.onlineMIS.ORM.entity.headQ.report.HeadQPurchaseStatisticReportItem;
import com.onlineMIS.ORM.entity.headQ.report.HeadQStatisticReportItem;

public class HeadQStatisticReportItemSumSorter  implements
Comparator<HeadQStatisticReportItem> {

	@Override
	public int compare(HeadQStatisticReportItem arg0, HeadQStatisticReportItem arg1) {

		Brand brand0 = arg0.getBrand();
		Brand brand1 = arg1.getBrand();
		
		Year year0 = arg0.getYear();
		Year year1 = arg1.getYear();
		
		Quarter quarter0 = arg0.getQuarter();
		Quarter quarter1 = arg1.getQuarter();
		
		
		if (year0.getYear_ID() != year1.getYear_ID()){
			return year0.getYear_ID() - year1.getYear_ID();
		} else if (quarter0.getQuarter_ID() != quarter1.getQuarter_ID()){
			return quarter0.getQuarter_ID() - quarter1.getQuarter_ID();
		} else {

			return brand0.getBrand_ID() - brand1.getBrand_ID();
		}
	}

}
