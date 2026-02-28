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
        
        // 저장
        function saveFile() {
        	var dx = dx5.get("upload1");
        	
        	// 파일이 있으면 업로드 시작
			if (dx.availUpload()) {
				dx.startUpload();
			}
			else {
				// 업로드할 파일이 존재하지 않습니다.
                alert('<spring:message code="filebox.alert.no.file" />');
                return;
			}
        }
        
        // 파일 업로드 완료
        function finishUpload() {
        	var dx = dx5.get("upload1");
        	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : dx.getUploadFiles(),
	    		"copyFiles"   : dx.getCopyFiles(),
	    		"uploadPath"  : dx.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			// 파일박스 업로드 정보 저장
	                saveFileBoxInfo();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
        }
        
        // 파일박스 업로드 정보 저장
        function saveFileBoxInfo() {
        	var dx = dx5.get("upload1");
            var url = "/file/fileHome/addFileToFileBox.do";
            var data = {
                  parFileBoxCd  : '<c:out value="${vo.parFileBoxCd}" />'
                , uploadFiles   : dx.getUploadFiles()
                , uploadPath    : dx.getUploadPath()
            };
            
            ajaxCall(url, data, function(data) {
                if(data.result > 0) {
                    // 성공적으로 작업을 완료하였습니다.
                    alert('<spring:message code="common.result.success" />');
                    
                    if(typeof window.parent.fileBoxUploadCallBack === "function") {
                        window.parent.fileBoxUploadCallBack();
                    }
                } else {
                    alert(data.message);
                }
                
                window.parent.closeModal();
            }, function(xhr, status, error) {
                // 에러가 발생했습니다!
                alert('<spring:message code="fail.common.msg" />');
                window.parent.closeModal();
            });
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
    <div id="loading_page">
        <p><i class="notched circle loading icon"></i></p>
    </div>
    <div id="wrap">
        <div class="ui form">
			<uiex:dextuploader
				id="upload1"
				path="/filebox/${userId}"
				limitCount="10"
				limitSize="${limitSize}"
				oneLimitSize="${limitSize}"
				listSize="5"
				fileList="${fileList}"
				finishFunc="finishUpload()"
				allowedTypes="*"
				bigSize="true"
			/>
        </div>
        <div class="bottom-content">
            <button class="ui blue cancel button" onclick="saveFile()"><spring:message code="filebox.button.reg" /><!-- 등록 --></button>
            <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="filebox.button.close" /><!-- 닫기 --></button>
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>