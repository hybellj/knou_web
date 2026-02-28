<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript" src="/webdoc/js/jquery.treeview.js"></script>
<script type="text/javascript">
    // 페이지 초기화
    $(document).ready(function() {
        // tree data 생성
        var treeHtml = '';
        var $treeNode;
        <c:if test="${not empty resultList}">
            <c:forEach items="${resultList}" var="item" varStatus="status">
                treeHtml = '<li><span class="folder" name="spFileBoxFolder" data-folderId="${item.fileBoxCd}"><c:out value='${item.folderNm}' /></span></li>';
                $treeNode = $(treeHtml);
                if ("${item.childrenCnt}" != "0") {
                    $treeNode.append('<ul name="treeNode${item.fileBoxCd}"></ul>');
                }

                if ('${item.parFileBoxCd}' == '') {
                    $("#fileBoxTreeMenu").append($treeNode);
                } else {
                    $("ul[name=treeNode${item.parFileBoxCd}]").append($treeNode);
                }
            </c:forEach>
        </c:if>

        // tree 설정
        $("#fileBoxTreeMenu li").droppable({
            drop: function( event, ui ) {
                moveFileBox($(this).find("span[name=spFileBoxFolder]").attr("data-folderId"));
            }
        });

        $("#fileBoxTreeMenu").treeview({
            collapsed: true,
            unique: false
        });

        // tree에 drop 가능 설정

        // 트리의 첫번째 항목 선택해줌
        if ($("#currFileBoxCd").val() == '') {
            if (typeof getFileListInsideFolder == 'function') {
                getFileListInsideFolder($("span[name=spFileBoxFolder]").first().attr("data-folderId"));
            }
        } else {
            if (typeof clickFileBoxSearch == 'function') {
                clickFileBoxSearch();
            }
        }
    });

    /**
     *  선택한 폴더의 파일리스트 조회
     */
    $("span[name=spFileBoxFolder]").on("click", function(event) {
        $("#searchValue").val('');
        if (typeof getFileListInsideFolder == 'function') {
            getFileListInsideFolder($(this).attr("data-folderId"));
        }
    });

    /**
     *  파일 이동
     */
    function moveFileBox(fileBoxCd) {
        if ($("input:checkbox[name=fileBoxCds]:checked").length == 0) {
            return;
        }

        $("#loading_page").show();
        $("#moveTargetFileBoxCd").val(fileBoxCd);
        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : $("#checkFileBoxForm").serialize(),
            url : "/file/fileHome/move/fileBox.do",
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
     *  ROOT 폴더 클릭(최상위 폴더를 수정 삭제 하기 위해)
     */
    function getRootFolderList() {
        $("#searchValue").val('');
        if (typeof getFileListInsideFolder == 'function') {
            getFileListInsideFolder("ROOT");
        }
    }
</script>

<div class="header">
	<a href="javascript:getRootFolderList();"><h2 ><spring:message code="filebox.label.tree.title" /></h2></a> <!-- 내 파일 -->
</div>
<div class="content">
	<a href="javascript:getRootFolderList();"><i class="grey archive icon"></i><spring:message code="filebox.label.my.fileBox"/></a> <!-- MyFileBox -->
    <ul id="fileBoxTreeMenu" class="filetree treeview"></ul>
</div>
