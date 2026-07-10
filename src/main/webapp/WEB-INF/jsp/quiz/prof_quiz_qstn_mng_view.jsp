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
		var SCORE_EDIT_MODE = false;
		var editorMap = {};

		$(document).ready(function() {
			if("${vo.examGbncd}" == "QUIZ_TEAM") {
				document.querySelector('li[name="teamButton"][value="' + "${vo.examDtlVO.examDtlId}" + '"] a').click();
			} else {
				qstnListSelect();
			}
		});

	    /**
		 * 문제 추가 폼 초기화
		 * @param qstnSeqno	- 문항순번
		 */
	    function qstnAddFrmInit(qstnSeqno) {
	    	let qstnDivId   = "qstnAddDiv"+qstnSeqno;		// 문제 추가용 최상위 div 아이디
	    	let qstnHeader  = qstnSeqno == "" ? "<spring:message code='quiz.button.qstn.add' />"/* 문제 추가 */ : "<spring:message code='quiz.button.qstn.sub.add' />";/* 후보 문제 추가 */
	    	let addFormId   = "qstnWriteForm"+qstnSeqno;	// 문제 추가용 form 아이디
	    	let editorKey   = "editor"+qstnSeqno;			// 문제 내용 에디터 저장 키 값
	    	let editorId    = "qstnCts"+qstnSeqno;			// 문제 내용 에디터 아이디
	    	let appendClass = "qstn"+qstnSeqno;				// 문제 추가 div 삽입 위치

	    	// 문제 추가 폼 삽입
	    	$("#"+qstnDivId).remove();
	    	var html = "";
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
			editorMap[editorKey] = UiEditor({
										targetId: editorId,
										uploadPath: "${vo.uploadPath}",
										height: "250px"
									});											// 문항내용 html 에디터 생성
			qstnOption.qstnRspnsTycdChgChange(addFormId);						// 문항답변유형코드 변경 이벤트
	    }

		/**
		 * 문제 추가 폼 보기
		 * @param qstnSeqno - 문항순번 ( 후보문항 추가시 )
		 */
	    function qstnAddFrmView(qstnSeqno) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}
	    	qstnAddFrmInit(qstnSeqno);	// 문제 추가 폼 초기화
	    	let formId  = "qstnWriteForm"+qstnSeqno;
	    	let btnId   = "qstnAddDiv"+qstnSeqno;
	    	let qstnCnt = qstnSeqno != "" ? qstnSeqno : $(".quizQstnList").length + 1;
	    	let qstnCnddtSeqno = qstnSeqno != "" ? $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("div.question_con:not(.question_con_add)").length + 1 : 1;
	    	let score   = qstnSeqno != "" ? $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").attr("data-qstnscr") : 0;
	    	$("#"+formId+" input[name=examBscId]").val("${vo.examBscId}");
	    	$("#"+formId+" input[name=examDtlId]").val($("#examDtlId").val());
	    	$("#"+formId+" input[name=qstnGbncd]").val("GENERAL");
	    	$("#"+formId+" input[name=qstnId]").val("");
	    	$("#"+formId+" input[name=qstnSeqno]").val(qstnCnt);
	    	$("#"+formId+" input[name=qstnCnddtSeqno]").val(qstnCnddtSeqno);
	    	$("#"+formId+" input[name=qstnTtl]").val(qstnCnt+"-"+qstnCnddtSeqno+" <spring:message code='quiz.label.qstn' />");/* 문제 */
	    	$("#"+formId+" input[name=qstnScr]").val(score);
	    	$("#"+btnId+" .addBtn").attr("href", "javascript:qstnRegist(\"" + btnId + "\", \"" + formId + "\", \"" + (qstnSeqno || "") + "\")");
	    }

	    /**
		 * 문제 수정 폼 존재여부
		 * @param examDtlId - 시험상세아이디
		 * @param qstnId 	- 문항아이디
		 */
	    function isExistQstnModFrm(examDtlId, qstnId) {
	    	if(!canQuizEdit("all")) {
	    		return false;
	    	}

	    	let qstnSeqno = $(".question_con[data-qstnId='"+qstnId+"']").attr("data-qstnSeqno");
	    	if($("#qstnAddDiv"+qstnSeqno).length == 0) {
	    		qstnModFrmView(examDtlId, qstnId);	// 문제 수정 폼 보기
	    	} else {
	    		$("#qstnAddDiv"+qstnSeqno).remove();
	    	}
	    }

	    /**
		 * 문제 수정 폼 보기
		 * @param {String} examDtlId 	- 시험상세아이디
		 * @param {String} qstnId 		- 문항아이디
		 */
	    function qstnModFrmView(examDtlId, qstnId) {
	    	let qstnSeqno    	= $(".question_con[data-qstnId='"+qstnId+"']").attr("data-qstnSeqno");			// 문항순번
	    	let qstnCnddtSeqno  = $(".question_con[data-qstnId='"+qstnId+"']").attr("data-qstnCnddtSeqno");		// 문항후보순번
	    	let qstnScr 		= $(".quizQstnList[data-qstnSeqno='"+qstnSeqno+"']").attr("data-qstnscr");		// 문항기본점수
	    	qstnAddFrmInit(qstnSeqno);	// 문제 추가 폼 초기화

	    	let formId  = "qstnWriteForm"+qstnSeqno;
	    	let btnId   = "qstnAddDiv"+qstnSeqno;
	    	if("${vo.tkexamStrtUserCnt}" > 0) {
				$("#"+formId+" .titleTr").addClass("cpn");
	    	}
	    	$("#"+formId+" input[name=qstnSeqno]").val(qstnSeqno);
	    	$("#"+formId+" input[name=qstnCnddtSeqno]").val(qstnCnddtSeqno);
	    	$("#"+formId+" input[name=qstnScr]").val(qstnScr);
	    	$("#"+formId+" input[name=qstnTtl]").val(qstnSeqno+"-"+qstnCnddtSeqno+" <spring:message code='exam.label.qstn' />");/* 문제 */
	    	$("#"+formId+" input[name=examBscId]").val("${vo.examBscId}");
	    	$("#"+formId+" input[name=examDtlId]").val(examDtlId);
	    	$("#"+formId+" input[name=qstnGbncd]").val("GENERAL");
	    	$("#"+formId+" input[name=qstnId]").val(qstnId);
	    	$("#"+btnId+" .addBtn").attr("href", "javascript:qstnModify(\"" + qstnSeqno + "\")");

	    	let editTitle = "<spring:message code='quiz.button.qstn.edit' />";		/* 문제 수정 */
	    	if(qstnCnddtSeqno > 1) {
	    		editTitle = "<spring:message code='quiz.button.qstn.sub.edit' />";	/* 후보 문제 수정 */
	    	}
	    	$("#"+btnId+" .sub-title").text(editTitle);
	    	$("#"+btnId+" .se-contents").focus();

	    	// 문항 정보 조회
	    	const url  = "/quiz/qstnSelectAjax.do";
	    	const data = {
				examDtlId	: examDtlId,
				qstnId 		: qstnId,
				qstnGbncd	: "GENERAL"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let qstn = data.data;
	        		// 공통 값 적용
	        		$("#"+formId+" input[name=qstnTtl]").val(qstn.qstnTtl);																	// 문항제목
	        		$("#"+formId+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("change").trigger("chosen:updated");		// 문항답변유형코드
	        		editorMap["editor"+qstnSeqno].openHTML(qstn.qstnCts);																	// 문항내용
	        		$("#"+formId+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("change").trigger("chosen:updated");					// 난이도

	        		// 단일, 다중선택형
	        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC") {
	        			$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change").trigger("chosen:updated");		// 보기개수
	        			qstn.vwitmList.forEach(function(v, i) {
	        				$("#"+formId+"Vwitm_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts);													// 보기내용
	        				if(v.cransYn == "Y") $("#"+formId+"VwitmSeqno_"+v.qstnVwitmSeqno).click();										// 정답선택
	        			});

	        		// OX선택형
	        		} else if(qstn.qstnRspnsTycd == "OX_CHC") {
						qstn.vwitmList.forEach(function(v, i) {
							if(v.cransYn == "Y") $("#"+formId+" input[name='qstnVwitmCts'][value='"+v.qstnVwitmCts+"']").trigger("click");	// 정답선택
						});

	        		// 연결형
	        		} else if(qstn.qstnRspnsTycd == "LINK") {
	        			$("#"+btnId+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change").trigger("chosen:updated");		// 보기개수
	        			qstn.vwitmList.forEach(function(v, i) {
	        				$("#"+formId+"VwitmTtl_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts.split("|")[0]);									// 보기내용
	        				$("#"+formId+"VwitmCts_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts.split("|")[1]);									// 정답내용
	        			});

	        		// 단답형
	        		} else if(qstn.qstnRspnsTycd == "SHORT_TEXT") {
		        		$("#"+btnId+" input[name=cransTycd]:input[value='"+qstn.cransTycd+"']").click();									// 정답유형
		        		qstn.vwitmList.forEach(function(v, i) {
							if(i > 0) {
								qstnOption.createTextQstnAddHTML(formId, "");	// 단답형 문항 추가 HTML 추가
							}
							v.qstnVwitmCts.split("|").forEach(function(el, index) {
		        				$("."+formId+"_shortTr:eq("+(i)+")").find("input[name=qstnVwitmCts]:eq("+index+")").val(el);				// 정답내용
		        			});
	        			});
	        		}
	        		if($("#examQstnsCmptnyn").val() == "M" && ("${today}" > "${vo.examDtlVO.examPsblSdttm}" || "${vo.tkexamStrtUserCnt}" > 0)) {
	        			$("#"+formId+" .notOption").addClass("cpn");
	        		}
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
			}, true);
	    }

		/**
		 * 문항 목록 조회
		 */
		 function qstnListSelect() {
			// 출제상태별 표시여부 변경
			const items = document.querySelectorAll('.examQstnsCmptnClass');
			items.forEach(item => item.classList.toggle("hide", $("#examQstnsCmptnyn").val() != "N"));

		 	const url  = "/quiz/quizQstnListAjax.do";
		 	const data = {
				examDtlId	: $("#examDtlId").val(),
				qstnGbncd	: "GENERAL"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
		     		let qstnList 		= data.returnList || [];
		     		let isExamSubmit 	= $("#examQstnsCmptnyn").val() == "M" || $("#examQstnsCmptnyn").val() == "Y";	// 문제출제완료여부
		     		let linkQstnList 	= [];
		     		let totalScore 		= 0;
		     		$("#qstnCnt").text(qstnList.length > 0 ? qstnList[0].qstnCnt : 0);
		     		$("#qstnTotalScore").text(totalScore);

		     		if(qstnList.length > 0) {
		     			let html 	   	= "";
		     			let qstnScr 	= 0;
		     			let examDtlId  	= "";

		     			for(var i = 1; i <= qstnList[0].qstnCnt; i++) {
		        			qstnList.forEach(function(v, ii) {
		        				if(i == v.qstnSeqno && 1 == v.qstnCnddtSeqno) {
		        					totalScore += v.qstnScr;
		        					qstnScr 	= v.qstnScr;
		        					examDtlId 	= v.examDtlId;
		        				}
		        			});
		        			html += "<div class='course_history quizQstnList' data-qstnScr='" + qstnScr + "' data-qstnSeqno='" + i + "'>";
		        			html += "	<div class='h_top'>";
		        			html += "		<div class='h_left'>";
		        			html += "			<h4><i class='xi-arrows m_handle mr10' aria-label='위젯 이동' role='button' tabindex='0' aria-grabbed='false'></i><spring:message code='quiz.label.qstn' /> " + i + "</h4>";	// 문제
		        			html += "		</div>";
		        			html += "		<div class='h_right'>";
		        			if(${today < vo.examDtlVO.examPsblSdttm }) {
								html += "		<a href='javascript:qstnAddFrmView(\"" + i + "\")' class='btn basic small'><spring:message code='quiz.button.qstn.sub.add' /></a>";	// 후보 문제 추가
			        		}
			        		if(isExamSubmit) {
			        			html += "		<div class='ui input mr10' id='scoreDisplayDiv" + i + "'>";
				        		html += "			<span>" + qstnScr + "<spring:message code='exam.label.score.point' /></span>"; // 점
				        		html += "		</div>";
				        		html += "		<div class='ui input mr10' id='scoreInputDiv" + i + "' style='display:none;'>";
				        		html += "			<input type='text' id='editScore" + i + "' name='editScore' value='" + qstnScr + "' inputmask='numeric' mask='999.99' maxVal='100' onfocus='this.select()' />";
				        		html += "			<input type='hidden' id='originScore" + i + "' value='" + qstnScr + "' />";
				        		html += "			<label class='ui label flex-none m0'><spring:message code='message.score' /></label>"; // 점
				        		html += "		</div>";
			        		} else {
	                            html += "		<div class='scr_div' onclick='qstnScrModifyFrmView(this)'>";
	                            html += "			<span>" + qstnScr + "<spring:message code='message.score' /></span>"; // 점
	                            html += "			<div class='input_btn' style='display: none;'>";
	                            html += "				<input type='text' class='form-control sm' name='qstnScr' inputmask='numeric' mask='999.99' maxVal='100' value='" + qstnScr + "' />";
	                            html += "				<label><spring:message code='message.score' /></label>";	// 점
	                            html += "			</div>";
	                            html += "		</div>";
			        		}
			        		if(${today < vo.examDtlVO.examPsblSdttm }) {
			        			html += "		<a href='javascript:qstnDelete(\"" + examDtlId + "\", \"" + i + "\", \"\")' class='btn basic type2 small'><spring:message code='common.button.delete' /></a>";	// 삭제
			        		}
		        			html += "		</div>";
		        			html += "	</div>";
		        			html += "	<div class='question_area qstn" + i + "'>";
							qstnList.forEach(function(v, ii) {
			        			if(i == v.qstnSeqno) {
									html += "<div class='question_con' data-qstnSeqno='" + v.qstnSeqno + "' data-qstnCnddtSeqno='" + v.qstnCnddtSeqno + "' data-qstnId='" + v.qstnId + "'>";
									html += "	<div class='q_top'>";
									html += "		<div class='flex-item width-100per'>";
									html += "			<div class='q-info-group'>";
                                    html += "				<i class='btn basic small mr10 xi-arrows-v m_handle'></i>";
									html += "				<p class='flex-none mr15'><b>" + v.qstnSeqno + "-" + v.qstnCnddtSeqno + "</b></p>";
									html += "			</div>";
									html += "			<div class='flex-1 tal q-content fcBlue cursor-pointer' onclick='isExistQstnModFrm(\"" + v.examDtlId + "\", \"" + v.qstnId + "\")'>" + v.qstnTtl + "</div>";
									html += "			<div class='q-ctrl-group'>";
									html += "				<p class='flex-none ml15 mr15'>" + v.qstnRspnsTynm + "</p>";
									if(!isExamSubmit) {
			        					html += "			<button type='button' onclick='qstnDelete(\"" + v.examDtlId + "\", \"" + v.qstnSeqno + "\", \"" + v.qstnCnddtSeqno + "\")' class='btn basic type2 small flex-none'><spring:message code='common.button.delete' /></button>";	// 삭제
			        				}
									html += "			</div>";
									html += "		</div>";
									html += "	</div>";
			        				html += 	previewOption.createQstnPreviewHTML(v);
			        				html += "</div>";
			        			}
			        		});
							html += "	</div>";
							html += "</div>";
		     			}
		     			$("#quizQstnDiv").empty().html(html);
		     			UiInputmask();
		     			$("#qstnTotalScore").text(totalScore);

		     			$('#quizQstnDiv').sortable({
		     	            connectWith: '#quizQstnDiv',
		     	            placeholderClass: '.quizQstnList',
		     	            placeholder: "portlet-placeholder",
		     	            handle: ".xi-arrows",
		     	            opacity: 0.6,
		     	            stop: function(event, ui) {
		     	            	qstnSeqnoChange(ui.item);	// 문항순번 변경
		     	            }
		     	        });

		     			$('.question_area').sortable({
		     	            connectWith: '.question_area',
		     	            placeholderClass: '.question_con',
		     	            placeholder: "portlet-placeholder",
		     	            handle: ".xi-arrows-v",
		     	            opacity: 0.6,
		     	            receive: function(event, ui) {
		     	                $(ui.sender).sortable('cancel');
		     	            },
		     	            stop: function(event, ui) {
		     	            	qstnCnddtSeqnoChange(ui.item);	// 문항후보순번 변경
		     	            }
		     	        });
		     		} else {
		     			$("#quizQstnDiv").empty();
		     		}
		         }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
			}, true);
		}

		 /**
		 * 문항순번 변경
		 * @param obj - 문항순번 변경할 문항
		 */
	    function qstnSeqnoChange(obj) {
	    	if(!canQuizEdit("unsubmit")) {
	    		qstnListSelect();
	    		return false;
	    	}

	    	let qstnSeqno 	  	= obj.attr("data-qstnSeqno");	// 문항순번
	    	let newqstnSeqno 	= 1;							// 변경할 문항순번

	    	$("div.quizQstnList").each(function(i) {
	    		if(qstnSeqno == $(this).attr("data-qstnSeqno")) {
	    			newqstnSeqno = i + 1;
	    		}
	    	});

	    	if(qstnSeqno != newqstnSeqno) {
	    		const url  = "/quiz/qstnSeqnoModifyAjax.do";
	    		const data = {
	    			examDtlId	: $("#examDtlId").val(),
	    			qstnSeqno	: newqstnSeqno,
	    			searchKey 	: qstnSeqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	            		qstnListSelect();
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("<spring:message code='quiz.error.qstn.sort' />", "error");/* 문제 번호 변경 중 에러가 발생하였습니다. */
	    		}, true);
	    	}
	    }

	    /**
		 * 문항후보순번 변경
		 * @param obj - 문항후보순번 변경할 문항
		 */
	    function qstnCnddtSeqnoChange(obj) {
	    	if(!canQuizEdit("unsubmit")) {
	    		qstnListSelect();
	    		return false;
	    	}

	    	let qstnId				= obj.attr("data-qstnId");				// 문항아이디
	    	let qstnSeqno   		= obj.attr("data-qstnSeqno");			// 문항순번
	    	let qstnCnddtSeqno  	= obj.attr("data-qstnCnddtSeqno");		// 문항후보순번
	    	let newQstnCnddtSeqno 	= 1;									// 변경할 문항후보순번

	    	// 변경할 순번값 찾기
	    	$("div.qstn"+qstnSeqno+" div.question_con").each(function(i) {
	    		if(qstnCnddtSeqno == $(this).attr("data-qstnCnddtSeqno")) {
	    			newQstnCnddtSeqno = i + 1;
	    		}
	    	});

	    	if(qstnCnddtSeqno != newQstnCnddtSeqno) {
	    		const url  = "/quiz/qstnCnddtSeqnoModifyAjax.do";
	    		const data = {
	    			examDtlId	 	: $("#examDtlId").val(),
	    			qstnId			: qstnId,
	    			qstnSeqno	 	: qstnSeqno,
	    			qstnCnddtSeqno 	: newQstnCnddtSeqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	            		qstnListSelect();
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("<spring:message code='quiz.error.sub.qstn.sort' />", "error");/* 후보 문항 순서 변경 중 에러가 발생하였습니다. */
	    		}, true);
	    	}
	    }

	    /**
		 * 문항 등록
		 * @param parentId 	- 문제 추가용 최상위 div 아이디
		 * @param formId 	- 문제 추가용 form 아이디
		 * @param qstnSeqno - 문항순번
		 */
		function qstnRegist(parentId, formId, qstnSeqno) {
			UiValidator(formId).then(function(result) {
				if (result) {
					if(!qstnOption.isValidQstn(qstnSeqno || "")) {
					 	return false;
					}

					tkexamUserCntSelect().done(function(returnVO) {
						if(returnVO > 0) {
							UiComm.showMessage("<spring:message code='quiz.alert.quiz.answer.user.y.not.edit' />", "info");/* 퀴즈 응시자가 있어 수정할 수 없습니다. */
						} else {
							const url = "/quiz/quizQstnRegistAjax.do";

							ajaxCall(url, $("#"+formId).serialize(), function (data) {
				                if (data.result > 0) {
				                	qstnScrAutoGrnt($("#examDtlId").val());
							 		$("#"+parentId).remove();
				                } else {
				                	UiComm.showMessage(data.message, "error");
				                }
				            }, function () {
				            	UiComm.showMessage("<spring:message code='quiz.error.qstn.insert' />", "error");/* 문항 등록 중 에러가 발생하였습니다. */
				            }, true);
						}
					});
				}
			});
	    }

	    /**
		 * 문항 수정
		 * @param qstnSeqno - 문항순번
		 */
	    function qstnModify(qstnSeqno) {
	    	let formId = "qstnWriteForm"+qstnSeqno;
			UiValidator(formId).then(function(result) {
				if (result) {
			    	if(!qstnOption.isValidQstn(qstnSeqno)) {
			    		return false;
			    	}

			    	tkexamUserCntSelect().done(function(returnVO) {
				    	if($("#examQstnsCmptnyn").val() == "M" && ("${today}" > "${vo.examDtlVO.examPsblSdttm}" || returnVO > 0)) {
				    		dialog = UiDialog("dialog1", {
								title		: "<spring:message code='quiz.label.qstn.modify.option' />",/* 문제 수정 옵션 */
								width		: 600,
								height		: 270,
								url			: "/quiz/profQuizQstnModifyOptionPopup.do?qstnSeqno="+qstnSeqno,
								autoresize	: true
							});
				    	} else {
							const url = "/quiz/quizQstnModifyAjax.do";

							ajaxCall(url, $("#"+formId).serialize(), function (data) {
				                if (data.result > 0) {
				                	qstnListSelect();
				                } else {
				                	UiComm.showMessage(data.message, "error");
				                }
				            }, function () {
				            	UiComm.showMessage("<spring:message code='quiz.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
				            }, true);
				    	}
			    	});
				}
			});
	    }

	    // 퀴즈문항옵션수정
	    function quizQstnOptionModify(qstnSeqno, type) {
			let formId = "qstnWriteForm"+qstnSeqno;
	    	UiValidator(formId).then(function(result) {
				if (result) {
					if(!qstnOption.isValidQstn(qstnSeqno || "")) {
					 	return false;
					}
					$("#"+formId).append("<input type='hidden' name='searchKey' value='"+type+"' />");

					const url = "/quiz/quizQstnOptionModifyAjax.do";

					ajaxCall(url, $("#"+formId).serialize(), function (data) {
		                if (data.result > 0) {
		                	qstnListSelect();
		                } else {
		                	UiComm.showMessage(data.message, "error");
		                }
		            }, function () {
		            	UiComm.showMessage("<spring:message code='quiz.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
		            }, true);
				}
			});
	    }

	    /**
		 * 문항 삭제
		 * @param examDtlId 		- 시험상세아이디
		 * @param qstnSeqno 		- 문항순번
		 * @param qstnCnddtSeqno 	- 문항후보순번
		 */
	    function qstnDelete(examDtlId, qstnSeqno, qstnCnddtSeqno) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}

	    	// 시험응시자수 조회
	    	tkexamUserCntSelect().done(function(returnVO) {
		        let confirm = "<spring:message code='quiz.confirm.delete.answer.user.n' />";/* 퀴즈 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
		        if(returnVO > 0) {
		        	confirm = "<spring:message code='quiz.confirm.delete.answer.user.y' />";/* 퀴즈 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
		        }
	    		UiComm.showMessage(confirm, "confirm")
	    		.then(function(result) {
	    			if (result) {
	    				const url  = "/quiz/quizQstnDeleteAjax.do";
	    				const data = {
				        	examDtlId	  	: examDtlId,
				        	qstnSeqno 		: qstnSeqno,
				        	qstnCnddtSeqno 	: qstnCnddtSeqno
			        	};

			        	ajaxCall(url, data, function(data) {
			        		if (data.result > 0) {
			        			UiComm.showMessage("<spring:message code='quiz.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
			        	    	qstnScrAutoGrnt(examDtlId);
			        	    } else {
			        	    	UiComm.showMessage(data.message, "error");
			        	    }
			           	}, function(xhr, status, error) {
			           		UiComm.showMessage("<spring:message code='quiz.error.qstn.delete' />", "error");/* 문항 삭제 중 에러가 발생하였습니다. */
			           	}, true);
	    			}
	    		});
	    	});
	    }

	 	// 문제 가져오기 팝업
	    function qstnCopyPopup() {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}

	    	var extData = {
	    		examBscId : "${vo.examBscId}",
	    		examDtlId : $("#examDtlId").val()
	    	};

			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='quiz.button.qstn.copy' />"/* 문제 가져오기 */,
				width	: 800,
				height	: 650,
				url		: "/quiz/profQuizQstnCopyPopup.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData)
			});
	    }

	    /**
		 * 문항점수 자동 부여
		 * @param examDtlId - 시험상세아이디
		 * @param isConfirm - confirm 표시 여부
		 */
	    function qstnScrAutoGrnt(examDtlId, isConfirm) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}

	    	if(examDtlId == "") examDtlId = $("#examDtlId").val();

	    	if(isConfirm) {
		    	tkexamUserCntSelect().done(function(returnVO) {
			        if(returnVO > 0) {
			        	UiComm.showMessage('<spring:message code="quiz.alert.quiz.answer.user.y.not.edit" />', "info");// 퀴즈 응시자가 있어 수정할 수 없습니다.
			     		return;
			     	}

		    		UiComm.showMessage("<spring:message code='quiz.confirm.score.edit' />", "confirm")// 배점을 수정하겠습니까?
		    		.then(function(result) {
		    			if (!result) {
		    				return false;
		    			}
		    		});
		    	});
	    	}

	    	const url  = "/quiz/quizQstnScrBulkModifyAjax.do";
	    	const data = {
	    		examBscId : "${vo.examBscId}",
	    		examDtlId : examDtlId
	   		};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		qstnListSelect();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='quiz.error.qstn.score.update' />", "error");/* 점수 수정 중 에러가 발생하였습니다. */
			}, true);
	    }

	 	// 출제완료문항점수자동배점
	    function cmptnYQstnScrAutoGrnt() {
	    	tkexamUserCntSelect().done(function(returnVO) {
		        if(returnVO > 0) {
		        	UiComm.showMessage('<spring:message code="quiz.alert.quiz.answer.user.y.not.edit" />', "info");// 퀴즈 응시자가 있어 수정할 수 없습니다.
		     		return;
		     	}

		    	UiComm.showMessage("<spring:message code='quiz.confirm.score.edit' />", "confirm")// 배점을 수정하겠습니까?
		    	.then(function(result) {
		    		if (result) {
		    			const url  = "/quiz/quizQstnScrBulkModifyAjax.do";
		    			const data = {
		    	    		examBscId : "${vo.examBscId}",
		    	    		examDtlId : $("#examDtlId").val()
		    	   		};

		    			ajaxCall(url, data, function(data) {
		    				if (data.result > 0) {
		    					cancelScoreEditMode();
		    	        		qstnListSelect();
		    	            } else {
		    	            	UiComm.showMessage(data.message, "error");
		    	            }
		    			}, function(xhr, status, error) {
		    				UiComm.showMessage("<spring:message code='quiz.error.qstn.score.update' />", "error");// 점수 수정 중 에러가 발생하였습니다.
		    			}, true);
		    		}
		    	});
	    	});
	    }

	    /**
		 * 문항점수 수정 폼 보기
		 * @param obj	- 문항점수 수정객체
		 */
	    function qstnScrModifyFrmView(obj) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}
	    	$(obj).children("div.input_btn").show();
	    	$(obj).children("span").hide();
	    	$(obj).children("input").focus();

	    	$(obj).children("input").on("keyup", function(e) {
	    		if(e.keyCode == "13") {
	    			qstnScrModify();
	    		}
	    	});

	    	$(obj).children("input").on("blur", function(e) {
	    		qstnScrModify();
	    	});
	    }

	    /**
		 * 문항점수 수정
		 */
	    function qstnScrModify() {
	    	$("input[name=qstnScr]:visible").each(function(i, v) {
				let qstnSeqno	= $(v).parents(".quizQstnList").attr("data-qstnSeqno");									// 문항순번
				let qstnScr		= $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("input[name=qstnScr]").val();	// 문항점수
	        	let isBoolean	= true;

	        	if(qstnScr == "") {
	        		UiComm.showMessage("<spring:message code='quiz.alert.input.score' />", "info");// 점수를 입력하세요.
	        		isBoolean = false;
	        	} else if(qstnScr < 0 || qstnScr > 100) {
	        		UiComm.showMessage("<spring:message code='quiz.alert.score.max.100' />", "info");// 점수는 100점 까지 입력 가능 합니다.
	        		isBoolean = false;
	        	}
	        	if(!isBoolean) {
	        		qstnListSelect();
	        	} else {
	        		tkexamUserCntSelect().done(function(returnVO) {
	    		        if(returnVO > 0) {
	    		        	UiComm.showMessage('<spring:message code="quiz.alert.quiz.answer.user.y.not.edit" />', "info");// 퀴즈 응시자가 있어 수정할 수 없습니다.
	    		     		return;
	    		     	}

			        	const url  = "/quiz/quizQstnScrModifyAjax.do";
			        	const data = {
				        	examBscId	: "${vo.examBscId}",
				        	examDtlId	: $("#examDtlId").val(),
				        	qstnSeqno 	: qstnSeqno,
				        	qstnScr  	: qstnScr
			        	};

			    		ajaxCall(url, data, function(data) {
			    			if (data.result > 0) {
			    				if((i+1) == $("input[name=qstnScr]:visible").length) {
		    	    				qstnListSelect();
			    				}
			                } else {
			                	UiComm.showMessage(data.message, "error");
			                }
			    		}, function(xhr, status, error) {
			    			UiComm.showMessage("<spring:message code='quiz.error.qstn.score.update' />", "error");/* 점수 수정 중 에러가 발생하였습니다. */
			    		}, true);
	        		});
	        	}
			});
	    }

	    /**
		 * 퀴즈출제완료수정
		 * @param type	- 저장 구분 ( save : 저장, edit : 수정 )
		 * @param gbn	- 구분 ( bsc : 전체, dtl : 팀 )
		 */
	    function quizQstnsCmptnModify(type, gbn) {
			if($("#qstnTotalScore").text() != "100" && type == "save") {
				UiComm.showMessage("<spring:message code='quiz.alert.score.ratio.100' />", "warning");/* 배점 점수가 100점과 맞지 않습니다. 다시 확인해 주세요. */
				return false;
			}

			if(SCORE_EDIT_MODE == true) {
				UiComm.showMessage("<spring:message code='quiz.alert.score.edit.not.complete' />", "info");// 배점 일괄 수정 중입니다. <br/>배점 일괄 저장 또는 취소후 저장및출제 가능합니다.
				return false;
			}

			if(gbn != undefined && gbn == "bsc") {
				if(${not isQstnsCmptn}) {
					UiComm.showMessage("<spring:message code='quiz.alert.all.team.submit' />", "info");/* 모든 팀의 문제를 출제완료 해주세요. */
					return false;
				}
			}

			if(canQuizEdit("submit")) {
				if(type == "edit" && "${vo.tkexamStrtUserCnt}" > 0) {
					let data = "examBscId=${vo.examBscId}&examDtlVO.examDtlId="+$("#examDtlId").val()+"&examGbncd=${vo.examGbncd}&searchGubun="+type+"&searchKey="+gbn;
					dialog = UiDialog("dialog1", {
						title	: "<spring:message code='quiz.button.qstn.edit' />",/* 문제 수정 */
						width	: 600,
						height	: 270,
						url		: "/quiz/profQuizQstnsCmptnModifyPopup.do?" + data
					});
				} else {
					let confirmMsg = "<spring:message code='quiz.confirm.qstn.submit' />"; // 문제를 출제하시겠습니까?
					if(type == "edit") {
						confirmMsg = "<spring:message code='quiz.confirm.qstn.edit' />"; // 문제를 수정하시겠습니까?
					}
					UiComm.showMessage(confirmMsg, "confirm")
					.then(function(result) {
						if (result) {
							const url  = "/quiz/quizQstnsCmptnModifyAjax.do";
							const data = {
								examBscId   			: "${vo.examBscId}",
								"examDtlVO.examDtlId"	: $("#examDtlId").val(),
								examGbncd				: "${vo.examGbncd}",
								searchGubun 			: type,
								searchKey				: gbn
							};

							ajaxCall(url, data, function (data) {
				                if (data.result > 0) {
				                	quizViewMv("${vo.examBscId}", "QSTN", $("#examDtlId").val());	// 퀴즈 문항 관리 화면
				                } else {
				                	UiComm.showMessage(data.message, "error");
				                }
				            }, function () {
				            	UiComm.showMessage("<spring:message code='quiz.error.qstn.submit' />", "error");/* 문항 출제 중 에러가 발생하였습니다. */
				            }, true);
						}
					});
				}
			}
	    }

		// 문항엑셀업로드팝업
	 	function qstnExcelUploadPopup() {
	 		if(!canQuizEdit("unsubmit")) {
	 			return false;
	 		}

	 		const data = "examDtlId="+$("#examDtlId").val()+"&qstnGbncd=GENERAL";

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.excel.upload.qstn' />",/* 엑셀 문항등록 */
				width		: 600,
				height		: 500,
				url			: "/quiz/profQstnExcelUploadPopup.do?"+data,
				autoresize	: true
			});
	 	}

		/**
		* 퀴즈수정가능여부
		* @param type - (unsubmit : 수정, submit : 제출완료, all : 전체)
		*/
		function canQuizEdit(type) {
			let isSubmit = $("#examQstnsCmptnyn").val() == "Y";				// 출제 완료 여부
			let isTemp	 = $("#examQstnsCmptnyn").val() == "M";				// 제출 후 수정 여부
			let isWait   = "${today}" > "${vo.examDtlVO.examPsblSdttm}";	// 퀴즈 대기 여부

			if(isSubmit && type != "submit") {
				UiComm.showMessage("<spring:message code='quiz.alert.click.edit.submit.btn' />", "info");/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
				return false;
			}
			if(isTemp && type == "unsubmit" && isWait) {
				UiComm.showMessage("<spring:message code='quiz.alert.only.qstn.modify' />", "info");/* 문제 수정만 가능합니다. */
				return false;
			}

			return true;
		}

	 	// 시험응시 사용자수 조회
		function tkexamUserCntSelect() {
			let deferred = $.Deferred();

			const url = "/quiz/tkexamStrtUserCntSelectAjax.do";
			const data = {
	   			examBscId : "${vo.examBscId}",
	   			examDtlId : $("#examDtlId").val()
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result >= 0) {
					deferred.resolve(data.result);
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        		deferred.reject();
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
				deferred.reject();
			}, true);

			return deferred.promise();
		}

	 	// 배점 일괄 수정 모드
	 	function changeScoreEditMode() {
	 		SCORE_EDIT_MODE = false;

	 		if($("#examQstnsCmptnyn").val() == "Y") {
	 			if(!canQuizEdit("unsubmit")) {
	 	    		return false;
	 	    	}
	 		}

			tkexamUserCntSelect().done(function(returnVO) {
		        if(returnVO > 0) {
		        	UiComm.showMessage('<spring:message code="quiz.alert.quiz.answer.user.y.not.edit" />', "info");// 퀴즈 응시자가 있어 수정할 수 없습니다.
		     		return;
		     	}

		        // 점수편집 비활성화
		     	cancelScoreEditMode();

		     	// 점수 입력 활성화
		     	$.each($("input[name='editScore']"), function() {
		     		let index = this.id.replace("editScore", "");

		     		$("#scoreDisplayDiv" + index).hide();
		     		$("#scoreInputDiv" + index).show();

		     		// 탭 이벤트 활성화
		     		$("#editScore" + index).off("keydown.tab").on("keydown.tab", function(e) {
		     			if(e.keyCode == 9 && e.shiftKey) {
		     				e.preventDefault();

		     				let index = Number(this.id.replace("editScore", ""));
		     				let $prev = $("#editScore" + (index - 1));
		     				let maxLen = $("input[name='editScore']").length;

		     				if($prev.length != 1 && index == 0) {
		     					$prev = $("#editScore" + (maxLen - 1));
		     				}

		     				if($prev.length == 1) {
		     					$prev.focus().select();
		     				}
		     			} else if(e.keyCode == 9) {
		     				e.preventDefault();

		     				let index = Number(this.id.replace("editScore", ""));
		     				let $next = $("#editScore" + (index + 1));

		     				if($next.length != 1 && index != 0) {
		     					$next = $("#editScore0");
		     				}

		     				if($next.length == 1) {
		     					$next.focus().select();
		     				}
		     			}
		     		});
		     	});

		     	// 일괄 점수저장 버튼으로 변경
		     	$("#changeScoreEditModeBtn").text("<spring:message code='quiz.button.batch.save.score' />"); // 배점 일괄 저장
		     	$("#changeScoreEditModeBtn").off("click").on("click", function() {
		     		cmptnYQstnScrBulkModify();
		     	});

		     	// 취소 버튼 보임
		     	$("#cancelScoreEditModeBtn").show();

		     	SCORE_EDIT_MODE = true;
			});
	 	}

	 	// 점수편집 비활성화
	 	function cancelScoreEditMode() {
	 		$.each($("input[name='editScore']"), function() {
	 			let index = this.id.replace("editScore", "");

	 			let originVal = $("#originScore" +  + index).val();

				// 입력창 hide
				$("#scoreDisplayDiv" + index).show();
				$("#scoreInputDiv" + index).hide();

				// 입력값 원복
				$(this).val(originVal);

				// 탭 이벤트 비활성화
				$("#editScore" + index).off("keydown.tab");
			});

	 		// 일괄 점수편집 버튼으로 변경
			$("#changeScoreEditModeBtn").text("<spring:message code='quiz.button.batch.edit.score' />"); // 배점 일괄 수정
			$("#changeScoreEditModeBtn").off("click").on("click", function() {
				changeScoreEditMode();
			});

	 		// 취소 버튼 숨김
			$("#cancelScoreEditModeBtn").hide();

			calcTotEditScore();

			SCORE_EDIT_MODE = false;
	 	}

	 	// 출제완료문항점수일괄수정
		function cmptnYQstnScrBulkModify() {
			tkexamUserCntSelect().done(function(returnVO) {
		        if(returnVO > 0) {
		        	UiComm.showMessage('<spring:message code="quiz.alert.quiz.answer.user.y.not.edit" />', "info");// 퀴즈 응시자가 있어 수정할 수 없습니다.
		     		return;
		     	}

		        let changeScoreList = [];
		        let isValid = true;
		        let totalScr = 0;

				// 점수 입력 체크
				$.each($("input[name='editScore']"), function() {
					let index = this.id.replace("editScore", "");

					if(this.value == "") {
						UiComm.showMessage("<spring:message code='quiz.alert.input.score' />", "info");// 점수를 입력하세요.
						isValid = false;
						$(this).focus();
						return false;
					}

					if(Number(this.value) > 100) {
						UiComm.showMessage("<spring:message code='quiz.alert.score.max.100' />", "info");// 점수는 100점 까지 입력 가능 합니다.
						isValid = false;
						$(this).focus();
						return false;
					}

					let qstnSeqno	= $(this).parents(".quizQstnList").attr("data-qstnSeqno");	// 문항순번
					let qstnScr 	= this.value;												// 문항점수

					changeScoreList.push({
	        			"examDtlId"	: $("#examDtlId").val(),
	        			"qstnSeqno" : qstnSeqno,
	        			"qstnScr"  	: qstnScr
					});

					totalScr += Number(qstnScr);
				});

				if(totalScr != 100) {
					UiComm.showMessage("<spring:message code='quiz.alert.score.ratio.100' />", "info");/* 배점 점수가 100점과 맞지 않습니다. 다시 확인해 주세요. */
					return false;
				}

				if(!isValid) return;

				UiComm.showMessage("<spring:message code='quiz.confirm.score.edit' />", "confirm")// 배점을 수정하겠습니까?
				.then(function(result) {
					if (result) {
						const url = "/quiz/cmptnYQuizQstnScrBulkModifyAjax.do";

						$.ajax({
					        url 	  	: url,
					        async	  	: false,
					        type 	  	: "POST",
					        dataType 	: "json",
					        data 	  	: JSON.stringify(changeScoreList),
					        contentType	: "application/json; charset=UTF-8",
					        beforeSend	: () => UiComm.showLoading(true),
			                success		: function (data) {
			                	cancelScoreEditMode();

								UiComm.showMessage("<spring:message code='quiz.alert.score.regist.finish' />", "success");// 점수 등록이 완료되었습니다.

								qstnListSelect();
			                },
			                error		: () => UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"),// 에러가 발생했습니다!
			                complete	: () => UiComm.showLoading(false)
					    });
					}
				});
			});
		}

	 	function calcTotEditScore() {
	 		let totScore = 0;

	 		$.each($("input[name='editScore']"), function() {
	 			let value = (this.value || 0) * 10;

	 			totScore += value;
			});

	 		$("#qstnTotalScore").text(totScore / 10);
	 	}

	 	/**
		* 퀴즈 팀 선택
		* @param examDtlId - 선택 팀에 대한 시험상세아이디
		*/
	 	function quizTeamSelect(examDtlId) {
			// 팀 버튼 색상 변경
			const teamButtons = document.querySelectorAll('[name="teamButton"]');
			teamButtons.forEach(button => {
			  	button.classList.remove('select');
			});
			document.querySelector('li[name="teamButton"][value="' + examDtlId + '"]').classList.add('select');

			$("#examDtlId").val(examDtlId);
			$("#qstnAddDiv").remove();

			// 문제 관리 버튼 변경
			let html = "";
			<c:forEach var="team" items="${quizTeamList }">
				if("${team.examDtlId}" == examDtlId) {
					$("#examQstnsCmptnyn").val("${team.examQstnsCmptnyn}");
					if("${team.examQstnsCmptnyn}" == "M") {
						html += "<a href='javascript:changeScoreEditMode()' id='changeScoreEditModeBtn' class='btn type2'><spring:message code='quiz.button.batch.edit.score' /></a>";/* 배점 일괄 수정 */
						html += "<a href='javascript:cancelScoreEditMode()' id='cancelScoreEditModeBtn' class='btn type2' style='display: none;'><spring:message code='common.button.cancel' /></a>";/* 취소 */
						html += "<a href='javascript:cmptnYQstnScrAutoGrnt(\"${vo.examBscId }\")' class='btn basic type1'><spring:message code='quiz.button.auto.score' /></a>";/* 자동 배점 */
						html += "<a href='javascript:quizQstnsCmptnModify(\"save\", \"dtl\")' class='btn basic type2'><spring:message code='quiz.button.qstn.cmptny' /></a>";/* 출제 완료 */
					} else if("${team.examQstnsCmptnyn}" == "Y") {
						html += "<a href='javascript:quizQstnsCmptnModify(\"edit\", \"dtl\")' class='btn basic type2'><spring:message code='common.button.modify' /></a>";/* 수정 */
					} else {
						html += "<a href='javascript:qstnCopyPopup()' class='btn basic'><spring:message code='quiz.button.qstn.copy' /></a>";/* 문제 가져오기 */
						html += "<a href='javascript:qstnExcelUploadPopup()' class='btn basic'><spring:message code='quiz.button.excel.upload.qstn' /></a>";/* 엑셀 문항등록 */
						html += "<a href='javascript:qstnScrAutoGrnt(\"\", true)' class='btn basic type1'><spring:message code='quiz.button.auto.score' /></a>";/* 자동 배점 */
						html += "<a href='javascript:quizQstnsCmptnModify(\"save\", \"dtl\")' class='btn basic type2'><spring:message code='quiz.button.qstn.cmptny' /></a>";/* 출제 완료 */
					}
				}
			</c:forEach>
			$("#qstnBtnDiv").empty().html(html);

			qstnListSelect();
	 	}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

					<div class="sub-content qstn">
						<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.common.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li><a onclick="quizViewMv('${vo.examBscId}', 'EVL')"><spring:message code="quiz.tab.evl" /><!-- 퀴즈정보 및 평가 --></a></li>
					            <li class="select"><a onclick="quizViewMv('${vo.examBscId}', 'QSTN')"><spring:message code="quiz.tab.qstn" /><!-- 문항관리 --></a></li>
					            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
						            <li><a onclick="quizViewMv('${vo.examBscId}', 'RETKEXAM')"><spring:message code="quiz.tab.retkexam" /><!-- 재응시 관리 --></a></li>
					            </c:if>
					        </ul>
					    </div>

				        <div class="board_top">
				        	<h3 class="board-title"><spring:message code="quiz.tab.qstn" /><!-- 문항관리 --></h3>
					        <div class="right-area">
					        	<a href="javascript:quizViewMv('${vo.examBscId}', 'LIST')" class="btn type2 big"><spring:message code="common.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

					    <%--퀴즈 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/quiz/common/quiz_info_inc.jsp"/>
	                    <%--퀴즈 정보--%>

						<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
							<div class="board_top margin-top-4">
								<div class="right-area">
									<c:choose>
										<c:when test="${vo.examQstnsCmptnyn eq 'Y' }">
											<a href="javascript:quizQstnsCmptnModify('edit', 'bsc')" class="btn type2 big"><spring:message code="common.button.modify" /><!-- 수정 --></a>
										</c:when>
										<c:otherwise>
											<a href="javascript:quizQstnsCmptnModify('save', 'bsc')" class="btn type2 big"><spring:message code="quiz.button.qstn.cmptny" /><!-- 출제 완료 --></a>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
							<div class="listTab">
	                            <ul>
	                            	<c:forEach var="item" items="${quizTeamList }">
	                            		<li name="teamButton" value="${item.examDtlId }"><a onclick="quizTeamSelect('${item.examDtlId }')">${item.teamnm }</a></li>
	                            	</c:forEach>
	                            </ul>
	                        </div>
						</c:if>

						<div class="margin-bottom-5">
							<input type="hidden" id="examDtlId" value="${vo.examDtlVO.examDtlId }" />
							<input type="hidden" id="examQstnsCmptnyn" value="${vo.examDtlVO.examQstnsCmptnyn }" />
							<div class="board_top">
								<h3><spring:message code="quiz.label.submit.qstn" /><!-- 출제 문제 --> : <span id="qstnCnt">0</span><spring:message code="quiz.label.qstn" /><!-- 문제 --></h3>
								<c:if test="${vo.examQstnsCmptnyn ne 'Y' || vo.examGbncd ne 'QUIZ_TEAM' }">
									<div class="right-area" id="qstnBtnDiv">
										<c:choose>
											<c:when test="${vo.examDtlVO.examQstnsCmptnyn eq 'M'}">
												<a href="javascript:changeScoreEditMode()" id="changeScoreEditModeBtn" class="btn type2"><spring:message code="quiz.button.batch.edit.score" /><!-- 배점 일괄 수정 --></a>
										    	<a href="javascript:cancelScoreEditMode()" id="cancelScoreEditModeBtn" class="btn type2" style="display: none;"><spring:message code="common.button.cancel" /><!-- 취소 --></a>
										    	<a href="javascript:cmptnYQstnScrAutoGrnt('${vo.examBscId }')" class="btn basic type1"><spring:message code="quiz.button.auto.score" /><!-- 자동 배점 --></a>
										    	<a href="javascript:quizQstnsCmptnModify('save', 'dtl')" class="btn basic type2"><spring:message code="quiz.button.qstn.cmptny" /><!-- 출제 완료 --></a>
											</c:when>
											<c:when test="${vo.examDtlVO.examQstnsCmptnyn eq 'Y'}">
												<a href="javascript:quizQstnsCmptnModify('edit', 'dtl')" class="btn type1"><spring:message code="common.button.modify" /><!-- 수정 --></a>
											</c:when>
											<c:otherwise>
												<a href="javascript:qstnCopyPopup()" class="btn basic"><spring:message code="quiz.button.qstn.copy" /><!-- 문제 가져오기 --></a>
										        <a href="javascript:qstnExcelUploadPopup()" class="btn basic"><spring:message code="quiz.button.excel.upload.qstn" /><!-- 엑셀 문항등록 --></a>
										        <a href="javascript:qstnScrAutoGrnt('', true)" class="btn basic type1"><spring:message code="quiz.button.auto.score" /><!-- 자동 배점 --></a>
										        <a href="javascript:quizQstnsCmptnModify('save', 'dtl')" class="btn basic type2"><spring:message code="quiz.button.qstn.cmptny" /><!-- 출제 완료 --></a>
											</c:otherwise>
										</c:choose>
									</div>
								</c:if>
							</div>

							<div class="grid-content modal-type ui-sortable ml0" id="quizQstnDiv"></div>
						</div>

						<div class="board_top class">
                            <h3 class="board-title"><spring:message code="quiz.label.total.score" /><!-- 배점 합계 --> <b class="primary" id="qstnTotalScore"></b><spring:message code="message.score" /><!-- 점 --></h3>
                            <div class="right-area">
                            	<button onclick="qstnAddFrmView('')" class="btn type1 examQstnsCmptnClass"><spring:message code="quiz.button.qstn.add" /></button><!-- 문제 추가 -->
                            </div>
                        </div>

						<div class="msg-box examQstnsCmptnClass">
                            <ul class="list-dot">
                                <li><spring:message code="quiz.label.qstn.submit.info1" /><!-- 출제완료 클릭 전에는 “임시저장” 상태입니다. --></li>
                                <li><spring:message code="quiz.label.qstn.submit.info2" /><!-- 문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요. --></li>
                            </ul>
                        </div>
					</div>
				</div>
			</div>
			<!-- //content -->
		</main>
		<!-- //classroom-->
    </div>
</body>
</html>