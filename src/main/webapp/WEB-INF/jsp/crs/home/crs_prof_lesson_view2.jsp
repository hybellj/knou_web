<%@ page import="knou.framework.util.LocaleUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="viewport" content="user-scalable=no, width=device-width"/>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<link rel="stylesheet" type="text/css" href="/webdoc/player/plyr.css?v=12" />
<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
<script type="text/javascript" src="/webdoc/player/plyr.js?v=2"></script>
<script type="text/javascript" src="/webdoc/player/player.js?v=25"></script>
<script type="text/javascript" src="/webdoc/js/crypto-js.min.js"></script>

<%
String userAgent = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent").toLowerCase() : "";
String deviceType = "PC";
String hycuappIos = "N";
String iphone = "N";

if(userAgent.indexOf("hycuapp") > -1 || userAgent.indexOf("android") > -1 || userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1) {
	deviceType = "mobile";
}
if(userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1){  
	iphone = "Y";
}
if (iphone == "Y" && userAgent.indexOf("hycuapp") > -1) {
	hycuappIos = "Y";
}

if ("mobile".equals(deviceType)) {
	%>
	<style>
		#container {
			padding:0 !important;
		}
		.layout2 .row > .col {
			padding:0 !important;
		}
		.accordionList .ui.styled.accordion .content {
			padding:0 !important;
		}
		.showCourseVideo .classInfo {
			padding-left:1em !important;
			padding-right:1em !important;
			margin-top:0;
		}
		
		.plyr .plyr__controls {
			height:60px;
		}
		
		body.play .classInfo,
		body.play .lesson.title,
		body.play #attendBaseBox {
			display:none;
		}
		body.play .layout2 .row {
			margin:0;
		}
		body.play .ui.styled.accordion.type2:not(:has(.lesson.title.active)) {
			display:none;
		}
		<%
		if ("Y".equals(iphone)) {
			%>
			.plyr--full-ui ::-webkit-media-text-track-container {
			    display: block;
			}
			<%
		}
		%>
	</style>
	<%
}
%>

	<script type="text/javascript">
		var plyrConf = localStorage.getItem("plyr");
		if (plyrConf == null) {
			localStorage.setItem('plyr', '{"quality":1080}');
		}	
		$(document).keydown( function(event) {
			if (event.keyCode == 32) {
				event.preventDefault();
			}
		});
	
		DEVICE_TYPE			= "<%=deviceType%>";
		let iPhone			= "<%=iphone%>";
		let hycuappIos 		= "<%=hycuappIos%>";
		let curCntsId		= "";
		let curPlayer 		= null;
		let isPlay			= false;
		let isCheckStart	= false;
		let checkTimeTerm	= 60;		// 체크간격(초)
		let checkTimerId	= null;
		let checkTime		= -1;
		let lessonCntsIdx   = "${lessonCntsIdx}";
		let playerList  	= [];

		$(function() {
			// 콘텐츠 타이틀 클릭시 내용 보이기
			$(".lesson.title").bind("click", function(){
				let idx = $(this).attr("idx");
				changeCntsView(idx);
			});

			// 출석기준 보이기
			$('#attendBase').bind("click", function(){
				if ($('#attendBase').siblings(".content").css("display") == "none") {
					$('#attendBase').siblings(".content").show();
					$('#attendBase').addClass("active");
				}
				else {
					$('#attendBase').siblings(".content").hide();
					$('#attendBase').removeClass("active");
				}
			});

			if (lessonCntsIdx == "") {
				lessonCntsIdx = "0"
			}

			curIdx = "";
			changeCntsView(lessonCntsIdx);
		});

		// 콘텐츠 표시 여부 변경
		function changeCntsView(idx) {
			if (curPlayer != null && curPlayer.player.playing) {
				curPlayer.pause();
			}
			
			if (idx === curIdx) {
				$("#cntsbox_"+idx).hide();
				$("#cnts_"+idx).removeClass("active");
				curIdx = "";
			}
			else {
				if (curIdx !== "") {
					$("#cntsbox_"+curIdx).hide();
					$("#cnts_"+curIdx).removeClass("active");
				}
				
				if ($("#cntsbox_"+idx).css("display") == "block") {
					$("#cntsbox_"+idx).hide();
					$("#cnts_"+idx).removeClass("active");
				}
				else {
					$("#cntsbox_"+idx).show();
					$("#cnts_"+idx).addClass("active");
					curIdx = idx;
					
					/* setTimeout(function(){
						var top = $("#cnts_"+curIdx).offset().top;
						$("#lessonViewModal", parent.document).scrollTop( top + 170 );
						$(window).scrollTop( top );
					}, 500); */
				}
			}
		}

		// 콘텐츠 바로가기 선택
		function changeCnts() {
			var idx = $("#selectCnts option:selected").val();
			
			if (curIdx != idx) {
				changeCntsView(idx);
			}
		}

		// 학습종료
		function closeLesson() {
			var crsTypeCd = "${creCrsVO.crsTypeCd}";
			var url = "";
			
			if(crsTypeCd != "UNI") {
				url = "/dashboard/dashboard.do?tabCd=" + crsTypeCd;
			} else {
				url = "/crs/crsHomeProf.do?crsCreCd=${lessonSchedule.crsCreCd}";
			}
			
	
			
			if (curPlayer != null) {
				if (curPlayer.player.playing) {
					curPlayer.player.pause();
				}
				
				document.location.href = url;
			}
			else {
				document.location.href = url;
			}
		}

		/**
		 * 학습시간 체크
		 */
		function checkPlayTime() {
			if (isPlay) {
				checkTime++;
				
				if (checkTime >= checkTimeTerm) {
					if (curPlayer != null) {
						showStudyProgInfo(curPlayer);
					}
					
					saveStudyRecord(false);
				}
				
				setTimeout("checkPlayTime()", 1000);
			}
		}

		// 학습기록 저장
		function saveStudyRecord(closeVideo) {
			// 교수는 기록 저장 안함
			checkTime = -1;
		}

		// 플레이 진행 표시
		function showStudyProgInfo(obj) {
			var sumTm = obj.playTime();
			var duration = obj.player.duration;
			var playTime = obj.playTime();
			var playlen = "0:00";
			var studyTm = "0:00";
			var prog = 0;
			
			if (obj.enablePage && obj.curPageNo != -1) {
				let pageInfo = obj.pageList[obj.curPageNo];
				if (pageInfo != null) {
					sumTm = Math.round(pageInfo.sessionTm / 1000);
				}
				if (typeof pageInfo.videoTm != undefined && pageInfo.videoTm != null) {
					duration = pageInfo.videoTm;
				}
			}
			
			if (duration > 0) {
				playlen = (duration > 60 ? parseInt(duration / 60) : "0") + ":";
				var ts = parseInt(duration % 60);
				playlen += (ts < 10 ? "0" : "") + ts;
			}
			
			if (duration > 0 && sumTm > 0) {
				studyTm = (sumTm > 60 ? parseInt(sumTm / 60) : 0) + ":";
				studyTm += parseInt(sumTm % 60) < 10 ? "0" : "";
				studyTm += parseInt(sumTm % 60);
				
				if (sumTm > duration) {
					prog = 100;
				}
				else {
					prog = parseInt((sumTm / duration) * 100);
				}
			}

			//$("#playlen_"+obj.playerIdx).html(playlen);
			//$("#playprog_"+obj.playerIdx).html(prog+"% ("+studyTm+")");
			//$("#playchart_"+obj.playerIdx).attr("style", "--value:"+prog);
		}

		// 교시 이동
		function changeLessonTime(lessonTimeId) {
			$("#lessonViewForm > input[name='lessonTimeId']").val(lessonTimeId);
			$("#lessonViewForm").attr("action", "/crs/crsProfLessonView.do");
			$("#lessonViewForm").submit();
		}
		
		// 비디오 플레이 스피드 가져오기
		function getVideoSpeed() {
			var videoSpeed = 1;
			var plyrConf = localStorage.getItem("plyr");
			if (plyrConf != null) {
				let confData = JSON.parse(plyrConf);
				if (confData.speed != undefined) {
					videoSpeed = confData.speed;
				}
			}
			
			return videoSpeed;
		}
		
		// 앱 네비바 표시 바꾸기
		function changeAppNaviBarState(state){
		    const scheme = 'smartq://hycu?action=' + state;
		    try {
		        webkit.messageHandlers.callbackHandler.postMessage(scheme); // IOS
		    } catch(err) {}

		    try{
		        window.Android.goScheme(scheme); // Andriod
		    } catch(err){}
		}
	</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
		<p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div id="container" class="ui form showCourseVideo">
	
		<div class="content stu_section"> 
            <div class="classInfo gap8"> 
                <div class="tl">
                    <h1>[${creCrsVO.crsCreNm}]
                    	<c:if test="${creCrsVO.crsTypeCd eq 'UNI'}">
                    	<%
                    	if ("en".equals(SessionInfo.getLocaleKey(request))) {
                    		%>Week ${fn:replace(lessonSchedule.lessonScheduleNm,'주차','')}<%
                    	}
                    	else {
                    		%>${lessonSchedule.lessonScheduleNm}<%
                    	}
                    	%>
                    	</c:if>
                    </h1>
                    <fmt:parseDate var="lessonStartDtFmt" pattern="yyyyMMdd" value="${not empty lessonSchedule.ltDetmFrDt ? lessonSchedule.ltDetmFrDt : lessonSchedule.lessonStartDt}" />
					<fmt:formatDate var="lessonStartDt" pattern="yyyy.MM.dd" value="${lessonStartDtFmt}" />
					<fmt:parseDate var="lessonEndDtFmt" pattern="yyyyMMdd" value="${not empty lessonSchedule.ltDetmToDt ? lessonSchedule.ltDetmToDt : lessonSchedule.lessonEndDt}" />
					<fmt:formatDate var="lessonEndDt" pattern="yyyy.MM.dd" value="${lessonEndDtFmt}" />
                    <div class="list_verticalline flex flex-wrap mb5">
                        <small><spring:message code="lesson.lecture.recomm_time"/><!-- 권장학습시간 --> : ${lessonSchedule.lbnTm}<spring:message code="lesson.label.min"/><!-- 분 --></small>
                        <small>${lessonStartDt} ~ ${lessonEndDt}</small>
                    </div>
                </div>
                
                <div class="classSection" style="align-items:flex-end;">
                    <div class="cls_btn">
                        <a href="javascript:closeLesson()" class="ui bcDarkblueAlpha85 button" title="<spring:message code="lesson.lecture.close"/>"><spring:message code="lesson.lecture.close"/><!-- 학습종료 --></a>
                    </div>
                </div>
            </div>
	
	        <div class="ui form">
	            <div class="layout2">
	                <!-- row -->
	                <div class="row">
	                    <div class="col">
					
							<div class="ui form accordionList">
							<c:forEach var="cnts" items="${lessonCntsList}" varStatus="status">
								<div class="ui styled fluid accordion type2">
									<div id="cnts_${status.index}" idx="${status.index}" cntsgbn="${cnts.cntsGbn}" class="lesson title p0" style="cursor:pointer;">
										<ul class="each_lect_list">
											<li>
												<div class="each_lect_box" data-list-num="${cnts.lessonCntsOrder}">
													<div class="each_lect_tit">
														<p>
															<span class="ui green small label"><spring:message code="common.label.lecture" /></span><!-- 강의 -->
															${cnts.lessonCntsNm}
															<%-- <small class="bullet_dot">순차학습<!-- 순차학습 --></small>--%>
														</p>
														<p class="flex-item mt5">
															<%-- <small class="bullet_dot">기간 : ${lessonSchedule.lessonStartDt} ~ ${lessonSchedule.lessonEndDt}</small> --%>
															<!-- <small class="bullet_dot">0분</small>&nbsp; -->
															<%-- 
															<small class="bullet_dot mr10">
																<c:choose>
																	<c:when test="${cnts.prgrYn eq 'Y'}">출결대상</c:when>
																	<c:otherwise>출결대상 아님</c:otherwise>
																</c:choose>
															</small>--%>
															<%-- 
															<small id="playlen_${status.index}" class="bullet_dot mr10">0:00</small>
															<small class="bullet_dot flex-inline-item">
																<span class="mr10">학습진행 :</span><i class="progressState mr5"><span id="playchart_${status.index}" class="circletype" style="--value:0"></span></i>
																<span id="playprog_${status.index}">0% (0:00)</span> 
															</small>
															--%>
														</p>
													</div>
													<div>
														<i class="dropdown icon"></i>
													</div>
												</div>
											</li>
										</ul>
									</div>
									<div id="cntsbox_${status.index}" class="content" style="display:none;<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "padding:0;" : "")%>">
										<c:choose>
											<c:when test="${cnts.cntsGbn eq 'VIDEO' or cnts.cntsGbn eq 'VIDEO_LINK'}">
												<video id="player_${status.index}" 
													title="${cnts.lessonCntsNm}" 
													data-poster="" 
													lang="<%=LocaleUtil.getLocale(request)%>" 
													continue="false" 
													continueTime="" 
													speed="true" 
													speedPlaytime="false"
													lessonTime="${lessonSchedule.lbnTm}"
													showProg="false"
													progTime="0"
													showChapter="false"
													showIndex="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "false" : "true")%>">
					
													<c:if test="${not empty cnts.lessonCntsUrl and empty cnts.pageInfo}">
														<source src="${cnts.lessonCntsUrl}" type="video/mp4" size="1080"/>									
													</c:if>
													
													<c:if test="${not empty cnts.subInfo and cnts.subInfo ne ''}">
														${cnts.subInfo}
													</c:if>
													
													<c:if test="${not empty cnts.pageInfo and cnts.pageInfo ne ''}">
														${cnts.pageInfo}
													</c:if>
												</video>
												<script type="text/javascript">
													// 플레이어 초기화
													var player_${status.index} = UiMediaPlayer("player_${status.index}");
													player_${status.index}.lessonCntsId = "${cnts.lessonCntsId}";
													player_${status.index}.prgrYn = "${cnts.prgrYn}";
													player_${status.index}.playerIdx = ${status.index};
													player_${status.index}.vidHeight = 0;
													player_${status.index}.lang = "<%=LocaleUtil.getLocale(request)%>";
													playerList.push(player_${status.index});
					
													player_${status.index}.player.on('ready', (event) => {
														var speed = getVideoSpeed();
														setTimeout(function(){
															event.detail.plyr.speed = speed;
														},500);
														
														setTimeout(function(){
															showStudyProgInfo(player_${status.index});
														}, 1000);
													});
													
													player_${status.index}.player.on('pause', (event) => {
														isPlay = false;
														showStudyProgInfo(player_${status.index});
														saveStudyRecord();
														
														/*
														if (DEVICE_TYPE == "mobile") {
															event.detail.plyr.fullscreen.exit();
															$("body").removeClass("play");
														}
														*/
													});
													
													player_${status.index}.player.on('play', (event) => {
														curPlayer = player_${status.index};
														isPlay = true;
														checkPlayTime();
														
														if (DEVICE_TYPE == "mobile") {
															//모바일에서 자동 fullscreen 설정 X
															//event.detail.plyr.fullscreen.enter();
														}
														
														resizePayerBox(true);
													});
													
													player_${status.index}.player.on('exitfullscreen', (event) => {
														if (DEVICE_TYPE == "mobile") {
															if (iPhone == "N") {
																if (player_${status.index}.vidHeight > 0) {
																	$(".plyr.plyr--full-ui.plyr--video").css("height", player_${status.index}.vidHeight+"px");
																}
															}
															changeAppNaviBarState("showBar");
														}
														
														resizePayerBox(true);
													});
													
													player_${status.index}.player.on('enterfullscreen', (event) => {
														if (DEVICE_TYPE == "mobile") {
															if (iPhone == "Y") {
																$(".plyr.plyr--full-ui.plyr--video").css("height", "");
															}
															changeAppNaviBarState("hideBar");
														}
														
														resizePayerBox(false);
													});
													
													// 플레이어 높이 조절
													function resizePayerBox(resize) {
														var video = $("#"+curPlayer.player.playerId);
														var videoWrpr = video.parent();
														
														if (resize == true) {
															var vidRatio = video[0].videoHeight / video[0].videoWidth;
															var vidHeight = videoWrpr.width() * vidRatio;
															if (vidHeight > 720) vidHeight = 720;
															if (videoWrpr.height() < vidHeight) {
																if($(window).height() < vidHeight) {
																	videoWrpr.height(100+"%");
																} else {
																	videoWrpr.height(vidHeight);
																}
															}
														}
														else {
															videoWrpr.height(100+"%");
														}
													}
												</script>
											</c:when>
											<c:when test="${cnts.cntsGbn eq 'PDF' or cnts.cntsGbn eq 'FILE'}">
												<c:forEach items="${cnts.fileList}" var="file">
													<div>
														<a href="<%=CommConst.CONTEXT_FILE_DOWNLOAD%>?path=${file.downloadPath}" class="fcBlue"><c:out value="${file.fileNm}" /></a>
													</div>
												</c:forEach>
											</c:when>
											<c:when test="${cnts.cntsGbn eq 'SOCIAL'}">
												<c:choose>
													<c:when test="${fn:contains(cnts.lessonCntsUrl, 'iframe')}">
														${cnts.lessonCntsUrl}
													</c:when>
													<c:otherwise>
														<a href="<c:out value="${cnts.lessonCntsUrl}" />" class="fcBlue" target="_blank"><c:out value="${cnts.lessonCntsUrl}" /></a>
													</c:otherwise>
												</c:choose>
											</c:when>
											<c:when test="${cnts.cntsGbn eq 'LINK'}">
												<a href="<c:out value="${cnts.lessonCntsUrl}" />" class="fcBlue" target="_blank"><c:out value="${cnts.lessonCntsUrl}" /></a>
											</c:when>
											<c:when test="${cnts.cntsGbn eq 'TEXT'}">
												${cnts.cntsText}
											</c:when>
										</c:choose>
									</div>
								</div>
							</c:forEach>
							</div>
						</div><!-- //col -->
					</div><!-- //row -->
				</div><!-- //layout2 -->
			</div><!-- //ui form -->
	
			<!-- 출석점수기준 -->
			<c:if test="${creCrsVO.crsTypeCd eq 'UNI'}">
			<div class="ui styled fluid accordion type2 week_lect_list mt20">
				<div id="attendBase" class="title flex-item" style="cursor:pointer;">
					<div class="mra"><b><spring:message code="score.attend.evaluation" /></b></div>	<%-- 출석 점수 기준 --%>
					<div>
						<i class="dropdown icon"></i>
					</div>
				</div>
				<div class="content">
					<p class="bullet_design1"><spring:message code="lesson.label.lecture.open" /></p>	<%-- 강의 오픈일 --%>
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
						</span><spring:message code="date.hour" /><%-- 시 --%>, (<spring:message code="date.platform" /><%-- 단 --%> 1<spring:message code="date.parking" /><!-- 주차는 --> 
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
						<spring:message code="date.hour" /><%-- 시 --%>, <spring:message code="crs.attend.attendance.criteria.msg1_1" /><span class="fcBlue"><spring:message code="crs.attend.attendance.criteria.msg1_2" /></span>
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
					<br />
					<div class="scrollbox_x">
						<table class="tBasic mt10 min-width-1080 "> 
							<thead>
								<tr>
									<th><spring:message code="seminar.label.attend.opportunity" /></th><!-- 출석시기 -->
									<th><spring:message code="lesson.label.lecture.time" /></th><!-- 강의시간 -->
									<th><spring:message code="crs.label.attend.mark" /></th><!-- 출석표시 -->
								</tr>
							</thead>
							<tbody>
								<tr>
									<th rowspan="2"><spring:message code="crs.attend.attendance.criteria.msg6" /></th>
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
					<br />
					<p>
					<spring:message code="crs.attend.attendance.criteria.msg12" />
					<spring:message code="crs.attend.attendance.criteria.msg13" />
					</p>
				</div>
			</div>
			</c:if>
			<!-- //출석점수기준 -->
		</div><!-- //content stu_section -->
		</div><!-- //container -->
	</div>

	<form id="lessonViewForm" name="lessonViewForm" method="post">
		<input type="hidden" name="crsCreCd" value="${lessonSchedule.crsCreCd}" />
		<input type="hidden" name="lessonScheduleId" value="${lessonSchedule.lessonScheduleId}" />
		<input type="hidden" name="lessonCntsIdx" value="0" />
		<input type="hidden" name="lessonTimeId" value="" />
	</form>
</body>