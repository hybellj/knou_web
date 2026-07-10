<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function () {
		listCalendarCtgr();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
//				listCalendarCtgr();
			}
		});
		
		$("#haksaYear").parent().css("z-index", "1002");
		$("#haksaTerm").parent().css("z-index", "1001");
	});
	
	// 업무 일정 목록
	function listCalendarCtgr() {
		var url  = "/jobSchMgr/jobSchCalendarCtgrNmList.do";
		var data = {
			"upCd"	: "TASK_SCHDL_TYCD",
			"orgId"		: $("#orgId").val()
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "";
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
						if(i === 0) {
							html += "<option value=''><spring:message code='lesson.label.select' /></option>"	// 선택
						}
						if(v.cdVl === "${vo.sysjobSchdlTycd}") {
							html += "<option value='"+v.cdVl +"' selected>"+ v.cdnm + "</option>";
						} else {
							html += "<option value='"+v.cdVl +"'>"+ v.cdnm + "</option>";
 						}
        			});
        		}
        		
        		$("#sysjobSchdlnm").empty().html(html);
        		/* if(${not empty vo.jobSchSn}) {
        			// 일정 코드 선택
        			$("#ctgr_${vo.cmmnCdId}").trigger("click");
        		} */
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert("<spring:message code='fail.common.msg' />");
		}, true);
	}
	
	// 업무구분 코드 선택
	function changeCtgr() {
		var sysjobSchdlnm = $("#sysjobSchdlTyCd option:selected").text();
		$("#sysjobSchdlnm").val(sysjobSchdlnm);
		$("#sysjobSchdlCmnt").val(sysjobSchdlnm);
	}
	
	// 업무일정 등록, 수정
	function save() {
		if(!nullCheck()) {
			return false;
		}
		setValue();
		
		var url = "";
		if(${not empty vo.jobSchSn}) {
			url = "/jobSchMgr/editJobSch.do";
		} else {
			url = "/jobSchMgr/writeJobSch.do";
		}
		
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#writeJobSchForm").serialize(),
        }).done(function(data) {
        	if (data.result > 0) {
        		if(${not empty vo.jobSchSn}) {
        			alert("<spring:message code='sys.alert.update.job.sch' />");/* 업무일정 수정이 완료되었습니다. */
        		} else {
	        		alert("<spring:message code='sys.alert.insert.job.sch' />");/* 업무일정 등록이 완료되었습니다. */
        		}
        		schList();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	if(${not empty vo.jobSchSn}) {
        		alert("<spring:message code='sys.error.update.job.sch' />");/* 업무일정 수정 중 에러가 발생하였습니다. */
        	} else {
	        	alert("<spring:message code='sys.error.insert.job.sch' />");/* 업무일정 등록 중 에러가 발생하였습니다. */
        	}
        });
	}
	
	// 빈 값 체크
	function nullCheck() {
		<spring:message code='dashboard.cal_schedule' var='schedule'/> // 일정

		if($("#orgId").val() == "") {
			alert("<spring:message code='sys.alert.select.org.cd' />");/* 대학구분을 선택하세요. */
			return false;
		}
		if($("#calendarCtgr").val() == "") {
			alert("<spring:message code='sys.label.calendar.ctgr.type' />");/* 업무구분을 선택하세요. */
			return false;
		}
		if($.trim($("#jobSchNm").val()) == "") {
			alert("<spring:message code='sys.alert.input.job.sch.nm' />");/* 일정명을 입력하세요. */
			return false;
		}
		if($("#haksaYear").val() == "") {
			alert("<spring:message code='sys.alert.select.haksa.year' />");/* 개설년도를 선택하세요. */
			return false;
		}
		if($("#haksaTerm").val() == "") {
			alert("<spring:message code='sys.alert.select.haksa.term' />");/* 학기구분을 선택하세요. */
			return false;
		}
		if($("#schStartFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_start_date' arguments='${schedule}'/>");/* [일정] 시작일을 입력하세요. */
			return false;
		}
		if($("#schStartHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${schedule}'/>");/* [일정] 시작시간을 입력하세요. */
			return false;
		}
		if($("#schStartMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_min' arguments='${schedule}'/>");/* [일정] 시작분을 입력하세요. */
			return false;
		}
		if($("#schEndFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_end_date' arguments='${schedule}'/>");/* [일정] 종료일을 입력하세요. */
			return false;
		}
		if($("#schEndHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${schedule}'/>");/* [일정] 종료시간을 입력하세요. */
			return false;
		}
		if($("#schEndMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_min' arguments='${schedule}'/>");/* [일정] 종료분을 입력하세요. */
			return false;
		}
		
		return true;
	}
	
	// 값 채우기
	function setValue() {
		if ($("#schStartFmt").val() != null && $("#schStartFmt").val() != "") {
			$("#schStartDt").val($("#schStartFmt").val().replaceAll('.','')+ '' + $("#schStartHH").val() + "" + $("#schStartMM").val() + "00");
		}
		
		if ($("#schEndFmt").val() != null && $("#schEndFmt").val() != "") {
			$("#schEndDt").val($("#schEndFmt").val().replaceAll('.','')+ '' + $("#schEndHH").val() + "" + $("#schEndMM").val() + "00");
		}
	}
	
	// 목록
	function schList() {
		var url  = "/jobSchMgr/jobSchList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "listForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'haksaYear', value: '${vo.haksaYear}'}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', value: '${vo.haksaTerm}'}));
		form.append($('<input/>', {type: 'hidden', name: 'codeOptn', value: '${vo.codeOptn}'}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: '${vo.searchValue}'}));
		form.appendTo("body");
		form.submit();
	}
