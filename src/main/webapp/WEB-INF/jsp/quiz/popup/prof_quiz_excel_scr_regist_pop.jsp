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
				{label:"<spring:message code='exam.label.dept' />",			name:'deptnm',	align:'left',	width:'5000',	colums:'A'},/* 학과 */
				{label:"<spring:message code='exam.label.user.no' />",		name:'userId',	align:'left',	width:'5000',	colums:'B'},/* 학번 */
				{label:"<spring:message code='exam.label.user.nm' />",		name:'usernm',	align:'left',	width:'5000',	colums:'C'},/* 이름 */
	            {label:"<spring:message code='exam.label.eval.score' />",	name:'totScr',	align:'right',	width:'5000',	colums:'D'}/* 총점수 */
			]
		};

		// 등록
		function quizScrExcelUpload() {
			UiComm.showLoading(true);
			let dx = dx5.get("fileUploader");

            $.ajax({
            	url: '/quiz/profQuizScrExcelUpload.do',
                async: false,
                type: 'POST',
                dataType: "json",
                data: {
                	  "examBscId"   : "${vo.examBscId}"
                    , "uploadFiles"	: dx.getUploadFiles()
            		, "uploadPath"  : dx.getUploadPath()
                    , "excelGrid" 	: JSON.stringify(excelExampleGrid)
                },
                contentType: "application/json; charset=UTF-8",
            }).done(function(data) {
		   		UiComm.showLoading(false);
		    	if (data.result > 0) {
		    		window.parent.quizTkexamListSelect();
                    window.parent.closeDialog();
		        } else {
		       		UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
			   	UiComm.showLoading(false);
			   	UiComm.showMessage("에러가 발생하였습니다.", "error");
		    });
		}

		// 엑셀 샘플 다운로드
		function sampleExcelDown() {
	        $("#excelGrid").val(JSON.stringify(excelExampleGrid));
			$("#quizScrRegistForm").attr("target", "exampleExcelDownloadIfm");
	        $("#quizScrRegistForm").attr("action", "/quiz/profQuizScrRegistSampleExcelDown.do");
	        $("#quizScrRegistForm").submit();
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
			let url = "/common/uploadFileCheck.do";	// 업로드된 파일 검증 URL
			let dx = dx5.get("fileUploader");
			let data = {
				"uploadFiles" : dx.getUploadFiles(),
				"uploadPath"  : dx.getUploadPath()
			};

			// 업로드된 파일 체크
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					quizScrExcelUpload();
				} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");	// 업로드를 실패하였습니다.
				}
			},
				function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");	// 업로드를 실패하였습니다.
			});
	    }
	</script>

	<form id="quizScrRegistForm" name="quizScrRegistForm" method="POST">
        <input type="hidden" name="examBscId"   value="${vo.examBscId}" />
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
        		</ul>
        	</div>
        	<div class="board_top">
	        	<button class="btn type2 right-area" onclick="sampleExcelDown()"><spring:message code="exam.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
            </div>
            <div id="fileUploadBlock">
            	<!-- 파일업로더 -->
            	<uiex:dextuploader
					id="fileUploader"
					path="/exam/${vo.examBscId }"
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
