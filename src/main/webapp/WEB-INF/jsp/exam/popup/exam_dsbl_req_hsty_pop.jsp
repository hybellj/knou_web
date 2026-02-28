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
		});
	</script>
	
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th><spring:message code="common.number.no" /><!-- NO --></th>
        				<th><spring:message code="common.label.contents" /><!-- 내용 --></th>
        				<th>IP</th>
        				<th><spring:message code="common.date_time" /><!-- 일시 --></th>
        			</tr>
        		</thead>
        		<tbody>
        			<c:forEach var="item" items="${hstyList }">
        				<tr>
        					<td>${item.lineNo }</td>
        					<td>${item.actnHstyCts }</td>
        					<td>${item.regIp }</td>
        					<td>
        						<fmt:parseDate var="regFmt" pattern="yyyyMMddHHmmss" value="${item.regDttm }" />
								<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd HH:mm" value="${regFmt }" />
								${regDttm }
        					</td>
        				</tr>
        			</c:forEach>
        		</tbody>
        	</table>
        	
            <div class="bottom-content mt50 tc">
                <button class="ui basic button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /><!-- 닫기 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
