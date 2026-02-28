<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   	});
	   	
	   	function popLectEvalModal() {
	   		setCookie("popLectEvalYn", "Y", 1); // 1일
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
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
        <div class="ui form">
        	<fmt:parseDate var="midLectEvalStartDttmFmt" pattern="yyyyMMddHHmmss" value="${midLectEvalStartDttm}" />
			<fmt:formatDate var="midLectEvalStartDttm" pattern="yyyy.MM.dd HH:mm" value="${midLectEvalStartDttmFmt }" />
	    	<fmt:parseDate var="midLectEvalEndDttmFmt" pattern="yyyyMMddHHmmss" value="${midLectEvalEndDttm}" />
			<fmt:formatDate var="midLectEvalEndDttm" pattern="yyyy.MM.dd HH:mm" value="${midLectEvalEndDttmFmt}" />
			
			<fmt:parseDate var="finalLectEvalStartDttmFmt" pattern="yyyyMMddHHmmss" value="${finalLectEvalStartDttm}" />
			<fmt:formatDate var="finalLectEvalStartDttm" pattern="yyyy.MM.dd HH:mm" value="${finalLectEvalStartDttmFmt }" />
	    	<fmt:parseDate var="finalLectEvalEndDttmFmt" pattern="yyyyMMddHHmmss" value="${finalLectEvalEndDttm}" />
			<fmt:formatDate var="finalLectEvalEndDttm" pattern="yyyy.MM.dd HH:mm" value="${finalLectEvalEndDttmFmt}" />
			
			<table class="tBasic">
				<tbody>
                    <tr>
                    	<td>
                    		<b>
                    			<span class="<c:if test="${midLectEvalPeriodYn eq 'Y'}">fcBlue</c:if>">* 2023년 2학기 [중간] 강의평가 기간 : <c:out value="${midLectEvalStartDttm}" /> ~ <c:out value="${midLectEvalEndDttm}" /></span><br />
                    			<span class="<c:if test="${finalLectEvalPeriodYn eq 'Y'}">fcBlue</c:if>">* 2023년 2학기 [기말] 강의평가 기간 : <c:out value="${finalLectEvalStartDttm}" /> ~ <c:out value="${finalLectEvalEndDttm}" /></span><br />
                    			<span>* 참여대상 : 수강생 전원</span>
                    		</b>
                    	</td>
                    </tr>
                    <c:if test="${midLectEvalPeriodYn eq 'Y'}">
                    <tr>
                    	<td>
                   			<div class="mb5"><b class="fcBlue">지금은 [중간 강의평가] 기간입니다.</b></div>
                   			모든 학생들은 본인이 수강한 과목에 대해서 강의평가를 실시하여 주시기 바랍니다.<br />
							강의평가는 수강생 여러분들의 의견을 수렴하기 위해 진행되는 평가로서 의무 참여사항은 아닙니다.<br />
							강의평가 결과는 학생들의 의견 수렴 및 반영, 수업의 질 향상과 교강사 평가 등을 위한 중요한 자료로 활용됩니다.<br />
							본인이 평가한 내용은 비밀이 보장됩니다.
                    	</td>
                    </tr>
                    </c:if>
                    <c:if test="${finalLectEvalPeriodYn eq 'Y'}">
                   	<tr>
                    	<td>
                   			<div class="mb5"><b class="fcBlue">[기말 강의평가] 해당사항입니다.</b></div>
                   			* 수강 과목에 대한 강의평가를 실시하지 않은 학생은 성적열람기간에 해당 과목 성적을 열람할 수 없습니다.<br />
                   			* 강의실홈에서 미완료 된 과목의 강의평가를 완료하여 주십시오<br />
                   			* 성적열람기간부터 강의평가 내용 수정은 불가합니다.
                    	</td>
                    </tr>
                    </c:if>
				</tbody>
			</table>
		</div>
		<div class="bottom-content tc">
			<div class="ui checkbox mr20" onclick="popLectEvalModal()">
                <input type="checkbox">
                <label style="color:black">하루동안 닫기</label>
            </div>			
			<c:choose>
				<c:when test="${midLectEvalPeriodYn eq 'Y'}">
					<a class="ui orange button" href="<c:out value="${lectEvalPopUrl}" />" target="_blank" onclick="window.parent.closeModal();">강의평가 참여</a>
				</c:when>
				<c:when test="${finalLectEvalPeriodYn eq 'Y'}">
					<a class="ui orange button" href="<c:out value="${lectEvalPopUrl}" />" target="_blank" onclick="window.parent.closeModal();">강의평가 참여</a>
				</c:when>
				<c:otherwise>
					<button class="ui black button" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>