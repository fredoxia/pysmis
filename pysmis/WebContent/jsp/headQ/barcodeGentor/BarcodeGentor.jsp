<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>

<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<title>产品条形码导入</title>
<%@ include file="../../common/Style.jsp"%>
<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/BarcodeGenKeys.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/HtmlTable.js"></script>
<script>
$(document).ready(function(){
	parent.$.messager.progress('close'); 
	jQuery.excel('InnerTableContent');
	jQuery.excel('PBAOuterTableTitale');
	$("#brandName").focus();
});
function checkProductCodeSerialNum(){
    var params=$("#barcodeGenForm").serialize(); 
    $.post("action/productJSONAction!checkProductCodeSerialNum",params, checkProductCodeBackProcess,"json");	
}
function checkProductCodeBackProcess(data){
	var returnCode = data.returnCode;
	var tips = data.tip;

	if (returnCode == FAIL){
       $.messager.alert('提示信息', tips,'warning');
    } else if (returnCode == WARNING){
		tips += "<br/> 你确定是否继续生成货品和条码?";
		$.messager.confirm('确认', 'tips', function(r){
			if (r){
				generateBarcode();
	
			}
		});
    } else if (returnCode == SUCCESS){
    	generateBarcode();
    }

	$("#saveButton").linkbutton("enable");
}
function generateBarcode(){
	$("#color").find("option").attr("selected","selected"); 
    var params=$("#barcodeGenForm").serialize(); 
    $.post("action/productJSONAction!generateProductBarcode",params, saveBarcodeBackProcess,"json");
}

function saveProduct(){
	  $("#saveButton").linkbutton("disable");
	    if ($('#barcodeGenForm').form('validate')){
			var error = "";

			var brandId = $("#brand_ID").val();
			if (brandId == "" || brandId == 0){
		          error += "品牌 - 是必选项<br/>";
			} else if (!isValidPositiveInteger(brandId)) {
		        error += "品牌 - 必须是系统已经存在的信息，请检查<br/>";
			}
			
			var categoryId = $("#category_ID").combobox("getValue");
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
				var colors = $("#color").text();
		
		        if (colors !="" ){
		        	var msg ="你确定要生成此颜色组和尺码组条码:<br/>" + colors;
		    		$.messager.confirm('确认', msg, function(r){
		    			if (r){
		    				checkProductCodeSerialNum();
		    			} else 
		    				$("#saveButton").linkbutton("enable");
		    		});
						
		        } else 
		        	checkProductCodeSerialNum();
			} else{
				$.messager.alert('操作失败', error,'error');
				$("#saveButton").linkbutton("enable");
			}
	    } else 
	    	$("#saveButton").linkbutton("enable");
}

