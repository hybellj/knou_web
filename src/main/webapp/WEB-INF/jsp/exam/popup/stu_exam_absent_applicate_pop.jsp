<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
   	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		// 결시원 신청
		function absentApplicate() {
			if(editor.isEmpty() || editor.getTextContent().trim() === "") {
	 			alert("<spring:message code='exam.alert.absent.reason' />");/* 결시 사유를 입력하세요. */
	 			return false;
	 		} else {
	 			var absentCts = editor.getPublishingHtml();
	 			$("#absentCts").val(absentCts);
	 		}
			
			var fileUploader = dx5.get("fileUploader");
			if(fileUploader.getFileCount() > 0) {
			} else {
				alert("<spring:message code='exam.alert.evidence' />");/* 증빙자료를 첨부하세요. */
				return false;
			}
			
			var formValues = $("form[name=examAbsentForm]").serialize();
			var url  = "/exam/examAbsentApplicate.do";
			var data = formValues;
			console.log("data.result=====>"+data.result);
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.apply.exam.absent.send.prof' />");/* 결시원 신청 완료되어 교수님께 전달되었습니다. */
					
					if(typeof window.parent.absentApplicateCallback === "function") {
						window.parent.absentApplicateCallback();
						return;
					}
					
					window.parent.listExamAbsent(1);
					if("${vo.searchMenu}" != "") {
						window.parent.selectExam("${vo.searchMenu}");
					}
					window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.apply' />");/* 신청 중 에러가 발생하였습니다. */
			});
		}
		
		// 저장 확인
	    function saveConfirm() {
			// 신청 후에는 수정 불가하오니 내용을 잘 확인하시기 바랍니다.\n(단. 교수 반려 시 내용을 보완하여 재신청 가능)\n신청하시겠습니까?
			var msg = '<spring:message code="exam.label.exam.absent.save.guide1" />';
			msg += '\n' + '<spring:message code="exam.label.exam.absent.save.guide2" />';
			msg += '\n' + '<spring:message code="exam.label.exam.absent.save.guide3" />';
			
	    	if(!confirm(msg)) {
				return;
			}
	    	
	    	// 파일이 있으면 업로드 시작
	    	var fileUploader = dx5.get("fileUploader");
	 		if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			}
			else {
				// 저장 호출
				absentApplicate();
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
	    	 		$("#uploadPath").val("/exam/${vo.examCd}");
	    			
	    	 		absentApplicate();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	 <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
       	<form name="examAbsentForm" id="examAbsentForm" method="POST">
       		<input type="hidden" name="examCd" 		value="${vo.examCd }" />
       		<input type="hidden" name="crsCreCd" 	value="${creCrsVO.crsCreCd }" />
       		<input type="hidden" name="stdNo" 		value="${stdVO.stdNo }" />
       		<input type="hidden" name="absentTitle" value="결시원 신청" />
       		<input type="hidden" name="repoCd"		value="EXAM_SAMPLE" />
       		<input type="hidden" name="absentCts" 	value=""					   id="absentCts" />
       		<input type="hidden" name="uploadFiles" value="" 					   id="uploadFiles"/>
       		<input type="hidden" name="copyFiles"	value=""					   id="copyFiles" />
       		<input type="hidden" name="uploadPath"	value=""					   id="uploadPath" />
       	</form>
       	<c:if test="${not empty midSysJobSchVO}">
       		<fmt:parseDate var="midSchStartDtFmt" pattern="yyyyMMddHHmmss" value="${midSysJobSchVO.schStartDt }" />
			<fmt:formatDate var="midSchStartDt" pattern="yyyy.MM.dd HH:mm" value="${midSchStartDtFmt }" />
	    	<fmt:parseDate var="midSchEndDtFmt" pattern="yyyyMMddHHmmss" value="${midSysJobSchVO.schEndDt }" />
			<fmt:formatDate var="midSchEndDt" pattern="yyyy.MM.dd HH:mm" value="${midSchEndDtFmt }" />
       	<div class="tc bcLYellow p10">
       		<b><spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate" /><spring:message code="exam.label.period" /> (<spring:message code="exam.label.mid.exam" /><!-- 중간고사 -->) : ${midSchStartDt} ~ ${midSchEndDt}</b>
       	</div>
       	</c:if>
       	<c:if test="${not empty lastSysJobSchVO}">
       		<fmt:parseDate var="lastSchStartDtFmt" pattern="yyyyMMddHHmmss" value="${lastSysJobSchVO.schStartDt }" />
			<fmt:formatDate var="lastSchStartDt" pattern="yyyy.MM.dd HH:mm" value="${lastSchStartDtFmt }" />
	    	<fmt:parseDate var="lastSchEndDtFmt" pattern="yyyyMMddHHmmss" value="${lastSysJobSchVO.schEndDt }" />
			<fmt:formatDate var="lastSchEndDt" pattern="yyyy.MM.dd HH:mm" value="${lastSchEndDtFmt }" />
       	<div class="tc bcLYellow p10">
       		<b><spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate" /><spring:message code="exam.label.period" /> (<spring:message code="exam.label.end.exam" /><!-- 기말고사 -->) : ${lastSchStartDt} ~ ${lastSchEndDt}</b>
       	</div>
       	</c:if>
       	<h3 class="sec_head"> <spring:message code="exam.label.absent" /><!-- 결시원 --> <spring:message code="exam.label.applicate" /><!-- 신청 --></h3>
       	<ul class="sixteen wide field tbl dt-sm mb20">
       		<li>
       			<%-- <dl>
       				<dt><spring:message code="exam.label.open" /><!-- 개설 --><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
       				<dd>${creCrsVO.deptNm }</dd>
       				<dt><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></dt>
       				<dd>${creCrsVO.crsCd }</dd>
       			</dl> --%>
       			<dl>
       				<dt><spring:message code="exam.label.subject.nm" /><!-- 교과명 --></dt>
       				<dd>${creCrsVO.crsCreNm }</dd>
       				<dt><spring:message code="crs.label.decls" /><!-- 분반 --></dt>
       				<dd>${creCrsVO.declsNo }<spring:message code="exam.label.decls" /><!-- 반 --></dd>
       			</dl>
       			<dl>
       				<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
					<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
       				<dt><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.stare.type" /><!-- 구분 --></dt>
       				<dd>${vo.examStareTypeNm }</dd>
       				<dt><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.dttm" /><!-- 잃시 --></dt>
       				<dd>${examStartDttm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.tch" /><!-- 교수 --><spring:message code="exam.label.nm" /><!-- 명 --></dt>
       				<dd>${vo.tchNm }</dd>
       				<dt><spring:message code="exam.label.tutor" /><!-- 튜터 --><spring:message code="exam.label.nm" /><!-- 명 --></dt>
       				<dd>${vo.tutorNm }</dd>
       			</dl>
       		</li>
       	</ul>
       	<ul class="sixteen wide field tbl dt-sm">
       		<li>
       			<dl>
       				<dt><spring:message code="exam.label.user.no" /><!-- 학번 --></dt>
       				<dd>${stdVO.userId }</dd>
       				<dt><spring:message code="exam.label.user.nm" /><!-- 이름 --></dt>
       				<dd>${stdVO.userNm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
       				<dd>${stdVO.deptNm }</dd>
       				<dt><spring:message code="exam.label.mobile.no" /><!-- 연락처 --></dt>
       				<dd>${stdVO.mobileNo }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.absent.reason" /><!-- 결시 사유 --></dt>
       				<dd style="height:200px">
       					<div style="height:100%">
							<textarea name="contentTextArea" id="contentTextArea"></textarea>
							<script>
						       // html 에디터 생성
						    	var editor = HtmlEditor('contentTextArea', THEME_MODE, '/exam/${vo.examCd }');
						    </script>
						</div>
       				</dd>
       			</dl>
       			<dl>
       				<dt class="req"><spring:message code="exam.label.evidence" /><!-- 증빙자료 --><spring:message code="exam.label.attatch" /><!-- 첨부 --></dt>
       				<dd>
       					<!-- 파일업로더 -->
       					<uiex:dextuploader
							id="fileUploader"
							path="/exam/${vo.examCd }"
							limitCount="5"
							limitSize="100"
							oneLimitSize="100"
							listSize="3"
							fileList="${fileList}"
							finishFunc="finishUpload()"
							allowedTypes="*"
						/>
						<span class="fcRed"><spring:message code="exam.label.evidence.example.info" /></span><!-- 예 : 진단서, 입원확인서, 출장확인서, 훈련통지서 등 -->
       				</dd>
       			</dl>
       		</li>
       	</ul>
       	<p class="f110 mt10"><spring:message code="exam.label.absent.msg" /></p><!-- 이상의 결시사유를 담당 과목 교수님께 보고 드립니다. -->
       	<div class="option-content">
       		<div class="mla w250">
        		<div class="ui fields f110 mt10">
					<div class="d-inline-block field p_w30"><spring:message code="exam.label.applicate" /><spring:message code="exam.label.day" /> : </div><!-- 신청 --><!-- 일 -->
					<div class="d-inline-block field p_w60">${fn:split(date,'-')[0]}<spring:message code="exam.label.year" /> ${fn:split(date,'-')[1]}<spring:message code="exam.label.month" /> ${fn:split(date,'-')[2]}<spring:message code="exam.label.day" /></div><!-- 년 --><!-- 월 --><!-- 일 -->
				</div>
        		<div class="ui fields f110 mt10">
        			<div class="d-inline-block field p_w30"><spring:message code="exam.label.applicant" /> : </div><!-- 신청자 -->
        			<div class="d-inline-block field p_w40">${stdVO.userNm }</div>
        		</div>
       		</div>
       	</div>
       	<p class="f110 mt10">* <spring:message code="exam.label.absent.warning.title.msg" /></p><!-- 결시원 작성시 주의사항 -->
       	<p class="p5">- <spring:message code="exam.label.absent.warning.msg1" /></p><!-- 결시사유 발생 : 정해진 일시에 시험에 응시하지 못하는 사유가 발행했을 경우 결시원 작성/제출합니다. -->
       	<p class="p5">- <spring:message code="exam.label.absent.warning.msg2" /></p><!-- 결시원 승인여부 확인 및 코멘트 확인 : 각 과목 강의실로 이동하여 해당 과목의 대처 방안(대체과제유무 등)을 반드시 확인하여 응시하여야 성적을 부여 받을 수 있습니다. -->
       	<p class="p5">- <spring:message code="exam.label.absent.warning.msg3" /></p><!-- 결시원 제출기간 준수해야 합니다. -->
           
           <div class="bottom-content mt50">
               <button class="ui blue button" onclick="saveConfirm()"><spring:message code="exam.label.applicate" /></button><!-- 신청 -->
               <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
           </div>
       </div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
