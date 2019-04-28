<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.ORM.entity.headQ.barcodeGentor.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>朴与素连锁店管理信息系统</title>
<script>

</script>
</head>
<body>
<script>
function saveCust(){
	if ( $('#updateCustForm').form('validate')){
	    var params=$("#updateCustForm").serialize();
    	$.post("headQCustMgmtJSONAction!createUpdateCust",params, updateCustBKProcess,"json");	
	}
}
function updateCustBKProcess(data){
	var returnCode = data.returnCode;
	if (returnCode != SUCCESS)
		$.messager.alert('失败信息', data.message,'error');
	else {
		$.modalDialog.handler.dialog('close');
		$("#dataGrid").datagrid('reload');
	}		
}
function cancel(){
	$.modalDialog.handler.dialog('close');
}

</script>
    <s:form id="updateCustForm" name="updateCustForm" method="post"  theme="simple"  cssClass="easyui-form">
	    <div class="errorAndmes"><s:actionerror cssStyle="color:red"/><s:actionmessage cssStyle="color:blue"/></div>
	    <table width="100%" border="0">
	       <tr class="PBAOuterTableTitale">
	          <td colspan="2">新建/更新客户信息</td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td>客户名字    :</td><td>
	          <s:hidden name="formBean.cust.id"/>
	          <s:textfield id="name" name="formBean.cust.name" cssClass="easyui-textbox" data-options="required:true,validType:'length[2,20]'"/>*</td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td>客户地区         :</td>
	          <td><s:textfield id="area" name="formBean.cust.area" cssClass="easyui-textbox" data-options="required:true,validType:'length[2,10]'"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td>客户地址         :</td>
	          <td><s:textfield id="address" name="formBean.cust.address" cssClass="easyui-textbox" data-options="required:true,validType:'length[2,50]'"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td>电话      :</td>
	          <td><s:textfield id="phone" name="formBean.cust.phone" cssClass="easyui-textbox" data-options="required:true,validType:'length[5,20]'"/></td>
	       </tr>
       
	       <tr class="InnerTableContent">
	          <td>当前账目      :</td><td><s:property value="formBean.cust.currentAcctBalance"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td>备注      :</td>
	          <td><s:textfield id="comment" name="formBean.cust.comment" cssClass="easyui-textbox" data-options="validType:'length[0,50]'" /></td>
	       </tr>	  
	       <tr class="InnerTableContent">
	          <td>状态      :</td>
	          <td><s:select name="formBean.cust.status" id="status" cssClass="easyui-combobox"  style="width:80px;" list="#{'0':'正常','1':'冻结'}" listKey="key" listValue="value" /> </td>
	       </tr>		            
	       <tr class="InnerTableContent">
	       <td colspan="2">
	          <a onclick="saveCust();" href="javascript:void(0);" class="easyui-linkbutton">保存</a>
	          <a onclick="cancel();" href="javascript:void(0);" class="easyui-linkbutton">退出</a>
	       </td>
	       </tr>
	    </table>
	    </s:form>

	      
</body>
</html>