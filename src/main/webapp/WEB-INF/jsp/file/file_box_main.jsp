<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    // 페이지 초기화
    $(document).ready(function() {
        //파일함 트리 화면 호출
        getFileBoxUseRate();
        getFileBoxTree();
        getFileUploadPopup();
    });

    /**
     *  파일함 트리 화면 호출
     */
    function getFileBoxTree() {
        $('#fileBoxTreeBlock').load(
            "/file/fileHome/fileBoxTree.do"
            , {}
            , function () {}
        );
    }

    /**
     *  검색 처리
     */
     function keyDownFileBoxSearch() {
        if(window.event.keyCode == 13) {
            getFileListInsideFolder('', $("#searchValue").val());
        }
    }

    /**
     *  검색버튼 클릭 처리
     */
    function clickFileBoxSearch(flag) {
        if (flag) {
            getFileListInsideFolder('', $("#searchValue").val());
        } else {
            getFileListInsideFolder($("#currFileBoxCd").val(), $("#searchValue").val());
        }
    }

    /**
     *  파일함 리스트 화면 호출
     */
    function getFileListInsideFolder(folderId, searchValue) {
        $("#currFileBoxCd").val(folderId == 'ROOT'?'':folderId);
        $('#fileBoxListBlock').load(
            "/file/fileHome/fileBoxList.do"
            , {
                "searchValue" : searchValue
              , "selectedFileBoxCd" : folderId
              }
            , function () {}
        );
    }

    /**
     *  폴더 생성 버튼 클릭
     */
    function createFolder() {
        $("#newFileBoxCreateRow").show();
    }

    /**
     * 파일함 삭제 버튼 클릭
     */
    function deleteFileBox() {
        if ($("input:checkbox[name=fileBoxCds]:checked").length == 0) {
            return;
        }

        $("#alert-box").prop("class","warning");
        $("#alert-box p").text("<spring:message code="filebox.confirm.filedel" />"); // 선택한 폴더(파일)을 삭제하시겠습니까?
        $("#alertOk").attr("href","javascript:deleteFileBoxProcess(); $('#alert-box').removeClass('on');");
        $("#alertNo").attr("href","javascript:$('#alert-box').removeClass('on');");
        $("#alert-btn").trigger("click");
    }

    /**
     * 파일함 삭제 처리
     */
    function deleteFileBoxProcess() {
        if ($("input:checkbox[name=fileBoxCds]:checked").length == 0) {
            return;
        }

        $("#loading_page").show();

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : $("#checkFileBoxForm").serialize(),
            url : "/file/fileHome/delete/fileBox.do",
            success : function(data){
                if(data.result > 0) {
                    getFileBoxTree();
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            },
            beforeSend: function() {
            },
            complete:function(status){
                $("#loading_page").hide();
            },
            error: function(xhr,  Status, error) {
                $("#loading_page").hide();
            }
        });
    }

    /**
     * 파일함 사용률 조회
     */
    function getFileBoxUseRate() {

        $("#loading_page").show();

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : {},
            url : "/file/fileHome/fileUseRate.do",
            success : function(data){
                if (data.result > 0) {
                    var rateStr = '<spring:message code="filebox.label.main.nolimit" />'; // 무제한
                    var fileUseRate = 0;
                    if (data.returnVO.fileLimitSize < 999999999) { // 무제한이 아닌겨우
                        fileUseRate = data.returnVO.fileUseRate;
                        rateStr = data.returnVO.fileUseSize + 'MB / ' + data.returnVO.fileLimitSize + 'MB (' + data.returnVO.fileUseRate + '% <spring:message code="filebox.label.main.use" />)'; // 사용중
                    }

                    $("#fileBoxUseRateBlock").attr("data-percent", fileUseRate);
                    $("#fileBoxUseRate").text(rateStr);
                    $('#fileBoxUseRateBlock').progress({
                        percent: fileUseRate>100?100:fileUseRate
                    });
                }
            },
            beforeSend: function() {
            },
            complete:function(status){
                $("#loading_page").hide();
            },
            error: function(xhr,  Status, error) {
                $("#loading_page").hide();
            }
        });
    }

    /**
     *  파일함 파일첨부 영역 호출
     */
    function getFileUploadPopup() {
        $('#fileBoxUploadBlock').load("/home/fileUploadHome/panel.do"
            , {   "fileUploadAreaId" : "fileBoxUploadBlock"
                , "repoCd" : "FILE_BOX"
                , "maxCnt" : "100"
                , "bindDataSn" : ""
                , "crsCreCd" : ""
                , "bbsSn" : ""
                , "allowFileExt" : ""
                , "useFileBoxYn" : "N"
              }
            , function () {}
        );
    }

    /**
     * 파일함에 파일 등록 처리
     */
    function insertFileBoxProcess() {
        if (!atchFilesfileBoxUploadBlock.getFileSnAll()) {
            $("#note-box").removeClass("warning");
            $("#note-box p").text('<spring:message code="filebox.alert.choose.file" />');
            $("#note-btn").trigger("click");
            return;
        }

        $("#attachFileSns").val(atchFilesfileBoxUploadBlock.getFileSnAll());

        $("#loading_page").show();

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : {
                       "attachFileSns" : $("#attachFileSns").val()
                     , "parFileBoxCd" : $("#currFileBoxCd").val()
                   },
            url : "/file/fileHome/add/fileBox/file.do",
            success : function(data){
                if(data.result > 0) {
                    getFileBoxTree();
                    getFileBoxUseRate();
                    $("#note-box").removeClass("warning");
                    $("#note-box p").text('<spring:message code="filebox.alert.file_upload.success" />');
                    $("#note-btn").trigger("click");
                    $('.modal').modal('hide');
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            },
            beforeSend: function() {
            },
            complete:function(status){
                $("#loading_page").hide();
            },
            error: function(xhr,  Status, error) {
                $("#loading_page").hide();
            } 
        }); 

    }
