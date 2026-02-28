<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:forEach var="cors" items="${legalCorsList}" varStatus="status">
    <c:set var="lessonList" value="${cors.lessonScheduleList}"/>

	<section class="item">
	    <div class="header">
	    	<a href="javascript:viewLessonLegal('${cors.crsCreCd}', '${cors.lessonScheduleId}', '${cors.lessonTimeId}')" title="강의실 이동" class="h4 <c:if test='${cors.uniCd eq "G"}'>graduSch</c:if>">${cors.crsCreNm} (${cors.declsNo}<spring:message code="dashboard.cor.dev_class"/>)</a>
	        <div class="extra1" style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
	            <dl><dd><spring:message code="common.period" /></dd></dl> <!-- 기간 -->
	            <dl>
	            	<dd>
	            		<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${cors.enrlStartDttm }" />
						<fmt:formatDate var="enrlStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
						<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${cors.enrlEndDttm }" />
						<fmt:formatDate var="enrlEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
						${enrlStartDttm } ~ ${enrlEndDttm }
	            	</dd>
	            </dl>
	        </div>
	    </div>

		<c:if test="${cors.auditYn eq 'N' }">
		    <div class="cnt">
    			<c:choose>
    				<c:when test="${cors.prgrRatio eq '100'}">
    					<span class="box complete">
    						<span style="line-height:3em"><spring:message code='common.label.finish'/></span> <!-- 완료 -->
    					</span>
    				</c:when>
    				<c:otherwise>
    					<span class="box noti" data-label="<spring:message code='lesson.lecture'/>">
				    		<span>${cors.prgrRatio}%</span>
				    	</span>
    				</c:otherwise>
    			</c:choose>
		    </div>
		</c:if>
	    
	</section>
</c:forEach>
<script>
	// 법정과목 강의보기
	function viewLessonLegal(crsCreCd, lessonScheduleId, lessonTimeId) {
		var url = "/crs/crsStdLessonView.do?crsCreCd=" + crsCreCd
    		+ "&lessonScheduleId="+lessonScheduleId+"&lessonTimeId="+lessonTimeId+"&lessonCntsIdx=0";
		
		document.location.href = url;
	}
</script>