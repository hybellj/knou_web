<%@page import="knou.framework.util.LocaleUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Stack"%>
<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@ taglib prefix="spring" 		uri="http://www.springframework.org/tags"%>
<%
if(request.getProtocol().compareTo("HTTP/1.0") == 0) {
	response.setHeader("Pragma", "no-cache");
}
else if(request.getProtocol().compareTo("HTTP/1.1") == 0) {
	response.setHeader("Cache-control", "no-cache");
}

response.setDateHeader("Expires", 0);


%>

<script type="text/javascript">
	// 테마 모드 (dark, white)
	let THEME_MODE = "white";
	// 장치구분
	let DEVICE_TYPE = "PC";
	let PROFESSOR_VIRTUAL_LOGIN_YN = "N";
	let IPHONE_YN = "N";

	// 언어
	let LANG = "ko";

</script>