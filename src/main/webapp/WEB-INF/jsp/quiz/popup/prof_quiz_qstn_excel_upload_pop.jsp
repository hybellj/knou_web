<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="fileuploader"/>
	</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
		});

		var excelExampleGrid = {
			colModel:[
				    {label:"<spring:message code='exam.label.qstn.no' />",				name:'qstnNo',					align:'left',	width:'5000',	colums:'A'},/* 문제번호 */
				    {label:"<spring:message code='exam.label.sub.qstn.no' />",			name:'subNo',					align:'left',	width:'5000',	colums:'B'},/* 후보문제 번호 */
				    {label:"<spring:message code='exam.label.qstn.cts' />",				name:'qstnCts',					align:'left',	width:'5000',	colums:'C'},/* 문제 내용 */
				    {label:"<spring:message code='exam.label.qstn.gbn' />",				name:'qstnTypeCd',				align:'left',	width:'5000',	colums:'D'},/* 문제 구분 */
				    {label:"<spring:message code='exam.label.qstn.item' />1",			name:'empl1',					align:'left',	width:'5000',	colums:'E'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />2",			name:'empl2',					align:'left',	width:'5000',	colums:'F'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />3",			name:'empl3',					align:'left',	width:'5000',	colums:'G'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />4",			name:'empl4',					align:'left',	width:'5000',	colums:'H'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />5",			name:'empl5',					align:'left',	width:'5000',	colums:'I'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />6",			name:'empl6',					align:'left',	width:'5000',	colums:'J'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />7",			name:'empl7',					align:'left',	width:'5000',	colums:'K'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />8",			name:'empl8',					align:'left',	width:'5000',	colums:'L'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />9",			name:'empl9',					align:'left',	width:'5000',	colums:'M'},/* 보기 */
				    {label:"<spring:message code='exam.label.qstn.item' />10",			name:'empl10',					align:'left',	width:'5000',	colums:'N'},/* 보기 */
				    {label:"<spring:message code='exam.label.answer' />1",				name:'rgtAnsr1',				align:'left',	width:'5000',	colums:'O'},/* 정답1 */
				    {label:"<spring:message code='exam.label.answer' />2",				name:'rgtAnsr2',				align:'left',	width:'5000',	colums:'P'},/* 정답2 */
				    {label:"<spring:message code='exam.label.answer' />3",				name:'rgtAnsr3',				align:'left',	width:'5000',	colums:'Q'},/* 정답3 */
				    {label:"<spring:message code='exam.label.answer' />4",				name:'rgtAnsr4',				align:'left',	width:'5000',	colums:'R'},/* 정답4 */
				    {label:"<spring:message code='exam.label.answer' />5",				name:'rgtAnsr5',				align:'left',	width:'5000',	colums:'S'},/* 정답5 */
				    {label:"<spring:message code='exam.label.answer.comment' />",		name:'qstnExpl',				align:'left',	width:'5000',	colums:'T'},/* 정답해설 */
				    {label:"<spring:message code='exam.label.score' />",				name:'qstnScore',				align:'left',	width:'5000',	colums:'U'},/* 점수 */
					{label:"<spring:message code='exam.label.multi.answer.yn' />",		name:'multiRgtChoiceYn',		align:'left',	width:'5000',	colums:'V'},/* 복수정답여부 */
					{label:"<spring:message code='exam.label.multi.answer.type' />",	name:'multiRgtChoiceTypeCd',	align:'right',	width:'5000',	colums:'W'}/* 복수정답타입 */
				]
		};

		// 등록
		function uploadExcelQuizQstn(fileObj, copyFile) {
			showLoading();
            $.ajax({
                  type: 'post',
                  url: '/quiz/uploadQuizQstnExcel.do',
                  async: false,
                  dataType: "json",
                  data: {
                          "examDtlId"     : "${vo.examDtlId}"
                        , "uploadFiles"   : fileObj
                        , "copyFiles"	  : copyFile
                        , "uploadPath"	  : "/quiz/${vo.examDtlId}"
                        , "repoCd"		  : "EXCEL_UPLOAD"
                        , "excelGrid" 	  : JSON.stringify(excelExampleGrid)
                  },
                  success : function(data) {
                	  hideLoading();
                      if(data.result > 0) {
                          window.parent.listQuizQstn();
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
	        $("#quizQstnUploadForm").attr("action", "/quiz/quizExcelUploadSampleDownload.do");
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

	    	 		uploadExcelQuizQstn(fileObj, copyFile);
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
	</script>

	<form id="quizQstnUploadForm" name="quizQstnUploadForm" method="POST">
        <input type="hidden" name="examDtlId"	value="${vo.examDtlId}" />
        <input type="hidden" name="excelGrid" 	value=""				id="excelGrid"/>
    </form>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box basic">
        		<p><spring:message code="common.excel.upload.warning.title.msg" /><!-- 주의사항 --></p>
                <ul class="list-dot">
                    <li><span><spring:message code="common.excel.upload.warning.msg1" /><!-- xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다. --></span></li>
                    <li><span><spring:message code="common.excel.upload.warning.msg2" /><!-- 잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다. --></span></li>
                    <li><span><spring:message code="common.excel.upload.warning.msg3" /><!-- 샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요. --></span></li>
                    <li><span><spring:message code="common.excel.upload.warning.msg4" /><!-- 자료를 작성하실 때 항목은 빈란으로 두지 마세요. --></span></li>
                    <li><span><spring:message code="exam.label.qstn.excel.upload" /><!-- 엑셀 문항 등록시 기존 등록한 문항은 모두 삭제됩니다. --></span</li>
                </ul>
            </div>
            <div class="board_top">
	        	<button class="btn type2 right-area" onclick="sampleExcelDown()"><spring:message code="exam.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
            </div>
            <div id="fileUploadBlock">
            	<!-- 파일업로더 -->
            	<uiex:dextuploader
					id="fileUploader"
					path="/quiz/${vo.examDtlId }"
					limitCount="1"
					limitSize="100"
					oneLimitSize="100"
					listSize="3"
					finishFunc="finishUpload()"
					allowedTypes="xlsx"
				/>
            </div>

            <div class="btns">
                <button class="btn type1" onclick="saveConfirm()"><spring:message code="exam.button.reg" /></button><!-- 등록 -->
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>

	<!-- 엑셀 샘플 -->
    <iframe  width="100%" scrolling="no" id="exampleExcelDownloadIfm" name="exampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
