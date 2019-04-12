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
		border : false,
		checkOnSelect : false,
		selectOnCheck : false,
		singleSelect:true,
		nowrap : false,
		showFooter:true,
		columns : [ [ {
			field : 'category',
			title : '账目名称',
			width : 150
		},	{			
			field : 'amount',
			title : '净付总额 (+收/-付)',
			width : 150,
			formatter: function (value, row, index){
				return parseNumberValue(row.amount);
			}
		}
		]]
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
		<div data-options="region:'north',border:false" style="height: 135px;">
		   <s:form id="preGenReportForm" action="" theme="simple" method="POST"> 
                      <table width="100%" border="0">
				    <tr class="InnerTableContent">
				      <td width="45" height="35">&nbsp;</td>
				      <td width="76"><strong>开始截止日期</strong></td>
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
                    <tr class="InnerTableContent">
				      <td height="35">&nbsp;</td>
				      <td>&nbsp;</td>
				      <td colspan="2"><input type="button" value="生成报表" onclick="generateReport();"/></td>
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