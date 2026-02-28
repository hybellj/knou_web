<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<style type="text/css">
		
	</style>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		function closeModalWithCookie() {
	   		setCookie("${popupNoticeVO.popNoticeSn}", "Y", "${popupNoticeVO.noMoreDay}"); // n일
	   		window.parent.closeModal();
	   	}
	   	
	   	function setCookie(name, value, days) {
		    var expires = "";
		    if (days) {
		        var date = new Date();
		        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		        expires = "; expires=" + date.toUTCString();
		    }
		    document.cookie = name + "=" + value + expires + "; path=/";
		}
	</script>
</head>
<body class="modal-page">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<div class="ui segment view p0 m0">
				<div class="ui message p0 m0">
					${popupNoticeVO.noticeCnts}
				</div>
			</div>
		</div>
		<div class="bottom-content tc">
            <c:if test="${popupNoticeVO.popTypeCd eq 'EVAL'}">
            <a class="ui orange button" href="<c:out value="${lectEvalPopUrl}" />" target="_blank">강의평가 참여</a>
			</c:if>
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
			<c:if test="${popupNoticeVO.noMoreDayUseYn eq 'Y'}">
				<c:choose>
					<c:when test="${pageType eq 'PREVIEW'}">
						<div class="ui checkbox mr20" onclick="window.parent.closeModal();">
			                <input type="checkbox">
			                <label style="color:black">${popupNoticeVO.noMoreDay}일동안 닫기</label>
			            </div>
					</c:when>
					<c:otherwise>
						<div class="ui checkbox mr20" onclick="closeModalWithCookie();">
			                <input type="checkbox">
			                <label>${popupNoticeVO.noMoreDay}일동안 닫기</label>
			            </div>
					</c:otherwise>
				</c:choose>
            </c:if>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>