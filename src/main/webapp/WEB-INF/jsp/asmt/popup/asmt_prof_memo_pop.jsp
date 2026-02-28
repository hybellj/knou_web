<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    $(document).ready(function () {
    });

    // 메모 저장
    function savescrMemo() {
        var url = "/asmt/profAsmtMemoModify.do";
        var data = {
            "asmtId": "${gVo.asmtId}",
            "stdNo": "${gVo.stdNo}",
            "scrMemo": $("#scrMemo").val()
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("<spring:message code='asmnt.alert.memo.insert' />");// 메모 저장이 완료되었습니다.
                window.parent.listAsmntUser(1);
                window.parent.closeModal();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='asmnt.alert.memo.error' />");// 메모 저장 중 에러가 발생하였습니다.
        }, true);
    }
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap">
    <div class="option-content">
        <h2 class="page-title">${cVo.crsCreNm } (${cVo.declsNo }<spring:message code="asmnt.label.decls.name"/>)</h2>
        <!-- 반 -->
        <div class="mla fcBlue">
            <ul class="list_verticalline  ">
                <li>${gVo.deptNm }</li>
                <li>${gVo.userNm }( ${gVo.userId } )</li>
                <c:if test="${gVo.scr ne '' && gVo.scr ne NULL}">
                    <li>
                        ${gVo.scr}<spring:message code="asmnt.label.point" /><!-- 점 -->
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
    <div>
        <textarea id="scrMemo" rows="10" cols="30">${gVo.scrMemo}</textarea>
        <c:if test="${not empty gVo.modDttm}">
            <fmt:parseDate var="modDttmFmt" pattern="yyyyMMddHHmmss" value="${gVo.modDttm}"/>
            <fmt:formatDate var="modDttm" pattern="yyyy.MM.dd HH:mm" value="${modDttmFmt}"/>
            <div class="fcRed">${modDttm} <spring:message code="common.button.save" /><!-- 저장 --></div>
        </c:if>
    </div>

    <div class="bottom-content mt70">
        <button class="ui blue button" onclick="savescrMemo()"><spring:message code="asmnt.button.save"/></button>
        <!-- 저장 -->
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="asmnt.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>