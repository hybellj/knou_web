<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<script type="text/javascript">
    const MSG_ID          = '<c:out value="${msgId}" />';
    let EPARAM          = '<c:out value="${encParams}" />';
    const RCVR_LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let RCVR_LOADING    = false;
    let rcvrTable;

    $(document).ready(function() {
        fn_initDetail();
        fn_initRcvrList();
    });

    function fn_initDetail() {
        const initDetail = {
            msgId:             '<c:out value="${detail.msgId}"/>',
            rsrvYn:            '<c:out value="${detail.rsrvYn}"/>',
            rsrvSndngSdttm:    '<c:out value="${detail.rsrvSndngSdttm}"/>',
            rsrvSndngCnclDttm: '<c:out value="${detail.rsrvSndngCnclDttm}"/>',
            efctvSndngDttm:    '<c:out value="${detail.efctvSndngDttm}"/>'
        };
        fn_renderDetail(initDetail);
    }

    function fn_initRcvrList() {
        fn_buildRcvrTable();
        fn_loadRcvrList(1);
    }

    function fn_buildRcvrTable() {
        rcvrTable = UiTable("rcvrList", {
            lang: "ko",
            pageFunc: fn_loadRcvrList,
            columns: [
                {title:"<spring:message code='msg.common.col.no' text='번호'/>",           field:"no",          headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:40},
                {title:"<spring:message code='msg.common.col.rcvrnm' text='수신자'/>",     field:"rcvrnm",      headerHozAlign:"center", hozAlign:"center", width:120, minWidth:70},
                {title:"<spring:message code='msg.common.col.stdntNo' text='학번'/>",      field:"stdntNo",     headerHozAlign:"center", hozAlign:"center", width:120, minWidth:70},
                {title:"<spring:message code='msg.common.col.eml' text='이메일'/>",        field:"eml",         headerHozAlign:"center", hozAlign:"center", width:180, minWidth:120},
                {title:"<spring:message code='msg.eml.col.sndngYn' text='발송'/>",      field:"sndngYn",     headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:50, formatter:"html"},
                {title:"<spring:message code='msg.common.col.rsltMsg' text='결과메시지'/>", field:"rsltCts",     headerHozAlign:"center", hozAlign:"center", width:0, minWidth:120, formatter:"html"}
            ]
        });
    }

    function fn_renderDetail(v) {
        let sndngDttmText = UiComm.formatDate(v.efctvSndngDttm, 'datetime2');
        if (v.rsrvYn === 'Y') {
            sndngDttmText = UiComm.formatDate(v.rsrvSndngSdttm, 'datetime2') + ' / <spring:message code="msg.common.label.rsrv" text="예약발신"/>';
        }
        $('#sndngDttm').html(sndngDttmText);
    }

    function fn_loadRcvrList(pageIndex) {
        if (RCVR_LOADING) return;
        RCVR_LOADING = true;

        const extData = {
            msgId: MSG_ID,
            pageIndex: pageIndex,
            listScale: RCVR_LIST_SCALE
        };

        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };
        ajaxCall('/msgEmlSndngRcvrListAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                const dataList = fn_createRcvrListData(res.returnList, res.pageInfo);
                rcvrTable.clearData();
                rcvrTable.replaceData(dataList);
                rcvrTable.setPageInfo(res.pageInfo);
                const total = res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                $('#rcvrTotalCnt').text(total);
            }
            RCVR_LOADING = false;
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
            RCVR_LOADING = false;
        }, true);
    }

    function fn_createRcvrListData(list, pageInfo) {
        const dataList = [];
        if (!list || list.length === 0) return dataList;

        const total = pageInfo ? pageInfo.totalRecordCount : 0;

        list.forEach(function(v) {
            const rnum = total - v.lineNo + 1;
            const sndngYnHtml = v.sndngYn === 'Y'
                ? 'Y'
                : '<span class="txt-red">N</span>';
            let rsltCtsHtml;
            if (v.sndngStscd === 'CNCL') {
                rsltCtsHtml = '<spring:message code="msg.common.msg.sndngCncl" text="발송취소"/>';
            } else if (v.sndngStscd === 'RSRV') {
                rsltCtsHtml = '<spring:message code="msg.common.msg.waitSndng" text="발신대기"/>';
            } else if (v.sndngYn === 'Y') {
                rsltCtsHtml = '<spring:message code="msg.common.msg.sndngSuccess" text="성공"/>';
            } else {
                rsltCtsHtml = v.sndngRsltCts ? UiComm.escapeHtml(v.sndngRsltCts) : '';
            }

            dataList.push({
                no: rnum,
                rcvrnm: UiComm.escapeHtml(v.rcvrnm || ''),
                stdntNo: v.stdntNo || '',
                eml: UiComm.escapeHtml(v.eml || ''),
                sndngYn: sndngYnHtml,
                rsltCts: rsltCtsHtml
            });
        });
        return dataList;
    }

    function fn_modify() {
        location.href = '/profMsgEmlSndngModifyView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({ msgId: MSG_ID });
    }

    function fn_rsrvCncl() {
        const now = new Date();
        const nowStr = now.getFullYear() + '.' + String(now.getMonth()+1).padStart(2,'0') + '.' + String(now.getDate()).padStart(2,'0') + ' ' + String(now.getHours()).padStart(2,'0') + ':' + String(now.getMinutes()).padStart(2,'0');

        $('#rsrvCnclTtl').text($('#detailTtl').text() || '');
        $('#rsrvCnclDttm').text(UiComm.formatDate($('#detailRsrvSndngSdttm').val(), 'datetime2'));
        $('#rsrvCnclRcvrCnt').text($('#rcvrTotalCnt').text() || '0');
        $('#rsrvCnclUser').text($('#sndngnm').text().trim() || '');
        $('#rsrvCnclNowDttm').text(nowStr);

        $('#rsrvCnclModal').addClass('active').attr('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
    }

    function fn_closeRsrvCnclPopup() {
        $('#rsrvCnclModal').removeClass('active').attr('aria-hidden', 'true');
        document.body.style.overflow = '';
    }

    function fn_doRsrvCncl() {
        const param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgId: MSG_ID })
        };
        ajaxCall('/msgEmlRsrvCnclModifyAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                fn_closeRsrvCnclPopup();
                UiComm.showMessage('<spring:message code="msg.common.msg.rsrvCnclSuccess"/>', 'success');
                location.reload();
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function fn_list() {
        location.href = '/profMsgEmlListView.do?encParams=' + EPARAM;
    }
</script>

<body class="home ${uiex:getTheme()} ${bodyClass}">
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
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="main"/>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title"><spring:message code="msg.eml.label.sndngCtsTitle" text="이메일 발신 내용"/></h3>
                        <div class="right-area">
                            <c:if test="${canModify}">
                            <button type="button" id="btnModify" class="btn type1" onclick="fn_modify()"><spring:message code="msg.common.label.modify" text="수정"/></button>
                            </c:if>
                            <c:if test="${canRsrvCncl}">
                            <button type="button" id="btnRsrvCncl" class="btn type1" onclick="fn_rsrvCncl()"><spring:message code="msg.common.label.rsrvCncl" text="발신예약취소"/></button>
                            </c:if>
                            <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.common.label.sndngList" text="발신 목록"/></button>
                        </div>
                    </div>

                    <!-- 상세 -->
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.yearSmstr" text="학사년도/학기"/></label></li>
                            <li id="sbjctYrSmstr"><c:choose>
                                <c:when test="${not empty detail.sbjctYr}"><c:out value="${detail.sbjctYr}"/><spring:message code="msg.rcptnAgre.label.year" text="년"/><c:if test="${not empty detail.sbjctSmstr}"> / <c:out value="${detail.sbjctSmstr}"/><spring:message code="msg.rcptnAgre.label.smstr" text="학기"/></c:if></c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.oprSbjct" text="운영과목"/></label></li>
                            <li id="sbjctnm"><c:choose>
                                <c:when test="${not empty detail.orgnm or not empty detail.sbjctnm}"><c:out value="${detail.orgnm}"/><c:if test="${not empty detail.orgnm and not empty detail.sbjctnm}"> &gt; </c:if><c:out value="${detail.sbjctnm}"/></c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.ttl" text="제목"/></label></li>
                            <li id="detailTtl"><c:out value="${detail.ttl}"/></li>
                        </ul>
                        <c:if test="${detail.fileCnt > 0 and not empty detail.atflList}">
                            <ul class="list">
                                <li class="head"><label><spring:message code="msg.eml.label.atfl" text="첨부파일"/></label></li>
                                <li>
                                    <ul class="file_list">
                                        <c:forEach var="atfl" items="${detail.atflList}">
                                            <li><a href="#_" onclick="UiFileDownloader('<c:out value='${atfl.encDownParam}'/>');return false;" class="link" title="File download"><i class="xi-paperclip"></i> <c:out value="${atfl.filenm}"/></a></li>
                                        </c:forEach>
                                    </ul>
                                </li>
                            </ul>
                        </c:if>
                        <ul class="list">
                            <li class="width-100per text-center">
                                <div class="htmlText tb_content" id="htmlCts">${detail.htmlCts}</div>
                                <input type="hidden" id="detailRsrvSndngSdttm" value="<c:out value='${detail.rsrvSndngSdttm}'/>"/>
                            </li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.sndngDttm" text="발신일시"/></label></li>
                            <li id="sndngDttm"></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.sndngnm" text="발신자"/></label></li>
                            <li id="sndngnm"><c:out value="${detail.sndngnm}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.eml.label.sndngEml" text="발신자 이메일"/></label></li>
                            <li id="sndngEml"><c:out value="${detail.sndngEml}"/></li>
                        </ul>
                    </div>

                    <!-- 받는 사람 목록 -->
                    <div class="board_top" style="margin-top:30px;">
                        <h4 class="sub-title"><spring:message code="msg.eml.label.rcvrList" text="받는 사람"/></h4>
                    </div>
                    <span id="rcvrTotalCnt" style="display:none">0</span>

                    <div id="rcvrList"></div>

                </div>

            </div>
        </div>
        <!-- //content -->

        <!-- common footer -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>

    </main>
    <!-- //dashboard-->

</div>

<!-- 발신 예약 취소 팝업 -->
<div class="modal-overlay" id="rsrvCnclModal" role="dialog" aria-modal="true" aria-hidden="true">
    <div class="modal-content modal-md" tabindex="-1">
        <div class="modal-header">
            <h2><spring:message code="msg.common.label.rsrvCnclTitle" text="발신 예약 취소"/></h2>
            <button class="modal-close" aria-label="<spring:message code='msg.common.label.closeBtn' text='닫기'/>" onclick="fn_closeRsrvCnclPopup()"><i class="icon-svg-close"></i></button>
        </div>
        <div class="modal-body">
            <div class="msg-box">
                <p class="txt">
                    <i class="icon-svg-warning" aria-hidden="true"></i>
                    <span>
                        <spring:message code="msg.eml.msg.rsrvCnclConfirm" text="이메일 발송 예약을 취소하시겠습니까?"/><br>
                        <strong class="fcRed"><spring:message code="msg.common.msg.rsrvCnclNote" text="※ 취소한 내역은 복구할 수 없습니다."/></strong>
                    </span>
                </p>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.ttl" text="제목"/></label></li>
                    <li id="rsrvCnclTtl"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rsrvSndngDttm" text="발신예약일시"/></label></li>
                    <li id="rsrvCnclDttm"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rcvrnm" text="수신자"/></label></li>
                    <li id="rsrvCnclRcvrCnt"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rsrvCnclUser" text="예약취소자"/></label></li>
                    <li id="rsrvCnclUser"></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="msg.common.label.rsrvCnclDttm" text="예약취소일시"/></label></li>
                    <li id="rsrvCnclNowDttm"></li>
                </ul>
            </div>
            <div class="modal_btns">
                <button type="button" class="btn type1" onclick="fn_doRsrvCncl()"><spring:message code="msg.common.label.rsrvCnclBtn" text="취소하기"/></button>
                <button type="button" class="btn type2" onclick="fn_closeRsrvCnclPopup()"><spring:message code="msg.common.label.closeBtn" text="닫기"/></button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
