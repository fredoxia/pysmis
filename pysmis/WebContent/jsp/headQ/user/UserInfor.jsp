<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工信息管理</title>
<%@ include file="../../common/Style.jsp"%>
<script>
$(document).ready(function(){
	parent.$.messager.progress('close'); 
});


function submitUser(userId){
    //clearAllData();

    if (userId != 0){
	    var params=$("#userInforForm").serialize();  
	    $.post("userJSON!getUser",params, getUserBackProcess,"json");	
    }
}
function getUserBackProcess(data){
    var user = data.user;
	
    if (user != ""){
    	$("#name").textbox("setValue",user.name);
    	$("#passwordU").val(user.password);
    	$("#user_name").textbox("setValue",user.user_name);
    	$("#roleType").val(user.roleType);

    	var departmentCode = user.department;
    	var departSlect = $("#department");
        departSlect.combobox("setValue",departmentCode);

        if (user.onBoardDate.year == undefined)
        	 $("#onBoardDate").datebox("setValue","");
        else
    	    $("#onBoardDate").datebox("setValue",formatDay(user.onBoardDate.year,user.onBoardDate.month,user.onBoardDate.date));
    	$("#homePhone").textbox("setValue",user.homePhone);
    	$("#mobilePhone").numberbox("setValue",user.mobilePhone);
    	if (user.birthday.year == undefined)
    	    $("#birthday").textbox("setValue","");
    	else
    	   $("#birthday").textbox("setValue",formatDay(user.birthday.year,user.birthday.month,user.birthday.date));
    	$("#jobTitle").textbox("setValue",user.jobTitle);
    	$("#baseSalary").textbox("setValue",user.baseSalary);
    	$("#baseVacation").textbox("setValue",user.baseVacation);
    	$("#idNumber").textbox("setValue",user.idNumber);

    	if (user.resign ==0)
    		$("#resign").attr("checked",false);
    	else
    		$("#resign").attr("checked",true);
    }else {
    	alert("获取员工信息发生错误!");
    }
}

function formatDay(year, month, day){
	year = 1900 + year;
	month = month +1;
	if (month <10)
		month = "0" + month;
	if (day <10)
		day = "0" + day;
	return year +"-" + month + "-" +day;
}

function clearAllData(){
	$("#name").textbox("setValue","");
	$("#passwordU").textbox("setValue","");
	$("#user_name").textbox("setValue","");
	$("#department").textbox("setValue","");
	$("#onBoardDate").datebox("setValue","");
	$("#homePhone").textbox("setValue","");
	$("#mobilePhone").numberbox("setValue","");
	$("#birthday").textbox("setValue","");
	$("#jobTitle").textbox("setValue","");
	$("#baseSalary").textbox("setValue","");
	$("#baseVacation").textbox("setValue","");
	$("#idNumber").textbox("setValue","");
	$("#roleType").val(0);

	$("#userNameDiv").html("");
	$("#resign").attr("checked",false);
}

function saveOrUpdate(){
	if (validate()){
		var params=$("#userInforForm").serialize();  
		$.post("userJSON!checkUserName",params, submitBackProcess,"json");	
	}
}


function submitBackProcess(data){
	var result = data.result;
	var userName = $("#user_name").val();
	if (result == true){
		$.messager.alert('错误', userName + " 已经在使用", 'error');
		$("#userNameDiv").html(userName + " 已经在使用");
	}else{
		document.userInforForm.action="userJSP!saveOrUpdate";
		document.userInforForm.submit();
	}
}

function validate(){
	var error = "";

    if (!$('#userInforForm').form('validate'))
    	return false ;
	
	if ($("#department").val() == ""){
		error +="部门 - 不能为空\n";
		$("#department").focus();
	}	

    
	if (error == "")
		return true;
	else{
		$.messager.alert('错误', error, 'error');
		return false;
	}
		
}
</script>

</head>
<body>

