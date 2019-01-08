<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.common.Common_util,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../common/Style.jsp"%>
<SCRIPT src="<%=request.getContextPath()%>/conf_files/js/HeadqInvenTrace.js" type=text/javascript></SCRIPT>
<script>
var baseurl = "<%=request.getContextPath()%>";
$(document).ready(function(){
	parent.$.messager.progress('close'); 
	
	$('#dataGrid').treegrid({
		url : 'headqInventoryFlowJSONAction!getInventoryFlowEles',
		idField: 'id',
		treeField : 'name',
		onBeforeExpand : function(node) {
		    $("#yearId").attr("value", node.yearId);
			$("#quarterId").attr("value", node.quarterId);
			$("#brandId").attr("value", node.brandId);
			var params = $('#preGenReportForm').serialize();
			$('#dataGrid').treegrid('options').url = 'headqInventoryFlowJSONAction!getInventoryFlowEles?' + params;
		},
		columns : [ [
					{field:'name', width:250,title:'库存列表',
						formatter: function (value, row, index){
							if (row.state == 'open') {
								var str = '';
							    str += $.formatString('<a href="#" onclick="traceInventory(\'{0}\',\'\');">{1}</a>', row.pbId, row.name);
							    return str;
							} else 
								return row.name;
						}},
					{field:'inventory', width:170,title:'库存数量'},
					{field:'wholeSales', width:175,title:'库存成本',
						formatter: function (value, row, index){
							return (row.wholeSales).toFixed(2);
						}
					}
			     ]],
		toolbar : '#toolbar',
	});
});

function refresh(){
	location.reload();
}
function downloadInventory(){
	var node = $('#dataGrid').treegrid('getSelected');

	if (node == null){
		$.messager.alert('错误', '请先选中一行再继续操作', 'error');
	} else {
	    $("#yearId").attr("value", node.yearId);
		$("#quarterId").attr("value", node.quarterId);
		$("#brandId").attr("value", node.brandId);
        document.preGenReportForm.action="headqInventoryFlowJSPAction!downloadHeadqInventory";
        document.preGenReportForm.submit();
	}

}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
	    <div data-options="region:'north',border:false" style="height: fit">
        <s:form id="preGenReportForm" name="preGenReportForm" action="" theme="simple" method="POST">  
            <input type="hidden" name="formBean.yearId" id="yearId" value="0"/>
            <input type="hidden" name="formBean.quarterId" id="quarterId" value="0"/>
            <input type="hidden" name="formBean.brandId" id="brandId" value="0"/>
            <s:hidden name="formBean.storeId" id="storeId"/>
        </s:form>
        </div>
		<div data-options="region:'center',border:false">
			    <table id="dataGrid" style="width:600px;height:fit">			       
		        </table>
		        <div id="toolbar" style="display: none;">
		             <a onclick="refresh();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'">刷新库存</a>
		             <a onclick="downloadInventory();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">下载库存</a>
	             </div>
		</div>
	</div>					  
</body>
</html>