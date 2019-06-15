<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<%@ page import="com.onlineMIS.ORM.entity.headQ.barcodeGentor.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改条型码资料</title>
<%@ include file="../../common/Style.jsp"%>
<script>
$(document).ready(function(){
	parent.$.messager.progress('close'); 
	$("#org_table tr").mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
	$("#clearBt").removeAttr("disabled");
});

function del(){
	var info = "你确定删除此商品条码信息?<br\>此商品信息一经删除所有相关单据都将删除对应信息!";
	$.messager.confirm('确认', info, function(r){
		if (r){
		    var params=$("#updateProductForm").serialize();  
		    $.post("action/productJSONAction!checkBarcode",params, backProcess,"json");
		} 
	});
 
}
function backProcess(data){
	var result = data.result;
	if (result == false){
	  document.updateProductForm.action = "action/productJSPAction!delete";
	  document.updateProductForm.submit();
	} else {
	  $.messager.alert('操作失败', "此条码已经使用无法删除！",'error');
	}
}
function update(){
	if ($('#updateProductForm').form('validate')){
		var error = "";

		var brandId = $("#brand_ID").val();
		if (brandId == "" || brandId == 0){
	          error += "品牌 - 是必选项<br/>";
		} else if (!isValidPositiveInteger(brandId)) {
	        error += "品牌 - 必须是系统已经存在的信息，请检查<br/>";
		}
		
		var categoryId = $("#category").combobox("getValue");
		if (categoryId == ""){
	          error += "货品类 - 是必选项<br/>";
		} else if (!isValidPositiveInteger(categoryId)) {
	        error += "货品类 - 必须是系统已经存在的类别，请检查<br/>";
		}
		
		var sizeMin = $("#sizeMin").combobox("getValue");
		var sizeMax = $("#sizeMax").combobox("getValue");
		
		if (sizeMin != ""){
			if (sizeMax == ""){
				error += "最小码段 和 最大码段  应该同时填写或者同时空白\n";
			} else if (parseInt(sizeMin) > parseInt(sizeMax)){
				error += "最小码段 应该小于 最大码段 \n";
			}
		} else {
			if (sizeMax != ""){
				error += "最小码段 和 最大码段  应该同时填写或者同时空白\n";
			}
		}

	
		if (error == ""){
			if (error != "")
			    $.messager.alert('操作失败', error,'error');
			else {
				document.updateProductForm.action = "action/productJSPAction!update";
				document.updateProductForm.submit();
			}
		} else{
			$.messager.alert('操作失败', error,'error');

		}
    }
	

}
</script>
</head>
<body>
    <table width="90%" align="center"  class="OuterTable">
    <tr><td>
        <s:form id="updateProductForm" cssClass="easyui-form" name="updateProductForm" method="post" action="" theme="simple">
	    <table width="100%" border="0" id="org_table">
	       <tr class="PBAOuterTableTitale">
	          <th colspan="2">修改条形码信息</th>
	       </tr>
	       <tr>
	          <td colspan="2"><div class="errorAndmes"><s:actionerror cssStyle="color:red"/><s:actionmessage cssStyle="color:blue"/></div>
	          </td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>归属</strong>   :</td><td>
	              
	              <s:if test="uiBean.product.chainStore != null">
	              	<s:property value="uiBean.product.chainStore.chain_name"/>
	              </s:if><s:else>
	                总部
	              </s:else>
	          </td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>商品编码</strong>    :</td>
	          <td><s:property value="uiBean.product.product.serialNum"/></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>条形码 </strong>  : </td>
	          <td><s:property value="uiBean.product.barcode"/>
	              <input type="hidden" name="formBean.productBarcode.barcode" value="<s:property value="uiBean.product.barcode"/>"/>
	              <input type="hidden" name="formBean.productBarcode.id" value="<s:property value="uiBean.product.id"/>"/>
	              <input type="hidden" name="formBean.productBarcode.product.productId" value="<s:property value="uiBean.product.product.productId"/>"/>
	          </td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>品牌 </strong>        :</td>
	          <td><%@ include file="SearchBrandStub.jsp"%></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>年份  </strong>       :</td>
	          <td><s:select name="formBean.productBarcode.product.year.year_ID" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false"  size="1" id="year" list="uiBean.basicData.yearList"  listKey="year_ID" listValue="year"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>季度</strong>         :</td>
	          <td><s:select name="formBean.productBarcode.product.quarter.quarter_ID" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false"  size="1" id="quarter" list="uiBean.basicData.quarterList"  listKey="quarter_ID" listValue="quarter_Name"/></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>类别</strong>       :</td>
	          <td><s:select name="formBean.productBarcode.product.category.category_ID" cssClass="easyui-combobox"  style="width:80px;"  size="1" id="category" list="uiBean.basicData.categoryList"  listKey="category_ID" listValue="category_Name"/></td>
	       </tr>

	      <tr class="InnerTableContent">
	          <td height="18"><strong>产品货号</strong>:</td><td><s:textfield name="formBean.productBarcode.product.productCode"  cssClass="easyui-textbox" style="width:80px;" id="productCode"  data-options="required:true,validType:['required','length[3,20]']" />*</td>
	       </tr>	
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>齐码数量 </strong>   :</td>
	          <td><s:select name="formBean.productBarcode.product.numPerHand" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false"  size="1" id="numPerHand" list="uiBean.basicData.numPerHandList" listKey="numPerHand" listValue="numPerHand"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>单位 </strong> :</td>
	          <td><s:select name="formBean.productBarcode.product.unit" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false"  size="1" id="unit" list="uiBean.basicData.unitList" listKey="productUnit" listValue="productUnit"/></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>颜色</strong>         :</td><td><s:property value="uiBean.product.color.name"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>连锁零售价 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.salesPrice" class="easyui-numberbox"  data-options="required:true,min:0,max:999,precision:0" size="9" style="width:80px;" id="salesPrice" value="<s:if test="uiBean.product.product.salesPrice!=0"><s:property value="uiBean.product.product.salesPrice"/></s:if>" size="10"/></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>进价 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.recCost" id="recCost" class="easyui-numberbox"  data-options="required:true,min:0,max:999,precision:1" size="9" style="width:80px;" value="<s:if test="uiBean.product.product.recCost!=0"><s:property value="uiBean.product.product.recCost"/></s:if>" size="10"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>进价(调价) </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.recCost2" id="recCost2" class="easyui-numberbox"  data-options="min:0,max:999,precision:1" size="9" style="width:80px;" value="<s:if test="uiBean.product.product.recCost2!=0"><s:property value="uiBean.product.product.recCost2"/></s:if>" size="10"/></td>
	       </tr>	       
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>预设价1 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.wholeSalePrice" class="easyui-numberbox"  data-options="min:0,max:999,precision:1" size="9" style="width:80px;" id="wholeSalePrice" value="<s:if test="uiBean.product.product.wholeSalePrice!=0"><s:property value="uiBean.product.product.wholeSalePrice"/></s:if>" size="10"/></td>
	       </tr>
	       <tr class="InnerTableContent">
	          <td height="18"><strong>预设价2 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.wholeSalePrice2" id="wholeSalePrice2"  data-options="min:0,max:999,precision:1" size="9" class="easyui-numberbox" style="width:80px;" value="<s:if test="uiBean.product.product.wholeSalePrice2!=0"><s:property value="uiBean.product.product.wholeSalePrice2"/></s:if>" size="10"/></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>预设价3 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.wholeSalePrice3" id="wholeSalePrice3"  data-options="min:0,max:999,precision:1" size="9" class="easyui-numberbox" style="width:80px;" value="<s:if test="uiBean.product.product.wholeSalePrice3!=0"><s:property value="uiBean.product.product.wholeSalePrice3"/></s:if>" size="10"/></td>
	       </tr>	       
	       <tr class="InnerTableContent">
	          <td height="18"><strong>厂家零售价 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.salesPriceFactory" id="salesPriceFactory"  data-options="min:0,max:999,precision:1" size="9" class="easyui-numberbox" style="width:80px;" value="<s:if test="uiBean.product.product.salesPriceFactory!=0"><s:property value="uiBean.product.product.salesPriceFactory"/></s:if>" size="10"/></td>
	       </tr>
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>折扣 </strong>       :</td><td><input type="text" name="formBean.productBarcode.product.discount" id="discount" class="easyui-numberbox"  data-options="required:true,min:0,max:1,precision:2" size="9" style="width:80px;" value="<s:if test="uiBean.product.product.discount!=0"><s:property value="uiBean.product.product.discount"/></s:if>" size="10" /></td>
	       </tr>	
	       <tr class="InnerTableContent">
	          <td height="18"><strong>段位</strong>:</td><td><s:select name="formBean.productBarcode.product.sizeRange" cssClass="easyui-combobox"  style="width:80px;" size="1" id="sizeRange"   list="#{'S':'小','M':'中','L':'大'}" listKey="key" listValue="value" headerKey="" headerValue=""/></td>
	       </tr>	       
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>性别</strong>       :</td>
	          <td><s:select name="formBean.productBarcode.product.gender" cssClass="easyui-combobox"  style="width:80px;" size="1" id="gender"   list="#{'M':'男','F':'女','N':'中性'}" listKey="key" listValue="value"  headerKey="" headerValue=""/></td>
	       </tr>  
	       <tr class="InnerTableContent">
	          <td height="18"><strong>最小码</strong>:</td><td><s:select name="formBean.productBarcode.product.sizeMin" cssClass="easyui-combobox"  style="width:80px;" id="sizeMin" list="{'',80,90,100,110,120,130,140,150,160,170,180}" /></td>
	       </tr>	       
	       <tr class="InnerTableContent" style="background-color: rgb(255, 250, 208);">
	          <td height="18"><strong>最大码</strong>:</td><td><s:select name="formBean.productBarcode.product.sizeMax" cssClass="easyui-combobox"  style="width:80px;" id="sizeMax"   list="{'',80,90,100,110,120,130,140,150,160,170,180}" /></td>
	       </tr>		                
	       <tr class="InnerTableContent">
	          <td colspan="2"> <a href="#" id="saveButton" class="easyui-linkbutton" onclick="update();">更新 </a>&nbsp;&nbsp;
	                           <a href="#" id="saveButton" class="easyui-linkbutton" onclick="del();">删除</a>&nbsp;&nbsp;
	                           <a href="#" id="saveButton" class="easyui-linkbutton" onclick="window.close();">取消</a></td>
	       </tr>
	    </table>
	    </s:form>
	    </td>
	</tr>
	</table>   
</body>
</html>