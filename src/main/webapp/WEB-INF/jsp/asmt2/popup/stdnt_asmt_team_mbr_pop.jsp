<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
    </jsp:include>
</head>
<body class="modal-page">
<div class="table-wrap">
    <table class="table-type2">
        <colgroup>
            <col style="width:15%"/>
            <col/>
            <col style="width:25%"/>
        </colgroup>
        <thead>
        <tr>
            <th>No</th>
            <th><spring:message code='asmt.label.user_nm'/><%--이름--%></th>
            <th><spring:message code='asmt.label.type'/><%--구분--%></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${teamMbrList}" varStatus="status">
            <tr>
                <td>${status.count}</td>
                <td><c:out value="${item.userNm}"/></td>
                <td>
                    <c:choose>
                <c:when test="${item.ldryn eq 'Y'}"><spring:message code='asmt.label.team.leader'/><%--팀장--%></c:when>
                <c:otherwise><spring:message code='asmt.label.team.member'/><%--팀원--%></c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty teamMbrList}">
            <tr>
        <td colspan="3"><spring:message code='asmt.label.team.member.empty'/><%--팀 구성원이 없습니다.--%></td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
<div class="modal_btns">
    <button type="button" class="btn type2" onclick="window.parent.closeTeamMbrDialog();"><spring:message code='asmt.button.close'/><%--닫기--%></button>
</div>
</body>
</html>
