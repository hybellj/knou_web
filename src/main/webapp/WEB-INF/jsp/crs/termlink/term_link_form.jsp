<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		var lastLinkDttm = "${lastLinkDttm}";
	    if(lastLinkDttm != "") {
	    	$("#LINK_ALL small span").text(lastLinkDttm);
	    }
	});
	
	//비동기 처리
	function promiseWrapper(time, value) {
	   return new Promise(resolve => {
		   return setTimeout(() => resolve(`passed value: ${value}`), time);
	   })
	} 
	
	//전체 연동 버튼 클릭 
	async function doAllLink() {
		$("#LINK_ALL small span").text("-");
		await doLink('DEPARTMENT');         // 1.소속 정보를 연동
		await doLink('USER_LEARNER');       // 2.사용자 정보 중 학습자 정보를 연동
		await doLink('PROFESSOR');          // 3.사용자 정보 중 교수자 정보를 연동
		await doLink('ETC_USER');           // 4.사용자 정보 중 기타 사용자 정보를 연동
		await doLink('COURSE');             // 5.운영 과목 정보를 연동
		await doLink('COURSE_PROFESSOR');	// 6.과목 운영자 정보를 연동
		await doLink('LEARNER');            // 7.과목 수강생 정보를 연동
		await doLink('LESSON_PLAN');     	// 8.수업계획서 정보를 연동
		await doLink('COURSE_SCORE');   	// 9.평가비율 정보를 연동
		await doLink('LESSON_SCHEDULE');	// 10.주차별 강의 정보를 연동

		await updateLastLinkDttm();         // 최종 업데이트 일시 조회
	}
	
	async function updateLastLinkDttm() {
		const result = await promiseWrapper(500, 'last called');
		
		var url  = "/crs/termLinkMgr/editMgr.do";
		var data = {
			lastLinkDttmUpdateYn : "Y",
            autoLinkYn           : "${autoLinkYn}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
            	$("#LINK_ALL small span").text(data.lastLinkDttm);
            } else {
            	$("#LINK_" + linkType + " i").removeClass("ion-checkmark-round");
                $("#LINK_" + linkType + " i").addClass("ion-close-round fcRed");
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	} 
	
	//개별 연동 버튼 클릭
    async function doLink(linkType) {     
        $("#LINK_" + linkType + " i").removeClass("fcGreen");
        $("#LINK_" + linkType + " small span").text("");        
        const result = await promiseWrapper(500, linkType+' called');   

        $("#LINK_" + linkType + " i").removeClass("ion-checkmark-round");
        $("#LINK_" + linkType + " i").removeClass("ion-close-round fcRed");
        
        var url  = "/crs/termLinkMgr/termLink.do";
		var data = {
			"linkType" : linkType,
			"termCd"   : "${vo.termCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				if(data.resultYn == "Y"){
                    $("#LINK_" + linkType + " i").addClass("ion-checkmark-round");
                    $("#LINK_" + linkType + " i").addClass("fcGreen");
                    $("#LINK_" + linkType + " small span").text(data.updateDttm);
                } else {
                    $("#LINK_" + linkType + " i").removeClass("ion-checkmark-round");
                    $("#LINK_" + linkType + " i").addClass("ion-close-round fcRed");
                    $("#LINK_" + linkType + " small span").text("");
                }
            } else {
            	$("#LINK_" + linkType + " i").removeClass("ion-checkmark-round");
                $("#LINK_" + linkType + " i").addClass("ion-close-round fcRed");
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	 }
	
	// 학사 연동 결과 조회 팝업
	function termLinkMgrResultPop() {
		$("#termLinkMgrForm").attr("target", "termLinkResultPopIfm");
        $("#termLinkMgrForm").attr("action", "/crs/termLinkMgr/termLinkMgrResultPop.do");
        $("#termLinkMgrForm").submit();
        $('#termLinkResultPop').modal('show');
	}
</script>

<body>
    <div id="wrap" class="pusher">
    	<form id="termLinkMgrForm" method="POST">
    	</form>
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin_header.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp"%>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/admin_location.jsp" %>
        		<%@ include file="/WEB-INF/jsp/common/admin_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                    <h2 class="page-title"><spring:message code="crs.termlink.title" /></h2><!-- 학사연동 -->
		                    <div class="option-content">
		                    	<h3 class="graduSch"> <spring:message code="crs.termlink.title" /></h3><!-- 학사연동 -->
		                    	<div class="mla">
		                    		<a href="javascript:termLinkMgrResultPop()" class="ui green button"><spring:message code="crs.button.termlink.result.list" /></a><!-- 연동 결과 조회 -->
		                    	</div>
		                    </div>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="ui segments link-list">
							        <div class="ui secondary segment option-content" id="LINK_ALL">
							            <button type="button" class="ui blue button w150" onclick="doAllLink();"><spring:message code="crs.button.termlink.all" /><!-- 전체 연동 --></button><span class="ml10"><spring:message code="crs.termlink.all.msg" /><!-- 하단 목록의 모든 정보를 연동합니다. --></span><small class="mla"><spring:message code="crs.termlink.lastupdate" /><!-- 최종 업데이트 --> :<span class="ml10"><spring:message code="crs.termlink.not.update" /><!-- 업데이트 정보가 없습니다. --></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_DEPARTMENT">
							            <button type="button" class="ui basic black button w150" onclick="doLink('DEPARTMENT');"><spring:message code="crs.button.termlink.department" /><!-- 소속 정보 --></button><span class="ml10">1. <spring:message code="crs.termlink.department.msg" /><!-- 소속정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_USER_LEARNER">
							            <button type="button" class="ui basic black button w150" onclick="doLink('USER_LEARNER');"><spring:message code="crs.button.termlink.userlearner" /><!-- 학습자 정보 --></button><span class="ml10">2. <spring:message code="crs.termlink.userlearner.msg" /><!-- 사용자 정보 중 학습자 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_PROFESSOR">
							            <button type="button" class="ui basic black button w150" onclick="doLink('PROFESSOR');"><spring:message code="crs.button.termlink.professor" /><!-- 교수자 정보 --></button><span class="ml10">3. <spring:message code="crs.termlink.professor.msg" /><!-- 사용자 정보 중 교수자 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_ETC_USER">
							            <button type="button" class="ui basic black button w150" onclick="doLink('ETC_USER');"><spring:message code="crs.button.termlink.etcuser" /><!-- 사용자 정보 --></button><span class="ml10">4. <spring:message code="crs.termlink.etcuser.msg" /><!-- 사용자 정보 중 기타 사용자 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_COURSE">
							            <button type="button" class="ui basic black button w150" onclick="doLink('COURSE');"><spring:message code="crs.button.termlink.course" /><!-- 과목 정보 --></button><span class="ml10">5. <spring:message code="crs.termlink.course.msg" /><!-- 운영 과목 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_COURSE_PROFESSOR">
							        	<button type="button" class="ui basic black button w150" onclick="doLink('COURSE_PROFESSOR')"><spring:message code="crs.button.termlink.course.professor" /><!-- 과목운영자 정보 --></button><span class="ml10">6. <spring:message code="crs.termlink.course.professor.msg" /><!-- 과목 운영자 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_LEARNER">
							            <button type="button" class="ui basic black button w150" onclick="doLink('LEARNER');"><spring:message code="crs.button.termlink.learner" /><!-- 수강생 정보 --></button><span class="ml10">7. <spring:message code="crs.termlink.learner.msg" /><!-- 과목 수강생 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_LESSON_PLAN">
							            <button type="button" class="ui basic black button w150" onclick="doLink('LESSON_PLAN');"><spring:message code="crs.button.termlink.lesson.plan" /><!-- 수업계획서 --></button><span class="ml10">8. <spring:message code="crs.termlink.lesson.plan.msg" /><!-- 강의계획서 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_COURSE_SCORE">
							            <button type="button" class="ui basic black button w150" onclick="doLink('COURSE_SCORE');"><spring:message code="crs.button.termlink.course.score" /><!-- 평가비율정보 --></button><span class="ml10">9. <spring:message code="crs.termlink.course.score.msg" /><!-- 평가비율 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							        <div class="ui segment option-content" id="LINK_LESSON_SCHEDULE">
							            <button type="button" class="ui basic black button w150" onclick="doLink('LESSON_SCHEDULE');"><spring:message code="crs.button.termlink.lesson.schedule" /><!-- 주차별 강의정보 --></button><span class="ml10">10. <spring:message code="crs.termlink.lesson.schedule.msg" /><!-- 주차별 강의 정보를 연동합니다. --></span><small class="mla"><i class="ion-checkmark-round mr10 f150 vm"></i><span></span></small>
							        </div>
							    </div>
							    <div class="fcRed tr"><spring:message code="crs.termlink.bottom.msg" /><!-- 최초 전체 연동 이후에 항목 별 연동 버튼을 클릭하면 해당 정보를 갱신합니다. --></div>
		        			</div>
		        		</div>
        			</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
    </div>
	<!-- 학사 연동 결과 조 팝업 --> 
	<div class="modal fade" id="termLinkResultPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="crs.termlink.result.pop" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="crs.termlink.result.pop" /><!-- 학사 연동 결과 조회 --></h4>
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="termLinkResultPopIfm" name="termLinkResultPopIfm" width="100%" scrolling="no"></iframe>
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
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
</body>
</html>