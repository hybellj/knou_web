<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/seminar/common/seminar_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		seminarCtgrChg("load");
		listStd();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listStd();
			}
		});
		
		$("#seminarStartHH").on("change", function(e) {
			if(document.getElementById("seminarStartFmt") == document.activeElement) {
				$("#seminarStartHH option[value=00]").prop("selected", true);
			}
		});
		
		$("#seminarStartMM").on("change", function(e) {
			if(document.getElementById("seminarStartFmt") == document.activeElement) {
				$("#seminarStartMM option[value=00]").prop("selected", true);
			}
		});
		
		$("#seminarStartHour").closest("div.dropdown").css("z-index", "102");
		$("#lessonScheduleId").closest("div.dropdown").css("z-index", "101");
		
		if(${empty vo.seminarId} && "${vo.lessonScheduleId}") {
			setTimeout(function() {
				$("#lessonScheduleId").trigger("change");
			}, 1000);
		}
	});
	
	// 세미나 구분 변경
	function seminarCtgrChg(type) {
		var seminarCtgrCd = $("input[name=seminarCtgrCd]:checked").val();
		$(".liDiv").hide();
		$("."+seminarCtgrCd+"Li").show();
		
		// 강의구분 별 주차 목록 조회
		var url  = "/lesson/lessonLect/listLessonScheduleByGbn.do";
		var data = {
			"crsCreCd" 	 : "${crsCreCd}",
			"wekClsfGbn" : seminarCtgrCd == "online" ? "02" : seminarCtgrCd == "offline" ? "03" : ""
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = "<option value=''><spring:message code='seminar.label.schedule.select' /></option>";/* 주차선택 */
				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						var isSelected = v.lessonScheduleId == "${vo.lessonScheduleId}" ? "selected" : "";
						html += "<option value='"+v.lessonScheduleId+"' "+isSelected+">"+v.lessonScheduleOrder+"주차</option>";
					});
				}
				$("#lessonScheduleId").empty().append(html);
				$("#lessonScheduleId").dropdown();
				
				if(type == "load") {
					if(${empty vo.seminarId} && "${vo.lessonScheduleId}") {
						selectListTime("chg", "${vo.lessonTimeId}");
					}
				}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 목록
	function listSeminar() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
		
		submitForm("/seminar/seminarHome/Form/seminarList.do", "", "", kvArr);
	}
	
	// 저장 확인
    function saveConfirm() {
    	if(!nullCheck("seminar")) {
			return false;
		}
    	
		var fileUploader = dx5.get("fileUploader");
    	// 파일이 있으면 업로드 시작
 		if (fileUploader.getFileCount() > 0) {
			fileUploader.startUpload();
		}
		else {
			// 저장 호출
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
    			$("#uploadFiles").val(fileUploader.getUploadFiles());
    	 		$("#copyFiles").val(fileUploader.getCopyFiles());
    	 		$("#uploadPath").val("/seminar/${vo.seminarId}");
    			
    	 		save();
    		} else {
    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    		}
    	}, function(xhr, status, error) {
    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    	});
    }
	
 	// 저장, 수정
 	function save() {
 		if(!nullCheck("seminar")) {
			return false;
		}
		setValue();
		
		showLoading();
		
		var fileUploader = dx5.get("fileUploader");
		var url = "/seminar/seminarHome/writeSeminar.do";
		if(${not empty vo.seminarId }) {
			$("input[name='delFileIdStr']").val(fileUploader.getDelFileIdStr()); // 삭제파일 Id
			url = "/seminar/seminarHome/editSeminar.do";
		}
		
		$("input[name='copyFiles']").val(fileUploader.getCopyFiles()); // 파일함에서 가져온 파일
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#seminarWriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		if(${empty vo.seminarId }) {
        			alert("<spring:message code='seminar.alert.insert' />");/* 정상 저장되었습니다. */
        		} else {
        			alert("<spring:message code='seminar.alert.update' />");/* 정상 수정되었습니다. */
        		}
        		listSeminar();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	if(${empty vo.seminarId }) {
	        	alert("<spring:message code='seminar.error.insert' />");/* 저장 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        	} else {
        		alert("<spring:message code='seminar.error.update' />");/* 수정 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        	}
        });
 	}
	
	// 빈 값 체크
	function nullCheck(type) {
		<spring:message code='seminar.label.seminar' var='seminar'/> // 세미나
		
		if($("input[name=seminarCtgrCd]:checked").length == 0) {
			alert("<spring:message code='seminar.alert.select.seminar.ctgr' />");/* 세미나 구분을 선택해주세요. */
			return false;
		}
		if($.trim($("input[name=seminarNm]").val()) == "") {
			alert("<spring:message code='seminar.alert.input.seminar.nm' />");/* 세미나명을 입력해주세요. */
			return false;
		}
		if($("#seminarStartFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_start_date' arguments='${seminar}'/>");/* [세미나] 시작일을 입력하세요. */
			return false;
		}
		if($("#seminarStartHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${seminar}'/>");/* [세미나] 시작시간을 입력하세요. */
			return false;
		}
		if($("#seminarStartMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_min' arguments='${seminar}'/>");/* [세미나] 시작분을 입력하세요. */
			return false;
		}
		if($("#lessonScheduleId").val() == "") {
			alert("<spring:message code='seminar.alert.select.lesson.schedule' />");/* 주차를 선택해주세요. */
			return false;
		}
		if(type == "seminar") {
			var seminarCtgrCd = $("input[name=seminarCtgrCd]:checked").val();
			if((seminarCtgrCd == "online" || seminarCtgrCd == "free") && ($("#zoomId").val() == "" || $("#zoomId").val() == undefined)) {
				alert("<spring:message code='seminar.alert.zoom.not.open' />");/* ZOOM 회의를 개설해주세요. */
				return false;
			}
		}
		return true;
	}
	
	// 값 채우기
	function setValue() {
		// 세미나 시작일시
		if ($("#seminarStartFmt").val() != null && $("#seminarStartFmt").val() != "") {
			$("input[name=seminarStartDttm]").val($("#seminarStartFmt").val().replaceAll(".","")+""+pad($("#seminarStartHH option:selected").val(),2)+""+pad($("#seminarStartMM option:selected").val(),2)+"00");
		}
		
		// 세미나 종료일시
		var startDttm = $("input[name=seminarStartDttm]").val();
		var date = new Date(startDttm.substring(0, 4), startDttm.substring(4, 6)-1, startDttm.substring(6, 8), startDttm.substring(8, 10), startDttm.substring(10, 12), startDttm.substring(12, 14));
		date.setHours(date.getHours() + parseInt($("#seminarStartHour").val()));
		date.setMinutes(date.getMinutes() + parseInt($("#seminarStartMin").val()));
		$("input[name=seminarEndDttm]").val(date.getFullYear().toString() + pad(date.getMonth()+1, 2) + pad(date.getDate(), 2) + pad(date.getHours(), 2) + pad(date.getMinutes(), 2) + pad(date.getSeconds(), 2));
		
		// 세미나 시간
		$("#seminarTime").val($("#seminarStartHour").val() * 60 + parseInt($("#seminarStartMin").val()));
	}
	
	// 체크박스 이벤트
	function changeCheckBox(obj) {
		if(obj.value == "all") {
			$("input[name=crsCreCds]").not(".readonly").prop("checked", obj.checked);
		} else {
			$("input[name=allDeclsNo]").prop("checked", $("input[name=crsCreCds]").length == $("input[name=crsCreCds]:checked").length);
		}
	}
	
	// 특정 주차 교시 정보 가져오기
	function selectListTime(type, lessonTimeId) {
		if(type == "chg") {
			$("#lessonScheduleId option").each(function(i, v) {
				if($(v).val() == "${vo.lessonScheduleId}") {
					$("#lessonTimeId").val(lessonTimeId);
					$("#lessonScheduleId").parent().css("pointer-events", "none");
					$("#lessonScheduleId").parent().attr("tabindex", "-1");
				}
			});
		} else {
			var lessonScheduleId = $("select[name=lessonScheduleId]").val();
			$("#lessonTimeId").val("ADD");
			
			// 교시 개수 조회
			var url  = "/lesson/lessonLect/listLessonTime.do";
			var data = {
				"crsCreCd" 	  		: "${crsCreCd}",
				"lessonScheduleId"	: lessonScheduleId
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							if(v.lessonTimeOrder == 1) {
								$("#lessonTimeId").val(v.lessonTimeId);
							}
						});
					}
					$("#lessonTimeOrder").val(returnList.length + 1);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
	}
	
	// 수강생 목록
	function listStd() {
		var url  = "/seminar/seminarHome/seminarStdList.do";
		var data = {
			"crsCreCd" 	  	: "${crsCreCd}",
			"searchValue"	: $("#searchValue").val(),
			"atndCd"		: $("#atndCd").val(),
			"seminarId"		: "${vo.seminarId}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = "";
				var stdNos = $("#stdNos").val().split(",");
				
				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						var isChecked   = '';
	        			if(stdNos != "") {
	        				stdNos.forEach(function(vv, ii) {
	        					if(vv == v.stdNo) {
	        						isChecked = 'checked';
	        					}
	        				});
	        			}
						var atndTime = dateFormat("time", v.atndTime);
						html += "<tr>";
						html += "	<td class='tc'>";
						html += "		<div class='ui checkbox'>";
						html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' data-stdNo=\""+v.stdNo+"\" onchange='checkStdNoToggle(this)' "+isChecked+" user_id=\""+v.userId+"\" user_nm=\""+v.userNm+"\" mobile=\""+v.mobileNo+"\" email=\""+v.email+"\">";
						html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
						html += "		</div>";
						html += "	</td>";
						html += "	<td class='tc'>"+v.lineNo+"</td>";
						html += "	<td>"+v.deptNm+"</td>";
						html += "	<td class='tc'>"+v.userId+"</td>";
						html += "	<td class='tc'>"+(v.hy == null ? '-' : v.hy)+"</td>";
						html += "	<td class='tc'><a class='fcBlue' href='javascript:studyStatusModal(\""+v.stdNo+"\")'>"+v.userNm+"</a>";
						html +=		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
						html += "	</td>";
						html += "	<td class='tc'>"+v.entrYy+"</td>";
						html += "	<td class='tc'>"+v.entrHy+"</td>";
						html += "	<td class='tc'>"+v.entrGbnNm+"</td>";
						html += "	<td class='tc'>"+atndTime+"</td>";
						html += "</tr>";
					});
				}
				$("#stdList").empty().html(html);
				$("#stdTable").footable();
				$("#stdCnt").text(returnList.length);
				$("#stdTable").parent("div").addClass("max-height-500");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 이전 세미나 가져오기 팝업
	function seminarCopyList() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd',  'val' : "${crsCreCd}"});
		kvArr.push({'key' : 'seminarId', 'val' : "${vo.seminarId}"});
		
		submitForm("/seminar/seminarHome/seminarCopyListPop.do", "seminarPopIfm", "copy", kvArr);
	}
	
	// 세미나 가져오기
	function copySeminar(seminarId) {
		var url  = "/seminar/seminarHome/viewSeminar.do";
		var data = {
			"seminarId" : seminarId
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnVO = data.returnVO;
				// 세미나 구분
				$("input[name=seminarCtgrCd][value=\""+returnVO.seminarCtgrCd+"\"]").trigger("click");
				// 세미나명
				$("input[name=seminarNm]").val(returnVO.seminarNm);
				// 세미나 내용
				$("button.se-clickable[name=new]").trigger("click");
        		editor.insertHTML($.trim(returnVO.seminarCts) == "" ? " " : returnVO.seminarCts);
        		// 진행 시간
        		$("#seminarStartHour").val(pad(parseInt(returnVO.seminarTime / 60), 2)).trigger("change");
        		$("#seminarStartMin").val(pad(returnVO.seminarTime % 60, 2)).trigger("change");
        		// 파일업로드
        		$("#uploaderBox").html("");
        		
        		/////////////////////////
        		/*
        		fileUploader.init();
        		for(var i = 0; i < returnVO.fileList.length; i++){
        			fileUploader.addOldFile(returnVO.fileList[i].fileId, returnVO.fileList[i].fileNm, returnVO.fileList[i].fileSize);
        		}
        		*/
        		
        		// 파일 복사할 세미나 번호
        		$("#searchTo").val(returnVO.seminarId);
        		$("#uploadPath").val("/seminar/${vo.seminarId}");
				
				$(".modal").modal("hide");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 수강생 학습현황 팝업
	function studyStatusModal(stdNo) {
		var kvArr = [];
		kvArr.push({'key' : 'stdNo',    'val' : stdNo});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
		
		submitForm("/std/stdPop/studyStatusPop.do", "seminarPopIfm", "stdStat", kvArr);
	}
	
	// 전체 선택 / 해제
    function checkAllStdNoToggle(obj) {
        $("input:checkbox[name=evalChk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=evalChk]').each(function (idx) {
            if ($(obj).is(":checked")) {
                addSelectedStdNos($(this).attr("data-stdNo"));
                $(this).closest("tr").addClass("on");
            } else {
                removeSelectedStdNos($(this).attr("data-stdNo"));
                $(this).closest("tr").removeClass("on");
            }
        });
    }

    // 한건 선택 / 해제
    function checkStdNoToggle(obj) {
        if ($(obj).is(":checked")) {
            addSelectedStdNos($(obj).attr("data-stdNo"));
            $(obj).closest("tr").addClass("on");
        } else {
            removeSelectedStdNos($(obj).attr("data-stdNo"));
            $(obj).closest("tr").removeClass("on");
        }
        var totChkCnt = $("input:checkbox[name=evalChk]").length;
        var chkCnt = $("input:checkbox[name=evalChk]:checked").length;
        if(totChkCnt == chkCnt) {
        	$("input:checkbox[name=allEvalChk]").prop("checked", true);
        } else {
        	$("input:checkbox[name=allEvalChk]").prop("checked", false);
        }
    }

    // 선택된 학습자 번호 추가
    function addSelectedStdNos(stdNo) {
        var selectedStdNos = $("#stdNos").val();
        if (selectedStdNos.indexOf(stdNo) == -1) {
            if (selectedStdNos.length > 0) {
                selectedStdNos += ',';
            }
            selectedStdNos += stdNo;
            $("#stdNos").val(selectedStdNos);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedStdNos(stdNo) {
        var selectedStdNos = $("#stdNos").val();
        if (selectedStdNos.indexOf(stdNo) > -1) {
            selectedStdNos = selectedStdNos.replace(stdNo, "");
            selectedStdNos = selectedStdNos.replace(",,", ",");
            selectedStdNos = selectedStdNos.replace(/^[,]*/g, '');
            selectedStdNos = selectedStdNos.replace(/[,]*$/g, '');
            $("#stdNos").val(selectedStdNos);
        }
    }
    
    // 인증 완료
    function authComple() {
    	writeZoom();
    }
    
    // ZOOM 개설
    function writeZoom() {
    	showLoading();
		var url = "/seminar/seminarHome/writeZoom.do";
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#seminarWriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		var returnVO = data.returnVO;
        		alert("<spring:message code='seminar.alert.insert' />");/* 정상 저장되었습니다. */
        		if(returnVO != null) {
        			$("#hostUrl").val(returnVO.hostUrl);
        			$("#joinUrl").val(returnVO.joinUrl);
        			$("#zoomId").val(returnVO.zoomId);
        			$("#zoomPw").val(returnVO.zoomPw);
        		}
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='seminar.error.insert' />");/* 저장 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        });
    }
    
    // ZOOM 사용자 인증
    function oAuthorizeCheck() {
    	if(!nullCheck("zoom")) {
			return false;
		}
		setValue();
		if($("#zoomId").val() != "") {
			alert("<spring:message code='seminar.alert.zoom.already.open' />");/* 이미 ZOOM 회의가 개설되어 있습니다. */
			return false;
		}
		if($("input[name=autoRecordYn]:checked").val() == undefined) {
			alert("<spring:message code='seminar.alert.select.auto.record' />");/* 녹화 여부를 선택해주세요. */
			return false;
		}
		
		var url  = "/zoom/v2/authorize/getUrl.do";
		var data = {
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var popUpOption = "width=550, height=600, menubar=no, status=no";
		    	var oAuth2 = window.open(data.returnVO, "", popUpOption);
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
    }
    
    // ZOOM 등록
    function zoomWrite() {
    	if("${authYn}" != "Y") {
    		alert("<spring:message code='seminar.alert.not.zoom.user.info' />");/* 등록된 ZOOM 계정이 없습니다. */
    		return false;
    	}
    	if(!nullCheck("zoom")) {
			return false;
		}
		setValue();
		if($("#zoomId").val() != "") {
			alert("<spring:message code='seminar.alert.zoom.already.open' />");/* 이미 ZOOM 회의가 개설되어 있습니다. */
			return false;
		}
		if($("input[name=autoRecordYn]:checked").val() == undefined) {
			alert("<spring:message code='seminar.alert.select.auto.record' />");/* 녹화 여부를 선택해주세요. */
			return false;
		}
		
		showLoading();
		var url = "/seminar/seminarHome/writeZoom.do";
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#seminarWriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		var returnVO = data.returnVO;
        		alert("<spring:message code='seminar.alert.insert' />");/* 정상 저장되었습니다. */
        		if(returnVO != null) {
        			$("#hostUrl").val(returnVO.hostUrl);
        			$("#joinUrl").val(returnVO.joinUrl);
        			$("#zoomId").val(returnVO.zoomId);
        			$("#zoomPw").val(returnVO.zoomPw);
        		}
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='seminar.error.insert' />");/* 저장 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
        });
    }
    
 	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		
		$.each($('#stdList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
			sendCnt++;
			if (sendCnt > 1) rcvUserInfoStr += "|";
			rcvUserInfoStr += $(this).attr("user_id");
			rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
			rcvUserInfoStr += ";" + $(this).attr("mobile");
			rcvUserInfoStr += ";" + $(this).attr("email"); 
		});
		
		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert("<spring:message code='common.alert.sysmsg.select_user'/>");
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
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        <div class="ui form">
		        	<div class="layout2">
		        		<c:set var="seminarInfo"><spring:message code="seminar.button.add" /></c:set>
		        		<c:if test="${not empty vo.seminarId }"><c:set var="seminarInfo"><spring:message code="seminar.button.edit" /></c:set></c:if>
		        		<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="seminar.label.seminar" />', '${seminarInfo}');
						});
						</script>
				        <div id="info-item-box">
				        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="seminar.label.seminar" /><!-- 세미나 -->
                            </h2>
				            <div class="button-area">
				            	<a href="javascript:saveConfirm()" class="ui blue button">
							       	<c:choose>
							       		<c:when test="${empty vo.seminarId }">
							       			<spring:message code="seminar.button.open.seminar" /><!-- 세미나 개설 -->
							       		</c:when>
							       		<c:otherwise>
							       			<spring:message code="seminar.button.edit.seminar" /><!-- 세미나 정보수정 -->
							       		</c:otherwise>
							       	</c:choose>
						        </a>
				            	<%-- <c:if test="${empty vo.seminarId }">
					            	<a href="javascript:seminarCopyList()" class="ui blue button"><spring:message code="seminar.button.prev.seminar.copy" /><!-- 이전 세미나 가져오기 --></a>
				            	</c:if> --%>
				            	<a href="javascript:listSeminar()" class="ui blue button"><spring:message code="seminar.button.list" /><!-- 목록 --></a>
				            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
				        		<form id="seminarWriteForm" method="POST" onsubmit="return false;" autocomplete="off">
				        			<input type="hidden" name="seminarId" 		value="${vo.seminarId }" />
				        			<input type="hidden" name="crsCreCd" 		value="${crsCreCd }" />
				        			<input type="hidden" name="seminarStartDttm" />
				        			<input type="hidden" name="seminarEndDttm" />
				        			<input type="hidden" name="repoCd"			value="SEMINAR" />
				        			<input type="hidden" name="seminarTime"		id="seminarTime" />
				        			<input type="hidden" name="uploadFiles"		id="uploadFiles" />
				                	<input type="hidden" name="copyFiles"		id="copyFiles" />
				                	<input type="hidden" name="uploadPath"		id="uploadPath" />
				                	<input type="hidden" name="searchTo"		id="searchTo" />
				                	<input type="hidden" name="lessonTimeOrder" id="lessonTimeOrder" />
				                	<input type="hidden" name="crsCreCds"	    value="${crsCreCd}" />
									<input type="hidden" name="delFileIdStr" value=""/>
					        		<div class="ui form">
					        			<div class="ui segment">
					        				<ul class="tbl">
					        					<li>
					        						<dl>
					        							<dt><label class="req"><spring:message code="seminar.label.seminar.ctgr" /><!-- 세미나 구분 --></label></dt>
					        							<dd>
					        								<div class="fields">
					        									<c:if test="${creCrsVO.uniCd eq 'G' or creCrsVO.crsCd.contains('TEST')}">
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" name="seminarCtgrCd" id="seminarCtgrOn" value="online" tabindex="0" class="hidden" onchange="seminarCtgrChg()" ${(empty vo.seminarId && creCrsVO.uniCd eq 'G') || vo.seminarCtgrCd eq 'online' ? 'checked' : '' }>
											                            <label for="seminarCtgrOn"><spring:message code="seminar.label.online" /><!-- 온라인 --></label>
											                        </div>
											                    </div>
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" name="seminarCtgrCd" id="seminarCtgrOff" value="offline" tabindex="0" class="hidden" onchange="seminarCtgrChg()" ${vo.seminarCtgrCd eq 'offline' ? 'checked' : '' }>
											                            <label for="seminarCtgrOff"><spring:message code="seminar.label.offline" /><!-- 오프라인 --></label>
											                        </div>
											                    </div>
					        									</c:if>
					        									<c:if test="${creCrsVO.uniCd ne 'G' }">
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" name="seminarCtgrCd" id="seminarCtgrFree" value="free" tabindex="0" class="hidden" onchange="seminarCtgrChg()" ${creCrsVO.uniCd ne 'G' || vo.seminarCtgrCd eq 'free' ? 'checked' : '' }>
											                            <label for="seminarCtgrFree"><spring:message code="seminar.label.free" /><!-- 자유세미나 --></label>
											                        </div>
											                    </div>
					        									</c:if>
											                </div>
					        							</dd>
					        						</dl>
					        					</li>
					        					<li>
					        						<dl>
					        							<dt><label class="req"><spring:message code="seminar.label.seminar.nm" /><!-- 세미나명 --></label></dt>
					        							<dd>
					        								<input type="text" name="seminarNm" value="${vo.seminarNm }" />
					        							</dd>
					        						</dl>
					        					</li>
					        					<li>
					        						<dl>
					        							<dt><label><spring:message code="seminar.label.seminar.cts" /><!-- 세미나 내용 --></label></dt>
					        							<dd style="height:300px">
                    										<div style="height:100%">
													        	<textarea name="seminarCts" id="seminarCts">${vo.seminarCts }</textarea>
													        	<script>
														           // html 에디터 생성
														      		var editor = HtmlEditor('seminarCts', THEME_MODE, '/seminar/${vo.seminarId }');
														       	</script>
													        </div>
					        							</dd>
					        						</dl>
					        					</li>
					        					<%-- <c:if test="${empty vo.seminarId }">
						        					<li class="offlineLi liDiv">
						        						<dl>
						        							<dt><label><spring:message code="seminar.label.decls.reg" /><!-- 분반 같이 등록 --></label></dt>
						        							<dd>
						        								<div class="fields">
											                       <div class="field">
											                           <div class="ui checkbox">
											                               <input type="checkbox" name="allDeclsNo" value="all" id="allDecls" onchange="changeCheckBox(this)">
											                               <label class="toggle_btn" for="allDecls"><spring:message code="exam.common.search.all" /></label><!-- 전체 -->
											                           </div>
											                       </div>
											                       <c:forEach var="list" items="${declsList }">
											                       		<c:set var="crsCreChk" value="N" />
												                   		<c:forEach var="item" items="${creCrsList }">
												                   			<c:if test="${item.crsCreCd eq list.crsCreCd }">
														                		<c:set var="crsCreChk" value="Y" />
												                   			</c:if>
												                   		</c:forEach>
												                   		<div class="field">
												                           <div class="ui checkbox">
												                               <input type="checkbox" ${list.crsCreCd eq crsCreCd || crsCreChk eq 'Y' ? 'class="readonly"' : '' } name="crsCreCds" id="decls_${list.declsNo }" value="${list.crsCreCd }" ${list.crsCreCd eq crsCreCd || crsCreChk eq 'Y' ? 'checked readonly' : '' } onchange="changeCheckBox(this)">
												                               <label class="toggle_btn" for="decls_${list.declsNo }">${list.declsNo }<spring:message code="exam.label.decls" /></label><!-- 반 -->
												                           </div>
												                       </div>
											                       </c:forEach>
											                    </div>
						        							</dd>
						        						</dl>
						        					</li>
					        					</c:if> --%>
					        					<li>
					        						<dl>
					        							<dt><label class="req"><spring:message code="seminar.label.seminar.date" /><!-- 세미나 일시 --></label></dt>
					        							<dd>
					        								<div class="fields gap4">
                                           						<uiex:ui-calendar dateId="seminarStartFmt" hourId="seminarStartHH" minId="seminarStartMM" rangeType="start" value="${vo.seminarStartDttm}"/>
					        								</div>
					        							</dd>
					        						</dl>
					        					</li>
					        					<li>
					        						<dl>
					        							<dt><label class="req"><spring:message code="seminar.label.progress.time" /><!-- 진행시간 --></label></dt>
					        							<dd>
					        								<c:set var="timeHour" value="1" />
					        								<c:set var="timeMin" value="0" />
					        								<c:if test="${not empty vo.seminarId }">
					        									<c:set var="timeHour" value="${vo.seminarTime / 60 }" />
					        									<c:set var="timeMin" value="${vo.seminarTime % 60 }" />
					        								</c:if>
					        								<fmt:parseNumber var="fmtHour" value="${timeHour }" integerOnly="true" />
					        								<select class="ui dropdown" id="seminarStartHour">
					        									<c:forEach var="hour" begin="0" end="5">
					        										<option value="0${hour }" ${hour eq fmtHour ? 'selected' : '' }>${hour }<spring:message code="seminar.label.time" /><!-- 시간 --></option>
					        									</c:forEach>
					        								</select>
					        								<select class="ui dropdown" id="seminarStartMin">
					        									<c:forEach var="min" begin="0" end="55" step="5">
					        										<option value="${min < 10 ? '0' : '' }${min }" ${min eq timeMin ? 'selected' : '' }>${min }<spring:message code="seminar.label.min" /><!-- 분 --></option>
					        									</c:forEach>
					        								</select>
					        							</dd>
					        						</dl>
					        					</li>
					        					<li>
					        						<dl>
					        							<dt><label class="req"><spring:message code="seminar.label.schedule" /><!-- 주차 --></label></dt>
					        							<dd>
					        								<select class="ui dropdown" name="lessonScheduleId" id="lessonScheduleId" onchange="selectListTime()">
					        									<option value=""><spring:message code="seminar.label.schedule.select" /><!-- 주차선택 --></option>
					        								</select>
					        								<input type="hidden" name="lessonTimeId" id="lessonTimeId" value="${vo.lessonTimeId }" />
					        								<%-- <label class="fcRed ml10"><spring:message code="seminar.message.schedule.attend" /><!-- ! 주차 출결이 필요한 경우 선택하세요. --></label> --%>
					        							</dd>
					        						</dl>
					        					</li>
					        					<li>
										            <dl>
										                <dt><label for="contentTextArea"><spring:message code="seminar.label.file.upload" /><!-- 파일 업로드 --></label></dt>
										                <dd>
										                	<uiex:dextuploader
																id="fileUploader"
																path="/seminar/${vo.seminarId }"
																limitCount="5"
																limitSize="1024"
																oneLimitSize="1024"
																listSize="3"
																fileList="${vo.fileList}"
																finishFunc="finishUpload()"
																useFileBox="true"
																allowedTypes="*"
															/>
										                </dd>
										            </dl>
										        </li>
					        				</ul>
					        			</div>
					        			<div class="ui segment onlineLi freeLi liDiv">
					        				<input type="hidden" name="hostUrl" id="hostUrl" value="${vo.hostUrl }" />
					        				<ul class="tbl">
					        					<li>
					        						<dl>
					        							<dt><label>ZOOM <spring:message code="seminar.label.setting" /><!-- 설정 --></label></dt>
					        							<dd>
					        								<a href="javascript:zoomWrite()" class="ui blue button">ZOOM <spring:message code="seminar.button.opened" /><!-- 개설 --></a>
					        							</dd>
					        						</dl>
					        					</li>
							        			<li>
							        				<dl>
							        					<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> ID</label></dt>
							        					<dd><input type="text" name="zoomId" id="zoomId" placeholder="ID <spring:message code='seminar.label.auto.marking' />" value="${vo.zoomId }" readonly="readonly" /></dd><!-- 자동 표시 됨 -->
							        				</dl>
							        			</li>
							        			<li>
							        				<dl>
							        					<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> PW</label></dt>
							        					<dd>
							        						<div class="ui input">
								        						<input type="text" name="zoomPw" id="zoomPw" placeholder="PW <spring:message code='seminar.label.auto.marking' />" value="${vo.zoomPw }" readonly="readonly" /><!-- 자동 표시 됨 -->
							        						</div>
							        					</dd>
							        				</dl>
							        			</li>
							        			<li>
							        				<dl>
							        					<dt><label>Zoom <spring:message code="seminar.label.stu" /><!-- 학생 --> URL</label></dt>
							        					<dd><input type="text" name="joinUrl" id="joinUrl" placeholder="URL <spring:message code='seminar.label.auto.marking' />" value="${vo.joinUrl }" readonly="readonly" /></dd><!-- 자동 표시 됨 -->
							        				</dl>
							        			</li>
							        			<li>
							        				<dl>
							        					<dt><label class="fcRed">ZOOM <spring:message code="seminar.label.detail.option" /><!-- 세부 옵션 --></label></dt>
							        					<dd></dd>
							        				</dl>
							        			</li>
										        <li>
										        	<dl>
										        		<dt><label><spring:message code="seminar.label.record" /><!-- 녹화 --></label></dt>
										        		<dd>
										        			<div class="fields">
													            <div class="field">
													                <div class="ui radio checkbox">
													                    <input type="radio" name="autoRecordYn" id="autoRecordY" ${vo.autoRecordYn eq 'Y' || empty vo.seminarId ? 'checked' : '' } value="Y" tabindex="0" class="hidden">
													                    <label for="autoRecordY"><spring:message code="seminar.common.yes" /><!-- 예 --></label>
													                </div>
													            </div>
													            <div class="field">
													                <div class="ui radio checkbox">
													                    <input type="radio" name="autoRecordYn" id="autoRecordN" ${vo.autoRecordYn eq 'N' ? 'checked' : '' } value="N" tabindex="0" class="hidden">
													                    <label for="autoRecordN"><spring:message code="seminar.common.no" /><!-- 아니오 --></label>
													                </div>
													            </div>
													        </div>
										        		</dd>
										        	</dl>
										        </li>
					        				</ul>
					        			</div>
						        		<div class="option-content">
						        			<div class="mla">
							        			<a href="javascript:saveConfirm()" class="ui blue button">
							        				<c:choose>
							        					<c:when test="${empty vo.seminarId }">
							        						<spring:message code="seminar.button.open.seminar" /><!-- 세미나 개설 -->
							        					</c:when>
							        					<c:otherwise>
							        						<spring:message code="seminar.button.edit.seminar" /><!-- 세미나 정보수정 -->
							        					</c:otherwise>
							        				</c:choose>
							        			</a>
							        			<%-- <c:if test="${empty vo.seminarId }">
									            	<a href="javascript:seminarCopyList()" class="ui blue button"><spring:message code="seminar.button.prev.seminar.copy" /><!-- 이전 세미나 가져오기 --></a>
								            	</c:if> --%>
								            	<a href="javascript:listSeminar()" class="ui blue button"><spring:message code="seminar.button.list" /><!-- 목록 --></a>
						        			</div>
						        		</div>
					        		</div>
				        		</form>
				        	</div>
				        </div>
				        <div class="row">
				        	<div class="col">
				        		<div class="ui segment">
						        	<div class="option-content mb20">
						        		<p class="mr15"><spring:message code="seminar.label.student" /><!-- 수강생 --></p>
						        		<span>[ <spring:message code="seminar.label.total" /><!-- 총 --> <label id="stdCnt" class="fcBlue"></label><spring:message code="seminar.label.cnt" /><!-- 건 --> ]</span>
						        		<div class="mla">
						        			<uiex:msgSendBtn func="sendMsg()"/><!-- 메시지 -->
						        		</div>
						        	</div>
						        	<div class="option-content mb20">
						        		<select class="ui dropdown" id="atndCd" onchange="listStd()">
						        			<option value="ALL"><spring:message code="seminar.common.search.all" /><!-- 전체 --></option>
												<option value="ATTEND"><spring:message code="seminar.label.attend" /><!-- 출석 --></option>
												<option value="LATE"><spring:message code="seminar.label.late" /><!-- 지각 --></option>
												<option value="ABSENT"><spring:message code="seminar.label.absent" /><!-- 결석 --></option>
												<option value="NONE"><spring:message code="seminar.label.pending" /><!-- 미걸 --></option>
						        		</select>
						        		<div class="ui action input search-box">
										    <input type="text" placeholder="<spring:message code='seminar.label.dept' />, <spring:message code='seminar.label.user.no' />, <spring:message code='seminar.label.user.nm' /> <spring:message code='seminar.button.input' />" class="w250" id="searchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
										    <button class="ui icon button" onclick="listStd()"><i class="search icon"></i></button>
										</div>
						        	</div>
						        	<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="stdTable"><!-- 등록된 내용이 없습니다. -->
						        		<thead>
						        			<tr class="ui native sticky top0">
						        				<th class='tc' scope="col">
													<div class="ui checkbox">
														<input type="hidden" id="stdNos" name="stdNos">
									                    <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAllStdNoToggle(this)">
									                    <label class="toggle_btn" for="allChk"></label>
									                </div>
												</th>
												<th class='tc'><spring:message code="common.number.no" /><!-- NO. --></th>
												<th class='tc' data-breakpoints="xs"><spring:message code="seminar.label.dept" /><!-- 학과 --></th>
												<th class='tc' data-breakpoints="xs"><spring:message code="seminar.label.user.no" /><!-- 학번 --></th>
												<th class='tc'><spring:message code="seminar.label.user.grade" /><!-- 학년 --></th>
												<th class='tc'><spring:message code="seminar.label.user.nm" /><!-- 이름 --></th>
												<th class='tc'><spring:message code="seminar.label.admission.year" /><!-- 입학년도 --></th>
												<th class='tc'><spring:message code="seminar.label.admission.grade" /><!-- 입학학년 --></th>
												<th class='tc'><spring:message code="seminar.label.admission.type" /><!-- 입학구분 --></th>
												<th class='tc' data-breakpoints="xs sm"><spring:message code="seminar.label.total.study.time" /><!-- 총 학습시간 --></th>
						        			</tr>
						        		</thead>
						        		<tbody id="stdList">
						        		</tbody>
						        	</table>
						        </div>
				        	</div>
				        </div>
		        	</div>
		        </div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>