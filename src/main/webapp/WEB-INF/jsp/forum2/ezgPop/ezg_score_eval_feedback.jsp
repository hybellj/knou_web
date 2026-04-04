<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
var audioRecord = null;
$(document).ready(function() {
	audioRecord = UiAudioRecorder("audioRecord");
	audioRecord.formName = "recordForm";
	audioRecord.dataName = "audioData";
	audioRecord.fileName = "audioFile";
	audioRecord.lang	 = "ko";
	audioRecord.init();

	audioRecord.recorderBox.css({"top":"0px", "left":"0px"});
	audioRecord.setRecorder();

	$("#audioRecord").height($(".recorder-box").height()+22);

	$(".audio-header").remove();
	$(".audio-btm .btm-btn").remove();

	audioRecord.recorderBox.show();

	if("${fdbkSize}" == 0){
		$("#fdbkUi").hide();
		$("#fdbkTitle").hide();
		$("#fdbkDiv").hide();
	}
});

function toggleArticleBlock() {
	if ($(".article").hasClass("show")) {
		$(".article").removeClass("show");
	} else {
		$(".article").addClass("show");
	}
}

//피드백 작성 팝업
function fdbkList(stdId) {
	if($('.active-toggle-btn.select').length < 1){
		alert("<spring:message code='forum_ezg.label.select.empty' />"); // 선택된 대상이 없습니다.
		return false;
	}

	var dscsId = "${dscsVO.dscsId}";
	$("form[name='forumCreCrsStdForm'] input[name='dscsId']").val(dscsId);
	$("form[name='forumCreCrsStdForm'] input[name='stdId']").val(stdId);
	$("#forumCreCrsStdForm").attr("target", "fdbkListIfm");
	$("#forumCreCrsStdForm").attr("action", "/forum2/forumLect/forumFdbkPop.do");
	$("#forumCreCrsStdForm").submit();
	$('#fdbkListPop').modal('show');
}

</script>
<form name="forumCreCrsStdForm" id="forumCreCrsStdForm" method="POST">
	<input type="hidden" name="dscsId" value="${dscsVO.dscsId }">
	<input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}">
	<input type="hidden" name="teamTycd" value="${dscsVO.teamTycd}">
	<input type="hidden" name="stdId" value="">
	<input type="hidden" name="crsCreCd" value="${dscsVO.crsCreCd}">
</form>

<c:if test="${dscsVO.dscsUnitTycd eq 'GNRL' && CLASS_USER_TYPE ne 'CLASS_LEARNER'  && (empty dscsVO.searchMenu || dscsVO.searchMenu != 'EZG') && dscsVO.evalCritUseYn eq 'N'}">
	<div class="inline field">
		<label class="label-title"><spring:message code="forum.label.record" /><%-- 성적 --%></label>
		<a id="scoreText">${dscsJoinUserVO.score }<spring:message code='forum.label.point'/></a><%-- 점 --%>
		<div class="ui right labeled small input" name="scoreInput" style="display:none;">
			<input type="number" min="0" id="${dscsJoinUserVO.stdId }" name="refLabel" class="w60" maxlength="3" value="${dscsJoinUserVO.score}" onkeyup="checkValid(this);">
			<div class="ui basic label"><spring:message code='forum.label.point'/></div><%--점  --%>
		</div>
	</div>
</c:if>

	<c:if test="${dscsVO.dscsUnitTycd eq 'GNRL' && CLASS_USER_TYPE ne 'CLASS_LEARNER' && dscsVO.evalCritUseYn eq 'N'}">
	<div class="ui divider"></div>
	</c:if>
	<c:if test="${CLASS_USER_TYPE ne 'CLASS_LEARNER'}">
	<div class="flex-item flex-wrap gap4 pt10">
		<c:if test="${not empty dscsVO.searchMenu && dscsVO.searchMenu == 'EZG'}"> 
		<a href="javascript:void(0);" class="ui basic fluid button" onClick="fdbkList('${dscsVO.stdId}')" id="cntFdbk">${cntFdbk}<spring:message code='forum.label.cnt.feedback'/><!-- 개의 피드백 --></a>
		</c:if>
	</div>
	</c:if>

<div id="projSendInfoBlock" class="mt10">
	<textarea id="fdbkValue" placeholder="<spring:message code='forum.label.input.feedback'/>"></textarea><!-- 피드백을 입력하세요 -->
	<div id="fdbkFileBox" class="flex-item mt4">
		<%-- 26.3.31 : 기획에서 제외됨(영역이 협소함) --%>
		<%--<button class="ui basic icon button" title="<spring:message code='forum.label.fdbk.file.attach'/>" onclick="fdbkFilePopOpen();"><!-- 파일첨부 --><i class="save icon"></i></button>

		<div class="field ui segment flex1 flex-item m0" style="height:39px;">
			<div class="flex align-items-center" id="fdbkFileViewPop"></div>
		</div>--%>

		<%-- <button class="ui basic icon button" title="<spring:message code='forum.label.fdbk.audio.attach'/>" onclick="fdbkAudioPopOpen();"><!-- 음성녹음 --><i class="microphone icon"></i></button> --%>
		<a href="javascript:valFdbk();" class="ui blue button mla"><span><spring:message code='forum.button.reg'/><!-- 등록 --></span></a>
	</div>
</div>
<div id="projFeedbackBlock" class="mt10">
	<textarea id="profMemo" style="height: 200px; max-height: unset; min-height: unset;" placeholder="<spring:message code='forum.alert.input.memo'/>">${mVO.profMemo}</textarea><!-- 메모를 입력하세요. -->
	<div class="flex-item mt4">
	<a href="javascript:submitMemo();" class="ui blue button mla"><spring:message code='forum.button.reg'/><!-- 등록 --></a>
</div>


<!-- 피드백 음석녹음 모달 팝업-->
<%--<div class="modal fade" id="fdbkAudioPop" tabindex="-1" role="dialog" aria-labelledby="audio-modal" aria-hidden="false">
	<div class="modal-dialog modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code='forum.label.feedback'/> <spring:message code='forum.label.fdbk.audio.attach'/><!-- 피드백 음성녹음 --></h4>
			</div>
			<div class="modal-body">
				<div class="modal-page">
					<div id="wrap">
						<div class="ui form" style="height:50px">
							<div id="audioRecord"></div>
						</div>
						<div class="bottom-content">
							<a class="ui blue black button toggle_btn flex-left-auto" onclick="fdbkAudioPopClose();"><spring:message code='forum.button.attaching'/><!-- 첨부하기 --></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>--%>
<!-- 피드백 음석녹음 모달 팝업-->
<!-- 피드백 작성  모달 -->
<div class="modal fade" id="fdbkListPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.button.feedback.write' />" aria-hidden="true"><!-- 피드백 작성하기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code='forum.button.feedback.write' /><!-- 피드백 작성하기--></h4>
			</div>
			<div class="modal-body">
				<iframe src="" id="fdbkListIfm" name="fdbkListIfm" width="100%" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div>
<!-- 피드백 작성  모달 -->
<script type="text/javascript">
$('iframe').iFrameResize();
</script>
