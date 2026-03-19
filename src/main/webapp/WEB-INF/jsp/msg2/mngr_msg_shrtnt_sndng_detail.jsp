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
    let msgId = '${msgId}';
    let rcvrCurrentPage = 1;
    let rcvrListScale = 10;
    let rcvrTable;
    let rsrvCnclDlg;
    let detailData = null;

    $(document).ready(function() {
        fn_loadDetail();
        fn_loadRcvrList(1);
    });

    /* 발신 상세 조회 */
    function fn_loadDetail() {
        ajaxCall('/msgShrtntSndngDetailAjax.do', { msgId: msgId }, function(res) {
            if (res.result > 0 && res.returnVO) {
                fn_renderDetail(res.returnVO);
            } else {
                alert(res.message || '<spring:message code="fail.common.select"/>');
            }
        });
    }

    /* 상세 렌더링 */
    function fn_renderDetail(v) {
        detailData = v;

        /* 학사년도/학기 */
        let yrSmstr = '';
        if (v.sbjctYr) yrSmstr = v.sbjctYr;
        if (v.sbjctSmstr) yrSmstr += ' / ' + v.sbjctSmstr;
        $('#sbjctYrSmstr').text(yrSmstr || '-');

        /* 운영과목 */
        let parts = [];
        if (v.orgnm) parts.push(v.orgnm);
        if (v.deptnm) parts.push(v.deptnm);
        if (v.sbjctnm) parts.push(v.sbjctnm);
        $('#sbjctnm').text(parts.length > 0 ? parts.join(' > ') : '-');

        /* 내용 */
        $('#txtCts').html(UiComm.escapeHtml(v.txtCts || '').replace(/\n/g, '<br>'));

        /* 첨부파일 */
        if (v.atflList && v.atflList.length > 0) {
            let fileHtml = '';
            v.atflList.forEach(function(f) {
                fileHtml += '<a href="/common/downloadFile.do?filenm=' + encodeURIComponent(f.filenm) + '&fileSavnm=' + encodeURIComponent(f.fileSavnm) + '&filePath=' + encodeURIComponent(f.filePath) + '">';
                fileHtml += '<i class="xi-paperclip"></i> ' + UiComm.escapeHtml(f.filenm);
                fileHtml += '</a><br>';
            });
            $('#atflContent').html(fileHtml);
        } else {
            $('#atflContent').text('-');
        }

        /* 발신일시 */
        let sndngDttmText = UiComm.formatDate(v.efctvSndngDttm, 'datetime');
        if (v.rsrvYn === 'Y') {
            sndngDttmText = UiComm.formatDate(v.rsrvSndngSdttm, 'datetime') + ' / <spring:message code="msg.shrtnt.label.rsrv" text="예약발신"/>';
        }
        $('#sndngDttm').html(sndngDttmText);

        /* 발신자 */
        $('#sndngnm').text(v.sndngnm || '');
        $('#sndngrPhnno').text(v.sndngrPhnno || '-');

        /* 예약 관련 버튼 */
        if (v.rsrvYn === 'Y') {
            if (v.rsrvSndngCnclDttm) {
                /* 이미 취소된 경우 */
            } else {
                $('#btnModify').show();
                $('#btnRsrvCncl').show();
            }
        }
    }

    /* 수신자 목록 조회 */
    function fn_loadRcvrList(pageIndex) {
        if (pageIndex) rcvrCurrentPage = pageIndex;

        let param = {
            msgId: msgId,
            pageIndex: rcvrCurrentPage,
            listScale: rcvrListScale
        };

        ajaxCall('/msgShrtntSndngRcvrListAjax.do', param, function(res) {
            if (res.result > 0) {
                let dataList = fn_createRcvrListData(res.returnList, res.pageInfo);
                rcvrTable.clearData();
                rcvrTable.replaceData(dataList);
                rcvrTable.setPageInfo(res.pageInfo);
                let total = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#rcvrTotalCnt').text(total);
            }
        }, function() {
            alert('<spring:message code="fail.common.select"/>');
        }, true);
    }

    /* 수신자 목록 데이터 생성 */
    function fn_createRcvrListData(list, pageInfo) {
        let dataList = [];
        if (!list || list.length === 0) return dataList;

        let total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v, i) {
            let rnum = total - ((rcvrCurrentPage - 1) * rcvrListScale) - i;
            let sndngYnHtml = v.sndngYn === 'Y'
                ? 'Y'
                : '<span class="txt-red">N</span>';

            dataList.push({
                no: rnum,
                rcvrnm: UiComm.escapeHtml(v.rcvrnm || ''),
                stdntNo: v.stdntNo || '',
                userRprsId2: v.userRprsId2 || '',
                mblPhn: v.mblPhn || '',
                eml: v.eml || '',
                sndngYn: sndngYnHtml
            });
        });
        return dataList;
    }

    /* 수정 */
    function fn_modify() {
        location.href = '/mngrMsgShrtntSndngRegistView.do?msgId=' + encodeURIComponent(msgId);
    }

    /* 받는 사람 엑셀 다운로드 */
    function fn_excelDownRcvr() {
        let excelGrid = { colModel: [] };
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.no" text="번호"/>', name: 'rnum', align: 'center', width: '2000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.rcvrnm" text="수신자"/>', name: 'rcvrnm', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.stdntNo" text="학번"/>', name: 'stdntNo', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.rprsId" text="대표 ID"/>', name: 'userRprsId2', align: 'center', width: '4000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.mblPhn" text="휴대폰번호"/>', name: 'mblPhn', align: 'center', width: '5000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.eml" text="이메일"/>', name: 'eml', align: 'center', width: '6000'});
        excelGrid.colModel.push({label: '<spring:message code="msg.shrtnt.col.sndngYn" text="발송"/>', name: 'sndngYn', align: 'center', width: '3000'});

        let form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "excelForm");
        form.attr("action", "/downExcelMsgShrtntRcvr.do");
        form.append($('<input/>', { type: 'hidden', name: 'msgId', value: msgId }));
        form.append($('<input/>', { type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid) }));
        form.appendTo("body");
        form.submit();
        $("form[name=excelForm]").remove();
    }

    /* 예약 취소 */
    function fn_rsrvCncl() {
        if (!detailData) return;

        let now = new Date();
        let nowStr = now.getFullYear() + '.' + String(now.getMonth()+1).padStart(2,'0') + '.' + String(now.getDate()).padStart(2,'0') + ' ' + String(now.getHours()).padStart(2,'0') + ':' + String(now.getMinutes()).padStart(2,'0');
        let rcvrCntVal = $('#rcvrTotalCnt').text() || '0';

        let html = '<div style="padding:15px;">';
        html += '<div style="margin-bottom:15px; color:#c00;">';
        html += '<i class="xi-warning" style="font-size:18px; margin-right:5px;"></i>';
        html += '<spring:message code="msg.shrtnt.msg.rsrvCnclWarn"/>';
        html += '</div>';
        html += '<div class="table_list">';
        html += '<ul class="list"><li class="head"><label><spring:message code="msg.shrtnt.label.ttl" text="제목"/></label></li>';
        html += '<li>' + UiComm.escapeHtml(detailData.ttl || '') + '</li></ul>';
        html += '<ul class="list"><li class="head"><label class="req"><spring:message code="msg.shrtnt.label.rsrvSndngDttm2" text="발신예약일시"/></label></li>';
        html += '<li>' + UiComm.formatDate(detailData.rsrvSndngSdttm, 'datetime') + '</li></ul>';
        html += '<ul class="list"><li class="head"><label class="req"><spring:message code="msg.shrtnt.label.rcvrnm" text="수신자"/></label></li>';
        html += '<li>' + rcvrCntVal + '</li></ul>';
        html += '<ul class="list"><li class="head"><label class="req"><spring:message code="msg.shrtnt.label.cnclr" text="예약취소자"/></label></li>';
        html += '<li>' + UiComm.escapeHtml(detailData.sndngnm || '') + '</li></ul>';
        html += '<ul class="list"><li class="head"><label class="req"><spring:message code="msg.shrtnt.label.cnclDttm" text="예약취소일시"/></label></li>';
        html += '<li>' + nowStr + '</li></ul>';
        html += '</div>';
        html += '<div class="btns" style="margin-top:15px;">';
        html += '<button type="button" class="btn type1" onclick="fn_rsrvCnclSubmit()"><spring:message code="msg.shrtnt.label.cnclBtn" text="취소하기"/></button>';
        html += '<button type="button" class="btn type2" onclick="rsrvCnclDlg.close()"><spring:message code="msg.shrtnt.label.closeBtn" text="닫기"/></button>';
        html += '</div>';
        html += '</div>';

        rsrvCnclDlg = UiDialog('rsrvCnclPopup', {
            title: '<spring:message code="msg.shrtnt.label.rsrvCnclTitle" text="발신 예약 취소"/>',
            width: 550,
            height: 420,
            html: html
        });
    }

    /* 예약 취소 처리 */
    function fn_rsrvCnclSubmit() {
        ajaxCall('/msgShrtntRsrvCnclAjax.do', { msgId: msgId }, function(res) {
            if (res.result > 0) {
                alert('<spring:message code="msg.shrtnt.msg.rsrvCnclSuccess"/>');
                if (rsrvCnclDlg) rsrvCnclDlg.close();
                fn_loadDetail();
                $('#btnModify').hide();
                $('#btnRsrvCncl').hide();
            } else {
                alert(res.message || '<spring:message code="fail.common.update"/>');
            }
        });
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

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="msg.shrtnt.label.sndngCtsTitle" text="쪽지 발신 내용"/></h3>
                            <div class="right-area">
                                <button type="button" id="btnModify" class="btn type1" onclick="fn_modify()" style="display:none;"><spring:message code="msg.shrtnt.label.modify" text="수정"/></button>
                                <button type="button" id="btnRsrvCncl" class="btn type1" onclick="fn_rsrvCncl()" style="display:none;"><spring:message code="msg.shrtnt.label.rsrvCncl" text="발신예약취소"/></button>
                                <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.shrtnt.label.sndngList" text="발신 목록"/></button>
                            </div>
                        </div>

                        <!-- 상세 -->
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.yearSmstr" text="학사년도/학기"/></label></li>
                                <li id="sbjctYrSmstr">-</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.oprSbjct" text="운영과목"/></label></li>
                                <li id="sbjctnm">-</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.cts" text="내용"/></label></li>
                                <li>
                                    <div class="tb_content" id="txtCts"></div>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.atfl" text="첨부파일"/></label></li>
                                <li id="atflContent">-</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.sndngDttm" text="발신일시"/></label></li>
                                <li id="sndngDttm"></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.sndngnm" text="발신자"/></label></li>
                                <li id="sndngnm"></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.shrtnt.label.sndngrPhnno" text="발신자 번호"/></label></li>
                                <li id="sndngrPhnno">-</li>
                            </ul>
                        </div>

                        <!-- 받는 사람 목록 -->
                        <div class="board_top" style="margin-top:30px;">
                            <h3 class="board-title"><spring:message code="msg.shrtnt.label.rcvrList" text="받는 사람 목록"/> [ <spring:message code="msg.sndrDsctn.label.totalCnt" text="총건수"/> : <b id="rcvrTotalCnt">0</b><spring:message code="msg.sndrDsctn.label.cnt" text="건"/> ]</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="fn_excelDownRcvr()"><spring:message code="msg.sndrDsctn.label.excelDown" text="엑셀 다운로드"/></button>
                            </div>
                        </div>

                        <div id="rcvrList"></div>

                        <script>
                        rcvrTable = UiTable("rcvrList", {
                            lang: "ko",
                            pageFunc: fn_loadRcvrList,
                            columns: [
                                {title:"<spring:message code='msg.shrtnt.col.no' text='번호'/>",           field:"no",          headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:40},
                                {title:"<spring:message code='msg.shrtnt.col.rcvrnm' text='수신자'/>",     field:"rcvrnm",      headerHozAlign:"center", hozAlign:"center", width:100, minWidth:80},
                                {title:"<spring:message code='msg.shrtnt.col.stdntNo' text='학번'/>",      field:"stdntNo",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:80},
                                {title:"<spring:message code='msg.shrtnt.col.rprsId' text='대표 ID'/>",    field:"userRprsId2", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:80},
                                {title:"<spring:message code='msg.shrtnt.col.mblPhn' text='휴대폰번호'/>", field:"mblPhn",      headerHozAlign:"center", hozAlign:"center", width:120, minWidth:100},
                                {title:"<spring:message code='msg.shrtnt.col.eml' text='이메일'/>",        field:"eml",         headerHozAlign:"center", hozAlign:"left",   width:180, minWidth:140},
                                {title:"<spring:message code='msg.shrtnt.col.sndngYn' text='발송'/>",      field:"sndngYn",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:50, formatter:"html"}
                            ]
                        });
                        </script>

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>

</body>
</html>
