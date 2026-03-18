<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="editor"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
		});

		// 설문지저장
		function srvypprSave() {
			var url  = "/srvy/srvypprRegistAjax.do";
			var data = $("#srvypprFrm").serialize();

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		window.parent.srvypprQstnListSelect();
	        		window.parent.closeDialog();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("설문지 저장 중 에러가 발생하였습니다.", "error");
    		}, true);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<form id="srvypprFrm" onsubmit="return false;">
        		<input type="hidden" name="srvypprId"	value="${vo.srvypprId }" />
        		<input type="hidden" name="srvyId" 		value="${vo.srvyId }" />
        		<input type="text" class="width-100per" name="srvyTtl" inputmask="byte" maxLen="1000" placeholder="페이지 제목 입력" value="${vo.srvyTtl }">
				<div class="editor-box margin-top-4">
					<%-- HTML 에디터 --%>
					<uiex:htmlEditor
						id="srvyCts"
						name="srvyCts"
						uploadPath="${vo.uploadPath}"
						value="${vo.srvyCts}"
						height="300px"
						required="true"
					/>
				</div>
        	</form>

			<div class="btns">
				<button type="button" class="btn type2" onclick="srvypprSave()">${empty vo.srvypprId ? '추가' : '수정' }</button>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
