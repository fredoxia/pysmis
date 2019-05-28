<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><s:property value="formBean.order.typeS"/> <s:property value="formBean.order.statusS"/></title>
<%@ include file="../../../common/Style.jsp"%>
<script type="text/javascript" src=<%=request.getContextPath()%>/conf_files/js/print/pazuclient.js></script>
<script type="text/javascript" src=<%=request.getContextPath()%>/conf_files/js/print/HeadqPurchaseOrderPrint.js?v=5-42></script>
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
		
		$.messager.alert({
			title: '消息',
			msg: "成功红冲单据",
			fn: function(){
				window.location.href = "supplierPurchaseJSP!preEditPurchase";
			}
		});
	} else {
		$.messager.progress('close'); 
        $.messager.alert('错误', returnMsg, 'error');
    }
}

function printOrder(){
	$.messager.progress({
		title : '提示',
		text : '数据处理中，请稍后....'
	});
    var params = $("#purchaseOrderForm").serialize();  
    $.post("<%=request.getContextPath()%>/action/supplierPurchaseJSON!printOrder",params, printOrderBKProcess,"json");
}
function printOrderBKProcess(data){
	$.messager.progress('close'); 
	var response = data;

	var returnCode = response.returnCode;
	var returnMsg = response.message;
	if (returnCode == SUCCESS){		   
		printContent(response.returnValue);
	} else {
		
        $.messager.alert('错误', returnMsg, 'error');
    }
}
function copyOrder(){
	var info = "你确定复制此单据?";
	$.messager.confirm('复制单据', info, function(r){
		if (r){
	    	var url = "<%=request.getContextPath()%>/action/supplierPurchaseJSON!copyPurchaseOrder";
	    	var params=$("#purchaseOrderForm").serialize();  
	    	$.post(url,params, copyOrderBackProcess,"json");	
	    }
	});
}
function copyOrderBackProcess(data){
    var response = data;
	var returnCode = response.returnCode;

	if (returnCode != SUCCESS)
	    $.messager.alert('复制单据失败', response.message, 'error');
	else {
        $.messager.alert('复制单据成功', "复制单据成功,单据号 " + response.returnValue, 'info');
    }	
}
function updateOrderComment(){
    var url = "<%=request.getContextPath()%>/action/supplierPurchaseJSON!updateOrderComment";
    var params=$("#purchaseOrderForm").serialize();  
    $.post(url,params, updateOrderCommentBackProcess,"json");	
}
function updateOrderCommentBackProcess(data){
	var returnValue = data.returnCode;
	if (returnValue == SUCCESS)
	    $.messager.alert('消息', data.message, 'info');
	else 
		$.messager.alert('操作失败', data.message, 'error');
}
$(document).ready(function(){
	parent.$.messager.progress('close'); 
});
</script>

</head>
<body>

<s:form action="/action/inventoryOrder!previewOrder" method="POST" name="purchaseOrderForm"  id="purchaseOrderForm" theme="simple" enctype="multipart/form-data">
 <s:hidden name="formBean.order.id"  id="orderId"/>

 <table cellpadding="0" cellspacing="0"  style="width: 90%" align="center" class="OuterTable">
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
			 		<th>供应商名字&nbsp;:&nbsp;<s:property value="formBean.order.supplier.name"/>&nbsp&nbsp&nbsp&nbsp&nbsp货品点数&nbsp; :&nbsp;<s:property value="formBean.order.orderCounter.name" />	</th>
			 		<th>订单号&nbsp;:&nbsp;<s:property value="formBean.order.id"/> </th>	 
			 	</tr>
			 	<tr class="PBAOuterTableTitale" align="left">
			 		<th>&nbsp;</th>
			 		<th>上欠&nbsp;:&nbsp;<s:property value="formBean.order.preAcctAmt"/>&nbsp&nbsp&nbsp&nbsp&nbsp下欠&nbsp; :&nbsp;<s:property value="formBean.order.postAcctAmt"/>	</th>
			 		<th></th>	 
			 	</tr>			 	
				<tr height="10">
					<th colspan="3"></th>
				</tr>	
				<tr height="10">
					<td colspan="3">
					 <table class="easyui-datagrid" style="height:400px"  data-options="singleSelect:true,border : false">	
						<thead>
						 <tr align="center"  class="PBAOuterTableTitale" height="22">
				 		    <th data-options="field:'1',width:40">&nbsp;</th>
					 		<th data-options="field:'2',width:90">条型码</th>
					 		<th data-options="field:'3',width:70">年份</th>	
					 		<th data-options="field:'4',width:70">季度</th>				 				
					 		<th data-options="field:'5',width:100">产品品牌</th>		 					 				 		
					 		<th data-options="field:'6',width:100">产品货号</th>
					 		<th data-options="field:'7',width:90">颜色</th>
					 		<th data-options="field:'8',width:90">单位</th>				 		
					 		<th data-options="field:'9',width:90">数量</th>	
					 		<th data-options="field:'10',width:90">进价 (单价)</th>
					 		<th data-options="field:'11',width:90">批发价(单价)</th>
					 		<th data-options="field:'12',width:10">&nbsp;</th>	
					 		<th data-options="field:'13',width:10"></th> 		 		
		                 </tr>
		                </thead>
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
					 		<td><s:text name="format.totalPrice">
								       			<s:param value="formBean.order.totalRecCost"/>
								       	  </s:text>
							</td>
					 		<td>		<s:text name="format.totalPrice">
								       			<s:param value="formBean.order.totalWholePrice"/>
								       	  </s:text>
						    </td>	
					 		<td>&nbsp;</td>	
					 		<td>&nbsp;</td>		 		
		                </tr>
					</table>					
					
					
					
					</td>
				</tr>						 	

                <tr height="10">
			         <td colspan="3" align="left"></td>			 					 		
	            </tr>
				<tr height="10" class="InnerTableContent" >
				  	 <td align ="center">备注</td>
					 <td colspan="2"><input name="formBean.order.comment" id="comment" class="easyui-textbox"  style="width:500px" value="<s:property value="uiBean.order.comment"/>"><a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="updateOrderComment();">修改备注</a></td>			 					 				 					 		
				</tr>
                <tr class="InnerTableContent">
                  <td width="5%" height="27" align="center">优惠</td>
                  <td width="85%"><s:property value="formBean.order.totalDiscount"/></td>
                  <td width="10%"></td>

                </tr>
		 </table>
	     </td>
	  </tr>
      <tr height="10">
	  	     <td>&nbsp;</td>
			 <td></td>			 					 		
			 <td></td>
			 <td colspan="2">
			     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'" onclick="cancelOrder();">红冲单据</a>&nbsp;&nbsp;
			     <a id="btn3" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="printOrder();">打印单据</a>&nbsp;&nbsp;
			     <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="copyOrder();">复制单据</a></td>			 					 		
			 <td></td>			 					 		
			 <td></td>	
	  </tr>
</table>

</s:form>

</body>
</html>