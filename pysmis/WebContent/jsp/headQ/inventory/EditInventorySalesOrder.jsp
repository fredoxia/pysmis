<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><s:property value="formBean.order.order_type_ws"/> <s:property value="formBean.order.order_Status_s"/></title>
<%@ include file="../../common/Style.jsp"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/inventory-order.js?v=5-26"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/HtmlTable.js"></script>
<script type="text/javascript" src=<%=request.getContextPath()%>/conf_files/js/print/pazuclient.js></script>
<script type="text/javascript" src=<%=request.getContextPath()%>/conf_files/js/print/InventoryPrint.js?v=5-27></script>
<script type="text/javascript">
var baseurl = "<%=request.getContextPath()%>";


//the index is depends on the preview or not
<s:if test="formBean.isPreview == true">
index = parseInt("<s:property value='formBean.order.product_List.size()'/>");
</s:if><s:else>
index = parseInt("<s:property value='formBean.order.product_Set.size()'/>");
</s:else>

function saveToDraft(){
	calculateTotal();
	
	var error = validateForm();
			
	if (error != ""){
		$.messager.alert('错误', error, 'error');
	}else{
		$("#barcode" + index).val("");
	    recordSubmit();
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
	   document.inventoryOrderForm.action = "inventoryOrder!saveToDraft";
	   document.inventoryOrderForm.submit();
	}
}

/**
 * once acct finish the edit and save
 */
function save(){
	calculateTotal();
	
	 var error = validateForm();
	
	if (error != ""){
		$.messager.alert('错误', error, 'error');
	}else{
		$("#barcode" + index).val("");
	    recordSubmit();
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		document.inventoryOrderForm.action = "<%=request.getContextPath()%>/action/inventoryOrder!acctSave";
		document.inventoryOrderForm.submit();
	}
}

/**
 * button to preview the order
 */
function preview(){
	calculateTotal();
	if (validateForm()){
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		   document.inventoryOrderForm.action = "<%=request.getContextPath()%>/action/inventoryOrder!previewOrder";
		   document.inventoryOrderForm.submit();
	}
}

/**
 * 提交并打印价格单据
 */
function submitOrder(){
	calculateTotal();
	
	var error = validateForm();
			
	if (error != ""){
		$.messager.alert('错误', error, 'error');
	}else{
		$("#barcode" + index).val("");
	    recordSubmit();
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		 
		var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!save";
		 var params=$("#inventoryOrderForm").serialize();  
		 $.post(url,params, saveOrderBackProcess,"json");	
	}

}
function saveOrderBackProcess(data){
    var response = data;
	var returnCode = response.returnCode;

	if (returnCode != SUCCESS)
		$.messager.alert('获取单据失败', response.message, 'error');
	else {
        var returnValue = response.returnValue;
        var inventoryOrder = returnValue.inventoryOrder;
       
        if (inventoryOrder != null && inventoryOrder != ""){
        	printContent(inventoryOrder, true);
        	printContent(inventoryOrder, true);
        }
        setTimeout(function(){ window.location.href = "<%=request.getContextPath()%>/action/inventoryOrder!create";}, 3000);
        
	}
 }
 
/**
 * 提交并打印数量单据
 */
function submitOrderQ(){
	calculateTotal();
	
	var error = validateForm();
			
	if (error != ""){
		$.messager.alert('错误', error, 'error');
	}else{
		$("#barcode" + index).val("");
	    recordSubmit();
		$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
		 
		var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!save";
		 var params=$("#inventoryOrderForm").serialize();  
		 $.post(url,params, saveOrderBackProcessQ,"json");	
	}

}
function saveOrderBackProcessQ(data){
    var response = data;
	var returnCode = response.returnCode;

	if (returnCode != SUCCESS)
		$.messager.alert('获取单据失败', response.message, 'error');
	else {
        var returnValue = response.returnValue;
        var inventoryOrder = returnValue.inventoryOrder;
       
        if (inventoryOrder != null && inventoryOrder != ""){
        	printContent(inventoryOrder, false);
        	printContent(inventoryOrder, false);
        }
        setTimeout(function(){ window.location.href = "<%=request.getContextPath()%>/action/inventoryOrder!create";}, 3000);
        
	}
 }


