<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>

<%@ page import="com.onlineMIS.ORM.entity.headQ.user.*,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查询采购单据</title>
<%@ include file="../../../common/Style.jsp"%>

<script>

function BSkeyDown(e){

	 var ieKey = event.keyCode;

	 if (ieKey==13){
	   if (event.srcElement.id == "supplierName"){
		   searchSupplier(); 
		   event.returnValue=false;
	   }
	 }  
} 

document.onkeydown = BSkeyDown; 

$(document).ready(function(){
	parent.$.messager.progress('close'); 

	var params = $.serializeObject($('#inventorySearchForm'));
	
	$('#dataGrid').datagrid({
		url : 'supplierPurchaseJSON!searchPurchaseOrder',
		queryParams: params,
		fit : true,
		border : false,
		checkOnSelect : false,
		selectOnCheck : false,
		singleSelect:true,
		nowrap : false,
		rowStyler: function(index,row){
			var style = "";
			if (row.status == 1)
				style += 'color:blue;';
			else if (row.status == 3)
				style += 'color:red;';

			if (row.type == 1)
				style += 'background-color:#F9F8FA;';
			return style;
		},
		columns : [ [ {
			field : 'id',
			title : '编号',
			width : 50
		}, {
			field : 'supplier',
			title : '供应商名称',
			width : 120
				
		}, {
			field : 'creationTime',
			title : '创建时间',
			width : 125
		}, {
			field : 'lastUpdateTime',
			title : '最后更新时间',
			width : 125
		}, {
			field : 'orderAuditor',
			title : '录入会计',
			width : 60
		}, {
			field : 'orderCounter',
			title : '点数人员',
			width : 60
		}, {
			field : 'totalQuantity',
			title : '总数',
			width : 60
		}, {
			field : 'totalRecCost',
			title : '进价总额',
			width : 70,
			formatter: function (value, row, index){
				return parseNumberValue(row.totalRecCost);
			}
		},	{			
			field : 'totalWholePrice',
			title : '批发总额',
			width : 80,
			formatter: function (value, row, index){
				return parseNumberValue(row.totalWholePrice);
			}
		}, {
			field : 'comment',
			title : '备注',
			width : 100
		}, {
			field : 'typeS',
			title : '单据类型',
			width : 70
		}, {	
			field : 'statusS',
			title : '状态',
			width : 70
		}, {			
			field : 'action',
			title : '查看/修改',
			width : 70,
			formatter : function(value, row, index) {
				var str = '';
				var url = "<%=request.getContextPath()%>/action/supplierPurchaseJSP!getPurchaseOrder?formBean.order.id=" + row.id;
					str += $.formatString('<a href="#" onclick="addTab6(\'{0}\',\'{1}\');"><img border="0" src="{2}" title="修改"/></a>', url, '采购单据 ' + row.id,'<%=request.getContextPath()%>/conf_files/easyUI/themes/icons/text_1.png');
				
				return str;
			}
		}]]
	});
});

function searchOrder(){
	var params = $.serializeObject($('#inventorySearchForm')); 
	$('#dataGrid').datagrid('load',params); 
}
</script>

</head>
<body>
 	<div class="easyui-layout"  data-options="fit : true,border : false">
		<div data-options="region:'north',border:false" style="height: 175px;">
		<s:form id="inventorySearchForm" action="/action/inventoryOrder!search" theme="simple" method="POST">
		 <table width="100%" border="0">
		    <tr class="InnerTableContent">
		      <td height="19"><strong>供应商名字：</strong></td>
		      <td colspan="3"><%@ include file="../SupplierInput.jsp"%></td>

		      <td><strong>单据号：</strong></td>
		      <td><input name="formBean.order.id" id="orderId"  onkeypress="return is_number(event);" size="7"/></td>
		      <td><strong>包含货品：</strong></td>
		      <td><%@ include file="../../include/SearchProduct.jsp"%></td>		 
	       
		    </tr>	   
		    <tr class="InnerTableContent">
		      <td width="95" height="32"><strong>单据种类：</strong></td>
		      <td width="100"><s:select name="formBean.order.type" id="orderType"  list="formBean.order.typeHQMap" listKey="key" listValue="value" headerKey="-1" headerValue="---全部---" /></td>
		      <td width="75"><strong>状态：</strong></td>
		      <td width="95"><s:select name="formBean.order.status" id="orderStatus"  list="formBean.order.statusMap" listKey="key" listValue="value" headerKey="-1" headerValue="---全部---" />      </td>
		      <td width="70"></td>
		      <td width="90"> </td>
		      <td width="70"> </td>
		      <td rowspan="2"><div id="productInfo"></div></td>

		    </tr>
		
		    <tr class="InnerTableContent">
		      <td height="19"><strong>单据创建时间：</strong></td>
		      <td colspan="6">
		        <s:textfield id="startDate" name="formBean.searchStartTime" cssClass="easyui-datebox"  data-options="width:100,editable:false"/> 
		        &nbsp;至 &nbsp;
		        <s:textfield id="endDate" name="formBean.searchEndTime" cssClass="easyui-datebox"  data-options="width:100,editable:false"/></td>

      		</tr>

		    <tr class="InnerTableContent">
		      <td height="5" colspan="8"><hr width="100%" color="#FFCC00"/></td>
		    </tr>
		    <tr class="InnerTableContent">
		      <td height="30">&nbsp;</td>
		      <td><input type="button" onclick="searchOrder();" value="查询采购单据"/> </td>
		      <td>&nbsp;</td>
		      <td>&nbsp;</td>
		      <td>&nbsp;</td>
		      <td>&nbsp;</td>
		      <td>&nbsp;</td>
		      <td>&nbsp;</td>		      		      
		    </tr>
  			</table>
		</s:form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid" border="0">			       
		    </table>
		</div>
	</div>

</body>
</html>