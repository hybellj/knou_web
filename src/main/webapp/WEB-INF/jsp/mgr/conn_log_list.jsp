<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<table class="table" data-sorting="false" data-paging="false" data-empty='<spring:message code="common.nodata.msg"/>'>
	<thead>
    	<tr>
        	<th scope="col" data-type="number" class="num"><spring:message code="main.common.number.no"/></th>		<!-- NO. -->
            <th scope="col"><spring:message code="main.connIp.conn.id"/></th>		<!-- 접속자 ID -->
            <th scope="col"><spring:message code="common.label.conn.ip.address"/></th>		<!-- 접속 IP 주소 -->
            <th scope="col" data-breakpoints="xs"><spring:message code="main.connIp.loginDttm"/></th>		<!-- 시작 시간 -->
            <th scope="col" data-breakpoints="xs"><spring:message code="main.connIp.logoutDttm"/></th>		<!-- 종료 시간 -->
            <th scope="col"><spring:message code="common.label.connect.time"/></th>		<!-- 접속 시간 -->
		</tr>
 	</thead>
    <tbody>
    	<c:forEach items="${connLogList }" var="item" varStatus="status">
			<tr>
	        	<td>${pageInfo.rowNum(status.index) }</td>
	            <td>${item.userId }</td>
	            <td>${item.loginIp }</td>
	            <td>
	            	<fmt:parseDate var="dateString" value="${item.loginDttm}" pattern="yyyyMMddHHmmss" />
	            	<fmt:formatDate value="${dateString}" pattern="yyyy.MM.dd (HH:mm:ss)" />
	            </td>
	            <td>
	            	<fmt:parseDate var="dateString1" value="${item.logoutDttm}" pattern="yyyyMMddHHmmss" />
	            	<fmt:formatDate value="${dateString1}" pattern="yyyy.MM.dd (HH:mm:ss)" />
	            </td>
	            <td>
					<fmt:parseNumber value="${(dateString1.time - dateString.time) < 0? 0:(dateString1.time - dateString.time)}" integerOnly="true" var="cDate"></fmt:parseNumber>
		            <fmt:parseNumber value="${(cDate/(1000*60*60)) % 24}" integerOnly="true" var="cHour"></fmt:parseNumber>
		            <fmt:parseNumber value="${(cDate/(1000*60)) % 60}" integerOnly="true" var="cMin"></fmt:parseNumber>
		            <fmt:parseNumber value="${(cDate/1000) % 60}" integerOnly="true" var="cSec"></fmt:parseNumber>
		            <fmt:parseNumber value="${cHour - (cHour % 1)}" integerOnly="true" var="strHour"></fmt:parseNumber>
		            <fmt:parseNumber value="${cMin - (cMin % 1)}" integerOnly="true" var="strMin"></fmt:parseNumber>
		            <fmt:parseNumber value="${cSec - (cSec % 1)}" integerOnly="true" var="strSec"></fmt:parseNumber>
		            <c:choose>
		            	<c:when test="${strHour > 10}">${strHour}</c:when>
		            	<c:otherwise>0${strHour}</c:otherwise>
		           	</c:choose>
		            :<c:choose>
		            	<c:when test="${strMin > 10}">${strMin}</c:when>
		            	<c:otherwise>0${strMin}</c:otherwise>
		            </c:choose>
					:<c:choose>
						<c:when test="${strSec > 10}">${strSec}</c:when>
						<c:otherwise>0${strSec}</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
    </tbody>
</table>
<tagutil:paging pageInfo="${pageInfo}" funcName="connLogList"/>
</html>