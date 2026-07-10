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
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					smnrAtndHstryListSelect();
				}
			});

			smnrAtndHstryListSelect();
		});

		// 세미나참석이력목록조회
    	function smnrAtndHstryListSelect() {
    		const url  = "/smnr/profSmnrAtndHstryListAjax.do";
    		const data = {
    			smnrId 		: "${vo.smnrId}",
    			searchValue : $("#searchValue").val()
    		};

    		ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let returnList = data.returnList || [];
					let dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				let atndScnds = v.atndScnds;

	    					let hours   = Math.floor(atndScnds / 3600);
	    					let minutes = Math.floor((atndScnds % 3600) / 60);
	    					let seconds = atndScnds % 60;
	    					atndScnds  = (hours < 10 ? "0" + hours : hours) + ":";
	    					atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
	    					atndScnds += seconds < 10 ? "0" + seconds : seconds;

	        				dataList.push({
	    						no: 			v.lineNo,
	    						userRprsId: 	v.userRprsId,
	    						stdntNo: 		v.stdntNo,
	    						usernm: 		v.usernm,
	    						atndSdttm: 		UiComm.formatDate(v.atndSdttm, "datetime2"),
	    						atndEdttm: 		UiComm.formatDate(v.atndEdttm, "datetime2"),
	    						atndScnds: 		atndScnds,
	    						cntnDvcTynm: 	v.cntnDvcTynm
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
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<table class="table-type2 margin-bottom-5">
        		<colgroup>
        			<col class="width-15per" />
        			<col class="" />
        			<col class="width-15per" />
        		</colgroup>
        		<tbody>
        			<tr>
        				<th>과목</th>
        				<td class="t_left">${vo.sbjctnm } ${vo.dvclasNo }반</td>
        				<td rowspan="2">
        					<button type="button" class="btn type1" onclick="smnrAtndHstryListSelect()">검색</button>
        				</td>
        			</tr>
        			<tr>
        				<th>검색어</th>
        				<td class="t_left"><input class="form-control width-100per" type="text" id="searchValue" placeholder="대표아이디/학번/이름 입력"></td>
        			</tr>
        		</tbody>
        	</table>

            <div id="list"></div>

            <script>
				// 리스트 테이블
				let hstryListTable = UiTable("list", {
					lang: "ko",
					height: 350,
					columns: [
						{title:"No", 			field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
						{title:"대표아이디", 		field:"userRprsId",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100},
						{title:"학번", 			field:"stdntNo",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100},
						{title:"이름", 			field:"usernm", 		headerHozAlign:"center", hozAlign:"left", 	width:0, 	minWidth:100},
						{title:"참석시작일시", 		field:"atndSdttm", 		headerHozAlign:"center", hozAlign:"left", 	width:150,	minWidth:150},
						{title:"참석종료일시", 		field:"atndEdttm", 		headerHozAlign:"center", hozAlign:"left", 	width:150,	minWidth:150},
						{title:"참석시간", 		field:"atndScnds", 		headerHozAlign:"center", hozAlign:"left", 	width:100,	minWidth:100},
						{title:"접속기기", 		field:"cntnDvcTynm", 	headerHozAlign:"center", hozAlign:"left", 	width:100,	minWidth:100}
					]
				});
			</script>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
