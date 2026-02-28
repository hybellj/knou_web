<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%-- 에디터 --%>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp"%>

   	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/webdoc/player/plyr.css" />
    <script type="text/javascript" src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
	<script type="text/javascript" src="/webdoc/player/player.js" crossorigin="anonymous"></script>
	
   	<script type="text/javascript">
		var cntsGbn = '<c:out value="${cntsGbn}" />';
		
	   	$(document).ready(function() {
	   		if(cntsGbn == "VIDEO") {
	   			/*
	   			$("#uploaderBox").find(".old-file").off("click.cntsVideo").on("click.cntsVideo", function() {
					if($("input[name='delFileIds']").length > 0) {
						var checked = $("input[name='delFileIds']").eq(0).is(":checked");
						
						if(checked) {
							$("#recmmdStudyTimeEditDiv").hide();
							$("#videoTimeCalcMethod").prop("checked", false);
							changeVideoTimeCalcMethod(false);
						} else {
							$("#recmmdStudyTimeEditDiv").show();
						}
					}
	   			});
	   			*/
	   		}
		});

	   	// 학습자료 변경
	   	function changeCntsGbn(cntsGbn) {
			var curCntsGbn = '<c:out value="${cntsGbn}" />';
			
			if(curCntsGbn == cntsGbn) return;
			
			var url = "/lesson/lessonPop/lessonCntsWritePop.do";
			
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveform");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", 			value: '<c:out value="${vo.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "lessonScheduleId", 	value: '<c:out value="${lessonScheduleVO.lessonScheduleId}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "lessonTimeId", 		value: '<c:out value="${lessonTimeVO.lessonTimeId}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "lessonCntsId", 		value: '<c:out value="${lessonCntsVO.lessonCntsId}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "cntsGbn", 			value: cntsGbn}));
			form.append($('<input/>', {type: 'hidden', name: "year", 				value: '<c:out value="${lessonCntsVO.year}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "semester", 			value: '<c:out value="${lessonCntsVO.semester}" />'}));
			form.append($('<input/>', {type: 'hidden', name: "courseCode", 			value: '<c:out value="${lessonCntsVO.courseCode}" />'}));
			
			// 입력된 값 전달
			form.append($('<input/>', {type: 'hidden', name: "lessonCntsNm", 		value: $("#lessonCntsNm").val()}));
			form.append($('<input/>', {type: 'hidden', name: "lessonCntsOrder", 	value: $("#lessonCntsOrder").val()}));
			form.append($('<input/>', {type: 'hidden', name: "prgrYn", 				value: $("#prgrYn").is(":checked") ? "Y" : "N"}));
			
			form.appendTo("body");
			form.submit();
	   	}
	   	
	 	// 학습자료 저장
		function saveConfirm() {
			var fileUploader = dx5.get("fileUploader");
			var lessonCntsId = '<c:out value="${vo.lessonCntsId}" />';
			var stdyMethod = '<c:out value="${lessonTimeVO.stdyMethod}" />';
			
			if(!$("#lessonCntsNm").val().trim()) {
				alert('<spring:message code="lesson.alert.input.title" />'); // 제목을 입력하세요.
				return;
			}
			
			if(stdyMethod == "SEQ" && !$("#lessonCntsOrder").val().trim()) {
				alert('<spring:message code="lesson.alert.input.lesson.cnts.order" />'); // 학습순번을 입력하세요.
				return;
			}
			
			if(cntsGbn == "FILEBOX") {
				if(!selectedFileBoxCdcd) {
					alert('<spring:message code="lesson.alert.input.lesson.cnts" />'); // 학습자료를 입력하세요.
					return;
				}
			} else if(cntsGbn == "VIDEO" || cntsGbn == "PDF" || cntsGbn == "FILE") {
				if(cntsGbn == "VIDEO") {
					if($("#prgrYn").is(":checked")) {
						if($("#videoTimeCalcMethod").is(":checked") && !$.trim($("#recmmdStudyTime").val())) {
							alert('<spring:message code="lesson.alert.message.empty.recmmd.study.time" />'); // 동영상 길이를 입력하세요.
							return;
						}
						
						if($("#videoTimeCalcMethod").is(":checked") && $("#recmmdStudyTime").val() == "0") {
							alert('<spring:message code="lesson.error.not.allow.time0" />'); // 출결체크 대상인 경우  0분을 입력할 수 없습니다.
							return;
						}
					}
				}
				
				if(lessonCntsId != '') {
					if(fileUploader.getTotalItemCount() == 0) {
						alert('<spring:message code="lesson.alert.input.lesson.cnts" />'); // 학습자료를 입력하세요.
						return;
					}
				} else {
					if(fileUploader.getFileCount() == 0) {
						alert('<spring:message code="lesson.alert.input.lesson.cnts" />'); // 학습자료를 입력하세요.
						return;
					}
				}
			} else if(cntsGbn == "SOCIAL") {
				if(!getSocialLessonCntsUrl()) {
					alert('<spring:message code="lesson.alert.input.lesson.cnts" />'); // 학습자료를 입력하세요.
					return;
				}
				
				if(!checkSocialLessonCntsUrl()) return;
			} else if(cntsGbn == "LINK") {
				if(!$("#lessonCntsUrl").val().trim()) {
					alert('<spring:message code="lesson.alert.input.lesson.cnts" />'); // 학습자료를 입력하세요.
					return;
				}
			} else if(cntsGbn == "TEXT") {
				if(editor.isEmpty()) {
					alert('<spring:message code="lesson.alert.input.lesson.cnts" />'); // 학습자료를 입력하세요.
					editor.execCommand('selectAll');
					editor.execCommand('deleteLeft');
					editor.execCommand('insertText', "");
				}
			} else if(cntsGbn == "VIDEO_LINK") {
				if (!lessonCntsId) {
					var lcWeek = $("input:radio[name=lcWeek]:checked").val();
					if (lcWeek == undefined || lcWeek == "") {
						alert("콘텐츠를 선택하세요.");
						return;
					}
				}
			}
			
			if(cntsGbn == "VIDEO" || cntsGbn == "PDF" || cntsGbn == "FILE") {
				if (fileUploader.availUpload()) {
					fileUploader.startUpload();
				}
				else if (cntsGbn == "VIDEO") {
					var uploadSubtit1 = dx5.get("uploadSubtit1");
    				var uploadSubtit2 = dx5.get("uploadSubtit2");
    				var uploadSubtit3 = dx5.get("uploadSubtit3");
    				var uploadScript = dx5.get("uploadScript");
    				
    				if (uploadSubtit1.availUpload()) {
    					uploadSubtit1.startUpload();
    				}
    				else if (uploadSubtit2.availUpload()) {
    					uploadSubtit2.startUpload();
    				}
    				else if (uploadSubtit3.availUpload()) {
    					uploadSubtit3.startUpload();
    				}
    				else if (uploadScript.availUpload()) {
    					uploadScript.startUpload();
    				}
    				else {
    					save();
    				}
				}
			} else {
				save();
			}
		}
	 	
		// 파일 업로드 완료
	    function finishUpload() {
	    	var fileUploader = dx5.get("fileUploader");
	    	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			if(cntsGbn == "VIDEO") {
	    				var uploadSubtit1 = dx5.get("uploadSubtit1");
	    				var uploadSubtit2 = dx5.get("uploadSubtit2");
	    				var uploadSubtit3 = dx5.get("uploadSubtit3");
	    				var uploadScript = dx5.get("uploadScript");
	    				
	    				if (uploadSubtit1.availUpload()) {
	    					uploadSubtit1.startUpload();
	    				}
	    				else if (uploadSubtit2.availUpload()) {
	    					uploadSubtit2.startUpload();
	    				}
	    				else if (uploadSubtit3.availUpload()) {
	    					uploadSubtit3.startUpload();
	    				}
	    				else if (uploadScript.availUpload()) {
	    					uploadScript.startUpload();
	    				}
	    				else {
	    					save();
	    				}
	    			}
	    			else {
	    				save();
	    			}	    			
	    			
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
		
		function finishUploadSubtit1() {
			var uploadSubtit1 = dx5.get("uploadSubtit1");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : uploadSubtit1.getUploadFiles(),
	    		"copyFiles"   : uploadSubtit1.getCopyFiles(),
	    		"uploadPath"  : uploadSubtit1.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
    				var uploadSubtit2 = dx5.get("uploadSubtit2");
    				var uploadSubtit3 = dx5.get("uploadSubtit3");
	    			var uploadScript = dx5.get("uploadScript");
	    				
	    			if (uploadSubtit2.availUpload()) {
	    				uploadSubtit2.startUpload();
    				}
	    			else if (uploadSubtit3.availUpload()) {
	    				uploadSubtit3.startUpload();
    				}
    				else if (uploadScript.availUpload()) {
    					uploadScript.startUpload();
    				}
    				else {
    					save();
    				}
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
		
		function finishUploadSubtit2() {
			var uploadSubtit2 = dx5.get("uploadSubtit2");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : uploadSubtit2.getUploadFiles(),
	    		"copyFiles"   : uploadSubtit2.getCopyFiles(),
	    		"uploadPath"  : uploadSubtit2.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			var uploadSubtit3 = dx5.get("uploadSubtit3");
	    			var uploadScript = dx5.get("uploadScript");
	    				
	    			if (uploadSubtit3.availUpload()) {
	    				uploadSubtit3.startUpload();
    				}
    				else if (uploadScript.availUpload()) {
    					uploadScript.startUpload();
    				}
    				else {
    					save();
    				}
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
		
		function finishUploadSubtit3() {
			var uploadSubtit3 = dx5.get("uploadSubtit3");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : uploadSubtit3.getUploadFiles(),
	    		"copyFiles"   : uploadSubtit3.getCopyFiles(),
	    		"uploadPath"  : uploadSubtit3.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			var uploadScript = dx5.get("uploadScript");
	    				
    				if (uploadScript.availUpload()) {
    					uploadScript.startUpload();
    				}
    				else {
    					save();
    				}
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
		
		function finishUploadScript() {
			var uploadScript = dx5.get("uploadScript");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : uploadScript.getUploadFiles(),
	    		"copyFiles"   : uploadScript.getCopyFiles(),
	    		"uploadPath"  : uploadScript.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
    				save();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
		
		// 저장
		function save() {
			var fileUploader = dx5.get("fileUploader");
			var lessonCntsId = '<c:out value="${lessonCntsVO.lessonCntsId}" />';
			var cntsGbn = '<c:out value="${cntsGbn}" />';
			var url;

			if(lessonCntsId) {
				url = "/lesson/lessonLect/updateLessonCnts.do";
			} else {
				url = "/lesson/lessonLect/insertLessonCnts.do";
			}
			
			var param = {
				  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				, lessonTimeId		: '<c:out value="${vo.lessonTimeId}" />'
				, lessonCntsId		: lessonCntsId
				, lessonCntsNm		: $("#lessonCntsNm").val()
				, lessonCntsOrder	: $("#lessonCntsOrder").val()
				, cntsGbn			: cntsGbn
				, prgrYn			: $("#prgrYn").is(":checked") ? "Y" : "N"
				, year 				: '<c:out value="${vo.year}" />'
				, semester			: '<c:out value="${vo.semester}" />'
				, courseCode		: '<c:out value="${vo.courseCode}" />'
				, lcdmsLinkYn		: '<c:out value="${vo.lcdmsLinkYn}" />'
			};
			
			if(cntsGbn == "FILE_BOX") {
				param.fileBoxCd = selectedFileBoxCdcd;
			} else if(cntsGbn == "VIDEO") {
				param.uploadFiles = fileUploader.getUploadFiles();
				param.delFileIdStr = fileUploader.getDelFileIdStr();
				param.uploadPath = "${uploadPath}";
				if(param.prgrYn == "Y") {
					param.videoTimeCalcMethod = $("#videoTimeCalcMethod").is(":checked") ? "MANUAL" : "";
				
					if(param.videoTimeCalcMethod == "MANUAL") {
						param.recmmdStudyTime = $("#recmmdStudyTime").val();
					}
				}
				
				var uploadSubtit1 = dx5.get("uploadSubtit1");
				var uploadSubtit2 = dx5.get("uploadSubtit2");
				var uploadSubtit3 = dx5.get("uploadSubtit3");
				var uploadScript = dx5.get("uploadScript");
				param.subtitFiles1 = uploadSubtit1.getUploadFiles();
				param.subtitFiles2 = uploadSubtit2.getUploadFiles();
				param.subtitFiles3 = uploadSubtit3.getUploadFiles();
				param.scriptKoFiles = uploadScript.getUploadFiles();
				
				param.subtit1 = '<c:out value="${lessonCntsVO.subtit1}" />';
				param.subtit2 = '<c:out value="${lessonCntsVO.subtit2}" />';
				param.subtit3 = '<c:out value="${lessonCntsVO.subtit3}" />';
				param.scriptKo = '<c:out value="${lessonCntsVO.scriptKo}" />';
				param.subtitDelIds1 = uploadSubtit1.getDelFileIdStr();
				param.subtitDelIds2 = uploadSubtit2.getDelFileIdStr();
				param.subtitDelIds3 = uploadSubtit3.getDelFileIdStr();
				param.scriptKoDelIds = uploadScript.getDelFileIdStr();
				param.subtitLang1 = $("#subtitLang1").val();
				param.subtitLang2 = $("#subtitLang2").val();
				param.subtitLang3 = $("#subtitLang3").val();
			} else if(cntsGbn == "PDF") {
				param.uploadFiles = fileUploader.getUploadFiles();
				param.delFileIdStr = fileUploader.getDelFileIdStr();
				param.uploadPath = "${uploadPath}";
			} else if(cntsGbn == "FILE") {
				param.uploadFiles = fileUploader.getUploadFiles();
				param.delFileIdStr = fileUploader.getDelFileIdStr();
				param.uploadPath = "${uploadPath}";
			} else if(cntsGbn == "SOCIAL") {
				param.lessonCntsUrl = getSocialLessonCntsUrl();
			} else if(cntsGbn == "LINK") {
				param.lessonCntsUrl = $("#lessonCntsUrl").val();
			} else if(cntsGbn == "TEXT") {
				param.cntsText = $("#cntsText").val();
			} else if(cntsGbn == "VIDEO_LINK") {
				var selWeek = $("input:radio[name=lcWeek]:checked").val();
				if (selWeek != undefined) {
					param.week = selWeek;
					param.recmmdStudyTime = parseInt($("#lbnTm_"+param.week).html());
				}
			}

			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var msg = '<spring:message code="lesson.alert.message.insert.lesson.cnts" />'; // 강의컨텐츠가 등록되었습니다.
					
					// 2: 동영상 시간계산 성공
					if(data.result == 2) {
						msg = '<spring:message code="lesson.alert.message.insert.attend.video" arguments="' + data.message + '" />'; // 출결체크 시간 {0}분이 정상적으로 저장되었습니다.
					}
					
					if(typeof window.parent.lessonCntsWritePopSaveCallback === "function") {
						window.parent.lessonCntsWritePopSaveCallback(param, msg);
					} else {
						alert(msg); // 강의컨텐츠가 등록되었습니다.
						window.parent.closeModal();
					}
		    	} else {
		    		// -2: 동영상 시간계산 실패
					if(data.result == -2) {
						var msg = '<spring:message code="lesson.alert.message.insert.lesson.cnts" />'; // 강의컨텐츠가 등록되었습니다.
						msg += '\n\n' + '<spring:message code="lesson.error.fail.calc.video.length" />'; // 동영상 길이 자동계산에 실패하여 0분으로 입력되었습니다. 해당 화면에서 수동으로 변경해주세요.
						alert(msg);
						
						if(!lessonCntsId) {
							window.parent.closeModal();
							if(typeof window.parent.lessonCntsWritePopVideoSaveFailCallback === "function") {
								param.lessonCntsId = data.returnVO.lessonCntsId;
								window.parent.lessonCntsWritePopVideoSaveFailCallback(param);
							}
						} else {
							window.location.reload();
						}
					} else {
						// 업로더 상태 초기화
						var fileUploader = dx5.get("fileUploader");
						var uploadSubtit1 = dx5.get("uploadSubtit1");
						var uploadSubtit2 = dx5.get("uploadSubtit2");
						var uploadSubtit3 = dx5.get("uploadSubtit3");
						var uploadScript = dx5.get("uploadScript");
						
						var fileUploaderItems = fileUploader.getItems(true) || [];
						var uploadSubtit1Items = uploadSubtit1.getItems(true) || [];
						var uploadSubtit2Items = uploadSubtit2.getItems(true) || [];
						var uploadSubtit3Items = uploadSubtit3.getItems(true) || [];
						var uploadScriptItems = uploadScript.getItems(true) || [];
						
						fileUploaderItems.forEach(function(v, i) {
							fileUploader.changeStatus(v.id, "WAIT");
						});
						
						uploadSubtit1Items.forEach(function(v, i) {
							uploadSubtit1.changeStatus(v.id, "WAIT");
						});
						
						uploadSubtit2Items.forEach(function(v, i) {
							uploadSubtit2.changeStatus(v.id, "WAIT");
						});
						
						uploadSubtit3Items.forEach(function(v, i) {
							uploadSubtit3.changeStatus(v.id, "WAIT");
						});
						uploadScriptItems.forEach(function(v, i) {
							uploadScript.changeStatus(v.id, "WAIT");
						});
						
						alert(data.message);
					}
		    	}
			}, function(xhr, status, error) {
				if(lessonCntsId) {
					alert('<spring:message code="lesson.error.update.lesson.cnts" />'); // 수정 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
				} else {
					alert('<spring:message code="lesson.error.insert.lesson.cnts" />'); // 등록 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
				}
			}, true);
		}

		// 학습자료 삭제
		function removeLessonCnts() {
			var crsCreCd = '<c:out value="${vo.crsCreCd}" />';
			var lessonCntsId = '<c:out value="${lessonCntsVO.lessonCntsId}" />';
			
			if(!lessonCntsId) return;
			
			var url = "/lesson/lessonLect/countLessonCntsStudyRecord.do";
			var data = {
				  crsCreCd 		: crsCreCd
				, lessonCntsId	: lessonCntsId
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					var totalCnt = returnVO.totalCnt;
					var confirmMsg = "";
					
					if(totalCnt == 0) {
						// 학습 중인 학습자가 없습니다. 삭제 가능합니다. 
						confirmMsg = "<spring:message code="lesson.confirm.delete.lesson.cnts.std.not.exist" />";
					} else {
						// 학습 중인 학습자가 있습니다. 삭제할 경우 모든 학습자의 학습 정보가 삭제됩니다. 그래도 삭제 하시겠습니까?
						confirmMsg = "<spring:message code="lesson.confirm.delete.lesson.cnts.std.exist" />";
					}
					
					if(!confirm(confirmMsg)) return;
					
					url = "/lesson/lessonLect/deleteLessonCnts.do";
					data = {
						  crsCreCd		: crsCreCd
						, lessonCntsId	: lessonCntsId
					};
					
					ajaxCall(url, data, function(data) {
						if(data.result > 0) {
							if(typeof window.parent.lessonCntsWritePopRemoveCallback === "function") {
								window.parent.lessonCntsWritePopRemoveCallback({
									lessonScheduleId: '<c:out value="${vo.lessonScheduleId}" />'
								});
							} else {
								alert("<spring:message code="lesson.alert.message.delete.lesson.cnts" />"); // 정상 삭제되었습니다.
								window.parent.closeModal();
							}
				    	} else {
				    		alert(data.message);
				    	}
					}, function(xhr, status, error) {
						alert("<spring:message code="lesson.error.delete.lesson.cnts" />"); // 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
					});
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert("<spring:message code="lesson.error.delete.lesson.cnts" />"); // 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요.
			}, true);
		}
		
		function changeRecmmdStudyTimeDisplay(checked) {
			$("#videoTimeCalcMethod").prop("checked", false);
			changeVideoTimeCalcMethod(false);
			
			if(checked) {
				$("#recmmdStudyTimeLi").show();
			} else {
				$("#recmmdStudyTimeLi").hide();
			}
		}
		
		function changeVideoTimeCalcMethod(checked) {
			if(checked) {
				$("#recmmdStudyTimeDiv").show();
			} else {
				$("#recmmdStudyTimeDiv").hide();
			}
		} 
		
		var boxCount = 1;
		<c:if test="${not empty langVal2}">
			boxCount++;
		</c:if>
		<c:if test="${not empty langVal3}">
			boxCount++;
		</c:if>
		function addSubtitBox() {
			if (boxCount > 3) {
				return;
			}
			
			boxCount++;
			$("#subtitBox"+boxCount).css({"visibility":"visible","position":"relative"});
		}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
        <div class="ui segment">
        	<div>
        		<c:out value="${lessonScheduleVO.lessonScheduleNm}" />
	        	<span class="ml5 mr5">></span>
	        	<c:out value="${lessonTimeVO.lessonTimeNm}" />
	        	<span class="ml5 mr5">></span>
	        	<span class="f110 fweb">
	        		<c:if test="${empty lessonCntsVO.lessonCntsId}">
	        			<spring:message code="lesson.label.lesson.cnts.write" /><!-- 학습자료 추가 -->
	        		</c:if>
	        		<c:if test="${not empty lessonCntsVO.lessonCntsId}">
	        			<spring:message code="lesson.label.lesson.cnts.edit.delete" /><!-- 학습자료 수정/삭제 -->
	        		</c:if>
	        	</span>
        	</div>
        	<div class="mt5">
        		<span class="fcGrey">
					<small>
            			<fmt:parseDate var="lessonStartDtFmt" pattern="yyyyMMdd" value="${not empty lessonScheduleVO.ltDetmFrDt ? lessonScheduleVO.ltDetmFrDt : lessonScheduleVO.lessonStartDt}" />
						<fmt:formatDate var="lessonStartDt" pattern="yyyy.MM.dd" value="${lessonStartDtFmt}" />
						<fmt:parseDate var="lessonEndDtFmt" pattern="yyyyMMdd" value="${not empty lessonScheduleVO.ltDetmToDt ? lessonScheduleVO.ltDetmToDt : lessonScheduleVO.lessonEndDt}" />
						<fmt:formatDate var="lessonEndDt" pattern="yyyy.MM.dd" value="${lessonEndDtFmt}" />
            			<spring:message code="lesson.label.period" /><!-- 기간 --><span class="ml5 mr5">:</span>
            			<c:out value="${lessonStartDt}" />
            			<span class="ml5 mr5">~</span>
            			<c:out value="${lessonEndDt}" />
            			<span class="ml5 mr5">|</span>
            			<c:if test="${lessonTimeVO.stdyMethod eq 'SEQ'}">
            				<spring:message code="lesson.label.stdy.method.seq" /><!-- 순차학습 -->
            			</c:if>
            			<c:if test="${lessonTimeVO.stdyMethod eq 'RND'}">
            				<spring:message code="lesson.label.stdy.method.rnd" /><!-- 랜덤학습 -->
            			</c:if>
           			</small>
				</span>
        	</div>
        </div>
        <div class="ui segment">
			<ul class="tbl">
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.title" /><!-- 제목 --></label>
						</dt>
						<dd>
							<div class="ui fluid input">
								<input type="text" id="lessonCntsNm" autocomplete="off" value="<c:out value="${lessonCntsVO.lessonCntsNm}" />" maxlength="100" placeholder="<spring:message code="lesson.common.placeholder2" />" />
							</div>
						</dd>
					</dl>
				</li>
				<li style="display: none;">
					<dl>
						<dt>
							<label class="<c:if test="${lessonTimeVO.stdyMethod eq 'SEQ'}">req</c:if>"><spring:message code="lesson.label.stdy.method" /><!-- 학습순번 --></label>
						</dt>
						<dd>
							<div class="ui input w50">
								<input type="text" id="lessonCntsOrder" autocomplete="off" value="<c:out value="${lessonCntsVO.lessonCntsOrder}" />" maxlength="3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
							</div>
						</dd>
					</dl>
				</li>
				<li style="<c:if test="${cntsGbn ne 'VIDEO' and cntsGbn ne 'VIDEO_LINK'}">display: none;</c:if>">
					<dl>
						<dt>
							<label><spring:message code="lesson.label.prgr.yn" /><!-- 출결체크 --></label>
						</dt>
						<dd>
							<div class="fields">
                                <div class="field">
                                    <div class="ui checkbox">
                                        <input type="checkbox" id="prgrYn" <c:if test="${lessonCntsVO.prgrYn eq 'Y'}">checked</c:if> onchange="changeRecmmdStudyTimeDisplay(this.checked)" />
                                        <label class="toggle_btn" for="prgrYn"><spring:message code="lesson.label.prgr.yn.include" /><!-- 출결체크 대상에 포함 --></label>
                                    </div>
                                </div>
                            </div>
						</dd>
					</dl>
				</li>
				<c:if test="${cntsGbn eq 'VIDEO' and not empty lessonCntsVO.lessonCntsId and lessonCntsVO.prgrYn eq 'Y'}">
				<li id="recmmdStudyTimeLi" style="<c:if test="${lessonCntsVO.prgrYn ne 'Y'}">display: none;</c:if>">
					<dl>
						<dt>
							<label><spring:message code="lesson.label.video.length" /><!-- 동영상 길이 --></label>
						</dt>
						<dd>
							<div class="fields inline-flex-item">
								<div class="field">
									<c:out value="${empty lessonCntsVO.recmmdStudyTime ? '-' : lessonCntsVO.recmmdStudyTime}" /> <spring:message code="lesson.label.min" /><!-- 분 -->
								</div>
								<div class="field ml10" id="recmmdStudyTimeEditDiv">
									<div class="inline-flex-item">
										<div class="ui checkbox">
	                                        <input type="checkbox" id="videoTimeCalcMethod" onchange="changeVideoTimeCalcMethod(this.checked)" />
	                                        <label class="toggle_btn" for="videoTimeCalcMethod"><spring:message code="common.button.modify" /><!-- 수정 --></label>
	                                    </div>
	                                    <div id="recmmdStudyTimeDiv" class="ml10" style="display: none;">
											<div class="field">
												<div class="ui input w50">
													<input type="text" id="recmmdStudyTime" autocomplete="off" value="<c:out value="${lessonCntsVO.recmmdStudyTime}" />" maxlength="3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onblur="this.value = this.value == '' ? '' : Number(this.value);" style="height: 26px; min-height: unset;" />
												</div>
												<span><spring:message code="lesson.label.min" /><!-- 분 --></span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</dd>
					</dl>
				</li>
				</c:if>
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.lesson.cnts" /><!-- 학습자료 --></label>
						</dt>
						<dd>
							<div class="contents flex flex-wrap">
								<div class="flex flex-wrap p8">
									<button type="button" class="btn flex-column p4 <c:if test="${empty cntsGbn or cntsGbn eq 'FILE_BOX'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('FILE_BOX')">
										<i class="icon-folder ico"></i>
										<span class="fs12"><spring:message code="lesson.label.file.box" /><!-- 내파일함 --></span>
									</button>
									<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'VIDEO'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('VIDEO')">
										<i class="icon-circle-player ico"></i>
										<span class="fs12"><spring:message code="lesson.label.video" /><!-- 동영상 --></span>
									</button>
									
									<c:if test="${vo.lcdmsLinkYn eq 'N'}">
										<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'VIDEO_LINK'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('VIDEO_LINK')">
											<i class="icon-square-play ico"></i>
											<span class="fs12">LCDMS</span>
										</button>
									</c:if>
									
									<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'PDF'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('PDF')">
										<i class="icon-pdf ico"></i>
										<span class="fs12">PDF</span>
									</button>
									<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'FILE'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('FILE')">
										<i class="icon-paperclip ico"></i>
										<span class="fs12"><spring:message code="lesson.label.file" /><!-- 파일 --></span>
									</button>
									<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'SOCIAL'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('SOCIAL')">
										<i class="icon-social-connect ico"></i>
										<span class="fs12"><spring:message code="lesson.label.social" /><!-- 소셜 --></span>
									</button>
									<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'LINK'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('LINK')">
										<i class="icon-link ico"></i>
										<span class="fs12"><spring:message code="lesson.label.web.link" /><!-- 웹링크 --></span>
									</button>
									<button type="button" class="btn flex-column p4 <c:if test="${cntsGbn eq 'TEXT'}">ui button blue activeCntsGbn</c:if>" onclick="changeCntsGbn('TEXT')">
										<i class="icon-paper-text ico"></i>
										<span class="fs12"><spring:message code="lesson.label.text" /><!-- 텍스트 --></span>
									</button>
								</div>
							</div>
						</dd>
					</dl>
				</li>
			</ul>
		</div>

		<!-- 내파일함 -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'FILE_BOX'}">
			<div class="ui form segment">
				<div class="two column stackable ui grid">
					<div class="column col-4">
						<div class="file-bar" style="height: 30px">
							<div class="ui blue small progress" data-percent="0" id="fileBoxUseRateBlock">
	                            <div class="bar" style="transition-duration: 300ms; width: 0%;"></div>
	                            <div class="label" id="fileBoxUseRate">0MB / 0MB (0% <spring:message code="filebox.label.main.use" /><!-- 사용중 -->)</div>
	                        </div>
						</div>
						<div class="ui segment boxline mt20">
	                       	<span class="label"><spring:message code="filebox.label.tree.title" /><!-- 내 파일 --></span>
	                       	<div class="ui divider"></div>
	     						<a href="javascript:setMenuTreeItem('ROOT');"><i class="grey archive icon"></i>MyFileBox</a>
	                       	<ul id="fileBoxTreeMenu" class="filetree treeview">
							</ul>
						</div>
					</div>
					<div class="column col-8">
						<div class="option-content">
							<select class="ui dropdown mr5" id="searchKey" onchange="listFileBox()">
				        		<option value=" "><spring:message code="lesson.label.lesson.cnts.type" /><!-- 학습자료 유형 --></option>
				        		<option value="MOV"><spring:message code="lesson.label.video" />(MP4)<!-- 동영상 --></option>
				        		<option value="PDF">PDF</option>
				        		<option value="IMG"><spring:message code="lesson.label.img" /><!-- 이미지 --></option>
				        		<option value="FILE"><spring:message code="lesson.label.file" /><!-- 파일 --></option>
					        </select>
							<div class="ui action input search-box">
	                            <input type="text" placeholder="검색" id="searchValue" name="searchValue" maxlength="50" />
	                            <button type="button" class="ui icon button" id="btnFileBoxSearch" onclick="listFileBox()">
	                                <i class="search icon"></i>
	                            </button>
	                        </div>
						</div>
						<div class="ui segment boxline mt10">
							<span class="label" id="folderNmText">MyFileBox</span>
							<div class="ui divider"></div>
							<form id="checkFileBoxForm" name="checkFileBoxForm">
								<table id="fileListTable" class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code="filebox.common.empty" />">
									<thead>
										<tr>
											<th scope="col"><spring:message code="lesson.label.file.box.nm" /><!-- 파일명 --></th>
											<th scope="col" data-breakpoints="xs"><spring:message code="lesson.label.reg.dt" /><!-- 생성일 --></th>
											<th scope="col" data-breakpoints="xs"><spring:message code="lesson.label.file.size" /><!-- 크기 --></th>
											<th scope="col"><spring:message code="lesson.label.select" /><!-- 선택 --></th>
										</tr>
									</thead>
									<tbody id="fileList">
									</tbody>
								</table>
							</form>
	                     </div>
					</div>
				</div>
			</div>
			<div class="ui segment" id="fileBoxSelectedDiv" style="display: none;">
				<div id="fileBoxVideoSelectedDiv" style="display: none;">
					<h4 class="mb5"><spring:message code="lesson.label.view.lesson" /><!-- 강의보기 --></h4>
					<video id="fileBoxVideo" style="width: 100%" 
						title="<div id='videoTitle'><spring:message code="lesson.label.preview" /></div>" 
						data-poster="" 
						lang="ko" 
						continue="false" 
						continueTime="" 
						speed="true" 
						speedPlaytime="false"
						>
					</video>
				</div>
				<div id="fileBoxFileSelectedDiv" style="display: none;">
				</div>
			</div>
			<script type="text/javascript" src="/webdoc/js/jquery.treeview.js"></script>
			<script type="text/javascript">
				var selectedFileBoxCd = "ROOT";
				var selectedFileBoxCdcd;
			
				$(document).ready(function() {
					// 플레이어 초기화
					var fileBoxVideo = UiMediaPlayer("fileBoxVideo");
					
					$('.ui.progress').progress({
						  duration: 100
						, total: 100
					});
					
					$("#searchValue").on("keydown", function(e) {
						if(e.keyCode == 13) {
							listFileBox();
						}
					});
					
					// 트리메뉴 조회
					listFileBoxTree();
					
					// 파일함 사용률 조회
					getFileBoxUseRate();
				});
				
				// 트리메뉴 조회
				function listFileBoxTree() {
					var url = "/file/fileHome/listFileBoxTree.do";
					var data = {
					};
					
					ajaxCall(url, data, function(data) {
			        	if(data.result > 0) {
			        		var returnList = data.returnList || [];
			        		
			        		$("#fileBoxTreeMenu").empty();
			        		setTree(returnList, 1);
			        		
			        		// tree 설정
			                $("#fileBoxTreeMenu li").droppable({
			                    drop: function( event, ui ) {
			                        moveFileBox($(this).find("span[name=spFileBoxFolder]").attr("data-folderId"));
			                    }
			                });
			        		
			                $("#fileBoxTreeMenu").treeview({
			                    collapsed: true,
			                    unique: false,
			                });
			                
			                if(selectedFileBoxCd == "ROOT") {
			                	listFileBox();
			                } else {
			                	// 선택된 목록 펼치기
			                	var fileBoxCdList = getParFileBoxCdList([selectedFileBoxCd], selectedFileBoxCd) || [];
			                	
			               		fileBoxCdList.reverse().forEach(function(fileBoxCd, i) {
			             			$("[data-file-box-cd=" + fileBoxCd + "]").trigger("click");
			               		});
			               		
			               		setMenuTreeItem(selectedFileBoxCd);
			                }
			                
			                // 메뉴 클릭 이벤트 세팅
			                $("[data-file-box-cd]").on("click", function() {
			           			var fileBoxCd = $(this).data("fileBoxCd");
			           			
			           			setMenuTreeItem(fileBoxCd);
			           		});
			            } else {
			            	alert(data.message);
			            }
					}, function(xhr, status, error) {
						// 에러가 발생했습니다!
						alert('<spring:message code="fail.common.msg" />');
					});
				}
				
				// 부모 폴더 겁색
				function getParFileBoxCdList(list, fileBoxCd) {
					var parFileBoxCd = $("[data-file-box-cd=" + fileBoxCd + "]").parent("li").parent("ul").data("folderFileBoxCd");
					
					if(parFileBoxCd) {
						list.push(parFileBoxCd);
						getParFileBoxCdList(list, parFileBoxCd);
					}
					
					return list;
				}
				
				// 트리메뉴 설정
				function setTree(list, depth) {
					var nextList = [];
					
					list.forEach(function(v, i) {
						if(v.depth == depth) {
							var html = '';
							html += '<li>'
							html += '	<span class="folder" data-file-box-cd="' + v.fileBoxCd + '" data-folder-nm="' + v.folderNm + '">' + v.folderNm + '</span>';
						if(v.childrenCnt != "0") {
							html += '	<ul data-folder-file-box-cd="' + v.fileBoxCd + '"></ul>';
						}
							html += '</li>';
						
							if(v.parFileBoxCd) {
								$("[data-folder-file-box-cd=" + v.parFileBoxCd + "]").append(html);
							} else {
								$("#fileBoxTreeMenu").append(html);
							}
						} else {
							nextList.push(v);
						}
					});
					
					if(nextList.length != 0) {
						setTree(nextList, ++depth);
					} else {
						$.each($("[data-folder-file-box-cd]"), function() {
							if($(this).find("li").length == 0) {
								$(this).remove();
							}
						});
					}
				}
				
				// 메뉴트리 아이템 선택
				function setMenuTreeItem(fileBoxCd) {
					// 중복선택 방지
					var isSelected = $("[data-file-box-cd=" + fileBoxCd + "]").parent("li").hasClass("selected");
					
					if(isSelected) {
						return; 
					} else {
						$("[data-file-box-cd]").parent("li").removeClass("selected");
						$("[data-file-box-cd=" + fileBoxCd + "]").parent("li").addClass("selected");
						selectedFileBoxCd = fileBoxCd;
						
						listFileBox();
					}
				}
				
				// 파일목록 조회
				function listFileBox() {
					var url = "/file/fileHome/listFileBox.do";
					var data = {
						  selectedFileBoxCd: selectedFileBoxCd
						, searchValue: $("#searchValue").val()
						, searchKey: $("#searchKey").val().trim()
					};
					
					ajaxCall(url, data, function(data) {
			        	if(data.result > 0) {
			        		var returnList = data.returnList || [];
			        		var html = '';
			        		
			        		returnList.forEach(function(v, i) {
			        			var icon = '';
			        			
			            		if(v.fileBoxTypeCd == "FOLDER") {
			            			icon = '<i class="folder outline icon f120 vm mr10"></i>';
			            		} else if(v.fileBoxTypeCd == "DOC") {
			            			icon = '<i class="file alternate outline icon f120 vm mr10"></i>';
			            		} else if(v.fileBoxTypeCd == "MOV") {
			            			icon = '<i class="file video outline icon f120 vm mr10"></i>';
			            		} else if(v.fileBoxTypeCd == "IMG") {
			            			icon = '<i class="file image outline icon f120 vm mr10"></i>';
			             		} else if(v.fileBoxTypeCd == "ETC") {
			             			icon = '<i class="file archive outline icon f120 vm mr10"></i>';
			             		}
			        			html += '<tr>';
			        			html += '	<td class="tl" style="width:100px;">';
			       			if(v.fileBoxTypeCd == "FOLDER") {
			       				html += '		<a id="fileBoxNmLink' + i + '" href="javascript:void(0)" onclick="moveFolder(\'' + v.fileBoxCd + '\')">' + icon + v.fileBoxFullNm + '</a>';
			       			} else {
			       				html += '		<span id="fileBoxNmLink' + i + '">' + icon + v.fileBoxFullNm + '</span>';
			       			}
			        			html += '	</td>';
			        			html += '	<td>' + v.regDt + '</td>';
			        			html += '	<td>' + (v.fileSize ? v.fileSizeFormatted : '-') + '</td>';
			        			html += '	<td>';
		        			if(v.fileBoxTypeCd != "FOLDER") {
			        			html += '		<a href="javascript:void(0)" onclick="selectFile(\'' + v.fileBoxCd + '\', \'' + v.fileBoxNm + '\', \'' + v.fileExt + '\', \'' + v.contentUrl + '\')" class="ui small button basic" data-file-box-cd="' + v.fileBoxCd + '">선택</a>';
		        			}
			        			html += '	</td>';
			        			html += '</tr>';
			        		});
			        		$("#fileList").html(html);
			        		$("#fileListTable").footable();
			        		$(".ui.checkbox").checkbox();
			        		
			        		var folderNm;
			        		if(selectedFileBoxCd == "ROOT") {
			        			folderNm = "MyFileBox";
			        		} else {
			        			var folderNm = $("[data-file-box-cd=" + selectedFileBoxCd + "]").data("folderNm");
			        		}
			        		
			        		$("#folderNmText").text(folderNm);
			            } else {
			            	alert(data.message);
			            }
					}, function(xhr, status, error) {
						// 에러가 발생했습니다!
						alert('<spring:message code="fail.common.msg" />');
					});
				}
				
				// 파일함 사용률 조회
				function getFileBoxUseRate() {
					var url = "/file/fileHome/fileBoxUseRate.do";
					var data = {
					};
					
					ajaxCall(url, data, function(data) {
			        	if(data.result > 0) {
			        		var returnVO = data.returnVO;
			        		
			        		var rateStr = '<spring:message code="filemgr.label.auth.size" />'; // 용량
			                var fileUseRate = 0;
			        		
			                fileUseRate = returnVO.fileUseRate;
			                rateStr = formatBytes(returnVO.fileUseSize) + ' / ' + formatBytes(returnVO.fileLimitSize) + ' (' + returnVO.fileUseRate + '% <spring:message code="filebox.label.main.use" />)'; // 사용중
			                
			                $("#fileBoxUseRateBlock").attr("data-percent", fileUseRate);
			                $("#fileBoxUseRate").text(rateStr);
			                $('#fileBoxUseRateBlock').progress({
			                    percent: fileUseRate > 100 ? 100 : fileUseRate
			                });
			            } else {
			            	alert(data.message);
			            }
					}, function(xhr, status, error) {
						// 에러가 발생했습니다!
						alert('<spring:message code="fail.common.msg" />');
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
				
				// 리스트에서 폴더 이동
				function moveFolder(fileBoxCd) {
					selectedFileBoxCd = fileBoxCd;
					listFileBoxTree();
				}
				
				// 파일박스 파일선택
				function selectFile(fileBoxCd, fileBoxNm, fileExt, contentUrl) {
					$("#fileBoxSelectedDiv").show();
					
					// 강의보기 초기화
					$("#fileBoxVideoSelectedDiv").hide();
					$("#fileBoxVideo").attr("src", "");
					
					// 파일선택 초기화
					$("#fileBoxFileSelectedDiv").hide().text("");
					
					if(fileExt == "mp4") {
						// 동영상보기 활성화
						$("#fileBoxVideo").attr("src", contentUrl);
						
						$("#fileBoxVideoSelectedDiv").show();
						
						$("#videoTitle").text(fileBoxNm + "." + fileExt);
					} else {
						var text = fileBoxNm + "." + fileExt;
						
						$("#fileBoxFileSelectedDiv").text(text).show();
					}
					
					// 파일박스 선택정보 세팅
					selectedFileBoxCdcd = fileBoxCd;
				}
			</script>
		</c:if>
		
		<!-- 동영상 -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'VIDEO'}">
			<ul class="tbl">
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.video" /></label>
						</dt>
						<dd>
							<uiex:dextuploader
								id="fileUploader"
								path="${uploadPath}"
								limitCount="1"
								limitSize="1024"
								oneLimitSize="1024"
								listSize="1"
								fileList="${fileList}"
								finishFunc="finishUpload()"
								allowedTypes="mp4"
								bigSize="false"
							/>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label>자막</label>
						</dt>
						<dd>
							<div>
								<button class="ui button basic small" title="자막추가" onclick="addSubtitBox()">자막추가</button>
							</div>
							<div class="mt5" style="display:flex">
								<div style="display:flex;margin-right:5px">
									<select id="subtitLang1">
										<c:forEach items="${subtitLangList}" var="code"> 
											<option value="${code.codeCd}" <c:if test="${code.codeCd eq langVal1}">selected='selected'</c:if>>${code.codeNm}</option>
										</c:forEach>
									</select>
								</div>
								<div style="display:flex;width:100%">
									<uiex:dextuploader
										id="uploadSubtit1"
										path="${uploadPath}"
										limitCount="1"
										limitSize="3"
										oneLimitSize="3"
										listSize="1"
										fileList="${subtitList1}"
										finishFunc="finishUploadSubtit1()"
										allowedTypes="vtt"
										bigSize="false"
										uiMode="simple"
									/>
								</div>
							</div>
							
							<div id="subtitBox2" class="mt5" style="<c:if test="${empty langVal2}">visibility:hidden;position:absolute;</c:if>">
							<div style="display:flex">
								<div style="display:flex;margin-right:5px">
									<select id="subtitLang2">
										<c:forEach items="${subtitLangList}" var="code" >
											<option value="${code.codeCd}" <c:if test="${code.codeCd eq langVal2}">selected='selected'</c:if>>${code.codeNm}</option>
										</c:forEach>
									</select>
								</div>
								<div style="display:flex;width:100%">
									<uiex:dextuploader
										id="uploadSubtit2"
										path="${uploadPath}"
										limitCount="1"
										limitSize="3"
										oneLimitSize="3"
										listSize="1"
										fileList="${subtitList2}"
										finishFunc="finishUploadSubtit2()"
										allowedTypes="vtt"
										bigSize="false"
										uiMode="simple"
									/>
								</div>
							</div>
							</div>
							
							<div id="subtitBox3" class="mt5" style="<c:if test="${empty langVal3}">visibility:hidden;position:absolute;</c:if>">
							<div class="mt5" style="display:flex">
								<div style="display:flex;margin-right:5px">
									<select id="subtitLang3">
										<c:forEach items="${subtitLangList}" var="code" >
											<option value="${code.codeCd}" <c:if test="${code.codeCd eq langVal3}">selected='selected'</c:if>>${code.codeNm}</option>
										</c:forEach>
									</select>
								</div>
								<div style="display:flex;width:100%">
									<uiex:dextuploader
										id="uploadSubtit3"
										path="${uploadPath}"
										limitCount="1"
										limitSize="3"
										oneLimitSize="3"
										listSize="1"
										fileList="${subtitList3}"
										finishFunc="finishUploadSubtit3()"
										allowedTypes="vtt"
										bigSize="false"
										uiMode="simple"
									/>
								</div>
							</div>
							<div class="mt5" style="display:none">
							
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label>스크립트</label>
						</dt>
						<dd>
							<uiex:dextuploader
								id="uploadScript"
								path="${uploadPath}"
								limitCount="1"
								limitSize="3"
								oneLimitSize="3"
								listSize="1"
								fileList="${scriptKoList}"
								finishFunc="finishUploadScript()"
								allowedTypes="txt"
								bigSize="false"
								uiMode="simple"
							/>
						</dd>
					</dl>
				</li>
			</ul>
		</c:if>
		
		<!-- PDF -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'PDF'}">
			<uiex:dextuploader
				id="fileUploader"
				path="${uploadPath}"
				limitCount="1"
				limitSize="1024"
				oneLimitSize="1024"
				listSize="1"
				fileList="${fileList}"
				finishFunc="finishUpload()"
				allowedTypes="pdf"
				bigSize="false"
			/>
		</c:if>
		
		<!-- 파일 -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'FILE'}">
			<uiex:dextuploader
				id="fileUploader"
				path="${uploadPath}"
				limitCount="1"
				limitSize="1024"
				oneLimitSize="1024"
				listSize="1"
				fileList="${fileList}"
				finishFunc="finishUpload()"
				allowedTypes="*"
				bigSize="false"
			/>
		</c:if>
		
		<!-- 소셜 -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'SOCIAL'}">
			<div class="ui segment">
				<div class="option-content">
					<a class="ui button small blue" href="javascript:void(0)" data-social-type="URL" onclick="changeSocialType('URL')"><spring:message code="lesson.label.url.link" /><!-- URL주소 --></a>
					<a class="ui button small basic" href="javascript:void(0)" data-social-type="SRC" onclick="changeSocialType('SRC')"><spring:message code="lesson.label.src.code" /><!-- 소스코드 --></a>
				</div>
				<div class="ui segment" id="socialTab1">
					<h4 class="mb5">* <spring:message code="lesson.label.social.guide1" /><!-- Youtube, TED, Vimeo의 동영상 주소를 입력하여 등록할 수 있습니다. --></h4>
					<div class="ui fluid input">
						<input type="text" id="socialTab1Val" autocomplete="off" maxlength="100" placeholder="<spring:message code="lesson.common.placeholder.social" />" />
					</div>
				</div>
				<div class="ui segment" style="display: none;" id="socialTab2">
					<h4 class="mb5">* <spring:message code="lesson.label.social.guide2" /><!-- Iframe 형식 HTML 코드를 등록합니다. --></h4>
					<div style="height: 100px">
						<textarea id="socialTab2Val"></textarea>
					</div>
					<div>* <spring:message code="lesson.label.social.guide3" /><!-- 소셜 미디어에서 제공하는 공유 코드를 복사여 붙여 넣습니다. --></div>
				</div>
				<div class="bottom-content">
					<button class="ui blue button small" type="button" onclick="socialPreview()" id="socialPreviewBtn" style="display: none;"><spring:message code="lesson.button.preview" /><!-- 미리보기 --></button>
				</div>
			</div>
			<div class="ui segment" style="display: none;" id="socialPreviewArea">
				<h4 class="mb5"><spring:message code="lesson.label.preview" /><!-- 미리보기 --></h4>
				<div id="socialPreviewCnts"></div>
			</div>
			<script type="text/javascript">
				var SELECTED_SOCIAL_TYPE = "URL";
			
				$(document).ready(function() {
					var lessonCntsId = '<c:out value="${lessonCntsVO.lessonCntsId}" />';
					
					if(lessonCntsId) {
						var lessonCntsUrl = '${lessonCntsVO.lessonCntsUrl}';
						
						if(!checkIframe(lessonCntsUrl)) {
							// URL 입력창 세팅
							$("#socialTab1Val").val(lessonCntsUrl);
						} else {
							changeSocialType("SRC");
							
							// 소스코드 입력창 세팅
							$("#socialTab2Val").val(lessonCntsUrl);
							
							// 미리보기
							$("#socialPreviewArea").show();
							$("#socialPreviewCnts").html(lessonCntsUrl);
						}
					}
				});
				
				// 소셜 타입 변경
				function changeSocialType(socialType) {
					// 중복실행 X
					if(socialType == SELECTED_SOCIAL_TYPE) return;
					
					SELECTED_SOCIAL_TYPE = socialType;
					
					// 버튼 상태변경
					$.each($("[data-social-type]"), function () {
						if($(this).data("socialType") == socialType) {
							$(this).removeClass("basic").addClass("blue");
						} else {
							$(this).removeClass("blue").addClass("basic");
						}
					});
					
					// 미리보기 버튼 초기화
					$("#socialPreviewBtn").hide();
					
					// 미리보기 영역 초기화
					$("#socialPreviewArea").hide();
					$("#socialPreviewCnts").html("");
					
					// 입력 영역 show/hide
					if(socialType == "URL") {
						$("#socialTab1").show();
						$("#socialTab2").hide();
					} else if(socialType == "SRC") {
						$("#socialTab1").hide();
						$("#socialTab2").show();
						
						// 미리보기 버튼 세팅
						$("#socialPreviewBtn").show();
						
						// 미리보기 세팅
						if($("#socialTab2Val").val().trim() && checkIframe($("#socialTab2Val").val())) {
							// 미리보기
							$("#socialPreviewArea").show();
							$("#socialPreviewCnts").html($("#socialTab2Val").val());
						}
					}
				}
				
				// 소셜 미리보기
				function socialPreview() {
					if(SELECTED_SOCIAL_TYPE != "SRC") return;
					
					if(!checkIframe($("#socialTab2Val").val())) {
						alert('<spring:message code="lesson.alert.input.iframe" />'); // Iframe 형식 HTML 코드를 입력하세요.
						return;
					}
					
					// 미리보기
					$("#socialPreviewArea").show();
					$("#socialPreviewCnts").html($("#socialTab2Val").val());
				}
				
				// iframe 형식 겸사
				function checkIframe(text) {
				    var iframeRegex = /<iframe.*?>.*?<\/iframe>/g;
				    return iframeRegex.test(text);
				}
				
				// 입력값 체크
				function checkSocialLessonCntsUrl() {
					if(SELECTED_SOCIAL_TYPE == "URL") {
						return true;
					} else {
						if(!checkIframe($("#socialTab2Val").val())) {
							alert('<spring:message code="lesson.alert.input.iframe" />'); // Iframe 형식 HTML 코드를 입력하세요.
							return false;
						} else {
							return true;
						}
					}
				}
				
				// 입력 값 가져오기
				function getSocialLessonCntsUrl() {
					if(SELECTED_SOCIAL_TYPE == "URL") {
						return $("#socialTab1Val").val();
					} else {
						return $("#socialTab2Val").val();
					}
				}
			</script>
		</c:if>
		
		<!-- 웹링크 -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'LINK'}">
			<div class="ui segment">
				<h4 class="mb5">* <spring:message code="lesson.label.link.guide1" /><!-- URL 주소를 붙여 넣으세요. --></h4>
				<div class="ui fluid input">
					<input type="text" autocomplete="off" value="<c:out value="${lessonCntsVO.lessonCntsUrl}" />" maxlength="2000" placeholder="<spring:message code="lesson.common.placeholder.social" />" oninput="setVideoSrc(this.value)" id="lessonCntsUrl" />
				</div>
			</div>
		</c:if>
		
		<!-- 텍스트 -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'TEXT'}">
			<div class="ui segment">
				<h4 class="mb5"><spring:message code="lesson.label.lesson.cnts.text" /><!-- 학습내용 --></h4>
					<dl style="display:table;width:100%">
					<dd style="height:200px;display:table-cell;width:100%">
	            		<div style="height:100%">
							<textarea id="cntsText">
								<c:out value="${lessonCntsVO.cntsText}" />
							</textarea>
							<script>
								// html 에디터 생성
								var editor = HtmlEditor('cntsText', THEME_MODE, '${uploadPath}');
							</script>
						</div>
					</dd>
					</dl>
			</div>
		</c:if>
		<div class="ui segment" style="display: none;">
			<h4 class="mb5"><spring:message code="lesson.label.lesson.cnts.text" /><!-- 학습내용 --></h4>
			<div style="height: 100px">
				<textarea></textarea>
			</div>
		</div>
		
		<!-- LCDMS -->
		<c:if test="${empty cntsGbn or cntsGbn eq 'VIDEO_LINK'}">
			<div class="ui segment">
				<div class="min-height-400 max-height-400" style="overflow:auto">
					<c:if test="${not empty vo.lessonCntsId}">
						* 콘텐츠를 변경할 경우만 선택하세요.
					</c:if>
					<table class="table type1 footable" summary="contents" data-empty="<spring:message code="common.content.not_found"/>">
					<thead>
						<tr>
							<th scope="col" class="col w50 tc"><spring:message code="common.select"/></th>
							<th scope="col" class="col w50 tc">No</th>
							<th scope="col" class="col "><spring:message code="lesson.label.cnts.nm"/></th>
							<th scope="col" class="col w70 tc">시간(분)</th>
						</tr>
					</thead>
					<tbody id="lcCntsBody" class="lcBody">
						<c:forEach items="${cntsList}" var="cnts" varStatus="status">
							<tr>
								<td class='tc'><input name='lcWeek' type='radio' value="${cnts.week}"></td>
								<td class='tc'>${status.count}</td>
								<td id='seqName_${cnts.week}'>${cnts.seqName}</td>
								<td id='lbnTm_${cnts.week}' class='tc'>${cnts.lbnTm}</td>
							</tr>
						</c:forEach>
					</tbody>
					</table>
				</div>
			</div>
			<script>
			$(document).ready(function() {
				$("input:radio[name=lcWeek]").click(function() {
					$("#lessonCntsNm").val($("#seqName_"+$(this).val()).html());
				});
			});
			</script>
		</c:if>
		
		<div class="bottom-content">
			<button class="ui blue button" type="button" onclick="saveConfirm();"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<c:if test="${not empty lessonCntsVO.lessonCntsId}">
				<button class="ui blue button" type="button" onclick="removeLessonCnts();"><spring:message code="common.button.delete" /><!-- 삭제 --></button>
			</c:if>
			<button class="ui black cancel button" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>