<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><s:property value="formBean.order.typeS"/> <s:property value="formBean.order.statusS"/></title>
<%@ include file="../../../common/Style.jsp"%>

<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/HtmlTable.js"></script>
<script type="text/javascript">
var baseurl = "<%=request.getContextPath()%>";

var index = 0;

function BSkeyDown(e){

	 var ieKey = event.keyCode;

	 if (ieKey==13){
	   if (event.srcElement.id == "supplierName"){
		   searchSupplier(); 
		   event.returnValue=false;
	   } else if (event.srcElement.id =="barcodeInput"){
	       var barcodeInput =$("#barcodeInput");

	       event.returnValue=false;
	       retrieveProductByBarcode("","",barcodeInput.val(),"");

	   } else if (event.srcElement.id =="productCodeInput"){

		   event.returnValue=false;
		   
		   searchProductsProductCode(index);
 	   } else if (event.srcElement.id.substring(0,8)=="quantity"){
 		   $("#productCodeInput").focus();
	   } else
		   event.returnValue=false; 
	 }  else if (ieKey==8){
		    if((event.srcElement.tagName.toLowerCase() == "input" && event.srcElement.readOnly != true) || event.srcElement.tagName.toLowerCase() == "textarea"){
		        event.returnValue = true; 
		    } else
		    	event.returnValue = false;
	 } 
} 

document.onkeydown = BSkeyDown; 

/**
 * user input the product code and press enter
 */
