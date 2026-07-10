<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
    <script type="text/javascript">
        const CTX = '<%=request.getContextPath()%>';
        let EPARAM = '<c:out value="${encParams}" />';
        const orgId = '<c:out value="${vo.orgId}" />';

        $(function() {
            fn_renderResult('-', 'ready', '');
        });

        function fn_renderResult(execDttm, status, message) {
            if (status === 'success') {
                $('#syncStatusIcon').html('<i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i>');
                $('#syncSuccessLog').append('<li><b>' + UiComm.escapeHtml(execDttm || '-') + '</b> ' + UiComm.escapeHtml(message || '') + '</li>');
                $('#syncSuccessBox').show();
            } else if (status === 'error') {
                $('#syncStatusIcon').html('<i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>');
            } else {
                $('#syncStatusIcon').text('-');
            }
        }

        function fn_runHaksaSync() {
            const $button = $('#btnRunHaksaSync');
            $button.prop('disabled', true);
            $('#syncStatusIcon').text('-');

            ajaxCall(CTX + '/user/userMgrDept/admRunUserMgrDeptHaksaSync.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({orgId: orgId})
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                const resultInfo = res.data || {};
                const message = resultInfo.message || res.message || '학사연동 실행 결과를 확인할 수 없습니다.';
                const status = res.result > 0 ? 'success' : 'error';
                fn_renderResult(resultInfo.execDttm || '-', status, message);

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
                fn_renderResult('-', 'error', '학사연동 실행 중 오류가 발생했습니다.');
                UiComm.showMessage('학사연동 실행 중 오류가 발생했습니다.', 'error');
                $button.prop('disabled', false);
            }, true);
        }
    </script>
</head>

<body class="modal-page">
<div id="wrap">
    <div class="table-wrap">
        <table class="table-type2">
            <colgroup>
                <col>
                <col style="width:20%">
                <col style="width:10%">
            </colgroup>
            <thead>
                <tr>
                    <th scope="col">대상</th>
                    <th scope="col">관리</th>
                    <th scope="col">상태</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td data-th="대상" class="t_left">학과/부서 정보를 연동합니다.</td>
                    <td data-th="관리">
                        <button type="button" id="btnRunHaksaSync" class="btn basic small" onclick="fn_runHaksaSync();">학과/부서 정보</button>
                    </td>
                    <td data-th="상태"><span id="syncStatusIcon">-</span></td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 연동 성공 메시지 -->
    <div class="msg-box basic" id="syncSuccessBox" style="display:none;">
        <ul id="syncSuccessLog"></ul>
    </div>
    <!-- //연동 성공 메시지 -->

    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="window.parent.closeDialog();">닫기</button>
    </div>
</div>
<script type="text/javascript" src="<c:url value='/webdoc/js/iframe-content.js'/>"></script>
</body>
</html>
