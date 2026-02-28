<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		$(document).ready(function () {
			$('.ui.styled.accordion').accordion({
				exclusive: false,
				selector: {
					trigger: '.title'
				}
			});
		});
		
		// 목록
		function teamList() {
			var url = "/team/teamMgr/teamList.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "teamList");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 수정
		function teamEdit(teamCtgrCd) {
			var url = "/team/teamMgr/editTeamForm.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "teamList");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
			form.append($('<input/>', {type: 'hidden', name: 'teamCtgrCd', value: teamCtgrCd}));
			form.appendTo("body");
			form.submit();
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="teamWriteForm" name="" action="" method="POST">
		<input type="hidden" name="crsCreCd" value="${vo.crsCreCd}">
		<input type="hidden" name="teamCtgrCd" id="teamCtgrCd" value="${vo.teamCtgrCd}" />
		<input type="hidden" name="teamCd" id="teamCd" value="" />
		<input type="hidden" name="mode" id="mode" />
	</form>

	<input type="hidden" name="chkState" id="chkState" value="${empty vo.teamCtgrCd ? 'N': 'Y'}">
	<input type="hidden" name="totalStdCount" id="totalStdCount" />

	<div id="wrap" class="pusher">
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
	
		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
	
			<!-- 본문 content 부분 -->
			<!-- 팀 상세정보 시작 -->
			<div class="content stu_section">
				<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
	
				<div class="ui form">
					<div class="layout2">
						<script>
						$(document).ready(function () {
							// set location
							setLocationBar("<spring:message code='team.write.info.subTitle1'/>", "<spring:message code='team.view.info.subTitle'/>");
						});
						</script>
	
						<div id="info-item-box" class="">
							<h2 class="page-title">
								<spring:message code='team.view.info.subTitle'/><!-- 팀관리 : 팀구성 정보 -->
							</h2>
							<div class="button-area tr mt40" id="btnButton">
								<c:set var="cnt" value="${vo.asmntCnt + vo.forumCnt}" />
								<c:if test="${prevCourseYn ne 'Y'}">
									<a href="javascript:void(0)" class="ui blue button" onclick="teamEdit('${vo.teamCtgrCd}')"><spring:message code='team.common.modify'/><!-- 수정 --></a>
								</c:if>
								<a href="javascript:void(0)" class="ui blue button" onclick="teamList()"><spring:message code='team.common.list'/><!-- 목록 --></a>
								<c:if test="${vo.teamBbsYn == 'Y'}">
									<a href="javascript:void(0)" class="ui blue button" onclick="moveMenu('/bbs/bbsLect/atclList.do', null, 'TEAM');return false;"><spring:message code='team.write.field.teamBbs'/><!-- 팀 게시판 --></a>
								</c:if>
							</div>
						</div>
						<div class="row">
							<div class="col">
				
								<div class="ui segment form">
									<%-- 
									<div class="option-content">
										<button type="button" class="ui basic icon button fl" title="<spring:message code='team.common.send'/>"><!-- 보내기 -->
											<i class="file audio outline icon"></i>
											<i class="envelope outline icon"></i>
											<spring:message code='team.common.send'/><!-- 보내기 -->
										</button>
									</div>
									 --%>
									<div class="fields inline mt10">
										<spring:message code='team.write.field.teamCtgrNm'/><!-- 팀분류 명 -->
										<div class="field">
											: ${vo.teamCtgrNm}
										</div>
									</div>
									<div class="fields inline mt10">
										<spring:message code='team.write.field.teamBbs'/><!-- 팀 게시판 -->
										<div class="field">
											:
											<c:choose>
												<c:when test="${vo.teamBbsYn == 'N' || empty vo.teamBbsYn}">
													<spring:message code='team.common.use.not'/><!-- 미사용 -->
												</c:when>
												<c:otherwise>
													<spring:message code='team.common.use.yes'/><!-- 사용 -->
												</c:otherwise>
											</c:choose>
										</div>
									</div>
								</div>
	
								<div class="sixteen wide column">
									<div class="ui segment">
										<div class="option-content">
											<label for="b1" class="mra"><spring:message code='team.view.label.teamList' /><!-- 팀 목록 및 구성원 --></label>
										</div>
										<div class="ui styled fluid accordion week_lect_list">
										<c:forEach var="item" items="${list}">
											<div class="title">
												<div class="title_cont">
													<div class="left_cont">
														<div class="lectTit_box">
															<span>${item.lineNo}</span>
															<p class="lect_name">${item.teamNm}</p>
															<span class="fcGrey"><small><spring:message code='team.table.leaderNm' /><!-- 팀장 --> : ${item.leaderNm}</small> | <small><spring:message code='team.table.teamMbrCnt' /><!-- 팀 인원 --> : ${item.teamMbrCnt}</small></span>
														</div>
													</div>
												</div>
												<i class="dropdown icon ml20"></i>
											</div>
											<div class="content menu_off">
												<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty'/>"><!-- 등록된 내용이 없습니다. -->
													<thead>
														<tr>
															<th scope="col" data-type="number" class="num w100"><spring:message code="main.common.number.no" /><!-- NO. --></th>
															<th scope="col" data-breakpoints="xs" class=""><spring:message code='team.popup.deptNm'/><!-- 학과 --></th>
															<th scope="col" data-breakpoints="xs sm" class="p_w20"><spring:message code='team.popup.userId'/><!-- 학번 --></th>
															<th scope="col" class="p_w5"><spring:message code='team.popup.hy'/><!-- 학년 --></th>
															<th scope="col" class="p_w15"><spring:message code='team.popup.userNm'/><!-- 이름 --></th>
															<th scope="col" data-breakpoints="xs sm" class="p_w5"><spring:message code='team.popup.admission.year'/><!-- 입학년도 --></th>
															<th scope="col" data-breakpoints="xs sm" class="p_w5"><spring:message code='team.popup.admission.grade'/><!-- 입학학년 --></th>
															<th scope="col" data-breakpoints="xs sm" class="p_w10"><spring:message code='team.popup.admission.type'/><!-- 입학구분 --></th>
															<th scope="col" class="p_w10"><spring:message code='team.view.table.memberRole'/><!-- 구분 --></th>
														</tr>
													</thead>
													<tbody>
														<c:forEach var="memList" items="${item.teamMemberList}">
														<tr>
															<td>${memList.lineNo}</td>
															<td>${memList.deptNm}</td>
															<td>${memList.userId}</td>
															<td>${memList.hy }</td>
															<td>${memList.userNm}</td>
															<td>${memList.entrYy}</td>
															<td>${memList.entrHy}</td>
															<td>${memList.entrGbnNm}</td>
															<td>${memList.memberRole}</td>
														</tr>
														</c:forEach>
													</tbody>
												</table>
											</div>
											</c:forEach> 
											
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 팀 상세 정보 끝 -->
			<!-- //본문 content 부분 -->
	
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div>
	</div>
</body>
</html>