function saveBarcodeBackProcess(data){
	var returnCode = data.returnCode;

	if (returnCode != SUCCESS){
		$.messager.alert('失败信息', data.error,'error');
	}else {
		clearAllData();
	
	    var barcodes = data.barcodes;

	    if (barcodes.length != 0){
		    for (var i = 0; i < barcodes.length; i++){
		    	var bg = "";
		    	if ((i % 2) == 0)
		    		bg = " style='background-color: rgb(255, 250, 208);'";
		        if (barcodes[i] != "")  {
			      var belong = "";
			      if (barcodes[i].chainStore.chainId != undefined)
				     belong = "连锁店"; 
		          $("<tr align='center' class='InnerTableContent'" + bg +"><td>"+barcodes[i].product.year.year + " " + barcodes[i].product.quarter.quarter_Name +"</td><td>"+
				          barcodes[i].product.brand.brand_Name+"</td><td>"+
				          barcodes[i].product.genderS + barcodes[i].product.sizeRangeS+ " " + barcodes[i].product.category.category_Name+"</td><td>"+
				          barcodes[i].product.productCode+"</td><td>"+
				          parseValue(barcodes[i].color.name)+"</td><td>"+
//Size will be implement later				          parseValue(barcodes[i].size.name)+"</td><td>"+ 
				          barcodes[i].product.numPerHand + "/" + barcodes[i].product.unit +"</td><td>"+
				          barcodes[i].product.salesPriceFactory +"</td><td>"+
				          barcodes[i].product.discount +"</td><td>"+
				          barcodes[i].product.salesPrice+"</td><td>"+
				          barcodes[i].product.recCost+"</td><td>"+
				          barcodes[i].product.wholeSalePrice+"</td><td>"+
				          barcodes[i].barcode+"</td><td>"+
				          barcodes[i].createDate+"</td><td>"+
				          belong+"</td><td><s:if test="#session.LOGIN_USER.containFunction('productJSPAction!searchForUpdate')"><a href='#' onclick=\"window.open ('productJSPAction!searchForUpdate?formBean.productBarcode.barcode="+barcodes[i].barcode+"','新窗口','height=670, width=400, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');\"><img src='<%=request.getContextPath()%>/conf_files/web-image/editor.gif' border='0'/></a></s:if></td></tr>").appendTo("#orgTablebody");
		         }
		    }

	        $.messager.alert('成功信息', "成功生成条码",'infor');
	    }else {
	    	$("<tr class='InnerTableContent' style='background-color: rgb(255, 250, 208);' align='center'><td colspan=15><font color='red'>对应信息没有条形码存在</font> </td></tr>").appendTo("#orgTablebody");
	    }
    }

	$("#saveButton").linkbutton("enable");
}

function getProductColors(){
	var serialNum = $("#serialNum").val();
	var params = "formBean.productBarcode.product.serialNum=" + serialNum;
    $.post("action/productJSONAction!getProductInforBySerialNum",params, getProductBySNBackProcess,"json");
}

function getProductBySNBackProcess(data){
	var response = data.response;
	var returnCode = response.returnCode;
	if (returnCode != SUCCESS)
	    $.messager.alert('失败信息', response.message,'error');
	else {
		var returnValue = response.returnValue;
		var colors = returnValue.color;
		$("#colorsDiv").html(colors);

		var productInfor = returnValue.product;
		assignProductValue(productInfor);
	}
}
function assignProductValue(p){
	if (p != undefined && p != null){
		$("#salesPrice").numberbox("setValue",p.salesPrice);
		$("#productCode").textbox("setValue",p.productCode);
		$("#recCost").numberbox("setValue",p.recCost);
		$("#wholeSalePrice").numberbox("setValue",p.wholeSalePrice);
		if (p.wholeSalePrice2 > 0)
			$("#wholeSalePrice2").numberbox("setValue",p.wholeSalePrice2);
		if (p.wholeSalePrice3 > 0)
			$("#wholeSalePrice3").numberbox("setValue",p.wholeSalePrice3);
		if (p.salesPriceFactory > 0)
		    $("#salesPriceFactory").numberbox("setValue",p.salesPriceFactory);
		$("#discount").numberbox("setValue",p.discount);
		$("#numPerHand").combobox("select",p.numPerHand);
		$("#unit").combobox("select",p.unit);
		$("#year_ID").combobox("select",p.year.year_ID);
		$("#quarter_ID").combobox("select",p.quarter.quarter_ID);
		$("#brand_ID").val(p.brand.brand_ID);
		$("#brandName").val(p.brand.brand_Name);
		
		
		$("#category_ID").combobox("select",p.category.category_ID);
		
		$("#sizeMin").combobox("select",p.sizeMin);
		$("#sizeMax").combobox("select",p.sizeMax);
		$("#gender").combobox("select",p.gender);
		$("#sizeRange").combobox("select",p.sizeRange);
	}
}
function clearAllData(){
	$("#error").html("");
	$("#tip").html("");
	$("#colorsDiv").html("");
	$("#salesPrice").numberbox("setValue","");
	$("#barcode").textbox("setValue","");
	$("#productCode").textbox("setValue","");
	$("#recCost").numberbox("setValue","");
	$("#wholeSalePrice").numberbox("setValue","");
	$("#wholeSalePrice2").numberbox("setValue","");
	$("#wholeSalePrice3").numberbox("setValue","");
	$("#salesPriceFactory").numberbox("setValue","");
	$("#serialNum").textbox("setValue","");
	$("#color").empty();
	$("#colorName").val("");
	$("#discount").val("");
	
    $('#orgTablebody tr').each(function () {                
        $(this).remove();
    });
}
/**
 * once click the button, it will help to search brand
 */
function searchColor(){
	var colorName = $.trim($("#colorName").val());
	if (colorName != "") {
	    var params= "formBean.colorNames=" + colorName  ; 
    
        var url = encodeURI(encodeURI("productJSPAction!searchColor?" +params));
	
        window.open(url,'新窗口','height=450, width=300, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');  
	} else {
        $.messager.alert('成功信息', "请输入颜色名称",'infor');
    }; 
}
function selectColor(data){
	var dataArray = data.split(";");
	$.each(dataArray,function(key,val){
	    if (val != ""){
		    var added = false;
            var colorArray = val.split(",");
            $("#color option").each(function(){
            	   if($(this).val() == colorArray[0])
            	      added = true;
            	   });
     	   if (added == false)
              $("#color").append("<option value='"+ colorArray[0]+"'>"+ colorArray[1]+"</option>");
		}
	});
}
function removeColor(){
	$("#color").find("option:selected").each(function(){
	   var removeColor = $(this).val();
	   if (removeColor != 0 && removeColor != undefined)
		   $("#color option[value='"+removeColor+"']").remove();  
       });
}
function clickSize(){
	var sizes = $("#size").val().toString().split(",");
	if (sizes[0] == "")
		$("#size").find("option:selected").attr("selected", false);
}

</script>

</head>
<body>
<s:form id="barcodeGenForm" cssClass="easyui-form" action="" method="POST"  theme="simple">
 <table width="95%" align="center"  class="OuterTable">
 <tr><td>

 <table width="100%" border="0">
    <s:hidden name="formBean.productBarcode.product.area.area_ID" value="1"/>     
    <tr class="InnerTableContent">
      <td height="19"><strong>年份：</strong></td>
      <td>
      		<s:select name="formBean.productBarcode.product.year.year_ID" cssClass="easyui-combobox" data-options="editable:false"  style="width:80px;" size="1" id="year_ID"  list="uiBean.basicData.yearList" listKey="year_ID" listValue="year"  />     
      </td>
      <td><strong>季度：</strong></td>
      <td>
            <s:select name="formBean.productBarcode.product.quarter.quarter_ID" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" size="1" id="quarter_ID" list="uiBean.basicData.quarterList" listKey="quarter_ID" listValue="quarter_Name"  />
      </td>
      <td><strong>品牌：</strong></td>
      <td colspan="2">
         <%@ include file="SearchBrandStub.jsp"%>
      </td>
      
      <td><strong>性别：</strong></td>    
      <td><s:select name="formBean.productBarcode.product.gender" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" size="1" id="gender"   list="#{'M':'男','F':'女','N':'中性'}" listKey="key" listValue="value"  headerKey="" headerValue=""/></td> 
      <td><strong>段位：</strong></td> 
      <td><s:select name="formBean.productBarcode.product.sizeRange" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" size="1" id="sizeRange"   list="#{'S':'小','M':'中','L':'大'}" listKey="key" listValue="value" headerKey="" headerValue=""/> </td> 
      <td>&nbsp;</td>     
    </tr>
    <tr class="InnerTableContent">
      <td height="19"><strong>齐码数量：</strong></td>
      <td>
          <s:select name="formBean.productBarcode.product.numPerHand" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" size="1" id="numPerHand" list="uiBean.basicData.numPerHandList" listKey="numPerHand" listValue="numPerHand"/>     
      </td>
      <td><strong>货品类：</strong></td>
      <td>
          <s:select name="formBean.productBarcode.product.category.category_ID" cssClass="easyui-combobox" size="1" id="category_ID" list="uiBean.basicData.categoryList" listKey="category_ID" listValue="category_Name"  headerKey="-1" headerValue="" />      </td>
      <td><strong>单位：</strong></td>
      <td>
      	 <s:select name="formBean.productBarcode.product.unit" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" size="1" id="unit" list="uiBean.basicData.unitList" listKey="productUnit" listValue="productUnit"/>
      </td>
      <td>&nbsp;</td>
      <td><strong>最小码段：</strong></td>  
      <td><s:select name="formBean.productBarcode.product.sizeMin" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" id="sizeMin" list="{'',80,90,100,110,120,130,140,150,160,170,180}" /></td> 
      <td><strong>最大码段：</strong></td> 
      <td><s:select name="formBean.productBarcode.product.sizeMax" cssClass="easyui-combobox"  style="width:80px;" data-options="editable:false" id="sizeMax"   list="{'',80,90,100,110,120,130,140,150,160,170,180}" /></td> 
      <td>&nbsp;</td>        
    </tr>
   <tr class="InnerTableContent">
      <td height="4" colspan="12"><hr width="100%" color="#FFCC00"/></td>
    </tr>
    <tr class="InnerTableContent">
		      <td width="80" height="19"><strong>货号：</strong></td>
		      <td width="110">
		       <input type="text" name="formBean.productBarcode.product.productCode"  class="easyui-textbox" style="width:80px;" id="productCode" data-options="required:true,validType:['required','length[3,20]']" />*
		      </td>
		      <td width="80"><strong>进价:</strong></td>
		      <td width="110">  
		        <input type="text" name="formBean.productBarcode.product.recCost" class="easyui-numberbox" style="width:80px;" id="recCost"  data-options="required:true,min:0,max:999,precision:0" size="9"/>
		      </td>
		      <td width="80"><strong>厂家零售价：</strong></td>
		      <td width="110"><input type="text" name="formBean.productBarcode.product.salesPriceFactory" class="easyui-numberbox" style="width:80px;" id="salesPriceFactory" data-options="min:0,max:999,precision:0" size="9"/></td>
		      <td width="100"></td>
		      <td width="80"><strong>折扣:</strong></td>
		      <td width="100"><input type="text" name="formBean.productBarcode.product.discount" class="easyui-numberbox" style="width:80px;" id="discount"  data-options="min:0,max:1,precision:2" size="9"/></td> 
      		  <td width="80">&nbsp;</td> 
      		  <td width="100">&nbsp;</td> 
     		  <td>&nbsp;</td>  
		    </tr>
		    <tr class="InnerTableContent">
              <td><strong>连锁零售价：</strong></td>
		      <td><input type="text" name="formBean.productBarcode.product.salesPrice" class="easyui-numberbox" style="width:80px;" id="salesPrice"  data-options="required:true,min:0,max:999,precision:0" size="9"/></td>
		      <td height="19"><strong>预设价1：</strong></td>
		      <td><input type="text" name="formBean.productBarcode.product.wholeSalePrice" class="easyui-numberbox" style="width:80px;" id="wholeSalePrice"  data-options="min:0,max:999,precision:0" size="9"/></td>
		      <td><strong>预设价2：</strong></td>
		      <td><input type="text" name="formBean.productBarcode.product.wholeSalePrice2" class="easyui-numberbox" style="width:80px;" id="wholeSalePrice2" data-options="min:0,max:999,precision:0"  size="9"/></td>
		      <td></td>
		      <td><strong>预设价3：</strong></td>
		      <td><input type="text" name="formBean.productBarcode.product.wholeSalePrice3" class="easyui-numberbox" style="width:80px;" id="wholeSalePrice3" data-options="min:0,max:999,precision:0"  size="9"/></td> 
      		  <td>&nbsp;</td> 
      		  <td>&nbsp;</td> 
     		  <td>&nbsp;</td> 		      
		    </tr>  
    <tr class="InnerTableContent">
		  <td height="4" colspan="12"><hr width="100%" color="#FFCC00"/></td>
	</tr>
    <tr class="InnerTableContent">
      <td height="19"><strong>商品编码：</strong></td>
      <td colspan="11">
       <input type="text" name="formBean.productBarcode.product.serialNum" class="easyui-textbox" style="width:80px;" id="serialNum" onfocus="this.select();"/> 
       <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="getProductColors();">获取已录信息</a>(*当需要为已经存在的货品添加额外颜色和尺码的条码时，请输入) <br/> <div id="colorsDiv"></div></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="4" colspan="12"><hr width="100%" color="#FFCC00"/></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="19"><strong>颜色：</strong></td>
      <td colspan="8">*多个颜色间用 - 分开,比如"红-黑-黄"<br/>
          <input type="text" id="colorName" size="10" onfocus="this.select();"/><input id="searchColorBt" type="button" onclick="searchColor();" value="查找"/><br/><br/>
          <select name="formBean.colorIds" id="color" multiple size="5" style="width:94px"></select><input id="searchColorBt" type="button" onclick="removeColor();" value="删除"/></td>
      <td></td>
      <td><!--<strong>尺码：</strong>--></td>
      <td><!--<s:select name="formBean.sizeIds" id="size" list="uiBean.basicData.sizeList" listKey="sizeId" listValue="name"  headerKey="" headerValue="--------无尺码---------"  multiple="true" size="15" onclick="clickSize();"/>--></td>
    </tr>

    <tr class="InnerTableContent">
      <td height="4" colspan="12"><hr width="100%" color="#FFCC00"/></td>
    </tr>
    <tr class="InnerTableContent">
      <td height="30">&nbsp;</td>
      <td colspan="3"><a href="#" id="saveButton" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="saveProduct();">保存产品信息 </a></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      		      <td>&nbsp;</td> 
      		  <td>&nbsp;</td> 
      		  <td>&nbsp;</td> 
     		  <td>&nbsp;</td>       
    </tr>
  </table>
   </td></tr>
 </table>
</s:form>

<jsp:include page="../include/ProductListTable.jsp"/>
<br/>
</body>
</html>