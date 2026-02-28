<%@page import="java.text.DecimalFormat"%>
<%@page import="knou.framework.util.IdGenerator"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<body class="">

<%
String id = "";



for (int i=0; i<100; i++) {
	id = IdGenerator.getNewId("");
	out.print(id+" -- " + (id.length())  + " <br>");
}

%>


</body>

</html>