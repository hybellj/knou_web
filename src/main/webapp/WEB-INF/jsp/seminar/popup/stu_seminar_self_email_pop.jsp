<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 화상 세미나 접속
		function emailCheck() {
			if($.trim($("#tcEmail").val()) == "") {
				alert("<spring:message code='seminar.alert.tc.email.input' />");/* 이메일을 입력해주세요. */
				return false;
			}
			if($("#tcEmail").val() != "${stdVO.userId}@hycu.ac.kr") {
				alert("<spring:message code='seminar.alert.tc.email.format' />");/* 이메일 형식이 잘못되었습니다. */
				return false;
			}
			
			if("${vo.seminarStatus}" == "완료" || "${vo.seminarStartYn}" == "N") {
				alert("<spring:message code='seminar.alert.not.seminar.date' />");/* 세미나 기간이 아닙니다. */
				return false;
			}
			
			var url  = "/seminar/seminarHome/zoomJoinStart.do";
			var data = {
				"seminarId" : "${vo.seminarId }",
				"crsCreCd"  : "${crsCreCd}",
				"stdNo"		: "${stdVO.stdNo}",
				"tcEmail"	: $("#tcEmail").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if("${IPHONE_YN}" == "Y") {
						window.location.href = data.returnVO.joinUrl;
					} else {
						var windowOpener = window.open();
						windowOpener.location = data.returnVO.joinUrl;
					}
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
		<div class="ui form">
       		<p>* ZOOM <spring:message code="seminar.label.info" /><!-- 정보 --></p>
       		<ul class="tbl-simple pl20">
       			<li>
       				<dl>
       					<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> URL</label></dt>
       					<dd>${vo.joinUrl }</dd>
       				</dl>
       			</li>
       			<li>
       				<dl>
       					<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> ID</label></dt>
       					<dd>${vo.zoomId }</dd>
       				</dl>
       			</li>
       			<li>
       				<dl>
       					<dt><label>Zoom <spring:message code="seminar.label.meeting" /><!-- 회의 --> PW</label></dt>
       					<dd>${vo.zoomPw }</dd>
       				</dl>
       			</li>
       		</ul>
		</div>
		<div class="ui form">
       		<p>* ZOOM <spring:message code="seminar.label.join.input.email" /><!-- 접속 이메일 입력 --></p>
       		<ul class="tbl-simple pl20">
       			<li>
       				<dl>
       					<dt><label>Zoom <spring:message code="seminar.label.join.email" /><!-- 접속 이메일 --></label></dt>
       					<dd><input type="text" name="tcEmail" id="tcEmail" class="w300" placeholder="<spring:message code='seminar.label.user.no' />@hycu.ac.kr" /><!-- 학번 --></dd>
       				</dl>
       				<p class="fcBlue"><spring:message code="seminar.label.join.input.email.info" /><!-- Zoom 접속 이메일은 LMS에 등록된 본인의 이메일 주소를 입력해야 자동 출석인정 됩니다. --></p>
       			</li>
       		</ul>
		</div>
       	<div class="option-content">
       		<div class="mla">
        		<div class="ui blue button p20" onclick="emailCheck()">
					<i class="laptop icon f150"></i>
					<a class="tl fcWhite"><spring:message code="seminar.button.video.seminar.part" /><!-- 화상 세미나<br>참여하기 --></a>
				</div>
       		</div>
       	</div>
            
	    <div class="bottom-content">
	        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="seminar.button.close" /></button><!-- 닫기 -->
	    </div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
