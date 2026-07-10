<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		function qstnOptionCheck() {
			let option = $("input:radio[name=qstnOption]:checked").val();
			if(option == undefined) {
				UiComm.showMessage("<spring:message code='exam.alert.select.qstn.edit.option' />", "info");	/* 수정 옵션을 선택하세요. */
				return false;
			}
			window.parent.quizQstnOptionModify("${vo.qstnSeqno}", option);
			window.parent.closeDialog();
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box basic fcRed">
                <ul class="list-asterisk">
                    <li><spring:message code="quiz.label.qstn.option.modify.info1" /><!-- 이미 답안을 제출한 학생들에 대한 재채점옵션을 선택하십시오. --></li>
                    <li><spring:message code="quiz.label.qstn.option.modify.info2" /><!-- 퀴즈 저장시 일괄 재채점 됩니다. --></li>
                    <li><spring:message code="quiz.label.qstn.option.modify.info3" /><!-- 학생 점수에 영향이 있을 수 있습니다. --></li>
                    <li><spring:message code="quiz.label.qstn.option.modify.info4" /><!-- 업데이트 후 "저장 및 출제" 버튼을 반드시 클릭해 주세요. --></li>
                </ul>
            </div>

			<div class="form-row">
				<span class="custom-input">
					<input type="radio" name="qstnOption" id="qstnOptionA" value="prevCrans">
					<label for="qstnOptionA"><spring:message code="quiz.label.qstn.modify.option1" /><!-- 수정된 정답과 이전 정답에 모두 점수 주기(낮아지는 점수가 없음) --></label>
				</span>
			</div>
			<div class="form-row">
				<span class="custom-input">
					<input type="radio" name="qstnOption" id="qstnOptionB" value="newCrans">
					<label for="qstnOptionB"><spring:message code="quiz.label.qstn.modify.option2" /><!-- 정답에만 점수 주기(일부 학생의 점수가 낮아질 수도 있음) --></label>
				</span>
			</div>
			<div class="form-row">
				<span class="custom-input">
					<input type="radio" name="qstnOption" id="qstnOptionC" value="allCrans">
					<label for="qstnOptionC"><spring:message code="quiz.label.qstn.modify.option3" /><!-- 이 문제에 대해 모두에게 만점 주기 --></label>
				</span>
			</div>

            <div class="modal_btns">
            	<button class="btn type1" onclick="qstnOptionCheck()"><spring:message code="common.button.ok" /><!-- 확인 --></button>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.label.cancel" /><!-- 취소 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>