<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	 <script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
});
</script>
<style>
.table_nodata > thead > tr > th, .table_nodata > tbody > tr > td { display: table-cell;  padding: 10px 8px; line-height: 1.42857143; vertical-align: middle;}
.table_nodata > thead > tr > th {text-align: left; color: #475a81;
    border-top: 1px solid #d9e4eb !important;
    border-bottom: 1px solid #d9e4eb !important;
    background: #f5f9fb;
    position: relative;}

.table_nodata > tbody > tr > td {text-align: center; font-size: 14px; border-bottom: 1px solid #ddd;}
</style>

<body>

	<div class="mb10">
		<div class="ui attached message flex gap4"><spring:message code="std.label.asmnt" /><spring:message code="std.label.lesson_cnt" /></div><!-- 과제학습요소 -->
		<div class="ui bottom attached segment">
		
			<c:choose>
				<c:when test="${not empty resultList}">
					<table class="table ftable mt15" data-sorting="false" data-paging="false" data-empty="<spring:message code="asmnt.message.data.empty" />">
						<thead>
							<tr>
								<th scope="col" class="w60"><spring:message code="common.number.no" /></th>
								<th scope="col"><spring:message code="review.label.crscd" /></th>
								<th scope="col"><spring:message code="contents.label.crscrenm" /> (<spring:message code="contents.label.decls" />)</th>
								<th scope="col"><spring:message code="asmnt.label.asmnt.title"/></th>
								<th scope="col"><spring:message code="common.submission"/><spring:message code="common.label.dead.line"/></th>
								<th scope="col"><spring:message code="common.label.submit.late" /></th>
								<th scope="col"><spring:message code="asmnt.label.eval.status"/></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${resultList}" varStatus="status">
								<tr>
									<td>${item.lineNo}</td>
									<td>${item.crsCreCd}</td>
									<td>${item.crsCreNm}</td>
									<td>${item.asmntTitle}</td>
									<td>${item.sendEndDttm}</td>
									<td>${item.extSendDttm}</td>
									<td>${item.asmntEvalCnt}/${item.asmntCnt}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
					<table class="table_nodata ftable mt15" data-sorting="false" data-paging="false" data-empty="<spring:message code="asmnt.message.data.empty" />" style="width:100%;">
						<thead>
							<tr>
								<th scope="col" class="w60"><spring:message code="common.number.no" /></th>
								<th scope="col"><spring:message code="review.label.crscd" /></th>
								<th scope="col"><spring:message code="contents.label.crscrenm" /> (<spring:message code="contents.label.decls" />)</th>
								<th scope="col"><spring:message code="asmnt.label.asmnt.title"/></th>
								<th scope="col"><spring:message code="common.submission"/><spring:message code="common.label.dead.line"/></th>
								<th scope="col"><spring:message code="common.label.submit.late" /></th>
								<th scope="col"><spring:message code="asmnt.label.eval.status"/></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="7"><spring:message code="asmnt.message.data.empty" /></td>
							</tr>
						</tbody>
					</table>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</body>
</html>