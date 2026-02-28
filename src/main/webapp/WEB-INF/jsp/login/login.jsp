<%@page import="knou.framework.common.MainOrgInfo"%>
<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.i18n.LocaleContextHolder"%>
<%@page import="knou.lms.org.service.OrgInfoService"%>
<%@page import="knou.lms.org.vo.OrgInfoVO"%>
<%@page import="knou.framework.util.StringUtil"%>
<%@page import="knou.framework.common.CommConst"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
String homeUrl = "";
String noSSO = "";
String orgDomainNm = "";

if (SessionInfo.isLogin(request)) {
	homeUrl = "/dashboard/main.do";
}
else {
	/*
	String serverName = request.getServerName();
	orgDomainNm = MainOrgInfo.getOrgDomain(request);
	*/
	// 외부기관 접속인 경우 전달 URI값(orgId) 확인 
	noSSO = StringUtil.nvl((String)request.getSession().getAttribute("noSSO"));
	orgDomainNm = StringUtil.nvl(SessionInfo.getOrgDomain(request));
	
	if (!"".equals(noSSO)) {
		request.getSession().removeAttribute("noSSO");
		
		if (!"".equals(orgDomainNm)) {
			// 외부기관은 영문을 기본으로
			LocaleUtil.setLocale(request, "en");
			%>
			<fmt:setLocale value="en" scope="page"/>
			<%
		}
	}
	else {
		if ("production".equals(CommConst.SERVER_MODE)) {
			homeUrl = "/sso/CreateRequest.jsp";
		}
	}
}

// 시스템점검중 페이지
if ("Y".equals(CommConst.WORK_PAGE_YN)) {
	homeUrl = "working.jsp";
}

String relogin = (String)request.getSession().getAttribute("relogin");
if (relogin != null && "true".equals(relogin)) {
	request.getSession().setAttribute("relogin", "");
	homeUrl = "";
}

// 로그인오류 메시지
String alertMessage = StringUtil.nvl((String)session.getServletContext().getAttribute("ALERT_MESSAGE"));
session.getServletContext().setAttribute("ALERT_MESSAGE", "");

Locale locale = request.getLocale();
locale.setDefault(Locale.ENGLISH);

String displayLanguage = locale.getDisplayLanguage();
String language = locale.getLanguage();
String displayCountry = locale.getDisplayCountry();
String country = locale.getCountry();

%>
<%@include file="/WEB-INF/jsp/common/common.jsp" %>
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta charset="UTF-8"/>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
	<%
	if (!"".equals(homeUrl)) {
		%><meta http-equiv="refresh" content="0; url=<%=homeUrl%>"/><%
	}
	%>	
	<link rel="shortcut icon" href="/favicon.ico"/>
	<title>KNOU-<spring:message code="common.label.classroom"/> [<%=CommConst.SERVER_NAME%>]</title>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui-slider-pips.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/footable.standalone.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery.mCustomScrollbar.min.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/ionicons.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />

    <link rel="stylesheet" type="text/css" href="/webdoc/css/reset.css?v=9" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/semantic.css?v=3" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui.css?v=24" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui-dark.css?v=4" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
    
	<script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
    <!-- <script type="text/javascript" src="/webdoc/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-migrate-3.4.1.min.js"></script> -->
    <script type="text/javascript" src="/webdoc/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic-ui-calendar.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.mCustomScrollbar.concat.min.js"></script>

	<style>
		#loading_page {
			display:none;
		}
		.flex-container .cont-none .text {
			color:#000;
		}
		.dark .flex-container .cont-none .text {
			color:#fff;
		} 
	</style>
</head>

