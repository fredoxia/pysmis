<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>

<%@ page import="com.onlineMIS.ORM.entity.headQ.user.*,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查询销售报表</title>
<%@ include file="../../common/Style.jsp"%>

<script>
var treeGrid;

function BSkeyDown(e){

	 var ieKey = event.keyCode;

	 if (ieKey==13){
	   if (event.srcElement.id == "clientName"){
		   searchCustomer(); 
		   event.returnValue=false;
	   }
	 }  
} 

document.onkeydown = BSkeyDown; 

$(document).ready(function(){
	parent.$.messager.progress('close'); 
	var params = "";
	$('#dataGrid').treegrid({
		url : 'headQReportJSON!getSalesStatisticReptEles',
		idField: 'id',
		queryParams: params,
		treeField : 'name',
		rownumbers: true,
		lines : true,
		onLoadSuccess : function(row, param){
			$.messager.progress('close'); 
		},
		onBeforeExpand : function(node) {
			$("#parentId").val(node.parentId);
		    $("#yearId").val(node.yearId);
			$("#quarterId").val(node.quarterId);
			$("#brandId").val(node.brandId);
			var params = $('#preGenReportForm').serialize();
			$('#dataGrid').treegrid('options').url = 'headQReportJSON!getSalesStatisticReptEles?' + params;
		},	
		frozenColumns :[[					
						{field:'name', width:250,title:'销售列表'}
						]],		
		columns : [ [
					{field:'salesQ', width:70,title:'销售数量',
						formatter: function (value, row, index){
							if (row.salesQ == 0)
								return "-";
							else 
								return row.salesQ;
	
						}},
					{field:'returnQ', width:70,title:'退货数量',
							formatter: function (value, row, index){
								if (row.returnQ == 0)
									return "-";
								else 
									return row.returnQ;
		
							}},
					{field:'netQ', width:80,title:'净销售量'},
					{field:'netPrice', width:100,title:'净销售额',
						formatter: function (value, row, index){
							return (row.netPrice).toFixed(2);
	
						}},
					{field:'netCost', width:100,title:'净销售成本',
						formatter: function (value, row, index){
							return (row.netCost).toFixed(2);
	
						}},
					{field:'netProfit', width:100,title:'利润',
						formatter: function (value, row, index){
							return (row.netProfit).toFixed(2);
	
						}}
			     ]],
		toolbar : '#toolbar',
	});
});

function genReport(){
	    $("#parentId").val(0);
	    $("#yearId").val(0);
		$("#quarterId").val(0);
		$("#brandId").val(0);
		var params = $('#preGenReportForm').serialize();
		$('#dataGrid').treegrid('options').url = 'headQReportJSON!getSalesStatisticReptEles?' + params;
		$('#dataGrid').treegrid('reload');
}
</script>

</head>
<body>
 	<div class="easyui-layout"  data-options="fit : true,border : false">
		<div data-options="region:'north',border:false" style="height: 75px;">
		<s:form id="preGenReportForm" action="/action/inventoryOrder!search" theme="simple" method="POST">
            <s:hidden name="formBean.parentId" id="parentId"/>
            <input type="hidden" name="formBean.year.year_ID" id="yearId" value="0"/>
            <input type="hidden" name="formBean.quarter.quarter_ID" id="quarterId" value="0"/>
            <input type="hidden" name="formBean.brand.brand_ID" id="brandId" value="0"/>
		 <table width="100%" border="0">
   		
		    <tr class="InnerTableContent">
		      <td height="19"><strong>单据过账时间：</strong></td>
		      <td >
		        <s:textfield id="startDate" name="formBean.startDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/> 
		        &nbsp;至 &nbsp;
		        <s:textfield id="endDate" name="formBean.endDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/></td>
      		</tr>
		    <tr class="InnerTableContent">
		      <td width="90" height="19"><strong>客户名字：</strong></td>
		      <td ><%@ include file="../include/ClientInput.jsp"%></td>

	       
		    </tr>	
  			</table>
		</s:form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid" border="0">			       
		    </table>
		    <div id="toolbar" style="display: none;">
			         <a onclick="genReport();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">查询报表</a>
	        </div>
		</div>
	</div>

</body>
</html>