function printPOSOrder(){
	var orderId = $("#orderId").val()
	if (orderId == 0){
		$.messager.alert('操作失败', '请保存单据之后再打印配货单', 'error');
	} else {

		$.messager.confirm('打印确认', '请确认，你在打印pos小票配货单前 没有修改单据 或者已经保存了修改项目', function(r){
			if (r){
	            printPOSOrderToPrinter();	
	
			}
		});
	}

}

function exportBarcodeToExcel(){
	var url = "<%=request.getContextPath()%>/action/exportInventoryOrToExcel!ExportJinSuanOrder";

	var msg = "请确认，你在下载订单条码前 没有修改单据 或者已经保存了修改项目";
	$.messager.confirm('导出单据确认', msg, function(r){
		if (r){
			   document.inventoryOrderForm.action = url;
			   document.inventoryOrderForm.submit();	

		}
	});

}
function exportOrderToExcel(){
	var url = "<%=request.getContextPath()%>/action/exportInventoryOrToExcel.action";
	document.inventoryOrderForm.action = url;
	document.inventoryOrderForm.submit();	
}
/**
 * 选择customer之后，更新preAcct
 */
function chooseClient(clientId, preAcct){
	$("#preAcct").val(preAcct);
	calculatePostAcct();
	
	self.parent.updateTabName("批发销售单据 " + clientId);
}

$(document).ready(function(){
	var id = "";
	var orderId = $("#orderId").val();
	if (orderId != 0)
		id = orderId;
	else {
	var clientId = $("#clientID").val();
    if (clientId != 0)
    	id= clientId;
	}
	self.parent.updateTabName("批发销售单据 " + id);
	
	
	$("#clientName").focus();
	parent.$.messager.progress('close'); 
	jQuery.excel('excelTable');
	$("#org_table tr").mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
	calculateCasher();
});


</script>

</head>
<body>

