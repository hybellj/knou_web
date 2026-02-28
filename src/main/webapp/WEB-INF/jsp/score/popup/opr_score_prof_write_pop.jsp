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
	   		$("#score10").val(1 * $("#score10").val());
	   		$("#score11").val(1 * $("#score11").val());
	   		$("#score12").val(1 * $("#score12").val());
	   		$("#score13").val(1 * $("#score13").val());
	   		$("#score14").val(1 * $("#score14").val());
	   		$("#totScoreText").text(1 * '<c:out value="${oprScoreProfVO.totScore}" />');
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
			var score10 = 1 * $("#score10").val();
			var score11 = 1 * $("#score11").val();
			var score12 = 1 * $("#score12").val();
			var score13 = 1 * $("#score13").val();
			var score14 = 1 * $("#score14").val();
			
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
				, score10			: score10
				, score11			: score11
				, score12			: score12
				, score13			: score13
				, score14			: score14
			});
			
			var url = "/score/scoreMgr/saveOprScoreProf.do";
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
						
						if(typeof window.parent.oprScoreProfWritePopCallback === "function") {
							window.parent.oprScoreProfWritePopCallback();
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
				  score01: '<spring:message code="score.label.prof.oper.score01" />' // 수업계획서 입력기간 준수 감점
				, score02: '<spring:message code="score.label.prof.oper.score02" />' // 종합성적 산출기간 미준수 감점
				, score04: '<spring:message code="score.label.prof.oper.score04" />' // 평가기준 정정 감점
				, score06: '<spring:message code="score.label.prof.oper.score06" />' // 강의QnA 72시간 미답변 건당 감점
				, score07: '<spring:message code="score.label.prof.oper.score07" />' // 1:1상담 72시간 미답변 건당 감점
				, score11: '<spring:message code="score.label.prof.oper.score11" />' // 시험출제 및 검수지연 감점
				, score13: '<spring:message code="score.label.prof.oper.score13" />' // 시험중복출제 감점
			};
			
			var plusScore = {
				  score03: '<spring:message code="score.label.prof.oper.score03" />' // 평가기준 활용 가점
				, score05: '<spring:message code="score.label.prof.oper.score05" />' // 공지사항 건당 가점
				, score08: '<spring:message code="score.label.prof.oper.score08" />' // 학습독려 메일발송 건당 가점
				, score09: '<spring:message code="score.label.prof.oper.score09" />' // 학습독려 SMS발송 건당 가점
				, score10: '<spring:message code="score.label.prof.oper.score10" />' // 학습독려 PUSH발송 건당 가점
				, score12: '<spring:message code="score.label.prof.oper.score12" />' // 시험배수출제 가점
				, score14: '<spring:message code="score.label.prof.oper.score14" />' // 학습독려 쪽지발송 건당 가점
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
			var score10 = 1 * $("#score10").val();
			var score11 = 1 * $("#score11").val();
			var score12 = 1 * $("#score12").val();
			var score13 = 1 * $("#score13").val();
			var score14 = 1 * $("#score14").val();
			
			var totScore = score01 + score02 + score03 + score04 + score05
				+ score06 + score07 + score08 + score09 + score10
				+ score11 + score12 + score13 + score14;
			
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
                	<col>
                	<col width="60">
                	<col width="100">
                </colgroup>
                <thead>
                    <tr>
                        <th colspan="3" class="p_w50 tc"><spring:message code="score.label.item" /><!-- 항목 --></th>
                        <th colspan="2" class="tc"><spring:message code="score.label.criteria" /><!-- 기준 --></th>
                        <th class="w80 tc"><spring:message code="score.label.score" /><!-- 점수 --></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td rowspan="3" class="tc"><spring:message code="score.label.prof.oper.criteria1" /><!-- 학사일정 --></td>
                        <td rowspan="2" colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria1.sub1" /><!-- 수업계획서 입력 기간 준수 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria1.sub1.sub1" /><!-- 공문 안내 기간 미준수 시 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td rowspan="2"><input type="text" class="tr" id="score01" name="score01" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score01}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>                            
                        <td><spring:message code="score.label.prof.oper.criteria1.sub1.sub2" /><!-- 정규 수강신청 시작 이후 입력 시 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.score02" /><!-- 종합성적 산출기간 준수 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria1.sub2.sub1" /><!-- 종합성적 산출 기간 미준수 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                        <td><input type="text" class="tr" id="score02" name="score02" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score02}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td rowspan="10" class="tc"><spring:message code="score.label.prof.oper.criteria2" /><!-- 수업운영 --></td>
                        <td rowspan="2" colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub1" /><!-- 평가기준 활용 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub1.sub1" /><!-- 평가기준 4가지 이상 활용 시 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td rowspan="2"><input type="text" class="tr" id="score03" name="score03" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score03}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>                            
                        <td><spring:message code="score.label.prof.oper.criteria2.sub1.sub2" /><!-- 평가기준 5가지 이상 활용 시 --></td>
                        <td class="tc"><span class="fcBlue">+0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub2" /><!-- 평가기준 정정 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub2.sub1" /><!-- 평가기준 정정신청서 제출 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                        <td><input type="text" class="tr" id="score04" name="score04" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score04}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub3" /><!-- 공지사항 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub3.sub1" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score05" name="score05" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score05}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
					<tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub4" /><!-- 강의Q&A --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub4.sub1" /><!-- 72시간 내 미답변 시 : 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                        <td><input type="text" class="tr" id="score06" name="score06" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score06}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub5" /><!-- 1:1상담 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub5.sub1" /><!-- 72시간 내 미답변 시 : 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                        <td><input type="text" class="tr" id="score07" name="score07" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score07}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td rowspan="4" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6" /><!-- 학습독려 --></td>
                        <td class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6.sub1" /><!-- 메일발송 --></td>
                        <td rowspan="4">
                        	<div><spring:message code="score.label.prof.oper.criteria2.alarm" /><!-- 강의실 발송 : 1건당 --></div>
                        	<div class="fcRed ui message">※ <spring:message code="score.label.oper.send.msg.guide" /><!-- 강의실 통합메세지로 발송해야 상점 반영됨 --></div>
                       	</td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score08" name="score08" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score08}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6.sub2" /><!-- SMS발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score09" name="score09" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score09}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6.sub3" /><!-- PUSH발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score10" name="score10" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score10}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.prof.oper.score14" /><!-- 쪽지발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                        <td><input type="text" class="tr" id="score14" name="score14" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score14}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td rowspan="4" class="tc"><spring:message code="score.label.prof.oper.criteria3" /><!-- 시험운영 --></td>
                        <td rowspan="2" colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria3.sub1" /><!-- 중간/기말 시험 출제 및 검수일 준수 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria3.sub1.sub1" /><!-- 3일 미만 지연 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                        <td rowspan="2"><input type="text" id="score11" name="score11" class="tr" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score11}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>                            
                        <td><spring:message code="score.label.prof.oper.criteria3.sub1.sub2" /><!-- 3일 이상 지연 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria3.sub2" /><!-- 시험배수출제 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria3.sub2.sub1" /><!-- 3배수 이상 문제 출제 시 --></td>
                        <td class="tc"><span class="fcBlue">+0.2</span></td>
                        <td><input type="text" class="tr" id="score12" name="score12" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score12}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria3.sub3" /><!-- 시험중복출제 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria3.sub3.sub1" /><!-- 전년도 대비 중복율 70% 이상 시 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                        <td><input type="text" class="tr" id="score13" name="score13" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore();" onfocus="this.select()" value="<c:out value="${oprScoreProfVO.score13}" />" <c:out value="${disabled}" /> /></td>
                    </tr>
                    <tr>
                    	<td class="tc" colspan="5"><spring:message code="message.total" /><!-- 합계 --></td>
                    	<td class="tr"><span id="totScoreText"><c:out value="${oprScoreProfVO.totScore}" /></span></td>
                    </tr>
                </tbody>
            </table>
        </div>
		<div class="ui info message">
		    <ul class="list">
		        <li><spring:message code="score.label.prof.oper.criteria.guide1" /><!-- 해당 주차의 상벌점은 다음 주 목요일에 확인가능 ( 1주차 상벌점 2주차 목요일 확인 가능) --></li>
		        <li><spring:message code="score.label.prof.oper.criteria.guide2" /><!-- 평가기준 활용 항목은 15주차 수업운영 점수에 반영됨 --></li>
		        <li><spring:message code="score.label.prof.oper.criteria.guide3" /><!-- 시험운영 항목 (출제 및 검수일 준수, 배수출제, 중복출제)은 중간, 기말고사 후 담당자가 점수 등록 --></li>
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