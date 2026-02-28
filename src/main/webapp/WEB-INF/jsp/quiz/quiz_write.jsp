<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		if(${not empty vo.parExamCd && (vo.examTypeCd eq 'EXAM' || vo.examTypeCd eq 'SUBS')}) {
			insStdList();
		}

		$("#lessonScheduleId").closest("div").css("z-index", "1000");
	});

 	// 이전 퀴즈 가져오기 팝업
	function quizCopyList() {
 		var kvArr = [];

		submitForm("/quiz/quizCopyListPop.do", "quizPopIfm", "copy", kvArr);
	}

 	// 이전 퀴즈 가져오기
 	function copyQuiz(examCd) {
 		var url  = "/quiz/quizCopy.do";
		var data = {
			"examCd" : examCd
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var examVO = data.returnVO;
        		$("#searchTo").val(examVO.examCd);

        		var fileUploader = dx5.get("fileUploader");
        		fileUploader.clearItems();

        		// 가져온 파일 리스트
        		if (examVO.fileList.length > 0) {
        			var oldFiles = [];
        			var fileSns = new Set();

        			examVO.fileList.forEach(function(v, i) {
        				oldFiles.push({vindex:v.fileId, name:v.fileNm, size:v.fileSize, saveNm:v.fileSaveNm});
			        	fileSns.add(v.fileSn);
	        		});

        			fileUploader.addOldFileList(oldFiles);
        			fileUploader.showResetBtn();
	        		$("#fileSns").val(Array.from(fileSns));
        		}

        		$("#uploadPath").val("/quiz/${vo.examCd}");

        		// 퀴즈명
        		$("#examTitle").val(examVO.examTitle);
        		// 퀴즈 내용
        		$("button.se-clickable[name=new]").trigger("click");
        		editor.insertHTML($.trim(examVO.examCts) == "" ? " " : examVO.examCts);
        		// 퀴즈 시간
        		$("#examStareTm").val(examVO.examStareTm);
        		// 성적 반영 여부
        		var scoreAplyId = examVO.scoreAplyYn == "Y" ? "scoreAplyY" : "scoreAplyN";
        		$("#"+scoreAplyId).trigger("click");
        		// 문제 표시 방식
        		var viewQstnId  = examVO.viewQstnTypeCd == "ALL" ? "allViewQstn" : "eachViewQstn";
        		$("#"+viewQstnId).trigger("click");
        		// 보기 섞기
        		$("#emplRandomYnChk").prop("checked", examVO.emplRandomYn == "Y");
        		$('.modal').modal('hide');
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.copy' />");/* 가져오기 중 에러가 발생하였습니다. */
		});
 	}

 	// 저장 확인
    function saveConfirm() {
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
    			save();
    		} else {
    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    		}
    	}, function(xhr, status, error) {
    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
    	});
    }

    // 퀴즈 등록, 수정
    function save() {
    	if(!nullCheck()) {
    		return false;
    	}
    	setValue();
    	showLoading();

    	var fileUploader = dx5.get("fileUploader");
		$("#uploadFiles").val(fileUploader.getUploadFiles());
 		$("#copyFiles").val(fileUploader.getCopyFiles());
 		$("#delFileIdStr").val(fileUploader.getDelFileIdStr());
 		$("#uploadPath").val("/quiz/${vo.examCd}");

    	var url = "/quiz/writeQuiz.do";
    	if(${not empty vo.examCd}) {
    		url = "/quiz/editQuiz.do";
    	}
    	$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#writeQuizForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		if(${empty vo.examCd} || ${vo.examSubmitYn ne 'Y'}) {
        			alert("<spring:message code='exam.alert.already.quiz.qstn.submit' />");/* 퀴즈 문제관리에서 문제를 출제 해 주세요. */
        			quizPageView("qstn", data.returnVO.examCd);
        		} else {
	        		quizPageView("list", '');
        		}
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	if(${empty vo.examCd}) {
	        	alert("<spring:message code='exam.error.insert' />");/* 저장 중 에러가 발생하였습니다. */
        	} else {
	        	alert("<spring:message code='exam.error.update' />");/* 수정 중 에러가 발생하였습니다. */
        	}
        });
    }

    // 빈 값 체크
    function nullCheck() {
    	<spring:message code='exam.label.quiz' var='quiz'/> // 퀴즈

    	if($.trim($("#examTitle").val()) == "") {
    		alert("<spring:message code='exam.alert.input.title' />");/* 제목을 입력하세요. */
    		return false;
    	}
    	if(editor.isEmpty() || editor.getTextContent().trim() === "") {
 			alert("<spring:message code='exam.alert.input.contents' />");/* 내용을 입력하세요. */
 			return false;
 		}
    	if($("#examStartFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_start_date' arguments='${quiz}'/>");/* [퀴즈] 시작일을 입력하세요. */
			return false;
		}
		if($("#examStartHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${quiz}'/>");/* [퀴즈] 시작시간을 입력하세요. */
			return false;
		}
		if($("#examStartMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_min' arguments='${quiz}'/>");/* [퀴즈] 시작분을 입력하세요. */
			return false;
		}
    	if($("#examEndFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_end_date' arguments='${quiz}'/>");/* [퀴즈] 종료일을 입력하세요. */
			return false;
		}
		if($("#examEndHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${quiz}'/>");/* [퀴즈] 종료시간을 입력하세요. */
			return false;
		}
		if($("#examEndMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_min' arguments='${quiz}'/>");/* [퀴즈] 종료분을 입력하세요. */
			return false;
		}
		if ( ($("#examStartFmt").val()+$("#examStartHH").val()+$("#examStartMM").val()) >
			($("#examEndFmt").val()+$("#examEndHH").val()+$("#examEndMM").val()) ) {
			alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='${quiz}'/>"); // 종료일시를 시작일시 이후로 입력하세요.
			return false;
		}
    	if($("#examStareTm").val() == "") {
    		alert("<spring:message code='exam.alert.input.time' />");/* 시간을 입력하세요. */
    		return false;
    	}
    	if($("input[name=scoreAplyYn]:checked").length == 0) {
    		alert("<spring:message code='exam.alert.select.score.aply' />");/* 성적 반영 여부를 선택하세요. */
    		return false;
    	}
    	if($("input[name=viewQstnTypeCd]:checked").length == 0) {
    		alert("<spring:message code='exam.alert.select.view.qstn.type' />");/* 문제 표시 방식을 선택하세요. */
    		return false;
    	}

    	return true;
    }

    // 값 채우기
    function setValue() {
    	// 퀴즈 내용
    	var examContents = editor.getPublishingHtml();
		$("#examCts").val(examContents);

		// 퀴즈 시작일시
		if ($("#examStartFmt").val() != null && $("#examStartFmt").val() != "") {
			$("#examStartDttm").val($("#examStartFmt").val().replaceAll(".","") + "" + pad($("#examStartHH option:selected").val(),2) + "" + pad($("#examStartMM option:selected").val(),2) + "00");
		}

		// 퀴즈 종료일시
		if ($("#examEndFmt").val() != null && $("#examEndFmt").val() != "") {
			$("#examEndDttm").val(setDateEndDttm($("#examEndFmt").val().replaceAll(".","") + "" + pad($("#examEndHH option:selected").val(),2) + "" + pad($("#examEndMM option:selected").val(),2),""));
		}

		// 보기 섞기
		$("#emplRandomYn").val($("#emplRandomYnChk").is(":checked") ? "Y" : "N");
		// 분반 체크 여부
		if(${empty vo.examCd}) {
			$("#declsRegYn").val($("input:checkbox[name=crsCreCds]:checked").length > 1 ? "Y" : "N");
		}

		if($("input[name='gradeViewYn']:checked").val() == "Y") {
			// 즉시답안보기
			$("#imdtAnsrViewYn").val($("#imdtAnsrViewYnCheck").is(":checked") ? "Y" : "N");
		} else {
			$("#imdtAnsrViewYn").val("N");
		}
    }

	// 퀴즈 페이지 이동
	function quizPageView(type, examCd) {
		var urlMap = {
			"qstn" : "/quiz/quizQstnManage.do"/* 문항관리 */,
			"list" : "/quiz/profQzListView.do"/* 목록 */
		}
		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : examCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm(urlMap[type], "", "", kvArr);
	}

	// 분반 체크박스 이벤트
	function checkDecls(obj) {
		if(obj.value == "all") {
			$("input[name=crsCreCds]").not(".readonly").prop("checked", obj.checked);
		} else {
			$("#allDecls").prop("checked", $("input[name=crsCreCds]").length == $("input[name=crsCreCds]:checked").length);
		}
	}

	// 대체평가 대상자 설정 팝업
	function examInsTargetPop(examCd) {
		var endDate = new Date("${fn:substring(vo.parExamEndDttm, 0, 4)}", parseInt("${fn:substring(vo.parExamEndDttm, 4, 6)}") -2, "${fn:substring(vo.parExamEndDttm, 6, 8)}");
		endDate.setDate(endDate.getDate()+1);
		var year = endDate.getFullYear();
		var month = (""+endDate.getMonth()).length == 1 ? "0" + endDate.getMonth() : endDate.getMonth();
		var day = endDate.getDate();
		var date = year + "" + month + "" + day + "07";
		if(date > "${fn:substring(today, 0, 10)}") {
			alert("<spring:message code='exam.alert.exam.applicate.not.date' />");/* 실시간시험일 익일 7시 이후 설정가능합니다. */
		} else {
			var kvArr = [];
			kvArr.push({'key' : 'examCd', 	'val' : examCd});
			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

			submitForm("/exam/examInsTargetPop.do", "quizPopIfm", "examInsTarget", kvArr);
		}
	}

	// 대체평가 대상자 선택 취소
	function examInsTargetCancel(examCd) {
		var stdNos = "";
		$("#stdTbody input[name=evalChk]:checked").each(function(i, v) {
			if(i > 0) stdNos += ",";
			stdNos += $(v).attr("data-stdNo");
		});

		if(stdNos == "") {
			alert("<spring:message code='common.alert.select.student' />");/* 학습자를 선택하세요. */
			return false;
		}

		var url  = "/exam/insTargetCancelByStdNos.do";
		var data = {
			"examCd"  : "${vo.parExamCd}",
			"stdNos"   : stdNos
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
				insStdList();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
            /* 삭제 중 에러가 발생하였습니다. */
            alert("<spring:message code='exam.error.delete' />");
		}, true);
	}

	// 대체평가 대상자 목록
	function insStdList() {
		var url  = "/exam/listInsTraget.do";
		var data = {
			"examCd"     : "${vo.parExamCd}",
			"crsCreCd"   : '${vo.crsCreCd}',
			"searchType" : "submit"
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = "";

				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						var absentNm = v.absentNm;
						if(v.absentNm == "APPROVE") absentNm = "<spring:message code='exam.label.approve' />";/* 승인 */
						if(v.absentNm == "APPLICATE") absentNm = "<spring:message code='exam.label.applicate' />";/* 신청 */
						if(v.absentNm == "RAPPLICATE") absentNm = "<spring:message code='exam.label.rapplicate' />";/* 재신청 */
						if(v.absentNm == "COMPANION") absentNm = "<spring:message code='exam.label.companion' />";/* 반려 */
						html += "<tr>";
						html += "	<td class='tc'>";
						html += "		<div class='ui checkbox'>";
						html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' data-stdNo='"+v.stdNo+"' user_id='"+v.userId+"' user_nm='"+v.userNm+"' mobile='"+v.mobileNo+"' email='"+v.email+"' onchange='checkStd(this)'>";
						html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
						html += "		</div>";
						html += "	</td>";
						html += "	<td>"+v.lineNo+"</td>";
						html += "	<td>"+v.deptNm+"</td>";
						html += "	<td>"+v.userId+"</td>";
						html += "	<td>"+v.userNm+"</td>";
						html += "	<td>"+v.stareYn+"</td>";
						html += "	<td>"+v.absentYn+"</td>";
						html += "	<td>"+absentNm+"</td>";
						html += "	<td><button type='button' class='ui basic small button' onclick='removeReStare(\""+v.stdNo+"\")'>삭제</button></td>";
						html += "</tr>";
					});
				}

				$("#stdTbody").empty().html(html);
				$("#stdTable").footable();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
            /* 리스트 조회 중 에러가 발생하였습니다. */
            alert("<spring:message code='exam.error.list' />");
		}, true);
	}

	// 대체평가 대상자 삭제
	function removeReStare(stdNo) {
		var url  = "/exam/insTargetCancel.do";
		var data = {
			"examCd"  : "${vo.parExamCd}",
			"stdNo"   : stdNo
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
				insStdList();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
            /* 삭제 중 에러가 발생하였습니다. */
            alert("<spring:message code='exam.error.delete' />");
		}, true);
	}

	// 체크박스
	function checkStd(obj) {
		if(obj.value == "all") {
			$("input[name=evalChk]").prop("checked", obj.checked);
		} else {
			$("#evalChkAll").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
		}
	}

	// 메세지 보내기
	function sendMsg(type) {
		var rcvUserInfoStr = "";
		var sendCnt = 0;

		$.each($('#stdTbody').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
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

	// 시험지 공개여부 변경
	function changeGradeViewYn(value) {
		$("#imdtAnsrViewYnCheck").prop("checked", false);

		if(value == "Y") {
			$("#imdtAnsrViewYnDiv").show();
		} else {
			$("#imdtAnsrViewYnDiv").hide();
		}
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
		        		<spring:message code="exam.button.save" var="save" /><!-- 저장 -->
		        		<spring:message code="exam.button.mod"  var="modify" /><!-- 수정 -->
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
		                    <div class="button-area">
		                    	<a href="javascript:saveConfirm()" class="ui blue button">${empty vo.examCd ? save : modify }</a>
		                        <a href="javascript:quizCopyList()" class="ui blue button"><spring:message code="exam.label.prev" /> <spring:message code="exam.label.quiz" /> <spring:message code="exam.label.copy" /></a><!-- 이전 --><!-- 퀴즈 --><!-- 가져오기 -->
		                        <a href="javascript:quizPageView('list', '')" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
				        <div class="row">
				        	<div class="col">
				                <form name="writeQuizForm" id="writeQuizForm" method="POST" autocomplete="off">
				                	<input type="hidden" name="crsCreCd" 		value="${vo.crsCreCd }" />
				                	<input type="hidden" name="examCd" 			value="${vo.examCd }" />
				                	<input type="hidden" name="scoreRatio" 		value="0" />
				                	<input type="hidden" name="dsbdYn" 			value="N" />
				                	<input type="hidden" name="dsbdTm" 			value="0" />
				                	<input type="hidden" name="stareLimitCnt" 	value="99" />
				                	<input type="hidden" name="avgScoreOpenYn" 	value="N" />
				                	<input type="hidden" name="repoCd"			value="EXAM_CD" />
				                	<input type="hidden" name="tmLimitYn"		value="Y" />
				                	<!-- <input type="hidden" name="reExamYn"		value="Y" /> -->
				                	<input type="hidden" name="examStartDttm" 	value="${vo.examStartDttm }"   id="examStartDttm" />
				                	<input type="hidden" name="examEndDttm" 	value="${vo.examEndDttm }"     id="examEndDttm" />
				                	<input type="hidden" name="qstnSetTypeCd" 	value="RANDOM" />
				                	<input type="hidden" name="emplRandomYn" 	value="${vo.emplRandomYn }"    id="emplRandomYn" />
				                	<input type="hidden" name="reExamStartDttm" value="${vo.reExamStartDttm }" id="reExamStartDttm" />
				                	<input type="hidden" name="reExamEndDttm" 	value="${vo.reExamEndDttm }"   id="reExamEndDttm" />
				                	<input type="hidden" name="declsRegYn" 		value="${vo.declsRegYn }"	   id="declsRegYn" />
				                	<input type="hidden" name="imdtAnsrViewYn"	value=""					   id="imdtAnsrViewYn" />
				                	<input type="hidden" name="examCts" 		value=""					   id="examCts"/>
				                	<input type="hidden" name="uploadFiles"		value=""					   id="uploadFiles" />
				                	<input type="hidden" name="copyFiles"		value=""					   id="copyFiles" />
				                	<input type="hidden" name="delFileIdStr"	value=""					   id="delFileIdStr" />
				                	<input type="hidden" name="uploadPath"		value=""					   id="uploadPath" />
				                	<input type="hidden" name="searchTo"		value=""					   id="searchTo" />
				                	<input type="hidden" name="fileSns"			value=""					   id="fileSns" />

					                <div class="ui form" id="quizWriteDiv">
										<div class="ui segment">
										    <ul class="tbl border-top-grey">
										    	<li>
					                                <dl>
					                                    <dt>
					                                    	<label for="lessonScheduleId">
					                                    		<spring:message code="common.week"/><!-- 주차 -->
					                                    	</label>
					                                    </dt>
					                                    <dd>
				                                            <select class="ui dropdown w300" id="lessonScheduleId" name="lessonScheduleId">
																<option value="DEFALUT"><spring:message code="common.week"/><!-- 주차 --><spring:message code="common.button.choice"/><!-- 선택 --></option>
																<c:forEach var="item" items="${lessonScheduleList}" varStatus="status">
																	<option value="${item.lessonScheduleId}"
																		<c:choose>
																			<c:when test="${not empty vo.examCd}">
																				<c:if test="${vo.lessonScheduleId eq item.lessonScheduleId}">selected</c:if>
																			</c:when>
																			<c:otherwise>
																				<c:if test="${lessonScheduleId eq item.lessonScheduleId}">selected</c:if>
																			</c:otherwise>
																		</c:choose>
																	>${item.lessonScheduleNm}</option>
																</c:forEach>
															</select>
					                                    </dd>
					                                </dl>
					                            </li>
										        <li>
										            <dl>
										                <dt><label for="examTitle" class="req"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></label></dt><!-- 퀴즈 --><!-- 명 -->
										                <dd>
										                    <div class="ui fluid input">
										                        <input type="text" name="examTitle" id="examTitle" value="${vo.examTitle }">
										                    </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label for="contentTextArea" class="req"><spring:message code="exam.label.quiz" /> <spring:message code="exam.label.cts" /></label></dt><!-- 퀴즈 --><!-- 내용 -->
										                <dd style="height:400px">
	            											<div style="height:100%">
										                		<textarea name="contentTextArea" id="contentTextArea">${vo.examCts }</textarea>
										                		<script>
											                       // html 에디터 생성
											               	  		var editor = HtmlEditor('contentTextArea', THEME_MODE, '/quiz', 'Y', 50);
											                   	</script>
										                	</div>
														</dd>
										            </dl>
										        </li>
										        <c:if test="${empty vo.examCd }">
											        <li>
											            <dl>
											                <dt><label for="contLabel" class="req"><spring:message code="exam.label.decls.modi.y" /></label></dt><!-- 분반 일괄 등록 -->
											                <dd>
											                	<div class="fields">
											                       <div class="field">
											                           <div class="ui checkbox">
											                               <input type="checkbox" name="allDeclsNo" value="all" id="allDecls" onchange="checkDecls(this)">
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
												                               <input type="checkbox" ${list.crsCreCd eq vo.crsCreCd || crsCreChk eq 'Y' ? 'class="readonly"' : '' } name="crsCreCds" id="decls_${list.declsNo }" value="${list.crsCreCd eq vo.crsCreCd || crsCreChk eq 'Y' ? '' : list.crsCreCd }" ${list.crsCreCd eq vo.crsCreCd || crsCreChk eq 'Y' ? 'checked readonly' : '' } onchange="checkDecls(this)">
												                               <label class="toggle_btn" for="decls_${list.declsNo }">${list.declsNo }<spring:message code="exam.label.decls" /></label><!-- 반 -->
												                           </div>
												                       </div>
											                       </c:forEach>
											                	</div>
											                </dd>
											            </dl>
											        </li>
										        </c:if>
										        <li>
										            <dl>
										                <dt><label for="examStartFmt" class="req"><spring:message code="exam.label.quiz" /> <spring:message code="exam.label.period" /> </label></dt><!-- 퀴즈 --><!-- 기간 -->
										                <dd>
										                	<div class="fields gap4">
					                                            <div class="field flex">
					                                               <!-- 시작일시 -->
					                                               <uiex:ui-calendar dateId="examStartFmt" hourId="examStartHH" minId="examStartMM"
					                                               		rangeType="start" rangeTarget="examEndFmt" value="${vo.examStartDttm}"/>
					                                            </div>
					                                            <div class="field p0 flex-item desktop-elem">~</div>
					                                            <div class="field flex">
					                                           	   <!-- 종료일시 -->
					                                               <uiex:ui-calendar dateId="examEndFmt" hourId="examEndHH" minId="examEndMM"
					                                               		rangeType="end" rangeTarget="examStartFmt" value="${vo.examEndDttm}"/>
					                                            	<div class="ui message m0 p5 pl10 f080 flex-item-center" style="line-height: 1em;">
							                                        	<spring:message code="exam.label.end.dttm.guide" /><!-- 종료시간에 맞춰 동시종료됨 -->
						                                        	</div>
					                                            </div>
					                                        </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label for="examStareTm" class="req"><spring:message code="exam.label.quiz" /> <spring:message code="exam.label.time" /></label></dt><!-- 퀴즈 --><!-- 시간 -->
										                <dd>
										                	<div class="fields">
										                		<div class="field">
										                			<div class="ui input num">
													                	<input type="text" name="examStareTm" id="examStareTm" class="w50" value="${vo.examStareTm }">
										                			</div>
										                			<spring:message code="exam.label.stare.min" /><!-- 분 -->
										                		</div>
										                	</div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label class="req"><spring:message code="exam.label.score.aply.y" /></label></dt><!-- 성적반영 -->
										                <dd>
										                    <div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" name="scoreAplyYn" id="scoreAplyY" value="Y" tabindex="0" class="hidden" ${vo.scoreAplyYn eq 'Y' || empty vo.examCd ? 'checked' : '' }>
										                                <label for="scoreAplyY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
										                            </div>
										                        </div>
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" name="scoreAplyYn" id="scoreAplyN" value="N" tabindex="0" class="hidden" ${vo.scoreAplyYn eq 'N' ? 'checked' : '' }>
										                                <label for="scoreAplyN"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
										                            </div>
										                        </div>
										                    </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										        	<dl>
											        	<dt><spring:message code="exam.label.score.open.y" /></dt><!-- 성적공개 -->
											        	<dd>
											        		<div class="fields">
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" id="scoreOpenY" name="scoreOpenYn" value="Y" tabindex="0" class="hidden" ${vo.scoreOpenYn eq 'Y' ? 'checked' : '' }>
											                            <label for="scoreOpenY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
											                        </div>
											                    </div>
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" id="scoreOpenN" name="scoreOpenYn" value="N" tabindex="0" class="hidden" ${empty vo.examCd || vo.scoreOpenYn eq 'N' ? 'checked' : '' }>
											                            <label for="scoreOpenN"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
											                        </div>
											                    </div>
											                </div>
											        	</dd>
											        </dl>
										        </li>
										        <li>
										        	<dl>
											        	<dt><spring:message code="exam.label.paper.open" /></dt><!-- 시험지 공개 -->
											        	<dd>
											        		<div class="fields">
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" id="gradeViewY" name="gradeViewYn" value="Y" tabindex="0" class="hidden" onchange="changeGradeViewYn(this.value)" ${empty vo.examCd || vo.gradeViewYn eq 'Y' ? 'checked' : '' }>
											                            <label for="gradeViewY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
											                        </div>
											                    </div>
											                    <div class="field">
											                        <div class="ui radio checkbox">
											                            <input type="radio" id="gradeViewN" name="gradeViewYn" value="N" tabindex="0" class="hidden" onchange="changeGradeViewYn(this.value)" ${vo.gradeViewYn eq 'N' ? 'checked' : '' }>
											                            <label for="gradeViewN"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
											                        </div>
											                    </div>
										                    <c:if test="${vo.crsCreCd.contains('JLPT')}">
											                    <div class="field" id="imdtAnsrViewYnDiv" style="<c:if test="${not(empty vo.examCd || vo.gradeViewYn eq 'Y')}">display: none;</c:if>">
								                                    <div class="ui checkbox">
								                                        <input type="checkbox" id="imdtAnsrViewYnCheck" <c:if test="${vo.imdtAnsrViewYn eq 'Y'}">checked</c:if> />
								                                        <label class="toggle_btn" for="imdtAnsrViewYnCheck"><spring:message code="exam.label.impt.ansr.view.yn" /><!-- 즉시답안보기 --></label>
								                                    </div>
								                                </div>
							                                </c:if>
											                </div>
											        	</dd>
											        </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label class="req"><spring:message code="exam.label.view.qstn.type" /></label></dt><!-- 문제표시방식 -->
										                <dd>
										                    <div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="allViewQstn" name="viewQstnTypeCd" value="ALL" tabindex="0" class="hidden" ${vo.viewQstnTypeCd eq 'ALL' || empty vo.examCd ? 'checked' : '' }>
										                                <label for="allViewQstn"><spring:message code="exam.label.all.view.qstn" /></label><!-- 전체문제 표시 -->
										                            </div>
										                        </div>
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="eachViewQstn" name="viewQstnTypeCd" value="EACH" tabindex="0" class="hidden" ${vo.viewQstnTypeCd eq 'EACH' ? 'checked' : '' }>
										                                <label for="eachViewQstn"><spring:message code="exam.label.each.view.qstn" /></label><!-- 페이지별로 1문제씩 표시 -->
										                            </div>
										                        </div>
										                    </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label for="teamLabel"><spring:message code="exam.label.empl.random" /></label></dt><!-- 보기 섞기 -->
										                <dd>
										                	<div class="fields">
										                        <div class="inline field">
										                            <div class="ui toggle checkbox">
										                                <input type="checkbox" name="emplRandomYnChk" id="emplRandomYnChk" ${vo.emplRandomYn eq 'Y' || empty vo.examCd ? 'checked' : '' }>
											                            <label for="emplRandomYnChk"></label>
										                            </div>

										                        </div>
										                    </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label><spring:message code="exam.tab.reexam.manage" /></label></dt><!-- 미응시 관리 -->
										                <dd>
										                    <div class="fields">
										                        <div class="field flex-item">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="reExamYnY" name="reExamYn" value="Y" tabindex="0" class="hidden" ${empty vo.reExamYn or vo.reExamYn eq 'Y' ? 'checked' : ''}>
										                                <label for="reExamYnY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
										                            </div>
										                        </div>
										                        <div class="field flex-item">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="reExamYnN" name="reExamYn" value="N" tabindex="0" class="hidden" ${vo.reExamYn eq 'N' ? 'checked' : ''}>
										                                <label for="reExamYnN"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
										                            </div>
										                        </div>
										                    </div>
										                    <div class="ui message info p10"><spring:message code="exam.label.re.exam.info" /><!-- '예' 선택 시, 미응시 관리 탭이 생성되어 미응시자를 대상으로 별도의 응기 기회 부여가 가능합니다. --></div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label for="contentTextArea"><spring:message code="exam.label.file" /></label></dt><!-- 첨부파일 -->
										                <dd>
										                	<c:set var="path" value="" />
										                	<c:choose>
										                		<c:when test="${empty vo.examCd }">
										                    	<c:set var="path" value="/quiz" />
										                		</c:when>
										                		<c:otherwise>
										                    	<c:set var="path" value="/quiz/${vo.examCd }" />
										                		</c:otherwise>
										                	</c:choose>
										                	<!-- 파일업로더 -->
                                                            <uiex:dextuploader
																id="fileUploader"
																path="${path}"
																limitCount="5"
																limitSize="1024"
																oneLimitSize="1024"
																listSize="3"
																fileList="${fileList}"
																finishFunc="finishUpload()"
																useFileBox="true"
																allowedTypes="*"
																bigSize="false"
															/>
										                </dd>
										            </dl>
										        </li>
										    </ul>
										</div>
					                </div>
				                </form>
				                <div class="option-content mt20">
				                	<div class="mla">
				                		<a href="javascript:saveConfirm()" class="ui blue button">${empty vo.examCd ? save : modify }</a>
				                        <a href="javascript:quizCopyList()" class="ui blue button"><spring:message code="exam.label.prev" /> <spring:message code="exam.label.quiz" /> <spring:message code="exam.label.copy" /></a><!-- 이전 --><!-- 퀴즈 --><!-- 가져오기 -->
				                        <a href="javascript:quizPageView('list', '')" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
				                    </div>
				                </div>
				                <c:if test="${not empty vo.parExamCd && vo.examTypeCd eq 'SUBS' }">
				                    <div class="option-content mt30">
				                    	<h3 class="sec_head">
				                    		<c:if test="${vo.examStareTypeCd eq 'M' }"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></c:if>
				                    		<c:if test="${vo.examStareTypeCd eq 'L' }"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></c:if>
				                    		<spring:message code="exam.label.ins.target" /><!-- 대체평가 대상자 -->
				                    	</h3>
				                    	<div class="mla">
				                    		<a href="javascript:sendMsg()" class="ui basic small button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
				                    		<a href="javascript:examInsTargetPop('${vo.parExamCd }')" class="ui blue small button"><spring:message code="exam.label.ins.target.set" /></a><!-- 대상자 설정 -->
				                    		<a href="javascript:examInsTargetCancel('${vo.parExamCd }')" class="ui blue small button"><spring:message code="exam.label.ins.target.cancel" /></a><!-- 대상자 취소 -->
				                    	</div>
				                    </div>
				                    <table class="table type2" id="stdTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.label.exam.ins.target.none' />" id="examEtcListTable"><!-- '대상자설정' 버튼을 클릭 후 대상자를 설정해주세요. -->
				                    	<thead>
				                    		<tr>
				                    			<th>
				                    				<div class="ui checkbox">
											             <input type="checkbox" name="evalChkAll" id="evalChkAll" value="all" onchange="checkStd(this)">
											             <label class="toggle_btn" for="evalChkAll"></label>
											        </div>
				                    			</th>
				                    			<th><spring:message code="common.number.no" /><!-- NO --></th>
				                    			<th><spring:message code="exam.label.dept" /><!-- 학과 --></th>
				                    			<th><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
				                    			<th><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
				                    			<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.yes.stare" /><!-- 응시 --></th>
				                    			<th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.submit.y" /><!-- 제출 --></th>
				                    			<th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.approve" /><!-- 승인 --></th>
				                    			<th><spring:message code="exam.label.manage" /><!-- 관리 --></th>
				                    		</tr>
				                    	</thead>
				                    	<tbody id="stdTbody">
				                    	</tbody>
				                    </table>
				                    <div class="option-content">
				                    	<div class="mla">
				                    		<a href="javascript:quizPageView('list', '')" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
				                    	</div>
				                    </div>
			                    </c:if>
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