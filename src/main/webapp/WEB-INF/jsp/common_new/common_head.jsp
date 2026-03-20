<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="knou.framework.util.SessionUtil" %>
<%
	String title = request.getParameter("title");
	if (title == null || "".equals(title)) {
		title = "한국방송통신대학교 미래형 통합학습관리시스템";
	}

	String style = request.getParameter("style");
	String module = request.getParameter("module");

	String contextPath = request.getContextPath();

	String webdoc = contextPath + "/webdoc";
	String assets = webdoc + "/assets";
	String uilib = webdoc + "/uilib";

	String pageType = (String)SessionUtil.getSessionValue(request, "PAGE_TYPE");
	String bodyClass = (String)SessionUtil.getSessionValue(request, "BODY_CLASS");

	request.setAttribute("pageType", pageType);
	request.setAttribute("bodyClass", bodyClass);
%>


<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="format-detection" content="telephone=no" />
<meta name="format-detection" content="date=no">
<meta name="format-detection" content="address=no">
<meta name="format-detection" content="email=no">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">

<meta name="author" content="한국방송통신대학교 미래형 통합학습관리시스템" />
<meta name="description" content="한국방송통신대학교 미래형 통합학습관리시스템입니다." />
<title><%=title%></title>

<!--favicon-->
<link rel="shortcut icon" href="<%=assets%>/img/favicon/favicon.ico">
<link rel="apple-touch-icon-precomposed" sizes="57x57" href="<%=assets%>/img/favicon/apple-touch-icon-57x57.png">
<link rel="icon" type="image/png" sizes="32x32" href="<%=assets%>/img/favicon/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="<%=assets%>/img/favicon/favicon-16x16.png">

<%-- Stylesheets --%>
<link rel="stylesheet" href="<%=assets%>/css/common.css" />
<link rel="stylesheet" href="<%=assets%>/jquery/jquery-ui.min.css">

<%-- scripts --%>
<script src="<%=assets%>/jquery/jquery-3.7.1.min.js"></script>
<script src="<%=assets%>/jquery/jquery-migrate-1.4.1.min.js"></script>
<script src="<%=assets%>/js/common.js"></script>
<script src="<%=assets%>/js/gnb.js"></script>
<script src="<%=assets%>/js/slick.min.js"></script>
<script src="<%=assets%>/jquery/jquery-ui.min.js"></script>

<%-- ui-datetimepicker --%>
<link rel="stylesheet" href="<%=uilib%>/datetimepicker/jquery.ui.timepicker.css">
<link rel="stylesheet" href="<%=uilib%>/datetimepicker/ui-datetimepicker.css">
<script src="<%=uilib%>/datetimepicker/jquery.ui.timepicker.js"></script>
<script src="<%=uilib%>/datetimepicker/ui-datetimepicker.js"></script>

<%-- chosen --%>
<link rel="stylesheet" href="<%=uilib%>/chosen/chosen.css">
<script src="<%=uilib%>/chosen/chosen.jquery.min.js"></script>
<script src="<%=uilib%>/chosen/ui-chosen.js"></script>

<%-- ui-dialog --%>
<link rel="stylesheet" href="<%=uilib%>/dialog/ui-dialog.css">
<script src="<%=uilib%>/dialog/ui-dialog.js"></script>

<%-- ui-inputmask --%>
<script src="<%=uilib%>/inputmask/jquery.inputmask.min.js"></script>
<script src="<%=uilib%>/inputmask/ui-inputmask.js"></script>

<%-- ui-switcher --%>
<link rel="stylesheet" href="<%=uilib%>/switcher/ui-switcher.css">
<script src="<%=uilib%>/switcher/jquery.switcher.min.js"></script>
<script src="<%=uilib%>/switcher/ui-switcher.js"></script>

<%-- ui-common --%>
<script src="<%=uilib%>/common/ui-common.js"></script>

<%-- ui-validator --%>
<script src="<%=uilib%>/validator/ui-validator.js"></script>

<%-- ui-filedownloader --%>
<script src="<%=uilib%>/filedownloader/ui-filedownloader.js"></script>

<%
// 모듈 로드
if (module != null && !"".equals(module)) {
	String[] modules = module.split(",");

	for (String name : modules) {
		name = name.trim().toLowerCase();

		// 테이블 (Tabulator)
		if ("table".equals(name)) {
			%>
			<link rel="stylesheet" href="<%=uilib%>/tabulator/tabulator.css">
			<script src="<%=uilib%>/tabulator/jquery_wrapper.js"></script>
			<script src="<%=uilib%>/tabulator/tabulator.min.js"></script>
			<script src="<%=uilib%>/tabulator/ui-table.js?v=1"></script>
			<%
		}
		// 에디터 (SynapEditor)
		else if ("editor".equals(name)) {
			%>
			<link rel="stylesheet" href="<%=uilib%>/editor/synapeditor.min.css">
			<link rel="stylesheet" href="<%=uilib%>/editor/plugins/characterPicker/characterPicker.min.css">
			<link rel="stylesheet" href="<%=uilib%>/editor/plugins/shapeEditor/shapeEditor.min.css">
			<script src="<%=uilib%>/editor/synapeditor.min.js"></script>
			<script src="<%=uilib%>/editor/plugins/characterPicker/characterPicker.min.js"></script>
			<script src="<%=uilib%>/editor/plugins/shapeEditor/shapeEditor.min.js"></script>
			<script src="<%=uilib%>/editor/plugins/math/math.js?v=1"></script>
			<script src="<%=uilib%>/editor/externals/SEShapeManager/SEShapeManager.min.js"></script>
			<script src="<%=uilib%>/editor/synapeditor.config.js?v=1"></script>
			<script src="<%=uilib%>/editor/ui-editor.js?v=1"></script>
			<%
		}
		// 파일 업로더 (Dextuploader)
		else if ("fileuploader".equals(name)) {
			%>
			<link rel="stylesheet" href="<%=uilib%>/fileuploader/ui-fileuploader.css">
			<script src="<%=uilib%>/fileuploader/dextuploadx5-configuration.js"></script>
			<script src="<%=uilib%>/fileuploader/dextuploadx5.js"></script>
			<script src="<%=uilib%>/fileuploader/ui-fileuploader.js?v=1"></script>
			<%
		}
		// 플레이어
		else if ("file-player".equals(name)) {
			%>

			<%
		}
		// 차트
		else if ("chart".equals(name)) {
			%>
			<script src="<%=uilib%>/chart/d3.v4.js"></script><!-- chart d3.js -->
			<script src="<%=uilib%>/chart/chart4.min.js"></script><!-- chart4 -->
			<script src="<%=uilib%>/chart/chart-utils.min.js"></script><!-- chart util -->
			<script src="<%=uilib%>/chart/chartjs-plugin-datalabels.min.js"></script>
			<%
		}
		// 위젯
		else if ("widget".equals(name)) {
			%>
			<link rel="stylesheet" href="<%=uilib%>/gridstack/gridstack.min.css">
			<script src="<%=uilib%>/gridstack/gridstack-all.js"></script>
			<script src="<%=uilib%>/gridstack/ui-widget.js"></script>
			<%
		}
		// 탭메뉴
		else if ("tabmenu".equals(name)) {
			%>
			<script src="<%=uilib%>/tabmenu/ui-tabmenu.js"></script>
			<%
		}
	}
}

// assets style 로드
if (style != null && !"".equals(style)) {
	String[] styles = style.split(",");

	for (String name : styles) {
		name = name.trim().toLowerCase();
		%>
		<link rel="stylesheet" href="<%=assets%>/css/<%=name%>.css">
		<%
	}
}
%>
