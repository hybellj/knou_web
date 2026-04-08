<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
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

	<body class="modal-page">
        <div id="wrap">

            <div class="table_list">
                <ul class="list" style="min-height: 200px;">
                    <li class="head"><label>신청사유</label></li>
                    <li>${mrkObjctAplyVO.objctAplyCts}</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>자료첨부</label></li>
                    <li>
                    <%--<c:forEach items="mrkObjctAplyVO.fileList" var="item">
                        <button class='ui icon small button' id="item.fileSn" title='파일다운로드' onclick="fileDown('item.fileSn', 'item.repoCd')"><i class='ion-android-download'></i></button>
                    </c:forEach>--%>
                        <c:if test="${not empty mrkObjctAplyVO.fileList}">
                            <div class="add_file_list">
                                <uiex:filedownload fileList="${mrkObjctAplyVO.fileList}"/>
                            </div>
                        </c:if>
                        <c:if test="${empty mrkObjctAplyVO.fileList}">
                            <small>첨부된 파일이 없습니다.</small>
                        </c:if>
                    </li>
                </ul>
            </div>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
