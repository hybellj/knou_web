<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
	            <div class="mla fcBlue">
	            	<b>${quizExamnee.deptnm } ${quizExamnee.stdntNo } ${quizExamnee.usernm } <span class="f150">${quizExamnee.totScr }<spring:message code="exam.label.score.point" /></span></b><!-- 점 -->
	            </div>
        	</div>
			<hr/>
			<div id="eventDiv" class="logDiv">
				<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
							<th scope="col" class="tc"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
							<th scope="col" class="tc">대표아이디</th>
							<th scope="col" class="tc">학번</th>
							<th scope="col" class="tc">이름</th>
							<th scope="col" class="tc"><spring:message code="exam.label.log" /></th><!-- 로그 -->
							<th scope="col" class="tc"><spring:message code="exam.label.reg.dttm" /></th><!-- 등록일시 -->
							<th scope="col" class="tc">IP</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${tkexamHstryList }">
							<fmt:parseDate var="regDateFmt" pattern="yyyyMMddHHmmss" value="${list.regDttm }" />
							<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd HH:mm" value="${regDateFmt }" />
							<tr>
								<td>${list.lineNo }</td>
								<td>${list.deptnm }</td>
								<td>${list.userRprsId }</td>
								<td>${list.stdntNo }</td>
								<td>${list.usernm }</td>
								<td>${list.hstryGbnnm }</td>
								<td>${regDttm }</td>
								<td>${list.connIp }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