function searchProductsProductCode(index_trigger){

	var productCode = $("#productCodeInput").val();

	if (validateProductCodeInput(productCode)){
	    var params= "formBean.productBarcode.product.productCode=" + productCode + "&formBean.indexPage=" + index_trigger + "&formBean.fromSrc=1"; 
	    
	    var url = encodeURI(encodeURI("productJSPAction!scanByProductCode?" +params));
		
	    window.open(url,'新窗口','height=570, width=630, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');    
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
 * just override the function
 */
function validateRowInputFromChild(currentBarcode){
	return true;
}

function retrieveProductByBarcode(index_trigger, suffix ,currentBarcode, fromSrc){

	var supplierId = $("#supplierId").val();	
	var orderType = $("#orderType").val();
	
    var params= "formBean.pb.barcode=" + currentBarcode + "&formBean.supplier.supplierId=" + supplierId + "&formBean.indexPage=" + index +"&formBean.order.type=" + orderType+"&formBean.fromSrc=" + fromSrc ; 

    $.post("supplierPurchaseJSON!scanByBarcodePurchaseOrder",params, backProcess,"json");

}

function backProcess(data){
	var returnCode = data.returnCode;
	
	if (returnCode == SUCCESS){
		var barcode = data.barcode;
		var preIndex = data.index;
		var orderType = data.orderType;
	
		addNewRow(barcode);
		
		calculateTotal();
		
		var where = data.where;
		if (where == 1){
			var indexB= index - 1;
			$("#productCodeInput").attr("value","");
			$("#quantity" + indexB).focus();
		} else {
			$("#barcodeInput").attr("value","");
			$("#barcodeInput").focus();
		}
	} else {
		alert(data.msg);
		$("#barcodeInput").attr("value","");
		$("#barcodeInput").focus();
	}
}


function calculateTotal(){
	 var totalQ = 0;
	 var totalRecCost = 0;
//	 var totalWholePrice = 0;
	 
	 for (var i =0; i < index; i++){
		 var quantityInputs = $("#quantity" + i).val();
		 var recCostInputs = $("#recCost" + i).val();
		 var wholeSalePriceInputs = $("#wholeSalePrice" + i).val();
		 
		 if (quantityInputs != undefined){
			 totalQ = totalQ + parseInt(quantityInputs);
		 } 

		 if (quantityInputs != undefined && recCostInputs != undefined && recCostInputs !=""){
			 totalRecCost = totalRecCost + parseInt(quantityInputs)*parseFloat(recCostInputs);
		 } 
//		 if (quantityInputs != undefined && wholeSalePriceInputs != undefined && wholeSalePriceInputs !=""){
//			 totalWholePrice = totalWholePrice + parseInt(quantityInputs)*parseFloat(wholeSalePriceInputs);
//		 } 
	 }
	 
	 $("#totalQuantity").attr("value",totalQ);
	 $("#totalRecCost").attr("value",(totalRecCost).toFixed(2));
}


function deleteRow(rowID, delIndex){

	var msg = "你确定要删除第" + (delIndex + 1) + "行 ";
	
	$("#row" + delIndex).css('background-color', '#99CC00');
	if (confirm(msg)){	
		$("#"+rowID).remove(); 
		
		calculateTotal(); 
	} else {
		$("#row" + delIndex).css('background-color', '');
	}
	
	$("#productCodeInput").focus();
}

function addNewRow(barcode){
	indexB = index
    var str = "";
    str += "<tr height='22' id='row"+ indexB + "' class='excelTable' align='center'>";

    str += "<td align='center'>" + (indexB+1) +"</td>";
    str += "<td>"+barcode.barcode +"<input type='hidden' name='formBean.order.productList["+indexB+"].pb.id' id='productId"+indexB+"' value='"+ barcode.id+"'/></td>";		 					 		
    str += "<td>"+barcode.product.year.year+"</td>";	
    str += "<td>"+barcode.product.quarter.quarter_Name+"</td>";	
    str += "<td>"+barcode.product.brand.brand_Name+"</td>";		
    str += "<td>"+barcode.product.productCode+"</td>";
       
	var color = barcode.color;
	var colorName = "";
	if (color != null && color != undefined && color.name!=undefined)
		colorName = color.name; 
    str += "<td>" + colorName+"</td>";	
    str += "<td>"+barcode.product.unit+"</td>"; 					 		
    str += "<td><input type='text' name='formBean.order.productList["+indexB+"].quantity' id='quantity"+indexB+"' value='"+barcode.product.numPerHand+"' size='2'  onchange='onQuantityChange();'  onfocus='this.select();'/>  </td>";
    str += "<td><input type='text' name='formBean.order.productList["+indexB+"].recCost' id='recCost"+indexB+"' value='"+barcode.product.recCost+"' size='4'  readonly/>  </td>";
    str += "<td>"+barcode.product.wholeSalePrice+"</td>";
    str += "<td><img src='"+baseurl+"/conf_files/web-image/delete.png' border='0' onclick='deleteRow(\"row"+indexB +"\","+indexB+")' style='cursor:pointer;'/></td>";
    str += "<td></td>";			 		
    str += "</tr>";
    
    $("#inventoryTable").append(str);

    $("#row"+ indexB).bind('keyup',onkeyup);
    
	$("#row"+ indexB).mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
	
	index++;
}

function validateForm(){
   	for (var i =0; i < index; i++)
   		$("#row" + i).css('background-color', '');
   	
	var error = "";
	if ($("#supplierName").val() == "" || $("#supplierId").val() == 0){
		error += "供应商名字 - 必须填!\n";
		$("#supplierName").focus();
	}


	if ($("#counterId").val() == 0){
		error += "点数人员 - 必须选!\n";
		$("#counterId").focus();
	}

	if ($("#totalQuantity").val() <= 0){
		error += "必须录入数据后才能提交\n";
	}
	var totalDiscount = $("#totalDiscount").val();
	if (isNaN(totalDiscount) || totalDiscount < 0){
		error += "优惠 - 必须是大于或者等于0的数字!\n";
	}

	var hasChar = false;
	var hasChar_r = false;
	var invalid_barcode = false;
	for (var i =0; i < index; i++){

		var q = $("#quantity" + i).val();
		var r = $("#recCost" + i).val();
		var pbId = $("#productId" + i).val();

		if (q != undefined){
			if (isNaN(q) || q<=0){
				$("#row" + i).css('background-color', '#EE8553');
				hasChar = true;
			}
		}
		if (r != undefined){
			if (isNaN(r) || r<=0 || r=='Infinity'){
				$("#row" + i).css('background-color', '#EE8553');
				hasChar_r = true;
			}
		}

		if (pbId != undefined){
			if (isEmpty(pbId) || pbId == 0){
				$("#row" + i).css('background-color', '#EE8553');
				invalid_barcode = true;
			}
		}
	}

	if (hasChar)
		error += "数量 - 必须为大于0数字!\n";
	if (hasChar_r)
		error += "采购进价 - 必须为大于0数字!\n";	

	if (invalid_barcode)
		error += "条码错误 - 货品条码无法找到,请删除再从新扫描!\n";	
	
	if (error != ""){
		alert(error);
		return false;
	}else{
		return true;
	}
}

/**
 * 数量改变
 */
function onQuantityChange(){
	calculateTotal();
}


function deleteOrder(){
	$.modalDialog({
		title : '授权删除单据',
		width : 330,
		height : 180,
		modal : true,
		href : baseurl +'/jsp/headQ/inventory/ConfirmDelete.jsp',
		buttons : [ {
			text : '授权删除',
			handler : function() {
				confirmDelete(); 
			}
		} ]
		});
}

index = parseInt("<s:property value='formBean.order.productList.size()'/>");

function saveToDraft(){
	calculateTotal();
	
	if (validateForm()){
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		var params = $("#purchaseOrderForm").serialize();  
		$.post("<%=request.getContextPath()%>/action/supplierPurchaseJSON!saveToDraft",params, draftOrderBKProcess,"json");
	}
}
function draftOrderBKProcess(data){
	var response = data;

	var returnCode = response.returnCode;
	var returnMsg = response.message;
	if (returnCode == SUCCESS){		   
		alert("成功保存草稿");
		window.location.href = "supplierPurchaseJSP!preEditPurchase";
	} else {
		$.messager.progress('close'); 
        alert(returnMsg);
    }
}


/**
 * to submit the order to account
 */
function submitOrder(){
	calculateTotal();
	if (validateForm()){
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		var params = $("#purchaseOrderForm").serialize();  
		$.post("<%=request.getContextPath()%>/action/supplierPurchaseJSON!saveToComplete",params, submitOrderBKProcess,"json");
	}
}
function submitOrderBKProcess(data){
	var response = data;

	var returnCode = response.returnCode;
	var returnMsg = response.message;
	if (returnCode == SUCCESS){		   
		alert("单据成功过账");
		window.location.href = "supplierPurchaseJSP!preEditPurchase";
	} else {
		$.messager.progress('close'); 
        alert(returnMsg);
    }
}

$(document).ready(function(){
	$("#supplierName").focus();
	parent.$.messager.progress('close'); 
	jQuery.excel('excelTable');
	$("#org_table tr").mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
});
</script>

</head>
<body>

<s:form action="/action/inventoryOrder!previewOrder" method="POST" name="purchaseOrderForm"  id="purchaseOrderForm" theme="simple" enctype="multipart/form-data">
 <s:hidden name="formBean.order.id"  id="orderId"/>
 <s:hidden name="formBean.order.type" id="orderType"/>
 <s:hidden name="formBean.order.status"/>

 <table cellpadding="0" border="0" cellspacing="0"  style="width: 98%" align="center" class="OuterTable">
	<tr class="title">
	     <td colspan="7">
	     <s:if test="formBean.order.type == 1">
	          <font style="color:red"><s:property value="formBean.order.typeS"/> </font>
	     </s:if><s:else>
	     	  <s:property value="formBean.order.typeS"/>
	     </s:else>
	     <s:property value="formBean.order.statusS"/></td>
	</tr>
    
	<tr height="10">
	     <td colspan="7"><hr/></td>
	</tr>

		<tr>	
	   <td colspan="7">
			<table cellpadding="0" cellspacing="0" style="width: 100%" border="0" id="org_table">
			 	<tr class="PBAOuterTableTitale" align="left">
			 		<th>&nbsp;</th>
			 		<th colspan="10">供应商名字&nbsp;:&nbsp;<%@ include file="../SupplierInput.jsp"%>货品点数&nbsp; :&nbsp;<s:select name="formBean.order.orderCounter.user_id" id="counterId"  list="uiBean.users" listKey="user_id" listValue="user_name" headerKey="0" headerValue="" />	</th>
			 		<th colspan="2">订单号&nbsp;:&nbsp;<s:property value="formBean.order.id"/> </th>	 
			 	</tr>
			    <tr height="10">
	  	            <th colspan="13"></th>
	            </tr>
			 	<tr class="PBAOuterTableTitale" align="left">
			 		<th>&nbsp;</th>
			 		<th colspan="5">按条码查找&nbsp;:&nbsp;<input type="text" id="barcodeInput"/> &nbsp;货号查找&nbsp;:&nbsp;<input type="text" id="productCodeInput"/> </th>		 					 				 					 		
			 		<th colspan="5" align="left"></th>	
			 		<th colspan="2"></th>							 		
			 	</tr>
				<tr height="10">
					<th colspan="15"></th>
				</tr>	
				<tr height="10">
					<th colspan="15"></th>
				</tr>							 	
			 	<tr class="PBAOuterTableTitale" height="22">
		 		    <th style="width: 6%">&nbsp;</th>
			 		<th style="width: 9%">条型码</th>	
			 		<th style="width: 4%">年份</th>	
			 		<th style="width: 4%">季度</th>	
			 		<th style="width: 10%">产品品牌</th>				 				 					 				 		
			 		<th style="width: 8%">产品货号</th>
			 		<th style="width: 4%">颜色</th>
			 		<th style="width: 5%">单位</th>	
			 		<th style="width: 4%">数量</th>	
			 		<th style="width: 5%">进价(单价)</th>
			 		<th style="width: 8%">批发价(单价)</th>
			 		<th style="width: 6%">&nbsp;</th>	
			 		<th style="width: 6%"></th> 		 		
                </tr>
                <tbody  id="inventoryTable">
	                <s:iterator value="formBean.order.productList" status = "st" id="orderProduct" >
					 	<tr id="row<s:property value="#st.index"/>"  class="excelTable" align="center">
					 		<td align="center"><s:property value="#st.index +1"/></td>
					 		<td><s:property value="#orderProduct.pb.barcode"/>
					 		    <input type="hidden" name="formBean.order.productList[<s:property value="#st.index"/>].pb.id" id="productId<s:property value="#st.index"/>" readonly="readonly" value="<s:property value="#orderProduct.pb.id"/>"/></td>			 					 		
					 		<td><s:property value="#orderProduct.pb.product.year.year"/></td>
					 		<td><s:property value="#orderProduct.pb.product.quarter.quarter_Name"/></td>			
					 		<td><s:property value="#orderProduct.pb.product.brand.brand_Name"/></td>			 		
					 		<td><s:property value="#orderProduct.pb.product.productCode"/> <s:property value="#orderProduct.pb.product.numPerHand"/></td>
					 		<td><s:property value="#orderProduct.pb.color.name"/></td>			 		
					 		<td><s:property value="#orderProduct.pb.product.unit"/></td>	
					 		<td><input type="text" name="formBean.order.productList[<s:property value="#st.index"/>].quantity" id="quantity<s:property value="#st.index"/>" size='2' onchange="onQuantityChange();" onfocus="this.select();" value="<s:property value="#orderProduct.quantity"/>"/></td>
					 		<td><input type="text" name="formBean.order.productList[<s:property value="#st.index"/>].recCost" id="recCost<s:property value="#st.index"/>" size='2' readonly onfocus="this.select();" value="<s:property value="#orderProduct.recCost"/>"/></td>		 					 		
					 		<td><s:property value="#orderProduct.wholeSalePrice"/></td>			 							 		
					 		<td><div id="delIcon0" style="display:block"><img src="<%=request.getContextPath()%>/conf_files/web-image/delete.png" border="0" onclick="deleteRow('row<s:property value="#st.index"/>',<s:property value="#st.index"/>);"  style="cursor:pointer;"/></div></td>
					 		<td></td>				
		                </tr>
	                </s:iterator>
                </tbody>
                <tr class="PBAOuterTableTitale" height="22" align="center">
			 		<td align ="center">总计</td>		 					 		
			 		<td></td>
			 		<td></td>	
			 		<td></td>
			 		<td></td>	
			 		<td></td>	
			 		<td></td>		 					 		
			 		<td></td>			 					 		
			 		<td><s:textfield name="formBean.order.totalQuantity" id="totalQuantity" readonly="true" size='2'/></td>
			 		<td><s:textfield name="formBean.order.totalRecCost" id="totalRecCost" size='8' readonly="true"/></td>
			 		<td>&nbsp;</td>	
			 		<td>&nbsp;</td>	
			 		<td>&nbsp;</td>		 		
                </tr>
                <tr height="10">
			         <td colspan="13" align="left"></td>			 					 		
	            </tr>
				<tr height="10" class="InnerTableContent" >
				  	 <td align ="center">备注</td>
					 <td colspan="12"><textarea name="formBean.order.comment" id="comment" rows="1" cols="80"><s:property value="formBean.order.comment"/></textarea></td>			 					 				 					 		
				</tr>
                <tr class="InnerTableContent">
                  <td height="27" align="center">优惠</td>
                  <td colspan="2"><s:textfield name="formBean.order.totalDiscount" id="totalDiscount"/></td>
                  <td colspan="3"></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
		 </table>
	     </td>
	  </tr>
      <tr height="10">
	  	     <td>&nbsp;</td>
			 <td><input type="button" onclick="submitOrder();" value="单据提交"/></td>			 					 		
			 <td></td>
			 <td><input type="button" value="存入草稿" onclick="saveToDraft();"/></td>			 					 		
			 <td></td>
			 <td><input type="button" value="删除订单" onclick="deleteOrder();"/></td>			 					 		
			 <td></td>	
	  </tr>

	  <tr height="10">
	     <td colspan="7"><s:fielderror/></td>
	  </tr>  
</table>

</s:form>

</body>
</html>