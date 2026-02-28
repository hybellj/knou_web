<%@page import="knou.framework.util.LocaleUtil"%>
<%@page import="knou.framework.common.CommConst"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<head>
    <title>KNOU LMS_<spring:message code="bbs.label.bbs_manager_home" /></title>
    <!-- Stylesheets -->
    <link rel="stylesheet" type="text/css" href="/webdoc/css/admin/reset.css?v=4" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/admin/element-ui.css?v=6" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/admin/footable.standalone.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/jquery.mCustomScrollbar.min.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/admin/semantic.css?v=2" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/admin/admin-default.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/ionicons.css" />
    <link rel="stylesheet" type="text/css" href="/webdoc/css/admin/element-ui-dark.css">

    <!-- Scripts -->
    <script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery-ui.min.js"></script>   
    <script type="text/javascript" src="/webdoc/js/jquery-ui-slider-pips.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/common_admin.js?v=5"></script>
    <script type="text/javascript" src="/webdoc/js/modernizr.custom.js"></script>
    <script type="text/javascript" src="/webdoc/js/classie.js"></script>
    <script type="text/javascript" src="/webdoc/js/gnmenu.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/semantic-ui-calendar.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/footable.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <script type="text/javascript" src="/webdoc/js/chart.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/Chart.PieceLabel.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/slick.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/modal.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/timeline.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.dynamiclist.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.knob.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/underscore-umd-min.js"></script>
    
	<script type="text/javascript" src="/webdoc/js/LiveTabs.js"></script>

	<script type="text/javascript" src="/webdoc/js/dx5/dextuploadx5-configuration.js"></script>
    <script type="text/javascript" src="/webdoc/js/dx5/dextuploadx5.js"></script>
    <script type="text/javascript" src="/webdoc/js/dx5-uploader.js?v=11"></script> 

	<!-- 추가! -->
    <link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
	<script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-<%=LocaleUtil.getLocale(request)%>.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
	<script type="text/javascript" src="/webdoc/file-uploader/file-uploader-plugin.js"></script>
    <!-- 추가! -->
	
    <link rel="stylesheet" type="text/css" href="/webdoc/tabulator/css/tabulator.css" />
    <script type="text/javascript" src="/webdoc/tabulator/js/tabulator.min.js"></script>

</head>
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<div id="virtualSupport" style='display:none;position:fixed;top:0;right:0;bottom:0;left:0;z-index:2000;outline:0;background-color:rgba(255,255,255,0.8)'>
	<div style="background:#fff;border:1px solid #000;text-align:center;margin-top:calc(50vh - 100px);margin-left:auto;margin-right:auto;width:500px;padding:40px;font-size:1.2em">
		<div>작업중...</div>
	</div>
</div>