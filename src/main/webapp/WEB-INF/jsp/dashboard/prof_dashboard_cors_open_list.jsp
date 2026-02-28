<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<c:forEach var="cors" items="${openCorsList}" varStatus="status">
	<section class="item">
		공개과정 데이터 목록
   	</section>
</c:forEach>        

<c:if test="${empty monCorsList}">
	<div class="flex-container" style="min-height:300px">
		<!-- 등록된 내용이 없습니다. -->
	    <div class="cont-none fcGrey"><i class="icon-list-no ico"></i><span class="fcGrey"><spring:message code="common.content.not_found"/></span></div>
	</div>
</c:if>
	