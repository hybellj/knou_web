<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<c:forEach var="cors" items="${legalCorsList}" varStatus="status">
	<section class="item">
	    <div class="header">                
	        <a href="javascript:viewLessonLegal('${cors.crsCreCd}', '${cors.lessonScheduleId}', '${cors.lessonTimeId}')" title="강의실 이동" class="h4">${cors.crsCreNm}</a>
	        <div class="extra1"> <!-- 수강 청강 태그 변경 및 위치 이동_230517 -->
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
	</section>
</c:forEach>        

<c:if test="${empty legalCorsList}">
	<div class="flex-container" style="min-height:300px">
		<!-- 등록된 내용이 없습니다. -->
	    <div class="cont-none fcGrey"><i class="icon-list-no ico"></i><span class="fcGrey"><spring:message code="common.content.not_found"/></span></div>
	</div>
</c:if>
<script>
	// 법정과목 강의보기
	function viewLessonLegal(crsCreCd, lessonScheduleId, lessonTimeId) {
		var url = "/crs/crsStdLessonView.do?crsCreCd=" + crsCreCd
    		+ "&lessonScheduleId="+lessonScheduleId+"&lessonTimeId="+lessonTimeId+"&lessonCntsIdx=0";
		
		document.location.href = url;
	}
</script>