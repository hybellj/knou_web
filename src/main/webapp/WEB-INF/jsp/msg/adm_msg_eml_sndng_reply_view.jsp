<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<style>
    .editor-box {
        position: relative;
        z-index: 1;
    }
</style>

<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let EPARAM = '<c:out value="${encParams}" />';
    const LIST_EPARAM = EPARAM;
    const IS_EDIT_MODE = false;
    let RCVR_LIST = [{
        userId:  '<c:out value="${replyInfo.original.sndngrId}"/>',
        usernm:  '<c:out value="${replyInfo.original.sndngnm}"/>',
        stdntNo: '<c:out value="${replyInfo.original.stdntNo}"/>',
        mblPhn:  '',
        eml:     '<c:out value="${replyInfo.original.sndngEml}"/>'
    }];


    $(document).ready(function() {
        fn_initYrSmstr();
        fn_initRsrvSndng();
        fn_initSndngnm();
        fn_initSndngEml();
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
    }

    const ORIG_YR       = '<c:out value="${replyInfo.sbjctYr}" />';
    const ORIG_SMSTR    = '<c:out value="${replyInfo.sbjctSmstr}" />';
    const ORIG_ORG_ID   = '<c:out value="${replyInfo.orgId}" />';
    const ORIG_SBJCT_ID = '<c:out value="${replyInfo.sbjctId}" />';
    const ORIG_SBJCT_NM = '<c:out value="${replyInfo.sbjctnm}" />';

    function fn_loadSmstrList(onDone) {
        const $sel = $('#sbjctSmstr');
        const allHtml = '<option value="" selected><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>';
        const yr = $('#sbjctYr').val();

        ajaxCall('/admMsgMgrSmstrListAjax.do', { encParams: EPARAM, addParams: UiComm.makeEncParams({ sbjctYr: yr }) }, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            let html = allHtml;
            let foundOrig = false;
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    if (yr === ORIG_YR && v.dgrsSmstrChrt === ORIG_SMSTR) foundOrig = true;
                    html += '<option value="' + (v.dgrsSmstrChrt || '') + '">' + UiComm.escapeHtml(v.smstrChrtnm || '') + '</option>';
                });
            }
            if (yr === ORIG_YR && ORIG_SMSTR && !foundOrig) {
                html += '<option value="' + UiComm.escapeHtml(ORIG_SMSTR) + '">' + UiComm.escapeHtml(ORIG_SMSTR) + '<spring:message code="msg.rcptnAgre.label.smstr" text="학기"/></option>';
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
        const orgId = $('#orgId').val();

        ajaxCall('/admMsgMgrSbjctListAjax.do', { encParams: EPARAM, addParams: UiComm.makeEncParams({ orgId: orgId }) }, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            let html = allHtml;
            let foundOrig = false;
            const ctxMatch = (orgId === ORIG_ORG_ID);
            if (res.result > 0 && res.returnList) {
                res.returnList.forEach(function(v) {
                    if (ctxMatch && v.sbjctId === ORIG_SBJCT_ID) foundOrig = true;
                    html += '<option value="' + (v.sbjctId || '') + '">' + UiComm.escapeHtml(v.sbjctnm) + '</option>';
                });
            }
            if (ctxMatch && ORIG_SBJCT_ID && !foundOrig) {
                html += '<option value="' + UiComm.escapeHtml(ORIG_SBJCT_ID) + '">' + UiComm.escapeHtml(ORIG_SBJCT_NM) + '</option>';
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

    function fn_initSndngEml() {
        const ownEml = '<c:out value="${vo.sndngrEml}" />';
        const NO_REPLY_EML = 'no-reply@knou.ac.kr';
        $('#noReplyEmlChk').on('change', function() {
            if ($(this).is(':checked')) {
                $('#sndngEml').val(NO_REPLY_EML);
            } else {
                $('#sndngEml').val(ownEml);
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

    function fn_getEditorContent() {
        if (typeof editor !== 'undefined' && editor) {
            if (typeof editor.getHTML === 'function') return editor.getHTML();
            if (typeof editor.getData === 'function') return editor.getData();
        }
        return $('#htmlCts').val() || '';
    }

    function fn_openTmpltSavePopup() {
        fn_openModal('tmpltSaveModal', '/admMsgMgrTmpltRegistPopView.do?ttl=' + encodeURIComponent($('#ttl').val() || '') + '&txtCts=' + encodeURIComponent(fn_getEditorContent()));
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
                html += '<tr>';
                html += '<td data-th="선택" class="txt-center"><span class="custom-input onlychk"><input type="checkbox" name="rcvrChk" id="rcvrChk' + i + '" value="' + (rcvr.userId || '') + '"><label for="rcvrChk' + i + '"></label></span></td>';
                html += '<td data-th="번호" class="txt-center">' + (i + 1) + '</td>';
                html += '<td data-th="수신자" class="txt-center">' + UiComm.escapeHtml(rcvr.usernm || '') + '</td>';
                html += '<td data-th="학번" class="txt-center">' + (rcvr.stdntNo || '') + '</td>';
                html += '<td data-th="휴대폰번호" class="txt-center">' + (rcvr.mblPhn || '') + '</td>';
                html += '<td data-th="이메일" class="txt-center">' + UiComm.escapeHtml(rcvr.eml || '') + '</td>';
                html += '<td data-th="발송" class="txt-center">-</td>';
                html += '<td data-th="결과메시지" class="txt-center"></td>';
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

        UiValidator("msgSndngForm").then(function(result) {
            if (!result) return;

            if (RCVR_LIST.length === 0) {
                UiComm.showMessage("<spring:message code='msg.eml.msg.requiredRcvr'/>", "warning");
                return;
            }

            UiComm.showMessage('<spring:message code="msg.eml.msg.confirmRegist"/>', 'confirm').then(function(ok) {
                if (!ok) return;
                fn_startUploadOrSave();
            });
        });
    }

    function fn_startUploadOrSave() {
        const dx = dx5.get("msgAtfl");
        if (dx.availUpload()) {
            dx.startUpload();
        } else {
            fn_doSave();
        }
    }

    function fn_finishUpload() {
        const dx = dx5.get("msgAtfl");
        const data = {
            "uploadFiles": dx.getUploadFiles(),
            "uploadPath": dx.getUploadPath()
        };
        const param = { encParams: EPARAM, addParams: UiComm.makeEncParams(data) };
        ajaxCall('/common/admUploadFileCheck.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                $('#uploadFiles').val(dx.getUploadFiles());
                fn_doSave();
            } else {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_doSave() {
        if ($('#rsrvYnChk').is(':checked')) {
            $('#rsrvSndngSdttm').val(UiComm.getDateTimeVal('rsrvSndngDate', 'rsrvSndngTime') + '00');
        } else {
            $('#rsrvSndngSdttm').val('');
        }

        $('#rcvrListJson').val(JSON.stringify(RCVR_LIST));

        const htmlContent = $('#htmlCts').val() || '';
        $('#txtCts').val($('<div>').html(htmlContent).text());

        const url = '/admMsgEmlSndngRegistAjax.do';
        const data = $("#msgSndngForm").serialize();

        ajaxCall(url, data, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                UiComm.showMessage('<spring:message code="msg.common.msg.registSuccess"/>', 'success');
                fn_list();
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_list() {
        location.href = '/admMsgEmlListView.do?encParams=' + LIST_EPARAM;
    }
</script>

<body class="admin">
<div id="wrap" class="main">
    <!-- common header -->
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <!-- dashboard -->
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
                        <h3 class="board-title"><spring:message code="msg.eml.label.sndngReply" text="이메일 답장"/></h3>
                        <div class="right-area">
                            <button type="button" class="btn basic" onclick="fn_openTmpltPopup()"><spring:message code="msg.common.label.tmpltLoad" text="메시지 불러오기"/> ▼</button>
                            <button type="button" class="btn basic" onclick="fn_openTmpltSavePopup()"><spring:message code="msg.common.label.tmpltSave" text="템플릿에 저장"/> ▼</button>
                        </div>
                    </div>

                    <form id="msgSndngForm" onsubmit="return false;">
                    <input type="hidden" name="msgId" id="msgId" value=""/>
                    <input type="hidden" name="bfrMsgEmlSndngId" id="bfrMsgEmlSndngId" value="<c:out value='${replyMsgEmlSndngId}'/>"/>
                    <input type="hidden" name="rcvrListJson" id="rcvrListJson" value=""/>
                    <input type="hidden" name="rsrvSndngSdttm" id="rsrvSndngSdttm" value=""/>
                    <input type="hidden" name="uploadFiles" id="uploadFiles" value=""/>
                    <input type="hidden" name="uploadPath" id="uploadPath" value="${uploadPath}"/>
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
                                                <option value="" <c:if test="${empty replyInfo.sbjctYr}">selected</c:if>><spring:message code="msg.sndrDsctn.label.all" text="전체"/></option>
                                                <c:forEach var="y" items="${filterOptions.yrList}">
                                                    <option value="<c:out value='${y.sbjctYr}'/>" <c:if test="${y.sbjctYr eq replyInfo.sbjctYr}">selected</c:if>><c:out value="${y.sbjctYr}"/><spring:message code="msg.rcptnAgre.label.year" text="년"/></option>
                                                </c:forEach>
                                            </select>
                                            <select id="sbjctSmstr" name="sbjctSmstr" class="form-select compact" required="true">
                                                <c:forEach var="s" items="${replyInfo.smstrList}">
                                                    <option value="<c:out value='${s.dgrsSmstrChrt}'/>" <c:if test="${s.dgrsSmstrChrt eq replyInfo.sbjctSmstr}">selected</c:if>><c:out value="${s.smstrChrtnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label class="req"><spring:message code="msg.common.label.oprSbjct" text="운영과목"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <select id="orgId" name="orgId" class="form-select compact" required="true">
                                                <option value="" <c:if test="${empty replyInfo.orgId}">selected</c:if>><spring:message code="msg.sndrDsctn.label.orgAll" text="기관 전체"/></option>
                                                <c:forEach var="o" items="${filterOptions.orgList}">
                                                    <option value="<c:out value='${o.orgId}'/>" <c:if test="${o.orgId eq replyInfo.orgId}">selected</c:if>><c:out value="${o.orgnm}"/></option>
                                                </c:forEach>
                                            </select>
                                            <select id="sbjctId" name="sbjctId" class="form-select compact" required="true">
                                                <option value="" <c:if test="${empty replyInfo.sbjctId}">selected</c:if>><spring:message code="msg.sndrDsctn.label.sbjctAll" text="운영과목 전체"/></option>
                                                <c:forEach var="sb" items="${replyInfo.sbjctList}">
                                                    <option value="<c:out value='${sb.sbjctId}'/>" <c:if test="${sb.sbjctId eq replyInfo.sbjctId}">selected</c:if>><c:out value="${sb.sbjctnm}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="ttl" class="req"><spring:message code="msg.common.label.ttl" text="제목"/></label></th>
                                    <td>
                                        <div class="form-row">
                                            <input type="text" id="ttl" name="ttl" class="form-control width-100per" placeholder="<spring:message code="msg.common.label.ttl"/>" inputmask="length" maxLen="200" value="Re: <c:out value='${replyInfo.original.sndngTtl}'/>" required="true">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="htmlCts" class="req"><spring:message code="msg.common.label.cts" text="내용"/></label></th>
                                    <td>
                                        <div class="editor-box">
                                            <label for="htmlCts" class="hide">Content</label>
                                            <textarea id="htmlCts" name="htmlCts" required="true"></textarea>
                                            <script>
                                                let editor = UiEditor({
                                                    targetId: "htmlCts",
                                                    uploadPath: "${uploadPath}",
                                                    height: "500px"
                                                });
                                            </script>
                                            <input type="hidden" name="txtCts" id="txtCts" value=""/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label><spring:message code="msg.eml.label.atfl" text="첨부파일"/></label></th>
                                    <td>
                                        <uiex:dextuploader
                                                id="msgAtfl"
                                                path="${uploadPath}"
                                                limitCount="5"
                                                limitSize="100"
                                                oneLimitSize="100"
                                                listSize="3"
                                                finishFunc="fn_finishUpload()"
                                                allowedTypes="*"
                                        />
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
                                            <input type="text" id="sndngnm" name="sndngnm" class="form-control" style="width:200px;" required="true" value="<c:out value='${vo.userNm}'/>" disabled>
                                            <span class="custom-input">
                                                <input type="checkbox" id="ownNameYnChk" name="ownNameYnChk" checked>
                                                <label for="ownNameYnChk"><spring:message code="msg.common.label.ownNameYn" text="본인 이름 선택"/></label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label class="req"><spring:message code="msg.eml.label.sndngEml" text="발신자 이메일"/></label></th>
                                    <td>
                                        <div class="form-inline">
                                            <input type="text" id="sndngEml" name="sndngEml" class="form-control" style="width:300px;" required="true" inputmask="email" value="<c:out value='${vo.sndngrEml}'/>">
                                            <span class="custom-input">
                                                <input type="checkbox" id="noReplyEmlChk" name="noReplyEmlChk">
                                                <label for="noReplyEmlChk">no-reply@knou.ac.kr</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </form>

                    <div class="btns">
                        <button type="button" id="btnSave" class="btn type1" onclick="fn_save()"><spring:message code="msg.eml.label.reply" text="답장"/></button>
                        <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.common.label.sndngList" text="발신목록"/></button>
                    </div>

                    <!-- 받는 사람 -->
                    <div class="board_top">
                        <h4 class="sub-title"><spring:message code="msg.eml.label.rcvrList" text="받는 사람"/></h4>
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
                                    <th><spring:message code="msg.eml.col.mblPhn" text="휴대폰번호"/></th>
                                    <th><spring:message code="msg.common.col.eml" text="이메일"/></th>
                                    <th><spring:message code="msg.eml.col.sndngYn" text="발송"/></th>
                                    <th><spring:message code="msg.common.col.rsltMsg" text="결과메시지"/></th>
                                </tr>
                            </thead>
                            <tbody id="rcvrTbody">
                                <tr>
                                    <td data-th="선택" class="txt-center"><span class="custom-input onlychk"><input type="checkbox" name="rcvrChk" id="rcvrChk0" value="<c:out value='${replyInfo.original.sndngrId}'/>"><label for="rcvrChk0"></label></span></td>
                                    <td data-th="번호" class="txt-center">1</td>
                                    <td data-th="수신자" class="txt-center"><c:out value="${replyInfo.original.sndngnm}"/></td>
                                    <td data-th="학번" class="txt-center"><c:out value="${replyInfo.original.stdntNo}"/></td>
                                    <td data-th="휴대폰번호" class="txt-center"></td>
                                    <td data-th="이메일" class="txt-center"><c:out value="${replyInfo.original.sndngEml}"/></td>
                                    <td data-th="발송" class="txt-center">-</td>
                                    <td data-th="결과메시지" class="txt-center"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- common footer -->
        
    </main>
</div>

<jsp:include page="/WEB-INF/jsp/msg/modal/msg_common_modals.jsp"/>

<script>
    // 템플릿 적용 시 에디터에 직접 반영 (모달의 fn_tmpltApply 오버라이드)
    function fn_tmpltApply() {
        const ttl = $('#tmpltEditTtl').val().trim();
        const cts = $('#tmpltEditCts').val().trim();
        if (!ttl && !cts) {
            UiComm.showMessage('<spring:message code="common.item.select.msg"/>', 'warning');
            return;
        }
        $('#ttl').val(ttl);
        if (typeof editor !== 'undefined' && editor && typeof editor.openHTML === 'function') {
            editor.openHTML(cts);
        } else {
            $('#htmlCts').val(cts);
        }
        fn_closeModal('tmpltModal');
    }
</script>

</body>
</html>
