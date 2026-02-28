<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    $(document).ready(function () {
    });

    function closeModal() {
        window.parent.closeModal();
    }
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap">

    <div class="ui form pdf-viewer">
        <ul class='tbl'>
            <li>
                <dl>
                    <dt><spring:message code="asmnt.label.send.file"/><!-- 제출파일 --></dt>
                    <dd>
                        <c:forEach items="${vo.fileList }" var="item" varStatus="status">
                            <button class="ui icon small button" id="file_${item.fileSn }"
                                    title="<spring:message code='asmnt.label.attachFile.download'/>"
                                    onclick="fileDown('${item.fileSn}', '${item.repoCd }')">
                                <i class="ion-android-download"></i>
                            </button>
                            <script>
                                byteConvertor("${item.fileSize}", "${item.fileNm}", "file_${item.fileSn}");
                            </script>
                        </c:forEach>
                    </dd>
                </dl>
            </li>
        </ul>
        <div class="flex flex-column scrollArea">
            <div class="flex1 flex-column mediaArea" style="display: flex; ">
                <c:forEach items="${vo.fileList }" var="item" varStatus="status">
                    <c:if test="${item.fileExt == 'pdf' || item.fileExt == 'txt'}">
                        <iframe class="item" width="100%" title="<spring:message code='crs.label.asmnt' />"
                                src="${item.fileView}"></iframe>
                        <!-- 과제 -->
                    </c:if>
                    <c:if test="${item.fileExt == 'png' || item.fileExt == 'gif' ||item.fileExt == 'jpg'}">
                        <div class='item'><img src='${item.fileView}' alt='과제' aria-hidden='true'></div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="bottom-content">
        <button class="ui black cancel button" onclick="closeModal();"><spring:message
                code="team.common.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>