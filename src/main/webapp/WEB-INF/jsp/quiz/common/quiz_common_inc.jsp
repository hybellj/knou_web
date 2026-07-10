<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">
	var dialog;
	var EPARAM = '<c:out value="${encParams}" />';

	// dialog 닫기
	window.closeDialog = function() {
		dialog.close();
	};

	// 팝업 오류메세지 용
	function msgPop(msg) {
		closeDialog();
		UiComm.showMessage(msg, "info");
	}

	// 지정 클래스의 label로 감싸기
	function wrapLabel(text, cls) {
		return "<label class='" + cls + "'>" + text + "</label>";
	}

	// 퀴즈화면이동
	function quizViewMv(examBscId, type, examDtlId, qbnkQstnId) {
		var urlMap = {
			"QSTN" 		:	 "/quiz/profQuizQstnMngView.do",		// 퀴즈 문항 관리 화면
			"RETKEXAM" 		: "/quiz/profQuizRetkexamMngView.do",	// 퀴즈 재응시 관리 화면
			"EVL" 			: "/quiz/profQuizEvlMngView.do",		// 퀴즈 평가 관리 화면
			"REGIST" 		: "/quiz/profQuizRegistView.do", 		// 퀴즈 등록 화면
			"MODIFY" 		: "/quiz/profQuizModifyView.do", 		// 퀴즈 수정 화면
			"LIST"			: "/quiz/profQuizListView.do",			// 퀴즈 목록 화면
			"VIEW"			: "/quiz/stdntQuizInfoView.do",			// 학생 퀴즈 정보 화면
			"STDLIST"		: "/quiz/stdntQuizListView.do",			// 학생 퀴즈 목록 화면
			"QBNKLIST" 		: "/qbnk/profQbnkListView.do",			// 문제은행 목록 화면
			"QBNKREIGST"	: "/qbnk/profQbnkQstnRegistView.do",	// 문제은행 문항 등록 화면
			"QBNKMODIFY"	: "/qbnk/profQbnkQstnModifyView.do",	// 문제은행 문항 수정 화면
			"QBNKCTGR"		: "/qbnk/profQbnkCtgrMngView.do",		// 문제은행 분류코드 관리 화면
		};

		var extData = {
			examBscId 	: examBscId,
			examDtlId 	: examDtlId,
			qbnkQstnId	: qbnkQstnId
		};

		document.location.href = urlMap[type] + "?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
	}

	// 페이지 이동
	function submitForm(action, kvArr) {
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);

		for(var i = 0; i < kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
	};

	var qstnOption = {
		/**
		 * 문제 말머리 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  editorId 	- 문제 내용 에디터 아이디
		 */
		createQstnHeaderHTML: function(parentId, formId, editorId) {
			var html  = "<form id=\"" + formId + "\" onsubmit='return false;'>";
				html += "	<input type='hidden' name='examBscId' />";
				html += "	<input type='hidden' name='examDtlId' />";
				html += "	<input type='hidden' name='exrcsSddnQstnBscId' />";
				html += "	<input type='hidden' name='qstnId' />";
				html += "	<input type='hidden' name='qstnSeqno' />";
				html += "	<input type='hidden' name='qstnCnddtSeqno' />";
				html += "	<input type='hidden' name='qstnGbncd' />";
				html += "	<input type='hidden' name='qstnScr'  	value='0' />";
				html += "	<div class='table-wrap qstnTypeDiv'>";
				html += "		<table class='table-type5'>";
				html += "			<colgroup>";
				html += "				<col class='width-15per'>";
				html += "				<col class=''>";
				html += "			</colgroup>";
				html += "			<tbody>";
				html += "				<tr class='titleTr notEmptyTr'>";
				html += "					<th><spring:message code='quiz.label.qstn' /></th>";	// 문제
				html += "					<td>";
				html += "						<div class='form-row gap-2'>";
				html += "							<input type='text' class='form-control width-80per' inputmask='byte' maxLen='200' name='qstnTtl' required='true'>";
				html += "							<select class='form-select width-20per' name='qstnRspnsTycd' onchange='qstnOption.qstnRspnsTycdChgChange(\"" + formId + "\")' required='true'>";
													<c:forEach var="code" items="${qstnRspnsTycdList }">
				html += "								<option value='${code.cd }'>${code.cdnm }</option>";
													</c:forEach>
				html += "							</select>";
				html += "						</div>";
				html += "						<small class='note2'><spring:message code='quiz.label.another.title' /></small>";/* ! 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다. */
				html += "					</td>";
				html += "				</tr>";
				html += "				<tr class='notEmptyTr'>";
				html += "					<th><spring:message code='common.label.contents' /></th>";	// 내용
				html += "					<td>";
				html += "						<label class='width-100per'>";
				html += "							<textarea rows='4'";
				html += "				  					  class='form-control resize-none'";
				html += "				  					  name='qstnCts'";
				html += "				  					  id='" + editorId + "'";
				html += "				  					  required='true'>";
				html += "							</textarea>";
				html += "						</label>";
				html += "					</td>";
				html += "				</tr>";
				html += "			</tbody>";
				html += "		</table>";
				html += "	</div>";
	    		html += "</form>";
			$("#"+parentId+" .content").append(html);
			$("#"+formId+" select[name=qstnRspnsTycd]").chosen({disable_search: true});
		},
		/**
		 * 문제 버튼 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createQstnBtnHTML: function(parentId, formId) {
			var html  = "<div class='btns'>";
	    		html += "	<a href='javascript:qstnRegist(\"" + parentId + "\", \"" + formId + "\")' class='btn basic type1 addBtn'><spring:message code='common.button.save' /></a>";/* 저장 */
	    		html += "	<a href='javascript:qstnOption.qstnAddFrmRemove(\"" + parentId + "\")' class='btn basic type2'><spring:message code='common.button.cancel' /></a>";/* 취소 */
	    		html += "</div>";
	    	$("#"+parentId+" .content").append(html);
		},
		/**
		 * 보기항목 수 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드
		 */
		createVwitmCntHTML: function(formId, type) {
			var html  = "<tr class='notOption'>";
	    		html += "	<th><spring:message code='quiz.label.vwitm.cnt' /></th>";/* 보기 개수 */
	    		html += "	<td>";
	    		html += "		<select class='form-select' name='vwitmCnt' onchange='qstnOption.createVwitmCntChgHTML(\"" + formId + "\", \"" + type + "\")' required='true'>";
	    						for(var idx = 2; idx <= 10; idx++) {
	    							var selected = (type == "ONE_CHC" || type == "MLT_CHC") && idx == 2 ? "selected" : "";
	    		html += "			<option value=\"" + idx + "\" " + selected + ">" + idx + "<spring:message code='message.cnt' /></option>";/* 개 */
	    						}
	    		html += "		</select>";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	$("#"+formId+" .qstnTypeDiv select[name=vwitmCnt]").chosen({disable_search: true});
		},
		/**
		 * 단일, 다중선택형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		createChgQstnHTML: function(formId) {
			var html  = "<tr>";
	    		html += "	<th><spring:message code='quiz.label.vwitm.input' /></th>";/* 보기 입력 */
	    		html += "	<td class='qstnItemTd'></td>";
	    		html += "</tr>";
	    		html += "<tr class='notOption'>";
	    		html += "	<th><spring:message code='quiz.label.all.crans' /></th>";/* 전체 정답처리 */
	    		html += "	<td>";
	    		html += "		<div class='form-row'>";
		    	html += "			<input type='checkbox' value='Y' name='wholCrans' class='switch yesno'>";
	    		html += "		</div>";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	UiSwitcher();
		},
		/**
		 * 단답형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createTextQstnHTML: function(formId) {
			var html  = "<tr class='"+formId+"_shortTr'>";
	    		html += "	<th id='"+formId+"_shortTh'><spring:message code='quiz.label.crans.input' /></th>";/* 정답 입력 */
	    		html += "	<td>";
	    		html += "		<div class='ansInputAddList'>";
	    		html += "			<span><spring:message code='quiz.label.crans' /> 1</span>";/* 정답 */
	    		html += "			<div class='ans-input-wrap'>";
	    		for(var i = 0; i < 5; i++) {
	    		html += "				<label for='"+formId+"_short_1_"+i+"'><input type='text' name='qstnVwitmCts' id='"+formId+"_short_1_"+i+"' " + (i == 0 ? "required='true'" : "") + "></label>";
	    		}
	    		html += "			</div>";
	    		html += "			<div class='addBtn'>";
	    		html += "				<button type='button' class='btn type2 notOption' onclick='qstnOption.createTextQstnAddHTML(\""+formId+"\", this)'><i class='xi-plus'></i></button>";
	    		html += "			</div>";
	    		html += "		</div>";
	    		html += "	</td>";
	    		html += "</tr>";
	    		html += "<tr id='"+formId+"ShortGubun'>";
	    		html += "	<th><spring:message code='quiz.label.crans.type' /></th>";/* 정답 유형 */
	    		html += "	<td>";
	    		html += "		<span class='custom-input'>";
	    		html += "			<input type='radio' name='cransTycd' id='"+formId+"cransI' value='CRANS_INORDER' checked='checked'>";
	    		html += "			<label for='"+formId+"cransI'><spring:message code='quiz.label.crans.order' /></label>";/* 순서에 맞게 정답 */
	    		html += "		</span>";
	    		html += "		<span class='custom-input'>";
	    		html += "			<input type='radio' name='cransTycd' id='"+formId+"cransN' value='CRANS_NOT_INORDER'>";
	    		html += "			<label for='"+formId+"cransN'><spring:message code='quiz.label.crans.not.order' /></label>";/* 순서에 상관없이 정답 */
	    		html += "		</span>";
	    		html += "	</td>";
	    		html += "</tr>";
			$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		},
		/**
		 * OX선택형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createOxQstnHTML: function(formId) {
			var html  = "<tr>";
	    		html += "	<th><spring:message code='quiz.label.crans.input' /></th>";/* 정답 입력 */
	    		html += "	<td>";
	    		html += "		<div class='ox_quiz justify-content-left'>";
				for(var idx = 1; idx <= 2; idx++) {
					var oxClass = idx == 1 ? "true" : "false";
					var iconClass = idx == 1 ? "xi-radiobox-blank" : "xi-close";
					html += "		<div class='ox_item'>";
					html += "			<input type='radio' class='ox_input' name='qstnVwitmCts' id='"+formId+"_"+oxClass+"' value='" + (idx == 1 ? "O" : "X") + "' />";
					html += "			<label for='"+formId+"_"+oxClass+"' class='btn basic'>";
					html += "				<i class='" + iconClass + " icon'></i>";
					html += "			</label>";
					html += "		</div>";
				}
	    		html += "		</div>";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		},
		/**
		 * 연결형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createLinkQstnHTML: function(formId) {
			var html  = "<tr>";
	    		html += "	<th><spring:message code='quiz.label.crans.input' /></th>";/* 정답 입력 */
	    		html += "	<td class='q_cont_ans matching_form'>";
	    		html += "		<ol class='matching_list'></ol>";
	    		html += "	</td>";
	    		html += "</tr>";
			$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		},
		/**
		 * 단답형 문항 추가 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  obj 		- 문항 추가 클릭 버튼 객체
		 */
		 createTextQstnAddHTML: function(formId, obj) {
			var shortCnt = $("."+formId+"_shortTr").length;
			if(shortCnt == 5) {
				return false;
			}

			var html  = "<tr class='"+formId+"_shortTr'>";
				html += "	<td>";
				html += "		<div class='ansInputAddList'>";
				html += "			<span><spring:message code='quiz.label.crans' /> "+(shortCnt+1)+"</span>";/* 정답 */
				html += "			<div class='ans-input-wrap'>";
				for(var i = 0; i < 5; i++) {
					html += "				<label for='"+formId+"_short_"+(shortCnt+1)+"_"+i+"'>";
					html += "					<input type='text' name='qstnVwitmCts' id='"+formId+"_short_1_"+i+"' " + (i == 0 ? "required='true'" : "") + ">";
					html += "				</label>";
		    	}
				html += "			</div>";
				html += "			<div class='addBtn'>";
				html += "				<button type='button' class='btn type2 notOption' onclick='qstnOption.textQstnDelHTML(\""+formId+"\", this)'><i class='xi-minus'></i></button>";
				html += "				<button type='button' class='btn type2 notOption' onclick='qstnOption.createTextQstnAddHTML(\""+formId+"\", this)'><i class='xi-plus'></i></button>";
				html += "			</div>";
				html += "		</div>";
				html += "	</td>";
				html += "</tr>";

			$("#"+formId+"_shortTh")[0].rowSpan = shortCnt + 1;
			if(obj == "") {
				$("."+formId+"_shortTr").last().after(html);
			} else {
				obj.closest('tr').insertAdjacentHTML('afterend', html);
			}
			qstnOption.textQstnSpanChg(formId);
		},
		/**
		 * 단답형 문항 HTML 삭제
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {Integer} obj 		- 문항 삭제 클릭 버튼 객체
		 */
	    textQstnDelHTML: function(formId, obj) {
	    	var shortCnt = $("."+formId+"_shortTr").length;
	    	$("#"+formId+"_shortTh")[0].rowSpan = shortCnt - 1;
	    	obj.closest('tr').remove();
	    	qstnOption.textQstnSpanChg(formId);
	    },
	    /**
		 * 단답형 문항 span 텍스트 변경
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
	    textQstnSpanChg(formId) {
			$("."+formId+"_shortTr").each(function(i, v) {
				v.querySelector('.ansInputAddList span').textContent = "<spring:message code='quiz.label.crans' /> " + (i+1);/* 정답 */
			});
	    },
	    /**
		 * 문항 난이도 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
	    createQstnDfctlvHTML: function(formId) {
	    	var html  = "<tr class='notOption'>";
	    		html += "	<th><spring:message code='quiz.label.dfctlv' /></th>";/* 난이도 */
	    		html += "	<td>";
	    		html += "		<select class='form-select' id='"+formId+"QstnDfctlvTycd' name='qstnDfctlvTycd' required='true'>";
	    						<c:forEach var="code" items="${qstnDfctlvTycdList }">
	    		html += "			<option value='${code.cd }'>${code.cdnm }</option>";
	    						</c:forEach>
	    		html += "		</select>";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	$("#"+formId+"QstnDfctlvTycd").chosen({disable_search: true});
	    },
	    /**
		 * 정답설명 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
	    createCransExplnHTML: function(formId) {
			var html  = "<tr>";
				html += "	<th><spring:message code='quiz.label.crans.explan' /></th>";/* 정답설명 */
				html += "	<td><textarea name='cransExpln' style='width:100%;height:70px;' maxLenCheck='byte,4000,true,true'></textarea></td>";
				html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    },
	    /**
		 * 문항답변유형코드 변경
		 * @param {String} formId 	- 문제 추가용 form 아이디
		 */
	    qstnRspnsTycdChgChange: function(formId) {
	    	$("#"+formId+" .qstnTypeDiv > table > tbody > tr").not(".notEmptyTr").empty();	// 문항보기항목 비우기

	        var type = $("#"+formId+" select[name=qstnRspnsTycd]").val();					// 문항답변유형코드
	        // 단일선택형, 다중선택형
	        if(type == "ONE_CHC" || type == "MLT_CHC") {
	        	qstnOption.createVwitmCntHTML(formId, type);								// 보기항목 수 HTML 추가
	        	qstnOption.createChgQstnHTML(formId);										// 단일, 다중선택형 문항 HTML 추가
	        	qstnOption.createVwitmCntChgHTML(formId, type);								// 보기항목 수 변경 HTML 추가

	        // 단답형
	        } else if(type == "SHORT_TEXT") {
	        	qstnOption.createTextQstnHTML(formId);										// 단답형 문항 HTML 추가

	        // OX선택형
	        } else if(type == "OX_CHC") {
	        	qstnOption.createOxQstnHTML(formId);										// OX선택형 문항 HTML 추가

	        // 연결형
	        } else if(type == "LINK") {
	        	qstnOption.createVwitmCntHTML(formId, type);								// 보기항목 수 HTML 추가
	        	qstnOption.createLinkQstnHTML(formId);										// 연결형 문항 HTML 추가
	        	qstnOption.createVwitmCntChgHTML(formId, type);								// 보기항목 수 변경 HTML 추가
	        }

	        qstnOption.createQstnDfctlvHTML(formId);										// 문항 난이도 HTML 추가
	    },
	    /**
		 * 보기항목 수 변경 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드 ( ONE_CHC : 단일선택형, MLT_CHC : 다중선택형, LINK : 연결형 )
		 */
	    createVwitmCntChgHTML: function(formId, type) {
		    var vwitmCnt   = $("#"+formId+" .qstnTypeDiv select[name=vwitmCnt]").val();	// 보기 항목 개수 selectBox
	    	// 단일, 다중선택형
	    	if(type == "ONE_CHC" || type == "MLT_CHC") {
		    	var vwitmLiCnt = $("#"+formId+" .qstnItemTd .checkbox_type").length;	// 기존 보기항목 수

		    	if(vwitmLiCnt < vwitmCnt) {
			    	for(var i = vwitmLiCnt; i < vwitmCnt; i++) {
						const inputType = type == "MLT_CHC" ? "checkbox" : "radio";
						var html  = "<div class='checkbox_type mb5'>";
							html += "	<span class='custom-input'>";
					   		html += "		<input type='" + inputType +"' name='qstnVwitmSeqno' id='"+formId+"VwitmSeqno_"+(i+1)+"' value='"+(i+1)+"' >";
					   		html += "		<label for='"+formId+"VwitmSeqno_"+(i+1)+"'><spring:message code='quiz.label.vwitm' /> "+(i+1)+"</label>";/* 보기 */
							html += "	</span>";
							html += "	<label for='"+formId+"Vwitm_"+(i+1)+"'><input type='text' class='width-100per' name='qstnVwitmCts' id='"+formId+"Vwitm_"+(i+1)+"' required='true' /></label>";
							html += "</div>";
				    	$("#"+formId+" .qstnItemTd").append(html);
			    	}
		    	} else if(vwitmLiCnt > vwitmCnt) {
			    	for(var i = vwitmLiCnt; i > vwitmCnt-1; i--) {
			    	 	$("#"+formId+" .qstnItemTd .checkbox_type:eq("+i+")").remove();
			    	}
		    	}

		    // 연결형
	    	} else if(type == "LINK") {
	    		var vwitmDivCnt = $("#"+formId+" .matching_list .matching_item").length;

	    		if(vwitmDivCnt < vwitmCnt) {
	    			const alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	    			for(var i = vwitmDivCnt; i < vwitmCnt; i++) {
	    				var html  = "<li class='matching_item'>";
	    					html += "	<div class='q_box'>";
	    					html += "		<label for='"+formId+"VwitmTtl_"+(i+1)+"'>";
	    					html += "			<span class='index'>" + alphabets[i] + "</span>";
	    					html += "			<input type='text' name='qstnVwitmTtl' id='"+formId+"VwitmTtl_"+(i+1)+"' placeholder='" + "<spring:message code='quiz.label.vwitm.input' />" + "' required='true' />";/* 보기 입력 */
	    					html += "		</label>";
	    					html += "	</div>";
	    					html += "	<div class='a_box'>";
	    					html += "		<label>";
	    					html += "			<input type='text' name='qstnVwitmCts' id='"+formId+"VwitmCts_"+(i+1)+"' placeholder='" + "<spring:message code='quiz.label.crans.input' />" + "' required='true' />";/* 정답 입력 */
	    					html += "		</label>";
	    					html += "	</div>";
	    					html += "</li>";
		    			$("#"+formId+" .matching_list").append(html);
	    			}
	    		} else if(vwitmDivCnt > vwitmCnt) {
	    			for(var i = vwitmDivCnt; i > vwitmCnt-1; i--) {
	    				$("#"+formId+" .matching_list .matching_item:eq("+i+")").remove();
	    			}
	    		}
	    	}
	    },
	    /**
		* 문항 추가 폼 제거
		* @param {String}  id - 제거할 문항 폼 아이디
		*/
	 	qstnAddFrmRemove: function(id) {
	 		$("#"+id).remove();
	 	},
	 	/**
		* 문항 유효성 검사
		* @param {String}  qstnSeqno - 문항순번
		*/
		isValidQstn: function(qstnSeqno) {
	    	var formId = "qstnWriteForm"+qstnSeqno;

			var qstnRspnsTycd = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
			$("#"+formId).find("input[type=hidden][name=cransTycd]").remove();
			$("#"+formId).find("input[name=qstns]").remove();

			const qstns = [];	// 문항 등록용

			// 단일, 다중선택형
			if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
				var isWholCrans = $("#"+formId).find("input[name=wholCrans]").prop("checked");	// 전체 정답처리 체크 여부
				if(!isWholCrans && $("#"+formId).find("input[name=qstnVwitmSeqno]:checked").length == 0) {
					UiComm.showMessage("<spring:message code='quiz.alert.select.crans' />", "info");/* 정답을 선택하세요. */
					return false;
				}

				// 다중정답 처리
				if($("#"+formId).find("input[name=qstnVwitmSeqno]:checked").length > 1 || isWholCrans) {
					$("#"+formId).append("<input type='hidden' name='cransTycd' value='CRANS_MLT' />");
				}

				var vwitmCnt = $("#"+formId+" select[name=vwitmCnt]").val();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					const map = {
						qstnVwitmSeqno: i,
						cransYn: $("#"+formId+"VwitmSeqno_"+i).prop("checked") || $("#"+formId).find("input[name=wholCrans]").prop("checked") ? "Y" : "N",
						qstnVwitmCts: $("#"+formId+"Vwitm_"+i).val()
					};

					qstns.push(map);
				}

			// 단답형
			} else if(qstnRspnsTycd == "SHORT_TEXT") {
				$("."+formId+"_shortTr").each(function(i) {
					var qstnVwitmCts = "";
					$(this).find("input[name=qstnVwitmCts]").each(function(ii) {
						if($.trim($(this).val()) != "") {
							if(qstnVwitmCts != "") {
								qstnVwitmCts += "|";
							}
							qstnVwitmCts += $(this).val();
						}
					});

					const map = {
				       	qstnVwitmSeqno: (i + 1),
				       	cransYn: "Y",
				       	qstnVwitmCts: qstnVwitmCts
				    };

			    	qstns.push(map);
				});

			// OX선택형
			} else if(qstnRspnsTycd == "OX_CHC") {
				if($("#"+formId).find("input[name=qstnVwitmCts]:checked").length == 0) {
					UiComm.showMessage("<spring:message code='quiz.alert.select.crans' />", "info");/* 정답을 선택하세요. */
					return false;
				}

			    for(var i = 1; i <= 2; i++) {
			    	const map = {
			    		qstnVwitmSeqno: i,
			    		cransYn: $("#"+formId).find("input[name=qstnVwitmCts]").eq(i-1).prop("checked") ? "Y" : "N",
			    		qstnVwitmCts: $("#"+formId).find("input[name=qstnVwitmCts]").eq(i-1).val()
			    	};

			    	qstns.push(map);
			    }

			// 연결형
			} else if(qstnRspnsTycd == "LINK") {
				var vwitmCnt = $("#"+formId+" select[name=vwitmCnt]").val();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					const map = {
						qstnVwitmSeqno: i,
						cransYn: "Y",
						qstnVwitmCts: $("#"+formId+"VwitmTtl_"+i).val() + "|" + $("#"+formId+"VwitmCts_"+i).val()
					};

					qstns.push(map);
				}
			}

			$("#"+formId).append("<input type='hidden' name='qstns' />");
			$("#"+formId+" input[name=qstns]").val(JSON.stringify(qstns));

			return true;
	    }
	};

	var previewOption = {
		/**
		 * 문항 미리보기 HTML 추가
		 * @param {obj}  item	- 문항 정보
		 */
		createQstnPreviewHTML: function(item) {
			var html  = "<div class='q_cont'>";
				if(item.qstnCts.trimStart().startsWith('<div class="se-contents"')) {
					html += "<pre>" + item.qstnCts + "</pre>";
				} else {
					html += "<p>" + item.qstnCts + "</p>";
				}
				// 단일, 다중선택형
				if(item.qstnRspnsTycd == "ONE_CHC" || item.qstnRspnsTycd == "MLT_CHC") {
					html += "<ol class='q_cont_ans' id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></ol>";
				// 서술형
				} else if(item.qstnRspnsTycd == "LONG_TEXT") {
					html += "<div class='q_cont_ans'><textarea style='width:100%;height:70px;' maxLenCheck='byte,4000,true,true'></textarea></div>";
				// 연결형
				} else if(item.qstnRspnsTycd == "LINK") {
					html += "<div class='q_cont_ans matching_form'>";
					html += "	<ol class='matching_list' id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></ol>";
					html += "</div>";
				// OX선택형
				} else if(item.qstnRspnsTycd == "OX_CHC") {
					html += "<div class='q_cont_ans ox_quiz justify-content-center' id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
				// 단답형
				} else if(item.qstnRspnsTycd == "SHORT_TEXT") {
					html += "<div class='q_cont_ans shortAnswerList' id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
				}
				html += "</div>";
				previewOption.createQstnVwitmPreviewHTML(item);	// 문항보기항목 미리보기 HTML 추가

			return html;
		},
		/**
		 * 문항보기항목 미리보기 HTML 추가
		 * @param {obj}  qstnVO	- 문항 정보
		 */
		createQstnVwitmPreviewHTML: function(qstnVO) {
			var url  = "/quiz/quizQstnVwitmListAjax.do";
			if("${userCtx.admin}" == "true") url = "/quiz/admQuizQstnVwitmListAjax.do";
			var data = {
				"qstnId" : qstnVO.qstnId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
		    		var qstnVwitmList = data.returnList || [];

					if(qstnVwitmList.length > 0) {
						var html = "";			// 공통 html
						var linkVwHtml = "";	// 연결형 보기항목 html
						var linkCransHtml = "";	// 연결형 정답항목 html
		    			qstnVwitmList.forEach(function(v, i) {
							// 단일, 다중선택형
		    				if(qstnVO.qstnRspnsTycd == "ONE_CHC" || qstnVO.qstnRspnsTycd == "MLT_CHC") {
								html += "<li>";
								html += "	<input type='" + (qstnVO.qstnRspnsTycd == "MLT_CHC" ? "checkbox" : "radio") + "' name='preview_" + v.qstnId + "' id='" + v.qstnVwitmId + "_" + (i+1) + "' " + (v.cransYn == "Y" ? "checked" : "") + " />";
							    html += "	<label for='" + v.qstnVwitmId + "_" + (i+1) + "'><span class='ansNum'>" + (i+1) + "</span>" + v.qstnVwitmCts + "</label>";
								html += "</li>";
							// OX선택형
		    				} else if(qstnVO.qstnRspnsTycd == "OX_CHC") {
		    					html += "<div class='ox_item'>";
		    					html += "	<input type='radio' class='ox_input' name='preview_" + v.qstnId + "' id='" + v.qstnVwitmId + "_" + (i+1) + "' " + (v.cransYn == "Y" ? "checked" : "") + " />";
		    					html += "	<label for='" + v.qstnVwitmId + "_" + (i+1) + "' class='btn basic'>";
		    					if(v.qstnVwitmCts == "O") {
			    					html += "	<i class='xi-radiobox-blank icon'></i>";
		    					} else {
			    					html += "	<i class='xi-close icon'></i>";
		    					}
		    					html += "	</label>";
		    					html += "</div>";
							// 단답형
		    				} else if(qstnVO.qstnRspnsTycd == "SHORT_TEXT") {
								html += "<label for='" + v.qstnVwitmId + "_" + (i+1) + "'><input type='text' id='" + v.qstnVwitmId + "_" + (i+1) + "' value='" + v.qstnVwitmCts + "' class='form-control'></label>";
		    				// 연결형
		    				} else if(qstnVO.qstnRspnsTycd == "LINK") {
		    					const alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		    					html += "<li class='matching_item'>";
		    					html += "	<div class='q_box'>";
		    					html += "		<label>";
		    					html += "			<span class='index'>" + alphabets[i] + "</span>";
		    					html += "			<input type='text' readonly='true' value='" + v.qstnVwitmCts.split("|")[0] + "' />";
		    					html += "		</label>";
		    					html += "	</div>";
		    					html += "	<div class='a_box'>";
		    					html += "		<label>";
		    					html += "			<input type='text' value='" + v.qstnVwitmCts.split("|")[1] + "' />";
		    					html += "		</label>";
		    					html += "	</div>";
		    					html += "</li>";
		    				}
						});
		    			$("#vwitm_"+qstnVO.qstnId+"_"+qstnVO.qstnCnddtSeqno).html(html);
		    		}
				}
			}, true);
		}
	}

	var selectOption = {
		// 학기기수목록
		smstrChrt: function(smstrChrtId) {
			return new Promise((resolve, reject) => {
		        let url  = "/quiz/admSmstrChrtListAjax.do";
		        const data = {
		            orgId  : $("#orgId").val(),
		            dgrsYr : $("#dgrsYr").val()
		        };

		        ajaxCall(url, data, function(data) {
		            if (data.result > 0) {
		                let returnList = data.returnList || [];
		                let html = "<option value=''><spring:message code='quiz.label.select.smstr' /></option>";/* 학기기수 선택 */

		                if(returnList.length > 0) {
		                    returnList.forEach(function(v, i) {
		                        html += "<option value='" + v.smstrChrtId + "'>" + v.smstrChrtnm + "</option>";
		                    });
		                }

		                $("#smstrChrtId").empty().append(html);
		                $("#smstrChrtId").val(smstrChrtId).trigger("chosen:updated");
		                resolve();
		            } else {
		                UiComm.showMessage(data.message, "error");
		                reject(data.message);
		            }
		        }, function(xhr, status, error) {
		            UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		            reject(error);
		        }, true);
		    });
		},
		// 과목목록
		sbjct: function(sbjctId) {
			return new Promise((resolve, reject) => {
		        let url  = "/quiz/admSbjctListAjax.do";
		        const data = {
			        orgId 		: $("#orgId").val(),
					sbjctYr		: $("#dgrsYr").val(),
					smstrChrtId : $("#smstrChrtId").val()
		        };

		        ajaxCall(url, data, function(data) {
		            if (data.result > 0) {
		            	let returnList = data.returnList || [];
		        		let html = "<option value=''><spring:message code='common.subject.select' /></option>";/* 과목 선택 */

		        		if(returnList.length > 0) {
		        			returnList.forEach(function(v, i) {
								html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + "</option>";
		        			});
		        		}

		        		$("#sbjctId").empty().append(html);
		        		$("#sbjctId").val(sbjctId).trigger("chosen:updated");
		                resolve();
		            } else {
		                UiComm.showMessage(data.message, "error");
		                reject(data.message);
		            }
		        }, function(xhr, status, error) {
		            UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		            reject(error);
		        }, true);
		    });
		}
	}
</script>

<style>
	.question_area .question_con .q_cont .q_cont_ans input[type="checkbox"]:checked + label .ansNum {
	    background-color: var(--btn-active);
	    color:var(--bc-white)
	}

	.ox_item .ox_input:checked + label .xi-radiobox-blank.icon {
	    color: #00A4D8;
	}
	.ox_item .ox_input:checked + label .xi-close.icon {
	    color: var(--red-400, #ff5252);
	}
</style>