<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function () {
		var parentIframe = window.frameElement;

        if(parentIframe) {
			parentIframe.classList.add('min-height-unset');
			//parentIframe.classList.remove('item');
        } else {
			console.log('Parent iframe not found.');
		}
	});
	
	function fileDown() {
		var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : "${fileVO.fileSn}",
			"repoCd" : '${fileVO.repoCd}'
		};
		
		ajaxCall(url, data, function(data) {
			$("#downloadForm").remove();
			// download용 iframe이 없으면 만든다.
			if ( $("#downloadIfm").length == 0 ) {
				$("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;'></iframe>");
			}
			
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "downloadForm");
			form.attr("id", "downloadForm");
			form.attr("target", "downloadIfm");
			form.attr("action", data);
			form.appendTo("body");
			form.submit();
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
		});
	}
</script>

<body style="display: flex; justify-content: center; align-items: center;">
	<div class='item pt30 pb30 noview'>
		<p class="mr5">
			<spring:message code='asmnt.message.no_view'/>
		</p>
		<p>
			${fileVO.fileNm} (${fileVO.fileSizeStr})
			<button class="ui icon button basic small" title="<spring:message code='asmnt.label.attachFile.download'/>" onclick="fileDown()">
				<i class='ion-android-download'></i>
			</button>
		</p>
	</div>
</body>
</html>