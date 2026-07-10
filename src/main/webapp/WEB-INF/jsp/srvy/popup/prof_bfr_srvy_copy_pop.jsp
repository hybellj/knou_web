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
					bfrSrvyListSelect();
				}
			});
		});

		/**
		 * 이전설문목록조회
		 */
    	function bfrSrvyListSelect() {
    		const url  = "/srvy/profAuthrtSbjctSrvyListAjax.do";
    		const data = {
    			smstrChrtId : $("#smstrChrtId").val(),
    			sbjctId 	: $("#sbjctId").val(),
    			searchValue : $("#searchValue").val(),
    			userId		: "${vo.userId}"
    		};

    		ajaxCall(url, data, function (data) {
	            if (data.result > 0) {
	            	let returnList = data.returnList || [];
                	let dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							let srvyId = v.srvyGbn == "SRVY_TEAM" ? v.subSrvyId : v.srvyId;
	        				dataList.push({
	    						no: 		v.lineNo,
	    						sbjctnm: 	v.sbjctnm,
	    						dvclasNo: 	v.dvclasNo + "<spring:message code='srvy.label.decls' />"/* 반 */,
	    						srvyGbnnm: 	v.srvyGbn == "SRVY_TEAM" ? "<spring:message code='srvy.common.srvy.team' />"/* 설문 팀 */ : "<spring:message code='srvy.common.srvy' />"/* 설문 */,
	    						srvyTtl: 	UiComm.escapeHtml(v.srvyTtl),
	    						selectBtn: 	"<a href='javascript:window.parent.srvyCopy(\"" + srvyId + "\")' class='btn basic small'><spring:message code='srvy.button.select' />​</a>"/* 선택 */
	    					});
	        			});
	        		}

	        		srvyListTable.clearData();
	        		srvyListTable.replaceData(dataList);
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        }, true);
    	}

		 /**
		 * 설문학기기수선택
		 * @param smstrChrtId - 학기기수아이디
		 */
		function srvySmstrChrtChc(smstrChrtId) {
			const url  = "/quiz/copyQstnSbjctListAjax.do";
			const data = {
				smstrChrtId : smstrChrtId,
				sbjctId 	: "${vo.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
				   	let returnList = data.returnList || [];
				   	let html = "<option value='' selected><spring:message code='srvy.label.select.sbjct' /></option>";	/* 과목 선택 */

				   	if(returnList.length > 0) {
				   		returnList.forEach(function(v, i) {
							html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + v.dvclasNo + "<spring:message code='srvy.label.decls' /></option>";/* 반 */
				   		});
				   	}

				   	$("#sbjctId").empty().append(html);
				   	$("#sbjctId").val('').trigger("chosen:updated");
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    }
		   	}, function(xhr, status, error) {
		   		UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
		   	}, true);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box info">
                <p class="txt"><i class="xi-error" aria-hidden="true"></i><spring:message code="srvy.label.select.copy.info" /><!-- 선택 시 정보가 복사됩니다. --></p>
            </div>
            <div class="board_top">
                <select class="form-select" id="smstrChrtId" onchange="srvySmstrChrtChc(this.value)">
                    <option value=""><spring:message code="srvy.label.select.smstr" /></option><!-- 학기기수 선택 -->
            		<c:forEach var="item" items="${srvySearchSmstrList }">
						<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
					</c:forEach>
                </select>
                <select class="form-select" id="sbjctId" onchange="bfrSrvyListSelect()">
                    <option value=""><spring:message code='srvy.label.select.sbjct' /></option><!-- 과목 선택 -->
                </select>
                <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='srvy.placeholder.input.srvy.ttl' />"><!-- 설문명 입력 -->
                <button type="button" class="btn basic icon search" aria-label="검색" onclick="bfrSrvyListSelect()"><i class="icon-svg-search"></i></button>
            </div>

            <div id="list"></div>

            <script>
				// 리스트 테이블
				let srvyListTable = UiTable("list", {
					lang: "ko",
					height: 400,
					columns: [
						{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
						{title:"<spring:message code='srvy.label.sbjct.nm' />", 		field:"sbjctnm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},/* 과목명 */
						{title:"<spring:message code='srvy.label.dvclas' />", 			field:"dvclasNo",		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 분반 */
						{title:"<spring:message code='srvy.label.srvy.category' />", 	field:"srvyGbnnm", 		headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 설문구분 */
						{title:"<spring:message code='srvy.label.title' />", 			field:"srvyTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:250},/* 설문명 */
						{title:"<spring:message code='srvy.button.select' />", 			field:"selectBtn", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}/* 선택 */
					]
				});
			</script>

			<div class="modal_btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /><!-- 닫기 --></button>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
