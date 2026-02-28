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
        	<div class="ui segment">
        		<ul class="tbl">
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.calendar.ctgr" /><!-- 일정코드 --></label></dt>
        					<dd>${vo.calendarCtgr }</dd>
        				</dl>
        			</li>
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.calendar.ctgr.type" /><!-- 업무구분 --></label></dt>
        					<dd>${vo.calendarCtgrNm }</dd>
        				</dl>
        			</li>
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.org.type" /><!-- 대학구분 --></label></dt>
        					<dd>
        						<c:choose>
        							<c:when test="${vo.codeOptn eq '1'}">
        								<spring:message code="common.label.uni.college" /><!-- 대학교 -->
        							</c:when>
        							<c:when test="${vo.codeOptn eq '2'}">
        								<spring:message code="common.label.uni.graduate" /><!-- 대학원 -->
        							</c:when>
        							<c:otherwise>
        								
        							</c:otherwise>
        						</c:choose>
        					</dd>
        				</dl>
        			</li>
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.sch.nm" /><!-- 일정명 --></label></dt>
        					<dd>${vo.jobSchNm }</dd>
        				</dl>
        			</li>
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.haksa.year" /><!-- 개설년도 --></label></dt>
        					<dd>${vo.haksaYear }</dd>
        				</dl>
        			</li>
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.haksa.term.type" /><!-- 학기구분 --></label></dt>
        					<dd>${vo.haksaTermNm }</dd>
        				</dl>
        			</li>
        			<li>
        				<fmt:parseDate var="startDtFmt" pattern="yyyyMMddHHmmss" value="${vo.schStartDt }" />
						<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${startDtFmt }" />
        				<fmt:parseDate var="endDtFmt" pattern="yyyyMMddHHmmss" value="${vo.schEndDt }" />
						<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${endDtFmt }" />
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.date" /><!-- 기간 --></label></dt>
        					<dd>${schStartDt } ~ ${schEndDt }</dd>
        				</dl>
        			</li>
        			<li>
        				<dl>
        					<dt><label for="label"><spring:message code="sys.label.sch.cmnt" /><!-- 설명 --></label></dt>
        					<dd><pre>${vo.schCmnt }</pre></dd>
        				</dl>
        			</li>
        		</ul>
        	</div>
        	
            <div class="bottom-content mt70">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="sys.button.close" /></button><!-- 닫기 -->
                
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
