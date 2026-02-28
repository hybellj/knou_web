<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 운영자 정보 수정
		function editTch() {
			var mobileNo = $("input[name=mobileNo]").val().replaceAll("-", "");
			mobileNo = mobileNo.replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
			var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
			if($("input[name=userNm]").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.user.nm.input' />");/* 이름을 입력해주세요. */
				return false;
			} else if($("input[name=email]").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.email.input' />");/* 이메일을 입력해주세요. */
				return false;
			} else if(!reg_email.test($("input[name=email]").val())) {
				alert("<spring:message code='user.message.userjoin.validate.email.format' />");/* 이메일 형식이 잘못되었습니다. */
				return false;
			} else if($("input[name=mobileNo]").val() == "") {
				alert("<spring:message code='user.message.userjoin.vaildate.mobile.no.input' />");/* 휴대전화 번호를 입력해주세요. */
				return false;
			} else if(mobileNo.indexOf("-") == -1) {
				alert("<spring:message code='user.message.userjoin.validate.mobile.format' />");/* 휴대전화 형식이 잘못되었습니다. */
				return false;
			}
			
			var url  = "/crs/creCrsHome/editSimpleUserInfo.do";
			var data = {
				"userId"	: "${vo.userId}",
				"userNm"	: $("input[name=userNm]").val(),
				"email"		: $("input[name=email]").val(),
				"mobileNo"	: mobileNo
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					window.parent.crecrsTchList("PROFESSOR");
					window.parent.crecrsTchList("ASSISTANT");
					window.parent.closeModal();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 메세지 보내기
		function sendMsg() {
			var rcvUserInfoStr = "${vo.userId};${vo.userNm};${vo.mobileNo};${vo.email}";
			
	        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

	        var form = window.parent.alarmForm;
	        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.submit();
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content mb20">
	        	<h3 class="sec_head"><spring:message code="user.title.tch.info.simple.edit" /></h3><!-- 교수/조교 정보 간편 수정 -->
        		<div class="mla">
        			<button class="ui basic button" onclick="sendMsg()"><spring:message code="user.button.alarm.msg.send" /></button><!-- 알림/쪽지 보내기 -->
        		</div>
        	</div>
        	<div class="ui form">
	        	<div class="ui segment">
	        		<div class="fields">
	        			<div class="field">
	        				<div class="ui segment w150 card" style="height:200px;">
	        					<c:choose>
	        						<c:when test="${empty vo.phtFile }">
	        							<img alt="사용자 이미지" class="wmax pushable" src="/webdoc/img/icon-hycu-symbol-grey.svg">
	        						</c:when>
	        						<c:otherwise>
	        							<img alt="사용자 이미지" class="wmax pushable" src="${vo.phtFile }">
	        						</c:otherwise>
	        					</c:choose>
	        				</div>
	        			</div>
	        			<div class="field">
	        				<ul class="tbl">
	        					<li>
	        						<dl>
	        							<dt><spring:message code="user.title.userinfo.manage.usernm" /></dt><!-- 이름 -->
	        							<dd><input type="text" name="userNm" class="w200" value="${vo.userNm }" readonly="readonly" /></dd>
	        						</dl>
	        						<dl>
	        							<dt><spring:message code="user.title.userinfo.email" /></dt><!-- 이메일 -->
	        							<dd><input type="text" name="email" class="w200" value="${vo.email }" readonly="readonly" /></dd>
	        						</dl>
	        						<dl>
	        							<dt><spring:message code="user.title.userinfo.phoneno" /></dt><!-- 전화번호 -->
	        							<dd><input type="text" name="mobileNo" class="w200" value="${vo.mobileNo }" maxlength="11" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly="readonly" /></dd>
	        						</dl>
	        						<p class="fcRed" style="position:absolute;bottom:1em;"><spring:message code="user.title.userinfo.email.info" /></p><!-- ! 메일 주소는 공개 여부와 관계없이 공개됩니다. -->
	        					</li>
	        				</ul>
	        			</div>
	        		</div>
	        	</div>
        	</div>
	        
            <div class="bottom-content mt70">
            	<%-- <button class="ui blue button" onclick="editTch()"><spring:message code="user.button.save" /></button> --%><!-- 저장 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
