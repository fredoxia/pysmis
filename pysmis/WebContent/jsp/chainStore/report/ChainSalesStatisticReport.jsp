<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.common.Common_util,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../common/Style.jsp"%>
<SCRIPT src="<%=request.getContextPath()%>/conf_files/js/ChainInvenTrace.js?v12.31" type=text/javascript></SCRIPT>
<script>
var baseurl = "<%=request.getContextPath()%>";
$(document).ready(function(){
	parent.$.messager.progress('close'); 
	$.messager.progress({
		title : '提示',
		text : '数据处理中，请稍后....'
	});
	
	var params= $.serializeObject($('#preGenReportForm'));
	
	$('#dataGrid').treegrid({
		url : 'chainReportJSON!getSalesStatisticReptEles',
		idField: 'id',
		queryParams: params,
		treeField : 'name',
		rownumbers: true,
		lines : true,
		rowStyler: function(row){
            var style = "";
            if (row.isChain == true)
            	style = "color:blue;";
			return style;
		},
		onLoadSuccess : function(row, param){
			$.messager.progress('close'); 
		},
		onBeforeExpand : function(node) {
			$("#parentId").attr("value", node.parentId);
		    $("#yearId").attr("value", node.yearId);
			$("#quarterId").attr("value", node.quarterId);
			$("#brandId").attr("value", node.brandId);
			var params = $('#preGenReportForm').serialize();
			$('#dataGrid').treegrid('options').url = 'chainReportJSON!getSalesStatisticReptEles?' + params;
		},	
		rowStyler: function(row){
            var style = "";
            if (row.isChain == true)
            	style = "color:blue;";
			return style;
		},
		columns : [ [
					{field:'name', width:210,title:'<s:property value="formBean.startDate"/> 到 <s:property value="formBean.endDate"/>',
						formatter: function (value, row, index){
							if (row.state == 'open' && row.chainId != -1) {
								var str = '';
							    str += $.formatString('<a href="#" onclick="traceInventory(\'{0}\',\'\');">{1}</a>', row.barcode, row.name);
							    return str;
							} else 
								return row.name;
						}},
					{field:'salesQ', width:50,title:'销售量A'},
					{field:'returnQ', width:50,title:'退货量B'},
					{field:'netQ', width:50,title:'净销量A-B'},
					{field:'freeQ', width:50,title:'赠品量'},
					{field:'salesPrice', width:50,title:'销售额C',
						formatter: function (value, row, index){
							return (row.salesPrice).toFixed(2);
						}
					},
					{field:'returnPrice', width:50,title:'退货额D',
						formatter: function (value, row, index){
							return (row.returnPrice).toFixed(2);
						}
					},
					{field:'netPrice', width:75,title:'净售额C-D',
						formatter: function (value, row, index){
							return (row.netPrice).toFixed(2);
						}
					},
					{field:'salesDiscount', width:50,title:'销售折扣',
						formatter: function (value, row, index){
							return (row.salesDiscount).toFixed(2);
						}
					},
					{field:'netCost', width:50,title:'净售成本E',
						formatter: function (value, row, index){
							if (row.seeCost == true) 
								return (row.netCost).toFixed(2);
							else 
								return "-";
						}},
					{field:'freeCost', width:50,title:'赠品成本 F',
						formatter: function (value, row, index){
							if (row.seeCost == true) 
								return (row.freeCost).toFixed(2);
							else 
								return "-";
						}
					},
					{field:'netProfit', width:110,title:'商品利润C-D-E-F',
						formatter: function (value, row, index){
							if (row.seeCost == true) 
								return (row.netProfit).toFixed(2);
							else 
								return "-";
						}
					}
			     ]],
		toolbar : '#toolbar',
	});
});

function refresh(){
	$("#parentId").attr("value", 0);
    $("#yearId").attr("value", 0);
	$("#quarterId").attr("value", 0);
	$("#brandId").attr("value", 0);
    document.preGenReportForm.action="chainReportJSPAction!generateSalesStatisticReport";
    document.preGenReportForm.submit();
}
function back(){
    document.preGenReportForm.action="chainReportJSPAction!preSalesStatisticReport";
    document.preGenReportForm.submit();
}
function exportFile(){
	
	var node = $('#dataGrid').treegrid('getSelected');

	if (node == null){
		$.messager.alert('错误', '请先选中一行再继续操作', 'error');
	} else {
		
		$("#chainId").attr("value", node.chainId);
	    $("#yearId").attr("value", node.yearId);
		$("#quarterId").attr("value", node.quarterId);
		$("#brandId").attr("value", node.brandId);
        document.preGenReportForm.action="chainReportJSPAction!generateChainSalesStatisticExcelReport";
        document.preGenReportForm.submit();
	}
}

</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
	    <div data-options="region:'north',border:false" style="height: fit">
        <s:form id="preGenReportForm" name="preGenReportForm" action="" theme="simple" method="POST">  
            <s:hidden name="formBean.parentId" id="parentId"/>
            <s:hidden name="formBean.chainStore.chain_id" id="chainId"/>
            <s:hidden name="formBean.startDate" id="startDate"/>
            <s:hidden name="formBean.endDate" id="endDate"/>
            <s:hidden name="formBean.saler.user_id" id="salerId"/>
            <input type="hidden" name="formBean.year.year_ID" id="yearId" value="0"/>
            <input type="hidden" name="formBean.quarter.quarter_ID" id="quarterId" value="0"/>
            <input type="hidden" name="formBean.brand.brand_ID" id="brandId" value="0"/>
        </s:form>
        </div>
		<div data-options="region:'center',border:false">
			    <table id="dataGrid" style="width:870px;height:800px">			       
		        </table>
		        <div id="toolbar" style="display: none;">
		             <a onclick="back();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-back'">退回上页</a>
		             <a onclick="refresh();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'">刷新库存</a>
					<a onclick="exportFile();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'">导出报表</a>
	             </div>
		</div>
	</div>					  
</body>
</html>