<script type="text/javascript">
	$(function(){
		if ($("#loginForm").length > 0) {
			$("#inputId").focus();
			changeOrg();
		}
	});

	function doLogin(id){
		if(id != null){
			$("#inputId").val(id);
			$("#inputPwd").val("1111");
		}

		if($("#inputId").val().trim() == "") return false;
		if($("#inputPwd").val().trim() == "") return false;

		$("#orgNm").val($("#orgId option:selected").text());
		$("#loginForm").submit();
	}
	
	function changeOrg() {
		this.selectedIndex = this.initialSelect;
		
		var orgId = $("#orgId").val();
		alert("orgId==>"orgId);
		if (orgId == "<%=CommConst.KNOU_ORG_ID%>") {
			$("#ssoLoginBtn").css("visibility", "visible");
		}
		else {
			$("#ssoLoginBtn").css("visibility", "hidden");
		}
	}
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<%
	if ("true".equals(relogin)) {
		%>
	    <section class="extras errorBasic">
	        <div class="flex-container">
	            <div class="cont-none">
	                <img src="/webdoc/img/error_img1.svg" alt="warning" aria-hidden="true"/>
	                <div class="text">
	                    <p>
	                    	<spring:message code="common.message.login_study"/>
	                    	<!-- 강의실은 [학습 로그인(강의수강, 시험응시를 위한 로그인)]<br class='desktop-elem'> 방식으로 로그인해야 수강이 가능합니다 -->
	                    </p>
	                </div>
	                <div class="mt20">
	                    <a href="#0" class="ui blue button" onclick="goRelogin();return false;" title="<spring:message code="common.label.relogin"/>"><spring:message code="common.label.relogin"/><!-- 다시 로그인하러 가기 --></a>                         
	                </div>
	            </div>
	        </div>
	    </section>
		
		<script>
			function goRelogin() {
				//다시 로그인하러 이동하시겠습니까?\n기존에 로그인돼있는 한양사이버대학교 사이트들에서 모두 로그아웃됩니다.
				var st = confirm("<spring:message code="common.message.relogin_confirm"/>");
				if (st) {
					document.location.href = "/sso/SPLogout.jsp";
				}
			}
		</script>
		<%
	}
	else {
		if ("".equals(homeUrl)) {
			List<OrgInfoVO> orgList = MainOrgInfo.getMainOrgList(request);
			%>
		    <div id="wrap" class="main">
		        <div id="container" class="ui form">
		            <!-- 본문 content 부분 -->
		            <form class="ui form lmsLogin" id="loginForm" method="POST" action="/loginProc.do" autocomplete="off">
	                    <div class="loginHedaer">
	                    	<%
	                    	if (!"".equals(orgDomainNm)) {
	                    		%>
	                    		<img src="/webdoc/img/login_logo_en.svg" alt="KNOU LOGO">
	                    		<%
	                    	}
	                    	else {
								%>
	                    		<img src="/webdoc/img/login_logo_kr.svg" alt="KNOU LOGO">
	                    		<%
	                    	}
	                    	%>
	                        <h1 class="title">
	                            <span><spring:message code="common.label.classroom_login"/><!-- 강의실로그인 --></span>
	                        </h1>
	                    </div>
	
		            	<%
		            	if (!"".equals(alertMessage)) {
		            		%>
				            <div class="ui small error message">
					            <i class="info circle icon"></i>
					            <%=alertMessage%>
					            <!-- 아이디 또는 비밀번호가 올바르지 않습니다. -->
					        </div>
				        	<%
		            	}
				        %>
		            
		                <div>
		                    <input type="hidden" id="orgNm" name="orgNm">
		                    <select id="orgId" name="orgId" onchange="changeOrg()">
		                    	<%
		                    	for (OrgInfoVO vo : orgList) {
		                    		%>
		                    		<option value="<%=vo.getOrgId()%>" <%=(vo.getDomainNm().equals(orgDomainNm) ? "selected='selected'" : "")%>><%=vo.getOrgNm()%></option>
		                    		<%
		                    	}
		                    	%>
		                    </select>
		                </div>
		                <label>
		                    <span class="title"><spring:message code="common.id"/><!-- 아이디 --></span>
		                    <input id="inputId" type="text" name="userId" placeholder="<spring:message code="common.id"/>" onkeypress="if(event.keyCode==13){doLogin();return false}" autocomplete="new-password">
		                </label>
		                <label>
		                    <span class="title"><spring:message code="common.label.password"/><!-- 비밀번호 --></span>
		                    <input id="inputPwd" type="password" name="userIdEncpswd" placeholder="<spring:message code="common.label.password"/>" onkeypress="if(event.keyCode==13){doLogin();return false}" autocomplete="new-password">
		                </label>
		                <div class="button-area">
		                    <button type="button" title="Login" class="ui fluid large button login-btn" id="btnLogin" onclick="doLogin();"><spring:message code="button.login"/><!-- 로그인 --></button>
		                    <a id="ssoLoginBtn" href="/sso/CreateRequest.jsp" title="<spring:message code="common.label.sso_login"/>" class="ui fluid large button mt10 sso " ><spring:message code="common.label.sso_login"/><!-- SSO 로그인 이동 --></a>
		                </div>
		            </form>
		        </div>
		    </div>
			<%
		}
	}
	%>


</body>
</html>