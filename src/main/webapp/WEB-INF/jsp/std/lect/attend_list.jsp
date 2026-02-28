<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		var tabCd = '<c:out value="${vo.tabCd}" />';
		
		if(!tabCd || tabCd == 1) {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					// 수강생 학습현황
					listStdAttend();
				}
			});
			
			// 주차별 미학습자 비율
			getNoAttendRateByWeek();
			
			// 수강생 학습현황
			listStdAttend();
		} else if(tabCd == 2) {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					// 학습요소 참여현황 목록
					listStdJoinStatus();
				}
			});
			
			// 학습요소 참여현황 목록
			listStdJoinStatus();
		}
	});
	
	// 탭이동
	function moveTab(tabCd) {
		var url = '/std/stdLect/Form/attendList.do'
		
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tabForm");
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${vo.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'tabCd', value: tabCd}));
		form.attr("action", url);
		form.appendTo("body");
		form.submit();
	}
	
	// tab-1. 주차별 미학습자 비율
	function getNoAttendRateByWeek() {
		var url  = "/std/stdLect/noAttendRateByWeek.do";
		var data = {
			  crsCreCd : '<c:out value="${vo.crsCreCd}" />'
			, searchAuditYn : $("#searchAuditYn").is(":checked") ? 'Y' : 'N'
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				
				if(returnVO) {
					$.each($("[data-lesson-schedule-id]"), function() {
						var id = $(this).data("lessonScheduleId");
						var weekRate = returnVO["weekRate_" + id];
						
						weekRate = (weekRate == null || weekRate == "") ? "/" : weekRate;
						
						if(weekRate != "/") {
							weekRate = '<a href="javascript:void(0)" class="fcBlue" onclick="noAttentListWeekModal(\'' + id + '\')">' + weekRate + '</a>';
						}
						
						$("#weekRateText_" + id).html(weekRate);
					});
					
					$("#weekAvgText").html(returnVO.weekAvg);
				}
	    	}
		}, function(xhr, status, error) {
		});
	}
	
	// tab-1. 수강생 학습현황
	function listStdAttend() {
		if($("#searchTo").val() != "" && $("#searchFrom").val() == "") {
			/* 종료 주차를 선택해주세요. */
			alert('<spring:message code="common.label.lesson.schedule.end.select" />');
			return false;
		}
		if($("#searchTo").val() == "" && $("#searchFrom").val() != "") {
			/* 시작 주차를 선택해주세요. */
			alert('<spring:message code="common.label.lesson.schedule.start.select" />');
			return false;
		}
		if($("#searchTo").val() != "" && $("#searchFrom").val() != "") {
			if(1 * $("#searchTo").val() > 1 * $("#searchFrom").val()) {
				/*종료 주차는 시작 주차보다 빠를 수 없습니다.  */
				alert('<spring:message code="common.label.lesson.schedule.end.start" />');
				return false;
			}
		}
		
		var url  = "/std/stdLect/listStdAttend.do";
		var data = {
			  crsCreCd : '<c:out value="${vo.crsCreCd}" />'
			, searchValue: $("#searchValue").val()
			, searchTo: $("#searchTo").val()
			, searchFrom: $("#searchFrom").val()
			, searchAuditYn : $("#searchAuditYn").is(":checked") ? 'Y' : 'N'
		};
				
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				var univGbn = "${creCrsVO.univGbn}";
				
				var completeIcon = '<span class=""><i class="ico icon-solid-circle fcBlue"></i></span>';
				var lateIcon = '<span class=""><i class="ico icon-triangle fcYellow"></i></span>';
				var nostudyIcon = '<span class=""><i class="ico icon-cross fcRed"></i></span>';
				var emptyIcon = '<span class=""><i class="ico icon-slash"></i></span>';
				var readyIcon = '<span class=""><i class="ico icon-hyphen"></i></span>';
				//var ingIcon = '<span class=""><i class="fcBlue ico icon-state-ing"></i></span>';
				
				returnList.forEach(function(v, i) {
					html += '<tr>';
					html += '	<td class="tc">';
					html += '		<div class="ui checkbox">';
					html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" user_nm="'+v.userNm+'" mobile="'+v.mobileNo+'" email="'+v.email+'" />';
					html += '		</div>';
					html += '	</td>';
					html += '	<td class="tc lineNo">' + v.lineNo + '</td>';
					html += '	<td class="tl word_break_none">' + (v.deptNm || '') + '</td>';
					html += '	<td class="">' + v.userId + '</td>';
					html += '	<td class="tc">' + (v.hy || '-') + '</td>';
					if(univGbn == "3" || univGbn == "4") {
						html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
					}
					html += '	<td class="tc word_break_none" data-sort-value="' + v.userNm + '">';
					html += '		<a href="javascript:void(0)" class="fcBlue" onclick="studyStatusModal(\'' + v.stdNo + '\')">' + v.userNm + '</a>';
					html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
					html += '	</td>';
					
					var completeCnt = 0;
					var lateCnt = 0;
					var noStudyCnt = 0;
					
					$.each($("[data-lesson-schedule-id]"), function() {
						html += '<td class="p5 w40">';
						var id = $(this).data("lessonScheduleId");
						var startDtYn = $(this).data("startDtYn");
						var endDtYn = $(this).data("endDtYn");
						var wekClsfGbn = $(this).data("wekClsfGbn");
						var prgrVideoCnt = 1 * $(this).data("prgrVideoCnt");
						
						const parts = id.split('_'); // 1) '_' 기준 split ["LS", "202510CME0000114"]
						const first = parts[0].charAt(0).toUpperCase() + parts[0].slice(1).toLowerCase(); // 2) 첫 파트: 'Ls' 
						const second = parts[1].toLowerCase(); // 3) 두 번째 파트: 소문자 '202510cme0000114'
						
						/* var studyStatusCd = v["stuSttCd_" + id]; */ // oracle로 바뀌면서 별칭이 카멜케이스로 변경되어 수정 
						var studyStatusCd = v["stuSttCd" + first + second];
						
						if(wekClsfGbn == "04" || wekClsfGbn == "05") {
							html += readyIcon;
						} else {
							if(!(wekClsfGbn == "02" || wekClsfGbn == "03") && prgrVideoCnt == 0) {
								if(startDtYn == "N") {
									html += emptyIcon;
								} else {
									html += readyIcon;
								}
							} else if(studyStatusCd == "COMPLETE") {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + id + '\', \'' + v.stdNo + '\')">' + completeIcon + '</a>';
								completeCnt++;
							} else if(studyStatusCd == "LATE") {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + id + '\', \'' + v.stdNo + '\')">' + lateIcon + '</a>';
								lateCnt++;
							} else if(startDtYn == "N") {
								html += emptyIcon;
							} else if(startDtYn == "Y" && endDtYn == "N") {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + id + '\', \'' + v.stdNo + '\')">' + readyIcon + '</a>';
							} else {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + id + '\', \'' + v.stdNo + '\')">' + nostudyIcon + '</a>';
								noStudyCnt++;
							}
						}
						html += '</td>';
					});
					
					html += '	<td class="tc">';
					html += '		<div style="min-width: 120px;">';
					html += '			<span class="ui blue circular label">' + completeCnt + '</span>';
					html += '			<span class="ui yellow circular label">' + lateCnt + '</span>';
					html += '			<span class="ui red circular label">' + noStudyCnt + '</span>';
					html += '		</div>';
					html += '	</td>';
					html += '</tr>';
				});
				
				$("#attendList").empty().html(html);
	  			$("#attendListTable").footable();
	  			$("#attendListTable").find(".ui.checkbox").checkbox();
	  			
	  			// 총
	  			$("#attendListCntText").text(returnList.length);
	  			
	  			// 정렬후 No 재설정
				$('#attendListTable').on('after.ft.sorting', function(e) {
					var tbList = $('#attendListTable').find("td.lineNo");
			    	if (tbList.length > 0) {
			    		for (var i=0; i < tbList.length; i++) {
			    			$(tbList[i]).html(i+1);
			    		}
			    	}
				});
	  			
	    	} else {
	    		alert(data.message);
	    		// 총
	  			$("#attendListCntText").text("0");
	    	}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
			// 총
  			$("#attendListCntText").text("0");
		}, true);
	}
	
	// tab-1. 수강생 학습현황 리스트 전체 선택
	function checkAllAttendList(checked) {
		$("#attendListTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
	}
	
	// tab-1. 수강생 학습현황 엑셀 다운로드
	function downExcelAttendList() {
		var univGbn = "${creCrsVO.univGbn}";
		var excelGrid = { colModel: [] };

		excelGrid.colModel.push({label: '<spring:message code="main.common.number.no" />', name: 'lineNo', align: 'right', width: '1000'}); // NO
		excelGrid.colModel.push({label: '<spring:message code="std.label.crscre_nm" />', name: 'crsCreNm', align: 'left', width: '5000'}); // 과목명
		excelGrid.colModel.push({label: '<spring:message code="std.label.decls" />', name: 'declsNo', align: 'center', width: '2500'}); // 분반
		excelGrid.colModel.push({label: '<spring:message code="std.label.name" />', name: 'userNm', align: 'left', width: '5000'}); // 이름
		excelGrid.colModel.push({label: '<spring:message code="std.label.user_id" />', name: 'userId', align: 'center', width: '5000'}); // 학번
		excelGrid.colModel.push({label: '<spring:message code="std.label.hy" />', name: 'hy', align: 'center', width: '2500', defaultValue: '-'}); // 학년
		if(univGbn == "3" || univGbn == "4") {
			excelGrid.colModel.push({label: '<spring:message code="common.label.grsc.degr.cors.gbn" />', name: 'grscDegrCorsGbnNm', align: 'left', width: '4000'}); // 학위과정
		}
		excelGrid.colModel.push({label: '<spring:message code="std.label.dept" />', name: 'deptNm', align: 'left', width: '5000'}); // 학과
		
		$.each($("[data-lesson-schedule-id]"), function() {
			var lessonScheduleId = $(this).data("lessonScheduleId");
			var name = this.innerText || "";
			
			const parts = lessonScheduleId.split('_'); // 1) '_' 기준 split ["LS", "202510CME0000114"]
			const first = parts[0].charAt(0).toUpperCase() + parts[0].slice(1).toLowerCase(); // 2) 첫 파트: 'Ls' 
			const second = parts[1].toLowerCase(); // 3) 두 번째 파트: 소문자 '202510cme0000114'
			
			excelGrid.colModel.push(
				{label: name,	name:'studyStatusIcon' + first + second,	align:'center',    	width:'2000'}
				// {label: name,	name:'studyStatusIcon' + lessonScheduleId,	align:'center',    	width:'2000'} // // oracle로 바뀌면서 별칭이 카멜케이스로 변경되어 수정
			);
		});
		
		excelGrid.colModel.push(
			  {label: '<spring:message code="std.label.attend" />',		name:'completeCnt',	align:'right',	width:'2000'} // 출석
			, {label: '<spring:message code="std.label.late" />',		name:'lateCnt',		align:'right',	width:'2000'} // 지각
			, {label: '<spring:message code="std.label.noattend" />',	name:'noStudyCnt',	align:'right',	width:'2000'} // 결석
		);
		
		var url  = "/std/stdLect/downExcelStdAttendList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    	value: '<c:out value="${vo.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'searchAuditYn', 	value: $("#searchAuditYn").is(":checked") ? 'Y' : 'N'}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   	value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}
	
	// tab-2. 학습요소 참여현황 목록
	function listStdJoinStatus() {

		showLoading();

		var url  = "/std/stdLect/listStdJoinStatus.do";
		var data = {
			  crsCreCd : '<c:out value="${vo.crsCreCd}" />'
			, searchValue: $("#searchValue").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				var univGbn = "${creCrsVO.univGbn}";
				
				returnList.forEach(function(v, i) {
					html += '<tr>';
					html += '	<td>';
					html += '		<div class="ui checkbox">';
					html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" user_nm="'+v.userNm+'" mobile="'+v.mobileNo+'" email="'+v.email+'" />';
					html += '		</div>';
					html += '	</td>';
					html += '	<td class="lineNo">' + v.lineNo + '</td>';
					html += '	<td class="word_break_none">' + (v.deptNm || "-") + '</td>';
					html += '	<td>' + v.userId + '</td>';
					html += '	<td>' + (v.hy || '-') + '</td>';
					if(univGbn == "3" || univGbn == "4") {
						html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
					}
					html += '	<td class="word_break_none" data-sort-value="' + v.userNm + '">';
					html += '       <a href="javascript:void(0)" class="fcBlue" onclick="studyStatusModal(\'' + v.stdNo + '\')">' + v.userNm + '</a>';
					html +=			userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
					html += '   </td>';
					//html += '	<td>' + v.ansCnt + ' (' + v.qstnCnt + ')</td>';
					//html += '	<td>' + v.forumCmntCnt + '</td>';
					html += '	<td><a href="javascript:void(0)" class="fcBlue" onclick="submitJoinHistoryModal(\'' + v.stdNo + '\', \'ASMNT\')">' + v.asmntJoinCnt + '/' + v.asmntCnt + '</a></td>';
					html += '	<td><a href="javascript:void(0)" class="fcBlue" onclick="submitJoinHistoryModal(\'' + v.stdNo + '\', \'FORUM\')">' + v.forumJoinCnt + '/' + v.forumCnt + '</a></td>';
					html += '	<td><a href="javascript:void(0)" class="fcBlue" onclick="submitJoinHistoryModal(\'' + v.stdNo + '\', \'QUIZ\')">' + v.quizJoinCnt + '/' + v.quizCnt + '</a></td>';
					html += '	<td><a href="javascript:void(0)" class="fcBlue" onclick="submitJoinHistoryModal(\'' + v.stdNo + '\', \'RESCH\')">' + v.reschJoinCnt + '/' + v.reschCnt + '</a></td>';
					html += '	<td>' + (v.midExamScore || '-') + '</td>';
					html += '	<td>' + (v.finalExamScore || '-') + '</td>';
					html += '</tr>';
				});
				
				$("#joinStatusList").empty().html(html);
	  			$("#joinStatusListTable").footable();
	  			$("#joinStatusListTable").find(".ui.checkbox").checkbox();
	  			
	  			// 총
	  			$("#joinStatusListCntText").text(returnList.length);
	  			
	  			// 정렬후 No 재설정
				$('#joinStatusListTable').on('after.ft.sorting', function(e) {
					var tbList = $('#joinStatusListTable').find("td.lineNo");
			    	if (tbList.length > 0) {
			    		for (var i=0; i < tbList.length; i++) {
			    			$(tbList[i]).html(i+1);
			    		}
			    	}
				});
	  			
	    	} else {
	    		alert(data.message);
	    		// 총
	    		$("#joinStatusListCntText").text("0");
	    	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			// 총
			$("#joinStatusListCntText").text("0");
		});
	}
	
	// tab-2. 학습요소 참여현황 리스트 전체 선택
	function checkAllJoinStatus(checked) {
		$("#joinStatusListTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
	}
	
	// tab-2. 학습요소 참여현황 엑셀 다운로드
	function downExcelJoinStatus() {
		var univGbn = "${creCrsVO.univGbn}";
		
		var excelGrid = { colModel: [] };

		excelGrid.colModel.push({label: '<spring:message code="main.common.number.no" />', name: 'lineNo', align: 'right', width: '1000'}); // NO
		excelGrid.colModel.push({label: '<spring:message code="std.label.dept" />', name: 'deptNm', align: 'left', width: '5000'}); // 학과
		excelGrid.colModel.push({label: '<spring:message code="std.label.user_id" />', name: 'userId', align: 'center', width: '5000'}); // 학번
		excelGrid.colModel.push({label: '<spring:message code="std.label.hy" />', name: 'hy', align: 'center', width: '2500', defaultValue: '-'}); // 학년
		if(univGbn == "3" || univGbn == "4") {
			excelGrid.colModel.push({label: '<spring:message code="common.label.grsc.degr.cors.gbn" />', name: 'grscDegrCorsGbnNm', align: 'left', width: '4000'}); // 학위과정
		}
		excelGrid.colModel.push({label: '<spring:message code="std.label.name" />', name: 'userNm', align: 'left', width: '5000'}); // 이름
		excelGrid.colModel.push({label: '<spring:message code="std.label.asmnt" /> (<spring:message code="std.label.submit" />)', name: 'asmntJoinCnt', align: 'right', width: '2500'}); // 과제 (제출)
		excelGrid.colModel.push({label: '<spring:message code="std.label.asmnt" /> (<spring:message code="std.label.total" />)', name: 'asmntCnt', align: 'right', width: '2500'}); // 과제 (전체)
		excelGrid.colModel.push({label: '<spring:message code="std.label.forum" /> (<spring:message code="std.label.submit" />)', name: 'forumJoinCnt', align: 'right', width: '2500'}); // 토론 (제출)
		excelGrid.colModel.push({label: '<spring:message code="std.label.forum" /> (<spring:message code="std.label.total" />)', name: 'forumCnt', align: 'right', width: '2500'}); // 토론 (전체)
		excelGrid.colModel.push({label: '<spring:message code="std.label.quiz" /> (<spring:message code="std.label.submit" />)', name: 'quizJoinCnt', align: 'right', width: '2500'}); // 퀴즈 (제출)
		excelGrid.colModel.push({label: '<spring:message code="std.label.quiz" /> (<spring:message code="std.label.total" />)', name: 'quizCnt', align: 'right', width: '2500'}); // 퀴즈 (전체)
		excelGrid.colModel.push({label: '<spring:message code="std.label.resch" /> (<spring:message code="std.label.submit" />)', name: 'reschJoinCnt', align: 'right', width: '2500'}); // 설문 (제출)
		excelGrid.colModel.push({label: '<spring:message code="std.label.resch" /> (<spring:message code="std.label.total" />)', name: 'reschCnt', align: 'right', width: '2500'}); // 설문 (전체)
		excelGrid.colModel.push({label: '<spring:message code="std.label.mid_exam" />', name: 'midExamScore', align: 'right', width: '2500'}); // 중간고사
		excelGrid.colModel.push({label: '<spring:message code="std.label.final_exam" />', name: 'finalExamScore', align: 'right', width: '2500'}); // 기말고사

		
		var url  = "/std/stdLect/downExcelStdJoinStatus.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    value: '<c:out value="${vo.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}
	
	// tab-1. 주차 미학습자 목록 팝업
	function noAttentListWeekModal(lessonScheduleId) {
		var frameId = "noAttentListWeekIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#noAttentListWeekForm > input[name='lessonScheduleId']").val(lessonScheduleId);
		$("#noAttentListWeekForm").attr("target", frameId);
        $("#noAttentListWeekForm").attr("action", "/std/stdPop/noAttentListWeekPop.do");
        $("#noAttentListWeekForm").submit();
        $('#noAttentListWeekModal').modal('show');
        
        $("#noAttentListWeekForm > input[name='lessonScheduleId']").val("");
	}
	
	// tab-1. 주차별 학습현황 상세 팝업
	function studyStatusByWeekModal(lessonScheduleId, stdNo) {
		// 모달 iframe 초기화
		var frameId = "studyStatusByWeekIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#studyStatusByWeekForm > input[name='lessonScheduleId']").val(lessonScheduleId);
		$("#studyStatusByWeekForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusByWeekForm").attr("target", frameId);
        $("#studyStatusByWeekForm").attr("action", "/std/stdPop/studyStatusByWeekPop.do");
        $("#studyStatusByWeekForm").submit();
        $('#studyStatusByWeekModal').modal('show');
        
        $("#studyStatusByWeekForm > input[name='lessonScheduleId']").val("");
        $("#studyStatusByWeekForm > input[name='stdNo']").val("");
	}
	
	// tab-2. 제출/참여 이력 팝업
	function submitJoinHistoryModal(stdNo, searchKey) {
		// 모달 iframe 초기화
		var frameId = "submitJoinHistoryIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#submitJoinHistoryForm > input[name='searchKey']").val(searchKey);
		$("#submitJoinHistoryForm > input[name='stdNo']").val(stdNo);
		$("#submitJoinHistoryForm").attr("target", frameId);
        $("#submitJoinHistoryForm").attr("action", "/std/stdPop/submitJoinHistoryPop.do");
        $("#submitJoinHistoryForm").submit();
        $('#submitJoinHistoryModal').modal('show');
        
        $("#submitJoinHistoryForm > input[name='searchKey']").val("");
        $("#submitJoinHistoryForm > input[name='stdNo']").val("");
	}
	
	// 수강생 학습현황 팝업
	function studyStatusModal(stdNo) {
		var frameId = "studyStatusModalIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#studyStatusForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusForm").attr("target", frameId);
        $("#studyStatusForm").attr("action", "/std/stdPop/studyStatusPop.do");
        $("#studyStatusForm").submit();
        $('#studyStatusModal').modal('show');
        
        $("#studyStatusForm > input[name='stdNo']").val("");
	}
	
	// 강제 출석 처리 콣백
	function saveForcedAttendCallBack() {
		getNoAttendRateByWeek();
		listStdAttend();
	}
	
	// 강제 출석 취소 콣백
	function cancelForcedAttendCallBack() {
		getNoAttendRateByWeek();
		listStdAttend();
	}
	
	// 수강생 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		
		var listTable = $('#attendList');
		var tabCd = '<c:out value="${vo.tabCd}" />';
		if(!tabCd || tabCd == 1) {
			listTable = $('#attendList');
		} else if(tabCd == 2) {
			listTable = $('#joinStatusList');
		}
		
		$.each(listTable.find("input:checkbox[name=userIds]:not(:disabled):checked"), function(){
			sendCnt++;
			if (sendCnt > 1) rcvUserInfoStr += "|";
			rcvUserInfoStr += $(this).val();
			rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
			rcvUserInfoStr += ";" + $(this).attr("mobile");
			rcvUserInfoStr += ";" + $(this).attr("email"); 
		});
		
		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert('<spring:message code="common.alert.sysmsg.select_user"/>');
			return;
		}
		
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

        var form = document.alarmForm;
        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
	}
	
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap" class="pusher">
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
		
		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
			
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
		        <div class="ui form">
		        	<div class="layout2">
		        		<!-- 타이틀 -->
						<div id="info-item-box">
							<script>
								$(document).ready(function () {
									// set location
									setLocationBar("<spring:message code='std.label.attend_status' />/<spring:message code='lesson.label.study.status' />");
								});
							</script>
						
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
		                    	<spring:message code="std.label.attend_status" />/<spring:message code="lesson.label.study.status" /><!-- 출석현황 --><!-- 학습현황 -->
	                    	</h2>
		                    <div class="button-area">
		                    </div>
		                </div>
		                
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
								
								<div class="listTab mb10">
			                        <ul>
			                            <li onclick="moveTab(1)" class="mw120 <c:if test="${empty vo.tabCd or vo.tabCd eq 1}">select</c:if>"><a href="javascript:void(0)"><spring:message code="std.label.study_status_week" /><!-- 주차별 학습현황 --></a></li>
			                            <li onclick="moveTab(2)" class="mw120 <c:if test="${vo.tabCd eq 2}">select</c:if>"><a href="javascript:void(0)"><spring:message code="std.label.lesson_cnt_join_status" /><!-- 학습요소 참여현황 --></a></li>
			                        </ul>
			                    </div>
			                    
							<c:if test="${empty vo.tabCd or vo.tabCd eq 1}">
								<!-- 컬럼 width 계산 -->
								<c:set var="totalCnt" value="0"></c:set>
								<c:forEach items="${listLessonSchedule}" var="row">
									<c:set var="totalCnt" value="${totalCnt + 1}" />
								</c:forEach>
								<c:set var="colWidth" value="${90 / totalCnt}" />
								
			                    <h3 class="mb10">•&nbsp;<spring:message code="std.label.nostudy_rate_week" /><!-- 주차별 미학습자 비율 --></h3>
			                    <table class="table type2">
									<thead>
										<tr>
											<th scope="col" class="wf5"><spring:message code="std.label.type" /><!-- 구분 --></th>
										<c:forEach items="${listLessonSchedule}" var="row">
											<th scope="col" class="p5 tc" data-breakpoints="xs" style="width: <c:out value="${colWidth}" />%">
												<c:out value="${row.lessonScheduleOrder}" />
											</th>
										</c:forEach>
											<th scope="col" class="wf5"><spring:message code="std.label.avg" /><!-- 평균 --></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><spring:message code="std.label.rate" /><!-- 비율 --></td>
											<c:forEach items="${listLessonSchedule}" var="row">
												<td id="weekRateText_<c:out value="${row.lessonScheduleId}" />" class="tc">/</td>
			                    			</c:forEach>
											<td id="weekAvgText" class="tc">-</td>
										</tr>
									</tbody>
								</table>
			                    
			                    <h3 class="mb10">•&nbsp;<spring:message code="std.label.learner_status" /><!-- 수강생 학습현황 -->&nbsp;(<spring:message code="std.label.total_cnt" /><!-- 총 -->&nbsp;:&nbsp;<span id="attendListCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h3>
			                    <!-- 검색조건 -->
								<div class="option-content mb10">
									<select class="ui dropdown" id="searchTo">
										<option value=""><spring:message code="common.label.schedule.absence" /></option><!-- 결석주차 -->
										<c:forEach var="item" items="${listLessonSchedule }">
											<option value="${item.lessonScheduleOrder }">${item.lessonScheduleNm }</option>
										</c:forEach>
									</select>
									~
									<select class="ui dropdown" id="searchFrom">
										<option value=""><spring:message code="common.label.schedule.absence" /></option><!-- 결석주차 -->
										<c:forEach var="item" items="${listLessonSchedule }">
											<option value="${item.lessonScheduleOrder }">${item.lessonScheduleNm }</option>
										</c:forEach>
									</select>
									<div class="ui action input search-box">
										<input id="searchValue" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="listStdAttend()">
											<i class="search icon"></i>
										</button>
									</div>
									<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
									<div class="ui checkbox ml5 mr5">
                                        <input type="checkbox" id="searchAuditYn" value="Y" onchange="listStdAttend(); getNoAttendRateByWeek();" />
                                        <label class="toggle_btn" for="docFile06"><spring:message code="std.label.auditor.include" /><!-- 청강생 포함 --></label>
                                    </div>
                                    </c:if>
									<div class="flex-item">
										<i class="ico icon-solid-circle fcBlue"></i><spring:message code="std.label.attend" /><!-- 출석 -->
									</div>
									<div class="flex-item">
										<i class="ico icon-triangle fcYellow"></i><spring:message code="std.label.late" /><!-- 지각 -->
									</div>
									<div class="flex-item">
										<i class="ico icon-cross fcRed"></i><spring:message code="std.label.noattend" /><!-- 결석 -->
									</div>
									<div class="flex-left-auto">
										<a href="javascript:void(0)" onclick="downExcelAttendList();return false;" class="ui basic small button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
										<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
									</div>
								</div>
								
								<table id="attendListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
									<thead>
										<tr id="attendListHead">
											<th scope="col" data-sortable="false" class="tc chk">
	                                            <div class="ui checkbox">
	                                                <input type="checkbox" onchange="checkAllAttendList(this.checked)" />
	                                            </div>
	                                        </th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" data-type="number" class="num tc"><spring:message code="main.common.number.no" /><!-- NO. --></th>
											<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="std.label.dept" /><!-- 학과 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.user_id" /><!-- 학번 --></th>
											<th scope="col" class="tc word_break_none"><spring:message code="std.label.hy" /><!-- 학년 --></th>
											<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
												<th scope="col" class="tc"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
											</c:if>
											<th scope="col" class="tc"><spring:message code="std.label.name" /><!-- 이름 --></th>
											<c:forEach items="${listLessonSchedule}" var="row">
												<th scope="col" class="tc p5" data-sortable="false" data-breakpoints="xs" data-lesson-schedule-id="<c:out value="${row.lessonScheduleId}" />" data-start-dt-yn="<c:out value="${row.startDtYn}" />" data-end-dt-yn="<c:out value="${row.endDtYn}" />" data-wek-clsf-gbn="<c:out value="${row.wekClsfGbn}" />" data-prgr-video-cnt="<c:out value="${row.prgrVideoCnt}" />">
													<c:out value="${row.lessonScheduleOrder}" />
												</th>
											</c:forEach>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.attend" /><!-- 출석 -->/<spring:message code="std.label.late" /><!-- 지각 -->/<spring:message code="std.label.noattend" /><!-- 결석 --></th>
										</tr>
									</thead>
									<tbody id="attendList">
									</tbody>
								</table>
								
								<div class="tr">
									<a href="javascript:void(0)" onclick="downExcelAttendList();return false;" class="ui basic small button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
									<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
								</div>
                            </c:if>
                            
                            <c:if test="${vo.tabCd eq 2}">
                            	<h3 class="mb10">•&nbsp;<spring:message code="std.label.lesson_cnt_join_status" /><!-- 학습요소 참여현황 -->&nbsp;(<spring:message code="std.label.total_cnt" /><!-- 총 --> : <span id="joinStatusListCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h3>
                            	
                            	<!-- 검색조건 -->
								<div class="option-content mb10">
									<div class="ui action input search-box">
										<input id="searchValue" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="listStdJoinStatus()">
											<i class="search icon"></i>
										</button>
									</div>
									<div class="flex-left-auto">
										<a href="javascript:void(0)" onclick="downExcelJoinStatus();return false;" class="ui basic small button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
										<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
									</div>
								</div>
								<table id="joinStatusListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
									<thead>
										<tr>
											<th scope="col" data-sortable="false" class="chk">
	                                            <div class="ui checkbox">
	                                                <input type="checkbox" onchange="checkAllJoinStatus(this.checked)" />
	                                            </div>
	                                        </th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" data-type="number" class="num"><spring:message code="main.common.number.no" /><!-- NO. --></th>
											<th scope="col" data-breakpoints="xs"><spring:message code="std.label.dept" /><!-- 학과 --></th>
											<th scope="col"><spring:message code="std.label.user_id" /><!-- 학번 --></th>
											<th scope="col" class="word_break_none"><spring:message code="std.label.hy" /><!-- 학년 --></th>
											<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
												<th scope="col" class="tc"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
											</c:if>
											<th scope="col"><spring:message code="std.label.name" /><!-- 이름 --></th>
											<%-- <th scope="col" data-breakpoints="xs">Q&A<br /><spring:message code="std.label.eval_select" /><!-- 평가선정 --></th> --%>
											<%-- <th scope="col" data-breakpoints="xs"><spring:message code="std.label.forum_room" /><!-- 토론방 --><br />(<spring:message code="std.label.comment_cnt" /><!-- 댓글수 -->)</th> --%>
											<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="std.label.asmnt" /><!-- 과제 --><br />(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>
											<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="std.label.forum" /><!-- 토론 --><br />(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>
											<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="std.label.quiz" /><!-- 퀴즈 --><br />(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>
											<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="std.label.resch" /><!-- 설문 --><br />(<spring:message code="std.label.submit" /><!-- 제출 -->/<spring:message code="std.label.total" /><!-- 전체 -->)</th>
											<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="std.label.mid_exam" /><!-- 중간고사 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="std.label.final_exam" /><!-- 기말고사 --></th>
										</tr>
									</thead>
									<tbody id="joinStatusList">
									</tbody>
								</table>
								
								<div class="tr">
									<a href="javascript:void(0)" onclick="downExcelJoinStatus();return false;" class="ui basic small button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
									<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
								</div>
                            </c:if>
                            </div><!-- //col -->
                        </div><!-- //row -->
		        	</div><!-- //layout2 -->
		        </div><!-- //ui form -->
			</div><!-- //content stu_section -->
			
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div><!-- //container -->
	</div><!-- //wrap -->
	
	<!-- 수강생 학습현황 팝업 --> 
	<form id="studyStatusForm" name="studyStatusForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}" />" />
		<input type="hidden" name="stdNo" />
	</form>
    <div class="modal fade in" id="studyStatusModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.learner_status" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="std.label.learner_status" /><!-- 수강생 학습현황 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="studyStatusModalIfm" name="studyStatusModalIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 주차 미학습자 목록 팝업 --> 
	<form id="noAttentListWeekForm" name="noAttentListWeekForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}" />" />
		<input type="hidden" name="lessonScheduleId" value="" />
	</form>
    <div class="modal fade in" id="noAttentListWeekModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.nostudy_rate_list" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="std.label.nostudy_rate_list" /><!-- 주차 미학습자 목록  --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="noAttentListWeekIfm" name="noAttentListWeekIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 주차별 학습현황 상세 팝업 --> 
	<form id="studyStatusByWeekForm" name="studyStatusByWeekForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}" />" />
		<input type="hidden" name="lessonScheduleId" value="" />
		<input type="hidden" name="stdNo" />
	</form>
    <div class="modal fade in" id="studyStatusByWeekModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.study_status_detail_week" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="std.label.study_status_detail_week" /><!-- 주차별 학습현황 상세 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="studyStatusByWeekIfm" name="studyStatusByWeekIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 제출/참여 이력 팝업 --> 
	<form id="submitJoinHistoryForm" name="submitJoinHistoryForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}" />" />
		<input type="hidden" name="stdNo" />
		<input type="hidden" name="searchKey" />
	</form>
    <div class="modal fade in" id="submitJoinHistoryModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.submit_join_history" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="std.label.submit_join_history" /><!-- 제출/참여 이력 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="submitJoinHistoryIfm" name="submitJoinHistoryIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>