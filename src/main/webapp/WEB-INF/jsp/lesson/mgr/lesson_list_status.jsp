<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/score/common/score_common_inc.jsp" %>
<style>
	.bcBlueAlpha15 {  background: var(--blue-alpha15) !important;}
</style>
<script type="text/javascript">
	var USER_DEPT_LIST;
	var CRS_CRE_LIST;
	var SORT_ODR = "ASC";				// 강의 주차 정렬
	var LESSON_SCHEDULE_LIST = []; 		// 강의 주차 목록

	$(document).ready(function() {
		$("#searchValue").on("keydown", function(e) {
			if(e.keyCode == 13) {
				getCrsCreList();
			}
		});
		
		// 부서 목록 조회
		getUserDeptList().done(function() {
			changeTerm(); // 학기 변경
		});
	});
	
	// 부서 목록 조회
	function getUserDeptList() {
		var deferred = $.Deferred();
		
		var url = "/user/userMgr/deptList.do";
		var data = {};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				USER_DEPT_LIST = returnList.sort(function(a, b) {
					if(a.deptCdOdr < b.deptCdOdr) return -1;
					if(a.deptCdOdr > b.deptCdOdr) return 1;
					if(a.deptCdOdr == b.deptCdOdr) {
						if(a.deptNm < b.deptNm) return -1;
						if(a.deptNm > b.deptNm) return 1;
					}
					return 0;
				});
				
				deferred.resolve();
        	} else {
        		alert(data.message);
        		deferred.reject();
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			deferred.reject();
		});
		
		return deferred.promise();
	}
	
	// 학기 변경
	function changeTerm() {
		// 대학구분 초기화
		$("#univGbn").off("change");
		$("#univGbn").dropdown("clear");
		
		// 부서 초기화
		$("#deptCd").dropdown("clear");
		
		// 강의실 목록 조회
		getCrsCreList().done(function(list) {
			CRS_CRE_LIST = list;
			
			changeUnivGbn("ALL");
		});
	}
	
	// 강의실 목록 조회
	function getCrsCreList() {
		lessonStautsListTable.clearData();
		
		var deferred = $.Deferred();
		var url = "/crs/creCrsMgr/listCrsCre.do";
		var data = {
			  creYear		: $("#haksaYear").val()
			, creTerm		: $("#haksaTerm").val()
			, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
			, univGbn 		: ($("#univGbn").val() || "").replace("ALL", "")
			, searchValue 	: $("#searchValue").val()
			, useYn			: "Y"
			, crsTypeCds	: "UNI" // 학기제
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				returnList.sort(function(a, b) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
					if(a.deptNm == b.deptNm) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;
						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
					}
					return 0;
				});
				
				if(returnList.length == 0) {

				} else {
					var dataList = [];
					
					returnList.forEach(function(v, i) {
						var repUserNm = '-';
						
						if(v.repUserId) {
							repUserNm = v.repUserNm + ' (' + v.repUserId + ')';
						}
						
						dataList.push({
            				deptNm: v.deptNm,
            				crsCd: v.crsCd,
            				crsCreNm: v.crsCreNm + ' ( ' + v.declsNo + ' )',
            				repUserNm: repUserNm,
            				stdCnt: v.stdCnt,
            				valCrsCreCd: v.crsCreCd,
            				valCrsCreNm: v.crsCreNm
            			});
					});
					
					lessonStautsListTable.addData(dataList);
					lessonStautsListTable.redraw();
				}
				
				$("#totalCntText").text(returnList.length);
				
				$("#univGbn").on("change", function() {
					changeUnivGbn(this.value);
				});
				
				// 주차 목록 초기화
				LESSON_SCHEDULE_LIST = [];
				setLessonScheduleList();
				
				deferred.resolve(returnList);
        	} else {
        		alert(data.message);
        		deferred.reject();
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			deferred.reject();
		}, true);
		
		return deferred.promise();
	}
	
	// 대학구분 변경
	function changeUnivGbn(univGbn) {
		$("#deptCd").dropdown("clear");
		
		var deptCdObj = {};
		
		CRS_CRE_LIST.forEach(function(v, i) {
			if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
				deptCdObj[v.deptCd] = true;
			}
		});
		
		var html = '';
		
		html += '<option value="ALL"><spring:message code="common.all" /></option>'; // 전체
		USER_DEPT_LIST.forEach(function(v, i) {
			if(deptCdObj[v.deptCd]) {
				html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
			}
		});
		
		// 부서 초기화
		$("#deptCd").html(html);
	}
	
	// 주차 목록 조회
	function listLessonSchedule(crsCreCd) {
		var deferred = $.Deferred();

		var url = "/crs/listCrsHomeLessonSchedule.do";
		var data = {
			crsCreCd : crsCreCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				if(SORT_ODR == "DESC") {
					returnList = returnList.reverse();
				}
				
				LESSON_SCHEDULE_LIST = returnList;
				
				// 주차목록 세팅
				setLessonScheduleList();
				
				deferred.resolve();
	    	} else {
	    		alert(data.message);
	    		deferred.reject();
	    	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			deferred.reject();
		}, true);
		
		return deferred.promise();
	}
	
	// 주차목록 세팅
	function setLessonScheduleList() {
		var html = '';
		
		if(LESSON_SCHEDULE_LIST.length == 0) {
			html += '<div class="flex-container mb10">';
			html += '	<div class="cont-none">';
			html += '		<span><spring:message code="common.content.not_found" /></span>';
			html += '	</div>';
			html += '</div>';
		} else {
			var html = createLessonScheduleHtml(LESSON_SCHEDULE_LIST);
		}
		
		$("#lessonScheduleList").empty().html(html);
		$('.ui.dropdown').dropdown();
		
		$('#lessonScheduleList > .ui.accordion').accordion({
	        exclusive: false,
	        selector: {
	            trigger: '.title'
	        },
	        duration: 100,
	        onOpen: function() {
	        },
	        onClose: function() {
	        	$(this).find(".add-elem-box").hide();
	        }
	    });
	}
	
	// 주차 목록 정렬 버튼
	function toggleLessonScheduleSortOrder(el) {
		var toggleClass = (SORT_ODR == "ASC" ? "down" : "up");
		
		SORT_ODR = (SORT_ODR == "ASC" ? "DESC" : "ASC");
		$(el).find("i").removeClass("up").removeClass("down").addClass(toggleClass);
	
		LESSON_SCHEDULE_LIST = LESSON_SCHEDULE_LIST.reverse();
		
		setLessonScheduleList();
	}
	
	// 전체 주차 버튼 - 전체 아코디언 닫기/열기
	function toggleLessonScheduleOpen() {
		var $accordionTitle = $('#lessonScheduleList > .ui.accordion > .title');
		var accordionCnt = $accordionTitle.length;
		var openAccordionCnt = 0;
		
		$.each($accordionTitle, function() {
			var isActive = $(this).hasClass("active");
			
			if(isActive) {
				openAccordionCnt++;
			}
		});
		
		$.each($accordionTitle, function() {
			if(openAccordionCnt == accordionCnt) {
				$('#lessonScheduleList > .ui.accordion').accordion("close", 0);
			} else {
				$('#lessonScheduleList > .ui.accordion').accordion("open", 0);
			}
		});
	}
	
	// 1.주차
	function createLessonScheduleHtml(listLessonSchedule) {
		var html = '';
		
		if(listLessonSchedule && listLessonSchedule.length > 0) {
			listLessonSchedule.forEach(function(v, i) {
				var listLessonTime = v.listLessonTime || [];
				var listCrsHomeExam = v.studyElementMap && v.studyElementMap.listCrsHomeExam || [];
				
				var lessonStartDtFmt = getDateFmt(v.lessonStartDt);
				var lessonEndDtFmt = getDateFmt(v.lessonEndDt);
				
				var lessonProgressHtml = '';
				var lessonProgressNm = '';
				var lessonProgressClass = '';
				var scheduleFrDt = getDateFmt(v.ltDetmFrDt) || lessonStartDtFmt;
				var scheduleToDt = getDateFmt(v.ltDetmToDt) || lessonEndDtFmt;
				
				// 강의보기 버튼 사용여부
				var hasVideoCnts = false;
				var firstLessonTimeId;
				
				if(listLessonTime.length > 0) {
					// 1주차 기준 동영상 컨텐츠가 있는경우
					var listLessonCnts = listLessonTime[0].listLessonCnts || [];

					firstLessonTimeId = listLessonTime[0].lessonTimeId;
					
					listLessonCnts.forEach(function (vv, j) {
						if(vv.cntsGbn == "VIDEO" || vv.cntsGbn == "VIDEO_LINK") {
							hasVideoCnts = true;
							return false;
						}
					});
				}
				
				html += '<div class="ui style fluid accordion test">';
				html += '	<div class="title flex flex-wrap align-items-center gap4">';
				html += '		<div class="text flex1">';
				html += '			<i class="dropdown icon"></i>';
				html += 			v.lessonScheduleNm;
				html += '			<br/>';
				html += '			<small class=""><spring:message code="lesson.label.lt.dttm" /> : '+ scheduleFrDt + ' ~ ' + scheduleToDt + '</small>'; // 출석인정 기간
				html += '		</div>';
				html += '		<div class="">';
				if(hasVideoCnts) {
					html += '		<button type="button" class="ui basic small button" onclick="event.stopPropagation(); viewLesson(\'' + v.crsCreCd + '\', \'' + v.lessonScheduleId + '\', \'' + firstLessonTimeId + '\', 0); return false;" title="강의보기">강의보기</button>';
				}
				if(v.ltNote && v.ltNoteOfferYn == "Y") {
					html += '		<button type="button" class="ui basic small button" onclick="event.stopPropagation(); ltNoteDown(\'' + v.ltNote + '\', \'' + v.lessonScheduleOrder + '\')" title="<spring:message code="lesson.label.lt.note" />"><spring:message code="lesson.label.lt.note" /></button>'; // 강의노트
				}
				html += '		</div>';
				html += '	</div>';
				html += '	<div class="content pt15 pb15" data-acc-lesson-schedule-id="' + v.lessonScheduleId + '">';
				html += 		createLessonTimeListHtml(listLessonTime, v);
				html += '	</div>';
				html += '</div>';
			});
		}
		return html;
	}
	
	// 2.교시
	function createLessonTimeListHtml(listLessonTime, lessonScheduleInfo) {
		var html = '';
		
		if(listLessonTime && listLessonTime.length > 0) {
			var lessonTimeCnt = listLessonTime.length; // 총 교시 수
			
			listLessonTime.forEach(function(v, i) {
				var listLessonCnts = v.listLessonCnts || [];
			
				// 1교시 이상만 교시타이틀 생성
				if(lessonTimeCnt > 1) {
					html += '<div class="sec_head mt10 mb10">';
					html += '	<span class="ui lightyellow small label mr10">' + v.lessonTimeOrder + '<spring:message code="lesson.label.time" /></span>'; // 교시
					html += 	v.lessonTimeNm;
					html += '</div>';
				}
				
				html += createLessonCntsListHtml(listLessonCnts, v, lessonScheduleInfo);
			});
		}
		
		return html;
	}
	
	// 3. 학습콘텐츠
	function createLessonCntsListHtml(listLessonCnts, lessonTimeInfo, lessonScheduleInfo) {
		var html = '';
		
		if(listLessonCnts && listLessonCnts.length > 0) {
			listLessonCnts.forEach(function(v, i) {
				var cntsGbn = v.cntsGbn;
				
				if(cntsGbn == "VIDEO" || cntsGbn == "VIDEO_LINK") {
					cntsGbn = "VIDEO"
				}
				
				var seqHtml = '-';
				if(lessonTimeInfo.stdyMethod == "SEQ") {
					seqHtml = v.lessonCntsOrder;
				}
				
				html += '<div class="ui segment flex">';
				html += '	<div>';
				html += '		<span class="ui violet small label mr10">' + seqHtml + '</span>';
				html += '	</div>';
				html += '	<div>'
				html += '		<span class="ui green small label mr10">' + cntsGbn + '</span>';
				html += 		v.lessonCntsNm;
				html += '		<p>';
	            if(v.prgrYn == "Y") {
					html += '		<small class="bullet_dot"><spring:message code="lesson.label.stdy.prgr.y" /></small>'; // 출결대상
				}
	            html += '		</p>';
	            html += '	</div>'
	            html += '	<div class="flex-left-auto">';
	         	// 다운로드, 링크, 강의보기 버튼
	            if(v.cntsGbn == "FILE" || v.cntsGbn == "PDF") {
	            	html += '	<button type="button" class="ui basic small button" onclick="downLessonCnts(\'' + lessonScheduleInfo.crsCreCd + '\', \'' + v.lessonCntsId + '\');" title="<spring:message code="button.download" />"><spring:message code="button.download" /></button>'; // 다운로드
	            } else if (v.cntsGbn == "LINK" || (v.cntsGbn == "SOCIAL" && (v.lessonCntsUrl || "").indexOf("iframe") == -1)) {
	            	html += '	<button type="button" class="ui basic small button" onclick="window.open(\'' + v.lessonCntsUrl + '\', \'_blank\')" title="<spring:message code="common.button.link" />"><spring:message code="common.button.link" /></button>'; // 링크
	            } else {
	            	if(v.cntsGbn == "VIDEO" || v.cntsGbn == "VIDEO_LINK") {
	            		
					} else {
						html += '<button type="button" class="ui basic small button" onclick="viewLesson(\'' + lessonScheduleInfo.crsCreCd + '\', \'' + lessonScheduleInfo.lessonScheduleId + '\', \'' + lessonTimeInfo.lessonTimeId + '\', ' + i + ')"><spring:message code="lesson.label.lt.cnts" /></button>'; // 학습콘텐츠
					}
	            }
	            html += '	</div>';
				html += '</div>';
			});
		}
		
		// 교시 세미나
		if(lessonTimeInfo.listSeminar.length > 0) {
			lessonTimeInfo.listSeminar.forEach(function(v, i) {
				var seminarStartDttmFmt = v.seminarStartDttm != undefined ? getDateFmt(v.seminarStartDttm) : "-";
				var seminarEndDttmFmt = v.seminarEndDttm != undefined ? getDateFmt(v.seminarEndDttm) : "-";
				var seminarTime = parseInt(v.seminarTime / 60) > 0 ? parseInt(v.seminarTime / 60) + '<spring:message code="date.time" />' + v.seminarTime % 60 + '<spring:message code="date.minute" />' : v.seminarTime % 60 + '<spring:message code="date.minute" />';

				if(v.seminarCtgrCd == "online") {
					html += '<div class="ui segment">';
					html += '	<ul class="each_lect_list">';
					html += '		<li class="flex">';
					html += '			<div class="each_lect_tit">';
					html += '				<div class="ui blue button p20" onclick="seminarStart(\'' + lessonScheduleInfo.crsCreCd + '\', \'' + v.seminarId + '\')">';
					html += '					<i class="laptop icon f150"></i>';
					html += '					<a class="tl fcWhite" href="javascript:void(0)"><spring:message code="lesson.button.seminar.start" /></a>'; // 화상 세미나<br>시작하기
					html += '				</div>';
					html += '			</div>';
					html += '			<div class="ml30">';
					html += '				<p><small class="bullet_dot"><spring:message code="lesson.label.seminar.nm" /> : '+v.seminarNm+'</small></p>'; // 세미나명
					html += '				<p><small class="bullet_dot"><spring:message code="lesson.label.start.dttm" /> : '+seminarStartDttmFmt+'</small></p>'; // 시작일시
					html += '				<p><small class="bullet_dot"><spring:message code="lesson.label.progress.time" /> : '+seminarTime+'</small></p>'; // 진행시간
					html += '			</div>';
					html += '		</li>';
					html += '	</ul>';
					html += '	<div class="bcBlueAlpha15 mt15 p10">';
					html += '		<p><spring:message code="lesson.label.seminar.guide1" /></p>'; // * [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요.
					html += '		<p class="fcRed"><spring:message code="lesson.label.seminar.guide2" /></p>'; // Zoom 프로그램이 아닌 브라우저 상의 “브라우저에서 참가”를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다.
					html += '	</div>';
					html += '</div>';
				} else if(v.seminarCtgrCd == "offline") {
					html += '<div class="ui segment flex">';
					html += '	<div>';
					html += '		<span class="ui violet small label mr10">-</span>';
					html += '	</div>';
					html += '	<div>'
					html += '		<span class="ui green small label mr10"><spring:message code="lesson.label.seminar" /></span>'; // 세미나
					html += 		v.seminarNm;
					html += '		<p>';
		            html += '			<small class="bullet_dot"><spring:message code="common.period" /> : ' + seminarStartDttmFmt + ' ~ ' + seminarEndDttmFmt + '</small>'; // 기간
		            html += '		</p>';
		            html += '	</div>'
					html += '</div>';
				}
			});
		}
		
		return html;
	}
	
	// 강의콘텐츠 다운로드
	function downLessonCnts(crsCreCd, lessonCntsId) {
		var url = "/lesson/lessonHome/selectLessonCntsFilePath.do";
		var data = {
			  crsCreCd : crsCreCd
			, lessonCntsId : lessonCntsId
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				
				if(returnVO && returnVO.downloadPath) {
					var path = returnVO.downloadPath;
					
					var downloadUrl = '<%= CommConst.CONTEXT_FILE_DOWNLOAD %>?path=';
					var form = $("<form></form>");
					form.attr("method", "POST");
					form.attr("name", "downloadForm");
					form.attr("id", "downloadForm");
					form.attr("target", "downloadIfm");
					form.attr("action", downloadUrl + path);
					form.appendTo("body");
					form.submit();
					
					$("#downloadForm").remove();
				} else {
					alert('<spring:message code="lesson.error.not.exists.lesson.cnts" />'); // 학습자료 정보를 찾을 수 없습니다.
				}
	    	} else {
	    		alert(data.message);
	    	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 화상 세미나 참여하기
	function seminarStart(crsCreCd, seminarId) {
		var url = "/seminar/seminarHome/viewSeminar.do";
		var data = {
			  seminarId : seminarId
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO.seminarEndYn == "Y") {
					alert('<spring:message code='seminar.alert.end.seminar' />');/* 해당 세미나는 종료되었습니다. */
				} else if(returnVO.seminarStartYn == "N") {
					alert("<spring:message code='seminar.alert.not.seminar.ten.minutes.before.start' />");/* 세미나 시작시간이 아닙니다. 10분 전부터 시작 가능합니다. */
				} else {
					var hostYn = returnVO.hostYn;
					url = hostYn == "Y" ? "/seminar/seminarHome/zoomHostStart.do" : "/seminar/seminarHome/zoomJoinStart.do";
					data = {
						seminarId : seminarId,
						crsCreCd  : crsCreCd
					}
					
					ajaxCall(url, data, function(data) {
						if(data.result > 0) {
							var zoomUrl = hostYn == "Y" ? data.returnVO.hostUrl : data.returnVO.joinUrl;
							if("${IPHONE_YN}" == "Y") {
								window.location.href = data.returnVO.joinUrl;
							} else {
								var windowOpener = window.open();
								windowOpener.location = zoomUrl;
							}
						}
					});
				}
	    	} else {
	    		alert(data.message);
	    	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 강의노트 다운로드
	function ltNoteDown(ltNote, lessonScheduleOrder) {
		var crsCreNm = "";
		
		$.each($("[data-crs-cre-nm]"), function() {
			if($(this).hasClass("on")) {
				crsCreNm = $(this).data("crsCreNm");
				return false;
			}
		});
		
		try {
			event.stopPropagation();	
		} catch (e) {
		}
		
		<%
    	String agentS = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "";
        String appIos = "N"; 
        if (agentS.indexOf("hycuapp") > -1 && (agentS.indexOf("iPhone") > -1 || agentS.indexOf("iPad") > -1)) {
        	appIos = "Y";
        }
    	%>
    	
    	var creNm = encodeURIComponent(crsCreNm);
    	var fileName = creNm+"_"+(lessonScheduleOrder.length < 2 ? "0"+lessonScheduleOrder : lessonScheduleOrder);
    	var viewPath = "{\"path\":\""+ltNote+"\",\"fileName\":\""+fileName+"\",\"date\":\""+(new Date().getTime())+"\"}";
    	var ltNoteUrl = "<%=CommConst.EXT_URL_LONOTE_VIEWER%>" + btoa(viewPath);
    	
    	var appIos = "<%=appIos%>";
    	if (appIos == "Y") {
    		document.location.href = ltNoteUrl;
    	}
    	else {
    		window.open(ltNoteUrl, '_blank');
    	}
	}
	
	// 날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
	function getDateFmt(dateStr) {
		var fmtStr = (dateStr || "");
		
		if(fmtStr.length == 14) {
			fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12);
		} else if(fmtStr.length == 8) {
			fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
		}
		
		return fmtStr;
	}
</script>
<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
                <div id="info-item-box">
                	<h2 class="page-title flex-item">
					    <spring:message code="lesson.label.lesson.list.status" /><!-- 강의목록 현황 -->
					    <!-- 
					    <div class="ui breadcrumb small">
					        <small class="section"></small>
					    </div>
					     -->
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<%-- <div class="ui buttons mb10" style="<c:if test="${isKnou ne true}">display:none</c:if>">
						<button type="button" class="ui blue button active"><spring:message code="common.label.semester.sys" /></button><!-- 학기제 -->
					</div> --%>
					<div class="option-content gap4">
					</div>
					<div class="ui segment searchArea">
						<select class="ui dropdown mr5" id="haksaYear" onchange="changeTerm()">
	                   		<c:forEach var="item" begin="${termVO.haksaYear - 2}" end="${termVO.haksaYear + 2}" step="1">
								<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
							</c:forEach>
	                   	</select>
	                   	<select class="ui dropdown mr5" id="haksaTerm" onchange="changeTerm()">
	                   		<option value=""><spring:message code="exam.label.term" /><!-- 학기 --></option>
							<c:forEach var="item" items="${haksaTermList}">
								<option value="${item.codeCd}" ${item.codeCd eq termVO.haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
							</c:forEach>
	                   	</select>

						<c:if test="${orgId eq 'ORG0000001'}">
							<select class="ui dropdown mr5" id="univGbn">
	                    		<option value=""><spring:message code="exam.label.org.type" /><!-- 대학구분 --></option>
	                    		<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
	                    		<c:forEach var="item" items="${univGbnList}">
									<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
								</c:forEach>
	                    	</select>
                    	</c:if>
                    	<select class="ui dropdown mr5 w250" id="deptCd">
                    		<option value=""><spring:message code="common.dept_name" /><!-- 학과 --></option>
                    	</select>
                    	<div class="ui input">
							<input id="searchValue" type="text" placeholder="<spring:message code="lesson.common.placeholder3" />" value="" class="w250" />
						</div>
	                	<div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="getCrsCreList()"><spring:message code="common.button.search" /><!-- 검색 --></a>
						</div>
	                </div>
	                <div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code="lesson.label.create.course" /><!-- 개설과목 --></h3>
	   					<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	   					<div class="mla">
	   					</div>
	   				</div>
	   				<div class="ui bottom attached segment">
	   					<div id="lessonStautsListTable"></div>
	   					<script>
                        var lessonStautsListTable = new Tabulator("#lessonStautsListTable", {
                        		maxHeight: "400px",
                        		minHeight: "100px",
                        		layout: "fitColumns",
                        		selectableRows: 1,
                        		headerSortClickElement: "icon",
                        		placeholder:"<spring:message code='common.content.not_found'/>",
                        		columns: [
                        		    {title:"<spring:message code='common.number.no'/>", 		field:"lineNo", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60, 		formatter:"rownum",		headerSort:false},
                        		    {title:"<spring:message code='common.dept_name'/>", 		field:"deptNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:150, 	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 학과			                        		    
                        		    {title:"<spring:message code='lesson.label.crs.cd'/>", 		field:"crsCd", 		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100,	formatter:"plaintext", 	headerSort:true}, // 학수번호
                        		    {title:"<spring:message code='lesson.label.crs.cre.nm'/>",	field:"crsCreNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 과목명
                        		    {title:"<spring:message code='common.professor'/>", 		field:"repUserNm",	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext", 	headerSort:true}, // 교수
                        		    {title:"<spring:message code='lesson.label.std'/>", 		field:"stdCnt", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80, 		formatter:"html",		headerSort:false}, // 수강생
                        		]
                       	});
                        
                        lessonStautsListTable.on("rowSelected", function(row){
                            var data = row.getData();
                            listLessonSchedule(data.valCrsCreCd);
                        });
                       </script>
	  				</div>
	  				
	  				<div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code="lesson.label.lesson.list" /><!-- 강의목록 --></h3>
	   				</div>
	   				
	   				<div class="option-content header2">
			            <button class="ui basic small button" type="button" id="openCloseBtn" onclick="toggleLessonScheduleOpen()"><spring:message code="lesson.button.all.lesson.schedule" /><!-- 전체 주차 --></button>
			            <button title="주차정렬" class="ui basic icon button flex-left-auto" type="button" onclick="toggleLessonScheduleSortOrder(this)"><i class="sort amount up icon"></i></button>
			        </div>
			        
			        <!-- 주차 목록 -->
        			<div id="lessonScheduleList" class="courseItemList timeline">
						<div class="flex-container mb10">
							<div class="cont-none">
								<span><spring:message code="common.content.not_found" /></span>
							</div>
						</div>
					</div>
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
        </div>
        <!-- footer 영역 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    
    <script>
		// 강의보기 팝업 호출
		function viewLesson(crsCreCd, lessonScheduleId, lessonTimeId, cntsIdx) {
	        var lessonScheduleOrderText;
	        
	        LESSON_SCHEDULE_LIST.forEach(function(v, i) {
	        	if(v.lessonScheduleId == lessonScheduleId) {
	        		lessonScheduleOrderText = v.lessonScheduleOrder + '<spring:message code="lesson.label.schedule"/> '; // 주차
	        		return false;
	        	}
	        });
	        
	        var modalTitle = lessonScheduleOrderText + '<spring:message code="lesson.label.view.lesson"/>'; // 강의보기
	        
	        var url = "/crs/crsProfLessonView.do?crsCreCd=" + crsCreCd
	    		+ "&lessonScheduleId="+lessonScheduleId+"&lessonTimeId="+lessonTimeId+"&lessonCntsIdx="+cntsIdx;
	        
	        $("<a id='testtest'>").prop({
	            target: "_blank",
	            href: url
	        })[0].click();
		}
		
	    window.closeModal = function() {
	        $('.modal').modal('hide');
	    };
	</script>
</body>
</html>