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

		var dialog;

		$(document).ready(function() {
			// 학습그룹부과제설정시 퀴즈 부 과제 목록 조회
			if("${vo.lrnGrpSubasmtStngyn}" == "Y") {
				quizSubAsmtListSelect();
			}

			$("#changeScoreEditModeBtn").on("click", function() {
				changeScoreEditMode();
			});

			if("${vo.examGbncd}" == "QUIZ_TEAM") {
				document.querySelector('button[name="teamButton"][value="' + "${vo.examDtlVO.examDtlId}" + '"]').click();
			} else {
				qstnListSelect();
			}

			$(".accordion").accordion();
			const title = document.querySelector('.accordion .title');

			document.querySelector('.accordion .title').addEventListener('click', () => {
			  	const content = title.nextElementSibling;
			  	content.classList.toggle('hide');
			});
		});

		/**
		 * 퀴즈 부 과제 목록 조회
		 * @param {String}  lrnGrpId 	- 학습그룹아이디
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @returns {list} 부 과제 목록
		 */
		function quizSubAsmtListSelect() {
			var url  = "/quiz/quizLrnGrpSubAsmtListAjax.do";
			var data = {
				lrnGrpId  : "${vo.lrnGrpId}",
				examBscId : "${vo.examBscId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<tr>";
							html += "	<th>" + v.teamnm + "</th>";
							html += "	<td>";
							html += "		<table class='table-type2'>";
							html += "			<colgroup>";
							html += "				<col class='width-10per' />";
							html += "				<col class='' />";
							html += "			</colgroup>";
							html += "			<tbody>";
							html += "				<tr>";
							html += "					<th>주제</th>";
							html += "					<td class='t_left'>" + v.examTtl + "</td>";
							html += "				</tr>";
							html += "				<tr>";
							html += "					<th>내용</th>";
							html += "					<td class='t_left'><pre>" + v.examCts + "</pre></td>";
							html += "				</tr>";
							html += "				<tr>";
							html += "					<th>첨부파일</th>";
							html += "					<td class='t_left'>";
							//html += "						<button class='ui icon small button' id='file_fileSn' title='파일다운로드' onclick='fileDown(\"" + ${list.fileSn } + "\", \"" + ${list.repoCd } + "\")'><i class='ion-android-download'></i></button>";
							html += "					</td>";
							html += "				</tr>";
							html += "			</tbody>";
							html += "		</table>";
							html += "	</td>";
							html += "	<td>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</td>";
							html += "</tr>";
	        			});
	        		}
					/* byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}"); */

	        		$("#quizSubAsmtTbody").append(html);
				}
			}, true);
		}

		var editorMap = {};

		var formOption = {
			/**
			 * 문제 말머리 HTML 추가
			 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 * @param {String}  editorId 	- 문제 내용 에디터 아이디
			 */
			createQstnHeaderHTML: function(parentId, formId, editorId) {
				var html  = "<form id=\"" + formId + "\">";
	    			html += "	<input type='hidden' name='examBscId' />";
	    			html += "	<input type='hidden' name='examDtlId' />";
	    			html += "	<input type='hidden' name='qstnId' />";
	    			html += "	<input type='hidden' name='qstnSeqno' />";
	    			html += "	<input type='hidden' name='qstnCnddtSeqno' />";
	    			html += "	<input type='hidden' name='qstnScr'  	value='0' />";
	    			html += "	<input type='hidden' name='qstnGbncd'	value='TXT' />";
	    			html += "	<div class='flex gap-1 margin-bottom-3'>";
	    			html += "		<div class='flex-1'>";
	    			html += "			<input type='text' class='width-100per' inputmask='byte' maxLen='200' name='qstnTtl' required='true'>";
	    			html += "		</div>";
	    			html += "		<select class='form-select' name='qstnRspnsTycd' onchange='qstnRspnsTycdChgChange(\"" + formId + "\")' required='true'>";
	    							<c:forEach var="code" items="${qstnRspnsTycdList }">
	    			html += "			<option value='${code.cd }'>${code.cdnm }</option>";
	    							</c:forEach>
	    			html += "		</select>";
	    			html += "	</div>";
	    			html += "	<p class='fcRed margin-bottom-3'>* 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다.</p>";
	    			html += "	<div class='editor-box'>";
	    			html += "		<textarea name='qstnCts' id=\"" + editorId + "\" required='true'></textarea>";
	    			html += "	</div>";
		    		html += "	<div class='margin-top-4 qstnTypeDiv'>";
		    		html += "		<table class='table-type2'>";
		    		html += "			<colgroup>";
		    		html += "				<col class='width-20per' />";
		    		html += "				<col class='' />";
		    		html += "			</colgroup>";
		    		html += "			<tbody></tbody>";
		    		html += "		</table>";
		    		html += "	</div>"
		    		html += "</form>";
	    		$("#"+parentId+" .content").append(html);
			},
	 		/**
			 * 문제 버튼 HTML 추가
			 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 */
			 createQstnBtnHTML: function(parentId, formId) {
				var html  = "<div class='btns'>";
		    		html += "	<a href='javascript:qstnRegist(\"" + parentId + "\", \"" + formId + "\")' class='btn type1 addBtn'><spring:message code='exam.button.save' /></a>";/* 저장 */
		    		html += "	<a href='javascript:qstnAddFrmRemove(\"" + parentId + "\")' class='btn type1'><spring:message code='exam.button.cancel' /></a>";/* 취소 */
		    		html += "</div>";
		    	$("#"+parentId+" .content").append(html);
			},
			/**
			 * 보기항목 수 HTML 추가
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 * @param {String}  type 		- 문항답변유형코드
			 */
			createVwitmCntHTML: function(formId, type) {
				var html  = "<tr>";
		    		html += "	<th>보기 개수</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<select class='form-select' name='vwitmCnt' onchange='createVwitmCntChgHTML(\"" + formId + "\", \"" + type + "\")' required='true'>";
		    						for(var idx = 2; idx <= 10; idx++) {
		    							var selected = (type == "ONE_CHC" || type == "MLT_CHC") && idx == 2 ? "selected" : "";
		    		html += "			<option value=\"" + idx + "\" " + selected + ">" + idx + "개</option>";
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
		    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		    	UiSwitcher();
			},
			/**
			 * 단답형 문항 HTML 추가
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 */
			 createTextQstnHTML: function(formId) {
				var html  = "<tr>";
		    		html += "	<th>정답 입력</th>";
		    		html += "	<td class='t_left' id='"+formId+"QstnDiv'>";
		    		html += "		<div class='shortInput flex gap-1'>";
		    		for(var i = 0; i < 5; i++) {
		    		html += "			<input type='text' name='qstnVwitmCts' class='w100' " + (i == 0 ? "required='true'" : "") + ">";
		    		}
		    		html += "			<button class='btn basic icon' onclick='formOption.createTextQstnAddHTML(\""+formId+"\")'><i class='xi-plus'></i></button>";
		    		html += "		</div>";
		    		html += "	</td>";
		    		html += "</tr>";
		    		html += "<tr id='"+formId+"ShortGubun'>";
		    		html += "	<th>정답 유형</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<span class='custom-input'>";
		    		html += "			<input type='radio' name='cransTycd' id='"+formId+"cransI' value='CRANS_INORDER' checked='checked'>";
		    		html += "			<label for='"+formId+"cransI'>순서에 맞게 정답</label>";
		    		html += "		</span>";
		    		html += "		<span class='custom-input'>";
		    		html += "			<input type='radio' name='cransTycd' id='"+formId+"cransN' value='CRANS_NOT_INORDER'>";
		    		html += "			<label for='"+formId+"cransN'>순서에 상관없이 정답</label>";
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
		    		html += "	<th>정답 입력</th>";
		    		html += "	<td class='t_left'>";
		    						for(var idx = 1; idx <= 2; idx++) {
		    							var oxClass = idx == 1 ? "true" : "false";
				 	html += "			<span class='custom-input'>";
					html += "				<input type='radio' name='qstnVwitmCts' id='"+formId+"_"+oxClass+"' value='" + (idx == 1 ? "O" : "X") + "' />";
					html += "				<label for='"+formId+"_"+oxClass+"'>" + (idx == 1 ? "O" : "X") + "</label>";
					html += "			</span>";
		    						}
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
		    		html += "	<th>정답 입력</th>";
		    		html += "	<td>";
		    		html += "		<table class='table-type2'>";
					html += "			<colgroup>";
					html += "				<col class='width-5per' />";
					html += "				<col class='width-45per' />";
					html += "				<col class='width-45per' />";
					html += "			</colgroup>";
					html += "			<tbody id='"+formId+"LinkTbody'>";
    				html += "			</tbody>";
    				html += "		</table>";
		    		html += "	</td>";
		    		html += "</tr>";
	    		$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
			},
			/**
			 * 단답형 문항 추가 HTML 추가
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 */
			 createTextQstnAddHTML: function(formId) {
				var shortInputCnt = $(".shortInput").length;
				if(shortInputCnt == 5) {
					return false;
				}
				var html  = "<div class='shortInput flex gap-1 margin-top-2' id='"+formId+"shortInput"+shortInputCnt+"'>";
					for(var i = 0; i < 5; i ++) {
					html += "	<input type='text' name='qstnVwitmCts' class='w100' " + (i == 0 ? "required='true'" : "") + " />";
					}
					html += "	<button class='btn basic icon' onclick='formOption.textQstnDelHTML(\""+formId+"\", "+shortInputCnt+")'><i class='xi-minus'></i></button>";
					html += "	<button class='btn basic icon' onclick='formOption.createTextQstnAddHTML(\""+formId+"\")'><i class='xi-plus'></i></button>";
					html += "</div>";
				$("#"+formId+"QstnDiv").append(html);
			},
			/**
			 * 단답형 문항 HTML 삭제
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 * @param {Integer} cnt 		- 삭제할 문항 줄 값
			 */
		    textQstnDelHTML: function(formId, cnt) {
		    	$("#"+formId+"shortInput"+cnt).remove();
		    },
		    /**
			 * 문항 난이도 HTML 추가
			 * @param {String}  formId 		- 문제 추가용 form 아이디
			 */
		    createQstnDfctlvHTML: function(formId) {
		    	var html  = "<tr>";
		    		html += "	<th>난이도</th>";
		    		html += "	<td class='t_left'>";
		    		html += "		<select class='form-select' id='"+formId+"QstnDfctlvTycd' name='qstnDfctlvTycd' required='true'>";
		    						<c:forEach var="code" items="${qstnDfctlvTycdList }">
		    		html += "			<option value='${code.cd }'>${code.cdnm }</option>";
		    						</c:forEach>
		    		html += "		</select>";
		    		html += "	</td>";
		    		html += "</tr>";
		    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		    	$("#"+formId+"QstnDfctlvTycd").chosen({disable_search: true});
		    }
		};

		var previewOption = {
			/**
			 * 문항 미리보기 HTML 추가
			 * @param {obj}  item	- 문항 정보
			 */
			 createQstnPreviewHTML: function(item) {
				var html  = "<div class='border-1 qstnList'>";
					html += "	<div class='board_top border-1 padding-3 qstnDiv'>";
					html += "		<span>" + item.qstnTtl + "</span>";
					// 연결형
					if(item.qstnRspnsTycd == "LINK") {
						html += "	<div class='right-area'>";
						html += "		(<spring:message code='exam.label.qstn.match.info' />)";/* 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. */
						html += "	</div>";
					}
					html += "	</div>";
					html += "	<div class='padding-3 margin-top-0'>";
					html += "		<div class='margin-bottom-5'>" + item.qstnCts + "</div>";
					// 단일, 다중선택형
					if(item.qstnRspnsTycd == "ONE_CHC" || item.qstnRspnsTycd == "MLT_CHC") {
						html += "	<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
					// 서술형
					} else if(item.qstnRspnsTycd == "LONG_TEXT") {
						html += "	<textarea style='width:100%;height:70px;' maxLenCheck='byte,4000,true,true'></textarea>";
					// 연결형
					} else if(item.qstnRspnsTycd == "LINK") {
						html += "	<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
					// OX선택형
					} else if(item.qstnRspnsTycd == "OX_CHC") {
						html += "	<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
					// 단답형
					} else if(item.qstnRspnsTycd == "SHORT_TEXT") {
						html += "	<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
					}
					html += "	</div>";
					html += "</div>";
					previewOption.createQstnVwitmPreviewHTML(item);	// 문항보기항목 미리보기 HTML 추가

				return html;
			},
			/**
			 * 미리보기 연결형 문항 이벤트 추가
			 * @param {String}  qstnId	- 문항아이디
			 */
			 createPreviewLinkQstnEvent: function(qstnId) {
				var invalid 	= false;
		        var $containner = $("#previewLinkContainer" + qstnId);
		        var $answers 	= $containner.find(".slot");

		        $answers.sortable({
		            placeholder: "",
		            opacity: 0.7,
		            zIndex: 9999,
		            connectWith: ".inventory-list .slot, .account-list .slot",
		            containment: $containner,
		            helper: "clone",
		            cursor: "pointer",
		            create: function(event, ui) {
		                if (!$(this).is(':empty')) {
		                    $(this).addClass("item-disabled");
		                }
		            },
		            over: function(event, ui) {
		                invalid = false;
		                if (this !== event.currentTarget) {
		                    if ($(event.target).hasClass("item-disabled")) {
		                        invalid = true;
		                    }
		                }
		            },
		            remove: function(event, ui) {
		                if (invalid != true) {
		                    $(this).removeClass("item-disabled");
		                }
		            },
		            receive: function(event, ui) {
		                if (invalid == true) {
		                    ui.sender.sortable("cancel");
		                }
		                $(this).addClass("item-disabled");
		            }
		        });
			},
			/**
			 * 문항보기항목 미리보기 HTML 추가
			 * @param {obj}  qstnVO	- 문항 정보
			 */
			createQstnVwitmPreviewHTML: function(qstnVO) {
				var url  = "/quiz/quizQstnVwitmListAjax.do";
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
								    html += "<div class='margin-bottom-3'>";
								    html += "	<span class='custom-input'>";
								    html += "		<input type='" + (qstnVO.qstnRspnsTycd == "MLT_CHC" ? "checkbox" : "radio") + "' name='preview_" + v.qstnId + "' id='" + v.qstnVwitmId + "_" + (i+1) + "' " + (v.cransYn == "Y" ? "checked" : "") + " />";
								    html += "		<label for='" + v.qstnVwitmId + "_" + (i+1) + "'>" + (i+1) + ". " + v.qstnVwitmCts + "</label>";
								    html += "	</span>";
								    html += "</div>";
								// OX선택형
			    				} else if(qstnVO.qstnRspnsTycd == "OX_CHC") {
									html += "<span class='custom-input'>";
									html += "	<input type='radio' name='prevew_" + v.qstnId + "' id='" + v.qstnVwitmId + "_" + (i+1) + "' " + (v.cransYn == "Y" ? "checked" : "") + " />";
									html += "	<label for='" + v.qstnVwitmId + "_" + (i+1) + "'>" + v.qstnVwitmCts + "</label>";
									html += "</span>";
								// 단답형
			    				} else if(qstnVO.qstnRspnsTycd == "SHORT_TEXT") {
									html += "<div class='flex gap-2 margin-bottom-2'>";
			    					v.qstnVwitmCts.split("|").forEach(function(vv, ii) {
				    					html += "<input type='text' class='width-15per' inputmask='byte' maxLen='4000' value='" + vv + "' />";
			    					});
									html += "</div>";
			    				// 연결형
			    				} else if(qstnVO.qstnRspnsTycd == "LINK") {
									linkVwHtml 		+= "<div class='line-box border-1 margin-bottom-3 padding-3 flex'>";
									linkVwHtml 		+= "	<div class='question width-30per'><span>" + v.qstnVwitmCts.split("|")[0] + "</span></div>";
									linkVwHtml 		+= "	<div class='slot margin-left-auto border-1 text-center width-100per' style='height:30px;' name='link" + qstnVO.qstnId + "'></div>";
									linkVwHtml 		+= "</div>";
									linkCransHtml 	+= "<div class='slot border-1 text-center width-100per margin-bottom-3' style='height:30px;' name='opposite'>";
									linkCransHtml 	+= "	<span><i class='xi-arrows'></i>" + v.qstnVwitmCts.split("|")[1] + "</span>";
									linkCransHtml	+= "</div>";
			    				}
							});

			    			// 연결형
			    			if(qstnVO.qstnRspnsTycd == "LINK") {
								html += "<div class='line-sortable-box flex' id='previewLinkContainer" + qstnVO.qstnId + "'>";
								html += "	<div class='account-list width-50per'>";
								html += 		linkVwHtml;
								html += "	</div>";
								html += "	<div class='inventory-list w200 margin-left-auto'>";
								html +=			linkCransHtml;
								html += "	</div>";
								html += "</div>";
			    			}
			    			$("#vwitm_"+qstnVO.qstnId+"_"+qstnVO.qstnCnddtSeqno).html(html);
			    			previewOption.createPreviewLinkQstnEvent(qstnVO.qstnId);
			    		}
					}
				}, true);
			}
		}

		/**
		 * 퀴즈 화면 이동
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function quizViewMv(tab) {
			var urlMap = {
				"1" : "/quiz/profQuizQstnMngView.do",		// 퀴즈 문항 관리 화면
				"2" : "/quiz/profQuizRetkexamMngView.do",	// 퀴즈 재응시 관리 화면
				"3" : "/quiz/profQuizEvlMngView.do",		// 퀴즈 평가 관리 화면
				"9" : "/quiz/profQuizListView.do"			// 퀴즈 목록 화면
			};

			var kvArr = [];
			kvArr.push({'key' : 'examBscId',   	'val' : "${vo.examBscId}"});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(urlMap[tab], "", "", kvArr);
		}

	    /**
		 * 보기항목 수 변경 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드 ( ONE_CHC : 단일선택형, MLT_CHC : 다중선택형, LINK : 연결형 )
		 */
	    function createVwitmCntChgHTML(formId, type) {
		    var vwitmCnt   = $("#"+formId+" .qstnTypeDiv select[name=vwitmCnt]").val();	// 보기 항목 개수 selectBox
	    	// 단일, 다중선택형
	    	if(type == "ONE_CHC" || type == "MLT_CHC") {
		    	var vwitmLiCnt = $("#"+formId+" .qstnItemTbody .vwitmTr").length;	// 기존 보기항목 수

		    	if(vwitmLiCnt < vwitmCnt) {
			    	for(var i = vwitmLiCnt; i < vwitmCnt; i++) {
					   	var html  = "<tr class='vwitmTr'>";
					   		html += "	<th>";
							html += "		<span class='custom-input'>";
					   		// 다중선택형
					   		if(type == "MLT_CHC") {
					   		html += "			<input type='checkbox' name='qstnVwitmSeqno' id='"+formId+"VwitmSeqno_"+(i+1)+"' value='"+(i+1)+"' >";
					   		// 단일선택형
					   		} else if(type == "ONE_CHC") {
					   		html += "			<input type='radio' name='qstnVwitmSeqno' id='"+formId+"VwitmSeqno_"+(i+1)+"' value='"+(i+1)+"' >";
					   		}
					   		html += "			<label for='"+formId+"VwitmSeqno_"+(i+1)+"'>보기"+(i+1)+"</label>";
					   		html += "		</span>";
					   		html += "	</th>";
					   		html += "	<td class='t_left'><input type='text' class='width-100per' name='qstnVwitmCts' id='"+formId+"Vwitm_"+(i+1)+"' required='true' /></td>";
					   		html += "</tr>";
				    	$("#"+formId+" .qstnItemTbody").append(html);
			    	}
		    	} else if(vwitmLiCnt > vwitmCnt) {
			    	for(var i = vwitmLiCnt; i > vwitmCnt-1; i--) {
			    	 	$("#"+formId+" .qstnItemTbody .vwitmTr:eq("+i+")").remove();
			    	}
		    	}

		    // 연결형
	    	} else if(type == "LINK") {
	    		var vwitmDivCnt = $("#"+formId+"LinkTbody .vwitmTr").length;

	    		if(vwitmDivCnt < vwitmCnt) {
	    			for(var i = vwitmDivCnt; i < vwitmCnt; i++) {
						var html  = "<tr class='vwitmTr'>";
							html += "	<td>" + (i+1) + "</td>";
							html += "	<td><input type='text' name='qstnVwitmTtl' id='"+formId+"VwitmTtl_"+(i+1)+"' placeholder='보기 입력' required='true' /></td>";
							html += "	<td><input type='text' name='qstnVwitmCts' id='"+formId+"VwitmCts_"+(i+1)+"' placeholder='정답 입력' required='true' /></td>";
							html += "</tr>";
		    			$("#"+formId+"LinkTbody").append(html);
	    			}
	    		} else if(vwitmDivCnt > vwitmCnt) {
	    			for(var i = vwitmDivCnt; i > vwitmCnt-1; i--) {
	    				$("#"+formId+"LinkTbody .vwitmTr:eq("+i+")").remove();
	    			}
	    		}
	    	}
	    }

	    /**
		 * 문항답변유형코드 변경
		 * @param {String} formId 	- 문제 추가용 form 아이디
		 */
	    function qstnRspnsTycdChgChange(formId) {
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").empty();			// 문항보기항목 비우기

	        var type = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
	        // 단일선택형, 다중선택형
	        if(type == "ONE_CHC" || type == "MLT_CHC") {
	        	formOption.createVwitmCntHTML(formId, type);				// 보기항목 수 HTML 추가
	        	formOption.createChgQstnHTML(formId);						// 단일, 다중선택형 문항 HTML 추가
	        	createVwitmCntChgHTML(formId, type);						// 보기항목 수 변경 HTML 추가

	        // 단답형
	        } else if(type == "SHORT_TEXT") {
	        	formOption.createTextQstnHTML(formId);						// 단답형 문항 HTML 추가

	        // OX선택형
	        } else if(type == "OX_CHC") {
	        	formOption.createOxQstnHTML(formId);						// OX선택형 문항 HTML 추가

	        // 연결형
	        } else if(type == "LINK") {
	        	formOption.createVwitmCntHTML(formId, type);				// 보기항목 수 HTML 추가
	        	formOption.createLinkQstnHTML(formId);						// 연결형 문항 HTML 추가
	        	createVwitmCntChgHTML(formId, type);						// 보기항목 수 변경 HTML 추가
	        }

	        formOption.createQstnDfctlvHTML(formId);						// 문항 난이도 HTML 추가
	    }

	    /**
		 * 문제 추가 폼 초기화
		 * @param {String} qstnSeqno	- 문항순번
		 */
	    function qstnAddFrmInit(qstnSeqno) {
	    	var qstnDivId   = "qstnAddDiv"+qstnSeqno;		// 문제 추가용 최상위 div 아이디
	    	var qstnHeader  = qstnSeqno == "" ? "<spring:message code='exam.button.qstn.add' />"/* 문제 추가 */ : "<spring:message code='exam.button.qstn.sub.add' />";/* 후보 문제 추가 */
	    	var addFormId   = "qstnWriteForm"+qstnSeqno;	// 문제 추가용 form 아이디
	    	var editorKey   = "editor"+qstnSeqno;			// 문제 내용 에디터 저장 키 값
	    	var editorId    = "qstnCts"+qstnSeqno;			// 문제 내용 에디터 아이디
	    	var appendClass = "qstn"+qstnSeqno;				// 문제 추가 div 삽입 위치

	    	// 문제 추가 폼 삽입
	    	$("#"+qstnDivId).remove();
	    	var html  = "<div class='margin-top-4 qstnFormDiv' id=\"" + qstnDivId + "\">";
	    		html += "	<h3 class='qstnTitle'>" + qstnHeader + "</h3>";
	    		html += "	<div class='content margin-top-3'>";
	    		html += "	</div>";
	    		html += "</div>";
			$("."+appendClass).append(html);

			formOption.createQstnHeaderHTML(qstnDivId, addFormId, editorId);	// 문제 말머리 HTML 추가
			formOption.createQstnBtnHTML(qstnDivId, addFormId);					// 문제 버튼 HTML 추가
			editorMap[editorKey] = UiEditor({
										targetId: editorId,
										uploadPath: "/quiz",
										height: "400px"
									});											// 문항내용 html 에디터 생성
			qstnRspnsTycdChgChange(addFormId);									// 문항답변유형코드 변경 이벤트
	    }

		/**
		 * 문제 추가 폼 보기
		 * @param {String} qstnSeqno - 문항순번 ( 후보문항 추가시 )
		 */
	    function qstnAddFrmView(qstnSeqno) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}
	    	qstnAddFrmInit(qstnSeqno);	// 문제 추가 폼 초기화
	    	var formId  = "qstnWriteForm"+qstnSeqno;
	    	var btnId   = "qstnAddDiv"+qstnSeqno;
	    	var qstnCnt = qstnSeqno != "" ? qstnSeqno : $(".quizQstnList").length + 1;
	    	var qstnCnddtSeqno = qstnSeqno != "" ? $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("div.quizQstnSubList").length + 1 : 1;
	    	var score   = qstnSeqno != "" ? $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("input[name=qstnScr]").val() : 0;
	    	$("#"+formId+" input[name=examBscId]").val("${vo.examBscId}");
	    	$("#"+formId+" input[name=examDtlId]").val($("#examDtlId").val());
	    	$("#"+formId+" input[name=qstnId]").val("");
	    	$("#"+formId+" input[name=qstnSeqno]").val(qstnCnt);
	    	$("#"+formId+" input[name=qstnCnddtSeqno]").val(qstnCnddtSeqno);
	    	$("#"+formId+" input[name=qstnTtl]").val(qstnCnt+"-"+qstnCnddtSeqno+" <spring:message code='exam.label.qstn' />");/* 문제 */
	    	$("#"+formId+" input[name=qstnScr]").val(score);
	    	$("#"+btnId+" .addBtn").attr("href", "javascript:qstnRegist(\"" + btnId + "\", \"" + formId + "\", \"" + (qstnSeqno || "") + "\")");
	    }

	    /**
		 * 문제 수정 폼 존재여부
		 * @param {String} examDtlId 	- 시험상세아이디
		 * @param {String} qstnId 		- 문항아이디
		 */
	    function isExistQstnModFrm(examDtlId, qstnId) {
	    	if(!canQuizEdit("all")) {
	    		return false;
	    	}

	    	var qstnSeqno = $(".quizQstnSubList[data-qstnId='"+qstnId+"']").attr("data-qstnSeqno");
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
	    	$(".qstnFormDiv").remove();
	    	var qstnSeqno    	= $(".quizQstnSubList[data-qstnId='"+qstnId+"']").attr("data-qstnSeqno");					// 문항순번
	    	var qstnCnddtSeqno  = $(".quizQstnSubList[data-qstnId='"+qstnId+"']").attr("data-qstnCnddtSeqno");				// 문항후보순번
	    	var qstnScr 		= $(".quizQstnList[data-qstnSeqno='"+qstnSeqno+"']").find("input[name=qstnScr]").val();		// 문항기본점수
	    	qstnAddFrmInit(qstnSeqno);	// 문제 추가 폼 초기화

	    	$("#qstnWriteForm"+qstnSeqno+" input[name=qstnSeqno]").val(qstnSeqno);
	    	$("#qstnWriteForm"+qstnSeqno+" input[name=qstnCnddtSeqno]").val(qstnCnddtSeqno);
	    	$("#qstnWriteForm"+qstnSeqno+" input[name=qstnScr]").val(qstnScr);
	    	$("#qstnWriteForm"+qstnSeqno+" input[name=qstnTtl]").val(qstnSeqno+"-"+qstnCnddtSeqno+" <spring:message code='exam.label.qstn' />");/* 문제 */
	    	$("#qstnWriteForm"+qstnSeqno+" input[name=examBscId]").val("${vo.examBscId}");
	    	$("#qstnWriteForm"+qstnSeqno+" input[name=examDtlId]").val(examDtlId);
	    	$("#qstnWriteForm"+qstnSeqno+" input[name=qstnId]").val(qstnId);
	    	$("#qstnAddDiv"+qstnSeqno+" .addBtn").attr("href", "javascript:qstnModify(\"" + qstnSeqno + "\")");

	    	var editTitle = "<spring:message code='exam.button.qstn.edit' />";/* 문제 수정 */
	    	if(qstnCnddtSeqno > 1) {
	    		editTitle = "<spring:message code='exam.button.qstn.sub.edit' />";/* 후보 문제 수정 */
	    	}
	    	$("#qstnAddDiv"+qstnSeqno+" .qstnTitle").text(editTitle);
	    	$("#qstnAddDiv"+qstnSeqno+" .se-contents").focus();

	    	// 문항 정보 조회
	    	var url  = "/quiz/qstnSelectAjax.do";
			var data = {
				"examDtlId"	: examDtlId,
				"qstnId" 	: qstnId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var qstn = data.returnVO;
	        		// 공통 값 적용
	        		$("#qstnWriteForm"+qstnSeqno+" input[name=qstnTtl]").val(qstn.qstnTtl);
	        		$("#qstnWriteForm"+qstnSeqno+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("change");
	        		editorMap["editor"+qstnSeqno].insertHTML($.trim(qstn.qstnCts) == "" ? " " : qstn.qstnCts);
	        		// 단일, 다중선택형
	        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC") {
	        			$("#qstnAddDiv"+qstnSeqno+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
	        			qstn.vwitmList.forEach(function(v, i) {
	        				$("#qstnWriteForm"+qstnSeqno+"Vwitm_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts);
	        				$("#qstnWriteForm"+qstnSeqno+"VwitmSeqno_"+v.qstnVwitmSeqno).prop("checked", v.cransYn == "Y" ? true : false);
	        			});
	        		// OX선택형
	        		} else if(qstn.qstnRspnsTycd == "OX_CHC") {
						qstn.vwitmList.forEach(function(v, i) {
							if(v.cransYn == "Y") {
								if(v.qstnVwitmCts == "O") {
									$("#qstnWriteForm"+qstnSeqno+"_true").trigger("click");
								} else {
									$("#qstnWriteForm"+qstnSeqno+"_false").trigger("click");
								}
							}
						});
	        		// 연결형
	        		} else if(qstn.qstnRspnsTycd == "LINK") {
	        			$("#qstnAddDiv"+qstnSeqno+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
	        			qstn.vwitmList.forEach(function(v, i) {
	        				$("#qstnWriteForm"+qstnSeqno+"VwitmTtl_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts.split("|")[0]);
	        				$("#qstnWriteForm"+qstnSeqno+"VwitmCts_"+v.qstnVwitmSeqno).val(v.qstnVwitmCts.split("|")[1]);
	        			});
	        		// 단답형
	        		} else if(qstn.qstnRspnsTycd == "SHORT_TEXT") {
		        		$("#qstnAddDiv"+qstnSeqno+" input[name=cransTycd]:input[value='"+qstn.cransTycd+"']").trigger("click");
		        		qstn.vwitmList.forEach(function(v, i) {
							if(i > 0) {
								formOption.createTextQstnAddHTML("qstnWriteForm"+qstnSeqno);	// 단답형 문항 추가 HTML 추가
							}
							v.qstnVwitmCts.split("|").forEach(function(el, index) {
		        				$("#qstnWriteForm"+qstnSeqno+"QstnDiv .shortInput:nth-child("+(i+1)+")").find("input[name=qstnVwitmCts]:eq("+index+")").val(el);
		        			});
	        			});
	        		}
	        		$("#qstnWriteForm"+qstnSeqno+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("change");
	        		if($("#examQstnsCmptnyn").val() == "M" && ("${today}" > "${vo.examDtlVO.examPsblSdttm}" || "${vo.tkexamStrtUserCnt}" > 0)) {
	        			$("#qstnWriteForm"+qstnSeqno+" select[name=qstnRspnsTycd]").closest("div.dropdown").css("pointer-events", "none");
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
		 * @param {String} examDtlId	- 시험상세아이디
		 * @returns {list} 문항 목록
		 */
		 function qstnListSelect() {
			// 출제상태별 표시여부 변경
			const items = document.querySelectorAll('.examQstnsCmptnClass');

			items.forEach(item => {
				if($("#examQstnsCmptnyn").val() == "N") {
					item.classList.remove("hide");
				} else {
					item.classList.add("hide");
				}
			});

		 	var url  = "/quiz/quizQstnListAjax.do";
			var data = {
				"examDtlId" : $("#examDtlId").val()
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
		     		var qstnList = data.returnList || [];
		     		var isExamSubmit = $("#examQstnsCmptnyn").val() == "M" || $("#examQstnsCmptnyn").val() == "Y";	// 문제출제완료여부
		     		var linkQstnList = [];
		     		var totalScore = 0;
		     		$("#qstnCnt").text(qstnList.length > 0 ? qstnList[0].qstnCnt : 0);
		     		$("#qstnTotalScore").text(totalScore);

		     		if(qstnList.length > 0) {
		     			var html 	   = "";
		     			var qstnScr = 0;
		     			var examDtlId  = "";

		     			for(var i = 1; i <= qstnList[0].qstnCnt; i++) {
		        			qstnList.forEach(function(v, ii) {
		        				if(i == v.qstnSeqno && 1 == v.qstnCnddtSeqno) {
		        					totalScore += v.qstnScr;
		        					qstnScr = v.qstnScr;
		        					examDtlId = v.examDtlId;
		        				}
		        			});
		        			html += "<div class='border-1 margin-bottom-3 quizQstnList qstn" + i + "' data-qstnScr='" + qstnScr + "' data-qstnSeqno='" + i + "'>";
							html += "	<div class='board_top border-1 padding-3'>";
							html += "		<i class='xi-arrows icon-sort ui-sortable-handle'></i>";
							html += "		<span>" + i + "<spring:message code='exam.label.qstn' /></span>"; // 문제
							html += "		<div class='right-area'>";
							if(${today < vo.examDtlVO.examPsblSdttm }) {
								html += "		<a href='javascript:qstnAddFrmView(\"" + i + "\")' class='btn basic small'><spring:message code='exam.button.sub.qstn.add' /></a>";	// 후보 문항 추가
								html += "		<a href='javascript:qstnDelete(\"" + examDtlId + "\", \"" + i + "\", \"\")' class='btn basic small'>삭제</a>";
			        		}
			        		if(isExamSubmit) {
			        			html += "		<div class='ui input mr10' id='scoreDisplayDiv" + i + "'>";
				        		html += "			<span>" + qstnScr + "<spring:message code='exam.label.score.point' /></span>"; // 점
				        		html += "		</div>";
				        		html += "		<div class='ui input mr10' id='scoreInputDiv" + i + "' style='display:none;'>";
				        		html += "			<input type='text' id='editScore" + i + "' name='editScore' value='" + qstnScr + "' inputmask='numeric' mask='999.99' maxVal='100' onKeyup='scoreValidation(this);' onblur='scoreValidation(this); calcTotEditScore();' onfocus='this.select()' />";
				        		html += "			<input type='hidden' id='originScore" + i + "' value='" + qstnScr + "' />";
				        		html += "			<label class='ui label flex-none m0'><spring:message code='exam.label.score.point' /></label>"; // 점
				        		html += "		</div>";
			        		} else {
			        			html += "		<div class='ui input mr10' onclick='qstnScrModifyFrmView(this)'>";
				        		html += "			<span>" + qstnScr + "<spring:message code='exam.label.score.point' /></span>"; // 점
				        		html += "			<input type='text' name='qstnScr' style='display:none;' inputmask='numeric' mask='999.99' maxVal='100' value='" + qstnScr + "' />";
				        		html += "		</div>";
			        		}
							html += "		</div>";
							html += "	</div>";
							html += "	<div class='padding-3 margin-top-0 quizQstnDiv'>";
							qstnList.forEach(function(v, ii) {
			        			if(i == v.qstnSeqno) {
									html += "<div class='quizQstnSubList margin-top-3' data-qstnSeqno='" + v.qstnSeqno + "' data-qstnCnddtSeqno='" + v.qstnCnddtSeqno + "' data-qstnId='" + v.qstnId + "'>";
			        				html += "	<div class='flex align-items-center gap-2 margin-bottom-2'>";
			        				html += "		<i class='xi-arrows-v icon-chg'></i>";
			        				html += "		<a class='fcBlue' href='javascript:isExistQstnModFrm(\"" + v.examDtlId + "\", \"" + v.qstnId + "\")'>" + v.qstnSeqno + "-" + v.qstnCnddtSeqno + "</a>";
			        				html += "		<p class='flex-left-auto'>" + v.qstnRspnsTynm + "</p>";
			        				if(!isExamSubmit) {
			        					html += "	<a href='javascript:qstnDelete(\"" + v.examDtlId + "\", \"" + v.qstnSeqno + "\", \"" + v.qstnCnddtSeqno + "\")' class='btn basic small'><spring:message code='exam.button.del' /></a>";	// 삭제
			        				}
			        				html += "	</div>";
			        				html += 	previewOption.createQstnPreviewHTML(v);
			        				html += "</div>";
			        			}
			        		});
							html += "	</div>";
							html += "</div>";
		     			}
		     			$("#quizQstnDiv").empty().html(html);
		     			$("#qstnTotalScore").text(totalScore);

		     			$('#quizQstnDiv').sortable({
		     	            connectWith: '#quizQstnDiv',
		     	            placeholderClass: '.quizQstnList',
		     	            placeholder: "portlet-placeholder",
		     	            handle: ".icon-sort",
		     	            opacity: 0.6,
		     	            stop: function(event, ui) {
		     	            	qstnSeqnoChange(ui.item);	// 문항순번 변경
		     	            }
		     	        });

		     			$('.quizQstnDiv').sortable({
		     	            connectWith: '.quizQstnDiv',
		     	            placeholderClass: '.quizQstnSubList',
		     	            placeholder: "portlet-placeholder",
		     	            handle: ".icon-chg",
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
				UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
			}, true);
		}

		 /**
		 * 문항순번 변경
		 * @param {obj}  obj - 문항순번 변경할 문항
		 */
	    function qstnSeqnoChange(item) {
	    	if(!canQuizEdit("unsubmit")) {
	    		qstnListSelect();
	    		return false;
	    	}

	    	var qstnSeqno 	  	= item.attr("data-qstnSeqno");	// 문항순번
	    	var newqstnSeqno 	= 1;							// 변경할 문항순번

	    	$("div.quizQstnList").each(function(i) {
	    		if(qstnSeqno == $(this).attr("data-qstnSeqno")) {
	    			newqstnSeqno = i + 1;
	    		}
	    	});

	    	if(qstnSeqno != newqstnSeqno) {
	    		var url  = "/quiz/qstnSeqnoModifyAjax.do";
	    		var data = {
	    			"examDtlId"	: $("#examDtlId").val(),
	    			"qstnSeqno"	: newqstnSeqno,
	    			"searchKey" : qstnSeqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	            		qstnListSelect();
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("<spring:message code='exam.error.qstn.sort' />", "error");/* 문제 번호 변경 중 에러가 발생하였습니다. */
	    		}, true);
	    	}
	    }

	    /**
		 * 문항후보순번 변경
		 * @param {obj}  obj - 문항후보순번 변경할 문항
		 */
	    function qstnCnddtSeqnoChange(obj) {
	    	if(!canQuizEdit("unsubmit")) {
	    		qstnListSelect();
	    		return false;
	    	}

	    	var qstnId				= obj.attr("data-qstnId");				// 문항아이디
	    	var qstnSeqno   		= obj.attr("data-qstnSeqno");			// 문항순번
	    	var qstnCnddtSeqno  	= obj.attr("data-qstnCnddtSeqno");		// 문항후보순번
	    	var newQstnCnddtSeqno 	= 1;									// 변경할 문항후보순번

	    	// 변경할 순번값 찾기
	    	$("div.qstn"+qstnSeqno+" div.quizQstnSubList").each(function(i) {
	    		if(qstnCnddtSeqno == $(this).attr("data-qstnCnddtSeqno")) {
	    			newQstnCnddtSeqno = i + 1;
	    		}
	    	});

	    	if(qstnCnddtSeqno != newQstnCnddtSeqno) {
	    		var url  = "/quiz/qstnCnddtSeqnoModifyAjax.do";
	    		var data = {
	    			"examDtlId"	 		: $("#examDtlId").val(),
	    			"qstnId"			: qstnId,
	    			"qstnSeqno"	 		: qstnSeqno,
	    			"qstnCnddtSeqno" 	: newQstnCnddtSeqno
	    		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	            		qstnListSelect();
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	    		}, function(xhr, status, error) {
	    			UiComm.showMessage("<spring:message code='exam.error.sub.qstn.sort' />", "error");/* 후보 문항 순서 변경 중 에러가 발생하였습니다. */
	    		}, true);
	    	}
	    }

	    /**
		 * 문항 등록
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  qstnSeqno 	- 문항순번
		 */
		function qstnRegist(parentId, formId, qstnSeqno) {
			UiValidator(formId).then(function(result) {
				if (result) {
					if(!isValidQuizQstn(qstnSeqno || "")) {
					 	return false;
					}

					UiComm.showLoading(true);
					var url = "/quiz/quizQstnRegistAjax.do";

					$.ajax({
						url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#"+formId).serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
					 	if (data.result > 0) {
					 		qstnScrAutoGrnt($("#examDtlId").val());
					 		$("#"+parentId).remove();
					     } else {
					    	 UiComm.showMessage(data.message, "error");
					     }
					}).fail(function() {
						 UiComm.showLoading(false);
						 UiComm.showMessage("<spring:message code='exam.error.qstn.insert' />", "error");/* 문항 등록 중 에러가 발생하였습니다. */
					});
				}
			});
	    }

	    /**
		 * 문항 수정
		 * @param {String}  qstnSeqno 	- 문항순번
		 */
	    function qstnModify(qstnSeqno) {
	    	if(!isValidQuizQstn(qstnSeqno)) {
	    		return false;
	    	}

	    	tkexamUserCntSelect().done(function(returnVO) {
		    	if($("#examQstnsCmptnyn").val() == "M" && ("${today}" > "${vo.examDtlVO.examPsblSdttm}" || returnVO.result > 0)) {
		    		var kvArr = [];
		    		kvArr.push({'key' : 'qstnSeqno', 'val' : qstnSeqno});

		    		submitForm("/quiz/quizQstnEditOptionPop.do", "quizPopIfm", "qstnOption", kvArr);
		    	} else {
		    		UiComm.showLoading(true);
					var url = "/quiz/quizQstnModifyAjax.do";

					$.ajax({
			            url 	 : url,
			            async	 : false,
			            type 	 : "POST",
			            dataType : "json",
			            data 	 : $("#qstnWriteForm"+qstnSeqno).serialize(),
			        }).done(function(data) {
			        	UiComm.showLoading(false);
			        	if (data.result > 0) {
			        		qstnListSelect();
			        		$("#qstnAddDiv"+qstnSeqno).remove();
			            } else {
			            	UiComm.showMessage(data.message, "error");
			            }
			        }).fail(function() {
			        	UiComm.showLoading(false);
			        	UiComm.showMessage("<spring:message code='exam.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
			        });
		    	}
	    	});
	    }

	    // 문항 수정 옵션 포함 ( 미완료 )
	    function editQuizQstnOption(qstnSeqno, type) {
	    	$("#qstnWriteForm"+qstnSeqno).append("<input type='hidden' name='searchKey' value='"+type+"' />");
	    	UiComm.showLoading(true);
			var url = "/quiz/editQuizQstnOption.do";

			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : $("#qstnWriteForm"+qstnSeqno).serialize(),
	        }).done(function(data) {
	        	UiComm.showLoading(false);
	        	if (data.result > 0) {
	        		qstnListSelect();
	        		$("#qstnAddDiv"+qstnSeqno).remove();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
	        }).fail(function() {
	        	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='exam.error.qstn.update' />", "error");/* 문항 수정 중 에러가 발생하였습니다. */
	        });
	    }

	    /**
		 * 문항 삭제
		 * @param {String}  examDtlId 		- 시험상세아이디
		 * @param {String}  qstnSeqno 		- 문항순번
		 * @param {String}  qstnCnddtSeqno 	- 문항후보순번
		 */
	    function qstnDelete(examDtlId, qstnSeqno, qstnCnddtSeqno) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}

	    	// 시험응시자수 조회
	    	tkexamUserCntSelect().done(function(returnVO) {
		        var confirm = "";
		        if(returnVO.result > 0) {
		        	confirm = "<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.y' />";/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.\r\n정말 삭제하시겠습니까? */
		        } else {
		        	confirm = "<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />";/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
		        }
	    		UiComm.showMessage(confirm, "confirm")
	    		.then(function(result) {
	    			if (result) {
	    				var url  = "/quiz/quizQstnDeleteAjax.do";
			        	var data = {
			        			"examDtlId"	  		: examDtlId,
			        			"qstnSeqno" 		: qstnSeqno,
			        			"qstnCnddtSeqno" 	: qstnCnddtSeqno
			        		};

			        	ajaxCall(url, data, function(data) {
			        		if (data.result > 0) {
			        			UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success");/* 정상 삭제 되었습니다. */
			        	    	qstnScrAutoGrnt(examDtlId);
			        	    } else {
			        	    	UiComm.showMessage(data.message, "error");
			        	    }
			           	}, function(xhr, status, error) {
			           		UiComm.showMessage("<spring:message code='exam.error.qstn.delete' />", "error");/* 문항 삭제 중 에러가 발생하였습니다. */
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

	    	var data = "examBscId=${vo.examBscId}&sbjctId=${vo.sbjctId}&examDtlId="+$("#examDtlId").val();

			dialog = UiDialog("dialog1", {
				title: "문제 가져오기",
				width: 700,
				height: 650,
				url: "/quiz/profQuizQstnCopyPopup.do?"+data,
				autoresize: true
			});
	    }

	    /**
		 * 문항점수 자동 부여
		 * @param {String}  examDtlId 		- 시험상세아이디
		 * @param {Boolean} isConfirm 		- confirm 표시 여부
		 */
	    function qstnScrAutoGrnt(examDtlId, isConfirm) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}

	    	if(examDtlId == "") examDtlId = $("#examDtlId").val();

	    	if(isConfirm) {
	    		UiComm.showMessage("<spring:message code='exam.confirm.score.edit' />", "confirm")// 배점을 수정하겠습니까?
	    		.then(function(result) {
	    			if (!result) {
	    				return false;
	    			}
	    		});
	    	}

	    	var url  = "/quiz/quizQstnScrBulkModifyAjax.do";
	    	var data = {
	    		"examBscId" : "${vo.examBscId}",
	    		"examDtlId" : examDtlId
	   		};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		qstnListSelect();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.qstn.score.update' />", "error");/* 점수 수정 중 에러가 발생하였습니다. */
			}, true);
	    }

	 	// 출제완료문항점수자동배점
	    function cmptnYQstnScrAutoGrnt() {
	    	UiComm.showMessage("<spring:message code='exam.confirm.score.edit' />", "confirm")// 배점을 수정하겠습니까?
	    	.then(function(result) {
	    		if (result) {
	    			var url  = "/quiz/quizQstnScrBulkModifyAjax.do";
	    	    	var data = {
	    	    		"examBscId" : "${vo.examBscId}",
	    	    		"examDtlId" : $("#examDtlId").val()
	    	   		};

	    			ajaxCall(url, data, function(data) {
	    				if (data.result > 0) {
	    					cancelScoreEditMode();
	    	        		qstnListSelect();
	    	            } else {
	    	            	UiComm.showMessage(data.message, "error");
	    	            }
	    			}, function(xhr, status, error) {
	    				UiComm.showMessage("<spring:message code='exam.error.qstn.score.update' />", "error");// 점수 수정 중 에러가 발생하였습니다.
	    			}, true);
	    		}
	    	});
	    }

	    /**
		* 퀴즈 문항 유효성 검사
		* @param {String}  qstnSeqno - 문항순번
		*/
		function isValidQuizQstn(qstnSeqno) {
	    	var formId = "qstnWriteForm"+qstnSeqno;

			var qstnRspnsTycd = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
			$("#"+formId).find("input[type=hidden][name=cransTycd]").remove();
			$("#"+formId).find("input[name=qstns]").remove();

			const qstns = [];	// 문항 등록용

			// 단일, 다중선택형
			if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
				var isWholCrans = $("#"+formId).find("input[name=wholCrans]").prop("checked");	// 전체 정답처리 체크 여부
				if(!isWholCrans && $("#"+formId).find("input[name=qstnVwitmSeqno]:checked").length == 0) {
					UiComm.showMessage("<spring:message code='exam.alert.select.answer' />", "info");/* 정답을 선택하세요. */
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
				$("#"+formId+" .shortInput").each(function(i) {
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
					UiComm.showMessage("<spring:message code='exam.alert.select.answer' />", "info");/* 정답을 선택하세요. */
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

	    /**
		 * 문항점수 수정 폼 보기
		 * @param {obj}  obj	- 문항점수 수정객체
		 */
	    function qstnScrModifyFrmView(obj) {
	    	if(!canQuizEdit("unsubmit")) {
	    		return false;
	    	}
	    	$(obj).children("input").show();
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
				var qstnSeqno	= $(v).parents(".quizQstnList").attr("data-qstnSeqno");									// 문항순번
	        	var qstnScr		= $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("input[name=qstnScr]").val();	// 문항점수
	        	var isBoolean	= true;

	        	if(qstnScr == "") {
	        		UiComm.showMessage("<spring:message code='exam.alert.input.score' />", "info");// 점수를 입력하세요.
	        		isBoolean = false;
	        	} else if(qstnScr < 0 || qstnScr > 100) {
	        		UiComm.showMessage("<spring:message code='exam.alert.score.max.100' />", "info");// 점수는 100점 까지 입력 가능 합니다.
	        		isBoolean = false;
	        	}
	        	if(!isBoolean) {
	        		qstnListSelect();
	        	} else {
		        	var url  = "/quiz/quizQstnScrModifyAjax.do";
		    		var data = {
		        			"examBscId"	: "${vo.examBscId}",
		        			"examDtlId"	: $("#examDtlId").val(),
		        			"qstnSeqno" : qstnSeqno,
		        			"qstnScr"  	: qstnScr
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
		    			UiComm.showMessage("<spring:message code='exam.error.qstn.score.update' />", "error");/* 점수 수정 중 에러가 발생하였습니다. */
		    		}, true);
	        	}
			});
	    }

	    /**
		 * 퀴즈출제완료수정
		 * @param {String} type	- 저장 구분 ( save : 저장, edit : 수정 )
		 * @param {String} gbn	- 구분 ( bsc : 전체, dtl : 팀 )
		 */
	    function quizQstnsCmptnModify(type, gbn) {
			if($("#qstnTotalScore").text() != "100" && type == "save") {
				UiComm.showMessage("<spring:message code='exam.alert.score.ratio.100' />", "warning");/* 배점 점수가 100점과 맞지 않습니다. 다시 확인해 주세요. */
				return false;
			}

			if(SCORE_EDIT_MODE == true) {
				UiComm.showMessage("<spring:message code='exam.alert.score.edit.not.complete' />", "info");// 배점 일괄 수정 중입니다. <br/>배점 일괄 저장 또는 취소후 저장및출제 가능합니다.
				return false;
			}

			if(gbn != undefined && gbn == "bsc") {
				if(${not isQstnsCmptn}) {
					UiComm.showMessage("모든 팀의 문제를 출제완료 해주세요.", "info");
					return false;
				}
			}

			if(canQuizEdit("submit")) {
				// 미완료
				if(type == "edit" && "${vo.tkexamStrtUserCnt}" > 0) {
					var kvArr = [];
					kvArr.push({'key' : 'examBscId',  			'val' : "${vo.examBscId}"});
					kvArr.push({'key' : 'examDtlVO.examDtlId',  'val' : $("#examDtlId").val()});
					kvArr.push({'key' : 'examGbncd',   			'val' : "${vo.examGbncd}"});
					kvArr.push({'key' : 'searchGubun', 			'val' : type});
					kvArr.push({'key' : 'searchKey',   			'val' : gbn});

					submitForm("/quiz/profQuizQstnsCmptnModifyPopup.do", "quizPopIfm", "qstnEdit", kvArr);
				} else {
					var confirmMsg = "<spring:message code='exam.confirm.exam.qstn.submit' />"; // 문제를 출제하시겠습니까?
					if(type == "edit") {
						confirmMsg = "<spring:message code='exam.confirm.exam.qstn.edit' />"; // 문제를 수정하시겠습니까?
					}
					UiComm.showMessage(confirmMsg, "confirm")
					.then(function(result) {
						if (result) {
							var url  = "/quiz/quizQstnsCmptnModifyAjax.do";
							var data = {
								"examBscId"   			: "${vo.examBscId}",
								"examDtlVO.examDtlId"	: $("#examDtlId").val(),
								"examGbncd"				: "${vo.examGbncd}",
								"searchGubun" 			: type,
								"searchKey"				: gbn
							};

							$.ajax({
					            url 	 : url,
					            async	 : false,
					            type 	 : "POST",
					            dataType : "json",
					            data 	 : data,
					        }).done(function(data) {
					        	UiComm.showLoading(false);
					        	if (data.result > 0) {
					        		if(data.message != null) {
					        			UiComm.showMessage(data.message, "error");
									}

						        	var kvArr = [];
						        	kvArr.push({'key' : 'examBscId',   			'val' : "${vo.examBscId}"});
						        	kvArr.push({'key' : 'examDtlVO.examDtlId', 	'val' : $("#examDtlId").val()});

						        	submitForm("/quiz/profQuizQstnMngView.do", "", "", kvArr);
					            } else {
					            	UiComm.showMessage(data.message, "error");
					            }
					        }).fail(function() {
					        	UiComm.showLoading(false);
					        	UiComm.showMessage("<spring:message code='exam.error.qstn.submit' />", "error");/* 문항 출제 중 에러가 발생하였습니다. */
					        });
						}
					});
				}
			}
	    }

		// 문항엑셀업로드팝업 ( 미완료 )
	 	function qstnExcelUploadPopup() {
	 		if(!canQuizEdit("unsubmit")) {
	 			return false;
	 		}

			dialog = UiDialog("dialog1", {
				title: "엑셀 문항등록",
				width: 600,
				height: 500,
				url: "/quiz/profQuizQstnExcelUploadPopup.do?examDtlId="+$("#examDtlId").val(),
				autoresize: true
			});
	 	}

		/**
		* 퀴즈수정가능여부
		* @param {String} type - (unsubmit : 수정, submit : 제출완료, all : 전체)
		*/
		function canQuizEdit(type) {
			// 출제 완료 여부
			var isSubmit = $("#examQstnsCmptnyn").val() == "Y";
			// 제출 후 수정 여부
			var isTemp	 = $("#examQstnsCmptnyn").val() == "M";
			// 퀴즈 대기 여부
			var isWait   = "${today}" > "${vo.examDtlVO.examPsblSdttm}";
			if(isSubmit && type != "submit") {
				UiComm.showMessage("<spring:message code='exam.alert.click.edit.submit.btn' />", "info");/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
				return false;
			}
			if(isTemp && type == "unsubmit" && isWait) {
				UiComm.showMessage("<spring:message code='exam.alert.update.quiz.option' />", "info");/* 문제 수정만 가능합니다. */
				return false;
			}

			return true;
		}

		/**
		* 문항 추가 폼 제거
		* @param {String}  id - 제거할 문항 폼 아이디
		*/
	 	function qstnAddFrmRemove(id) {
	 		$("#"+id).remove();
	 	}

	 	// 시험응시 사용자수 조회
		function tkexamUserCntSelect() {
			var deferred = $.Deferred();

			var url = "/quiz/tkexamStrtUserCntSelectAjax.do";
			var data = {
	   			"examBscId" : "${vo.examBscId}",
	   			"examDtlId" : $("#examDtlId").val()
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

	 		var url  = "/quiz/quizSelectAjax.do";
			var data = {
	    		"examBscId" : "${vo.examBscId}"
	    	};

			tkexamUserCntSelect().done(function(returnVO) {
		        if(returnVO.result > 0) {
		        	UiComm.showMessage('<spring:message code="exam.error.submit.join.user" />', "info");// 시험 응시 학생이 있으므로 변경이 불가능합니다.
		     		return;
		     	}

		        // 점수편집 비활성화
		     	cancelScoreEditMode();

		     	// 점수 입력 활성화
		     	$.each($("input[name='editScore']"), function() {
		     		var index = this.id.replace("editScore", "");

		     		$("#scoreDisplayDiv" + index).hide();
		     		$("#scoreInputDiv" + index).show();

		     		// 탭 이벤트 활성화
		     		$("#editScore" + index).off("keydown.tab").on("keydown.tab", function(e) {
		     			if(e.keyCode == 9 && e.shiftKey) {
		     				e.preventDefault();

		     				var index = Number(this.id.replace("editScore", ""));
		     				var $prev = $("#editScore" + (index - 1));
		     				var maxLen = $("input[name='editScore']").length;

		     				if($prev.length != 1 && index == 0) {
		     					$prev = $("#editScore" + (maxLen - 1));
		     				}

		     				if($prev.length == 1) {
		     					$prev.focus().select();
		     				}
		     			} else if(e.keyCode == 9) {
		     				e.preventDefault();

		     				var index = Number(this.id.replace("editScore", ""));
		     				var $next = $("#editScore" + (index + 1));

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
		     	$("#changeScoreEditModeBtn").removeClass("blue").removeClass("orange");
		     	$("#changeScoreEditModeBtn").addClass("orange");
		     	$("#changeScoreEditModeBtn").text("<spring:message code='exam.button.batch.save.score' />"); // 배점 일괄 저장
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
				var index = this.id.replace("editScore", "");

				var originVal = $("#originScore" +  + index).val();

				// 입력창 hide
				$("#scoreDisplayDiv" + index).show();
				$("#scoreInputDiv" + index).hide();

				// 입력값 원복
				$(this).val(originVal);

				// 탭 이벤트 비활성화
				$("#editScore" + index).off("keydown.tab");
			});

	 		// 일괄 점수편집 버튼으로 변경
			$("#changeScoreEditModeBtn").removeClass("blue").removeClass("orange");
			$("#changeScoreEditModeBtn").addClass("blue");
			$("#changeScoreEditModeBtn").text("<spring:message code='exam.button.batch.edit.score' />"); // 배점 일괄 수정
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
			var changeScoreList = [];
			var isValid = true;
			var totalScr = 0;

			// 점수 입력 체크
			$.each($("input[name='editScore']"), function() {
				var index = this.id.replace("editScore", "");

				if(this.value == "") {
					UiComm.showMessage("<spring:message code='forum.alert.input.score' />", "info");// 점수를 입력하세요.
					isValid = false;
					$(this).focus();
					return false;
				}

				if(Number(this.value) > 100) {
					UiComm.showMessage("<spring:message code='common.pop.max.score.hundred' />", "info");// 점수는 100점 까지 입력 가능 합니다.
					isValid = false;
					$(this).focus();
					return false;
				}

				var qstnSeqno	= $(this).parents(".quizQstnList").attr("data-qstnSeqno");	// 문항순번
				var qstnScr = this.value;													// 문항점수

				changeScoreList.push({
        			"examDtlId"	: $("#examDtlId").val(),
        			"qstnSeqno" : qstnSeqno,
        			"qstnScr"  	: qstnScr
				});

				totalScr += Number(qstnScr);
			});

			if(totalScr != 100) {
				UiComm.showMessage("배점합계가 100점이 아닙니다.", "info");
				return false;
			}

			if(!isValid) return;

			UiComm.showMessage("<spring:message code='exam.confirm.score.edit' />", "confirm")// 배점을 수정하겠습니까?
			.then(function(result) {
				if (result) {
					var url = "/quiz/cmptnYQuizQstnScrBulkModifyAjax.do";

					$.ajax({
				        url 	  : url,
				        async	  : false,
				        type 	  : "POST",
				        dataType : "json",
				        data 	  : JSON.stringify(changeScoreList),
				        contentType: "application/json; charset=UTF-8",
				    }).done(function(data) {
				    	cancelScoreEditMode();

						UiComm.showMessage("<spring:message code='exam.alert.score.finish' />", "success");// 점수 등록이 완료되었습니다.

						qstnListSelect();
				    }).fail(function() {
				    	UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
				    });
				}
			});
		}

	 	var prevInputObj = {};
	 	function scoreValidation(obj) {
	 		var regex = /^\./;

	 		if(regex.test(obj.value)) {
	 			obj.value = "0" + obj.value;
	 		}

	 		// 100 이하의 정수 또는 소수점인지 확인
	 	    var regex = /^100(\.0+)?(\.\d{1,4})?$|^\d{0,2}(\.\d{0,2})?$/;

	 	    // 입력값이 정규식과 일치하지 않으면 이전 값으로 복원
	 	    if (!regex.test(obj.value)) {
	 	    	obj.value = prevInputObj[obj.name];
	 	    } else {
	 	    	prevInputObj[obj.name] = obj.value;
	 	    }
	 	}

	 	function calcTotEditScore() {
	 		var totScore = 0;

	 		$.each($("input[name='editScore']"), function() {
	 			var value = (this.value || 0) * 10;

	 			totScore += value;
			});

	 		$("#qstnTotalScore").text(totScore / 10);
	 	}

	 	/**
		* 퀴즈 팀 선택
		* @param {String}  examDtlId - 선택 팀에 대한 시험상세아이디
		*/
	 	function quizTeamSelect(examDtlId) {
			// 팀 버튼 색상 변경
			const teamButtons = document.querySelectorAll('[name="teamButton"]');
			teamButtons.forEach(button => {
			  button.classList.replace('type1', 'type2');
			});
			document.querySelector('button[name="teamButton"][value="' + examDtlId + '"]').classList.replace('type2', 'type1');

			$("#examDtlId").val(examDtlId);
			$("#qstnAddDiv").remove();

			// 문제 관리 버튼 변경
			var html = "";
			<c:forEach var="team" items="${quizTeamList }">
				if("${team.examDtlId}" == examDtlId) {
					$("#examQstnsCmptnyn").val("${team.examQstnsCmptnyn}");
					if("${team.examQstnsCmptnyn}" == "M") {
						html += "<a href='javascript:void(0)' id='changeScoreEditModeBtn' class='btn type1'>배점 일괄 수정</a>";
						html += "<a href='javascript:cancelScoreEditMode()' id='cancelScoreEditModeBtn' class='btn type1' style='display: none;'>취소</a>";
						html += "<a href='javascript:cmptnYQstnScrAutoGrnt(\"${vo.examBscId }\")' class='btn type1'>자동 배점</a>";
						html += "<a href='javascript:quizQstnsCmptnModify(\"save\", \"dtl\")' class='btn type1'>출제 완료</a>";
					} else if("${team.examQstnsCmptnyn}" == "Y") {
						html += "<a href='javascript:quizQstnsCmptnModify(\"edit\", \"dtl\")' class='btn type1'>수정</a>";
					} else {
						html += "<a href='javascript:qstnCopyPopup()' class='btn type1'>문제 가져오기</a>";
						html += "<a href='javascript:qstnExcelUploadPopup()' class='btn type1'>엑셀 문항등록</a>";
						html += "<a href='javascript:qstnScrAutoGrnt(\"\", true)' class='btn type1'>자동 배점</a>";
						html += "<a href='javascript:quizQstnsCmptnModify(\"save\", \"dtl\")' class='btn type1'>출제 완료</a>";
					}
				}
			</c:forEach>
			$("#qstnBtnDiv").empty().html(html);

			qstnListSelect();
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
					<div class="sub-content qstn">
						<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:quizViewMv(9)" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

						<div class="listTab">
					        <ul>
					            <li class="mw120"><a onclick="quizViewMv(3)">퀴즈정보 및 평가</a></li>
					            <li class="select mw120"><a onclick="quizViewMv(1)">문항관리</a></li>
					            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
						            <li class="mw120"><a onclick="quizViewMv(2)">재응시 관리</a></li>
					            </c:if>
					        </ul>
					    </div>

					    <div class="accordion">
							<div class="title flex">
								<div class="title_cont">
									<div class="left_cont">
										<div class="lectTit_box">
											<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
											<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
											<fmt:parseDate var="psblSdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.examPsblSdttm }" />
											<fmt:formatDate var="examPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${psblSdttmFmt }" />
											<fmt:parseDate var="psblEdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.examPsblEdttm }" />
											<fmt:formatDate var="examPsblEdttm" pattern="yyyy.MM.dd HH:mm" value="${psblEdttmFmt }" />
											<p class="lect_name">${fn:escapeXml(vo.examTtl) }</p>
											<span class="fcGrey">
												<small>응시기간 : ${examPsblSdttm } ~ ${examPsblEdttm }</small> |
												<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.mrkRfltyn eq 'Y' ? yes : no }</small> |
												<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.mrkOyn eq 'Y' ? yes : no }</small>
											</span>
										</div>
									</div>
								</div>
								<i class="dropdown icon ml20"></i>
							</div>
							<div class="content" style="padding:0;">
								<!--table-type-->
				        		<div class="table-wrap">
				        			<table class="table-type2">
				        				<colgroup>
				        					<col class="width-20per" />
				        					<col class="" />
				        				</colgroup>
				        				<tbody>
				        					<tr>
				        						<th><label>퀴즈내용</label></th>
				        						<td class="t_left" colspan="3"><pre>${vo.examCts }</pre></td>
				        					</tr>
				        					<tr>
				        						<th><label>응시기간</label></th>
				        						<td class="t_left" colspan="3">${examPsblSdttm } ~ ${examPsblEdttm }</td>
				        					</tr>
				        					<tr>
				        						<th><label>퀴즈시간</label></th>
				        						<td class="t_left" colspan="3">${vo.examDtlVO.examMnts }분</td>
				        					</tr>
				        					<tr>
				        						<th><label>성적반영</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
				        						<th><label>성적 반영비율</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? vo.examGbncd eq 'QUIZ_EXAM_MID' or vo.examGbncd eq 'QUIZ_EXAM_LST' ? '100' : vo.mrkRfltrt : '0' }%</td>
				        					</tr>
				        					<tr>
				        						<th><label>성적공개</label></th>
				        						<td class="t_left" colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>문제표시방식</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.qstnDsplyGbncd eq 'ALL' }">
															<spring:message code="exam.label.all.view.qstn" /><!-- 전체문제 표시 -->
														</c:when>
														<c:otherwise>
															<spring:message code="exam.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
														</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>문제 섞기</label></th>
				        						<td class="t_left" colspan="3">${vo.qstnRndmyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>보기 섞기</label></th>
				        						<td class="t_left" colspan="3">${vo.qstnVwitmRndmyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>첨부파일</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:if test="${not empty vo.fileList}">
														<div class="add_file_list">
															<uiex:filedownload fileList="${vo.fileList}"/>
														</div>
													</c:if>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>팀 퀴즈</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.examGbncd eq 'QUIZ_TEAM' }">

															<p>학습그룹 : ${vo.lrnGrpnm }</p>
															<p>학습그룹별 부 과제 설정 : ${vo.lrnGrpSubasmtStngyn eq 'Y' ? '사용' : '미사용' }</p>
															<c:if test="${vo.lrnGrpSubasmtStngyn eq 'Y' }">
																<table class="table-type2">
											        				<colgroup>
											        					<col class="width-10per" />
											        					<col class="" />
											        					<col class="width-20per" />
											        				</colgroup>
											        				<tbody id="quizSubAsmtTbody">
											        					<tr>
											        						<th><label>팀</label></th>
											        						<th><label>부주제</label></th>
											        						<th><label>학습그룹 구성원</label></th>
											        					</tr>
											        				</tbody>
											        			</table>
															</c:if>
														</c:when>
														<c:otherwise>${no }</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>재응시 사용</label></th>
				        						<td class="t_left" colspan="3">
				        							<p>${vo.examDtlVO.reexamyn eq 'Y' ? yes : no }</p>
													<c:if test="${vo.examDtlVO.reexamyn eq 'Y' }">
														<fmt:parseDate var="rePsblSdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.reexamPsblSdttm }" />
														<fmt:formatDate var="reexamPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${rePsblSdttmFmt }" />
														<fmt:parseDate var="rePsblEdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.reexamPsblEdttm }" />
														<fmt:formatDate var="reexamPsblEdttm" pattern="yyyy.MM.dd HH:mm" value="${rePsblEdttmFmt }" />
														<p>재응시 기간 : ${reexamPsblSdttm } ~ ${reexamPsblEdttm }</p>
														<p>재응시 적용률 : ${vo.examDtlVO.reexamMrkRfltrt }%</p>
													</c:if>
				        						</td>
				        					</tr>
				        				</tbody>
				        			</table>
				        		</div>
							</div>
						</div>

						<div class="board_top margin-top-4">
							<input type="hidden" id="examDtlId" value="${vo.examDtlVO.examDtlId }" />
							<input type="hidden" id="examQstnsCmptnyn" value="${vo.examDtlVO.examQstnsCmptnyn }" />
							<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
								<c:forEach var="item" items="${quizTeamList }">
									<button class="btn type2" name="teamButton" value="${item.examDtlId }" onclick="quizTeamSelect('${item.examDtlId }')">${item.teamnm }</button>
								</c:forEach>
								<div class="right-area">
									<c:choose>
										<c:when test="${vo.examQstnsCmptnyn eq 'Y' }">
											<a href="javascript:quizQstnsCmptnModify('edit', 'bsc')" class="btn type1">수정</a>
										</c:when>
										<c:otherwise>
											<a href="javascript:quizQstnsCmptnModify('save', 'bsc')" class="btn type1">출제 완료</a>
										</c:otherwise>
									</c:choose>
								</div>
							</c:if>
						</div>

						<div class="">
							<div class="board_top">
								<h3>출제 문제 : <span id="qstnCnt">0</span>문제</h3>
								<c:if test="${vo.examQstnsCmptnyn ne 'Y' || vo.examGbncd ne 'QUIZ_TEAM' }">
									<div class="right-area" id="qstnBtnDiv">
										<c:choose>
											<c:when test="${vo.examDtlVO.examQstnsCmptnyn eq 'M'}">
												<a href="javascript:void(0)" id="changeScoreEditModeBtn" class="btn type1">배점 일괄 수정</a>
										    	<a href="javascript:cancelScoreEditMode()" id="cancelScoreEditModeBtn" class="btn type1" style="display: none;">취소</a>
										    	<a href="javascript:cmptnYQstnScrAutoGrnt('${vo.examBscId }')" class="btn type1">자동 배점</a>
										    	<a href="javascript:quizQstnsCmptnModify('save', 'dtl')" class="btn type1">출제 완료</a>
											</c:when>
											<c:when test="${vo.examDtlVO.examQstnsCmptnyn eq 'Y'}">
												<a href="javascript:quizQstnsCmptnModify('edit', 'dtl')" class="btn type1">수정</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:qstnCopyPopup()" class="btn type1">문제 가져오기</a>
										        <a href="javascript:qstnExcelUploadPopup()" class="btn type1">엑셀 문항등록</a>
										        <a href="javascript:qstnScrAutoGrnt('', true)" class="btn type1">자동 배점</a>
										        <a href="javascript:quizQstnsCmptnModify('save', 'dtl')" class="btn type1">출제 완료</a>
											</c:otherwise>
										</c:choose>
									</div>
								</c:if>
							</div>

							<div class="grid-content modal-type ui-sortable ml0" id="quizQstnDiv"></div>

							<div class="flex flex-item-center">
								<div class="flex-highlight"></div>
								<a href="javascript:qstnAddFrmView('')" class="btn type1 examQstnsCmptnClass"><spring:message code="exam.button.qstn.add" /></a><!-- 문제 추가 -->
								<div class="flex-highlight text-right">
									<spring:message code="exam.label.gain.point" /><!-- 배점 --> <spring:message code="exam.label.sum.point" /><!-- 합계 --> : <span id="qstnTotalScore"></span> <spring:message code="exam.label.score.point" /><!-- 점 -->
								</div>
							</div>
						</div>

						<div class="fcBlue examQstnsCmptnClass">
							<p>* 출제완료 클릭 전에는 “임시저장” 상태입니다.</p>
							<p>* 문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요.</p>
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