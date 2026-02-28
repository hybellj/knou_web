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
	var url  = "/score/scoreOverall/updateStdMemo.do";
	var data = {
		stdNo : "${vo.stdNo}"
	  , profMemo : $("#profMemo").val()
	  , crsCreCd : "${vo.crsCreCd}"
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			/* 저장되었습니다 */
    		alert('<spring:message code="info.regok.msg" />');
    		window.parent.closeModal();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
	});
}
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap">
		<div class="option-content">
			<h2 class="page-title">${cVo.crsCreNm } (${cVo.declsNo }<spring:message code="asmnt.label.decls.name" />)</h2><!-- 반 -->
		</div>
		<div class="option-content">
			<span><spring:message code="crs.label.compdv" />${cVo.compDvNm } | <spring:message code="common.phy.dept_name" /> : ${cVo.deptNm }</span>	<!-- 이수구분 관상학과 -->
		</div>
		<div>
			<textarea id="profMemo" rows="10" cols="30">${dVo.profMemo}</textarea>
		</div>

		<div class="bottom-content mt70">
			<button class="ui blue button" onclick="saveProfMemo()"><spring:message code="exam.button.save" /></button><!-- 저장 -->
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
