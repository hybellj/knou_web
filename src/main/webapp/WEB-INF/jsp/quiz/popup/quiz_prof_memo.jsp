<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 메모 저장
		function saveProfMemo() {
			var url  = "/quiz/editExamStareMemo.do";
			var data = {
				"examCd"  	: "${stareVO.examCd}",
				"stdNo" 	: "${stareVO.stdNo}",
				"profMemo"	: $("#profMemo").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		alert("<spring:message code='exam.alert.insert.memo' />");/* 메모 저장이 완료되었습니다. */
	        		window.parent.listExamUser(1);
	        		window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.memo.insert' />");/* 메모 저장 중 에러가 발생하였습니다. */
			});
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
	            <h2 class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="exam.label.decls" />)</h2><!-- 반 -->
	            <div class="mla fcBlue">
	            	<b>${stareVO.deptNm } ${stareVO.userId } ${stareVO.userNm } <span class="f150">${stareVO.totGetScore }<spring:message code="exam.label.score.point" /></span></b><!-- 점 -->
	            </div>
        	</div>
        	<div>
        		<textarea id="profMemo" rows="10" cols="30">${stareVO.profMemo }</textarea>
        	</div>
	        
            <div class="bottom-content mt70">
                <button class="ui blue button" onclick="saveProfMemo()"><spring:message code="exam.button.save" /></button><!-- 저장 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
