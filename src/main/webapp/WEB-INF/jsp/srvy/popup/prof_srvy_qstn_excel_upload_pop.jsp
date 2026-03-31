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
				{label:"페이지순번",      	name:'srvySeqno',           align:'center',	width:'2000',  	colums:'A'},
				{label:"페이지명",       	name:'srvyTtl',             align:'left',	width:'10000', 	colums:'B'},
				{label:"페이지내용",     	name:'srvyCts',             align:'left',	width:'15000',	colums:'C'},
				{label:"문항순번",       	name:'qstnSeqno',           align:'center',	width:'2000',  	colums:'D'},
				{label:"문항답변유형코드",	name:'qstnRspnsTycd',       align:'center',	width:'5000',  	colums:'E'},
				{label:"문항명",        	name:'qstnTtl',             align:'left', 	width:'10000', 	colums:'F'},
				{label:"문항내용",      	name:'qstnCts',            	align:'left', 	width:'15000',	colums:'G'},
				{label:"필수답변여부",    	name:'esntlRspnsyn',		align:'center',	width:'5000', 	colums:'H'},
				{label:"페이지점프여부",   	name:'srvyMvmnUseyn',       align:'center',	width:'5000',  	colums:'I'},
				{label:"기타입력사용여부",	name:'etcInptUseyn',		align:'center',	width:'5000', 	colums:'J'},
				{label:"레벨",           	name:'lvl',              	align:'left', 	width:'15000', 	colums:'K'},
				{label:"보기항목순번",		name:'vwitmSeqno',         	align:'center',	width:'2000', 	colums:'L'},
				{label:"보기항목내용",     	name:'vwitmCts',          	align:'left',  	width:'10000', 	colums:'M'},
				{label:"점프페이지",      	name:'mvmnSrvyQstnId',      align:'center',	width:'5000', 	colums:'N'},
				{label:"기타입력여부",     	name:'etcInptyn',  			align:'center',	width:'5000', 	colums:'O'}
			]
		};

		// 등록
		function srvyQstnExcelUpload() {
			UiComm.showLoading(true);
			let dx = dx5.get("fileUploader");

			$.ajax({
            	url: '/srvy/profSrvyQstnExcelUpload.do',
                async: false,
                type: 'POST',
                dataType: "json",
                data: {
                	  "srvyId"   	: "${vo.srvyId}"
                    , "uploadFiles"	: dx.getUploadFiles()
            		, "uploadPath"  : dx.getUploadPath()
                    , "excelGrid" 	: JSON.stringify(excelExampleGrid)
                }
            }).done(function(data) {
		   		UiComm.showLoading(false);
		    	if (data.result > 0) {
		    		window.parent.srvypprQstnListSelect();
                    window.parent.closeDialog();
		        } else {
		       		UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
			   	UiComm.showLoading(false);
			   	UiComm.showMessage("에러가 발생하였습니다.", "error");
		    });
		}

		// 엑셀샘플다운로드
		function sampleExcelDown() {
	        $("#excelGrid").val(JSON.stringify(excelExampleGrid));
			$("#srvyQstnUploadForm").attr("target", "exampleExcelDownloadIfm");
	        $("#srvyQstnUploadForm").attr("action", "/srvy/profSrvyQstnRegistSampleExcelDown.do");
	        $("#srvyQstnUploadForm").submit();
		}

		// 저장 확인
	    function saveConfirm() {
	    	let dx = dx5.get("fileUploader");
			// 첨부파일 있으면 업로드
    		if (dx.availUpload()) {
    			dx.startUpload();
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
					srvyQstnExcelUpload();
				} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");	// 업로드를 실패하였습니다.
				}
			},
				function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");	// 업로드를 실패하였습니다.
			});
	    }
	</script>

	<form id="srvyQstnUploadForm" name="srvyQstnUploadForm" method="POST">
        <input type="hidden" name="srvyId"		value="${vo.srvyId}" />
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
                    <li><span><spring:message code="resh.label.excel.qstn.upload.info" /><!-- 엑셀 문항 등록시 기존 등록한 문항은 모두 삭제됩니다. --></span</li>
                </ul>
            </div>
            <div class="board_top">
	        	<button class="btn type2 right-area" onclick="sampleExcelDown()"><spring:message code="exam.button.excel.sample.down" /></button><!-- 엑셀 샘플 다운로드 -->
            </div>
            <div id="fileUploadBlock">
            	<!-- 파일업로더 -->
            	<uiex:dextuploader
					id="fileUploader"
					path="${vo.uploadPath}"
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
