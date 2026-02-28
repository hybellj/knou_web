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

String multiConn = (String)request.getSession().getAttribute("MULTICON_STATE");
String logoutGbn = (String)request.getSession().getAttribute("LOGOUT_GBN");
if ("LOGOUT".equals(multiConn)) {
	request.getSession().setAttribute("MULTICON_STATE", "");
}

boolean isVirtualMode =  SessionInfo.isVirtualLogin(request);
boolean isAdminCrs = SessionInfo.isAdminCrsInfo(request);
String ProfessorVirtualLoginYn = SessionInfo.getProfessorVirtualLoginYn(request);

// 교수 학생보기 모드 여부
request.setAttribute("PROFESSOR_VIRTUAL_LOGIN_YN", ProfessorVirtualLoginYn);

// IPHONE 체크
String userAgent2 = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent").toLowerCase() : "";
String iPhoneYn = "N";

if(userAgent2.indexOf("iphone") > -1 || userAgent2.indexOf("ipad") > -1 || userAgent2.indexOf("ipod") > -1){  
    iPhoneYn = "Y";
}


request.setAttribute("IPHONE_YN", iPhoneYn);
%>

<script type="text/javascript">
	if ("<%=multiConn%>" == "LOGOUT") {
		alert("<spring:message code='common.system.autologout'/>"); <%-- 다른 장치에서 로그인하여 자동 로그아웃되었습니다 --%>
		if ("" != "<%=logoutGbn%>") {
			top.location.href = "/sso/SPLogout.jsp";
		}
		else {
			top.location.href = "/";
		}
	}

	// 테마 모드 (dark, white)  
	let THEME_MODE = "<%=SessionInfo.getThemeMode(request)%>";
	// 장치구분
	let DEVICE_TYPE = "<%=SessionInfo.getDeviceType(request)%>";
	let PROFESSOR_VIRTUAL_LOGIN_YN = "<%=SessionInfo.getProfessorVirtualLoginYn(request)%>";
	let IPHONE_YN = "<%=iPhoneYn%>";
	
	// 언어
	let LANG = "<%=LocaleUtil.getLocale(request)%>";
	<%
	if (isVirtualMode == true) {
		%>
		$(document).ready(function() {
			if (PROFESSOR_VIRTUAL_LOGIN_YN == "Y") {
				applyVirtualMode("prof");
			}
			else {
				applyVirtualMode("admin", "<%=SessionInfo.getUserId(request)%>");
			}
		});
		<%
	}
	else if (isAdminCrs == true) {
		%>
		$(document).ready(function() { applyAdminCrsMode(); });
		<%
	}
	%>
	
</script>