<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    <%-- 페이지 초기화 --%>
    $(document).ready(function() {
    	listUserSizeLimit(1);
    });

    <%--  검색 처리 --%>
    $("#searchValue").on("keydown", function(event) {
        if(event.keyCode == 13) {
            listUserSizeLimit(1);
        }
    });

    <%-- 검색 처리 --%>
    $("#btnUserSizeLimitSearch").on("click", function(event) {
        listUserSizeLimit(1);
    });

    <%--  리스트 갯수 변경시 검색 처리 --%>
    $("#listScale").on("change", function(event) {
        listUserSizeLimit(1);
    });

	<%--  리스트 호출 --%>
    function listUserSizeLimit(page) {
    	
    	var url = "/file/fileMgr/userSizeLimitList.do";
        var paramData = {
			"authGrpCd" : "${vo.authGrpCd}"
            , "searchType" : $("#searchType").val()
            , "searchValue" : $("#searchValue").val()
            , "listScale" : $("#listScale").val()
            , "pageIndex" : page
		}; 
    	
		$('#userSizeLimitListBlcok').load(
			url
			, paramData
			, function() { }
		);
	} 
</script>

	<div class="ui top attached message">
    	<div class="header"><spring:message code="filemgr.label.userauth.title" /> <%-- 용량 관리 --%></div>
    </div>
    <div class="ui bottom attached segment">
    	<div class="option-content">
        	<select class="ui dropdown mr5" id="searchType" name="searchType" onchange="listUserSizeLimit(1);">
            	<option value="ALL_SEARCH"><spring:message code="common.all" /></option> <%-- 전체 --%>
                <c:forEach items="${userStsList}" var="item" varStatus="status">
                	<option value="${item.codeCd}"><c:out value='${item.codeNm}' /></option>
                </c:forEach>
            </select>
            <div class="ui action input search-box">
				<input type="text" id="searchValue" name="searchValue" maxlength="50" placeholder="<spring:message code="button.search" />"> <%-- 검색 --%>
				<button type="button" id="btnUserSizeLimitSearch" class="ui icon button"><i class="search icon"></i></button>
			</div>
           	<div class="button-area">
            	<select class="ui dropdown list-num" id="listScale" name="listScale">
                	<option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <option value="300">300</option>
                    <option value="500">500</option>
                </select>
            </div>
        </div>
        <div id="userSizeLimitListBlcok"></div>
	</div>