<s:form action="/action/inventoryOrder!previewOrder" method="POST" name="inventoryOrderForm"  id="inventoryOrderForm" theme="simple" enctype="multipart/form-data">
 <s:hidden name="formBean.order.order_ID"  id="orderId"/>
 <s:hidden name="formBean.order.order_type" id="orderType"/>
 <s:hidden name="formBean.order.order_Status"/>
 <s:hidden name="formBean.order.importTimes"/>
 <s:hidden name="formBean.order.pdaScanner.user_id"/>
 <table cellpadding="0" border="0" cellspacing="0"  style="width: 98%" align="center" class="OuterTable">
	<tr class="title">
	     <td colspan="7"><s:if test="formBean.isPreview == true">预览</s:if>
	     <s:if test="formBean.order.order_type == 1">
	          <font style="color:red"><s:property value="formBean.order.order_type_ws"/> </font>
	     </s:if><s:else>
	     	  <s:property value="formBean.order.order_type_ws"/>
	     </s:else>
	     <s:property value="formBean.order.order_Status_s"/></td>
	</tr>
    
	<tr height="10">
	     <td colspan="7"><hr/></td>
	</tr>

	<%@ include file="../include/EditInventorySalesOrderDetail.jsp"%>
    <s:if test="formBean.isPreview == true">
      <tr height="10">
	  	     <td>&nbsp;</td>
			 <td>
			      <a id="btn1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-database'" onclick="importFile();">导入文件</a>&nbsp;
			 	  <a href="javascript:void(0)" id="mb" class="easyui-menubutton" data-options="iconCls:'icon-save',menu:'#mm',plain:false,onClick:submitOrder">单据提交</a>
					<div id="mm" style="width:150px;">
					    <div data-options="iconCls:'icon-save',name:'price'" onclick="javascript:submitOrder()">打印价格单</div>
					    <div data-options="iconCls:'icon-save',name:'quantity'" onclick="javascript:submitOrderQ()">打印数量单</div>
					</div>
			 
			 </td>			 					 		
			 <td>&nbsp;</td>
			 <td><input type="button" value="存入草稿" onclick="saveToDraft();"/><input type="button" value="重新计算" onclick="calculateTotal();"/></td>			 					 		
			 <td>排序<input type="checkbox" name="formBean.sorting" value="true"/></td>			 					 		
			 <td></td>
			 <td>&nbsp;</td>	
	  </tr>
    </s:if><s:elseif test="formBean.order.order_Status==0">
	  <tr height="10">
	  	     <td>&nbsp;</td>
			 <td><a id="btn1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-database'" onclick="importFile();">导入文件</a>&nbsp; 
			 	  <a href="javascript:void(0)" id="mb" class="easyui-menubutton" data-options="iconCls:'icon-save',menu:'#mm',plain:false,onClick:submitOrder">单据提交</a>
					<div id="mm" style="width:150px;">
					    <div data-options="iconCls:'icon-print',name:'price'" onclick="javascript:submitOrder()">打印价格单</div>
					    <div data-options="iconCls:'icon-print',name:'quantity'" onclick="javascript:submitOrderQ()">打印数量单</div>
					</div>			 
			 </td>			 					 		
			 <td>&nbsp;</td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveToDraft();">存入草稿</a>
			 <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-sum'" onclick="calculateTotal();">重新计算</a></td>			 					 		
			 <td>排序<input type="checkbox" name="formBean.sorting" value="true"/></td>			 					 		
			 <td></td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="printPOSOrder();">打印小票配货</a></td>	
	  </tr>
	</s:elseif><s:elseif test="formBean.order.order_Status==9">
	  <tr height="10">
	  	     <td>&nbsp;</td>
			 <td><a id="btn1" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-database'" onclick="importFile();">导入文件</a>&nbsp;
			     	<a href="javascript:void(0)" id="mb" class="easyui-menubutton" data-options="iconCls:'icon-save',menu:'#mm',plain:false,onClick:submitOrder">单据提交</a>
					<div id="mm" style="width:150px;">
					    <div data-options="iconCls:'icon-print',name:'price'" onclick="javascript:submitOrder()">打印价格单</div>
					    <div data-options="iconCls:'icon-print',name:'quantity'" onclick="javascript:submitOrderQ()">打印数量单</div>
					</div>
			 </td>			 					 		
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="exportBarcodeToExcel();">条码标签导出</a></td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveToDraft();">存入草稿</a><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-sum'" onclick="calculateTotal();">重新计算</a></td>			 					 		
			 <td>排序<input type="checkbox" name="formBean.sorting" value="true"/></td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="deleteOrder();">删除单据</a></td>			 					 		
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="exportOrderToExcel();">订单导出到Excel</a><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="printPOSOrder();">打印小票配货</a></td>	
	  </tr>
	</s:elseif><s:elseif test="#session.LOGIN_USER.containFunction('inventoryOrder!acctUpdate') || #session.LOGIN_USER.roleType == 99">
	  <tr height="10">
	         <td>&nbsp;</td>
	  	     <td>&nbsp;</td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="exportBarcodeToExcel();">条码标签导出</a></td>			 					 		
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-sum'" onclick="calculateTotal();">重新计算</a></td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save();">保存</a></td>			 					 					 					 		
			 <td style="width: 18%">排序<input type="checkbox" name="formBean.sorting" value="true"/></td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="exportOrderToExcel();">订单导出到Excel</a><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="printPOSOrder();">打印小票配货</a></td>	
	  </tr>				 		      
	</s:elseif>
	  <tr height="10">
	     <td colspan="7"><s:fielderror/></td>
	  </tr>  
</table>

</s:form>

</body>
</html>