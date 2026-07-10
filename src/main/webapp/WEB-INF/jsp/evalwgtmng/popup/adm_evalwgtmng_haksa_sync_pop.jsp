<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
    <script type="text/javascript">
        var CTX = '<%=request.getContextPath()%>';
        var EPARAM = '<c:out value="${encParams}" />';
        var orgId = '<c:out value="${vo.orgId}" />';
        var haksaYear = '<c:out value="${vo.haksaYear}" />';
        var haksaTerm = '<c:out value="${vo.haksaTerm}" />';

        $(function() {
            fn_renderResult('-', 'ready', '대기', '연동 실행 전입니다.');
        });

        function fn_renderResult(execDttm, status, statusNm, message) {
            $('#syncExecDttm').text(execDttm || '-');
            $('#syncStatus').text(statusNm || '-');
            $('#syncMessage').text(message || '-');

            $('#syncStatus').removeClass('state_ok state_no state_late');
            if (status === 'success') {
                $('#syncStatus').addClass('state_ok');
            } else if (status === 'error') {
                $('#syncStatus').addClass('state_no');
            } else {
                $('#syncStatus').addClass('state_late');
            }
        }

        function fn_runHaksaSync() {
            var $button = $('#btnRunHaksaSync');
            $button.prop('disabled', true);
            fn_renderResult('-', 'ready', '실행중', '학사연동을 실행 중입니다.');

            ajaxCall(CTX + '/evalwgtmng/admRunEvalWgtMngHaksaSync.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: orgId,
                    haksaYear: haksaYear,
                    haksaTerm: haksaTerm
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                var resultInfo = res.data || {};
                var message = resultInfo.message || res.message || '학사연동 실행 결과를 확인할 수 없습니다.';
                var status = resultInfo.status || (res.result > 0 ? 'success' : 'error');
                var statusNm = resultInfo.statusNm || (res.result > 0 ? '성공' : '실패');
                fn_renderResult(resultInfo.execDttm || '-', status, statusNm, message);

                if (res.result > 0) {
                    UiComm.showMessage(message, 'success');
                    if (window.parent && typeof window.parent.listPaging === 'function') {
                        window.parent.listPaging(window.parent.CURRENT_PAGE || 1);
                    }
                } else {
                    UiComm.showMessage(message, 'error');
                }
                $button.prop('disabled', false);
            }, function() {
                fn_renderResult('-', 'error', '실패', '학사연동 실행 중 오류가 발생했습니다.');
                UiComm.showMessage('학사연동 실행 중 오류가 발생했습니다.', 'error');
                $button.prop('disabled', false);
            }, true);
        }
    </script>
</head>

<body class="modal-page">
<div id="wrap">
    <div class="msg-box basic margin-bottom-4">
        <p class="txt">학사연동설정의 평가비중정보 항목을 기준으로 연동을 실행합니다.</p>
        <ul class="list-dot">
            <li><span>설정 사용여부가 Y일 때만 연동 가능합니다.</span></li>
            <li><span>연동 URL이 없으면 실행할 수 없습니다.</span></li>
        </ul>
    </div>

    <div class="board_top">
        <p class="width-25per border-1 padding-3 flex">기관</p>
        <p class="flex-1 border-1 padding-3 flex"><c:out value="${vo.orgId}"/></p>
    </div>
    <div class="board_top">
        <p class="width-25per border-1 padding-3 flex">년도/학기(기수)</p>
        <p class="flex-1 border-1 padding-3 flex"><c:out value="${vo.haksaYear}"/> / <c:out value="${vo.haksaTerm}"/></p>
    </div>
    <div class="board_top">
        <p class="width-25per border-1 padding-3 flex">연동항목</p>
        <p class="flex-1 border-1 padding-3 flex"><c:out value="${empty aisLinkInfo ? '평가비중정보' : aisLinkInfo.aisLinkTynm}"/></p>
    </div>
    <div class="board_top">
        <p class="width-25per border-1 padding-3 flex">연동코드</p>
        <p class="flex-1 border-1 padding-3 flex"><c:out value="${aisLinkTycd}"/></p>
    </div>
    <div class="board_top">
        <p class="width-25per border-1 padding-3 flex">사용여부</p>
        <p class="flex-1 border-1 padding-3 flex"><c:out value="${empty aisLinkInfo or empty aisLinkInfo.autoLinkyn ? '-' : aisLinkInfo.autoLinkyn}"/></p>
    </div>
    <div class="board_top margin-bottom-4">
        <p class="width-25per border-1 padding-3 flex">연동 URL</p>
        <p class="flex-1 border-1 padding-3 flex"><c:out value="${empty aisLinkInfo or empty aisLinkInfo.manlUrl ? '미설정' : aisLinkInfo.manlUrl}"/></p>
    </div>

    <div class="board_top">
        <h3 class="board-title">연동 결과</h3>
    </div>
    <div class="msg-box basic">
        <ul class="list-dot">
            <li><span>실행시각: <strong id="syncExecDttm">-</strong></span></li>
            <li><span>상태: <strong id="syncStatus" class="state_late">대기</strong></span></li>
            <li><span>메시지: <strong id="syncMessage">연동 실행 전입니다.</strong></span></li>
        </ul>
    </div>

    <div class="modal_btns">
        <button type="button" id="btnRunHaksaSync" class="btn type1" onclick="fn_runHaksaSync();">연동 실행</button>
        <button type="button" class="btn type2" onclick="window.parent.closeDialog();">닫기</button>
    </div>
</div>
<script type="text/javascript" src="<c:url value='/webdoc/js/iframe-content.js'/>"></script>
</body>
</html>
