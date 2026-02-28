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
        	<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th class="tc"><spring:message code="seminar.label.seminar.nm" /><!-- 세미나명 --></th>
        				<th class="tc"><spring:message code="seminar.label.progress.time" /><!-- 진행시간 --></th>
        				<th class="tc"><spring:message code="seminar.button.record.view" /><!-- 녹화영상 보기 --></th>
        			</tr>
        		</thead>
        		<tbody>
        			<c:forEach var="recordingVO" items="${allRecordingList}">
        				<c:forEach var="item" items="${recordingVO.recordingFiles}">
        					<fmt:parseNumber integerOnly="true" var="hour" value="${item.recordingTime / 60 / 60 }" />
	        				<fmt:parseNumber integerOnly="true" var="min"  value="${item.recordingTime / 60 - hour * 60 }" />
	        				<fmt:parseNumber integerOnly="true" var="sec"  value="${item.recordingTime % 60 }" />
	        				<fmt:formatNumber minIntegerDigits="2" type="number" var="hourStr" value="${hour }" />
	        				<fmt:formatNumber minIntegerDigits="2" type="number" var="minStr"  value="${min }" />
	        				<fmt:formatNumber minIntegerDigits="2" type="number" var="secStr"  value="${sec }" />
	        				<tr>
	        					<td>${item.topic}</td>
	        					<td>${hourStr }:${minStr }:${secStr }</td>
	        					<td><a href="javascript:window.open('${item.playUrl}?pwd=${recordingVO.recordingPlayPasscode}')" class="ui blue button small"><spring:message code="seminar.button.record.view" /><!-- 녹화영상 보기 --></a></td>
	        				</tr>
        				</c:forEach>
        			</c:forEach>
        		</tbody>
        	</table>
        	
        	<div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="seminar.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
