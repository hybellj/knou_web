<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

 <script type="text/javascript">
	$(document).ready(function(){ 
	});
 </script>

<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.nodata.msg'/>"> <%-- 등록된 내용이 없습니다. --%>
      <thead>
          <tr>
              <th scope="col" data-sortable="false" class="chk">
                  <div class="ui checkbox allCheck" onclick="allCheck()">
                      <input type="checkbox" id="allCheck">
                  </div>
              </th>
              <th scope="col" data-type="number" class="num"><spring:message code='common.number.no'/></th> <%-- NO. --%>
              <th scope="col"><spring:message code='common.name'/></th> <%-- 이름 --%>
              <th scope="col"><spring:message code='common.dept_name'/></th>   <%-- 학과 --%>
              <th scope="col"><spring:message code='common.id'/></th>   <%-- 아이디 --%>
              <th scope="col" data-breakpoints="xs"><spring:message code='common.registrant'/></th> <%-- 등록자 --%>
              <th scope="col" data-breakpoints="xs"><spring:message code='crs.lecture.request.day'/></th> <%-- 수강 신청일 --%>
              <th scope="col" data-breakpoints="xs"><spring:message code='crs.lecture.request.status'/></th> <%-- 수강 상태 --%>
              <th scope="col" data-breakpoints="xs"><spring:message code="crs.completion.status"/></th><%-- 수료 상태  --%>
              <th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code='common.mgr'/></th> <%-- 관리 --%>
          </tr>
      </thead>
      <tbody>
      <c:forEach items="${creStdList}" var="item" varStatus="status">
          <tr>
              <td>
                  <div class="ui checkbox">
                      <input type="checkbox" id="check${status.index}" name="check" value="${item.stdNo}" onchange="javasciprt:checkEventBind(this);">
                      <input type="hidden" name="${item.stdNo}" value="${item.userId}" />
                      <input type="hidden" name="${item.stdNo}_cpltNo" value="${item.cpltNo}" />
                      <input type="hidden" name="${item.stdNo}_cpltYn" value="${item.cpltYn}" />
                  </div>
              </td>
              <td>${pageInfo.rowNum(status.index)}</td>
              <td>${item.userNm}</td>
              <td>${item.deptNm}</td>
              <td>${item.userId}</td>
              <td>${item.regNm}</td>
              <td>
	              <fmt:parseDate var="dateString" value="${item.modDttm}" pattern="yyyyMMddHHmmss" />
	              <fmt:formatDate value="${dateString}" pattern="yyyy. MM. dd" />
              </td>
              <td>
              <c:choose>
              	<c:when test="${item.enrlSts eq 'E'}">
              		<spring:message code='common.label.request'/><%-- 신청 --%>
              	</c:when>
              	<c:when test="${item.enrlSts eq 'S'}">
              		<spring:message code='button.confirm'/><%-- 승인 --%>
              	</c:when>
              	<c:when test="${item.enrlSts eq 'N'}">
              		<spring:message code='common.label.reject'/><%-- 반려 --%>
              	</c:when>
              	<c:when test="${item.enrlSts eq 'D'}">
              		<spring:message code='button.delete'/><%-- 삭제 --%>
              	</c:when>
              	<c:otherwise>
              	    <spring:message code='crs.lecture.register'/><%-- 수강 신청 --%>
           	    </c:otherwise>
              </c:choose>
              </td>             
              <td>
	              <c:choose>
		              <c:when test="${item.cpltYn eq 'Y'}">
						<spring:message code="crs.completion"/>
		              </c:when>
		              <c:otherwise>
		              	 <spring:message code="crs.completion.no"/>
		           	  </c:otherwise>
	              </c:choose>
              </td>
              
              <td>
                  <a href="javascript:editstdEnrlSts('delete','${item.stdNo}');" class="ui basic small button"><spring:message code='button.delete'/></a> <%-- 삭제 --%>
                  <c:if test="${item.enrlSts eq 'N'}">
                  		<c:choose>
                  			<c:when test="${empty item.enrlDenyContent}">
                  				<a href="#0" data-memo="${item.enrlDenyContent}" class="ui positive basic small button" onclick="openDenyContent('${item.stdNo }', this)"><spring:message code="crs.reject.reason.add"/></a>
                  			</c:when>
                  			<c:otherwise>
                  				<a href="#0" data-memo="${item.enrlDenyContent}" class="ui negative basic small button" onclick="openDenyContent('${item.stdNo }', this)"><spring:message code="crs.reject.reason.show"/></a>
                  			</c:otherwise>
                  		</c:choose>
            	  </c:if>
              </td>
          </tr>
      </c:forEach>
      </tbody>
  </table>
<tagutil:paging pageInfo="${pageInfo}" funcName="creStdListForm"/>