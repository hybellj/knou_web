<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<style type="text/css">
	</style>
	<script type="text/javascript">
		$(document).ready(function() {
			termLinkMgrResultList(1);
		});
		
		// 학사 연동 결과 목록
		function termLinkMgrResultList(page) {
			var url  = "/crs/termLinkMgr/termLinkMgrResultListPaging.do";
			var data = {
				"pageIndex"   : page,
				"listScale"   : 5
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var classNm 	= v.linkSucYn == "Y" ? "" : "bcRed fcWhite";
	        				var labelNm 	= v.linkSucYn == "Y" ? "" : "bcRed fcWhite";
	        				var iNm			= v.linkSucYn == "Y" ? "ion-checkmark-round" : "ion-close-round";
	        				var atclRegDttm = v.linkDttm.substring(0, 4) + '.' + v.linkDttm.substring(4, 6) + '.' + v.linkDttm.substring(6, 8) + '(' + v.linkDttm.substring(8, 10) + ':' + v.linkDttm.substring(10, 12) + ":" + v.linkDttm.substring(12, 14) + ")";
	        				var linkSucYn	= v.linkSucYn == "Y" ? "<spring:message code='crs.termlink.result.suc' />"/* [성공] */ : "<spring:message code='crs.termlink.result.fal' />";/* [실패] */
	        				html += "<div class='ui segment option-content "+classNm+"'>";
	        				html += "	<span class='ui label "+labelNm+"'>" + atclRegDttm + "</span>";
	        				html += "	<span>" + linkSucYn + v.linkRsltCts + "</span>";
	        				html += "	<small class='mla'><i class='f150 "+iNm+"'></i></small>";
	        				html += "</div>";
	        			});
	        		}
	        		
	        		$("#termLinkMgrList").empty().html(html);
			    	var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.recordCountPerPage,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "termLinkMgrResultList"
				    };
				    
				    gfn_renderPaging(params);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<c:if test="${vo.searchMenu eq 'POP' }">
	        	<div class="option-content">
	        		<div class="mla">
	        			<a href="javascript:history.back()" class="ui green button"><spring:message code="crs.button.termlink.result.back" /></a><!-- 돌아가기 -->
	        		</div>
	        	</div>
        	</c:if>
        	<div class="ui segments link-list" id="termLinkMgrList">
		    </div>
		    <div id="paging" class="paging"></div>
	        
            <div class="bottom-content mt50">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
