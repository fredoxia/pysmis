<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>访问失败</title>
<%@ include file="Style.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	parent.$.messager.progress('close'); 
});
</script>

</head>
<body>
   <s:actionmessage/><s:fielderror/>
   <br/>
   您暂时还没有该功能访问权限。请联系管理人员。
   <a href="javascript:history.go(-1);">返回</a>
</body>
</html>