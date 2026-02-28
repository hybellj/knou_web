<%@page import="knou.framework.util.StringUtil"%>
<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<%
String alertMsg = StringUtil.nvl((String)session.getServletContext().getAttribute("ALERT_MESSAGE"));
String isError = "N";
if (!"".equals(alertMsg)) {
	isError = "Y";
	session.getServletContext().setAttribute("ALERT_MESSAGE", "");
}
%>

<script type="text/javascript">
$(document).ready(function(){
	if ("<%=isError%>" == "Y") {
		alert("<%=alertMsg%>");
		document.location.href = "/crs/termMgr/Form/crsTermForm.do";
	}
});

function check(gubun) {
	var termType1 = "NORMAL";
	var haksaYear1 = $("#haksaYear").val();
	var haksaTerm1 = $("#haksaTerm option:selected").val();
	var termNm = $("#termNm").val();
	var haksaNm;
	
	if(isEmpty($("#termNm").val())) {
		 alert("<spring:message code='crs.confirm.insert.semester.name'/>"); // 학기명을 입력해주세요.
		 $("#termNm").focus();
		 return;
	}
	if(isEmpty($("#haksaYear").val())) {
		 alert("<spring:message code='crs.confirm.insert.school.year'/>"); // 학사 년도를 입력해주세요.
		 return;
	}

	if($("#svcStartDt").val() == "") {
		alert("<spring:message code='crs.confirm.insert.operation.svc.start'/>"); // 강의시작일자를 입력해주세요.
		$("#svcStartDt").focus();
		return;
	}
	if($("#svcEndtDt").val() == "") {
		alert("<spring:message code='crs.confirm.insert.operation.svc.end'/>"); // 복습기간종료일자를 입력해주세요.
		$("#svcEndtDt").focus();
		return;
	}

	/*
	if(isEmpty($("#svcStartDttm").val() && $("#svcEndDttm").val())) {
		 alert("<spring:message code='crs.confirm.insert.operation.period'/>"); // 운영 기간을 입력해주세요.
		 return;
	}

	if(isEmpty($("#enrlStartDttm").val() && $("#enrlEndDttm").val())) {
		alert("<spring:message code='crs.confirm.insert.lecture.period'/>"); // 강의 기간을 입력해주세요.
		return;
		
	} else {
		if($("#svcStartDttm").val() > $("#enrlStartDttm").val()) {
			alert("<spring:message code='crs.confirm.setting.lecture.period.in.operation.period'/>"); // 강의 기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
		if($("#svcEndDttm").val() < $("#enrlEndDttm").val()) {
			alert("<spring:message code='crs.confirm.setting.lecture.period.in.operation.period'/>"); // 강의 기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
	}

	// 수강신청 기간
	if(!isEmpty($("#enrlAplcStartDttm").val() && $("#enrlAplcStartDttm").val())) {
		if($("#svcStartDttm").val() > $("#enrlAplcStartDttm").val()) {
			alert("<spring:message code='crs.confirm.setting.register.course.period.in.operation.period'/>"); // 수강 신청 기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
		if($("#svcEndDttm").val() < $("#enrlAplcStartDttm").val()) {
			alert("<spring:message code='crs.confirm.setting.register.course.period.in.operation.period'/>"); // 수강 신청 기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
	}

	// 성적평가기간
	if(!isEmpty($("#scoreEvalStartDttm").val() && $("#scoreEvalEndDttm").val())) {
		if($("#svcStartDttm").val() > $("#scoreEvalStartDttm").val()) {
			alert("성적 평가 기간을 운영 기간 안으로 설정 바랍니다."); // 성적 평가 기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
		if($("#svcEndDttm").val() < $("#scoreEvalEndDttm").val()) {
			alert("성적 평가  기간을 운영 기간 안으로 설정 바랍니다."); // 성적 평가  기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
	}

	// 성적공개기간
	if(!isEmpty($("#scoreOpenStartDttm").val() && $("#scoreOpenEndDttm").val())) {
		if($("#svcStartDttm").val() > $("#scoreOpenStartDttm").val()) {
			alert("<spring:message code='crs.confirm.setting.open.score.period.in.operation.period'/>"); // 성적 공개 기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
		if($("#svcEndDttm").val() < $("#scoreOpenEndDttm").val()) {
			alert("<spring:message code='crs.confirm.setting.open.score.period.in.operation.period'/>"); // 성적 공개  기간을 운영 기간 안으로 설정 바랍니다.
			return;
		}
	}
	*/
	
	var type = "";
	// 학기 중복 검사
	$.ajax({   
		type : "POST", 
		cache : false,
		url : "/crs/termMgr/crsTermCheck.do",
		data: {
				"termType" :termType1, 
				"haksaYear" : haksaYear1, 
				"haksaTerm" : haksaTerm1
		},
		dataType: "json",
		success : function(data) {	
		 if(data.count > 0) {
				if("${termVo.termCd}" != "") {
					add(gubun);
				} else {
					
					if(haksaTerm1 == "10") {
						haksaNm = "1학기";
					} else if(haksaTerm1 == "11") {
						haksaNm = "여름학기";
					} else if(haksaTerm1 == "20") {
						haksaNm = "2학기";
					} else if(haksaTerm1 == "21") {
						haksaNm = "겨울학기";
					}
					
					// 중복
					alert(haksaYear1+'<spring:message code="common.haksa.year"/>'+ haksaNm+'<spring:message code="crs.alert.already.data.in.school.year"/>');
					return;
				}
			} else {
				// 중복 아님
				add(gubun);
			}
		},
		error : function(request, status, error){
			alert("<spring:message code='crs.pop.regist.course.fail'/>"); // 학기 등록 실패하였습니다.
			return;
		}
	});
}

