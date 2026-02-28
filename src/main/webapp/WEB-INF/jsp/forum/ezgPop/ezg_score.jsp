<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	if("${vo.teamCd}" != "" && "${vo.stdNo}" =="") {
		$("#teamAlert").show();
	}else{
		$("#teamAlert").hide();
	}
});

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

	var url = "/forum/ezgPop/saveScore.do";

	$("#loading_page").show();
	$.ajax({
		type : "POST",
		async: false,
		dataType : "json",
		data : {
			"crsCreCd" : $("#totalScoreBlockCrsCreCd").val()
			, "forumCd" : $("#totalScoreBlockForumCd").val()
			, "evalCd" : $("#evalScoreBlockEvalCd").val()
			, "evalTrgtUserId" : $("#totalScoreBlockStdNo").val()
			, "rltnTeamCd" : $("#totalScoreBlockTeamCd").val()
			, "evalScore" : $("#totalScore").val()
		},
		url : url,
		success : function(data){
			if(data.result > 0) {
				getJoinUserOrTeamList();
				//alert("<spring:message code='forum.alert.save_success.score' />"); // 평가 점수를 저장하였습니다.
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

	var url = "/forum/ezgPop/deleteScore.do";

	$("#loading_page").show();
	$.ajax({
		type : "POST",
		async: false,
		dataType : "json",
		data : {
			"crsCreCd" : $("#totalScoreBlockCrsCreCd").val()
			, "forumCd" : $("#totalScoreBlockForumCd").val()
			, "evalCd" : $("#evalScoreBlockEvalCd").val()
			, "evalTrgtUserId" : $("#totalScoreBlockStdNo").val()
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

// 상호평가결과 팝업
function mutEvalViewPop() {
	$("#mutEvalViewForm > input[name='crsCreCd']").val("${vo.crsCreCd}");
	$("#mutEvalViewForm > input[name='forumCd']").val("${vo.forumCd}");
	$("#mutEvalViewForm > input[name='stdNo']").val("${vo.stdNo}");
	$("#mutEvalViewForm").attr("target", "mutEvalViewIfm");
	$("#mutEvalViewForm").attr("action", "/forum/forumLect/mutEvalViewPop.do");
	$("#mutEvalViewForm").submit();
	$('#mutEvalViewPop').modal('show');
}
</script>
<div class="mt10 flex">
	<div class="ui input flex1">
		<input type="text" maxlength="3" placeholder="<spring:message code="forum.alert.input.score" />" id="totalScore" value="${forumJoinUserVo.score}" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');saveEvalScore();"><!-- 점수를 입력하세요. -->
	</div>
	<input type="hidden" id="totalScoreBlockCrsCreCd" value="${vo.crsCreCd}">
	<input type="hidden" id="totalScoreBlockForumCd" value="${vo.forumCd}">
	<input type="hidden" id="totalScoreBlockStdNo" value="${vo.stdNo}">
	<input type="hidden" id="totalScoreBlockTeamCd" value="${vo.teamCd}">
	<a href="javascript:void(0);" class="ui blue button m0" id="btnSaveEvalScore" onClick="saveEvalScore()"><spring:message code='forum.button.save'/><!-- 저장 --></a>
	<%-- <a href="javascript:void(0);" class="ui Lgrey button m0" onClick="deleteEvalScore()"><spring:message code='forum.button.reset'/><!-- 초기화 --></a> --%>
	<c:if test="${vo.evalCtgr eq 'R'}">
		<a href="javascript:void(0);" class="ui Lgrey button m0" onClick="partiScore()"><spring:message code='forum.label.evalctgr.participate.all'/><!-- 참여형 일괄평가 --></a>
	</c:if>
</div>

<!-- 상호평가 -->
<c:if test="${forumJoinUserVo.mutEvalYn eq 'Y'}">
	<div class="mt10">
		<div class="mt10 mb10">
			<div class="ui attached message flex align-items-center">
				<div class="flex align-items-center">
					<a class="ui button small basic" href="javascript:mutEvalViewPop()">
					<small class="opacity7" style="font-size: 1em;"><spring:message code='forum.label.mut.eval.result'/></small><!-- 상호평가결과 -->
					</a>
					<div class="ui tiny star rating gap4" data-rating="0" data-max-rating="5">
						<c:set var="mutAvg" value="${forumJoinUserVo.mutAvg}" />
						<c:forEach var="i" begin="1" end="5">
							<c:choose>
								<c:when test="${ mutAvg ge i }">
									<i class="star icon fcYellow"></i>
								</c:when>
								<c:otherwise>
									<i class="star outline icon"></i>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
				</div>
				<!-- 
				<div class="ui tiny star rating gap4" data-rating="0" data-max-rating="5">
					<i class="icon"></i>
					<i class="icon"></i>
					<i class="icon"></i>
					<i class="icon"></i>
					<i class="icon"></i>
				</div>
				<script>
				$('.ui.rating').rating("set rating", "${forumJoinUserVo.mutAvg eq '' || emptyforumJoinUserVo.mutAvg ? '0' : forumJoinUserVo.mutAvg}");
				</script> 
				-->
				<!-- <button type="button" class="ui small btn mla" onclick="mutEvalViewPop()">평가의견</button> -->
			</div>
		</div>
	</div>
</c:if>
<!-- 상호평가 -->

<!-- 평가의견  모달 -->
<form id="mutEvalViewForm" name="mutEvalViewForm" method="post">
	<input type="hidden" name="crsCreCd" />
	<input type="hidden" name="forumCd" />
	<input type="hidden" name="stdNo" />
</form>
<div class="modal fade" id="mutEvalViewPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.button.feedback.write' />" aria-hidden="true"><!-- 피드백 작성하기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code="common.label.eval.user.list" /><!-- 평가자 목록 --></h4>
			</div>
			<div class="modal-body">
				<iframe src="" id="mutEvalViewIfm" name="mutEvalViewIfm" width="100%" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div>
<!-- 피드백 작성  모달 -->
<script type="text/javascript">
$('iframe').iFrameResize();
</script>
