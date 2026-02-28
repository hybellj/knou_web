<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<script type="text/javascript">
		let responseMessage = "<spring:message code='${msg_code}'/>";
		if (responseMessage != ""){
			parent.UiComm.showMessage(responseMessage, "error");
		}
	</script>
</head>
<body class="">

</body>
</html>