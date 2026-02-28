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
	   		forumMutList();
		});
	   	
		function forumMutList() {
			var url = '/forum/forumLect/forumMutList.do';
			var data = {
				  forumCd	: "${vo.forumCd}"
				, stdNo		: "${vo.stdNo}"
				, crsCreCd	: "${vo.crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					if(returnList.length > 0) {
						returnList.sort(function(a, b) {
							if(a.regDttm > b.regDttm) return 1;
							if(a.regDttm < b.regDttm) return -1;
							
							return 0;
						});
						
						var index = 1;
						
						returnList.forEach(function(v, i) {
							if(!v.cmnt || !$.trim(v.cmnt)) return true;
							
					   		html += '<tr>';
					   		html += '	<td class="tr p10">' + index++ + '</td>';
					   		html += '	<td class="p10" style="white-space: pre-line;">' + v.cmnt + '</td>';
					   		html += '</tr>';
						});
					} else {
						html += '<tr>';
				   		html += '	<td class="p10 tc" colspan="2"><spring:message code="common.nodata.msg" /></td>';
				   		html += '</tr>';
					}
					
		    		$("#cmntList").html(html);
		        } else {
		        	alert(data.message);
		        }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
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
			<table class="tBasic">
				<thead>
					<tr>
						<th class="w50"><spring:message code="common.number.no" /></th>
						<th><spring:message code="common.label.eval.opinion" /></th>
					</tr>
				</thead>
				<tbody id="cmntList">
				</tbody>
			</table>
		</div>
		<div class="bottom-content tr">
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>