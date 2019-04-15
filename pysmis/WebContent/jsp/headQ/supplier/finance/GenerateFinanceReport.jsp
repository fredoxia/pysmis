<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.common.Common_util,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../../common/Style.jsp"%>

<script>

$(document).ready(function(){
	parent.$.messager.progress('close'); 

	var params = $.serializeObject($('#preGenReportForm'));
	
	$('#dataGrid').datagrid({
		url : 'financeSupplierJSON!generateFinanceRpt',
		queryParams: params,
		fit : true,
		fitColumns : false,
		pagination : false,
		border : false,
		checkOnSelect : false,
		selectOnCheck : false,
		singleSelect:true,
		showFooter:true,
		rownumbers:true,
		nowrap : false,
		frozenColumns :[[					
			                {field:'supplier', width:100,title:'供应商名字',fixed:true}
			           ]],
		columns : [ [
					{field:'cash', width:70,title:'现金 A',
						formatter: function (value, row, index){
							return (row.cash).toFixed(1);
						}},
					{field:'card', width:70,title:'银行卡 B',
						formatter: function (value, row, index){
							return (row.card).toFixed(1);
						}},
					{field:'alipay', width:70,title:'支付宝 C',
						formatter: function (value, row, index){
							return (row.alipay).toFixed(1);
						}},
					{field:'wechat', width:70,title:'微信 D',
						formatter: function (value, row, index){
							return (row.wechat).toFixed(1);
						}},

					{field:'sum', width:100,title:'汇总A+B+C+D',
						formatter: function (value, row, index){
							return (row.sum).toFixed(1);
						}},					
					{field:'discount', width:75,title:'财务折扣',
							formatter: function (value, row, index){
								return (row.discount).toFixed(2);
						}},
					{field:'acctFlow', width:120,title:'应付增加+/减少-',
								formatter: function (value, row, index){
									return (row.acctFlow).toFixed(1);
						}}
		]],
		toolbar : '#toolbar',
	});
});

function generateReport(){
	var params = $.serializeObject($('#preGenReportForm')); 
	$('#dataGrid').datagrid('load',params); 
}
</script>
</head>
<body>
 	<div class="easyui-layout"  data-options="fit : true,border : false">
		<div data-options="region:'north',border:false" style="height: 85px;">
		   <s:form id="preGenReportForm" action="" theme="simple" method="POST"> 
                      <table width="100%" border="0">
				    <tr class="InnerTableContent">
				      <td width="45" height="35">&nbsp;</td>
				      <td width="76"><strong>财务单据日期</strong></td>
				      <td width="284" colspan="2">
		      	 			<s:textfield id="startDate" name="formBean.searchStartTime" cssClass="easyui-datebox"  data-options="width:100,editable:false"/>			      
		      					&nbsp; 至&nbsp;
		         			<s:textfield id="endDate" name="formBean.searchEndTime" cssClass="easyui-datebox"  data-options="width:100,editable:false"/>	
			  		  </td>
				      <td></td>
				    </tr>
					<tr class="InnerTableContent">
				      <td height="35">&nbsp;</td>
				      <td><strong>供应商</strong></td>
				      <td><%@ include file="../SupplierInput.jsp"%>
				      </td>
				      <td></td>
				      <td></td>
				    </tr>
				  </table>
			 </s:form>
	 		</div>
		 <div data-options="region:'center',border:false">
			<table id="dataGrid" border="0">			       
		    </table>
		    <div id="toolbar" style="display: none;">
			         <a onclick="generateReport();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">查询报表</a>
	        </div>		    
		</div>
	</div>
</body>
</html>