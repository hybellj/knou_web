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
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
            <table class="tBasic table-layout-fixed word-break-keep-all mt10 "> 
                <thead>
                    <tr>
                        <th class="p_w20 tc"><spring:message code="common.type" /><!-- 구분 --></th>
                        <th class=" tc"><spring:message code="score.label.eval.item" /><!-- 평가요소 --></th>
                        <th class=" tc"><spring:message code="score.label.score.check" /><!-- 점수체크 --></th>
                        <th class="tc p_w20"><spring:message code="score.label.criteria" /><!-- 기준 --></th>
                        <th class="w60 tc"><spring:message code="score.label.score" /><!-- 점수 --></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td rowspan="2" class="tc"><spring:message code="score.label.assist.oper.criteria1" /><!-- 수업운영지원 --></td>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria1.sub1" /><!-- 주간운영보고서 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria1.sub1.sub1" /><!-- 주차 종료 후 수요일 24시까지 등록(분반별) --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per2" /><!-- 1회/수 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria1.sub2" /><!-- 콘텐츠 검수 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria1.sub2.sub1" /><!-- 각 주차 오픈 전 목요일 24시까지 등록(분반별) --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per3" /><!-- 1회/차시 과목당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                    </tr>
                    <tr>
                        <td rowspan="3" class="tc"><spring:message code="score.label.assist.oper.criteria2" /><!-- 학습활동지원 --></td>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub1" /><!-- 강의Q&A 답변 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.72h" /><!-- 질문등록 후 72시간 이내 미답변시 감점 * 교수 답변 시에는 중복 답변 불필요 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.no.answer.per" /><!-- 미답변 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub2" /><!-- 1:1상담 답변--></td>
                        <td><spring:message code="score.label.assist.oper.criteria.72h" /><!-- 질문등록 후 72시간 이내 미답변시 감점 * 교수 답변 시에는 중복 답변 불필요 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.no.answer.per" /><!-- 미답변 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub3" /><!-- 강의자료실--></td>
                        <td colspan="2"><spring:message code="score.label.assist.oper.criteria.lms" /><!-- LMS 등록 --> : <spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td rowspan="4" class="tc"><spring:message code="score.label.assist.oper.criteria3" /><!-- 학습독려 및 상담 --></td>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub1" /><!-- 메일 발송 --></td>
                        <td colspan="2" rowspan="4">
                        	<div><spring:message code="score.label.assist.oper.criteria.lms.send" /><!-- LMS 발송 --> : <spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></div>
                        	<div class="fcRed ui message">※ <spring:message code="score.label.oper.send.msg.guide" /><!-- 강의실 통합메세지로 발송해야 상점 반영됨 --></div>
                        </td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub2" /><!-- SMS 발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub3" /><!-- PUSH 발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub4" /><!-- 쪽지 발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
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
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>