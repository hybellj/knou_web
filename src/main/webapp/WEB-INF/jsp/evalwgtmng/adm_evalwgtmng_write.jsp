<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
    <script type="text/javascript">
        var EPARAM = '<c:out value="${encParams}" />';
        var MENU_ID = '<c:out value="${vo.menuId}" />';
        var CTX = '<%=request.getContextPath()%>';
        var MODE = '<c:out value="${mode}" />';
        var IS_REGIST = MODE === 'regist';
        var IS_READ_ONLY = MODE === 'view';

        var SELECTED_ORG_ID = '<c:out value="${empty subjectInfo.orgId ? vo.orgId : subjectInfo.orgId}" />';
        var SELECTED_HAKSA_YEAR = '<c:out value="${empty subjectInfo.haksaYear ? vo.haksaYear : subjectInfo.haksaYear}" />';
        var SELECTED_HAKSA_TERM = '<c:out value="${empty subjectInfo.haksaTerm ? vo.haksaTerm : subjectInfo.haksaTerm}" />';
        var SELECTED_SBJCT_ID = '<c:out value="${empty subjectInfo.sbjctId ? vo.sbjctId : subjectInfo.sbjctId}" />';

        var searchYearList = [];
        <c:forEach var="year" items="${yearList}">
        searchYearList.push('<c:out value="${year}" />');
        </c:forEach>

        var currentSmstrChrtList = [];
        <c:forEach var="item" items="${smstrChrtList}">
        currentSmstrChrtList.push({
            dgrsYr: '<c:out value="${item.dgrsYr}" />',
            dgrsSmstrChrt: '<c:out value="${item.dgrsSmstrChrt}" />',
            smstrChrtId: '<c:out value="${item.smstrChrtId}" />',
            smstrChrtnm: '<c:out value="${item.smstrChrtnm}" />'
        });
        </c:forEach>

        $(function() {
            if (IS_REGIST) {
                fn_initRegistOptions();
            } else {
                fn_changeTargetSbjct();
            }
        });

        function fn_list() {
            location.href = fn_appendMenuId(CTX + '/evalwgtmng/admEvalWgtMngList.do?encParams=' + encodeURIComponent(EPARAM));
        }

        function fn_appendMenuId(url) {
            if (!MENU_ID) {
                return url;
            }
            return url + (url.indexOf('?') > -1 ? '&' : '?') + 'menuId=' + encodeURIComponent(MENU_ID);
        }

        function fn_modify() {
            var extData = {
                orgId: $('#orgId').val(),
                haksaYear: $('#haksaYear').val(),
                haksaTerm: $('#haksaTerm').val(),
                sbjctId: $('#sbjctId').val(),
                mode: 'modify'
            };

            location.href = fn_appendMenuId(CTX + '/evalwgtmng/admEvalWgtMngWrite.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(UiComm.makeEncParams(extData)));
        }

        function fn_initRegistOptions() {
            renderRegHaksaYearOptions(SELECTED_HAKSA_YEAR);
            if (!$('#orgId').val()) {
                renderRegHaksaTermOptions([], $('#haksaYear').val(), '');
                renderRegSubjectOptions([], '');
                fn_clearSubjectInfo();
                return;
            }

            renderRegHaksaTermOptions(currentSmstrChrtList, $('#haksaYear').val(), SELECTED_HAKSA_TERM);
            fn_loadRegSubjectOptions(SELECTED_SBJCT_ID, function() {
                if ($('#sbjctId').val()) {
                    fn_changeRegSubject();
                } else {
                    fn_clearSubjectInfo();
                }
            });
        }

        function renderRegHaksaYearOptions(selectedYear) {
            var html = '<option value="">년도</option>';
            for (var i = 0; i < searchYearList.length; i++) {
                html += '<option value="' + UiComm.escapeHtml(String(searchYearList[i])) + '">' + UiComm.escapeHtml(String(searchYearList[i])) + '</option>';
            }
            $('#haksaYear').html(html);
            $('#haksaYear').val(selectedYear || '');
            fn_refreshChosen('#haksaYear');
        }

        function renderRegHaksaTermOptions(list, year, selectedTerm) {
            var html = '<option value="">학기</option>';
            for (var i = 0; i < list.length; i++) {
                if ((list[i].dgrsYr || '') !== (year || '')) {
                    continue;
                }
                html += '<option value="' + UiComm.escapeHtml(String(list[i].dgrsSmstrChrt || '')) + '">' + UiComm.escapeHtml(String(fn_formatTermText(list[i].dgrsSmstrChrt || '', list[i].smstrChrtnm || list[i].haksaTermNm || ''))) + '</option>';
            }
            $('#haksaTerm').html(html);

            $('#haksaTerm').val(selectedTerm || '');
            fn_refreshChosen('#haksaTerm');
        }

        function renderRegSubjectOptions(list, selectedSbjctId) {
            var html = '<option value="">과목</option>';

            list = list || [];

            for (var i = 0; i < list.length; i++) {
                var sbjctId = list[i].sbjctId || '';
                var label = list[i].sbjctNm || '-';

                html += '<option value="' + UiComm.escapeHtml(String(sbjctId)) + '">' + UiComm.escapeHtml(String(label)) + '</option>';
            }
            $('#sbjctId').html(html);
            $('#sbjctId').val(selectedSbjctId || '');
            fn_refreshChosen('#sbjctId');
        }

        function fn_refreshChosen(selector) {
            var $select = $(selector);
            if ($select.hasClass('chosen')) {
                $select.trigger('chosen:updated');
            }
        }

        function fn_changeRegOrg() {
            renderRegHaksaYearOptions($('#haksaYear').val());
            fn_loadRegHaksaTermOptions('', function() {
                renderRegSubjectOptions([], '');
                fn_clearSubjectInfo();
                fn_loadRegSubjectOptions('');
            });
        }

        function fn_changeRegYear() {
            fn_loadRegHaksaTermOptions('', function() {
                renderRegSubjectOptions([], '');
                fn_clearSubjectInfo();
                fn_loadRegSubjectOptions('');
            });
        }

        function fn_changeRegTerm() {
            renderRegSubjectOptions([], '');
            fn_clearSubjectInfo();
            fn_loadRegSubjectOptions('');
        }

        function fn_changeRegSubject() {
            var sbjctId = $('#sbjctId').val();
            fn_clearSubjectInfo();
            if (!sbjctId) {
                return;
            }

            ajaxCall(CTX + '/evalwgtmng/admSelectEvalWgtMngSubject.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: $('#orgId').val(),
                    sbjctId: sbjctId,
                    mode: MODE
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                    $('#encParams').val(EPARAM);
                }
                if (res.result > 0) {
                    var resultMap = res.data || {};
                    var subject = resultMap.subjectInfo || {};
                    $('#orgId').val(subject.orgId || $('#orgId').val());
                    $('#haksaYear').val(subject.haksaYear || $('#haksaYear').val());
                    $('#haksaTerm').val(subject.haksaTerm || $('#haksaTerm').val());
                    fn_refreshChosen('#orgId');
                    fn_refreshChosen('#haksaYear');
                    fn_refreshChosen('#haksaTerm');

                    $('#dvclasNoText').text(subject.dvclasNo || '-');
                    $('#profNmText').text(subject.profNm || '-');
                    fn_renderDvclasList(resultMap.dvclasList || [], subject.sbjctId || sbjctId);
                    fn_renderItemRows(resultMap.itemList || []);
                } else {
                    UiComm.showMessage(res.message || '과목 정보를 확인할 수 없습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('과목 정보를 확인하는 중 오류가 발생했습니다.', 'error');
            }, true);
        }

        function fn_loadRegHaksaTermOptions(selectedTerm, callback) {
            currentSmstrChrtList = [];
            renderRegHaksaTermOptions([], $('#haksaYear').val(), '');

            if (!$('#orgId').val() || !$('#haksaYear').val()) {
                if (typeof callback === 'function') {
                    callback();
                }
                return;
            }

            ajaxCall(CTX + '/evalwgtmng/admListHaksaTerm.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: $('#orgId').val(),
                    haksaYear: $('#haksaYear').val()
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                    $('#encParams').val(EPARAM);
                }
                if (res.result > 0) {
                    currentSmstrChrtList = fn_normalizeSmstrChrtList(res.returnList || [], $('#haksaYear').val());
                    renderRegHaksaTermOptions(currentSmstrChrtList, $('#haksaYear').val(), selectedTerm || '');
                }
                if (typeof callback === 'function') {
                    callback();
                }
            }, function() {
                UiComm.showMessage('년도/학기 목록 조회 중 오류가 발생했습니다.', 'error');
                if (typeof callback === 'function') {
                    callback();
                }
            }, true);
        }

        function fn_loadRegSubjectOptions(selectedSbjctId, callback) {
            if (!$('#orgId').val() || !$('#haksaYear').val() || !$('#haksaTerm').val()) {
                renderRegSubjectOptions([], '');
                if (typeof callback === 'function') {
                    callback();
                }
                return;
            }

            ajaxCall(CTX + '/evalwgtmng/admListEvalWgtMngSubject.do', {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams({
                    orgId: $('#orgId').val(),
                    haksaYear: $('#haksaYear').val(),
                    haksaTerm: $('#haksaTerm').val()
                })
            }, function(res) {
                if (res.encParams) {
                    EPARAM = res.encParams;
                    $('#encParams').val(EPARAM);
                }
                if (res.result > 0) {
                    renderRegSubjectOptions(res.returnList || [], selectedSbjctId || '');
                } else {
                    renderRegSubjectOptions([], '');
                }
                if (typeof callback === 'function') {
                    callback();
                }
            }, function() {
                UiComm.showMessage('과목 목록 조회 중 오류가 발생했습니다.', 'error');
                if (typeof callback === 'function') {
                    callback();
                }
            }, true);
        }

        function fn_clearSubjectInfo() {
            $('#dvclasNoText').text('-');
            $('#profNmText').text('-');
            fn_renderDvclasList([], '');
            fn_renderEmptyItemRows('과목 선택 시 자동 셋팅');
        }

        function fn_isAttendanceItem(item) {
            var code = $.trim(String(item && item.mrkItmTycd ? item.mrkItmTycd : '')).toUpperCase();
            return code === 'PRG' || code === 'EXRCS_QSTN';
        }

        function fn_renderRateCell(item, index) {
            item = item || {};
            var rate = item.mrkRfltrt == null ? '' : item.mrkRfltrt;
            var useYn = item.mrkItmUseyn === 'Y' ? 'Y' : 'N';
            var html = '<td class="border-left-1">';

            if (IS_READ_ONLY) {
                html += useYn === 'Y' ? UiComm.escapeHtml(String(rate)) : '-';
            } else {
                html += '<div class="form-row">'
                    + '<input type="hidden" name="mrkItmStngList[' + index + '].mrkItmTycd" value="' + UiComm.escapeHtml(String(item.mrkItmTycd || '')) + '"/>'
                    + '<input type="hidden" id="mrkItmUseyn' + index + '" name="mrkItmStngList[' + index + '].mrkItmUseyn" value="' + UiComm.escapeHtml(String(item.mrkItmUseyn || 'N')) + '"/>'
                    + '<input type="number" class="form-control width-100per item-rate tr" name="mrkItmStngList[' + index + '].mrkRfltrt" value="' + UiComm.escapeHtml(String(rate)) + '" data-index="' + index + '" min="0" max="100" step="0.01"/>'
                    + '</div>';
            }

            html += '</td>';
            return html;
        }

        function fn_renderOpenCell(item, index) {
            item = item || {};
            var useYn = item.mrkItmUseyn === 'Y' ? 'Y' : 'N';
            var mrkOyn = item.mrkOyn === 'N' ? 'N' : 'Y';
            var html = '<td class="border-left-1">';

            if (IS_READ_ONLY) {
                if (useYn !== 'Y') {
                    html += '-';
                } else if (mrkOyn === 'N') {
                    html += '<span class="fcRed">비공개</span>';
                } else {
                    html += '공개';
                }
            } else {
                html += '<div class="form-row justify-content-center">'
                    + '<input type="hidden" id="mrkOyn' + index + '" name="mrkItmStngList[' + index + '].mrkOyn" value="' + mrkOyn + '"/>'
                    + '<input type="checkbox" id="mrkOynSwitch' + index + '" class="switch yesno item-open-toggle" value="Y" data-index="' + index + '"' + (mrkOyn === 'Y' ? ' checked="checked"' : '') + '/>'
                    + '</div>';
            }

            html += '</td>';
            return html;
        }

        function fn_renderEmptyItemRows(message) {
            var text = message || '평가항목을 확인할 수 없습니다.';
            $('#evalRateTbody').html(
                '<tr><th class="req" colspan="2">평가비중</th></tr>'
                + '<tr><td colspan="2" class="tc padding-5">' + UiComm.escapeHtml(text) + '</td></tr>'
            );
        }

        function fn_renderItemRows(list) {
            if (!list || list.length === 0) {
                fn_renderEmptyItemRows('평가항목을 확인할 수 없습니다.');
                return;
            }

            var html = '';
            var hasExamItem = fn_hasExamItem(list);
            var totalCols = list.length + (hasExamItem ? 0 : 1) + 1;
            var attendanceItems = [];
            var hasAttendanceGroup = attendanceItems.length > 0;
            var attendanceHeaderRendered = false;

            for (var i = 0; i < list.length; i++) {
                if (fn_isAttendanceItem(list[i])) {
                    attendanceItems.push(list[i]);
                }
            }

            hasAttendanceGroup = attendanceItems.length > 0;

            html += '<tr><th class="req" colspan="' + totalCols + '">평가비중</th></tr>';
            html += '<tr><th scope="col" class="text-center"' + (hasAttendanceGroup ? ' rowspan="2"' : '') + '>평가항목</th>';
            for (var j = 0; j < list.length; j++) {
                if (fn_isAttendanceItem(list[j])) {
                    if (attendanceHeaderRendered) {
                        continue;
                    }
                    html += '<th scope="col" colspan="' + attendanceItems.length + '" class="text-center border-left-1">출석</th>';
                    attendanceHeaderRendered = true;
                } else {
                    html += '<th scope="col" class="text-center border-left-1"' + (hasAttendanceGroup ? ' rowspan="2"' : '') + '>' + UiComm.escapeHtml(String(list[j].mrkItmTynm || '')) + '</th>';
                }
            }
            if (!hasExamItem) {
                html += '<th scope="col" class="text-center border-left-1"' + (hasAttendanceGroup ? ' rowspan="2"' : '') + '>시험</th>';
            }
            html += '</tr>';

            if (hasAttendanceGroup) {
                html += '<tr>';
                for (var a = 0; a < attendanceItems.length; a++) {
                    html += '<th scope="col" class="text-center border-left-1">' + UiComm.escapeHtml(String(attendanceItems[a].mrkItmTynm || '')) + '</th>';
                }
                html += '</tr>';
            }

            html += '<tr><th scope="row" class="text-center">비중</th>';
            for (var b = 0; b < list.length; b++) {
                html += fn_renderRateCell(list[b], b);
            }
            if (!hasExamItem) {
                html += '<td class="text-center border-left-1">-</td>';
            }
            html += '</tr>';

            html += '<tr><th scope="row" class="text-center">성적공개여부</th>';
            for (var c = 0; c < list.length; c++) {
                html += fn_renderOpenCell(list[c], c);
            }
            if (!hasExamItem) {
                html += '<td class="text-center border-left-1">-</td>';
            }
            html += '</tr>';

            $('#evalRateTbody').html(html);
            UiSwitcher();
        }

        function fn_hasExamItem(list) {
            for (var i = 0; i < list.length; i++) {
                if ((list[i].mrkItmTynm || '') === '시험') {
                    return true;
                }
            }
            return false;
        }

        function fn_renderDvclasList(list, selectedSbjctId) {
            var html = '';
            if (!list || list.length === 0) {
                html = '<span class="fcRed">(과목 선택 시 자동 셋팅)</span>';
                $('#dvclasArea').html(html);
                return;
            }

            html += '<div class="checkbox_type flex flex-wrap align-items-center">';
            html += '<span class="custom-input">';
            html += '<input type="checkbox" id="targetSbjctAll" value="all" onchange="fn_changeTargetAll(this)">';
            html += '<label for="targetSbjctAll">전체</label>';
            html += '</span>';

            for (var i = 0; i < list.length; i++) {
                var sbjctId = list[i].sbjctId || '';
                if (!sbjctId) {
                    continue;
                }
                var dvclasNo = list[i].dvclasNo || '-';
                var checked = sbjctId === selectedSbjctId;
                var inputId = 'targetSbjctId' + i;
                var escapedSbjctId = UiComm.escapeHtml(String(sbjctId));

                html += '<span class="custom-input">';
                html += '<input type="checkbox" class="target-sbjct-id" name="targetSbjctIds" id="' + inputId + '" value="' + escapedSbjctId + '"';
                if (checked) {
                    html += ' checked="checked"';
                }
                html += ' onchange="fn_changeTargetSbjct();"';
                html += '>';
                html += '<label for="' + inputId + '">' + UiComm.escapeHtml(String(dvclasNo)) + (dvclasNo === '-' ? '' : '반') + '</label>';
                html += '</span>';
            }

            html += '<span class="fcRed ml5">(과목 선택 시 자동 셋팅)</span>';
            html += '</div>';
            $('#dvclasArea').html(html);
            fn_changeTargetSbjct();
        }

        function fn_changeTargetAll(el) {
            var checked = $(el).is(':checked');
            $('.target-sbjct-id').prop('checked', checked);
            fn_changeTargetSbjct();
        }

        function fn_changeTargetSbjct() {
            var $targets = $('.target-sbjct-id');
            $('#targetSbjctAll').prop('checked', $targets.length > 0 && $targets.filter(':checked').length === $targets.length);
        }

        function fn_normalizeSmstrChrtList(list, year) {
            var result = [];
            for (var i = 0; i < list.length; i++) {
                result.push({
                    dgrsYr: list[i].dgrsYr || year || '',
                    dgrsSmstrChrt: list[i].dgrsSmstrChrt || '',
                    smstrChrtId: list[i].smstrChrtId || '',
                    smstrChrtnm: list[i].smstrChrtnm || list[i].haksaTermNm || ''
                });
            }
            return result;
        }

        function fn_formatTermText(term, termName) {
            var nameText = $.trim(termName || '');
            if (nameText) {
                return nameText;
            }
            return $.trim(term || '');
        }

        function fn_syncUseYn() {
            $('.item-rate').each(function() {
                var index = $(this).data('index');
                var value = $.trim($(this).val());
                $('#mrkItmUseyn' + index).val(value === '' ? 'N' : 'Y');
            });
        }

        function fn_syncMrkOyn() {
            $('.item-open-toggle').each(function() {
                var index = $(this).data('index');
                $('#mrkOyn' + index).val($(this).is(':checked') ? 'Y' : 'N');
            });
        }

        function fn_validate() {
            if(!$('#orgId').val()) {
                UiComm.showMessage('기관을 선택해 주세요.', 'error');
                return false;
            }
            if(!$('#haksaYear').val() || !$('#haksaTerm').val()) {
                UiComm.showMessage('년도/학기(기수)를 선택해 주세요.', 'error');
                return false;
            }
            if(!$('#sbjctId').val()) {
                UiComm.showMessage('과목을 선택해 주세요.', 'error');
                return false;
            }
            if($('input[name="targetSbjctIds"]:checked').length === 0) {
                UiComm.showMessage('분반을 선택해 주세요.', 'error');
                return false;
            }

            var totalScaled = 0;
            var valid = true;
            $('.item-rate').each(function(index) {
                var valueText = $.trim($(this).val());
                if(valueText === '') {
                    return true;
                }

                if(!/^\d+(\.\d{1,2})?$/.test(valueText)) {
                    UiComm.showMessage((index + 1) + '번째 평가비중은 소수 둘째자리까지 입력해 주세요.', 'error');
                    valid = false;
                    return false;
                }

                var value = Number(valueText);
                if(isNaN(value)) {
                    UiComm.showMessage((index + 1) + '번째 평가비중은 숫자로 입력해 주세요.', 'error');
                    valid = false;
                    return false;
                }
                if(value < 0 || value > 100) {
                    UiComm.showMessage('평가비중은 0부터 100 사이로 입력해 주세요.', 'error');
                    valid = false;
                    return false;
                }
                totalScaled += Math.round(value * 100);
            });

            if(!valid) {
                return false;
            }
            if(totalScaled !== 10000) {
                UiComm.showMessage('평가비중 합계는 100이어야 합니다.', 'error');
                return false;
            }

            return true;
        }

        function fn_save() {
            fn_syncUseYn();
            fn_syncMrkOyn();
            if(!fn_validate()) {
                return;
            }

            UiComm.showMessage('평가비중을 저장하시겠습니까?', 'confirm').then(function(ok) {
                if(!ok) {
                    return;
                }

                ajaxCall(CTX + '/evalwgtmng/admSaveEvalWgtMng.do', $('#evalWgtMngForm').serialize(), function(res) {
                    if(res.encParams) {
                        EPARAM = res.encParams;
                        $('#encParams').val(EPARAM);
                    }

                    if(res.result > 0) {
                        UiComm.showMessage(res.message || '<spring:message code="success.common.save"/>', 'success').then(function() {
                            fn_list();
                        });
                    } else {
                        UiComm.showMessage(res.message || '저장 중 오류가 발생했습니다.', 'error');
                    }
                }, function() {
                    UiComm.showMessage('저장 중 오류가 발생했습니다.', 'error');
                }, true);
            });
        }
    </script>
