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
			    .then(() => bfrSrvyListSelect())
			    .catch(() => {});
		    });

			selectOption.smstrChrt()
		    .then(() => bfrSrvyListSelect())
		    .catch(() => {});

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					bfrSrvyListSelect();
				}
			});
		});

		/**
		 * 이전전체설문목록조회
		 */
    	function bfrSrvyListSelect() {
    		const url  = "/srvy/admRegistSrvyListAjax.do";
    		const data = {
    			smstrChrtId 		: $("#smstrChrtId").val(),
    			dgrsYr				: $("#dgrsYr").val(),
    			orgId 				: $("#orgId").val(),
    			srvyTrgtTycd 		: $("#srvyTrgtTycd").val(),
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
    	        				dataList.push({
    	    						no: 			v.lineNo,
    	    						orgnm: 			v.orgnm,
    	    						srvyTrgtTynm: 	v.srvyTrgtTycd == "ALL" ? "<spring:message code='srvy.common.all' />"/* 전체 */ : v.srvyTrgtTynm,
    	    						srvyTtl: 		UiComm.escapeHtml(v.srvyTtl),
    	    						selectBtn: 		"<a href='javascript:window.parent.srvyCopy(\"" + v.srvyId + "\")' class='btn basic small'><spring:message code='srvy.button.select' />​​</a>"/* 선택 */
    	    					});
    	        			});
    	        		}

    	        		srvyListTable.clearData();
    	        		srvyListTable.replaceData(dataList);
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
            <select class="form-select" id="smstrChrtId" onchange="bfrSrvyListSelect()">
            </select>
            <select class="form-select" id="orgId" disabled="true">
                <c:forEach var="org" items="${orgList }">
                	<option value="${org.orgId }" ${org.orgId eq vo.orgId ? 'selected' : '' }>${org.orgnm }</option>
                </c:forEach>
            </select>
            <select class="form-select" id="srvyTrgtTycd" onchange="bfrSrvyListSelect()">
            	<option value=""><spring:message code="common.object" /><!-- 대상 --></option>
            	<option value="ALL"><spring:message code="srvy.common.all" /><!-- 전체 --></option>
            	<option value="STDNT"><spring:message code="common.label.students" /><!-- 수강생 --></option>
            	<option value="PROF"><spring:message code="common.professor" /><!-- 교수 --></option>
            	<option value="TUT"><spring:message code="common.label.tutor" /><!-- 튜터 --></option>
            	<option value="ASSI"><spring:message code="common.teaching.assistant" /><!-- 조교 --></option>
            	<option value="ADM"><spring:message code="common.label.admin" /><!-- 관리자 --></option>
            	<option value="EXTRNL_LCTRR"><spring:message code="srvy.label.external.lecturer" /><!-- 외부강사 --></option>
            </select>
            <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='srvy.placeholder.input.all.srvy.ttl' />"><!-- 전체설문명 입력 -->
            <button type="button" class="btn basic icon search" aria-label="검색" onclick="bfrSrvyListSelect()"><i class="icon-svg-search"></i></button>
        </div>

        <div id="list"></div>

        <script>
			// 리스트 테이블
			let srvyListTable = UiTable("list", {
				lang: "ko",
				height: 400,
				columns: [
					{title:"No", 												field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
					{title:"<spring:message code='srvy.label.org' />", 			field:"orgnm",			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 기관 */
					{title:"<spring:message code='common.object' />", 			field:"srvyTrgtTynm",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 대상 */
					{title:"<spring:message code='srvy.label.all.srvy.ttl' />", field:"srvyTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:250},/* 전체설문 제목 */
					{title:"<spring:message code='srvy.button.select' />", 		field:"selectBtn", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}/* 선택 */
				]
			});
		</script>

		<div class="modal_btns">
	    	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
