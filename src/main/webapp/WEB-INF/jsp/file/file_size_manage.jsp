<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
		<%--  페이지 초기화--%>
    $(document).ready(function(){
    	<%--  권한 그룹별 용량관리 리스트 화면 호출 --%>
        getAuthGrpSizeLimitList();
    });

    <%--  권한 그룹별 용량관리 리스트 화면 호출 --%>
    function getAuthGrpSizeLimitList() {
        $('#authGrpSizeLimitListBlock').load("/file/fileMgr/authGrpSizeLimitList.do"
            , {}
            , function () {}
        );
    }

    <%--  사용자별 용량관리 검색 화면 호출 --%>
    function getUserSizeLimitSearch(authGrpCd) {
        $('#userSizeLimitSearchBlock').load("/file/fileMgr/userSizeLimitSearch.do"
            , {"authGrpCd" : authGrpCd}
            , function () {}
        );
    }
</script>

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
            
				<!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->
                
                <div class="ui form">
                
                    <div id="info-item-box" class="admin">
                        <h2 class="page-title"><spring:message code="filemgr.label.auth.title" /></h2> <%-- 권한별 파일함 용량관리 --%>
                    </div>
                    <div class="ui form">
                        <div class="ui grid stretched row">
                            <div class="sixteen wide tablet six wide computer column" id="authGrpSizeLimitListBlock"></div>
                            <div class="sixteen wide tablet ten wide computer column" id="userSizeLimitSearchBlock"></div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>
