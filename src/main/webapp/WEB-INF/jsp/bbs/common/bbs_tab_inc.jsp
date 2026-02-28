<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 		uri="http://www.springframework.org/tags"%>

<c:if test="${not empty tabList}">
<div class="listTab">
	<ul>
	<c:forEach var="row" items="${tabList}" varStatus="status">
		<li class="mw120 <c:if test="${tab eq status.index}">select</c:if>" onclick="<c:if test="${tabList.size() > 1 and tab ne status.index}">moveTab('<c:out value="${row.bbsId}" />', '<c:out value="${status.index}" />')</c:if>">
			<a href="javascript:void(0)">
				<c:choose>
	       			<c:when test="${empty row.bbsNm}">
	       				<spring:message code="bbs.label.view.all" /><!-- 전체보기 -->
	       			</c:when>
	       			<c:otherwise>
	       				<c:out value="${row.bbsNm}" />
	       			</c:otherwise>
	       		</c:choose>
				<c:if test="${row.bbsCd eq 'QNA' or row.bbsCd eq 'SECRET'}">
					<small class="list_slash msg_num">
                        <span class=""><c:out value="${row.noAnswerAtclCnt}" /></span>
                    </small>
				</c:if>
			</a>
		</li>
	</c:forEach>
	</ul>
</div>


<script type="text/javascript">
	function moveTab(bbsId, tabOrder) {
		var bbsCd 		= '<c:out value="${param.bbsCd}" />';
		var crsCreCd	= '<c:out value="${param.crsCreCd}" />';
		var templateUrl = '<c:out value="${templateUrl}" />';
		
		var queryInfo = {};
		
		if(bbsCd) {
			queryInfo.bbsCd = bbsCd;
		}
		
		if(crsCreCd) {
			queryInfo.crsCreCd = crsCreCd;
		}
		
		if(bbsId && bbsId.split(",").length == 1) {
			queryInfo.bbsId	= bbsId;
		}
		
		queryInfo.tab = tabOrder;
		
		var queryStr = new URLSearchParams(queryInfo).toString();
		var url = "/bbs/" + templateUrl + "/atclList.do";
		
		bbsCommon.movePost(url, queryStr);
	}
</script>
</c:if>