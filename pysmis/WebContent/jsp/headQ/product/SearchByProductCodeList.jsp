<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素连锁店管理信息系统</title>
<%@ include file="../../common/Style.jsp"%>
<link href="<%=request.getContextPath()%>/conf_files/css/pagination.css" rel="stylesheet" type="text/css"/>
<SCRIPT src="<%=request.getContextPath()%>/conf_files/js/pagenav1.1.js?v=8.28" type=text/javascript></SCRIPT>
<LINK type=text/css href="<%=request.getContextPath()%>/conf_files/js/tableRowSelect/tableRowSelect.css" rel=STYLESHEET>
<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/jquery.hotkeys-0.7.9.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/conf_files/js/tableRowSelect/tableRowSelect.js"></script>
<script>
$(document).ready(function(){
	renderPaginationBar($("#currentPage").val(), $("#totalPage").val());
	$("#org_table tr").mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
	initialize();
	window.onblur=function(){window.focus();};
	});
function selectBarcodes(){
	var barcodeArray = new Array();
    $('input[name="products"]:checked').each(function(){
        var barcode = $(this).val();
        barcodeArray.push(barcode);
        });
    if (barcodeArray.length == 0)
        alert("请选中至少一个条码");
    else {
    	var index_trigger = $("#index").val();
    	var index  = 0;
        var barcode = "";
    	for (var i = 0; i < barcodeArray.length; i++){
    		barcode = barcodeArray[i];
    		index = parseInt(index_trigger) +  i;
    		window.opener.retrieveProductByBarcode(index, "", barcode,$("#fromSrc").val());  
  //  		alert(i + "," + barcodeArray.length);
    	}
    	window.close();		
    }
}
function selectProductValue(barcode){
    var index_trigger = $("#index").val();
    
	var exist = window.opener.validateRowInputFromChild("", "",barcode);
	if (exist){
       window.opener.retrieveProductByBarcode(index_trigger, "", barcode,$("#fromSrc").val());  
	}
    window.close();
}
function selectAll(){

	if ($("#selectAllCheck").prop("checked"))
		$("input[name='products']").attr("checked",true); 
	else
		$("input[name='products']").attr("checked",false); 
	
}
pageNav.fn = function(page,totalPage){                
	$("#currentPage").attr("value",page);
    document.searchProductCodeForm.action="productJSPAction!scanByProductCodeHeadq";
    document.searchProductCodeForm.submit();
};
function tableRowSelectEnter(){
	var selectedRow = $("#prevTrIndex").val();
	var selectBarcode = $("#barcode"+selectedRow);
	//alert(selectedRow);
	if (selectBarcode == undefined)
		alert("没有找到你选总的条码");
	else {
		var selectedBarcodeValue = selectBarcode.val();
		selectProductValue(selectedBarcodeValue);
    }
}

function  clickRight(){
	pageNav.nextPage();
}
function clickLeft(){
	pageNav.prePage();
}
function clickEsc(){
	window.close();
}
</script>
</head>
<body>
   <s:form name="searchProductCodeForm" id ="searchProductCodeForm" action="productJSPAction!scanByProductCodeHeadq">
   <%@ include file="../../common/pageForm.jsp"%>

   <s:hidden id="index" name="formBean.indexPage"/>
   <s:hidden id="fromSrc" name="formBean.fromSrc"/>
   <s:hidden id="productCode" name="formBean.productBarcode.product.productCode"/>
   <table width="100%"  align="left" class="OuterTable">
		  <tr class="PBAInnerTableTitale" align='left'>
		    <th width="30" height="35"><input type="checkbox" id="selectAllCheck" onclick="selectAll()"/></th>
		    <th width="90" height="35">货号</th>
		    <th width="40" height="35">颜色</th>
		    <th width="95">品牌</th>
		    <th width="40">年</th>
		    <th width="40">季度</th>
		    <th width="50">单位</th>
		    <th width="55">预设价1</th>
		    <th width="55">预设价2</th>
		    <th width="55">库存</th>
		    <th>&nbsp;</th>
		  </tr>
		  <tbody class="dataTablegrid">
	      <s:iterator value="uiBean.productVOs" status="st" id="productBarcode" >
			    <tr class="InnerTableContent">	   
			      <td height="25"><input type="checkbox" name="products" value="<s:property value="#productBarcode.barcode"/>"/></td>   
			      <td><s:property value="#productBarcode.productCode"/></td>
			      <td><s:property value="#productBarcode.color"/></td>
			      <td><s:property value="#productBarcode.brand"/></td>
			      <td><s:property value="#productBarcode.year"/></td>
			      <td><s:property value="#productBarcode.quarter"/></td>
			      <td><s:property value="#productBarcode.unit"/></td>
			      <td><s:property value="#productBarcode.wholePrice1"/></td>
			      <td><s:property value="#productBarcode.wholePrice2"/></td>
			      <td><s:property value="#productBarcode.inventoryLevel"/></td>
			      <td><input type="hidden" id="barcode<s:property value="#st.index"/>" value="<s:property value="#productBarcode.barcode"/>"/><a href="#" onclick="selectProductValue('<s:property value="#productBarcode.barcode"/>');"><img src='<%=request.getContextPath()%>/conf_files/web-image/editor.gif' border='0'/></a></td>
			    </tr>
	       </s:iterator>
	       </tbody>

	       <s:if test="uiBean.productVOs.size==0">
			 	<tr height="22" class="InnerTableContent" align="center">
			 	        <th colspan="11">没有找到相应结果</th>
			 	 </tr>
		   </s:if><s:else>
				<tr class="InnerTableContent" align="left">	      
						<th colspan="11"><div id="pageNav"></div></th>
				</tr>	
				<tr height="22" class="InnerTableContent" align="left">
			 	        <th colspan="11"><input type="button" value="选中条码" onclick="selectBarcodes();"/></th>
			 	 </tr>				       
			</s:else> 	  
	</table>
	</s:form>
	<input type="hidden" name="prevTrIndex" id="prevTrIndex" value="-1" /> 
	
	<br/>
</body>
</html>