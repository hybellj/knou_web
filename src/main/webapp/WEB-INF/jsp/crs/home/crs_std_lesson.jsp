<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=9" />

<script type="text/javascript">
	$(document).ready(function(){
	});
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <!-- class_top 인클루드  -->
        	<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

            <!-- 본문 content 부분 -->
            <div class="content stu_section st2">
            
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

                <div class="ui form">
                    <div class="layout2">
                    	<script>
						$(document).ready(function () {
							// set location
							setLocationBar("<spring:message code='common.label.lecture.list' />");	// 강의목록
						});
						</script>

                        <c:import url="/crs/crsStuLessonList.do">
							<c:param name="crsCreCd" value="${crsCreCd}"/>
							<c:param name="stdNo" value="${stdNo}"/>
						</c:import>
						
	                </div>
				</div>
            </div>
            <!-- //본문 content 부분 -->

			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //container -->

    </div>
	
</body>

</html>