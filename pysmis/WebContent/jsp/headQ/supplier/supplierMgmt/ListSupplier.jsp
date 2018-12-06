<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-Strict.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.common.Common_util,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../../common/Style.jsp"%>
<script>
var dataGrid ;
$(document).ready(function(){
	parent.$.messager.progress('close'); 
	
	var params = "";

	dataGrid = $('#dataGrid').datagrid({
		url : 'headQSupplierMgmtJSONAction!listSupplierData',
		queryParams: params,
		fit : true,
		border : false,
		pagination : true,
		pageSize : 15,
		pageList : [ 15, 30],		
		checkOnSelect : false,
		selectOnCheck : false,
		singleSelect:true,
		nowrap : false,
		rownumbers : true,
		sortName : 'status',
		sortOrder : 'asc',
		rowStyler: function(index,row){
			var style = "";
			if (row.status == 1)
				style += 'color:red;';

			return style;
		},
		columns : [ [ {
			field : 'id',
			title : '供应商代码',
			width : 80,
			sortable:true,
			order:'desc',
		    },{
				field : 'name',
				title : '供应商名字',
				width : 150
			},{		
				field : 'pinyin',
				title : '首字母',
				width : 70
			},{					
				field : 'address',
				title : '地址',
				width : 200
		    }, {	
				field : 'initialAcctBalance',
				title : '初期账目',
				width : 90
			}, {		    	
				field : 'currentAcctBalance',
				title : '当前账目',
				width : 90
			}, {
				field : 'comment',
				title : '备注信息',
				width : 90
			}, {
				field : 'status',
				title : '状态',
				width : 50,
				formatter: function (value, row, index){
					if (row.status == 0 )
						return "正常";
					else if (row.status == 1)
						return "冻结";
				}
			}, {				
				field : 'action',
				title : '更改',
				width : 50,
			formatter : function(value, row, index) {
				var str = '';
				str += $.formatString('<a href="#" onclick="updateSupplier(\'{0}\');"><img border="0" src="{1}" title="更改供应商信息"/></a>', row.id, '<%=request.getContextPath()%>/conf_files/easyUI/themes/icons/text_1.png');
				return str;
			}
		}]],
		toolbar : '#toolbar',
	});

});

function AddSupplier(){
	var params = "";

	$.modalDialog.opener_dataGrid = dataGrid;
	
	$.modalDialog({
		title : "添加/更新客户信息",
		width : 540,
		height : 380,
		modal : false,
		draggable:false,
		href : 'headQSupplierMgmtJSPAction!preEditSupplier',
		
	});
}
function updateSupplier(id){
	var params = "formBean.supplier.id=" + id;
	$.modalDialog({
		title : "添加/更新客户信息",
		width : 540,
		height : 380,
		modal : false,
		draggable:false,
		href : 'headQSupplierMgmtJSPAction!preEditSupplier?' + params,
		
	});
}
function EditSupplier(){
	var rows = dataGrid.datagrid('getSelections');
	if (rows.length == 0){
		parent.$.messager.alert('错误', '请选中一个客户信息再继续操作', 'error');
		return;
	}
	
	var	id = rows[0].id;

	updateSupplier(id);
	

}

function searchSupplier(){
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
function cleanSearch(){
	$('#searchForm input').val('');
	dataGrid.datagrid('load', {});
}
function refresh(){
	dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',border:false" style="height: 35px; overflow: hidden;">
			<form id="searchForm" name="searchForm" method="post">
				<table border="0" class="table table-hover table-condensed" style="display: block;">
					<tr>
						<th>供应商名字首字母</th>
						<td><input name="formBean.supplier.pinyin" id="searchName" placeholder="可以模糊查询供应商名字首字母"/></td>
						<th colspan="2"></th>
					</tr>
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
				<table id="dataGrid">			       
		        </table>
	
			<div id="toolbar" style="display: none;">
			         <a onclick="searchSupplier();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">搜索供应商</a>
			         <a onclick="cleanSearch();" href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true">清空查询</a>
		             <a onclick="AddSupplier();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
                     <a onclick="EditSupplier();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'">更改</a>
                     <a onclick="refresh();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'">刷新</a>
	        </div>
		</div>
	</div>
</body>
</html>