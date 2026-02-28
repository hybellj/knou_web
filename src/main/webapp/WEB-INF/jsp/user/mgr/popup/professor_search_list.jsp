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
			var url  = "/user/userMgr/professorList.do";
			var data = {
				"searchValue" 	: $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var userNmEng = v.userNmEng != null ? v.userNmEng : '';
	        				var deptNm    = v.deptNm != null ? v.deptNm : '';
	        				var userGrade = v.userGrade != null ? v.userGrade : '';
	        				html += "<tr onclick='selectUser(\""+v.userId+"\", \""+v.userNm+"\", this)'>";
	        				html += "	<td class='tc p_w5'>"+v.lineNo+"</td>";
	        				html += "	<td class='tc p_w10'>-</td>";
	        				html += "	<td class='p_w15'>"+v.userId+"</td>";
	        				html += "	<td class='tc p_w10'>"+v.userNm+"</td>";
	        				html += "	<td class='tc p_w10'>-</td>";
	        				html += "	<td class='tc p_w10'>-</td>";
	        				html += "	<td class='p_w25'>"+deptNm+"</td>";
	        				html += "	<td class='tc p_w10'>-</td>";
	        				html += "	<td class='tc p_w10'>-</td>";
	        				html += "</tr>";
	        			});
	        		}
	        		
	        		$("#userTotCnt").text(returnList.length > 0 ? returnList[0].totalCnt : 0);
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
			
			var formId = "${fn:split(vo.subParam,'|')[0]}";
			var target = "${fn:split(vo.subParam,'|')[1]}";
			var modal  = "${fn:split(vo.subParam,'|')[2]}";
			var dataMap = {
				userId : userId,
				userNm : userNm,
			   	type   : "search"
			};
			window.parent.postMessage(dataMap, "*");
			//parent.$("#"+formId+" input[name=userId]").val(userId);
			//parent.$("#"+formId+" input[name=userNm]").val(userNm);
			if("${vo.searchMenu}" == "popup") {
			//	parent.$("#"+formId).attr("target", target);
		    //    parent.$("#"+formId).attr("action", "${vo.goUrl}");
		    //    parent.$("#"+formId).submit();
		    //    parent.$('#'+modal).modal('show');
			} else {
				modalClose();
			}
		}
		
		// 팝업 닫기
		function modalClose() {
			if("${vo.searchMenu}" == "popup") {
				history.back();
			} else {
				var dataMap = {
			    	type : "close"
				};
				window.parent.postMessage(dataMap, "*");
			}
		}
	</script>
	
	<body class="modal-page <%-- <%=SessionInfo.getThemeMode(request)%> --%>">
        <div id="wrap">
        	<form id="selectForm" method="POST">
        		<input type="hidden" name="userId" />
        		<input type="hidden" name="userNm" />
        	</form>
        	<div class="option-content">
        		<select class="ui dropdown">
        			<option value=""><spring:message code="user.title.userinfo.teacher.division" /></option><!-- 교직원구분 -->
        		</select>
        		<select class="ui dropdown">
        			<option value=""><spring:message code="user.title.userinfo.position.group" /></option><!-- 직급그룹 -->
        		</select>
        		<select class="ui dropdown">
        			<option value=""><spring:message code="user.title.userinfo.type.division" /></option><!-- 직종구분 -->
        		</select>
        		<select class="ui dropdown">
        			<option value=""><spring:message code="user.title.userinfo.proof.division" /></option><!-- 재직구분 -->
        		</select>
        	</div>
        	<div class="option-content ui form mt20">
        		<input type="text" id="searchValue" class="w300" placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />" /><!-- 학번/학과명/이름 입력 -->
        		<div class="mla">
        			<a href="javascript:listUser()" class="ui green button"><spring:message code="user.button.search" /><!-- 검색 --></a>
        		</div>
        	</div>
        	<div class="option-content mt30 mb20">
        		<h3 class="sec_head"><spring:message code="user.title.userinfo.teacher.list" /></h3><!-- 교직원 목록 -->
        	</div>
        	<table class="tBasic scrolltable" data-empty="<spring:message code='user.common.empty' />" id="userTable"><!-- 등록된 내용이 없습니다. -->
        		<thead class="m-w80">
        			<tr>
        				<th class="tc p_w5"><spring:message code="main.common.number.no" /></th><!-- NO -->
        				<th class="tc p_w10"><spring:message code="user.title.userinfo.teacher.division" /></th><!-- 교직원구분 -->
        				<th class="tc p_w15"><spring:message code="crs.label.no.enseignement" /></th><!-- 교직원번호 -->
        				<th class="tc p_w10"><spring:message code="user.title.userinfo.manage.user.nm" /></th><!-- 성명 -->
        				<th class="tc p_w10"><spring:message code="user.title.userinfo.appointment.date" /></th><!-- 임용일자 -->
        				<th class="tc p_w10"><spring:message code="user.title.userinfo.proof.division" /></th><!-- 재직구분 -->
        				<th class="tc p_w25"><spring:message code="user.title.userinfo.dept.name" /></th><!-- 부서명 -->
        				<th class="tc p_w10"><spring:message code="user.title.userinfo.position" /></th><!-- 직급 -->
        				<th class="tc p_w10"><spring:message code="user.title.userinfo.position.group" /></th><!-- 직급그룹 -->
        			</tr>
        		</thead>
        		<tbody id="userList" class="max-height-400 m-w80">
        		</tbody>
        	</table>
        	<div id="paging" class="paging"></div>
        	
            <div class="bottom-content mt50">
            	<button class="ui blue button" onclick="passUser()"><spring:message code="user.button.confirm" /><!-- 확인 --></button>
                <button class="ui basic button" onclick="modalClose()"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
