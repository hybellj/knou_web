<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="fileuploader"/>
    </jsp:include>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    const isTeamAsmt = "${vo.teamAsmtStngyn}" === "Y";

    const excelExampleGrid = {
        colModel: [
            {label: "<spring:message code='asmt.label.dept.nm'/><%--학과--%>", name: "deptnm", align: "left", width: "5000", colums: "A"},
            {label: "<spring:message code='asmt.label.login.id'/><%--사용자ID--%>", name: "userId", align: "left", width: "5000", colums: "B"},
            {label: "<spring:message code='asmt.label.stdnt_no'/><%--학번--%>", name: "stdntNo", align: "left", width: "5000", colums: "C"},
            {label: "<spring:message code='asmt.label.user_nm'/><%--이름--%>", name: "usernm", align: "left", width: "5000", colums: "D"},
            {label: "<spring:message code='asmt.label.eval.score'/><%--평가점수--%>", name: "scr", align: "right", width: "5000", colums: "E"}
        ]
    };

    const teamExcelExampleGrid = {
        colModel: [
            {label: "<spring:message code='asmt.label.team.name'/><%--팀명--%>", name: "teamnm", align: "left", width: "5000", colums: "A"},
            {label: "<spring:message code='asmt.label.login.id'/><%--사용자ID--%>", name: "userId", align: "left", width: "5000", colums: "B"},
            {label: "<spring:message code='asmt.label.stdnt_no'/><%--학번--%>", name: "stdntNo", align: "left", width: "5000", colums: "C"},
            {label: "<spring:message code='asmt.label.user_nm'/><%--이름--%>", name: "usernm", align: "left", width: "5000", colums: "D"},
            {label: "<spring:message code='asmt.label.role'/><%--역할--%>", name: "memberRole", align: "left", width: "5000", colums: "E"},
            {label: "<spring:message code='asmt.label.eval.score'/><%--평가점수--%>", name: "scr", align: "right", width: "5000", colums: "F"}
        ]
    };

    function getExcelGrid() {
        return isTeamAsmt ? teamExcelExampleGrid : excelExampleGrid;
    }

    function asmtScrExcelUpload() {
        const dx = dx5.get("fileUploader");
        const data = {
            asmtId: "${vo.asmtId}",
            uploadFiles: dx.getUploadFiles(),
            uploadPath: dx.getUploadPath(),
            excelGrid: JSON.stringify(getExcelGrid())
        };

        ajaxCall("/asmt2/profAsmtScrExcelUpload.do", data, function (data) {
            if (data.result > 0) {
                window.parent.getAsmtEvlList();
                window.parent.closeDialog();
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function () {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
        }, true);
    }

    function sampleExcelDown() {
        $("#excelGrid").val(JSON.stringify(getExcelGrid()));
        $("#asmtScrRegistForm").attr("target", "exampleExcelDownloadIfm");
        $("#asmtScrRegistForm").attr("action", "/asmt2/profAsmtScrRegistSampleExcelDown.do");
        $("#asmtScrRegistForm").submit();
    }

    function saveConfirm() {
        const dx = dx5.get("fileUploader");
        if (dx.availUpload()) {
            dx.startUpload();
        }
    }

    function finishUpload() {
        const dx = dx5.get("fileUploader");
        const data = {
            uploadFiles: dx.getUploadFiles(),
            uploadPath: dx.getUploadPath()
        };

        ajaxCall("/common/uploadFileCheck.do", data, function (data) {
            if (data.result > 0) {
                asmtScrExcelUpload();
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }
        }, function () {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
        });
    }
</script>

<form id="asmtScrRegistForm" name="asmtScrRegistForm" method="POST">
    <input type="hidden" name="asmtId" value="${vo.asmtId}"/>
    <input type="hidden" name="excelGrid" value="" id="excelGrid"/>
</form>

<body class="modal-body">
<div class="msg-box">
    <p class="txt"><spring:message code='asmt.excel.upload.warning.title.msg'/><%--주의사항--%></p>
    <ul class="list-dot">
        <li><span><spring:message code='asmt.excel.upload.warning.msg1'/><%--xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다.--%></span></li>
        <li><span><spring:message code='asmt.excel.upload.warning.msg2'/><%--잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다.--%></span></li>
        <li><span><spring:message code='asmt.excel.upload.warning.msg3'/><%--샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요.--%></span></li>
        <li><span><spring:message code='asmt.excel.upload.warning.msg4'/><%--자료를 작성하실 때 항목은 빈란으로 두지 마세요.--%></span></li>
    </ul>
</div>
<div class="board_top">
    <button type="button" class="btn basic" onclick="sampleExcelDown()"><spring:message code='asmt.button.excel.sample.down'/><%--엑셀 샘플 다운로드--%></button>
</div>
<div id="fileUploadBlock">
    <uiex:dextuploader
            id="fileUploader"
            path="${vo.uploadPath}"
            limitCount="1"
            limitSize="100"
            oneLimitSize="100"
            listSize="3"
            finishFunc="finishUpload()"
            allowedTypes="xlsx"
    />
</div>

<div class="modal_btns">
    <button type="button" class="btn type1" onclick="saveConfirm()"><spring:message code='asmt.button.reg'/><%--등록--%></button>
    <button type="button" class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='asmt.button.close'/><%--닫기--%></button>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>

<iframe width="100%" scrolling="no" id="exampleExcelDownloadIfm" name="exampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
