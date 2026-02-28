 <%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function editAttend() {
	$("#attendForm").attr("action", "/score/scoreConf/editAttend.do");
	$("#attendForm").submit();
}
</script>
<body>
<form class="ui form" name="attendForm" id="attendForm" method="POST">
	
	<div id="wrap" class="pusher">

        <!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

        <!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->
        
        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content stu_section">

				<!-- admin_location -->
				<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
				<!-- //admin_location -->
		        
				<div class="ui segment">
					<div class="ui form">
						<div class="layout2">
					    	<!-- 타이틀 -->
							<div id="info-item-box">
					        	<h2 class="page-title"><spring:message code="score.base.info.manager.label" /> > <spring:message code="score.attend.evaluation.label" /></h2>
					            <div class="button-area">
					            	<a href="javascript:editAttend()" class="ui blue button"><spring:message code="asmnt.button.save" /></a><!-- 저장 -->
					            	<a href="/score/scoreConf/attendClassList.do" class="ui blue button"><spring:message code="asmnt.button.cancel" /></a> <!-- 취소 -->
					            </div>
					        </div>

							<div class="ui styled fluid accordion type2 mt40">
						    	<div class="content">
			                        <p class="bullet_design1"><spring:message code="lesson.label.lecture.open" /></p><%-- 강의 오픈일 --%>
									<p>* <spring:message code="lesson.label.every.week" /><%-- 매주 --%>
										<select class="ui dropdown" name="openWeekVal" id="openWeekVal" title="<spring:message code="date.day.of.the.week" />"><!-- 요일 -->
											<option value="MON" <c:if test="${vo.openWeekVal eq 'MON'}">selected</c:if>><spring:message code="date.monday" /></option>
										    <option value="TUE" <c:if test="${vo.openWeekVal eq 'TUE'}">selected</c:if>><spring:message code="date.tuesday" /></option>
										    <option value="WED" <c:if test="${vo.openWeekVal eq 'WED'}">selected</c:if>><spring:message code="date.wednesday" /></option>
										    <option value="THE" <c:if test="${vo.openWeekVal eq 'THE'}">selected</c:if>><spring:message code="date.thursday" /></option>
										    <option value="FRI" <c:if test="${vo.openWeekVal eq 'FRI'}">selected</c:if>><spring:message code="date.friday" /></option>
										    <option value="SAT" <c:if test="${vo.openWeekVal eq 'SAT'}">selected</c:if>><spring:message code="date.saturday" /></option>
										    <option value="SUN" <c:if test="${vo.openWeekVal eq 'SUN'}">selected</c:if>><spring:message code="date.sunday" /></option>
						                </select>
										<input type="hidden" id="openWeekCd" name="openWeekCd" value="${vo.openWeekCd}" class="w100" maxlength="3" />
										<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="openTmVal" name="openTmVal" value="${vo.openTmVal}" class="w100" maxlength="3" />
										<spring:message code="date.hour" /><%-- 시 --%>, <spring:message code="date.platform" /><%-- 단 --%> 1<spring:message code="date.parking" /><!-- 주차는 -->
				                        <input type="hidden" id="openTmCd" name="openTmCd" value="${vo.openTmCd}" class="w100" maxlength="3" />
				                        <select class="ui dropdown" name="openWeek1ApVal" id="openWeek1ApVal" title="<spring:message code="date.day.of.the.week" />">
											<option value="AM" <c:if test="${vo.openWeek1ApVal eq 'AM'}">selected</c:if>><spring:message code="date.morning" /> </option><%-- 오전 --%>
											<option value="PM" <c:if test="${vo.openWeek1ApVal eq 'PM'}">selected</c:if>><spring:message code="date.afternoon" /> </option><%-- 오후 --%>
										</select>
										<input type="hidden" id="openWeek1ApCd" name="openWeek1ApCd" value="${vo.openWeek1ApCd}" class="w100" maxlength="3" />
										<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="openWeek1TmVal" name="openWeek1TmVal" value="${vo.openWeek1TmVal}" class="w100" maxlength="3" />
										<spring:message code="date.hour" /><%-- 시 --%>,<spring:message code="crs.attend.attendance.criteria.msg1_1" /><span class="fcBlue"><spring:message code="crs.attend.attendance.criteria.msg1_2" /></span>
					                    <input type="hidden" id="openWeek1TmCd" name="openWeek1TmCd" value="${vo.openWeek1TmCd}" class="w100" maxlength="3" />
									</p>
					              	<p class="bullet_design1 mt20"><spring:message code="seminar.label.attend.approval.day" /></p><!-- 출석인정 기간 -->
			                       	<p>
										<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="atendTermVal" name="atendTermVal" value="${vo.atendTermVal}" class="w100" maxlength="3" />
										<spring:message code="crs.attend.attendance.criteria.msg2_1" /></span><spring:message code="crs.attend.attendance.criteria.msg2_2" />
										(<spring:message code="crs.attend.attendance.criteria.msg3_1" />
											<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="atendWeekVal" name="atendWeekVal" value="${vo.atendWeekVal}" class="w100" maxlength="3" />
											<spring:message code="crs.attend.attendance.criteria.msg3_2" />)<br /> 
									</p>
									<br />
			                        <input type="hidden" id="atendTermCd" name="atendTermCd" value="${vo.atendTermCd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="atendWeekCd" name="atendWeekCd" value="${vo.atendWeekCd}" class="w100" maxlength="3" />
			                        <p class="bullet_design1 mt10"><spring:message code="crs.label.attend.standard" /><!-- 출석인정기준 --></p>
									<spring:message code="crs.attend.attendance.criteria.msg4_1" /><span class="fcRed"><spring:message code="crs.attend.attendance.criteria.msg4_2" /></span><spring:message code="crs.attend.attendance.criteria.msg4_3" /><br />
									<spring:message code="crs.attend.attendance.criteria.msg5_1" /><span class="fcRed"><spring:message code="crs.attend.attendance.criteria.msg5_2" /></span><spring:message code="crs.attend.attendance.criteria.msg5_3" />
									<br />
									<div class="scrollbox_x">
			                            <table class="tBasic mt10 min-width-1080 "> 
			                                <thead>
			                                    <tr>
													<th><spring:message code="seminar.label.attend.opportunity" /></th><!-- 출석시기 -->
													<th><spring:message code="common.label.lecture.term" /></th><!-- 강의시간 -->
													<th><spring:message code="crs.label.attend.mark" /></th><!-- 출석표시 -->
			                                    </tr>
			                                </thead>
			                                <tbody>
			                                    <tr>
									<th rowspan="2"><spring:message code="crs.attend.attendance.criteria.msg6"/></th>
									<td><spring:message code="crs.attend.attendance.criteria.msg7" /></td>
									<td class="word_break_none"><spring:message code="lesson.label.study.status.complete" />(<i class="ico icon-solid-circle fcBlue"></i>)</td>
			                                    </tr>
			                                    <tr>
									<td><spring:message code="crs.attend.attendance.criteria.msg8" /></td>
									<td class="word_break_none"><spring:message code="lesson.label.study.status.nostudy" />(<i class="ico icon-cross fcRed"></i>)</td>
			                                    </tr>
			                                    <tr>
													<th rowspan="2"><spring:message code="crs.attend.attendance.criteria.msg9" /></th>
													<td><spring:message code="crs.attend.attendance.criteria.msg10" /></td>
													<td class="word_break_none"><spring:message code="lesson.label.study.status.late" />(<i class="ico icon-triangle fcYellow"></i>)</td>
			                                    </tr>
			                                    <tr>
													<td><spring:message code="crs.attend.attendance.criteria.msg11" /></td>
													<td class="word_break_none"><spring:message code="lesson.label.study.status.nostudy" />(<i class="ico icon-cross fcRed"></i>)</td>
			                                    </tr>
			                                </tbody>
			                            </table>
			                        </div>

			                      	<%-- 
			                      	<p class="bullet_design1 mt10">강의 출석/지각/결석 기준</p>
									<br />
			                      	<p>[ 정규학기 ]</p>
			                      	<p>
			                      		매주 등록(Upload)되는 강의(Content)를<br />
										출석 : 출석 인정기간 이내 강의시간의 <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="atndRatioVal" name="atndRatioVal" value="${vo.atndRatioVal}" class="w100" maxlength="3" />% 이상 수강<br />
										지각 : 출석 인정기간 이후 강의시간의 <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateRatioVal" name="lateRatioVal" value="${vo.lateRatioVal}" class="w100" maxlength="3" />% 이상 수강<br />
										결석 : <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="absentRatioVal" name="absentRatioVal" value="${vo.absentRatioVal}" class="w100" maxlength="3" />% 미만<br />
										단, 1주차는 수강신청 정정기간을 감안하여 3주 이내 수강 시 출석으로 인정
			                         </p>
			                         <input type="hidden" id="atndRatioCd" name="atndRatioCd" value="${vo.atndRatioCd}" class="w100" maxlength="3" />
			                         <input type="hidden" id="lateRatioCd" name="lateRatioCd" value="${vo.lateRatioCd}" class="w100" maxlength="3" />
			                         <input type="hidden" id="absentRatioCd" name="absentRatioCd" value="${vo.absentRatioCd}" class="w100" maxlength="3" />
									<br /> 
									--%>

									<%-- 
			                        <p>[ 계절학기 ]</p>
			                        <p>
			                        	단기간(1개월) 운영되는 학기인 만큼  <br />
										출석 : 총 4주차(13개) 강의를 <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senLesnWeekVal" name="senLesnWeekVal" value="${vo.senLesnWeekVal}" class="w100" maxlength="3" />주 이내 강의시간의 <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senAtndRatioVal" name="senAtndRatioVal" value="${vo.senAtndRatioVal}" class="w100" maxlength="3" />% 이상 수강<br />
										지각 : 감점은 없음.<br />
										결석 : <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senAbsentRatioVal" name="senAbsentRatioVal" value="${vo.senAbsentRatioVal}" class="w100" maxlength="3" />% 미만<br />
										단, 매주 1주차(<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senLesnWeek1Val" name="senLesnWeek1Val" value="${vo.senLesnWeek1Val}" class="w100" maxlength="3" />개),
										2주차(<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senLesnWeek2Val" name="senLesnWeek2Val" value="${vo.senLesnWeek2Val}" class="w100" maxlength="3" />개), 
										3주차(<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senLesnWeek3Val" name="senLesnWeek3Val" value="${vo.senLesnWeek3Val}" class="w100" maxlength="3" />개), 
										4주차(<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="senLesnWeek4Val" name="senLesnWeek4Val" value="${vo.senLesnWeek4Val}" class="w100" maxlength="3" />개) 형태로 강의가 등록/제공
			                        </p>
			                        <input type="hidden" id="senLesnWeekCd" name="senLesnWeekCd" value="${vo.senLesnWeekCd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="senAbsentRatioCd" name="senAbsentRatioCd" value="${vo.senAbsentRatioCd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="senAtndRatioCd" name="senAtndRatioCd" value="${vo.senAtndRatioCd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="senLesnWeek1Cd" name="senLesnWeek1Cd" value="${vo.senLesnWeek1Cd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="senLesnWeek2Cd" name="senLesnWeek2Cd" value="${vo.senLesnWeek2Cd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="senLesnWeek3Cd" name="senLesnWeek3Cd" value="${vo.senLesnWeek3Cd}" class="w100" maxlength="3" />
			                        <input type="hidden" id="senLesnWeek4Cd" name="senLesnWeek4Cd" value="${vo.senLesnWeek4Cd}" class="w100" maxlength="3" />

									<p class="bullet_design1">출석평가 기준</p>
			                        <table class="tbl st2">
			                            <thead>
			                                <tr>
			                                    <th scope="col">출석 횟수</th>
			                                    <th scope="col"><c:out value="${vo.absentScoreNm5}" /></th>
			                                    <th scope="col"><c:out value="${vo.absentScoreNm4}" /></th>
			                                    <th scope="col"><c:out value="${vo.absentScoreNm3}" /></th>
			                                    <th scope="col"><c:out value="${vo.absentScoreNm2}" /></th>
			                                    <th scope="col"><c:out value="${vo.absentScoreNm1}" /></th>
			                                </tr>
			                            </thead>
			                            <tbody>
			                                <tr>
			                                    <td>출석 점수</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="absentScoreVal5" name="absentScoreVal5" value="${vo.absentScoreVal5}" class="w100" maxlength="3" />점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="absentScoreVal4" name="absentScoreVal4" value="${vo.absentScoreVal4}" class="w100" maxlength="3" />점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="absentScoreVal3" name="absentScoreVal3" value="${vo.absentScoreVal3}" class="w100" maxlength="3" />점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="absentScoreVal2" name="absentScoreVal2" value="${vo.absentScoreVal2}" class="w100" maxlength="3" />점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="absentScoreVal1" name="absentScoreVal1" value="${vo.absentScoreVal1}" class="w100" maxlength="3" />점</td>
			                                	<input type="hidden" id="absentScoreCd5" name="absentScoreCd5" value="${vo.absentScoreCd5}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="absentScoreCd4" name="absentScoreCd4" value="${vo.absentScoreCd4}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="absentScoreCd3" name="absentScoreCd3" value="${vo.absentScoreCd3}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="absentScoreCd2" name="absentScoreCd2" value="${vo.absentScoreCd2}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="absentScoreCd1" name="absentScoreCd1" value="${vo.absentScoreCd1}" class="w100" maxlength="3" />
			                                </tr>
			                            </tbody>
			                        </table>
			                        <br />
									--%>

			                        <%--
			                        <p class="bullet_design1">지각감점 기준</p>
			                        <table class="tbl st2">
			                            <thead>
			                                <tr>
			                                	<th scope="col">지각횟수</th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm1}" /></th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm2}" /></th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm3}" /></th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm4}" /></th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm5}" /></th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm6}" /></th>
			                                    <th scope="col"><c:out value="${vo.lateScoreNm7}" /></th>
			                                </tr>
			                            </thead>
			                            <tbody>
			                            	<tr>
			                                    <td rowspan="2">감점 비율</td>
			                                    <td rowspan="2"><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal1" name="lateScoreVal1" value="${vo.lateScoreVal1}" class="w100" maxlength="3" />% 감점</td>
			                                    <td colspan="6">획득한 출석 점수 기준에서</td>
			                                </tr>
			                                <tr>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal2" name="lateScoreVal2" value="${vo.lateScoreVal2}" class="w100" maxlength="3" />% 감점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal3" name="lateScoreVal3" value="${vo.lateScoreVal3}" class="w100" maxlength="3" />% 감점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal4" name="lateScoreVal4" value="${vo.lateScoreVal4}" class="w100" maxlength="3" />% 감점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal5" name="lateScoreVal5" value="${vo.lateScoreVal5}" class="w100" maxlength="3" />% 감점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal6" name="lateScoreVal6" value="${vo.lateScoreVal4}" class="w100" maxlength="3" />% 감점</td>
			                                    <td><input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="lateScoreVal7" name="lateScoreVal7" value="${vo.lateScoreVal7}" class="w100" maxlength="3" />% 감점</td>
			                                	<input type="hidden" id="lateScoreCd1" name="lateScoreCd1" value="${vo.lateScoreCd1}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="lateScoreCd2" name="lateScoreCd2" value="${vo.lateScoreCd2}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="lateScoreCd3" name="lateScoreCd3" value="${vo.lateScoreCd3}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="lateScoreCd4" name="lateScoreCd4" value="${vo.lateScoreCd4}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="lateScoreCd5" name="lateScoreCd5" value="${vo.lateScoreCd5}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="lateScoreCd6" name="lateScoreCd6" value="${vo.lateScoreCd6}" class="w100" maxlength="3" />
			                                	<input type="hidden" id="lateScoreCd7" name="lateScoreCd7" value="${vo.lateScoreCd7}" class="w100" maxlength="3" />                                    
			                                </tr>
			                            </tbody>
			                        </table> 
			                        --%>
									<br />
						            <p>
										<spring:message code="crs.attend.attendance.criteria.msg12" />
										<spring:message code="crs.attend.attendance.criteria.msg13" />
						            </p>
								</div>
			                </div>
						</div>
					</div><!-- //container -->
				</div>
            </div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>
