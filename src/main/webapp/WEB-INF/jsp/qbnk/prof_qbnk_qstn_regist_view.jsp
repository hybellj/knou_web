<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function () {
			qstnRspnsTycdChgChange();

			if(${not empty qbnkQstnVO.qbnkQstnId}) {
				qbnkQstnSetting();
			}
		});

		/**
		 * 문제은행 화면 이동
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function qbnkViewMv(tab) {
			var urlMap = {
				"1" : "/qbnk/profQbnkListView.do",		// 문제은행 목록 화면
				"2" : "/qbnk/profQbnkCtgrMngView.do"	// 분류코드 관리 화면
			};

			var kvArr = [];
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(urlMap[tab], kvArr);
		}

	    // 문항답변유형코드 변경
	    function qstnRspnsTycdChgChange() {
			$("#qstnTypeDiv > table > tbody").empty();	// 문항보기항목 비우기

			var type = $("#qbnkRegistForm select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
			// 단일선택형, 다중선택형
	        if(type == "ONE_CHC" || type == "MLT_CHC") {
	        	formOption.createVwitmCntHTML(type);	// 보기항목 수 HTML 추가
	        	formOption.createChgQstnHTML();			// 단일, 다중선택형 문항 HTML 추가
	        	createVwitmCntChgHTML(type);			// 보기항목 수 변경 HTML 추가

	        // 단답형
	        } else if(type == "SHORT_TEXT") {
	        	formOption.createTextQstnHTML();		// 단답형 문항 HTML 추가

	        // OX선택형
	        } else if(type == "OX_CHC") {
	        	formOption.createOxQstnHTML();			// OX선택형 문항 HTML 추가

	        // 연결형
	        } else if(type == "LINK") {
	        	formOption.createVwitmCntHTML(type);	// 보기항목 수 HTML 추가
	        	formOption.createLinkQstnHTML();		// 연결형 문항 HTML 추가
	        	createVwitmCntChgHTML(type);			// 보기항목 수 변경 HTML 추가
	        }

	        formOption.createQstnDfctlvHTML();			// 문항 난이도 HTML 추가
	    }

	    /**
		 * 문제은행하위분류목록조회
		 * @param {Integer} qbnkCtgrId 	- 문제은행분류아이디
		 * @param {String}  userRprsId 	- 사용자대표아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 * @returns {list} 문제은행하위분류 목록
		 */
	    function subQbnkCtgrList(qbnkCtgrId) {
	    	var url  = "/qbnk/profQbnkCtgrListAjax.do";
			var data = {
				"upQbnkCtgrId" 	: qbnkCtgrId,
				"userRprsId"	: "${qbnkSbjct.userRprsId}",
				"sbjctId"		: "${qbnkSbjct.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		html = "<option value=''><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */

	        		if(returnList.length > 0 && qbnkCtgrId != "") {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.qbnkCtgrId + "'>" + v.ctgrnm + "</option>";
		        		});
	        		}

	        		var ctgrId = "";
	        		if(${not empty qbnkQstnVO.upQbnkCtgrId}) {
						ctgrId = "${qbnkQstnVO.qbnkCtgrId}";
	        		}
	        		$("#selectQbnkCtgrId").empty().append(html);
	        		$("#selectQbnkCtgrId").val(ctgrId).trigger("chosen:updated");
	        		$("#selectQbnkCtgrId").val(ctgrId).prop("selected", true).trigger("change");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
			}, true);
	    }

		var formOption = {
			/**
			 * 보기항목 수 HTML 추가
			 * @param {String}  type 		- 문항답변유형코드
			 */
			createVwitmCntHTML: function(type) {
				var html  = "<tr>";
		    		html += "	<th>보기 개수</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<select class='form-select' name='vwitmCnt' onchange='createVwitmCntChgHTML(\"" + type + "\")' required='true'>";
		    						for(var idx = 2; idx <= 10; idx++) {
		    							var selected = (type == "ONE_CHC" || type == "MLT_CHC") && idx == 2 ? "selected" : "";
		    		html += "			<option value=\"" + idx + "\" " + selected + ">" + idx + "개</option>";
		    						}
		    		html += "		</select>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#qstnTypeDiv > table > tbody").append(html);
		    	$("#qstnTypeDiv select[name=vwitmCnt]").chosen({disable_search: true});
			},
			/**
			 * 단일, 다중선택형 문항 HTML 추가
			 */
			createChgQstnHTML: function() {
				var html  = "<tr>";
		    		html += "	<th>보기 입력</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<table class='table-type2'>";
		    		html += "			<colgroup>";
		    		html += "				<col class='width-20per' />";
		    		html += "				<col class='' />";
		    		html += "			</colgroup>";
		    		html += "			<tbody class='qstnItemTbody'></tbody>";
		    		html += "		</table>";
		    		html += "	</td>";
		    		html += "</tr>";
		    		html += "<tr>";
		    		html += "	<th>전체 정답처리</th>";
		    		html += "	<td class='t_left'>";
			    	html += "		<input type='checkbox' value='Y' name='wholCrans' class='switch'>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#qstnTypeDiv > table > tbody").append(html);
		    	UiSwitcher();
			},
			/**
			 * 단답형 문항 HTML 추가
			 */
			 createTextQstnHTML: function() {
				var html  = "<tr>";
		    		html += "	<th>정답 입력</th>";
		    		html += "	<td class='t_left' id='qstnDiv'>";
		    		html += "		<div class='shortInput flex gap-1'>";
		    		for(var i = 0; i < 5; i++) {
		    		html += "			<input type='text' name='vwitmCts' class='w100' " + (i == 0 ? "required='true'" : "") + ">";
		    		}
		    		html += "			<button class='btn basic icon' onclick='formOption.createTextQstnAddHTML()'><i class='xi-plus'></i></button>";
		    		html += "		</div>";
		    		html += "	</td>";
		    		html += "</tr>";
		    		html += "<tr id='shortGubun'>";
		    		html += "	<th>정답 유형</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<span class='custom-input'>";
		    		html += "			<input type='radio' name='cransTycd' id='cransI' value='cransInorder' checked='checked'>";
		    		html += "			<label for='cransI'>순서에 맞게 정답</label>";
		    		html += "		</span>";
		    		html += "		<span class='custom-input'>";
		    		html += "			<input type='radio' name='cransTycd' id='cransN' value='cransNotInorder'>";
		    		html += "			<label for='cransN'>순서에 상관없이 정답</label>";
		    		html += "		</span>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#qstnTypeDiv > table > tbody").append(html);
			},
			/**
			 * OX선택형 문항 HTML 추가
			 */
			 createOxQstnHTML: function() {
				var html  = "<tr>";
		    		html += "	<th>정답 입력</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<div class='list_view_box width-50per'>";
		    		html += "			<span class='checkImg'>";
		    							for(var idx = 1; idx <= 2; idx++) {
		    								var oxClass = idx == 1 ? "true" : "false";
		    		html += "				<input type='radio' name='vwitmCts' id='ox_"+oxClass+"' value='" + (idx == 1 ? "O" : "X") + "' >";
		    		html += "				<label for='ox_"+oxClass+"' class='imgChk "+oxClass+"'></label>";
		    							}
		    		html += "			</span>";
		    		html += "		</div>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#qstnTypeDiv > table > tbody").append(html);
			},
			/**
			 * 연결형 문항 HTML 추가
			 */
			 createLinkQstnHTML: function() {
				var html  = "<tr>";
		    		html += "	<th>정답 입력</th>";
		    		html += "	<td>";
		    		html += "		<table class='table-type2'>";
					html += "			<colgroup>";
					html += "				<col class='width-5per' />";
					html += "				<col class='width-45per' />";
					html += "				<col class='width-45per' />";
					html += "			</colgroup>";
					html += "			<tbody id='linkTbody'>";
					html += "			</tbody>";
					html += "		</table>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#qstnTypeDiv > table > tbody").append(html);
			},
			/**
			 * 단답형 문항 추가 HTML 추가
			 */
			 createTextQstnAddHTML: function() {
				var shortInputCnt = $(".shortInput").length;
				if(shortInputCnt == 5) {
					return false;
				}
				var html  = "<div class='shortInput flex gap-1 margin-top-2' id='shortInput"+shortInputCnt+"'>";
					for(var i = 0; i < 5; i ++) {
					html += "	<input type='text' name='vwitmCts' class='w100' " + (i == 0 ? "required='true'" : "") + " />";
					}
					html += "	<button class='btn basic icon' onclick='formOption.textQstnDelHTML("+shortInputCnt+")'><i class='xi-minus'></i></button>";
					html += "	<button class='btn basic icon' onclick='formOption.createTextQstnAddHTML()'><i class='xi-plus'></i></button>";
					html += "</div>";
				$("#qstnDiv").append(html);
			},
			/**
			 * 단답형 문항 HTML 삭제
			 * @param {Integer} cnt 		- 삭제할 문항 줄 값
			 */
		    textQstnDelHTML: function(cnt) {
		    	$("#shortInput"+cnt).remove();
		    },
		    /**
			 * 문항 난이도 HTML 추가
			 */
		    createQstnDfctlvHTML: function() {
		    	var html  = "<tr>";
		    		html += "	<th>난이도</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<select class='form-select' name='qstnDfctlvTycd' required='true'>";
		    						<c:forEach var="code" items="${qstnDfctlvTycdList }">
		    		html += "			<option value='${code.cd }'>${code.cdnm }</option>";
		    						</c:forEach>
		    		html += "		</select>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#qstnTypeDiv > table > tbody").append(html);
		    	$("#qstnTypeDiv select[name=qstnDfctlvTycd]").chosen({disable_search: true});
		    }
		};

		/**
		 * 보기항목 수 변경 HTML 추가
		 * @param {String}  type - 문항답변유형코드 ( ONE_CHC : 단일선택형, MLT_CHC : 다중선택형, LINK : 연결형 )
		 */
	    function createVwitmCntChgHTML(type) {
		    var vwitmCnt   = $("#qstnTypeDiv select[name=vwitmCnt]").val();	// 보기 항목 개수 selectBox
	    	// 단일, 다중선택형
	    	if(type == "ONE_CHC" || type == "MLT_CHC") {
		    	var vwitmLiCnt = $("#qstnTypeDiv .qstnItemTbody .vwitmTr").length;	// 기존 보기항목 수

		    	if(vwitmLiCnt < vwitmCnt) {
			    	for(var i = vwitmLiCnt; i < vwitmCnt; i++) {
					   	var html  = "<tr class='vwitmTr'>";
					   		html += "	<th>";
							html += "		<span class='custom-input'>";
					   		// 다중선택형
					   		if(type == "MLT_CHC") {
					   		html += "			<input type='checkbox' name='vwitmSeqno' id='vwitmSeqno_"+(i+1)+"' value='"+(i+1)+"' >";
					   		// 단일선택형
					   		} else if(type == "ONE_CHC") {
					   		html += "			<input type='radio' name='vwitmSeqno' id='vwitmSeqno_"+(i+1)+"' value='"+(i+1)+"' >";
					   		}
					   		html += "			<label for='vwitmSeqno_"+(i+1)+"'>보기"+(i+1)+"</label>";
					   		html += "		</span>";
					   		html += "	</th>";
					   		html += "	<td class='t_left'><input type='text' class='width-100per' name='vwitmCts' id='vwitm_"+(i+1)+"' required='true' /></td>";
					   		html += "</tr>";
				    	$("#qstnTypeDiv .qstnItemTbody").append(html);
			    	}
		    	} else if(vwitmLiCnt > vwitmCnt) {
			    	for(var i = vwitmLiCnt; i > vwitmCnt-1; i--) {
			    	 	$("#qstnTypeDiv .qstnItemTbody .vwitmTr:eq("+i+")").remove();
			    	}
		    	}

		    // 연결형
	    	} else if(type == "LINK") {
	    		var vwitmDivCnt = $("#linkTbody .vwitmTr").length;

	    		if(vwitmDivCnt < vwitmCnt) {
	    			for(var i = vwitmDivCnt; i < vwitmCnt; i++) {
						var html  = "<tr class='vwitmTr'>";
							html += "	<td>" + (i+1) + "</td>";
							html += "	<td><input type='text' name='qstnVwitmTtl' id='vwitmTtl_"+(i+1)+"' placeholder='보기 입력' required='true' /></td>";
							html += "	<td><input type='text' name='vwitmCts' id='vwitmCts_"+(i+1)+"' placeholder='정답 입력' required='true' /></td>";
							html += "</tr>";
		    			$("#linkTbody").append(html);
	    			}
	    		} else if(vwitmDivCnt > vwitmCnt) {
	    			for(var i = vwitmDivCnt; i > vwitmCnt-1; i--) {
	    				$("#linkTbody .vwitmTr:eq("+i+")").remove();
	    			}
	    		}
	    	}
	    }

		// 문제은행문항등록
		function qbnkQstnRegist() {
			UiValidator("qbnkRegistForm").then(function(result) {
				if (result) {
					if(!isValidQuizQstn()) {
					 	return false;
					}

					UiComm.showLoading(true);
					var url = "/qbnk/qbnkQstnRegistAjax.do";
					if(${not empty qbnkQstnVO.qbnkQstnId}) {
						url = "/qbnk/qbnkQstnModifyAjax.do";
					}

					$.ajax({
						url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#qbnkRegistForm").serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
					 	if (data.result > 0) {
					 		qbnkViewMv(1);
					    } else {
					    	UiComm.showMessage(data.message, "error");
					    }
					}).fail(function() {
						 UiComm.showLoading(false);
						 if(${not empty qbnkQstnVO.qbnkQstnId}) {
							 UiComm.showMessage("문항 수정 중 에러가 발생하였습니다.", "error");
						 } else {
							 UiComm.showMessage("문항 등록 중 에러가 발생하였습니다.", "error");
						 }
					});
				}
			});
		}

		function isValidQuizQstn() {
	    	var formId = "qbnkRegistForm";

	    	if($("#"+formId+" select[name=selectQbnkCtgrId]").val() == "") {
				$("#qbnkCtgrId").val($("#"+formId+" select[name=upQbnkCtgrId]").val());
	    	} else {
	    		$("#qbnkCtgrId").val($("#"+formId+" select[name=selectQbnkCtgrId]").val());
	    	}

			var qstnRspnsTycd = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
			$("#"+formId).find("input[type=hidden][name=cransTycd]").remove();
			$("#"+formId).find("input[name=qstns]").remove();

			const qstns = [];	// 문항 등록용

			// 단일, 다중선택형
			if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
				var isWholCrans = $("#"+formId).find("input[name=wholCrans]").prop("checked");	// 전체 정답처리 체크 여부
				if(!isWholCrans && $("#"+formId).find("input[name=vwitmSeqno]:checked").length == 0) {
					UiComm.showMessage("<spring:message code='exam.alert.select.answer' />", "info");/* 정답을 선택하세요. */
					return false;
				}

				// 다중정답 처리
				if($("#"+formId).find("input[name=vwitmSeqno]:checked").length > 1 || isWholCrans) {
					$("#"+formId).append("<input type='hidden' name='cransTycd' value='CRANS_MLT' />");
				}

				var vwitmCnt = $("#"+formId+" select[name=vwitmCnt]").val();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					const map = {
						vwitmSeqno: i,
						cransyn: $("#vwitmSeqno_"+i).prop("checked") || $("#"+formId).find("input[name=wholCrans]").prop("checked") ? "Y" : "N",
						vwitmCts: $("#vwitm_"+i).val()
					};

					qstns.push(map);
				}

			// 단답형
			} else if(qstnRspnsTycd == "SHORT_TEXT") {
				$("#"+formId+" .shortInput").each(function(i) {
					var vwitmCts = "";
					$(this).find("input[name=vwitmCts]").each(function(ii) {
						if($.trim($(this).val()) != "") {
							if(vwitmCts != "") {
								vwitmCts += "|";
							}
							vwitmCts += $(this).val();
						}
					});

					const map = {
			       	vwitmSeqno: (i + 1),
			       	cransyn: "Y",
			       	vwitmCts: vwitmCts
			    };

			    qstns.push(map);
				});

			// OX선택형
			} else if(qstnRspnsTycd == "OX_CHC") {
				if($("#"+formId).find("input[name=vwitmCts]:checked").length == 0) {
					UiComm.showMessage("<spring:message code='exam.alert.select.answer' />", "info");/* 정답을 선택하세요. */
					return false;
				}

			    for(var i = 1; i <= 2; i++) {
			    	const map = {
			    		vwitmSeqno: i,
			    		cransyn: $("#"+formId).find("input[name=vwitmCts]").eq(i-1).prop("checked") ? "Y" : "N",
			    		vwitmCts: $("#"+formId).find("input[name=vwitmCts]").eq(i-1).val()
			    	};

			    	qstns.push(map);
			    }

			// 연결형
			} else if(qstnRspnsTycd == "LINK") {
				var vwitmCnt = $("#"+formId+" select[name=vwitmCnt]").val();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					const map = {
						vwitmSeqno: i,
						cransyn: "Y",
						vwitmCts: $("#vwitmTtl_"+i).val() + "|" + $("#vwitmCts_"+i).val()
					};

					qstns.push(map);
				}
			}

			$("#"+formId).append("<input type='hidden' name='qstns' />");
			$("#"+formId+" input[name=qstns]").val(JSON.stringify(qstns));

			return true;
	    }

		// 문제은행문항설정
		function qbnkQstnSetting() {
			// 상위, 하위분류 disabled
			if(${not empty qbnkQstnVO.upQbnkCtgrId}) {
				$("#upQbnkCtgrId").val("${qbnkQstnVO.upQbnkCtgrId}").trigger("chosen:updated");
			   	$("#upQbnkCtgrId").val("${qbnkQstnVO.upQbnkCtgrId}").prop("selected", true).trigger("change");
			} else {
				$("#upQbnkCtgrId").val("${qbnkQstnVO.qbnkCtgrId}").trigger("chosen:updated");
				$("#upQbnkCtgrId").val("${qbnkQstnVO.qbnkCtgrId}").prop("selected", true).trigger("change");
			}
			$("#upQbnkCtgrId").prop("disabled", true).trigger("chosen:updated");
			$("#selectQbnkCtgrId").prop("disabled", true).trigger("chosen:updated");

		    const vwitmList = JSON.parse('${qbnkQstnVwitmList}');
		    vwitmList.forEach(function(v, i) {
				var qstnRspnsTycd = "${qbnkQstnVO.qstnRspnsTycd}";

				// 난이도
				$("#qbnkRegistForm select[name=qstnDfctlvTycd]").val("${qbnkQstnVO.qstnDfctlvTycd}").trigger("chosen:updated");
				$("#qbnkRegistForm select[name=qstnDfctlvTycd]").val("${qbnkQstnVO.qstnDfctlvTycd}").prop("selected", true).trigger("change");

				// 단일, 다중선택형
        		if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
        			$("#qbnkRegistForm select[name=vwitmCnt]").val(vwitmList.length).trigger("chosen:updated");
    				$("#qbnkRegistForm select[name=vwitmCnt]").val(vwitmList.length).prop("selected", true).trigger("change");
    				$("#vwitm_"+v.vwitmSeqno).val(v.vwitmCts);
    				$("#vwitmSeqno_"+v.vwitmSeqno).prop("checked", v.cransyn == "Y" ? true : false);

        		// OX선택형
        		} else if(qstnRspnsTycd == "OX_CHC") {
        			if(v.cransyn == "Y") {
						$("#qbnkRegistForm input[name=vwitmCts]").val(v.vwitmCts).trigger("click");
					}

        		// 연결형
        		} else if(qstnRspnsTycd == "LINK") {
        			$("#qbnkRegistForm select[name=vwitmCnt]").val(vwitmList.length).trigger("chosen:updated");
    				$("#qbnkRegistForm select[name=vwitmCnt]").val(vwitmList.length).prop("selected", true).trigger("change");
    				$("#vwitmTtl_"+v.vwitmSeqno).val(v.vwitmCts.split("|")[0]);
    				$("#vwitmCts_"+v.vwitmSeqno).val(v.vwitmCts.split("|")[1]);

        		// 단답형
        		} else if(qstnRspnsTycd == "SHORT_TEXT") {
        			if(i > 0) {
						formOption.createTextQstnAddHTML();	// 단답형 문항 추가 HTML 추가
					}
					v.vwitmCts.split("|").forEach(function(el, index) {
        				$("#qstnDiv .shortInput:nth-child("+(i+1)+")").find("input[name=vwitmCts]:eq("+index+")").val(el);
        			});
					$('input[name="fruit"][value="banana"]').prop('checked', true);
					$("#shortGubun input[name=cransTycd][value='${qbnkQstnVO.cransTycd}']").prop("checked", true);

        		}
		    });
		}

		// 문제은행문항삭제
		function qbnkQstnDelete() {
			var url  = "/qbnk/qbnkQstnDeleteAjax.do";
			var data = {
				  "qbnkQstnId" 	: "${qbnkQstnVO.qbnkQstnId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					qbnkViewMv(1)
	            } else {
	             	UiComm.showMessage(data.message, "error");
	            }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
    		}, true);
		}
	</script>
