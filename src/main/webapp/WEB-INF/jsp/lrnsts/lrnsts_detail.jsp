<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="chart,table"/>
    </jsp:include>
</head>
<body class="home ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
        <jsp:param name="userId" value="${userId}"/>
    </jsp:include>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="cls.title.my.learning.status"/><%-- 나의 학습현황 --%></h2>
                        <uiex:navibar type="main"/>
                    </div>

                    <div class="board_top class">
                        <h3 class="board-title">
                            <c:out value="${sbjctnm}"/>
                            <c:if test="${not empty dvclasNo}">
                                <c:out value=" ${dvclasNo}"/><spring:message code="cls.label.decls.name"/><%-- 반 --%>
                            </c:if>
                        </h3>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="moveList()"><spring:message code="common.button.list"/><%-- 목록 --%></button>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/jsp/lrnsts/common/lrnsts_common_inc.jsp" %>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
    </main>
</div>
</body>
</html>
