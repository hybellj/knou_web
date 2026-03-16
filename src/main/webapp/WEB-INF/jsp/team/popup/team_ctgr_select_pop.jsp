<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
		});

		function teamList(lrnGrpId) {
			if(lrnGrpId == "") {
				teamListTable.clearData();
				return;
			}

			var url  = "/team/teamHome/listTeam.do";
			var data = {
				"teamCtgrCd"  : lrnGrpId
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				dataList.push({
	    						no: 		v.lineNo,
	    						teamNm: 	v.teamNm,
	    						leaderNm: 	v.leaderNm,
	    						teamMbrCnt: v.teamMbrCnt + "명"
	    					});
	        			});
	        		}

	        		teamListTable.clearData();
	        		teamListTable.replaceData(dataList);
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

	<body class="modal-page">
        <div id="wrap">
        	<small class="note2 margin-3">! 학습그룹 배정이 완료된 학습그룹만 조회됩니다.</small>
        	<div class="board_top">
        		<select class="form-select" id="teamCtgrCd" onchange="teamList(this.value)">
                    <option value="" hidden>학습그룹 지정</option>
            		<c:forEach var="item" items="${teamCtgrList }">
						<option value="${item.lrnGrpId }">${item.lrnGrpnm }</option>
					</c:forEach>
                </select>
        	</div>

			<div id="list"></div>

			<script>
				// 리스트 테이블
				let teamListTable = UiTable("list", {
					lang: "ko",
					height: 200,
					columns: [
						{title:"NO.", 	field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
						{title:"팀명", 	field:"teamNm",			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
						{title:"팀장", 	field:"leaderNm",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
						{title:"인원수", 	field:"teamMbrCnt", 	headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100}
					]
				});
			</script>

			<div class="btns">
                <button class="btn type2" onclick="selectTeamCtgr();"><spring:message code='team.common.select'/><!-- 선택 --></button>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='team.common.close'/><!-- 닫기 --></button>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
