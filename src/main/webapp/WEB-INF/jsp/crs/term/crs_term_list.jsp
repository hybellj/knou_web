<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
<%-- 1. 학기 등록, 수정 페이지 이동 --%>
function moveCrsAddForm(termCd) {
	$("#crsTermForm").attr("action","/crs/termMgr/Form/crsTermInfoWrite.do");
	$("#termCd").val(termCd);
	$("#crsTermForm").submit(); 
}

<%-- 2.주차기간 설정 페이지 이동--%>
function moveCrsLessonTermList(termCd) {
	$("#crsTermForm").attr("action","/crs/termMgr/Form/crsTermLessonForm.do");
	$("#termCd").val(termCd);
	$("#crsTermForm").submit(); 
}

<%-- 3. 학기 삭제 --%>
function delCrsTerm(termCd, termNm, curTermYn, crsCount) {

	if(curTermYn == "Y") {
		/* 현재학기인 경우 삭제할 수 없습니다. */
		alert('<spring:message code="common.alert.now.term.no.delete"/>');
		return;
	}

	if (crsCount > 0) {
		alert(termNm + " <spring:message code='crs.term.delete.no'/>"); <%-- 학기에 과목이 존재하여 삭제가 불가능합니다.--%>
		return;
	}
	
	<%-- 학기를 삭제 하시겠습니까? 학기 하위 메뉴의 정보도 같이 삭제됩니다. 삭제 시 데이터 복구는 불가합니다. --%>
	if(confirm(termNm+"<spring:message code='crs.confirm.delete.semester'/>")) {
		
		$.ajax({
			type : "POST", 
			url : "/crs/termMgr/removeCrsTerm.do",
			data: {
				"termCd" : termCd
			},
			dataType: "json",
			success : function(data) {
				if(data != null){
					if(data.result == 1) {
						crsTermList(1);
					} else {
						alert(termNm + " <spring:message code='crs.term.delete.no'/>"); <%-- 학기에 과목이 존재하여 삭제가 불가능합니다.--%>
					}
				}
			},
			error : function(request, status, error){
				alert("<spring:message code='errors.json'/>"); <%-- 요청에 대해 정상적인 응답을 받지 못하였습니다.관리자에게 문의 하십시오.--%>
			}
		});
	}
}

function togleUseYn(obj_id) {
	var useYn = "Y";
	if($("#"+obj_id+"").is(":checked")) {
 		useYn = "N"; 
 	}
	var termCd = obj_id.substr(obj_id.indexOf('_')+1);
	$.getJSON("/crs/termMgr/editCurTermYn.do",
	{
		"termCd" : termCd
	   	, "useYn" : useYn
	},
	function(data) {
		if(data.result > 0) {

			if(useYn == "N") {
				/* 현재학기에서 제외 하였습니다. */
				alert('<spring:message code="common.alert.now.term.except" />');
				crsTermList(1);
			} else if(useYn == "Y") {
				notEditCurTermYn(termCd);
				/* 현재학기로 설정 하였습니다. */
				alert('<spring:message code="common.alert.now.term.setting" />');
				crsTermList(1);
			}
		} else{
			/* 현재학기 설정에 실패하였습니다. */	
			alert('<spring:message code="common.alert.now.term.setting.error" />');
		}
	});
}

function notEditCurTermYn(termCd) {
	var useYn = "N";
	$.getJSON("/crs/termMgr/notEditCurTermYn.do",
	{
		"termCd" : termCd
	},
	function(data) {
		/*
		if(data.result > 0) {
			alert("현재학기로 변경한 학기를 제외 하고, 나머지 학기는 현재학기에서 제외 하였습니다.");
		} else{
			alert("현재학기로 변경한 학기를 제외 하고, 나머지 학기는 현재학기에서 제외 설정에 실패하였습니다.");
		}
		*/
	});
}
</script>

