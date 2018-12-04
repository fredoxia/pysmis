<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.onlineMIS.ORM.entity.headQ.user.UserInfor" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>朴与素</title>
<%@ include file="../../common/Style.jsp"%>

<script>
$(document).ready(function(){
	parent.$.messager.progress('close'); 
})
</script>
</head>
<body class="easyui-layout"> 

    <div data-options="region:'center'">
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
						 		<p>连锁店条码制作注意事项:</p>
						 		1. 请勿大量制作第三方条码，仅在总部允许的条件下制作条码<p/>
						 		2. 请勿频繁刷新页面和大量数据处理，一旦条码制作完成，请及时关闭网页，节省资源<p/>
								3. 在总部系统制作好的条码，程序会自动复制到服务器，中间可能有五分钟的滞后
						 		</td>
						 	</tr>
						</table>
			        </div> 
			    </td>
			  <td>
			    <div id="p" class="easyui-panel" title="文档下载"  
			 			style="width:450px;height:250px;padding:10px;background:#fafafa;"  
	        			data-options="collapsible:false">  
				        <table style="width: 100%" border="0">	 
							 	<tr class="InnerTableContent">
									<td><a href="/docs/QXBaby-MIS-Docs/TianMaZhiZuo.doc" target="_blank">千禧宝贝条码制作手册V1 (word下载格式)</a></td>
							 	</tr>
							 	<tr height="10">
									<td><hr/></td>
								</tr>
								<tr class="InnerTableContent">
									<td><a href="/docs/QXBaby-MIS-Docs/template.zip" target="_blank">千禧宝贝条码样板下载</a></td>
							 	</tr>
							 	<tr height="10">
									<td><hr/></td>
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
</body>
</html>