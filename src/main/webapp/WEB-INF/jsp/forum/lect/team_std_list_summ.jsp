<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<div class="ui top attached message">
    <div class="header">${stdList[0].teamNm } <spring:message code='forum.label.info'/></div><!-- 정보 -->
</div>
<div class="ui bottom attached segment">
    <table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty'/>"><!--등록된 내용이 없습니다  -->
        <thead>
            <tr>
                <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /><!-- NO. --></th>
                <th scope="col"><spring:message code='forum.label.user_nm'/></th><!-- 이름 -->
                <th scope="col" data-breakpoints="xs"><spring:message code='forum.label.user_id'/></th><!-- 아이디 -->
                <th scope="col"><spring:message code='forum.label.dept.nm'/></th><!-- 학과 -->
                <th scope="col"><spring:message code='forum.label.type'/></th><!--구분  -->
            </tr>
        </thead>
        <tbody>
         <c:forEach items="${stdList }" var="item">
             <tr>
                 <td>${item.lineNo }</td>
                 <td>${item.userNm }</td>
                 <td>${item.userId }</td>
                 <td>${item.deptNm }</td>
                 <td>
                	<c:choose>
                		<c:when test="${item.leaderYn eq 'Y' }">
                			<spring:message code='forum.label.team.leader'/><!--팀장  -->
                		</c:when>
                		<c:otherwise>
                			<spring:message code='forum.label.team.member'/><!--팀원-->
                		</c:otherwise>
                	</c:choose>
                </td>
             </tr>
         </c:forEach>
        </tbody>
    </table>
</div>
<script>
$(".table").footable();
</script>