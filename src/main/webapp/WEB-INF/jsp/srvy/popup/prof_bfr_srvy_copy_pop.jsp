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
		 * @param {String}  smstrChrtId 	- 학사년도/학기
		 * @param {String}  sbjctId	 		- 과목아이디
		 * @param {String}  searchValue 	- 검색어 ( 설문명 )
		 * @param {String}  userId 			- 사용자아이디
		 * @returns {list} 설문목록
		 */
    	function bfrSrvyListSelect() {
    		var url  = "/srvy/profAuthrtSbjctSrvyListAjax.do";
    		var data = {
    			"smstrChrtId" 	: $("#smstrChrtId").val(),
    			"sbjctId" 		: $("#sbjctId").val(),
    			"searchValue" 	: $("#searchValue").val(),
    			"userId"		: "${vo.userId}"
    		};

    		UiComm.showLoading(true);
			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType  : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	UiComm.showLoading(false);
	        	if (data.result > 0) {
            		var returnList = data.returnList || [];
	        		var dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var srvyGbnnm = v.srvyGbn == "SRVY_TEAM" ? "설문 팀" : "설문";
							var selectBtn = "<a href='javascript:window.parent.srvyCopy(\"" + v.srvyId + "\")' class='btn basic small'>선택​</a>";

	        				dataList.push({
	    						no: 		v.lineNo,
	    						sbjctnm: 	v.sbjctnm,
	    						dvclasNo: 	v.dvclasNo + "반",
	    						srvyGbnnm: 	srvyGbnnm,
	    						srvyTtl: 	UiComm.escapeHtml(v.srvyTtl),
	    						selectBtn: 	selectBtn
	    					});
	        			});
	        		}

	        		srvyListTable.clearData();
	        		srvyListTable.replaceData(dataList);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
		    }).fail(function() {
		    	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		    });
    	}

		 /**
		 * 설문학기기수선택
		 * @param {String}  smstrChrtId - 학기기수아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function srvySmstrChrtChc(smstrChrtId) {
			var url  = "/quiz/copyQstnSbjctListAjax.do";
			var data = {
				"smstrChrtId"   : smstrChrtId,
				"sbjctId" 		: "${vo.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
				   	var returnList = data.returnList || [];
				   	var html = "<option value='' selected><spring:message code='exam.label.sel.crs' /></option>";/* 과목 선택 */

				   	if(returnList.length > 0) {
				   		returnList.forEach(function(v, i) {
							html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + v.dvclasNo + "반</option>";
				   		});
				   	}

				   	$("#sbjctId").empty().append(html);
				   	$("#sbjctId").val('').trigger("chosen:updated");
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    }
		   	}, function(xhr, status, error) {
		   		UiComm.showMessage("<spring:message code='exam.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
		   	});
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box info">
                <p class="txt"><i class="xi-error" aria-hidden="true"></i><spring:message code="exam.label.select.copy.info" /><!-- 선택 시 정보가 복사됩니다. --></p>
            </div>
            <div class="board_top">
                <select class="form-select" id="smstrChrtId" onchange="srvySmstrChrtChc(this.value)">
                    <option value=""><spring:message code="exam.label.open.crs.year.term" /> <spring:message code="exam.button.select" /></option><!-- 개설년도_학기 --><!-- 선택 -->
            		<c:forEach var="item" items="${srvySearchSmstrList }">
						<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
					</c:forEach>
                </select>
                <select class="form-select" id="sbjctId" onchange="bfrSrvyListSelect()">
                    <option value=""><spring:message code='crs.label.crecrs.sel' /></option><!-- 과목 선택 -->
                </select>
                <input class="form-control wide" type="text" id="searchValue" placeholder="설문명 입력">
                <button type="button" class="btn basic icon search" aria-label="검색" onclick="bfrSrvyListSelect()"><i class="icon-svg-search"></i></button>
            </div>

            <div id="list"></div>

            <script>
				// 리스트 테이블
				let srvyListTable = UiTable("list", {
					lang: "ko",
					height: 400,
					columns: [
						{title:"No", 		field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
						{title:"과목명", 		field:"sbjctnm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
						{title:"분반", 		field:"dvclasNo",		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
						{title:"설문구분", 	field:"srvyGbnnm", 		headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},
						{title:"설문명", 		field:"srvyTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:250},
						{title:"선택", 		field:"selectBtn", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}
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
