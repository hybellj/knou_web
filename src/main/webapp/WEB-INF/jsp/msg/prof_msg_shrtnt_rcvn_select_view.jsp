<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>

<script type="text/javascript">
    const MSG_SHRTNT_SNDNG_ID = '<c:out value="${msgShrtntSndngId}" />';
    const EPARAM              = '<c:out value="${encParams}" />';

    $(document).ready(function() {
        fn_initDetail();
        fn_refreshUnreadCnt();
    });

    function fn_initDetail() {
        const initDetail = {
            sndngDttm:  '<c:out value="${detail.sndngDttm}"/>',
            stdntNo:    '<c:out value="${detail.stdntNo}"/>'
        };
        fn_renderDetail(initDetail);
    }

    function fn_renderDetail(v) {
        $('#sndngDttm').text(UiComm.formatDate(v.sndngDttm, 'datetime2'));
        $('#stdntNo').text(v.stdntNo || '-');
    }

    function fn_refreshUnreadCnt() {
        try {
            const topWin = (parent !== window) ? parent : window;
            if (topWin.headerNotiUnreadCntSelect) {
                topWin.headerNotiUnreadCntSelect();
            }
        } catch(e) {}
    }

    function fn_reply() {
        location.href = '/profMsgShrtntSndngReplyView.do?encParams=' + EPARAM + '&addParams=' + UiComm.makeEncParams({ replyMsgShrtntSndngId: MSG_SHRTNT_SNDNG_ID });
    }

    function fn_list() {
        location.href = '/profMsgShrtntListView.do?encParams=' + EPARAM;
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
                        <h3 class="board-title"><spring:message code="msg.shrtnt.label.rcvnCtsTitle" text="쪽지 수신 내용"/></h3>
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
                            <li><c:out value="${detail.sndngTtl}"/></li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.cts" text="내용"/></label></li>
                            <li>
                                <div class="tb_content" id="sndngCts" style="white-space: pre-wrap;"><c:out value="${detail.sndngCts}"/></div>
                            </li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.shrtnt.label.atfl" text="첨부파일"/></label></li>
                            <li>
                                <ul class="file_list">
                                    <c:forEach var="atfl" items="${detail.atflList}">
                                        <li><a href="#_" onclick="UiFileDownloader('<c:out value='${atfl.encDownParam}'/>');return false;" class="link" title="File download"><i class="xi-paperclip"></i> <c:out value="${atfl.filenm}"/></a></li>
                                    </c:forEach>
                                </ul>
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
                            <li class="head"><label><spring:message code="msg.common.label.stdntNo" text="학번"/></label></li>
                            <li id="stdntNo">-</li>
                        </ul>
                    </div>

                    <!-- 버튼 -->
                    <div class="btns">
                        <button type="button" class="btn type1" onclick="fn_reply()"><spring:message code="msg.common.label.sndngRegist" text="발신하기"/></button>
                        <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.common.label.rcvnList" text="수신 목록"/></button>
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

</body>
</html>
