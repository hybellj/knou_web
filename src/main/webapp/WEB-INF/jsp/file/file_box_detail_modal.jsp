<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript">
    // 페이지 초기화
    $(document).ready(function() {
    });
</script>

    <body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <div class="ui form">
                <div class="fields">
                    <div class="four wide field"><label><spring:message code="common.label.list.filenm" /></label></div> <!-- 파일명 -->
                    <div class="twelve wide field"><c:out value='${resultVo.fileBoxFullNm}' /></div>
                </div>
                <div class="fields">
                    <div class="four wide field"><label><spring:message code="filebox.label.pop.kind" /></label></div> <!-- 종류 -->
                    <div class="twelve wide field"><c:out value='${resultVo.fileBoxTypeNm}' /></div>
                </div>
                <div class="fields">
                    <div class="four wide field"><label><spring:message code="common.label.list.size" /></label></div> <!-- 크기 -->
                    <div class="twelve wide field"><c:out value='${resultVo.fileSizeFormatted}' /></div>
                </div>
                <div class="fields">
                    <div class="four wide field"><label><spring:message code="common.label.list.createdt" /></label></div> <!-- 생성일 -->
                    <div class="twelve wide field">
                        <fmt:parseDate var="regDt" pattern="yyyyMMddHHmmss" value="${resultVo.regDt }" />
                        <fmt:formatDate pattern="yyyy.MM.dd(HH:mm)" value="${regDt}" />
                    </div>
                </div>
                <div class="fields">
                    <div class="four wide field"><label>URL</label></div>
                    <div class="twelve wide field" style="word-break:break-all"><c:out value='${resultVo.downloadUrl}' /></div>
                </div>
                <div class="fields">
                    <div class="four wide field"><label><spring:message code="filebox.label.pop.path" /></label></div> <!-- 경로 -->
                    <div class="twelve wide field">
                    <c:forEach items="${fullFolderPath }" var="path" varStatus="idx">
                        <c:if test="${idx.index > 0}">
                            <i class="ion-ios-arrow-forward"></i>
                        </c:if>
                        <c:out value='${path}' />
                    </c:forEach>
                    </div>
                </div>
            </div>
            <div class="bottom-content">
                <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="button.close" /></button> <!-- 닫기 -->
            </div>
        </div>
        <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
