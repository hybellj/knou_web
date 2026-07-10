<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<c:set var="initTab" value="${empty param.tab ? 'weekly' : param.tab}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom" />
        <jsp:param name="module" value="table" />
    </jsp:include>
    <link rel="stylesheet" type="text/css" href="<c:url value='/webdoc/assets/css/classroom.css'/>" />
</head>

<body class="class ${uiex:getTheme()}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp" />

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp" />

        <div id="content" class="content-wrap common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

            <div class="class_sub">
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                <div class="class_tab_wrap">
                    <div class="tab_btn" id="crsclsTab">
                        <a href="#tabWeekly" class="current" data-tab="weekly"><spring:message code="cls.title.weekly"/><%-- 주차별 수업현황 --%></a>
                        <a href="#tabElement" data-tab="element"><spring:message code="cls.title.element.status"/><%-- 학습요소 참여현황 --%></a>
                    </div>
                </div>

                <div class="dashboard_sub">
                    <div class="sub-content">

                        <c:set var="clsTabId" value="crsclsTab"/>
                        <c:set var="clsShowStudentYearColumns" value="${false}"/>
                        <c:set var="clsListViewUrl" value=""/>
                        <c:set var="clsWklyStatsUrl" value="/clssts/selectClsStsClassWklyStats.do"/>
                        <c:set var="clsNotLrnnPopupUrl" value="/clssts/selectClsStsClassNoStudyPopupView.do"/>
                        <c:set var="clsStdntListUrl" value="/clssts/selectClsStsClassStdntListPaging.do"/>
                        <c:set var="clsStdntPopupUrl" value="/clssts/selectClsStsClassStdntWkPopupView.do"/>
                        <c:set var="clsStdntWkDetailPopupUrl" value="/clssts/selectClsStsClassStdntWkDetailPopupView.do"/>
                        <c:set var="clsStdntExcelUrl" value="/clssts/selectClsStsClassStdntListExcelDown.do"/>
                        <c:set var="clsElemStatsUrl" value="/clssts/selectClsStsClassElemStats.do"/>
                        <c:set var="clsElemPopupUrl" value="/clssts/selectClsStsClassStdntElemPopupView.do"/>
                        <c:set var="clsElemExcelUrl" value="/clssts/selectClsStsClassElemStatsExcelDown.do"/>
                        <%@ include file="/WEB-INF/jsp/clssts/common/clssts_common_inc.jsp" %>

                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
