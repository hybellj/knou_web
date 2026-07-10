<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let EPARAM = '<c:out value="${encParams}" />';
    const LIST_EPARAM = EPARAM;
    let RCVR_LIST = [];

    const SMS_BYTE_LIMIT = 90;

    $(document).ready(function() {
        fn_initYrSmstr();
        fn_initRsrvSndng();
        fn_initSndngnm();
        fn_initSndngrPhnno();
        fn_initChnl();
    });

    function fn_refreshChosen(selector) {
        const $el = $(selector);
        if ($el.data('chosen')) {
            $el.chosen('destroy');
        }
        $el.chosen({disable_search: true});
    }

    function fn_initYrSmstr() {
        fn_refreshChosen('#sbjctYr');
        fn_refreshChosen('#sbjctSmstr');
        fn_refreshChosen('#orgId');
        fn_refreshChosen('#sbjctId');

        $('#sbjctYr').on('change', function() { fn_loadSmstrList(); });
        $('#orgId').on('change', function() { fn_loadSbjctList(); });

        // 신규 발신 진입 시 학사년도 현재 연도 기본 선택 + 학기 로드, 기관 선택 시 운영과목 로드
        if (!$('#sbjctYr').val()) {
            $('#sbjctYr').val(String(new Date().getFullYear())).trigger('chosen:updated');
            fn_loadSmstrList();
        }
        if ($('#orgId').val()) {
            fn_loadSbjctList();
        }
    }

    function fn_byteLength(str) {
        let bytes = 0;
        for (let i = 0; i < str.length; i++) {
            bytes += str.charCodeAt(i) > 127 ? 2 : 1;
        }
        return bytes;
    }

    function fn_initChnl() {
        $('#txtCts').on('keyup change input', function() {
            fn_refreshChnl();
        });
        fn_refreshChnl();
    }

    function fn_refreshChnl() {
        const byteLen = fn_byteLength($('#txtCts').val() || '');
        const isLms = byteLen > SMS_BYTE_LIMIT;
        const chnl = isLms ? 'LMS' : 'SMS';

        $('#mblSndngTycd').val(chnl);
        $('#chnlText').text(chnl);
        $('#byteCntText').text(byteLen);

        if (isLms) {
            $('#ttlRow').show();
            $('#ttl').prop('disabled', false);
        } else {
            $('#ttlRow').hide();
            $('#ttl').prop('disabled', true);
        }
    }

    function fn_loadSmstrList(onDone) {
        const $sel = $('#sbjctSmstr');
        const allHtml = '<option value="" selected><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>';
        const yr = $('#sbjctYr').val();

        ajaxCall('/admMsgMgrSmstrListAjax.do', { encParams: EPARAM, addParams: UiComm.makeEncParams({ sbjctYr: yr }) }, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            let html = allHtml;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    html += '<option value="' + (v.dgrsSmstrChrt || '') + '">' + UiComm.escapeHtml(v.smstrChrtnm || '') + '</option>';
                });
            }
            $sel.html(html);
            fn_refreshChosen('#sbjctSmstr');
            if (typeof onDone === 'function') onDone();
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error");
            if (typeof onDone === 'function') onDone();
        });
    }


    function fn_loadSbjctList() {
        const $sel = $('#sbjctId');
        const allHtml = '<option value="" selected><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>';
        const data = {
            orgId: $('#orgId').val()
        };

        ajaxCall('/admMsgMgrSbjctListAjax.do', { encParams: EPARAM, addParams: UiComm.makeEncParams(data) }, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            let html = allHtml;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    html += '<option value="' + (v.sbjctId || '') + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>';
                });
            }
            $sel.html(html);
            fn_refreshChosen('#sbjctId');
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        });
    }

    function fn_initSndngnm() {
        const ownName = '<c:out value="${vo.userNm}" />';
        $('#ownNameYnChk').on('change', function() {
            if ($(this).is(':checked')) {
                $('#sndngnm').val(ownName).prop('disabled', true);
            } else {
                $('#sndngnm').prop('disabled', false).focus();
            }
        });
    }

    function fn_initSndngrPhnno() {
        const ownPhnno = '<c:out value="${vo.sndngrPhnno}" />';
        $('#ownPhnnoYnChk').on('change', function() {
            if ($(this).is(':checked')) {
                $('#sndngrPhnno').val(ownPhnno).prop('disabled', true);
            } else {
                $('#sndngrPhnno').prop('disabled', false).focus();
            }
        });
    }

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

    function fn_openRcvrPopup() {
        fn_openModal('rcvrModal', '/admMsgMgrRcvrPopView.do');
    }

    function fn_addSelectedRcvrs(selectedList) {
        if (!selectedList || selectedList.length === 0) return;
        selectedList.forEach(function(rcvr) { fn_addRcvrToList(rcvr); });
        if (rcvrDlg) rcvrDlg.close();
    }

    function fn_openTmpltSavePopup() {
        fn_openModal('tmpltSaveModal', '/admMsgMgrTmpltRegistPopView.do?ttl=' + encodeURIComponent($('#ttl').val() || '') + '&txtCts=' + encodeURIComponent($('#txtCts').val() || ''));
    }

    function fn_addRcvrToList(rcvr) {
        const exists = RCVR_LIST.some(function(r) { return r.userId === rcvr.userId; });
        if (exists) return;
        RCVR_LIST.push(rcvr);
        fn_renderRcvrList();
    }

    function fn_removeSelectedRcvr() {
        const checked = $('input[name=rcvrChk]:checked');
        if (checked.length === 0) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }
        checked.each(function() {
            const userId = $(this).val();
            RCVR_LIST = RCVR_LIST.filter(function(r) { return r.userId !== userId; });
        });
        fn_renderRcvrList();
    }

    function fn_renderRcvrList() {
        let html = '';
        const colCnt = 8;
        if (RCVR_LIST.length === 0) {
            html = '<tr><td colspan="' + colCnt + '" class="txt-center"><spring:message code="common.content.not_found"/></td></tr>';
        } else {
            RCVR_LIST.forEach(function(rcvr, i) {
                let sndngYnHtml = '-';
                if (rcvr.sndngYn === 'Y') {
                    sndngYnHtml = 'Y';
                } else if (rcvr.sndngYn === 'N') {
                    sndngYnHtml = '<span class="txt-red">N</span>';
                }
                let rsltCtsHtml;
                if (rcvr.sndngYn === 'Y') {
                    rsltCtsHtml = '<spring:message code="msg.common.msg.sndngSuccess" text="성공"/>';
                } else {
                    rsltCtsHtml = rcvr.sndngRsltCts ? UiComm.escapeHtml(rcvr.sndngRsltCts) : '';
                }

                html += '<tr>';
                html += '<td data-th="선택" class="txt-center"><span class="custom-input onlychk"><input type="checkbox" name="rcvrChk" id="rcvrChk' + i + '" value="' + (rcvr.userId || '') + '"><label for="rcvrChk' + i + '"></label></span></td>';
                html += '<td data-th="번호" class="txt-center">' + (i + 1) + '</td>';
                html += '<td data-th="수신자" class="txt-center">' + UiComm.escapeHtml(rcvr.usernm || '') + '</td>';
                html += '<td data-th="학번" class="txt-center">' + (rcvr.stdntNo || '') + '</td>';
                html += '<td data-th="휴대폰번호" class="txt-center">' + (rcvr.mblPhn || '') + '</td>';
                html += '<td data-th="이메일" class="txt-center">' + UiComm.escapeHtml(rcvr.eml || '') + '</td>';
                html += '<td data-th="발송" class="txt-center">' + sndngYnHtml + '</td>';
                html += '<td data-th="결과메시지" class="txt-center">' + rsltCtsHtml + '</td>';
                html += '</tr>';
            });
        }
        $('#rcvrTbody').html(html);
    }

    function fn_save() {
        const isRsrv = $('#rsrvYnChk').is(':checked');
        if (isRsrv) {
            $('#rsrvSndngDate').attr('required', 'true');
            $('#rsrvSndngTime').attr('required', 'true');
        } else {
            $('#rsrvSndngDate').removeAttr('required');
            $('#rsrvSndngTime').removeAttr('required');
        }

        fn_refreshChnl();
        if ($('#mblSndngTycd').val() === 'LMS') {
            $('#ttl').attr('required', 'true');
        } else {
            $('#ttl').removeAttr('required');
        }

        UiValidator("msgSndngForm").then(function(result) {
            if (!result) return;

            if (RCVR_LIST.length === 0) {
                UiComm.showMessage("<spring:message code='msg.sms.msg.requiredRcvr'/>", "warning");
                return;
            }

            UiComm.showMessage('<spring:message code="msg.sms.msg.confirmRegist"/>', 'confirm').then(function(ok) {
                if (!ok) return;
                fn_doSave();
            });
        });
    }

    function fn_doSave() {
        if ($('#rsrvYnChk').is(':checked')) {
            $('#rsrvSndngSdttm').val(UiComm.getDateTimeVal('rsrvSndngDate', 'rsrvSndngTime') + '00');
        } else {
            $('#rsrvSndngSdttm').val('');
        }

        $('#rcvrListJson').val(JSON.stringify(RCVR_LIST));

        const url = '/admMsgSmsSndngRegistAjax.do';
        $('#sndngrPhnno').prop('disabled', false);
        const data = $("#msgSndngForm").serialize();

        ajaxCall(url, data, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const msg = res.message || '<spring:message code="msg.common.msg.registSuccess"/>';
                UiComm.showMessage(msg, 'success').then(function() {
                    fn_list();
                });
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_list() {
        location.href = '/admMsgSmsListView.do?encParams=' + LIST_EPARAM;
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <!-- admin -->
    <main class="common">
        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="msg.common.label.sndngRegist" text="문자 발신하기"/></h3>
                        <div class="right-area">
                            <button type="button" class="btn basic" onclick="fn_openTmpltPopup()"><spring:message code="msg.common.label.tmpltLoad" text="메시지 불러오기"/> ▼</button>
                            <button type="button" class="btn basic" onclick="fn_openTmpltSavePopup()"><spring:message code="msg.common.label.tmpltSave" text="템플릿에 저장"/> ▼</button>
                        </div>
                    </div>

                    <form id="msgSndngForm" onsubmit="return false;">
                    <input type="hidden" name="msgId" id="msgId" value=""/>
                    <input type="hidden" name="upMsgMblSndngId" id="upMsgMblSndngId" value=""/>
                    <input type="hidden" name="rcvrListJson" id="rcvrListJson" value=""/>
                    <input type="hidden" name="rsrvSndngSdttm" id="rsrvSndngSdttm" value=""/>
                    <input type="hidden" name="mblSndngTycd" id="mblSndngTycd" value="SMS"/>
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per"/>
                                <col/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th><label class="req"><spring:message code="msg.common.label.yearSmstr" text="학사년도/학기"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select id="sbjctYr" name="sbjctYr" class="form-select compact" required="true">
                                                <option value="" selected><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                                <c:forEach var="y" items="${filterOptions.yrList}">
                                                    <option value="<c:out value='${y.sbjctYr}'/>"><c:out value="${y.sbjctYr}"/><spring:message code="msg.rcptnAgre.label.year" text="년"/></option>
                                                </c:forEach>
                                            </select>
                                            <select id="sbjctSmstr" name="sbjctSmstr" class="form-select compact" required="true">
                                                <option value="" selected><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label class="req"><spring:message code="msg.common.label.oprSbjct" text="운영과목"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select id="orgId" name="orgId" class="form-select compact" required="true">
                                                <option value="" selected><spring:message code="msg.sndrDsctn.label.orgAll" text="기관 전체"/></option>
                                                <c:forEach var="o" items="${filterOptions.orgList}">
                                                    <option value="<c:out value='${o.orgId}'/>"><c:out value="${o.orgnm}"/></option>
                                                </c:forEach>
                                            </select>
                                            <select id="sbjctId" name="sbjctId" class="form-select compact" required="true">
                                                <option value="" selected><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="ttlRow" style="display:none;">
                                    <th><label for="ttl" class="req"><spring:message code="msg.common.label.ttl" text="제목"/></label></th>
                                    <td>
                                        <div class="form-row">
                                            <input type="text" id="ttl" name="ttl" class="form-control width-100per" placeholder="<spring:message code="msg.common.label.ttl"/>" inputmask="length" maxLen="200" disabled>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="txtCts" class="req"><spring:message code="msg.common.label.cts" text="내용"/></label></th>
                                    <td>
                                        <div class="form-row">
                                            <textarea id="txtCts" name="txtCts" class="form-control width-100per" rows="10" style="width:100%; resize:vertical;" maxLenCheck="byte,2000,true,true" required="true"></textarea>
                                        </div>
                                        <p class="txt-help">
                                            <spring:message code="msg.sms.label.chnl" text="채널"/> : <strong id="chnlText">SMS</strong>
                                            / <spring:message code="msg.sms.label.byteCnt" text="바이트"/> : <strong id="byteCntText">0</strong>
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label><spring:message code="msg.common.label.sndngDttm" text="발신일시"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input type="text" id="rsrvSndngDate" name="rsrvSndngDate" class="datepicker" placeholder="<spring:message code="msg.common.label.sndngDate" text="날짜"/>" disabled>
                                            <input type="text" id="rsrvSndngTime" name="rsrvSndngTime" class="timepicker" placeholder="<spring:message code="msg.common.label.sndngTime" text="시간"/>" disabled>
                                            <span class="custom-input">
                                                <input type="checkbox" id="rsrvYnChk" name="rsrvYnChk">
                                                <label for="rsrvYnChk"><spring:message code="msg.common.label.rsrvSndng" text="예약 발신"/></label>
                                            </span>
                                            <span id="rsrvDateArea" style="display:none;"></span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label class="req"><spring:message code="msg.common.label.sndngnm" text="발신자"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input type="text" id="sndngnm" name="sndngnm" class="form-control" style="width:200px;" required="true" value="<c:out value="${vo.userNm}" />" disabled>
                                            <span class="custom-input">
                                                <input type="checkbox" id="ownNameYnChk" name="ownNameYnChk" checked>
                                                <label for="ownNameYnChk"><spring:message code="msg.common.label.ownNameYn" text="본인 이름 선택"/></label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label class="req"><spring:message code="msg.common.label.sndngrPhnno" text="발신자 번호"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input type="text" id="sndngrPhnno" name="sndngrPhnno" class="form-control" style="width:200px;" required="true" maxLength="11" value="<c:out value="${vo.sndngrPhnno}"/>" disabled>
                                            <span class="custom-input">
                                                <input type="checkbox" id="ownPhnnoYnChk" name="ownPhnnoYnChk" checked>
                                                <label for="ownPhnnoYnChk"><spring:message code="msg.common.label.ownPhnnoYn" text="본인 번호 선택"/></label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </form>

                    <div class="btns">
                        <button type="button" id="btnSave" class="btn type1" onclick="fn_save()"><spring:message code="msg.common.label.sndng" text="발신"/></button>
                        <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.common.label.sndngList" text="발신목록"/></button>
                    </div>

                    <!-- 받는 사람 -->
                    <div class="board_top">
                        <h4 class="sub-title"><spring:message code="msg.sms.label.rcvrList" text="받는 사람"/></h4>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="fn_openRcvrPopup()"><i class="xi-plus-min"></i> <spring:message code="msg.common.label.add" text="추가"/></button>
                            <button type="button" class="btn type2" onclick="fn_removeSelectedRcvr()"><i class="xi-minus-min"></i> <spring:message code="msg.common.label.delete" text="삭제"/></button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:3%">
                                <col style="width:5%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:20%">
                                <col style="width:25%">
                                <col style="width:5%">
                                <col style="">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th><span class="custom-input onlychk"><input type="checkbox" id="rcvrChkAll" onclick="$('input[name=rcvrChk]').prop('checked', this.checked)"><label for="rcvrChkAll"></label></span></th>
                                    <th><spring:message code="msg.common.col.no" text="번호"/></th>
                                    <th><spring:message code="msg.common.col.rcvrnm" text="수신자"/></th>
                                    <th><spring:message code="msg.common.col.stdntNo" text="학번"/></th>
                                    <th><spring:message code="msg.sms.col.mblPhn" text="휴대폰번호"/></th>
                                    <th><spring:message code="msg.common.col.eml" text="이메일"/></th>
                                    <th><spring:message code="msg.sms.col.sndngYn" text="발송"/></th>
                                    <th><spring:message code="msg.common.col.rsltMsg" text="결과메시지"/></th>
                                </tr>
                            </thead>
                            <tbody id="rcvrTbody">
                                <tr><td colspan="8" data-th="" class="txt-center"><spring:message code="common.content.not_found"/></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </main>
    <!-- //admin -->
</div>

<jsp:include page="/WEB-INF/jsp/msg/modal/msg_common_modals.jsp"/>

</body>
</html>
