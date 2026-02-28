<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	if("${vo.crsTypeCd}" == "CO") {
		$("#crsTypeCdCo").addClass("active"); 
	} else if("${vo.crsTypeCd}" == "UNI") {
		$("#crsTypeCdUni").addClass("active"); 
		$('.dimmer').dimmer({closable: false}).dimmer('show');
	} else if("${vo.crsTypeCd}" == "LEGAL") {
		$("#crsTypeCdLegal").addClass("active"); 
		$('.dimmer').dimmer({closable: false}).dimmer('show');
	} else if("${vo.crsTypeCd}" == "OPEN") {
		$("#crsTypeCdOpen").addClass("active"); 
		$('.dimmer').dimmer({closable: false}).dimmer('show');
	} else {
	}
	fn_nopLimitYn($('input[name="nopLimitYn"]:checked').val());
});

function setCrsCtgr(ctgrCd, ctgrNm) {
	$('#crsCtgrCd').val(ctgrCd);
}

<%--1. 수강 인원 제한 --%>
function fn_nopLimitYn(nopLimitYn) {
	if (nopLimitYn == 'N') {
		$("#stdcnt").hide();
	} else {
		$("#stdcnt").show();
	}
}

<%-- 2. 수료 처리 방법--%>
function chkOperType() {
	var cpltHandlType = $('input[name="cpltHandlType"]:checked').val();
	var pcpltHandlTypeAt = $('input:radio[id=cpltHandlType]').is(':checked');
	var pcpltHandlTypeMa = $('input:radio[id=cpltHandlTypeMa]').is(':checked');

	if(cpltHandlType == "MA" && $("#crsOperTypeCd").val() == "S") {
		alert('<spring:message code="crs.ordinary.course.can.auto.certification.process"/>'); <%-- 상시과정은 자동 수료 처리만 가능합니다.--%>
		$("input[value='MA']").attr('checked', false);
		$("input[value='AT']").attr('checked', true);
	}

	<c:if test="${gubun eq 'E'}">
	if(cpltHandlType == "MA" && $("#crsOperTypeCdEdit").val() == "S") {
		alert('<spring:message code="crs.ordinary.course.can.auto.certification.process"/>'); <%-- 상시과정은 자동 수료 처리만 가능합니다.--%>
		$('input:radio[name="cpltHandlType"]').filter('[value="MA"]').attr('checked', false);
		$('input:radio[name="cpltHandlType"]').filter('[value="AT"]').attr('checked', true);
	}
	</c:if>
}

function isChkNumber(obj) {
	var val = obj.value;
	val = val.replace(",","");
	val = val.replace(".","");
	if(!isNumber(val)) {
		/* 숫자만 입력 가능합니다. */
		alert('<spring:message code="asmnt.alert.input.only.number" />');
		obj.value = parseInteger(val);
		return;
	}
}

function isChkMaxNumber(obj, maxval, preval) {
	var val = obj.value;
	val = val.replace(",","");
	if(!isNumber(val)) {
		/* 숫자만 입력 가능합니다. */
		alert('<spring:message code="asmnt.alert.input.only.number" />');
		obj.value = parseInteger(val);
		return;
	}
	if(parseInt(val,10) > maxval) {
		/* * 총합이 100이 되도록 설정해야 합니다. */
		alert('<spring:message code="crs.confirm.total.count.must.hundred" />');
		obj.select();
		if(!isNumber(preval)){preval=0;}
		obj.value = preval;
		obj.focus();
		return;
	}
}

// 입력된 값의
function parseInteger(str) {
	var ptn = "0123456789";
	var ret = "";
	for(var i=0; i < str.length; i++) {
		for(var j=0; j < ptn.length; j++) {
			if(str.charAt(i) == ptn.charAt(j)) {
				ret = ret + str.charAt(i);
			}
		}
	}
	return ret;
}

/**
 * 오직 숫자로만 이루어져 있는지 체크 한다.
 *
 * @param   num
 * @return  boolean
 */
function isNumber(num) {
    var reg = RegExp(/^(\d|-)?(\d|,)*\.?\d*$/);
    if (reg.test(num)) return  true;
    return  false;
};
</script>

