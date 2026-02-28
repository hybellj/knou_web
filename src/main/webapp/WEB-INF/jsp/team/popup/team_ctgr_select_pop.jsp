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

		function teamList() {
			var url  = "/team/teamHome/listTeam.do";
			var data = {
				"teamCtgrCd"  : $("#teamCtgrCd").val(),
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = "";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				html += `<tr>`;
	        				html += `	<td>\${v.lineNo}</td>`;
	        				html += `	<td>\${v.teamNm}</td>`;
	        				html += `	<td>\${v.leaderNm}</td>`;
	        				html += `	<td>\${v.teamMbrCnt}<spring:message code='team.common.memberCnt'/></td>`; // 명
	        				html += `</tr>`;
	        			});
	        		}

	        		$("#teamListBody").empty().html(html);
	        		$("#teamListTable").footable();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 에러가 발생했습니다!
			});
		}

		// 팀 선택
		function selectTeamCtgr() {
			if($("#teamCtgrCd").val() == "") {
				alert("팀 분류를 선택해주세요.");
				return false;
			}

			var teamCtgrNm = $("#teamCtgrCd option:checked").text();
			var teamCtgrCd = $("#teamCtgrCd option:checked").val();
			var id		   = "${vo.searchFrom}"

			window.parent.selectTeam(teamCtgrCd, teamCtgrNm, id);
			window.parent.closeDialog();
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div id="info-item-box">
                <p>* <spring:message code='team.label.teamCtgr.info'/><!-- 팀배정이 완료된 팀 분류만 조회됩니다. --></p>
                <div class="button-area">
                	<select class="ui dropdown" id="teamCtgrCd" onchange="teamList()">
                		<option value=""><spring:message code='team.label.teamCtgr.select'/><!-- 팀 분류를 선택하세요. --></option>
                		<c:forEach var="list" items="${teamCtgrList }">
                			<option value="${list.lrnGrpId }">${list.lrnGrpnm }</option>
                		</c:forEach>
                	</select>
                </div>
            </div>
            <table class="table" id="teamListTable" data-sorting="false" data-paging="false" data-empty="<spring:message code='team.common.empty'/>"><!-- 등록된 내용이 없습니다. -->
            	<thead>
            		<tr>
            			<th scope="col" class="tc"><spring:message code="main.common.number.no" /><!-- NO. --></th>
            			<th scope="col" class="tc"><spring:message code='team.table.teamNm'/><!-- 팀명 --></th>
            			<th scope="col" class="tc"><spring:message code='team.table.leaderNm'/><!-- 팀장 --></th>
            			<th scope="col" class="tc"><spring:message code='team.table.memberCnt'/><!-- 인원수 --></th>
            		</tr>
            	</thead>
            	<tbody id="teamListBody">
            	</tbody>
            </table>

            <div class="bottom-content">
                <button class="ui blue button" onclick="selectTeamCtgr();"><spring:message code='team.common.select'/><!-- 선택 --></button>
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code='team.common.close'/><!-- 닫기 --></button>
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