<form class="ui form" id="crsTermForm" method="POST" action="/crs/termMgr/crsTermList.do">
<input type="hidden" id="termCd" name="termCd"/>

	<table class="table" data-sorting="false" data-paging="false" data-empty='<spring:message code="common.nodata.msg"/>'> 
		<thead>
			<tr>
				<th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><!-- NO. -->
				<th scope="col"><spring:message code="crs.title.term.name"/></th><!-- 학기명 -->
				<th scope="col"><spring:message code="crs.label.school.year"/> (<spring:message code="common.term"/>)</th><!-- 학사년도 (학기)-->
				<th scope="col" data-breakpoints="xs"><spring:message code="common.term.status"/></th><!-- 운영 상태 -->
				<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="crs.label.course.connected"/></th><!-- 학사연동 -->
				<th scope="col" data-breakpoints="xs sm"><spring:message code="crs.label.course.number"/></th> <!-- 과목수 -->
				<th scope="col" data-breakpoints="xs sm"><spring:message code="lesson.label.lesson.start.dttm" /></th><!-- 강의시작일자 -->
				<th scope="col" data-breakpoints="xs sm md"><spring:message code="review.lecture.EndDttm"/></th><!-- 복습기간종료일자 -->
				<th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.now.term"/></th><!-- 현재학기 -->
				<th scope="col" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="common.mgr"/></th><!-- 관리 -->
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${crsTermList}" var="item" varStatus="status">
				<tr>
					<td>${item.lineNo}</td>
					<td>${item.termNm}</td>
					<td>${item.haksaYear} (${item.haksaTermNm})</td>
					<td <c:choose>
						<c:when test="${item.termStatus eq 'FINISH'}">class="fcRed"</c:when>
						<c:when test="${item.termStatus eq 'SERVICE'}">class="fcBlue"</c:when>
						<c:when test="${item.termStatus eq 'WAIT'}">class="fcYellow"</c:when>
						</c:choose>>
						<c:forEach items="${termStatustList}" var="item2" varStatus="status">
							<c:if test="${item2.codeCd eq item.termStatus}">
								<c:out value="${item2.codeNm}"/>
							</c:if>
						</c:forEach>
					</td>
					<td>
					<c:choose>
						<c:when test="${item.termLinkYn eq 'Y'}"><spring:message code="message.yes"/></c:when>
						<c:otherwise><spring:message code="message.no"/></c:otherwise>
					</c:choose>
					</td>
					<td>${item.crsCount}</td>
					<td>${item.svcStartDttm}</td>
					<td>${item.svcEndDttm}</td>
					<td>
						<div class="ui toggle checkbox" onclick="togleUseYn('useYn_${item.termCd}');">
							<input type="checkbox" id="useYn_${item.termCd}" <c:if test="${item.curTermYn eq 'Y'}">checked</c:if>  class="hidden"><label></label>
						</div>
					</td>
					<td>
						<div class="manage_buttons">
							<a href="javascript:moveCrsLessonTermList('${item.termCd}')" class="ui basic small button"><spring:message code='crs.label.week.period.setting'/></a> <%-- 주차기간 설정 --%>
							<a href="javascript:moveCrsAddForm('${item.termCd}')" class="ui basic small button"><spring:message code='button.edit'/></a> <%-- 수정 --%>
							<a href="javascript:delCrsTerm('${item.termCd}','${item.termNm}','${item.curTermYn}','${item.crsCount}')" class="ui basic small button" ><spring:message code='button.delete'/></a> <%-- 삭제 --%>
							<c:if test="${item.termLinkYn eq 'Y'}">
							<a href="/crs/termLinkMgr/Form/termLinkMain?termCd=${item.termCd}" class="ui basic small button"><spring:message code='crs.label.course.connected'/></a> <%-- 학사연동 --%>
							</c:if>
						</div>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<tagutil:paging pageInfo="${pageInfo}" funcName="crsTermList"/>
</form>
</html>