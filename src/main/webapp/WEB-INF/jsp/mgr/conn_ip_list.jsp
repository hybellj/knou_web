<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<table class="table" data-sorting="false" data-paging="false" data-empty='<spring:message code="common.nodata.msg"/>'>
		<thead>
			<tr>
				<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no"/></th>	<!-- NO. -->
				<th scope="col"><spring:message code="main.connIp.conn.allow.ip"/></th>	<!-- 접속 허용 IP 주소 -->
				<th scope="col"><spring:message code="main.mgr"/></th>		<!-- 관리 -->
			</tr>
        </thead>
		<tbody>
        	<c:forEach items="${connIpList }" var="item" varStatus="status">
				<tr>
					<td>${pageInfo.rowNum(status.index) }</td>
					<td>${item.connIp }<c:if test="${item.bandYn == 'Y' }"> ~ ${item.bandVal }</c:if></td>
	                <td><a href="javascript:removeConnIp('${item.connIp }');" class="ui basic small button"><spring:message code="button.delete"/></a></td>		<!-- 삭제 -->
				</tr>
            </c:forEach>
		</tbody>
	</table>
    <tagutil:paging pageInfo="${pageInfo}" funcName="connIpList"/>
</html> 