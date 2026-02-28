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
                        <th colspan="3" class="p_w50 tc"><spring:message code="score.label.item" /><!-- 항목 --></th>
                        <th class="tc"><spring:message code="score.label.criteria" /><!-- 기준 --></th>
                        <th class="w60 tc"><spring:message code="score.label.score" /><!-- 점수 --></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td rowspan="3" class="tc"><spring:message code="score.label.prof.oper.criteria1" /><!-- 학사일정 --><%-- <br>(<spring:message code="score.label.prof.oper.hand.write" /><!-- 수기입력 -->) --%></td>
                        <td rowspan="2" colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria1.sub1" /><!-- 수업계획서 입력 기간 준수 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria1.sub1.sub1" /><!-- 공문 안내 기간 미준수 시 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                    </tr>
                    <tr>                            
                        <td><spring:message code="score.label.prof.oper.criteria1.sub1.sub2" /><!-- 정규 수강신청 시작 이후 입력 시 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria1.sub2" /><!-- 종합성적 산출기간 준수 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria1.sub2.sub1" /><!-- 종합성적 산출 기간 미준수 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td rowspan="10" class="tc"><spring:message code="score.label.prof.oper.criteria2" /><!-- 수업운영 --><%-- <br>(<spring:message code="score.label.prof.oper.system.write" /><!-- 시스템 추출 -->) --%></td>
                        <td rowspan="2" colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub1" /><!-- 평가기준 활용 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub1.sub1" /><!-- 평가기준 4가지 이상 활용 시 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>                            
                        <td><spring:message code="score.label.prof.oper.criteria2.sub1.sub2" /><!-- 평가기준 5가지 이상 활용 시 --></td>
                        <td class="tc"><span class="fcBlue">+0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub2" /><!-- 평가기준 정정 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub2.sub1" /><!-- 평가기준 정정신청서 제출 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub3" /><!-- 공지사항 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub3.sub1" /><!-- 1건당 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
					<tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub4" /><!-- 강의Q&A --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub4.sub1" /><!-- 72시간 내 미답변 시 : 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub5" /><!-- 1:1상담 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria2.sub5.sub1" /><!-- 72시간 내 미답변 시 : 1건당 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td rowspan="4" class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6" /><!-- 학습독려 --></td>
                        <td class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6.sub1" /><!-- 메일발송 --></td>
                        <td rowspan="4">
                        	<div><spring:message code="score.label.prof.oper.criteria2.alarm" /><!-- 강의실 발송 : 1건당 --></div>
                        	<div class="fcRed ui message">※ <spring:message code="score.label.oper.send.msg.guide" /><!-- 강의실 통합메세지로 발송해야 상점 반영됨 --></div>
                       	</td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6.sub2" /><!-- SMS발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.prof.oper.criteria2.sub6.sub3" /><!-- PUSH발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td class="tc"><spring:message code="score.label.prof.oper.score14" /><!-- 쪽지발송 --></td>
                        <td class="tc"><span class="fcBlue">+0.1</span></td>
                    </tr>
                    <tr>
                        <td rowspan="4" class="tc"><spring:message code="score.label.prof.oper.criteria3" /><!-- 시험운영 --><%-- <br>(<spring:message code="score.label.prof.oper.hand.write" /><!-- 수기입력 -->) --%></td>
                        <td rowspan="2" colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria3.sub1" /><!-- 중간/기말 시험 출제 및 검수일 준수 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria3.sub1.sub1" /><!-- 3일 미만 지연 --></td>
                        <td class="tc"><span class="fcRed">-0.1</span></td>
                    </tr>
                    <tr>                            
                        <td><spring:message code="score.label.prof.oper.criteria3.sub1.sub2" /><!-- 3일 이상 지연 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria3.sub2" /><!-- 시험배수출제 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria3.sub2.sub1" /><!-- 3배수 이상 문제 출제 시 --></td>
                        <td class="tc"><span class="fcBlue">+0.2</span></td>
                    </tr>
                    <tr>
                        <td colspan="2" class="tc"><spring:message code="score.label.prof.oper.criteria3.sub3" /><!-- 시험중복출제 --></td>
                        <td><spring:message code="score.label.prof.oper.criteria3.sub3.sub1" /><!-- 전년도 대비 중복율 70% 이상 시 --></td>
                        <td class="tc"><span class="fcRed">-0.2</span></td>
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
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>