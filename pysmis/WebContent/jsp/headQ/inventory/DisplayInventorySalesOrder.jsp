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
<script type="text/javascript">
var PAZU_Config = { 
        prot:"http",           //è®¿é®ä½ çåºç¨çåè®®   
        server: 'localhost',   //æå°æå¡å¨å°åï¼å¦æä½ çåºç¨é¢åWindowså¹³å°ï¼åæ éæ´æ¹ï¼æ¯å°å®¢æ·ç«¯é½èªå·±åæå°æå¡å¨ï¼ 
        port: 6894,            //ä¸è¦æ´æ¹ç«¯å£,å¹¶ç¡®ä¿æå°æå¡å¨ä¸ 
        license:'8F34B771723DCC171F931EA900F9967E'             //ä½ çPAZUè®¸å¯ç ï¼å¯ä»¥èªè¡å¨å®æ¹ç³è¯·ï¼ä¸æ¶è´¹ï¼è½¬åå¾®ä¿¡æååå³å¯ç³è¯·æå 
    }
function chkPAZU(){ 
    if(!window.PAZU){ 
       alert("PAZU is not ready \r\n :" + PAZU_Config.server + " download PAZUCloud_setup.exeçurl"); 
       //ä¹å¯ä»¥ä½ èªå·±å¨é¡µé¢éé¢æå»ºä¸ä¸ªé¾æ¥æç¤ºç¨æ·ä¸è½½  
       return false;
    } 
    return true; 
 }