</head>

<c:set var="readOnly" value="${mode eq 'view'}"/>
<body class="admin ${bodyClass}">
<div id="wrap" class="main evalwgtmng-page">
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="box">
                        <div class="board_top">
                            <h3 class="board-title">
                                <c:choose>
                                    <c:when test="${mode eq 'regist'}">등록</c:when>
                                    <c:when test="${mode eq 'modify'}">수정</c:when>
                                    <c:otherwise>상세보기</c:otherwise>
                                </c:choose>
                            </h3>
                        </div>

                        <form id="evalWgtMngForm" name="evalWgtMngForm" method="post">
                        <c:set var="currentOrgId" value="${empty subjectInfo.orgId ? vo.orgId : subjectInfo.orgId}"/>
                        <c:set var="currentOrgNm" value="${empty subjectInfo.orgNm ? vo.orgId : subjectInfo.orgNm}"/>
                        <c:set var="currentHaksaYear" value="${empty subjectInfo.haksaYear ? vo.haksaYear : subjectInfo.haksaYear}"/>
                        <c:set var="currentHaksaTerm" value="${empty subjectInfo.haksaTerm ? vo.haksaTerm : subjectInfo.haksaTerm}"/>
                        <c:set var="currentHaksaTermNm" value="${empty subjectInfo.haksaTermNm ? '' : subjectInfo.haksaTermNm}"/>
                        <c:set var="currentHaksaYearText" value="${currentHaksaYear}"/>
                        <c:if test="${not empty currentHaksaYear}">
                            <c:set var="currentHaksaYearText" value="${currentHaksaYear}년"/>
                        </c:if>
                        <c:set var="currentHaksaTermText" value="${empty currentHaksaTermNm ? currentHaksaTerm : currentHaksaTermNm}"/>
                        <c:set var="currentSbjctId" value="${empty subjectInfo.sbjctId ? vo.sbjctId : subjectInfo.sbjctId}"/>
                        <c:set var="currentSbjctNm" value="${empty subjectInfo.sbjctNm ? vo.sbjctNm : subjectInfo.sbjctNm}"/>
                        <c:set var="currentDvclasNo" value="${empty subjectInfo.dvclasNo ? '-' : subjectInfo.dvclasNo}"/>
                        <input type="hidden" id="encParams" name="encParams" value="${encParams}"/>
                        <input type="hidden" id="mode" name="mode" value="${mode}"/>
                        <c:if test="${mode ne 'regist'}">
                            <input type="hidden" id="orgId" name="orgId" value="${currentOrgId}"/>
                            <input type="hidden" id="haksaYear" name="haksaYear" value="${currentHaksaYear}"/>
                            <input type="hidden" id="haksaTerm" name="haksaTerm" value="${currentHaksaTerm}"/>
                            <input type="hidden" id="sbjctId" name="sbjctId" value="${currentSbjctId}"/>
                        </c:if>

                        <c:set var="hasExamItem" value="N"/>
                        <c:forEach var="item" items="${mrkItmStngList}">
                            <c:if test="${item.mrkItmTynm eq '시험'}">
                                <c:set var="hasExamItem" value="Y"/>
                            </c:if>
                        </c:forEach>
                        <c:set var="evalExtraCol" value="0"/>
                        <c:if test="${hasExamItem ne 'Y'}">
                            <c:set var="evalExtraCol" value="1"/>
                        </c:if>
                        <c:set var="attendanceColspan" value="0"/>
                        <c:forEach var="item" items="${mrkItmStngList}">
                            <c:if test="${item.mrkItmTycd eq 'PRG' or item.mrkItmTycd eq 'EXRCS_QSTN'}">
                                <c:set var="attendanceColspan" value="${attendanceColspan + 1}"/>
                            </c:if>
                        </c:forEach>
                        <c:set var="hasAttendanceItem" value="${attendanceColspan gt 0}"/>
                        <c:set var="evalColspan" value="${fn:length(mrkItmStngList) + evalExtraCol + 1}"/>

                        <div class="table-wrap">
                            <table class="table-type5 eval-rate-table">
                                <colgroup>
                                    <col style="width:160px;">
                                    <c:forEach var="item" items="${mrkItmStngList}">
                                        <col>
                                    </c:forEach>
                                    <c:if test="${not empty mrkItmStngList and hasExamItem ne 'Y'}">
                                        <col>
                                    </c:if>
                                    <c:if test="${empty mrkItmStngList}">
                                        <col>
                                    </c:if>
                                </colgroup>
                                <tbody>
                                <c:choose>
                                    <c:when test="${readOnly}">
                                        <tr>
                                            <th>기관</th>
                                            <td colspan="${evalColspan - 1}"><c:out value="${currentOrgNm}"/></td>
                                        </tr>
                                        <tr>
                                            <th>년도/학기(기수)</th>
                                            <td colspan="${evalColspan - 1}"><c:out value="${currentHaksaYearText} ${currentHaksaTermText}"/></td>
                                        </tr>
                                        <tr>
                                            <th>과목</th>
                                            <td colspan="${evalColspan - 1}"><c:out value="${currentSbjctNm}"/></td>
                                        </tr>
                                        <tr>
                                            <th>분반</th>
                                            <td colspan="${evalColspan - 1}">
                                                <c:choose>
                                                    <c:when test="${currentDvclasNo eq '-'}">-</c:when>
                                                    <c:otherwise><c:out value="${currentDvclasNo}"/>반</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:when test="${mode eq 'regist'}">
                                        <tr>
                                            <th>기관 <span class="fcRed">*</span></th>
                                            <td colspan="${evalColspan - 1}">
                                                <select id="orgId" name="orgId" class="form-select type-num w350" onchange="fn_changeRegOrg();">
                                                    <c:if test="${allOrgYn eq 'Y'}">
                                                        <option value="">선택</option>
                                                    </c:if>
                                                    <c:forEach var="org" items="${orgList}">
                                                        <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${empty org.orgNm ? org.orgnm : org.orgNm}"/></option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>년도/학기(기수) <span class="fcRed">*</span></th>
                                            <td colspan="${evalColspan - 1}">
                                                <div class="form-inline">
                                                    <select id="haksaYear" name="haksaYear" class="form-select type-num w150" onchange="fn_changeRegYear();" placeholder="년도"></select>
                                                    <select id="haksaTerm" name="haksaTerm" class="form-select type-num w200" onchange="fn_changeRegTerm();" placeholder="학기"></select>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>과목 <span class="fcRed">*</span></th>
                                            <td colspan="${evalColspan - 1}">
                                                <select id="sbjctId" name="sbjctId" class="form-select type-num w500" onchange="fn_changeRegSubject();" placeholder="과목"></select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>분반같이 등록 <span class="fcRed">*</span></th>
                                            <td id="dvclasArea" colspan="${evalColspan - 1}"><span class="fcRed">(과목 선택 시 자동 셋팅)</span></td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <th>기관 <c:if test="${not readOnly}"><span class="fcRed">*</span></c:if></th>
                                            <td colspan="${evalColspan - 1}"><input type="text" class="form-control w350" value="<c:out value='${currentOrgNm}'/>" disabled="disabled"/></td>
                                        </tr>
                                        <tr>
                                            <th>년도/학기(기수) <c:if test="${not readOnly}"><span class="fcRed">*</span></c:if></th>
                                            <td colspan="${evalColspan - 1}">
                                                <div class="form-inline">
                                                    <input type="text" class="form-control w150" value="<c:out value='${currentHaksaYearText}'/>" disabled="disabled"/>
                                                    <input type="text" class="form-control w200" value="<c:out value='${currentHaksaTermText}'/>" disabled="disabled"/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>과목 <c:if test="${not readOnly}"><span class="fcRed">*</span></c:if></th>
                                            <td colspan="${evalColspan - 1}"><input type="text" class="form-control w500" value="<c:out value='${currentSbjctNm}'/>" disabled="disabled"/></td>
                                        </tr>
                                        <tr>
                                            <th>분반같이 등록 <c:if test="${not readOnly}"><span class="fcRed">*</span></c:if></th>
                                            <td id="dvclasArea" colspan="${evalColspan - 1}">
                                                <c:choose>
                                                    <c:when test="${empty dvclasList}">
                                                        <span class="fcRed">(과목 선택 시 자동 셋팅)</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="checkbox_type flex flex-wrap align-items-center">
                                                            <span class="custom-input">
                                                                <input type="checkbox"
                                                                       id="targetSbjctAll"
                                                                       value="all"
                                                                       onchange="fn_changeTargetAll(this)"
                                                                       <c:if test="${fn:length(dvclasList) eq 1}">checked="checked"</c:if>
                                                                       <c:if test="${readOnly}">disabled="disabled"</c:if>>
                                                                <label for="targetSbjctAll">전체</label>
                                                            </span>
                                                            <c:forEach var="dvclas" items="${dvclasList}" varStatus="st">
                                                                <span class="custom-input">
                                                                    <input type="checkbox"
                                                                           class="target-sbjct-id"
                                                                           name="targetSbjctIds"
                                                                           id="targetSbjctId${st.index}"
                                                                           value="${dvclas.sbjctId}"
                                                                           <c:if test="${dvclas.sbjctId eq currentSbjctId}">checked="checked"</c:if>
                                                                           <c:if test="${not readOnly}">onchange="fn_changeTargetSbjct();"</c:if>
                                                                           <c:if test="${readOnly}">disabled="disabled"</c:if>>
                                                                    <label for="targetSbjctId${st.index}"><c:out value="${dvclas.dvclasNo}"/><c:if test="${dvclas.dvclasNo ne '-'}">반</c:if></label>
                                                                </span>
                                                            </c:forEach>
                                                            <span class="fcRed ml5">(과목 선택 시 자동 셋팅)</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                                <tbody id="evalRateTbody">
                                <c:choose>
                                    <c:when test="${empty mrkItmStngList}">
                                        <tr>
                                            <th class="req" colspan="2">평가비중</th>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="tc padding-5">평가항목을 확인할 수 없습니다.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <th class="req" colspan="${evalColspan}">평가비중</th>
                                        </tr>
                                        <tr>
                                            <th scope="col" class="text-center" <c:if test="${hasAttendanceItem}">rowspan="2"</c:if>>평가항목</th>
                                            <c:set var="attendanceHeaderRendered" value="N"/>
                                            <c:forEach var="item" items="${mrkItmStngList}">
                                                <c:choose>
                                                    <c:when test="${item.mrkItmTycd eq 'PRG' or item.mrkItmTycd eq 'EXRCS_QSTN'}">
                                                        <c:if test="${attendanceHeaderRendered ne 'Y'}">
                                                            <th scope="col" colspan="${attendanceColspan}" class="text-center border-left-1">출석</th>
                                                            <c:set var="attendanceHeaderRendered" value="Y"/>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <th scope="col" class="text-center border-left-1" <c:if test="${hasAttendanceItem}">rowspan="2"</c:if>><c:out value="${item.mrkItmTynm}"/></th>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <c:if test="${hasExamItem ne 'Y'}">
                                                <th scope="col" class="text-center border-left-1" <c:if test="${hasAttendanceItem}">rowspan="2"</c:if>>시험</th>
                                            </c:if>
                                        </tr>
                                        <c:if test="${hasAttendanceItem}">
                                            <tr>
                                                <c:forEach var="item" items="${mrkItmStngList}">
                                                    <c:if test="${item.mrkItmTycd eq 'PRG' or item.mrkItmTycd eq 'EXRCS_QSTN'}">
                                                        <th scope="col" class="text-center border-left-1"><c:out value="${item.mrkItmTynm}"/></th>
                                                    </c:if>
                                                </c:forEach>
                                            </tr>
                                        </c:if>
                                        <tr>
                                            <th scope="row" class="text-center">비중</th>
                                            <c:forEach var="item" items="${mrkItmStngList}" varStatus="st">
                                                <td class="border-left-1">
                                                    <c:choose>
                                                        <c:when test="${readOnly}">
                                                            <c:choose>
                                                                <c:when test="${item.mrkItmUseyn eq 'Y'}"><c:out value="${item.mrkRfltrt}"/></c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="form-row">
                                                            <input type="hidden" name="mrkItmStngList[${st.index}].mrkItmTycd" value="${item.mrkItmTycd}"/>
                                                            <input type="hidden" id="mrkItmUseyn${st.index}" name="mrkItmStngList[${st.index}].mrkItmUseyn" value="${empty item.mrkItmUseyn ? 'N' : item.mrkItmUseyn}"/>
                                                            <input type="number"
                                                                   class="form-control width-100per item-rate tr"
                                                                   name="mrkItmStngList[${st.index}].mrkRfltrt"
                                                                   value="${item.mrkRfltrt}"
                                                                   data-index="${st.index}"
                                                                   min="0"
                                                                   max="100"
                                                                   step="0.01"/>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:forEach>
                                            <c:if test="${hasExamItem ne 'Y'}">
                                                <td class="text-center border-left-1">-</td>
                                            </c:if>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="text-center">성적공개여부</th>
                                            <c:forEach var="item" items="${mrkItmStngList}" varStatus="st">
                                                <td class="border-left-1">
                                                    <c:choose>
                                                        <c:when test="${readOnly}">
                                                            <c:choose>
                                                                <c:when test="${item.mrkItmUseyn ne 'Y'}">-</c:when>
                                                                <c:when test="${item.mrkOyn eq 'N'}"><span class="fcRed">비공개</span></c:when>
                                                                <c:otherwise>공개</c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="form-row justify-content-center">
                                                            <input type="hidden"
                                                                   id="mrkOyn${st.index}"
                                                                   name="mrkItmStngList[${st.index}].mrkOyn"
                                                                   value="${item.mrkOyn eq 'N' ? 'N' : 'Y'}"/>
                                                            <input type="checkbox"
                                                                   class="switch yesno item-open-toggle"
                                                                   value="Y"
                                                                   data-index="${st.index}"
                                                                   <c:if test="${item.mrkOyn ne 'N'}">checked="checked"</c:if>/>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:forEach>
                                            <c:if test="${hasExamItem ne 'Y'}">
                                                <td class="text-center border-left-1">-</td>
                                            </c:if>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                            <div class="btns">
                                <c:choose>
                                    <c:when test="${readOnly}">
                                        <button type="button" class="btn type1" onclick="fn_modify();">수정</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn type1" onclick="fn_save();">저장</button>
                                    </c:otherwise>
                                </c:choose>
                                <button type="button" class="btn type2" onclick="fn_list();">목록</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
