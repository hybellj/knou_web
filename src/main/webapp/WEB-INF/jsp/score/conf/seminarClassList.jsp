 <%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function editSeminarClass() {
	$("#seminarListForm").attr("action", "/score/scoreConf/editSeminarClass.do");
	$("#seminarListForm").submit();
}
</script>

<body>
	<form class="ui form" name="seminarListForm" id="seminarListForm" method="POST">

    <div id="wrap" class="pusher">
    
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		<!-- //header -->

		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->
        
        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content ">

				<!-- admin_location -->
				<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
				<!-- //admin_location -->
				
				<div class="ui segment">
					<div class="ui form">
						<div class="layout2">
					    	<!-- 타이틀 -->
							<div id="info-item-box">
					        	<h2 class="page-title"><spring:message code="score.base.info.manager.label"/> > <spring:message code="score.seminar.evaluation.label"/></h2>	<!-- 성적기초정보관리 > 세미나 출석기준 설정 -->
					            <div class="button-area">
					            	<a href="javascript:editSeminarClass()" class="ui blue button"><spring:message code="score.seminar.evaluation.button"/></a> <!-- 세미나출석기준 설정 -->
					            </div>
					        </div>
			
				            <!-- 영역 -->
				            <div class="grid-content modal-type">
			                    <div class="grid-content-box menu-nth-wrap"> 
			                        <div class="option-content header-border-bottomline">
			                            <div class="flex-item">
			                                <h3 class="mr20 "><spring:message code="seminar.label.seminar" /> <spring:message code="seminar.label.attend" />/<spring:message code="seminar.label.late" />/<spring:message code="seminar.label.absent" /> <spring:message code="asmnt.label.standard" /></h3>
			                            </div>
			                        </div>
			                        <ul class="notice_list mt10">
			                            <li><i>&middot;</i>
			                                <span><span class="fcBlue"><spring:message code="seminar.label.attend" /><!-- 출석 --></span> : <spring:message code="std.label.start_time" /><!-- 시작시간 --><span class="fcBlue"><c:out value="${vo.seminarAtndTmVal}" /></span><spring:message code="score.label.attend.before.minute" /><!-- 분 전에 참석하고 --><span class="fcBlue"><c:out value="${vo.seminarAtndRatioVal}" /></span>% <spring:message code="score.label.over.atnd" /><!-- 이상 참여 --></span></li>
			                            <li><i>&middot;</i>
			                            	<span><span class="fcBrown"><spring:message code="seminar.label.late" /><!-- 지각 --></span> : <spring:message code="std.label.start_time" /><!-- 시작시간 --><span class="fcBlue"><c:out value="${vo.seminarLateTmVal}" /></span><spring:message code="score.label.attend after.minute" /><!-- 분 후에 참석하고 --><span class="fcBlue"><c:out value="${vo.seminarLateRatioVal}" /></span>% <spring:message code="score.label.over.atnd" /><!-- 이상 참여 --></span></li>
			                            <li><i>&middot;</i>
			                            	<span><span class="fcRed"><spring:message code="seminar.label.absent" /><!-- 결석 --></span> : <span class="fcBlue"><c:out value="${vo.seminarAbsentRatioVal}" /></span>% <spring:message code="score.label.under.atnd" /><!-- 미만 참석 --></span></li>	
			                        </ul>
			                    </div>
			                </div>
						</div>
					</div><!-- //container -->
				</div>
            </div>
        </div>
        <!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    </form>
</body>
</html>
