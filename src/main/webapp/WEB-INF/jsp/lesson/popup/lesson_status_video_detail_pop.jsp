<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>

   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		// 주차 목록 조회
	   		listLessonSchedule();
		});
	   	
	 	// 주차 목록 조회
	   	function listLessonSchedule() {
	   		var url = "/lesson/lessonLect/selectLessonScheduleAll.do";
			var data = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, stdNo				: '<c:out value="${vo.stdNo}" />'
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					var listLessonTime = returnVO.listLessonTime || [];
					var listLessonStudyDetailTotal = [];
					
					var html = '';
					
					var startDtYn = returnVO.startDtYn;
					var endDtYn = returnVO.endDtYn;
					var studyStatusNm = "";
					
					if(returnVO.studyStatusCd == "COMPLETE") {
						studyStatusNm = '<span class="fcBlue"><spring:message code="lesson.label.study.status.complete" /></span>'; // 출석
					} else if(returnVO.studyStatusCd == "LATE") {
						studyStatusNm = '<span class="fcYellow"><spring:message code="lesson.label.study.status.late" /></span>'; // 지각
					} else if(returnVO.studyStatusCd == "STUDY") {
						studyStatusNm = '<span class="fcBlue"><spring:message code="lesson.label.study.status.study" /></span>'; // 학습중
					} else if(returnVO.studyStatusCd == "NOSTUDY") {
						if(startDtYn == "Y" && endDtYn == "N") {
							studyStatusNm = '<span class="fcBlack"><spring:message code="lesson.lecture.study.ready" /></span>'; // 미학습
						} else {
							studyStatusNm = '<span class="fcRed"><spring:message code="lesson.label.study.status.nostudy" /></span>'; // 결석
						}
					}
					
					// 학습상태 text 설정
					$("#studyStatusNmText").html(studyStatusNm);
					// 학습시간 분, 초 설정
					var totalTm = returnVO.studyTotalTm + returnVO.studyAfterTm;
					
					$("#studyTmMinText").text("" + Math.floor(totalTm / 60));
					$("#studyTmSecText").text("" + (totalTm % 60));
					
					// 기간외 학습시간 분, 초 설정
					$("#studyAfterTmMinText").text("" + Math.floor(returnVO.studyAfterTm / 60));
					$("#studyAfterTmSecText").text("" + (returnVO.studyAfterTm % 60));
					
					// 학습기록 세팅
					var html = '';
					
					listLessonTime.forEach(function(lessonTime, i) {
						var listLessonCnts = lessonTime.listLessonCnts || [];
					
						listLessonCnts.forEach(function(lessonCnts, j) {
							if(lessonCnts.prgrYn != "Y" || !(lessonCnts.cntsGbn == "VIDEO" || lessonCnts.cntsGbn == "VIDEO_LINK")) return true;
							
							var listLessonPage = lessonCnts.listLessonPage || [];
							var lessonStudyRecordVO = lessonCnts.lessonStudyRecordVO || {}; // 콘텐츠 학습기록
							
							// 페이지별 학습콘텐츠 인경우
							if(listLessonPage.length > 0) {
								var listLessonStudyPage = lessonStudyRecordVO.listLessonStudyPage || [];
								var lessonStudyPageObj = {};
								
								// 페이지별 학습기록
								listLessonStudyPage.forEach(function(lessonStudy, k) {
									if(!lessonStudyPageObj[lessonStudy.lessonCntsId]) {
										lessonStudyPageObj[lessonStudy.lessonCntsId] = {};
									}
									
									lessonStudyPageObj[lessonStudy.lessonCntsId][lessonStudy.pageCnt] = lessonStudy;
								});
								
								listLessonPage.forEach(function(lessonPage, k) {
									var lessonStudy = lessonStudyPageObj[lessonPage.lessonCntsId] && lessonStudyPageObj[lessonPage.lessonCntsId][lessonPage.pageCnt] || {};
									var modDttmFmt = getDateFmt(lessonStudy.modDttm);
									var studySessionTm = lessonStudy.studySessionTm || 0;
									var mi = Math.floor(studySessionTm / 60);
				   		 			var sec = studySessionTm % 60;
									
									html += '<tr>';
									html += '	<td>' + lessonTime.lessonTimeOrder + '<spring:message code="lesson.label.time" /></td>'; // 교시
									html += '	<td>' + lessonPage.pageNm + '</td>';
									html += '	<td>' + mi + '<spring:message code="lesson.label.min" /> ' + sec + '<spring:message code="lesson.label.sec" />' + '</td>';
									html += '	<td>' + (lessonStudy.prgrRatio || '0') + '%</td>';
									html += '	<td>' + (modDttmFmt || '-') + '</td>';
									html += '</tr>';
								});
							} else {
								var listLessonStudyDetail = lessonStudyRecordVO.listLessonStudyDetail || [];
								var modDttmFmt = getDateFmt(lessonStudyRecordVO.modDttm);
								var studyTotalTm = lessonStudyRecordVO.studyTotalTm || 0;
								var studyAfterTm = lessonStudyRecordVO.studyAfterTm || 0;
								var studyTm = studyTotalTm + studyAfterTm;
								var mi = Math.floor(studyTm / 60);
			   		 			var sec = studyTm % 60;
								
								html += '<tr>';
								html += '	<td>' + lessonTime.lessonTimeOrder + '<spring:message code="lesson.label.time" /></td>'; // 교시
								html += '	<td>' + (lessonCnts.lessonCntsNm || "") + '</td>';
								html += '	<td>' + mi + '<spring:message code="lesson.label.min" /> ' + sec + '<spring:message code="lesson.label.sec" />' + '</td>';
								html += '	<td>' + (lessonStudyRecordVO.prgrRatio || '0') + '%</td>';
								html += '	<td>' + (modDttmFmt || '-') + '</td>';
								html += '</tr>';
							}
						});
					});
					
					$("#studyHistoryList").html(html);
					$("#studyHistoryListTable").footable();
					
					// 출석 처리 or 출석 처리 취소 버튼 설정 (완료된 주차에 가능)
					$("#attendBtn").off("click").text("");
					
					//if(startDtYn == "Y" && returnVO.lessonScheduleEnd14Yn == "N" && (returnVO.wekClsfGbn == "02" || returnVO.wekClsfGbn == "03") || returnVO.prgrVideoCnt > 0) {
						var studyStatusCdBak = returnVO.studyStatusCdBak;
						
						if(studyStatusCdBak && returnVO.studyStatusCd == "COMPLETE") {
							$("#attendBtn").on("click", function() {
								cancelForcedAttend();
							}).text('<spring:message code="lesson.button.attend.cancel" />').show(); // 출석 처리 취소
						} else if(returnVO.studyStatusCd != "COMPLETE") {
							$("#attendBtn").on("click", function() {
								saveForcedAttend();
							}).text('<spring:message code="lesson.button.attend" />').show(); // 출석 처리
						} else {
							$("#attendBtn").hide();
						}
					//} else {
					//	$("#attendBtn").hide();
					//}
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	   	}
	 	
	 // 강제 출석 처리
	   	function saveForcedAttend() {
	   		if(!confirm('<spring:message code="lesson.confirm.forced.attend" />')) return; // 출석처리 하시겠습니까?
	   		
	   		// 학습정보 조회
	   		selectLessonStudyState().done(function(studyStatusCd) {
	   			if(studyStatusCd == "COMPLETE") {
	   				alert('<spring:message code="lesson.alert.message.forced.attend" />'); // 출석처리 되었습니다.
	   				return;
	   			}
	   			
	   			var url = "/lesson/lessonLect/saveForcedAttend.do";
				var data = {
					  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
					, stdNo				: '<c:out value="${vo.stdNo}" />'
					, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						alert('<spring:message code="lesson.alert.message.forced.attend" />'); // 출석처리 되었습니다.
						
						// 주차 목록 조회
				   		listLessonSchedule();
						
				   		// 부모창 콜백 실행
						if(typeof window.parent.saveForcedAttendCallBack === "function") {
							window.parent.saveForcedAttendCallBack();
						}
			    	} else {
			    		alert(data.message);
			    	}
				}, function(xhr, status, error) {
					alert('<spring:message code="lesson.error.forced.attend" />'); // 출석처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요 
				});
	   		});
	   	}
	   	
	   	// 강제 출석 처리 취소
	   	function cancelForcedAttend() {
	   		if(!confirm('<spring:message code="lesson.confirm.forced.attend.cancel" />')) return; // 출석처리취소 하시겠습니까?
	   		
	   		// 학습정보 조회
	   		selectLessonStudyState().done(function(studyStatusCd) {
	   			if(studyStatusCd != "COMPLETE") {
	   				alert('<spring:message code="lesson.alert.message.forced.attend.cancel" />'); // 출석처리 취소 되었습니다.
	   				return;
	   			}
	   			
	   			var url = "/lesson/lessonLect/cancelForcedAttend.do";
				var data = {
					  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
					, stdNo				: '<c:out value="${vo.stdNo}" />'
					, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						alert('<spring:message code="lesson.alert.message.forced.attend.cancel" />'); // 출석처리 취소 되었습니다.
						
						// 주차 목록 조회
				   		listLessonSchedule();
						
				   		// 부모창 콜백 실행
						if(typeof window.parent.cancelForcedAttendCallBack === "function") {
							window.parent.cancelForcedAttendCallBack();
						}
			    	} else {
			    		alert(data.message);
			    	}
				}, function(xhr, status, error) {
					alert('<spring:message code="lesson.error.forced.attend.cancel" />'); // 출석처리취소 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
				});
	   		});
	   	}
	   	
	 	// 학습정보 조회
	   	function selectLessonStudyState() {
	   		var deferred = $.Deferred();
	   		
	   		var url = "/lesson/lessonLect/selectLessonStudyState.do";
			var data = {
				  stdNo				: '<c:out value="${vo.stdNo}" />'
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					
					if(!returnVO) {
						deferred.resolve("NOSTUDY");
					} else {
						var studyStatusCd = returnVO.studyStatusCd;
						
						deferred.resolve(studyStatusCd);
					}
		    	} else {
		    		alert(data.message);
		    		deferred.reject();
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="lesson.error.forced.attend.cancel" />'); // 출석처리취소 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
				deferred.reject();
			});
			
			return deferred.promise();
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
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<div class="fields">
                <div class="two wide field">
                    <div class="initial-img border-radius0" id="pthFileDiv" style="width:100px">
                        <img src="<c:out value="${empty stdVO.phtFile ? '/webdoc/img/icon-hycu-symbol-grey.svg' : stdVO.phtFile}" />" alt="<spring:message code="team.common.user.img" />" /><!-- 학습자이미지 -->
                    </div>                                            
                </div>
                <ul class="fourteen wide field tbl dt-sm">
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.user_id" /><!-- 학번 --></dt>
                            <dd id="stdInfoUserIdText"><c:out value="${stdVO.userId}" /></dd>
                            <dt><spring:message code="std.label.name" /><!-- 이름 --></dt>
                            <dd id="stdInfoUserNmText"><c:out value="${stdVO.userNm}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.dept" /><!-- 학과 --></dt>
                            <dd id="stdInfoDeptNmText"><c:out value="${empty stdVO.deptNm ? '-' : stdVO.deptNm}" /></dd>
                            <dt><spring:message code="std.label.mobile_no" /><!-- 휴대폰 번호 --></dt>
                            <dd id="stdInfoMobileNoText"><c:out value="${empty stdVO.mobileNo ? '-' : stdVO.mobileNo}" /></dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="std.label.email" /><!-- 이메일 --></dt>
                            <dd id="stdInfoEmailText"><c:out value="${empty stdVO.email ? '-' : stdVO.email}" /></dd>
                        </dl>
                    </li>
				</ul>
			</div>
			
			<div class="ui segment">
	        	<div class="flex">
			        <p class="flex-item ml10">
			        	<c:out value="${lessonScheduleVO.lessonScheduleOrder}" /><spring:message code="lesson.label.schedule" /><!-- 주차 -->
			        </p>
		        	<div class="flex-left-auto">
		        		<a href="javascript:void(0)" class="ui blue button small" id="attendBtn"></a>
		        	</div>
	        	</div>
	        </div>
	        
	        <div class="ui segment">
	        	<div class="mb15">
	        		<span class="fcBlue mr5">[<spring:message code="lesson.label.status" /><!-- 상태 -->] <span id="studyStatusNmText">-</span></span>
	        		(<spring:message code="lesson.label.study.time" /><!-- 학습시간 --> : <span id="studyTmMinText"> - </span><spring:message code="lesson.label.min" /><!-- 분 --> <span id="studyTmSecText"> - </span><spring:message code="lesson.label.sec" /><!-- 초 -->, <spring:message code="lesson.label.after.study" /><!-- 지각학습 -->: <span id="studyAfterTmMinText"> - </span><spring:message code="lesson.label.min" /><!-- 분 --> <span id="studyAfterTmSecText"> - </span><spring:message code="lesson.label.sec" /><!-- 초 -->)
	        	</div>
	        	<div style="max-height: 260px; overflow: auto;">
	        		<table id="studyHistoryListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
						<thead>
							<tr>
								<th scope="col"><spring:message code="lesson.label.time" /><!-- 교시 --></th>
								<th scope="col"><spring:message code="lesson.label.video.name" /><!-- 동영상제목 --></th>
								<th scope="col"><spring:message code="lesson.label.study.time" /><!-- 학습시간 --></th>
								<th scope="col"><spring:message code="lesson.label.prgr.ratio" /><!-- 진도율 --></th>
								<th scope="col"><spring:message code="lesson.label.last.study.date" /><!-- 마지막 학습일시 --></th>
							</tr>
						</thead>
						<tbody id="studyHistoryList">
						</tbody>
					</table>
	        	</div>
	        </div>
		</div>
	</div>
	
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>