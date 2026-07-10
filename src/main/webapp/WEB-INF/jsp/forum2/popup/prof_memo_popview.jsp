<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
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
    		UiComm.showMessage("<spring:message code='forum.alert.memo.insert' />", "success"); // 메모 저장이 완료되었습니다.
    		window.parent.listForumUser(1);
    		window.parent.closeDialog();
        } else {
         	UiComm.showMessage(data.message, "error");
        }
	}, function(xhr, status, error) {
		UiComm.showMessage("<spring:message code='forum.alert.memo.error' />", "error");// 메모 저장 중 에러가 발생하였습니다.
	}, true);
}
</script>
<style type="text/css">
	.board_top.class > span { display: none; }
	.board_top.class > .right-area > b { display: none; }
</style>

<body class="modal-page ${uiex:getTheme()}">
	<div id="wrap">
		<div class="board_top class">
			<%
				String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
			%>
			<h3 class="board-title"><%=sbjctnm%></h3>
			<div class="right-area">
				<div class="feedback-info">
					<p class="desc">
						<span><strong>${dscsJoinUserVO.deptnm }</strong></span>
						<span><strong>${dscsJoinUserVO.stdntNo }</strong></span>
						<span><strong>${dscsJoinUserVO.userNm }</strong></span>
						<span class="score">
							<strong>
								<c:choose>
									<c:when test="${not empty dscsJoinUserVO.scr}">
										${dscsJoinUserVO.scr}<spring:message code="forum.label.point" />
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</strong>
						</span>
					</p>
				</div>
				<b>
					${dscsJoinUserVO.deptNm } ${dscsJoinUserVO.stdntNo } ${dscsJoinUserVO.userNm }
					<span class="f150">
						<c:choose>
							<c:when test="${not empty dscsJoinUserVO.scr}">
								${dscsJoinUserVO.scr}<spring:message code="forum.label.point" />
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose>
					</span>
				</b><!-- 점 -->
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
