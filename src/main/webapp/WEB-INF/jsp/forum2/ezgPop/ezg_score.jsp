<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
//정수인지 검사
function isIntegerNumber(value) {
	if( value === undefined || value == null || $.trim(value) == '' ) {
		return false;
	}

	var reg = /^\d+$/;
	value += '';
	return reg.test(value.replace(/,/gi,""));
}

// total 점수  계산
function setTotalScore(score) {
	$("#inputScore").val(score);
}

// 점수 저장 처리
function saveEzgScore() {
	if($('.active-toggle-btn.select').length < 1){
		UiComm.showMessage("<spring:message code='forum_ezg.label.select.empty' />", "info"); // 선택된 대상이 없습니다.
		return false;
	}
	
	if (!isIntegerNumber($("#inputScore").val())) {
		UiComm.showMessage("<spring:message code='forum.alert.score.input_num' />", "info"); // 점수를 숫자로 입력해주세요.
		$("#inputScore").val("");
		$("#inputScore").focus();
		return;
	}

	if (Number($("#inputScore").val()) > 100) {
		UiComm.showMessage("<spring:message code='forum.alert.score.max_100' />", "info"); // 점수는 100점까지 입력 가능 합니다.
		$("#inputScore").focus();
		return;
	}

	var url = "/forum2/ezgPop/saveScore.do";
	var stdIds = typeof getSelectedEzgStdIds === "function" ? getSelectedEzgStdIds() : $("#totalScoreBlockStdId").val();
	var selectionState = typeof getEzgSelectionState === "function" ? getEzgSelectionState() : null;
	var errorMsg = "<spring:message code='forum.common.error' />"; // 오류가 발생했습니다.
	var data = {
		"sbjctId" : $("#totalScoreBlockSbjctId").val()
		, "dscsId" : $("#totalScoreBlockDscsId").val()
		, "stdId" : $("#totalScoreBlockStdId").val()
		, "stdIds" : stdIds
		, "teamId" : $("#totalScoreBlockTeamId").val()
		, "scr" : $("#inputScore").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			getJoinUserOrTeamList(selectionState);
		} else {
			UiComm.showMessage(data.message || errorMsg, "error");
		}
	}, function(xhr, status, error) {
		UiComm.showMessage(errorMsg, "error");
	}, true);
}
// 점수 삭제 처리
function deleteEzgScore() {
	if($('.active-toggle-btn.select').length < 1){
		UiComm.showMessage("<spring:message code='forum_ezg.label.select.empty' />", "info"); // 선택된 대상이 없습니다.
		return false;
	}

	var url = "/forum2/ezgPop/deleteScore.do";
	var stdIds = typeof getSelectedEzgStdIds === "function" ? getSelectedEzgStdIds() : $("#totalScoreBlockStdId").val();
	var selectionState = typeof getEzgSelectionState === "function" ? getEzgSelectionState() : null;
	var errorMsg = "<spring:message code='forum.common.error' />"; // 오류가 발생했습니다.
	var data = {
		"sbjctId" : $("#totalScoreBlockSbjctId").val()
		, "dscsId" : $("#totalScoreBlockDscsId").val()
		, "stdId" : $("#totalScoreBlockStdId").val()
		, "stdIds" : stdIds
		, "teamId" : $("#totalScoreBlockTeamId").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			getJoinUserOrTeamList(selectionState);
			UiComm.showMessage("<spring:message code='forum.alert.init_success.score' />", "success"); // 평가 점수를 초기화하였습니다.
		} else {
			UiComm.showMessage(data.message || errorMsg, "error");
		}
	}, function(xhr, status, error) {
		UiComm.showMessage(errorMsg, "error");
	}, true);
}
</script>
	<label for="inputScore">
		<input type="text" maxlength="3" placeholder="<spring:message code="forum.alert.input.score" />" id="inputScore" value="${dscsJoinUserVO.scr}" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"><!-- 점수를 입력하세요. -->
	</label>
	<input type="hidden" id="totalScoreBlockSbjctId" value="${vo.sbjctId}">
	<input type="hidden" id="totalScoreBlockDscsId" value="${vo.dscsId}">
	<input type="hidden" id="totalScoreBlockStdId" value="${vo.stdId}">
	<input type="hidden" id="totalScoreBlockTeamId" value="${vo.teamId}">
	<button type="button" class="btn small type3" id="btnSaveEzgScore" onClick="saveEzgScore()"><spring:message code='forum.button.save'/><!-- 저장 --></button>
	<button type="button" class="btn small type2" onClick="deleteEzgScore()"><spring:message code='forum.button.reset'/><!-- 초기화 --></button>

<script type="text/javascript">
// 참여형 일괄평가 버튼 분리 렌더링
$("#totalScoreActionBlock").empty();
<c:if test="${vo.evlScrTycd eq 'PTCP_FULL_SCR'}">
$("#totalScoreActionBlock").html("<button type=\"button\" class=\"btn basic width-100per\" onClick=\"partiScore()\"><spring:message code='forum.label.evalctgr.participate.all'/></button>"); // 참여형 일괄평가
</c:if>
</script>
