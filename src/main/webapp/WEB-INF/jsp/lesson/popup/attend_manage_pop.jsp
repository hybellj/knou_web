<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					// 주차 학생 출석현황
					listAttendByLessonSchedule();
				}
			});
	   		
	   		// 주차 학습통계 세팅
	   		setAttendStatus();
	   		
	   		// 주차 학생 출석현황
	   		listAttendByLessonSchedule();
	   		
	   		$("#attendBtn").popup({ 
	   			popup : '#attendMemo',
	   			on : "click"
	   		});
		});
	   	
	   	// 주차 학습통계
	   	function setAttendStatus() {
	   		var url = "/std/stdLect/listAttendByLessonSchedule.do";
			var data = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					var startDtYn = '<c:out value="${lessonScheduleVO.startDtYn}" />';
					var endDtYn = '<c:out value="${lessonScheduleVO.endDtYn}" />';
					
					var completeCnt = 0;
					var lateCnt = 0;
					var nostudyCnt = 0;
					
					returnList.forEach(function(v, i) {
						if(v.studyStatusCd == "COMPLETE") {
							completeCnt++;
						} else if(v.studyStatusCd == "LATE") {
							lateCnt++;
						} else if(v.studyStatusCd == "STUDY") {
							// 집계 x
						} else if(v.studyStatusCd == "NOSTUDY") {
							if(startDtYn == "Y" && endDtYn == "N") {
								// 집계 x
							} else {
								nostudyCnt++;
							}
						}
					});
					
					$("#completeCntText").text(completeCnt);
					$("#lateCntText").text(lateCnt);
					$("#nostudyCntText").text(nostudyCnt);
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	   	}
	   	
	   	// 주차 학생 출석현황
	   	function listAttendByLessonSchedule() {
	   		var url = "/std/stdLect/listAttendByLessonSchedule.do";
			var data = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				, searchValue		: $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					var startDtYn = '<c:out value="${lessonScheduleVO.startDtYn}" />';
					var endDtYn = '<c:out value="${lessonScheduleVO.endDtYn}" />';
					
					returnList.forEach(function(v, i) {
						var studyStatusColor = "";
						var studyStatusNm = "";
						
						if(v.studyStatusCd == "COMPLETE") {
							studyStatusColor = "fcBlue";
							studyStatusNm = '<spring:message code="lesson.label.study.status.complete" />'; // 출석
						} else if(v.studyStatusCd == "LATE") {
							studyStatusColor = "fcYellow";
							studyStatusNm = '<spring:message code="lesson.label.study.status.late" />'; // 지각
						} else if(v.studyStatusCd == "STUDY") {
							studyStatusColor = "fcBlue";
							studyStatusNm = '<spring:message code="lesson.label.study.status.study" />'; // 학습중
						} else if(v.studyStatusCd == "NOSTUDY") {
							if(startDtYn == "Y" && endDtYn == "N") {
								studyStatusColor = "";
								studyStatusNm = '<spring:message code="lesson.lecture.study.ready" />'; // 미학습
							} else {
								studyStatusColor = "fcRed";
								studyStatusNm = '<spring:message code="lesson.label.study.status.nostudy" />'; // 결석
							}
						}
						
						html += '<tr>';
						html += '	<td>';
						html += '		<div class="ui checkbox">';
						html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" data-std-no="' + v.stdNo + '" data-user-nm="' + v.userNm + '" data-email="' + v.email + '" data-mobile-no="' + v.mobileNo + '" />';
						html += '		</div>';
						html += '	</td>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td>' + (v.deptNm || '-') + '</td>';
						html += '	<td>' + v.userId + '</td>';
						html += '	<td>' + v.userNm + '<a href="javascript:userInfoPop(\'' + v.userId + '\')" class="ml5"><i class="ico icon-info"></i></td>';
						html += '	<td class="' + studyStatusColor + '">' + studyStatusNm + '</td>';
						html += '	<td>';
						html += '		<a class="ui button basic small" href="javascript:void(0)" onclick="lessonStatusDetailModal(\'' + v.stdNo + '\')"><spring:message code="lesson.button.detail" /></a>'; // 상세보기
						if(v.studyStatusCdBak && v.studyStatusCd == "COMPLETE") {
							html += '	<a class="ui button basic small" href="javascript:void(0)" onclick="stdyStateMemoModal(\'' + v.stdNo + '\')"><spring:message code="lesson.label.memo" /></a>'; // 메모
						}
						html += '	</td>';
						html += '</tr>';
					});
					
					$("#stdList").empty().html(html);
		  			$("#stdListTable").footable();
		  			$("#stdListTable").find(".ui.checkbox").checkbox();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
	   	}
	   	
	   	// 전체선택
	   	function checkAll(checked) {
			$("#stdListTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
		}
	   	
	   	// 엑셀 다운
	   	function downExcel() {
	   		var lessonScheduleOrder = '<c:out value="${lessonScheduleVO.lessonScheduleOrder}" />';
	   		var studyStatusNmTitle = lessonScheduleOrder + '<spring:message code="lesson.label.schedule" />';
	   		
	   		var excelGrid = {
			    colModel:[
		            {label:'<spring:message code="common.number.no" />',		name:'lineNo',     		align:'right', 		width:'1000'},	// No
		            {label:'<spring:message code="lesson.label.dept" />',    	name:'deptNm',			align:'left',    	width:'5000'}, // 학과
		            {label:'<spring:message code="lesson.label.user.no" />',	name:'userId',			align:'center',    	width:'5000'}, // 학번
		            {label:'<spring:message code="lesson.label.name" />',    	name:'userNm',			align:'left',   	width:'5000'}, // 이름
		            {label:studyStatusNmTitle, 									name:'studyStatusNm',   align:'center',   	width:'5000'}, // 주차
	    		]
			};
			
			var url  = "/std/stdLect/attendByLessonScheduleExcelDown.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    		value: '<c:out value="${vo.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'lessonScheduleId',	value: '<c:out value="${vo.lessonScheduleId}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue',			value: $("#searchValue").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   		value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
	   	}
	   	
	   	// 교시별상세보기
	   	function lessonStatusDetailModal(stdNo) {
	   		$("#lessonStatusDetailForm > input[name='lessonScheduleId']").val('<c:out value="${vo.lessonScheduleId}" />');
	   		$("#lessonStatusDetailForm > input[name='stdNo']").val(stdNo);
			$("#lessonStatusDetailForm").attr("target", "lessonStatusDetailIfm");
	        $("#lessonStatusDetailForm").attr("action", "/lesson/lessonPop/lessonStatusDetailPop.do");
	        $("#lessonStatusDetailForm").submit();
	        $("#lessonStatusDetailModal").modal('show');
	        
	        $("#lessonStatusDetailForm > input[name='lessonScheduleId']").val("");
	        $("#lessonStatusDetailForm > input[name='stdNo']").val("");
	   	}
	   	
	 	// 영상별상세보기
	   	function lessonStatusVideoDetailModal(userId, stdNo) {
	   		$("#lessonStatusVideoDetailForm > input[name='lessonScheduleId']").val('<c:out value="${vo.lessonScheduleId}" />');
	   		$("#lessonStatusVideoDetailForm > input[name='userId']").val(userId);
	   		$("#lessonStatusVideoDetailForm > input[name='stdNo']").val(stdNo);
			$("#lessonStatusVideoDetailForm").attr("target", "lessonStatusVideoDetailIfm");
	        $("#lessonStatusVideoDetailForm").attr("action", "/lesson/lessonPop/lessonStatusVideoDetailPop.do");
	        $("#lessonStatusVideoDetailForm").submit();
	        $("#lessonStatusVideoDetailModal").modal('show');
	        
	        $("#lessonStatusVideoDetailForm > input[name='lessonScheduleId']").val("");
	        $("#lessonStatusVideoDetailForm > input[name='stdNo']").val("");
	   	}
	   	
	 	// 일괄 출석 처리
	   	function saveForcedAttendBatch(stdNoStr) {
			var stdNoList = [];
	   		
			$.each($("#stdListTable").find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
	   			var stdNo = $(this).data("stdNo");
	   			
	   			stdNoList.push(stdNo);
	   		});
	   		
	   		if(stdNoList.length == 0) {
	   			alert('<spring:message code="lesson.alert.message.no.select.std" />'); // 선택된 학생이 없습니다. 
	   			return;
	   		}
	   		
	   		if(!confirm('<spring:message code="lesson.confirm.forced.attend" />')) return; // 출석처리 하시겠습니까?
	   		
	   		var url = "/lesson/lessonLect/saveForcedAttendBath.do";
			var data = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, stdNos			: stdNoList.join(",")
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				, attendReason      : $("#attendReason").val()
				, studyStatusCd 	: 'COMPLETE'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="lesson.alert.message.forced.attend" />'); // 출석처리 되었습니다.
					
					// 주차 목록 조회
			   		listAttendByLessonSchedule();
					
			   		// 주차 학습통계 세팅
			   		setAttendStatus();
			   		
			   		$("#attendReason").val("");
			   		$("#attendMemo").removeClass("visible");
					$("#attendMemo").removeClass("hidden");
					$("#attendMemo").addClass("hidden");
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	   	}
	 	
	 	// 일괄 출석 처리 취소
	   	function cancelForcedAttendBatch() {
			var stdNoList = [];
	   		
	   		$.each($("#stdListTable").find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
	   			var stdNo = $(this).data("stdNo");
	   			
	   			stdNoList.push(stdNo);
	   		});
	   		
			if(stdNoList.length == 0) {
				alert('<spring:message code="lesson.alert.message.no.select.std" />'); // 선택된 학생이 없습니다.
	   			return;
	   		}
			
			if(!confirm('<spring:message code="lesson.confirm.forced.attend.cancel" />')) return; // 출석처리취소 하시겠습니까?
	   		var url = "/lesson/lessonLect/cancelForcedAttendBath.do";
			var data = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, stdNos			: stdNoList.join(",")
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="lesson.alert.message.forced.attend.cancel" />'); // 출석처리 취소 되었습니다.
					
					// 주차 목록 조회
			   		listAttendByLessonSchedule();
					
			   		// 주차 학습통계 세팅
			   		setAttendStatus();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	   	}

	 	// 강제 출석 처리 콜백
	 	function saveForcedAttendCallBack() {
	 		// 학습자 목록 갱신
	    	listAttendByLessonSchedule();
	 	}

	 	// 강제 출석 취소 콜백
	 	function cancelForcedAttendCallBack() {
	 		// 학습자 목록 갱신
	    	listAttendByLessonSchedule();
	 	}
	 
	   	// 보내기
	   	function sendMsg() {
	   		var rcvUserInfoStr = "";
	   		var sendCnt = 0;
	   		
	   		$.each($("#stdListTable").find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
	   			var userId = this.value;
				var userNm = $(this).data("userNm");
				var mobileNo = $(this).data("mobileNo");
				var email = $(this).data("email");
				
				sendCnt++;
				
				if (sendCnt > 1)
					rcvUserInfoStr += "|";
				rcvUserInfoStr += userId;
				rcvUserInfoStr += ";" + userNm;
				rcvUserInfoStr += ";" + mobileNo;
				rcvUserInfoStr += ";" + email;
	   		});
	   		
	   		if(sendCnt == 0) {
				alert('<spring:message code="std.alert.no_select_user" />'); // 선택된 사용자가 없습니다.
	 			return;
			}
	   		
	   		var form = window.parent.alarmForm;
			form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	        form.submit();
	   	}
	   	
	 	// 메모 보기 팝업
	 	function stdyStateMemoModal(stdNo) {
	   		$("#stdyStateMemoForm > input[name='stdNo']").val(stdNo);
			$("#stdyStateMemoForm").attr("target", "stdyStateMemoIfm");
	        $("#stdyStateMemoForm").attr("action", "/lesson/lessonPop/stdyStateMemoPop.do");
	        $("#stdyStateMemoForm").submit();
	        $("#stdyStateMemoModal").modal('show');
	        
	        $("#stdyStateMemoForm > input[name='stdNo']").val("");
	 	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div class="ui segment">
            <div class="option-content">
            	<div style="width: 100%">
            		<div class="flex">
            			<c:out value="${lessonScheduleVO.lessonScheduleNm}" />
           				<div class="flex-left-auto">
           					<div class="ui grey small label">
           						<c:if test="${lessonScheduleVO.lessonScheduleProgress eq 'READY'}">
           							<spring:message code="lesson.label.status.ready" /><!-- 수업전 -->
           						</c:if>
           						<c:if test="${lessonScheduleVO.lessonScheduleProgress eq 'PROGRESS'}">
           							<spring:message code="lesson.label.status.progress" /><!-- 수업중 -->
           						</c:if>
           						<c:if test="${lessonScheduleVO.lessonScheduleProgress eq 'END'}">
           							<spring:message code="lesson.label.status.end" /><!-- 마감 -->
           						</c:if>
         					</div>
       						<c:if test="${lessonScheduleVO.startDtYn eq 'Y'}">
       							<div class="ui purple small label">
       								<spring:message code="lesson.label.open.y" /><!-- 공개 -->
       							</div>
       						</c:if>
       						<c:if test="${lessonScheduleVO.startDtYn ne 'Y'}">
       							<div class="ui purple small label">
       								<spring:message code="lesson.label.open.n" /><!-- 비공개 -->
       							</div>
       						</c:if>
           					<span class="fcGrey">
           						<spring:message code="lesson.label.study.status.complete" /><!-- 출석 -->&nbsp;:&nbsp;<span id="completeCntText"> - </span><spring:message code="lesson.label.user.cnt" /><!-- 명 -->
								<span>&nbsp;|&nbsp;</span>
           						<spring:message code="lesson.label.study.status.late" /><!-- 지각 -->&nbsp;:&nbsp;<span id="lateCntText"> - </span><spring:message code="lesson.label.user.cnt" /><!-- 명 -->
           						<span>&nbsp;|&nbsp;</span>
           						<spring:message code="lesson.label.study.status.nostudy" /><!-- 결석 -->&nbsp;:&nbsp;<span id="nostudyCntText"> - </span><spring:message code="lesson.label.user.cnt" /><!-- 명 -->
          					</span>
           				</div>
           			</div>
            		<div>
            			<span class="fcGrey">
	            			<small>
	            				<fmt:parseDate var="lessonStartDtFmt" pattern="yyyyMMdd" value="${not empty lessonScheduleVO.ltDetmFrDt ? lessonScheduleVO.ltDetmFrDt : lessonScheduleVO.lessonStartDt}" />
								<fmt:formatDate var="lessonStartDt" pattern="yyyy.MM.dd" value="${lessonStartDtFmt}" />
								<fmt:parseDate var="lessonEndDtFmt" pattern="yyyyMMdd" value="${not empty lessonScheduleVO.ltDetmToDt ? lessonScheduleVO.ltDetmToDt : lessonScheduleVO.lessonEndDt}" />
								<fmt:formatDate var="lessonEndDt" pattern="yyyy.MM.dd" value="${lessonEndDtFmt}" />
	            				<spring:message code="lesson.label.lt.dttm" /><!-- 출석인정 기간 --><span class="ml5 mr5">:</span>
	            				<c:out value="${lessonStartDt}" />
	            				<span class="ml5 mr5">~</span>
	            				<c:out value="${lessonEndDt}" />
	            				<span class="ml5 mr5">|</span>
	            				<c:out value="${lessonScheduleVO.lbnTm}" /><spring:message code="lesson.label.min" /><!-- 분 -->
	           				</small>
           				</span>
           			</div>
            	</div>
            </div>
		<c:forEach items="${lessonScheduleVO.listLessonTime}" var="lessonTime" varStatus="status">
            <div class="ui styled fluid accordion week_lect_list">
                <div class="title">
                    <div class="title_cont">
                        <div class="left_cont">
                            <div class="lectTit_box">
                                <p class="lect_name"><c:out value="${lessonTime.lessonTimeNm}" />
                                <small class="ml5 fcGrey">
                                <c:if test="${lessonTime.stdyMethod eq 'RND'}">
                            		<spring:message code="lesson.label.stdy.method.rnd" /><!-- 랜덤학습 -->
                            	</c:if>
                            	<c:if test="${lessonTime.stdyMethod eq 'SEQ'}">
                            		<spring:message code="lesson.label.stdy.method.seq" /><!-- 순차학습 -->
                            	</c:if>
                            	</small>
                            </div>
                        </div>
                    </div>
                    <i class="dropdown icon ml20"></i>
                </div>
                <div class="content <c:if test="${status.index eq 0}">active</c:if>">
               		<ul>
              		<c:forEach items="${lessonTime.listLessonCnts}" var="lessonCnts">
               			<c:if test="${lessonCnts.prgrYn eq 'Y'}">
	                    	<li class="mb5">
	                    		<div class="ui message flex">
	                    			<span class="ui blue circular label mr10" style="height: 30px">
	                    				<c:choose>
	                    					<c:when test="${lessonTime.stdyMethod eq 'SEQ'}">
	                    						<c:out value="${lessonCnts.lessonCntsOrder}" />
	                    					</c:when>
	                    					<c:otherwise>
	                    						-
	                    					</c:otherwise>
	                    				</c:choose>
                    				</span>
	                    			<div>
	                    				<div class="mb5">
											<span class="fcGreen mr5">[<c:out value="${lessonCnts.cntsGbn eq 'VIDEO_LINK' ? 'VIDEO' : lessonCnts.cntsGbn}" />]</span>
											<c:out value="${lessonCnts.lessonCntsNm}" />
										</div>
										<div class="flex f080 fcGrey">
											<span>
												<spring:message code="lesson.label.lt.dttm" /><!-- 출석인정 기간 -->: 
												<c:out value="${lessonStartDt}" />
					            				<span class="ml5 mr5">~</span>
					            				<c:out value="${lessonEndDt}" />
				            				<c:if test="${lessonCnts.prgrYn eq 'Y'}">
												<span class="ml5 mr5">|</span>
												<spring:message code="lesson.label.stdy.prgr.y" /><!-- 출결대상 -->
											</c:if>
											</span>
										</div>
	                    			</div>
								</div>
							</li>
						</c:if>
					</c:forEach>
                    </ul>
                </div>
            </div>
		</c:forEach>
        </div>
        <div class="option-content mb10">
        	<div class="ui action input search-box">
				<input id="searchValue" type="text" placeholder="<spring:message code="lesson.common.placeholder" />" value="" />
				<button class="ui icon button" type="button" onclick="listAttendByLessonSchedule()">
					<i class="search icon"></i>
				</button>
			</div>
			<div class="select_area">
				<a href="javascript:void(0)" onclick="sendMsg()" class="ui basic button"><i class="icon bell outline"></i><i class="paper plane outline icon"></i><spring:message code="common.button.message" /><!-- 메시지 --></a>
				<a href="javascript:void(0)" id="attendBtn" class="ui blue button"><spring:message code="lesson.button.attend.batch" /></a><!-- 일괄 출석 처리 -->
				<div id="attendMemo" class="ui flowing popup left center transition hidden">
					<div>
						<div class="fcWhite bcBlue p10">
							<spring:message code="lesson.label.attend.reason" /><!-- 출석처리 사유 -->
						</div>
						<textarea rows="5" cols="40" placeholder="<spring:message code="lesson.label.attend.reason" /><spring:message code="sys.button.input" />" id="attendReason"></textarea>
						<div class="tc mt20">
							<button class="ui blue small button" id="saveAttendBtn" onclick="saveForcedAttendBatch()"><spring:message code="lesson.button.attend.batch" /><!-- 일괄 출석 처리 --></button>
						</div>
					</div>
				 </div>
				<!-- <a href="javascript:void(0)" onclick="cancelForcedAttendBatch()" class="ui basic button"></a> -->
				<a href="javascript:void(0)" onclick="downExcel()" class="ui blue button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
			</div>
        </div>
        <div style="max-height: 260px; overflow: auto;">
			<table id="stdListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
				<thead>
					<tr>
						<th scope="col" data-sortable="false" class="chk">
                            <div class="ui checkbox">
                                <input type="checkbox" onchange="checkAll(this.checked)" />
                            </div>
                        </th>
						<th scope="col" data-breakpoints="xs" data-type="number" class="num"><spring:message code="lesson.label.study.status.detail" /></th><!-- 학습현황 상세 -->
						<th scope="col" data-breakpoints="xs"><spring:message code="lesson.label.dept" /><!-- 학과 --></th>
						<th scope="col" data-breakpoints="xs"><spring:message code="lesson.label.user.no" /><!-- 학번 --></th>
						<th scope="col"><spring:message code="lesson.label.name" /><!-- 이름 --></th>
						<th scope="col"><c:out value="${lessonScheduleVO.lessonScheduleOrder}" /><spring:message code="lesson.label.schedule" /><!-- 주차 --></th>
						<th scope="col" data-breakpoints="xs"><spring:message code="lesson.label.lesson.study.detail" /><!--  학습현황 상세보기 --></th>
					</tr>
				</thead>
				<tbody id="stdList">
				</tbody>
			</table>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	
	<!-- 교시별상세보기 팝업 --> 
	<form id="lessonStatusDetailForm" name="lessonStatusDetailForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}"/>" />
		<input type="hidden" name="lessonScheduleId" value="" />
		<input type="hidden" name="userId" value="" />
		<input type="hidden" name="stdNo" value="" />
	</form>
	<div class="modal fade in" id="lessonStatusDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="lesson.label.study.status.detail" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />" onclick="listAttendByLessonSchedule()">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="lesson.label.study.status.detail" /><!-- 학습현황 상세 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" width="100%" id="lessonStatusDetailIfm" name="lessonStatusDetailIfm"></iframe>
	            </div>
	        </div>
	    </div>
	</div>

	<!-- 영상별상세보기 팝업 --> 
	<form id="lessonStatusVideoDetailForm" name="lessonStatusVideoDetailForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}"/>" />
		<input type="hidden" name="lessonScheduleId" value="" />
		<input type="hidden" name="userId" value="" />
		<input type="hidden" name="stdNo" value="" />
	</form>
	<div class="modal fade in" id="lessonStatusVideoDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="lesson.label.study.status.detail" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />" onclick="listAttendByLessonSchedule()">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="lesson.label.study.status.detail" /><!-- 학습현황 상세 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" width="100%" id="lessonStatusVideoDetailIfm" name="lessonStatusVideoDetailIfm"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 메모보기 팝업 --> 
	<form id="stdyStateMemoForm" name="stdyStateMemoForm" method="post">
		<input type="hidden" name="crsCreCd" value="<c:out value="${vo.crsCreCd}"/>" />
		<input type="hidden" name="lessonScheduleId" value="<c:out value="${vo.lessonScheduleId}" />" />
		<input type="hidden" name="stdNo" value="" />
	</form>
	<div class="modal fade in" id="stdyStateMemoModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="lesson.label.study.status.detail" />" aria-hidden="false" style="display: none; padding-right: 17px;">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="lesson.label.attend.reason" /><!-- 출석처리 사유 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" width="100%" id="stdyStateMemoIfm" name="stdyStateMemoIfm"></iframe>
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
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>