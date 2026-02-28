<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
    	<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
    	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <script type="text/javascript">
	    $(document).ready(function () {
			examDateSet();
		});
		
	 	// 이전 퀴즈 가져오기 팝업
		function quizCopyList() {
			$("#quizCopyListForm").attr("target", "quizCopyIfm");
	        $("#quizCopyListForm").attr("action", "/quiz/quizCopyListPop.do");
	        $("#quizCopyListForm").submit();
	        $('#quizCopyPop').modal('show');
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
	        		// 가져온 파일 리스트
	        		$("#searchTo").val(examVO.examCd);
	        		var fileSns = new Set();
	        		if(fileUploader.limitCount < examVO.fileList.length) {
	        			/* 최대 가능 개수를 넘어 파일 가져오기가 취소되었습니다. */
	        			alert("<spring:message code='exam.alert.max.file.limit.cancel' />");
	        		} else {
	        			$(".old-file").remove();
		        		examVO.fileList.forEach(function(v, i) {
		        			fileUploader.addOldFile(v.fileId, v.fileNm, v.fileSize);
				        	fileSns.add(v.fileSn);
		        		});
		        		$("#fileSns").val(Array.from(fileSns));
	        		}
	        		$("#uploadPath").val("/quiz/${examVo.examCd}");
	        		
	        		// 퀴즈명
	        		$("#examTitle").val(examVO.examTitle);
	        		// 퀴즈 내용
	        		$("button.se-clickable[name=new]").trigger("click");
	        		editor.insertHTML($.trim(examVO.examCts) == "" ? " " : examVO.examCts);
	        		// 퀴즈 시간
	        		$("#examStareTm").val(examVO.examStareTm);
	        		// 문제 표시 방식
	        		var viewQstnId = examVO.viewQstnTypeCd == "ALL" ? "allViewQstn" : "eachViewQstn";
	        		$("#"+viewQstnId).trigger("click");
	        		// 문제 섞기
	        		$("#qstnSetTypeCdChk").prop("checked", examVO.qstnSetTypeCd == "RANDOM");
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
	    	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.path
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("#uploadFiles").val(fileUploader.getUploadFiles());
	    	 		$("#copyFiles").val(fileUploader.getCopyFiles());
	    	 		$("#uploadPath").val("/quiz/${examVo.examCd}");
	    			
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
	    	var url = "/quiz/writeQuiz.do";
	    	if(${not empty examVo.examCd }) {
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
	        		var startDttm = $("#examStartFmt").val().replaceAll(".","") + "" + pad($("#examStartHH option:selected").val(),2) + "" + pad($("#examStartMM option:selected").val(),2);
            		var endDttm   = $("#examEndFmt").val().replaceAll(".","") + "" + pad($("#examEndHH option:selected").val(),2) + "" + pad($("#examEndMM option:selected").val(),2);
	        		
	        		var quizVO = data.returnVO;
	        		if(${empty examVo.examCd }) {
			        	alert("<spring:message code='exam.alert.insert' />");/* 정상 저장 되었습니다. */
		        	} else {
			        	alert("<spring:message code='exam.alert.update' />");/* 정상 수정 되었습니다. */
		        	}
	        		window.parent.complateWriteType("QUIZ", quizVO.examCd, quizVO.examTitle, startDttm, endDttm);
	        		window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	if(${empty examVo.examCd }) {
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
			
			// 퀴즈 시작 일시
			if ($("#examStartFmt").val() != null && $("#examStartFmt").val() != "") {
				$("#examStartDttm").val($("#examStartFmt").val().replaceAll(".","") + "" + pad($("#examStartHH option:selected").val(),2) + "" + pad($("#examStartMM option:selected").val(),2) + "00");
			}
			
			// 퀴즈 종료 일시
			if ($("#examEndFmt").val() != null && $("#examEndFmt").val() != "") {
				$("#examEndDttm").val($("#examEndFmt").val().replaceAll(".","") + "" + pad($("#examEndHH option:selected").val(),2) + "" + pad($("#examEndMM option:selected").val(),2) + "00");
			}
			
			// 문제 섞기
			$("#qstnSetTypeCd").val($("#qstnSetTypeCdChk").is(":checked") ? "RANDOM" : "SAME");
			
			// 보기 섞기
			$("#emplRandomYn").val($("#emplRandomYnChk").is(":checked") ? "Y" : "N");
	    }
	    
	    // 시험 날짜 세팅
	    function examDateSet() {
	    	if("${dateVO.startDate}" != "") $("#examStartFmt").val("${dateVO.startDate}");
	    	if("${dateVO.startHH}" != "") $("#examStartHH option[value=${dateVO.startHH}]").prop("selected", true).trigger("change");
	    	if("${dateVO.startMM}" != "") $("#examStartMM option[value=${dateVO.startMM}]").prop("selected", true).trigger("change");
	    	if("${dateVO.endDate}" != "") $("#examEndFmt").val("${dateVO.endDate}");
	    	if("${dateVO.endHH}" != "") $("#examEndHH option[value=${dateVO.endHH}]").prop("selected", true).trigger("change");
	    	if("${dateVO.endMM}" != "") $("#examEndMM option[value=${dateVO.endMM}]").prop("selected", true).trigger("change");
	    }
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
		<form id="quizCopyListForm" name="quizCopyListForm" method="POST"></form>
        <div id="wrap">
        	<div class="option-content mb20">
        		<div class="mla">
        			<a href="javascript:quizCopyList()" class="ui blue button"><spring:message code="exam.button.prev.quiz.copy" /></a><!-- 이전 퀴즈 가져오기 -->
        		</div>
        	</div>
        	<form name="writeQuizForm" id="writeQuizForm" method="POST" autocomplete="off">
				<input type="hidden" name="crsCreCd" 		value="${creCrsVO.crsCreCd }" />
				<input type="hidden" name="examCd" 			value="${examVo.examCd }" />
				<input type="hidden" name="scoreRatio" 		value="${empty evo.examCd ? '0' : evo.scoreRatio }" />
				<input type="hidden" name="dsbdYn" 			value="N" />
				<input type="hidden" name="dsbdTm" 			value="0" />
				<input type="hidden" name="stareLimitCnt" 	value="99" />
				<input type="hidden" name="avgScoreOpenYn" 	value="N" />
				<input type="hidden" name="repoCd"			value="EXAM_CD" />
				<input type="hidden" name="declsRegYn" 		value="N" />
				<input type="hidden" name="reExamYn"		value="Y" />
				<input type="hidden" name="gradeViewYn" 	value="Y" />
				<input type="hidden" name="examStareTypeCd" value="${dateVO.examStareTypeCd }" />
				<input type="hidden" name="examTypeCd"		value="${examTypeCd eq 'EXAM' ? 'SUBS' : 'EXAM' }" />
				<input type="hidden" name="examStartDttm" 	value="${examVo.examStartDttm }"   	id="examStartDttm" />
				<input type="hidden" name="examEndDttm" 	value="${examVo.examEndDttm }"     	id="examEndDttm" />
				<input type="hidden" name="qstnSetTypeCd" 	value="${examVo.qstnSetTypeCd }"   	id="qstnSetTypeCd" />
				<input type="hidden" name="emplRandomYn" 	value="${examVo.emplRandomYn }"    	id="emplRandomYn" />
				<input type="hidden" name="examCts" 		value=""					   		id="examCts"/>
				<input type="hidden" name="uploadFiles"		value=""					   		id="uploadFiles" />
				<input type="hidden" name="copyFiles"		value=""					   		id="copyFiles" />
				<input type="hidden" name="uploadPath"		value=""					   		id="uploadPath" />
				<input type="hidden" name="searchTo"		value=""					   		id="searchTo" />
				<input type="hidden" name="fileSns"			value=""					   		id="fileSns" />
			    <div class="ui form" id="quizWriteDiv">
					<div class="ui segment">
					    <ul class="tbl border-top-grey">
					        <li>
					            <dl>
					                <dt><label for="examTitle" class="req"><spring:message code="crs.label.quiz_name" /></label></dt><!-- 퀴즈명 -->
					                <dd>
					                    <div class="ui fluid input">
					                        <input type="text" name="examTitle" id="examTitle" value="${examVo.examTitle }">
					                    </div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="contentTextArea" class="req"><spring:message code="crs.label.quiz_contents" /></label></dt><!-- 퀴즈내용 -->
					                <dd style="height:400px">
	            						<div style="height:100%">
					                		<textarea name="contentTextArea" id="contentTextArea">${examVo.examCts }</textarea>
					                		<script>
						                       // html 에디터 생성
						               	  		var editor = HtmlEditor('contentTextArea', THEME_MODE, '${path }');
						                   	</script>
					                	</div>
									</dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="examStartFmt" class="req"><spring:message code="crs.label.quiz_period" /> </label></dt><!-- 퀴즈기간 -->
					                <dd>
					                	<div class="fields gap4">
					                        <div class="field flex">
					                           <!-- 시작일시 -->
					                           <uiex:ui-calendar dateId="examStartFmt" hourId="examStartHH" minId="examStartMM" rangeType="start" rangeTarget="examEndFmt" value="${evo.examStartDttm}"/>
					                        </div>
					                        <div class="field p0 flex-item desktop-elem">~</div>
					                        <div class="field flex">
					                       	   <!-- 종료일시 -->
					                           <uiex:ui-calendar dateId="examEndFmt" hourId="examEndHH" minId="examEndMM" rangeType="end" rangeTarget="examStartFmt" value="${evo.examEndDttm}"/>
					                        </div>
					                    </div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="examStareTm" class="req"><spring:message code="crs.label.quiz_time" /></label></dt><!-- 퀴즈시간 -->
					                <dd>
					                	<div class="fields">
					                		<div class="field">
					                			<div class="ui input num">
								                	<input type="text" name="examStareTm" id="examStareTm" class="w50" value="${examVo.examStareTm }">
					                			</div>
					                			<spring:message code="exam.label.stare.min" /><!-- 분 -->
					                		</div>
					                	</div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					        	<dl>
					        		<dt><spring:message code="exam.label.score.aply.y" /></dt><!-- 성적반영 -->
					        		<dd>
					        			<div class="fields">
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" id="scoreAplyY" name="scoreAplyYn" value="Y" tabindex="0" class="hidden" ${empty examVo.examCd || examVo.scoreAplyYn eq 'Y' ? 'checked' : '' }>
						                            <label for="scoreAplyY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
						                        </div>
						                    </div>
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" id="scoreAplyN" name="scoreAplyYn" value="N" tabindex="0" class="hidden" ${examVo.scoreAplyYn eq 'N' ? 'checked' : '' }>
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
						                            <input type="radio" id="scoreOpenY" name="scoreOpenYn" value="Y" tabindex="0" class="hidden" ${empty examVo.examCd || examVo.scoreOpenYn eq 'Y' ? 'checked' : '' }>
						                            <label for="scoreOpenY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
						                        </div>
						                    </div>
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" id="scoreOpenN" name="scoreOpenYn" value="N" tabindex="0" class="hidden" ${examVo.scoreOpenYn eq 'N' ? 'checked' : '' }>
						                            <label for="scoreOpenN"><spring:message code="exam.common.no" /></label><!-- 아니오 -->
						                        </div>
						                    </div>
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
					                                <input type="radio" id="allViewQstn" name="viewQstnTypeCd" value="ALL" tabindex="0" class="hidden" ${examVo.viewQstnTypeCd eq 'ALL' || empty examVo.examCd ? 'checked' : '' }>
					                                <label for="allViewQstn"><spring:message code="exam.label.all.view.qstn" /></label><!-- 전체문제 표시 -->
					                            </div>
					                        </div>
					                        <div class="field">
					                            <div class="ui radio checkbox">
					                                <input type="radio" id="eachViewQstn" name="viewQstnTypeCd" value="EACH" tabindex="0" class="hidden" ${examVo.viewQstnTypeCd eq 'EACH' ? 'checked' : '' }>
					                                <label for="eachViewQstn"><spring:message code="exam.label.each.view.qstn" /></label><!-- 페이지별로 1문제씩 표시 -->
					                            </div>
					                        </div>
					                    </div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="teamLabel"><spring:message code="exam.label.qstn.random" /></label></dt><!-- 문제 섞기 -->
					                <dd>
					                	<div class="fields">
					                        <div class="inline field">
					                            <div class="ui toggle checkbox">
					                                <input type="checkbox" name="qstnSetTypeCdChk" id="qstnSetTypeCdChk" ${examVo.qstnSetTypeCd eq 'RANDOM' || empty examVo.examCd ? 'checked' : '' }>
						                            <label for="qstnSetTypeCdChk"></label>
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
					                                <input type="checkbox" name="emplRandomYnChk" id="emplRandomYnChk" ${examVo.emplRandomYn eq 'Y' || empty examVo.examCd ? 'checked' : '' }>
						                            <label for="emplRandomYnChk"></label>                                                                
					                            </div>
					                        </div>
					                    </div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="contentTextArea"><spring:message code="exam.label.file" /></label></dt><!-- 첨부파일 -->
					                <dd>
					                	<c:set var="path" value="" />
					                	<c:choose>
					                		<c:when test="${empty examVo.examCd }">
					                    	<c:set var="path" value="/quiz" />
					                		</c:when>
					                		<c:otherwise>
					                    	<c:set var="path" value="/quiz/${examVo.examCd }" />
					                		</c:otherwise>
					                	</c:choose>
					                	<!-- 파일업로더 -->
					                	<div id="uploaderBox"></div>
										<uiex:fileuploader
											uploaderName="fileUploader"
											target="uploaderBox"
											path="${path }"
											limitCount="5"
											limitSize="1024"
											oneLimitSize="1024"
											listSize="3"
											fileList="${fileList}"
											finishFunc="finishUpload"
											useFileBox="true"
										/>
					                </dd>
					            </dl>
					        </li>
					    </ul> 
					</div>
			    </div>
			</form>
            
            <div class="bottom-content">
                <button class="ui blue button" onclick="saveConfirm();"><spring:message code="asmnt.button.save" /></button><!-- 저장 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="filebox.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
        <!-- 이전 토론 가져오기 팝업 -->
		<div class="modal fade" id="quizCopyPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="exam.button.prev.quiz.copy" />" aria-hidden="false">
		    <div class="modal-dialog modal-lg" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
		                    <span aria-hidden="true">&times;</span>
		                </button>
		                <h4 class="modal-title"><spring:message code="exam.button.prev.quiz.copy" /></h4><!-- 이전 퀴즈 가져오기 -->
		            </div>
		            <div class="modal-body">
		                <iframe src="" id="quizCopyIfm" name="quizCopyIfm" width="100%" height="1100px" scrolling="no"></iframe>
		            </div>
		        </div>
		    </div>
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
