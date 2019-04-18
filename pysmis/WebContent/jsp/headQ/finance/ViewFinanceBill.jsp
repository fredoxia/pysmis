<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.common.Common_util" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../common/Style.jsp"%>
<script>
$(document).ready(function(){
	parent.$.messager.progress('close'); 
});
function editBill(){
	document.financeBillForm.action = "<%=request.getContextPath()%>/action/financeHQJSP!editFHQBill";
	document.financeBillForm.submit();
}

function cancelBill(){
	document.financeBillForm.action = "<%=request.getContextPath()%>/action/financeHQJSP!cancelFHQBill";
	document.financeBillForm.submit();
}
function printBill(){
	alert("财务单据打印功能还未完善");
	 /*var url = "<%=request.getContextPath()%>/action/financeHQJSON!printOrder";
	 var params=$("#financeBillForm").serialize();  
	 
	 $.post(url,params, printOrderBackProcess,"json");*/	
}	
function printOrderBackProcess(data){
   var response = data;
	var returnCode = response.returnCode;

	if (returnCode != SUCCESS)
		alert("获取单据失败 ： " + response.message);
	else {
       alert(response.returnValue);
	}
}
</script>
</head>
<body>
    <s:form action="/action/financeHQJSP!editFHQBill" method="POST" name="financeBillForm"  id="financeBillForm" theme="simple">
     <s:hidden name="formBean.order.id"/> 
	<table width="70%" align="center"  class="OuterTable">
	    <tr><td>
		 <table width="100%" border="0">
		    <tr>
		      <td colspan="7">
		      		    <div class="errorAndmes"><s:actionerror cssStyle="color:red"/><s:actionmessage cssStyle="color:blue"/></div>
						<table width="100%"  align="left" border="0" id="org_table">
							<tr class="PBAOuterTableTitale">
	                            <td height="50" colspan="4"> 批发财务单据  
	                            </td>
		    				</tr>
						   <tr class="InnerTableContent">
						     <td width="180" height="35">单据种类 ： <s:property value="uiBean.order.typeHQS"/> <s:property value="uiBean.order.id"/></td>
						     <td width="180">连锁店 ： <s:property value="uiBean.order.cust.name"/> </td>
						     <td width="180">过账日期:<s:date name="uiBean.order.createDate" format="yyyy-MM-dd" /></td>
						     <td width="100">
						          <s:if test="uiBean.order.inventoryOrderId != 0">
					                   <a href='#' onclick='addTab3("inventoryOrder!loadOrder?formBean.order.order_ID=<s:property value="uiBean.order.inventoryOrderId"/>","批发销售单据<s:property value="uiBean.order.inventoryOrderId"/>")'> 批发销售单据<s:property value="uiBean.order.inventoryOrderId"/></a>
					              </s:if>	
						     </td>
					       </tr>
						   <tr class="InnerTableContent">	      
							 <td height="25">经手人:<s:property value="uiBean.order.creatorHq.user_name"/></td>
							 <td> 状态 ： <s:if test="uiBean.order.status == 3"><font style="color:red"><s:property value="uiBean.order.statusS"/></font></s:if><s:else>
							 				<s:property value="uiBean.order.statusS"/>
							 		   </s:else>
							 </td>
							 <td>备注 ： <s:property value="uiBean.order.comment"/></td>
							 <td></td>
					       </tr>
					       <tr class="InnerTableContent">	
					         <td height="25">折扣:<s:property value="uiBean.order.invoiceDiscount"/></td>      
							 <td>上欠:<s:property value="uiBean.order.preAcctAmt"/></td>
							 <td>下欠 ： <s:property value="uiBean.order.postAcctAmt"/></td>
							 <td></td>
					       </tr>
				       </table>
			      </td>
			    </tr>
			    
			    <tr class="InnerTableContent">
			      <td height="4" colspan="7"><hr width="100%" color="#FFCC00"/></td>
			    </tr>
				<tr>
				  <td><table width="100%"  align="left" class="OuterTable" id="org_table">
	                  <tr class="PBAInnerTableTitale" align='left'>
	                    <th width="60" height="35">序号</th>
	                    <th width="110">账户名称</th>
	                    <th width="120">金额</th>
	                    <th width="199">说明</th>
	                  </tr>
	                  <s:iterator value="uiBean.order.financeBillItemList" status="st" id="billItem" >
	                    <tr class="InnerTableContent" <s:if test="#st.even">style="<%=Common_util.EVEN_ROW_BG_STYLE %>"</s:if>>
	                      <td height="25"><s:property value="#st.index + 1"/></td>
	                      <td><s:property value="#billItem.financeCategory.itemName"/></td>
	                      <td><s:property value="#billItem.total"/></td>
	                      <td><s:property value="#billItem.comment"/></td>
	                    </tr>
	                  </s:iterator>
	                  <tr align='left' class="PBAInnerTableTitale">
	                    <td height="35" colspan="2">总计</td>
	                    <td><s:property value="uiBean.order.invoiceTotal"/></td>
	                    <td></td>
	                  </tr>
	                </table></td>
				</tr>
				<tr class="InnerTableContent">
			      <td height="4" colspan="7">
			          <s:if test="#session.LOGIN_USER.containFunction('financeHQJSP!editFHQBill') && formBean.canEdit"> 
			                 <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editBill();">修改单据</a>
			          </s:if>
			          <s:if test="#session.LOGIN_USER.containFunction('financeHQJSP!cancelFHQBill') && formBean.canCancel"> 
			                 <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'" onclick="cancelBill();">红冲单据</a>
			          </s:if>
			          <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-print'" onclick="printBill();">打印单据</a>
			      </td>
			    </tr>
			  </table>
		   </td></tr>
	   		    <tr class="InnerTableContent">
		      <td height="4" colspan="7"><hr width="100%" color="#FFCC00"/></td>
		    </tr>
	 </table>
	 </s:form>
</body>
</html>