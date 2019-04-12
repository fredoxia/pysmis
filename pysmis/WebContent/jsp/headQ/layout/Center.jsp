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
						 		<p>2019-4-11更新:</p>
						 		1. 批发单据自动生成财务单据优化<p/>
						 		2. 制作条码时，自动根据编码获取条码信息<p/>
						 		3. 完成某个条码制作时，清除输入项<p/>
								4. 批发单据自动收小数<p/>
								5. 采购单据增加货号搜索<p/>
								6. 批发单据搜索时添加 合计 (自动过滤了红冲和删除的单据金额)
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
