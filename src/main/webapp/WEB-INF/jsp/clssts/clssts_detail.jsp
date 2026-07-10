<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<c:set var="initTab" value="${empty param.tab ? 'weekly' : param.tab}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="home ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="cls.title.list"/><%-- 전체수업현황 --%></h2>
                        <uiex:navibar type="main"/>
                    </div>

                    <div class="board_top class">
                        <h3 class="board-title" id="hdrTitle">
                            <c:choose>
                                <c:when test="${not empty sbjctnm}">
                                    <c:out value="${sbjctnm}"/>
                                    <c:if test="${not empty dvclasNo}">
                                        <c:out value=" ${dvclasNo}"/><spring:message code="cls.label.decls.name"/><%-- 반 --%>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="cls.label.subject.name"/><%-- 과목명 --%>
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <div class="right-area">
                            <div class="tab_btn" id="clsTab">
                                <a href="#tabWeekly" class="current" data-tab="weekly"><spring:message code="cls.title.weekly"/><%-- 주차별 수업현황 --%></a>
                                <a href="#tabElement" data-tab="element"><spring:message code="cls.title.element.status"/><%-- 학습요소 참여현황 --%></a>
                            </div>
                            <button type="button" class="btn type2" onclick="goClsList();">
                                <spring:message code="common.button.list"/><%-- 목록 --%>
                            </button>
                        </div>
                    </div>

                    <c:set var="clsTabId" value="clsTab"/>
                    <c:set var="clsShowStudentYearColumns" value="${true}"/>
                    <c:set var="clsListViewUrl" value="/clssts/selectClsStsListView.do"/>
                    <c:set var="clsWklyStatsUrl" value="/clssts/selectClsStsWklyStats.do"/>
                    <c:set var="clsNotLrnnPopupUrl" value="/clssts/selectClsStsNoStudyPopupView.do"/>
                    <c:set var="clsStdntListUrl" value="/clssts/selectClsStsStdntListPaging.do"/>
                    <c:set var="clsStdntPopupUrl" value="/clssts/selectClsStsStdntWkPopupView.do"/>
                    <c:set var="clsStdntWkDetailPopupUrl" value="/clssts/selectClsStsStdntWkDetailPopupView.do"/>
                    <c:set var="clsStdntExcelUrl" value="/clssts/selectClsStsStdntListExcelDown.do"/>
                    <c:set var="clsElemStatsUrl" value="/clssts/selectClsStsElemStats.do"/>
                    <c:set var="clsElemPopupUrl" value="/clssts/selectClsStsStdntElemPopupView.do"/>
                    <c:set var="clsElemExcelUrl" value="/clssts/selectClsStsElemStatsExcelDown.do"/>
                    <%@ include file="/WEB-INF/jsp/clssts/common/clssts_common_inc.jsp" %>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
    </main>
</div>
</body>
</html>
