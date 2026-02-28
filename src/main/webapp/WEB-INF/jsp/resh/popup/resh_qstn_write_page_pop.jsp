<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 페이지 저장
		function writeReshPage(type) {
			var urlMap = {
				"insert" : "/resh/writeReshPage.do",
				"update" : "/resh/editReshPage.do"
			};
			
			var url  = urlMap[type];
			var data = {
				"reschCd" 	     : "${vo.reschCd}",
				"reschPageCd"    : "${pageVO.reschPageCd}",
				"reschPageTitle" : $("#reschPageTitle").val(),
				"reschPageArtl"  : editor.getPublishingHtml(),
				"reschPageOdr"   : "${pageVO.reschPageOdr}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		window.parent.listReshPageQstn();
	        		window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			if(type == "insert") {
	    			alert("<spring:message code='resh.error.page.insert' />");/* 설문 페이지 추가 중 에러가 발생하였습니다. */
    			} else if(type == "update") {
	    			alert("<spring:message code='resh.error.page.update' />");/* 설문 페이지 수정 중 에러가 발생하였습니다. */
    			}
    		});
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
		    <div class="ui form tc">
		       	<div class="p_w80" style="margin:auto;">
					<input type="text" id="reschPageTitle" placeholder="<spring:message code='resh.label.page.title' /> <spring:message code='resh.label.input' />" value="${pageVO.reschPageTitle }" /><!-- 페이지 제목 --><!-- 입력 -->
					<div style="height:400px">
						<div style="height:100%" class="mt15 tl">
				        	<textarea name="reschPageContents" id="reschPageContents">${pageVO.reschPageArtl }</textarea>
				        	<script>
						        // html 에디터 생성
						      	var editor = HtmlEditor('reschPageContents', THEME_MODE, '/resh/${vo.reschCd }');
					    	</script>
				        </div>
					</div>
		       	</div>
		    </div>
	        
            <div class="bottom-content mt50">
            	<c:choose>
            		<c:when test="${empty pageVO }">
		                <button class="ui blue button allBtn" onclick="writeReshPage('insert')"><spring:message code="resh.button.save" /></button><!-- 저장 -->
            		</c:when>
            		<c:otherwise>
		                <button class="ui blue button allBtn" onclick="writeReshPage('update')"><spring:message code="resh.button.modify" /></button><!-- 수정 -->
            		</c:otherwise>
            	</c:choose>
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
