<%@page import="knou.framework.util.CommonUtil"%>
<%@ page import="knou.framework.util.LocaleUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html  lang="ko">
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
String deviceType = CommonUtil.getDeviceType(request);
String hycuappIos = "N";
String iPhone = "N";
String menuType = SessionInfo.getAuthrtGrpcd(request);

if(userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1){  
	iPhone = "Y";
}
if (iPhone == "Y" && userAgent.indexOf("hycuapp") > -1) {
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
		if ("Y".equals(iPhone)) {
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
		// 플레이어 에러, 이전 페이지 URL
		var crsTypeCd = "${creCrsVO.crsTypeCd}";
		var returnUrl;
		
		if(crsTypeCd != "UNI") {
			var menuType = '<%=menuType%>';
			
			if(menuType.indexOf('PROFESSOR') > -1) {
				returnUrl = "/dashboard/profDashboard.do?tabCd=" + crsTypeCd;
			} else {
				returnUrl = "/dashboard/stuDashboard.do?tabCd=" + crsTypeCd;
			}
		} else {
			returnUrl = "/crs/crsHomeStd.do?crsCreCd=${lessonSchedule.crsCreCd}";
		}
	
		var plyrConf = localStorage.getItem("plyr");
		if (plyrConf == null) {
			localStorage.setItem('plyr', '{"quality":1080}');
		}
		else {
			var plyrConfObj = JSON.parse(plyrConf);
			if (plyrConfObj.speed > 1.8) {
				plyrConfObj.speed = 2;
				localStorage.setItem('plyr', JSON.stringify(plyrConfObj));
			}
		}
	
		$(document).keydown( function(event) {
			if (event.keyCode == 32) {
				event.preventDefault();
			}
		});
		
		var userId = "${userId}";
		var stdNo = "${stdNo}";
		if (userId == "" || stdNo == "") {
			/* 정보가 올바르지 않습니다. 학습창을 닫고 다시 접속해주세요. */
			alert('<spring:message code="crs.fail.information.err.msg1" />');
			document.location.href = returnUrl;
		}
		
		if (self.window.name.indexOf("LessonViewWindow") != 0) {
		 	self.window.name = "LessonViewWindow";
		 	let stdyCheckTime = localStorage.getItem("STDY_CHEK");
			if (stdyCheckTime != null && (new Date().getTime() - stdyCheckTime) < 3000) {
				alert("<spring:message code='lesson.alert.message.duplicate_win'/>"); //학습창은 중복으로 열 수 없습니다. 하나의 학습창에서만 학습하세요.
				document.location.href = returnUrl;
			}
		}
		
		DEVICE_TYPE			= "<%=deviceType%>";
		let iPhone			= "<%=iPhone%>";
		let hycuappIos 		= "<%=hycuappIos%>";
		let closeLessonWin  = false;
		let studyStatusCd	= "${studyStateVO.studyStatusCd}";
		let curIdx 			= "";
		let curPlayer 		= null;
		let isPlay			= false;
		let isCheckStart	= false;
		let checkTimeTerm	= 180;		// 체크간격(초)
		let checkTimerId	= null;
		let checkTime		= -1;
		let attendYn		= "Y";
		let totPlayTime 	= 0;
		let startTime 		= 0;
		let studySumTm		= 0;
		let playerList  	= [];
		let playStartDttm	= "";
		let lessonCntsIdx   = "${lessonCntsIdx}";
		let playTimeEx		= 0;
		let playTimeEx2		= 0;
		let prvChkTime 		= 0;
		let studySaveErrorCount = 0;
		let lbnTm			= ${lessonSchedule.lbnTm == null ? 0 : lessonSchedule.lbnTm};
		if (lbnTm > 0) {
			lbnTm = lbnTm * 60;
		}
		let newTotPlayTime	= 0;
		let prevTimeupdateTime = 0;
		let newTimeupdateTime = 0;
		let timeUpdateCnt = 0;
		let ltDetmToDtMaxOverYn = "N"; // 학습인정 최대일 초과 체크
		let studyWindowId = "<c:out value='${studyWindowId}'/>";
		
		let studyRecordList	= [];
		<c:set var="studyProgTm" value="0" scope="page" />
		<c:forEach var="record" items="${studyRecordList}" varStatus="status">
			studyRecordList.push({lessonCntsId:'${record.lessonCntsId}', studyCnt:${record.studyCnt+1}, 
				studyTotalTm:${record.studyTotalTm}, studyAfterTm:${record.studyAfterTm}, studyStatusCd:'${record.studyStatusCd}'});
			studySumTm += ${record.studyTotalTm};
			<c:set var="studyProgTm" value="${studyProgTm + record.studyTotalTm + record.studyAfterTm}" />
		</c:forEach>
		
		$(function() {
			changeAppNaviBarState("showBar");
			
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
			//checkPlayTime();
			
			if(DEVICE_TYPE == "PC") {
				setUniqueTab();
			}
		});
		
		function setUniqueTab() {
			try {
				if(typeof BroadcastChannel !== "undefined") {
					const channel = new BroadcastChannel("tab_channel");

					// 현재 열린 탭이 있는지 체크
					channel.postMessage("check");
					channel.onmessage = (event) => {
						if (event.data === "check") {
							channel.postMessage("exists");
						} else if (event.data === "exists") {
							alert("<spring:message code='lesson.alert.message.duplicate_win'/>"); // 학습창은 중복으로 열 수 없습니다. 하나의 학습창에서만 학습하세요.
							document.location.href = returnUrl;
						}
					};
					$(window).on("beforeunload.BroadcastChannel", function() {
						channel.close();
						console.log("BroadcastChannel close");
					});
				}
				
			} catch (e) {
				console.log("BroadcastChannel set Error", e);
			}
		}
		
		// 콘텐츠 표시 여부 변경
		function changeCntsView(idx) {
			if (curPlayer != null && curPlayer.player.playing) {
				saveStudyRecord("close");
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
					
					/*
					setTimeout(function(){
						var top = $("#cnts_"+curIdx).offset().top;
						$("#lessonViewModal", parent.document).scrollTop( top + 170 );
					}, 500);*/
				}
			}
		}

		// 학습종료
		function closeLesson() {
			localStorage.removeItem("STDY_CHEK", 0);
			self.window.name = "";
			
			if (curPlayer != null) {
				closeLessonWin = true;
				
				// 학습기록 저장안됐을 경우 저장하고 종료
				if (timeUpdateCnt > 0) {
					saveStudyRecord("close");
				}
				else {
					setTimeout(function(){
						document.location.href = returnUrl;	
					},300);	
				}
			}
			else {
				document.location.href = returnUrl;
			}
		}
		
		var lessonViewDialog = null;
		
		// Q&A, 메모 등록 팝업
		function popWrite(type) {
			var typeMap = {
				"qna" : {
					"url" 	  : "/bbs/bbsLect/popup/qnaWrite.do",
					"text"	: "<spring:message code='lesson.label.qna.write.text' />",/* Q&A 바로 등록 */
					"message" : "<spring:message code='lesson.alert.start.study.write.qna' />"/* 학습시작 후 Q&A 등록 가능합니다. */
				},
				"memo" : {
					"url" 	  : "/lesson/lessonPop/lessonStudyMemoWritePop.do",
					"text" 	  : "MEMO",
					"message" : "<spring:message code='lesson.alert.start.study.write.memo' />"/* 학습시작 후 메모 등록 가능합니다. */
				}
			};
			if(curPlayer != null) {
				let crsCreCd = "${lessonSchedule.crsCreCd}";
				let lessonScheduleId = "${lessonSchedule.lessonScheduleId}";
				let lessonCntsId = curPlayer.lessonCntsId;
				let studySessionLoc = curPlayer.currentTime();
				let popWidth = 650;
				let popHeight = 500;
				
				lessonViewDialog = UiDialog("lessonView", typeMap[type]["text"], "width="+popWidth+",height="+popHeight+",resizable=true,draggable=true,modal=false,fullscreen=false", "");
				lessonViewDialog.html("<iframe id='lessonPopIframe' name='lessonPopIframe' frameborder='0' scrolling='auto' style='width:100%;height:98%' src='about:blank'></iframe>");
				lessonViewDialog.dialog("option", "position", {my:"right top", at:"right top", of:$(curPlayer.videoWrapper)});
				lessonViewDialog.open();
				if (DEVICE_TYPE == "mobile") {
					lessonViewDialog.setFullscreen();
				}

				$("#lessonPopForm > input[name='crsCreCd']").val(crsCreCd);
				$("#lessonPopForm > input[name='lessonScheduleId']").val(lessonScheduleId);
				$("#lessonPopForm > input[name='lessonCntsId']").val(lessonCntsId);
				$("#lessonPopForm > input[name='studySessionLoc']").val(studySessionLoc);
				//$("#lessonPopForm").attr("target", "lessonPopIfm");
				$("#lessonPopForm").attr("target", "lessonPopIframe");
				$("#lessonPopForm").attr("action", typeMap[type]["url"]);
				$("#lessonPopForm").submit();
				
				/*
				$("#modal-pop-title").text(typeMap[type]["text"]);
				$('#lessonPopModal').modal('show');
				$('iframe').iFrameResize();
				*/
				
				window.closeModal = function() {
					$('.modal').modal('hide');
					lessonViewDialog.close();
				};
				
				$("#lessonPopForm > input[name='crsCreCd']").val("");
				$("#lessonPopForm > input[name='lessonScheduleId']").val("");
				$("#lessonPopForm > input[name='lessonCntsId']").val("");
				$("#lessonPopForm > input[name='studySessionLoc']").val("");
				
			} else {
				alert(typeMap[type]["message"]);
			}
		}
		
		
		var checkPlayInterval = null;
		function checkPlayTime() {
			if (checkPlayInterval == null) {
				checkPlayInterval = setInterval(checkPlayTimeProc, 1000);
			}
			
			$(window).on("beforeunload.checkPlayTime", () => {
				// 학습기록 저장안됐을 경우 저장하고 종료
				if (timeUpdateCnt > 0) {
					setTimeout(function() {
						saveStudyRecord("close");
						localStorage.removeItem("STDY_CHEK", 0);
					}, 0);
				}
			});
		}
		
		/**
		 * 학습시간 체크
		 */
		function checkPlayTimeProc() {
			try {
				//outputLog("checkPlayTime : cnt:"+checkTime+", play:"+isPlay+", totTime:"+getTotTime()+", speedChk:"+curPlayer.speedPlaytime + ", speed:"+curPlayer.player.speed+", uptimecnt="+timeUpdateCnt);
				checkTime++;
				
				let saveType = "noplay";
				let curTime = new Date().getTime();
				if (prvChkTime == 0) {
					prvChkTime = curTime;
				}
				
				if (isPlay || (curPlayer != null && curPlayer.player.playing)) {
					saveType = "play";
					
					if (curPlayer != null) {
						showStudyProgInfo(curPlayer);
					}
					
					if (curPlayer.attendYn == "Y" && curTime > prvChkTime && (curTime-prvChkTime) < 3000) {
						if (curPlayer.speedPlaytime == true && curPlayer.player.speed > 1) {
							playTimeEx = playTimeEx + ((curTime-prvChkTime) * curPlayer.player.speed);
						}
						else {
							playTimeEx = playTimeEx + (curTime-prvChkTime);
						}
					}
					
					if (curPlayer == null || curPlayer.attendYn != "N") {
						if (curPlayer.speedPlaytime == true && curPlayer.player.speed > 1) {
							playTimeEx2 += (1 * curPlayer.player.speed);
						}
						else {
							playTimeEx2++;	
						}
					}
				}
				
				// 지정된 시간마다 저장 호출
				if (checkTime >= checkTimeTerm) {
					saveStudyRecord(saveType);
					checkTime = 0;
				}
				
				localStorage.setItem("STDY_CHEK", new Date().getTime());
				prvChkTime = curTime;
				
				/*
				setTimeout(function(){
					checkPlayTime();
				}, 1000);
				*/
			}
			catch (e) {
				curPlayer.player.pause();
				alert('<spring:message code="lesson.error.study.record" />');
				document.location.href = returnUrl;
			}
		}

		// get 플레이 시간 합계
		function getTotTime() {
			let totTime = 0;
			totTime = Math.ceil(newTotPlayTime / 1000);
			
			return totTime;
		}

		// 콘텐츠 바로가기 선택
		function changeCnts() {
			var idx = $("#selectCnts option:selected").val();
			
			if (curIdx != idx) {
				changeCntsView(idx);
			}
		}
		
		
		// 학습기록 저장
		function saveStudyRecord(type) {
			var crsTypeCd = "${creCrsVO.crsTypeCd}";
			var currentTermYn = "${currentTermYn}";
			
			try {
				<%
				// 교수의 학생모드는 학습기록 안함
				if (isVirtualMode == true) {
					%>
					return;
					<%
				}
				%>
				
				// 현재학기만 학습기록
				if(currentTermYn != "Y" && crsTypeCd != "LEGAL") {
					return;
				}
				
				if (curPlayer == null) {
					return;
				}
				
				let totTime = getTotTime();
				let playTime = curPlayer.playTime();
				let currentTime = curPlayer.currentTime();
				let pageCnt = -1;
				let studyCnt = 1;
				let studyTotalTm = 0;
				let studyAfterTm = 0;
				let pageSessionTm = 0;
				let studyStatusCd = "";
				let pageStudyTm = 0;
				let pageStudyTmSp = 0;
				let pageStudyCnt = 1;
				let cntsRatio = 0;
				let pageRatio = 0;
				let pageAtndYn = "Y";
				let playSpeed = curPlayer.player.speed;
				let exChkPlayTime = Math.ceil(playTimeEx / 1000);
				
				if (curPlayer.player.speed > 1.8) {
					playSpeed = 2;
				}
				
				if (totTime < exChkPlayTime) {
					totTime = exChkPlayTime;
				}
				if (totTime < playTimeEx2) {
					totTime = Math.ceil(playTimeEx2);
				}
				
				if (currentTime >= curPlayer.player.duration - 10) {
					currentTime = 0;
				}
				
				if (curPlayer.enablePage && curPlayer.curPageNo != -1) {
					let pageInfo = curPlayer.pageList[curPlayer.curPageNo];
					pageCnt = pageInfo.pageCnt;
					pageAtndYn = pageInfo.attendYn;
					
					pageStudyTm = pageInfo.studyTm;
					pageStudyCnt = parseInt(pageInfo.studyCnt) + 1;
					pageSessionTm = Math.ceil(pageInfo.sessionTmSp / 1000);
					
					let videoTm = typeof curPlayer.videoTm == undefined ? 0 : curPlayer.videoTm;
					if (videoTm == 0) {
						videoTm = curPlayer.player.duration;
					}
					
					if (curPlayer.player.duration > 0 && videoTm > curPlayer.player.duration) {
						videoTm = curPlayer.player.duration;
					}
					
					if (videoTm > 0) {
						pageRatio = pageInfo.prgrRatio;
						
						if (pageRatio < 100) {
							pageRatio = Math.ceil(((parseInt(pageStudyTm) + pageSessionTm) / videoTm) * 100.0);
							if (pageRatio >= 99) {
								pageRatio = 100;
							}
						}
					}
				}
				
				for (var i=0; i<studyRecordList.length; i++) {
					if (studyRecordList[i].lessonCntsId == curPlayer.lessonCntsId) {
						studyCnt = studyRecordList[i].studyCnt;
						studyTotalTm = studyRecordList[i].studyTotalTm;
						studyAfterTm = studyRecordList[i].studyAfterTm;
						studyStatusCd = studyRecordList[i].studyStatusCd;
						break;
					}
				}
				
				if (!curPlayer.enablePage) {
					// 단독 동영상....
					let ssTime = studyTotalTm + studyAfterTm + totTime;
					if (curPlayer.player.duration > 0) {
						cntsRatio = parseInt((ssTime / curPlayer.player.duration) * 100);
						if (cntsRatio > 100) {
							cntsRatio = 100;
						}
					}
				}
				
				var data = {
						userId: "${userId}",
						stdNo: "${stdNo}",
						crsCreCd : "${lessonSchedule.crsCreCd}",
						lessonScheduleId: "${lessonSchedule.lessonScheduleId}",
						lessonStartDt: "${lessonSchedule.lessonStartDt}",
						lessonEndDt: "${lessonSchedule.lessonEndDt}",
						ltDetmToDtMax: "${lessonSchedule.ltDetmToDtMax}",
						speedPlayTime: "${speedPlayTime}",
						lbnTm: ${lessonSchedule.lbnTm},
						studyCnt: studyCnt,
						lessonCntsId: curPlayer.lessonCntsId,
						lessonTimeId: "${lessonTime.lessonTimeId}",
						studyStatusCd: studyStatusCd,
						prgrYn: curPlayer.prgrYn,
						studySessionTm: totTime,
						studyTotalTm: studyTotalTm,
						studyAfterTm: studyAfterTm,
						studySumTm: studySumTm,
						cntsPlayTm: playTime,
						studySessionLoc: currentTime,
						pageCnt: pageCnt,
						pageSessionTm: pageSessionTm,
						pageStudyTm: pageStudyTm,
						pageStudyCnt: pageStudyCnt,
						cntsRatio: cntsRatio,
						pageRatio: pageRatio,
						pageAtndYn: pageAtndYn,
						saveType: type,
						playSpeed: playSpeed,
						playStartDttm: playStartDttm
				};
				
				outputLog("save................");
				//outputLog(data);
				
				$.ajax({
					url : "/lesson/stdy/saveStdyRecord.do",
					data: data,
					type: "POST",
					success : function(data, status, xr){
						outputLog("save result............ "+data.result);
						
						if (data.result == -1) {
							curPlayer.player.pause();
							alert('<spring:message code="lesson.error.study.record" />\n(LOGIN ERROR)'); // 오류가 발생하여 학습기록을 정상적으로 저장하지 못하였습니다.\n학습창을 닫은 후 다시 학습을 진행해주세요.
							document.location.href = returnUrl;
						}
						else if (data.result == -2) {
							curPlayer.player.pause();
							alert('<spring:message code="lesson.alert.message.multi_study" />'); // 다른 장치에서 중복 로그인하였습니다. 학습을 계속할 수 없습니다.
							document.location.href = "/";
						}
						else if (data.result == -3) {
							curPlayer.player.pause();
							alert('<spring:message code="lesson.alert.message.multi_study" />'); // 다른 장치에서 중복 로그인하였습니다. 학습을 계속할 수 없습니다.
							document.location.href = "/sso/SPLogout.jsp";
						}
						else if (data.result == -4) {
							curPlayer.player.pause();
							alert('<spring:message code="lesson.error.study.record" />\n(SERVER ERROR)'); // 오류가 발생하여 학습기록을 정상적으로 저장하지 못하였습니다.\n학습창을 닫은 후 다시 학습을 진행해주세요.
							document.location.href = "/sso/SPLogout.jsp";
						}
						else if (data.result == -5) {
							curPlayer.player.pause();
							alert('<spring:message code="lesson.alert.message.duplicate_win_other" />'); // 다른 장치에서 중복으로 학습창을 열었습니다. 하나의 학습창에서만 학습하세요.
							document.location.href = "/";
						}
						else {
							// success
							studySaveErrorCount = 0;
							if (studyStatusCd != "COMPLTE" && data.result == "100") {
								$("#atndComplete").show();
								studyStatusCd = "COMPLETE";
							}
						}
						
						if (closeLessonWin == true) {
							document.location.href = returnUrl;
						}
					},
					error : function(xhr, status, error){
						studySaveErrorCount++;
						outputLog("save connection error..."+studySaveErrorCount);
						
						if (studySaveErrorCount > 2) {
							curPlayer.player.pause();
							alert('<spring:message code="lesson.error.study.record" /> \n(CONNECTION ERROR ' + studySaveErrorCount+")"); // 오류가 발생하여 학습기록을 정상적으로 저장하지 못하였습니다.\n학습창을 닫은 후 다시 학습을 진행해주세요.
							document.location.href = returnUrl;
						}
						
						if (closeLessonWin == true) {
							document.location.href = returnUrl;
						}
					},
					timeout:20000
				});
				
				if (type != undefined && type == "close") {
					curIdx = "";
					curPlayer.pause();
					curPlayer = null;
				}
				checkTime = -1;
				timeUpdateCnt = 0;
			}
			catch (e) {
				curPlayer.player.pause();
				alert('<spring:message code="lesson.error.study.record" />\n(BROWSER ERROR)');
				document.location.href = returnUrl;
			}
		}

		// 플레이 진행 표시
		function showStudyProgInfo(obj) {
			var recData = null;
			var sumTm = obj.playTime();
			var duration = obj.player.duration;
			var playTime = obj.playTime();
			var playlen = "0:00";
			var studyTm = "0:00";
			var prog = 0;
			var pageInfo = null;
			
			if (typeof obj.videoTm != undefined && obj.videoTm > 0) {
				duration = obj.videoTm;
			}
			
			for (var i=0; i<studyRecordList.length; i++) {
				if (studyRecordList[i].lessonCntsId == obj.lessonCntsId) {
					recData = studyRecordList[i];
					break;
				}
			}
			
			if (duration > 0) {
				playlen = (duration > 60 ? parseInt(duration / 60) : "0") + ":";
				var ts = parseInt(duration % 60);
				playlen += (ts < 10 ? "0" : "") + ts;
			}
			
			if (recData != null && obj.prgrYn == "Y") {
				sumTm += parseInt(recData.studyTotalTm) + parseInt(recData.studyAfterTm);
			}
			
			if (obj.enablePage && obj.curPageNo != -1) {
				pageInfo = obj.pageList[obj.curPageNo];
				if (pageInfo != null) {
					sumTm = parseInt(pageInfo.studyTm) + Math.round(pageInfo.sessionTmSp / 1000);
				}
			}
			
			if (duration > 0 && sumTm > 0) {
				studyTm = (sumTm > 60 ? parseInt(sumTm / 60) : 0) + ":";
				studyTm += parseInt(sumTm % 60) < 10 ? "0" : "";
				studyTm += parseInt(sumTm % 60);
				
				if (sumTm >= (duration-5)) {
					prog = 100;
				}
				else {
					prog = parseInt((sumTm / duration) * 100);
				}
			}
			
			let totProgTime;
			if(ltDetmToDtMaxOverYn == "Y") {
				totProgTime = obj.progTime;
			} else {
				totProgTime = obj.progTime + (obj.totPlayTime / 1000);
			}
			
			let lessonTime = obj.lessonTime == 0 ? 1 : obj.lessonTime;
			let totProgRate = parseInt((totProgTime / lessonTime) * 100);
			if (totProgRate > 100) totProgRate = 100;
			
			let totProgTimeStr = (totProgTime > 60 ? parseInt(totProgTime / 60) : 0) + ":";
			totProgTimeStr += parseInt(totProgTime % 60) < 10 ? "0" : "";
			totProgTimeStr += parseInt(totProgTime % 60);
			
			$("#weekTotProg").html(totProgRate+"% ("+totProgTimeStr+")");
			
			if (pageInfo != null) {
				if (pageInfo.prgrRatio >= 100) {
					prog = 100;
				}
				
				pageInfo.prgrRatio = prog;
				var pageObj = $("#"+pageInfo.id);
				pageObj.find(".prgr-ratio").html(prog);
				
				var progState = $("#"+obj.player.playerId+"_page"+obj.curPageNo).find(".progressState");
				progState.attr("style", "--value:"+(prog < 1 ? 0.1 : prog));
				progState.attr("data-value", (prog < 1 ? 0.1 : prog));
			}
		}
		
		// 교시 이동
		function changeLessonTime(lessonTimeId) {
			$("#lessonViewForm > input[name='lessonTimeId']").val(lessonTimeId);
			$("#lessonViewForm").attr("action", "/crs/crsStdLessonView.do");
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
		
		// Fullscreen 닫을때 App에 정보 호출
		function closeFullForApp() {
		    if (hycuappIos == "Y") {
			    try {
			    	const scheme2 = 'smartq://hycu?action=closeFullScreen';
				    webkit.messageHandlers.callbackHandler.postMessage(scheme2); // IOS 
			    } catch(err) {}
		    }			
		}
		
		// console log
		var showLog = true;
		function outputLog(log) {
			if (showLog) {
				console.log(log);
			}
		}
		
		// 학습주차 체크
		function checkStdySchedule(checkType) {
			var deferred = $.Deferred();
			
			var url = "/lesson/stdy/checkStdySchedule.do";
			var data = {
				  crsCreCd: "${lessonSchedule.crsCreCd}"
				, lessonScheduleId: "${lessonSchedule.lessonScheduleId}"
				, stdNo: "${stdNo}"
			};
			
			try {
				ajaxCall(url, data, function(data) {
					
					if(data.result > 0) {
						var returnVO = data && data.returnVO || {};
						
						if(checkType == "ltDetmToDtMax") {
							ltDetmToDtMaxOverYn = returnVO.ltDetmToDtMaxOverYn || "N";
						}
						
						deferred.resolve();
		        	} else {
		        		console.log("학습주차 체크 실패");
		        		deferred.reject();
		        	}
				}, function(xhr, status, error) {
					console.log("학습주차 체크 실패 Ajax");
					deferred.reject();
				});
			} catch (e) {
				console.log("학습주차 체크 실패 Fn", e);
				deferred.reject();
			}
		
			return deferred.promise();
		}
	</script>
	
	<style>
		@media screen and (max-width: 800px) {
			.lec-loc {
				display:none;
			}
		}
		.lec-loc a:active, .lec-loc a:hover {
		    outline: 0;
		    color: #000;
		    text-shadow: 0px 0px 0px rgba(0, 0, 0, .3);			
		}
		.lec-loc::after {
		    content: "";
		    display: inline-block;
		    width: 8px;
		    height: 8px;
		    border-right: 1px solid currentColor;
		    border-top: 1px solid currentColor;
		    transform-origin: right bottom;
		    transform: rotate(45deg);
		    margin-right: calc(1em * .8);
		}		
	</style>
	
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
		<p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div id="container" class="ui form showCourseVideo">
	
		<div id="main_menu" class="content stu_section"> 
            <div class="classInfo gap8"> 
                <div class="tl">
                    <div class="mb10" style="display:flex">
                    	<span style="display:inline-block"><a href="<%=SessionInfo.getCurUserHome(request)%>" class="home r_btn mr5"><img src="/webdoc/img/location_home.gif" alt="<spring:message code="button.go.home" />"></a></span>
                    	<span class="lec-loc">
                    	 	<a href="<%=SessionInfo.getCurUserHome(request)%>" style="color:currentColor"><spring:message code="bbs.label.bbs_lect_home" /></a>
                    	</span>
                    	<span class="lec-loc">
	                    	<a href="<%=SessionInfo.getCurCorHome(request)%>?crsCreCd=<%=SessionInfo.getCurCrsCreCd(request)%>" style="color:currentColor"><spring:message code="common.log.classroom.home" /><!-- 과목홈 --></a>
                    	</span>
                    	<span class="f150 ml10">
	                    	[${creCrsVO.crsCreNm}]
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
                    	</span>
                    </div>
                    <div class="list_verticalline flex flex-wrap mb5">
                        <small><spring:message code="lesson.lecture.recomm_time"/><!-- 권장학습시간 --> : ${lessonSchedule.lbnTm}<spring:message code="lesson.label.min"/><!-- 분 --></small>
                        <small><spring:message code="lesson.lecture.progress"/><!-- 학습진행 --> : <span id="weekTotProg">0% (0:00)</span></small>
                        <small id="atndComplete"
                        	<c:if test="${studyStateVO.studyStatusCd == 'COMPLETE'}">style="display:block"</c:if>
                        	<c:if test="${studyStateVO.studyStatusCd != 'COMPLETE'}">style="display:none"</c:if>
                        	>
                            <div class="ui green label small">
                                <i class="check circle outline icon "></i><spring:message code="lesson.lecture.atnd_complte"/><!-- 출석완료 -->
                            </div>
                        </small>
                    </div>
                    
                    <fmt:parseDate var="lessonStartDtFmt" pattern="yyyyMMdd" value="${lessonSchedule.lessonStartDt}" />
					<fmt:formatDate var="lessonStartDt" pattern="yyyy.MM.dd" value="${lessonStartDtFmt}" />
					<fmt:parseDate var="lessonEndDtFmt" pattern="yyyyMMdd" value="${lessonSchedule.lessonEndDt}" />
					<fmt:formatDate var="lessonEndDt" pattern="yyyy.MM.dd" value="${lessonEndDtFmt}" />
                    <c:choose>
						<c:when test="${lessonSchedule.lessonScheduleStat == 'PROGRESS'}">
							<small class="ui info message p5" style="letter-spacing: -1.0px;">
								<i class="info circle icon mr0"></i>
								<span><spring:message code="lesson.alert.message.attend.avail_period"/><!-- 출석인정 기간입니다. --></span>
								<span class="ml5">${lessonStartDt} ~ ${lessonEndDt}</span>
							</small>
						</c:when>
						<c:when test="${lessonSchedule.lessonScheduleStat == 'END'}">
							<small class="ui error message p5" style="letter-spacing: -1.5px;">
								<i class="info circle icon mr0"></i>
								<span><spring:message code="lesson.alert.message.attend.noavail_period"/><!-- 출석인정 기간이 마감되었습니다. --></span>
								<span class="ml5" style="letter-spacing: -0.8px; font-size: 0.90em;">${lessonStartDt} ~ ${lessonEndDt}</span>
							</small>
						</c:when>
					</c:choose>
					
					<div class="mt10">
					<small class="ui info message p5" style="display: block;">
						<i class="info circle icon mr0"></i>
						<span><spring:message code="lesson.alert.message.attend.playspeed"/><!-- 배속으로 학습할 경우 실제 시간과 다를 수 있습니다. --></span>
					</small>
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
									<!-- 주자 openYn 상태가 N 이고, LCDMS 동영상이면 SKIP -->
									<c:if test="${not(lessonSchedule.openYn ne 'Y' and cnts.cntsGbn eq 'VIDEO_LINK')}">
										<div class="ui styled fluid accordion type2">
											<div id="cnts_${status.index}" idx="${status.index}" cntsgbn="${cnts.cntsGbn}" class="lesson title p0">
												<ul class="each_lect_list">
													<li>
														<div class="each_lect_box" data-list-num="${cnts.lessonCntsOrder}">
															<div class="each_lect_tit">
																<p>
																	<span class="ui green small label"><spring:message code="lesson.label.lecture.lesson"/><!-- 강의 --></span>
																	${cnts.lessonCntsNm}
																</p>
															</div>
															<div>
																<i class="dropdown icon"></i>
															</div>
														</div>
													</li>
												</ul>
											</div>
											<div id="cntsbox_${status.index}" class="content active" style="display:none;<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "padding:0;" : "")%>">
												<c:choose>
													<c:when test="${cnts.cntsGbn eq 'VIDEO' or cnts.cntsGbn eq 'VIDEO_LINK'}">
														
													
														<video id="player_${status.index}" 
															title="${cnts.lessonCntsNm}" 
															data-poster="" 
															lang="<%=LocaleUtil.getLocale(request)%>" 
															continue="false" 
															continueTime="" 
															speed="true" 
															speedPlaytime="${speedPlayTime}"
															lessonTime="${lessonSchedule.lbnTm}"
															showProg="${cnts.prgrYn eq 'Y' ? true : false}"
															progTime="${cnts.prgrYn eq 'Y' ? studyProgTm : 0}"
															showChapter="false"
															startPageIndex="${startPageIndex}"
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
															
															<!-- 확장 버튼 추가 (플레이어 상단) -->
															<ext-btn>
																<btn-item>
																	<text>Q&A</text>
																	<onclick>popWrite("qna")</onclick>
																	<class>qna</class>
																</btn-item>
																<btn-item>
																	<text>MEMO</text>
																	<onclick>popWrite("memo")</onclick>
																	<class>memo</class>
																</btn-item>
															</ext-btn>
														</video>
														<script type="text/javascript">
															// 플레이어 초기화
															var player_${status.index} = UiMediaPlayer("player_${status.index}");
															player_${status.index}.lessonCntsId = "${cnts.lessonCntsId}";
															player_${status.index}.prgrYn = "${cnts.prgrYn}";
															player_${status.index}.playerIdx = ${status.index};
															player_${status.index}.pageProgCheckTime = 0;
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
																	closeLessonWin = false;
																}, 1000);
																
																player_${status.index}.vidHeight = $(".plyr.plyr--full-ui.plyr--video").find("video").height();
															});
															
															player_${status.index}.player.on('pause', (event) => {
																isPlay = false;
																showStudyProgInfo(player_${status.index});
																saveStudyRecord("pause");
																
																if (DEVICE_TYPE == "mobile") {
																	//event.detail.plyr.fullscreen.exit();
																	//$("body").removeClass("play");
																}
															});
															
															player_${status.index}.player.on('play', (event) => {
																curPlayer = player_${status.index};
																isPlay = true;
																let date = new Date();
																playStartDttm = (date.getHours() < 10 ? "0"+date.getHours() : date.getHours()) 
																		+ ":" + (date.getMinutes() < 10 ? "0"+date.getMinutes() : date.getMinutes())
																		+ ":" + (date.getSeconds() < 10 ? "0"+date.getSeconds() : date.getSeconds());
																
																if (curPlayer.curPageNo != null && curPlayer.curPageNo > -1) {
																	let pageInfo = curPlayer.pageList[curPlayer.curPageNo];
																	if (typeof pageInfo.attendYn != undefined) {
																		attendYn = pageInfo.attendYn;
																	}
																	else {
																		attendYn = "Y";
																	}
																}
																
																if (typeof curPlayer.attendYn == undefined) {
																	curPlayer.attendYn = null;
																}
																
																if (DEVICE_TYPE == "mobile") {
																	//모바일에서 자동 fullscreen 설정 X
																	//event.detail.plyr.fullscreen.enter();
																}
																
																if (!isCheckStart) {
																	isCheckStart = true;
																	checkPlayTime();
																}
																
																resizePayerBox(true);
																
																// 학습주차 체크
																checkStdySchedule("ltDetmToDtMax").always(function() {
																	saveStudyRecord("start");
																});
															});
															
															player_${status.index}.player.on('timeupdate', (event) => {
																timeUpdateCnt++;
																if (event.detail.plyr.speed == 2) {
																	event.detail.plyr.speed = 1.9;
																}
																
																if (curPlayer != null) {
																	newTimeupdateTime = (new Date()).getTime();
																	if (prevTimeupdateTime == 0) {
																		prevTimeupdateTime = newTimeupdateTime;
																	}
																	else {
																		if (curPlayer.attendYn != null && curPlayer.attendYn == "Y") {
																			if ((newTimeupdateTime - prevTimeupdateTime) < 1000) {
																				newTotPlayTime += (newTimeupdateTime - prevTimeupdateTime);
																			}
																			else {
																				newTotPlayTime += 1000;
																			}
																		}
																		//console.log("newTotPlayTime = "+newTotPlayTime+" -- "+(newTotPlayTime / 1000)+", attend="+curPlayer.attendYn+", cnt="+timeUpdateCnt);
																		prevTimeupdateTime = newTimeupdateTime;
																	}
																}
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
																	if (iPhone != "N") {
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
									</c:if>
								</c:forEach>
							</div>
					
						</div><!-- //col -->
					</div><!-- //row -->
				</div><!-- //layout2 -->
			</div><!-- //ui form -->


			<!-- 출석점수기준 -->
			<c:if test="${creCrsVO.crsTypeCd eq 'UNI'}">
			<div id="attendBaseBox" class="ui styled fluid accordion type2 week_lect_list mt20">
				<div id="attendBase" class="title flex-item" style="cursor:pointer;">
					<div class="mra"><b><spring:message code="score.attend.evaluation" /></b></div><%-- 출석 점수 기준 --%>
					<div>
						<i class="dropdown icon"></i>
					</div>
				</div>
				<div class="content p10">
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
						</span> <spring:message code="crs.attend.attendance.criteria.msg14" /><%-- 시 --%>, (<spring:message code="date.platform" /><%-- 단 --%> 1<spring:message code="date.parking" /><!-- 주차는 -->  
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
						<spring:message code="crs.attend.attendance.criteria.msg14" /><%-- 시 --%>, <spring:message code="crs.attend.attendance.criteria.msg1_1" /> <span class="fcBlue"><spring:message code="crs.attend.attendance.criteria.msg1_2" /></span>
						<spring:message code="crs.attend.attendance.criteria.msg1_3" />)
					</p>
					<p class="bullet_design1 mt20"><spring:message code="seminar.label.attend.approval.day" /></p><!-- 출석인정 기간 -->
					<p>
						<span class="fcBlue">* <c:out value="${vo.atendTermVal}" /><spring:message code="crs.attend.attendance.criteria.msg2_1" /></span> <spring:message code="crs.attend.attendance.criteria.msg2_2" />
						(<spring:message code="crs.attend.attendance.criteria.msg3_1" /> <span class="fcBlue"><c:out value="${vo.atendWeekVal}" /></span><spring:message code="crs.attend.attendance.criteria.msg3_2" /><br /> 
					</p>
					<p class="bullet_design1 mt10"><spring:message code="crs.label.attend.standard" /></p><!-- 출석인정기준 -->
					<spring:message code="crs.attend.attendance.criteria.msg4_1" /> <span class="fcRed"><spring:message code="crs.attend.attendance.criteria.msg4_2" /></span> <spring:message code="crs.attend.attendance.criteria.msg4_3" /><br />
					<spring:message code="crs.attend.attendance.criteria.msg5_1" /> <span class="fcRed"><spring:message code="crs.attend.attendance.criteria.msg5_2" /></span> <spring:message code="crs.attend.attendance.criteria.msg5_3" />
					<br />
					<div class="scrollbox_x">
						<table class="tBasic mt10 min-width-1080 "> 
							<caption class="hide"><spring:message code="crs.label.attend.standard" /></caption>
							<thead>
								<tr>
									<th><spring:message code="seminar.label.attend.opportunity" /></th><!-- 출석시기 -->
									<th><spring:message code="lesson.label.lecture.time" /></th><!-- 강의시간 -->
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
					<br />
					<p>
					<spring:message code="crs.attend.attendance.criteria.msg12" />
					<spring:message code="crs.attend.attendance.criteria.msg13" />
					</p>
				</div>
			</div>
			</c:if>
			<!-- //출석점수기준 -->

		</div>
		
		</div><!-- //container -->
		
	</div>
	
	
	<div id="bottom">
	</div>
	
	
	
	<!-- 학습메모 등록 팝업 --> 
	<form id="lessonPopForm" name="lessonPopForm" method="post">
		<input type="hidden" name="crsCreCd" 			value="" />
		<input type="hidden" name="lessonScheduleId" 	value="" />
		<input type="hidden" name="lessonCntsId" 		value="" />
		<input type="hidden" name="studySessionLoc" 	value="" />
		<input type="hidden" name="bbsCd"				value="QNA" />
	</form>
	<div class="modal fade in" id="lessonPopModal" tabindex="-1" role="dialog" aria-labelledby="Dialog" aria-hidden="false" style="display: none; padding-right: 17px;">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header bcGreen">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="modal-pop-title">MEMO</h4>
				</div>
				<div class="modal-body">
					<iframe src="" width="100%" id="lessonPopIfm" name="lessonPopIfm" title="Memo"></iframe>
				</div>
			</div>
		</div>
	</div>
	
	<form id="lessonViewForm" name="lessonViewForm" method="post">
		<input type="hidden" name="crsCreCd" value="${lessonSchedule.crsCreCd}" />
		<input type="hidden" name="lessonScheduleId" value="${lessonSchedule.lessonScheduleId}" />
		<input type="hidden" name="lessonCntsIdx" value="0" />
		<input type="hidden" name="lessonTimeId" value="" />
	</form>
</body>
</html>