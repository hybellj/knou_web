<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table,fileuploader"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let msgId = '${fn:escapeXml(msgId)}';
    let replyMsgShrtntSndngId = '${fn:escapeXml(replyMsgShrtntSndngId)}';
    let isEditMode = (msgId !== '' && msgId !== 'null');
    let isReplyMode = (replyMsgShrtntSndngId !== '' && replyMsgShrtntSndngId !== 'null');
    let rcvrList = [];
    let tmpltCurrentTab = 'INDV_MSG';
    let tmpltList = [];
    let tmpltSelected = null;
    let replySubjectInfo = null;
    let cascadeReady = false;

    /* 모달 열기 */
    function fn_openModal(modalId, url) {
        let $modal = $('#' + modalId);
        if (url) {
            $modal.find('iframe').attr('src', url);
        }
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

    /* 답장 모드: 발신자 정보를 수신자로 자동 세팅 + 운영과목 자동 세팅 */
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

                if (v.sbjctId) {
                    replySubjectInfo = {
                        sbjctYr: (v.sbjctYr || '').trim(),
                        sbjctSmstr: (v.sbjctSmstr || '').trim(),
                        orgId: (v.orgId || '').trim(),
                        deptId: (v.deptId || '').trim(),
                        sbjctId: (v.sbjctId || '').trim(),
                        sbjctnm: v.sbjctnm || '',
                        deptnm: v.deptnm || ''
                    };
                    fn_waitAndApplyReplySubject();
                }
            }
        });
    }

    /* 답장 모드: cascade 완료 대기 후 운영과목 일괄 세팅 */
    function fn_waitAndApplyReplySubject() {
        if (!replySubjectInfo) return;
        let retryCount = 0;
        let maxRetry = 20;

        let timer = setInterval(function() {
            retryCount++;
            if (cascadeReady) {
                clearInterval(timer);
                fn_forceSetReplySubject();
            } else if (retryCount >= maxRetry) {
                clearInterval(timer);
                fn_forceSetReplySubject();
            }
        }, 200);
    }

    /* 답장 모드: 운영과목 강제 세팅 (cascade 무관하게 한 번에 적용) */
    function fn_forceSetReplySubject() {
        if (!replySubjectInfo) return;
        let info = replySubjectInfo;
        replySubjectInfo = null;

        if (info.sbjctYr && $('#sbjctYr option[value="' + info.sbjctYr + '"]').length > 0) {
            $('#sbjctYr').val(info.sbjctYr);
            fn_refreshChosen('#sbjctYr');
        }
        if (info.sbjctSmstr && $('#sbjctSmstr option[value="' + info.sbjctSmstr + '"]').length > 0) {
            $('#sbjctSmstr').val(info.sbjctSmstr);
            fn_refreshChosen('#sbjctSmstr');
        }
        if (info.orgId && $('#orgId option[value="' + info.orgId + '"]').length > 0) {
            $('#orgId').val(info.orgId);
            fn_refreshChosen('#orgId');
        }
        if (info.deptId) {
            if ($('#deptId option[value="' + info.deptId + '"]').length === 0) {
                $('#deptId').append('<option value="' + UiComm.escapeHtml(info.deptId) + '">' + UiComm.escapeHtml(info.deptnm) + '</option>');
            }
            $('#deptId').val(info.deptId);
            fn_refreshChosen('#deptId');
        }
        if (info.sbjctId) {
            if ($('#sbjctId option[value="' + info.sbjctId + '"]').length === 0) {
                $('#sbjctId').append('<option value="' + UiComm.escapeHtml(info.sbjctId) + '">' + UiComm.escapeHtml(info.sbjctnm) + '</option>');
            }
            $('#sbjctId').val(info.sbjctId);
            fn_refreshChosen('#sbjctId');
        }
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
                    html += '<option value="' + v.deptId + '">' + UiComm.escapeHtml(v.deptnm) + '</option>';
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
                    html += '<option value="' + v.sbjctId + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>';
                });
                $('#sbjctId').html(html);
                fn_refreshChosen('#sbjctId');
                cascadeReady = true;
            }
        }, function() {
            cascadeReady = true;
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
        tmpltCurrentTab = 'INDV_MSG';
        tmpltSelected = null;
        fn_tmpltClearPreview();
        $('#tmpltPopSearch').val('');
        $('[data-tmplt-tab]').removeClass('current');
        $('[data-tmplt-tab="INDV_MSG"]').addClass('current');

        fn_openModal('tmpltModal');
        fn_tmpltLoadList();
    }

    /* 템플릿에 저장 팝업 */
    function fn_openTmpltSavePopup() {
        fn_openModal('tmpltSaveModal', '/msgShrtntTmpltSavePopupView.do?ttl=' + encodeURIComponent($('#ttl').val() || '') + '&txtCts=' + encodeURIComponent($('#txtCts').val() || ''));
    }

    /* 템플릿 적용 콜백 */
    function fn_applyTemplate(ttl, cts) {
        $('#ttl').val(ttl || '');
        $('#txtCts').val(cts || '');
        fn_closeModal('tmpltModal');
    }

    /*****************************************************
     * 메시지 불러오기 팝업 내부 함수
     *****************************************************/

    /* 템플릿 팝업 - 탭 변경 */
    function fn_tmpltChangeTab(tabCd) {
        tmpltCurrentTab = tabCd;
        $('#tmpltPopSearch').val('');
        tmpltSelected = null;
        fn_tmpltClearPreview();
        $('[data-tmplt-tab]').removeClass('current');
        $('[data-tmplt-tab="' + tabCd + '"]').addClass('current');
        fn_tmpltLoadList();
    }

    /* 템플릿 팝업 - 목록 조회 */
    function fn_tmpltLoadList() {
        let param = {
            pageIndex: 1,
            listScale: 100,
            msgCtsGbncd: tmpltCurrentTab,
            searchText: $('#tmpltPopSearch').val()
        };
        ajaxCall('/msgTmpltListAjax.do', param, function(res) {
            if (res.result > 0) {
                tmpltList = res.returnList || [];
                fn_tmpltRenderCards();
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 템플릿 팝업 - 카드 렌더링 */
    function fn_tmpltRenderCards() {
        let html = '';
        if (tmpltList.length === 0) {
            html = '<div style="text-align:center; padding:40px; color:#999;"><spring:message code="common.content.not_found"/></div>';
        } else {
            html = '<ul class="message_card">';
            tmpltList.forEach(function(v, i) {
                let activeClass = (tmpltSelected && tmpltSelected.msgTmpltId === v.msgTmpltId) ? ' active' : '';
                html += '<li>';
                html += '<a href="#0" class="card_item' + activeClass + '" onclick="fn_tmpltSelectCard(' + i + '); return false;">';
                html += '<div class="item_header">';
                html += '<span class="custom-input onlychk"><input type="checkbox" name="tmpltChk" id="tmpltChk' + i + '" value="' + v.msgTmpltId + '" onclick="event.stopPropagation()"><label for="tmpltChk' + i + '"></label></span>';
                html += '<div class="msg_tit">' + UiComm.escapeHtml(v.msgTmpltTtl || '') + '</div>';
                html += '</div>';
                html += '<div class="extra"><p class="desc">' + UiComm.escapeHtml(v.msgTmpltCts || '') + '</p></div>';
                html += '</a>';
                html += '</li>';
            });
            html += '</ul>';
        }
        $('#tmpltCardWrap').html(html);
    }

    /* 템플릿 팝업 - 카드 선택 */
    function fn_tmpltSelectCard(idx) {
        tmpltSelected = tmpltList[idx];
        $('#tmpltCardWrap .card_item').removeClass('active');
        $('#tmpltCardWrap .card_item').eq(idx).addClass('active');
        $('#tmpltEditTtl').val(tmpltSelected.msgTmpltTtl || '');
        $('#tmpltEditCts').val(tmpltSelected.msgTmpltCts || '');
    }

    /* 템플릿 팝업 - 편집 필드 초기화 */
    function fn_tmpltClearPreview() {
        $('#tmpltEditTtl').val('');
        $('#tmpltEditCts').val('');
    }

    /* 템플릿 팝업 - 사용하기 */
    function fn_tmpltApply() {
        let ttl = $('#tmpltEditTtl').val().trim();
        let cts = $('#tmpltEditCts').val().trim();
        if (!ttl && !cts) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }
        fn_applyTemplate(ttl, cts);
    }

    /* 템플릿 팝업 - 전체선택 */
    function fn_tmpltSelectAll() {
        let allChecked = $('input[name=tmpltChk]').length === $('input[name=tmpltChk]:checked').length;
        $('input[name=tmpltChk]').prop('checked', !allChecked);
    }

    /* 템플릿 팝업 - 선택 삭제 */
    function fn_tmpltDeleteSelected() {
        let checked = $('input[name=tmpltChk]:checked');
        if (checked.length === 0) {
            alert('<spring:message code="common.item.select.msg"/>');
            return;
        }
        if (!confirm('<spring:message code="msg.shrtnt.msg.confirmDelete"/>')) return;
        let ids = [];
        checked.each(function() { ids.push($(this).val()); });
        ajaxCall('/msgTmpltDeleteAjax.do', { msgTmpltIds: ids.join(',') }, function(res) {
            if (res.result > 0) {
                alert('<spring:message code="msg.shrtnt.msg.deleteSuccess"/>');
                tmpltSelected = null;
                fn_tmpltClearPreview();
                fn_tmpltLoadList();
            } else {
                alert(res.message || '<spring:message code="fail.common.delete"/>');
            }
        });
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
        location.href = '/mngrMsgShrtntListView.do?tab=SNDNG';
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <!-- admin -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">

                <div class="sub-content">
                    <!-- page info -->
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="msg.shrtnt.label.title" text="쪽지"/></h2>
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
                                <input type="text" id="sndngnm" name="sndngnm" class="form-control" style="width:200px; display:inline-block;" value="${fn:escapeXml(usernm)}" disabled>
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

    </main>
    <!-- //admin -->
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
            <!-- tab -->
            <div class="board_top">
                <h3 class="board-title"><spring:message code="msg.shrtnt.label.indvMsg" text="개인 문구"/></h3>
                <div class="right-area">
                    <div class="tab_btn">
                        <a href="#0" class="current" data-tmplt-tab="INDV_MSG" onclick="fn_tmpltChangeTab('INDV_MSG'); return false;"><spring:message code="msg.shrtnt.label.indvMsg" text="개인 문구"/></a>
                        <a href="#0" data-tmplt-tab="ORG_MSG" onclick="fn_tmpltChangeTab('ORG_MSG'); return false;"><spring:message code="msg.shrtnt.label.deptMsg" text="학과/부서 문구"/></a>
                    </div>
                </div>
            </div>

            <!-- 선택된 템플릿 편집 영역 -->
            <div class="table-wrap">
                <table class="table-type5">
                    <colgroup>
                        <col class="width-15per" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th><label for="tmpltEditTtl"><spring:message code="msg.shrtnt.label.ttl" text="제목"/></label></th>
                            <td>
                                <div class="form-row">
                                    <input class="form-control width-100per" type="text" id="tmpltEditTtl" placeholder="<spring:message code="msg.shrtnt.label.tmpltTtlPlaceholder" text="제목 입력"/>">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><label for="tmpltEditCts"><spring:message code="msg.shrtnt.label.cts" text="내용"/></label></th>
                            <td>
                                <label class="width-100per"><textarea rows="4" class="form-control resize-none" id="tmpltEditCts"></textarea></label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal_btns mt10">
                <button type="button" class="btn type1" onclick="fn_tmpltApply()"><spring:message code="msg.shrtnt.label.useMsg" text="사용하기"/></button>
            </div>

            <!-- 문구 목록 -->
            <div class="board_top">
                <h4 class="sub-title"><spring:message code="msg.shrtnt.label.tmpltListTitle" text="문구 목록"/></h4>
                <div class="right-area">
                    <div class="search-typeC">
                        <input class="form-control" type="text" id="tmpltPopSearch" value="" placeholder="<spring:message code="msg.tmplt.label.searchPlaceholder" text="제목/내용 검색"/>" onkeydown="if(event.keyCode===13) fn_tmpltLoadList()">
                        <button type="button" class="btn basic icon search" aria-label="<spring:message code="msg.shrtnt.label.rcvrSearch" text="검색"/>" onclick="fn_tmpltLoadList()"><i class="icon-svg-search"></i></button>
                    </div>
                    <button type="button" class="btn basic" onclick="fn_tmpltSelectAll()"><spring:message code="msg.shrtnt.label.selectAll" text="전체선택"/></button>
                    <button type="button" class="btn basic" onclick="fn_tmpltDeleteSelected()"><spring:message code="msg.shrtnt.label.delete" text="삭제"/></button>
                </div>
            </div>

            <!-- 카드 목록 -->
            <div id="tmpltCardWrap" class="message_list" style="max-height:300px; overflow-y:auto;"></div>

            <!-- 하단 버튼 -->
            <div class="modal_btns">
                <button type="button" class="btn type2" onclick="fn_closeModal('tmpltModal')"><spring:message code="msg.shrtnt.label.closeBtn" text="닫기"/></button>
            </div>
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
