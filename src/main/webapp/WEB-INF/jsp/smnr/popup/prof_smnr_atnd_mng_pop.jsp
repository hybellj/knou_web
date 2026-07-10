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
			smnrAtndSelect();
			smnrAtndHstryListSelect();
		});

		// 세미나참석정보조회
		function smnrAtndSelect() {
			const url  = "/smnr/smnrAtndSelectAjax.do";
			const data = {
				smnrId : "${vo.smnrId}",
				userId : "${vo.userId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let atnd = data.data;

	        		let atndScnds = "-";
	        		if(atnd != null && atnd.atndScnds != null) {
						let hours   = Math.floor(v.atndScnds / 3600);
						let minutes = Math.floor((v.atndScnds % 3600) / 60);
						let seconds = v.atndScnds % 60;
						atndScnds  = hours > 0 ? hours + ":" : "";
						atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
						atndScnds += seconds < 10 ? "0" + seconds : seconds;
	        		}

	        		let zoomDuration = "-";
	        		if("${vo.smnrGbncd}" == "ONLN_SMNR" && ${not empty zoomPastMeetingVO}) {
						let duration = zoomPastMeetingVO.duration;
	        			let hours   = Math.floor(duration / 3600);
						let minutes = Math.floor((duration % 3600) / 60);
						let seconds = duration % 60;
						zoomDuration  = hours > 0 ? hours + ":" : "";
						zoomDuration += (minutes < 10 ? "0" + minutes : minutes) + ":";
						zoomDuration += seconds < 10 ? "0" + seconds : seconds;
	        		}
	        		let html  = "<div class='table-wrap'>";
	        			html += "	<table class='table-type2'>";
	        			html += "		<colgroup>";
	        			html += "			<col class='' />";
	        			html += "			<col class='' />";
	        			html += "			<col class='width-15per' />";
	        			html += "			<col class='width-15per' />";
	        			html += "			<col class='width-20per' />";
	        			html += "		</colgroup>";
	        			html += "		<thead>";
	        			html += "			<tr>";
	        			html += "				<th>ZOOM 화상회의 진행시간</th>";
	        			html += "				<th>참여일시</th>";
	        			html += "				<th>참여시간</th>";
	        			html += "				<th>참여상태</th>";
	        			html += "				<th>참여관리</th>";
	        			html += "			</tr>";
	        			html += "		</thead>";
	        			html += "		<tbody>";
	        			html += "			<tr>";
	        			html += "				<td>" + zoomDuration + "</td>";
	        			html += "				<td>" + (atnd != null && atnd.atndSdttm != null ? UiComm.formatDate(atnd.atndSdttm, "datetime2") : "-") + "</td>";
	        			html += "				<td>" + atndScnds + "</td>";
	        			html += "				<td>" + (atnd != null && atnd.atndStscd == "ATND" ? "참석" : "미참석") + "</td>";
	        			html += "				<td>";
	        			html += "					<a href='javascript:atndStscdModify(\"ATND\")' class='btn type1'>참석</a>";
	        			html += "					<a href='javascript:atndStscdModify(\"ABSNT\")' class='btn type8'>미참석</a>";
	        			html += "				</td>";
	        			html += "			</tr>";
	        			html += "		</tbody>";
	        			html += "	</table>";
	        			html += "</div>";

					$("#atndViewDiv").empty().html(html);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("정보 조회 중 에러가 발생하였습니다.", "error");
			}, true);
		}

		// 사용자세미나참석이력목록조회
    	function smnrAtndHstryListSelect() {
    		const url  = "/smnr/userSmnrAtndHstryListAjax.do";
    		const data = {
    			smnrId 	: "${vo.smnrId}",
    			atndeId : "${vo.userId}"
    		};

    		ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let returnList = data.returnList || [];
					let dataList   = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				let atndScnds = v.atndScnds;

	    					let hours   = Math.floor(atndScnds / 3600);
	    					let minutes = Math.floor((atndScnds % 3600) / 60);
	    					let seconds = atndScnds % 60;
	    					atndScnds  = hours > 0 ? hours + ":" : "";
	    					atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
	    					atndScnds += seconds < 10 ? "0" + seconds : seconds;
	    					let atndStsnm = "";
	    					if(v.atndSdttm == null && v.atndEdttm == null && v.atndScnds == null) {
								atndStsnm += "참여상태 변경 : ";
	    					}
	    					if(v.atndStscd == "ABSNT") {
	    						atndStsnm += "미참석";
	    					} else if(v.atndStscd == "ATND") {
	    						atndStsnm += "참석";
	    					}

	        				dataList.push({
	    						cntnDvcTynm: 	v.cntnDvcTynm,
	    						atndeIp: 		v.atndeIp,
	    						atndSdttm: 		UiComm.formatDate(v.atndSdttm, "datetime2"),
	    						atndEdttm: 		UiComm.formatDate(v.atndEdttm, "datetime2"),
	    						atndScnds: 		v.atndScnds,
	    						atndStsnm: 		atndStsnm
	    					});
	        			});
	        		}

	        		hstryListTable.clearData();
	        		hstryListTable.replaceData(dataList);
			    } else {
			     	UiComm.showMessage(data.message, "error");
			    }
		    }, function(xhr, status, error) {
		    	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		    }, true);
    	}

		// 참석상태수정
		function atndStscdModify(atndStscd) {
			const url  = "/smnr/smnrAtndStsModifyAjax.do";
			const data = {
				smnrId 		: "${vo.smnrId}",
				atndeId		: "${vo.userId}",
				smnrAtndId	: "${atndVO.smnrAtndId}",
				atndStscd 	: atndStscd
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(${empty atndVO.smnrAtndId}) {
						location.reload();
					} else {
						smnrAtndSelect();
						smnrAtndHstryListSelect();
					}
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.score.open' />", "error");/* 성적 공개 변경 중 에러가 발생하였습니다. */
			}, true);
		}

		// 메모수정
		function atndMemoModify() {
			const url  = "/smnr/smnrAtndMemoModifyAjax.do";
			const data = {
				smnrId 		: "${vo.smnrId}",
				atndeId		: "${vo.userId}",
				smnrAtndId	: "${atndVO.smnrAtndId}",
				atndMemo 	: $("#atndMemo").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(${empty atndVO.smnrAtndId}) {
						location.reload();
					}
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    }
			}, function(xhr, status, error) {
				UiComm.showMessage("메모 수정 중 에러가 발생하였습니다.", "error");
			}, true);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="board_top class">
                <h3 class="board-title">
                	<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
					<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
					<c:set var="mntsHour" value="${vo.smnrMnts / 60 }" />
					<c:set var="mntsMin"><fmt:formatNumber value="${vo.smnrMnts % 60}" type="number" pattern="#" /></c:set>
                    ${vo.smnrnm }
                    <span>세미나 일시 : <uiex:formatDate type="datetime" value="${vo.smnrSdttm }"/> / <c:if test="${vo.smnrMnts >= 60 }">${mntsHour }시간 </c:if>${mntsMin }분 / 출결반영 : ${vo.mrkRfltyn eq 'Y' ? yes : no }</span>
                </h3>
                <div class="right-area">
                    <div class="feedback-info">
                        <p class="desc">
                            <span><strong>${atndVO.deptnm }</strong></span>
                            <span><strong>${atndVO.stdntNo }</strong></span>
                            <span><strong>${uiex:maskUserNm(atndVO.usernm)}</strong></span>
                        </p>
                    </div>
                </div>
            </div>

			<b class="margin-bottom-2">* 참여 관리</b>
        	<div id="atndViewDiv"></div>

			<b class="margin-bottom-2 margin-top-4">* 참여 관리 이력</b>
            <div id="list"></div>

            <script>
				// 리스트 테이블
				let hstryListTable = UiTable("list", {
					lang: "ko",
					height: 200,
					columns: [
						{title:"디바이스",			field:"cntnDvcTynm",	headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
						{title:"IP",	 		field:"atndeIp",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:120},
						{title:"시작일시",			field:"atndSdttm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
						{title:"종료일시",			field:"atndEdttm", 		headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:150},
						{title:"참여시간", 		field:"atndScnds", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
						{title:"참여구분", 		field:"atndStsnm", 		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:200}
					]
				});
			</script>

			<div class="board_top margin-bottom-2 margin-top-4">
				<b>* 메모</b>
				<button class="right-area btn type1" onclick="atndMemoModify()">메모저장</button>
			</div>
        	<textarea style="width:100%;height:70px" id="atndMemo" maxLenCheck="byte,4000,true,true">${atndVO.atndMemo }</textarea>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>