<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.ORM.entity.headQ.barcodeGentor.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>朴与素连锁店管理信息系统</title>

</head>
<body>
<script>
function updateColor(){
    if ($('#updateColorForm').form('validate')){
    	var params=$("#updateColorForm").serialize();

        $.post("basicDataJSON!updateColor",params, updateColorBKProcess,"json");	
	}
}
function updateColorBKProcess(data){
	var response = data.response;
	var returnCode = response.returnCode;
	if (returnCode != SUCCESS)
		$.messager.alert('操作失败', response.message, 'error');
	else {
		$.modalDialog.handler.dialog('close');
		$("#dataGrid").datagrid('reload');
	}		
}
</script>
    <s:form id="updateColorForm" name="updateColorForm" method="post"  cssClass="easyui-form" action="action/basicData!saveUpdateColor" theme="simple" onsubmit="return validateForm();">
	    <table width="100%" border="0">
	       <tr>
	          <td colspan="2"><font color="red"><s:fielderror/></font><s:actionmessage/>
	          </td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td>颜色序号:</td><td><s:textfield name="formBean.color.colorId" cssClass="easyui-textbox"  readonly="true"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td>颜色    :</td><td><s:textfield id="color" name="formBean.color.name" cssClass="easyui-textbox" data-options="required:true,validType:['required','length[1,4]']"/>*</td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td colspan="2"><a onclick="updateColor();" href="javascript:void(0);" class="easyui-linkbutton">新建/修改</a></td>
	       </tr>
	    </table>
	    </s:form>
   
</body>
</html>