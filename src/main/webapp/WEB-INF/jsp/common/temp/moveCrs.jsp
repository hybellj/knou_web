<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
</head>
<body>
	<form action="<c:out value="${goUrl}" />" method="post" id="moveForm">
		<c:forEach items="${subParamMap}" var="item">
			<input type="hidden" name="${item.getKey()}" value="${item.getValue()}" />
		</c:forEach>
	</form>
	<script type="text/javascript">
		moveForm.submit();
	</script>
</body>
</html>