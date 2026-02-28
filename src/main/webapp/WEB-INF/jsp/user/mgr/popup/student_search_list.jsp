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
			var url  = "/user/userMgr/studentList.do";
			var data = {
				"orgId"    		: $("#orgId").val(),
				"deptCd"  		: $("#deptCd").val(),
				"userGrade" 	: $("#userGrade").val(),
				"searchValue" 	: $("#searchValue").val(),
				"searchType"    : "${vo.searchType}"
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = "";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var userNmEng = v.userNmEng != null ? v.userNmEng : '';
	        				var deptNm = v.deptNm != null ? v.deptNm : '';
	        				var hy = v.hy != null ? v.hy : '';
	        				html += "<tr onclick='selectUser(\""+v.userId+"\", \""+v.userNm+"\", this)'>";
	        				html += "	<td class='tc'>"+v.lineNo+"</td>";
	        				html += "	<td class=''>"+v.orgNm+"</td>";
	        				html += "	<td class=''>"+v.userId+"</td>";
	        				html += "	<td class='tc'><p>"+v.userNm;
	        				html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
	        				html += "	</p></td>";
	        				html += "	<td class='tc'>"+userNmEng+"</td>";
	        				html += "	<td class=''>"+deptNm+"</td>";
	        				html += "	<td class='tc'>"+hy+"</td>";
	        				html += "	<td class='tc'>-</td>";
	        				html += "	<td class='tc'>"+v.schregGbn+"</td>";
	        				html += "	<td class='tc'>-</td>";
	        				html += "	<td class='tc'>-</td>";
	        				html += "	<td class='tc'>-</td>";
	        				html += "</tr>";
	        			});
	        		}

	        		$("#userTotCnt").text(returnList.length > 0 ? returnList[0].totalCnt : 0);
	        		$("#userList").empty().html(html);
	        		$("#userTable").footable();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			}, true);
		}

		function selectUser(userId, userNm, obj) {
			$("#userList tr").removeClass("bcLblue");
			$(obj).attr("class", "bcLblue");
			$("#selectForm input[name=userId]").val(userId);
			$("#selectForm input[name=userNm]").val(userNm);
		}

		// 학습자 선택
		function passUser() {
			var userId = $("#selectForm input[name=userId]").val();
			var userNm = $("#selectForm input[name=userNm]").val();

			if(userId == "") {
				alert("<spring:message code='user.message.userinfo.select.student' />");/* 학습자를 선택하세요. */
				return false;
			}

			var formId = "${fn:split(vo.subParam,'|')[0]}";
			var target = "${fn:split(vo.subParam,'|')[1]}";
			var modal  = "${fn:split(vo.subParam,'|')[2]}";
			parent.$("#"+formId+" input[name=userId]").val(userId);
			parent.$("#"+formId+" input[name=userNm]").val(userNm);
			if("${vo.searchMenu}" == "popup") {
				parent.$("#"+formId).attr("target", target);
		        parent.$("#"+formId).attr("action", "${vo.goUrl}");
		        parent.$("#"+formId).submit();
		        parent.$('#'+modal).modal('show');
			} else {
				window.parent.closeModal();
			}
		}

		// 팝업 닫기
		function modalClose() {
			if("${vo.searchMenu}" == "popup") {
				history.back();
			} else {
				window.parent.closeModal();
			}
		}

		//사용자 정보 팝업
	 	function userInfoPop(userId) {
	 		var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
	 		var options = 'top=100, left=150, width=1200, height=800';
	 		window.open(userInfoUrl, "", options);
	 	}
	</script>

	<body class="modal-page <%-- <%=SessionInfo.getThemeMode(request)%> --%>">
        <div id="wrap">
        	<form id="selectForm" method="POST">
        		<input type="hidden" name="userId" />
        		<input type="hidden" name="userNm" />
        	</form>
        	<div class="option-content">
        		<select class="ui dropdown" id="orgId">
        			<option value=""><spring:message code="user.title.org.info" /><!-- 대학구분 --></option>
        			<option value="ALL"><spring:message code="user.common.search.all" /><!-- 전체 --></option>
        			<c:forEach var="item" items="${orgInfoList }">
        				<option value="${item.orgId }">${item.orgNm }</option>
        			</c:forEach>
        		</select>
        		<select class="ui dropdown" id="deptCd">
        			<option value=""><spring:message code="user.title.userinfo.dept" /><!-- 학과 --></option>
        			<option value="ALL"><spring:message code="user.common.search.all" /><!-- 전체 --></option>
        			<c:forEach var="item" items="${deptCdList }">
        				<option value="${item.deptCd }">${item.deptNm }</option>
        			</c:forEach>
        		</select>
        		<select class="ui dropdown" id="userGrade">
        			<option value=""><spring:message code="user.title.userinfo.grade" /><!-- 학년 --></option>
        			<option value="ALL"><spring:message code="user.common.search.all" /><!-- 전체 --></option>
        			<c:forEach var="item" items="${userGradeList }">
        				<option value="${item.codeCd }">${item.codeNm }</option>
        			</c:forEach>
        		</select>
        		<select class="ui dropdown">
        			<option value=""><spring:message code="user.title.userinfo.addmission.year" /><!-- 입학년도 --></option>
        		</select>
        		<select class="ui dropdown">
        			<option value=""><spring:message code="user.title.userinfo.graduate.year" /><!-- 졸업년도 --></option>
        		</select>
        	</div>
        	<div class="option-content ui form mt20">
        		<input type="text" id="searchValue" class="w300" placeholder="<spring:message code='user.message.search.input.user.no.nm.mobile' />" /><!-- 학번/성명/휴대폰번호 입력 -->
        		<div class="ui checkbox ml20">
	        		<input type="checkbox" id="foreigner" /><label for="foreigner"><spring:message code="user.title.userinfo.foreigner" /><!-- 외국인 --></label>
        		</div>
        		<div class="mla">
        			<a href="javascript:listUser()" class="ui green button"><spring:message code="user.button.search" /><!-- 검색 --></a>
        		</div>
        	</div>
        	<div class="option-content mt30 mb20">
        		<h3 class="sec_head"><spring:message code="user.title.userinfo.std.list" /><!-- 학생 목록 --></h3>
        		<span class="ml20">[ <spring:message code="user.title.total" /><!-- 총 --> <label class="fcBlue" id="userTotCnt"></label><spring:message code="user.title.count" /><!-- 건 --> ]</span>
        	</div>
        	<div class="footable_box type2 max-height-550">
	        	<table class="table type2" data-empty="<spring:message code='user.common.empty' />" id="userTable"><!-- 등록된 내용이 없습니다. -->
	        		<thead class="sticky top0">
	        			<tr>
	        				<th class="tc"><spring:message code="user.title.line.no" /><!-- 순번 --></th>
	        				<th class="tc"><spring:message code="user.title.org.info" /><!-- 대학구분 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.manage.userid" /><!-- 학번 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.manage.user.nm" /><!-- 성명 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.manage.user.nm.eng" /><!-- 영문성명 --></th>
	        				<th class="tc"><spring:message code="user.title.userdept.dept.major" /><!-- 학과/전공 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.grade" /><!-- 학년 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.std.type" /><!-- 학생구분 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.user.stats" /><!-- 학적상태 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.user.modify" /><!-- 학적변동 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.birth.day" /><!-- 생년월일 --></th>
	        				<th class="tc"><spring:message code="user.title.userinfo.nationalit" /><!-- 국적 --></th>
	        			</tr>
	        		</thead>
	        		<tbody id="userList">
	        		</tbody>
	        	</table>
        	</div>

            <div class="bottom-content mt50">
            	<button class="ui blue button" onclick="passUser()"><spring:message code="user.button.confirm" /><!-- 확인 --></button>
                <button class="ui basic button" onclick="modalClose()"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
