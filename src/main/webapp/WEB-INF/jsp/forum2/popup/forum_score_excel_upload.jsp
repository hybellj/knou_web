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
				{label:'학번'	,	name:'userId',	align:'left',	width:'5000'	,colums:'B'},
				{label:'이름',   name:'userNm',     align:'left',   width:'5000'  ,colums:'C'},
				{label:'평가점수',	name:'score',	align:'right',	width:'5000'	,colums:'D'}
			]
		};	

		var teamExcelGrid = {
			colModel:[
				{label:'No.',   name:'lineNo',     align:'center', width:'1000'  ,colums:'A'},
				{label:'팀명',   name:'teamNm',   align:'left',   width:'5000'    ,colums:'B'},
				{label:'학번'	,	name:'userId',	align:'left',	width:'5000'	,colums:'C'},
				{label:'이름',   name:'userNm',     align:'left',  width:'5000'   ,colums:'D'},
				{label:'역할',   name:'memberRole',     align:'left',   width:'5000' ,colums:'E'},
				{label:'평가점수',	name:'score',	align:'right',	width:'5000'	,colums:'F'},
			]
		};	
		
		// 등록
		function uploadExcelForum(fileObj, copyFile) {
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
					alert("<spring:message code='forum.common.excel.score.insert' />"); // 성적 처리가 완료되었습니다.
					window.parent.listForumUser(1);
					window.parent.closeDialog();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />");// 오류가 발생했습니다!
			}, true);
		}
		
		// 엑셀 샘플 다운로드
		function sampleExcelDown() {
			if("${dscsVO.dscsUnitTycd}" == "TEAM") {
		        $("#excelGrid").val(JSON.stringify(teamExcelGrid));
			} else {
				$("#excelGrid").val(JSON.stringify(nomalExcelGrid));
			}
			$("#forumUploadForm").attr("target", "forumpleExcelDownloadIfm");
			$("#forumUploadForm").attr("action", "/forum2/forumLect/forumScoreSampleDownload.do");
			$("#forumUploadForm").submit();
		}
		
		// 저장 확인
		function saveConfirm() {
			/*var fileUploader = dx5.get("fileUploader");
			// 파일이 있으면 업로드 시작
			if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			}*/
			UiValidator("forumUploadForm")
			.then(function(result) {
				if (result) {
					let dx = dx5.get("fileUploader");
					// 첨부파일 있으면 업로드
					if (dx.availUpload()) {
						dx.startUpload();
					}
					// 첨부파일 없으면 저장 호출
					else {
						alert("파일을 먼저 선택해 주세요");
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

	    			uploadExcelForum(fileObj, copyFile);
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

					uploadExcelForum(fileObj);
				} else {
					alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
			});
		}
	</script>
	
	<form id="forumUploadForm" name="forumUploadForm" method="POST">
        <input type="hidden" name="dscsId" value="${dscsVO.dscsId}" />
        <input type="hidden" name="sbjctId" value="${dscsVO.sbjctId}"/>
        <input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}"/>
        <input type="hidden" name="excelGrid" value="" id="excelGrid"/>
		<%-- 26.3.23 : New upload file 처리 field 추가 --%>
		<input type="hidden" name="uploadFiles" id="uploadFiles" value="" />
		<input type="hidden" name="uploadPath" id="uploadPath" value="${dscsVO.uploadPath}" />
		<input type="hidden" name="delFileIdStr" id="delFileIdStr" value="" />
    </form>

	<body class="modal-page">
        <div id="wrap">
        	<div class="fcBlue">
        		<p><spring:message code="common.excel.upload.warning.title.msg" /></p><!-- 주의사항 -->
        		<ul class="notice_list">
                    <li><i>&middot;</i><span><spring:message code="forum.common.excel.upload.warning.msg1" /></span></li><!-- xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다. -->
                    <li><i>&middot;</i><span><spring:message code="forum.common.excel.upload.warning.msg2" /></span></li><!-- 잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다. -->
                    <li><i>&middot;</i><span><spring:message code="forum.common.excel.upload.warning.msg3" /></span></li><!-- 샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요. -->
                    <li><i>&middot;</i><span><spring:message code="forum.common.excel.upload.warning.msg4" /></span></li><!-- 자료를 작성하실 때 항목은 빈란으로 두지 마세요. -->
                </ul>
        	</div>
            <div class="left-btn">
        	    <button class="btn basic small w180" onclick="sampleExcelDown()"><spring:message code="forum.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
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
    <iframe  width="100%" scrolling="no" id="forumpleExcelDownloadIfm" name="forumpleExcelDownloadIfm" style="display: none;"></iframe>
</html>
