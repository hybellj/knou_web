<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
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
			teamMbrListSelect();
		});

		// 팀원목록조회
		function teamMbrListSelect() {
			const url   = "/team/teamHome/listTeamMember.do";
			const data = {
				teamCd	: "${vo.teamCd}"
			};

			ajaxCall(url, data, function (data) {
	            if (data.result > 0) {
	            	let returnList = data.returnList || [];
	            	let dataList = createTeamMbrListHTML(returnList);	// 팀원 리스트 HTML 생성

	        		teamMbrListTable.clearData();
	        		teamMbrListTable.replaceData(dataList);

	        		const el = document.querySelector('#list');
	        		const height = el.getBoundingClientRect().height;
	        		window.parent.dialog[0].style.height = height + 110;
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        }, true);
		}

		// 팀원 리스트 HTML 생성
		function createTeamMbrListHTML(teamMbrList) {
			let dataList = [];

			if(teamMbrList.length == 0) {
				return dataList;
			} else {
				teamMbrList.forEach(function(v,i) {
					let ldrnm = v.leaderYn == "Y" ? "팀장" : "팀원";
					dataList.push({
						no:		v.lineNo,
						usernm:	v.userNm,
						ldrnm:	ldrnm
					});
				});
			}

			return dataList;
		}
	</script>

	<body class="modal-body">
		<div>
			<div id="list"></div>

			<script>
				// 리스트 테이블
				let teamMbrListTable = UiTable("list", {
					lang: "ko",
					columns: [
						{title:"No", 	field:"no",			headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
						{title:"이름", 	field:"usernm",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100},
						{title:"구분", 	field:"ldrnm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
					]
				});
			</script>
		</div>

		<div class="modal_btns">
        	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
