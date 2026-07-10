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
			$(".qstnList").css("display", "none");
			quizCopyTypeChk();
			qbnkCtgrList('upCtgrId');
		});

		// 퀴즈 가져오기 위치 선택
		function quizCopyTypeChk() {
			$(".listDiv").hide();
			let type = $("#copyType").val();

			// 문제 은행
			if(type == "qbnk") {
				$(".qbnkCopy").css("display", "table-row");
				$(".exampprCopy").css("display", "none");
				$("#qbnkList").show();
				qbnkCtgrList('upCtgrId');
			// 다른 시험
			} else if(type == "examppr") {
				$(".qbnkCopy").css("display", "none");
				$(".exampprCopy").css("display", "table-row");
				$("#quizList").show();
			}
			qbnkQstnListTable.clearData();
			quizQstnListTable.clearData();
		}

		/**
		 * 문제은행분류 목록 조회
		 * @param type	- (ctgrId : 하위분류, upCtgrId : 상위분류)
		 */
		function qbnkCtgrList(type) {
			qbnkQstnListTable.clearData();
			let upQbnkCtgrId = type == "ctgrId" ? $("#upQbnkCtgrId").val() : "";

			const url = "/qbnk/profQbnkCtgrListAjax.do";
			const data = {
				sbjctId 		: "${vo.sbjctId}",
				upQbnkCtgrId	: upQbnkCtgrId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "";
		        	if(type == "upCtgrId") {
						html += "<option value=''><spring:message code='quiz.label.upper.category' /></option>";	// 상위분류
		        	} else if(type == "ctgrId") {
						html += "<option value=''><spring:message code='quiz.label.sub.category' /></option>";		// 하위분류
		        	}

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.qbnkCtgrId + "'>" + v.ctgrnm + "</option>";
	        			});
	        		}

	        		let idText = type == "upCtgrId" ? "upQbnkCtgrId" : "qbnkCtgrId";
	        		$("#"+idText).empty().append(html);
	        		$("#"+idText).val('').trigger("chosen:updated");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		/**
		 * 문제은행분류선택
		 * @param obj - 선택한 문제은행분류
		 */
		function qbnkCtgrChc(obj) {
			if($(obj).attr("id") == "upQbnkCtgrId") {
				qbnkCtgrList("ctgrId");
			}
			let qbnkCtgrId = $("#upQbnkCtgrId").val();
			if($("#qbnkCtgrId").val() != null && $("#qbnkCtgrId").val() != "" && $(obj).attr("id") == "qbnkCtgrId") {
				qbnkCtgrId = $("#qbnkCtgrId").val();
			}

			const url  = "/qbnk/profQstnCopyQbnkQstnListAjax.do";
			const data = {
				  qbnkCtgrId 	: qbnkCtgrId
				, sbjctId		: "${vo.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		$(".copyQuizList").css("display", "block");
	        		$(".copyQuizList > ul.tbl-simple").show();
	        		$("div.qstnList").css("display", "none");
	    			$("table.qstnList").css("display", "none");
	    			let returnList = data.returnList || [];
	    			let dataList = createQuizQstnListHTML(returnList, "qbnk");	// 퀴즈문항 리스트 HTML 생성
	    			qbnkQstnListTable.clearData();
					qbnkQstnListTable.replaceData(dataList);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		/**
		 * 퀴즈학기기수선택
		 * @param smstrChrtId - 학기기수아이디
		 */
		function quizSmstrChrtChc(smstrChrtId) {
			const url  = "/quiz/copyQstnSbjctListAjax.do";
			const data = {
				smstrChrtId	: smstrChrtId,
				sbjctId 	: "${vo.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "";

	        		html += "<option value=''><spring:message code='common.subject' /></option>";/* 과목 */
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " " + v.dvclasNo + "<spring:message code='quiz.label.decls' /></option>";/* 반 */
	        			});
	        		}

	        		$("#copySbjctId").empty().append(html);
	        		$("#copySbjctId").val('').trigger("chosen:updated");
	    			quizQstnListTable.clearData();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		/**
		 * 퀴즈과목선택
		 * @param sbjctId 	- 과목아이디
		 */
		function quizSbjctChc(sbjctId) {
			var url  = "/quiz/copyQstnQuizListAjax.do";
			var data = {
				sbjctId	: sbjctId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value=''><spring:message code='quiz.label.examppr' /></option>";/* 시험지 */

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.examDtlId + "'>" + UiComm.escapeHtml(v.examTtl) + "</option>";
	        			});
	        		}

	        		$("#quizQstnPage").empty().append(html);
	        		$("#quizQstnPage").val('').trigger("chosen:updated");
	    			quizQstnListTable.clearData();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		/**
		 * 퀴즈선택
		 * @param examDtlId 	- 시험상세아이디
		 */
		function quizChc(examDtlId) {
			var url  = "/quiz/profQstnCopyQuizQstnListAjax.do";
			var data = {
				examDtlId : examDtlId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let dataList = createQuizQstnListHTML(returnList, "examppr");	// 퀴즈문항 리스트 HTML 생성
	        		quizQstnListTable.clearData();
					quizQstnListTable.replaceData(dataList);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		// 퀴즈문항 리스트 HTML 생성
		function createQuizQstnListHTML(list, type) {
			let dataList = [];

			if(list.length > 0) {
				list.forEach(function(v, i) {
					if(type == "qbnk") {
						dataList.push({
							upQbnkCtgrnm: 	v.upQbnkCtgrnm,
							qbnkCtgrnm: 	v.qbnkCtgrnm,
							qstnRspnsTynm: 	v.qstnRspnsTynm,
							qstnTtl: 		v.qstnTtl,
							qstnDfctlvTynm: v.qstnDfctlvTynm,
							qstnId:			v.qstnId
    					});
					} else if(type == "examppr") {
						dataList.push({
							sbjctYr: 		v.sbjctYr,
							sbjctSmstr: 	v.sbjctSmstr,
							qstnRspnsTynm: 	v.qstnRspnsTynm,
							qstnSeqno: 		v.qstnSeqno,
    						qstnCnddtSeqno: v.qstnCnddtSeqno,
    						qstnTtl: 		v.qstnTtl,
    						qstnDfctlvTynm: v.qstnDfctlvTynm,
    						qstnId:			v.qstnId
    					});
					}
				});
			}

			return dataList;
		}

		/**
		 * 퀴즈문항가져오기
		 */
		function quizQstnCopy() {
			if(!copyQstnChk()) {
				return false;
			}

			let copyType = $("#copyType").val();
			const qstns = [];	// 문항 가져오기용

			let tmp = copyType == "qbnk" ? qbnkQstnListTable : quizQstnListTable;
			for(var i = 0; i < tmp.getSelectedData("qstnId").length; i++) {
				qstns.push({
					copyQstnId 	: tmp.getSelectedData("qstnId")[i],
					examDtlId	: "${vo.examDtlId}"
				});
			}

			const url  = "/quiz/profQuizQstnCopyAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(qstns),
		        contentType	: "application/json; charset=UTF-8",
		    }).done(function(data) {
	       		window.parent.qstnScrAutoGrnt("${vo.examDtlId}");
	       		window.parent.closeDialog();
		    }).fail(function() {
		    	UiComm.showMessage("<spring:message code='quiz.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
		    });
		}

		// 가져오기 체크 확인
		function copyQstnChk() {
			let isChk    = true;
			let copyType = $("#copyType").val();

			// 문제 은행
			if(copyType == "qbnk") {
				if($("#upQbnkCtgrId").val() == "") {
					UiComm.showMessage("<spring:message code='quiz.alert.select.upper.category' />", "info");	/* 상위 분류를 선택하세요. */
					return false;
				}
				if(qbnkQstnListTable.getSelectedData("qstnId").length == 0) {
					UiComm.showMessage("<spring:message code='quiz.alert.select.copy.qstn' />", "info");	/* 복사할 문항을 선택하세요. */
					return false;
				}
			// 다른 시험
			} else if(copyType == "examppr") {
				if($("#copySmstrChrtId").val() == "") {
					UiComm.showMessage("<spring:message code='common.alert.select.term' />", "info");	/* 학기를 선택하세요. */
					return false;
				}
				if($("#copySbjctId").val() == "") {
					UiComm.showMessage("<spring:message code='common.label.select.crs' />", "info");	/* 과목을 선택하세요. */
					return false;
				}
				if($("#quizQstnPage").val() == "") {
					UiComm.showMessage("<spring:message code='quiz.alert.select.examppr' />", "info");	/* 시험지를 선택하세요. */
					return false;
				}
				if(quizQstnListTable.getSelectedData("qstnId").length == 0) {
					UiComm.showMessage("<spring:message code='quiz.alert.select.copy.qstn' />", "info");/* 복사할 문항을 선택하세요. */
					return false;
				}
			}

			return isChk;
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<table class="table-type2">
        		<colgroup>
        			<col class="width-15per" />
        			<col class="" />
        		</colgroup>
        		<tbody>
        			<tr>
        				<th><spring:message code="common.label.location" /><!-- 위치 --></th>
        				<td class="t_left">
        					<select class="form-select width-100per" id="copyType" onchange="quizCopyTypeChk()">
			                    <option value="qbnk"><spring:message code="quiz.label.copy.qbank" /></option><!-- 문제은행에서 가져오기 -->
						    	<option value="examppr"><spring:message code="quiz.label.copy.another.quiz" /></option><!-- 다른 퀴즈에서 가져오기 -->
			                </select>
        				</td>
        			</tr>
        			<tr class="qbnkCopy">
        				<th><spring:message code="common.label.ctgr" /><!-- 분류 --></th>
        				<td class="t_left">
        					<select class="form-select width-45per" id="upQbnkCtgrId" onchange="qbnkCtgrChc(this)">
			                    <option value=""><spring:message code="quiz.label.upper.category" /></option><!-- 상위분류 -->
			                </select>
        					<select class="form-select width-50per" id="qbnkCtgrId" onchange="qbnkCtgrChc(this)">
			                    <option value=""><spring:message code="quiz.label.sub.category" /></option><!-- 하위분류 -->
			                </select>
        				</td>
        			</tr>
        			<tr class="exampprCopy">
        				<th><spring:message code="quiz.label.year.smstr" /><!-- 학사년도/학기 --></th>
        				<td class="t_left">
        					<select class="form-select width-100per" id="copySmstrChrtId" onchange="quizSmstrChrtChc(this.value)">
			                    <option value=""><spring:message code="quiz.label.year.smstr" /><!-- 학사년도/학기 --></option>
						        <c:forEach var="item" items="${smstrList }">
						        	<option value="${item.smstrChrtId }">${item.smstrChrtnm }</option>
						        </c:forEach>
			                </select>
        				</td>
        			</tr>
        			<tr class="exampprCopy">
        				<th><spring:message code="common.subject" /><!-- 과목 --></th>
        				<td class="t_left">
        					<select class="form-select width-100per" id="copySbjctId" onchange="quizSbjctChc(this.value)">
			                    <option value=""><spring:message code="common.subject" /><!-- 과목 --></option>
			                </select>
        				</td>
        			</tr>
        			<tr class="exampprCopy">
        				<th><spring:message code="quiz.label.examppr" /><!-- 시험지 --></th>
        				<td class="t_left">
        					<select class="form-select width-100per" id="quizQstnPage" onchange="quizChc(this.value)">
			                    <option value=""><spring:message code="quiz.label.examppr" /><!-- 시험지 --></option>
			                </select>
        				</td>
        			</tr>
        		</tbody>
        	</table>

			<div id="quizList" class="listDiv"></div>
			<div id="qbnkList" class="listDiv"></div>

			<script>
				// 퀴즈문항리스트 테이블
				let quizQstnListTable = UiTable("quizList", {
					lang: "ko",
					height: 300,
					selectRow: "checkbox",
					columns: [
						{title:"<spring:message code='quiz.label.smstr.year' />", 		field:"sbjctYr",			headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 학사년도 */
						{title:"<spring:message code='common.term' />", 				field:"sbjctSmstr",			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 학기 */
						{title:"<spring:message code='quiz.label.qstn.type' />", 		field:"qstnRspnsTynm",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 문제유형 */
						{title:"<spring:message code='quiz.label.qstn.no' />", 			field:"qstnSeqno", 			headerHozAlign:"center", hozAlign:"center", width:80, 	minWidth:80},/* 문제번호 */
						{title:"<spring:message code='quiz.label.cnddt.qstn.no' />", 	field:"qstnCnddtSeqno", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 후보문제번호 */
						{title:"<spring:message code='common.label.title' />", 			field:"qstnTtl", 			headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:200},/* 제목 */
						{title:"<spring:message code='quiz.label.dfctlv' />", 			field:"qstnDfctlvTynm", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 난이도 */
					]
				});

				// 문제은행문항리스트 테이블
				let qbnkQstnListTable = UiTable("qbnkList", {
					lang: "ko",
					height: 300,
					selectRow: "checkbox",
					columns: [
						{title:"<spring:message code='quiz.label.upper.category' />", 	field:"upQbnkCtgrnm",		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:130},/* 상위분류 */
						{title:"<spring:message code='quiz.label.sub.category' />", 	field:"qbnkCtgrnm",			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:130},/* 하위분류 */
						{title:"<spring:message code='quiz.label.qstn.type' />", 		field:"qstnRspnsTynm",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 문제유형 */
						{title:"<spring:message code='common.label.title' />", 			field:"qstnTtl", 			headerHozAlign:"center", hozAlign:"left", 	width:0, 	minWidth:200},/* 제목 */
						{title:"<spring:message code='quiz.label.dfctlv' />", 			field:"qstnDfctlvTynm", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}/* 난이도 */
					]
				});
			</script>

			<div class="modal_btns">
                <button class="btn type1" onclick="quizQstnCopy()"><spring:message code="common.button.copy" /></button><!-- 가져오기 -->
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
