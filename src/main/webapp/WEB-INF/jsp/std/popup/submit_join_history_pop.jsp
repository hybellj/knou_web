<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
   		var MENU_TYPE = '<c:out value="${menuType}" />';
   		var STD_INFO;
   	
	   	$(document).ready(function() {
	   		// 학생정보 조회
	   		getStdInfo();
	   		
	   		// 제출기록 조회
	   		getSubmitHistory();
	   	});
	   	
	 	// 학생정보 조회
	   	function getStdInfo() {
	   		var url = "/std/stdLect/studentInfo.do";
			var data = {
				  crsCreCd		: '<c:out value="${vo.crsCreCd}" />'
				, stdNo			: '<c:out value="${vo.stdNo}" />'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					
					if(returnVO) {
						var imgSrc = '/webdoc/img/icon-hycu-symbol-grey.svg';
				 		
				 		if(returnVO.phtFile) {
				 			imgSrc = returnVO.phtFile;
				 		}
				 		
				 		var studentImg = '<img src="' + imgSrc + '" alt="photo">';
				 		
				 		$("#pthFileDiv").html(studentImg);
						$("#stdInfoUserIdText").text(returnVO.userId || "-");
			  			$("#stdInfoUserNmText").text(returnVO.userNm || "-");
			  			$("#stdInfoDeptNmText").text(returnVO.deptNm || "-");
			  			$("#stdInfoMobileNoText").text(returnVO.mobileNo || "-");
			  			$("#stdInfoEmailText").text(returnVO.email || "-");
			  			
			  			STD_INFO = returnVO;
					}
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	   	}
	 	
	 	// 제출/참여 이력 조회
	 	function getSubmitHistory() {
			var searchKey = '<c:out value="${vo.searchKey}" />';
	   		
			var url = "/std/stdLect/listSubmitHistory.do";
			var data = {
				  crsCreCd		: '<c:out value="${vo.crsCreCd}" />'
				, stdNo			: '<c:out value="${vo.stdNo}" />'
				, searchKey		: searchKey
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					// 제출/참여 목록 세팅
					if(searchKey == "ASMNT") {
						setAsmntList(returnList);
			   		} else if(searchKey == "QUIZ") {
			   			setQuizList(returnList);
			   		} else if(searchKey == "RESCH") {
			   			setReschList(returnList);
			   		} else if(searchKey == "FORUM") {
			   			setForumList(returnList);
			   		}
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
			
	 	}
	 	
	 	// 과제 제출/참여 목록 세팅
	 	function setAsmntList(list) {
	 		if(list.length == 0) {
	 			$("#asmntList").html(getEmptyHtml());
	 			return;
	 		}
	 		
	 		var html = '';
			html += '<div class="ui styled fluid accordion week_lect_list">';
			list.forEach(function(v, i) {
				var listAsmntSbmtFile = v.listAsmntSbmtFile || [];
				var listAsmntJoinHsty = v.listAsmntJoinHsty || [];
				
				var sendStartDttmFmt = v.sendStartDttm.length == 14 ? v.sendStartDttm.substring(0, 4) + "." + v.sendStartDttm.substring(4, 6) + "." + v.sendStartDttm.substring(6, 8) + " " + v.sendStartDttm.substring(8, 10) + ":" + v.sendStartDttm.substring(10, 12) : v.sendStartDttm;
				var sendEndDttmFmt = v.sendEndDttm.length == 14 ? v.sendEndDttm.substring(0, 4) + "." + v.sendEndDttm.substring(4, 6) + "." + v.sendEndDttm.substring(6, 8) + " " + v.sendEndDttm.substring(8, 10) + ":" + v.sendEndDttm.substring(10, 12) : v.sendEndDttm;
				var asmntSubmitStatusCd = (v.asmntSubmitStatusCd || "").toUpperCase();
				
				// 진행 상태
				var asmntProgressNm = "";
				var asmntProgressColor = "";
				
				if(v.asmntProgress == "READY") {
					asmntProgressNm = '<spring:message code="std.label.study_ready" />'; // 대기
					asmntProgressColor = "fcGreen";
				} else if(v.asmntProgress == "PROGRESS") {
					asmntProgressNm = '<spring:message code="std.label.study_progress" />'; // 진행중
					asmntProgressColor = "fcGreen";
				} else if(v.asmntProgress == "END") {
					asmntProgressNm = '<spring:message code="std.label.study_end" />'; // 학습종료
					asmntProgressColor = "fcGreen";
				}
				
				// 제출 상태
				var asmntSubmitStatusCdNm = "";
				var asmntSubmitStatusColor = "";
				
				if(asmntSubmitStatusCd == "NO") {
					asmntSubmitStatusCdNm = '<spring:message code="std.label.asmnt_nosubmit" />'; // 미제출
					asmntSubmitStatusColor = "fcGrey";
				} else if(asmntSubmitStatusCd == "SUBMIT") {
					asmntSubmitStatusCdNm = '<spring:message code="std.label.asmnt_submit" />'; // 제출
					asmntSubmitStatusColor = "fcBlue";
				} else if(asmntSubmitStatusCd == "RESUBMIT") {
					asmntSubmitStatusCdNm = '<spring:message code="std.label.asmnt_resubmit" />'; // 재제출
					asmntSubmitStatusColor = "fcBlue";
				} else if(asmntSubmitStatusCd == "LATE") {
					asmntSubmitStatusCdNm = '<spring:message code="std.label.asmnt_late" />'; // 연장제출
					asmntSubmitStatusColor = "fcBlue";
				}
				
				html += '<div class="title">';
				html += '	<div class="title_cont">';
				html += '		<div class="left_cont">';
				html += '			<div class="lectTit_box flex_1">';
				html += '				<p class="lect_name"><span class="' + asmntProgressColor + ' mr5">[' + asmntProgressNm + ']</span>' + v.asmntTitle + '</p>';
				html += '				<span class="fcGrey"><small><spring:message code="std.label.asmnt_peroid" /> : ' + sendStartDttmFmt + ' ~ ' + sendEndDttmFmt + '</small></span>'; // 제출 기간
				html += '			</div>';
				if(v.scoreAplyYn == "Y" && (MENU_TYPE.indexOf("PROFESSOR") > -1 || (v.scoreOpenYn == "Y" && v.evalYn == "Y"))) {
				html += '			<div class="fcBlue f120 fweb">' + (v.evalYn == 'Y' && v.score != null && v.score !== '' ? v.score : '- ') + '<spring:message code="std.label.point" /></div>'; // 점
				}
				if(asmntSubmitStatusCdNm) {
					html += '		<div class="' + asmntSubmitStatusColor + ' w60">' + asmntSubmitStatusCdNm + '</div>';
				}
				html += '		</div>';
				html += '	</div>';
				html += '	<i class="dropdown icon ml20"></i>';
				html += '</div>';
				html += '<div class="content menu_off">';
				html += '	<div class="ui message">';
				html += '		<h4 class="ui header transition visible"><spring:message code="asmnt.label.submitted.work" /></h4>'; // 제출 과제
				if(listAsmntSbmtFile.length == 0) {
					html += '	<div class="ui message">';
					html += '		<span class="fcRed"><spring:message code="std.label.empty_asmnt" /></span>'; // 제출기록 없음
					html += '	</div>';
				} else {
					html += '	<ul>';
					// 제출 과제
					listAsmntSbmtFile.forEach(function(v, i) {
						var regDttmFmt = v.regDttm.length == 14 ? v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) : v.regDttm;
						
						html += '	<li class="mb5">';
						html += '		<a href="javascript:void(0)" onclick="fileDown(\'' + v.fileSn + '\', \'' + v.repoCd + '\')">';
						html += '			<small class="fcGrey">• <spring:message code="std.label.submit" /> ' + (i + 1) + ' : ' + regDttmFmt + ' | ' + v.fileNm + ' <span class="ml5 mr5 f080">' +formatBytes(v.fileSize) + '</span></small>'; // 제출
						html += '			<i class="icon arrow alternate circle down fcPink"></i>';
						html += '		</a>';
						html += '	</li>';
					});
					html += '	</ul>';
				}
				html += '	</div>'; // 제출 과제 END
				html += '	<div class="ui message" style="max-height: 170px; overflow-y: auto;">';
				html += '		<h4 class="ui header transition visible"><spring:message code="std.label.show_asmnt_history" /></h4>'; // 과제 제출 이력 보기
				if(listAsmntJoinHsty.length == 0) {
					html += '	<div class="ui message">';
					html += '		<span class="fcRed"><spring:message code="std.label.empty_asmnt" /></span>'; // 제출기록 없음
					html += '	</div>';
				} else {
					html += '	<ul>';
					// 과제 제출 이력 보기
					listAsmntJoinHsty.forEach(function(v, i) {
						var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) + ":" + v.regDttm.substring(12, 14) : v.regDttm;
						var hstyText = "-";
						
						if(v.sbmtFileInfo) {
							hstyText = v.sbmtFileInfo;
						} else {
							hstyText = "<spring:message code='asmnt.label.submit.dt' /> : " + regDttmFmt; // 제출일시
						}
						
						html += '	<li class="mb5"><small class="fcGrey">• ' + hstyText + '</small></li>';
					});
					html += '	</ul>';
				}
				html += '	</div>'; // 과제 제출 이력 보기 END
				html += '</div>';
			});
			
			html += '</div>';
			
			$("#asmntList").html(html);
			
			$('.ui.styled.accordion').accordion({
	   	        exclusive: false,
	   	        selector: {
	   	            trigger: '.title .left_cont'
	   	        }
	   	    });
	 	}
	 	
	 	// 퀴즈 제출/참여 목록 세팅
	 	function setQuizList(list) {
	 		if(list.length == 0) {
	 			$("#quizList").html(getEmptyHtml());
	 			return;
	 		}
	 		
	 		var html = '';
   			
   			html += '<div class="ui styled fluid accordion week_lect_list">';
   			
   			list.forEach(function(v, i) {
   				var submitHistoryQuizHstyList = v.submitHistoryQuizHstyList || [];
   				
   				var examStartDttmFmt = v.examStartDttm.length == 14 ? v.examStartDttm.substring(0, 4) + "." + v.examStartDttm.substring(4, 6) + "." + v.examStartDttm.substring(6, 8) + " " + v.examStartDttm.substring(8, 10) + ":" + v.examStartDttm.substring(10, 12) : v.examStartDttm;
   				var examEndDttmFmt = v.examEndDttm.length == 14 ? v.examEndDttm.substring(0, 4) + "." + v.examEndDttm.substring(4, 6) + "." + v.examEndDttm.substring(6, 8) + " " + v.examEndDttm.substring(8, 10) + ":" + v.examEndDttm.substring(10, 12) : v.examEndDttm;
   				
   				// 진행 상태
				var quizProgressNm = "";
				var quizProgressColor = "";
				
				if(v.quizProgress == "READY") {
					quizProgressNm = '<spring:message code="std.label.study_ready" />'; // 대기
					quizProgressColor = "fcGreen";
				} else if(v.quizProgress == "PROGRESS") {
					quizProgressNm = '<spring:message code="std.label.study_progress" />'; // 진행중
					quizProgressColor = "fcGreen";
				} else if(v.quizProgress == "END") {
					quizProgressNm = '<spring:message code="std.label.study_end" />'; // 학습종료
					quizProgressColor = "fcGreen";
				}
   				
   				// 응시 상태
   				var stareStatusNm = "";
   				var stareStatusColor = "";
   				
   				if(v.stareStatusCd == "N") {
   					stareStatusNm = '<spring:message code="std.label.quiz_n" />'; // 미응시
   	   				stareStatusColor = "fcGrey";
   				} else if(v.stareStatusCd == "T") {
   					stareStatusNm = '<spring:message code="std.label.quiz_t" />'; // 임시저장
   	   				stareStatusColor = "fcGrey";
   				} else if(v.stareStatusCd == "C") {
   					stareStatusNm = '<spring:message code="std.label.quiz_c" />'; // 응시완료
   	   				stareStatusColor = "fcBlue";
   				}
   				
   				html += '<div class="title">';
   				html += '	<div class="title_cont">';
   				html += '		<div class="left_cont">';
   				html += '			<div class="lectTit_box flex_1">';
   				html += '				<p class="lect_name"><span class="' + quizProgressColor + ' mr5">[' + quizProgressNm + ']</span>' + v.examTitle + '</p>';
   				html += '				<span class="fcGrey"><small><spring:message code="std.label.quiz_period" /> : ' + examStartDttmFmt + ' ~ ' + examEndDttmFmt + '</small></span>'; // 응시 기간
   				html += '			</div>';
   				if(v.scoreAplyYn == "Y" && (MENU_TYPE.indexOf("PROFESSOR") > -1 || (v.scoreOpenYn == "Y" && v.evalYn == "Y"))) {
 				html += '			<div class="fcBlue f120 fweb">' + (v.evalYn == 'Y' && v.totGetScore != null && v.totGetScore !== '' ? v.totGetScore : '- ') + '<spring:message code="std.label.point" /></div>'; // 점
   				}
 				html += '			<div class="' + stareStatusColor + ' w60">' + stareStatusNm + '</div>';
   				html += '		</div>';
   				html += '	</div>';
   				html += '	<i class="dropdown icon ml20"></i>';
   				html += '</div>';
   				html += '<div class="content menu_off">';
   				html += '	<h4 class="ui header transition visible"><spring:message code="std.label.quiz_history" /></h4>'; // 응시 기록
   		
 				html += '	<div style="overflow-y: auto; max-height: 255px;">';
 				html += '		<table class="table type2 quizListTable" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">'; // 등록된 내용이 없습니다.
 	   			html += '			<thead>';
 	   			html += '				<tr>';
 	   			html += '					<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>';// NO.
 	   			html += '					<th scope="col"><spring:message code="std.label.date_time" /></th>'; // 일시
 	   			html += '					<th scope="col"><spring:message code="std.label.log" /></th>'; // 로그
 	   			html += '					<th scope="col" data-breakpoints="xs">IP</th>';
 	   			html += '				</tr>';
 	   			html += '			</thead>';
 	   			html += '			<tbody>';
  	   				// 응시기록 목록
   	   			submitHistoryQuizHstyList.forEach(function(v, i) {
   	   				var regDttmFmt = v.regDttm.length == 14 ? v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) : v.regDttm;
	   	   			
   	   				html += '			<tr>';
   	   				html += '				<td>' + (submitHistoryQuizHstyList.length - i) + '</td>';
   	   				html += '				<td>' + regDttmFmt + '</td>';
   	   				html += '				<td>' + (v.hstyTypeNm || "") + '</td>';
   	   				html += '				<td>' + (v.connIp || "") + '</td>';
   	   				html += '			</tr>';
   	   			});
   	   			html += '			</tbody>';
   				html += '		</table>';
   				html += '	</div>';
   				
   				html += '</div>';
   			});
   			
			html += '</div>';
			
			$("#quizList").html(html);
			$(".quizListTable").footable();
			
			$('.ui.styled.accordion').accordion({
	   	        exclusive: false,
	   	        selector: {
	   	            trigger: '.title .left_cont'
	   	        }
	   	    });
	 	}
	 	
	 	// 설물 제출/참여 목록 세팅
	 	function setReschList(list) {
	 		if(list.length == 0) {
	 			$("#reschList").html(getEmptyHtml());
	 			return;
	 		}
	 		
	 		var html = '';
	 		
	 		html += '<div class="ui styled fluid accordion week_lect_list">';
	 		
	 		list.forEach(function(v, i) {
	 			var submitHistoryReschJoinList = v.submitHistoryReschJoinList || [];
	 			
	 			var reschStartDttmFmt = (v.reschStartDttm || "").length == 14 ? v.reschStartDttm.substring(0, 4) + "." + v.reschStartDttm.substring(4, 6) + "." + v.reschStartDttm.substring(6, 8) + " " + v.reschStartDttm.substring(8, 10) + ":" + v.reschStartDttm.substring(10, 12) : (v.reschStartDttm || "");
	 			var reschEndDttmFmt = (v.reschEndDttm || "").length == 14 ? v.reschEndDttm.substring(0, 4) + "." + v.reschEndDttm.substring(4, 6) + "." + v.reschEndDttm.substring(6, 8) + " " + v.reschEndDttm.substring(8, 10) + ":" + v.reschEndDttm.substring(10, 12) : (v.reschEndDttm || "");
	 			
	 			// 진행 상태
				var reschProgressNm = "";
				var reschProgressColor = "";
				
				if(v.reschProgress == "READY") {
					reschProgressNm = '<spring:message code="std.label.study_ready" />'; // 대기
					reschProgressColor = "fcGreen";
				} else if(v.reschProgress == "PROGRESS") {
					reschProgressNm = '<spring:message code="std.label.study_progress" />'; // 진행중
					reschProgressColor = "fcGreen";
				} else if(v.reschProgress == "END") {
					reschProgressNm = '<spring:message code="std.label.end" />'; // 종료
					reschProgressColor = "fcGreen";
				}
				
				// 제출 상태
				var joinStatusNm = "";
				var joinStatusColor = "";
				
				if(v.joinYn == "N") {
					joinStatusNm = '<spring:message code="std.label.resch_nosubmit" />'; // 미제출
					joinStatusColor = "fcGrey";
				} else if(v.joinYn == "Y") {
					joinStatusNm = '<spring:message code="std.label.resch_submit" />'; // 제출
					joinStatusColor = "fcBlue";
				}
				
	 			html += '<div class="title">';
	 			html += '	<div class="title_cont">';
	 			html += '		<div class="left_cont">';
	 			html += '			<div class="lectTit_box flex_1">';
	 			html += '				<p class="lect_name"><span class="' + reschProgressColor + ' mr5">[' + reschProgressNm + ']</span>' + v.reschTitle + '</p>';
	 			html += '				<span class="fcGrey"><small><spring:message code="std.label.resch_period" /> : ' + reschStartDttmFmt + ' ~ ' + reschEndDttmFmt + '</small></span>'; // 제출 기간
	 			html += '			</div>';
	 			if(v.scoreAplyYn == "Y" && (MENU_TYPE.indexOf("PROFESSOR") > -1 || (v.scoreOpenYn == "Y" && v.evalYn == "Y"))) {
		 			html += '			<div class="fcBlue f120 fweb">' + (v.evalYn == 'Y' && v.score != null && v.score !== '' ? v.score : '- ') + '<spring:message code="std.label.point" /></div>'; // 점
	 			}
	 			html += '			<div class="' + joinStatusColor + '">' + joinStatusNm + '</div>';
	 			html += '		</div>';
	 			html += '	</div>';
	 			html += '	<i class="dropdown icon ml20"></i>';
	 			html += '</div>';
	 			html += '<div class="content menu_off">';
	 			html += '	<h4 class="ui header transition visible"><spring:message code="std.label.resch_history" /></h4>'; // 제출 기록
	 			html += '	<div style="overflow-y: auto; max-height: 255px;">';
	 			html += '		<table class="table type2 reschListTable" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">'; // 등록된 내용이 없습니다.
	 			html += '			<thead>';
	 			html += '				<tr>';
	 			html += '					<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>';// NO.
	 			html += '					<th scope="col"><spring:message code="std.label.date_time" /></th>'; // 일시
	 			html += '					<th scope="col"><spring:message code="std.label.type" /></th>'; // 구분
	 			html += '					<th scope="col" data-breakpoints="xs">IP</th>';
	 			html += '				</tr>';
	 			html += '			</thead>';
	 			html += '			<tbody>';
	 			submitHistoryReschJoinList.forEach(function(v, i) {
	 				var regDttmFmt = v.regDttm.length == 14 ? v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) : v.regDttm;
	 				
	 				html += '			<tr>';
		 			html += '				<td>' + (submitHistoryReschJoinList.length - i) + '</td>';
		 			html += '				<td>' + regDttmFmt + '</td>';
		 			html += '				<td>' + (v.deviceTypeCd || "") + '</td>';
		 			html += '				<td>' + (v.connIp || "") + '</td>';
		 			html += '			</tr>';
	 			});
	 			html += '			</tbody>';
	 			html += '		</table>';
	 			html += '	</div>';
	 			html += '</div>';
	 		});
	 		
	 		html += '</div>';
	 		
	 		$("#reschList").html(html);
			$(".reschListTable").footable();
			
			$('.ui.styled.accordion').accordion({
	   	        exclusive: false,
	   	        selector: {
	   	            trigger: '.title .left_cont'
	   	        }
	   	    });
	 	}
	 
	 	// 토론 제출/참여 목록 세팅
	 	function setForumList(list) {
	 		if(list.length == 0) {
	 			$("#forumList").html(getEmptyHtml());
	 			return;
	 		}
	 		
	 		var html = ''
	 		
	 		html += '<div class="ui styled fluid accordion week_lect_list">';
	 		
	 		list.forEach(function(v, i) {
	 			var forumStartDttmFmt = v.forumStartDttm.length == 14 ? v.forumStartDttm.substring(0, 4) + "." + v.forumStartDttm.substring(4, 6) + "." + v.forumStartDttm.substring(6, 8) + " " + v.forumStartDttm.substring(8, 10) + ":" + v.forumStartDttm.substring(10, 12) : v.forumStartDttm;
	 			var forumEndDttmFmt = v.forumEndDttm.length == 14 ? v.forumEndDttm.substring(0, 4) + "." + v.forumEndDttm.substring(4, 6) + "." + v.forumEndDttm.substring(6, 8) + " " + v.forumEndDttm.substring(8, 10) + ":" + v.forumEndDttm.substring(10, 12) : v.forumEndDttm;
	 			
	 			// 진행 상태
				var forumProgressNm = "";
				var forumProgressColor = "";
				
				if(v.forumProgress == "READY") {
					forumProgressNm = '<spring:message code="std.label.study_ready" />'; // 대기
					forumProgressColor = "fcGreen";
				} else if(v.forumProgress == "PROGRESS") {
					forumProgressNm = '<spring:message code="std.label.study_progress" />'; // 진행중
					forumProgressColor = "fcGreen";
				} else if(v.forumProgress == "END") {
					forumProgressNm = '<spring:message code="std.label.study_end" />'; // 학습종료
					forumProgressColor = "fcGreen";
				}
	 			
	 			// 참여 상태
				var joinStatusNm = "";
				var joinStatusColor = "";
				
	 			if(v.forumAtclCnt > 0 || v.forumCmntCnt > 0) {
	 				joinStatusNm = '<spring:message code="std.label.forum_join_y" />'; // 참여
					joinStatusColor = "fcBlue";
	 			} else {
	 				joinStatusNm = '<spring:message code="std.label.forum_join_n" />'; // 미참여
					joinStatusColor = "fcGrey";
	 			}
	 			
	 			html += '<div class="title">';
	 			html += '	<div class="title_cont">';
	 			html += '		<div class="left_cont">';
	 			html += '			<div class="lectTit_box flex_1">';
	 			html += '				<p class="lect_name"><span class="' + forumProgressColor + '">[' + forumProgressNm + ']</span> ' + v.forumTitle + '</p>';
	 			html += '				<span class="fcGrey"><small><spring:message code="std.label.period" /> : ' + forumStartDttmFmt + ' ~ ' + forumEndDttmFmt + '</small></span>'; // 기간
	 			html += '			</div>';
	 			if(v.scoreAplyYn == "Y" && (MENU_TYPE.indexOf("PROFESSOR") > -1 || (v.scoreOpenYn == "Y" && v.evalYn == "Y"))) {
	 			html += '			<div class="fcBlue f120 fweb">' + (v.evalYn == 'Y' && v.score != null && v.score !== '' ? v.score : '- ') + '<spring:message code="std.label.point" /></div>'; // 점
	 			}
	 			html += '			<div class="' + joinStatusColor + '">' + joinStatusNm + '</div>';
	 			html += '		</div>';
	 			html += '	</div>';
	 			html += '	<i class="dropdown icon ml20"></i>';
	 			html += '</div>';
	 			html += '<div class="content menu_off">';
	 			html += '	<h4 class="ui header transition visible"><spring:message code="std.label.forum_status" /></h4>'; // 토론 현황
	 			html += '	<table class="table type2 forumListTable" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">'; // 등록된 내용이 없습니다.
	 			html += '		<thead>';
	 			html += '			<tr>';
	 			html += '				<th scope="col"><spring:message code="std.label.forum_atcl_cnt" /></th>'; // 게시글 수
	 			html += '				<th scope="col"><spring:message code="std.label.forum_cmnt_cnt" /></th>'; // 댓글 수
	 			html += '			</tr>';
	 			html += '		</thead>';
	 			html += '		<tbody>';
	 			html += '			<tr>';
	 			html += '				<td>' + v.forumAtclCnt + '</td>';
	 			html += '				<td>' + v.forumCmntCnt + '</td>';
	 			html += '			</tr>';
	 			html += '		</tbody>';
	 			html += '	</table>';
	 			html += '</div>';
	 		});
	 		
	 		html += '</div>';
	 		
	 		$("#forumList").html(html);
	 		$(".forumListTable").footable();
	 		
	 		$('.ui.styled.accordion').accordion({
	   	        exclusive: false,
	   	        selector: {
	   	            trigger: '.title .left_cont'
	   	        }
	   	    });
	 	}
	 	
	 	function getEmptyHtml() {
			var emptyHtml = '';
	   		emptyHtml += '<div class="flex-container" style="min-height: 150px !important;">';
	   		emptyHtml += '	<div class="cont-none">';
	   		emptyHtml += '		<span><spring:message code="common.content.not_found" /></span>';
	   		emptyHtml += '	</div>';
	   		emptyHtml += '</div>';
	   		return emptyHtml;
	 	}
	 	
	 	// 다운로드
	 	function fileDown(fileSn, repoCd) {
	 		var url  = "/common/fileInfoView.do";
			var data = {
				"fileSn" : fileSn,
				"repoCd" : repoCd
			};
			
			ajaxCall(url, data, function(data) {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "downloadForm");
				form.attr("id", "downloadForm");
				form.attr("target", "downloadIfm");
				form.attr("action", data);
				form.appendTo("body");
				form.submit();
				
				$("#downloadForm").remove();
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
	 	}
	 	
	 	// byte 포멧 변환
		function formatBytes(bytes) {
			if (bytes === 0) return '0 Bytes';
			var decimals = 2;
			var k = 1024;
			var dm = decimals < 0 ? 0 : decimals;
			var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
			var i = Math.floor(Math.log(bytes) / Math.log(k));
			return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
		}
	 	
	 	// 수강생 메세지 보내기
	   	function sendMsg() {
	   		if(!STD_INFO) {
	 			alert('<spring:message code="std.alert.no_select_user" />'); // 선택된 사용자가 없습니다.
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
		<div class="option-content gap4 ">
            <div class="sec_head mra">
            	<spring:message code="common.label.students.info" /><!-- 수강생 정보 -->
            </div>
            <c:if test="${menuType.contains('PROFESSOR')}">
           		<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
        	</c:if>
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
			<c:if test="${vo.searchKey eq 'ASMNT'}">
				<div class="" id="asmntList">
		        </div>
			</c:if>
			<c:if test="${vo.searchKey eq 'QUIZ'}">
		        <div class="" id="quizList">
		        </div>
			</c:if>
			<c:if test="${vo.searchKey eq 'RESCH'}">
		        <div class="" id="reschList">
		        </div>
			</c:if>
			<c:if test="${vo.searchKey eq 'FORUM'}">
		        <div class="" id="forumList">
		        </div>
			</c:if>
		</div>
	
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="download frame"></iframe>
</body>
</html>