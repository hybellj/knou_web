<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function () {
		docConvert();
	});
	
	function docConvert() {
		var failUrl = "/common/docViewFail.do?encFileSn=" + "${fileVO.encFileSn}";
		
		var url  = "/common/docConvert.do";
		var param = {
			"encFileSn" : "${fileVO.encFileSn}",
		};
		
		ajaxCall(url, param, function(data) {
			var returnVO = data.returnVO || {};
			
			location.href = returnVO.goUrl || failUrl;
		}, function(xhr, status, error) {
			location.href = failUrl;
		}, true);
	}
	
</script>

<body style="display: flex; justify-content: center; align-items: center;">
</body>
</html>