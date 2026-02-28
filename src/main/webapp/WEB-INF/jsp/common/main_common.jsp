<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="knou.framework.util.LocaleUtil"%>
<%@ page import="knou.framework.common.CommConst"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta name="author" content="LMS" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/favicon.ico" type="image/x-icon">

    <title>LMS-<spring:message code="common.label.classroom" />[<%=CommConst.SERVER_NAME%>]</title>
    <!-- Stylesheets -->
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery-ui-slider-pips.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/footable.standalone.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery.mCustomScrollbar.min.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/ionicons.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/reset.css?v=9" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/semantic.css?v=8" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui.css?v=24" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/element-ui-dark.css?v=18" />

    <!-- Scripts -->
    <script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-ui-slider-pips.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/modernizr.custom.js"></script>
    <script type="text/javascript" src="/webdoc/js/classie.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic-ui-calendar.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/footable.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <script type="text/javascript" src="/webdoc/js/chart.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/Chart.PieceLabel.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/slick.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/modal.js"></script>
    <script type="text/javascript" src="/webdoc/js/moment.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/timeline.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.dynamiclist.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.star-rating-svg.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.knob.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.treeview.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.video-layers.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.indexeddb.js"></script>
    <script type="text/javascript" src="/webdoc/js/common.js?v=20"></script>
    <script type="text/javascript" src="/webdoc/js/ui-dialog.js?v=6"></script> 
    <script type="text/javascript" src="/webdoc/js/underscore-umd-min.js"></script>

	<script type="text/javascript" src="/webdoc/js/dx5/dextuploadx5-configuration.js"></script>
    <script type="text/javascript" src="/webdoc/js/dx5/dextuploadx5.js"></script>
    <script type="text/javascript" src="/webdoc/js/dx5-uploader.js?v=11"></script>

    <link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-<%=LocaleUtil.getLocale(request)%>.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js?v=2"></script>

    <!-- Favicon ie/ie외 브라우저/apple/android -->
    <link rel="shortcut icon" type="image/x-icon" >
    <link rel="icon" type="image/png" >
    <link rel="apple-touch-icon" >
    <link rel="icon" type="image/png" >

<%
    String ssoId = (String)request.getSession().getAttribute("SSO_ID");
    String idpId = (String)request.getSession().getAttribute("IDP_JSESSIONID");
    String agent = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "";
    String appYn = "N";

    if(agent.indexOf("hycuapp") > -1) {
    	appYn = "Y";
    }
    
%>
</head>

<h1 class="blind">바로가기 메뉴</h1>
<div id="key_access" class="blind">
    <ul>
        <li><a href="#main_menu" title="주메뉴 위치로 바로가기">주메뉴 바로가기</a></li>
        <li><a href="#container" title="본문 위치로 바로가기">본문 바로가기</a></li>
        <li><a href="#bottom" title="하단 위치로 바로가기">하단 바로가기</a></li>
    </ul>
</div>
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
