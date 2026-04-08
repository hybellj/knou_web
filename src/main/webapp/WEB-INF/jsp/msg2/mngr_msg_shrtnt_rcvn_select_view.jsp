<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let msgShrtntSndngId = '<c:out value="${msgShrtntSndngId}" />';
    let EPARAM = '<c:out value="${encParams}" />';
    $(document).ready(function() {
        fn_loadDetail();
    });

    /* 상세 조회 */
    function fn_loadDetail() {
        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgShrtntSndngId: msgShrtntSndngId })
        };
        ajaxCall('/msgShrtntRcvnSelectAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0 && res.returnVO) {
                fn_renderDetail(res.returnVO);
                fn_markRead();
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error");
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 상세 렌더링 */
    function fn_renderDetail(v) {
        /* 학사년도/학기 */
        let yrSmstr = '';
        if (v.sbjctYr) yrSmstr = v.sbjctYr + '<spring:message code="msg.rcptnAgre.label.year" text="년"/>';
        if (v.sbjctSmstr) yrSmstr += ' / ' + v.sbjctSmstr + '<spring:message code="msg.rcptnAgre.label.smstr" text="학기"/>';
        $('#sbjctYrSmstr').text(yrSmstr || '-');

        /* 운영과목 */
        let parts = [];
        if (v.orgnm) parts.push(v.orgnm);
        if (v.deptnm) parts.push(v.deptnm);
        if (v.sbjctnm) parts.push(v.sbjctnm);
        $('#sbjctnm').text(parts.length > 0 ? parts.join(' > ') : '-');

        /* 기본 필드 */
        $('#sndngTtl').text(v.sndngTtl || '');
        $('#sndngCts').html(UiComm.escapeHtml(v.sndngCts || '').replace(/\n/g, '<br>'));
        $('#sndngDttm').text(UiComm.formatDate(v.sndngDttm, 'datetime'));
        $('#sndngnm').text(v.sndngnm || '');

        /* 발신자 정보 */
        $('#stdntNo').text(v.stdntNo || '-');
        $('#userRprsId2').text(v.userRprsId2 || '-');

        /* 첨부파일 */
        if (v.atflList && v.atflList.length > 0) {
            let fileHtml = '';
            v.atflList.forEach(function(f) {
                fileHtml += '<a href="#_" onclick="UiFileDownloader(\'' + f.encDownParam + '\');return false;" class="link" title="File download">';
                fileHtml += '<i class="xi-paperclip"></i> ' + UiComm.escapeHtml(f.filenm);
                fileHtml += '</a><br>';
            });
            $('#atflContent').html(fileHtml);
        } else {
            $('#atflContent').text('-');
        }
    }

    /* 읽음 처리 */
    function fn_markRead() {
        let param = {
              encParams: EPARAM
            , addParams: UiComm.makeEncParams({ msgShrtntSndngId: msgShrtntSndngId })
        };
        ajaxCall('/msgShrtntReadModifyAjax.do', param, function(res) {
            if (res.encParams) EPARAM = res.encParams;
            if (res.result > 0) {
                fn_refreshUnreadCnt();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    /* 알림 미읽음 카운트 갱신 */
    function fn_refreshUnreadCnt() {
        try {
            let topWin = (parent !== window) ? parent : window;
            if (topWin.headerNotiUnreadCntSelect) {
                topWin.headerNotiUnreadCntSelect();
            }
        } catch(e) {}
    }

    /* 답장 */
    function fn_reply() {
        location.href = '/mngrMsgShrtntSndngRegistView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({ replyMsgShrtntSndngId: msgShrtntSndngId });
    }

    /* 수신 목록 */
    function fn_list() {
        location.href = '/mngrMsgShrtntListView.do?encParams=' + EPARAM;
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
                        <h3 class="board-title"><spring:message code="msg.shrtnt.label.rcvnCtsTitle" text="쪽지 수신 내용"/></h3>
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
                                <div class="tb_content" id="sndngCts"></div>
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
                            <li class="head"><label><spring:message code="msg.shrtnt.label.stdntNo" text="학번"/></label></li>
                            <li id="stdntNo">-</li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.shrtnt.label.userRprsId" text="대표 ID"/></label></li>
                            <li id="userRprsId2">-</li>
                        </ul>
                    </div>

                    <!-- 버튼 -->
                    <div class="btns">
                        <button type="button" class="btn type1" onclick="fn_reply()"><spring:message code="msg.shrtnt.label.sndngRegist" text="발신하기"/></button>
                        <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.shrtnt.label.rcvnList" text="수신 목록"/></button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //content -->

    </main>
    <!-- //admin -->
</div>

</body>
</html>