</script>

<body>
	<form id="viewJobSchForm" method="POST">
		<input type="hidden" name="jobSchSn" />
	</form>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                [${vo.searchValue}]
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="sys.label.basic.job.info.manage" /><!-- 업무기초정보관리 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="sys.label.job.sch.manage" /><!-- 업무일정관리 --></small>
                                </div>
                            </h2>
		                </div>
		                <div class="row">
		                	<div class="col">
								<div class="option-content mt30 mb20">
									<spring:message code="sys.button.save"   var="save" /><!-- 저장 -->
									<spring:message code="sys.button.write"  var="write" /><!-- 등록 -->
									<spring:message code="sys.button.modify" var="modify" /><!-- 수정 -->
									<h3 class="sec_head">
										<spring:message code="sys.label.job.sch" /><!-- 업무 일정 --> ${not empty vo.jobSchSn ? modify : write }
									</h3>
									<div class="mla">
										<button type="button" class="ui green button" onclick="save()">${not empty vo.jobSchSn ? modify : save }</button>
										<button type="button" class="ui green button" onclick="schList()"><spring:message code="sys.button.list" /><!-- 목록 --></button>
									</div>
								</div>
								<form name="writeJobSchForm" id="writeJobSchForm" method="POST">
									<input type="hidden" name="jobSchSn" value="${vo.jobSchSn }" />
									<input type="hidden" name="schStartDt" id="schStartDt" />
									<input type="hidden" name="schEndDt" id="schEndDt" />
									<div class="ui segment">
										<ul class="tbl">
											<li>
												<dl>
													<dt><label for="orgId" class="req"><spring:message code="sys.label.org.type" /><!-- 대학구분 --></label></dt>
													<dd>
														<select class="button-area mt10" name="orgId" id="orgId" onchange="listCalendarCtgr();">
															<option value=""><spring:message code="sys.common.search.all" /><!-- 전체 --></option>
															<c:forEach items="${orgInfoList }" var="orgInfoVO">
																<option value="${orgInfoVO.orgId }" ${orgInfoVO.orgId eq vo.orgId ? " selected" : ""}>${orgInfoVO.orgNm }</option>
															</c:forEach>
														</select>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="sysjobSchdlTyCd" class="req"><spring:message code="sys.label.calendar.ctgr.type" /><!-- 업무구분 --></label></dt>
													<dd>
														<select class="button-area mt10" name="sysjobSchdlTyCd" id="sysjobSchdlTyCd" onchange="changeCtgr();">
															<option value=""><spring:message code='sys.button.select'/></option><!-- 선택 -->
														</select>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="sysjobSchdlnm" class="req"><spring:message code="sys.label.sch.nm" /><!-- 일정명 --></label></dt>
													<dd><input type="text" name="sysjobSchdlnm" id="sysjobSchdlnm" value="${vo.sysjobSchdlnm }" /></dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="haksaYear" class="req"><spring:message code="sys.label.haksa.year" /><!-- 개설년도 --></label></dt>
													<dd>
														<select class="w300" name="haksaYear" id="haksaYear">
															<c:forEach var="item" items="${yearList }">
																<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
															</c:forEach>
														</select>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="haksaTerm" class="req"><spring:message code="sys.label.haksa.term.type" /><!-- 학기구분 --></label></dt>
													<dd>
														<select class="w300" name="haksaTerm" id="haksaTerm">
															<option value=""><spring:message code="sys.common.search.all" /><!-- 전체 --></option>
															<c:forEach var="item" items="${termList }">
																<option value="${item.cd }" ${termVO.haksaTerm eq item.cd ? 'selected' : '' }>${item.cdnm }</option>
															</c:forEach>
														</select>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="schStartDt" class="req"><spring:message code="sys.label.date" /><!-- 기간 --></label></dt>
													<dd>
														<div class="fields gap4">
                                            				<div class="field flex" style="z-index:1000">
																<!-- 시작일시 -->
						                                        <uiex:ui-calendar dateId="schStartFmt" hourId="schStartHH" minId="schStartMM" 
						                                        	rangeType="start" rangeTarget="reschEndFmt" value="${vo.schStartDt}"/>
															</div>
															<div class="field p0 flex-item desktop-elem">~</div>
				                                            <div class="field flex">
				                                           	   <!-- 종료일시 -->
				                                               <uiex:ui-calendar dateId="schEndFmt" hourId="schEndHH" minId="schEndMM" 
				                                               		rangeType="end" rangeTarget="schStartFmt" value="${vo.schEndDt}"/>
				                                            </div>
				                                        </div>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label class="schCmnt"><spring:message code="sys.label.sch.cmnt" /><!-- 설명 --></label></dt>
													<dd><textarea id="sysjobSchdlCmnt" name="sysjobSchdlCmnt" rows="5" style="resize: none;">${vo.sysjobSchdlCmnt }</textarea></dd>
												</dl>
											</li>
										</ul>
									</div>
								</form>
		                	</div>
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