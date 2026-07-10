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
	        		let html = "<option value='' selected><spring:message code='srvy.label.select.sbjct' /></option>";/* 과목 선택 */

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + (v.dvclasNo || "-") + "<spring:message code='srvy.label.decls' /></option>";/* 반 */
	        			});
	        		}

	        		$("#copySbjctId").empty().append(html);
	        		$("#copySbjctId").val('').trigger('chosen:updated');
	        		srvyQstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		/**
		 * 설문과목선택
		 * @param sbjctId 	- 과목아이디
		 */
		function srvySbjctChc(sbjctId) {
			const url  = "/srvy/copyQstnSrvyListAjax.do";
			const data = {
				sbjctId	: sbjctId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value='' selected><spring:message code='srvy.common.srvy' /></option>";/* 설문 */

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.srvyId + "'>" + UiComm.escapeHtml(v.srvyTtl) + "</option>";
	        			});
	        		}

	        		$("#copySrvy").empty().append(html);
	        		$("#copySrvy").val('').trigger('chosen:updated');
	        		srvyQstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		/**
		 * 설문선택
		 * @param srvyId 	- 설문아이디
		 */
		function srvyChc(srvyId) {
			const url  = "/srvy/copyQstnSrvypprListAjax.do";
			const data = {
				srvyId	: srvyId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value='' selected><spring:message code='srvy.label.srvyppr' /></option>";/* 설문지 */

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.srvypprId + "'>" + UiComm.escapeHtml(v.srvyTtl) + "</option>";
	        			});
	        		}

	        		$("#copySrvyppr").empty().append(html);
	        		$("#copySrvyppr").val('').trigger('chosen:updated');
	        		srvyQstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		/**
		 * 설문지선택
		 * @param srvypprId 	- 설문지아이디
		 */
		function srvypprChc(srvypprId) {
			const url  = "/srvy/profQstnCopySrvyQstnListAjax.do";
			const data = {
				srvypprId : srvypprId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

	        		srvyQstnListTable.clearData();
	        		srvyQstnListTable.replaceData(dataList);
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
					sbjctYr: 		v.sbjctYr,
					sbjctSmstr: 	v.sbjctSmstr,
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

			for(var i = 0; i < srvyQstnListTable.getSelectedData("srvyQstnId").length; i++) {
				qstns.push({
					copySrvyQstnId 	: srvyQstnListTable.getSelectedData("srvyQstnId")[i],
					srvyId			: "${vo.srvyId}"
				});
			}

			const url  = "/srvy/profSrvyQstnCopyAjax.do";

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

			if($("#copySmstrChrtId").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.year.smstr' />", "info");	/* 학사년도/학기를 선택하세요. */
				return false;
			}
			if($("#copySbjctId").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.sbjct' />", "info");	/* 과목을 선택하세요. */
				return false;
			}
			if($("#copySrvy").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.srvy' />", "info");/* 설문을 선택하세요. */
				return false;
			}

			if($("#copySrvyppr").val() == "") {
				UiComm.showMessage("<spring:message code='srvy.alert.select.srvyppr' />", "info");/* 설문지를 선택하세요. */
				return false;
			}

			if(srvyQstnListTable.getSelectedData("srvyQstnId").length == 0) {
				UiComm.showMessage("<spring:message code='srvy.alert.select.copy.qstn' />", "info");/* 복사할 문항을 선택하세요. */
				return;
			}
			return isChk;
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<form id="copySearchFrm" onsubmit="return false;">
        		<table class="table-type2">
        			<colgroup>
        				<col class="width-20per" />
        				<col class="" />
        			</colgroup>
        			<tbody>
        				<tr>
        					<th><label for="copySmstrChrtId"><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></label></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySmstrChrtId" onchange="srvySmstrChrtChc(this.value)">
	                                <option value=""><spring:message code="srvy.label.select.smstr" /><!-- 학기기수 선택 --></option>
						            <c:forEach var="item" items="${srvySearchSmstrList }">
						            	<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
						            </c:forEach>
	                            </select>
        					</td>
        				</tr>
        				<tr>
        					<th><label for="copySbjctId"><spring:message code="common.subject" /></label><!-- 과목 --></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySbjctId" onchange="srvySbjctChc(this.value)">
	                                <option value=""><spring:message code="srvy.label.select.sbjct" /></option><!-- 과목 선택 -->
	                            </select>
        					</td>
        				</tr>
        				<tr>
        					<th><label for="copySrvy"><spring:message code="srvy.common.srvy" /><!-- 설문 --></label></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySrvy" onchange="srvyChc(this.value)">
	                                <option value=""><spring:message code="srvy.common.srvy" /><!-- 설문 --></option>
	                            </select>
        					</td>
        				</tr>
        				<tr>
        					<th><label for="copySrvyppr"><spring:message code="srvy.label.srvyppr" /><!-- 설문지 --></label></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySrvyppr" onchange="srvypprChc(this.value)">
	                                <option value=""><spring:message code="srvy.label.srvyppr" /><!-- 설문지 --></option>
	                            </select>
        					</td>
        				</tr>
        			</tbody>
        		</table>
        	</form>

        	<div id="srvyQstnList"></div>

        	<script>
				// 설문문항리스트 테이블
				let srvyQstnListTable = UiTable("srvyQstnList", {
					lang: "ko",
					height: 300,
					selectRow: "checkbox",
					columns: [
						{title:"<spring:message code='srvy.label.smstr.year' />", 	field:"sbjctYr",			headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 학사년도 */
						{title:"<spring:message code='srvy.label.smstr' />", 		field:"sbjctSmstr",			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 학기 */
						{title:"<spring:message code='srvy.label.qstn.type' />", 	field:"qstnRspnsTynm",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 문제유형 */
						{title:"<spring:message code='srvy.label.qstn.no' />", 		field:"qstnSeqno", 			headerHozAlign:"center", hozAlign:"center", width:80, 	minWidth:80},/* 문제번호 */
						{title:"<spring:message code='common.label.title' />", 		field:"qstnTtl", 			headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:200}/* 제목 */
					]
				});
			</script>

        	<div class="btns">
        		<button class="btn type2" onclick="srvyQstnCopy()"><spring:message code="srvy.button.retrieve" /></button><!-- 가져오기 -->
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
        	</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
