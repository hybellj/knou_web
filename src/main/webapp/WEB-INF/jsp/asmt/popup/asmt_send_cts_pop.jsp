<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css"/>
    <script type="text/javascript">
        $(document).ready(function () {

        });
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div class="ui segment" style="min-height: 150px; max-height: 300px; overflow: auto;">
        ${asmntJoinVO.sbmsnTxt}
    </div>
    <div class="bottom-content mt5">
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="asmnt.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>