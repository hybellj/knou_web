<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>

   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		
		});
	   	
	 	// 출석처리 사유 수정
	   	function editAttendReason() {
	   		var crsCreCd = '<c:out value="${vo.crsCreCd}" />';
   			var stdNo = '<c:out value="${vo.stdNo}" />';
   			var lessonScheduleId = '<c:out value="${vo.lessonScheduleId}" />';
   			
   			$("#editForm input[name='crsCreCd']").val(crsCreCd);
			$("#editForm input[name='stdNo']").val(stdNo);
			$("#editForm input[name='lessonScheduleId']").val(lessonScheduleId);
			$("#editForm input[name='uploadFiles']").val("");
			$("#editForm input[name='copyFiles']").val("");
			$("#editForm input[name='uploadPath']").val("");
			
	   		// 파일이 있으면 업로드 시작
   			var fileUploader = dx5.get("fileUploader");
   			$("input[name='delFileIdStr']").val(fileUploader.getDelFileIdStr()); // 삭제파일 Id
   			if (fileUploader.getFileCount() > 0) {
   				fileUploader.startUpload();
   			} else {
   				edit();
   			}
	   	}
	 	
	 	function edit() {
	 		var url = "/lesson/lessonLect/editAttendReason.do";
			var data = $("#editForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="success.common.update" />'); // 정상적으로 수정되었습니다.
					
					reload();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	 	}
	 	
	   	function finishUpload(){
			var fileUploader = dx5.get("fileUploader");
			var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			$("#editForm input[name='uploadFiles']").val(fileUploader.getUploadFiles());
	    			$("#editForm input[name='copyFiles']").val(fileUploader.getCopyFiles());
	    			$("#editForm input[name='uploadPath']").val(fileUploader.getUploadPath());
	    		   	
	    			edit();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
		}
	   	
	 	// 다운로드
		function fileDown(fileSn, repoCd) {
			var url  = "/common/fileInfoView.do";
			var data = {
				"fileSn" : fileSn,
				"repoCd" : repoCd
			};
			
			ajaxCall(url, data, function(data) {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "downloadForm");
				form.attr("id", "downloadForm");
				form.attr("target", "downloadIfm");
				form.attr("action", data);
				form.appendTo("body");
				form.submit();
				
				$("#downloadForm").remove();
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
	 	
		function reload() {
	 		var url = "/lesson/lessonPop/stdyStateMemoPop.do";
	 		
	 		var form = $("<form></form>");
	 		form.attr("method", "POST");
	 		form.attr("name", "moveform");
	 		form.attr("action", url);
	 		form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${vo.crsCreCd}" />'}));
	 		form.append($('<input/>', {type: 'hidden', name: "lessonScheduleId", value: '<c:out value="${vo.lessonScheduleId}" />'}));
	 		form.append($('<input/>', {type: 'hidden', name: "stdNo", value: '<c:out value="${vo.stdNo}" />'}));
	 		form.appendTo("body");
	 		form.submit();
	 		
	 		$("form[name='moveform']").remove();
	 	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div class="ui form">
	        <div id="attendMemo" class="ui">
	        	<form id="editForm" name="editForm">
	        		<input type="hidden" name="crsCreCd" />
					<input type="hidden" name="stdNo" />
					<input type="hidden" name="lessonScheduleId" />
					<input type="hidden" name="uploadPath" />
					<input type="hidden" name="uploadFiles" />
					<input type="hidden" name="copyFiles" />
					<input type="hidden" name="delFileIdStr" />
					<div>
						<div class="fcWhite bcBlue p10">
							<spring:message code="lesson.label.attend.reason" /><!-- 출석처리 사유 -->
						</div>
						<textarea id="attendReason" name="attendReason" rows="4" cols="40" placeholder="<spring:message code="lesson.label.memo" />"><c:out value="${lessonStudyStateVO.attendReason}"/></textarea>
						<c:if test="${fileList.size() > 0}">
							<div class="ui segment">
								<ul>
								<c:forEach items="${fileList}" var="row">
									<li class="opacity7 file-txt">
										<a href="javascript:void(0)" class="btn border0 p5" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd}" />')">
											<i class="xi-download mr3"></i><c:out value="${row.fileNm}" /> (<c:out value="${row.fileSizeStr}" />)
										</a>
									</li>
								</c:forEach>
								</ul>
							</div>
						</c:if>
						<div class="mt5">
							<uiex:dextuploader
								id="fileUploader"
								path="/attend/${vo.crsCreCd}/${vo.lessonScheduleId}/${stdVO.userId}"
								limitCount="10"
								limitSize="100"
								oneLimitSize="100"
								listSize="2"
								fileList="${fileList}"
								finishFunc="finishUpload()"
								useFileBox="false"
								allowedTypes="*"
								uiMode="simple"
							/>
						</div>
				     </div>
			     </form>
			 </div>
		</div>
		<div class="bottom-content">
			<button type="button" class="ui blue button" onclick="editAttendReason()"><spring:message code="common.button.edit" /><!-- 수정하기 --></button>
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="downloadIfm"></iframe>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>