function add(gubun) {
	var termType = "NORMAL";
	var haksaYear = $("#haksaYear").val();
	var haksaTerm = $("#haksaTerm option:selected").val();
	var termStatus = $("#termStatus option:selected").val();
	
	var svcStartDttm = $("#svcStartDt").val().replaceAll('.','-') + ' ' + $("#svcStartHh").val() + ':' + $("#svcStartMm").val();
	var svcEndDttm = $("#svcEndtDt").val().replaceAll('.','-') + ' ' + $("#svcEndtHh").val() + ':' + $("#svcEndtMm").val();

	<%
	if (!SessionInfo.isKnou(request)) {
		%>
		var scoInputStartDttm = $("#scoInputStartDt").val().replaceAll('.','-') + ' ' + $("#scoInputStartHh").val() + ':' + $("#scoInputStartMm").val();
		var scoInputEndDttm   = $("#scoInputEndDt"  ).val().replaceAll('.','-') + ' ' + $("#scoInputEndHh"  ).val() + ':' + $("#scoInputEndMm"  ).val();
		var scoViewStartDttm  = $("#scoViewStartDt" ).val().replaceAll('.','-') + ' ' + $("#scoViewStartHh" ).val() + ':' + $("#scoViewStartMm" ).val();
		var scoViewEndDttm    = $("#scoViewEndDt"   ).val().replaceAll('.','-') + ' ' + $("#scoViewEndHh"   ).val() + ':' + $("#scoViewEndMm"   ).val();
		var scoObjtStartDttm  = $("#scoObjtStartDt" ).val().replaceAll('.','-') + ' ' + $("#scoObjtStartHh" ).val() + ':' + $("#scoObjtStartMm" ).val();
		var scoObjtEndDttm    = $("#scoObjtEndDt"   ).val().replaceAll('.','-') + ' ' + $("#scoObjtEndHh"   ).val() + ':' + $("#scoObjtEndMm"   ).val();
		var scoRechkStartDttm = $("#scoRechkStartDt").val().replaceAll('.','-') + ' ' + $("#scoRechkStartHh").val() + ':' + $("#scoRechkStartMm").val();
		var scoRechkEndDttm   = $("#scoRechkEndDt"  ).val().replaceAll('.','-') + ' ' + $("#scoRechkEndHh"  ).val() + ':' + $("#scoRechkEndMm"  ).val();
		
		if ($("#scoInputStartDt").val() != "") $("#scoInputStartDttm").val(scoInputStartDttm);
		if ($("#scoInputEndDt"  ).val() != "") $("#scoInputEndDttm"  ).val(scoInputEndDttm  );
		if ($("#scoViewStartDt" ).val() != "") $("#scoViewStartDttm" ).val(scoViewStartDttm );
		if ($("#scoViewEndDt"   ).val() != "") $("#scoViewEndDttm"   ).val(scoViewEndDttm   );
		if ($("#scoObjtStartDt" ).val() != "") $("#scoObjtStartDttm" ).val(scoObjtStartDttm );
		if ($("#scoObjtEndDt"   ).val() != "") $("#scoObjtEndDttm"   ).val(scoObjtEndDttm   );
		if ($("#scoRechkStartDt").val() != "") $("#scoRechkStartDttm").val(scoRechkStartDttm);
		if ($("#scoRechkEndDt"  ).val() != "") $("#scoRechkEndDttm"  ).val(scoRechkEndDttm  );
		<%
	}
	%>
	
	$("#crsForm").attr("action","/crs/termMgr/addTerm.do");
	$("#termType").val(termType);
	$("#termStatus").val(termStatus);
	$("#gubun").val(gubun);
	$("#svcStartDttm").val(svcStartDttm);
	$("#svcEndDttm").val(svcEndDttm);
	$('#crsForm').submit();
}

