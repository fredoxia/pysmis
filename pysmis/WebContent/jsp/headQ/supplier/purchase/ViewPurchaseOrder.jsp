<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><s:property value="formBean.order.typeS"/> <s:property value="formBean.order.statusS"/></title>
<%@ include file="../../../common/Style.jsp"%>

<script type="text/javascript">
/**
 * to submit the order to account
 */
function cancelOrder(){
	$.messager.progress({
			title : '提示',
			text : '数据处理中，请稍后....'
		});
	var params = $("#purchaseOrderForm").serialize();  
	$.post("<%=request.getContextPath()%>/action/supplierPurchaseJSON!cancelPurchase",params, cancelOrderBKProcess,"json");
}
function cancelOrderBKProcess(data){
	var response = data;

	var returnCode = response.returnCode;
	var returnMsg = response.message;
	if (returnCode == SUCCESS){		   
		alert("成功红冲单据");
		window.location.href = "supplierPurchaseJSP!preEditPurchase";
	} else {
		$.messager.progress('close'); 
        alert(returnMsg);
    }
}

$(document).ready(function(){
	parent.$.messager.progress('close'); 
});
</script>

</head>
<body>

<s:form action="/action/inventoryOrder!previewOrder" method="POST" name="purchaseOrderForm"  id="purchaseOrderForm" theme="simple" enctype="multipart/form-data">
 <s:hidden name="formBean.order.id"  id="orderId"/>

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
			 		<th colspan="10">供应商名字&nbsp;:&nbsp;<s:property value="formBean.order.supplier.name"/>&nbsp&nbsp&nbsp&nbsp&nbsp货品点数&nbsp; :&nbsp;<s:property value="formBean.order.orderCounter.name" />	</th>
			 		<th colspan="2">订单号&nbsp;:&nbsp;<s:property value="formBean.order.id"/> </th>	 
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
			 		<th style="width: 5%">进价 (单价)</th>
			 		<th style="width: 8%">批发价(单价)</th>
			 		<th style="width: 6%">&nbsp;</th>	
			 		<th style="width: 6%"></th> 		 		
                </tr>
                <tbody  id="inventoryTable">
	                <s:iterator value="formBean.order.productList" status = "st" id="orderProduct" >
					 	<tr id="row<s:property value="#st.index"/>"  class="excelTable" align="center">
					 		<td align="center"><s:property value="#st.index +1"/></td>
					 		<td><s:property value="#orderProduct.pb.barcode"/></td>		
					 		<td><s:property value="#orderProduct.pb.product.year.year"/></td>
					 		<td><s:property value="#orderProduct.pb.product.quarter.quarter_Name"/></td>					 		
					 		<td><s:property value="#orderProduct.pb.product.brand.brand_Name"/></td>		 					 		
					 		<td><s:property value="#orderProduct.pb.product.productCode"/> <s:property value="#orderProduct.pb.product.numPerHand"/></td>
					 		<td><s:property value="#orderProduct.pb.color.name"/></td>	
				 		    <td><s:property value="#orderProduct.pb.product.unit"/></td>						 			 		
					 		<td><s:property value="#orderProduct.quantity"/></td>
					 		<td>
					 		     <s:text name="format.totalPrice">
						       			<s:param value="#orderProduct.recCost"/>
						       	 </s:text>					 		
					 		</td>		 					 		
					 		<td>
					 		     <s:text name="format.totalPrice">
						       			<s:param value="#orderProduct.wholeSalePrice"/>
						       	  </s:text>
						    </td>			 							 		
					 		<td></td>
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
			 		<td><s:property value="formBean.order.totalQuantity"/></td>
			 		<td><s:property value="formBean.order.totalRecCost"/></td>
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
                  <td colspan="2"><s:property value="formBean.order.totalDiscount"/></td>
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
			 <td></td>			 					 		
			 <td></td>
			 <td><input type="button" value="红冲单据" onclick="cancelOrder();"/></td>			 					 		
			 <td></td>
			 <td></td>			 					 		
			 <td></td>	
	  </tr>
</table>

</s:form>

</body>
</html>