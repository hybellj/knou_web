 <%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
 
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function editAttendClass() {
	$("#attendListForm").attr("action", "/score/scoreConf/editAttendClass.do");
	$("#attendListForm").submit();
}
</script>

<body>
	<form class="ui form" id="attendListForm" name="attendListForm" method="POST">

	<div id="wrap" class="pusher">

		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		<!-- //header -->

		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->

		<div id="container">

			<!-- 본문 content 부분 -->
			<div class="content">

				<!-- admin_location -->
				<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
				<!-- //admin_location -->

				<!-- 강의실인 경우 과목 정보 표시 -->
				<%@ include file="/WEB-INF/jsp/common/admin_info.jsp" %>

				<div class="ui segment">
					<div class="ui form">
						<div class="layout2">
							<!-- 타이틀 -->
							<div id="info-item-box">
								<h2 class="page-title"><spring:message code="score.base.info.manager.label"/> > <spring:message code="score.attend.evaluation.label"/></h2>	<!-- 성적기초정보관리 > 출석점수 기준설정 -->
								<div class="button-area">
									<a href="javascript:editAttendClass()" class="ui blue button"><spring:message code="score.attend.evaluation.button"/></a> <!-- 출석점수 기준설정 -->
								</div>
							</div>

							<!-- 출석점수기준 -->
							<div class="ui styled fluid accordion type2 mt40">
								<div class="content">
									<p class="bullet_design1"><spring:message code="lesson.label.lecture.open" /></p><%-- 강의 오픈일 --%>
									<p>* <spring:message code="lesson.label.every.week" /> <%-- 매주 --%>
										<span class="fcBlue">
											<c:choose>
												<c:when test="${vo.openWeekVal eq 'MON'}">
													<spring:message code="date.monday" /> <%-- 월요일 --%>
												</c:when>
												<c:when test="${vo.openWeekVal eq 'TUE'}">
													<spring:message code="date.tuesday" /> <%-- 화요일 --%>
												</c:when>
												<c:when test="${vo.openWeekVal eq 'WED'}">
													<spring:message code="date.wednesday" /> <%-- 수요일 --%>
												</c:when>
												<c:when test="${vo.openWeekVal eq 'THE'}">
													<spring:message code="date.thursday" /> <%-- 목요일 --%>
												</c:when>
												<c:when test="${vo.openWeekVal eq 'FRI'}">
													<spring:message code="date.friday" /> <%-- 금요일 --%>
												</c:when>
												<c:when test="${vo.openWeekVal eq 'SAT'}">
													<spring:message code="date.saturday" /> <%-- 토요일 --%>
												</c:when>
												<c:when test="${vo.openWeekVal eq 'SUN'}">
													<spring:message code="date.sunday" /> <%-- 일요일 --%>
												</c:when>
												<c:otherwise>
												</c:otherwise>
											</c:choose>
											<c:out value="${vo.openTmVal}" />
										</span>
										<spring:message code="date.hour" /><%-- 시 --%>, (<spring:message code="date.platform" /><%-- 단 --%> 1<spring:message code="date.parking" /><!-- 주차는 -->
										<span class="fcBlue">
											<c:choose>
												<c:when test="${vo.openWeek1ApVal eq 'AM'}">
													<spring:message code="date.morning" /> <%-- 오전 --%>
												</c:when>
												<c:when test="${vo.openWeek1ApVal eq 'PM'}">
													<spring:message code="date.afternoon" /> <%-- 오후 --%>
												</c:when>
												<c:otherwise>
												</c:otherwise>
											</c:choose>
											<c:out value="${vo.openWeek1TmVal}" />
										</span>
										<spring:message code="date.hour" /><%-- 시 --%>,<spring:message code="crs.attend.attendance.criteria.msg1_1" /><span class="fcBlue"><spring:message code="crs.attend.attendance.criteria.msg1_2" /></span>
										<spring:message code="crs.attend.attendance.criteria.msg1_3" />)
									</p>
									<p class="bullet_design1 mt20"><spring:message code="seminar.label.attend.approval.day" /></p><!-- 출석인정 기간 -->
									<p>
									<span class="fcBlue">* <c:out value="${vo.atendTermVal}" /><spring:message code="crs.attend.attendance.criteria.msg2_1" /></span><spring:message code="crs.attend.attendance.criteria.msg2_2" />
									(<spring:message code="crs.attend.attendance.criteria.msg3_1" /><span class="fcBlue"><c:out value="${vo.atendWeekVal}" /></span><spring:message code="crs.attend.attendance.criteria.msg3_2" /><br /> 
									</p>
									<p class="bullet_design1 mt10"><spring:message code="crs.label.attend.standard" /></p><!-- 출석인정기준 -->
									<spring:message code="crs.attend.attendance.criteria.msg4_1" /><span class="fcRed"><spring:message code="crs.attend.attendance.criteria.msg4_2" /></span><spring:message code="crs.attend.attendance.criteria.msg4_3" /><br />
									<spring:message code="crs.attend.attendance.criteria.msg5_1" /><span class="fcRed"><spring:message code="crs.attend.attendance.criteria.msg5_2" /></span><spring:message code="crs.attend.attendance.criteria.msg5_3" />
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
													<th rowspan="2"><spring:message code="crs.attend.attendance.criteria.msg6"/></th><!-- 출석인정기간 이내 모든 동영상 수강 -->
													<td><spring:message code="crs.attend.attendance.criteria.msg7" /></td><!-- 이상 수강 -->
													<td class="word_break_none"><spring:message code="seminar.label.attend" /> (<i class="ico icon-solid-circle fcBlue"></i>)</td><!-- 출석 -->
												</tr>
												<tr>
													<td><spring:message code="crs.attend.attendance.criteria.msg8" /></td><!-- 미만 수강 -->
													<td class="word_break_none"><spring:message code="seminar.label.absent" /> (<i class="ico icon-cross fcRed"></i>)</td><!-- 결석 -->
												</tr>
												<tr>
													<th rowspan="2"><spring:message code="crs.attend.attendance.criteria.msg9" /></th><!-- 출석인정기간 이후 수강 모든 동영상 수강 -->
													<td><spring:message code="crs.attend.attendance.criteria.msg10" /></td><!-- 이상 수강 -->
													<td class="word_break_none"><spring:message code="seminar.label.late" /> (<i class="ico icon-triangle fcYellow"></i>)</td><!-- 지각 -->
												</tr>
												<tr>
													<td><spring:message code="crs.attend.attendance.criteria.msg11" /></td></td><!-- 미만 수강 -->
													<td class="word_break_none"><spring:message code="seminar.label.absent" /> (<i class="ico icon-cross fcRed"></i>)</td><!-- 결석 -->
												</tr>
											</tbody>
										</table>
									</div>
									<br />
									<p>
										<spring:message code="crs.attend.attendance.criteria.msg12" />
										<spring:message code="crs.attend.attendance.criteria.msg13" />
									</p>
								</div>
							</div>
							<!-- //출석점수기준 -->
						</div>
					</div><!-- //container -->
				</div>
			</div>
		</div>
		<!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
	</form>
</body>
