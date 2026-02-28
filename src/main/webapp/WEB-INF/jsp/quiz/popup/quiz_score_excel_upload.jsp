<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		var excelExampleGrid = {
			colModel:[
					{label:"<spring:message code='exam.label.dept' />",			name:'deptNm',		align:'left',	width:'5000',	colums:'A'},/* 학과 */
					{label:"<spring:message code='exam.label.user.no' />",		name:'userId',		align:'left',	width:'5000',	colums:'B'},/* 학번 */
					{label:"<spring:message code='exam.label.user.nm' />",		name:'userNm',		align:'left',	width:'5000',	colums:'C'},/* 이름 */
	                {label:"<spring:message code='exam.label.eval.score' />",	name:'stareScore',	align:'right',	width:'5000',	colums:'D'}/* 평가점수 */
				]
		};
		
		// 등록
		function uploadExcelReshQstn(fileObj, copyFile) {
			showLoading();
            $.ajax({
                  type: 'post',
                  url: '/quiz/uploadQuizScoreExcel.do',
                  async: false,
                  dataType: "json",
                  data: {
                          "examCd"    	  : "${vo.examCd}"
                        , "scoreType" 	  : "each"
                        , "uploadFiles"   : fileObj
                        , "copyFiles"	  : copyFile
                        , "uploadPath"	  : "/quiz/${vo.examCd}"
                        , "repoCd"		  : "EXAM_SAMPLE"
                        , "excelGrid" 	  : JSON.stringify(excelExampleGrid)
                  },
                  success : function(data) {
                	  hideLoading();
                      if(data.result > 0) {
                          window.parent.listExamUser(1);
                          window.parent.closeModal();
                      } else {
                          alert(data.message);
                      }
                  }
            });
		}
		
		// 엑셀 샘플 다운로드
		function sampleExcelDown() {
	        $("#excelGrid").val(JSON.stringify(excelExampleGrid));
			$("#quizQstnUploadForm").attr("target", "exampleExcelDownloadIfm");
	        $("#quizQstnUploadForm").attr("action", "/quiz/quizScoreSampleDownload.do");
	        $("#quizQstnUploadForm").submit();
		}
		
		// 저장 확인
	    function saveConfirm() {
	    	var fileUploader = dx5.get("fileUploader");
	    	// 파일이 있으면 업로드 시작
	 		if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
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
	    			var fileObj = fileUploader.getUploadFiles();
	    	    	var copyFile = fileUploader.getCopyFiles();

	    	 		uploadExcelReshQstn(fileObj, copyFile);
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
	</script>
	
	<form id="quizQstnUploadForm" name="quizQstnUploadForm" method="POST">
        <input type="hidden" name="examCd"    value="${vo.examCd}" />
        <input type="hidden" name="excelGrid" value=""				id="excelGrid"/>
    </form>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="ui info message">
        		<p><spring:message code="common.excel.upload.warning.title.msg" /></p><!-- 주의사항 -->
        		<ul class="notice_list">
                    <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg1" /></span></li><!-- xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다. -->
                    <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg2" /></span></li><!-- 잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다. -->
                    <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg3" /></span></li><!-- 샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요. -->
                    <li><i>&middot;</i><span><spring:message code="common.excel.upload.warning.msg4" /></span></li><!-- 자료를 작성하실 때 항목은 빈란으로 두지 마세요. -->
                </ul>
        	</div>
        	<button class="ui basic button mb10" onclick="sampleExcelDown()"><spring:message code="exam.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
            <div id="fileUploadBlock">
            	<!-- 파일업로더 -->
            	<uiex:dextuploader
					id="fileUploader"
					path="/quiz/${vo.examCd}"
					limitCount="1"
					limitSize="100"
					oneLimitSize="100"
					listSize="2"
					finishFunc="finishUpload()"
					useFileBox="false"
					allowedTypes="xlsx"
					bigSize="false"
				/>
            </div>
        	
            <div class="bottom-content mt50">
                <button class="ui blue button" onclick="saveConfirm()"><spring:message code="exam.button.reg" /></button><!-- 등록 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
	<!-- 엑셀 샘플 -->
    <iframe  width="100%" scrolling="no" id="exampleExcelDownloadIfm" name="exampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