<s:form id="userInforForm" name="userInforForm" action="" method="POST" theme="simple">
 <table width="90%" align="center"  class="OuterTable">
 <tr><td>

 <table width="100%" border="0">
    <tr class="PBAOuterTableTitale">
       <td colspan="6">员工信息管理</td>
    </tr>
    <tr>
       <td colspan="6" height="6"><s:fielderror/></td>
    </tr>
    <tr class="InnerTableContent">
      <td width="87" height="19"><strong>现有员工：</strong></td>
      <td width="100">
       <s:select name="formBean.userInfor.user_id" id="user_id" cssClass="easyui-combobox"  style="width:100px;"  list="uiBean.users" listKey="user_id" listValue="name" data-options="onChange:function(current, old){submitUser(current);}" headerKey="0" headerValue="---新增---" />

      </td>
      <td width="88">&nbsp;</td>
      <td width="125"></td>
      <td width="90">&nbsp;</td>
      <td width="392"></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="4" colspan="6"><hr width="100%" color="#FFCC00"/></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="19"><strong>员工姓名：</strong></td>
      <td>
         <input type="text" name="formBean.userInfor.name" id="name" class="easyui-textbox"  data-options="required:true"/>
         <input type="hidden" name="formBean.userInfor.roleType" id="roleType" value="0"/>
         
      </td>
      <td><strong>部门：</strong></td>
      <td>
         <select name="formBean.userInfor.department"  size="1" id="department"  style="width:100px;" class="easyui-combobox"  data-options="required:true">
             <option value="">---------</option>
             <option value="01">会计部</option>
             <option value="02">销售部</option>
             <option value="03">物流部</option>
         </select>
      </td>
      <td><strong>入职时间：</strong></td>
      <td>
        <s:textfield id="onBoardDate" name="formBean.userInfor.onBoardDate"  cssClass="easyui-datebox"/>
      </td>
    </tr>
   <tr class="InnerTableContent">
      <td height="4" colspan="6"><hr width="100%" color="#FFCC00"/></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="19"><strong>住宅电话：</strong></td>
      <td>
      <input type="text" name="formBean.userInfor.homePhone" id="homePhone" class="easyui-textbox"  data-options="validType:'length[0,14]'"/>

      </td>
      <td><strong>手机号：</strong></td>
      <td> 
         <input type="text" name="formBean.userInfor.mobilePhone" id="mobilePhone" class="easyui-numberbox"  data-options="required:true,precision:0,validType:'length[11,11]'"/>
      </td>
      <td><strong>生日：</strong></td>
      <td>
        <s:textfield id="birthday"  name="formBean.userInfor.birthday"  cssClass="easyui-datebox"/>   
      </td>
    </tr>

    <tr class="InnerTableContent">
      <td height="4" colspan="6"><hr width="100%" color="#FFCC00"/></td>
    </tr>
        <tr class="InnerTableContent">
      <td height="19"><strong>职位：</strong></td>
      <td>
        <input type="text" name="formBean.userInfor.jobTitle" id="jobTitle"  class="easyui-textbox"/>
      </td>
      <td><strong>基本工资：</strong></td>
      <td>
        <input type="text" name="formBean.userInfor.baseSalary" id="baseSalary"  class="easyui-numberbox"/> 
      </td>
      <td><strong>基本假期：</strong></td>
      <td>
        <input type="text" name="formBean.userInfor.baseVacation" id="baseVacation"  class="easyui-numberbox" data-options="precision:0"/>
      </td>
    </tr>

    <tr class="InnerTableContent">
      <td height="4" colspan="6"><hr width="100%" color="#FFCC00"/></td>
    </tr>
        <tr class="InnerTableContent">
      <td height="19"><strong>身份证：</strong></td>
      <td>
        <input type="text" name="formBean.userInfor.idNumber" id="idNumber"  class="easyui-textbox"  data-options="validType:'length[0,18]'"/>
      </td>
      <td><strong>用户名：</strong> 
      </td>
      <td>
         <input type="text" name="formBean.userInfor.user_name" id="user_name"  onchange="checkUserName();" class="easyui-textbox"  data-options="required:true"/><div id="userNameDiv"></div> 
      </td>
      <td><strong>系统密码：</strong> </td>
      <td>
         <input type="text" name="formBean.userInfor.password" id="passwordU"  class="easyui-textbox"  data-options="required:true,validType:'length[4,8]'"/> 
      </td>
    </tr>
    <tr class="InnerTableContent">
      <td height="4" colspan="6"><hr width="100%" color="#FFCC00"/></td>
    </tr>
        <tr class="InnerTableContent">
      <td height="19"><strong>离职：</strong></td>
      <td>
        <input type="checkbox" name="formBean.userInfor.resign" id="resign" value="1" />
      </td>
      <td> </td>
      <td colspan="3"></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="4" colspan="6"><hr width="100%" color="#FFCC00"/></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="30">&nbsp;</td>
      <td><a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveOrUpdate();">保存更新</a></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr class="InnerTableContent">
      <td height="2" colspan="6"></td>
    </tr>
  </table>
  </td></tr>
 </table>
</s:form>

</body>
</html>