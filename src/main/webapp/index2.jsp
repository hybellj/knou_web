<%@page import="knou.framework.util.StringUtil"%>
<%@page import="knou.framework.common.CommConst"%>
<%@page import="java.util.Locale"%>
<%@include file="/WEB-INF/jsp/common/common.jsp" %>
<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="org.springframework.context.i18n.LocaleContextHolder"%>
<%
//로그인오류 메시지
String alertMessage = StringUtil.nvl((String)session.getServletContext().getAttribute("ALERT_MESSAGE"));
session.getServletContext().setAttribute("ALERT_MESSAGE", "");
%>
	
<html lang="ko">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta charset="UTF-8"/>	
	<link rel="shortcut icon" href="/favicon.ico"/>
	<title>KNOU-강의실 [<%=CommConst.SERVER_NAME%>]</title>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui-slider-pips.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/footable.standalone.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery.mCustomScrollbar.min.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/ionicons.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />

    <link rel="stylesheet" type="text/css" href="/webdoc/css/reset.css?v=9" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/semantic.css?v=2" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui.css?v=24" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui-dark.css?v=2" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css" />
    
	<script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
    <!-- <script type="text/javascript" src="/webdoc/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-migrate-3.4.1.min.js"></script> -->
    <script type="text/javascript" src="/webdoc/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic.min.js"></script>
    
	<style>
		.container { display: flex; }
		.box-left { flex: 0.5; }
		.box-center { flex: 2; text-align: center; }
		.box-right { flex: 2.5; }
		p { font-size: 25px; font-weight: bold ; }
		a { font-size: 18px; }
		#loading_page {
			display:none;
		}
	</style>
</head>

<script type="text/javascript">
	$(function(){
		$("#inputId").focus();
	});

	// login
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
</script>
<body>

    <div id="wrap" class="main"> <!-- 클래스 변경_235017 -->
        <div id="container" class="ui form">
            <!-- 본문 content 부분 -->
            <form class="ui form lmsLogin" id="loginForm" method="POST" action="/loginProc.do" autocomplete="off">
                   <div class="loginHedaer">
                       <img src="/webdoc/img/login_logo.png" alt="KNOU LOGO">
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
                    <select id="orgId" name="orgId">
                        <option value="ORG0000001">한양사이버대학교</option>
                    </select>
                </div>
                <label>
                    <span class="title"><spring:message code="common.id"/><!-- 아이디 --></span>
                    <input id="inputId" type="text" name="userId" placeholder="<spring:message code="common.id"/>" onkeypress="if(event.keyCode==13){doLogin();return false}" autocomplete="new-password">
                </label>
                <label>
                    <span class="title"><spring:message code="common.label.password"/><!-- 비밀번호 --></span>
                    <input id="inputPwd" type="password" name="userIdEncpswd" placeholder="<spring:message code="common.label.password"/>" onkeypress="if(event.keyCode==13){doLogin();return false}" autocomplete="new-password">
                    <!-- <span class="warning">알림메시지입력</span> -->
                </label>
                <div class="button-area">
                    <button type="button" title="로그인" class="ui fluid large button login-btn" id="btnLogin" onclick="doLogin();"><spring:message code="button.login"/><!-- 로그인 --></button>
					<a href="/sso/CreateRequest.jsp" title="<spring:message code="common.label.sso_login"/>" class="ui fluid large button mt10 sso " ><spring:message code="common.label.sso_login"/><!-- SSO 로그인 이동 --></a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>