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

function allMajorCheck() {
	if(!$("#allCheck").is(":checked")) {
		$("input[name='check']").each(function(){
			$(this).prop('checked','checked');
		});
	} else {
		$("input[name='check']").each(function(){
			$(this).removeAttr('checked');
		});
	}
};

function allTripleCheck() {
	if(!$("#allCheck").is(":checked")) {
		$("input[name='check']").each(function(){
			$(this).prop('checked','checked');
		});
	} else {
		$("input[name='check']").each(function(){
			$(this).removeAttr('checked');
		});
	}
};

function allMinorCheck() {
	if(!$("#allCheck").is(":checked")) {
		$("input[name='check']").each(function(){
			$(this).prop('checked','checked');
		});
	} else {
		$("input[name='check']").each(function(){
			$(this).removeAttr('checked');
		});
	}
};
</script>

<body>

    <div class="option-content gap4 mt10 mb10">   
        <div class="flex gap4 mra">
            <div class="sec_head"><spring:message code="crs.label.open.crs" /></div><!-- 개설과목 -->
        </div>
        <div class="">
            <a class="ui basic small button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
            <a class="ui basic small button"><i class="download icon"></i><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
        </div>
    </div>
    <table class="table ftable mt15" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
        <thead>
            <tr>
                <th scope="col" data-type="number" class="num "><spring:message code="common.number.no" /></th><!-- NO. -->
                <th scope="col" data-breakpoints="xs"><spring:message code="bbs.label.type" /></th><!-- 구분 -->
                <th scope="col" data-breakpoints="xs"><spring:message code="review.label.crscre.dept" /></th><!-- 개설학과 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="review.label.crscd" /></th><!-- 학수번호 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="review.label.crscrenm" /><br /> (<spring:message code="review.label.decls" />)</th><!-- 과목명 (분반) -->
				<th scope="col" data-sortable="false" class="chk">
                	<div class="ui checkbox allCheck" onclick="allMajorCheck()">
                    	<input type="checkbox" id="allCheck">
                	</div>
            	</th>
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="user.title.tch.req.professor" /></th><!-- 메인교수 -->
				<!-- 
				<th scope="col" data-sortable="false" class="chk">
                	<div class="ui checkbox allCheck" onclick="allTripleCheck()">
                    	<input type="checkbox" id="allCheck">
                	</div>
            	</th>
            	 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="user.title.tch.associate" /></th><!-- 공동교수 -->
				<!-- 
				<th scope="col" data-sortable="false" class="chk">
                	<div class="ui checkbox allCheck" onclick="allMinorCheck()">
                    	<input type="checkbox" id="allCheck">
                	</div>
            	</th> 
            	-->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="crs.label.rep.assistant" /></th><!-- 담당조교 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="common.label.score"/></th><!-- 성적 -->
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
			                <td>${result.crsCreCd}</td>
			                <td>${result.crsCreNm}</td>
							<td>
				                <div class="ui checkbox">
				                	<input type="checkbox" id="check${status.index}" name="check" value="${result.majorUserId}|${asmntJoinUserVO.majorUserNm}">
				            	</div>
				            </td>
			                <td>
								<c:choose>
	                            	<c:when test="${result.majorUserNm eq ''}">
	                            		-
									</c:when>
	  								<c:otherwise>
										${result.majorUserNm}
									</c:otherwise>
								</c:choose>
				            </td>
							<%-- <td>
				                <div class="ui checkbox">
				                	<input type="checkbox" id="check${status.index}" name="check" value="${result.tripleUserId}|${asmntJoinUserVO.tripleUserNm}">
				            	</div>
				            </td> --%>
				            <td>
								<c:choose>
	                            	<c:when test="${result.tripleUserNm eq ''}">
	                            		-
									</c:when>
	  								<c:otherwise>
										${result.tripleUserNm}
									</c:otherwise>
								</c:choose>
				            </td>
							<%-- <td>
				                <div class="ui checkbox">
				                	<input type="checkbox" id="check${status.index}" name="check" value="${result.minorUserId}|${asmntJoinUserVO.minorUserNm}">
				            	</div>
				            </td> --%>
				            <td>
								<c:choose>
	                            	<c:when test="${result.minorUserNm eq ''}">
	                            		-
									</c:when>
	  								<c:otherwise>
										${result.minorUserNm}
									</c:otherwise>
								</c:choose>
				            </td>
							<td>
								<c:choose>                                
							    	<c:when test="${empty result.scoreEvalGbn or result.scoreEvalGbn eq ''}">
								    	<c:choose>                                
											<c:when test="${empty result.scoreGrantGbn or result.scoreGrantGbn eq ''}">
											    <spring:message code="exam.label.eval.n" /><!-- 미평가 -->
											</c:when>
									        <c:otherwise>
									        </c:otherwise>
									    </c:choose>
							        </c:when>
							        <c:otherwise>
										<spring:message code="exam.label.eval.y" /><!-- 평가 -->
							        </c:otherwise>
							    </c:choose>
			                </td>
			            </tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>
        </tbody>
    </table>
</body>
</html>