<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
function callP(){
	alert("this parent");
}
</script>
<div id="indexTab" class="easyui-tabs" fit="true" border="false">  
      <div title="首页">
		<table cellpadding='10px' cellspacing='10px'>
			<tr valign="top">
			   <td>
			    <div id="p" class="easyui-panel" title="消息栏"  
			 			style="width:450px;height:250px;padding:10px;background:#fafafa;"  
	        			data-options="collapsible:false">  
				        <table cellpadding="0" cellspacing="0" style="width: 95%" border="0">	 	
						 	<tr height="22">
						 		<td colspan="9">
						 		<p>2019-4-26更新:</p>
						 		1. 销售统计报表导出<p/>
						 		2. 财务单据打印<p/>
						 		3. 优惠人工介入后不再自动计算<p/>
						 		</td>
						 	</tr>
						</table>
			    </div> 
			   </td>
			   <td>
			   		<div id="p2" class="easyui-panel" title="功能更新栏"  
			 			style="width:450px;height:250px;padding:10px;background:#fafafa;"  
	        			data-options="collapsible:false">  
				        <table style="width: 100%" border="0">	
				        	<tr class="InnerTableContent">
								<td><strong>系统支持</strong><br/>
								    - 目前系统支持任何浏览器，建议使用Chrome, Firefox<p/>
								</td>
						 	</tr>
						 	<tr height="10">
								<td><hr/></td>
							</tr> 
						</table>
			       </div>
			   </td>
			</tr>
		</table>
	</div>
</div>
