<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.ORM.entity.headQ.user.UserInfor,com.onlineMIS.ORM.entity.headQ.inventory.*" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><s:property value="formBean.order.order_type_ws"/></title>
<%@ include file="../../common/Style.jsp"%>
<script type="text/javascript" src=<%=request.getContextPath()%>/conf_files/js/print/pazuclient.js></script>
<script type="text/javascript" src=<%=request.getContextPath()%>/conf_files/js/print/InventoryPrint.js?v=5-42></script>
<script type="text/javascript">


function exportOrderToExcel(){
	var url = "<%=request.getContextPath()%>/action/exportInventoryOrToExcel.action";
	document.inventoryOrderForm.action = url;
	document.inventoryOrderForm.submit();	
}
function exportBarcodeToExcel(){
	var url = "<%=request.getContextPath()%>/action/exportInventoryOrToExcel!ExportJinSuanOrder";
	document.inventoryOrderForm.action = url;
	document.inventoryOrderForm.submit();	
}

function completeAuditOrder(){
	var info = "你确定完成了单据的审核?";
	$.messager.confirm('单据审核确认', info, function(r){
		if (r){
			var url = "<%=request.getContextPath()%>/action/inventoryOrder!acctAuditOrder";
			document.inventoryOrderForm.action = url;
			document.inventoryOrderForm.submit();	
		}
	});

}
function edit(){
	var url = "<%=request.getContextPath()%>/action/inventoryOrder!acctUpdate";
	document.inventoryOrderForm.action = url;
	document.inventoryOrderForm.submit();	
}
function cancelOrder(){
	var info = "你确定红冲此单据?";
	$.messager.confirm('单据红冲确认', info, function(r){
		if (r){
		    var url = "<%=request.getContextPath()%>/action/inventoryOrder!cancelOrder";
		    document.inventoryOrderForm.action = url;
		    document.inventoryOrderForm.submit();	
		}
	});
}
function updateOrderComment(){
    var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!updateOrderComment";
    var params=$("#inventoryOrderForm").serialize();  
    $.post(url,params, updateOrderCommentBackProcess,"json");	
}
function updateOrderCommentBackProcess(data){
	var returnValue = data.returnCode;
	if (returnValue == SUCCESS)
	    $.messager.alert('消息', data.message, 'info');
	else 
		$.messager.alert('操作失败', data.message, 'error');
}

function copyOrder(){
	var info = "你确定复制此单据?";
	if (confirm(info)){	
	    var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!copyOrder";
	    var params=$("#inventoryOrderForm").serialize();  
	    $.post(url,params, copyOrderBackProcess,"json");	
	}	
}
function copyOrderBackProcess(data){
    var response = data.response;
	var returnCode = response.returnCode;
	if (returnCode != SUCCESS)
	    $.messager.alert('复制单据失败', response.message, 'error');
	else {
        $.messager.alert('复制单据成功', "复制单据成功,单据号 " + response.returnValue, 'error');
    }
		
}
function deleteOrder(){
	$.modalDialog({
		title : '授权删除单据',
		width : 330,
		height : 180,
		modal : true,
		href : '<%=request.getContextPath()%>/jsp/headQ/inventory/ConfirmDelete.jsp',
		buttons : [ {
			text : '授权删除',
			handler : function() {
				confirmDelete(); 
			}
		} ]
		});
}

function printOrder(wholePrice){
	 var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!printOrder";
	 var params=$("#inventoryOrderForm").serialize();  
	 if (wholePrice)
	    $.post(url,params, printOrderBackProcess,"json");	
	 else 
		 $.post(url,params, printOrderQuantityBackProcess,"json");	
}	


		
$(document).ready(function(){
	parent.$.messager.progress('close'); 
	$("#org_table tr").mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
});
</script>

</head>
<body>

