<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="fileuploader"/>
    </jsp:include>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    var VALID_UPLOAD_CONTEXT = "${validUploadContext}" == "true";
    var INVALID_UPLOAD_CONTEXT_MESSAGE = "<spring:message code='fail.common.msg'/>"; // 에러가 발생했습니다!

    $(document).ready(function() {
        if(!isValidSbjctOfringStdntExcelUploadContext()) {
            $("#wrap").hide();
            showInvalidContextAndClose();
        }
    });

    // 수강생 엑셀 샘플 다운로드와 업로드에서 공통으로 사용하는 컬럼 매핑 정보.
    var excelGrid = {
        colModel:[
            {label:"<spring:message code='crs.sbjct.ofring.label.stdnt.no'/>", name:"stdntNo", align:"left", width:"7000", colums:"A"} // 학번
        ]
    };

    // 필수 기준값 없이 팝업에 직접 접근한 경우 작업을 차단한다.
    function isValidSbjctOfringStdntExcelUploadContext() {
        return VALID_UPLOAD_CONTEXT
            && "${sbjctAtndlcVO.sbjctId}" != ""
            && "${sbjctAtndlcVO.orgId}" != "";
    }

    // 우회 접근 안내 메시지를 표시한 뒤 가능한 방식으로 팝업을 닫는다.
    function showInvalidContextAndClose() {
        var result = UiComm.showMessage(INVALID_UPLOAD_CONTEXT_MESSAGE, "warning");
        if(result && typeof result.then === "function") {
            result.then(function() {
                closeSbjctOfringStdntExcelUploadPop();
            });
        } else {
            setTimeout(closeSbjctOfringStdntExcelUploadPop, 500);
        }
    }

    // 부모 UiDialog가 있으면 닫고, 단독 창이면 window.close를 시도한다.
    function closeSbjctOfringStdntExcelUploadPop() {
        if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
            window.parent.closeDialog();
            return;
        }
        window.close();
    }

    // 현재 팝업 조건과 컬럼 매핑을 전달하여 수강생 엑셀 샘플을 다운로드한다.
    function sampleExcelDown() {
        if(!isValidSbjctOfringStdntExcelUploadContext()) {
            showInvalidContextAndClose();
            return;
        }

        $("#excelGrid").val(JSON.stringify(excelGrid));
        $("#stdntExcelUploadForm").attr("target", "stdntSampleExcelDownloadIfm");
        $("#stdntExcelUploadForm").attr("action", "/crs/sbjctOfring/admSbjctOfringStdntExcelSampleDownload.do");
        $("#stdntExcelUploadForm").submit();
    }

    // 업로드가 완료된 파일 정보를 수강생 엑셀 파싱 API로 전달한다.
    function uploadSbjctOfringStdntExcel(fileObj) {
        if(!isValidSbjctOfringStdntExcelUploadContext()) {
            showInvalidContextAndClose();
            return;
        }

        var data = {
            sbjctId: "${sbjctAtndlcVO.sbjctId}",
            orgId: "${sbjctAtndlcVO.orgId}",
            uploadFiles: fileObj,
            uploadPath: "${sbjctAtndlcVO.uploadPath}",
            repoCd: "SBJCT",
            excelGrid: JSON.stringify(excelGrid)
        };

        ajaxCall("/crs/sbjctOfring/admSbjctOfringStdntExcelUpload.do", data, function(res) {
            if(res.result > 0) {
                if(window.parent && typeof window.parent.sbjctOfringStdntExcelUploadCallback === "function") {
                    window.parent.sbjctOfringStdntExcelUploadCallback(res.returnList || []);
                }
                closeSbjctOfringStdntExcelUploadPop();
            } else {
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                dx5.get("fileUploader").clearItems();
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
        }, true);
    }

    // 등록 버튼 클릭 시 업로드 대상 파일 존재 여부를 확인하고 DEXT 업로드를 시작한다.
    function saveConfirm() {
        if(!isValidSbjctOfringStdntExcelUploadContext()) {
            showInvalidContextAndClose();
            return;
        }

        var dx = dx5.get("fileUploader");
        if(dx.availUpload()) {
            dx.startUpload();
        } else {
            UiComm.showMessage("<spring:message code='common.excel.upload.warning.msg1'/>", "info"); // xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다.
        }
    }

    // DEXT 업로드 완료 후 서버 임시 파일 검증을 거쳐 실제 엑셀 파싱 처리를 호출한다.
    function finishUpload() {
        if(!isValidSbjctOfringStdntExcelUploadContext()) {
            showInvalidContextAndClose();
            return;
        }

        var dx = dx5.get("fileUploader");
        var data = {
            uploadFiles: dx.getUploadFiles(),
            uploadPath: dx.getUploadPath()
        };

        ajaxCall("/common/admUploadFileCheck.do", data, function(res) {
            if(res.result > 0) {
                uploadSbjctOfringStdntExcel(dx.getUploadFiles());
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        }, function(xhr, status, error) {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        });
    }
</script>

<form id="stdntExcelUploadForm" name="stdntExcelUploadForm" method="POST">
    <input type="hidden" name="sbjctId" value="${sbjctAtndlcVO.sbjctId}" />
    <input type="hidden" name="orgId" value="${sbjctAtndlcVO.orgId}" />
    <input type="hidden" name="excelGrid" value="" id="excelGrid" />
</form>

<body class="modal-page">
    <div id="wrap">
        <div class="msg-box">
            <p class="txt"><strong><spring:message code="common.excel.upload.warning.title.msg" /></strong></p><%-- 주의사항 --%>
            <ul class="list-dot">
                <li><spring:message code="common.excel.upload.warning.msg1" /></li><%-- xlsx 파일만 업로드해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다. --%>
                <li><spring:message code="common.excel.upload.warning.msg2" /></li><%-- 잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다. --%>
                <li><spring:message code="common.excel.upload.warning.msg3" /></li><%-- 샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요. --%>
                <li><spring:message code="common.excel.upload.warning.msg4" /></li><%-- 자료를 작성하실 때 항목은 빈란으로 두지 마세요. --%>
            </ul>
        </div>
        <div class="board_top">
            <button type="button" class="btn basic" onclick="sampleExcelDown()"><spring:message code="crs.button.excel.sample.down" /></button><%-- 엑셀 샘플 다운로드 --%>
        </div>
        <c:if test="${validUploadContext}">
            <div id="fileUploadBlock">
                <uiex:dextuploader
                    id="fileUploader"
                    path="${sbjctAtndlcVO.uploadPath}"
                    limitCount="1"
                    limitSize="100"
                    oneLimitSize="100"
                    listSize="1"
                    finishFunc="finishUpload()"
                    allowedTypes="xlsx"
                    uiMode="simple"
                />
            </div>
        </c:if>

        <div class="btns">
            <button type="button" class="btn type1" onclick="saveConfirm()"><spring:message code="user.button.reg" /></button><%-- 등록 --%>
            <button type="button" class="btn type2" onclick="closeSbjctOfringStdntExcelUploadPop();"><spring:message code="button.close" /></button><%-- 닫기 --%>
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>

<iframe width="100%" scrolling="no" id="stdntSampleExcelDownloadIfm" name="stdntSampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
