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
		
		// 퀴즈 응시
		function quizJoin() {
			window.parent.$("form[name=${vo.goUrl}] input[name=examCd]").val("${vo.examCd}");
			window.parent.$("form[name=${vo.goUrl}] input[name=stdNo]").val("${vo.stdNo}");
			window.parent.$("form[name=${vo.goUrl}] input[name=crsCreCd]").val("${vo.crsCreCd}");
			window.parent.$("form[name=${vo.goUrl}]").attr("action", "/quiz/quizJoinPop.do");
			window.parent.$("form[name=${vo.goUrl}]").submit();
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
        		<div class="mt15 mb15 tc bcBlue fcWhite p10 wmax">
        			${creCrsVO.creYear }<spring:message code="std.label.year" />&nbsp;
        			<c:choose>
        				<c:when test="${creCrsVO.creTerm eq '10'}">
        					<spring:message code="common.haksa.term.spring" /><!-- 1학기 -->
        				</c:when>
        				<c:when test="${creCrsVO.creTerm eq '11'}">
        					<spring:message code="common.haksa.term.summer" /><!-- 여름학기 -->
        				</c:when>
        				<c:when test="${creCrsVO.creTerm eq '20'}">
        					<spring:message code="common.haksa.term.fall" /><!-- 2학기 -->
        				</c:when>
        				<c:when test="${creCrsVO.creTerm eq '21'}">
        					<spring:message code="common.haksa.term.winter" /><!-- 겨울학기 -->
        				</c:when>
        			</c:choose>&nbsp;${creCrsVO.crsCreNm }&nbsp;<spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
        		</div>
        		<ul>
        			<li><spring:message code="exam.label.quiz.test.msg1" /><span class="fcBlue">${vo.examStareTm }</span><spring:message code="exam.label.quiz.test.msg12" /></li><!-- * 해당 퀴즈의 응시 제한시간은 60분 입니다. -->
        			<li><spring:message code="exam.label.quiz.test.msg2" /></li><!-- * 최초 응시 시점부터 응시 시간이 자동으로 흘러가며, 응시 시간이 지나면 재응시가 불가능합니다. -->
        			<li><span class="fcBlue"><spring:message code="exam.label.quiz.test.msg3" /></span></li><!-- * 퀴즈 응시 중간에 창을 닫을 경우에도 응시 시간이 계속 진행 됩니다. -->
        		</ul>
        		<div class="tc mt30 wmax">
        			<p><span class="fcBlue"><spring:message code="exam.label.quiz.test.msg4" /></span></p><!-- 응시 버튼을 클릭하면 응시 시간이 진행 됩니다. -->
        			<p><spring:message code="exam.label.quiz.test.msg5" /></p><!-- 지금 응시가 어려우시면 취소를 눌러 퀴즈 응시 기간 내 재접속하시기 바랍니다. -->
        		</div>
        	</div>
	        
            <div class="bottom-content tc mt50">
                <button class="ui blue w100 button" onclick="quizJoin()"><spring:message code="exam.button.stare.start" /></button><!-- 응시 -->
                <button class="ui blue w100 button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
