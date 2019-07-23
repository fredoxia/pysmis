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
$(document).ready(function(){
	parent.$.messager.progress('close'); 

});
function exportReport(){
	tips = "你确定是否按照当前条件生成报表?<br\>";
	tips += "时间段 : " + $("#startDate").datebox("getValue") + " 至 " + $("#endDate").datebox("getValue") + "<br\>";
	$.messager.confirm('确认输入信息', tips, function(r){

		if (r){

	        document.preGenReportForm.action="headqReportJSP!downloadSupplierAcctFlowExcelReport";
	        document.preGenReportForm.submit();
		}
	});
}
</script>

</head>
<body>
 	<div class="easyui-layout"  data-options="fit : true,border : false">
		<div data-options="region:'north',border:false" style="height: 150px;">
		<s:form id="preGenReportForm" name="preGenReportForm" action="/action/inventoryOrder!search" theme="simple" method="POST">
		 <table width="100%" border="0">
   		
		    <tr class="InnerTableContent">
		      <td width="90"  height="45"><strong>时间段：</strong></td>
		      <td >
		        <s:textfield id="startDate" name="formBean.startDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/> 
		        &nbsp;至 &nbsp;
		        <s:textfield id="endDate" name="formBean.endDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/></td>
      		</tr>

		    <tr class="InnerTableContent">
		     <td></td>
		      <td height="45"><a onclick="exportReport();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:false,iconCls:'icon-save'">导出报表</a>	</td>
		    </tr>		    
		     
  			</table>
		</s:form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid" border="0">			       
		    </table>
		    <div id="toolbar" style="display: none;">
			        
	        </div>
		</div>
	</div>

</body>
</html>