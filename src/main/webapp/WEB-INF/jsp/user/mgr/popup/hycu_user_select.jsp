<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/admin-default.css" />
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/reset.css" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			//listUser();
			hideLoading();
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listUser();
				}
			});
		});
		
		// 사용자 목록
		function listUser() {
			var url  = "/user/userMgr/hycuUserList.do";
			var data = {
				"searchValue" 	: $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var deptNm    = v.deptNm != null ? v.deptNm : '';
	        				var userType  = v.wwwAuthGrpNm != null ? v.wwwAuthGrpNm : '<spring:message code='user.title.userinfo.staff' />'; // 교직원
	        				html += "<tr onclick='selectUser(\""+v.userId+"\", \""+v.userNm+"\", this)'>";
	        				html += "	<td class='tc p_w5'><input name='choiceUser' type='radio'></td>";
	        				html += "	<td class='tc p_w5'>"+(i+1)+"</td>";
	        				html += "	<td class='tc p_w25'>"+v.userId+"</td>";
	        				html += "	<td class='tc p_w25'>"+v.userNm+"</td>";
	        				html += "	<td class='tc p_w15'>"+userType+"</td>";
	        				html += "	<td class='tc p_w25'>"+deptNm+"</td>";	        				
	        				html += "</tr>";
	        			});
	        		}
	        		
	        		//$("#userTotCnt").text(returnList.length > 0 ? returnList[0].totalCnt : 0);
	        		$("#userList").empty().html(html);
	        		
	        		
	        		
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert("<spring:message code='fail.common.msg' />");
			});
		}
		
		function selectUser(userId, userNm, obj) {
			$("#userList tr").removeClass("bcLblue");
			$(obj).attr("class", "bcLblue");
			$("#selectForm input[name=userId]").val(userId);
			$("#selectForm input[name=userNm]").val(userNm);
			$(obj).find("input[name=choiceUser]").prop("checked",true);
		}
		
		// 교직원 선택
		function passUser() {
			var userId = $("#selectForm input[name=userId]").val();
			var userNm = $("#selectForm input[name=userNm]").val();
			
			if(userId == "") {
				/* 교직원을 선택하세요. */
				alert("<spring:message code='user.message.userinfo.select.professor' />");
				return false;
			}
			
			$(top.document).find("#hycuUserId").val(userId);
			$(top.document).find("#hycuUserInfo").val(userNm + " ("+userId+")");
			$(top.document).find("#hycuUserDelBtn").show();
			
			window.parent.closeModal();
		}
	</script>
	
	<body class="modal-page <%-- <%=SessionInfo.getThemeMode(request)%> --%>">
        <div id="wrap">
        	<form id="selectForm" method="POST">
        		<input type="hidden" name="userId" />
        		<input type="hidden" name="userNm" />
        	</form>
        	<div class="option-content ui form">
        		<input type="text" id="searchValue" class="w300" placeholder="<spring:message code="user.message.search.input.userinfo.user.no.nm" />" /><!-- 학번/사번, 이름 입력 -->
        		<a href="javascript:listUser()" class="ui green button"><spring:message code="user.button.search" /><!-- 검색 --></a>
        	</div>

        	<div class="option-content mt30 mb20">
        		<h3 class="sec_head"><spring:message code="user.title.userinfo.search" /></h3><!-- 사용자 검색 -->
        	</div>
        	<table class="tBasic scrolltable" data-empty="<spring:message code='user.common.empty' />" id="userTable"><!-- 등록된 내용이 없습니다. -->
        		<thead class="m-w80">
        			<tr>
        				<th scope="col" class="tc p_w5"><spring:message code='common.select' /></th>
        				<th scope="col" class="tc p_w5"><spring:message code="main.common.number.no" /></th><!-- NO -->
        				<th scope="col" class="tc p_w25"><spring:message code="user.title.userinfo.user.no" /></th><!-- 학번/사번 -->
						<th scope="col" class="tc p_w25"><spring:message code="common.name"/></th><!-- 이름 -->
						<th scope="col" class="tc p_w15"><spring:message code="common.type"/></th><!-- 구분 -->
						<th scope="col" class="tc p_w25"><spring:message code="user.title.userdept.dept" /></th><!-- 학과/부서 -->						
        			</tr>
        		</thead>
        		<tbody id="userList" class="max-height-400 m-w80">
        		</tbody>
        	</table>
        	<div id="paging" class="paging"></div>
        	
            <div class="bottom-content mt50">
            	<button class="ui blue button" onclick="passUser()"><spring:message code="button.choice" /><!-- 선택 --></button>
                <button class="ui basic button" onclick="window.parent.closeModal()"><spring:message code="user.button.cancel" /></button><!-- 취소 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
