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
		});

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
	        		var html = "<option value='' selected>과목</option>";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + v.dvclasNo + "반</option>";
	        			});
	        		}

	        		$("#copySbjctId").empty().append(html);
	        		$("#copySbjctId").val('').trigger('chosen:updated');
	        		srvyQstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='exam.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		/**
		 * 설문과목선택
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function srvySbjctChc(sbjctId) {
			var url  = "/srvy/copyQstnSrvyListAjax.do";
			var data = {
				"sbjctId"  	: sbjctId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "<option value='' selected>설문</option>";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.srvyId + "'>" + v.srvyTtl + "</option>";
	        			});
	        		}

	        		$("#copySrvy").empty().append(html);
	        		$("#copySrvy").val('').trigger('chosen:updated');
	        		srvyQstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='exam.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		/**
		 * 설문선택
		 * @param {String}  srvyId 	- 설문아이디
		 */
		function srvyChc(srvyId) {
			var url  = "/srvy/copyQstnSrvypprListAjax.do";
			var data = {
				"srvyId"  	: srvyId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "<option value='' selected>설문지</option>";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.srvypprId + "'>" + v.srvyTtl + "</option>";
	        			});
	        		}

	        		$("#copySrvyppr").empty().append(html);
	        		$("#copySrvyppr").val('').trigger('chosen:updated');
	        		srvyQstnListTable.clearData();
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='exam.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		/**
		 * 설문지선택
		 * @param {String}  srvypprId 	- 설문지아이디
		 */
		function srvypprChc(srvypprId) {
			var url  = "/srvy/profQstnCopySrvyQstnListAjax.do";
			var data = {
				"srvypprId" : srvypprId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
	        		var dataList = createSrvyQstnListHTML(returnList);	// 설문문항 리스트 HTML 생성
	        		srvyQstnListTable.clearData();
	        		srvyQstnListTable.replaceData(dataList);
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='exam.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}

		// 설문문항 리스트 HTML 생성
		function createSrvyQstnListHTML(list) {
			var dataList = [];

			if(list.length > 0) {
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
			}

			return dataList;
		}

		/**
		 * 설문문항가져오기
		 * @param {String}  copySrvyQstnId 	- 복사설문문항아이디
		 * @param {String}  srvyId 			- 설문아이디
		 */
		function srvyQstnCopy() {
			if(!copyQstnChk()) {
				return false;
			}

			const qstns = [];	// 문항 가져오기용

			for(var i = 0; i < srvyQstnListTable.getSelectedData("srvyQstnId").length; i++) {
				var map = {
					copySrvyQstnId 	: srvyQstnListTable.getSelectedData("srvyQstnId")[i],
					srvyId			: "${vo.srvyId}"
				};
				qstns.push(map);
			}

			var url  = "/srvy/profSrvyQstnCopyAjax.do";

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType : "json",
		        data 	  : JSON.stringify(qstns),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
	       		window.parent.srvypprQstnListSelect();
	       		window.parent.closeDialog();
		    }).fail(function() {
		    	UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
		    });
		}

		// 가져오기 체크 확인
		function copyQstnChk() {
			var isChk    = true;

			if($("#copySmstrChrtId").val() == "") {
				UiComm.showMessage("<spring:message code='exam.alert.select.year.term' />", "info");	/* 학년도 학기를 선택하세요. */
				return false;
			}
			if($("#copySbjctId").val() == "") {
				UiComm.showMessage("<spring:message code='exam.alert.select.crs' />", "info");	/* 과목을 선택하세요. */
				return false;
			}
			if($("#copySrvy").val() == "") {
				UiComm.showMessage("설문을 선택하세요.", "info");
				return false;
			}
			if($("#copySrvyppr").val() == "") {
				UiComm.showMessage("설문지를 선택하세요.", "info");
				return false;
			}
			if(srvyQstnListTable.getSelectedData("srvyQstnId").length == 0) {
				UiComm.showMessage("<spring:message code='exam.alert.select.copy.qstn' />", "info");/* 복사할 문항을 선택하세요. */
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
        					<th><label for="copySmstrChrtId">학사년도/학기</label></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySmstrChrtId" onchange="srvySmstrChrtChc(this.value)">
	                                <option value="">학사년도/학기 선택</option>
						            <c:forEach var="item" items="${srvySearchSmstrList }">
						            	<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
						            </c:forEach>
	                            </select>
        					</td>
        				</tr>
        				<tr>
        					<th><label for="copySbjctId"><spring:message code="crs.label.crecrs" /></label><!-- 과목 --></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySbjctId" onchange="srvySbjctChc(this.value)">
	                                <option value=""><spring:message code="crs.label.crecrs.sel" /></option><!-- 과목 선택 -->
	                            </select>
        					</td>
        				</tr>
        				<tr>
        					<th><label for="copySrvy">설문</label></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySrvy" onchange="srvyChc(this.value)">
	                                <option value="">설문</option>
	                            </select>
        					</td>
        				</tr>
        				<tr>
        					<th><label for="copySrvyppr">설문지</label></th>
        					<td class="t_left">
        						<select class="form-select width-100per" id="copySrvyppr" onchange="srvypprChc(this.value)">
	                                <option value="">설문지</option>
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
						{title:"학사년도", 	field:"sbjctYr",			headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},
						{title:"학기", 		field:"sbjctSmstr",			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
						{title:"문제유형", 	field:"qstnRspnsTynm",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
						{title:"문제번호", 	field:"qstnSeqno", 			headerHozAlign:"center", hozAlign:"center", width:80, 	minWidth:80},
						{title:"제목", 		field:"qstnTtl", 			headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:200}
					]
				});
			</script>

        	<div class="btns">
        		<button class="btn type2" onclick="srvyQstnCopy()"><spring:message code="exam.label.copy" /></button><!-- 가져오기 -->
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
        	</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
