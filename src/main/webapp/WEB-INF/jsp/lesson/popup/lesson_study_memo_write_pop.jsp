<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="/*position: fixed;*/ width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
   		window.onbeforeunload = function() {
   			return "";
   		}
   		
	   	$(document).ready(function() {
		});
	   	
	   	// 저장
	   	function writeMemo() {
	   		if(!nullCheck()) {
	   			return false;
	   		}
	   		
	   		var url = "/lesson/lessonLect/writeLessonStudyMemo.do";
	   		var data = $("#memoWriteForm").serialize();
	    	
	   		ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='lesson.alert.message.insert.study.memo' />"); // 학습메모 등록이 완료되었습니다.
					window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
			}, true);
	   	}
	   	
	 	// 임시저장
	   	function writeMemoTmp() {
	   		if(!nullCheck()) {
	   			return false;
	   		}
	   		
	   		var url = "/lesson/lessonLect/writeLessonStudyMemo.do";
	   		var data = $("#memoWriteForm").serialize();
	    	
	   		ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnVO = data.returnVO || {};
					
					$("#studyMemoId").val(returnVO.studyMemoId);
				} else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
			}, true);
	   	}
	   	
	   	// 빈 값 체크
	   	function nullCheck() {
	   		if($.trim($("#memoWriteForm input[name=memoTitle]").val()) == "") {
	   			alert("<spring:message code='lesson.alert.input.title' />"); // 제목을 입력해주세요.
	   			return false;
	   		}
	   		
	   		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
	 			alert("<spring:message code='lesson.alert.input.cnts' />"); // 내용을 입력해주세요.
	 			return false;
	 		}
	   		
	   		return true;
	   	}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<form id="memoWriteForm" method="POST">
			<input type="hidden" name="crsCreCd" 			value="${vo.crsCreCd }" />
			<input type="hidden" name="lessonScheduleId" 	value="${vo.lessonScheduleId }" />
			<input type="hidden" name="lessonCntsId" 		value="${vo.lessonCntsId }" />
			<input type="hidden" name="studySessionLoc" 	value="${vo.studySessionLoc }" />
			<input type="hidden" name="studyMemoId" 		value="" id="studyMemoId" />
			<div class="ui form">
				<ul class="tbl-simple">
					<li>
						<dl>
							<dt class="p_w10"><label class="req"><spring:message code="lesson.label.title" /><!-- 제목 --></label></dt>
							<dd><input type="text" name="memoTitle" placeholder="<spring:message code='lesson.label.title.input' />" /></dd><!-- 제목 입력 -->
						</dl>
					</li>
					<li>
						<dl>
							<dd style="height:<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "250px" : "350px")%>">
		            			<div style="height:100%">
		            				<label for="memoCnts" class="hide">Memo</label>
									<textarea name="memoCnts" id="memoCnts"></textarea>
									<script>
								       	// html 에디터 생성
								  	  	var editor = HtmlEditor('memoCnts', THEME_MODE, '/memo');
								  	</script>
								</div>
							</dd>
						</dl>
					</li>
				</ul>
			</div>
		</form>
		<div class="bottom-content tc">
			<button class="ui orange button w100" type="button" onclick="writeMemoTmp();"><spring:message code="lesson.button.temp.save" /><!-- 임시저장 --></button>
			<button class="ui blue button w100" type="button" onclick="writeMemo();"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<button class="ui basic button w100" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>