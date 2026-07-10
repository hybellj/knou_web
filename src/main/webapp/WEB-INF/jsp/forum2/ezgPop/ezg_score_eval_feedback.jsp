<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>

<script type="text/javascript">

// 피드백 목록 팝업
function fdbkList(stdId) {
	if($('.active-toggle-btn.select').length < 1){
		UiComm.showMessage("<spring:message code='forum_ezg.label.select.empty' />", "info"); // 선택된 대상이 없습니다.
		return false;
	}

	if(!stdId) {
		UiComm.showMessage("<spring:message code='forum_ezg.alert.select.student'/>", "warning"); // 수강생을 선택해 주세요.
		return false;
	}

	var dscsId = "${dscsVO.dscsId}";
	$("form[name='dscsCreCrsStdForm'] input[name='dscsId']").val(dscsId);
	$("form[name='dscsCreCrsStdForm'] input[name='stdId']").val(stdId);
	var queryString = $("#dscsCreCrsStdForm").serialize();
	dialog = UiDialog("dialog1", {
		title: "<spring:message code='forum.button.feedback.write' />", // 피드백 작성
		width: 800,
		height: 600,
		url: "/forum2/forumLect/dscsFdbkPop.do?" + queryString + "&encParams=" + EPARAM
	});
}

</script>
<form name="dscsCreCrsStdForm" id="dscsCreCrsStdForm" method="POST">
	<input type="hidden" name="dscsId" value="${dscsVO.dscsId }">
	<input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}">
	<input type="hidden" name="stdId" value="">
	<input type="hidden" name="sbjctId" value="${dscsVO.sbjctId}">
</form>

<div class="mb5">
	<button type="button" class="btn basic width-100per" onClick="fdbkList('${dscsVO.stdId}')" id="cntFdbk">${cntFdbk}<spring:message code='forum.label.cnt.feedback'/><!-- 개의 피드백 --></button>
</div>

<div id="projSendInfoBlock" class="memoBox">
	<label for="fdbkValue"><textarea id="fdbkValue" placeholder="<spring:message code='forum.label.input.feedback'/>"></textarea></label><!-- 피드백을 입력하세요 -->
	<div id="fdbkFileBox" class="flex-item mt4">
		<%-- 26.3.31 : 기획에서 제외됨(영역이 협소함) --%>
		<%--<button class="ui basic icon button" title="<spring:message code='forum.label.fdbk.file.attach'/>" onclick="fdbkFilePopOpen();"><!-- 파일첨부 --><i class="save icon"></i></button>

		<div class="field ui segment flex1 flex-item m0" style="height:39px;">
			<div class="flex align-items-center" id="fdbkFileViewPop"></div>
		</div>--%>

		<button type="button" class="btn small type3 width-100per" onclick="valFdbk();"><span><spring:message code='forum.button.reg'/><!-- 등록 --></span></button>
	</div>
</div>
<c:if test="${not empty dscsVO.stdId}">
<div id="projFeedbackBlock" class="memoBox mt10">
	<label for="profMemo"><textarea id="profMemo" style="height: 200px; max-height: unset; min-height: unset;" placeholder="<spring:message code='forum.alert.input.memo'/>">${mVO.profMemo}</textarea></label><!-- 메모를 입력하세요. -->
	<div class="flex-item mt4">
	<button type="button" class="btn small type3 width-100per" onclick="submitMemo();"><spring:message code='forum.button.reg'/><!-- 등록 --></button>
	</div>
</div>
</c:if>
