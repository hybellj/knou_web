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
				{label:"<spring:message code='resh.label.excel.page.no' />",      			name:'pageNo',             	align:'center',	width:'2000',  	colums:'A'},/* 페이지번호 */
				{label:"<spring:message code='resh.label.excel.page.nm' />",       			name:'pageNm',             	align:'left',	width:'10000', 	colums:'B'},/* 페이지명 */
				{label:"<spring:message code='resh.label.excel.page.cts' />",     			name:'pageCts',             align:'left',	width:'15000',	colums:'C'},/* 페이지내용 */
				{label:"<spring:message code='resh.label.excel.qstn.no' />",       			name:'qstnNo',             	align:'center',	width:'2000',  	colums:'D'},/* 문항번호 */
				{label:"<spring:message code='resh.label.excel.qstn.type' />",        		name:'qstnTypeCd',         	align:'center',	width:'5000',  	colums:'E'},/* 문항유형 */
				{label:"<spring:message code='resh.label.excel.qstn.nm' />",        		name:'qstnNm',              align:'left', 	width:'10000', 	colums:'F'},/* 문항명 */
				{label:"<spring:message code='resh.label.excel.qstn.cts' />",      			name:'qstnCts',            	align:'left', 	width:'15000',	colums:'G'},/* 문항내용 */
				{label:"<spring:message code='resh.label.excel.req.qstn.yn' />",    		name:'reqQstnYn',           align:'center',	width:'5000', 	colums:'H'},/* 필수문항여부 */
				{label:"<spring:message code='resh.label.excel.page.jump.yn' />",   		name:'pageJumpYn',          align:'center',	width:'5000',  	colums:'I'},/* 페이지점프여부 */
				{label:"<spring:message code='resh.label.excel.etc.opinion.qstn.yn' />",	name:'etcOpinionQstnYn',	align:'center',	width:'5000', 	colums:'J'},/* 기타의견입력가능여부 */
				{label:"<spring:message code='resh.label.excel.scale' />",           		name:'scale',              	align:'left', 	width:'15000', 	colums:'K'},/* 척도 */
				{label:"<spring:message code='resh.label.excel.qstn.item.no' />",      		name:'qstnItemNo',         	align:'center',	width:'2000', 	colums:'L'},/* 문항보기번호 */
				{label:"<spring:message code='resh.label.excel.qstn.item.nm' />",       	name:'qstnItemNm',          align:'left',  	width:'10000', 	colums:'M'},/* 문항보기명 */
				{label:"<spring:message code='resh.label.excel.jump.page' />",       		name:'jumpPage',           	align:'center',	width:'5000', 	colums:'N'},/* 점프페이지 */
				{label:"<spring:message code='resh.label.excel.etc.opinion.item.yn' />",    name:'etcOpinionItemYn',  	align:'center',	width:'5000', 	colums:'O'}/* 기타의견여부 */
			]
	    };
		
		// 등록
		function uploadExcelReshQstn(fileObj, copyFile) {
			showLoading();
            $.ajax({
                  type: 'post',
                  url: '/resh/uploadReshQstnExcel.do',
                  async: false,
                  dataType: "json",
                  data: {
                          "reschCd"   	: "${vo.reschCd}"
                        , "uploadFiles" : fileObj
                        , "copyFiles"	: copyFile
                        , "uploadPath"	: "/resh/${vo.reschCd}"
                        , "repoCd"		: "EXCEL_UPLOAD"
                        , "excelGrid" 	: JSON.stringify(excelExampleGrid)
                  },
                  success : function(data) {
                	  hideLoading();
                      if(data.result > 0) {
                          window.parent.listReshPageQstn();
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
			$("#reshQstnUploadForm").attr("target", "exampleExcelDownloadIfm");
	        $("#reshQstnUploadForm").attr("action", "/resh/reshExcelUploadSampleDownload.do");
	        $("#reshQstnUploadForm").submit();
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
	
	<form id="reshQstnUploadForm" name="reshQstnUploadForm" method="POST">
        <input type="hidden" name="reschCd"   value="${vo.reschCd}" />
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
                    <li><i>&middot;</i><span><spring:message code="resh.label.excel.qstn.upload.info" /></span></li><!-- 엑셀 문항 등록시 기존 등록한 문항은 모두 삭제됩니다. -->
                </ul>
        	</div>
        	<button class="ui basic button mb10" onclick="sampleExcelDown()"><spring:message code="resh.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
            <div id="fileUploadBlock">
            	<!-- 파일업로더 -->
				<uiex:dextuploader
					id="fileUploader"
					path="/resh/${vo.reschCd }"
					limitCount="1"
					limitSize="100"
					oneLimitSize="100"
					listSize="2"
					finishFunc="finishUpload()"
					useFileBox="false"
					allowedTypes="xlsx"
				/>
            </div>
        	
            <div class="bottom-content mt50">
                <button class="ui blue button" onclick="saveConfirm()"><spring:message code="resh.button.write" /></button><!-- 등록 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
	<!-- 엑셀 샘플 -->
    <iframe  width="100%" scrolling="no" id="exampleExcelDownloadIfm" name="exampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
