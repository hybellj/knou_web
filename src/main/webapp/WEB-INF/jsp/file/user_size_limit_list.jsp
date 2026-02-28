<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
<%-- 페이지 초기화 --%>
    $(document).ready(function(){
    });

    <%-- 용량 클릭 시 수정 박스 표시--%>
    $("a[name=userSizeDpBlock]").on("click", function(event) {
        $(this).closest("tr").find("a[name=userSizeDpBlock]").hide();
        $(this).closest("tr").find("div[name=userSizeModifyBlock]").show();
    });

     <%-- 용량변경 취소 버튼 클릭--%>
    $("button[name=btnUserSizeModifyCancel]").on("click", function(event){
        $(this).closest("tr").find("a[name=userSizeDpBlock]").show();
        $(this).closest("tr").find("div[name=userSizeModifyBlock]").hide();
    });

     <%-- 용량변경 ok 버튼 클릭 --%>
    $("button[name=btnUserSizeModifyOk]").on("click",function(event){

        var limitSize = $(this).closest("td").find("input:text[name=userSizeLimit]").val();

        <%--
        if (!isNumber(limitSize)) {
            $("#note-box").prop("class", "warning");
            $("#note-box p").text("<spring:message code="filemgr.alert.input.num" />"); 숫자로 입력하세요.
            $("#note-btn").trigger("click");
            $(this).closest("td").find("input:text[name=userSizeLimit]").focus();
            return;
        } 
        --%>

        $("#loading_page").show();

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : {
                     "selectedAthGrpCd" : '${vo.authGrpCd}'
                   , "selectedUserId" : $(this).closest("tr").find("input:hidden[name=selectedUserId]").val()
                   , "fileSize" : limitSize
                   },
            url : "/file/fileMgr/modify/user/fileLimitSize.do",
            success : function(data){
                if(data.result > 0) {
                    if (typeof listUserSizeLimit == 'function') {
                        listUserSizeLimit('${pageInfo.currentPageNo}');
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
    });
</script>

<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />"> <%-- 등록된 내용이 없습니다. --%>
    <thead>
        <tr>
            <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <%-- NO. --%>
            <th scope="col"><spring:message code="common.type" /></th> <%-- 구분 --%>
            <th scope="col" data-breakpoints="xs"><spring:message code="common.dept_name" /></th> <%-- 학과 --%>
            <th scope="col"><spring:message code="common.name" /></th> <%-- 이름 --%>
            <th scope="col"><spring:message code="common.id" /></th> <%-- 아이디 --%>
            <th scope="col" data-breakpoints="xs"><spring:message code="common.label.status" /></th> <%-- 상태 --%>
            <th scope="col" data-breakpoints="xs sm"><spring:message code="filemgr.label.userauth.boxlimit" /></th> <%-- 파일함 용량 --%>
        </tr>
    </thead>
    <tbody>
        <c:if test="${not empty resultList}">
            <c:forEach items="${resultList}" var="item" varStatus="status">
                <tr>
                    <td>${pageInfo.rowNum(status.index)}</td>
                    <td><c:out value='${item.authGrpNm}' /></td>
                    <td><c:out value='${item.deptNm}' /></td>
                    <td><c:out value='${item.userNm}' /></td>
                    <td><c:out value='${item.userId}' /></td>
                    <td><c:out value='${item.userStsNm}' /></td>
                    <td>
                        <input type="hidden" name="selectedUserId" value="${item.userId}" />
                    <c:if test="${item.fileSize == 0}">
                        <a href="javascript:;" name="userSizeDpBlock" class="link-dots"><spring:message code="filebox.label.main.nolimit" /></a> <%-- 무제한 --%>
                    </c:if>
                    <c:if test="${item.fileSize > 0}">
                        <a href="javascript:;" name="userSizeDpBlock" class="link-dots"><fmt:formatNumber value="${item.fileSize}" type="number" />MB</a>
                    </c:if>
                        <div class="ui action input w80" style="display:none;" name="userSizeModifyBlock">
                            <input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name="userSizeLimit" maxlength="6" value="${item.fileSize}" placeholder="MB">
                            <span class="ui basic button img-button">
                                <button type="button" class="icon_check" name="btnUserSizeModifyOk"></button>
                                <button type="button" class="icon_cancel" name="btnUserSizeModifyCancel"></button>
                            </span>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
    </tbody>
</table>
<tagutil:paging pageInfo="${pageInfo}" funcName="listUserSizeLimit"/>