function next() {
	var termCdVal = "${termVo.termCd}";
	if(termCdVal == "") {
		alert("<spring:message code='crs.confirm.register.course.info'/>"); // 학기 정보를 등록 바랍니다.
		return;
	} else {
		$("#crsForm").attr("action","/crs/termMgr/Form/crsTermLessonForm.do");
		$("#crsForm").submit();	
	}
}

function changeoffLessonMgtYn() {
	if($("input:checkbox[name=offLessonMgt]").is(":checked") == true) {
		$('input[name=offLessonMgtYn]').val('Y');
	} else {
		$('input[name=offLessonMgtYn]').val('N');
	}
}
</script>

<form class="ui form" id="crsForm" method="POST" commandName="termVo" action="">
<input type="hidden" id="termCd" name="termCd" value="${termVo.termCd}">
<input type="hidden" id="orgId" name="orgId"  value="${termVo.orgId}">
<input type="hidden" id="gubun" name="gubun">
<input type="hidden" id="svcStartDttm" name="svcStartDttm">
<input type="hidden" id="svcEndDttm" name="svcEndDttm">
<input type="hidden" id="scoInputStartDttm" name="scoInputStartDttm">
<input type="hidden" id="scoInputEndDttm"   name="scoInputEndDttm">
<input type="hidden" id="scoViewStartDttm"  name="scoViewStartDttm">
<input type="hidden" id="scoViewEndDttm"    name="scoViewEndDttm">
<input type="hidden" id="scoObjtStartDttm"  name="scoObjtStartDttm">
<input type="hidden" id="scoObjtEndDttm"    name="scoObjtEndDttm">
<input type="hidden" id="scoRechkStartDttm" name="scoRechkStartDttm">
<input type="hidden" id="scoRechkEndDttm"   name="scoRechkEndDttm">

