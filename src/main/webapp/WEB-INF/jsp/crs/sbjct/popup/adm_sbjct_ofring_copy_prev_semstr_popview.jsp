<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        // 부모 UiDialog가 있으면 닫고, 단독 창이면 window.close를 시도한다.
        function closeSbjctOfringCopyPrevSmstrPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
                return;
            }
            window.close();
        }
    </script>
    <style>
        .ofring-copy-prev-pop { padding: 12px; }
        .ofring-copy-prev-pop .btns { margin-top: 14px; text-align: center; }
    </style>
</head>
<body class="modal-page">
    <div class="ofring-copy-prev-pop">
        <c:set var="prevSmstrImportUrl" value="/crs/creCrsMgr/admPrevSmstrDataRegist.do" />
        <c:set var="hidePrevSmstrImportTitle" value="Y" scope="request" /><%-- 과목관리 팝업에서는 공통 제목 영역을 표시하지 않는다. --%>
        <jsp:include page="/WEB-INF/jsp/crs/smstr/copy_prev_semester_inc.jsp" />
        <div class="btns">
            <button type="button" class="btn type2" onclick="closeSbjctOfringCopyPrevSmstrPop();"><spring:message code="button.close" /></button><%-- 닫기 --%>
        </div>
    </div>
</body>
</html>
