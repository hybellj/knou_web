<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
	   	$(document).ready(function() {
		});

	   	// 저장
	   	function save() {
	   		$.trim($("#lessonScheduleNm").val())
	   		
	   		if(!$("#lessonScheduleOrder").val()) {
	   			alert('<spring:message code="lesson.alert.input.lesson.schedule.order" />'); // 주차를 입력하세요.
	   			return;
	   		}
	   		
	   		if(!$.trim($("#lessonScheduleNm").val())) {
	   			alert('<spring:message code="lesson.alert.input.lesson.schedule.nm" />'); // 주차명을 입력하세요.
	   			return;
	   		}
	   		
	   		if(!$("#wekClsfGbn").val()) {
	   			alert('<spring:message code="lesson.alert.input.wek.clsf.gbn" />'); // 주차 구분을 선택하세요.
	   			return;
	   		}
	   		
	   		if(!$("#lessonStartDt").val() || !$("#lessonEndDt").val()) {
	   			alert('<spring:message code="lesson.alert.input.dttm" />'); // 기간을 입력하세요.
	   			return;
	   		}
	   		
	   		if((!$("#ltDetmFrDt").val() && $("#ltDetmToDt").val()) || ($("#ltDetmFrDt").val() && !$("#ltDetmToDt").val())) {
	   			alert('<spring:message code="lesson.alert.input.attend.accept.dttm" />'); // 줄석인정 기간 시작일, 종료일을 입력하세요.
	   			return;
	   		}
	   		
	   		var lessonScheduleId = '<c:out value="${lessonScheduleVO.lessonScheduleId}" />';
	   		var param = {
				  crsCreCd				: '<c:out value="${vo.crsCreCd}" />'
		  		//, wekClsfGbn			: $("#wekClsfGbn").val()
			  	//, lessonScheduleOrder	: $("#lessonScheduleOrder").val()
			  	//, lessonStartDt			: $("#lessonStartDt").val().replaceAll(".", "")
			  	//, lessonEndDt			: $("#lessonEndDt").val().replaceAll(".", "")
			  	, lessonScheduleNm		: $.trim($("#lessonScheduleNm").val())
			  	, ltDetmFrDt			: ($("#ltDetmFrDt").val() || "").replaceAll(".", "")
			  	, ltDetmToDt			: ($("#ltDetmToDt").val() || "").replaceAll(".", "")
			  	, ltNoteOfferYn			: $("input[name='ltNoteOfferYn'][value='Y']").prop("checked") ? "Y" : "N"
			  	, ltNote				: $("#ltNote").val()
			  	, openYn				: $("input[name='openYn'][value='Y']").prop("checked") ? "Y" : "N"
	   		};
	   		
	   		if(!lessonScheduleId) {
	   			// 등록
	   			var url = "/lesson/lessonLect/insertLessonSchedule.do";
	   		} else {
	   			// 수정
	   			var url = "/lesson/lessonLect/updateLessonSchedule.do";
	   			param.lessonScheduleId = lessonScheduleId
	   		}
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					if(typeof window.parent.lessonScheduleWritePopCallback === "function") {
						window.parent.lessonScheduleWritePopCallback(param);
					} else {
						alert('<spring:message code="lesson.alert.message.insert.lesson.schedule" />'); // 주차가 등록되었습니다.
					}
					
					window.parent.closeModal();
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
	   	}
	   	
	 	// 강의노트 input show/hide
	 	/*
	 	function changeLtNote() {
	 		if($("input[name='ltNoteOfferYn'][value='Y']").prop("checked")) {
	 			$("#ltNoteDiv").show();
	 		} else {
	 			$("#ltNoteDiv").hide();
	 		}
	 	}
	 	*/
	 	
	 	function checkNumber(el) {
	 		if(!el.value) {
	 			el.value = "";
	 		} else {
	 			el.value = Number(el.value);
	 			
	 			if(el.value == "0") {
		 			el.value = "";
		 		} 
	 		}
	 	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div class="ui segment">
			<span class="fcBlue">
				*&nbsp;<c:out value="${crsCreVO.crsCreNm}"/>&nbsp;(<c:out value="${crsCreVO.declsNo}"/><spring:message code="std.label.decls" />)&nbsp;>&nbsp;<!-- 분반 -->
				&nbsp;<span class="f110 fweb"><spring:message code="lesson.label.schedule" /></span>&nbsp;
				<c:choose>
					<c:when test="${not empty lessonScheduleVO.lessonScheduleOrder}">
						<spring:message code="common.button.modify" /><!-- 수정 -->
					</c:when>
					<c:otherwise>
						<spring:message code="common.button.create" /><!-- 등록 -->
					</c:otherwise>
				</c:choose>
			</span>
		</div>
		<div class="ui segment">
			<ul class="tbl">
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.progress.week" /><!-- 주차 --></label>
						</dt>
						<dd>
							<div class="ui input w50">
								<input type="text" id="lessonScheduleOrder" autocomplete="off" value="<c:out value="${lessonScheduleVO.lessonScheduleOrder}"/>" maxlength="2" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onblur="checkNumber(this)" <c:if test="${not empty lessonScheduleVO.lessonScheduleId}">disabled</c:if> />
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.progress.week.name" /><!-- 주차명 --></label>
						</dt>
						<dd>
							<div class="ui input fluid">
								<input type="text" id="lessonScheduleNm" autocomplete="off" value="<c:out value="${lessonScheduleVO.lessonScheduleNm}"/>" />
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.type" /><!-- 구분 --></label>
						</dt>
						<dd>
							<select class="ui dropdown" id="wekClsfGbn" disabled="disabled">
								<option value=""><spring:message code="common.select"/><!-- 선택 --></option>
								<c:forEach var="row" items="${wekClsfGbnList}">
									<option value="${row.codeCd}" <c:if test="${lessonScheduleVO.wekClsfGbn eq row.codeCd}">selected</c:if>>${row.codeNm}</option>
								</c:forEach>
							</select>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.period" /><!-- 기간 --></label>
						</dt>
						<dd>
							<div class="inline fields flex">
			                    <div class="field">
			                        <div class="ui calendar" id="lessonStartCal" dateval="${lessonScheduleVO.lessonStartDt}" range="endCalendar,lessonEndCal">
			                            <div class="ui input left icon">
			                                <i class="calendar alternate outline icon"></i>
			                                <input type="text" class="w150" id="lessonStartDt" value="" placeholder="<spring:message code='common.start.date'/>" autocomplete="off" disabled /> <!-- 시작일 -->
			                            </div>
			                        </div>
			                    </div>
			                    <div class="field ml10">
			                        <div class="ui calendar" id="lessonEndCal" dateval="${lessonScheduleVO.lessonEndDt}" range="startCalendar,lessonStartCal">
			                            <div class="ui input left icon">
			                                <i class="calendar alternate outline icon"></i>
			                                <input type="text" class="w150" id="lessonEndDt" value="" placeholder="<spring:message code='common.enddate'/>" autocomplete="off" disabled /> <!-- 종료일 -->
			                            </div>
			                        </div>
			                    </div>
			                </div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label><spring:message code="lesson.label.lt.dttm" /><!-- 출석인정 기간 --></label>
						</dt>
						<dd>
							<div class="inline fields flex">
			                    <div class="field">
			                        <div class="ui calendar" id="rangestart2" dateval="${lessonScheduleVO.ltDetmFrDt}" range="endCalendar,rangeend2">
			                            <div class="ui input left icon">
			                                <i class="calendar alternate outline icon"></i>
			                                <input type="text" class="w150" id="ltDetmFrDt" value="" placeholder="<spring:message code='common.start.date'/>" autocomplete="off"> <!-- 시작일 -->
			                            </div>
			                        </div>
			                    </div>
			                    <div class="field ml10">
			                        <div class="ui calendar" id="rangeend2" dateval="${lessonScheduleVO.ltDetmToDt}" range="startCalendar,rangestart2">
			                            <div class="ui input left icon">
			                                <i class="calendar alternate outline icon"></i>
			                                <input type="text" class="w150" id="ltDetmToDt" value="" placeholder="<spring:message code='common.enddate'/>" autocomplete="off"> <!-- 종료일 -->
			                            </div>
			                        </div>
			                    </div>
			                </div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label><spring:message code="lesson.label.lt.note" /><!-- 강의노트 --></label>
						</dt>
						<dd>
							<div class="inline fields flex">
								<div class="field">
									<div class="ui radio checkbox">
										<input type="radio" name="ltNoteOfferYn" onchange="" value="Y" <c:choose><c:when test="${lessonScheduleVO.ltNoteOfferYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
										<label><spring:message code="common.use"/></label><!-- 사용 -->
									</div>
								</div>
								<div class="field ml10">
									<div class="ui radio checkbox">
										<input type="radio" name="ltNoteOfferYn" onchange="" value="N" <c:if test="${lessonScheduleVO.ltNoteOfferYn ne 'Y'}">checked</c:if>> 
										<label><spring:message code="common.not_use"/></label><!-- 미사용 -->
									</div>
								</div>
							</div>
							<div id="ltNoteDiv" class="ui input fluid mt10 flex-align-item" >
								<div class="inline-flex-item"></div><input type="text" id="ltNote" autocomplete="off" value="<c:out value="${lessonScheduleVO.ltNote}"/>" />
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label><spring:message code="lesson.label.open.yn" /><!-- 공개여부 --> (LCDMS <spring:message code="lesson.label.video"/>)</label>
						</dt>
						<dd>
							<div class="inline fields flex">
								<div class="field">
									<div class="ui radio checkbox">
										<input type="radio" name="openYn" onchange="" value="Y" <c:choose><c:when test="${lessonScheduleVO.openYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
										<label><spring:message code="message.yes"/></label><!-- 예 -->
									</div>
								</div>
								<div class="field ml10">
									<div class="ui radio checkbox">
										<input type="radio" name="openYn" onchange="" value="N" <c:if test="${lessonScheduleVO.openYn ne 'Y'}">checked</c:if>> 
										<label><spring:message code="message.no"/></label><!-- 아니오 -->
									</div>
								</div>
							</div>
						</dd>
					</dl>
				</li>
			</ul>
		</div>
		<div class="bottom-content">
			<button class="ui blue button" type="button" onclick="save();"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<button class="ui black cancel button" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>