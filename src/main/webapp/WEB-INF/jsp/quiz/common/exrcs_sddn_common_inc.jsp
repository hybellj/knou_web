<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">

	// 연습문제, 돌발퀴즈화면이동
	function exrcsSddnViewMv(exrcsSddnQstnBscId, type, qstnGbncd, sbjctId) {
		var urlMap = {
			"PROFSDDNREGIST" 	: "/quiz/profSddnQuizRegistView.do",	// 교수 돌발퀴즈 등록 화면
			"PROFSDDNMODIFY" 	: "/quiz/profSddnQuizModifyView.do",	// 교수 돌발퀴즈 수정 화면
			"PROFSDDNLIST" 		: "/quiz/profSddnQuizListView.do",		// 교수 돌발퀴즈 목록 화면
			"PROFEXRCSREGIST"	: "/quiz/profExrcsQstnRegistView.do",	// 교수 연습문제 등록 화면
			"PROFEXRCSMODIFY"	: "/quiz/profExrcsQstnModifyView.do",	// 교수 연습문제 수정 화면
			"PROFEXRCSLIST"		: "/quiz/profExrcsQstnListView.do",		// 교수 연습문제 목록 화면
			"ADMSDDNREGIST"		: "/quiz/admSddnQuizRegistView.do",		// 관리자 돌발퀴즈 등록 화면
			"ADMSDDNMODIFY"		: "/quiz/admSddnQuizModifyView.do",		// 관리자 돌발퀴즈 수정 화면
			"ADMSDDNLIST"		: "/quiz/admSddnQuizListView.do",		// 관리자 돌발퀴즈 목록 화면
			"ADMEXRCSREGIST"	: "/quiz/admExrcsQstnRegistView.do",	// 관리자 연습문제 등록 화면
			"ADMEXRCSMODIFY"	: "/quiz/admExrcsQstnModifyView.do",	// 관리자 연습문제 수정 화면
			"ADMEXRCSLIST"		: "/quiz/admExrcsQstnListView.do"		// 관리자 연습문제 목록 화면
		};

		var extData = {
			exrcsSddnQstnBscId 	: exrcsSddnQstnBscId,
			qstnGbncd			: qstnGbncd
		};

		if (type.indexOf("ADM") !== -1) extData.sbjctId = sbjctId;

		document.location.href = urlMap[type] + "?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
	}

	// 연습문제옵션
	var exrcsOption = {
		/**
		* 문제추가폼보기
		*/
		qstnAddFrmView: function() {
			if(!exrcsOption.canQstnEdit("edit")) {
				return false;
			}
			exrcsOption.qstnAddFrmInit("");	// 문제 추가 폼 초기화
			let formId  = "qstnWriteForm";
			let btnId   = "qstnAddDiv";
			let qstnCnt = $(".qstnList").length + 1;
			$("#"+formId+" input[name=exrcsSddnQstnBscId]").val("${vo.exrcsSddnQstnBscId}");
			$("#"+formId+" input[name=qstnGbncd]").val("EXRCS_QSTN");
			$("#"+formId+" input[name=qstnId]").val("");
			$("#"+formId+" input[name=qstnSeqno]").val(qstnCnt);
			$("#"+formId+" input[name=qstnCnddtSeqno]").val(1);
			$("#"+formId+" input[name=qstnTtl]").val(qstnCnt+"<spring:message code='quiz.label.qstn' />");/* 문제 */
			$("#"+btnId+" .addBtn").attr("href", "javascript:qstnRegist(\"" + btnId + "\", \"" + formId + "\")");
		},
		/**
		 * 문제 추가 폼 초기화
		 * @param {int}  qstnSeqno - 문항순번(문제수정시)
		 */
		qstnAddFrmInit: function(qstnSeqno) {
			let qstnDivId   = "qstnAddDiv"+qstnSeqno;		// 문제 추가용 최상위 div 아이디
			let qstnHeader  = qstnSeqno == "" ? "<spring:message code='quiz.button.qstn.add' />"/* 문제 추가 */ : "<spring:message code='quiz.button.qstn.edit' />";/* 문제 수정 */
			let addFormId   = "qstnWriteForm"+qstnSeqno;	// 문제 추가용 form 아이디
			let editorId    = "qstnCts"+qstnSeqno;			// 문제 내용 에디터 아이디
			let appendClass = "qstn"+qstnSeqno;				// 문제 추가 div 삽입 위치

			// 문제 추가 폼 삽입
			$("#"+qstnDivId).remove();
			let html = "";
			if(qstnSeqno == "") {
	    		html  = "<div id='" + qstnDivId + "'>";
	    		html += "	<div class='board_top'>";
	    		html += "		<h4 class='sub-title'>" + qstnHeader + "</h4>";
	    		html += "	</div>";
	    		html += "	<div class='content'></div>";
	    		html += "</div>";
	    	} else {
				html += "<div class='question_con question_con_add' id='" + qstnDivId + "'>";
				html += "	<div class='q_top'>";
				html += "		<div class='flex-item width-100per'>";
				html += "			<p class='flex-none mr15'><b class='sub-title'>" + qstnHeader + "</b></p>";
				html += "		</div>";
				html += "	</div>";
				html += "	<div class='q_cont_form content'>";
				html += "	</div>";
				html += "</div>";
	    	}
			$("."+appendClass).append(html);

			qstnOption.createQstnHeaderHTML(qstnDivId, addFormId, editorId);	// 문제 말머리 HTML 추가
			qstnOption.createQstnBtnHTML(qstnDivId, addFormId);					// 문제 버튼 HTML 추가
			editors[editorId] = UiEditor({
				targetId: editorId,
				uploadPath: "${vo.uploadPath}",
				height: "250px"
			});																	// 문항내용 html 에디터 생성
			qstnOption.qstnRspnsTycdChgChange(addFormId);						// 문항답변유형코드 변경 이벤트
		},
		/**
		 * 문제 수정 폼 존재여부
		 * @param exrcsSddnQstnBscId 	- 연습돌발문항기본아이디
		 * @param qstnId 				- 문항아이디
		 */
		isExistQstnModFrm: function(exrcsSddnQstnBscId, qstnId) {
			if(!exrcsOption.canQstnEdit("edit")) {
				return false;
			}

			let qstnSeqno = $(".question_con[data-qstnId='"+qstnId+"']").attr("data-qstnSeqno");
			if($("#qstnAddDiv"+qstnSeqno).length == 0) {
				exrcsOption.qstnModFrmView(exrcsSddnQstnBscId, qstnId);	// 문제 수정 폼 보기
			} else {
				$("#qstnAddDiv"+qstnSeqno).remove();
			}
		},
		/**
		 * 문제 수정 폼 보기
		 * @param exrcsSddnQstnBscId 	- 연습돌발문항기본아이디
		 * @param qstnId 				- 문항아이디
		 */
	    qstnModFrmView: function(exrcsSddnQstnBscId, qstnId) {
	    	let qstnSeqno    	= $(".question_con[data-qstnId='"+qstnId+"']").attr("data-qstnSeqno");			// 문항순번
	    	exrcsOption.qstnAddFrmInit(qstnSeqno);	// 문제 추가 폼 초기화

	    	let formId  = "qstnWriteForm"+qstnSeqno;
	    	let btnId   = "qstnAddDiv"+qstnSeqno;
	    	$("#"+formId+" input[name=qstnSeqno]").val(qstnSeqno);
	    	$("#"+formId+" input[name=qstnCnddtSeqno]").val(1);
	    	$("#"+formId+" input[name=qstnTtl]").val(qstnSeqno+"<spring:message code='quiz.label.qstn' />");/* 문제 */
	    	$("#"+formId+" input[name=exrcsSddnQstnBscId]").val("${vo.exrcsSddnQstnBscId}");
	    	$("#"+formId+" input[name=qstnGbncd]").val("EXRCS_QSTN");
	    	$("#"+formId+" input[name=qstnId]").val(qstnId);
	    	$("#"+btnId+" .addBtn").attr("href", "javascript:qstnModify(\"" + qstnSeqno + "\")");

	    	let editTitle = "<spring:message code='quiz.button.qstn.edit' />";/* 문제 수정 */
	    	$("#"+btnId+" .sub-title").text(editTitle);
	    	$("#"+btnId+" .se-contents").focus();

	    	// 문항 정보 조회
	    	var url  = "/quiz/qstnSelectAjax.do";
	    	if("${userCtx.admin}" == "true") url ="/quiz/admQstnSelectAjax.do";
	    	const data = {
				exrcsSddnQstnBscId	: exrcsSddnQstnBscId,
				qstnId 				: qstnId,
				qstnGbncd			: "EXRCS_QSTN"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let qstn = data.data;
	        		// 공통 값 적용
	        		$("#"+formId+" input[name=qstnTtl]").val(qstn.qstnTtl);
	        		$("#"+formId+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("chosen:updated");
	        		$("#"+formId+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("change");
	        		editors["qstnCts"+qstnSeqno].openHTML(qstn.qstnCts);
	        		// 단일, 다중선택형
	        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC") {
	        			$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("chosen:updated");
	        			$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
	        			qstn.vwitmList.forEach(function(v, i) {
	        				$("#"+formId+"Vwitm_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts);
	        				$("#"+formId+"VwitmSeqno_"+v.qstnVwitmSeqno).prop("checked", v.cransYn == "Y" ? true : false);
	        			});
	        		// OX선택형
	        		} else if(qstn.qstnRspnsTycd == "OX_CHC") {
						qstn.vwitmList.forEach(function(v, i) {
							if(v.cransYn == "Y") {
								$("#"+formId+" input[name='qstnVwitmCts'][value='"+v.qstnVwitmCts+"']").trigger("click");
							}
						});
	        		// 연결형
	        		} else if(qstn.qstnRspnsTycd == "LINK") {
	        			$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("chosen:updated");
	        			$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
	        			qstn.vwitmList.forEach(function(v, i) {
	        				$("#"+formId+"VwitmTtl_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts.split("|")[0]);
	        				$("#"+formId+"VwitmCts_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts.split("|")[1]);
	        			});
	        		// 단답형
	        		} else if(qstn.qstnRspnsTycd == "SHORT_TEXT") {
		        		$("#"+btnId+" input[name=cransTycd]:input[value='"+qstn.cransTycd+"']").trigger("click");
		        		qstn.vwitmList.forEach(function(v, i) {
							if(i > 0) {
								qstnOption.createTextQstnAddHTML(formId, "");	// 단답형 문항 추가 HTML 추가
							}
							v.qstnVwitmCts.split("|").forEach(function(el, index) {
		        				$("."+formId+"_shortTr:eq("+(i)+")").find("input[name=qstnVwitmCts]:eq("+index+")").val(el);
		        			});
	        			});
	        		}
	        		$("#"+formId+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("chosen:updated");
	        		$("#"+formId+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("change");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
			}, true);
	    },
		/**
		* 문항수정가능여부
		* @param type - (edit : 수정, submit : 제출완료)
		*/
		canQstnEdit: function(type) {
			// 출제 완료 여부
			let isSubmit = "${vo.qstnsCmptnyn}" == "Y";
			if(isSubmit && type != "submit") {
				UiComm.showMessage("<spring:message code='quiz.alert.click.edit.submit.btn' />", "info");/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
				return false;
			}

			return true;
		}
	};

	// 돌발퀴즈옵션
	var sddnOption = {
		/**
		 * 문제추가폼보기
		 */
		qstnAddFrmView: function() {
			sddnOption.qstnAddFrmInit();	// 문제 추가 폼 초기화
			let formId  = "qstnWriteForm";
			let btnId   = "qstnAddDiv";
			let qstnCnt = $(".qstnList").length + 1;
			$("#"+formId+" input[name=qstnId]").val("");
			$("#"+formId+" input[name=qstnCnddtSeqno]").val(1);
			$("#"+formId+" input[name=qstnTtl]").val("<spring:message code='quiz.label.qstn' />");/* 문제 */
		},
		/**
		 * 문제 추가 폼 초기화
		 */
		qstnAddFrmInit: function() {
			let qstnDivId   = "qstnAddDiv";		// 문제 추가용 최상위 div 아이디
			let addFormId   = "qstnWriteForm";	// 문제 추가용 form 아이디
			let editorId    = "qstnCts";		// 문제 내용 에디터 아이디
			let appendClass = "qstn";			// 문제 추가 div 삽입 위치

			// 문제 추가 폼 삽입
			$("#"+qstnDivId).remove();
			let html  = "<div class='margin-top-4 qstnFormDiv' id=\"" + qstnDivId + "\">";
				html += "	<div class='content margin-top-3'></div>";
				html += "</div>";
			$("."+appendClass).append(html);

			qstnOption.createQstnHeaderHTML(qstnDivId, addFormId, editorId);	// 문제 말머리 HTML 추가
			editors[editorId] = UiEditor({
				targetId: editorId,
				uploadPath: "${vo.uploadPath}",
				height: "250px"
			});																	// 문항내용 html 에디터 생성
			qstnOption.qstnRspnsTycdChgChange(addFormId);						// 문항답변유형코드 변경 이벤트
			qstnOption.createCransExplnHTML(addFormId);							// 정답설명 HTML 추가
			$("#"+addFormId+" input[name=exrcsSddnQstnBscId]").remove();
			$("#"+addFormId+" input[name=qstnGbncd]").remove();
			$("#"+addFormId+" input[name=qstnSeqno]").remove();
		},
		/**
		 * 문제 수정 폼 보기
		 * @param exrcsSddnQstnBscId 	- 연습돌발문항기본아이디
		 * @param qstnId 				- 문항아이디
		 */
	    qstnModFrmView: function(exrcsSddnQstnBscId, qstnId) {
	    	sddnOption.qstnAddFrmInit();	// 문제 추가 폼 초기화

	    	let formId  = "qstnWriteForm";
	    	let btnId   = "qstnAddDiv";
	    	$("#"+formId+" input[name=qstnCnddtSeqno]").val(1);
	    	$("#"+formId+" input[name=qstnId]").val(qstnId);

	    	// 문항 정보 조회
	    	var url  = "/quiz/qstnSelectAjax.do";
	    	if("${userCtx.admin}" == "true") url ="/quiz/admQstnSelectAjax.do";
	    	const data = {
				exrcsSddnQstnBscId	: exrcsSddnQstnBscId,
				qstnId 				: qstnId,
				qstnGbncd			: "SURPRISE_QUIZ"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let qstn = data.data;
	        		// 공통 값 적용
	        		$("#qstnSeqno").val(qstn.qstnSeqno);
	        		$("#"+formId+" input[name=qstnTtl]").val(qstn.qstnTtl);
	        		$("#"+formId+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("chosen:updated");
	        		$("#"+formId+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("change");
	        		qstnOption.createCransExplnHTML(formId);	// 정답설명 HTML 추가
	        		$("#"+formId+" textarea[name=cransExpln]").val(qstn.cransExpln);
	        		editors["qstnCts"].openHTML(qstn.qstnCts);
		        	$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("chosen:updated");
		        	$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
		        	qstn.vwitmList.forEach(function(v, i) {
		        		$("#"+formId+"Vwitm_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts);
		        		$("#"+formId+"VwitmSeqno_"+v.qstnVwitmSeqno).prop("checked", v.cransYn == "Y" ? true : false);
		        	});
	        		$("#"+formId+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("chosen:updated");
	        		$("#"+formId+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("change");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
			}, true);
	    }
	};

</script>