<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<script>

function searchSupplier(){
	var supplierName = $("#supplierName").val();

	//if (supplierName ==""){
	//	alert("请输入供应商名字然后查询！");
	//} else {
        var params= "formBean.supplier.name=" +supplierName; 
        $.post("<%=request.getContextPath()%>/action/headQSupplierMgmtJSONAction!searchSupplierData",params, backProcessSearchSupplier,"json");
	//}
}
function backProcessSearchSupplier(data){
	var clients = data.returnValue;
	
    $('#supplierTablebody tr').each(function () {                
        $(this).remove();
    });

    if (clients.length != 0){
	    for (var i = 0; i < clients.length; i++){
	    	var bg = "";
	    	if ((i % 2) == 0)
	    		bg = " style='background-color: rgb(255, 250, 208);'";
	        if (clients[i] != "")  
		          $("<tr align='center'  height='10' " + bg +"><td>"+clients[i].name+"</td><td>"+clients[i].pinyin+"</td><td>"+clients[i].comment+"</td><td><a href='#' onclick='selectSupplier("+clients[i].id+",\""+clients[i].name +"\")'><img src='<%=request.getContextPath()%>/conf_files/web-image/editor.gif' border='0'/></a></td></tr>").appendTo("#supplierTablebody");
	    }
    }else {
    	$("<tr class='InnerTableContent' height='10' style='background-color: rgb(255, 250, 208);' align='center'><td colspan=5><font color='red'>对应信息没有查询信息</font> </td></tr>").appendTo("#clientTablebody");
    }  
    $("#SupplierDiv").dialog("open");
}
function selectSupplier(supplierId, supplierName){
	$("#supplierId").attr("value", supplierId);
	$("#supplierName").attr("value", supplierName);
	$("#SupplierDiv").dialog("close");
	chooseSupplier(supplierId);
}
function clearSupplier(){

	$("#supplierId").attr("value", 0);
	$("#supplierName").attr("value", "");
}

</script>
<s:hidden id="supplierId" name="formBean.order.supplier.id"/>
<s:textfield id="supplierName" name="formBean.order.supplier.name" size="20"/> <input type="button" value="查询" onClick="searchSupplier();"/><input type="button" value="清除" onClick="clearSupplier();"/>
                          
 <div id="SupplierDiv"  class="easyui-dialog" style="width:400px;height:300px"
		data-options="title:'查找供应商',modal:false,closed:true,resizable:true">
   <table width="100%" align="center"  class="OuterTable" bgcolor="#FFFFFF" >
    <tr><td>
	    <table width="100%" border="0">
	       <tr class="InnerTableContent" style="background-color: #CCCCCC">
	          <th width="30%" height="10">供应商名字</th>
	          <th width="30%" height="10">名字首字母</th>
	          <th width="20%">备注</th>
	          <th width="20%"></th>
	       </tr>
		   <tbody id="supplierTablebody">
		   </tbody>
	    </table>
	    </td>
	</tr>

  </table>
</div>