<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript" src="/webdoc/js/jquery.treeview.js"></script>

<script type="text/javascript">
    // 페이지 초기화
    $(document).ready(function() {
        $("a[name=linkFileBoxFileNm]").draggable();
        $("a[name=linkFileBoxFileNm]").draggable("disable");
    });

    /**
     *  상세정보 보기
     */
     function getFileBoxDetailModal(selectedFileBoxCd) {
        $("#fileBoxDetailForm").find("input:hidden[name=selectedFileBoxCd]").val(selectedFileBoxCd);
        $("#fileBoxDetailForm").attr("target", "modalFileBoxFileDetailIfm");
        $("#fileBoxDetailForm").attr("action", "/file/fileHome/fileBoxDetail.do");
        $("#fileBoxDetailForm").submit();
        //$('#modalFileBoxFileDetailPopup').modal('show');
    }

    /**
     *  클립보드 복사 버튼 클릭
     */
    function clickClipBoard(obj, idx) {
        copyClipBoard($("#fileBoxListRow_" + idx).find("input:hidden[name=downloadUrl]").val());
        $("#note-box").removeClass("class", "warning");
        $("#note-box p").text("<spring:message code="filebox.alert.copy.clipboard" />"); // 클립보드에 복사하였습니다.
        $("#note-btn").trigger("click");
    }

    /**
     *  클립보드 복사
     */
    function copyClipBoard(val) {
        var dummy = document.createElement("textarea");
        document.body.appendChild(dummy);
        dummy.value = val;
        dummy.select();
        document.execCommand("copy");
        document.body.removeChild(dummy);
    }

    /**
     *  전체 선택 / 해제
     */
    $("#checkAllFileBox").on("change", function(event) {
        $("input:checkbox[name=fileBoxCds]").prop("checked", $(this).is(":checked"));
    });

    /**
     *  이름변경  버튼 클릭
     */
    function changeFileNmEditMode(obj, idx) {
        $("#fileBoxListRow_" + idx).find("a[name=linkFileBoxFileNm]").hide();
        $("#fileBoxListRow_" + idx).find("div[name=fileBoxFileNmModifyBlock]").show();
    }

    /**
     *  이름변경  확인 버튼 클릭
     */
    $("button[name=btnFileBoxFileNmModifyOk]").on("click", function(event) {
        var folderNm = $(this).closest("tr").find("input:text[name=fileBoxFileNmModify]").val();
        var fileBoxCd = $(this).closest("tr").find("input:hidden[name=fileBoxCd]").val();
        var serverUrl = "/file/fileHome/modify/fileBoxNm.do";  // 이름변경
        var paramData = {"fileBoxCd" : fileBoxCd, "fileBoxNm" : folderNm};
        if ($(this).closest("tr").attr("id") == 'newFileBoxCreateRow') {
            serverUrl = "/file/fileHome/create/folder.do";  // 폴더생성
            paramData = {"parFileBoxCd" : $("#selFileBoxCd").val(), "fileBoxNm" : folderNm};
        }

        if ( $.trim(folderNm) == '') {
            return;
        }

        if (!isValidFileBoxNm(folderNm)) {
            $("#note-box").prop("class", "warning");
            $("#note-box p").text("<spring:message code="filebox.alert.notallow.specialchar" />"); // 폴더(파일)명에 허용되지 않은 특수문자가 포함되어 있습니다.
            $("#note-btn").trigger("click");
            return;
        }

        $("#loading_page").show();
        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : paramData,
            url : serverUrl,
            success : function(data){
                if(data.result > 0) {
                    if (typeof getFileBoxTree == 'function') {
                        getFileBoxTree();
                    }
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            },
            beforeSend: function() {
                $("#loading_page").show();
            },
            complete:function(status){
                $("#loading_page").hide();
            },
            error: function(xhr,  Status, error) {
                $("#loading_page").hide();
            }
        });
    });

    /**
     *  이름변경  취소 버튼 클릭
     */
    $("button[name=btnFileBoxFileNmModifyCancel]").on("click", function(event) {
        var beforeEdittedText = $(this).closest("td").find("input:hidden[name=fileBoxNm]").val();
        $(this).closest("td").find("input:text[name=fileBoxFileNmModify]").val(beforeEdittedText); 
        $(this).closest("tr").find("a[name=linkFileBoxFileNm]").show();
        $(this).closest("tr").find("div[name=fileBoxFileNmModifyBlock]").hide();
    });

    /**
     *  폴더생성 취소 버튼 클릭
     */
    $("button[name=btnNewFileBoxFileNmCancel]").on("click", function(event) {
        $(this).closest("tr").find("input:text[name=fileBoxFileNmModify]").val('');
        $("#newFileBoxCreateRow").hide();
    });

    /**
     *  파일명 특수문자 검사
     */
    function isValidFileBoxNm(str) {
        var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?<>]/gi;
        if (special_pattern.test(str) == true) {
            return false;
        } else {
            return true;
        }
    }

    /**
     *  각 row의 체크박스  클릭 시
     */
    $("input:checkbox[name=fileBoxCds]").on("change", function(event) {
        if ($(this).is(":checked")) {
            //$(this).closest("tr").find("a[name=linkFileBoxFileNm]").draggable("enable");
        } else {
            $(this).closest("tr").find("a[name=linkFileBoxFileNm]").draggable("disable");
        }
    });

    /**
     *  클릭한 파일의 경로 표시
     */
    function displayFilePath(path) {
        var pathStr = path.replace(/ > /gi, '<i class="ion-ios-arrow-forward"></i>');
        $("#searhFilePathBlock").html(pathStr);
    }

    /**
     *  파일 변환 처리 컨펌
     */
    function transferPdfFileConfirm(fileBoxCd) {
        var confirmMsg = '<spring:message code="filebox.confirm.tranfer.file" />'; // 파일을 변환하시겠습니까?
        $("#alert-box").removeClass("warning");
        $("#alert-box p").text(confirmMsg);
        $("#alertOk").attr("href","javascript:transferPdfFile('" + fileBoxCd + "'); $('#alert-box').removeClass('on');");
        $("#alertNo").attr("href","javascript:$('#alert-box').removeClass('on');");
        $("#alert-btn").trigger("click");
   }

    /**
     *  파일 변환 처리
     */
    function transferPdfFile(fileBoxCd) {
        var serverUrl = "/file/fileHome/transfer/pdfFile.do"; 
        var paramData = {"fileBoxCd" : fileBoxCd};

       $("#loading_page").show();
       $("#loading_page").animate({opacity: "0.6"}, 00);
        $.ajax({
            type : "POST",
            async: true,
            dataType : "json",
            data : paramData,
            url : serverUrl,
            success : function(data){
                if(data.result > 0) {
                    if (typeof getFileBoxTree == 'function') {
                        getFileBoxTree();
                    }
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            },
            beforeSend: function() {
                $("#loading_page").show();
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
     *  변환 파일 다운로드
     */
    function downloadTranferFile(encFileSn) {
        var serverUrl = "/download/transferFile.do/" + encFileSn;
        $("#filedownForm").attr('action', serverUrl);
        $("#filedownForm").attr('method',"post");
        $("#filedownForm").attr('target',"hiddenDownFrame");
        $("#filedownForm").submit();
    }
</script>

<body>
<form name="fileBoxDetailForm" id="fileBoxDetailForm" method="POST">
    <input type="hidden" id="selectedFileBoxCd" name="selectedFileBoxCd" />
</form>

<div id="wrap" class="pusher">
    <!-- class_top 인클루드  -->

    <!-- header -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
    <!-- //header -->

    <!-- lnb -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
    <!-- //lnb -->

    <div id="container">
                        
        <!-- 본문 content 부분 -->
        <div class="content">

            <div class="ui form">
                <div class="header flex-wrap">
                    <h2>
                    <c:if test="${not empty vo.searchValue}">
                        <c:out value='${vo.searchValue}' />
                    </c:if>
                    <c:if test="${empty vo.searchValue}">
                        <c:forEach items="${fullFolderPath }" var="path" varStatus="idx">
                            <c:if test="${idx.index > 0}">
                                <i class="ion-ios-arrow-forward"></i>
                            </c:if>
                            <c:out value='${path}' />
                        </c:forEach>
                    </c:if>
                    </h2>
                </div>

                <c:if test="${not empty vo.searchValue}">
                    <div class="header flex-wrap">
                        <h2><spring:message code="filebox.label.list.title" /></h2> <!-- '참고' 검색 결과 -->
                        <div class="flex-left-auto" id="searhFilePathBlock">
                        </div>
                    </div>
                </c:if>

                <!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->

                <form id="checkFileBoxForm" name="checkFileBoxForm">
                <input type="hidden" id="moveTargetFileBoxCd" name="moveTargetFileBoxCd"  >
                <table id="fileboxList" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />"> <!-- 등록된 내용이 없습니다. -->
                    <thead>
                        <tr>
                            <th scope="col" data-sortable="false" class="chk">
                                <div class="ui checkbox">
                                    <input type="checkbox" id="checkAllFileBox">
                                    <input type="hidden" id="selFileBoxCd" name="selFileBoxCd" value="<c:out value='${vo.selectedFileBoxCd}' />" >
                                </div>
                            </th>
                            <th scope="col"><spring:message code="common.label.list.filenm" /></th> <!-- 파일명 -->
                            <th scope="col" data-breakpoints="xs"><spring:message code="common.label.list.createdt" /></th> <!-- 생성일 -->
                            <th scope="col" data-breakpoints="xs"><spring:message code="common.label.list.size" /></th> <!-- 크기 -->
                            <th scope="col" data-breakpoints="xs sm" data-sortable="false"><spring:message code="common.mgr" /></th> <!-- 관리 -->
                        </tr>
                    </thead>
                    <tbody>
                        <tr id="newFileBoxCreateRow" style="display:none;">
                            <td></td>
                            <td>
                                <div class="ui action input w150" >
                                    <input type="text" name="fileBoxFileNmModify" value="" maxlength="50">
                                    <span class="ui basic button img-button">
                                        <button type="button" class="icon_check" name="btnFileBoxFileNmModifyOk"></button>
                                        <button type="button" class="icon_cancel" name="btnNewFileBoxFileNmCancel"></button>
                                    </span>
                                </div>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <c:if test="${not empty resultList}">
                            <c:forEach items="${resultList }" var="item" varStatus="status">
                                <tr name="fileBoxListRow" id="fileBoxListRow_${status.index}">
                                    <td>
                                        <div class="ui checkbox">
                                            <input type="checkbox" name="fileBoxCds" value="${item.fileBoxCd}" data-encFileSn="${item.encFileSn}" data-ext="${item.fileExt}" data-fileBoxType="${item.fileBoxTypeCd}" data-size="${item.fileSize}" data-fileType="${item.fileType}" >
                                        </div>
                                    </td>
                                    <td>
                                        <input type="hidden" name="fileBoxCd" value="<c:out value='${item.fileBoxCd}' />" >
                                        <input type="hidden" name="parFileBoxCd" value="<c:out value='${item.parFileBoxCd}' />" >
                                        <input type="hidden" name="fileSn" value="<c:out value='${item.fileSn}' />" >
                                        <input type="hidden" name="fileBoxTypeCd" value="<c:out value='${item.fileBoxTypeCd}' />" >
                                        <input type="hidden" name="fileBoxTypeNm" value="<c:out value='${item.fileBoxTypeNm}' />" >
                                        <input type="hidden" name="fileBoxNm" value="<c:out value='${item.fileBoxFullNm}' />" >
                                        <input type="hidden" name="regDt" value="<c:out value='${item.regDt}' />" >
                                        <input type="hidden" name="fileSizeFormatted" value="<c:out value='${item.fileSizeFormatted}' />" >
                                        <input type="hidden" name="downloadUrl" value="<c:out value='${item.downloadUrl}' />" >
                                        <input type="hidden" name="filePullPath" value="<c:out value='${item.folderPath}' />" >
                                    <c:if test="${empty vo.searchValue}">
                                        <a href="javascript:;" name="linkFileBoxFileNm">
                                    </c:if>
                                    <c:if test="${not empty vo.searchValue}">
                                        <a href="javascript:;" name="linkFileBoxFileNm" onClick='displayFilePath("<c:out value='${item.folderPath}'/>")'>
                                    </c:if>
                                        <c:if test="${item.fileBoxTypeCd == 'FOLDER'}">
                                            <i class="folder outline icon f120 vm"></i>
                                        </c:if>
                                        <c:if test="${item.fileBoxTypeCd == 'DOC'}">
                                            <i class="file alternate outline icon f120 vm"></i>
                                        </c:if>
                                        <c:if test="${item.fileBoxTypeCd == 'MOV'}">
                                            <i class="file video outline icon f120 vm"></i>
                                        </c:if>
                                        <c:if test="${item.fileBoxTypeCd == 'IMG'}">
                                            <i class="file image outline icon f120 vm"></i>
                                        </c:if>
                                        <c:if test="${item.fileBoxTypeCd == 'ETC'}">
                                            <i class="file archive outline icon f120 vm"></i>
                                        </c:if>
                                           <c:out value='${item.fileBoxFullNm}' />
                                        </a>
                                        <div class="ui action input w150" style="display:none;" name="fileBoxFileNmModifyBlock">
                                            <input type="text" name="fileBoxFileNmModify" value="<c:out value='${item.fileBoxNm}' />" maxlength="50">
                                            <span class="ui basic button img-button">
                                                <button type="button" class="icon_check" name="btnFileBoxFileNmModifyOk"></button>
                                                <button type="button" class="icon_cancel" name="btnFileBoxFileNmModifyCancel"></button>
                                            </span>
                                        </div>
                                    </td>
                                    <td><c:out value='${item.regDt}' /></td>
                                    <td>${empty item.fileSize?'-':item.fileSizeFormatted}</td>
                                    <td>
                                        <div class="ui basic small buttons">
                                            <a href="#0" class="ui button" data-toggle="modal" data-target="#modalFileBoxFileDetailPopup" name="btnFileBoxFileDetail" onClick="getFileBoxDetailModal('${item.fileBoxCd}')"><spring:message code="common.button.detailinfo" /></a> <!-- 상세정보 -->
                                    <c:choose>
                                        <c:when test="${item.fileBoxTypeCd == 'FOLDER'}">
                                            <a class="ui button disabled" ><spring:message code="button.sns.copyurl" /></a> <!-- URL복사 -->
                                        </c:when>
                                        <c:otherwise>
                                            <a href="javascript:;" class="ui button" name="btnUrlClipBoardCopy" onClick="clickClipBoard(this, '${status.index}')"><spring:message code="button.sns.copyurl" /></a> <!-- URL복사 -->
                                        </c:otherwise>
                                    </c:choose>
                                        </div>

                                        <div class="ui basic small buttons">
                                    <c:choose>
                                        <c:when test="${item.fileBoxTypeCd == 'FOLDER'}">
                                            <a class="ui button disabled"><spring:message code="button.download" /></a> <!-- PDF 다운로드 -->
                                        </c:when>
                                        <c:when test="${item.fileType == 'TRANSFER'}">
                                            <a href="javascript:;" onClick="downloadTranferFile('${item.encFileSn}')" class="ui button"  name="btnFileBoxDownload"><spring:message code="button.download" /></a> <!-- PDF 다운로드 -->
                                        </c:when>
                                        <c:otherwise>
                                            <a href="javascript:fileDown('${item.encFileSn}');" class="ui button" name="btnFileBoxDownload"><spring:message code="button.download" /></a> <!-- PDF 다운로드 -->
                                        </c:otherwise>
                                    </c:choose>
                                            <a href="javascript:;" class="ui button" name="btnFileBoxFileNmModify" onClick="changeFileNmEditMode(this, '${status.index}')"><spring:message code="filebox.button.nmmodify" /></a> <!-- 이름변경  -->
                                        <c:if test="${transServerUseYn eq 'Y'}">
                                            <c:choose>
                                                <c:when test="${item.fileBoxTypeCd == 'DOC' && item.fileExt != 'pdf' && item.fileExt != 'txt' && item.fileExt != 'csv'}">
                                                    <a href="javascript:transferPdfFileConfirm('${item.fileBoxCd}');" class="ui button" name="btnFileTrans"><spring:message code="filebox.button.filetrans" /></a> <!-- 파일변환 -->
                                                </c:when>
                                            </c:choose>
                                        </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                    </tbody>
                </table>
                </form>
            </div>
        </div>
    </div>
    <!-- //본문 content 부분 -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</div>

<!------------------------------------ 변환 파일 다운로드 ------------------------------------>
<form id="filedownForm" name="filedownForm" target="hiddenDownFrame" method="post" >
    <input type="hidden" id="downloadFrm_fileBoxFullNm" name="fileBoxFullNm" />
    <input type="hidden" id="downloadFrm_downloadUrl" name="downloadUrl" />
    <input type="hidden" id="downloadFrm_fileSn" name="fileSn" />
</form>
<iframe id="hiddenDownFrame" name="hiddenDownFrame" width="0" height="0" ></iframe> <!-- 파일다운로드 용 -->
<!------------------------------------ 변환 파일 다운로드 ------------------------------------>

<!------------------------------------ Modal 부분 ------------------------------------>
<!-- 상세정보 -->
<div class="modal fade" id="modalFileBoxFileDetailPopup" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.button.detailinfo" />"" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="button.close" />"> <!-- 닫기 -->
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><spring:message code="common.button.detailinfo" /></h4> <!-- 상세정보 -->
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" scrolling="no" id="modalFileBoxFileDetailIfm" name="modalFileBoxFileDetailIfm"></iframe>
            </div>
        </div>
    </div>
</div>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function(){
        $('#modalFileBoxFileDetailPopup').modal('hide');
    };
</script>
</body>
</html>
