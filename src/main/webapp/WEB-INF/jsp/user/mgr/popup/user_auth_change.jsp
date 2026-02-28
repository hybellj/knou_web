<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		$(document).ready(function() {
		});

		// 권한 변경
		function save() {
			var authGrpCd = $("input[name='authGrpCd']:checked").val();
			var userId = '<c:out value="${uuivo.userId}" />';
			
			var url  = "/user/userMgr/saveAdminAuthGrp.do";
			var data = {
				  userId		: userId
				, authGrpCd 	: authGrpCd
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert('<spring:message code="success.common.update" />'); // 정상적으로 수정되었습니다.
					if(typeof window.parent.authGrpChangeCallBack === "function") {
						window.parent.authGrpChangeCallBack();
					}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<c:set var="userTypeSize" value="${userTypeList.size()}" />
	        	
			<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
				<thead>
	       			<tr>
	       				<th><spring:message code="user.title.userdept.dept" /></th><!-- 학과/부서 -->
	       				<th><spring:message code="user.title.userinfo.user.no" /></th><!-- 학번/사번 -->
	       				<th><spring:message code="user.title.userinfo.manage.usernm" /></th><!-- 이름 -->
	       				<th><spring:message code="user.title.userinfo.auth.grp.nm" /></th><!-- 권한 그룹명 -->
	       				<th><spring:message code="user.title.userinfo.auth.grp.cd" /></th><!-- 권한 그룹 코드 -->
	       			</tr>
	       		</thead>
	       		<tbody>
	       			<tr>
	       				<td class="tc" rowspan="<c:out value="${userTypeSize + 2}" />"><c:out value="${uuivo.deptNm}" /></td>
	       				<td class="tc" rowspan="<c:out value="${userTypeSize + 2}" />"><c:out value="${uuivo.userId}" /></td>
	      				<td class="tc" rowspan="<c:out value="${userTypeSize + 2}" />"><c:out value="${uuivo.userNm}" /></td>
	       				<td class="p0 m0"></td>
	       				<td class="p0 m0"></td>
	       			</tr>
	       			<c:set var="checkedYn" value="N" />
	       			<c:forEach var="row" items="${userTypeList}" varStatus="status">
	       				<c:set var="authGrpCdChecked" value="" />
	   					<c:if test="${uuivo.wwwAuthGrpCd.contains(row.codeCd)}">
	   						<c:set var="authGrpCdChecked" value="checked" />
	   						<c:set var="checkedYn" value="Y" />
	   					</c:if>
	   				<tr>
	       				<td>
	       					<div class="ui radio checkbox">
								<input type="radio" name="authGrpCd" class="hidden" value="<c:out value="${row.codeCd}" />" <c:out value="${authGrpCdChecked}" /> />
								<label><c:out value="${row.codeNm}" /></label>
							</div>
	       				</td>
	       				<td>
	       					<c:out value="${row.codeCd}" />
	       				</td>
	       			</tr>
	       			</c:forEach>
					<tr>
						<td>
							<c:if test="${checkedYn eq 'N'}">
								<c:set var="authGrpCdChecked" value="checked" />
							</c:if>
							<div class="ui radio checkbox">
								<input type="radio" name="authGrpCd" class="hidden" value="" <c:out value="${authGrpCdChecked}" /> />
								<label>해당없음</label>
							</div>
						</td>
						<td></td>
					</tr>
				</tbody>
			</table>
        </div>
		<div class="bottom-content mt50">
			<button type="button" class="ui blue button" onclick="save()"><spring:message code="user.button.confirm" /></button><!-- 확인 -->
		    <button type="button" class="ui basic blue button" onclick="window.parent.closeModal();"><spring:message code="user.button.cancel" /></button><!-- 취소 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
