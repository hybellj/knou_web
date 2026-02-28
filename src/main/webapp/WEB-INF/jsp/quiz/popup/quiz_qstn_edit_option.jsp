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
		function qstnOptionCheck() {
			var option = $("input:radio[name=qstnOption]:checked").val();
			if(option == undefined) {
				alert("<spring:message code='exam.alert.select.qstn.edit.option' />");/* 수정 옵션을 선택하세요. */
				return false;
			}
			window.parent.editQuizQstnOption("${vo.qstnNo}", option);
			window.parent.closeModal();
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="ui segment">
        		<p class="fcRed"><spring:message code="exam.label.quiz.msg1" /></p><!-- * 이미 답안을 제출한 학생들에 대한 재채점옵션을 선택하십시오. -->
        		<p class="fcRed"><spring:message code="exam.label.quiz.msg2" /></p><!-- * 학생 점수에 영향이 있을 수 있습니다. -->
        		<p class="fcRed"><spring:message code="exam.label.quiz.msg3" /></p><!-- * 학생 점수에 영향이 있을 수 있습니다. -->
        		<p class="fcRed"><spring:message code="exam.label.quiz.msg4" /></p><!-- * 업데이트 후 "저장 및 출제" 버튼을 반드시 클릭해 주세요. -->
        	</div>
        	<div class="ui radio checkbox show p10">
	        	<input type="radio" name="qstnOption" id="qstnOptionA" class="hidden" value="prevAnsr" />
	        	<label for="qstnOptionA"><spring:message code="exam.label.quiz.msg5" /></label><!-- 수정된 정답과 이전 정답에 모두 점수 주기(낮아지는 점수가 없음) -->
        	</div>
	        <div class="ui radio checkbox show p10">
		     	<input type="radio" name="qstnOption" id="qstnOptionB" class="hidden" value="newAnsr" />
		     	<label for="qstnOptionB"><spring:message code="exam.label.quiz.msg6" /></label><!-- 정답에만 점수 주기(일부 학생의 점수가 낮아질 수도 있음) -->
	        </div>
        	<div class="ui radio checkbox show p10">
	        	<input type="radio" name="qstnOption" id="qstnOptionC" class="hidden" value="errorAnsr" />
	        	<label for="qstnOptionC"><spring:message code="exam.label.quiz.msg7" /></label><!-- 이 문제에 대해 모두에게 만점 주기 -->
        	</div>
            
            <div class="bottom-content tc">
            	<button class="ui blue button" onclick="qstnOptionCheck()"><spring:message code="exam.button.check" /><!-- 확인 --></button>
                <button class="ui basic button" onclick="window.parent.closeModal();"><spring:message code="exam.button.cancel" /><!-- 취소 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