<body>
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
            
				<div id="info-item-box">
					<h2 class="page-title">
						<spring:message code="common.term"/>/<spring:message code="common.week"/> <spring:message code="common.mgr"/> <spring:message code="button.write"/>
					</h2>
					<div class="button-area">
						<a href="#0" onclick="check('next');" class="btn"><spring:message code='button.next'/></a> <%-- 다음 --%>
						<a href="#0" class="btn btn-primary" onclick="check();"><spring:message code='button.add'/></a> <%-- 저장 --%>
						<a href="/crs/termMgr/Form/crsTermForm.do" class="btn btn-negative"><spring:message code='button.cancel'/></a> <%-- 취소 --%>
					</div>
				</div>
	
				<div class="ui form">
					<ol class="cd-multi-steps text-bottom count">
						 <li class="current"><span><spring:message code='crs.label.register.course.info'/></span></li> <%-- 학기 정보 등록 --%>
						 <li class="cp" onclick="next();"><span><spring:message code='crs.label.semester.week.setting'/></span></li> <%-- 학기 주차 설정 --%>
					</ol>
					<div class="ui grid stretched row">
						<div class="sixteen wide tablet eight wide computer column" style="width:40% !important">
							<div class="ui segment">
								<ul class="tbl-simple">
									<%-- 
									<li>
										<dl>
											<dt><label for="caLabel" class="req"><spring:message code="common.type"/></label></dt> 구분
											<dd>
												<select class="ui dropdown"  id="termType" name="termType">
													<c:forEach items="${termTypeList}" var="item" varStatus="status">
													<option  value="${item.codeCd}" <c:if test="${item.codeCd eq termVo.termType}">selected</c:if>>${item.codeNm}</option>
													</c:forEach>
												</select>
											</dd>
										</dl>
									</li> 
									--%>
									<li>
										<dl>
											<dt><label for="subjectLabel" class="req"><spring:message code="crs.title.term.name"/></label></dt> <%-- 학기명 --%>
											<dd>
												<div class="ui fluid input error">
													<input type="text" id="termNm" name="termNm" value="${termVo.termNm}">
												</div>
											</dd>
										</dl>
									</li>
									
									<%--
									<li>
										<dl>
											<dt><label for="yearLabel" class="req"><spring:message code="crs.label.school.year"/></label></dt> 학사년도
											<dd>
												<div class="ui input">
													<input type="text" id="haksaYear" name="haksaYear" value="${termVo.haksaYear}" onkeyup="isChkNumber(this)">
												</div>
											</dd>
										</dl>
									</li> 
									--%>
									<li>
		                                <dl>
		                                    <dt><label for="haksaYear" class="req"><spring:message code="resh.label.term.year" /></label></dt><!-- 학사년도 -->
		                                    <dd>
		                                        <select class="ui dropdown" id="haksaYear" name="haksaYear">
						                    		<c:forEach items="${yearList}" var="yearList">
		                                          		<option  value="${yearList}" <c:if test="${yearList eq termVo.haksaYear}">selected</c:if>>${yearList}</option>
		                                            </c:forEach>
		                                        </select>
		                                    </dd>
		                                </dl>
		                            </li>
									<li>
										<dl>
											<dt><label for="semesterLabel" class="req"><spring:message code="common.term"/></label></dt> <%-- 학기 --%>
											<dd>
												<select class="ui dropdown" id="haksaTerm" name="haksaTerm">
													<c:forEach items="${haksaTermList}" var="haksaTermListItem" varStatus="haksaTermListStatus">
													  	<option  value="${haksaTermListItem.codeCd}" <c:if test="${haksaTermListItem.codeCd eq termVo.haksaTerm}">selected</c:if>>${haksaTermListItem.codeNm}</option>
													</c:forEach>
												</select>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="semesterLabel" class="req"><spring:message code="crs.label.semester.status"/></label></dt> <%-- 학기 상태 --%>
											<dd>
												 <select class="ui dropdown" id="termStatus" name="termStatus">
													<c:forEach items="${termStatustList}" var="termStatusItem" varStatus="termStatusStatus">
													  	<option  value="${termStatusItem.codeCd}" <c:if test="${termStatusItem.codeCd eq termVo.termStatus}">selected</c:if>>${termStatusItem.codeNm}</option>
													</c:forEach>
												</select>
											</dd>
										</dl>
									</li>
									<%--
									<li>
										<dl>
											<dt><label for="linkageLabel"><spring:message code='crs.label.offline.week.data'/></label></dt> 오프라인 주차 생성 여부
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio"  class="hidden" name="offLessonMgtYn" value="Y" <c:if test="${termVo.offLessonMgtYn eq 'Y'}">checked</c:if>  tabindex="0"/>
															<label><spring:message code="message.yes"/></label> 예
														</div>
													</div>
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio"  class="hidden" name="offLessonMgtYn" value="N" <c:choose><c:when test="${termVo.offLessonMgtYn eq 'N'}">checked</c:when>
															<c:when test="${empty termVo.offLessonMgtYn}">checked</c:when></c:choose>  tabindex="0"/>
															<label><spring:message code="message.no"/></label> 아니오
														</div>
													</div>
												</div>
											</dd>
										</dl>
									</li>
									--%>
									<li>
										<dl>
											<dt><label for="linkageLabel"><spring:message code="crs.label.checked.course.connected"/></label></dt> <%-- 학사연동 여부 --%>
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" class="hidden" name="termLinkYn" value="Y" <c:if test="${termVo.termLinkYn eq 'Y'}">checked</c:if> <c:if test="${termVo.orgId ne 'ORG0000001'}">readonly</c:if>  tabindex="0"/>
															<label><spring:message code='message.yes'/></label> <%-- 예 --%>
														</div>
													</div>
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio"  class="hidden" name="termLinkYn" value="N" <c:choose><c:when test="${termVo.termLinkYn eq 'N'}">checked</c:when>
															<c:when test="${empty termVo.termLinkYn}">checked</c:when></c:choose> <c:if test="${termVo.orgId ne 'ORG0000001'}">readonly</c:if> tabindex="0"/>
															<label><spring:message code='message.no'/></label> <%-- 아니오 --%>
														</div>
													</div>
												</div>
											</dd>
										</dl>
									</li>
								</ul>
							</div>
						</div>
						<div class="sixteen wide tablet eight wide computer column" style="min-width:820px !important">
							<div class="ui segment">
								<ul class="tbl-simple">
									<li>
							            <dl>
							                <dt class="w150"><label for="svcStartDt" class="req"><spring:message code="lesson.label.lesson.start.dttm" /></label></dt><!-- 강의시작일자 -->
							                <dd>
							                	<div class="fields gap4">
							                        <div class="field flex">
							                           <uiex:ui-calendar dateId="svcStartDt" hourId="svcStartHh" minId="svcStartMm" rangeType="start" value="${termVo.svcStartDttm}"/>
							                        </div>
							                    </div>
							                </dd>
							            </dl>
							        </li>
									<li>
							            <dl>
							                <dt class="w150"><label for="svcEndDttm" class="req"><spring:message code="review.lecture.EndDttm"/></label></dt><!-- 복습기간종료일자 -->
							                <dd>
							                	<div class="fields gap4">
							                        <div class="field flex">
							                           <uiex:ui-calendar dateId="svcEndtDt" hourId="svcEndtHh" minId="svcEndtMm" rangeType="end" value="${termVo.svcEndDttm}"/>
							                        </div>
							                    </div>
							                </dd>
							            </dl>
							        </li>
									<%
									if (!SessionInfo.isKnou(request)) {
										%>
										<li>
								            <dl>
								                <dt class="w150"><label for="scoInputStartDt" class=""><spring:message code="crs.label.job.sco_input_date"/></label></dt><!-- 성적입력기간 -->
								                <dd>
								                	<div class="fields gap4">
								                        <div class="field flex">
								                           <uiex:ui-calendar dateId="scoInputStartDt" hourId="scoInputStartHh" minId="scoInputStartMm" rangeType="start" value="${termVo.scoInputStartDttm}" rangeTarget="scoInputEndDt" />
								                        </div>
								                        <span>~</span>
								                        <div class="field flex">
								                           <uiex:ui-calendar dateId="scoInputEndDt" hourId="scoInputEndHh"  minId="scoInputEndMm" rangeType="end" value="${termVo.scoInputEndDttm}" rangeTarget="scoInputStartDt"/>
								                        </div>
								                    </div>
								                </dd>
								            </dl>
								        </li>
								        <li>
								            <dl>
								                <dt class="w150"><label for="scoViewStartDt" class=""><spring:message code="crs.label.job.sco_view_date"/></label></dt><!-- 성적조회기간 -->
								                <dd>
								                	<div class="fields gap4">
								                		<div class="field flex">
								                           <uiex:ui-calendar dateId="scoViewStartDt" hourId="scoViewStartHh" minId="scoViewStartMm" rangeType="start" value="${termVo.scoViewStartDttm}" rangeTarget="scoViewEndDt" />
								                        </div>
								                        <span>~</span>
								                        <div class="field flex">
								                           <uiex:ui-calendar dateId="scoViewEndDt" hourId="scoViewEndHh"  minId="scoViewEndMm" rangeType="end" value="${termVo.scoViewEndDttm}" rangeTarget="scoViewStartDt"/>
								                        </div>
								                    </div>
								                </dd>
								            </dl>
								        </li>
								        <li>
								            <dl>
								                <dt class="w150"><label for="scoObjtStartDt" class=""><spring:message code="crs.label.job.sco_objt_date"/></label></dt><!-- 성적재확인신청기간 -->
								                <dd>
								                	<div class="fields gap4">
								                		<div class="field flex">
								                           <uiex:ui-calendar dateId="scoObjtStartDt" hourId="scoObjtStartHh" minId="scoObjtStartMm" rangeType="start" value="${termVo.scoObjtStartDttm}" rangeTarget="scoObjtEndDt" />
								                        </div>
								                        <span>~</span>
								                        <div class="field flex">
								                           <uiex:ui-calendar dateId="scoObjtEndDt" hourId="scoObjtEndHh"  minId="scoObjtEndMm" rangeType="end" value="${termVo.scoObjtEndDttm}" rangeTarget="scoObjtStartDt"/>
								                        </div>
								                    </div>
								                </dd>
								            </dl>
								        </li>
								        <li>
								            <dl>
								                <dt class="w150"><label for="scoRechkStartDt" class=""><spring:message code="crs.label.job.sco_rechk_date"/></label></dt><!-- 성적재확인신청 정정기간 -->
								                <dd>
								                	<div class="fields gap4">
								                		<div class="field flex">
								                           <uiex:ui-calendar dateId="scoRechkStartDt" hourId="scoRechkStartHh" minId="scoRechkStartMm" rangeType="start" value="${termVo.scoRechkStartDttm}" rangeTarget="scoRechkEndDt" />
								                        </div>
								                        <span>~</span>
								                        <div class="field flex">
								                           <uiex:ui-calendar dateId="scoRechkEndDt" hourId="scoRechkEndHh"  minId="scoRechkEndMm" rangeType="end" value="${termVo.scoRechkEndDttm}" rangeTarget="scoRechkStartDt"/>
								                        </div>
								                    </div>
								                </dd>
								            </dl>
								        </li>
								        <%
									}
							        %>

									<%-- 
									<li>
										<dl>
											<dt><label for="svcModifyLabel" class="req"><spring:message code="lesson.label.lesson.start.dttm" /></label></dt> <!-- 강의시작일자 -->
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="svcstartdt">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="svcStartDtString" value="${termVo.svcStartDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="svcStartDT" value="${svcStartDtString}" pattern="yyyy.MM.dd HH:mm" />
																<input type="text" autocomplete="off" id="svcStartDttm" name="svcStartDttm"  placeholder="<spring:message code='common.start.date'/>"  value="${svcStartDT}">
																<form:errors path="svcStartDT" />
															</div>
														</div>
													</div>
												</div>
												<script>
													$('#svcstartdt').calendar({
														type: 'datetime',
														ampm: false,
														endCalendar: $('#svcendtdt'),
														formatter: {
															date: function(date, settings) {
																if (!date) return '';
																var day  = (date.getDate()) + '';
																	if(day.length < 2) {
																		day = '0' + day;
																  	}
																var month = settings.text.monthsShort[date.getMonth()];
																  	if (month.length < 2) {
																		month = '0' + month;
																  	}
																var year = date.getFullYear();
																return year + '.' + month + '.' + day;
															}
														} 
													});
												</script>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="svcModifyLabel" class="req"><spring:message code="review.lecture.EndDttm"/></label></dt> <!-- 복습기간종료일자 -->
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="svcendtdt">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="svcEndDtString" value="${termVo.svcEndDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="svcEndDT" value="${svcEndDtString}" pattern="yyyy.MM.dd HH:mm" />
																<input type="text" autocomplete="off" id="svcEndDttm"  name="svcEndDttm" placeholder="<spring:message code='common.enddate'/>" value="${svcEndDT}">
																<form:errors path="svcEndDT" />
															</div>
														</div>
													</div>
												</div>
												<script>
													$('#svcendtdt').calendar({
														type: 'datetime',
														ampm: false,
														startCalendar: $('#svcstartdt'),
														formatter: {
															date: function(date, settings) {
																if (!date) return '';
																var day  = (date.getDate()) + '';
								 									if(day.length < 2) {
								 										day = '0' + day;
																	}
																var month = settings.text.monthsShort[date.getMonth()];
																	if (month.length < 2) {
																		month = '0' + month;
																  	}
																var year = date.getFullYear();
																return year + '.' + month + '.' + day;
															}
														} 
													});
												</script>
											</dd>
										</dl>
									</li> --%>
									
								  	<%-- 
								  	<li>
										<dl>
											<dt><label for="svcModifyLabel" class="req"><spring:message code="crs.label.operation.period"/></label></dt> 운영 기간
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="svcstartdt">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="svcStartDtString" value="${termVo.svcStartDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="svcStartDT" value="${svcStartDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="svcStartDttm" name="svcStartDttm"  placeholder="<spring:message code='common.start.date'/>"  value="${svcStartDT}"> 시작일
																<form:errors path="svcStartDT" />
															</div>
														</div>
													</div>
													<div class="field">
														<div class="ui calendar" id="svcendtdt">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="svcEndDtString" value="${termVo.svcEndDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="svcEndDT" value="${svcEndDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="svcEndDttm"  name="svcEndDttm" placeholder="<spring:message code='common.enddate'/>" value="${svcEndDT}"> 종료일
																<form:errors path="svcEndDT" />
															</div>
														</div>
													</div>
												</div>
												<script>
													  $('#svcstartdt').calendar({
														  type: 'datetime',
														  endCalendar: $('#svcendtdt'),
														 formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day;
															  }
														  } 
													  });
													  $('#svcendtdt').calendar({
														  type: 'datetime',
														  startCalendar: $('#svcstartdt'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day;
															  }
														  } 
													  });
												</script>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="enrollModifyLabel" class="req"><spring:message code='common.label.lecture.period'/></label></dt> 강의 기간
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="enrlstartdttm">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="enrlStartDtString" value="${termVo.enrlStartDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="enrlStartDT" value="${enrlStartDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="enrlStartDttm" name="enrlStartDttm" placeholder="<spring:message code='common.start.date'/>" value="${enrlStartDT}"> <!-- 시작일 -->
															</div>
														</div>
													</div>
													<div class="field">
														<div class="ui calendar" id="enrlenddttm">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="enrlEndDtString" value="${termVo.enrlEndDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="enrlEndDT" value="${enrlEndDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="enrlEndDttm" name="enrlEndDttm" placeholder="<spring:message code='common.enddate'/>" value="${enrlEndDT}"> <!-- 종료일 -->
															</div>
														</div>
													</div>
												</div>
												<script>
													  $('#enrlstartdttm').calendar({
														  type: 'datetime',
														  endCalendar: $('#enrlenddttm'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day;
															  }
														  } 
													  });
													  $('#enrlenddttm').calendar({
														  type: 'datetime',
														  startCalendar: $('#enrlstartdttm'),											
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day;
															  }
														  } 
													  });
												</script>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="enrollLabel"><spring:message code='crs.lecture.request.period'/></label></dt> <!-- 수강 신청 기간 -->
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="enrlaplcstart">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="enrlAplcStartDtString" value="${termVo.enrlAplcStartDttm}" pattern="yyyyMMddHHmmss"/>
																<fmt:formatDate var="enrlAplcStartDT" value="${enrlAplcStartDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="enrlAplcStartDttm" name="enrlAplcStartDttm" placeholder="<spring:message code='common.start.date'/>" value="${enrlAplcStartDT}"> <!-- 시작일 -->
															</div>
														</div>
													</div>
													<div class="field">
														<div class="ui calendar" id="enrlaplcend">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="enrlAplcEndDtString" value="${termVo.enrlAplcEndDttm}" pattern="yyyyMMddHHmmss"/>
																<fmt:formatDate var="enrlAplcEndDT" value="${enrlAplcEndDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="enrlAplcEndDttm" name="enrlAplcEndDttm"  placeholder="<spring:message code='common.enddate'/>" value="${enrlAplcEndDT}"> <!-- 종료일 -->
															</div>
														</div>
													</div>
												</div>
												<script>
													  $('#enrlaplcstart').calendar({
														  type: 'datetime',
														  endCalendar: $('#enrlaplcend'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day ;
															  }
														  } 
													  });
													  $('#enrlaplcend').calendar({
														  type: 'datetime',
														  startCalendar: $('#enrlaplcstart'),											  
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day ;
															  }
														  } 
													  });
												</script>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="learningLabel"><spring:message code='crs.score.process.period'/></label></dt> <!-- 성적 처리 기간 -->
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="scoreevalstart">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="scoreEvalStartDtString" value="${termVo.scoreEvalStartDttm}" pattern="yyyyMMddHHmmss"/>
																<fmt:formatDate var="scoreEvalStartDT" value="${scoreEvalStartDtString}" pattern="yyyy.MM.dd"/>
																<input type="text" autocomplete="off" id="scoreEvalStartDttm" name="scoreEvalStartDttm" placeholder="<spring:message code='common.start.date'/>" value="${scoreEvalStartDT}" > <!-- 시작일 -->
															</div>
														</div>
													</div>
													<div class="field">
														<div class="ui calendar" id="scoreevalend">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="scoreEvalEndDtString" value="${termVo.scoreEvalEndDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="scoreEvalEndDT" value="${scoreEvalEndDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="scoreEvalEndDttm" name="scoreEvalEndDttm"  placeholder="<spring:message code='common.enddate'/>" value="${scoreEvalEndDT}"> <!-- 종료일 -->
															</div>
														</div>
													</div>
												</div>
												<script>
													  $('#scoreevalstart').calendar({
														  type: 'datetime',
														  endCalendar: $('#scoreevalend'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day ;
															  }
														  } 
													  });
													  $('#scoreevalend').calendar({
														  type: 'datetime',
														  startCalendar: $('#scoreevalstart'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
							 									 if (day.length < 2) {
							 										 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day ;
															  }
														  } 
													  });
												</script>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="learningLabel">성적 공개 기간</label></dt> <!-- 성적 공개 기간 -->
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui calendar" id="scoreopenstart">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="scoreOpenStartDtString" value="${termVo.scoreOpenStartDttm}" pattern="yyyyMMddHHmmss"/>
																<fmt:formatDate var="scoreOpenStartDT" value="${scoreOpenStartDtString}" pattern="yyyy.MM.dd"/>
																<input type="text" autocomplete="off" id="scoreOpenStartDttm" name="scoreOpenStartDttm" placeholder="<spring:message code='common.start.date'/>" value="${scoreOpenStartDT}" > <!-- 시작일 -->
															</div>
														</div>
													</div>
													<div class="field">
														<div class="ui calendar" id="scoreopenend">
															<div class="ui input left icon">
																<i class="calendar alternate outline icon"></i>
																<fmt:parseDate var="scoreOpenEndDtString" value="${termVo.scoreOpenEndDttm}" pattern="yyyyMMddHHmmss" />
																<fmt:formatDate var="scoreOpenEndDT" value="${scoreOpenEndDtString}" pattern="yyyy.MM.dd" />
																<input type="text" autocomplete="off" id="scoreOpenEndDttm" name="scoreOpenEndDttm"  placeholder="<spring:message code='common.enddate'/>" value="${scoreOpenEndDT}"> <!-- 종료일 -->
															</div>
														</div>
													</div>
												</div>
												<script>
													  $('#scoreopenstart').calendar({
														  type: 'datetime',
														  endCalendar: $('#scoreopenend'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
																 if (day.length < 2) {
																	 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day ;
															  }
														  } 
													  });
													  $('#scoreopenend').calendar({
														  type: 'datetime',
														  startCalendar: $('#scoreopenstart'),
														   formatter: {
															  date: function(date, settings) {
																  if (!date) return '';
																  var day  = (date.getDate()) + '';
																  var month = settings.text.monthsShort[date.getMonth()];
																  if (month.length < 2) {
																	  month = '0' + month;
																  }
																 if (day.length < 2) {
																	 day = '0' + day;
																  }
																  var year = date.getFullYear();
																  return year + '.' + month + '.' + day ;
															  }
														  } 
													  });
												</script>
											</dd>
										</dl>
									</li> 
									--%> 
								</ul>
							</div>
						</div>
					</div>
				</div>
            </div><!-- //content -->
        </div><!-- //container -->
    	<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div><!-- //wrap -->
</body>				
</form>
</html>