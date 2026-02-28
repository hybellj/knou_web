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
    	$(document).ready(function() {
    		examDateSet();
    	});
    	
    	var checkOption = {
    		// 체크 여부 확인
    		isChecked: function(value, id) {
    			if($("#"+value).is(":checked")) {
        			$("#"+id).val("Y");
        		} else {
        			$("#"+id).val("N");
        		}
    		},
    		// value trigger click single
    		checkValueTriggerSingle: function(value, checkValue, id) {
    			if (value == checkValue) {
    				$('#'+id).trigger("click");
    			}
    		},
    		// value trigger click multi
    		checkValueTriggerMulti: function(value, checkValue, idY, idN) {
    			if(value == checkValue) {
	    			$("#"+idY).trigger("click");
	    		} else {
	    			$("#"+idN).trigger("click");
	    		}
    		},
    		// value prop checked
    		checkValueProp: function(value, checkValue, name) {
    			if(value == checkValue) {
    				$("input[name="+name+"]").prop("checked", true);
    			} else {
    				$("input[name="+name+"]").prop("checked", false);
    			}
    		}
    	};
    	
    	// 이전 토론 가져오기
    	function forumCopyList() {
    		$("#forumCopyForm > input[name='crsCreCd']").val("${creCrsVO.crsCreCd }");
    		$("#forumCopyForm").attr("target", "forumCopyIfm");
    	    $("#forumCopyForm").attr("action", "/forum/forumLect/Form/forumCopyPop.do");
    	    $("#forumCopyForm").submit();
    	    $('#forumCopyPop').modal('show');
    	}
    	
    	// 토론 가져오기
    	function copyForum(forumCd) {
    		var url  = "/forum/forumLect/Form/forumCopy.do";
    		var data = {
    			"forumCd" : forumCd
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
    	    		var forumVO = data.returnVO;
    	    		// 가져온 파일 리스트
            		$("#searchTo").val(forumVO.forumCd);
            		var fileSns = new Set();
            		if(fileUploader.limitCount < forumVO.fileList.length) {
            			/* 최대 가능 개수를 넘어 파일 가져오기가 취소되었습니다. */
            			alert("<spring:message code='exam.alert.max.file.limit.cancel' />");
            		} else {
            			$(".old-file").remove();
            			forumVO.fileList.forEach(function(v, i) {
    	        			fileUploader.addOldFile(v.fileId, v.fileNm, v.fileSize);
    			        	fileSns.add(v.fileSn);
    	        		});
    	        		$("#fileSns").val(Array.from(fileSns));
            		}
            		$("#uploadPath").val("/forum/${forumVo.forumCd}");
    	    		
    	    		// 토론명
    	    		$("#forumTitle").val(forumVO.forumTitle);
    	    		// 토론 내용
    	    		$("button.se-clickable[name=new]").trigger("click"); // 에디터 새문서
    	    		editor.insertHTML(forumVO.forumArtl);
    	    		// 평가 방법
    	    		checkOption.checkValueTriggerMulti(forumVO.evalCtgr, "R", "evalCtgr2", "evalCtgr1");
    	    		// 첨부파일
    				// console.log("fileList : javascript에서 어떻게???")
    				// 성적 반영 여부
    				checkOption.checkValueTriggerMulti(forumVO.scoreAplyYn, "Y", "scoreAplyY", "scoreAplyN");
    	    		// 성적 공개 여부
    	    		checkOption.checkValueTriggerMulti(forumVO.scoreOpenYn, "Y", "scoreOpenY", "scoreOpenN");
    	    		$('.modal').modal('hide'); // 모달창 닫기
    	        } else {
    	         	alert(data.message);
    	        }
    		}, function(xhr, status, error) {
    			/* 가져오기 중 에러가 발생하였습니다. */
    			alert("<spring:message code='exam.error.copy' />");
    		});
    	}
    	
    	//토론 등록
    	function addForum() {
    		if(!nullCheck()) {
    			return false;
    		}
    		setValue();
    		
    		showLoading();
    		var url = "";
    		if(${empty forumVo.forumCd}) {
    			url = "/exam/addForum.do";
    		} else {
    			url = "/exam/editForum.do";
    		}
        	
    		$.ajax({
                url 	 : url,
                async	 : false,
                type 	 : "POST",
                dataType : "json",
                data 	 : $("#forumWriteForm").serialize(),
            }).done(function(data) {
            	hideLoading();
            	if (data.result > 0) {
            		var startDttm = $("#forumStartFmt").val().replaceAll(".","") + "" + pad($("#forumStartHH option:selected").val(),2) + "" + pad($("#forumStartMM option:selected").val(),2);
            		var endDttm   = $("#forumEndFmt").val().replaceAll(".","") + "" + pad($("#forumEndHH option:selected").val(),2) + "" + pad($("#forumEndMM option:selected").val(),2);
            		
            		var forumVO = data.returnVO;
            		/* 분류명을 입력하세요. */
            		alert("<spring:message code='exam.alert.insert' />");
            		window.parent.complateWriteType("FORUM", forumVO.forumCd, forumVO.forumTitle, startDttm, endDttm);
            		window.parent.closeModal();
                } else {
                 	alert(data.message);
                }
            }).fail(function() {
            	hideLoading();
            	/* 저장 중 에러가 발생하였습니다. */
            	alert("<spring:message code='exam.error.insert' />");
            });
    	}
    	
    	// 빈 값 체크
    	function nullCheck() {
    		<spring:message code='forum.label.forum.date' var='forumPeriod'/> // 토론기간
    		
    		if($.trim($("#forumTitle").val()) == "") {
    			/* 제목을 입력하세요. */
    			alert("<spring:message code='exam.alert.input.title' />");
    			return false;
    		}
    		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
    			/* 내용을 입력하세요. */
    			alert("<spring:message code='exam.alert.input.contents' />");
    			return false;
    		}
    		if($("#forumStartFmt").val() == "") {
    			alert("<spring:message code='common.alert.input.eval_start_date' arguments='${forumPeriod}'/>"); //. 토론 시작일을 입력하세요.
    			$("#forumStartFmt").focus();
    			return false;
    		}
    		if($("#forumStartHH option:selected").val() == " ") {
    			alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${forumPeriod}'/>"); //. 토론 시작시간을 입력하세요.
    			$("#forumStartHH").parent().focus();
    			return false;
    		}
    		if($("#forumStartMM option:selected").val() == " ") {
    			alert("<spring:message code='common.alert.input.eval_start_min' arguments='${forumPeriod}'/>"); //. 토론 시작분을 입력하세요.
    			$("#forumStartMM").parent().focus();
    			return false;
    		}
    		if($("#forumEndFmt").val() == "") {
    			alert("<spring:message code='common.alert.input.eval_end_date' arguments='${forumPeriod}'/>"); // 토론 종료일을 입력하세요.
    			$("#forumEndFmt").focus();
    			return false;
    		}
    		if($("#forumEndHH option:selected").val() == " ") {
    			alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${forumPeriod}'/>"); //. 토론 종료시간을 입력하세요.
    			$("#endHour").parent().focus();
    			return false;
    		}
    		if($("#forumEndMM option:selected").val() == " ") {
    			alert("<spring:message code='common.alert.input.eval_end_min' arguments='${forumPeriod}'/>"); //. 토론 종료분을 입력하세요.
    			$("#endMin").parent().focus();
    			return false;
    		}
    		if ( ($("#forumStartDttm").val()+$("#startHour").val()+$("#startMin").val()) >
	    		($("#forumEndDttm").val()+$("#endHour").val()+$("#endMin").val()) ) {
	    		alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='${forumPeriod}'/>"); // 종료일시를 시작일시 이후로 입력하세요.
	    		return false;
	    	}
    		if($("input[name=evalCtgr]:checked").length == 0) {
    			/* 평가 방법을 선택하세요. */
    			alert("<spring:message code='exam.alert.select.eval.ctgr' />");
    			return false;
    		}
    		return true;
    	}

    	// 값 채우기
    	function setValue() {
    		var forumContents = editor.getPublishingHtml();
    		$("#forumArtl").val(forumContents);
    		
    		if ($("#forumStartFmt").val() != null && $("#forumStartFmt").val() != "") {
    			$("#forumStartDttm").val($("#forumStartFmt").val().replaceAll(".","") + "" + pad($("#forumStartHH option:selected").val(),2) + "" + pad($("#forumStartMM option:selected").val(),2) + "00");
    		}
    		
    		if ($("#forumEndFmt").val() != null && $("#forumEndFmt").val() != "") {
    			$("#forumEndDttm").val($("#forumEndFmt").val().replaceAll(".","") + "" + pad($("#forumEndHH option:selected").val(),2) + "" + pad($("#forumEndMM option:selected").val(),2) + "00");
    		}
    	}
    	
    	// 저장 확인
        function saveConfirm() {
        	// 파일이 있으면 업로드 시작
     		if (fileUploader.getFileCount() > 0) {
    			fileUploader.startUpload();
    		} else {
    			// 저장 호출
    			addForum();
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
	         		$("#uploadPath").val("/forum/${forumVo.forumCd}");
	        		
	         		addForum();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
        }
     	
     	// 시험 날짜 세팅
	    function examDateSet() {
	    	if("${dateVO.startDate}" != "") $("#forumStartFmt").val("${dateVO.startDate}");
	    	if("${dateVO.startHH}" != "") $("#forumStartHH option[value=${dateVO.startHH}]").prop("selected", true).trigger("change");
	    	if("${dateVO.startMM}" != "") $("#forumStartMM option[value=${dateVO.startMM}]").prop("selected", true).trigger("change");
	    	if("${dateVO.endDate}" != "") $("#forumEndFmt").val("${dateVO.endDate}");
	    	if("${dateVO.endHH}" != "") $("#forumEndHH option[value=${dateVO.endHH}]").prop("selected", true).trigger("change");
	    	if("${dateVO.endMM}" != "") $("#forumEndMM option[value=${dateVO.endMM}]").prop("selected", true).trigger("change");
	    }
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content mb20">
        		<div class="mla">
        			<a href="javascript:forumCopyList()" class="ui blue button"><spring:message code="forum.button.copy" /></a><!-- 이전 토론 가져오기 -->
        			<form id="forumCopyForm" name="forumCopyForm" action="" method="POST">
						<input type="hidden" name="crsCreCd" value="" />
					</form>
        		</div>
        	</div>
        	<form name="forumWriteForm" id="forumWriteForm" method="POST" autocomplete="off">
        		<input type="hidden" name="crsCreCd" 		   value="${creCrsVO.crsCreCd }" />
        		<input type="hidden" name="forumCd"			   value="${forumVo.forumCd }" />
	            <input type="hidden" name="scoreRatio" 		   value="${empty evo.examCd ? '0' : evo.scoreRatio }" />
	            <input type="hidden" name="forumCtgrCd"		   value="${examTypeCd eq 'EXAM' ? 'SUBS' : 'EXAM' }" />
	            <input type="hidden" name="repoCd"			   value="FORUM" />
	            <input type="hidden" name="aplyAsnYn"		   value="N" />
	            <input type="hidden" name="prosConsForumCfg"   value="N" />
	            <input type="hidden" name="prosConsRateOpenYn" value="N" />
	            <input type="hidden" name="regOpenYn" 		   value="N" />
	            <input type="hidden" name="multiAtclYn"		   value="N" />
	            <input type="hidden" name="prosConsModYn"	   value="N" />
	            <input type="hidden" name="mutEvalYn"		   value="N" />
	            <input type="hidden" name="teamForumCfgYn"	   value="N" id="teamForumCfgYn" />
	            <input type="hidden" name="teamCtgrCd"		   value="" id="teamCtgrCd" />
	            <input type="hidden" name="forumStartDttm"	   value="" id="forumStartDttm" />
	            <input type="hidden" name="forumEndDttm"	   value="" id="forumEndDttm" />
	            <input type="hidden" name="forumArtl" 		   value="" id="forumArtl" />
	            <input type="hidden" name="evalCd"			   value="" id="evalCd" />
	            <input type="hidden" name="uploadFiles"		   value="" id="uploadFiles" />
	            <input type="hidden" name="copyFiles"		   value="" id="copyFiles" />
	            <input type="hidden" name="uploadPath"		   value="" id="uploadPath" />
	            <input type="hidden" name="searchTo"		   value="" id="searchTo" />
	            <input type="hidden" name="fileSns"			   value="" id="fileSns" />
	            <div class="ui form" id="examWriteForumDiv">
					<div class="ui segment">
					    <ul class="tbl border-top-grey">
					        <li>
					            <dl>
					                <dt><label for="forumTitle" class="req"><spring:message code="forum.label.forum.title" /></label></dt><!-- 토론명 -->
					                <dd>
					                    <div class="ui fluid input">
					                        <input type="text" name="forumTitle" id="forumTitle" value="${forumVo.forumTitle }">
					                    </div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="contentTextArea" class="req"><spring:message code="forum.label.forum.content" /></label></dt><!-- 토론내용 -->
					                <dd style="height:400px">
	            						<div style="height:100%">
					                		<textarea name="contentTextArea" id="contentTextArea">${forumVo.forumArtl }</textarea>
					                		<script>
						                        // html 에디터 생성
					                   	  		var editor = HtmlEditor('contentTextArea', THEME_MODE, '/forum');
						                   	</script>
					                	</div>
									</dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="forumStartFmt" class="req"><spring:message code="forum.label.forum.date" /></label></dt><!-- 토론기간 -->
					                <dd>
					                	<div class="fields gap4">
	                                        <div class="field flex">
	                                           <!-- 시작일시 -->
	                                           <uiex:ui-calendar dateId="forumStartFmt" hourId="forumStartHH" minId="forumStartMM" rangeType="start" rangeTarget="forumEndFmt" value="${evo.examStartDttm}"/>
	                                        </div>
	                                        <div class="field p0 flex-item desktop-elem">~</div>
	                                        <div class="field flex">
	                                       	   <!-- 종료일시 -->
	                                           <uiex:ui-calendar dateId="forumEndFmt" hourId="forumEndHH" minId="forumEndMM" rangeType="end" rangeTarget="forumStartFmt" value="${evo.examEndDttm}"/>
	                                        </div>
	                                    </div>
					                </dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					            	<dt><label class="req"><spring:message code="forum.label.scoreAplyYn" /></label></dt><!-- 성적 반영 -->
					            	<dd>
					            		<div class="fields">
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" name="scoreAplyYn" id="scoreAplyY" value="Y" tabindex="0" class="hidden" ${empty forumVo.forumCd || forumVo.scoreAplyYn eq 'Y' ? 'checked' : '' }>
						                            <label for="scoreAplyY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
						                        </div>
						                    </div>
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" name="scoreAplyYn" id="scoreAplyN" value="N" tabindex="0" class="hidden" ${forumVo.scoreAplyYn eq 'N' ? 'checked' : '' }>
						                            <label for="scoreAplyN"><spring:message code="exam.common.no" /></label><!-- 아니요 -->
						                        </div>
						                    </div>
						                </div>
					            	</dd>
					            </dl>
					        </li>
					        <li>
					            <dl>
					            	<dt><label class="req"><spring:message code="forum.label.scoreOpen" /></label></dt><!-- 성적 공개 -->
					            	<dd>
					            		<div class="fields">
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" name="scoreOpenYn" id="scoreOpenY" value="Y" tabindex="0" class="hidden" ${empty forumVo.forumCd || forumVo.scoreOpenYn eq 'Y' ? 'checked' : '' }>
						                            <label for="scoreOpenY"><spring:message code="exam.common.yes" /></label><!-- 예 -->
						                        </div>
						                    </div>
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" name="scoreOpenYn" id="scoreOpenN" value="N" tabindex="0" class="hidden" ${forumVo.scoreOpenYn eq 'N' ? 'checked' : '' }>
						                            <label for="scoreOpenN"><spring:message code="exam.common.no" /></label><!-- 아니요 -->
						                        </div>
						                    </div>
						                </div>
					            	</dd>
					            </dl>
					        </li>
					        <li>
					        	<dl>
					        		<dt><label class="req"><spring:message code="resh.label.eval.ctgr" /></label></dt><!-- 평가 방법 -->
					        		<dd>
					        			<div class="fields">
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" name="evalCtgr" id="evalCtgr1" value="P" tabindex="0" class="hidden" ${forumVo.evalCtgr eq 'P' || empty forumVo.evalCtgr ? 'checked' : '' }>
						                            <label for="evalCtgr1"><spring:message code="resh.label.eval.ctgr.score" /></label><!-- 점수형 -->
						                        </div>
						                    </div>
						                    <div class="field">
						                        <div class="ui radio checkbox">
						                            <input type="radio" name="evalCtgr" id="evalCtgr2" value="R" tabindex="0" class="hidden" ${forumVo.evalCtgr eq 'R' ? 'checked' : '' }>
						                            <label for="evalCtgr2"><spring:message code="resh.label.eval.ctgr.join" /></label><!-- 참여형 -->
						                        </div>
						                    </div>
						                </div>
					        		</dd>
					        	</dl>
					        </li>
					        <li>
					            <dl>
					                <dt><label for="contentTextArea"><spring:message code="asmnt.label.file.upload" /></label></dt><!-- 파일 업로드 -->
					                <dd>
					                	<c:set var="path" value="" />
						                <c:choose>
						                	<c:when test="${empty forumVo.forumCd }">
						                 	<c:set var="path" value="/forum" />
						                	</c:when>
						                	<c:otherwise>
						                 	<c:set var="path" value="/forum/${forumVo.forumCd }" />
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
										fileList="${forumVo.fileList}"
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
                <button class="ui blue button" onclick="saveConfirm()"><spring:message code="exam.button.save" /></button>
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button>
            </div>
        </div>
        <!-- 이전 토론 가져오기 팝업 -->
		<div class="modal fade" id="forumCopyPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="forum.button.copy" />" aria-hidden="false"><!-- 이전 토론 가져오기 -->
		    <div class="modal-dialog modal-lg" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="resh.button.close" />"><!-- 닫기 -->
		                    <span aria-hidden="true">&times;</span>
		                </button>
		                <h4 class="modal-title"><spring:message code="forum.button.copy" /></h4><!-- 이전 토론 가져오기 -->
		            </div>
		            <div class="modal-body">
		                <iframe src="" id="forumCopyIfm" name="forumCopyIfm" width="100%" height="1100px" scrolling="no"></iframe>
		            </div>
		        </div>
		    </div>
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
