<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="admin"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			zoomUserSync();
		});

		// ZOOM사용자동기화
		function zoomUserSync() {
			// 사용계정이메일 우측 icon
			let icon = "<i class='xi-check right-area fcBlue xi-x'></i>";
			$("#authrtEml").append(icon);

			const url   = "/smnr/pltfrm/admZoomUserSyncAjax.do";
			const param = {
				orgId	: "${vo.orgId}"
			};

			ajaxCall(url, param, function(data) {
				const now = new Date();

				const formatted = now.getFullYear()
				  + String(now.getMonth() + 1).padStart(2, '0')
				  + String(now.getDate()).padStart(2, '0')
				  + String(now.getHours()).padStart(2, '0')
				  + String(now.getMinutes()).padStart(2, '0')
				  + String(now.getSeconds()).padStart(2, '0');

				let html  = "<div class='border-1 padding-3 bcLgrey'>";
					html += 	UiComm.formatDate(formatted, "datetime2")
					html += "</div>";
					html += "<div>";
				if (data.result >= 0) {
					$("#syncTxt").append("<i class='xi-radiobox-blank right-area fcBlue xi-x'></i>");
					html += "<p>ZOOM 사용계정을 연동합니다.</p>";
					if(data.result == 0) html += "<p>ZOOM 라이센스 목록이 없습니다.</p>";
			    } else {
					$("#syncTxt").append("<i class='xi-close right-area fcRed xi-x'></i>");
					html += "<p>ZOOM 사용계정 연동에 실패하였습니다.</p>";
			    }
					html += "</div>";
				$("#syncDiv").empty().html(html);
			}, function(xhr, status, error) {
				$("#syncTxt").append("<i class='xi-close right-area fcRed xi-x'></i>");
				$("#syncDiv").empty().html("ZOOM 사용계정 연동에 실패하였습니다.");
			}, true);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top">
        		<p class="width-25per border-1 padding-3 flex" id="authrtEml">${onlnPltfrmAuthrtList[0].authrtEml }</p>
        		<p class="flex-1 border-1 padding-3 flex" id="syncTxt">ZOOM 사용계정을 연동합니다.</p>
        	</div>

        	<div id="syncDiv" class="border-1 padding-3 flex gap-3"></div>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
