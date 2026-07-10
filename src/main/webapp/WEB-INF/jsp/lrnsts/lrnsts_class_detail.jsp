<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="chart,table"/>
    </jsp:include>
</head>
<body class="class ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>

        <div id="content" class="content-wrap common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

            <div class="class_sub">
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                <div class="sub-content">
                    <div class="page-info">
                        <h4 class="sub-title"><spring:message code="cls.title.my.learning.status"/><%-- 나의 학습현황 --%></h4>
                    </div>

                    <%@ include file="/WEB-INF/jsp/lrnsts/common/lrnsts_common_inc.jsp" %>

                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
