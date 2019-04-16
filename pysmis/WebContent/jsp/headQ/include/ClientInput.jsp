<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>

<script>

function searchCustomer(){
	var clientName = $("#clientName").val();
	var clientArray = clientName.split(",");	
	clientName = clientArray[0];  
	
	//if (clientName ==""){
	//	alert("请输入客户名字然后查询！");
	//} else {
        var params= "formBean.cust.name=" +clientName; 
        $.post("<%=request.getContextPath()%>/action/headQCustMgmtJSONAction!searchCustData",params, backProcessSearchClient,"json");
	//}
}
function backProcessSearchClient(data){
	var clients = data.returnValue;
	
    $('#clientTablebody tr').each(function () {                
        $(this).remove();
    });

    if (clients.length != 0){
	    for (var i = 0; i < clients.length; i++){
	    	var bg = "";
	    	if ((i % 2) == 0)
	    		bg = " style='background-color: rgb(255, 250, 208);'";
	        if (clients[i] != "")  
		          $("<tr align='center'  height='10' " + bg +"><td>"+clients[i].name+"</td><td>"+clients[i].area+"</td><td>"+clients[i].phone+"</td><td>"+clients[i].currentAcctBalance+"</td><td><a href='#' onclick='selectClient("+clients[i].id+",\""+clients[i].name+"," +clients[i].area +"\","+clients[i].currentAcctBalance+")'><img src='<%=request.getContextPath()%>/conf_files/web-image/editor.gif' border='0'/></a></td></tr>").appendTo("#clientTablebody");
	    }
    }else {
    	$("<tr class='InnerTableContent' height='10' style='background-color: rgb(255, 250, 208);' align='center'><td colspan=5><font color='red'>对应信息没有查询信息</font> </td></tr>").appendTo("#clientTablebody");
    }  
    $("#ClientDiv").dialog("open");
}
function selectClient(clientId, clientName1, preAcct){
	$("#clientID").val(clientId);
	$("#clientName").val(clientName1);
	$("#ClientDiv").dialog("close");
	try {
      chooseClient(clientId, preAcct);
	} catch (error){

	}
}
function clearCustomer(){
	$("#clientID").val(0);
	$("#clientName").val("");
}

</script>
<s:hidden id="clientID" name="formBean.order.cust.id"/>
<s:textfield id="clientName" name="formBean.order.cust.name" size="20"/> <input type="button" value="查询" onClick="searchCustomer();"/><input type="button" value="清除" onClick="clearCustomer();"/>
                          
 <div id="ClientDiv"  class="easyui-dialog" style="width:450px;height:300px"
		data-options="title:'查找客户',modal:false,closed:true,resizable:true">
   <table width="100%" align="center"  class="OuterTable" bgcolor="#FFFFFF" >
    <tr><td>
	    <table width="100%" border="0">
	       <tr class="InnerTableContent" style="background-color: #CCCCCC">
	          <th width="30%" height="10">客户名字</th>
	          <th width="20%">客户地区</th>
	          <th width="20%">客户电话</th>
	          <th width="15%">当前欠款</th>
	          <th width="15%"></th>
	       </tr>
		   <tbody id="clientTablebody">
		   </tbody>
	    </table>
	    </td>
	</tr>

  </table>
</div>