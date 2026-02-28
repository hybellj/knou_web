<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/seminar/common/seminar_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 엑셀 다운로드
		function excelDown() {
			var excelGrid = {
			    colModel:[
			        {label:"<spring:message code='seminar.label.join.email' />",		name:'email',   	align:'left',   width:'10000'},/* 참여자 이메일 */
			        {label:"<spring:message code='seminar.label.join.name' />",			name:'name',   	   	align:'left',   width:'8000'},/* 참여자 이름 */
			        {label:"<spring:message code='seminar.label.join.start.dttm' />",	name:'startDt',   	align:'center', width:'5000'},/* 입장 일시 */
			        {label:"<spring:message code='seminar.label.join.end.dttm' />", 	name:'endDt',       align:'right',  width:'5000'},/* 퇴장 일시 */
			        {label:"<spring:message code='seminar.label.join.time' />", 		name:'time',        align:'left',   width:'5000'},/* 유지 시간 */
			        {label:"<spring:message code='seminar.label.join.type' />", 		name:'typeNm',      align:'left',   width:'5000'},/* 입장 구분 */
			    ]
			};
			
			var kvArr = [];
			kvArr.push({'key' : 'zoomId', 	   'val' : "${vo.zoomId}"});
			kvArr.push({'key' : 'crsCreCd',    'val' : "${vo.crsCreCd}"});
			kvArr.push({'key' : 'excelGrid',   'val' : JSON.stringify(excelGrid)});
			
			submitForm("/seminar/seminarHome/attendExcelDown.do", "", "", kvArr);
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content mb10">
        		<a href="javascript:excelDown()" class="ui small basic button mla"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
        	</div>
        	<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />" id="seminarAtndTable"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th><spring:message code="seminar.label.join.email" /><!-- 참여자 이메일 --></th>
        				<th><spring:message code="seminar.label.join.name" /><!-- 참여자 이름 --></th>
        				<th><spring:message code="seminar.label.join.start.dttm" /><!-- 입장 일시 --></th>
        				<th><spring:message code="seminar.label.join.end.dttm" /><!-- 퇴장 일시 --></th>
        				<th><spring:message code="seminar.label.join.time" /><!-- 유지 시간 --></th>
        				<th><spring:message code="seminar.label.join.type" /><!-- 입장 구분 --></th>
        			</tr>
        		</thead>
        		<tbody>
        			<c:forEach var="list" items="${attendList }">
        				<tr>
        					<td>${list.email }</td>
        					<td>${list.name }</td>
        					<td>${list.startDt }</td>
        					<td>${list.endDt }</td>
        					<td>${list.time }</td>
        					<td>${list.typeNm }</td>
        				</tr>
        			</c:forEach>
        		</tbody>
        	</table>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="seminar.button.close" /><!-- 닫기 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
