<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	 <script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<c:choose>
	<c:when test="${not empty resultList }">
		<input type="hidden" name="searchCnt" id="searchCnt" value="1">
		<c:forEach items="${resultList}" var="item" varStatus="status">
		<c:set var="num" value="${status.count}"/>
		<blockquote class="toggle-btn" id="blockquote_${item.userId}">
			<input type="checkbox" id="check_${item.userId}" name="check" value="${item.userId}">
		    <span id="username">${item.userNm}</span> <span id="userid">(${item.userId})</span>
		    <p class="author">
		        <small id="deptcd">${item.deptNm}</small>
		        <small>${item.mobileNo}</small>
		        <small>${item.email}</small>
		    </p>
		</blockquote>
		</c:forEach>
	</c:when>
	<c:otherwise>
	<input type="hidden" name="searchCnt" id="searchCnt" value="0">
	<div class="flex-container">
        <div class="search-none">
            <span><spring:message code="sys.common.search.no.result" /></span><!-- 검색 결과가 없습니다. -->
        </div>
    </div>
	</c:otherwise>
</c:choose>
</html>