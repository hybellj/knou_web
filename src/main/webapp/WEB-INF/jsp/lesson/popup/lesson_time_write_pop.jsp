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
	   		if(!$("#lessonTimeNm").val().trim()) {
	   			alert('<spring:message code="lesson.alert.input.lesson.time.nm" />'); // 교시명을 입력하세요.
	   			$("#lessonTimeNm").val("").focus();
	   		}
	   		
	   		var lessonTimeId = '<c:out value="${lessonTimeVO.lessonTimeId}" />';
	   		var param;
	   		
	   		if(!lessonTimeId) {
	   			// 등록
	   			var url = "/lesson/lessonLect/insertLessonTime.do";
				param = {
					  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				  	, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
				  	, lessonTimeOrder	: '<c:out value="${lessonTimeOrderMax}" />'
				  	, lessonTimeNm		: $("#lessonTimeNm").val()
				  	, stdyMethod		: $("input[name='stdyMethod']:checked").val()
				};
	   		} else {
	   			// 수정
	   			var url = "/lesson/lessonLect/updateLessonTime.do";
	   			param = {
					  crsCreCd			: '<c:out value="${vo.crsCreCd}" />'
				  	, lessonScheduleId	: '<c:out value="${vo.lessonScheduleId}" />'
			  		, lessonTimeId		: lessonTimeId
				  	, lessonTimeNm		: $("#lessonTimeNm").val()
				  	, stdyMethod		: $("input[name='stdyMethod']:checked").val()
				};
	   		}
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					if(typeof window.parent.lessonTimeWritePopCallback === "function") {
						window.parent.lessonTimeWritePopCallback(param);
					} else {
						alert('<spring:message code="lesson.alert.message.insert.lesson.time" />'); // 교시가 등록되었습니다.
						window.parent.closeModal();
					}
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
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
				*&nbsp;<c:if test="${not empty crsCreVO.deptNm}">[<c:out value="${crsCreVO.deptNm}"/>]</c:if>&nbsp;<c:out value="${crsCreVO.crsCreNm}"/>&nbsp;(<c:out value="${crsCreVO.declsNo}"/><spring:message code="std.label.decls" />)&nbsp;>&nbsp;<!-- 분반 -->
				&nbsp;<c:out value="${lessonScheduleVO.lessonScheduleNm}"/>&nbsp;>&nbsp;<span class="f110 fweb"><c:out value="${lessonTimeOrderMax}"/><spring:message code="lesson.label.time" /></span>&nbsp;<spring:message code="resh.button.write" /><!-- 교시등록 -->
			</span>
		</div>
		<div class="ui segment">
			<ul class="tbl">
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.lesson.time.nm" /><!-- 교시명 --></label>
						</dt>
						<dd>
							<div class="ui fluid input">
								<input type="text" id="lessonTimeNm" autocomplete="off" value="<c:out value="${lessonTimeVO.lessonTimeNm}"/>" maxlength="100" />
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>
							<label class="req"><spring:message code="lesson.label.stdy.method" /><!-- 학습방법 --></label>
						</dt>
						<dd>
							<div class="fields">
								<div class="field">
									<div class="ui radio checkbox">
										<input type="radio" value="RND" name="stdyMethod" id="stdyMethod_RND" <c:if test="${empty lessonTimeVO.stdyMethod or lessonTimeVO.stdyMethod eq 'RND'}">checked</c:if> />
										<label for="stdyMethod_RND">
											<spring:message code="lesson.label.stdy.method.rnd" /><!-- 랜덤학습 -->
										</label>
									</div>
								</div>
								<div class="field">
									<div class="ui radio checkbox">
										<input type="radio" value="SEQ" name="stdyMethod" id="stdyMethod_SEQ" <c:if test="${lessonTimeVO.stdyMethod eq 'SEQ'}">checked</c:if> />
										<label for="stdyMethod_SEQ">
											<spring:message code="lesson.label.stdy.method.seq" /><!-- 순차학습 -->
										</label>
									</div>
								</div>
							</div>
						</dd>
					</dl>
				</li>
			</ul>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" type="button" onclick="save();"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<button class="ui black cancel button" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>