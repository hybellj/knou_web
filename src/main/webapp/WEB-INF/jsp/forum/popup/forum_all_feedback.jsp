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
$(document).ready(function(){
});

//피드백 작성 
function addFdbkCts(forumFdbkCd,parForumFdbkCd){
	var fdbkCts = $("#fdbkCts").val();
	
	if(fdbkCts == null || fdbkCts == "") {
		alert("<spring:message code='forum.alert.input.feedback'/>"); //피드백을 입력해주시기 바랍니다.
	} else {
		$("#fdbkCts").val('');
		if(forumFdbkCd == "" ||forumFdbkCd == null ) {
			var url = "/forum/forumLect/allAddFdbkCts.do";
			var data = {
				"fdbkCts" : fdbkCts,
				"forumCd" : "${forumCd}",
				"userId" : "${userId}",
				"userName" : "${userName}",
				"teamCd" : $("#teamCd").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='forum.alert.reg_success.feedback'/>"); //피드백 등록에 성공하였습니다.
					// window.parent.location.reload();
					window.parent.listForumUser(1);
					window.parent.closeModal();
				} else {
					alert("<spring:message code='forum.alert.reg_fail.feedback'/>"); //피드백 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
					location.reload();
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
			}, true);
		}
	}
}
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<input type ="hidden" name="teamCd" id="teamCd">

	<div id="wrap">

		<div class="comment">
			    <div class="">
			        <ul class="comment-write">
			            <li><textarea rows="3" class="wmax" placeholder="<spring:message code="forum.label.input.feedback" />" id="fdbkCts"></textarea></li>
			            <li id="addBtn"><a class="ui basic grey small button" onclick="addFdbkCts();"><spring:message code="forum.button.reg" /><!-- 등록 --></a></li>
			        </ul>
			    </div>
		</div>
		<div class="ui small error message">
			<i class="info circle icon"></i>
			<spring:message code='forum.label.fdbk.error.message'/><!-- 전체 수강생에게 피드백 보낼 경우에만 사용하시기 바랍니다. -->
		</div>
		<div class="bottom-content mt70">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="forum.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