<s:form action="" method="POST" id="inventoryOrderForm"  name="inventoryOrderForm">
<s:hidden name="formBean.order.order_ID" id="orderId"/>
 <table cellpadding="0" cellspacing="0"  style="width: 90%" align="center" class="OuterTable">
	<tr class="title">
	     <td colspan="7">
	     	     <s:if test="formBean.order.order_type == 1">
	          <font style="color:red"><s:property value="formBean.order.order_type_ws"/> </font>
	     </s:if><s:else>
	     	  <s:property value="formBean.order.order_type_ws"/>
	     </s:else>
	     -<s:property value="formBean.order.order_Status_s"/></td>
	</tr>
	<tr>	
	   <td colspan="7">
		<table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
			 	<tr class="InnerTableContent" align="left">
			 		<td width="5%">&nbsp;</td>
			 		<td colspan="2">客户名字&nbsp; :&nbsp;<s:property value="formBean.order.cust.name"/></td>			 					 				 					 				 					 		
			 		<td width="32%">仓库开始时间&nbsp; :&nbsp;<s:date name ="formBean.order.order_StartTime" format="yyyy-MM-dd hh:mm:ss" />  </td>
	 		        <td width="13%">订单号&nbsp; :&nbsp; <s:property value="formBean.order.order_ID"/> </td>
			 	</tr>
			 	<tr height="4">
					<td colspan="5"></td>
				</tr>
			 	<tr class="InnerTableContent" align="left">
			 		<td>&nbsp;</td>
	 		      <td width="20%">仓库录入人员&nbsp; :&nbsp; <s:property value="formBean.order.order_Keeper.name"/></td>	
			 		<td width="31%">仓库点数人员&nbsp; :&nbsp; <s:property value="formBean.order.order_Counter.name"/></td>		 					 				 		 							
			 		<td>仓库完成时间&nbsp; :&nbsp;<s:date name ="formBean.order.order_ComplTime" format="yyyy-MM-dd hh:mm:ss" /> </td>
					<td><s:if test="formBean.order.financeBillId != 0">
					         <a href='#' onclick='addTab3("financeHQJSP!getFHQ?formBean.order.id=<s:property value="formBean.order.financeBillId"/>","财务收款单<s:property value="formBean.order.financeBillId"/>")'> 财务收款单<s:property value="formBean.order.financeBillId"/></a>
					    </s:if>					
					</td>
			 	</tr>
				<tr height="4">
					<td colspan="5"></td>
				</tr>		
			 	<tr class="InnerTableContent" align="left">
			 		<td>&nbsp;</td>
			 		<td>单据扫描人员&nbsp; :&nbsp; <s:property value="formBean.order.order_scanner.name"/></td>	
			 		<td>单据审核人员&nbsp; :&nbsp; <s:property value="formBean.order.order_Auditor.name"/></td>		 					 				 					 			 					 		
			 		<td>单据完成时间&nbsp; :&nbsp;<s:date name ="formBean.order.order_EndTime" format="yyyy-MM-dd hh:mm:ss" /> </td>
					<td></td>
			 	</tr>
				<tr height="4">
					<td colspan="5"></td>
				</tr>
				<tr class="InnerTableContent" align="left">
			 		<td>&nbsp;</td>
			 		<td>上欠&nbsp; :&nbsp; <s:property value="formBean.order.preAcctAmt"/></td>	
			 		<td>下欠&nbsp; :&nbsp; <s:property value="formBean.order.postAcctAmt"/></td>		 					 				 					 			 					 		
			 		<td>优惠&nbsp; :&nbsp;<s:property value="formBean.order.totalDiscount"/></td>
					<td></td>
			 	</tr>
		 </table>
		 <table class="easyui-datagrid" style="height:550px"  data-options="singleSelect:true,border : false">			 	
			   <thead>
				 	<tr align="center" class="PBAOuterTableTitale" height="22">
				 		<th data-options="field:'1',width:40">序号</th>
				 		<th data-options="field:'2',width:90">条型码</th>	
				 		<th data-options="field:'3',width:100">产品品牌</th>			 					 		
				 		<th data-options="field:'4',width:90">产品货号</th>	
				 		<th data-options="field:'5',width:60">颜色</th>	
				 		<th data-options="field:'6',width:60">年份</th>
				 		<th data-options="field:'7',width:60">季度</th>	 				 		
				 		<th data-options="field:'8',width:60">单位</th>	
				 		<th data-options="field:'9',width:60">数量</th>		 		
	                    <th data-options="field:'10',width:60">原批发价</th>
	                    <th data-options="field:'11',width:60">折扣</th>
	                    <th data-options="field:'12',width:80">折后批发价</th>		
				 		<th data-options="field:'13',width:80">批发价汇总</th>		 		
	                </tr>
               </thead>
               <tbody>
                  <s:if test="formBean.order.product_List.size > 20">
	               	   <tr align="center"  height="10" class="InnerTableContent" >
				  	     <td>总数</td>
						 <td>&nbsp;</td>			 					 		
						 <td>&nbsp;</td>
						 <td>&nbsp;</td>			 					 		
						 <td>&nbsp;</td>	
						 <td>&nbsp;</td>			 					 		
						 <td>&nbsp;</td>		
						 <td>&nbsp;</td>	 					 		
						 <td><s:property value="formBean.order.totalQuantity"/></td>
						 <td>&nbsp;</td>
						 <td>&nbsp;</td>
						 <td></td>
						 <td><s:property value="formBean.order.totalWholePrice"/></td>
				        </tr>
			      </s:if>
               <s:iterator value="formBean.order.product_List" status = "st" id="order" >
				 	<tr>
				 		<td><s:property value="#st.index+1"/></td>
				 		<td><s:property value="#order.productBarcode.barcode"/></td>	
				 		<td><s:property value="#order.productBarcode.product.brand.brand_Name"/></td>			 					 		
				 		<td><s:property value="#order.productBarcode.product.productCode"/></td>	
				 		<td><s:property value="#order.productBarcode.color.name"/></td> 	
				 		<td><s:property value="#order.productBarcode.product.year.year"/></td>	
				 		<td><s:property value="#order.productBarcode.product.quarter.quarter_Name"/></td>	
				 		<td><s:property value="#order.productBarcode.product.unit"/></td>						 		
				 		<td><s:property value="#order.quantity"/>&nbsp;<s:if test="#order.moreThanTwoHan">*</s:if></td>
				 		<td><s:property value="#order.salePriceSelected"/></td>	
				 		<td><s:property value="#order.discount"/></td>	
				 		<td><s:property value="#order.wholeSalePrice"/></td>	
				 		<td><s:text name="format.price"><s:param value="#order.wholeSalePrice * #order.quantity"/></s:text></td>			 		
				 	</tr>
			 	</s:iterator>
			 	
			 	<tr align="center"  height="10" class="InnerTableContent" >
			  	     <td>总数</td>
					 <td>&nbsp;</td>			 					 		
					 <td>&nbsp;</td>
					 <td>&nbsp;</td>			 					 		
					 <td>&nbsp;</td>	
					 <td>&nbsp;</td>			 					 		
					 <td>&nbsp;</td>		
					 <td>&nbsp;</td>	 					 		
					 <td><s:property value="formBean.order.totalQuantity"/></td>
					 <td>&nbsp;</td>
					 <td>&nbsp;</td>
					 <td></td>
					 <td><s:property value="formBean.order.totalWholePrice"/></td>
			    </tr>
				</tbody>
		 </table>
	     </td>
	  </tr>
	  <tr height="10">
	  	     <td colspan="7"></td>
	  </tr>
	  <tr height="10" class="InnerTableContent" >
	  	     <td align="center"></td>
			 <td colspan="4">备注 : <textarea name="formBean.order.comment" id="comment" rows="1" cols="80"><s:property value="formBean.order.comment"/></textarea></td>			 					 				 					 		
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="updateOrderComment();">修改备注</a></td>
			 <td>&nbsp;</td>	
	  </tr>
	  <tr height="10" class="InnerTableContent" >
	  	     <td align="center"></td>
			 <td colspan="6">
			      现金 : <s:property value="formBean.order.cash"/>&nbsp;
			      银行 : <s:property value="formBean.order.card"/>&nbsp;
			      支付宝 : <s:property value="formBean.order.alipay"/>&nbsp;
			      微信 : <s:property value="formBean.order.wechat"/>
			 </td>	
	  </tr>
	  <tr height="10">
	  	     <td colspan="7"></td>
	  </tr>
	  <tr height="10">
	  	     <td>&nbsp;</td>
			 <td>
			     <!-- for user, 1. the order is not in Complete status, 2. the order status ==1 || 2 -->
				 <s:if test="#session.LOGIN_USER.containFunction('inventoryOrder!acctProcess')  && (formBean.order.order_Status==1  || formBean.order.order_Status==2)">

				     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="edit();">会计修改</a>
				 </s:if>
			 </td>			 					 		
			 <td colspan="2"> 
			     <!-- for user, 1. This order is completed (status == 2) 2. They have the authority to do export -->
				 
				 <!-- for user, 1. This order is completed (status == 2 || status==6) 2. They have the authority to do complete without import jinsuan -->
				 <s:if test="(#session.LOGIN_USER.containFunction('inventoryOrder!acctAuditOrder') && (formBean.order.order_Status==2 || formBean.order.order_Status == 6)) ">
				     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="completeAuditOrder();">完成单据审核</a>
				 </s:if>
				 
				 <!-- for user, 1. This order has been exported (status == 3) 2. They have the authority  -->
				 <s:if test="(#session.LOGIN_USER.containFunction('inventoryOrder!cancelOrder') && formBean.order.order_Status==3) ">
				     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'" onclick="cancelOrder();">红冲单据</a>
				 </s:if>
				 

				 <a href="javascript:void(0)" id="mb1" class="easyui-menubutton" data-options="iconCls:'icon-print',menu:'#mm',plain:false">打印单据</a>
					<div id="mm" style="width:150px;">
					    <div data-options="iconCls:'icon-print',name:'price'" onclick="javascript:printOrder(true)">打印价格单</div>
					    <div data-options="iconCls:'icon-print',name:'quantity'" onclick="javascript:printOrder(false)">打印数量单</div>
					</div>
			 </td>			 					 		
			 <td>
				 <s:if test="formBean.order.order_Status== 1 || formBean.order.order_Status==2 || formBean.order.order_Status==6  || formBean.order.order_Status==9">
				     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="deleteOrder();">删除单据</a>
				 </s:if> 
				 <s:if test="#session.LOGIN_USER.containFunction('inventoryOrderJSON!copyOrder') && formBean.order.order_Status==5">
				     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="copyOrder();">复制单据</a>
				 </s:if> 				 
			 </td>			 					 		
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="exportOrderToExcel();">订单导出到Excel</a></td>
			 <td><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="exportBarcodeToExcel();">条码标签导出</a></td>	
	  </tr>
	  <tr height="10">
	  	     <td colspan="7"><s:actionerror cssStyle="color:red"/><s:actionmessage cssStyle="color:blue"/></td>
	  </tr>
</table>

</s:form>
</body>
</html>