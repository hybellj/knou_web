<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		var excelGrid = {
			colModel:[
			      {label:'<spring:message code="std.label.user_id" />',		align:'left',	width:'4000',	colums:'A'} // 학번
			    , {label:'<spring:message code="std.label.learn_year" />-<spring:message code="common.term" />',	align:'left',	width:'5000',	colums:'B'} // 학습년도-학기
				, {label:'<spring:message code="std.label.pub_yaer" />-<spring:message code="common.term" />',	align:'left',	width:'5000',	colums:'C'} // 게시년도-학기
			    , {label:'<spring:message code="std.label.risk_index" />', 	align:'left',	width:'2500',	colums:'D'} // 위험지수
			    , {label:'<spring:message code="std.label.risk_grade" />', 	align:'left',	width:'2500',	colums:'E'} // 위험등급
			]
		};
		
		// 등록
		function uploadExcel(fileObj) {
			var url = '/std/stdMgr/learnStopRiskIndexExcelUpload.do';
			var data = {
				  uploadFiles   : fileObj
				, uploadPath	: "/std"
				, repoCd		: "EXCEL_UPLOAD"
				, excelGrid		: JSON.stringify(excelGrid)
			}
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
	            	  alert('<spring:message code="success.request.msg" />'); // 요청처리가 성공적으로 수행되었습니다.
	            	  if(typeof window.parent.listPaging === "function") {
	            		  window.parent.listPaging(1);
	            	  }
	                  window.parent.closeModal();
	              } else {
	                  alert(data.message);
	              }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 엑셀 샘플 다운로드
		function sampleExcelDown() {
			$("form[name='excelForm']").remove();
			var excelForm = $('<form></form>');
	        excelForm.attr("name","excelForm");
	        excelForm.attr("action","/std/stdMgr/learnStopRiskIndexSampleExcel.do");
	        excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
	        excelForm.appendTo('body');
	        excelForm.submit();
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
	    			
	    			uploadExcel(fileObj);
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
				path="/std"
				limitCount="1"
				limitSize="1024"
				oneLimitSize="1024"
				listSize="2"
				finishFunc="finishUpload()"
				useFileBox="false"
				allowedTypes="xlsx"
			/>
		</div>
       	
		<div class="bottom-content mt50">
			<button class="ui blue button" onclick="saveConfirm()"><spring:message code="user.button.reg" /></button><!-- 등록 -->
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code='user.button.close' /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>