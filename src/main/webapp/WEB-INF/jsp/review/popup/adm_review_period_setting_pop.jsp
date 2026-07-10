<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
    <script type="text/javascript">
        var CTX = '<%=request.getContextPath()%>';
        var EPARAM = '<c:out value="${encParams}" />';
        var ORG_ID = '<c:out value="${vo.orgId}" />';
        var SBJCT_ID = '<c:out value="${detail.sbjctId}" />';
        var REVIEW_STATUS = '<c:out value="${detail.reviewStatus}" />';
        var REVIEW_START_DTTM = '<c:out value="${detail.reviewStartDttm}" />';
        var REVIEW_END_DTTM = '<c:out value="${detail.reviewEndDttm}" />';

        $(function() {
            // 팝업 초기 상태 설정
            REVIEW_STATUS = REVIEW_STATUS || 'RVW_IMPSBL';
            $('input[name=reviewStatus][value="' + REVIEW_STATUS + '"]').prop('checked', true);
            if ($('input[name=reviewStatus]:checked').length === 0) {
                $('#reviewStatus0').prop('checked', true);
            }

            fn_setDttmValue(REVIEW_START_DTTM, '#reviewStartDate', '#reviewStartTime');
            fn_setDttmValue(REVIEW_END_DTTM, '#reviewEndDate', '#reviewEndTime');
            $('input[name=reviewStatus]').on('change', fn_changeStatus);
            fn_changeStatus();
        });

        // 복습 상태에 따라 기간 입력 활성화
        function fn_changeStatus() {
            var enabled = $('input[name=reviewStatus]:checked').val() === 'PRD_STNG';
            $('#periodFields').find('input').prop('disabled', !enabled);
            if (!enabled) {
                fn_clearPeriodFields();
            }
        }

        // 기간 입력값 초기화
        function fn_clearPeriodFields() {
            $('#reviewStartDate, #reviewStartTime, #reviewEndDate, #reviewEndTime').val('');
        }

        // 서버 일시값을 날짜/시간 입력값으로 분리
        function fn_setDttmValue(value, dateSelector, timeSelector) {
            var formatted = UiComm.formatDate(value, 'datetime2');
            if (formatted) {
                var parts = formatted.split(' ');
                $(dateSelector).val(parts[0] || '');
                $(timeSelector).val(parts[1] || '');
            }
        }

        // 복습기간설정 저장
        function fn_save() {
            var reviewStatus = $('input[name=reviewStatus]:checked').val() || 'RVW_IMPSBL';
            var extData = {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                reviewStatus: reviewStatus
            };

            if (reviewStatus === 'PRD_STNG') {
                var startDttm = fn_makeDttm('#reviewStartDate', '#reviewStartTime');
                var endDttm = fn_makeDttm('#reviewEndDate', '#reviewEndTime');

                if (!startDttm || !endDttm) {
                    UiComm.showMessage('복습기간 시작일과 종료일을 입력해 주세요.', 'warning');
                    return;
                }
                if (startDttm > endDttm) {
                    UiComm.showMessage('복습기간 시작일은 종료일보다 늦을 수 없습니다.', 'warning');
                    return;
                }

                extData.reviewStartDttm = startDttm;
                extData.reviewEndDttm = endDttm;
            }

            ajaxCall(CTX + '/review/admSaveReviewPeriod.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    fn_showParentMessage(res.message || '<spring:message code="success.common.save"/>', 'success', function() {
                        if (window.parent && typeof window.parent.fn_afterSaveReviewPeriod === 'function') {
                            window.parent.fn_afterSaveReviewPeriod();
                        } else {
                            fn_close();
                        }
                    });
                } else {
                    UiComm.showMessage(res.message || '저장 중 오류가 발생했습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('저장 중 오류가 발생했습니다.', 'error');
            }, true);
        }

        // 날짜/시간 입력값을 YYYYMMDDHHMISS 형식으로 변환
        function fn_makeDttm(dateSelector, timeSelector) {
            var dttm = UiComm.getDateTimeVal(dateSelector.substring(1), timeSelector.substring(1));
            if (dttm.length !== 12) {
                return '';
            }
            return dttm + '00';
        }

        // 부모 화면 우선으로 메시지 출력
        function fn_showParentMessage(message, type, callback) {
            var comm = window.parent && window.parent.UiComm ? window.parent.UiComm : UiComm;
            var result = comm.showMessage(message, type);
            if (result && typeof result.then === 'function') {
                result.then(callback);
            } else if (typeof callback === 'function') {
                callback();
            }
        }

        // 팝업 닫기
        function fn_close() {
            if (window.parent && typeof window.parent.closeDialog === 'function') {
                window.parent.closeDialog();
                return;
            }
            try {
                $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
            } catch (e) {
                window.close();
            }
        }
    </script>
</head>
<body>
<div class="pop-body">
    <div class="table_list">
        <ul class="list">
            <li class="head"><label>설정</label></li>
            <li>
                <span class="custom-input">
                    <input type="radio" id="reviewStatus0" name="reviewStatus" value="RVW_IMPSBL"/>
                    <label for="reviewStatus0">불가</label>
                </span>
                <span class="custom-input">
                    <input type="radio" id="reviewStatus1" name="reviewStatus" value="RVW_PSBL"/>
                    <label for="reviewStatus1">영구</label>
                </span>
                <span class="custom-input">
                    <input type="radio" id="reviewStatus2" name="reviewStatus" value="PRD_STNG"/>
                    <label for="reviewStatus2">기간설정</label>
                </span>
            </li>
        </ul>
        <ul class="list" id="periodFields">
            <li class="head"><label>기간</label></li>
            <li>
                <div class="form-inline">
                    <div class="date_area">
                        <input id="reviewStartDate" type="text" name="reviewStartDate" class="datepicker" timeId="reviewStartTime" toDate="reviewEndDate" placeholder="시작일"/>
                        <input id="reviewStartTime" type="text" name="reviewStartTime" class="timepicker" dateId="reviewStartDate" placeholder="시작시간"/>
                        <span class="txt-sort">~</span>
                        <input id="reviewEndDate" type="text" name="reviewEndDate" class="datepicker" timeId="reviewEndTime" fromDate="reviewStartDate" placeholder="종료일"/>
                        <input id="reviewEndTime" type="text" name="reviewEndTime" class="timepicker" dateId="reviewEndDate" placeholder="종료시간"/>
                    </div>
                </div>
            </li>
        </ul>
    </div>

    <div class="modal_btns">
        <button type="button" class="btn type1" onclick="fn_save();">저장</button>
        <button type="button" class="btn type2" onclick="fn_close();">닫기</button>
    </div>
</div>
</body>
</html>
