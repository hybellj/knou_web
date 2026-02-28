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
	
	<script type="text/javascript">
		$(document).ready(function() {
			if($("#teamCd").val() == "") {
				$("#teamCd").val("${meTeamNm}");
				$("#teamCd").val("${meTeamNm}").prop("selected", true);
			}
			teamMemberList()
		});
		
		function teamMemberList() {
			var url  = "/forum/forumLect/teamMember.do";
			var data = {
				"teamCd"  : $("#teamCd").val(),
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				html += `<tr>`;
	        				html += `	<td>\${v.lineNo}</td>`;
	        				html += `	<td>\${v.deptNm}</td>`;
	        				html += `	<td>\${v.userId}</td>`;
	        				html += `	<td>\${v.userNm}</td>`;
	        				html += `	<td>\${v.memberRole}</td>`;
	        				html += `</tr>`;
	        			});
	        		}
	        		
	        		$("#teamListBody").empty().html(html);
	        		$("#teamListTable").footable();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
			}, true);
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content mb10">
                <div class="button-area mla">
                	<select class="ui dropdown${student =='STD' ? ' disabled': ''}" id="teamCd" onchange="teamMemberList()">
                		<%-- <option value=""><spring:message code='forum.label.selected'/><!-- 팀 분류를 선택하세요. --></option> --%>
                		<c:forEach var="list" items="${teamCtgrList }">
                			<option value="${list.teamCd }"${list.teamNm eq meTeamNm ? " selected" : ""}>${list.teamNm }</option>
                		</c:forEach>
                	</select>
                </div>
            </div>
            <table class="table type2" id="teamListTable" data-sorting="false" data-paging="false" data-empty="<spring:message code='forum.common.empty'/>"><!-- 등록된 내용이 없습니다 -->
            	<thead>
            		<tr>
            			<th scope="col" class="tc"><spring:message code="common.number.no" /></th><!-- NO. -->
            			<th scope="col" class="tc"><spring:message code='forum.label.dept.nm'/></th><!-- 학과 -->
            			<th scope="col" class="tc"><spring:message code='forum.label.user.no'/></th><!-- 학번 -->
            			<th scope="col" class="tc"><spring:message code='forum.label.user_nm'/></th><!-- 이름 -->
            			<th scope="col" class="tc"><spring:message code='forum.label.type'/></th><!-- 구분 -->
            		</tr>
            	</thead>
            	<tbody id="teamListBody">
            	</tbody>
            </table>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
