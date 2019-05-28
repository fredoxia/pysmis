<%@page import="com.onlineMIS.ORM.entity.headQ.supplier.finance.FinanceCategorySupplier"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.common.Common_util,com.onlineMIS.ORM.entity.headQ.supplier.finance.FinanceBillSupplier,com.onlineMIS.ORM.entity.headQ.supplier.finance.FinanceCategorySupplier" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../../common/Style.jsp"%>
<script>
var itemSize = <s:property value="formBean.order.financeBillItemList.size"/>;
var paidBillType = <%=FinanceBillSupplier.FINANCE_PAID_HQ%>;
var incomeBillType = <%=FinanceBillSupplier.FINANCE_INCOME_HQ%>;

var increaseBillType = <%=FinanceBillSupplier.FINANCE_INCREASE_HQ%>;
var increaseDecreaseAcctType =  <%=FinanceCategorySupplier.INCREASE_DECREASE_ACCT_TYPE%>;
var decreaseBillType = <%=FinanceBillSupplier.FINANCE_DECREASE_HQ%>;

$(document).ready(function(){
	parent.$.messager.progress('close'); 
	for (var i = 0; i < itemSize; i++){
        $("#financeBillItem" + i).numberbox({
           onChange: function (newValue,oldValue) {
        	   recalcualteTotal();
          }
        });
	}
});
function saveToDraft(){
	if (validateForm()){
		var params = $("#financeBillForm").serialize(); 
	    $.post("<%=request.getContextPath()%>/action/financeSupplierJSON!saveFBToDraft",params, financeBillBK,"json");	
	}
}
function postBill(){
	if (validateForm()){
		var params = $("#financeBillForm").serialize(); 
	    $.post("<%=request.getContextPath()%>/action/financeSupplierJSON!postFB",params, financeBillBK,"json");	
	}
}
function financeBillBK(data){
	var response = data.response;
	var returnCode = response.returnCode;
	if (returnCode != SUCCESS)
		$.messager.alert('错误', response.message, 'error');
	else{
		$.messager.alert({
			title: '保存成功',
			msg: response.message,
			fn: function(){
				window.location.href = "financeSupplierJSP!preCreate";
			}
		});
	}
}
function deleteBill(){

	$.messager.confirm('删除单据确认', "你确定要删除单据", function(r){
		if (r){
			   document.financeBillForm.action = "<%=request.getContextPath()%>/action/financeSupplierJSP!deleteFB";
			   document.financeBillForm.submit();
		}
	});
}
function cancelBill(){
	$.messager.confirm('红冲单据确认', "你确定要红冲单据", function(r){
		if (r){
			   document.financeBillForm.action = "<%=request.getContextPath()%>/action/financeSupplierJSP!cancelFB";
			   document.financeBillForm.submit();
		}
	});	
}
function recalcualteTotal(){
	var invoiceTotalInput = $("#invoiceTotal");
	var total =0;
	for (var i = 0; i < itemSize; i++){
	    var itemTotalS = $("#financeBillItem" + i).numberbox('getValue');
	    var itemTotal ;
	    if (itemTotalS == "")
		    itemTotal = 0;
	    else 
	    	itemTotal = parseFloat(itemTotalS);
		total += itemTotal;
	}
	invoiceTotalInput.attr("value", (total).toFixed(2));
}

function validateForm(){
	var charInNum = false;
	var error = "";
	
	if (!$('#financeBillForm').form('validate'))
		return;
	
//alert(itemSize);
	for (var i = 0; i < itemSize; i++){
	    var itemTotalS = $("#financeBillItem" + i).numberbox('getValue');

	    if (itemTotalS == "")
		    itemTotal = 0;
	    else if (isNaN(itemTotalS))
			charInNum = true;
	    else if (itemTotalS < 0)
	    	charInNum = true;
	}
//alert(charInNum);
	var invoiceTotal = $("#invoiceTotal").val();
	if (isNaN(invoiceTotal))
		charInNum = true;
	else if (parseFloat(invoiceTotal) == 0) 
		error += "单据没有输入金额项,请检查<br\>";

	if (charInNum)
		error += "金额 - 只能允许输入大于零数字,请检查<br\>";
//alert(invoiceTotal);
	var billType = $("#financeBillType").val();
	var financeBillSupplier = $("#supplierId").val();

	if (billType == 0){
		error += "单据种类 - 不能为空<br\>";
	}

	if (financeBillSupplier == 0){
		error += "供应商  - 不能为空<br\>";
	}	
//alert(financeBillSupplier);
//alert(billType +"," + increaseBillType + "," + decreaseBillType);
	//2. check the increase/decrease bill type
	if (billType == increaseBillType || billType == decreaseBillType){
		for (var i = 0; i < itemSize; i++){
		    var acctType = $("#acctType" + i).val();

		    if (acctType != increaseDecreaseAcctType && $("#financeBillItem"+i).val() !=0){
		    	error += "应收增加/减少单据  - 只能选择'应收增加/减少'账户<br\>";
			}  
		}
	}

//alert(billType);
	//3. check the income/paid bill type
	if (billType == incomeBillType || billType == paidBillType){
		for (var i = 0; i < itemSize; i++){
		    var acctType = $("#acctType" + i).val();

		    if (acctType == increaseDecreaseAcctType && $("#financeBillItem"+i).val() !=0){
		    	error += "付款单/收款单  - 不能选择'应收增加/减少'账户<br\>";
			}  
		}
	}	
//alert(increaseDecreaseAcctType);

	if (error != ""){
		$.messager.alert('验证错误', error, 'error');
       return false;
	} else
		return true;
}

