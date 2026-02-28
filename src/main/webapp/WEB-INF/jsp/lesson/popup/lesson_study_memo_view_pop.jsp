<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		memoForm("view");
		});
	   	var editor;
	   	
	   	// 메모 폼
	   	function memoForm(type) {
	   		var html = "";
	   		if(type == "view") {
	   			var min = parseInt("${vo.studySessionLoc / 60}");
	   			min = min == 0 ? "" : min + "<spring:message code='lesson.label.min' />";/* 분 */
	   			var sec = parseInt("${vo.studySessionLoc % 60}") + "<spring:message code='lesson.label.sec' />";/* 초 */
	   			html += "<ul class='tbl-simple type3'>";
	   			html += "	<li>";
	   			html += "		<dl>";
	   			html += "			<dt><label><spring:message code='lesson.label.schedule' />(<spring:message code='lesson.label.time' />)</label></dt>";/* 주차 *//* 교시 */
	   			html += "			<dd>${vo.lessonScheduleOrder} <spring:message code='lesson.label.schedule' /> (${vo.lessonTimeOrder} <spring:message code='lesson.label.time' />)</dd>";
	   			html += "		</dl>";
	   			html += "	</li>";
	   			html += "	<li>";
	   			html += "		<dl>";
	   			html += "			<dt><label><spring:message code='lesson.label.cnts.nm' /></label></dt>";/* 콘텐츠명 */
	   			html += "			<dd><c:out value='${vo.lessonCntsNm}' /></dd>";
	   			html += "		</dl>";
	   			html += "	</li>";
	   			html += "	<li>";
	   			html += "		<dl>";
	   			html += "			<dt><label><spring:message code='lesson.label.study.session.loc' /></label></dt>";/* 학습위치 */
	   			html += "			<dd>" + min + " " + sec + "</dd>";
	   			html += "		</dl>";
	   			html += "	</li>";
	   			html += "	<li>";
	   			html += "		<dl>";
	   			html += "			<dt><label><spring:message code='lesson.label.memo' /><spring:message code='lesson.label.title' /></label></dt>";/* 메모 *//* 제목 */
	   			html += "			<dd>${vo.memoTitle}</dd>";
	   			html += "		</dl>";
	   			html += "	</li>";
	   			html += "	<li>";
	   			html += "		<dl>";
	   			html += "			<dt><label><spring:message code='lesson.label.memo' /><spring:message code='lesson.label.cnts' /></label></dt>";/* 메모 *//* 내용 */
	   			html += "			<dd>";
	   			html += `				<pre>${fn:replace(vo.memoCnts, '`', '\'')}</pre>`;
	   			html += "			</dd>";
	   			html += "		</dl>";
	   			html += "	</li>";
	   			html += "</ul>";
	   			$(".editBtn").hide();
	   			$(".viewBtn").show();
	   		} else if(type == "edit") {
	   			html += "<ul class='tbl-simple'>";
	   			html += "	<li>";
	   			html += "		<dl>";
	   			html += "			<dt class='p_w10'><label for='memoTitle' class='req'><spring:message code='lesson.label.title' /></label></dt>";/* 제목 */
	   			html += "			<dd><input type='text' name='memoTitle' id='memoTitle' value='${vo.memoTitle}' /></dd>";
	   			html += "		</dl>";
	   			html += "	</li>";
	   			html += "	<li>";
	   			html += "		<div style='height:400px;'>";
	   			html += `			<textarea name='memoCnts' id='memoCnts'>${fn:replace(vo.memoCnts, '`', '\'')}</textarea>`;
	   			html += "		</div>";
	   			html += "	</li>";
	   			html += "</ul>";
	   			$(".editBtn").show();
	   			$(".viewBtn").hide();
	   		}
	   		$("#memoDiv").empty().html(html);
	   		if(type == "edit") editor = HtmlEditor('memoCnts', THEME_MODE, '/memo');
	   	}
	   	
	   	// 메모 수정
	   	function editMemo() {
	   		if(!nullCheck()) {
	   			return false;
	   		}
	   		
	   		showLoading();
	   		var url = "/lesson/lessonLect/editLessonStudyMemo.do";
	    	
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data     : $("#editMemoForm").serialize(),
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		alert("<spring:message code='lesson.alert.message.update.study.memo' />");/* 학습메모 수정이 완료되었습니다. */
	        		window.parent.listMemo(1);
	        		window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
	        });
	   	}
	   	
	 	// 빈 값 체크
	   	function nullCheck() {
	   		if($.trim($("#editMemoForm input[name=memoTitle]").val()) == "") {
	   			alert("<spring:message code='lesson.alert.input.title' />");/* 제목을 입력해주세요. */
	   			return false;
	   		}
	   		
	   		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
	 			alert("<spring:message code='lesson.alert.input.cnts' />");/* 내용을 입력해주세요. */
	 			return false;
	 		}
	   		
	   		return true;
	   	}
	 	
	 	// 메모 삭제
		function delMemo() {
			var url  = "/lesson/lessonLect/deleteLessonStudyMemo.do";
			var data = {
				"studyMemoId" : "${vo.studyMemoId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='lesson.alert.message.delete.study.memo' />");/* 학습메모 삭제가 완료되었습니다. */
					window.parent.listMemo(1);
					window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<form id="editMemoForm" method="POST">
			<input type="hidden" name="studyMemoId" value="${vo.studyMemoId }" />
			<div class="ui form memo-wrap" id="memoDiv">
			</div>
		</form>
		<div class="bottom-content tr">
			<button class="ui blue button w100 editBtn" type="button" onclick="editMemo()"><spring:message code="common.button.save" /><!-- 저장 --></button>
			<button class="ui blue button w100 editBtn" type="button" onclick="memoForm('view')"><spring:message code="common.button.cancel" /><!-- 취소 --></button>
			<button class="ui blue button w100 viewBtn" type="button" onclick="memoForm('edit')"><spring:message code="common.button.modify" /><!-- 수정 --></button>
			<button class="ui grey button w100 viewBtn" type="button" onclick="delMemo()"><spring:message code="common.button.delete" /><!-- 삭제 --></button>
			<button class="ui black button w100" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>