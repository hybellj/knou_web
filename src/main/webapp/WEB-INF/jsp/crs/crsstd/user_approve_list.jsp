<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<head>
	 <script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	var creStdList = new Map(); 
	var creUserList = "";
	$(document).ready(function() {
		creStdList = "${vo.userIdStr}".split(",");
	});
</script>
<div class="field">
	<div class="reponsive-table">
		<table class="table select-list checkbox" data-sorting="true" data-paging="true" data-paging-size="15" data-empty="<spring:message code='common.nodata.msg'/>"> <%-- 등록된 내용이 없습니다. --%>
			<thead>
				<tr>
					<th scope="col" data-sortable="false" class="chk">
						<div class="ui-mark">
							<i class="ion-android-done"></i>
						</div>
					</th>
					<th scope="col"><spring:message code="common.number.no"/></th> <%-- NO. --%>
					<th scope="col"><spring:message code="common.dept_name"/></th> <%-- 학과 --%>
                    <th scope="col"><spring:message code="common.id"/></th>    <%-- 아이디 --%>
                    <th scope="col"><spring:message code="common.name"/></th>  <%-- 이름 --%>
                    <th scope="col"><spring:message code="common.email"/></th> <%-- 이메일 --%>
				</tr>
			</thead>
			<tbody id="listArea">
				<c:forEach items="${resultList}" var="item" varStatus="status">
					<tr>
						<td>
							<div class="ui-mark">
								<input type="checkbox" name="checkStd" value="${item.userId}"> <label><i class="ion-android-done"></i></label>
							</div>
						</td>
                        <td>${status.count}</td>
                        <td>${item.deptNm}</td>
                        <td>${item.userId}</td>
                        <td>${item.userNm}</td>
                        <td>${item.email}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
