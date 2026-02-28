<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript" src="/webdoc/js/jquery.treeview.js"></script>
<script type="text/javascript">
<%--  페이지 초기화 --%>
    $(document).ready(function(){
		<%--  리스트의 첫번째 항목 선택해줌 --%>
        if($("input:radio[name=chkAuthGrp]").length > 0) {
            if(typeof getUserSizeLimitSearch == 'function') {
            	getUserSizeLimitSearch($("input:radio[name=chkAuthGrp]:first").val());
            }
        }
    });

    <%-- 용량 클릭 시 수정 박스 표시 --%>
    function changeSizeEditMode(obj) {
        $(obj).closest("tr").find("a[name=authGrpSizeDpBlock]").hide();
        $(obj).closest("tr").find("div[name=authGrpSizeModifyBlock]").show();
    }

    <%-- 용량변경  취소 버튼 클릭 --%>
     function cancelSizeEditMode(obj) {
         $(obj).closest("tr").find("a[name=authGrpSizeDpBlock]").show();
         $(obj).closest("tr").find("div[name=authGrpSizeModifyBlock]").hide();
     }

     <%-- 용량변경  ok 버튼 클릭 --%>
     function updateSizeEditMode(obj, authGrpCd) {
         var limitSize = $(obj).closest("td").find("input:text[name=authGrpSizeLimit]").val();

         <%--
         if (limitSize == '' || !isNumber(limitSize)) {
             $("#note-box").prop("class", "warning");
             $("#note-box p").text("<spring:message code="filemgr.alert.input.num" />"); 숫자로 입력하세요.
             $("#note-btn").trigger("click");
             $(obj).closest("td").find("input:text[name=authGrpSizeLimit]").focus();
             return;
         } 
         --%>

         $("#loading_page").show();

         $.ajax({
             type : "POST",
             async: false,
             dataType : "json",
             data : {
                      "selectedAthGrpCd" : authGrpCd
                    , "fileSize" : limitSize
                    },
             url : "/file/fileMgr/modify/auth/fileLimitSize.do",
             success : function(data){
                 if(data.result > 0) {
                     if (typeof getAuthGrpSizeLimitList == 'function') {
                         getAuthGrpSizeLimitList();
                     }
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

     <%--  권한그룹 선택 --%>
     function getUserSizeLimitSearchView(obj) {
         if (typeof getUserSizeLimitSearch == 'function') {
             getUserSizeLimitSearch($(obj).find("input:radio[name=chkAuthGrp]").val());
         }
     }
     
 	// 권한그룹등록
 	function editAuthPop() {
 	    $("#authForm").attr("target", "editAuthPopIfm");
        $("#authForm").attr("action", "/menu/menuMgr/sysMenuAuthGrpPop.do");
        $("#authForm").submit();
        $('#editAuthPop').modal('show');
 	}
</script>
<body>
	<div class="ui top attached message flex-item">
        <div class="header m0 mra"><spring:message code="filemgr.label.auth.grp" /></div> <%-- 권한 그룹 --%>
       	<%--<button type="button" class="ui basic small button" onclick="editAuthPop(); return false;"><spring:message code="button.write.authgrp"/></button>권한 그룹 추가--%>
    </div>
    <div class="ui bottom attached segment">
        <table class="table select-list radiobox" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />"> <%-- 등록된 내용이 없습니다. --%>
            <thead>
                <tr>
                    <th scope="col" data-sortable="false" class="chk">
                        <div class="ui-mark">
                            <i class="ion-android-done"></i>
                        </div>
                    </th>
                    <th scope="col"><spring:message code="common.label.auth.grpnm" /></th> <%-- 권한 그룹명 --%>
                    <th scope="col"><spring:message code="common.label.auth.grpcd" /></th> <%-- 권한 그룹 코드 --%>
                    <th scope="col" data-breakpoints="xs"><spring:message code="common.label.auth.size" /></th> <%-- 용량 --%>
                </tr>
            </thead>
            <tbody>
        <c:if test="${not empty resultList}">
            <c:forEach items="${resultList}" var="item" varStatus="status">
                <tr>
                    <td>
                        <div class="ui-mark" name="divAuthGrp" onClick="getUserSizeLimitSearchView(this)">
                            <input type="radio" name="chkAuthGrp" value="${item.authGrpCd}">
                            <label><i class="ion-android-done"></i></label>
                        </div>
                    </td>
                    <td><c:out value='${item.authGrpNm}' /></td>
                    <td><c:out value='${item.authGrpCd}' /></td>
                    <td>
                    <c:if test="${item.fileSize == 0}">
                        <a href="javascript:;" name="authGrpSizeDpBlock" class="link-dots" onClick="changeSizeEditMode(this)"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                    </c:if>
                    <c:if test="${item.fileSize > 0}">
                        <a href="javascript:;" name="authGrpSizeDpBlock" class="link-dots" onClick="changeSizeEditMode(this)"><fmt:formatNumber value="${item.fileSize}" type="number" />MB</a>
                    </c:if>
                        <div class="ui action input w80" style="display:none;" name="authGrpSizeModifyBlock">
                            <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="authGrpSizeLimit" maxlength="6" value="${item.fileSize}" placeholder="MB">
                            <span class="ui basic button img-button">
                                <button type="button" class="icon_check" name="btnAuthGrpSizeModifyOk" onClick="updateSizeEditMode(this, '${item.authGrpCd}')"></button>
                                <button type="button" class="icon_cancel" name="btnAuthGrpSizeModifyCancel" onClick="cancelSizeEditMode(this, '${item.authGrpCd}')"></button>
                            </span>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
            </tbody>
        </table>
        <div class="ui small warning message"><i class="info icon"></i><spring:message code="filemgr.alert.zero.limit" /></div> <%-- 0은 무제한으로 표기됩니다. --%>
    </div>

    <!-- 권한그룹 추가 팝업 -->
    <form id="authForm" name="authForm" method="POST"></form>
    <div class="modal fade" id="editAuthPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="button.write.authgrp"/>" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="button.write.authgrp"/></h4><!-- 권한그룹추가 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="editAuthPopIfm" name="editAuthPopIfm" width="100%"  style="height: 600px;" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body> 
</html>