</script>

<div id="context">
    <div id="info-item-box">
        <h2 class="page-title"><spring:message code="common.label.filebox" /></h2> <!-- 파일함 -->
        <div class="button-area">
            <a href="javascript:;" class="btn" onClick="createFolder()"><spring:message code="filebox.button.create.foler" /></a> <!-- 폴더생성 -->
            <a href="#0" class="btn btn-primary" data-toggle="modal" data-target="#fileBoxUploadPopup" onClick="getFileUploadPopup()"><spring:message code="button.upload" /></a> <!-- 업로드 -->
            <a href="javascript:;" class="btn btn-negative" onClick="deleteFileBox()"><spring:message code="button.delete" /></a> <!-- 삭제 -->
        </div>
    </div>
    <div class="option-content">
        <div class="ui action input search-box">
            <input type="text" placeholder="<spring:message code="button.search" />" id="searchValue" name="searchValue" maxlength="50" onKeydown="keyDownFileBoxSearch()"> <!-- 검색 -->
            <input type="hidden" id="currFileBoxCd" name="currFileBoxCd" >
            <input type="hidden" name="attachFileSns" id="attachFileSns" value="">
            <button type="button" class="ui icon button" id="btnFileBoxSearch" onClick="clickFileBoxSearch('SEARCH')">
                <i class="search icon"></i>
            </button>
        </div>
        <div class="button-area file-bar">
            <div class="ui blue small progress" data-percent="0" id="fileBoxUseRateBlock">
                <div class="bar"></div>
                <div class="label" id="fileBoxUseRate">0MB / 0MB (0% <spring:message code="filebox.label.main.use" />)</div> <!-- 사용중 -->
            </div>
        </div>
    </div>
    <div class="grid-main">
        <div class="grid-main-box border-type size_2 tblet_fluid" id="fileBoxTreeBlock">
        </div>
        <div class="grid-main-box border-type size_4 tblet_fluid" id="fileBoxListBlock">
        </div>
    </div>
</div>

<!-- 업로드 팝업 -->
<div class="modal fade" id="fileBoxUploadPopup" tabindex="-1" role="dialog" aria-labelledby="모달영역" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="button.close" />" onClick="fileUploadPopupClose()"> <!-- 닫기 -->
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><spring:message code="button.upload" /></h4> <!-- 업로드 -->
            </div>
            <div class="modal-body" >
                <div class="modal-page">
                    <div id="wrap">
                        <div class="ui form" id="fileBoxUploadBlock">
                        </div>
                        <div class="bottom-content">
                            <button type="button" class="ui blue button" onclick="insertFileBoxProcess();"><spring:message code="button.write" /></button> <!-- 등록 -->
                            <button type="button" class="ui black cancel button" onclick="fileUploadPopupClose();"><spring:message code="button.close" /></button> <!-- 닫기 -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function fileUploadPopupClose() {
        var tempFileSnsStr =  atchFilesfileBoxUploadBlock.getFileSnAll();
        var tempFileSnsArr = tempFileSnsStr.split('!@!');
        $.each(tempFileSnsArr, function(key, value) {
            if ($.trim(value)) {
                $.post(Context.FILE_DELETE + value);
            }
        });
        $('.modal').modal('hide');
    }
</script>
<!-- 업로드 팝업 -->
