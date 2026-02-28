<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<ul class="tbl">
				<li>
					<dl>
						<dt><spring:message code="filebox.label.pop.filenm" /><!-- 파일명 --></dt>
						<dd><c:out value='${resultVo.fileBoxFullNm}' /></dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt><spring:message code="filebox.label.pop.kind" /><!-- 종류 --></dt>
						<dd><c:out value='${resultVo.fileBoxTypeNm}' /></dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt><spring:message code="filebox.label.list.size" /><!-- 크기 --></dt>
						<dd><c:out value="${empty resultVo.fileSizeFormatted ? '-' : resultVo.fileSizeFormatted}" /></dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt><spring:message code="filebox.label.list.createdt" /><!-- 생성일 --></dt>
						<dd>
							<fmt:parseDate var="regDt" pattern="yyyyMMddHHmmss" value="${resultVo.regDt }" />
                    		<fmt:formatDate pattern="yyyy.MM.dd(HH:mm)" value="${regDt}" />
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>URL</dt>
						<dd>
							<c:out value="${empty resultVo.downloadUrl ? '-' : resultVo.downloadUrl}" />
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt><spring:message code="filebox.label.pop.path" /><!-- 경로 --></dt>
						<dd>
							<c:forEach items="${fullFolderPath }" var="path" varStatus="idx">
			                    <c:if test="${idx.index > 0}">
			                        <i class="ion-ios-arrow-forward"></i>
			                    </c:if>
			                    <c:out value='${path}' />
			                </c:forEach>
						</dd>
					</dl>
				</li>
			</ul>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="filebox.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>