function printF(){
	if (chkPAZU()){
		var dfPrinter=pazu.TPrinter.getDefaultPrinter();
		PAZU.TPrinter.printToDefaultPrinter("add ");
	}
}
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
	if (confirm(info)){	
		var url = "<%=request.getContextPath()%>/action/inventoryOrder!acctAuditOrder";
		document.inventoryOrderForm.action = url;
		document.inventoryOrderForm.submit();	
	}
}
function edit(){
	var url = "<%=request.getContextPath()%>/action/inventoryOrder!acctUpdate";
	document.inventoryOrderForm.action = url;
	document.inventoryOrderForm.submit();	
}
function cancelOrder(){
	var info = "你确定红冲此单据?";
	if (confirm(info)){	
	    var url = "<%=request.getContextPath()%>/action/inventoryOrder!cancelOrder";
	    document.inventoryOrderForm.action = url;
	    document.inventoryOrderForm.submit();	
	}	
}
function updateOrderComment(){
    var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!updateOrderComment";
    var params=$("#inventoryOrderForm").serialize();  
    $.post(url,params, updateOrderCommentBackProcess,"json");	
}
function updateOrderCommentBackProcess(data){
	var returnValue = data.returnCode;
	if (returnValue == SUCCESS)
		alert(data.message);
	else 
		alert("错误 : " + data.message);
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
		alert("复制单据失败 ： " + response.message);
	else {
        alert("复制单据成功,单据号 " + response.returnValue);
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

function printOrder(){
	 var url = "<%=request.getContextPath()%>/action/inventoryOrderJSON!printOrder";
	    var params=$("#inventoryOrderForm").serialize();  
	    $.post(url,params, printOrderBackProcess,"json");	
}	
function printOrderBackProcess(data){
    var response = data;
	var returnCode = response.returnCode;

	if (returnCode != SUCCESS)
		alert("获取单据失败 ： " + response.message);
	else {
        var returnValue = response.returnValue;
        var inventoryOrder = returnValue.inventoryOrder;
       
        if (inventoryOrder != null && inventoryOrder != ""){
        	pageSetup();
        	printContent(inventoryOrder);
        }
	}
 }
function pageSetup(){
	PAZU.TPrinter.header = "成都朴与素 大成市场2期A座3楼";
	PAZU.TPrinter.fontCSS = "font-size:16px;";
	PAZU.TPrinter.paperName= "zhenchi";
}
function printContent(io){
	var space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
    var s = "单据号 : " + io.id + space + "客户名字 : " + io.clientName + space + "单据日期  : " + io.orderTime + "<br/>";
    	s += "单据种类 : " + io.orderType + space + "上欠 : " + io.preAcctAmt + space + "下欠  : " + io.postAcctAmt + "<br/>";
		s += "单据明细  : <br/>";
	var products = io.products;

	var j =1;
	var k = 1; //每页多少行了
 	for (var i = 1; i <= products.length; i++){
	  	var product = products[i-1];
	  	s += i + space + product.brand + space + product.productCode + space + product.color + space +product.quantity + space + product.wholeSales + space + product.totalWholeSales + "<br/>";

//	  	if (i == (products.length - 2))
//	  	   alert(i + "," +products.length);
	  	
 	  	if ((j == 1 && i == 15) || i == products.length){
	  		if (i == products.length)
		  		s += "合计                                             总数 : " + io.totalQ + "       批发总额 : " + io.totalWholeSales;
 	  		//alert(s);
	  		printOut(s);
	  		s = "";
	  		j++;
	  	} else if (j!=1 && (i-15) % 20 == 0){
	  		if (i == products.length)
		  		s += "合计                                             总数 : " + io.totalQ + "       批发总额 : " + io.totalWholeSales;
	  		//alert(s);
	  		printOut(s);
	  		s = "";
	  	} else if (i == products.length){
	  		s += "合计                                             总数 : " + io.totalQ + "       批发总额 : " + io.totalWholeSales;
	  		//alert(s);
	  		printOut(s);
	  	}
  	}
	
	
}

function printOut(data){
	PAZU.print("<p>" + data);
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
		 <table class="easyui-datagrid" style="height:400px"  data-options="singleSelect:true,border : false">			 	
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
			 <td><input type="button" value="修改备注" onclick="updateOrderComment();"/></td>
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
				     <input type="button" value="会计修改" onclick="edit();"/>
				 </s:if>
			 </td>			 					 		
			 <td colspan="2"> 
			     <!-- for user, 1. This order is completed (status == 2) 2. They have the authority to do export -->
				 
				 <!-- for user, 1. This order is completed (status == 2 || status==6) 2. They have the authority to do complete without import jinsuan -->
				 <s:if test="(#session.LOGIN_USER.containFunction('inventoryOrder!acctAuditOrder') && (formBean.order.order_Status==2 || formBean.order.order_Status == 6)) ">
				     <input type="button" value="完成单据审核" onclick="completeAuditOrder();"/>
				 </s:if>
				 
				 <!-- for user, 1. This order has been exported (status == 3) 2. They have the authority  -->
				 <s:if test="(#session.LOGIN_USER.containFunction('inventoryOrder!cancelOrder') && formBean.order.order_Status==3) ">
				     <input type="button" value="红冲单据" onclick="cancelOrder();"/>
				 </s:if>
				 
				 <input type="button" value="打印单据" onclick="printOrder();"/>
			 </td>			 					 		
			 <td>
				 <s:if test="formBean.order.order_Status== 1 || formBean.order.order_Status==2 || formBean.order.order_Status==6  || formBean.order.order_Status==9">
				     <input type="button" value="删除单据" onclick="deleteOrder();"/>
				 </s:if> 
				 <s:if test="#session.LOGIN_USER.containFunction('inventoryOrderJSON!copyOrder') && formBean.order.order_Status==5">
				     <input type="button" value="复制单据" onclick="copyOrder();"/>
				 </s:if> 				 
			 </td>			 					 		
			 <td><input type="button" value="订单导出到Excel" onclick="exportOrderToExcel();"/></td>
			 <td><input type="button" value="条码标签导出" onclick="exportBarcodeToExcel();"/></td>	
	  </tr>
	  <tr height="10">
	  	     <td colspan="7"><s:actionerror cssStyle="color:red"/><s:actionmessage cssStyle="color:blue"/></td>
	  </tr>
</table>

</s:form>
</body>
</html>