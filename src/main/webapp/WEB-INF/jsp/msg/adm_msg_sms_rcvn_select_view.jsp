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
    const MSG_MBL_SNDNG_ID = '<c:out value="${msgMblSndngId}" />';
    const EPARAM           = '<c:out value="${encParams}" />';

    $(document).ready(function() {
        fn_initDetail();
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

    function fn_list() {
        location.href = '/admMsgSmsListView.do?encParams=' + EPARAM;
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
                        <h3 class="board-title"><spring:message code="msg.sms.label.rcvnCtsTitle" text="문자 수신 내용"/></h3>
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
                            <li class="head"><label><spring:message code="msg.sms.label.chnl" text="채널"/></label></li>
                            <li id="mblSndngTycd"><c:out value="${detail.mblSndngTycd}"/></li>
                        </ul>
                        <c:if test="${not empty detail.sndngTtl}">
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.ttl" text="제목"/></label></li>
                            <li><c:out value="${detail.sndngTtl}"/></li>
                        </ul>
                        </c:if>
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.cts" text="내용"/></label></li>
                            <li>
                                <div class="tb_content" id="sndngCts" style="white-space: pre-wrap;"><c:out value="${detail.sndngCts}"/></div>
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
                        <ul class="list">
                            <li class="head"><label><spring:message code="msg.common.label.sndngrPhnno" text="발신자 번호"/></label></li>
                            <li id="sndngrPhnno"><c:out value="${detail.sndngrPhnno}"/></li>
                        </ul>
                    </div>

                    <!-- 버튼 -->
                    <div class="btns">
                        <button type="button" class="btn type2" onclick="fn_list()"><spring:message code="msg.common.label.rcvnList" text="수신 목록"/></button>
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
