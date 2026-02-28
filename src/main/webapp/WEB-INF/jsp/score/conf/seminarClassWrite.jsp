 <%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function editSeminar() {
	$("#seminarForm").attr("action", "/score/scoreConf/editSeminar.do");
	$("#seminarForm").submit();
}
</script>
<body>
<form name="seminarForm" id="seminarForm" method="POST">
	
    <div id="wrap" class="pusher">
    
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		<!-- //header -->

		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->
        
        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content stu_section">

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
					            	<a href="javascript:editSeminar()" class="ui blue button"><spring:message code="socre.save.button" /></a> <!-- 저장 -->
					            	<a href="/score/scoreConf/seminarClassList.do" class="ui blue button"><spring:message code="socre.cancel.button" /></a> <!-- 취소 -->
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
			                                <span>
			                            		<span class="fcBlue"><spring:message code="seminar.label.attend" /><!-- 출석 --></span> :
			                            		<spring:message code="std.label.start_time" /><!-- 시작시간 -->
			                            		<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="seminarAtndTmVal" name="seminarAtndTmVal" value="${vo.seminarAtndTmVal}" class="w100" maxlength="3" />
			                            		<spring:message code="score.label.attend.before.minute" /><!-- 분 전에 참석하고 -->
												<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="seminarAtndRatioVal" name="seminarAtndRatioVal" value="${vo.seminarAtndRatioVal}" class="w100" maxlength="3" />
												% <spring:message code="score.label.over.atnd" /><!-- 이상 참여 -->
			                            		<input type="hidden" id="seminarAtndTmCd" name="seminarAtndTmCd" value="${vo.seminarAtndTmCd}">  
			                            		<input type="hidden" id="seminarAtndRatioCd" name="seminarAtndRatioCd" value="${vo.seminarAtndRatioCd}">  
			                                </span>
			                            </li>
			                            <li><i>&middot;</i>
			                            	<span>
			                            		<span class="fcBrown"><spring:message code="seminar.label.late" /><!-- 지각 --></span> :
			                            		<spring:message code="std.label.start_time" /><!-- 시작시간 --> 
			                            		<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="seminarLateTmVal" name="seminarLateTmVal" value="${vo.seminarLateTmVal}" class="w100" maxlength="3" />
			                            		<spring:message code="score.label.attend after.minute" /><!-- 분 후에 참석하고 -->
												<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="seminarLateRatioVal" name="seminarLateRatioVal" value="${vo.seminarLateRatioVal}" class="w100" maxlength="3" />
												% <spring:message code="score.label.over.atnd" /><!-- 이상 참여 -->
			                            		<input type="hidden" id="seminarLateTmCd" name="seminarLateTmCd" value="${vo.seminarLateTmCd}">  
			                            		<input type="hidden" id="seminarLateRatioCd" name="seminarLateRatioCd" value="${vo.seminarLateRatioCd}">  
			                            	</span>
			                            </li>
			                            <li><i>&middot;</i>
			                            	<span>
			                            		<span class="fcRed"><spring:message code="seminar.label.absent" /><!-- 결석 --></span> :
			                            		<input type="text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" id="seminarAbsentRatioVal" name="seminarAbsentRatioVal" value="${vo.seminarAbsentRatioVal}" class="w100" maxlength="3" />
			                            		% <spring:message code="score.label.under.atnd" /><!-- 미만 참석 -->
			                            		<input type="hidden" id="seminarAbsentRatioCd" name="seminarAbsentRatioCd" value="${vo.seminarAbsentRatioCd}">  
			                            	</span>
			                            </li>	
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
