<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/score/common/score_common_inc.jsp" %>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		// 숫자로 변환
	   		$("#score01").val(1 * $("#score01").val());
	   		$("#score02").val(1 * $("#score02").val());
	   		$("#score03").val(1 * $("#score03").val());
	   		$("#score04").val(1 * $("#score04").val());
	   		$("#score05").val(1 * $("#score05").val());
	   		$("#score06").val(1 * $("#score06").val());
	   		$("#score07").val(1 * $("#score07").val());
	   		$("#score08").val(1 * $("#score08").val());
	   		$("#score09").val(1 * $("#score09").val());
	   		$("#totScoreText").text(1 * '<c:out value="${oprScoreAssistVO.totScore}" />');
		});
	   	
	 	// 저장
	   	function saveScore() {
	   		var list = [];
	   		
	   		var score01 = 1 * $("#score01").val();
			var score02 = 1 * $("#score02").val();
			var score03 = 1 * $("#score03").val();
			var score04 = 1 * $("#score04").val();
			var score05 = 1 * $("#score05").val();
			var score06 = 1 * $("#score06").val();
			var score07 = 1 * $("#score07").val();
			var score08 = 1 * $("#score08").val();
			var score09 = 1 * $("#score09").val();
			
			list.push({
				  lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				, userId			: '<c:out value="${vo.userId}" />'
				, crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, score01			: score01
				, score02			: score02
				, score03			: score03
				, score04			: score04
				, score05			: score05
				, score06			: score06
				, score07			: score07
				, score08			: score08
				, score09			: score09
			});
			
			var url = "/score/scoreMgr/saveOprScoreAssist.do";
			var data = JSON.stringify(list);
			
			$.ajax({
				url: url,
				type: "POST",
				contentType: "application/json",
				data: data,
				dataType: "json",
				beforeSend : function() {
					showLoading();
				},
				success: function(data) {
					if(data.result === 1) {
						alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
						
						if(typeof window.parent.oprScoreAssistWritePopCallback === "function") {
							window.parent.oprScoreAssistWritePopCallback();
						}
					} else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				},
				complete: function() {
					hideLoading();
				},
			});
	   	}
	   	
	 	// 입력할 수 있는 점수인지 체크
		function checkValidScore(el) {
			if(el.value == "") {
				el.value = 0;
				return;
			}
			
			var minusScore = {
				  score01: '<spring:message code="score.label.assist.oper.score01" />' // 주간운영 보고서
				, score02: '<spring:message code="score.label.assist.oper.score02" />' // 콘텐츠 검수
				, score03: '<spring:message code="score.label.assist.oper.score03" />' // 강의Q&A
				, score04: '<spring:message code="score.label.assist.oper.score04" />' // 1:1상담
			};
			
			var plusScore = {
				  score05: '<spring:message code="score.label.assist.oper.score05" />' // 강의자료실
				, score06: '<spring:message code="score.label.assist.oper.score06" />' // 메일발송
				, score07: '<spring:message code="score.label.assist.oper.score07" />' // SMS발송
				, score08: '<spring:message code="score.label.assist.oper.score08" />' // PUSH발송
				, score09: '<spring:message code="score.label.assist.oper.score09" />' // 쪽지발송
			};
			
			var name = el.name;
			
			if(minusScore[name] && 1 * el.value > 0) {
				alert("<spring:message code='score.errors.input.zero.minus' arguments='" + minusScore[name] + "'/>");
				el.value = 0;
				return;
			}
			
			if(plusScore[name] && 1 * el.value < 0) {
				alert("<spring:message code='score.errors.input.zero.plus' arguments='" + plusScore[name] + "'/>");
				el.value = 0;
				return;
			}
		}
	 	
		// 총점 계산
		function sumTotScore() {
			var score01 = 1 * $("#score01").val();
			var score02 = 1 * $("#score02").val();
			var score03 = 1 * $("#score03").val();
			var score04 = 1 * $("#score04").val();
			var score05 = 1 * $("#score05").val();
			var score06 = 1 * $("#score06").val();
			var score07 = 1 * $("#score07").val();
			var score08 = 1 * $("#score08").val();
			var score09 = 1 * $("#score09").val();
			
			var totScore = score01 + score02 + score03 + score04 + score05
				+ score06 + score07 + score08 + score09;
			
			$("#totScoreText").text(totScore);
		}
   	</script>
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
                        <td><input type="text" class="tr" id="score01" name="score01" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score01}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria1.sub2" /><!-- 콘텐츠 검수 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria1.sub2.sub1" /><!-- 각 주차 오픈 전 목요일 24시까지 등록(분반별) --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.one.per3" /><!-- 1회/차시 과목당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td><input type="text" class="tr" id="score02" name="score02" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score02}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub1" /><!-- 강의Q&A 답변 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.72h" /><!-- 질문등록 후 72시간 이내 미답변시 감점 * 교수 답변 시에는 중복 답변 불필요 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.no.answer.per" /><!-- 미답변 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td><input type="text" class="tr" id="score03" name="score03" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score03}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub2" /><!-- 1:1상담 답변--></td>
                        <td><spring:message code="score.label.assist.oper.criteria.72h" /><!-- 질문등록 후 72시간 이내 미답변시 감점 * 교수 답변 시에는 중복 답변 불필요 --></td>
                        <td><spring:message code="score.label.assist.oper.criteria.no.answer.per" /><!-- 미답변 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td><input type="text" class="tr" id="score04" name="score04" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score04}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria2.sub3" /><!-- 강의자료실--></td>
                        <td colspan="2"><spring:message code="score.label.assist.oper.criteria.lms" /><!-- LMS 등록 --> : <spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score05" name="score05" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score05}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub1" /><!-- 메일 발송 --></td>
                        <td colspan="2" rowspan="4">
                        	<div><spring:message code="score.label.assist.oper.criteria.lms.send" /><!-- LMS 발송 --> : <spring:message code="score.label.assist.oper.criteria.one.per" /><!-- 1건당 --></div>
                        	<div class="fcRed ui message">※ <spring:message code="score.label.oper.send.msg.guide" /><!-- 강의실 통합메세지로 발송해야 상점 반영됨 --></div>
                        </td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score06" name="score06" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score06}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub2" /><!-- SMS 발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score07" name="score07" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score07}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub3" /><!-- PUSH 발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score08" name="score08" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score08}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.assist.oper.criteria3.sub4" /><!-- 쪽지 발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score09" name="score09" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreAssistVO.score09}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                    	<td class="tc" colspan="4"><spring:message code="message.total" /><!-- 합계 --></td>
                    	<td class="tr"><span id="totScoreText"><c:out value="${oprScoreAssistVO.totScore}" /></span></td>
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
			<c:if test="${not empty vo.lessonScheduleId}">
			<button type="button" class="ui blue cancel button" onclick="saveScore()"><spring:message code="common.button.save" /><!-- 저장 --></button>
			</c:if>
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>