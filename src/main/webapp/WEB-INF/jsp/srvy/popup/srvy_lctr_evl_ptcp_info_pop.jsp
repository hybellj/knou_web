<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="dashboard"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <script type="text/javascript">
    	// 강의평가 참여
    	function srvyPtcpPopup() {
			if("${vo.srvyQstnsCmptnyn}" == "Y") {
				if("${vo.srvyPrgrsSts}" == "IN_PROGRESS") {
					window.parent.popupOption.srvyPtcp("${srvyId}", "${vo.srvyId}", "", "", "LCTR");
				} else {
					UiComm.showMessage("<spring:message code='srvy.alert.lctr.evl.already.ptcp.period' />", "info");/* 강의평가 참여기간이 아닙니다. */
				}
			} else {
				UiComm.showMessage("<spring:message code='srvy.alert.qstn.not.completed' />", "info");/* 문제 출제가 완료되지 않았습니다. */
			}
    	}
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-body">
		<div class="flex-item-center margin-bottom-5">
	        <h1 class="logo">
				<img src="/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교">
			</h1>
		</div>

		<div class="sub-box">
			<ul class="flex flex-column gap-2 margin-bottom-5">
				<li class="${fn:contains(vo.srvyTycd, 'MIDEXAM') ? 'fcBlue' : '' }"><b>* <spring:message code="srvy.label.mid.lctr.evl.period" /><!-- 중간 강의평가 기간 --></b></li>
				<li class="${fn:contains(vo.srvyTycd, 'LSTEXAM') ? 'fcBlue' : '' }"><b>* <spring:message code="srvy.label.lst.lctr.evl.period" /><!-- 기말 강의평가 기간 --></b></li>
				<li><b>* <spring:message code="srvy.label.ptcp.target" /><!-- 참여대상 --> : ${vo.srvyTrgtGbnnm }</b></li>
			</ul>
			<ul class="flex flex-column gap-2 margin-bottom-5">
				<c:set var="smstr" value="" />
				<c:choose>
					<c:when test="${fn:contains(vo.srvyTycd, 'MIDEXAM') }">
						<c:set var="smstr"><spring:message code="srvy.label.mid.exam" /></c:set>
					</c:when>
					<c:otherwise>
						<c:set var="smstr"><spring:message code="srvy.label.lst.exam" /></c:set>
					</c:otherwise>
				</c:choose>
				<li class="fcBlue"><b><spring:message code="srvy.label.lctr.evl.ptcp.info.1" arguments="${smstr }" /><!-- * 지금은 [{0} 강의평가] 기간입니다. --></b></li>
				<li><spring:message code="srvy.label.lctr.evl.ptcp.info.2" /><!-- * 과목에 대한 수강생 여러분의 의견을 수렴하기 위해 진행되는 평가로서 의무 참여사항은 아닙니다. --></li>
				<li><spring:message code="srvy.label.lctr.evl.ptcp.info.3" /><!-- * 본 강의평가 결과는 학생들의 의견 수렴 및 반영, 수업의 질 향상과 교사/강사 평가 등을 위한 중요한 자료로 활용됩니다. --></li>
				<li><spring:message code="srvy.label.lctr.evl.ptcp.info.4" /><!-- * 모든 학생들은 본인이 수강한 과목에 대해서 강의평가를 실시하여 주시기 바랍니다. --></li>
			</ul>
			<ul class="flex flex-column gap-2">
				<li class="fcBlue"><b><spring:message code="srvy.label.lctr.evl.ptcp.info.5" /><!-- * [기말 강의평가] 해당사항입니다. --></b></li>
				<li><spring:message code="srvy.label.lctr.evl.ptcp.info.6" /><!-- * 수강 과목에 대한 강의평가를 실시하지 않은 학생은 성적열람기간에 해당 과목 성적을 열람할 수 없습니다. --></li>
				<li><spring:message code="srvy.label.lctr.evl.ptcp.info.7" /><!-- * 강의실에서 미완료 된 과목의 강의평가를 완료하여 주십시오. --></li>
				<li><spring:message code="srvy.label.lctr.evl.ptcp.info.8" /><!-- * 성적열람기간부터 강의평가 내용 수정은 불가합니다. --></li>
			</ul>
		</div>

		<div class="modal_btns">
        	<button class="btn type2" onclick="srvyPtcpPopup();"><spring:message code="srvy.button.lctr.evl.ptcp" /><!-- 강의평가 참여 --></button>
        	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
        </div>

		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
