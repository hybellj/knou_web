<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
    <div id="wrap">
       	<div class="option-content header2">
       		<div class="pr20 fcBlue">
       			<spring:message code="exam.label.user.no" /><!-- 학번 --> : ${stdVO.userId }
       		</div>
       		<div class="fcBlue">
        		<spring:message code="exam.label.usernm" /><!-- 성명 --> : ${stdVO.userNm }
       		</div>
       	</div>
       	<div class="mt20 mb10 option-content">
       		<h3><spring:message code="exam.label.absent.apply.hsty" /><!-- 결시원 신청이력 --></h3>
       		<span class="pl10"><spring:message code="exam.label.total" /><!-- 총 --> <label class="fcBlue">${cnt }</label><spring:message code="exam.label.cnt" /><!-- 건 --></span>
       	</div>
       	<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
       		<thead>
       			<tr>
       				<th class="p_w3">No</th>
       				<th class="p_w10"><spring:message code="exam.label.stare.type" /><!-- 구분 --></th>
       				<th class="p_w10"><spring:message code="exam.label.process.status" /><!-- 처리상태 --></th>
       				<th class="p_w15"><spring:message code="exam.label.process.dttm" /><!-- 처리일시 --></th>
       				<th class="p_w30"><spring:message code="exam.label.absent.cts" /><!-- 결시사유 --></th>
       				<th class="p_w30"><spring:message code="exam.label.approve.cts" /><!-- 처리의견 --></th>
       			</tr>
       		</thead>
       		<tbody>
       			<c:forEach var="item" items="${list }">
       				<c:set var="statNm">
       					<c:choose>
       						<c:when test="${item.apprStat eq 'APPLICATE' }"><spring:message code="exam.label.applicate" /><!-- 신청 --></c:when>
       						<c:when test="${item.apprStat eq 'RAPPLICATE' }"><spring:message code="exam.label.rapplicate" /><!-- 재신청 --></c:when>
       						<c:when test="${item.apprStat eq 'APPROVE' }"><spring:message code="exam.label.approve" /><!-- 승인 --></c:when>
       						<c:when test="${item.apprStat eq 'COMPANION' }"><spring:message code="exam.label.companion" /><!-- 반려 --></c:when>
       					</c:choose>
       				</c:set>
       				<fmt:parseDate var="modFmt" pattern="yyyyMMddHHmmss" value="${item.modDttm }" />
					<fmt:formatDate var="modDttm" pattern="yyyy.MM.dd HH:mm" value="${modFmt }" />
       				<tr>
       					<td class="tc">${item.lineNo }</td>
       					<td class="tc">${item.examStareTypeNm }</td>
       					<td class="tc">
       						<c:choose>
       							<c:when test="${item.apprStat eq 'APPLICATE'}">
       								<span class="fcBlue"><spring:message code='exam.label.applicate' /><!-- 신청 --></span>
       							</c:when>
       							<c:when test="${item.apprStat eq 'RAPPLICATE'}">
       								<span class="fcBlue"><spring:message code='exam.label.rapplicate' /><!-- 재신청 --></span>
       							</c:when>
       							<c:when test="${item.apprStat eq 'APPROVE'}">
       								<span class="fcGreen"><spring:message code='exam.label.approve' /><!-- 승인 --></span>
       							</c:when>
       							<c:when test="${item.apprStat eq 'COMPANION'}">
       								<span class="fcRed"><spring:message code='exam.label.companion' /><!-- 반려 --></span>
       							</c:when>
       						</c:choose>
       					</td>
       					<td>${modDttm }</td>
       					<td><pre>${item.absentCts }</pre></td>
       					<td><pre>${item.apprCts }</pre></td>
       				</tr>
       			</c:forEach>
       		</tbody>
		</table>
            
        <div class="bottom-content mt50">
            <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
        </div>
    </div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
