<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
    </jsp:include>
</head>


<script type="text/javascript">

    let EPARAM = '<c:out value="${encParams}" />';

    /**
     * 메모 저장
     */
    function saveProfMemo() {
        const url = "/asmt2/profAsmtMemoModifyAjax.do";
        const extData = {
            "asmtId": "${asmtVO.asmtId}",
            "userId": "${asmtAtndlcVO.userId}",
            "teamId": "${asmtAtndlcVO.teamId}",
            "asmtEvlId": "${asmtAtndlcVO.asmtEvlId}",
            "evlMemo": $("#profMemo").val()
        };
        const param = {
            encParams: EPARAM
            , addParams: UiComm.makeEncParams(extData)
        };


        ajaxCall(url, param, function (data) {
            if (data.encParams != null && data.encParams != '') {
                EPARAM = data.encParams;
            }

            if (data.result > 0) {
                UiComm.showMessage("<spring:message code='asmt.alert.memo.insert' /><%--메모 저장이 완료되었습니다.--%>", "success");// 메모 저장이 완료되었습니다.
                window.parent.getAsmtEvlList();
                window.parent.closeDialog();
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function (xhr, status, error) {
            UiComm.showMessage("<spring:message code='asmt.alert.memo.error' /><%--메모 저장 중 에러가 발생하였습니다. 잠시 후 다시 진행해 주세요.--%>", "error");// 메모 저장 중 에러가 발생하였습니다.
        }, true);
    }
</script>

<body class="modal-page">
<div class="board_top class">
    <%
        String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
    %>
    <h3 class="board-title"><%=sbjctnm%>${asmtVO.dvclasNo }<spring:message code='asmt.label.decls.name'/><%--반--%>
    </h3>
    <div class="right-area">
        <div class="feedback-info">
            <p class="desc">
                <span><strong>${asmtAtndlcVO.deptnm }</strong></span>
                <span><strong>${asmtAtndlcVO.userId }</strong></span>
                <span><strong>${asmtAtndlcVO.usernm }</strong></span>
                <c:if test="${asmtAtndlcVO.scr ne '' && asmtAtndlcVO.scr ne NULL && asmtVO.mrkOyn eq 'Y'}">
                    <span class="score"><strong>${asmtAtndlcVO.scr}<spring:message code='asmt.label.point'/><!-- 점 --></strong></span>
                </c:if>
            </p>
        </div>
    </div>
</div>
<div class="table-wrap mt10">
    <table class="table-type5 in_table">
        <tbody>
        <tr>
            <td>
                <textarea id="profMemo" class="form-control width-100per min-height-200px" maxLenCheck="byte,4000,true,true">${asmtAtndlcVO.evlMemo}</textarea>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<div class="modal_btns">
    <button class="btn type1" onclick="saveProfMemo()"><spring:message code='asmt.button.save'/><%--저장--%></button><!-- 저장 -->
    <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='asmt.button.close'/><%--닫기--%></button><!-- 닫기 -->
</div>
</body>
</html>
