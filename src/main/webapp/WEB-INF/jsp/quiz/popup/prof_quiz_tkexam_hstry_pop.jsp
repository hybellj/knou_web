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

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top">
        		<div class="right-area fcBlue">
	            	<b>${quizExamnee.deptnm } ${quizExamnee.stdntNo } ${quizExamnee.usernm } <span class="f150">${quizExamnee.totScr }<spring:message code="message.score" /></span></b><!-- 점 -->
        		</div>
        	</div>
        	<div class="table-wrap overflow-y bd0">
                <table class="table-type3">
                    <colgroup>
                        <col class="width-5per">
                        <col class="width-10per">
                        <col class="width-15per">
                        <col class="width-15per">
                        <col class="">
                        <col class="width-15per">
                        <col class="width-15per">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>NO.</th>
                            <th><spring:message code="common.dept_name" /><!-- 학과 --></th>
                            <th><spring:message code="common.label.student.number" /><!-- 학번 --></th>
                            <th><spring:message code="common.name" /><!-- 이름 --></th>
                            <th><spring:message code="common.label.log" /><!-- 로그 --></th>
                            <th><spring:message code="common.label.reg.dttm" /><!-- 등록일시 --></th>
                            <th>IP</th>
                        </tr>
                    </thead>
                    <tbody>
                    	<c:forEach var="list" items="${tkexamHstryList }">
							<tr>
								<td>${list.lineNo }</td>
								<td>${list.deptnm }</td>
								<td>${list.stdntNo }</td>
								<td>${list.usernm }</td>
								<td>${list.hstryGbnnm }</td>
								<td><uiex:formatDate value="${list.regDttm}" type="datetime"/></td>
								<td>${list.connIp }</td>
							</tr>
						</c:forEach>
                    </tbody>
                </table>
            </div>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
