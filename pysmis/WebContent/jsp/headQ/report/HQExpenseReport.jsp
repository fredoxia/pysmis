<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>

<%@ page import="com.onlineMIS.ORM.entity.headQ.user.*,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查询采购单据</title>
<%@ include file="../../common/Style.jsp"%>

<script>
var treeGrid;


$(document).ready(function(){
	parent.$.messager.progress('close'); 
	var params = $('#preGenReportForm').serialize();
	$('#dataGrid').treegrid({
		url : 'headQReportJSON!getHQExpenseReptEles',
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
		    $("#expenseTypeParentId").val(node.expenseTypeParentId);

			var params = $('#preGenReportForm').serialize();
			$('#dataGrid').treegrid('options').url = 'headQReportJSON!getHQExpenseReptEles?' + params;
		},	
		columns : [ [
					{field:'name', width:250,title:'费用列表'},
					{field:'cash', width:80,title:'现金',
						formatter: function (value, row, index){
							if (row.cash == 0)
								return "-";
							else 
								return row.cash;
	
						}},
					{field:'card', width:80,title:'银行卡',
							formatter: function (value, row, index){
								if (row.card == 0)
									return "-";
								else 
									return row.card;
		
							}},
					{field:'alipay', width:80,title:'支付宝',
						formatter: function (value, row, index){
							if (row.alipay == 0)
								return "-";
							else 
								return row.alipay;
	
						}},
					{field:'wechat', width:80,title:'微信',
						formatter: function (value, row, index){
								if (row.wechat == 0)
									return "-";
								else 
									return row.wechat;
		
							}},
					{field:'total', width:100,title:'汇总',
							formatter: function (value, row, index){
								return (row.total).toFixed(2);
		
						}}
			     ]],
		toolbar : '#toolbar',
	});
});

function genReport(){
	    $("#parentId").val(0);
	    $("#expenseTypeParentId").val(0);
		var params = $('#preGenReportForm').serialize();

		$('#dataGrid').treegrid('options').url = 'headQReportJSON!getHQExpenseReptEles?' + params;
		$('#dataGrid').treegrid('reload');
}
function exportFile(){
	
	var node = $('#dataGrid').treegrid('getSelected');

	if (node == null){
		$.messager.alert('错误', '请先选中一行再继续操作', 'error');
	} else {

	    $("#expenseTypeParentId").val(node.expenseTypeParentId);

        document.preGenReportForm.action="headqReportJSP!downloadPurchaseExcelReport";
        document.preGenReportForm.submit();
	}
}
</script>

</head>
<body>
 	<div class="easyui-layout"  data-options="fit : true,border : false">
		<div data-options="region:'north',border:false" style="height: 55px;">
		<s:form id="preGenReportForm" name="preGenReportForm" action="/action/inventoryOrder!search" theme="simple" method="POST">
            <s:hidden name="formBean.parentId" id="parentId"/>
            <input type="hidden" name="formBean.expenseTypeParentId" id="expenseTypeParentId" value="0"/>
		 <table width="100%" border="0">
   		
		    <tr class="InnerTableContent">
		      <td height="19" width="100"><strong>费用日期：</strong></td>
		      <td >
		        <s:textfield id="startDate" name="formBean.startDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/> 
		        &nbsp;至 &nbsp;
		        <s:textfield id="endDate" name="formBean.endDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/></td>
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