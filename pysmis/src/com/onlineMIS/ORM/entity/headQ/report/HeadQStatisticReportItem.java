package com.onlineMIS.ORM.entity.headQ.report;

import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Brand;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.ProductBarcode;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Quarter;
import com.onlineMIS.ORM.entity.headQ.barcodeGentor.Year;

public class HeadQStatisticReportItem {
	
	protected ProductBarcode pb = new ProductBarcode();
	protected Year year = new Year();
	protected Quarter quarter = new Quarter();
	protected Brand brand = new Brand();

	public ProductBarcode getPb() {
		return pb;
	}

	public void setPb(ProductBarcode pb) {
		this.pb = pb;
	}

	public Brand getBrand() {
		return brand;
	}

	public void setBrand(Brand brand) {
		this.brand = brand;
	}

	public Year getYear() {
		return year;
	}

	public void setYear(Year year) {
		this.year = year;
	}

	public Quarter getQuarter() {
		return quarter;
	}

	public void setQuarter(Quarter quarter) {
		this.quarter = quarter;
	}

	
	
}
