<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>

<%@ page import="java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>连锁店/人员信息管理</title>
<%@ include file="../../common/Style.jsp"%>
<script>
$(document).ready(function(){
	parent.$.messager.progress('close'); 
});
function editChainStore(){
	var params=$("#EditChainInforForm").serialize(); 
	if (validateChainStore()) {
	    $.post("<%=request.getContextPath()%>/action/chainSMgmtJSON!saveChainStore",params, backProcessEditChainStore,"json");
	}
}
function backProcessEditChainStore(data){
	var error = data.error;
	JSON.stringify(data);
    if (error == true){
       var msg = data.msg;
       $.messager.alert('错误', "更新失败 : " + msg, 'error');
    } else {
    	var chainStore =  data.chainStore;
		if (chainStore != undefined){
			$("#chainName").val(chainStore.chain_name);
			$("#chainId").val(chainStore.chain_id);
			$("#chainStoreId").val(chainStore.chain_id);
			$.messager.alert('消息', "成功更新", 'info');
		} else 
		    $.messager.alert("更新失败", "更新失败 ", 'error');
    }
}
function deleteChainStore(){
	$.messager.prompt("密码验证","一旦删除这个连锁店，所有当前连锁店和他子连锁店的信息将会被永久删除.输入密码:", function(password){
		if (password == "vj7683c688"){
			var params="formBean.chainStore.chain_id=" + $("#chainStoreId").val();
			$.post("<%=request.getContextPath()%>/action/chainSMgmtJSON!deleteChainStore",params, backProcessDeleteChainStore,"json");
		} else {
			$.messager.alert('错误', "密码错误", 'error');
		}	   
	});

}
function backProcessDeleteChainStore(data){
	if (data.returnCode == SUCCESS){
		window.location.reload();
	} else {
		$.messager.alert('错误', "删除失败 : " + data.message, 'error');
		
	}
		
}


function changeChainStore(chainId){
	var params="formBean.chainStore.chain_id=" + chainId;
	$.post("<%=request.getContextPath()%>/action/chainSMgmtJSON!getChainStore",params, backProcessGetChainStore,"json");

}

function backProcessGetChainStore(data){
	var chainStore =  data.chainStoreInfor;

	if (chainStore != undefined){
		$("#chainId").attr("value", chainStore.chain_id);
		$("#chainStoreId").val(chainStore.chain_id);
		$("#chainOwner").val(chainStore.owner_name);
		$("#chainNameS").val(chainStore.chain_name);
		$("#clientId").val(chainStore.client_id);
		$("#initialAcctAmt").val(chainStore.initialAcctAmt);
		$("#status").val(chainStore.status);
		$("#allowEdit").val(chainStore.allowChangeSalesPrice);
		$("#initialAcctAmt").attr("readonly", "readonly");
        $("#clientId").attr("readonly", "readonly");
        $("#printHeader").val(chainStore.printHeader);

        var priceIncrement = chainStore.priceIncrement;
        var priceIncreTF = $("#priceIncrement");
        if (priceIncrement == null || priceIncrement.id == undefined){
            priceIncreTF.val(0);
        } else {
        	priceIncreTF.val(priceIncrement.id);
        }
        $("#allowAddBarcode").val(chainStore.allowAddBarcode);
        
        var parentStore = chainStore.parentStore;

        if (parentStore != undefined && parentStore.chain_id != undefined){
        	$("#parentChainName").val(parentStore.chain_name);
        	$("#parentChainId").val(parentStore.chain_id);
        } else {
        	$("#parentChainName").val("");
        	$("#parentChainId").val(0);
        }
	}

}
function clearChainStore(){
	$("#chainId").val(0);
	$("#chainStoreId").val(0);
	$("#chainOwner").val("");
	$("#chainNameS").val("");
	$("#chainName").val("");
	
	$("#initialAcctAmt").val("");
	$("#clientId").val("");
	$("#allowEdit").val("0");
	$("#initialAcctAmt").removeAttr("readonly");
	$("#clientId").removeAttr("readonly");
	$("#priceIncrement").val(0);
	$("#allowAddBarcode").val(0);
	
	$("#parentChainName").val("");
	$("#parentChainId").val(0);
	$("#printHeader").val("");
}


function validateChainStore(){
	var error = "";
	var chainOwner = $("#chainOwner").val();
	var chainNm = $("#chainNameS").val();

	if (chainNm == "")
		error += "连锁店名字 - 不能为空.<br\>";
	else if (chainNm.length > 20)
		error += "连锁店名字 - 超过最长20字.<br\>";

	if (chainOwner =="")
		error += "客户名字 - 不能为空.<br\>";

	if (error != ""){
		$.messager.alert('错误', error, 'error');
		return false;
	} else
		return true;
}


