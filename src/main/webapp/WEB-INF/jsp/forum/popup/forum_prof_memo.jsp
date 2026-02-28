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
$(document).ready(function() {
});

// 메모 저장
function saveProfMemo() {
	var url  = "/forum/forumLect/editForumProfMemo.do";
	var data = {
		"forumCd"  	: "${forumCd}",
		"stdNo" 	: "${stdNo}",
		"profMemo"	: $("#profMemo").val()
	};
	
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
    		alert("<spring:message code='forum.alert.memo.insert' />"); // 메모 저장이 완료되었습니다.
    		window.parent.listForumUser(1);
    		window.parent.closeModal();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.alert.memo.error' />");// 메모 저장 중 에러가 발생하였습니다.
	}, true);
}
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap">
		<div class="option-content">
			<h2 class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="forum.label.decls.name" />)</h2><!-- 반 -->
			<div class="mla fcBlue">
				<b>${vo.deptNm } ${vo.userId } ${vo.userNm } <span class="f150">${vo.score}<spring:message code="forum.label.point" /></span></b><!-- 점 -->
			</div>
		</div>
		<%--
		<div class="option-content">
			<span>이수구분 : ${creCrsVO.compDvNm } | 관상학과 : ${creCrsVO.deptNm }</span>
		</div>
		--%>
		<div class="ui segment">
			<h3 class="mb10">${vo.forumTitle }</h3>
			<%--
			<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumStartDttm }" />
			<fmt:formatDate var="forumStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
			<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.forumEndDttm }" />
			<fmt:formatDate var="forumEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
			<p><spring:message code="forum.label.forum.date" /> : ${forumStartDttm} ~ ${forumEndDttm}</p><!-- 토론기간 -->
			--%>
		</div>
		<div>
			<textarea id="profMemo" rows="10" cols="30">${vo.profMemo}</textarea>
		</div>

		<div class="bottom-content mt70">
			<button class="ui blue button" onclick="saveProfMemo()"><spring:message code="forum.button.save" /></button><!-- 저장 -->
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="forum.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
