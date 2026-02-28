<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/score/common/score_common_inc.jsp" %>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<c:if test="${empty vo.lessonScheduleId}">
				<c:set var="disabled" value="disabled" />
			</c:if>
            <table class="tBasic table-layout-fixed word-break-keep-all mt10 "> 
                <colgroup>
                	<col>
                	<col>
                	<col>
                	<col width="60">
                	<col width="100">
                </colgroup>
                <thead>
                    <tr>
                        <th class="tc"><spring:message code="score.label.eval.item" /><!-- 평가요소 --></th>
                        <th class="tc"><spring:message code="score.label.score.check" /><!-- 점수체크 --></th>
                        <th class="tc p_w40" colspan="2"><spring:message code="score.label.criteria" /><!-- 기준 --></th>
                        <th class="w60 tc"><spring:message code="score.label.score" /><!-- 점수 --></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria1.sub1" /><!-- 주간운영보고서 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria1.sub1.sub1" /><!-- 주차 종료 후 수요일 24시까지 등록(분반별) --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per2" /><!-- 1회/수 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score01}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria1.sub2" /><!-- 콘텐츠 검수 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria1.sub2.sub1" /><!-- 각 주차 오픈 전 목요일 24시까지 등록(분반별) --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per3" /><!-- 1회/차시 과목당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score02}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub1" /><!-- 강의Q&A 답변 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.72h" /><!-- 질문등록 후 72시간 이내 미답변시 감점 * 교수 답변 시에는 중복 답변 불필요 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.no.answer.per" /><!-- 미답변 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score03}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub2" /><!-- 1:1상담 답변--></td>
                        <td><spring:message code="score.label.assist.oper.criteria.72h" /><!-- 질문등록 후 72시간 이내 미답변시 감점 * 교수 답변 시에는 중복 답변 불필요 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.no.answer.per" /><!-- 미답변 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score04}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub3" /><!-- 강의자료실--></td>
                        <td><spring:message code="score.label.assist.oper.criteria.lms" /><!-- LMS 등록 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score05}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub1" /><!-- 메일 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.lms.send" /><!-- LMS 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score06}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub2" /><!-- SMS 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.lms.send" /><!-- LMS 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score07}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub3" /><!-- PUSH 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.lms.send" /><!-- LMS 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score08}" /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub4" /><!-- 쪽지 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.lms.send" /><!-- LMS 발송 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td class="tc"><c:out value="${oprScoreAssistVO.score09}" /></td>
                    </tr>
                    <tr>
                    	<td class="tc" colspan="4"><spring:message code="message.total" /><!-- 합계 --></td>
                    	<td class="tc"><span id="totScoreText"><c:out value="${oprScoreAssistVO.totScore}" /></span></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ui info message">
            <ul class="list">
            	<li><spring:message code="score.label.prof.oper.criteria.guide1" /><!-- 해당 주차의 상벌점은 다음 주 목요일에 확인가능 ( 1주차 상벌점 2주차 목요일 확인 가능) --></li>
                <li>
            		<i class="info circle icon"></i><spring:message code="score.label.assist.oper.criteria1" /><!-- 수업운영지원 -->
            		<br />
            		- <spring:message code="score.label.assist.oper.criteria.guide1" /><!-- 등록 마감일 이후 활동은 평가에 미반영 -->
            		<br />
            		- <spring:message code="score.label.assist.oper.criteria.guide2" /><!-- 콘텐츠가 없는 주차는 ‘콘텐츠 없음’으로 선택하여 콘텐츠 검수 등록 -->
            	</li>
            </ul>
        </div>
		<div class="bottom-content tr">
			<button type="button" class="ui black cancel button" onclick="window.parent.closeAssistDetailModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>