</script>
</head>
<body>
<table width="90%" align="center"  class="OuterTable">
    <tr><td>
        
		<table width="100%" border="0">
		 <s:form id="fakeForm" theme="simple">
	    <tr class="PBAOuterTableTitale">
	       <td height="78" colspan="8">连锁店/人员信息管理<br />
	         <br />
           - 通过这个界面管理员可以添加/修改/删除,连锁店信息以及连锁店员工信息<br/>           </td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td width="90" height="25">
	         <strong>连锁店</strong></td>
	      <td> <%@ include file="../include/SearchChainStore.jsp"%><input type="hidden" id="isAll" name="formBean.isAll" value="1"/>
	      <input type="button" value="清空数据,准备新增连锁店" onclick="clearChainStore();"/>
	      </td>
	      <td width="68">&nbsp;</td>
	      <td width="314">&nbsp;</td>
	      <td width="182">&nbsp;</td>
	      <td width="137">&nbsp;</td>
	    </tr>
	    </s:form>
	    <s:form id="EditChainInforForm" action="/action/chainSMgmtJSP!save" method="POST" theme="simple" target="_blank" onsubmit="" >
	    <tr class="InnerTableContent">
	      <td height="25"><strong>连锁店名字</strong></td>
	      <td><s:textfield id="chainNameS" name="formBean.chainStore.chain_name" size="25"/>
	      	  <s:hidden name="formBean.chainStore.chain_id" id="chainStoreId"/></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>负责人名字</strong></td>
	      <td colspan="2"><s:textfield id="chainOwner" name="formBean.chainStore.owner_name" size="25"/></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>修改零售价</strong></td>
	      <td colspan="2"><s:select id="allowEdit" name="formBean.chainStore.allowChangeSalesPrice"  list="#{0:'不能修改',1:'允许修改'}" listKey="key" listValue="value"/>
	      </td>
	      <td colspan="3"></td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>固定提价</strong></td>
	      <td colspan="5"><s:select id="priceIncrement" name="formBean.chainStore.priceIncrement.id"  list="uiBean.priceIncrements" listKey="id" listValue="description" headerKey="0" headerValue="------"/>
	      </td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>创建条码</strong></td>
	      <td colspan="5">
	           <s:select id="allowAddBarcode" name="formBean.chainStore.allowAddBarcode"  list="#{0:'不能添加',1:'允许添加条码'}" listKey="key" listValue="value" />
	      </td>
	    </tr>	    
	    <!--  
	    <tr class="InnerTableContent">
	      <td height="25"><strong>打印模板</strong></td>
	      <td colspan="4"><s:textfield id="printTemplate" name="formBean.chainStore.printTemplate" size="25"/></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>打印份数</strong></td>
	      <td colspan="4"><s:textfield id="printCopy" name="formBean.chainStore.printCopy" size="25"/></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>-->
	    <tr class="InnerTableContent">
	      <td height="25"><strong>客户账号</strong></td>
	      <td colspan="3"><s:textfield id="clientId" name="formBean.chainStore.client_id" size="15" onkeypress="return is_number(event);"/> *这个账号必须与客户开户账号一致</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>状态</strong></td>
	      <td colspan="2"><s:select name="formBean.chainStore.status" list="uiBean.statusMap" id="status" listKey="key" listValue="value" /></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"><strong>小票抬头</strong></td>
	      <td colspan="2"><s:textfield id="printHeader" name="formBean.chainStore.printHeader" size="25"/></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>	    
	    <tr class="InnerTableContent">
	      <td height="25"><strong>父连锁店名字</strong></td>
	      <td colspan="5">
	          <!-- 父亲连锁店选择 -->
	      <script>
			 function searchParentStore(){
				 var param = "";
				 var indicator = $("#indicator2").val();
				 var isAll = $("#isAll2").val();
				 
				 if (isAll != undefined)
					 param = "formBean.isAll=" + isAll;
			
				 if (indicator != undefined){
					 if (param != "")
						 param += "&";
					 param = "formBean.indicator=" + indicator;
				 }
				 
				 var url = "chainSMgmtJSP!listParentStore" + "?" + param;
				 
				 window.open(url,'新窗口','height=400, width=400, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');  
			}
			 
			function clearParentStore(){
				$("#parentChainId").val(0);
				$("#parentChainName").val("");
			}
			
			function selectParentStore(chainId, chainName){
				$("#parentChainId").val(chainId);
				$("#parentChainName").val(chainName);
			}
			</script>
			<s:hidden name="formBean.chainStore.parentStore.chain_id" id="parentChainId"/>
			<input type="hidden" id="isAll2" name="formBean.isAll" value="0"/>
			<s:textfield name="formBean.chainStore.parentStore.chain_name" id="parentChainName" size="18" readonly="true"/>
			<input type="button" id="checkChainStoreBt" value="..." onclick="searchParentStore();"/>
			<input type="button" id="clearParentStoreBt" value="清空" onclick="clearParentStore();"/>
			如果添加的是联营连锁店的鞋子账号，请在这里找到对应的实际连锁店账号
	          <!-- 父亲连锁店选择  -->
	      </td>
	    </tr>
	    <tr class="InnerTableContent">
	      <td height="25"></td>
	      <td colspan="2"><s:if test="#session.LOGIN_USER.containFunction('chainSMgmtJSON!saveChainStore')"><input type="button" value="添加/更新连锁店" onclick="editChainStore();"/></s:if></td>
	      <td><s:if test="#session.LOGIN_USER.containFunction('chainSMgmtJSON!deleteChainStore')"><input type="button" value="删除连锁店" onclick="deleteChainStore();"/></s:if></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	  
	  </s:form>
	  </table>
   </td>
   </tr>

 </table>


</body>
</html>