<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="/*position: fixed;*/ width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
   	<!-- 게시판 공통 -->
	<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
	   	$(document).ready(function() {
		});
	   	
	 	// 저장
	   	function writeQna() {
	   		if(!nullCheck()) {
	   			return false;
	   		}
	   		
	   		var url = "/bbs/${templateUrl}/addAtcl.do";
	    	
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data     : $("#atclWriteForm").serialize(),
	        }).done(function(data) {
	        	if (data.result > 0) {
	        		alert("<spring:message code='bbs.alert.success_save' />");/* 정상적으로 저장되었습니다. */
	        		window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
	        });
	   	}
	   	
	   	// 빈 값 체크
	   	function nullCheck() {
	   		if($.trim($("#atclWriteForm input[name=atclTitle]").val()) == "") {
	   			alert("<spring:message code='bbs.alert.empty_title' />");/* 제목은 필수 항목입니다. 다시 확인 바랍니다. */
	   			return false;
	   		}
	   		
	   		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
	 			alert("<spring:message code='bbs.alert.empty_content' />");/* 내용은 필수 항목입니다. 다시 확인 바랍니다. */
	 			return false;
	 		}
	   		
	   		return true;
	   	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<form id="atclWriteForm" method="POST">
			<input type="hidden" name="crsCreCd" value="${vo.crsCreCd }" />
			<input type="hidden" name="bbsId"	value="${bbsInfoVO.bbsId }" />
			<div class="ui form">
				<ul class="tbl-simple">
					<li>
						<dl>
							<dt class="p_w10"><label class="req"><spring:message code="lesson.label.title" /><!-- 제목 --></label></dt>
							<dd><input type="text" name="atclTitle" placeholder="<spring:message code='lesson.label.title.input' />" /></dd><!-- 제목 입력 -->
						</dl>
					</li>
					<li>
						<dl>
							<dd style="height:<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "250px" : "350px")%>">
								<div style="height:100%">
									<textarea name="atclCts" id="atclCts"></textarea>
									<script>
								       	// html 에디터 생성
								  	  	var editor = HtmlEditor('atclCts', THEME_MODE, "/bbs/${bbsInfoVO.bbsId}");
								       	var weekStr = ('<spring:message code="lesson.label.schedule"/>' || "").toLowerCase();
								       	var html = '<spring:message code="lesson.label.schedule"/> : ${lessonVO.lessonScheduleOrder} ' + weekStr + '<br><spring:message code="lesson.label.cnts.nm"/> : ${lessonVO.lessonCntsNm}<br>------------------------------------------------------------------<br><br>';
								       	editor.insertHTML(html);
								  	</script>
								</div>
							</dd>
						</dl>
					</li>
				</ul>
			</div>
		</form>
		<div class="bottom-content tc">
			<button class="ui blue button w100" type="button" onclick="writeQna();"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<button class="ui basic button w100" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>