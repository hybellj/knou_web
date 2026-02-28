<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />
   	
   	<script type="text/javascript">
   		var STD_INFO;
   		var CURRENT_MONTH = '<c:out value="${nowMonth}" />';
   		var CHART;
   	
	   	$(document).ready(function() {
	   		var stdNo = '<c:out value="${vo.stdNo}" />';
	   		
	   		// 학생정보 조회
	   		getStdInfo(stdNo);
	   	});
	   	
	 	// 학생정보 조회
	   	function getStdInfo(stdNo) {
	   		STD_INFO = null;
	   		$("#beforeBtn, #afterBtn").off("click");
	   		
	   		var url = "/std/stdLect/prevNextStdStudyStatusInfo.do";
			var data = {
				  orgId			: '<c:out value="${orgId}" />'
				, crsCreCd		: '<c:out value="${vo.crsCreCd}" />'
				, stdNo			: stdNo
				, disablilityYn : '<c:out value="${vo.disablilityYn}" />'
			};
			
			ajaxCall(url, data, function(data) {
				var returnVO = data.returnVO;
				
				if(data.result > 0) {
					STD_INFO = returnVO.studentInfo;
		    	} else {
		    		$("#beforeBtn, #afterBtn").addClass("disabled");
		    	}
				
				// 이전, 다음 버튼 세팅
				setPrevNextBtn(returnVO)
				
				// 수강생 정보 영역
				setStdInfoArea(returnVO);
				
				// 학습현황 영역
				setStudyStatusArea(returnVO);
				
				// 강의실 접속 현황 영역 세팅
				setEnterStatusArea();
	  			
				// 강의실 활동기록 영역
				setActivityHistoryArea();
				
			}, function(xhr, status, error) {
				$("#beforeBtn, #afterBtn").addClass("disabled");
				$("#loading_page").hide();
				// 강의실 접속 현황 영역 초기화
				setEnterStatusArea();
				// 강의실 활동기록 영역 초기화
				setActivityHistoryArea();
			});
	   	}
	   	
	 	// 이전, 다음 버튼 세팅
	   	function setPrevNextBtn(data) {
	   		var studentInfo = data && data.studentInfo;
	   		
	   		if(studentInfo) {
	   			var beforeStdNo = studentInfo.beforeStdNo;
				var afterStdNo = studentInfo.afterStdNo;
				
				if(beforeStdNo) {
					$("#beforeBtn").removeClass("disabled");
					$("#beforeBtn").on("click", function() {
						getStdInfo(beforeStdNo);
					});
				} else {
					$("#beforeBtn").addClass("disabled");
				}
				
				if(afterStdNo) {
					$("#afterBtn").removeClass("disabled");
					$("#afterBtn").on("click", function() {
						getStdInfo(afterStdNo);
					});
				} else {
					$("#afterBtn").addClass("disabled");
				}
	   		}
	   	}
	   	
	 	// 수강생 정보 영역 세팅
	 	function setStdInfoArea(data) {
	 		var studentInfo = data && data.studentInfo || {};
	 		var imgSrc = '/webdoc/img/icon-hycu-symbol-grey.svg';
	 		
	 		if(studentInfo.phtFile) {
	 			imgSrc = studentInfo.phtFile;
	 		}
	 		
	 		var studentImg = '<img src="' + imgSrc + '">';
	 		
	 		$("#pthFileDiv").html(studentImg);
			$("#stdInfoUserIdText").text(studentInfo.userId || "-");
  			$("#stdInfoUserNmText").text(studentInfo.userNm || "-");
  			$("#stdInfoDeptNmText").text(studentInfo.deptNm || "-");
  			$("#stdInfoMobileNoText").text(studentInfo.mobileNo || "-");
  			$("#stdInfoEmailText").text(studentInfo.email || "-");
	 	}
	 	
	 	// 학습현황 영역 세팅
	 	function setStudyStatusArea(data) {
	 		var attendInfo = data && data.attendInfo || {};
			var stdJoinStatusInfo = data && data.stdJoinStatusInfo || {};
			
			/* 1. 출석정보 세팅 */
 			var html = '';
			
			var completeIcon = '<div class="p8 flex1 flex-item tc"><i class="ico icon-solid-circle fcBlue"></i></div>';
			var lateIcon = '<div class="p8 flex1 flex-item tc"><i class="ico icon-triangle fcYellow"></i></div>';
			var nostudyIcon = '<div class="p8 flex1 flex-item tc"><i class="ico icon-cross fcRed"></i></div>';
			var emptyIcon = '<div class="p8 flex1 flex-item tc"><i class="ico icon-slash"></i></div>';
			var readyIcon = '<span class=""><i class="ico icon-hyphen"></i></span>';
			//var ingIcon = '<div class="p8 flex1 flex-item tc"><i class="fcBlue ico icon-state-ing"></i></div>';
			
			var completeCnt = 0;
			var lateCnt = 0;
			var noStudyCnt = 0;
			
			$.each($("[data-lesson-schedule-id]"), function() {
				var id = $(this).data("lessonScheduleId");
				var startDtYn = $(this).data("startDtYn");
				var endDtYn = $(this).data("endDtYn");
				var wekClsfGbn = $(this).data("wekClsfGbn");
				var prgrVideoCnt = 1 * $(this).data("prgrVideoCnt");
				
				var key = "stuSttCd_" + id;
				var studyStatusCd = attendInfo[key];
				var html = emptyIcon;
				
				if(wekClsfGbn == "04" || wekClsfGbn == "05") {
					html = readyIcon;
				} else {
					if(!(wekClsfGbn == "02" || wekClsfGbn == "03") && prgrVideoCnt == 0) {
						if(startDtYn == "N") {
							html = emptyIcon;
						} else {
							html = readyIcon;
						}
					} else if(studyStatusCd == "COMPLETE") {
						html = completeIcon;
						completeCnt++;
					} else if(studyStatusCd == "LATE") {
						html = lateIcon;
						lateCnt++;
					} else if(startDtYn == "N") {
						html = emptyIcon;
					} else if(startDtYn == "Y" && endDtYn == "N") {
						html = readyIcon;
					} else {
						html = nostudyIcon;
						noStudyCnt++;
					}
				}
			
				$(this).html(html);
			});
			
			$("#endCompleteCntText").html(completeCnt);
	 		$("#endLateCntText").html(lateCnt);
	 		$("#endNostudyCntText").html(noStudyCnt);
	 		
	 		/* 2. 학습현황 세팅 */
	 		
	 		// 과제 (제출/전체)
	 		$("#asmntCnt").text(stdJoinStatusInfo.asmntCnt || "0");
	 		$("#asmntJoinCnt").text(stdJoinStatusInfo.asmntJoinCnt || "0");
	 		// 퀴즈 (제출/전체)
	 		$("#quizCnt").text(stdJoinStatusInfo.quizCnt || "0");
	 		$("#quizJoinCnt").text(stdJoinStatusInfo.quizJoinCnt || "0");
	 		// 설문 (제출/전체)
	 		$("#reschCnt").text(stdJoinStatusInfo.reschCnt || "0");
	 		$("#reschJoinCnt").text(stdJoinStatusInfo.reschJoinCnt || "0");
	 		// 토론 (제출/전체)
	 		$("#forumCnt").text(stdJoinStatusInfo.forumCnt || "0");
	 		$("#forumJoinCnt").text(stdJoinStatusInfo.forumJoinCnt || "0");
	 		
	 		/* 3.중간/기말 세팅 */
	 		
	 		// 중간고사 (실시간, 대체, 기타)
	 		$("#midExamLive").text(stdJoinStatusInfo.midScore || "-");
	 		$("#midExamSub").text(stdJoinStatusInfo.midReplaceScore || "-");
	 		$("#midExamEtc").text(stdJoinStatusInfo.midEtcScore || "-");
	 		// 기말고사 (실시간, 대체, 기타)
	 		$("#finalExamLive").text(stdJoinStatusInfo.endScore || "-");
	 		$("#finalExamSub").text(stdJoinStatusInfo.endReplaceScore || "-");
	 		$("#finalExamEtc").text(stdJoinStatusInfo.endEtcScore || "-");
	 	}
	 	
	 	// 강의실 접속 현황 영역 세팅
	 	function setEnterStatusArea() {
	 		setChart([], [], []);
			
			if(!STD_INFO) return;
			
			var year = '<c:out value="${nowYear}" />';
			var month = ("" + CURRENT_MONTH).padStart(2, "0");
			var searchTo = ("" + year) + month;
			
	 		var url = "/lesson/lessonLect/stdEnterStatusList.do";
			var data = {
				  crsCreCd		: '<c:out value="${vo.crsCreCd}" />'
				, stdNo			: STD_INFO.stdNo
				, searchTo		: searchTo
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					var returnList = data.returnList || [];

					// 강의실 접속현황 차트 세팅
					var prevList = new Array(31);
					var nowList = new Array(31);
					var avgList = new Array(31);
					
					var prevObj = {};
					var nowObj = {};
					var avgObj = {};
					
					returnList.forEach(function(v, i) {
						var days = v.days * 1;
						
						if(v.label == "prevMonth") {
							prevObj[days] = v.stdDayCnt;
						} else if(v.label == "nowMonth") {
							nowObj[days] = v.stdDayCnt;
							avgObj[days] = v.avgStdDayCnt;
						}
					});
					
					for(var i = 0; i < 31; i++) {
						var days = i + 1;
						
						if(typeof prevObj[days] !== "undefined") {
							prevList[i] = prevObj[days];
						} else {
							prevList[i] = 0;
						}
						
						if(typeof nowObj[days] !== "undefined") {
							nowList[i] = nowObj[days];
							avgList[i] = avgObj[days];
						} else {
							nowList[i] = 0;
							avgList[i] = 0;
						}
					}
					
					setChart(prevList, nowList, avgList);
					
					// 강의실 접속현황 기간 Text 세팅
		    	}
			}, function(xhr, status, error) {
			});
	 	}
	 	
	 	// 월 선택 변경
	 	function changeEnterStatusMonth(type) {
	 		var nowMonth = '<c:out value="${nowMonth}" />'; 
	 		
	 		// 현재년도 내에서 조회
	 		if(type == "left" && CURRENT_MONTH == 1) return;
	 		if(type == "right" && (CURRENT_MONTH == 12 || CURRENT_MONTH == nowMonth)) return;
	 		
	 		$("#monthLeftBtn").prop("disabled", false);
	 		$("#monthRightBtn").prop("disabled", false);
	 		
	 		if(type == "left") {
	 			CURRENT_MONTH = CURRENT_MONTH * 1 - 1;
	 			
	 			if(CURRENT_MONTH == 1) {
	 				$("#monthLeftBtn").prop("disabled", true);
	 			}
	 		} else if(type == "right") {
	 			CURRENT_MONTH = CURRENT_MONTH * 1 + 1;
	 			
	 			if(CURRENT_MONTH == 12 || CURRENT_MONTH == nowMonth) {
	 				$("#monthRightBtn").prop("disabled", true);
	 			}
	 		}
	 		
	 		$("#monthText").val(CURRENT_MONTH + '<spring:message code="std.label.month" />'); // 월
	 		
	 		setEnterStatusArea();
	 	}
	 	
	 	// 강의실 활동기록 영역 세팅
	 	function setActivityHistoryArea() {
	 		listPaging(1);
	 	}
	 	
	 	// 강의실 활동 기록 조회
	 	function listPaging(pageIndex) {
	 		if(!STD_INFO) {
	 			$("#enterStatusList").empty().html("");
	  			$("#enterStatusListTable").footable();
	  			$("#paging").empty();
	 			return;
	 		}
	 		
	 		var url = "/lesson/lessonLect/lessonActnHstyList.do";
			var data = {
				  crsCreCd	: '<c:out value="${vo.crsCreCd}" />'
				, pageIndex : pageIndex
				, userId	: STD_INFO.userId
				, listScale	: $("#listScale").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
	  				var returnList = data.returnList || [];
	  				var pageInfo = data.pageInfo;
	  				var html = "";
	  				
	  				returnList.forEach(function(v, i) {
	  					var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' ' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) + ':' + v.regDttm.substring(12, 14) : v.regDttm;
	  					
		  				html += '<tr>';
		  				html += '	<td>' + v.lineNo + '</td>';
		  				html += '	<td>' + regDttmFmt + '</td>';
		  				html += '	<td>' + v.actnHstyCts + '</td>';
		  				html += '	<td>' + v.deviceTypeCd + '</td>';
		  				html += '	<td>' + v.regIp + '</td>';
		  				html += '</tr>';
		  			});
		  			
		  			$("#enterStatusList").empty().html(html);
		  			$("#enterStatusListTable").footable();
		  			
		  			var params = {
	   					totalCount : pageInfo.totalRecordCount,
	   					listScale : pageInfo.recordCountPerPage,
	   					currentPageNo : pageInfo.currentPageNo,
	   					eventName : "listPaging"
	   				};
	    			
	    			gfn_renderPaging(params);
		    	} else {
		    		$("#enterStatusList").empty().html("");
		  			$("#enterStatusListTable").footable();
		  			$("#paging").empty();
		    	}
			}, function(xhr, status, error) {
				$("#enterStatusList").empty().html("");
	  			$("#enterStatusListTable").footable();
	  			$("#paging").empty();
			});
	 	}
	 	
	 	// 강의실 활동 기록 엑셀 다운로드
		function downExcel() {
			var excelGrid = {
			    colModel:[
		            {label:'<spring:message code="main.common.number.no" />',	name:'lineNo', align:'right', 	width:'1000'},	// NO
		            {label:'<spring:message code="std.label.date_time" />', name:'regDttm', align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}},
		            {label:'<spring:message code="std.label.activity_content" />', name:'actnHstyCts', align:'left', width:'5000'}, // 활동 내용
		            {label:'<spring:message code="std.label.access_device" />', name:'deviceTypeCd', align:'left', width:'5000'}, // 접근 장비
		            {label:'IP', name:'regIp', align:'center', width:'5000'},
	    		]
			};
			
			var url  = "/lesson/lessonLect/lessonActnHstyExcelDown.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    value: '<c:out value="${vo.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'userId', 		value: STD_INFO.userId}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
	 	
	 	// 강의실 접속현황 차트 세팅
	 	function setChart(prevList, nowList, avgList) {
	 		var ctx = document.getElementById("lineChart");
	 		
	 		if(CHART) {
	 			CHART.destroy();
	 		}
	 		
	 		CHART = new Chart(ctx, {
				type: 'line',
				data: {
					labels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
					datasets: [
						{
							label: '<spring:message code="std.label.last_month" />', // 지난달
							fill: false,
							lineTension: 0,
							backgroundColor: "rgba(172, 172, 172,0.4)",
							borderColor: "rgba(172, 172, 172,1)",
							borderCapStyle: 'butt',
							borderDash: [],
							borderDashOffset: 0.0,
							borderJoinStyle: 'miter',
							pointBorderColor: "rgba(172, 172, 172,1)",
							pointBackgroundColor: "#fff",
							pointBorderWidth: 1,
							pointHoverRadius: 5,
							pointHoverBackgroundColor: "rgba(172, 172, 172,1)",
							pointHoverBorderColor: "rgba(0,0,0,0.4)",
							pointHoverBorderWidth: 2,
							pointRadius: 2,
							pointHitRadius: 10,
							data: prevList,
							spanGaps: false,
							borderWidth: 1
						},
						{
							label: '<spring:message code="std.label.learner2" />', // 학습자
							fill: false,
							lineTension: 0,
							backgroundColor: "rgba(255,99,132,0.4)",
							borderColor: "rgba(255,99,132,1)",
							borderCapStyle: 'butt',
							borderDash: [],
							borderDashOffset: 0.0,
							borderJoinStyle: 'miter',
							pointBorderColor: "rgba(255,99,132,1)",
							pointBackgroundColor: "#fff",
							pointBorderWidth: 1,
							pointHoverRadius: 5,
							pointHoverBackgroundColor: "rgba(255,99,132,1)",
							pointHoverBorderColor: "rgba(0,0,0,0.4)",
							pointHoverBorderWidth: 2,
							pointRadius: 2,
							pointHitRadius: 10,
							data: nowList,
							spanGaps: false,
							borderWidth: 1
						},
						{
							label: '<spring:message code="std.label.avg" />', // 평균
							fill: false,
							lineTension: 0,
							backgroundColor: "rgba(54, 162, 235,0.4)",
							borderColor: "rgba(54, 162, 235,1)",
							borderCapStyle: 'butt',
							borderDash: [],
							borderDashOffset: 0.0,
							borderJoinStyle: 'miter',
							pointBorderColor: "rgba(54, 162, 235,1)",
							pointBackgroundColor: "#fff",
							pointBorderWidth: 1,
							pointHoverRadius: 5,
							pointHoverBackgroundColor: "rgba(54, 162, 235,1)",
							pointHoverBorderColor: "rgba(0,0,0,0.4)",
							pointHoverBorderWidth: 2,
							pointRadius: 2,
							pointHitRadius: 10,
							data: avgList,
							spanGaps: false,
							borderWidth: 1
						}
					]
				},
				options: {
					responsive: true,
					scales: {
						yAxes: [{
							ticks: {
								beginAtZero : true,
								// stepSize: stSize,
								// suggestedMax: 10,
								callback: function(value){return (value > 1 ? value.toFixed(0) : chkCharYval(value) ? value.toFixed(1) : value) + "<spring:message code='user.title.count' />"} // 건
							}
						}]
					},
					legend: {
						display: true,
						position: 'bottom',
						labels: {
							boxWidth: 12
						}
					}
				}
			});
	 	}
	 	
	 	function chkCharYval(num) {
	 		if (num === 0) return false;
 			if(num === 2) return true;
 			for(let i = 2; i <= Math.floor(Math.sqrt(num)); i++) {
				if(num % i === 0) return false;
 			}
			return true; 
 		}
 	
	 	// 보내기
	 	function sendMsg() {
	 		if(!STD_INFO) {
	 			/* 선택된 사용자가 없습니다. */
	 			alert('<spring:message code="std.alert.no_select_user" />');
	 			return;
	 		}
	 		
	 		var rcvUserInfoStr = "";
	 		
	 		rcvUserInfoStr += STD_INFO.userId;
	 		rcvUserInfoStr += ";" + STD_INFO.userNm;
	 		rcvUserInfoStr += ";" + STD_INFO.mobileNo;
	 		rcvUserInfoStr += ";" + STD_INFO.email;
	 		
	 		var form = window.parent.alarmForm;
			form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	        form.submit();
	 	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="info-item-box">
            <h2 class="page-title">
            	<c:out value="${creCrsVO.crsCreNm}" />
           	</h2>
            <div class="button-area">
                <a href="javascript:void(0)" class="ui blue small button disabled" id="beforeBtn"><i class="icon chevron left"></i><spring:message code="std.button.prev" /><!-- 이전 --></a>
				<a href="javascript:void(0)" class="ui blue small button disabled" id="afterBtn"><spring:message code="std.button.next" /><!-- 다음 --><i class="icon chevron right"></i></a>
            </div>
        </div>
        <div class="option-content gap4 ">
            <div class="sec_head mra">
            	<ul class="list_verticalline">
		            <li>
		            </li>
		        </ul>
            </div>
			<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
        </div>
        <div class="ui form">
			<div class="fields">
                <div class="two wide field">
                    <div class="initial-img border-radius0" id="pthFileDiv" style="width:100px">
                    </div>                                            
                </div>
                <ul class="fourteen wide field tbl dt-sm">
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.user_id" /><!-- 학번 --></dt>
                            <dd id="stdInfoUserIdText">-</dd>
                            <dt><spring:message code="std.label.name" /><!-- 이름 --></dt>
                            <dd id="stdInfoUserNmText">-</dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.dept" /><!-- 학과 --></dt>
                            <dd id="stdInfoDeptNmText">-</dd>
                            <dt><spring:message code="std.label.mobile_no" /><!-- 휴대폰 번호 --></dt>
                            <dd id="stdInfoMobileNoText">-</dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.email" /><!-- 이메일 --></dt>
                            <dd id="stdInfoEmailText">-</dd>
                        </dl>
                    </li>
                </ul>
            </div>
			<div class="flex">
				<div><b><spring:message code="std.label.learn_status2" /><!-- 학습 현황 --></b></div>
				<div class="flex-left-auto flex gap4">
					<div class="flex-item f080">
						<i class="ico icon-solid-circle fcBlue"></i><spring:message code="std.label.attend" /><!-- 출석 -->
					</div>
					<div class="flex-item f080">
						<i class="ico icon-triangle fcYellow"></i><spring:message code="std.label.late" /><!-- 지각 -->
					</div>
					<div class="flex-item f080">
						<i class="ico icon-cross fcRed"></i><spring:message code="std.label.noattend" /><!-- 결석 -->
					</div>
				</div>
			</div>
			<div class="ui divider"></div>
			<div class="flex-item">
                <b><spring:message code="std.label.lesson_schedule" /><!-- 주차 --></b>
            </div>
            <table class="grid-table type2 mt5">
            	<thead>
					<tr>
					<c:forEach items="${listLessonSchedule}" var="row">
						<th scope="col"><c:out value="${row.lessonScheduleOrder}" /></th>
					</c:forEach>
						<th scope="col" class="wf20"><spring:message code="std.label.attend" /><!-- 출석 -->/<spring:message code="std.label.late" /><!-- 지각 -->/<spring:message code="std.label.noattend" /><!-- 결석 --></th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<c:forEach items="${listLessonSchedule}" var="row">
						<td data-lesson-schedule-id="<c:out value="${row.lessonScheduleId}" />" data-label="<c:out value="${row.lessonScheduleOrder}" />" data-start-dt-yn="<c:out value="${row.startDtYn}" />" data-end-dt-yn="<c:out value="${row.endDtYn}" />" data-wek-clsf-gbn="<c:out value="${row.wekClsfGbn}" />" data-prgr-video-cnt="<c:out value="${row.prgrVideoCnt}" />"></td>
					</c:forEach>
						<td data-label="<spring:message code="std.label.attend" />/<spring:message code="std.label.late" />/<spring:message code="std.label.noattend" />">
							<div class="flex1 flex-item tc">
								<span class="ui blue circular label" id="endCompleteCntText">-</span>
								<span class="ui yellow circular label" id="endLateCntText">-</span>
								<span class="ui red circular label" id="endNostudyCntText">-</span>
							</div>
						</td>
					</tr>
				</tbody>
            </table>
            <div class="flex-item mt15">
                <b><spring:message code="std.label.lesson_cnt" /><!-- 학습요소 --></b>
            </div>
            <table class="grid-table type2 mt5">
            	<thead>
					<tr>                                
                        <th scope="col" class=""><spring:message code="std.label.asmnt" /><!-- 과제 --><br>(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>                                
                        <th scope="col" class=""><spring:message code="std.label.forum" /><!-- 토론 --><br>(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>
                        <th scope="col" class=""><spring:message code="std.label.quiz" /><!-- 퀴즈 --><br>(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>                                
                        <th scope="col" class=""><spring:message code="std.label.resch" /><!-- 설문 --><br>(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>
                    </tr>
                </thead>
                <tbody>
                	<tr>
                		<td data-label="<spring:message code="std.label.asmnt" />" data-next-label="(<spring:message code="std.label.submit" />/<spring:message code="std.label.total" />)"><div class="p8"><span id="asmntJoinCnt">-</span>/<span id="asmntCnt">-</span></div></td>
						<td data-label="<spring:message code="std.label.forum" />" data-next-label="(<spring:message code="std.label.submit" />/<spring:message code="std.label.total" />)"><div class="p8"><span id="forumJoinCnt">-</span>/<span id="forumCnt">-</span></div></td>
						<td data-label="<spring:message code="std.label.quiz" />" data-next-label="(<spring:message code="std.label.submit" />/<spring:message code="std.label.total" />)"><div class="p8"><span id="quizJoinCnt">-</span>/<span id="quizCnt">-</span></div></td>
						<td data-label="<spring:message code="std.label.resch" />" data-next-label="(<spring:message code="std.label.submit" />/<spring:message code="std.label.total" />)"><div class="p8"><span id="reschJoinCnt">-</span>/<span id="reschCnt">-</span></div></td>
                	</tr>
                </tbody>
            </table>
	        <div class="flex-item mt15">
                <b><spring:message code="std.label.mid" /><!-- 중간 -->/<spring:message code="std.label.final" /><!-- 기말 --></b>
            </div>
            <table class="grid-table type2 mt5">
            	<thead>
                    <tr>                                
                        <th scope="col"><spring:message code="std.label.mid_exam" /><!-- 중간고사 --><br>(<spring:message code="std.label.live" /><!-- 실시간 -->)</th>                                
                        <th scope="col"><spring:message code="std.label.mid_exam" /><!-- 중간고사 --><br>(<spring:message code="std.label.replace" /><!-- 대체 -->)</th> 
                        <th scope="col"><spring:message code="std.label.mid_exam" /><!-- 중간고사 --><br>(<spring:message code="std.label.etc" /><!-- 기타 -->)</th> 
                        <th scope="col"><spring:message code="std.label.final_exam" /><!-- 기말고사 --><br>(<spring:message code="std.label.live" /><!-- 실시간 -->)</th> 
                        <th scope="col"><spring:message code="std.label.final_exam" /><!-- 기말고사 --><br>(<spring:message code="std.label.replace" /><!-- 대체 -->)</th> 
                        <th scope="col"><spring:message code="std.label.final_exam" /><!-- 기말고사 --><br>(<spring:message code="std.label.etc" /><!-- 기타 -->)</th>
                        <th scope="col"><spring:message code="std.label.always" /><!-- 수시 --></th>       
                    </tr>
                </thead>
                <tbody>
                    <tr>                                
                        <td data-label="<spring:message code="std.label.mid_exam" />" data-next-label="(<spring:message code="std.label.live" />)">
                           <div class="p8" id="midExamLive">-</div>
                        </td>
                        <td data-label="<spring:message code="std.label.mid_exam" />" data-next-label="(<spring:message code="std.label.replace" />)">
                            <div class="p8" id="midExamSub">-</div>
                        </td>
                        <td data-label="<spring:message code="std.label.mid_exam" />" data-next-label="(<spring:message code="std.label.etc" />)">
                            <div class="p8" id="midExamEtc">-</div>
                        </td>
                        <td data-label="<spring:message code="std.label.final_exam" />" data-next-label="(<spring:message code="std.label.live" />)">
                            <div class="p8" id="finalExamLive">-</div>
                        </td>
                        <td data-label="<spring:message code="std.label.final_exam" />" data-next-label="(<spring:message code="std.label.replace" />)">
                            <div class="p8" id="finalExamSub">-</div>
                        </td>
                        <td data-label="<spring:message code="std.label.final_exam" />" data-next-label="(<spring:message code="std.label.etc" />)">
                            <div class="p8" id="finalExamEtc">-</div>
                        </td>
                        <td data-label="<spring:message code="std.label.always" />" data-next-label=" ">
                            <div class="p8" id="aExam"><span id="aExamJoinCnt">0</span>/<span id="aExamCnt">0</span></div>
                        </td>
                    </tr>
                </tbody>
            </table>
			<div class="ui segment">
				<div class="flex">
					<spring:message code="std.label.class_enter_status" /><!-- 강의실 접속 현황 -->
					<div class="flex ml10">
						<button type="button" class="ui button small basic m0" onclick="changeEnterStatusMonth('left')" id="monthLeftBtn" <c:if test="${nowMonth eq 1}">disabled="disabled"</c:if>><i class="xi-angle-left"></i></button>
						<input type="text" value="<c:out value="${nowMonth}" /><spring:message code="std.label.month" />" class="w50 tc" readonly="readonly" id="monthText" />
						<button type="button" class="ui button small basic" onclick="changeEnterStatusMonth('right')" id="monthRightBtn" disabled="disabled"><i class="xi-angle-right"></i></button>
					</div>
				</div>
				<div class="ui divider mt5"></div>
				<canvas id="lineChart" height="80"></canvas>
			</div>
			<div class="ui segment">
				<spring:message code="std.label.class_activity_history" /><!-- 강의실 활동 기록 -->
				<div class="ui divider mt5"></div>
				<!-- 검색조건 -->
				<div class="option-content mb10">
					<div class="select_area">
						<a href="javascript:void(0)" onclick="downExcel()" class="ui basic button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
						<select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
				            <option value="10">10</option>
				            <option value="20">20</option>
				            <option value="50">50</option>
				            <option value="100">100</option>
				        </select>
					</div>
				</div>
				
				<div style="max-height: 260px; overflow: auto;">
					<table id="enterStatusListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
						<thead>
							<tr>
								<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /><!-- NO. --></th>
								<th scope="col"><spring:message code="std.label.date_time" /><!-- 일시 --></th>
								<th scope="col"><spring:message code="std.label.activity_content" /><!-- 활동 내용 --></th>
								<th scope="col" data-breakpoints="xs"><spring:message code="std.label.access_device" /><!-- 접근 장비 --></th>
								<th scope="col" data-breakpoints="xs">IP</th>
							</tr>
						</thead>
						<tbody id="enterStatusList">
							<!-- 
							<tr>
								<td>5</td>
								<td>2022.02.18 15:23</td>
								<td>강의실 입장</td>
								<td>PC</td>
								<td>210.122.125.254</td>
							</tr>
							<tr>
								<td>4</td>
								<td>2022.02.18 15:23</td>
								<td>과제 제출</td>
								<td>PC</td>
								<td>210.122.125.254</td>
							</tr>
							<tr>
								<td>3</td>
								<td>2022.02.18 15:23</td>
								<td>토론 참여</td>
								<td>PC</td>
								<td>210.122.125.254</td>
							</tr>
							 -->
						</tbody>
					</table>
				</div>
				<div id="paging" class="paging"></div>
			</div>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>