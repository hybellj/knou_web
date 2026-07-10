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
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					bfrQuizListSelect();
				}
			});
		});

		/**
		 * 이전 퀴즈 목록 조회
		 */
    	function bfrQuizListSelect() {
    		const url  = "/quiz/profAuthrtSbjctQuizListAjax.do";
    		const data = {
    			smstrChrtId : $("#smstrChrtId").val(),
    			sbjctId 	: $("#sbjctId").val(),
    			searchValue	: $("#searchValue").val(),
    			userId		: "${vo.userId}"
    		};

			$.ajax({
		        url 	  	: url,
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
    	    						no: 		v.lineNo,
    	    						sbjctnm: 	v.sbjctnm,
    	    						dvclasNo: 	(v.dvclasNo || "-") + "<spring:message code='quiz.label.decls' />"/* 반 */,
    	    						examGbnnm: 	v.examGbnnm,
    	    						examTtl: 	UiComm.escapeHtml(v.examTtl),
    	    						selectBtn: 	"<a href='javascript:window.parent.quizCopy(\"" + v.examBscId + "\")' class='btn basic small'><spring:message code='common.button.choice' />​</a>"/* 선택 */
    	    					});
    	        			});
    	        		}

    	        		quizListTable.clearData();
    	        		quizListTable.replaceData(dataList);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='quiz.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
    	}

		 /**
		 * 퀴즈학기기수선택
		 * @param smstrChrtId - 학기기수아이디
		 */
		function quizSmstrChrtChc(smstrChrtId) {
			let extData = {
				smstrChrtId   : smstrChrtId,
			};

			const url   = "/quiz/copyQstnSbjctListAjax.do";
			const param = {
				  encParams	: EPARAM
				, addParams	: UiComm.makeEncParams(extData)
			};

			ajaxCall(url, param, function(data) {
				if (data.result > 0) {
					let returnList = data.returnList || [];
					let html = "<option value='' selected><spring:message code='common.subject.select' /></option>";/* 과목 선택 */

		    		if(returnList.length > 0) {
		    			returnList.forEach(function(v, i) {
							html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + (v.dvclasNo || "-") + "<spring:message code='quiz.label.decls' /></option>";/* 반 */
		    			});
		    		}

		    		$("#sbjctId").empty().append(html);
		    		$("#sbjctId").val('').trigger("chosen:updated");
		        } else {
		        	UiComm.showMessage(data.message, "error");
		        }
		   	}, function(xhr, status, error) {
		   		UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
		   	}, true);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box info">
                <p class="txt"><i class="xi-error" aria-hidden="true"></i><spring:message code="quiz.label.select.copy.info" /><!-- 선택 시 정보가 복사됩니다. --></p>
            </div>
            <div class="board_top">
                <select class="form-select" id="smstrChrtId" onchange="quizSmstrChrtChc(this.value)">
                    <option value=""><spring:message code="quiz.label.year.smstr.select" /></option><!-- 학사년도/학기 선택 -->
            		<c:forEach var="item" items="${quizSearchSmstrList }">
						<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
					</c:forEach>
                </select>
                <select class="form-select" id="sbjctId" onchange="bfrQuizListSelect()">
                    <option value=""><spring:message code='common.subject.select' /></option><!-- 과목 선택 -->
                </select>
                <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='quiz.placeholder.input.quiz.nm' />"><!-- 퀴즈명 입력 -->
                <button type="button" class="btn basic icon search" aria-label="검색" onclick="bfrQuizListSelect()"><i class="icon-svg-search"></i></button>
            </div>

            <div id="list"></div>

            <script>
				// 리스트 테이블
				let quizListTable = UiTable("list", {
					lang: "ko",
					height: 300,
					columns: [
						{title:"No", 												field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
						{title:"<spring:message code='quiz.label.sbjct.nm' />", 	field:"sbjctnm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},/* 과목명 */
						{title:"<spring:message code='common.label.decls.no' />", 	field:"dvclasNo",		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 분반 */
						{title:"<spring:message code='quiz.label.quiz.type' />", 	field:"examGbnnm", 		headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 퀴즈 구분 */
						{title:"<spring:message code='quiz.label.ttl' />", 			field:"examTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:250},/* 퀴즈명 */
						{title:"<spring:message code='common.select' />", 			field:"selectBtn", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}/* 선택 */
					]
				});
			</script>

			<div class="modal_btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