</head>

<body class="class colorA">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            	<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<div class="class_sub">
					<div class="sub-content">
						<div class="listTab">
					        <ul>
					            <li class="select mw120"><a onclick="qbnkViewMv(1)">문제은행</a></li>
					            <li class="mw120"><a onclick="qbnkViewMv(2)">분류코드 관리</a></li>
					        </ul>
					    </div>
		        		<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="exam.label.qbank" /><!-- 문제은행 -->
                            </h2>
				        </div>
				        <div class="board_top">
				        	등록
				        	<div class="right-area">
				        		<button type="button" class="btn type2" onclick="qbnkQstnRegist()">저장</button>
				        		<c:if test="${not empty qbnkQstnVO.qbnkQstnId }">
				        			<button type="hidden" class="btn type2" onclick="qbnkQstnDelete()">삭제</button>
				        		</c:if>
				        		<button type="button" class="btn type2" onclick="qbnkViewMv(1)">목록</button>
				        	</div>
				        </div>

				        <form id="qbnkRegistForm" onsubmit="return false;" novalidate>
				        	<input type="hidden" name="qbnkCtgrId" 	id="qbnkCtgrId" value="${qbnkQstnVO.qbnkCtgrId }" />
				        	<input type="hidden" name="qbnkQstnId"	id="qbnkQstnId"	value="${qbnkQstnVO.qbnkQstnId }" />
				        	<input type="hidden" name="qstnSeqno"	id="qstnSeqno"	value="${qbnkQstnVO.qstnSeqno }" />
				        	<input type="hidden" name="qstnScr"		value="0" />
				        	<table class="table-type5">
				        		<colgroup>
				        			<col class="width-20per" />
				        			<col class="" />
				        		</colgroup>
				        		<tbody>
				        			<tr>
				        				<th><label for="upQbnkCtgrId" class="req">분류</label></th>
				        				<td>
				        					<select class="form-select" name="upQbnkCtgrId" id="upQbnkCtgrId" onchange="subQbnkCtgrList(this.value)" required="true">
		                                		<option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
			                                    <c:forEach var="item" items="${upQbnkCtgrList }">
									            	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
									            </c:forEach>
			                                </select>
		                                	<select class="form-select" name="selectQbnkCtgrId" id="selectQbnkCtgrId">
		                                		<option value=""><spring:message code="exam.label.sub.categori" /></option><!-- 하위분류 -->
			                                </select>
				        				</td>
				        			</tr>
				        			<tr>
					        			<th><label class="req">과목코드/과목</label></th>
					        			<td>
					        				<input class="form-control" type="text" name="sbjctId" value="${qbnkSbjct.sbjctId }" readonly="true" autocomplete="off" required="true">
					        				<span>( ${qbnkSbjct.sbjctnm } ${qbnkSbjct.dvclasNo }반 )</span>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label class="req">대표아이디</label></th>
					        			<td><input class="form-control" type="text" name="userRprsId" value="${qbnkSbjct.userRprsId }" readonly="true" autocomplete="off" required="true"></td>
					        		</tr>
					        		<tr>
					        			<th><label>교수번호/교수명</label></th>
					        			<td>
					        				<input class="form-control" type="text" name="userId" value="${qbnkSbjct.profId }" readonly="true" autocomplete="off">
					        				<span>( ${qbnkSbjct.usernm } 교수 )</span>
					        			</td>
					        		</tr>
				        		</tbody>
				        	</table>
							<div class="margin-top-4" id="qstnRegistDiv">
								<h3>[ 문제 추가 ]</h3>
								<div class="content margin-top-3">
									<div class="flex gap-1 margin-bottom-3">
										<div class="flex-1">
											<input type="text" class="width-100per" inputmask="byte" maxLen="200" name="qstnTtl" required="true" value="${qbnkQstnVO.qstnTtl }" />
										</div>
										<select class="form-select" name="qstnRspnsTycd" onchange="qstnRspnsTycdChgChange()" required="true">
											<c:forEach var="code" items="${qstnRspnsTycdList }">
												<option value="${code.cd }" ${qbnkQstnVO.qstnRspnsTycd eq code.cd ? 'selected' : '' }>${code.cdnm }</option>
											</c:forEach>
										</select>
									</div>
									<p class="fcRed margin-bottom-3">* 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다.</p>
									<div class="editor-box">
										<textarea name="qstnCts" id="qstnEditor" required="true">${qbnkQstnVO.qstnCts }</textarea>
										<script>
											// HTML 에디터
											var editor = UiEditor({
																	targetId: "qstnEditor",
																	uploadPath: "/qbnk",
																	height: "400px"
																});
										</script>
									</div>
									<div class="margin-top-4" id="qstnTypeDiv">
										<table class="table-type2">
											<colgroup>
												<col class="width-20per" />
												<col class="" />
											</colgroup>
											<tbody></tbody>
										</table>
									</div>
								</div>
							</div>
				        </form>
					</div>
				</div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom -->
    </div>
</body>
</html>