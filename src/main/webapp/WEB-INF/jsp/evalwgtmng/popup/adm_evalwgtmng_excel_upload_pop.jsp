<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="fileuploader"/>
    </jsp:include>
    <script type="text/javascript">
        var CTX = '<%=request.getContextPath()%>';

        var excelExampleGrid = {
            colModel: [
                {label: '기관', name: 'orgNm', align: 'left', width: '5000', colums: 'A'},
                {label: '년도', name: 'haksaYear', align: 'left', width: '3000', colums: 'B'},
                {label: '학기(기수)', name: 'haksaTerm', align: 'left', width: '3000', colums: 'C'},
                {label: '과목코드', name: 'crclmnNo', align: 'left', width: '4000', colums: 'D'},
                {label: '과목명', name: 'sbjctNm', align: 'left', width: '7000', colums: 'E'},
                {label: '평가항목', name: 'mrkItmTycd', align: 'left', width: '5000', colums: 'F'},
                {label: '평가비중', name: 'mrkRfltrt', align: 'right', width: '3000', colums: 'G'},
                {label: '공개여부', name: 'mrkOyn', align: 'left', width: '3000', colums: 'H'}
            ]
        };

        function sampleExcelDown() {
            ajaxCall(CTX + '/evalwgtmng/admCheckEvalWgtMngExcelSample.do', {
                orgId: $('#orgId').val(),
                haksaYear: $('#haksaYear').val(),
                haksaTerm: $('#haksaTerm').val(),
                sbjctId: $('#sbjctId').val(),
                searchValue: $('#searchValue').val()
            }, function(data) {
                if (data.result > 0) {
                    $('#excelGrid').val(JSON.stringify(excelExampleGrid));
                    $('#evalWgtMngExcelUploadForm').attr('target', 'exampleExcelDownloadIfm');
                    $('#evalWgtMngExcelUploadForm').attr('action', CTX + '/evalwgtmng/admEvalWgtMngExcelUploadSampleDownload.do');
                    $('#evalWgtMngExcelUploadForm').submit();
                    return;
                }

                UiComm.showMessage(data.message || '엑셀 샘플을 생성할 수 없습니다.', 'warning');
            }, function() {
                UiComm.showMessage('엑셀 샘플을 생성할 수 없습니다.', 'error');
            }, true);
        }

        function saveConfirm() {
            var fileUploader = dx5.get('fileUploader');
            if (!fileUploader || !fileUploader.availUpload()) {
                UiComm.showMessage('업로드할 엑셀 파일을 선택해 주세요.', 'warning');
                return;
            }

            fileUploader.startUpload();
        }

        function finishUpload() {
            var fileUploader = dx5.get('fileUploader');

            ajaxCall(CTX + '/common/uploadFileCheck.do', {
                uploadFiles: fileUploader.getUploadFiles(),
                uploadPath: fileUploader.getUploadPath()
            }, function(data) {
                if (data.result > 0) {
                    uploadEvalWgtMngExcel(fileUploader.getUploadFiles(), fileUploader.getUploadPath());
                } else {
                    UiComm.showMessage('엑셀 파일 업로드에 실패했습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('엑셀 파일 업로드에 실패했습니다.', 'error');
            }, true);
        }

        function uploadEvalWgtMngExcel(uploadFiles, uploadPath) {
            ajaxCall(CTX + '/evalwgtmng/admEvalWgtMngExcelUpload.do', {
                orgId: $('#orgId').val(),
                haksaYear: $('#haksaYear').val(),
                haksaTerm: $('#haksaTerm').val(),
                excelGrid: JSON.stringify(excelExampleGrid),
                uploadFiles: uploadFiles,
                uploadPath: uploadPath
            }, function(data) {
                if (data.result > 0) {
                    UiComm.showMessage(data.message || '평가비중 엑셀 등록이 완료되었습니다.', 'success');
                    if (window.parent && typeof window.parent.fn_search === 'function') {
                        window.parent.fn_search();
                    }
                    if (window.parent && typeof window.parent.closeDialog === 'function') {
                        window.parent.closeDialog();
                    }
                } else {
                    UiComm.showMessage(data.message || '엑셀 등록 중 오류가 발생했습니다.', 'error');
                }
            }, function() {
                UiComm.showMessage('엑셀 등록 중 오류가 발생했습니다.', 'error');
            });
        }
    </script>
</head>

<body class="modal-page">
<div id="wrap">
    <div class="msg-box basic margin-bottom-4">
        <p class="txt">엑셀 파일로 과목별 평가비중 정보를 일괄 등록합니다.</p>
        <ul class="list-dot">
            <li><span>샘플 파일의 열 순서와 제목은 변경하지 마세요.</span></li>
            <li><span>샘플에는 현재 검색조건의 과목과 평가항목이 포함됩니다.</span></li>
            <li><span>년도, 학기(기수), 과목코드, 과목명, 평가항목, 평가비중은 필수입니다.</span></li>
            <li><span>한 과목의 사용 평가항목 비중 합계는 100이어야 합니다.</span></li>
            <li><span>성적공개여부는 공개 또는 비공개로 입력해 주세요. 비워두면 공개로 처리됩니다.</span></li>
        </ul>
    </div>

    <form id="evalWgtMngExcelUploadForm" method="post">
        <input type="hidden" id="orgId" name="orgId" value="<c:out value='${vo.orgId}'/>"/>
        <input type="hidden" id="haksaYear" name="haksaYear" value="<c:out value='${vo.haksaYear}'/>"/>
        <input type="hidden" id="haksaTerm" name="haksaTerm" value="<c:out value='${vo.haksaTerm}'/>"/>
        <input type="hidden" id="sbjctId" name="sbjctId" value="<c:out value='${vo.sbjctId}'/>"/>
        <input type="hidden" id="searchValue" name="searchValue" value="<c:out value='${vo.searchValue}'/>"/>
        <input type="hidden" id="excelGrid" name="excelGrid" value=""/>
    </form>

    <div class="board_top">
        <button type="button" class="btn basic" onclick="sampleExcelDown();">샘플 다운로드</button>
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
        <button type="button" class="btn type1" onclick="saveConfirm();">등록</button>
        <button type="button" class="btn type2" onclick="window.parent.closeDialog();">닫기</button>
    </div>
</div>
<script type="text/javascript" src="<c:url value='/webdoc/js/iframe-content.js'/>"></script>
</body>
<iframe width="100%" scrolling="no" id="exampleExcelDownloadIfm" name="exampleExcelDownloadIfm" style="display: none;"></iframe>
</html>
