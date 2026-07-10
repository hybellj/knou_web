<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>
</head>

<body class="modal-page ${uiex:getTheme()}">
	<div id="wrap">
		<div id="list"></div>

		<script type="text/javascript">
			var teamMemberRows = [
				<c:forEach var="item" items="${teamMemberList}" varStatus="status">
				{
					no: "${status.count}",
					userNm: "<c:out value='${item.userNm}'/>",
					roleNm: "${item.leaderYn}" == "Y" ? "<spring:message code='forum.label.team.leader'/>" /*팀장*/: "<spring:message code='forum.label.team.member'/>"/*팀원*/
				}<c:if test="${!status.last}">,</c:if>
				</c:forEach>
			];

			let teamMemberTable = UiTable("list", {
				lang: "ko",
				height: 300,
				data: teamMemberRows,
				placeholder: "<spring:message code='forum.common.empty'/>",
				columns: [
					{title:"<spring:message code='common.number.no' />"/*NO.*/, field:"no", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
					{title:"<spring:message code='forum.label.user_nm'/>"/*이름*/, field:"userNm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:80},
					{title:"<spring:message code='forum.label.type'/>"/*구분*/, field:"roleNm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:80}
				]
			});
		</script>

		<div class="btns">
			<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='forum.button.close'/></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
