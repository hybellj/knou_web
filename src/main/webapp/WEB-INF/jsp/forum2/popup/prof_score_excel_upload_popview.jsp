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
		
		var nomalExcelGrid = {
			colModel:[
				{label:'No.',   name:'lineNo',     align:'center', width:'1000'  ,colums:'A'},
				{label:'<spring:message code="forum.label.user_id"/>',	name:'userId',	align:'left',	width:'5000'	,colums:'B'},/*학번*/
				{label:'<spring:message code="forum.label.user_nm"/>',   name:'userNm',     align:'left',   width:'5000'  ,colums:'C'},/*이름*/
				{label:'<spring:message code="forum.label.eval.score"/>',	name:'scr',	align:'right',	width:'5000'	,colums:'D'}/*평가점수*/
			]
		};	

		var teamExcelGrid = {
			colModel:[
				{label:'No.',   name:'lineNo',     align:'center', width:'1000'  ,colums:'A'},
				{label:'<spring:message code='forum.label.team.name'/>',   name:'teamnm',   align:'left',   width:'5000'    ,colums:'B'},/*팀명*/
				{label:'<spring:message code="forum.label.user_id"/>'	,	name:'userId',	align:'left',	width:'5000'	,colums:'C'},/*학번*/
				{label:'<spring:message code="forum.label.user_nm"/>',   name:'userNm',     align:'left',  width:'5000'   ,colums:'D'},/*이름*/
				{label:'<spring:message code='forum.label.role'/>',   name:'memberRole',     align:'left',   width:'5000' ,colums:'E'},/*역할*/
				{label:'<spring:message code="forum.label.eval.score"/>',	name:'scr',	align:'right',	width:'5000'	,colums:'F'},/*평가점수*/
			]
		};	
		
		// 등록
		function uploadDscsScoreExcel(fileObj, copyFile) {
			var excelGrid = "";
			if("${dscsVO.dscsUnitTycd}" == "TEAM") {
				excelGrid = JSON.stringify(teamExcelGrid);
			} else {
				excelGrid = JSON.stringify(nomalExcelGrid);
			}
			
			var url = "/forum2/forumLect/uploadDscsScoreExcel.do";
			var data = {
				"dscsId"    	  : "${dscsVO.dscsId}"
				, "sbjctId" : "${dscsVO.sbjctId}"
				, "dscsUnitTycd" : "${dscsVO.dscsUnitTycd}"
				, "uploadFiles"   : fileObj
				// , "copyFiles"	  : copyFile
				, "uploadPath"	  : "/forum/${dscsVO.dscsId}"
				, "repoCd"		  : "EXCEL_UPLOAD"
				, "excelGrid" 	  : excelGrid
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					UiComm.showMessage("<spring:message code='forum.common.excel.score.insert' />", "success"); // 성적 처리가 완료되었습니다.
					window.parent.listForumUser(1);
					window.parent.closeDialog();
				} else {
					UiComm.showMessage(data.message, "error");
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error");// 오류가 발생했습니다!
			}, true);
		}
		
		// 엑셀 샘플 다운로드
		function sampleExcelDown() {
			if("${dscsVO.dscsUnitTycd}" == "TEAM") {
		        $("#excelGrid").val(JSON.stringify(teamExcelGrid));
			} else {
				$("#excelGrid").val(JSON.stringify(nomalExcelGrid));
			}
			$("#dscsScoreUploadForm").attr("target", "dscsSampleExcelDownloadIfm");
			$("#dscsScoreUploadForm").attr("action", "/forum2/forumLect/forumScoreSampleDownload.do");
			$("#dscsScoreUploadForm").submit();
		}
		
		// 저장 확인
		function saveConfirm() {
			/*var fileUploader = dx5.get("fileUploader");
			// 파일이 있으면 업로드 시작
			if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			}*/
			UiValidator("dscsScoreUploadForm")
			.then(function(result) {
				if (result) {
					let dx = dx5.get("fileUploader");
					// 첨부파일 있으면 업로드
					if (dx.availUpload()) {
						dx.startUpload();
					}
					// 첨부파일 없으면 저장 호출
					else {
						UiComm.showMessage("<spring:message code='forum.alert.input.file.upload'/>", "info");/*등록된 파일이없습니다. 파일을 등록해주세요.*/
					}
				}
			});
		}

		// 파일 업로드 완료
		function finishUpload() {
			/*var fileUploader = dx5.get("fileUploader");
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

	    			uploadDscsScoreExcel(fileObj, copyFile);
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});*/
			let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
			let dx = dx5.get("fileUploader");
			let data = {
				"uploadFiles" : dx.getUploadFiles(),
				"uploadPath"  : dx.getUploadPath()
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					// $("#uploadFiles").val(dx.getUploadFiles());
					var fileObj = dx.getUploadFiles();

					uploadDscsScoreExcel(fileObj);
				} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
			});
		}
	</script>
	
	<form id="dscsScoreUploadForm" name="dscsScoreUploadForm" method="POST">
        <input type="hidden" name="dscsId" value="${dscsVO.dscsId}" />
        <input type="hidden" name="sbjctId" value="${dscsVO.sbjctId}"/>
        <input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}"/>
        <input type="hidden" name="excelGrid" value="" id="excelGrid"/>
		<%-- 26.3.23 : New upload file 처리 field 추가 --%>
		<input type="hidden" name="uploadFiles" id="uploadFiles" value="" />
		<input type="hidden" name="uploadPath" id="uploadPath" value="${dscsVO.uploadPath}" />
		<input type="hidden" name="delFileIdStr" id="delFileIdStr" value="" />
    </form>

	<body class="modal-page ${uiex:getTheme()}">
        <div id="wrap">
        	<div class="msg-box">
				<p class="txt"><strong><spring:message code="common.excel.upload.warning.title.msg" /></strong></p><!-- 주의사항 -->
				<ul class="list-dot">
                    <li><spring:message code="forum.common.excel.upload.warning.msg1" /></li><!-- 엑셀 파일만 업로드 해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다. -->
                    <li><spring:message code="forum.common.excel.upload.warning.msg2" /></li><!-- 잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다. -->
                    <li><spring:message code="forum.common.excel.upload.warning.msg3" /></li><!-- 샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요. -->
                    <li><spring:message code="forum.common.excel.upload.warning.msg4" /></li><!-- 자료를 작성하실 때 항목은 빈 란으로 두지 마세요. -->
                </ul>
        	</div>
			<div class="board_top">
        	    <button type="button" class="btn basic" onclick="sampleExcelDown()"><spring:message code="forum.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
            </div>
            <div id="fileUploadBlock">
            	<!-- 파일업로더 -->
            	<uiex:dextuploader
					id="fileUploader"
					path="/forum/${dscsVO.dscsId}"
					limitCount="1"
					limitSize="100"
					oneLimitSize="100"
					listSize="1"
					finishFunc="finishUpload()"
					allowedTypes="xlsx"
					uiMode="simple"
				/>
            </div>
        	
            <div class="btns">
                <button class="btn type1" onclick="saveConfirm()"><spring:message code="forum.button.reg" /></button><!-- 등록 -->
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="forum.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
	<!-- 엑셀 샘플 -->
    <iframe  width="100%" scrolling="no" id="dscsSampleExcelDownloadIfm" name="dscsSampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
