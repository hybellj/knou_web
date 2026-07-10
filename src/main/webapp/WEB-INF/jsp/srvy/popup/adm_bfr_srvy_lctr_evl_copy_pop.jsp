<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="admin"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			// 학사년도
			$('#dgrsYr').on('change', function() {
				selectOption.smstrChrt()
			    .then(() => bfrSrvyLctrEvlListSelect())
			    .catch(() => {});
		    });

			selectOption.smstrChrt()
		    .then(() => bfrSrvyLctrEvlListSelect())
		    .catch(() => {});

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					bfrSrvyLctrEvlListSelect();
				}
			});
		});

		/**
		 * 이전설문강의평가목록조회
		 */
    	function bfrSrvyLctrEvlListSelect() {
    		const url  = "/srvy/admRegistSrvyLctrEvlListAjax.do";
    		const data = {
    			smstrChrtId 		: $("#smstrChrtId").val(),
    			orgId 				: $("#orgId").val(),
    			srvyTrgtGbncd 		: $("#srvyTrgtGbncd").val(),
    			searchValue 		: $("#searchValue").val(),
    			srvyId				: "${vo.srvyId}",
    			srvyQstnsCmptnyn	: "Y"
    		};

			$.ajax({
		        url 	 	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType  	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	let returnList = data.returnList || [];
                    	let dataList = [];

    	        		if(returnList.length > 0) {
    	        			returnList.forEach(function(v, i) {
    	        				// 강의평가구분
    	    					let srvyTynm = {
    	    						"SRVY_MIDEXAM_AFTR_LCTR_EVL" : "<spring:message code='srvy.label.mid.lctr.evl' />"/* 중간 강의평가 */,
    	    						"SRVY_LSTEXAM_AFTR_LCTR_EVL" : "<spring:message code='srvy.label.lst.lctr.evl' />"/* 기말 강의평가 */
    	    					};

    	        				dataList.push({
    	    						no: 			v.lineNo,
    	    						orgnm: 			v.orgnm,
    	    						srvyWrtTynm: 	v.srvyWrtTynm,
    	    						srvyTrgtGbnnm: 	v.srvyTrgtGbnnm,
    	    						srvyTtl: 		UiComm.escapeHtml(v.srvyTtl),
    	    						srvyTynm: 		srvyTynm[v.srvyTycd],
    	    						selectBtn: 		"<a href='javascript:window.parent.srvyLctrEvlCopy(\"" + v.srvyId + "\")' class='btn basic small'><spring:message code='srvy.button.select' />​</a>"/* 선택 */
    	    					});
    	        			});
    	        		}

    	        		srvyLctrEvlListTable.clearData();
    	        		srvyLctrEvlListTable.replaceData(dataList);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
    	}
	</script>

	<body class="modal-body">
        <div class="board_top">
        	<select class="form-select wide" id="dgrsYr">
            	<c:forEach var="year" items="${yearList }">
            		<option value="${year }" ${year eq curYear ? 'selected' : '' }>${year }</option>
            	</c:forEach>
            </select>
            <select class="form-select" id="smstrChrtId" onchange="bfrSrvyLctrEvlListSelect()">
            </select>
            <select class="form-select" id="orgId" disabled="true">
                <c:forEach var="org" items="${orgList }">
                	<option value="${org.orgId }" ${org.orgId eq vo.orgId ? 'selected' : '' }>${org.orgnm }</option>
                </c:forEach>
            </select>
            <select class="form-select" id="srvyTrgtGbncd" onchange="bfrSrvyLctrEvlListSelect()">
            	<option value=""><spring:message code="common.label.ctgr" /><!-- 분류 --></option>
            	<option value="WHOL"><spring:message code="srvy.label.batch" /><!-- 일괄 --></option>
            	<option value="SBJCT"><spring:message code="srvy.label.by.sbjct" /><!-- 과목별 --></option>
            </select>
            <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='srvy.placeholder.input.lctr.evl.ttl' />"><!-- 강의평가명 입력 -->
            <button type="button" class="btn basic icon search" aria-label="검색" onclick="bfrSrvyLctrEvlListSelect()"><i class="icon-svg-search"></i></button>
        </div>

        <div id="list"></div>

        <script>
			// 리스트 테이블
			let srvyLctrEvlListTable = UiTable("list", {
				lang: "ko",
				height: 400,
				columns: [
					{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
					{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm",			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 기관 */
					{title:"<spring:message code='srvy.label.manage.type' />", 		field:"srvyWrtTynm",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 관리구분 */
					{title:"<spring:message code='common.label.ctgr' />", 			field:"srvyTrgtGbnnm",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 분류 */
					{title:"<spring:message code='srvy.label.lctr.evl.ttl' />", 	field:"srvyTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:250},/* 강의평가 제목 */
					{title:"<spring:message code='srvy.label.lctr.evl.type' />", 	field:"srvyTynm", 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120},/* 강의평가 구분 */
					{title:"<spring:message code='srvy.button.select' />", 			field:"selectBtn", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}/* 선택 */
				]
			});
		</script>

		<div class="modal_btns">
	    	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
