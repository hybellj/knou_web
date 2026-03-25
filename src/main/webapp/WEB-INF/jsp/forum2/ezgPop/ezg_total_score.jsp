<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
});

// 정수인지 검사
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
	$("#totalScore").val(score);
}

// 평가 점수 저장 처리
function saveEvalScore() {
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
		return false;
	}
	
	if (!isIntegerNumber($("#totalScore").val())) {
		alert("<spring:message code='forum.alert.score.input_num' />"); // 점수를 숫자로 입력하세요.
		$("#totalScore").val("");
		$("#totalScore").focus();
		return;
	}

	if (Number($("#totalScore").val()) > 100) {
		alert("<spring:message code='forum.alert.score.max_100' />"); // 점수는 100점 까지 입력 가능 합니다.
		$("#totalScore").focus();
		return;
	}

	var offset = 0;
	var qstrnCds = '';
	var qstrnScores = '';
	var qstrnScoreObjs = $('input[name=qstnScore]');
	$('input:hidden[name=qstnCd]').each(function (idx) {
		if ($(qstrnScoreObjs[idx]).val() && $.trim($(qstrnScoreObjs[idx]).val()) != '' && isIntegerNumber($(qstrnScoreObjs[idx]).val())) {
			if(offset > 0) {
				qstrnCds += '@#';
				qstrnScores += '@#';
			}
			qstrnCds += $(this).val();
			qstrnScores += $(qstrnScoreObjs[idx]).val();
			offset++;
		}
	});

	var url = "/forum2/ezgPop/saveScore.do";

	$("#loading_page").show();
	$.ajax({
		type : "POST",
		async: false,
		dataType : "json",
		data : {
			"crsCreCd" : $("#totalScoreBlockCrsCreCd").val()
			, "forumCd" : $("#totalScoreBlockForumCd").val()
			, "evalCd" : $("#evalScoreBlockEvalCd").val()
			, "mutEvalCd" : $("#evalScoreBlockMutEvalCd").val()
			, "evalTrgtUserId" : $("#totalScoreBlockStdId").val()
			, "rltnTeamCd" : $("#totalScoreBlockTeamCd").val()
			, "evalScore" : $("#totalScore").val()
			, "evalScores" : qstrnScores
			, "qstnNos" : qstrnCds
		},
		url : url,
		success : function(data){
			if(data.result > 0) {
				getJoinUserOrTeamList();
				alert("<spring:message code='forum.alert.save_success.score' />"); // 평가 점수를 저장하였습니다.
			} else {
				alert(data.message);
			}
		},
		beforeSend: function() {
		},
		complete:function(status){
			$("#loading_page").hide();
		},
		error: function(xhr,  Status, error) {
			$("#loading_page").hide();
		}
	});
}

// 평가 점수 삭제 처리
function deleteEvalScore() {
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
		return false;
	}

	var url = "/forum2/ezgPop/deleteScore.do";

	$("#loading_page").show();
	$.ajax({
		type : "POST",
		async: false,
		dataType : "json",
		data : {
			"crsCreCd" : $("#totalScoreBlockCrsCreCd").val()
			, "forumCd" : $("#totalScoreBlockForumCd").val()
			, "evalCd" : $("#evalScoreBlockEvalCd").val()
			, "mutEvalCd" : $("#evalScoreBlockMutEvalCd").val()
			, "evalTrgtUserId" : $("#totalScoreBlockStdId").val()
			, "rltnTeamCd" : $("#totalScoreBlockTeamCd").val()
		},
		url : url,
		success : function(data){
			if(data.result > 0) {
				getJoinUserOrTeamList();
				alert("<spring:message code='forum.alert.init_success.score' />"); // 평가점수를 초기화하였습니다.
			} else {
				alert(data.message);
			}
		},
		beforeSend: function() {
		},
		complete:function(status){
			$("#loading_page").hide();
		},
		error: function(xhr,  Status, error) {
			$("#loading_page").hide();
		}
	});
}
</script>

<div class="mt10 flex">
	<div class="ui input flex1">
		<input type="text" maxlength="3" placeholder="<spring:message code="forum.alert.input.score" />" id="totalScore" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');saveEvalScore();" ><!-- 점수를 입력하세요. -->
	</div>
	<input type="hidden" id="totalScoreBlockCrsCreCd" value="${CRS_CRE_CD}">
	<input type="hidden" id="totalScoreBlockForumCd" value="${vo.forumCd}">
	<input type="hidden" id="totalScoreBlockStdId" value="${vo.stdId}">
	<input type="hidden" id="totalScoreBlockTeamCd" value="${vo.teamCd}">
	<a href="javascript:void(0);" class="ui blue button m0" id="btnSaveEvalScore" onClick="saveEvalScore()"><spring:message code='forum.button.save'/><!-- 저장 --></a>
	<%-- <a href="javascript:void(0);" class="ui Lgrey button m0" onClick="deleteEvalScore()"><spring:message code='forum.button.reset'/><!-- 초기화 --></a> --%>
	<c:if test="${vo.evalCtgr eq 'R'}">
		<a href="javascript:void(0);" class="ui Lgrey button m0" onClick="partiScore()"><spring:message code='forum.label.evalctgr.participate.all'/><!-- 참여형 일괄평가 --></a>
	</c:if>
</div>
