<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
   	
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   	});
	   	
	   	function sendMsg() {
	   		var ctnt = $("#ctnt").val();
	   		
	   		if(!ctnt) {
	   			alert('<spring:message code="common.empty.msg" />'); // 내용을 입력하세요.
	   			return;
	   		}
	   		
	   		var url = "/erp/sendErpMessage.do";
			var data = {
				  userId: '<c:out value="${vo.userId}" />'
				, crsCreCd: '<c:out value="${vo.crsCreCd}" />'
				, ctnt: ctnt
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="success.common.insert" />'); // 정상적으로 등록되었습니다.
					window.parent.closeModal();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
	   	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
        <div class="ui form">
        	<textarea id="ctnt" rows="10" class="wmax" placeholder="<spring:message code="common.empty.msg" />"></textarea><!-- 내용을 입력하세요. -->
		</div>
		<div class="bottom-content">
			<button type="button" class="ui blue cancel button" onclick="sendMsg();"><spring:message code="common.button.send" /><!-- 보내기 --></button>
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>