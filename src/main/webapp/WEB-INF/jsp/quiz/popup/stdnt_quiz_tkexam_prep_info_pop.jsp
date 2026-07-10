<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
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
		// 퀴즈응시
		function quizTkexam() {
			window.parent.quizTkexamPopup("${vo.examBscId }", "${vo.examDtlId }");
		}
	</script>

	<body class="modal-body">
		<%
            String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
        %>
		<div class="tit_divider mb30 mt10">${vo.sbjctYr }<spring:message code="common.year" /><!--  --> ${vo.sbjctSmstr }<spring:message code="common.term" /><!-- 학기 --> <%=sbjctnm%><spring:message code="quiz.label.is.quiz" /><!-- 의 퀴즈 --></div>
		<div class="msg-box basic mb40">
            <ul class="list-asterisk">
                <li><spring:message code="quiz.label.tkexam.info1" arguments="${vo.examMnts }" /><!-- 해당 퀴즈의 응시 제한시간은 <b class="blue">{0}분</b> 입니다. --></li>
                <li><spring:message code="quiz.label.tkexam.info2" /><!-- 최초 응시 시점부터 응시 시간이 자동으로 흘러가며, 응시 시간이 지나면 재응시가  불가능합니다. --></li>
                <li><spring:message code="quiz.label.tkexam.info3" /><!-- <b class="blue">퀴즈 응시 중간에 창을 닫을 경우에도 응시 시간이 계속 진행</b> 됩니다. --></li>
            </ul>
        </div>
        <div class="text-center mb40">
            <spring:message code="quiz.label.tkexam.info4" /><!-- <b class="fcRed">응시 버튼을 클릭하면 응시 시간이 진행</b>됩니다. --><br>
            <spring:message code="quiz.label.tkexam.info5" /><!-- 지금 응시가 어려우시면 취소를 눌러 퀴즈 응시 기간 내에 재 접속하시기 바랍니다. -->
        </div>

		<div class="modal_btns">
        	<button class="btn type1" onclick="quizTkexam();"><spring:message code="quiz.button.tkexam" /></button><!-- 응시하기 -->
        	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.cancel" /></button><!-- 취소 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
