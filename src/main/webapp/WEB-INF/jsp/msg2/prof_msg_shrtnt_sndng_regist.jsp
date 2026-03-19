<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table,fileuploader"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let msgId = '${msgId}';
    let replyMsgShrtntSndngId = '${replyMsgShrtntSndngId}';
    let isEditMode = (msgId !== '' && msgId !== 'null');
    let isReplyMode = (replyMsgShrtntSndngId !== '' && replyMsgShrtntSndngId !== 'null');
    let rcvrList = [];

    /* 모달 열기 */
    function fn_openModal(modalId, url) {
        let $modal = $('#' + modalId);
        $modal.find('iframe').attr('src', url);
        $modal.addClass('active').attr('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }

    /* 모달 닫기 */
    function fn_closeModal(modalId) {
        let $modal = $('#' + modalId);
        $modal.removeClass('active').attr('aria-hidden', 'true');
        $modal.find('iframe').attr('src', 'about:blank');
        document.body.style.overflow = '';
    }

    /* 팝업 호환 객체 (parent.xxxDlg.close() 지원) */
    window.rcvrDlg = { close: function() { fn_closeModal('rcvrModal'); } };
    window.tmpltDlg = { close: function() { fn_closeModal('tmpltModal'); } };
    window.tmpltSaveDlg = { close: function() { fn_closeModal('tmpltSaveModal'); } };

    $(document).ready(function() {
        fn_initYrSmstr();
        fn_initRsrvSndng();
        fn_initSndngnm();

        if (isEditMode) {
            fn_loadDetail();
            fn_loadRcvrTrgtrList();
        }
        if (isReplyMode) {
            fn_loadReplyInfo();
        }

        /* 모달 오버레이 클릭 닫기 */
        $('.modal-overlay').on('click', function(e) {
            if ($(e.target).hasClass('modal-overlay')) {
                fn_closeModal(this.id);
            }
        });

        /* ESC 키 닫기 */
        $(document).on('keydown', function(e) {
            if (e.key === 'Escape') {
                $('.modal-overlay.active').each(function() {
                    fn_closeModal(this.id);
                });
            }
        });
    });

    /* 답장 모드: 발신자 정보를 수신자로 자동 세팅 */
    function fn_loadReplyInfo() {
        ajaxCall('/msgShrtntRcvnDetailAjax.do', { msgShrtntSndngId: replyMsgShrtntSndngId }, function(res) {
            if (res.result > 0 && res.returnVO) {
                let v = res.returnVO;
                fn_addRcvrToList({
                    userId: v.sndngrId,
                    usernm: v.sndngnm || '',
                    stdntNo: v.stdntNo || '',
                    rprsId: v.userRprsId2 || '',
                    mblPhn: v.sndngrPhnno || '',
                    eml: ''
                });
            }
        });
    }

    /* Chosen 셀렉트박스 갱신 */
    function fn_refreshChosen(selector) {
        let $el = $(selector);
        if ($el.data('chosen')) {
            $el.chosen('destroy');
        }
        $el.chosen({disable_search: true});
    }

    /* 학사년도/학기 초기화 */
    function fn_initYrSmstr() {
        fn_loadOrgList();

        ajaxCall('/msgShrtntYrListAjax.do', {}, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.sbjctYr + '">' + v.sbjctYr + '<spring:message code="msg.rcptnAgre.label.year" text="년"/></option>';
                });
                $('#sbjctYr').html(html);
                fn_refreshChosen('#sbjctYr');
                fn_loadSmstrList();
            }
        });

        $('#sbjctYr').on('change', function() { fn_loadSmstrList(); });
        $('#sbjctSmstr').on('change', function() { fn_loadDeptList(); });
        $('#orgId').on('change', function() { fn_loadDeptList(); });
        $('#deptId').on('change', function() { fn_loadSbjctList(); });
    }

    /* 학기 목록 */
    function fn_loadSmstrList() {
        let yr = $('#sbjctYr').val();
        if (!yr) return;

        ajaxCall('/msgShrtntSmstrListAjax.do', { dgrsYr: yr }, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.sbjctSmstr + '">' + v.sbjctSmstr + '<spring:message code="msg.rcptnAgre.label.smstr" text="학기"/></option>';
                });
                $('#sbjctSmstr').html(html);
                fn_refreshChosen('#sbjctSmstr');
                fn_loadDeptList();
            }
        });
    }

    /* 기관 목록 */
    function fn_loadOrgList() {
        ajaxCall('/msgShrtntOrgListAjax.do', {}, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.sndrDsctn.label.orgAll" text="기관 전체"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.orgId + '">' + UiComm.escapeHtml(v.orgnm) + '</option>';
                });
                $('#orgId').html(html);
                fn_refreshChosen('#orgId');
            }
        });
    }

    /* 학과 목록 */
    function fn_loadDeptList() {
        let yr = $('#sbjctYr').val();
        let smstr = $('#sbjctSmstr').val();
        if (!yr || !smstr) return;

        ajaxCall('/msgShrtntDeptListAjax.do', { orgId: $('#orgId').val(), dgrsYr: yr, smstr: smstr }, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.deptId + '">' + v.deptnm + '</option>';
                });
                $('#deptId').find('option:gt(0)').remove();
                $('#deptId').append(html);
                fn_refreshChosen('#deptId');
                fn_loadSbjctList();
            }
        });
    }

    /* 과목 목록 */
    function fn_loadSbjctList() {
        let yr = $('#sbjctYr').val();
        let smstr = $('#sbjctSmstr').val();
        let deptId = $('#deptId').val();

        ajaxCall('/msgShrtntSbjctListAjax.do', { orgId: $('#orgId').val(), dgrsYr: yr, smstr: smstr, deptId: deptId }, function(res) {
            if (res.result > 0 && res.returnList) {
                let html = '<option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>';
                res.returnList.forEach(function(v) {
                    html += '<option value="' + v.sbjctId + '">' + v.sbjctnm + '</option>';
                });
                $('#sbjctId').html(html);
                fn_refreshChosen('#sbjctId');
            }
        });
    }

    /* 발신자 이름 체크박스 */
    function fn_initSndngnm() {
        let ownName = $('#sndngnm').val();

        $('#ownNameYnChk').on('change', function() {
            if ($(this).is(':checked')) {
                $('#sndngnm').val(ownName).prop('disabled', true);
            } else {
                $('#sndngnm').prop('disabled', false).focus();
            }
        });
    }

    /* 예약 발신 체크박스 */
    function fn_initRsrvSndng() {
        $('#rsrvYnChk').on('change', function() {
            if ($(this).is(':checked')) {
                $('#rsrvSndngDate, #rsrvSndngTime').prop('disabled', false);
                $('#rsrvDateArea').show();
            } else {
                $('#rsrvSndngDate, #rsrvSndngTime').val('').prop('disabled', true);
                $('#rsrvDateArea').hide();
            }
        });
    }

    /* 수정 시 상세 조회 */
    function fn_loadDetail() {
        ajaxCall('/msgShrtntSndngDetailAjax.do', { msgId: msgId }, function(res) {
            if (res.result > 0 && res.returnVO) {
                let v = res.returnVO;
                $('#ttl').val(v.ttl || '');
                $('#txtCts').val(v.txtCts || '');

                if (v.rsrvYn === 'Y' && v.rsrvSndngSdttm) {
                    $('#rsrvYnChk').prop('checked', true).trigger('change');
                    let dttm = v.rsrvSndngSdttm;
                    if (dttm.length >= 8) {
                        $('#rsrvSndngDate').val(dttm.substring(0,4) + '-' + dttm.substring(4,6) + '-' + dttm.substring(6,8));
                    }
                    if (dttm.length >= 12) {
                        $('#rsrvSndngTime').val(dttm.substring(8,10) + ':' + dttm.substring(10,12));
                    }
                }
            }
        });
    }

    /* 수정 시 수신대상자 목록 조회 */
    function fn_loadRcvrTrgtrList() {
        ajaxCall('/msgShrtntRcvTrgtrListAjax.do', { msgId: msgId }, function(res) {
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    fn_addRcvrToList({
                        userId: v.rcvrId, usernm: v.rcvrnm, stdntNo: v.stdntNo || '',
                        rprsId: v.rprsId || '', mblPhn: v.mblPhn || '', eml: v.eml || ''
                    });
                });
            }
        });
    }

    /* 받는 사람 추가 팝업 */
    function fn_openRcvrPopup() {
        fn_openModal('rcvrModal', '/msgShrtntRcvrPopupView.do');
    }

    /* 팝업에서 호출: 선택한 수신자 추가 */
    function fn_addSelectedRcvrs(selectedList) {
        if (!selectedList || selectedList.length === 0) return;
        selectedList.forEach(function(rcvr) { fn_addRcvrToList(rcvr); });
        if (rcvrDlg) rcvrDlg.close();
    }

    /* 메시지 불러오기 팝업 */
    function fn_openTmpltPopup() {
        fn_openModal('tmpltModal', '/msgShrtntTmpltPopupView.do');
    }

    /* 템플릿에 저장 팝업 */
    function fn_openTmpltSavePopup() {
        fn_openModal('tmpltSaveModal', '/msgShrtntTmpltSavePopupView.do?ttl=' + encodeURIComponent($('#ttl').val() || '') + '&txtCts=' + encodeURIComponent($('#txtCts').val() || ''));
    }

    /* 템플릿 적용 콜백 */
    function fn_applyTemplate(ttl, cts) {
        $('#ttl').val(ttl || '');
        $('#txtCts').val(cts || '');
        if (tmpltDlg) tmpltDlg.close();
    }

    /* 수신자 목록에 추가 */
    function fn_addRcvrToList(rcvr) {
        let exists = rcvrList.some(function(r) { return r.userId === rcvr.userId; });
        if (exists) return;
        rcvrList.push(rcvr);
        fn_renderRcvrList();
    }

    /* 수신자 선택 삭제 */
    function fn_removeSelectedRcvr() {
        let checked = $('input[name=rcvrChk]:checked');
        if (checked.length === 0) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }
        checked.each(function() {
            let userId = $(this).val();
            rcvrList = rcvrList.filter(function(r) { return r.userId !== userId; });
        });
        fn_renderRcvrList();
    }

    /* 수신자 목록 렌더링 */
    function fn_renderRcvrList() {
        let html = '';
        let colCnt = 9;
        if (rcvrList.length === 0) {
            html = '<tr><td colspan="' + colCnt + '" class="txt-center"><spring:message code="common.content.not_found"/></td></tr>';
        } else {
            rcvrList.forEach(function(rcvr, i) {
                html += '<tr>';
                html += '<td class="txt-center"><span class="custom-input"><input type="checkbox" name="rcvrChk" id="rcvrChk' + i + '" value="' + UiComm.escapeHtml(rcvr.userId) + '"><label for="rcvrChk' + i + '">&nbsp;</label></span></td>';
                html += '<td class="txt-center">' + (i + 1) + '</td>';
                html += '<td class="txt-center">' + UiComm.escapeHtml(rcvr.usernm || '') + '</td>';
                html += '<td class="txt-center">' + UiComm.escapeHtml(rcvr.stdntNo || '') + '</td>';
                html += '<td class="txt-center">' + UiComm.escapeHtml(rcvr.rprsId || '') + '</td>';
                html += '<td class="txt-center">' + UiComm.escapeHtml(rcvr.mblPhn || '') + '</td>';
                html += '<td class="txt-center">' + UiComm.escapeHtml(rcvr.eml || '') + '</td>';
                html += '<td class="txt-center">-</td>';
                html += '<td class="txt-center">-</td>';
                html += '</tr>';
            });
        }
        $('#rcvrTbody').html(html);
        $('#rcvrCnt').text(rcvrList.length);
    }

    /* TODO: 엑셀 양식 확정 후 주석 해제
    function fn_excelTmpltDown() {
        location.href = '/downExcelMsgShrtntRcvrTmplt.do';
    }

    function fn_excelUpload() {
        $('#excelFile').click();
    }

    function fn_excelFileChange() {
        let fileInput = document.getElementById('excelFile');
        if (!fileInput.files || fileInput.files.length === 0) return;

        let formData = new FormData();
        formData.append('excelFile', fileInput.files[0]);

        $.ajax({
            url: '/msgShrtntRcvrExcelUploadAjax.do',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function(res) {
                if (res.result > 0 && res.returnList) {
                    res.returnList.forEach(function(rcvr) { fn_addRcvrToList(rcvr); });
                } else {
                    alert(res.message || '<spring:message code="fail.common.select"/>');
                }
            },
            error: function() {
                alert('<spring:message code="fail.common.select"/>');
            }
        });
        fileInput.value = '';
    }
    */

    /* 검증 */
    function fn_validate() {
        if (!$('#sbjctId').val()) {
            alert('<spring:message code="msg.shrtnt.msg.requiredSbjct"/>');
            $('#sbjctId').focus();
            return false;
        }
        if (rcvrList.length === 0) {
            alert('<spring:message code="msg.shrtnt.msg.requiredRcvr"/>');
            return false;
        }
        if (!$('#ttl').val().trim()) {
            alert('<spring:message code="msg.shrtnt.msg.requiredTtl"/>');
            $('#ttl').focus();
            return false;
        }
        if (!$('#txtCts').val().trim()) {
            alert('<spring:message code="msg.shrtnt.msg.requiredCts"/>');
            $('#txtCts').focus();
            return false;
        }
        if ($('#rsrvYnChk').is(':checked')) {
            if (!$('#rsrvSndngDate').val()) {
                alert('<spring:message code="msg.shrtnt.msg.requiredRsrvDate" text="예약 발신 날짜를 입력하세요."/>');
                $('#rsrvSndngDate').focus();
                return false;
            }
            if (!$('#rsrvSndngTime').val()) {
                alert('<spring:message code="msg.shrtnt.msg.requiredRsrvTime" text="예약 발신 시간을 입력하세요."/>');
                $('#rsrvSndngTime').focus();
                return false;
            }
        }
        return true;
    }

    /* 발신/수정 */
    function fn_save() {
        if (!fn_validate()) return;

        let confirmMsg = isEditMode ? '<spring:message code="msg.shrtnt.msg.confirmModify"/>' : '<spring:message code="msg.shrtnt.msg.confirmRegist"/>';
        if (!confirm(confirmMsg)) return;

        let dx = dx5.get("msgAtfl");
        if (dx.availUpload()) {
            dx.startUpload();
        } else {
            fn_doSave();
        }
    }

    /* 파일 업로드 완료 콜백 */
    function fn_finishUpload() {
        let dx = dx5.get("msgAtfl");
        let data = {
            "uploadFiles": dx.getUploadFiles(),
            "uploadPath": dx.getUploadPath()
        };

        ajaxCall('/common/uploadFileCheck.do', data, function(res) {
            if (res.result > 0) {
                $('#uploadFiles').val(dx.getUploadFiles());
                fn_doSave();
            } else {
                alert('<spring:message code="fail.common.msg"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.msg"/>');
        });
    }

    /* 실제 저장 처리 */
    function fn_doSave() {
        let dx = dx5.get("msgAtfl");
        $('#delFileIdStr').val(dx.getDelFileIdStr());

        let rsrvSndngSdttm = '';
        if ($('#rsrvYnChk').is(':checked')) {
            rsrvSndngSdttm = UiComm.getDateTimeVal('rsrvSndngDate', 'rsrvSndngTime') + '00';
        }

        let param = {
            msgId: msgId,
            ttl: $('#ttl').val(),
            txtCts: $('#txtCts').val(),
            rsrvSndngSdttm: rsrvSndngSdttm,
            sbjctYr: $('#sbjctYr').val(),
            sbjctSmstr: $('#sbjctSmstr').val(),
            sbjctId: $('#sbjctId').val(),
            sndngnm: $('#sndngnm').val(),
            rcvrListJson: JSON.stringify(rcvrList),
            upMsgShrtntSndngId: isReplyMode ? replyMsgShrtntSndngId : '',
            uploadFiles: $('#uploadFiles').val(),
            uploadPath: $('#uploadPath').val(),
            delFileIdStr: $('#delFileIdStr').val()
        };

        let url = isEditMode ? '/msgShrtntSndngModifyAjax.do' : '/msgShrtntSndngRegistAjax.do';
        let successMsg = isEditMode ? '<spring:message code="msg.shrtnt.msg.modifySuccess"/>' : '<spring:message code="msg.shrtnt.msg.registSuccess"/>';

        ajaxCall(url, param, function(res) {
            if (res.result > 0) {
                alert(successMsg);
                fn_list();
            } else {
                alert(res.message || '<spring:message code="fail.common.insert"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.insert"/>');
        }, true);
    }

    /* 목록으로 */
    function fn_list() {
        location.href = '/profMsgShrtntListView.do?tab=SNDNG';
    }
</script>

<body class="home colorA ${bodyClass}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span><spring:message code="msg.shrtnt.label.msgBox" text="메시지함"/></span><spring:message code="msg.shrtnt.label.title" text="쪽지"/></h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><spring:message code="msg.shrtnt.label.msgBox" text="메시지함"/></li>
                                    <li><spring:message code="msg.shrtnt.label.title" text="쪽지"/></li>
                                    <li><span class="current"><spring:message code="msg.shrtnt.label.sndngRegist" text="발신하기"/></span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- 상단 버튼 -->
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="msg.shrtnt.label.sndngRegist" text="쪽지 발신하기"/></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_openTmpltPopup()"><spring:message code="msg.shrtnt.label.tmpltLoad" text="메시지 불러오기"/> ▼</button>
                                <button type="button" class="btn basic" onclick="fn_openTmpltSavePopup()"><spring:message code="msg.shrtnt.label.tmpltSave" text="템플릿에 저장"/> ▼</button>
                                <c:choose>
                                    <c:when test="${not empty msgId}">
                                        <button type="button" class="btn type1" onclick="fn_save()"><spring:message code="msg.shrtnt.label.modify" text="수정"/></button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn type1" onclick="fn_save()"><spring:message code="msg.shrtnt.label.sndng" text="발신"/></button>
                                    </c:otherwise>
                                </c:choose>
                                <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.shrtnt.label.sndngList" text="발신목록"/></button>
                            </div>
                        </div>

                        <!-- 폼 -->
                        <div class="table_list">
                            <!-- 학사년도/학기 -->
                            <ul class="list">
                                <li class="head"><label class="req"><spring:message code="msg.shrtnt.label.yearSmstr" text="학사년도/학기"/></label></li>
                                <li>
                                    <select id="sbjctYr" name="sbjctYr" class="form-control" style="width:120px; display:inline-block;"></select>
                                    <select id="sbjctSmstr" name="sbjctSmstr" class="form-control" style="width:120px; display:inline-block;"></select>
                                </li>
                            </ul>
                            <!-- 운영과목 -->
                            <ul class="list">
                                <li class="head"><label class="req"><spring:message code="msg.shrtnt.label.oprSbjct" text="운영과목"/></label></li>
                                <li>
                                    <select id="orgId" name="orgId" class="form-control" style="width:160px; display:inline-block;">
                                    </select>
                                    <select id="deptId" name="deptId" class="form-control" style="width:160px; display:inline-block;">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.deptAll" text="학과 전체"/></option>
                                    </select>
                                    <select id="sbjctId" name="sbjctId" class="form-control" style="width:200px; display:inline-block;">
                                        <option value=""><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                    </select>
                                </li>
                            </ul>
                            <!-- 제목 -->
                            <ul class="list">
                                <li class="head"><label for="ttl" class="req"><spring:message code="msg.shrtnt.label.ttl" text="제목"/></label></li>
                                <li>
                                    <input type="text" id="ttl" name="ttl" class="form-control width-100per" placeholder="<spring:message code="msg.shrtnt.label.ttl"/>" inputmask="length" maxLen="200">
                                </li>
                            </ul>
                            <!-- 내용 -->
                            <ul class="list">
                                <li class="head"><label for="txtCts" class="req"><spring:message code="msg.shrtnt.label.cts" text="내용"/></label></li>
                                <li>
                                    <textarea id="txtCts" name="txtCts" class="form-control width-100per" rows="10" style="width:100%; resize:vertical;" maxLenCheck="byte,2000,true,true"></textarea>
                                </li>
                            </ul>
                            <!-- 첨부파일 -->
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.atfl" text="첨부파일"/></label></li>
                                <li>
                                    <input type="hidden" name="uploadFiles" id="uploadFiles" value="" />
                                    <input type="hidden" name="uploadPath" id="uploadPath" value="${uploadPath}" />
                                    <input type="hidden" name="delFileIdStr" id="delFileIdStr" value="" />
                                    <uiex:dextuploader
                                        id="msgAtfl"
                                        path="${uploadPath}"
                                        limitCount="5"
                                        limitSize="100"
                                        oneLimitSize="100"
                                        listSize="3"
                                        fileList="${fileList}"
                                        finishFunc="fn_finishUpload()"
                                        allowedTypes="*"
                                    />
                                </li>
                            </ul>
                            <!-- 발신일시 -->
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.sndngDttm" text="발신일시"/></label></li>
                                <li>
                                    <input type="text" id="rsrvSndngDate" name="rsrvSndngDate" class="datepicker" placeholder="<spring:message code="msg.shrtnt.label.sndngDate" text="날짜"/>" disabled>
                                    <input type="text" id="rsrvSndngTime" name="rsrvSndngTime" class="timepicker" placeholder="<spring:message code="msg.shrtnt.label.sndngTime" text="시간"/>" disabled>
                                    <span class="custom-input" style="margin-left:10px;">
                                        <input type="checkbox" id="rsrvYnChk" name="rsrvYnChk">
                                        <label for="rsrvYnChk"><spring:message code="msg.shrtnt.label.rsrvSndng" text="예약 발신"/></label>
                                    </span>
                                    <span id="rsrvDateArea" style="display:none;"></span>
                                </li>
                            </ul>
                            <!-- 발신자 -->
                            <ul class="list">
                                <li class="head"><label class="req"><spring:message code="msg.shrtnt.label.sndngnm" text="발신자"/></label></li>
                                <li>
                                    <input type="text" id="sndngnm" name="sndngnm" class="form-control" style="width:200px; display:inline-block;" value="${usernm}" disabled>
                                    <span class="custom-input" style="margin-left:10px;">
                                        <input type="checkbox" id="ownNameYnChk" name="ownNameYnChk" checked>
                                        <label for="ownNameYnChk"><spring:message code="msg.shrtnt.label.ownNameYn" text="본인 이름 선택"/></label>
                                    </span>
                                </li>
                            </ul>
                        </div>

                        <!-- 받는 사람 -->
                        <div class="board_top" style="margin-top:30px;">
                            <h3 class="board-title"><spring:message code="msg.shrtnt.label.rcvrList" text="받는 사람"/> [ <spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b id="rcvrCnt">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]</h3>
                            <div class="right-area">
                                <!-- TODO: 엑셀 양식 확정 후 주석 해제
                                <button type="button" class="btn basic" onclick="fn_excelTmpltDown()"><spring:message code="msg.shrtnt.label.excelTmpltDown" text="엑셀양식 다운로드"/></button>
                                <button type="button" class="btn basic" onclick="fn_excelUpload()"><spring:message code="msg.shrtnt.label.excelUpload" text="엑셀 업로드"/></button>
                                <input type="file" id="excelFile" accept=".xlsx,.xls" style="display:none;" onchange="fn_excelFileChange()">
                                -->
                                <button type="button" class="btn type1" onclick="fn_openRcvrPopup()">+ <spring:message code="msg.shrtnt.label.add" text="추가"/></button>
                                <button type="button" class="btn type2" onclick="fn_removeSelectedRcvr()">- <spring:message code="msg.shrtnt.label.delete" text="삭제"/></button>
                            </div>
                        </div>

                        <div class="table-wrap" style="max-height:400px; overflow-y:auto;">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:40px">
                                    <col style="width:50px">
                                    <col style="width:80px">
                                    <col style="width:90px">
                                    <col style="width:90px">
                                    <col style="width:120px">
                                    <col>
                                    <col style="width:60px">
                                    <col style="width:100px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th><span class="custom-input"><input type="checkbox" id="rcvrChkAll" onclick="$('input[name=rcvrChk]').prop('checked', this.checked)"><label for="rcvrChkAll">&nbsp;</label></span></th>
                                        <th><spring:message code="msg.shrtnt.col.no" text="No"/></th>
                                        <th><spring:message code="msg.shrtnt.col.rcvrnm" text="수신자"/></th>
                                        <th><spring:message code="msg.shrtnt.col.stdntNo" text="학번"/></th>
                                        <th><spring:message code="msg.shrtnt.col.rprsId" text="대표ID"/></th>
                                        <th><spring:message code="msg.shrtnt.col.mblPhn" text="연락처"/></th>
                                        <th><spring:message code="msg.shrtnt.col.eml" text="이메일"/></th>
                                        <th><spring:message code="msg.shrtnt.col.sndngYn" text="발송"/></th>
                                        <th><spring:message code="msg.shrtnt.col.rsltMsg" text="결과메시지"/></th>
                                    </tr>
                                </thead>
                                <tbody id="rcvrTbody">
                                    <tr><td colspan="9" class="txt-center"><spring:message code="common.content.not_found"/></td></tr>
                                </tbody>
                            </table>
                        </div>

                    </div>

                </div>
            </div>
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>

        </main>
        <!-- //dashboard-->

    </div>

    <!-- 받는 사람 추가 모달 -->
    <div class="modal-overlay" id="rcvrModal" role="dialog" aria-modal="true" aria-hidden="true">
        <div class="modal-content modal-xl" tabindex="-1">
            <div class="modal-header">
                <h2><spring:message code="msg.shrtnt.label.addRcvrTitle" text="받는 사람 추가"/></h2>
                <button class="modal-close" aria-label="닫기" onclick="fn_closeModal('rcvrModal')"><i class="icon-svg-close"></i></button>
            </div>
            <div class="modal-body">
                <iframe src="about:blank" style="width:100%; height:500px; border:none;"></iframe>
            </div>
        </div>
    </div>

    <!-- 메시지 불러오기 모달 -->
    <div class="modal-overlay" id="tmpltModal" role="dialog" aria-modal="true" aria-hidden="true">
        <div class="modal-content modal-lg" tabindex="-1">
            <div class="modal-header">
                <h2><spring:message code="msg.shrtnt.label.tmpltLoad" text="메시지 불러오기"/></h2>
                <button class="modal-close" aria-label="닫기" onclick="fn_closeModal('tmpltModal')"><i class="icon-svg-close"></i></button>
            </div>
            <div class="modal-body">
                <iframe src="about:blank" style="width:100%; height:500px; border:none;"></iframe>
            </div>
        </div>
    </div>

    <!-- 템플릿에 저장 모달 -->
    <div class="modal-overlay" id="tmpltSaveModal" role="dialog" aria-modal="true" aria-hidden="true">
        <div class="modal-content modal-lg" tabindex="-1">
            <div class="modal-header">
                <h2><spring:message code="msg.shrtnt.label.tmpltSave" text="템플릿에 저장"/></h2>
                <button class="modal-close" aria-label="닫기" onclick="fn_closeModal('tmpltSaveModal')"><i class="icon-svg-close"></i></button>
            </div>
            <div class="modal-body">
                <iframe src="about:blank" style="width:100%; height:500px; border:none;"></iframe>
            </div>
        </div>
    </div>

</body>
</html>
