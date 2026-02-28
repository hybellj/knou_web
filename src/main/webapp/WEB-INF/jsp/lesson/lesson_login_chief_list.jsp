<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_div.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	/*
	if(typeof displayCount == 'function') {
		displayCount('${pageInfo.totalRecordCount}');
	}
	*/
});
</script>

<body>
	
    <div class="option-content gap4 mt10 mb10">   
        <div class="flex gap4 mra">
            <div class="sec_head"><spring:message code="user.title.tch.professor" /></div><!-- 교수 -->
			<div class="fcGrey"><spring:message code="lesson.alert.input.name.lecture" /></div><!-- 이름을 누르시면 강의 과목 및 학습현황 확인이 가능합니다. -->
        </div>
    </div>

	<div>
	    <table class="table ftable mt15" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
	        <thead>
	            <tr>
	                <th scope="col" data-type="number" class="num "><spring:message code="common.number.no" /></th><!-- NO. -->
	                <th scope="col" data-breakpoints="xs"><spring:message code="bbs.label.type" /></th><!-- 구분 -->
	                <th scope="col" data-breakpoints="xs"><spring:message code="common.label.department"/><spring:message code="common.dept_name"/></th><!-- 소속학과 -->
	                <th scope="col" data-breakpoints="xs"><spring:message code="crs.label.lecture" /></th><!-- 강의 -->
	                <th scope="col" data-breakpoints="xs"><spring:message code="common.name" /> (<spring:message code='exam.label.tch.no' />)</th><!-- 이름 (사번) -->
	                <th scope="col" data-breakpoints="xs sm md"><spring:message code="common.last.login.day"/></th><!-- 마지막로그인일시 -->
	            </tr>
	        </thead>
	        <tbody>
				<c:choose>
					<c:when test="${not empty resultList}">
						<c:forEach items="${resultList}" var="result" varStatus="status">
				            <tr>
				                <td>${result.lineNo}</td>
				                <td>${result.orgNm}</td>
				                <td>${result.deptNm}</td>
				                <td>${result.lessonCnt}</td>
				                <td>
				                	<c:choose>
										<c:when test="${result.lessonCnt == 0}">
											${result.userNm} (${result.userId})
										</c:when>
										<c:otherwise>
											<a href="javascript:viewUser('${result.userId}')" class="link">${result.userNm}</a> (${result.userId})
										</c:otherwise>
									</c:choose>
				                </td>
				                <td>${result.lastLoginDttm}</td>
				            </tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
					</c:otherwise>
				</c:choose>
	        </tbody>
	    </table>
	</div>
	
	<!-- 개설과목 -->
	<div id="lessonLectureList"></div>

	<!-- 과제 -->
	<div id="lessonAsmntList"></div>

	<!-- 퀴즈 -->
	<div id="lessonQuizList"></div>

	<!-- 토론 -->
	<div id="lessonForumList"></div>

	<!-- 설문 -->
	<div id="lessonResearchList"></div>
	
</body>
</html>