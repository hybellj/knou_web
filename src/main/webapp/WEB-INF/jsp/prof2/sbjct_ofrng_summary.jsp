<%@page import="knou.framework.common.CommConst"%>
<%@page import="knou.framework.util.StringUtil"%>
<%@ page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	$(document).ready(function(){
		var univGbn = "<%=SessionInfo.getUnivGbn(request)%>";
		var univGbnText = '';
		
		if(univGbn == "2") {
			univGbnText = '[<spring:message code="crs.label.special"/>]'; // 특수
		} else if(univGbn == "3") {
			univGbnText = '[<spring:message code="crs.label.general"/>]'; // 일반
		} else if(univGbn == "4") {
			univGbnText = '[<spring:message code="crs.label.busi"/>]'; // 전문
		}
		
		$("#univGbnText").text(univGbnText);
	});

	// 평가기준 모달
	function evalCriteriaModal() {
		var crsCreCd = '<c:out value="${crsCreCd}" />';
		var menuType = '<%=SessionInfo.getAuthrtGrpcd(request)%>';
		
		if(menuType.indexOf("PROFESSOR") > -1) {
			$("#evalCriteriaTitle").text("<spring:message code='crs.label.eval.criteria' /><spring:message code='common.mgr' />");	// 평가기준 관리
		} else {
			$("#evalCriteriaTitle").text("<spring:message code='crs.label.eval.criteria' />");	// 평가기준
		}

		$("#evalCriteriaForm > input[name='crsCreCd']").val(crsCreCd);
		$("#evalCriteriaForm").attr("target", "evalCriteriaIfm");
        $("#evalCriteriaForm").attr("action", "/crs/evalCriteriaPop.do");
        $("#evalCriteriaForm").submit();
        $('#evalCriteriaModal').modal('show');

        $("#evalCriteriaForm > input[name='crsCreCd']").val("");
	}

	// 학습독려 모달
	function learnAlarmModal() {
		var crsCreCd = '<c:out value="${crsCreCd}" />';

		$("#learnAlarmForm > input[name='crsCreCd']").val(crsCreCd);
		$("#learnAlarmForm").attr("target", "learnAlarmIfm");
        $("#learnAlarmForm").attr("action", "/crs/learnAlarmPop.do");
        $("#learnAlarmForm").submit();
        $('#learnAlarmModal').modal('show');

        $("#learnAlarmForm > input[name='crsCreCd']").val("");
	}
</script>

<div class="classInfo">
    <h1 <% if(!"Y".equals(SessionInfo.getProfessorVirtualLoginYn(request))) { %>onclick="location.href='<%=SessionInfo.getCurUserHome(request)%>'"<% } %>>
    	<b id="univGbnText" class="fwb"></b>
    	<% 
    	if (StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("USR") && "Y".equals(SessionInfo.getAuditYn(request))) {
    		if ("Y".equals(SessionInfo.getGvupYn(request))) {
    			%>[<spring:message code="crs.label.giveup"/>]<!-- 수강포기 --><%
    		}
    		else {
    			%>[<spring:message code="crs.label.audit"/>]<!-- 청강 --><%
    		}
    	}
    	%>
    	<% if (StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("USR") && "Y".equals(SessionInfo.getRepeatYn(request))) { %>[<spring:message code="crs.label.repeat"/>]<!-- 재수강 --><% }%>
    	<% if (StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request)).contains("USR") && "Y".equals(SessionInfo.getPreCrsYn(request))) { %>[<spring:message code="crs.label.pre_course"/>]<!-- 선수 --><% }%>
    	대학원/대학교</br>
    	<c:out value="${subjectVO.sbjctnm}"/><!-- 과목명 -->복습 , 강의계획서, 학습진도관리, 평가비중
    </h1>
    <div class="classSection">

        <div class="cls_btn">
        	<%
			// 기관:한사대만
	        if (SessionInfo.isKnou(request)) {
	           	%>
	            <a href="#0" onclick="viewLessonPlan();return false;" class="ui bcPurpleAlpha85 button mb5" title="<spring:message code="common.label.class.plan" />"><spring:message code="common.label.class.plan" /></a><!-- 수업계획서 -->
	   	        <%
		        if ("prof".equalsIgnoreCase(SessionInfo.getClassUserType(request))) {
		        	%>
		        	<a href="javascript:void(0)" class="ui bcTealAlpha85 button mb5" onclick="learnAlarmModal()"><spring:message code="common.label.learn.encourage" /></a><!-- 학습독려 -->
		        	<%
		       	}
	   	        %>
	   	        <a href="javascript:void(0)" class="ui bcDarkblueAlpha85 button mb5" onclick="evalCriteriaModal()"><spring:message code="crs.label.eval.criteria" /></a><!-- 평가기준 -->
	   	        <%
	        }
	        else {
	        	%>
				<a href="javascript:void(0)" class="ui bcPeruBlue90 button mb5" onclick="evalCriteriaModal()"><spring:message code="crs.label.eval.criteria" /></a><!-- 평가기준 -->	        	
	        	<%
	        }
            %>
        </div>
    </div>
    <!-- <button class="info-toggle"><i class="ion-minus-round"></i></button> -->
</div>

<!-- 평가기준 팝업 -->
<form id="evalCriteriaForm" name="evalCriteriaForm" method="post" style="position:absolute">
	<input type="hidden" name="crsCreCd" value="" />
</form>
<div class="modal fade in" id="evalCriteriaModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="crs.label.eval.criteria" /><spring:message code="exam.label.manage" />" aria-hidden="false" style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg2" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="evalCriteriaTitle"><spring:message code="crs.label.eval.criteria" /><spring:message code="exam.label.manage" /></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="evalCriteriaIfm" name="evalCriteriaIfm" title="evalCriteriaIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<form id="learnAlarmForm" name="learnAlarmForm" method="post" style="position:absolute">
	<input type="hidden" name="crsCreCd" value="" />
</form>

<div class="modal fade in" id="learnAlarmModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="forum.button.learn.alarm" />" aria-hidden="false" >
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title"><spring:message code="forum.button.learn.alarm" /></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" scrolling="no" id="learnAlarmIfm" name="learnAlarmIfm" title="learnAlarmIfm"></iframe>
            </div>
        </div>
    </div>
</div>

<script>
    $('#evalCriteriaIfm').iFrameResize();
    $('#learnAlarmIfm').iFrameResize();
    window.closeModal = function() {
        $('.modal').modal('hide');
    };

    // 수업계획서 보기
    function viewLessonPlan() {
    	alert("[준비중] 수업계획서")
    }
</script>