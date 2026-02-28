<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/seminar/common/seminar_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		viewAtnd();
		//listHsty();
		
		$(".accordion").accordion();
	});
	
	// 목록
	function seminarList() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
		
		submitForm("/seminar/seminarHome/Form/stuSeminarList.do", "", "", kvArr);
	}
	
	// 세미나 출결 정보 조회
	function viewAtnd() {
		var url  = "/seminar/seminarHome/seminarStdView.do";
		var data = {
			"stdNo" 	: "${stdVO.stdNo}",
			"seminarId"	: "${vo.seminarId}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var html = "";
				var returnVO = data.returnVO;
				
				if(returnVO != null) {
					html += "<tr>";
					html += "	<td class='tc'>" + dateFormat("date", returnVO.atndDttm) + "</td>";
					html += "	<td class='tc'>" + dateFormat("timePad", returnVO.seminarTime) + "</td>";
					html += "	<td class='tc'>" + dateFormat("time", returnVO.atndTime) + "</td>";
					html += "	<td class='tc'>" + returnVO.seminarStatus + "</td>";
					html += "	<td class='tc'>" + attendFormat("nonsuspense", returnVO.atndCd) + "</td>";
					html += "</tr>";
				}
				
				$("#seminarAtndList").empty().html(html);
				$("#seminarAtndTable").footable();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 출결 상태 변경 이력 조회
	function listHsty() {
		var url  = "/seminar/seminarHome/seminarStdAttendLog.do";
		var data = {
			"stdNo" 	: "${stdVO.stdNo}",
			"seminarId"	: "${vo.seminarId}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = "";
				
				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						html += "<tr>";
						html += "	<td class='tc'>" + v.deviceTypeCd + "</td>";
						html += "	<td class='tc'>" + v.regIp + "</td>";
						if("${vo.seminarCtgrCd}" == "online") {
						html += "	<td class='tc'>" + dateFormat("date", v.startDttm) + "</td>";
						html += "	<td class='tc'>" + dateFormat("date", v.endDttm) + "</td>";
						}
						html += "	<td class='tc'>" + dateFormat("time", v.atndTime) + "</td>";
						html += "	<td class='tc'><spring:message code='seminar.label.attend.status.change' /> : " + attendFormat("suspense", v.atndCd) + "</td>";/* 출결상태 변경 */
						html += "</tr>";
					});
				}
				
				$("#seminarLogList").empty().html(html);
				$("#seminarLogTable").footable();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 세미나 참여
	function seminarJoin() {
		console.log(IPHONE_YN)
		if("${vo.seminarStatus}" == "완료" || "${vo.seminarStartYn}" == "N") {
			alert("<spring:message code='seminar.alert.not.seminar.date' />");/* 세미나 기간이 아닙니다. */
			return false;
		}
		
		var url  = "/seminar/seminarHome/zoomJoinStart.do";
		var data = {
			"seminarId" : "${vo.seminarId }",
			"crsCreCd"  : "${crsCreCd}",
			"stdNo"		: "${stdVO.stdNo}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				if("${IPHONE_YN}" == "Y") {
					window.location.href = data.returnVO.joinUrl;
				} else {
					var windowOpener = window.open();
					windowOpener.location = data.returnVO.joinUrl;
				}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 세미나 팝업
	function seminarPop(type) {
		var urlMap = {
			"selfEmail"  : "/seminar/seminarHome/stuSeminarSelfEmailPop.do",	// 이메일 직접 작성 후 참여
			"recordView" : "/seminar/seminarHome/recordViewPop.do"				// 녹화영상 보기
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'seminarId', 'val' : "${vo.seminarId}"});
		kvArr.push({'key' : 'zoomId', 	 'val' : "${vo.zoomId}"});
		kvArr.push({'key' : 'crsCreCd',  'val' : "${crsCreCd}"});
		
		submitForm(urlMap[type], "seminarPopIfm", type, kvArr);
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        <div class="ui form">
		        	<div class="layout2">
		        		<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="seminar.label.seminar" />', '<spring:message code="seminar.button.list" />');
						});
						</script>
				        <div id="info-item-box">
				        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="seminar.label.seminar" /><!-- 세미나 -->
                            </h2>
				            <div class="button-area">
				            	<a href="javascript:seminarList()" class="ui blue button"><spring:message code="seminar.button.list" /><!-- 목록 --></a>
				            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
								<div class="ui styled fluid accordion week_lect_list card" style="border:none;">
									<div class="title active">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.seminarStartDttm }" />
													<fmt:formatDate var="seminarStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseNumber var="hour" value="${vo.seminarTime / 60 }" integerOnly="true" />
													<fmt:parseNumber var="min" value="${vo.seminarTime % 60 }" integerOnly="true" />
													<p class="lect_name">${vo.seminarNm }</p>
													<span class="fcGrey">
														<small class="fcBlue">${vo.seminarCtgrNm }</small> | 
														<small><spring:message code="seminar.label.progress.date" /><!-- 진행일시 --> : ${seminarStartDttm }</small> | 
														<small><c:if test="${hour > 0 }">${hour }<spring:message code="seminar.label.time" /><!-- 시간 --> </c:if>${min }<spring:message code="seminar.label.min" /><!-- 분 --></small>
													</span>
												</div>
											</div>
										</div>
										<i class="dropdown icon ml20"></i>
									</div>
									<div class="content active">
										<div class="ui segment">
											<ul class="tbl" style="word-break: break-word;">
												<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="seminar.label.seminar.cts" /><!-- 세미나 내용 --></label>
														</dt>
														<dd><pre>${vo.seminarCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="seminar.label.progress.time" /><!-- 진행시간 --></label>
														</dt>
														<dd>
															<c:if test="${hour > 0 }">${hour }<spring:message code="seminar.label.time" /><!-- 시간 --> </c:if>${min }<spring:message code="seminar.label.min" /><!-- 분 -->
														</dd>
														<dt>
															<label><spring:message code="seminar.label.schedule" /><!-- 주차 -->/<spring:message code="seminar.label.lesson.time" /><!-- 교시 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${not empty vo.lessonScheduleOrder && not empty vo.lessonTimeOrder }">
																	${vo.lessonScheduleOrder }<spring:message code="seminar.label.schedule" /><!-- 주차 --> / ${vo.lessonTimeOrder }<spring:message code="seminar.label.lesson.time" /><!-- 교시 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="seminar.label.not.applicable" /><!-- 해당없음 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="seminar.label.file" /><!-- 첨부파일 --></label>
														</dt>
														<dd>
															<c:forEach var="list" items="${vo.fileList }">
																<button class="ui icon small button" id="file_${list.fileSn }" title="파일다운로드" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
																<script>
																	byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
																</script>
															</c:forEach>
														</dd>
													</dl>
												</li>
												<c:if test="${vo.seminarCtgrCd eq 'online' || vo.seminarCtgrCd eq 'free' }">
													<li>
														<dl>
															<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> ID</label></dt>
															<dd>${vo.zoomId }</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> PW</label></dt>
															<dd>${vo.zoomPw }</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> URL</label></dt>
															<dd>${vo.joinUrl }</dd>
														</dl>
													</li>
													<c:if test="${vo.attProcYn eq 'Y' }">
														<li>
															<dl>
																<dt><label><spring:message code="seminar.label.real.progress.time" /><!-- 실진행시간 --></label></dt>
																<dd class="fcBlue">
																	<fmt:parseNumber var="atndMin" value="${vo.tchAtndTime / 60 }" integerOnly="true" />
																	<fmt:parseNumber var="atndSec" value="${vo.tchAtndTime % 60 }" integerOnly="true" />
																	<c:if test="${atndMin > 0 }">${atndMin }<spring:message code="seminar.label.min" /><!-- 분 --></c:if> ${atndSec }<spring:message code="seminar.label.sec" /><!-- 초 -->
																</dd>
															</dl>
														</li>
													</c:if>
												</c:if>
											</ul>
										</div>
									</div>
								</div>
				        	</div>
				        </div>
				        <c:if test="${vo.seminarCtgrCd eq 'online' || vo.seminarCtgrCd eq 'free' }">
				        	<div class="row">
				        		<div class="col">
									<div class="ui styled fluid week_lect_list card" style="border:none;">
										<div class="content">
											<h3><c:if test="${not empty vo.lessonScheduleOrder && not empty vo.lessonTimeOrder }">${vo.lessonScheduleOrder }<spring:message code="seminar.label.schedule" /><!-- 주차 --> / ${vo.lessonTimeOrder }<spring:message code="seminar.label.lesson.time" /><!-- 교시 --> </c:if>${vo.seminarNm }</h3>
											<div class="option-content mt20">
												<div class="ui blue button p20" onclick="seminarJoin()">
													<i class="laptop icon f150"></i>
													<a class="tl fcWhite"><spring:message code="seminar.button.video.seminar.part" /><!-- 화상 세미나<br>참여하기 --></a>
												</div>
												<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.seminarStartDttm }" />
												<fmt:formatDate var="seminarStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
												<fmt:parseNumber var="hour" value="${vo.seminarTime / 60 }" integerOnly="true" />
												<c:set var="min" value="${vo.seminarTime % 60 }" />
												<ul class="ml40" style="list-style:disc;">
													<li><spring:message code="seminar.label.start.date" /><!-- 시작일시 --> : ${seminarStartDttm }</li>
													<li><spring:message code="seminar.label.progress.time" /><!-- 진행시간 --> : <c:if test="${hour > 0 }">${hour }<spring:message code="seminar.label.time" /><!-- 시간 --> </c:if>${min }<spring:message code="seminar.label.min" /><!-- 분 --></li>
												</ul>
											</div>
											<div class="mt20 p10">
												<p><spring:message code="seminar.message.zoom.info1" /><!-- * [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요. --></p>
											</div>
											<div class="mt20 p10">
												<p><spring:message code="seminar.message.zoom.info3" /><!-- * 참가에 실패하는 경우 --></p>
												<p><spring:message code="seminar.message.zoom.info4" /><!-- 화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다. --></p>
												<p><spring:message code="seminar.message.zoom.info5" /><!-- 참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다. --></p>
												<a href="javascript:seminarPop('selfEmail')" class="ui black button mt10 mb10"><spring:message code="seminar.button.self.input.email.part" /><!-- 이메일 주소 직접 등록하여 참가 --></a>
												<p><spring:message code="seminar.message.zoom.info6" /><!-- 참가 등록시 입력할 이메일 주소 --> : <span class="fcBlue"><spring:message code="seminar.message.zoom.info7" /><!-- 학번@hycu.ac.kr --></span></p>
											</div>
										</div>
									</div>
				        		</div>
				        	</div>
						</c:if>
					    <div class="row" style="<c:if test="${auditYn eq 'Y'}">display:none</c:if>">
					    	<div class="col">
								<div class="ui styled fluid week_lect_list card" style="border:none;">
									<div class="content option-content">
										<h3 class="sec_head"><spring:message code="seminar.label.attend.hsty" /><!-- 출석이력 --></h3>
										<%-- <c:if test="${vo.seminarCtgrCd eq 'online' && vo.seminarStatus eq '완료' && vo.autoRecordYn eq 'Y' }">
											<a href="javascript:seminarPop('recordView')" class="ui blue small button mla"><spring:message code="seminar.button.record.view" /><!-- 녹화영상 보기 --></a>
										</c:if> --%>
										<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="seminarAtndTable"><!-- 등록된 내용이 없습니다. -->
											<caption class="hide">Seminar</caption>
											<thead>
												<tr>
													<th class="tc"><spring:message code="seminar.label.part.date" /><!-- 참여일시 --></th>
													<th class="tc" data-breakpoints="xs sm"><spring:message code="seminar.label.study.time" /><!-- 학습시간 --></th>
													<th class="tc"><spring:message code="seminar.label.atnd.time" /><!-- 참여시간 --></th>
													<th class="tc" data-breakpoints="xs sm"><spring:message code="seminar.label.study.status" /><!-- 학습현황 --></th>
													<th class="tc"><spring:message code="seminar.label.attend.situation" /><!-- 출결상태 --></th>
												</tr>
											</thead>
											<tbody id="seminarAtndList">
											</tbody>
										</table>
										<%-- <h3 class="sec_head"><spring:message code="seminar.label.attend.status.change.hsty" /><!-- 출결 상태 변경이력 --></h3>
										<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="seminarLogTable"><!-- 등록된 내용이 없습니다. -->
											<thead>
												<tr>
													<c:if test="${vo.seminarCtgrCd eq 'online' }">
													<th class="tc" data-breakpoints="xs sm"><spring:message code="seminar.label.device" /><!-- 디바이스 --></th>
													<th class="tc" data-breakpoints="xs sm">IP</th>
													</c:if>
													<th class="tc"><spring:message code="seminar.label.start.date" /><!-- 시작일시 --></th>
													<th class="tc"><spring:message code="seminar.label.end.date" /><!-- 종료일시 --></th>
													<th class="tc"><spring:message code="seminar.label.atnd.time" /><!-- 참여시간 --></th>
													<th class="tc"><spring:message code="seminar.label.attend.type" /><!-- 출결구분 --></th>
												</tr>
											</thead>
											<tbody id="seminarLogList">
											</tbody>
										</table> --%>
									</div>
								</div>
					    	</div>
					    </div>
		        	</div>
		        </div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>

</body>

</html>

