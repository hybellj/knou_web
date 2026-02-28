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
    <script type="text/javascript" src="/webdoc/js/iframeResizer.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframeResizer.contentWindow.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/chart.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/Chart.PieceLabel.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/slick.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/modal.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/timeline.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.dynamiclist.js"></script>
    <script type="text/javascript" src="/webdoc/js/jquery.knob.min.js"></script>
    <script type="text/javascript" src="/webdoc/js/underscore-umd-min.js"></script>
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
    
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<style>
		.btn-close {
		  box-sizing: content-box;
		  width: 1em;
		  height: 1em;
		  padding: 0.25em;
		  color: #000;
		  background: transparent url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'><path stroke='black' stroke-linecap='round' stroke-width='2' d='M4 4l8 8M12 4L4 12'/></svg>") center/1em auto no-repeat;
		  border: 0;
		  border-radius: 0.25rem;
		  opacity: 0.5;
		  cursor: pointer;
		}
		
		.btn-close:hover {
		  opacity: 0.75;
		}
		
		.btn-close:focus {
		  outline: 0;
		  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, .25);
		  opacity: 1;
		}
		
		.btn-close:disabled,
		.btn-close.disabled {
		  pointer-events: none;
		  user-select: none;
		  opacity: 0.25;
		}
		.d-block {
			display:block;
		}
		.d-none {
			display:none;
		}
	</style>
    
	<script type="text/javascript">
		$(document).ready(function() {
			const config = {
				//name of the Tab div
				tabContainer :'tab_',
				
			    //name of the content div
			    tabContentContainer:'tabContent_',
			}
				        
			const newTab = new LiveTabs( config ,'newTab');
		});
		
		function resizeIframe(obj) {
			//obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
			//obj.style.height = obj.offsetHeight + (obj.contentDocument.body.scrollHeight - obj.clientHeight)+ 1 + "px";
		} 
	</script>
	
	
</head>
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<div id="virtualSupport" style='display:none;position:fixed;top:0;right:0;bottom:0;left:0;z-index:2000;outline:0;background-color:rgba(255,255,255,0.8)'>
	<div style="background:#fff;border:1px solid #000;text-align:center;margin-top:calc(50vh - 100px);margin-left:auto;margin-right:auto;width:500px;padding:40px;font-size:1.2em">
		<div>작업중...</div>
	</div>
</div>
<body>
	<div id="wrap" class="pusher">

 		<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

		<!-- lnb / 사이드메뉴 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb_sample.jsp" %>
        <!-- //lnb -->
        
		<div id="container">
			<!-- 본문 content 부분 -->
			<div class="content">
				<div class="ui divider mt0"></div>
				
				<!--Tabs will be placed here-->
				<ul class="nav nav-tabs" id="tab_"></ul>
				
				<!--content of the tabs will be here-->
				<div id="tabContent_" style="height:100%;"></div>
						
			</div>
			<!-- //본문 content 부분 -->
			
			
			<!-- footer -->
	        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
		</div>
		
    </div>
</body>