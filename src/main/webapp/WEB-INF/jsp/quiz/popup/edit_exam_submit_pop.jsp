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
		
		// 퀴즈 문제 수정
		function updateExamSubmit() {
			var url  = "/quiz/editExamSubmitYn.do";
			var data = {
				"examCd"      : "${vo.examCd}",
				"crsCreCd"    : "${vo.crsCreCd }",
				"searchKey"   : "${vo.searchKey}",
				"searchGubun" : "${vo.searchGubun}"
			};
			
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : data,
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		if(data.message != null) {
					   	alert(data.message);
					}
	        		window.parent.closeModal();
	        		window.parent.location.reload();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='exam.error.qstn.submit' />");/* 문항 출제 중 에러가 발생하였습니다. */
	        });
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="ui segment fcBlue">
        		<ul>
        			<li><spring:message code="exam.label.quiz.precaution" /></li><!-- 주의사항 -->
        			<li><spring:message code="exam.label.quiz.precaution.msg1" /></li><!-- * 일부 학생이 이미 퀴즈에 참여하였습니다. -->
        			<li><spring:message code="exam.label.quiz.precaution.msg2" /></li><!-- * 학생들이 이미 퀴즈를 풀었거나 시작했으므로 편집에 주의하십시오. -->
        			<li><spring:message code="exam.label.quiz.precaution.msg3" /></li><!-- * 변경 내용이 많은 경우 이전 버전의 퀴즈를 푼 학생들의 평가를 재검토하는 것이 좋습니다. -->
        		</ul>
        	</div>
	        
            <div class="option-content">
            	<p><spring:message code="common.update.msg" /></p><!-- 수정하시겠습니까? -->
            	<button class="ui blue button" onclick="updateExamSubmit()"><spring:message code="forum.button.modify.do" /></button><!-- 수정하기 -->
                <button class="ui basic blue button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
	<!-- 엑셀 다운로드 -->
	<iframe  width="100%" scrolling="no" id="excelDownloadIfm" name="excelDownloadIfm" style="display: none;"></iframe>
</html>