<form class="ui form" id="crsForm" name="crsForm" method="POST">
	<input type="hidden" id="crsCd" name="crsCd" value="${vo.crsCd}">
	<input type="hidden" id="crsTypeCd" name="crsTypeCd" value="${vo.crsTypeCd}">
	<input type="hidden" id="crsCtgrCd" name="crsCtgrCd" value="${vo.crsCtgrCd}">
	<input type="hidden" id="creTmCtgrCd" name="creTmCtgrCd" value="${vo.creTmCtgrCd}">
	<input type="hidden" id="crsOperTypeCd" name="crsOperTypeCd">
	<input type="hidden" id="gubun" name="gubun" value="${vo.gubun}">
	<input type="hidden" id="cntsUrl" name="cntsUrl">

	<div class="ui grid stretched row">
		<div class="sixteen wide tablet eight wide computer column">
			<div class="ui segment">
				<ul class="tbl-simple">
					<li>
						<dl>
							<dt>
								<label for="subjectTypeLabel"><spring:message code="crs.label.crs.category"/></label> <%-- 과목분류 --%>
							</dt>
							<dd>
								<div class="ui basic buttons btn_dimmer mo-wmax">
									<a href="#0" class="w150 ui button" id="crsTypeCdUni" name="crsTypeCd" value="UNI"><spring:message code="common.label.semester.sys"/></a> <!-- 학기제 --> 
									<a href="#0" class="w150 ui button" id="crsTypeCdCo" name="crsTypeCd" value="CO"><spring:message code="common.label.fundamental.sys"/></a> <!-- 기수제 -->
									<a href="#0" class="w150 ui button" id="crsTypeCdLegal" name="crsTypeCd" value="LEGAL"><spring:message code="common.button.legal" /></a><!-- 법정교육 -->
									<a href="#0" class="w150 ui button" id="crsTypeCdOpen" name="crsTypeCd" value="OPEN"><spring:message code="common.label.open.crs"/></a> <!-- 공개강좌 -->
								</div>
							</dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>
								<label for="subjectLabel" class="req"><spring:message code="common.label.crsauth.crsnm"/></label> <%-- 과목명 --%>
							</dt>
							<dd>
								<div>
									<input type="text" id="crsNm" name="crsNm" value="${vo.crsNm}" styleId="writeCrsCtgrNm"> 
									<input type="hidden" name="crsNmOrigin" id="crsNmOrigin" value="${vo.crsNm}">
								</div>
							</dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>
								<label for="lectureTypeLabel" class="req"><spring:message code="crs.title.education.method"/></label> <%-- 강의형태 --%>
							</dt>
							<dd>
								<select class="ui dropdown" id="crsOperTypeCdVal">
									<option value=""><spring:message code="common.label.select"/></option> <%-- 선택하세요 --%>
									<option value="ONLINE"
										<c:if test="${vo.crsOperTypeCd eq 'ONLINE'}">selected</c:if>><spring:message code="common.label.online"/></option> <%-- 온라인 --%>
									<option value="OFFLINE"
										<c:if test="${vo.crsOperTypeCd eq 'OFFLINE'}">selected</c:if>><spring:message code="common.label.offline"/></option> <%-- 오프라인 --%>
									<option value="MIX"
										<c:if test="${vo.crsOperTypeCd eq 'MIX'}">selected</c:if>><spring:message code="common.label.blend"/></option> <%-- 혼합 --%>
								</select>
							</dd>  
						</dl>
					</li>
					<li>
						<dl>
							<dt>
								<label for="useLabel"><spring:message code="common.label.use.type.yn"/></label> <%-- 사용 여부 --%>
							</dt>
							<dd>
								<div class="inline fields mb0">
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" name="useYn" value="Y" <c:choose><c:when test="${vo.useYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
											<label><spring:message code="common.use"/></label> <%-- 사용 --%>
										</div>
									</div>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" name="useYn" value="N" <c:if test="${vo.useYn eq 'N'}">checked</c:if>> 
											<label><spring:message code="common.not_use"/></label> <%-- 미사용 --%>
										</div>
									</div>
								</div>
							</dd>
						</dl>
					</li>
					<li>
                    	<dl class="row">
                        	<dt>
                        		<label for="contentTextArea"><spring:message code="crs.title.subject.description"/></label> <%-- 과목 설명 --%>
                        	</dt>
                            <dd style="height:400px">
								<div style="height:100%">
                                	<textarea name="crsDesc" id="crsDesc">${vo.crsDesc}</textarea>
                                    <script>
	                                	// html 에디터 생성
	                                	var editor = HtmlEditor('crsDesc', THEME_MODE, '/crs');
	                                </script>
                                    </div>
                            </dd>
                        </dl>
                    </li>					
				</ul>
			</div>
		</div>
		<div class="sixteen wide tablet eight wide computer column" id="options" style="z-index:20;">
			<div class="ui segment">
				<h3 class="page-title mb20"><spring:message code="crs.additional.function"/></h3> <%-- 부가 기능 --%>
				<ul class="tbl-simple">
					<li>
						<dl>
							<dt>
								<label for="courseCertifyLabel"><spring:message code="crs.lecture.approve.method"/></label> <%-- 수강 승인 방법 --%>
							</dt>
							<dd>
								<div class="inline fields mb0">
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" name="enrlCertMthd" value="AT"
												<c:choose><c:when test="${vo.enrlCertMthd eq 'AT'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
											<label><spring:message code="crs.auto.approve"/></label> <%-- 자동 승인 --%>
										</div>
									</div>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" name="enrlCertMthd" value="MA" <c:if test="${vo.enrlCertMthd eq 'MA'}">checked</c:if>>
											<label><spring:message code="crs.manager.approve"/></label> <%-- 관리자 승인 --%>
										</div>
									</div>
								</div>
							</dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>
								<label for="userLimitedLabel"><spring:message code="crs.lecture.person.limit"/></label> <%-- 수강인원 제한 --%>
							</dt>
							<dd>
								<div class="inline fields mb0">
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" name="nopLimitYn" value="N" onchange="fn_nopLimitYn('N')" <c:if test="${vo.nopLimitYn eq 'N'}">checked</c:if>>
											<label><spring:message code="message.no"/></label> <%-- 아니오 --%>
										</div>
									</div>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" name="nopLimitYn" value="Y"
												onchange="fn_nopLimitYn('Y')"
												<c:choose><c:when test="${vo.nopLimitYn eq 'Y'}">checked</c:when><c:when test="${vo.nopLimitYn eq null}">checked</c:when></c:choose>>
											<label><spring:message code="message.yes"/></label> <%-- 예 --%>
										</div>
									</div>
									<div class="field" id="stdcnt">
										<div class="ui input">
											<input type="text" maxlength="3" class="w70" id="eduNop" name="eduNop" value="${vo.eduNop}" onkeyup="isChkNumber(this)">
										</div>
										명
									</div>
								</div>
							</dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>
								<label for="coptScoreLabel"><spring:message code="crs.label.cplt.score"/></label> <%-- 수료 점수 --%>
							</dt>
							<dd>
								<div class="ui input">
									<input type="text" id="cpltScore" name="cpltScore" class="w70" maxlength="3" value="${vo.cpltScore}" onkeyup="isChkMaxNumber(this,100)">
								</div>
								<spring:message code="message.score"/> <%-- 점 --%>
							</dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>
								<label for="coptProcessLabel"><spring:message code="crs.completion.process.method"/></label> <%-- 수료 처리 방법 --%>
							</dt>
							<dd>
								<div class="inline fields mb0">
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" id="cpltHandlTypeAt" name="cpltHandlType" value="AT" onChange="chkOperType()" <c:if test="${vo.cpltHandlType eq 'AT'}">checked</c:if>>
											<label><spring:message code="crs.auto.process"/></label> <%-- 자동 처리 --%>
										</div>
									</div>
									<div class="field">
										<div class="ui radio checkbox">
											<input type="radio" id="cpltHandlTypeMa" name="cpltHandlType"
												value="MA" onChange="chkOperType()"
												<c:choose><c:when test="${vo.cpltHandlType eq 'MA'}">checked</c:when><c:when test="${vo.nopLimitYn eq null}">checked</c:when></c:choose>>
											<label><spring:message code="crs.manager.process"/></label> <%-- 관리자 처리 --%>
										</div>
									</div>
								</div>
							</dd>
						</dl>
					</li>
				</ul>
				<div class="ui inverted dimmer"></div>
				<script>
					$('.btn_dimmer .ui.button').click(function(){
				        if($(this).is(":first-child")) {
							<%-- 학기제 --%>
				            $('.dimmer').dimmer({closable: false}).dimmer('show');
				            $("#crsTypeCdCo").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdLegal").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdOpen").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdUni").removeClass("active").removeClass("column-hide").addClass("active");
				            $("#crsTypeCd").val("UNI");
				            
				        } else if($(this).is(":nth-child(3n)")) {    
				        	<%-- 법정교육 --%>
				     	   	$('.dimmer').dimmer({closable: false}).dimmer('show');
				     	  	$("#crsTypeCdUni").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdCo").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdOpen").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdLegal").removeClass("active").removeClass("column-hide").addClass("active");
				            $("#crsTypeCd").val("LEGAL");
				            
				        } else if($(this).is(":last-child")) {
				     	  	<%-- 공개강좌--%>
				     	   	$('.dimmer').dimmer({closable: false}).dimmer('show');
				     	  	$("#crsTypeCdUni").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdCo").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdLegal").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdOpen").removeClass("active").removeClass("column-hide").addClass("active");
				            $("#crsTypeCd").val("OPEN");
			
				        } else if($(this).is(":nth-child(2n)")) {
				     	   	<%-- 비교과 --%>
				            $('.dimmer').dimmer({closable: false}).dimmer('hide');
				            $("#crsTypeCdUni").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdOpen").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdLegal").removeClass("active").addClass("column-hide");
				            $("#crsTypeCdCo").removeClass("active").removeClass("column-hide").addClass("active");
				            $("#crsTypeCd").val("CO");
				        }
				    });
				</script>
			</div>
		</div>
	</div>
</form>
</html>