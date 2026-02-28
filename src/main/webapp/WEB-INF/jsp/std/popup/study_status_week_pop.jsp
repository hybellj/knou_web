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
   	
	   	$(document).ready(function() {
	   		// 학생정보 조회
	   		getStdInfo();
	   		
	   		var lessonScheduleNm = $("#lessonScheduleId > option:selected")[0].innerText;
	   		$("#lessonScheduleNmText").text(lessonScheduleNm);
	   		
	   		$("#lessonScheduleId").on("change", function() {
	   			//var lessonScheduleNm = $("#lessonScheduleId > option:selected")[0].innerText;
	   			//$("#lessonScheduleNmText").text(lessonScheduleNm);
	   			
	   			//listLessonCnts(this.value);
	   			
	   			reload();
	   		});
	   		
	   		listLessonCnts($("#lessonScheduleId").val());
	   		
	   		// dext 업로드 초기화용
	   		$("#attendMemo").show();
	   		$("#memoView").show();
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
				 		
				 		var studentImg = '<img src="' + imgSrc + '">';
				 		
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
	   	
	   	// 학습 콘텐츠 목록 조회
	   	function listLessonCnts(lessonScheduleId) {
	   		var emptyHtml = '';
	   		
	   		emptyHtml += '<div class="flex-container" style="min-height: 150px !important;">';
	   		emptyHtml += '	<div class="cont-none">';
	   		emptyHtml += '		<span><spring:message code="common.content.not_found" /></span>';
	   		emptyHtml += '	</div>';
	   		emptyHtml += '</div>';
	   		
	   		var url = "/lesson/lessonHome/selectLessonScheduleAll.do";
			var data = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, stdNo				: '<c:out value="${vo.stdNo}" />'
				, lessonScheduleId 	: lessonScheduleId
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					var listLessonTime = returnVO.listLessonTime || [];

					if(listLessonTime == 0) {
						$("#lessonCntsList").html(emptyHtml);
					} else {
						var html = '';
						var lessonCntYn = "N";
						
						listLessonTime.forEach(function(lessonTime, i) {
							var listLessonCnts = lessonTime.listLessonCnts || [];
							if(!listLessonCnts == 0) {
								lessonCntYn = "Y";
							}
							
							html += '<div class="ui segment">'
			   				html += '	<div class="option-content">';
				   			html += '		[ ' + lessonTime.lessonTimeOrder + ' <spring:message code="std.label.study_time" /> ] ' + (lessonTime.lessonTimeNm || ""); // 교시
				   			html += '	</div>';
				   			html += '	<div class="ui styled fluid accordion week_lect_list">';
				   			
				   			listLessonCnts.forEach(function(lessonCnts, i) {
				   				var lessonStudyRecordVO = lessonCnts.lessonStudyRecordVO;
				   				var listLessonStudyDetail = lessonStudyRecordVO && lessonStudyRecordVO.listLessonStudyDetail || [];
				   				
				   				listLessonStudyDetail = listLessonStudyDetail.sort(function(a, b) {
									if(a.regDttm < b.regDttm) return 1;
									if(a.regDttm > b.regDttm) return -1;
									return 0;
								});
				   				
				   				var lessonStartDtFmt = getDateFmt(returnVO.ltDetmFrDt || returnVO.lessonStartDt);
								var lessonEndDtFmt = getDateFmt(returnVO.ltDetmToDt || returnVO.lessonEndDt);
				   				
				   				html += '	<div class="title">';
				   				html += '		<div class="title_cont">';
				   				html += '			<div class="left_cont">';
				   				html += '				<div class="lectTit_box flex_1">';
				   				html += '					<a href="javascript:void(0)" onclick="">';
				   				html += '						<p class="lect_name"><span class="fcGreen mr5">[ ' + (lessonCnts.cntsGbn == "VIDEO_LINK" ? "VIDEO" : lessonCnts.cntsGbn) + '  ] </span>' + (lessonCnts.lessonCntsNm || "") + '</p>';
				   				html += '						<span class="fcGrey">';
				   				html += '							<small><spring:message code="lesson.label.lt.dttm" /> : ' + lessonStartDtFmt + ' ~ ' + lessonEndDtFmt + '</small>'
			   					if(lessonCnts.prgrYn == "Y") {
				   					html += '						| <small><spring:message code="std.label.attend_target" /></small>'; // 출결대상
			   					}
				   				html += '						</span>';
				   				html += '					</a>';
				   				html += '				</div>';
				   				html += '			</div>';
				   				html += '		</div>';
				   				html += '		<i class="dropdown icon ml20"></i>';
				   				html += '	</div>';
				   				html += '	<div class="content menu_off">';
				   				if(listLessonStudyDetail.length == 0) {
					   				html += '	<div class="ui message">';
				   		 			html += '		<span class="fcRed"><spring:message code="std.label.empty_study_history" /></span>'; // 학습기록 없음
				   		 			html += '	</div>';
				   				} else {
				   					html += '	<h4 class="ui header transition visible"><spring:message code="std.label.study_history" /></h4>'; // 학습 기록
					   		 		html += '	<div style="overflow-y: auto; max-height: 260px;">';
					   				html += '		<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">'; // 등록된 내용이 없습니다.
					   				html += '			<thead>';
					   		   		html += '				<tr>';
					   		 		html += '					<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no" /></th>'; // NO.
					   		 		if(lessonCnts.cntsGbn == "VIDEO" || lessonCnts.cntsGbn == "VIDEO_LINK") {
					   		 		html += '					<th scope="col" data-breakpoints="xs"><spring:message code="std.label.study_reg_date" /></th>'; // 학습기록시간
				   					html += '					<th scope="col"><spring:message code="std.label.study_time" /></th>'; // 학습시간
					   		 		} else {
					   		 		html += '					<th scope="col" data-breakpoints="xs"><spring:message code="std.label.study_reg_date" /></th>'; // 학습기록시간
					   		 		}
					   				html += '					<th scope="col" data-breakpoints="xs">Device</th>'; // OS
					   				html += '					<th scope="col" data-breakpoints="xs"><spring:message code="std.label.type" /></th>'; // 구분
					   				html += '					<th scope="col" data-breakpoints="xs">IP</th>';
					   		   		html += '				</tr>';
					   		 		html += '			</thead>';
					   				html += '		<tbody id="">';
				   		 			
					   				listLessonStudyDetail.forEach(function(lessonStudyDetail, i) {
					   		 			var regDttmFmt = getDateFmt(lessonStudyDetail.regDttm);
					   		 			var studyTm = lessonStudyDetail.studyTm || 0;
					   		 			var mi = Math.floor(studyTm / 60);
					   		 			var sec = studyTm % 60;
					   		 			if (mi < 10) mi = "0"+mi;
					   		 			if (sec < 10) sec = "0"+sec;
					   		 			
						   				html += '	<tr>';
						   				html += '		<td>' + (listLessonStudyDetail.length - i) + '</td>';
						   				if(lessonCnts.cntsGbn == "VIDEO" || lessonCnts.cntsGbn == "VIDEO_LINK") {
						   					html += '	<td>' + regDttmFmt + '</td>';
							   				html += '	<td>[' + lessonStudyDetail.studyCnt + '] ' + mi + ':'+ sec + '</td>'; // 분, 초
						   				} else {
						   					html += '	<td>' + regDttmFmt + '</td>';
						   				}
						   				html += '		<td>' + (lessonStudyDetail.studyDeviceCd || "") + '</td>';
						   				html += '		<td>' + (lessonStudyDetail.studyBrowserCd || "") + '</td>';
						   		   		html += '		<td>' + (lessonStudyDetail.regIp || "") + '</td>';
						   		 		html += '	</tr>';
					   		 		});
					   		 		html += '			</tbody>';
				   					html += '		</table>';
				   					html += '	</div>';
				   				}
				   				html += '	</div>';
							});
							
							html += '	</div>';
							html += '</div>';
						});
						
						$("#lessonCntsList").html(html);
						
						$(".table").footable();
			   			
			   			$(".ui.styled.accordion").accordion({
				   	        exclusive: false,
				   	        selector: {
				   	            trigger: '.title .left_cont'
				   	        }
				   	    });
			   			
			   			var startDtYn = returnVO.startDtYn;
						var endDtYn = returnVO.endDtYn;
						
						var studyStatusNm = "";
						
						if(returnVO.studyStatusCd == "COMPLETE") {
							studyStatusNm = '<i class="ico icon-solid-circle fcBlue"></i><spring:message code="std.label.attend" />'; // 출석
						} else if(returnVO.studyStatusCd == "LATE") {
							studyStatusNm = '<i class="ico icon-triangle fcYellow"></i><spring:message code="std.label.late" />'; // 지각
						} else {
							if(startDtYn == "N") {
								// 진행전
							} else if(startDtYn == "Y" && endDtYn == "N") {
								if(returnVO.studyStatusCd == "STUDY") {
									studyStatusNm = '<span><i class="ico icon-hyphen"></i></span><spring:message code="std.label.study" />'; // 학습중
								} else {
									studyStatusNm = '<span><i class="ico icon-hyphen"></i></span><spring:message code="std.label.study_status_nostudy" />'; // 미학습
								}
							} else {
								studyStatusNm = '<i class="ico icon-cross fcRed"></i><spring:message code="std.label.noattend" />'; // 결석
							}
						}
			   			
			   			// 권장학습시간 설정
			   			var lbnTm = returnVO.lbnTm || 0;
			   			$("#lbnTmText").text(lessonCntYn == "Y" ? lbnTm : "-");
			   			
			   			// 학습상태 text 설정
						$("#studyStatusNmText").html(studyStatusNm);
			   			
						// 학습시간 분, 초 설정
						var totalTm = returnVO.studyTotalTm + returnVO.studyAfterTm;
						var min = "" + Math.floor(totalTm / 60);
						var sec = "" + (totalTm % 60);
						var prgrRatio = lbnTm == 0 ? 0 : (totalTm / (lbnTm * 60)) * 100;
						prgrRatio = prgrRatio > 100 ? 100 : prgrRatio;
						prgrRatio = Math.floor(prgrRatio);
						
						$("#studyTmText").text(lessonCntYn == "Y" ? min + ":" + pad(sec, 2) + "("+prgrRatio+"%)" : "-");
						
						var afterMin = "" + Math.floor(returnVO.studyAfterTm / 60);
						var afterSec = "" + (returnVO.studyAfterTm % 60);
						
						$("#studyAfterTmText").text(lessonCntYn == "Y" ? afterMin + ":" + pad(afterSec, 2) : "-");
						
						// 출석 처리 or 출석 처리 취소 버튼 설정 (완료된 주차에 가능)
						$("#attendBtn").off("click").text("");
						// 메모 버튼 초기화
						$("#memoArea").html("");
						
						var hasAttendAuth = false;
						var deptCd = '<c:out value="${deptCd}" />';
						var userId = '<c:out value="${userId}" />';
						var seminarAttendAuthYn = '<c:out value="${seminarAttendAuthYn}" />';
						
						// 수업지원팀(20042), 교육플랫폼혁신팀(20134), 대학원교학팀(20040)
						if((deptCd == "20042" || deptCd == "20134" || deptCd == "20040" || userId == "mediadmin") && returnVO.prgrVideoCnt > 0) {
							hasAttendAuth = true;
						} else {
							if(startDtYn == "Y" && returnVO.lessonScheduleEnd14Yn == "N" && (returnVO.wekClsfGbn == "02" || returnVO.wekClsfGbn == "03") && seminarAttendAuthYn == "Y") {
								hasAttendAuth = true;
							}
						}
						
						if(hasAttendAuth) {
							var studyStatusCdBak = returnVO.studyStatusCdBak;
							
							if(studyStatusCdBak && (returnVO.studyStatusCd == "COMPLETE" || returnVO.studyStatusCd == "LATE")) {
								var html = '<a href="javascript:void(0)" class="ui blue button small" id="memoBtn"><spring:message code="lesson.label.memo" /><!-- 메모 --></a>';
								$("#memoArea").html(html);
								$("#memoBtn").popup({ 
						   			popup : '#memoView',
						   			on : "click"
						   		});
								
								$("#memoBtn").on("click", function() {
									if($("#memoView").is("visible")) {
										$("#attendReasonView").val("");
									} else {
										memoViewPop(lessonScheduleId);
									}
								}); // 출석 처리
								
								$("#attendBtn").on("click", function() {
									cancelForcedAttend(lessonScheduleId);
								}).text('<spring:message code="std.button.forced.attend.cancel" />').show(); // 출석 처리 취소
							} else if(returnVO.studyStatusCd != "COMPLETE") {
								if(returnVO.wekClsfGbn == "02" || returnVO.wekClsfGbn == "03") {
									$("#attendBtn").on("click", function() {
										alert('<spring:message code="lesson.alert.message.seminar.attend.move" />'); // 세미나 주차는 학습활동>세미나에서 출결 처리하시기 바랍니다.
									}).text('<spring:message code="std.button.forced.attend.save" />').show(); // 출석 처리
								} else {
									$("#attendBtn").popup({ 
							   			popup : '#attendMemo',
							   			on : "click",
							   		});
									
									$("#attendBtn").on("click", function() {
										if($("#attendMemo").is("visible")) {
											$("#attendReason").val("");
										} else {
											memoPop(lessonScheduleId);
										}
									}).text('<spring:message code="std.button.forced.attend.save" />').show(); // 출석 처리
								}
							} else {
								$("#attendBtn").hide();
							}
						} else {
							$("#attendBtn").hide();
						}
						
						$("#studyStateDiv").show();
					}
		    	} else {
		    		alert(data.message);
		    		$("#lessonCntsList").html(emptyHtml);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				$("#lessonCntsList").html(emptyHtml);
			});
	   	}
	   	
	 	// 강제 출석 처리
	   	function saveForcedAttend(lessonScheduleId) {
	   		if(!confirm('<spring:message code="std.comfirm.forced.attend.save" />')) return; // 출석인정 하겠습니까?
	   		
	   		// 학습정보 조회
	   		selectLessonStudyState(lessonScheduleId).done(function(studyStatusCd) {
	   			if(studyStatusCd == "COMPLETE") {
	   				alert('<spring:message code="std.alert.forced.attend.save.already" />'); // 이미 출석처리 되었습니다.
	   				listLessonCnts(lessonScheduleId);
	   				return;
	   			}
	   			
	   			var paramStudyStatusCd = $("#saveForm input[name='studyStatusCd']:checked").val();
	   			if(studyStatusCd == "LATE" && studyStatusCd == paramStudyStatusCd) {
	   				alert('<spring:message code="std.alert.forced.attend.save.already" />'); // 이미 출석처리 되었습니다.
	   				listLessonCnts(lessonScheduleId);
	   				return;
				}
	   			
	   			var crsCreCd = '<c:out value="${vo.crsCreCd}" />';
	   			var stdNo = '<c:out value="${vo.stdNo}" />';
	   			
	   			$("#saveForm input[name='crsCreCd']").val(crsCreCd);
    			$("#saveForm input[name='stdNo']").val(stdNo);
    			$("#saveForm input[name='lessonScheduleId']").val(lessonScheduleId);
    			$("#saveForm input[name='uploadFiles']").val("");
    			$("#saveForm input[name='copyFiles']").val("");
    			$("#saveForm input[name='uploadPath']").val("");
	   			
	   			// 파일이 있으면 업로드 시작
	   			var fileUploader = dx5.get("fileUploader");
	   			if (fileUploader.getFileCount() > 0) {
	   				fileUploader.startUpload();
	   			} else {
	   				save(lessonScheduleId);
	   			}
	   		});
	   	}
	 	
	   	function finishUploadWrite(){
			var fileUploader = dx5.get("fileUploader");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("#saveForm input[name='uploadFiles']").val(fileUploader.getUploadFiles());
	    			$("#saveForm input[name='copyFiles']").val(fileUploader.getCopyFiles());
	    			$("#saveForm input[name='uploadPath']").val(fileUploader.getUploadPath());
	    		   	
	    			save();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
	 	
	 	function save() {
	 		var url = "/lesson/lessonLect/saveForcedAttend.do";
			var data = $("#saveForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="std.alert.forced.attend.save" />'); // 출석처리 되었습니다.
					$("#attendMemo").removeClass("visible");
					$("#attendMemo").removeClass("hidden");
					$("#attendMemo").addClass("hidden");
					//listLessonCnts($("#saveForm input[name='lessonScheduleId']").val());
					
					// 부모창 콜백 실행
					if(typeof window.parent.saveForcedAttendCallBack === "function") {
						window.parent.saveForcedAttendCallBack();
					}
					
					if(typeof window.parent.studyStatusByWeekModal === "function") {
						window.parent.saveForcedAttendCallBack();
					}
					
					reload();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="std.error.forced.attend.save" />'); // 출석처리 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요 
			}, true);
	 	}
	 	
	 	function reload() {
	 		var url = "/std/stdPop/studyStatusByWeekPop.do";
	 		
	 		var form = $("<form></form>");
	 		form.attr("method", "POST");
	 		form.attr("name", "moveform");
	 		form.attr("action", url);
	 		form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${vo.crsCreCd}" />'}));
	 		form.append($('<input/>', {type: 'hidden', name: "lessonScheduleId", value: $("#lessonScheduleId").val()}));
	 		form.append($('<input/>', {type: 'hidden', name: "stdNo", value: '<c:out value="${vo.stdNo}" />'}));
	 		form.appendTo("body");
	 		form.submit();
	 		
	 		$("form[name='moveform']").remove();
	 	}
	 	
	 	// 강제 출석 처리 취소
	   	function cancelForcedAttend(lessonScheduleId) {
	   		if(!confirm('<spring:message code="std.comfirm.forced.attend.cancel" />')) return; // 출석처리취소 하시겠습니까?
	   		
	   		// 학습정보 조회
	   		selectLessonStudyState(lessonScheduleId).done(function(studyStatusCd) {
	   			if(!(studyStatusCd == "COMPLETE" || studyStatusCd == "LATE")) {
	   				alert('<spring:message code="std.alert.forced.attend.cancel.already" />'); // 이미 출석취소 되었습니다.
	   				listLessonCnts(lessonScheduleId);
	   				return;
	   			}
	   			
	   			var url = "/lesson/lessonLect/cancelForcedAttend.do";
				var data = {
					  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
					, stdNo				: '<c:out value="${vo.stdNo}" />'
					, lessonScheduleId	: lessonScheduleId
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						alert('<spring:message code="std.alert.forced.attend.cancel" />'); // 출석처리 취소 되었습니다.
						
						//listLessonCnts(lessonScheduleId);
						
						// 부모창 콜백 실행
						if(typeof window.parent.cancelForcedAttendCallBack === "function") {
							window.parent.cancelForcedAttendCallBack();
						}
						
						reload();
			    	} else {
			    		alert(data.message);
			    	}
				}, function(xhr, status, error) {
					alert('<spring:message code="std.error.forced.attend.cancel" />'); // 출석취소 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요
				}, true);
	   		});
	   	}
	 	
	 	// 학습정보 조회
	   	function selectLessonStudyState(lessonScheduleId) {
	   		var deferred = $.Deferred();
	   		
	   		var url = "/lesson/lessonLect/selectLessonStudyState.do";
			var data = {
				  stdNo				: '<c:out value="${vo.stdNo}" />'
				, lessonScheduleId	: lessonScheduleId
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
				alert('<spring:message code="std.error.search.study.state" />'); // 학습상태 조회중 오류가 발행하였습니다. 잠시 후 다시 진행해 주세요
				deferred.reject();
			});
			
			return deferred.promise();
	   	}
	   	
	 	// 날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
		function getDateFmt(dateStr) {
			var fmtStr = (dateStr || "");
			
			if(fmtStr.length == 14) {
				fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12) + ':' + fmtStr.substring(12, 14);
			} else if(fmtStr.length == 8) {
				fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
			}
			
			return fmtStr;
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
	 	
	 	// 메모 팝업
	 	function memoPop(lessonScheduleId) {
	 		var url = "/lesson/lessonPop/selectLessonStudyState.do";
			var data = {
				  stdNo			   : '<c:out value="${vo.stdNo}" />'
				, lessonScheduleId : lessonScheduleId
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					
					if(returnVO != null) {
				 		$("#attendReason").val(returnVO.attendReason);
					} else {
						$("#attendReason").val("");
					}
					
					$("#saveAttendBtn").off("click").on("click", function() {
						saveForcedAttend(lessonScheduleId);
					});
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	 	}
	 	
	 	// 메모 보기 팝업
	 	function memoViewPop(lessonScheduleId) {
	 		var url = "/lesson/lessonPop/selectLessonStudyState.do";
			var data = {
				  stdNo			   : '<c:out value="${vo.stdNo}" />'
				, lessonScheduleId : lessonScheduleId
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					
					if(returnVO != null) {
				 		$("#attendReasonView").val(returnVO.attendReason);
					} else {
						$("#attendReasonView").val("");
					}
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	 	}
	 	
	 	function finishUploadEdit(){
			var fileUploader = dx5.get("fileUploader");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("#editForm input[name='uploadFiles']").val(fileUploader.getUploadFiles());
	    			$("#editForm input[name='copyFiles']").val(fileUploader.getCopyFiles());
	    			$("#editForm input[name='uploadPath']").val(fileUploader.getUploadPath());
	    		   	
	    			edit();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
	 	
	 	// 출석처리 사유 수정
	   	function editAttendReason() {
	   		var crsCreCd = '<c:out value="${vo.crsCreCd}" />';
   			var stdNo = '<c:out value="${vo.stdNo}" />';
   			var lessonScheduleId = '<c:out value="${vo.lessonScheduleId}" />';
   			
   			$("#editForm input[name='crsCreCd']").val(crsCreCd);
			$("#editForm input[name='stdNo']").val(stdNo);
			$("#editForm input[name='lessonScheduleId']").val(lessonScheduleId);
			$("#editForm input[name='uploadFiles']").val("");
			$("#editForm input[name='copyFiles']").val("");
			$("#editForm input[name='uploadPath']").val("");
   			
   			// 파일이 있으면 업로드 시작
   			var fileUploader = dx5.get("fileUploader");
   			$("input[name='delFileIdStr']").val(fileUploader.getDelFileIdStr()); // 삭제파일 Id
   			if (fileUploader.getFileCount() > 0) {
   				fileUploader.startUpload();
   			} else {
   				edit();
   			}
	   	}
	 	
	 	function edit() {
	 		var url = "/lesson/lessonLect/editAttendReason.do";
			var data = $("#editForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="success.common.update" />'); // 정상적으로 수정되었습니다.
					$("#memoView").removeClass("visible");
					$("#memoView").removeClass("hidden");
					$("#memoView").addClass("hidden");
					
					reload();
				} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
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
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="option-content gap4 ">
            <div class="sec_head mra">
            	<spring:message code="std.label.learner" />&nbsp;<spring:message code="std.label.info" /><!-- 수강생 정보 -->
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
            
            <div class="option-content">
				<select class="ui dropdown" id="lessonScheduleId">
				<c:forEach items="${listLessonSchedule}" var="row">
					<c:if test="${empty row.examStareTypeCd}">
						<option value="<c:out value="${row.lessonScheduleId}" />" <c:if test="${row.lessonScheduleId eq param.lessonScheduleId}">selected</c:if>><c:out value="${row.lessonScheduleNm}" /></option>
					</c:if>
				</c:forEach>
				</select>
			</div>
			<div class="option-content">
				<h4 class="sec_head mra"><span id="lessonScheduleNmText"></span>&nbsp;<spring:message code="std.label.study_history" /><!-- 학습이력 --></h4>
				<div id="studyStateDiv" style="display: none">
					<span id="studyStatusNmText">-</span>
					<span>&nbsp;|&nbsp;</span>
					<spring:message code="std.label.lbn.tm" /><!-- 권장학습시간 --> <span id="lbnTmText">0</span><spring:message code="std.label.minute" /><!-- 분 -->
					<span>&nbsp;|&nbsp;</span>
					<spring:message code="std.label.study.tm" /><!-- 학습시간 -->&nbsp;<span id="studyTmText">0:00</span>&nbsp;(<spring:message code="std.label.after.study.tm" /><!-- 기간 후 -->&nbsp;:&nbsp;<span id="studyAfterTmText">0:00</span>)
					&nbsp;<a href="javascript:void(0)" class="ui blue button small" id="attendBtn"></a>
					<c:if test="${lessonStudyStateVO.studyStatusCd ne 'COMPLETE'}">
					<div id="attendMemo" class="ui flowing popup left center transition hidden">
						<form id="saveForm" name="saveForm">
							<input type="hidden" name="crsCreCd" />
							<input type="hidden" name="stdNo" />
							<input type="hidden" name="lessonScheduleId" />
							<input type="hidden" name="uploadPath" />
							<input type="hidden" name="uploadFiles" />
							<input type="hidden" name="copyFiles" />
							<div>
								<div class="fcWhite bcBlue p10">
									<spring:message code="lesson.label.attend.reason" />
									<!-- 출석처리 사유 -->
								</div>
								<textarea rows="5" cols="40" placeholder="<spring:message code="lesson.label.attend.reason" /><spring:message code="sys.button.input" />" id="attendReason" name="attendReason"></textarea>
								<div class="p5">
									<div class="fields">
                                        <div class="field">
                                            <div class="ui radio checkbox">
                                                <input type="radio" id="studyStatusCdATTEND" tabindex="0" class="hidden" name="studyStatusCd" value="COMPLETE" checked />
                                                <label for="studyStatusCdATTEND"><spring:message code="lesson.label.study.status.complete"/></label><!-- 출석 -->
                                            </div>
                                        </div>
                                        <div class="field">
                                            <div class="ui radio checkbox">
                                                <input type="radio" id="studyStatusCdLATE" tabindex="0" class="hidden" name="studyStatusCd" value="LATE" />
                                                <label for="studyStatusCdLATE"><spring:message code="lesson.label.study.status.late"/></label><!-- 지각 -->
                                            </div>
                                        </div>
                                    </div>
								</div>
								<div class="mt5">
									<uiex:dextuploader
										id="fileUploader"
										path="/attend/${vo.crsCreCd}/${vo.lessonScheduleId}/${stdVO.userId}"
										limitCount="10"
										limitSize="100"
										oneLimitSize="100"
										listSize="2"
										fileList="${fileList}"
										finishFunc="finishUploadWrite()"
										useFileBox="false"
										allowedTypes="*"
										uiMode="simple"
									/>
								</div>
								<div class="tc mt20">
									<button type="button" class="ui blue small button" id="saveAttendBtn">
										<spring:message code="common.button.save" />
										<!-- 저장 -->
									</button>
								</div>
							</div>
						</form>
					</div>
					</c:if>
					<c:if test="${(lessonStudyStateVO.studyStatusCd eq 'COMPLETE' or lessonStudyStateVO.studyStatusCd eq 'LATE') and not empty lessonStudyStateVO.studyStatusCdBak}">
					<div id="memoView" class="ui flowing popup left center transition hidden">
						<form id="editForm" name="editForm">
							<input type="hidden" name="crsCreCd" />
							<input type="hidden" name="stdNo" />
							<input type="hidden" name="lessonScheduleId" />
							<input type="hidden" name="uploadPath" />
							<input type="hidden" name="uploadFiles" />
							<input type="hidden" name="copyFiles" />
							<input type="hidden" name="delFileIdStr" />
							<div>
								<div class="fcWhite bcBlue p5">
									<spring:message code="lesson.label.attend.reason" />
									<!-- 출석처리 사유 -->
								</div>
								<textarea rows="5" cols="40" placeholder="<spring:message code="lesson.label.attend.reason" /><spring:message code="sys.button.input" />" id="attendReasonView" name="attendReason"></textarea>
								<c:if test="${fileList.size() > 0}">
								<div class="ui segment mt5 mb0">
									<ul>
									<c:forEach items="${fileList}" var="row">
										<li class="opacity7 file-txt">
											<a href="javascript:void(0)" class="btn border0 p5" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd}" />')">
												<i class="xi-download mr3"></i><c:out value="${row.fileNm}" /> (<c:out value="${row.fileSizeStr}" />)
											</a>
										</li>
									</c:forEach>
									</ul>
								</div>
								</c:if>
								<div class="mt5">
									<uiex:dextuploader
										id="fileUploader"
										path="/attend/${vo.crsCreCd}/${vo.lessonScheduleId}/${stdVO.userId}"
										limitCount="10"
										limitSize="100"
										oneLimitSize="100"
										listSize="2"
										fileList="${fileList}"	
										finishFunc="finishUploadEdit()"
										useFileBox="false"
										allowedTypes="*"
										uiMode="simple"
									/>
								</div>
								<div class="tc mt20">
									<button type="button" class="ui blue small button" onclick="editAttendReason()"><spring:message code="common.button.edit" /><!-- 수정하기 --></button>
								</div>
							</div>
						</form>
					</div>
					</c:if>
					<span id="memoArea"></span>
				</div>
			</div>
			<div class="" id="lessonCntsList">
	        </div>
        </div>
		
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="downloadIfm"></iframe>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>