function getSupplierFinance(supplierId){
	//var chainId = $("#financeBillChainStore").val();
	if (supplierId != 0){
	    var params = "formBean.order.supplier.id=" + supplierId; 
	    $.post("financeSupplierJSON!getSupplierAcctFinance",params, getCurrFinanceBackProcess,"json");
	} else 
		$("#currentFinance").html("");
}

function getCurrFinanceBackProcess(data){
	var response = data.response;
	if (response.returnCode != SUCCESS){
		$("#currentFinance").html("");
		$.messager.alert('错误', response.message, 'error');
	} else {
		var dataMap = response.returnValue
		$("#currentFinance").html("当前待付款 : " + dataMap.cf);
	}
		
}

function chooseSupplier(supplierId){

	getSupplierFinance(supplierId);
}
</script>
</head>
<body>

    <s:form action="/action/financeHQJSP!saveToDraft" method="POST" name="financeBillForm"  id="financeBillForm" theme="simple">
    
	<table width="80%" align="center"  class="OuterTable">
	    <tr><td>
		 <table width="100%" border="0">
		    <tr>
		      <td colspan="7">
		      		    <div class="errorAndmes"><s:actionerror cssStyle="color:red"/><s:actionmessage cssStyle="color:blue"/></div>
						<table width="100%"  align="left" border="0" id="org_table">
							<tr class="PBAOuterTableTitale">
	                            <td height="50" colspan="3"> 供应商财务单据 <s:property value="formBean.order.statusS"/><br/> 
	                            - 总部管理人员通过此功能创建/修改/删除供应商之间的往来财务单据
	                            <s:hidden name="formBean.order.id"/> </td>
		    				</tr>
						   <tr class="InnerTableContent">
						     <td width="200" height="35">单据种类 ： <s:select  cssClass="easyui-combobox"  style="width:100px;" data-options="editable:false" id="financeBillType" name="formBean.order.type"  list="formBean.order.typeHQMap" listKey="key" listValue="value" /></td>

						     <td>日期 ：  <s:textfield id="billDate" name="formBean.order.billDate" cssClass="easyui-datebox"  data-options="width:100,editable:false"/>	  
							</td>
							 <td width="400">供应商 ： <%@ include file="../SupplierInput.jsp"%>
								              <div style="display:block;" id="currentFinance"></div>
						     </td>
					       </tr>
						   <tr class="InnerTableContent">	      
							<td height="25" colspan="3"> 备注 ： <s:textfield cssClass="easyui-textbox" style="width:300px" name="formBean.order.comment" /></td>
					      </tr>
					      <tr class="InnerTableContent">	      
							<td height="25" colspan="3"> 折让 ： <s:textfield cssClass="easyui-numberbox" name="formBean.order.invoiceDiscount"/></td>
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
	                  <s:iterator value="formBean.order.financeBillItemList" status="st" id="billItem" >
	                    <tr class="InnerTableContent" <s:if test="#st.even"> style='<%=Common_util.EVEN_ROW_BG_STYLE %>'</s:if>>
	                      <td height="25"><s:property value="#st.index + 1"/></td>
	                      <td><s:property value="#billItem.financeCategorySupplier.itemName"/>
	                          <input type="hidden" id="acctType<s:property value="#st.index"/>" name="formBean.order.financeBillItemList[<s:property value="#st.index"/>].financeCategorySupplier.type" value="<s:property value="#billItem.financeCategorySupplier.type"/>"/>
	                          <input type="hidden" name="formBean.order.financeBillItemList[<s:property value="#st.index"/>].id" value="<s:property value="#billItem.id"/>"/>
	                          <input type="hidden" name="formBean.order.financeBillItemList[<s:property value="#st.index"/>].financeCategorySupplier.id" value="<s:property value="#billItem.financeCategorySupplier.id"/>"/>
	                      </td>
	                      <td><input type="text" id="financeBillItem<s:property value="#st.index"/>" name="formBean.order.financeBillItemList[<s:property value="#st.index"/>].total" value="<s:property value="#billItem.total"/>" size="6"  class="easyui-numberbox" value="0" data-options="min:-100000,precision:2" onchange="recalcualteTotal();"/></td>
	                      <td><input type="text" name="formBean.order.financeBillItemList[<s:property value="#st.index"/>].comment" value="<s:property value="#billItem.comment"/>"  class="easyui-textbox" data-options="validType:'length[0,20]'"/></td>
	                    </tr>
	                  </s:iterator>
	                  <tr align='left' class="PBAInnerTableTitale">
	                    <td height="35" colspan="2">总计</td>
	                    <td><s:textfield id="invoiceTotal" name="formBean.order.invoiceTotal" readonly="true" size="6"/></td>
	                    <td></td>
	                  </tr>
	                </table></td>
				</tr>
				<tr class="InnerTableContent">
			      <td height="4" colspan="7">
			          <s:if test="#session.LOGIN_USER.containFunction('financeSupplierJSON!saveFBToDraft')  && formBean.canSaveDraft">
			                 <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveToDraft();">保存草稿</a>
			          </s:if>
			          <s:if test="#session.LOGIN_USER.containFunction('financeSupplierJSON!postFB') && formBean.canPost">
			                  <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="postBill();">单据过账</a>
			          </s:if>
			          <s:if test="#session.LOGIN_USER.containFunction('financeSupplierJSP!deleteFB') && formBean.canDelete"> 
			               <a id="btn2" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="deleteBill();">删除单据</a>
			          </s:if>
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