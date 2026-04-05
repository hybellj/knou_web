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
$(document).ready(function() {
});

// 메모 저장
function saveProfMemo() {
	var url  = "/forum2/forumLect/editDscsProfMemo.do";
	var data = {
			"dscsId"  	: "${dscsId}",
		"stdId" 	: "${stdId}",
		"profMemo"	: $("#profMemo").val()
	};
	
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
    		alert("<spring:message code='forum.alert.memo.insert' />"); // 메모 저장이 완료되었습니다.
    		window.parent.listForumUser(1);
    		window.parent.closeDialog();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.alert.memo.error' />");// 메모 저장 중 에러가 발생하였습니다.
	}, true);
}
</script>

<body class="modal-page">
	<div id="wrap">
		<div class="msg-box basic board_top">
			<span>${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="forum.label.decls.name" />)</span><!-- 반 -->
			<div class="right-area fcBlue">
				<b>${dscsJoinUserVO.deptNm } ${dscsJoinUserVO.userId } ${dscsJoinUserVO.userNm } <span class="f150">${dscsJoinUserVO.score}<spring:message code="forum.label.point" /></span></b><!-- 점 -->
			</div>
		</div>
		<div class="field ui fluid input">
			<textarea id="profMemo" style="width:100%;height:100px;resize: none;" maxLenCheck="byte,4000,true,true">${dscsJoinUserVO.profMemo}</textarea>
		</div>

		<div class="btns">
			<button class="btn type1" onclick="saveProfMemo()"><spring:message code="forum.button.save" /></button><!-- 저장 -->
			<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="forum.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
<%--	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>--%>
</body>
</html>
