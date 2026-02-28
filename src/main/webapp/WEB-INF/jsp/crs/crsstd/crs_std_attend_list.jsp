<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<style>
	.bcBlueAlpha15 {  background: var(--blue-alpha15) !important;}
</style>
<script type="text/javascript">
	var USER_DEPT_LIST;
	var CRS_CRE_LIST;

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
		var data = {
		};
		
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
		
		// 학기 과목정보 조회
		var url = "/crs/creCrsHome/listCrsCreDropdown.do";
		var data = {
			  creYear	: $("#haksaYear").val()
			, creTerm	: $("#haksaTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				CRS_CRE_LIST = returnList.sort(function(a, b) {
					if(a.crsCreNm < b.crsCreNm) return -1;
					if(a.crsCreNm > b.crsCreNm) return 1;
					if(a.crsCreNm == b.crsCreNm) {
						if(a.declsNo < b.declsNo) return -1;
						if(a.declsNo > b.declsNo) return 1;
					}
					return 0;
				});
				
				// 대학 구분 변경
				changeUnivGbn("ALL");
				
				$("#univGbn").on("change", function() {
					changeUnivGbn(this.value);
				});
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		}, true);
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
	
	// 강의실 목록 조회
	function getCrsCreList() {
		lessonStautsListTable.clearData();
		
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
				
				$("#totalCntText").text(returnList.length);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		}, true);
	}
	
	// 주차별 학습현황 목록 조회
	function listStdAttend(crsCreCd) {
		var deferred = $.Deferred();
		
		var url = "/lesson/lessonHome/listLessonSchedule.do";
		var data = {
			crsCreCd : crsCreCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				// 주차별 학습현황 목록 세팅
				setStdAttendList(returnList);
				
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
	
	// 주차별 학습현황 목록 세팅
	function setStdAttendList(list) {
		var html = "";
		var colWidth = 90 / list.length;
		
		html += "<h3 class='mb10'>•&nbsp;<spring:message code='std.label.nostudy_rate_week' /></h3>";/* 주차별 미학습자 비율 */
		html += "<table class='table type2'>";
		html += "	<thead>";
		html += "		<tr>";
		html += "			<th scope='col' class='wf5'><spring:message code='std.label.type' /></th>";/* 구분 */
		list.forEach(function(v, i) {
		html += "			<th scope='col' class='p5 tc' data-breakpoints='xs' style='width:"+colWidth+"'>"+v.lessonScheduleOrder+"</th>";
		});
		html += "			<th scope='col' class='wf5'><spring:message code='std.label.avg' /></th>";/* 평균 */
		html += "		</tr>";
		html += "	</thead>";
		html += "	<tbody>";
		html += "		<tr>";
		html += "			<td><spring:message code='std.label.rate' /></td>";/* 비율 */
		list.forEach(function(v, i) {
		html += "			<td id='weekRateText_"+v.lessonScheduleId+"' class='tc'></td>";
		});
		html += "			<td id='weekAvgText' class='tc'>-</td>";
		html += "		</tr>";
		html += "	</tbody>";
		html += "</table>";
		html += "<h3 class='mb10'>•&nbsp;<spring:message code='std.label.learner_status' />&nbsp;(<spring:message code='std.label.total_cnt' />&nbsp;:&nbsp;<span id='attendListCntText'>0</span><spring:message code='message.person' />)</h3>";/* 수강생 학습현황 *//* 총 *//* 명 */
		html += "<div class='option-content mb10'>";
		html += "	<select class='ui dropdown' id='searchTo'>";
		html += "		<option value=''><spring:message code='common.label.schedule.absence' /></option>";/* 결석주차 */
		list.forEach(function(v, i) {
		html += "		<option value='"+v.lessonScheduleOrder+"'>"+v.lessonScheduleNm+"</option>";
		});
		html += "	</select>";
		html += "	~";
		html += "	<select class='ui dropdown' id='searchFrom'>";
		html += "		<option value=''><spring:message code='common.label.schedule.absence' /></option>";/* 결석주차 */
		list.forEach(function(v, i) {
		html += "		<option value='"+v.lessonScheduleOrder+"'>"+v.lessonScheduleNm+"</option>";
		});
		html += "	</select>";
		html += "	<div class='ui action input search-box'>";
		html += "		<input id='stdSearchValue' type='text' placeholder='" + "<spring:message code='std.common.placeholder' />" +"' />";
		html += "		<button class='ui icon button' type='button' onclick='listAttend()'><i class='search icon'></i></button>";
		html += "	</div>";
		html += "	<div class='flex-item'>";
		html += "		<i class='ico icon-solid-circle fcBlue'></i><spring:message code='std.label.attend' />";/* 출석 */
		html += "	</div>";
		html += "	<div class='flex-item'>";
		html += "		<i class='ico icon-triangle fcYellow'></i><spring:message code='std.label.late' />";/* 지각 */
		html += "	</div>";
		html += "	<div class='flex-item'>";
		html += "		<i class='ico icon-cross fcRed'></i><spring:message code='std.label.noattend' />";/* 결석 */
		html += "	</div>";
		html += "	<div class='flex-left-auto'>";
		html += "		<a href='javascript:void(0)' onclick='downExcelAttendList();return false;' class='ui basic button'><spring:message code='common.button.excel_down' /></a>";/* 엑셀 다운로드 */
		if ("true" == "<%=SessionInfo.isKnou(request)%>") {
			html += "		<a href='javascript:void(0)' class='ui basic button' onclick='sendMsg();return false;'><i class='paper plane outline icon'></i><spring:message code='common.button.send' /></a>";/* 보내기 */
		}
		html += "	</div>";
		html += "</div>";
		html += "<table id='attendListTable' class='table type2' data-sorting='true' data-paging='false' data-empty='" + "<spring:message code='common.content.not_found' />" + "'>";
		html += "	<thead>";
		html += "		<tr id='attendListHead'>";
		html += "			<th scope='col' data-sortable='false' class='tc chk'>";
		html += "				<div class='ui checkbox'>";
		html += "					<input type='checkbox' onchange='checkAllAttendList(this.checked)' />";
		html += "				</div>";
		html += "			</th>";
		html += "			<th scope='col' data-sortable='false' data-breakpoints='xs' data-type='number' class='num tc'><spring:message code='main.common.number.no' /></th>";/* NO. */
		html += "			<th scope='col' data-breakpoints='xs' class='tc'><spring:message code='std.label.dept' /></th>";/* 학과 */
		html += "			<th scope='col' class='tc'><spring:message code='std.label.user_id' /></th>";/* 학번 */
		html += "			<th scope='col' class='tc word_break_none'><spring:message code='std.label.hy' /></th>";/* 학년 */
		html += "			<th scope='col' class='tc'><spring:message code='std.label.name' /></th>";/* 이름 */
		list.forEach(function(v, i) {
		html += "			<th scope='col' class='tc p5' data-sortable='false' data-breakpoints='xs' data-crs-cre-cd='" + v.crsCreCd + "' data-lesson-schedule-id='"+v.lessonScheduleId+"' data-start-dt-yn='"+v.startDtYn+"' data-end-dt-yn='"+v.endDtYn+"' data-wek-clsf-gbn='"+v.wekClsfGbn+"' data-prgr-video-cnt='"+v.prgrVideoCnt+"'>"+v.lessonScheduleOrder+"</th>";
		});
		html += "			<th scope='col' data-sortable='false' data-breakpoints='xs sm' class='tc'><spring:message code='std.label.attend' />/<spring:message code='std.label.late' />/<spring:message code='std.label.noattend' /></th>";/* 출석 *//* 지각 *//* 결석 */
		html += "		</tr>";
		html += "	</thead>";
		html += "	<tbody id='attendList'>";
		html += "	</tbody>";
		html += "</table>";
		html += "<div class='tr'>";
		html += "	<a href='javascript:void(0)' onclick='downExcelAttendList();return false;' class='ui basic button'><spring:message code='common.button.excel_down' /></a>";/* 엑셀 다운로드 */
		if ("true" == "<%=SessionInfo.isKnou(request)%>") {
			html += "	<a href='javascript:void(0)' class='ui basic button' onclick='sendMsg();return false;'><i class='paper plane outline icon'></i><spring:message code='common.button.send' /></a>";/* 보내기 */
		}
		html += "</div>";
		
		$("#lessonScheduleList").empty().html(html);
		$(".table").footable();
		$(".ui.dropdown").dropdown();
		
		// 주차별 학습현황
		listAttend();
		// 주차별 미학습자 비율
		getNoAttendRateByWeek();
	}
	
	// tab-1. 주차별 미학습자 비율
	function getNoAttendRateByWeek() {
		var crsCreCd = "";
		var selData = lessonStautsListTable.getSelectedData();
		if (selData != null) {
			crsCreCd = selData[0].valCrsCreCd;
		}
		
		var url  = "/std/stdLect/noAttendRateByWeek.do";
		var data = {
			crsCreCd : crsCreCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				
				if(returnVO) {
					$.each($("[data-lesson-schedule-id]"), function() {
						var crsCreCd = $(this).data("crsCreCd");
						var id = $(this).data("lessonScheduleId");
						var weekRate = returnVO["weekRate_" + id];
						
						weekRate = (weekRate == null || weekRate == "") ? "/" : weekRate;
						
						if(weekRate != "/") {
							weekRate = '<a href="javascript:void(0)" class="fcBlue" onclick="noAttentListWeekModal(\'' + crsCreCd + '\', \'' + id + '\')">' + weekRate + '</a>';
						}
						
						$("#weekRateText_" + id).html(weekRate);
					});
					
					$("#weekAvgText").html(returnVO.weekAvg);
				}
	    	}
		}, function(xhr, status, error) {
		});
	}
	
	// 주차별 학습현황
	function listAttend() {
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
			if($("#searchTo").val() > $("#searchFrom").val()) {
				/*종료 주차는 시작 주차보다 빠를 수 없습니다.  */
				alert('<spring:message code="common.label.lesson.schedule.end.start" />');
				return false;
			}
		}
		
		var crsCreCd = "";
		var selData = lessonStautsListTable.getSelectedData();
		if (selData != null) {
			crsCreCd = selData[0].valCrsCreCd;
		}
		
		var url  = "/std/stdLect/listStdAttend.do";
		var data = {
			  crsCreCd 		: crsCreCd
			, searchValue	: $("#stdSearchValue").val()
			, searchTo		: $("#searchTo").val()
			, searchFrom	: $("#searchFrom").val()
		};
				
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				
				var completeIcon = '<span class=""><i class="ico icon-solid-circle fcBlue"></i></span>';
				var lateIcon = '<span class=""><i class="ico icon-triangle fcYellow"></i></span>';
				var nostudyIcon = '<span class=""><i class="ico icon-cross fcRed"></i></span>';
				var emptyIcon = '<span class=""><i class="ico icon-slash"></i></span>';
				var readyIcon = '<span class=""><i class="ico icon-hyphen"></i></span>';
				
				returnList.forEach(function(v, i) {
					console.log(v);
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
					html += '	<td class="tc word_break_none" data-sort-value="' + v.userNm + '">';
					html += '		<a href="javascript:void(0)" class="fcBlue" onclick="studyStatusModal(\'' + v.crsCreCd + '\', \'' + v.stdNo + '\')">' + v.userNm + '</a>';
					html +=			userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
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
						var crsCreCd = $(this).data("crsCreCd");
						
						var studyStatusCd = v["stuSttCd_" + id];
						
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
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + crsCreCd + '\', \'' + id + '\', \'' + v.stdNo + '\')">' + completeIcon + '</a>';
								completeCnt++;
							} else if(studyStatusCd == "LATE") {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + crsCreCd + '\', \'' + id + '\', \'' + v.stdNo + '\')">' + lateIcon + '</a>';
								lateCnt++;
							} else if(startDtYn == "N") {
								html += emptyIcon;
							} else if(startDtYn == "Y" && endDtYn == "N") {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + crsCreCd + '\', \'' + id + '\', \'' + v.stdNo + '\')">' + readyIcon + '</a>';
							} else {
								html += '<a href="javascript:void(0)" onclick="studyStatusByWeekModal(\'' + crsCreCd + '\', \'' + id + '\', \'' + v.stdNo + '\')">' + nostudyIcon + '</a>';
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
		var excelGrid = {
		    colModel:[
	            {label:'<spring:message code="main.common.number.no" />', name:'lineNo', align:'right', width:'1000'}, // NO
	            {label:'<spring:message code="std.label.name" />', name:'userNm', align:'left', width:'5000'}, // 이름
	            {label:'<spring:message code="std.label.user_id" />', name:'userId', align:'center', width:'5000'}, // 학번
	            {label:'<spring:message code="std.label.hy" />', name:'hy', align:'center', width:'2500', defaultValue: '-'}, // 학년
	            {label:'<spring:message code="std.label.dept" />', name:'deptNm', align:'left', width:'5000'}, // 학과
    		]
		};
		
		$.each($("[data-lesson-schedule-id]"), function() {
			var lessonScheduleId = $(this).data("lessonScheduleId");
			var name = this.innerText || "";
			
			excelGrid.colModel.push(
				{label: name,	name:'studyStatusIcon_' + lessonScheduleId,	align:'center',    	width:'2000'}
			);
		});
		
		excelGrid.colModel.push(
			  {label: '<spring:message code="std.label.attend" />',		name:'completeCnt',	align:'right',	width:'2000'} // 출석
			, {label: '<spring:message code="std.label.late" />',		name:'lateCnt',		align:'right',	width:'2000'} // 지각
			, {label: '<spring:message code="std.label.noattend" />',	name:'noStudyCnt',	align:'right',	width:'2000'} // 결석
		);
		
		var crsCreCd = "";
		
		var selData = lessonStautsListTable.getSelectedData();
		if (selData != null) {
			crsCreCd = selData[0].valCrsCreCd;
		}
		
		var url  = "/std/stdLect/downExcelStdAttendList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    value: crsCreCd}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}
	
	// tab-1. 주차별 학습현황 상세 팝업
	function studyStatusByWeekModal(crsCreCd, lessonScheduleId, stdNo) {
		// 모달 iframe 초기화
		var frameId = "studyStatusByWeekIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#studyStatusByWeekForm > input[name='lessonScheduleId']").val(lessonScheduleId);
		$("#studyStatusByWeekForm > input[name='crsCreCd']").val(crsCreCd);
		$("#studyStatusByWeekForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusByWeekForm").attr("target", frameId);
        $("#studyStatusByWeekForm").attr("action", "/std/stdPop/studyStatusByWeekPop.do");
        $("#studyStatusByWeekForm").submit();
        $('#studyStatusByWeekModal').modal('show');
        
        $("#studyStatusByWeekForm > input[name='lessonScheduleId']").val("");
        $("#studyStatusByWeekForm > input[name='stdNo']").val("");
	}
	
	// tab-1. 주차 미학습자 목록 팝업
	function noAttentListWeekModal(crsCreCd, lessonScheduleId) {
		var frameId = "noAttentListWeekIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#noAttentListWeekForm > input[name='lessonScheduleId']").val(lessonScheduleId);
		$("#noAttentListWeekForm > input[name='crsCreCd']").val(crsCreCd);
		$("#noAttentListWeekForm").attr("target", frameId);
        $("#noAttentListWeekForm").attr("action", "/std/stdPop/noAttentListWeekPop.do");
        $("#noAttentListWeekForm").submit();
        $('#noAttentListWeekModal').modal('show');
        
        $("#noAttentListWeekForm > input[name='lessonScheduleId']").val("");
	}
	
	// 수강생 학습현황 팝업
	function studyStatusModal(crsCreCd, stdNo) {
		var frameId = "studyStatusModalIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#studyStatusForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusForm > input[name='crsCreCd']").val(crsCreCd);
		$("#studyStatusForm").attr("target", frameId);
        $("#studyStatusForm").attr("action", "/std/stdPop/studyStatusPop.do");
        $("#studyStatusForm").submit();
        $('#studyStatusModal').modal('show');
        
        $("#studyStatusForm > input[name='stdNo']").val("");
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
					    <spring:message code="std.label.attend_status" /><!-- 출석현황 -->
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<%-- <div class="ui buttons mb10">
						<button type="button" class="ui blue button active"><spring:message code="common.label.semester.sys" /></button><!-- 학기제 -->
					</div> --%>
					<div class="option-content gap4">
					</div>
					<div class="ui segment searchArea">
						<select class="ui dropdown mr5" id="haksaYear" onchange="changeTerm()">
							<c:forEach var="item" items="${yearList }">
								<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
							</c:forEach>
	                   	</select>
	                   	<select class="ui dropdown mr5" id="haksaTerm" onchange="changeTerm()">
	                   		<option value=""><spring:message code="exam.label.term" /><!-- 학기 --></option>
							<c:forEach var="item" items="${termList}">
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
                        		    {title:"<spring:message code='common.number.no'/>", 		field:"lineNo", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60, 		formatter:"rownum", 	headerSort:false},
                        		    {title:"<spring:message code='common.dept_name'/>", 		field:"deptNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:150, 	formatter:"plaintext",	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 학과			                        		    
                        		    {title:"<spring:message code='lesson.label.crs.cd'/>", 		field:"crsCd", 		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100,	formatter:"plaintext",	headerSort:true}, // 학수번호
                        		    {title:"<spring:message code='lesson.label.crs.cre.nm'/>",	field:"crsCreNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext",	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 과목명
                        		    {title:"<spring:message code='common.professor'/>", 		field:"repUserNm",	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext",	headerSort:true}, // 교수
                        		    {title:"<spring:message code='lesson.label.std'/>", 		field:"stdCnt", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80, 		formatter:"html",		headerSort:false}, // 수강생
                        		]
                       	});
                        
                        lessonStautsListTable.on("rowSelected", function(row){
                            var data = row.getData();
                            listStdAttend(data.valCrsCreCd);
                        });
                        </script>
	  				</div>
	  				
	  				<div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code="std.label.attend_status" /><!-- 출석현황 --></h3>
	   				</div>
	   				
			        <!-- 주차 목록 -->
        			<div id="lessonScheduleList">
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
    
    <!-- 주차 미학습자 목록 팝업 --> 
	<form id="noAttentListWeekForm" name="noAttentListWeekForm" method="post">
		<input type="hidden" name="crsCreCd" value="" />
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
    <!-- 수강생 학습현황 팝업 --> 
	<form id="studyStatusForm" name="studyStatusForm" method="post">
		<input type="hidden" name="crsCreCd" value="" />
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
    <!-- 주차별 학습현황 상세 팝업 --> 
	<form id="studyStatusByWeekForm" name="studyStatusByWeekForm" method="post">
		<input type="hidden" name="crsCreCd" value="" />
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
</body>
</html>