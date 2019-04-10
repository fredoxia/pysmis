<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<script>
/**
 * user input the product code and press enter
 */
function searchProductsProductCode(){
	var productCode = $("#productCode").val();

	if (validateProductCodeInput(productCode)){
		var params= "formBean.productBarcode.product.productCode=" + productCode+ "&formBean.fromSrc=1" ; 
	    
	    var url = encodeURI(encodeURI("action/productJSPAction!scanByProductCodeHeadq?" + params))  ; 
	
	    window.open(url,'新窗口','height=510, width=600, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');    
	}
}

/**
 * to validate the product code input
 */
function validateProductCodeInput(productCode){
	if (productCode.length <= 1){
       alert("输入的货号太短");
       return false;
	}
	return true;
}
/**
 * retrieve the product by input barcode
 */
function retrieveProductByBarcode(index_trigger, suffix, currentBarcode){
	var params= "formBean.productBarcode.barcode=" + currentBarcode; 
	$.post("productJSONAction!search",params, backRetrievePByBarcodeProcess,"json");

}
function backRetrievePByBarcodeProcess(data){
	var barcodes = data.barcodes;
	  if (barcodes.length != 0){			
			var barcode = barcodes[0].barcode;
			var productId = barcodes[0].id;
			var product = barcodes[0].product;
			
			var productCode = product.productCode;
			var brand = product.brand.brand_Name;
			var color = barcodes[0].color;

			var colorName = "";
			if (color != null && color.name != null)
	    		colorName = color.name;
			var productInfor = barcode  + " " + brand + " " + productCode + " " + colorName;
			var originalProduct = $("#productInfo").html();
			if (originalProduct == "")
				originalProduct = productInfor;
			else 
				originalProduct = originalProduct + "<br>" + productInfor;
			$("#productInfo").html(originalProduct);
			
			var productIds = $("#productId").val();
			if (productIds == "")
				productIds = productId;
			else 
				productIds = productIds + "," + productId;
			$("#productId").val(productIds);
	  } else {
		  alert("无法找到对应货品.请检查，重新输入!");
	  }

}
function validateRowInputFromChild(index_trigger,suffix, currentBarcode){
	return true;
}
function clearSearch(){
	$("#productInfo").html("");
	$("#productCode").val("");
	$("#productId").val("");
}
</script>
		<s:hidden name="formBean.productIds" id="productId" value=""/>
		<s:textfield name="formBean.productCode" id="productCode" size="18"/><input type="button" id="checkBrandBt" value="查找货号" onclick="searchProductsProductCode();"/><input type="button" id="clearBtn" value="清除" onclick="clearSearch();"/>
		
