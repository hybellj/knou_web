<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    // 페이지 초기화
    $(document).ready(function() {
        //파일함 트리 화면 호출
        getFileBoxTree();
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
     *  파일함의 파일 가져오기 
     */
    function importFileFromFileBox() {
        var $fileBoxCds = $("input:checkbox[name=fileBoxCds][data-fileBoxType!=FOLDER]:checked");
        var cnt = $fileBoxCds.length;
        if (cnt  == 0) {
            return;
        }

        if (typeof window.parent.copyAndAddFileFromFileBox == 'function') {
            $fileBoxCds.each(function (idx) {
                var fileData = new Object();
                fileData.encFileSn = $(this).attr("data-encFileSn");
                if ($(this).attr("data-fileType") == 'TRANSFER') {
                    fileData.size = '0';
                } else {
                    fileData.size = $(this).attr("data-size");
                }
                fileData.ext = $(this).attr("data-ext");
                window.parent.copyAndAddFileFromFileBox(fileData);
            });

            $("input:checkbox[name=fileBoxCds]").prop("checked", false);
            $("#note-box").removeClass("class", "warning");
            $("#note-box p").text("<spring:message code="filebox.alert.imported.file" />"); // 파일을 가져왔습니다.
            $("#note-btn").trigger("click");
        }
    }
</script>


<div id="wrap" class="result-content">
    <div class="content">

            <div id="context">
                <div class="option-content">
                    <div class="ui action input search-box">
                        <input type="text" placeholder="<spring:message code="button.search" />" id="searchValue" name="searchValue" maxlength="50" onKeydown="keyDownFileBoxSearch()"> <!-- 검색 -->
                        <input type="hidden" id="currFileBoxCd" name="currFileBoxCd" >
                        <input type="hidden" name="attachFileSns" id="attachFileSns" value="">
                        <button type="button" class="ui icon button" id="btnFileBoxSearch" onClick="clickFileBoxSearch('SEARCH')">
                            <i class="search icon"></i>
                        </button>
                    </div>
                    <div class="button-area">
                        <button type="button" class="ui blue button" onClick="importFileFromFileBox()"><spring:message code="common.button.copy" /></button> <!-- 가져오기 -->
                    </div>
                </div>
                <div class="grid-main">
                    <div class="grid-main-box border-type size_2 tblet_fluid" id="fileBoxTreeBlock">
                    </div>
                    <div class="grid-main-box border-type size_4 tblet_fluid" id="fileBoxListBlock">
                    </div>
                </div>
            </div>

    </div>
    <div class="bottom-content">
        <button type="button" class="ui blue button" onClick="importFileFromFileBox()"><spring:message code="common.button.copy" /></button> <!-- 가져오기 -->
        <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="button.close" /></button> <!-- 닫기 -->
    </div>

    <a href="#0" id="alert-btn" class="ui red button alert-btn" style="display: none;"><spring:message code="common.confirm.pop" /></a> <!-- 선택 경고창 -->
    <div id="alert-box" class="warning"><p style="display: inline-block;"></p>
        <a href="#0" id="alertOk" class="ui inverted small button w80 ml20"><spring:message code="message.yes" /></a> <!-- 네 -->
        <a href="#0" id="alertNo" class="ui inverted small button w80"><spring:message code="message.no" /></a> <!-- 아니오 -->
        <a id="close2"><i class="ion-ios-close-empty"></i></a>
    </div>

    <a href="#0" id="note-btn" class="ui red button note-btn" style="display: none;"><spring:message code="common.alert.pop" /></a> <!-- 확인 경고창 -->
    <div id="note-box" class=""><p></p><a id="close1"><i class="ion-ios-close-empty"></i></a></div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
