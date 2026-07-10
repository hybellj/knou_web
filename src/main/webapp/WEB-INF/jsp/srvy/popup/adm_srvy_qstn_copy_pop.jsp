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
			    .then(() => srvyListSelect())
			    .catch(() => {});
		    });

			selectOption.smstrChrt()
		    .then(() => srvyListSelect())
		    .catch(() => {});
		});

		// 전체설문목록조회
		function srvyListSelect() {
			const data = {
				orgId 				: $("#orgId").val(),
				dgrsYr				: $("#dgrsYr").val(),
				smstrChrtId			: $("#smstrChrtId").val(),
				srvyId				: "${vo.srvyId}",
				srvyQstnsCmptnyn	: "Y"
			};

			$.ajax({
		        url			: "/srvy/admRegistSrvyListAjax.do",
		        type		: "POST",
		        contentType	: "application/json",
		        data		: JSON.stringify(data),
		        dataType	: "json",
		        beforeSend	: () => UiComm.showLoading(true),
		        success		: function (data) {
		            if (data.result > 0) {
		            	let returnList = data.returnList || [];
		        		let html = "<option value=''><spring:message code='srvy.label.select.all.srvyppr' /></option>";/* 전체설문지 선택 */

		        		if(returnList.length > 0) {
		        			returnList.forEach(function(v, i) {
								html += "<option value='" + v.srvyId + "'>" + UiComm.escapeHtml(v.srvyTtl) + "</option>";
		        			});
		        		}

		        		$("#srvyId").empty().append(html);
		        		$("#srvyId").val('').trigger("chosen:updated");
		        		qstnListTable.clearData();
		            } else {
		            	UiComm.showMessage(data.message, "error");
		            }
		        },
		        error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),	/* 리스트 조회 중 에러가 발생하였습니다. */
		        complete	: () => UiComm.showLoading(false)
		    });
		}

		// 페이지목록조회
		function srvypprListSelect() {
			const url  = "/srvy/admCopyQstnSrvypprListAjax.do";
			const data = {
				srvyId	: $("#srvyId").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value='' selected><spring:message code='srvy.label.select.page' /></option>";/* 페이지 선택 */

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.srvypprId + "'>" + UiComm.escapeHtml(v.srvyTtl) + "</option>";
	        			});
	        		}

	        		$("#srvypprId").empty().append(html);
	        		$("#srvypprId").val('').trigger('chosen:updated');
	        		qstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		// 문항목록조회
		function srvyQstnListSelect() {
			const url  = "/srvy/admQstnCopySrvyQstnListAjax.do";
			const data = {
				srvypprId : $("#srvypprId").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

	        		qstnListTable.clearData();
	        		qstnListTable.replaceData(dataList);
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v, i) {
				dataList.push({
					qstnRspnsTynm: 	v.qstnRspnsTynm,
					qstnSeqno: 		v.qstnSeqno,
		   			qstnTtl: 		v.qstnTtl,
		   			srvyQstnId:		v.srvyQstnId
		   		});
			});

			return dataList;
		}

		/**
		 * 설문문항가져오기
		 */
		function srvyQstnCopy() {
			if(!copyQstnChk()) {
				return false;
			}

			const qstns = [];	// 문항 가져오기용

			for(var i = 0; i < qstnListTable.getSelectedData("srvyQstnId").length; i++) {
				qstns.push({
					copySrvyQstnId 	: qstnListTable.getSelectedData("srvyQstnId")[i],
					srvyId			: "${vo.srvyId}"
				});
			}

			const url  = "/srvy/admSrvyQstnCopyAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(qstns),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                	window.parent.srvypprQstnListSelect();
    	       		window.parent.closeDialog();
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.copy' />", "error"),	/* 가져오기 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
		}

		// 가져오기 체크 확인
		function copyQstnChk() {
			let isChk    = true;

			if($("#smstrChrtId").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.year.smstr' />", "info");	/* 학사년도/학기를 선택하세요. */
				return false;
			}
			if($("#orgId").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.org' />", "info");/* 기관을 선택하세요. */
				return false;
			}
			if($("#srvyId").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.all.srvyppr' />", "info");/* 전체설문지를 선택하세요. */
				return false;
			}

			if($("#srvypprId").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.page' />", "info");/* 페이지를 선택하세요. */
				return false;
			}

			if(qstnListTable.getSelectedData("srvyQstnId").length == 0) {
				UiComm.showMessage("<spring:message code='srvy.alert.select.copy.qstn' />", "info");/* 복사할 문항을 선택하세요. */
				return;
			}
			return isChk;
		}
	</script>

	<body class="modal-body">
        <div class="board_top">
        	<table class="table-type2">
	        	<colgroup>
	        		<col class="width-20per" />
	        		<col class="" />
	        	</colgroup>
	        	<tbody>
	        		<tr>
	        			<th><label for="smstrChrtId"><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></label></th>
	        			<td class="t_left">
	        				<select class="form-select" id="dgrsYr">
                            	<c:forEach var="year" items="${yearList }">
                            		<option value="${year }" ${year eq curYear ? 'selected' : '' }>${year }</option>
                            	</c:forEach>
                            </select>
	        				<select class="form-select" id="smstrChrtId" onchange="srvyListSelect()">
		                    </select>
	        			</td>
	        		</tr>
	        		<tr>
	        			<th><label for="orgId"><spring:message code="srvy.label.org" /><!-- 기관 --></label></th>
	        			<td class="t_left">
	        				<select class="form-select width-100per" id="orgId" disabled="true">
		                    	<c:forEach var="org" items="${orgList }">
				                	<option value="${org.orgId }" ${org.orgId eq vo.orgId ? 'selected' : '' }>${org.orgnm }</option>
				                </c:forEach>
		                    </select>
	        			</td>
	        		</tr>
	        		<tr>
	        			<th><label for="srvyId"><spring:message code="srvy.label.all.srvyppr" /><!-- 전체설문지 --></label></th>
	        			<td class="t_left">
	        				<select class="form-select width-100per" id="srvyId" onchange="srvypprListSelect()">
		                        <option value=""><spring:message code="srvy.label.select.all.srvyppr" /><!-- 전체설문지 선택 --></option>
		                    </select>
	        			</td>
	        		</tr>
	        		<tr>
	        			<th><label for="srvypprId"><spring:message code="srvy.label.page" /><!-- 페이지 --></label></th>
	        			<td class="t_left">
	        				<select class="form-select width-100per" id="srvypprId" onchange="srvyQstnListSelect()">
		                        <option value=""><spring:message code="srvy.label.select.page" /><!-- 페이지 선택 --></option>
		                    </select>
	        			</td>
	        		</tr>
	        	</tbody>
	        </table>
        </div>

        <div id="qstnList"></div>

		<script>
			// 강의평가문항리스트 테이블
			let qstnListTable = UiTable("qstnList", {
				lang: "ko",
				height: 300,
				selectRow: "checkbox",
				columns: [
					{title:"<spring:message code='srvy.label.qstn.type' />", 	field:"qstnRspnsTynm",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 문제유형 */
					{title:"<spring:message code='srvy.label.qstn.no' />", 		field:"qstnSeqno", 			headerHozAlign:"center", hozAlign:"center", width:80, 	minWidth:80},/* 문제번호 */
					{title:"<spring:message code='common.label.title' />", 		field:"qstnTtl", 			headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:200}/* 제목 */
				]
			});
		</script>

		<div class="modal_btns">
	    	<button class="btn type2" onclick="srvyQstnCopy()"><spring:message code="srvy.button.retrieve" /></button><!-- 가져오기 -->
	    	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
