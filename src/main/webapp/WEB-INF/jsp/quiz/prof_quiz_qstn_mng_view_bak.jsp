<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<style type="text/css">
	.ui.checkbox label.question.multi:before {
		border-radius: 0;
	}
	.ui.checkbox label.question.multi:after {
		border-radius: 0;
	}
	.ui.checkbox input:checked ~ label.question.multi:after {
		border-radius: 0;
	}
	.dark .line-sortable-box .inventory-list .slot.item-disabled {
		background: none;
	}
	.dark .line-sortable-box .inventory-list .slot {
		background: none;
	}
	.dark .line-sortable-box .inventory-list {
		background: none;
	}
	.dark .line-sortable-box .inventory-list .slot span {
		background: none;
	}
</style>
<script type="text/javascript">
	var SCORE_EDIT_MODE = false;

	$(document).ready(function() {
		if("${vo.lrnGrpSubasmtStngyn}" == "Y") {
			quizSubAsmtListSelect();
		}

		$("#changeScoreEditModeBtn").on("click", function() {
			changeScoreEditMode();
		});

		if("${vo.examGbncd}" == "QUIZ_TEAM") {
			$(`button[name=teamButton][value='\${vo.examDtlVO.examDtlId}']`).trigger("click");
		} else {
			qstnListSelect();
		}

		$(".accordion").accordion();
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
	        			html += "<li class='subQuizLi'>";
						html += "	<dl>";
						html += "		<dt>" + v.teamnm + "</dt>";
						html += "		<dd style='padding: 0;'>";
						html += "			<ul class='tbl'>";
						html += "				<li>";
						html += "					<dl>";
						html += "						<dt>주제</dt>";
						html += "						<dd>" + v.examTtl + "</dd>";
						html += "					</dl>";
						html += "				</li>";
						html += "				<li>";
						html += "					<dl>";
						html += "						<dt><spring:message code='exam.label.cts' /></dt>";/* 내용 */
						html += "						<dd><pre>" + v.examCts + "</pre></dd>";
						html += "					</dl>";
						html += "				</li>";
						html += "				<li>";
						html += "					<dl>";
						html += "						<dt><spring:message code='bbs.label.form_attach_file' /></dt>";/* 첨부파일 */
						html += "						<dd>";
						//html += "							<button class='ui icon small button' id='file_fileSn' title='파일다운로드' onclick='fileDown(\"" + ${list.fileSn } + "\", \"" + ${list.repoCd } + "\")'><i class='ion-android-download'></i></button>";
						html += "						</dd>";
						html += "					</dl>";
						html += "				</li>";
						html += "			</ul>";
						html += "		</dd>";
						html += "		<dt class='bcWhite'>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</dt>";
						html += "	</dl>";
						html += "</li>";
        			});
        		}
				/* byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}"); */

        		$("#quizSubAsmtUl").append(html);
			}
		});
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
    			html += "	<input type='hidden' name='qstnDfctlvTycd' />";
    			html += "	<input type='hidden' name='qstnScr'  	value='0' />";
    			html += "	<input type='hidden' name='qstnGbncd'	value='TXT' />";
    			html += "	<div class='flex gap4 mb10'>";
    			html += "		<select class='ui dropdown' name='qstnRspnsTycd' onchange='qstnRspnsTycdChgChange(\"" + parentId + "\", \"" + formId + "\")'>";
    							<c:forEach var="code" items="${qstnRspnsTycdList }">
    			html += "			<option value='${code.cd }'>${code.cdnm }</option>";
    							</c:forEach>
    			html += "		</select>";
    			html += "		<div class='field flex1 mb0'>";
    			html += "			<input type='text' name='qstnTtl'>";
    			html += "		</div>";
    			html += "	</div>";
    			html += "	<dl style='display:table;width:100%'>";
    			html += "		<dd style='display:table-cell;height:400px'>";
    			html += "			<div style='height:100%'>";
    			html += "				<textarea name='qstnCts' id=\"" + editorId + "\"></textarea>";
    			html += "			</div>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</form>";
	    		html += "<div class='field mt20 qstnTypeDiv'>";
	    		html += "	<ul class='tbl border-top-grey'></ul>";
	    		html += "</div>"
    		$("#"+parentId+" .ui.form.content").append(html);
		},
 		/**
		 * 문제 버튼 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createQstnBtnHTML: function(parentId, formId) {
			var html  = "<div class='option-content'>";
	    		html += "	<div class='mla'>";
	    		html += "		<a href='javascript:qstnRegist(\"" + parentId + "\", \"" + formId + "\")' class='ui blue button addBtn'><spring:message code='exam.button.save' /></a>";/* 저장 */
	    		html += "		<a href='javascript:qstnAddFrmRemove(\"" + parentId + "\")' class='ui basic button'><spring:message code='exam.button.cancel' /></a>";/* 취소 */
	    		html += "	</div>";
	    		html += "</div>";
	    	$("#"+parentId+" .ui.form.content").append(html);
		},
		/**
		 * 보기항목 수 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드
		 */
		createVwitmCntHTML: function(parentId, formId, type) {
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.qstn.item.cnt' /></label>";/* 보기 갯수 */
	    		html += "		</dt>";
	    		html += "		<dd>";
	    		html += "			<select class='ui dropdown w150' name='vwitmCnt' onchange='createVwitmCntChgHTML(\"" + parentId + "\", \"" + formId + "\", \"" + type + "\")'>";
	    							for(var idx = 2; idx <= 10; idx++) {
	    								var selected = (type == "ONE_CHC" || type == "MLT_CHC") && idx == 2 ? "selected" : "";
	    		html += "				<option value=\"" + idx + "\" " + selected + ">" + idx + "<spring:message code='exam.label.unit' /></option>";/* 개 */
	    							}
	    		html += "			</select>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
	    	$("#"+parentId+" .qstnTypeDiv > ul .dropdown").dropdown();
		},
		/**
		 * 단일, 다중선택형 문항 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드
		 */
		createChgQstnHTML: function(parentId) {
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='contLabel'><spring:message code='exam.label.qstn.item.input' /></label>";/* 보기 입력 */
	    		html += "		</dt>";
	    		html += "		<dd>";
	    		html += "			<ul class='tbl-simple dt-sm border-top-grey qstnItemUl'></ul>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    		html += "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='contLabel'>전체 정답처리</label>";
	    		html += "		</dt>";
	    		html += "		<dd>";
	    		html += "			<div class='ui toggle checkbox'>";
				html += "				<input type='checkbox' value='Y' name='wholCrans' />";
				html += "				<label></label>";
				html += "			</div>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		/**
		 * 단답형 문항 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createTextQstnHTML: function(parentId, formId) {
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
	    		html += "		</dt>";
	    		html += "		<dd id='"+formId+"QstnDiv'>";
	    		html += "			<div class='ui action fluid input mt10 shortInput gap8 flex-wrap'>";
	    		for(var i = 0; i < 5; i++) {
	    		html += "				<input type='text' name='qstnVwitmCts' style='max-width:8em'>";
	    		}
	    		html += "				<button class='ui icon button' onclick='formOption.createTextQstnAddHTML(\""+formId+"\")'><i class='plus icon'></i></button>";
	    		html += "			</div>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    		html += "<li id='"+formId+"ShortGubun'>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.answer.type' /></label>";/* 정답 유형 */
	    		html += "		</dt>";
	    		html += "		<dd>";
	    		html += "			<div class='fields'>";
	    		html += "				<div class='field'>";
	    		html += "					<div class='ui radio checkbox'>";
	    		html += "						<input type='radio' name='cransTycd' id='"+formId+"cransI' tabindex='0' class='hidden' value='cransInorder' checked>";
	    		html += "						<label for='"+formId+"cransI'><spring:message code='exam.label.answer.order' /></label>";/* 순서에 맞게 정답 */
	    		html += "					</div>";
	    		html += "				</div>";
	    		html += "				<div class='field'>";
	    		html += "					<div class='ui radio checkbox'>";
	    		html += "						<input type='radio' name='cransTycd' id='"+formId+"cransN' tabindex='0' class='hidden' value='cransNotInorder'>";
	    		html += "						<label for='"+formId+"cransN'><spring:message code='exam.label.answer.not.order' /></label>";/* 순서에 상관없이 정답 */
	    		html += "					</div>";
	    		html += "				</div>";
	    		html += "			</div>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
    		$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		/**
		 * OX선택형 문항 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createOxQstnHTML: function(parentId, formId) {
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
	    		html += "		</dt>";
	    		html += "		<dd>";
	    						for(var idx = 1; idx <= 2; idx++) {
	    							var oxClass = idx == 1 ? "true" : "false";
	    		html += "			<div class='w150 mr15 d-inline-block ui card'>";
	    		html += "				<div class='checkImg'>";
	    		html += "					<input id='"+formId+"_"+oxClass+"' name='qstnVwitmCts' type='radio' value='" + (idx == 1 ? "O" : "X") + "'>";
	    		html += "					<label class='imgChk "+oxClass+"' for='"+formId+"_"+oxClass+"'></label>";
	    		html += "				</div>";
	    		html += "			</div>";
	    						}
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		/**
		 * 연결형 문항 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		 createLinkQstnHTML: function(parentId, formId) {
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
	    		html += "		</dt>";
	    		html += "		<dd id='"+formId+"LinkDd'></dd>";
	    		html += "	</dl>";
	    		html += "</li>";
    		$("#"+parentId+" .qstnTypeDiv > ul").append(html);
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
			var html  = "<div class='ui action fluid input mt10 shortInput addShort gap8 flex-wrap' id='"+formId+"shortInput"+shortInputCnt+"'>";
				for(var i = 0; i < 5; i ++) {
				html += "	<input type='text' name='qstnVwitmCts' style='max-width:8em' />";
				}
				html += "	<button class='ui icon button' onclick='formOption.textQstnDelHTML(\""+formId+"\", "+shortInputCnt+")'><i class='minus icon'></i></button>";
				html += "	<button class='ui icon button' onclick='formOption.createTextQstnAddHTML(\""+formId+"\")'><i class='plus icon'></i></button>";
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
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
	    createQstnDfctlvHTML: function(parentId, formId) {
	    	var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'>난이도</label>";
	    		html += "		</dt>";
	    		html += "		<dd>";
	    		html += "			<select class='ui dropdown' id='"+formId+"QstnDfctlvTycd'>";
	    							<c:forEach var="code" items="${qstnDfctlvTycdList }">
	    		html += "				<option value='${code.cd }'>${code.cdnm }</option>";
	    							</c:forEach>
	    		html += "			</select>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
	    	$("#"+parentId+" .qstnTypeDiv > ul .dropdown").dropdown();
	    }
	};

	var previewOption = {
		/**
		 * 문항 미리보기 HTML 추가
		 * @param {obj}  item	- 문항 정보
		 */
		 createQstnPreviewHTML: function(item) {
			var	html  = "<div class='ui form qstnList mt10'>";
				html += "	<div class='ui card wmax qstnDiv question-box'>";
				html += "		<div class='fields content header2'>";
				html += "			<div class='field'>" + item.qstnTtl + "</div>";
				// 연결형
				if(item.qstnRspnsTycd == "LINK") {
					html += "		<div class='field mla'>";
					html += "			(<spring:message code='exam.label.qstn.match.info' />)";/* 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. */
					html += "		</div>";
				}
				html += "		</div>";
				html += "		<div class='content'>";
				html += "			<div class='mb20'>" + item.qstnCts + "</div>";
				// 단일, 다중선택형
				if(item.qstnRspnsTycd == "ONE_CHC" || item.qstnRspnsTycd == "MLT_CHC") {
					html += "			<div class='ui divider'></div>";
					html += "			<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
				// 서술형
				} else if(item.qstnRspnsTycd == "LONG_TEXT") {
					html += '		<textarea rows="3" maxlength="500"></textarea>';
				// 연결형
				} else if(item.qstnRspnsTycd == "LINK") {
					html += "		<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
				// OX선택형
				} else if(item.qstnRspnsTycd == "OX_CHC") {
					html += "		<div class='checkImg'>";
					html += "			<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
					html += "		</div>";
				// 단답형
				} else if(item.qstnRspnsTycd == "SHORT_TEXT") {
					html += "		<div id='vwitm_" + item.qstnId + "_" + item.qstnCnddtSeqno + "'></div>";
				}
				html += "		</div>";
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
	        var $containner = $("#previewMatchContainer" + qstnId);
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
								html += "<div class='field'>";
								html += "	<div class='ui checkbox'>";
								html += "		<input type='" + (qstnVO.qstnRspnsTycd == "MLT_CHC" ? "checkbox" : "radio") + "' name='preview_CHOICE_" + qstnVO.qstnSeqno + "_" + qstnVO.qstnCnddtSeqno + "' " + (v.cransYn == "Y" ? "checked" : "") + " />";
								html += "		<label class='question " + (qstnVO.qstnRspnsTycd == "MLT_CHC" ? "multi" : "") + " empl' data-value='" + (i+1) + "'>" + v.qstnVwitmCts + "</label>";
								html += "	</div>";
								html += "</div>";
							// OX선택형
		    				} else if(qstnVO.qstnRspnsTycd == "OX_CHC") {
								var oxClass = v.qstnVwitmCts == "O" ? "true" : "false";
								html += "<input id='preview_oxChk" + qstnVO.qstnSeqno + "_" + qstnVO.qstnCnddtSeqno + "_" + oxClass + "' type='radio' name='preview_oxChk" + qstnVO.qstnSeqno + "_" + qstnVO.qstnCnddtSeqno + "' " + (v.cransYn == "Y" ? "checked" : "") + " />";
								html += "<label class='imgChk " + oxClass +"' for='preview_oxChk" + qstnVO.qstnSeqno + "_" + qstnVO.qstnCnddtSeqno + "_" + oxClass + "'></label>";
							// 단답형
		    				} else if(qstnVO.qstnRspnsTycd == "SHORT_TEXT") {
								html += "<div class='equal width fields'>";
		    					html += "	<div class='field'>";
		    					html += "		<input type='text' value='" + v.qstnVwitmCts + "' maxlength='40' placeholder='" + v.qstnVwitmSeqno + "<spring:message code='exam.label.answer.no' />" + "' />"; // 번 답
		    					html += "	</div>";
		    					html += "</div>"
		    				// 연결형
		    				} else if(qstnVO.qstnRspnsTycd == "LINK") {
		    					linkVwHtml 		+= "<div class='line-box num0" + v.qstnVwitmSeqno + "'>";
								linkVwHtml 		+= "	<div class='question'><span>" + v.qstnVwitmCts.split("|")[0] + "</span></div>";
								linkVwHtml 		+= "	<div class='slot' name='match" + qstnVO.qstnId + "'></div>";
								linkVwHtml 		+= "</div>";
								linkCransHtml 	+= "<div class='slot' name='opposite" + qstnVO.qstnId + "'><span style='min-width:160px;'><i class='ion-arrow-move'></i>" + v.qstnVwitmCts.split("|")[1] + "</span></div>";
		    				}
						});

		    			// 연결형
		    			if(qstnVO.qstnRspnsTycd == "LINK") {
		    				html += "<div class='line-sortable-box' id='previewMatchContainer" + qstnVO.qstnId + "'>";
	    					html += "	<div class='account-list'>";
	    					html += 		linkVwHtml;
	    					html += "	</div>";
	    					html += "	<div class='inventory-list w200'>";
	    					html += 		linkCransHtml;
	    					html += "	</div>";
	    					html += "</div>";
		    			}
		    			$("#vwitm_"+qstnVO.qstnId+"_"+qstnVO.qstnCnddtSeqno).html(html);
		    		}
				}
			});
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
			"2" : "/quiz/profQuizRetkexamMngView.do",	// 퀴즈 재응시 관리 페이지
			"3" : "/quiz/quizScoreManage.do",			// 퀴즈 평가 관리 페이지
			"9" : "/quiz/profQuizListView.do"			// 퀴즈 목록 화면
		};

		var kvArr = [];
		kvArr.push({'key' : 'examBscId',   	'val' : "${vo.examBscId}"});
		kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

		submitForm(urlMap[tab], "", "", kvArr);
	}

    /**
	 * 보기항목 수 변경 HTML 추가
	 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
	 * @param {String}  formId 		- 문제 추가용 form 아이디
	 * @param {String}  type 		- 문항답변유형코드 ( ONE_CHC : 단일선택형, MLT_CHC : 다중선택형, LINK : 연결형 )
	 */
    function createVwitmCntChgHTML(parentId, formId, type) {
	    var vwitmCnt   = $("#"+parentId+" .qstnTypeDiv select[name=vwitmCnt]").val();	// 보기 항목 개수 selectBox
    	// 단일, 다중선택형
    	if(type == "ONE_CHC" || type == "MLT_CHC") {
	    	var vwitmLiCnt = $("#"+parentId+" .qstnItemUl .vwitmLi").length;	// 기존 보기항목 수

	    	if(vwitmLiCnt < vwitmCnt) {
		    	for(var i = vwitmLiCnt; i < vwitmCnt; i++) {
				   	var html  = "<li class='vwitmLi'>";
				   		html += "	<dl>";
				   		html += "		<dt>";
				   		// 다중선택형
				   		if(type == "MLT_CHC") {
				   		html += "			<div class='ui checkbox'>";
				   		html += "				<input type='checkbox' name='qstnVwitmSeqno' id='"+formId+"VwitmSeqno_"+(i+1)+"' value='"+(i+1)+"'>";
				   		// 단일선택형
				   		} else if(type == "ONE_CHC") {
				   		html += "			<div class='ui radio checkbox'>";
				   		html += "				<input type='radio' name='qstnVwitmSeqno' id='"+formId+"VwitmSeqno_"+(i+1)+"' value='"+(i+1)+"'>";
				   		}
				   		html += "				<label class='toggle_btn' for='"+formId+"VwitmSeqno_"+(i+1)+"'><spring:message code='exam.label.qstn.item' />"+(i+1)+"</label>";/* 보기 */
				   		html += "			</div>";
				   		html += "		</dt>";
				   		html += "		<dd><input type='text' name='qstnVwitmCts' id='"+formId+"Vwitm_"+(i+1)+"' /></dd>";
				   		html += "	</dl>";
				   		html += "</li>";
			    	$("#"+parentId+" .qstnItemUl").append(html);
		    	}
	    	} else if(vwitmLiCnt > vwitmCnt) {
		    	for(var i = vwitmLiCnt; i > vwitmCnt-1; i--) {
		    	 	$("#"+parentId+" .qstnItemUl .vwitmLi:eq("+i+")").remove();
		    	}
	    	}

	    // 연결형
    	} else if(type == "LINK") {
    		var vwitmDivCnt = $("#"+formId+"LinkDd .vwitmDiv").length;

    		if(vwitmDivCnt < vwitmCnt) {
    			for(var i = vwitmDivCnt; i < vwitmCnt; i++) {
    				var classNm = "num0"+(i+1);
    				var html  = "<div class='line-sortable-box vwitmDiv'>";
    					html += "	<div class='account-list p10'>";
    					html += "		<div class='line-box "+classNm+"'>";
    					html += "			<div class='question p20 pl45'>";
    					html += "				<input type='text' name='qstnVwitmTtl' id='"+formId+"VwitmTtl_"+(i+1)+"' placeholder='"+"<spring:message code='exam.label.qstn.item' /> <spring:message code='exam.label.input' />"+"'/>";/* 보기 *//* 입력 */
    					html += "			</div>";
    					html += "			<div class='slot'><input type='text' name='qstnVwitmCts' id='"+formId+"VwitmCts_"+(i+1)+"' placeholder='"+"<spring:message code='exam.label.input.answer' />"+"' /></div>";/* 정답 입력 */
    					html += "		</div>";
    					html += "	</div>";
    					html += "</div>";
    				$("#"+formId+"LinkDd").append(html);
    			}
    		} else if(vwitmDivCnt > vwitmCnt) {
    			for(var i = vwitmDivCnt; i > vwitmCnt-1; i--) {
    				$("#"+formId+"LinkDd .vwitmDiv:eq("+i+")").remove();
    			}
    		}
    	}
    }

    /**
	 * 문항답변유형코드 변경
	 * @param {String} parentId	- 문제 추가용 최상위 div 아이디
	 * @param {String} formId 	- 문제 추가용 form 아이디
	 */
    function qstnRspnsTycdChgChange(parentId, formId) {
    	$("#"+parentId+" .qstnTypeDiv > ul").empty();					// 문항보기항목 비우기

        var type = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
        // 단일선택형, 다중선택형
        if(type == "ONE_CHC" || type == "MLT_CHC") {
        	formOption.createVwitmCntHTML(parentId, formId, type);	// 보기항목 수 HTML 추가
        	formOption.createChgQstnHTML(parentId);					// 단일, 다중선택형 문항 HTML 추가
        	createVwitmCntChgHTML(parentId, formId, type);			// 보기항목 수 변경 HTML 추가
        // 단답형
        } else if(type == "SHORT_TEXT") {
        	formOption.createTextQstnHTML(parentId, formId);		// 단답형 문항 HTML 추가
        // OX선택형
        } else if(type == "OX_CHC") {
        	formOption.createOxQstnHTML(parentId, formId);			// OX선택형 문항 HTML 추가
        // 연결형
        } else if(type == "LINK") {
        	formOption.createVwitmCntHTML(parentId, formId, type);	// 보기항목 수 HTML 추가
        	formOption.createLinkQstnHTML(parentId, formId);		// 연결형 문항 HTML 추가
        	createVwitmCntChgHTML(parentId, formId, type);			// 보기항목 수 변경 HTML 추가
        }

        formOption.createQstnDfctlvHTML(parentId, formId);			// 문항 난이도 HTML 추가
    }

    /**
	 * 문제 추가 폼 초기화
	 * @param {String} qstnSeqno	- 문항순번
	 */
    function qstnAddFrmInit(qstnSeqno) {
		// 문제 추가용 최상위 div 아이디
    	var qstnDivId   = qstnSeqno == undefined ? "qstnAddDiv" : "qstnAddDiv_"+qstnSeqno;
    	var qstnHeader  = qstnSeqno == undefined ? "<spring:message code='exam.button.qstn.add' />"/* 문제 추가 */ : "<spring:message code='exam.button.qstn.sub.add' />";/* 후보 문제 추가 */
    	// 문제 추가용 form 아이디
    	var addFormId   = qstnSeqno == undefined ? "qstnWriteForm" : "qstnWriteForm_"+qstnSeqno;
    	// 문제 내용 에디터 저장 키 값
    	var editorKey   = qstnSeqno == undefined ? "editor" : "editor_"+qstnSeqno;
    	// 문제 내용 에디터 아이디
    	var editorId    = qstnSeqno == undefined ? "qstnCts" : "qstnCts"+qstnSeqno;
    	// 문제 추가 div 삽입 위치
    	var appendClass = qstnSeqno == undefined ? "layout2" : "qstn_"+qstnSeqno;

    	// 문제 추가 폼 삽입
    	$("#"+qstnDivId).remove();
    	var html  = "<div class='row wmax qstnFormDiv' id=\"" + qstnDivId + "\">";
    		html += "	<div class='col'>";
    		html += "		<div class='option-content header2'>";
    		html += "			<h3 class='qstnTitle'>" + qstnHeader + "</h3>";
    		html += "		</div>";
    		html += "		<div class='ui form content'>";
    		html += "		</div>";
    		html += "	</div>";
    		html += "</div>";
		$("."+appendClass).append(html);

		formOption.createQstnHeaderHTML(qstnDivId, addFormId, editorId);			// 문제 말머리 HTML 추가
		formOption.createQstnBtnHTML(qstnDivId, addFormId);							// 문제 버튼 HTML 추가
		editorMap[editorKey] = HtmlEditor(editorId, THEME_MODE, '/quiz', 'Y', 50);	// 문항내용 html 에디터 생성
		$("div[id^=new_]").css("z-index", "1");										// 문항답변유형코드 selectBox 가려짐 방지
		$("#"+qstnDivId+" .dropdown").dropdown();									// 문항답변유형코드 selectBox dropdown 적용
		qstnRspnsTycdChgChange(qstnDivId, addFormId);								// 문항답변유형코드 변경 이벤트
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
    	var formId  = qstnSeqno != undefined ? "qstnWriteForm_"+qstnSeqno : "qstnWriteForm";
    	var btnId   = qstnSeqno != undefined ? "qstnAddDiv_"+qstnSeqno : "qstnAddDiv";
    	var qstnCnt = qstnSeqno != undefined ? qstnSeqno : $(".quizQstnList").length + 1;
    	var qstnCnddtSeqno = qstnSeqno != undefined ? $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("div.quizQstnSubList").length + 1 : 1;
    	var score   = qstnSeqno != undefined ? $(".quizQstnList[data-qstnSeqno="+qstnSeqno+"]").find("input[name=qstnScr]").val() : 0;
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
    	if($("#qstnAddDiv_"+qstnSeqno).length == 0) {
    		qstnModFrmView(examDtlId, qstnId);	// 문제 수정 폼 보기
    	} else {
    		$("#qstnAddDiv_"+qstnSeqno).remove();
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

    	$("#qstnWriteForm_"+qstnSeqno+" input[name=qstnSeqno]").val(qstnSeqno);
    	$("#qstnWriteForm_"+qstnSeqno+" input[name=qstnCnddtSeqno]").val(qstnCnddtSeqno);
    	$("#qstnWriteForm_"+qstnSeqno+" input[name=qstnScr]").val(qstnScr);
    	$("#qstnWriteForm_"+qstnSeqno+" input[name=qstnTtl]").val(qstnSeqno+"-"+qstnCnddtSeqno+" <spring:message code='exam.label.qstn' />");/* 문제 */
    	$("#qstnWriteForm_"+qstnSeqno+" input[name=examBscId]").val("${vo.examBscId}");
    	$("#qstnWriteForm_"+qstnSeqno+" input[name=examDtlId]").val(examDtlId);
    	$("#qstnWriteForm_"+qstnSeqno+" input[name=qstnId]").val(qstnId);
    	$("#qstnAddDiv_"+qstnSeqno+" .addBtn").attr("href", "javascript:qstnModify(\"" + qstnSeqno + "\")");

    	var editTitle = "<spring:message code='exam.button.qstn.edit' />";/* 문제 수정 */
    	if(qstnCnddtSeqno > 1) {
    		editTitle = "<spring:message code='exam.button.qstn.sub.edit' />";/* 후보 문제 수정 */
    	}
    	$("#qstnAddDiv_"+qstnSeqno+" .qstnTitle").text(editTitle);
    	$("#qstnAddDiv_"+qstnSeqno+" .se-contents").focus();

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
        		$("#qstnWriteForm_"+qstnSeqno+" input[name=qstnTtl]").val(qstn.qstnTtl);
        		$("#qstnWriteForm_"+qstnSeqno+" select[name=qstnRspnsTycd]").val(qstn.qstnRspnsTycd).trigger("change");
        		editorMap["editor_"+qstnSeqno].insertHTML($.trim(qstn.qstnCts) == "" ? " " : qstn.qstnCts);
        		// 단일, 다중선택형
        		if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC") {
        			$("#qstnAddDiv_"+qstnSeqno+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
        			qstn.vwitmList.forEach(function(v, i) {
        				$("#qstnWriteForm_"+qstnSeqno+"Vwitm_"+v.qstnVwitmSeqno).val(_.unescape(v.qstnVwitmCts));
        				$("#qstnWriteForm_"+qstnSeqno+"VwitmSeqno_"+v.qstnVwitmSeqno).prop("checked", v.cransYn == "Y" ? true : false);
        			});
        		// OX선택형
        		} else if(qstn.qstnRspnsTycd == "OX_CHC") {
					qstn.vwitmList.forEach(function(v, i) {
						if(v.cransYn == "Y") {
							if(v.qstnVwitmCts == "O") {
								$("#qstnWriteForm_"+qstnSeqno+"_true").trigger("click");
							} else {
								$("#qstnWriteForm_"+qstnSeqno+"_false").trigger("click");
							}
						}
					});
        		// 연결형
        		} else if(qstn.qstnRspnsTycd == "LINK") {
        			$("#qstnAddDiv_"+qstnSeqno+" select[name=vwitmCnt]").val(qstn.vwitmList.length).trigger("change");
        			qstn.vwitmList.forEach(function(v, i) {
        				$("#qstnWriteForm_"+qstnSeqno+"VwitmTtl_"+v.qstnVwitmSeqno).val(_.unescape(v.qstnVwitmCts.split("|")[0]));
        				$("#qstnWriteForm_"+qstnSeqno+"VwitmCts_"+v.qstnVwitmSeqno).val(_.unescape(v.qstnVwitmCts.split("|")[1]));
        			});
        		// 단답형
        		} else if(qstn.qstnRspnsTycd == "SHORT_TEXT") {
	        		$("#qstnAddDiv_"+qstnSeqno+" input[name=cransTycd]:input[value='"+qstn.cransTycd+"']").trigger("click");
	        		qstn.vwitmList.forEach(function(v, i) {
						if(i > 0) {
							formOption.createTextQstnAddHTML("qstnWriteForm_"+qstnSeqno);	// 단답형 문항 추가 HTML 추가
						}
						v.qstnVwitmCts.split("|").forEach(function(el, index) {
	        				$("#qstnWriteForm_"+qstnSeqno+"QstnDiv .shortInput:nth-child("+(i+1)+")").find("input[name=qstnVwitmCts]:eq("+index+")").val(el);
	        			});
        			});
        		}
        		$("#qstnWriteForm_"+qstnSeqno+"QstnDfctlvTycd").val(qstn.qstnDfctlvTycd).trigger("change");
        		if("${vo.examDtlVO.examQstnsCmptnyn}" == "M" && ("${today}" > "${vo.examDtlVO.examPsblSdttm}" || "${vo.tkexamStrtUserCnt}" > 0)) {
        			$("#qstnWriteForm_"+qstnSeqno+" select[name=qstnRspnsTycd]").closest("div.dropdown").css("pointer-events", "none");
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
    }

    /**
	 * 문항 목록 조회
	 * @param {String} examDtlId	- 시험상세아이디
	 * @returns {list} 문항 목록
	 */
    function qstnListSelect() {
    	var url  = "/quiz/quizQstnListAjax.do";
		var data = {
			"examDtlId" : $("#examDtlId").val()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var qstnList = data.returnList || [];
        		var isExamSubmit = "${vo.examDtlVO.examQstnsCmptnyn}" == "M" || "${vo.examDtlVO.examQstnsCmptnyn}" == "Y";	// 문제출제완료여부
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
						html += "<div class='grid-content-box menu-nth-wrap quizQstnList qstn_" + i+ "' data-qstnScr='" + qstnScr + "' data-qstnSeqno='" + i + "'>";
		        		html += "	<div class='option-content gap8'>";
		        		html += "		<div class='more-btn'>";
		        		html += "			<i class='expand arrows alternate icon icon-sort ui-sortable-handle'></i>";
		        		html += 			i + "<spring:message code='exam.label.qstn' />"; // 문제
		        		html += "		</div>";
		        		html += "		<div class='mla'>";
		        		if(${today < vo.examDtlVO.examPsblSdttm }) {
							html += "		<a href='javascript:qstnAddFrmView(\"" + i + "\")' class='ui basic small button'><spring:message code='exam.button.sub.qstn.add' /></a>";	// 후보 문항 추가
							html += "		<a href='javascript:qstnDelete(\"" + examDtlId + "\", \"" + i + "\", \"\")' class='ui basic small button'>삭제</a>";
		        		}
		        		if(isExamSubmit) {
		        			html += "		<div class='ui input mr10' id='scoreDisplayDiv" + i + "'>";
			        		html += "			<span>" + qstnScr + "<spring:message code='exam.label.score.point' /></span>"; // 점
			        		html += "		</div>";
			        		html += "		<div class='ui input mr10' id='scoreInputDiv" + i + "' style='display:none;'>";
			        		html += "			<input type='text' id='editScore" + i + "' name='editScore' value='" + qstnScr + "' class='num' maxlength='4' onKeyup='scoreValidation(this);' onblur='scoreValidation(this); calcTotEditScore();' onfocus='this.select()' />";
			        		html += "			<input type='hidden' id='originScore" + i + "' value='" + qstnScr + "' />";
			        		html += "			<label class='ui label flex-none m0'><spring:message code='exam.label.score.point' /></label>"; // 점
			        		html += "		</div>";
		        		} else {
		        			html += "		<div class='ui input mr10' onclick='qstnScrModifyFrmView(this)'>";
			        		html += "			<span>" + qstnScr + "<spring:message code='exam.label.score.point' /></span>"; // 점
			        		html += "			<input type='number' name='qstnScr' style='display:none;' step='0.1' class='num' value='" + qstnScr + "' />";
			        		html += "		</div>";
		        		}
		        		html += "		</div>";
		        		html += "	</div>";
		        		html += "	<div class='mt10 sub-content wmax pl15 ui-sortable'>";
		        		qstnList.forEach(function(v, ii) {
		        			if(i == v.qstnSeqno) {
								html += "<div class='sub-content-box ui form m5 quizQstnSubList' data-qstnSeqno='" + v.qstnSeqno + "' data-qstnCnddtSeqno='" + v.qstnCnddtSeqno + "' data-qstnId='" + v.qstnId + "'>";
		        				html += "	<div class='fields m0 align-items-center gap8'>";
		        				html += "		<i class='arrows alternate vertical icon icon-chg'></i>";
		        				html += "		<div class='field fourteen wide tl'>";
		        				html += "			<a class='fcBlue' href='javascript:isExistQstnModFrm(\"" + v.examDtlId + "\", \"" + v.qstnId + "\")'>" + v.qstnSeqno + "-" + v.qstnCnddtSeqno + "</a>";
		        				html += "		</div>";
		        				html += "		<div class='field three wide tr'>" + v.qstnRspnsTynm + "</div>";
		        				if(isExamSubmit) {
		        					html += "	<div class='field two wide tc'></div>";
		        				} else {
		        					html += "	<div class='field two wide tc'>";
		        					html += "		<a href='javascript:qstnDelete(\"" + v.examDtlId + "\", \"" + v.qstnSeqno + "\", \"" + v.qstnCnddtSeqno + "\")' class='ui basic small button'><spring:message code='exam.button.del' /></a>";	// 삭제
			        				html += "	</div>";
		        				}
		        				html += "	</div>";
		        				html += 	previewOption.createQstnPreviewHTML(v);
		        				if(v.qstnRspnsTycd == "LINK") {
		        					linkQstnList.push(v.qstnId);
		        				}
		        				html += "</div>";
		        			}
		        		});
		        		html += "	</div>";
		        		html += "</div>";
        			}
        			$("#quizQstnDiv").empty().html(html);
        			$("#qstnTotalScore").text(totalScore);

        			$('.grid-content').sortable({
        	            connectWith: '.grid-content',
        	            placeholderClass: '.grid-content-box',
        	            placeholder: "portlet-placeholder",
        	            handle: ".icon-sort",
        	            opacity: 0.6,
        	            stop: function(event, ui) {
        	            	qstnSeqnoChange(ui.item);	// 문항순번 변경
        	            }
        	        });

        			$('.sub-content').sortable({
        	            connectWith: '.sub-content',
        	            placeholderClass: '.sub-content-box',
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

        			// 미리보기 연결형 문항 이벤트 추가
        			linkQstnList.forEach(function(qstnId) {
       					setTimeout(function() {
       						previewOption.createPreviewLinkQstnEvent(qstnId);
						}, 10);
           			});

       				$("#quizQstnDiv").find(".ui.checkbox").checkbox();
        		} else {
        			$("#quizQstnDiv").empty();
        		}
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
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
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.qstn.sort' />");/* 문제 번호 변경 중 에러가 발생하였습니다. */
    		});
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
    	$("div.qstn_"+qstnSeqno+" div.quizQstnSubList").each(function(i) {
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
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.sub.qstn.sort' />");/* 후보 문항 순서 변경 중 에러가 발생하였습니다. */
    		});
    	}
    }

    /**
	 * 문항 등록
	 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
	 * @param {String}  formId 		- 문제 추가용 form 아이디
	 * @param {String}  qstnSeqno 	- 문항순번
	 */
    function qstnRegist(parentId, formId, qstnSeqno) {
    	if(!isValidQuizQstn(qstnSeqno || "")) {
    		return false;
    	}

    	showLoading();
    	var url = "/quiz/quizQstnRegistAjax.do";

		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#"+formId).serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		qstnScrAutoGrnt($("#examDtlId").val());
        		$("#"+parentId).remove();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.qstn.insert' />");/* 문항 등록 중 에러가 발생하였습니다. */
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
	    	if("${vo.examDtlVO.examQstnsCmptnyn}" == "M" && ("${today}" > "${vo.examDtlVO.examPsblSdttm}" || returnVO.result > 0)) {
	    		var kvArr = [];
	    		kvArr.push({'key' : 'qstnSeqno', 'val' : qstnSeqno});

	    		submitForm("/quiz/quizQstnEditOptionPop.do", "quizPopIfm", "qstnOption", kvArr);
	    	} else {
		    	showLoading();
				var url = "/quiz/quizQstnModifyAjax.do";

				$.ajax({
		            url 	 : url,
		            async	 : false,
		            type 	 : "POST",
		            dataType : "json",
		            data 	 : $("#qstnWriteForm_"+qstnSeqno).serialize(),
		        }).done(function(data) {
		        	hideLoading();
		        	if (data.result > 0) {
		        		qstnListSelect();
		        		$("#qstnAddDiv_"+qstnSeqno).remove();
		            } else {
		             	alert(data.message);
		            }
		        }).fail(function() {
		        	hideLoading();
		        	alert("<spring:message code='exam.error.qstn.update' />");/* 문항 수정 중 에러가 발생하였습니다. */
		        });
	    	}
    	});
    }

    // 문항 수정 옵션 포함 ( 미완료 )
    function editQuizQstnOption(qstnSeqno, type) {
    	$("#qstnWriteForm_"+qstnSeqno).append("<input type='hidden' name='searchKey' value='"+type+"' />");
    	showLoading();
		var url = "/quiz/editQuizQstnOption.do";

		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#qstnWriteForm_"+qstnSeqno).serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		qstnListSelect();
        		$("#qstnAddDiv_"+qstnSeqno).remove();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.qstn.update' />");/* 문항 수정 중 에러가 발생하였습니다. */
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
	        	confirm = window.confirm(`<spring:message code="exam.label.quiz" /> <spring:message code="exam.confirm.exist.answer.user.y" />`);/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.\r\n정말 삭제하시겠습니까? */
	        } else {
	        	confirm = window.confirm("<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />");/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
	        }

	        if(confirm) {
	        	var url  = "/quiz/quizQstnDeleteAjax.do";
	        	var data = {
	        			"examDtlId"	  		: examDtlId,
	        			"qstnSeqno" 		: qstnSeqno,
	        			"qstnCnddtSeqno" 	: qstnCnddtSeqno
	        		};

	        	ajaxCall(url, data, function(data) {
	        		if (data.result > 0) {
	        	    		alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
	        	    		qstnScrAutoGrnt(examDtlId);
	        	        } else {
	        	         	alert(data.message);
	        	        }
	           	}, function(xhr, status, error) {
	           		alert("<spring:message code='exam.error.qstn.delete' />");/* 문항 삭제 중 에러가 발생하였습니다. */
	           	});
	        }
    	});
    }

 	// 문제 가져오기 팝업
    function qstnCopyPopup() {
    	if(!canQuizEdit("unsubmit")) {
    		return false;
    	}
    	var kvArr = [];
		kvArr.push({'key' : 'examBscId', 	'val' : "${vo.examBscId}"});
		kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

		submitForm("/quiz/profQuizQstnCopyPopup.do", "quizPopIfm", "copyQstn", kvArr);
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
    		// 배점을 수정하겠습니까?
    		if(!confirm("<spring:message code='exam.confirm.score.edit' />")) return false;
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
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.qstn.score.update' />");/* 점수 수정 중 에러가 발생하였습니다. */
		}, true);
    }

 	// 퀴즈 문항 점수 자동 배점 (출제 완료 후) ( 미완료 )
    function editqstnScrAllAfter() {
   		// 배점을 수정하겠습니까?
   		if(!confirm("<spring:message code='exam.confirm.score.edit' />")) return false;

    	var url  = "/quiz/updateQuizqstnScr.do";
    	var data = {
      		  "examBscId" : "${vo.examBscId}"
  			, "crsCreCd" : "${vo.crsCreCd}"
  		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				cancelScoreEditMode();
        		qstnListSelect();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.qstn.score.update' />"); // 점수 수정 중 에러가 발생하였습니다.
		}, true);
    }

    /**
	* 퀴즈 문항 유효성 검사
	* @param {String}  qstnSeqno - 문항순번
	*/
    function isValidQuizQstn(qstnSeqno) {
    	var parentId = qstnSeqno == "" ? "qstnAddDiv" : "qstnAddDiv_"+qstnSeqno;
    	var formId   = qstnSeqno == "" ? "qstnWriteForm" : "qstnWriteForm_"+qstnSeqno;
    	var editor   = editorMap[qstnSeqno == "" ? "editor" : "editor_"+qstnSeqno];
    	var isValid = true;
    	var qstnRspnsTycd = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
    	$("#"+formId).find("input[name=cransTycd]").remove();
    	$("#"+formId).find("input[name=qstns]").remove();

    	if(editor.isEmpty() || editor.getTextContent().trim() === "") {
    		alert("<spring:message code='exam.alert.input.contents' />");/* 내용을 입력하세요. */
    		return false;
    	}

    	const qstns = [];	// 문항 등록용

    	// 단일, 다중선택형
    	if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
			var isWholCrans = $("#"+parentId).find("input[name=wholCrans]").prop("checked");	// 전체 정답처리 체크 여부
    		if(!isWholCrans && $("#"+parentId).find("input[name=qstnVwitmSeqno]:checked").length == 0) {
				alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
				return false;
			}

			// 다중정답 처리
			if($("#"+parentId).find("input[name=qstnVwitmSeqno]:checked").length > 1 || isWholCrans) {
				$("#"+formId).append("<input type='hidden' name='cransTycd' value='CRANS_MLT' />");
			}

    		var vwitmCnt = $("#"+parentId+" select[name=vwitmCnt]").val();	// 보기항목수
    		for(var i = 1; i <= vwitmCnt; i++) {
    			if($("#"+formId+"Vwitm_"+i).val() == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				break;
    			}

    			const map = {
    				qstnVwitmSeqno: i,
    				cransYn: $("#"+formId+"VwitmSeqno_"+i).prop("checked") || $("#"+parentId).find("input[name=wholCrans]").prop("checked") ? "Y" : "N",
    				qstnVwitmCts: _.escape($("#"+formId+"Vwitm_"+i).val())
    			};

    			qstns.push(map);
    		}

    	// 단답형
    	} else if(qstnRspnsTycd == "SHORT_TEXT") {
    		$("#"+parentId+" .shortInput").each(function(i) {
	    		var qstnVwitmCts = "";
    			if($(this).find("input[name=qstnVwitmCts]").val() == "") {
    				alert((i+1)+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
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

    		var cransTycd = $("#"+parentId).find("input[name=cransTycd]:checked").val();
    		$("#"+formId).append("<input type='hidden' name='cransTycd' value='" + cransTycd + "' />");

    	// OX선택형
    	} else if(qstnRspnsTycd == "OX_CHC") {
    		if($("#"+parentId).find("input[name=qstnVwitmCts]:checked").length == 0) {
    			alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
    			return false;
    		}
    			$("#"+formId).append("<input type='hidden' name='rgtAnsr1' value=\"" + $("#"+parentId).find($("input[name=rgtAnsr1]:checked")).val() + "\" />");

	    	var vwitmCnt = $("#"+parentId).find("input[name=qstnVwitmCts]").length;	// 보기항목수
	        for(var i = 1; i <= vwitmCnt; i++) {
	        	const map = {
	        		qstnVwitmSeqno: i,
	        		cransYn: $("#"+parentId).find("input[name=qstnVwitmCts]").eq(i-1).prop("checked") ? "Y" : "N",
	        		qstnVwitmCts: $("#"+parentId).find("input[name=qstnVwitmCts]").eq(i-1).val()
	        	};

	        	qstns.push(map);
	        }

    	// 연결형
    	} else if(qstnRspnsTycd == "LINK") {
    		var vwitmCnt = $("#"+parentId+" select[name=vwitmCnt]").val();	// 보기항목수
    		for(var i = 1; i <= vwitmCnt; i++) {
    			if($("#"+formId+"VwitmTtl_"+i).val() == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			if($("#"+formId+"VwitmCts_"+i).val() == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}

    			const map = {
    				qstnVwitmSeqno: i,
    				cransYn: "Y",
    				qstnVwitmCts: $("#"+formId+"VwitmTtl_"+i).val() + "|" + $("#"+formId+"VwitmCts_"+i).val()
    			};

    			qstns.push(map);
    		}
    	}

    	$("#"+formId+" input[name=qstnDfctlvTycd]").val($("#"+formId+"QstnDfctlvTycd").val());
    	$("#"+formId).append("<input type='hidden' name='qstns' />");
		$("#"+parentId+" input[name=qstns]").val(JSON.stringify(qstns));

    	return isValid;
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
        		alert("<spring:message code='exam.alert.input.score' />"); // 점수를 입력하세요.
        		isBoolean = false;
        	} else if(qstnScr < 0 || qstnScr > 100) {
        		alert("<spring:message code='exam.alert.score.max.100' />"); // 점수는 100점 까지 입력 가능 합니다.
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
	                 	alert(data.message);
	                }
	    		}, function(xhr, status, error) {
	    			alert("<spring:message code='exam.error.qstn.score.update' />");/* 점수 수정 중 에러가 발생하였습니다. */
	    		});
        	}
		});
    }

    /**
	 * 퀴즈출제완료수정
	 * @param {String} type	- 저장 구분 ( save : 저장, edit : 수정 )
	 */
    function quizQstnsCmptnModify(type, gbn) {
		if($("#qstnTotalScore").text() != "100" && type == "save") {
			alert("<spring:message code='exam.alert.score.ratio.100' />");/* 배점 점수가 100점과 맞지 않습니다. 다시 확인해 주세요. */
			return false;
		}

		if(SCORE_EDIT_MODE == true) {
			alert("<spring:message code='exam.alert.score.edit.not.complete' />");// 배점 일괄 수정 중입니다. <br/>배점 일괄 저장 또는 취소후 저장및출제 가능합니다.
			return false;
		}

		if(gbn != undefined && gbn == "bsc") {
			if(${not isQstnsCmptn}) {
				alert("모든 팀의 문제를 출제완료 해주세요.");
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

				if(window.confirm(confirmMsg)) {
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
			        	hideLoading();
			        	if (data.result > 0) {
			        		if(data.message != null) {
							   	alert(data.message);
							}

				        	var kvArr = [];
				        	kvArr.push({'key' : 'examBscId',   			'val' : "${vo.examBscId}"});
				        	kvArr.push({'key' : 'examDtlVO.examDtlId', 	'val' : $("#examDtlId").val()});

				        	submitForm("/quiz/profQuizQstnMngView.do", "", "", kvArr);
			            } else {
			             	alert(data.message);
			            }
			        }).fail(function() {
			        	hideLoading();
			        	alert("<spring:message code='exam.error.qstn.submit' />");/* 문항 출제 중 에러가 발생하였습니다. */
			        });
				}
			}
		}
    }

	// 엑셀 문항 등록 ( 미완료 )
 	function quizQstnExcelUploadPop() {
 		if(!canQuizEdit("unsubmit")) {
 			return false;
 		}
		var kvArr = [];
		kvArr.push({'key' : 'examBscId', 'val' : "${vo.examBscId}"});

		submitForm("/quiz/quizQstnExcelUploadPop.do", "quizPopIfm", "excelUpload", kvArr);
 	}

	/**
	* 퀴즈수정가능여부
	* @param {String} type - (unsubmit : 수정, submit : 제출완료, all : 전체)
	*/
	function canQuizEdit(type) {
		// 출제 완료 여부
		var isSubmit = "${vo.examDtlVO.examQstnsCmptnyn}" == "Y";
		// 제출 후 수정 여부
		var isTemp	 = "${vo.examDtlVO.examQstnsCmptnyn}" == "M";
		// 퀴즈 대기 여부
		var isWait   = "${today}" > "${vo.examDtlVO.examPsblSdttm}";
		if(isSubmit && type != "submit") {
			alert("<spring:message code='exam.alert.click.edit.submit.btn' />");/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
			return false;
		}
		if(isTemp && type == "unsubmit" && isWait) {
			alert("<spring:message code='exam.alert.update.quiz.option' />");/* 문제 수정만 가능합니다. */
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
        		alert(data.message);
        		deferred.reject();
        	}
		}, function(xhr, status, error) {
			// 에러가 발생했습니다!
			alert('<spring:message code="fail.common.msg" />');
			deferred.reject();
		}, true);

		return deferred.promise();
	}

 	// 배점 일괄 수정 모드
 	function changeScoreEditMode() {
 		SCORE_EDIT_MODE = false;

 		if("${vo.examDtlVO.examQstnsCmptnyn}" == "Y") {
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
     				alert('<spring:message code="exam.error.submit.join.user" />'); // 시험 응시 학생이 있으므로 변경이 불가능합니다.
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
     				submitScoreBatch();
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

 	// 일괄 점수편집 저장
	function submitScoreBatch() {
		var changeScoreList = [];
		var isValid = true;

		// 점수 입력 체크
		$.each($("input[name='editScore']"), function() {
			var index = this.id.replace("editScore", "");

			if(this.value == "") {
				alert("<spring:message code='forum.alert.input.score' />"); // 점수를 입력하세요.
				isValid = false;
				$(this).focus();
				return false;
			}

			if(Number(this.value) > 100) {
				alert("<spring:message code='common.pop.max.score.hundred' />"); // 점수는 100점 까지 입력 가능 합니다.
				isValid = false;
				$(this).focus();
				return false;
			}

			var qstnIds = "" + $(this).data("editqstnSeqnos")
			var qstnScr = this.value;

			changeScoreList.push({
				  examBscId   : "${vo.examBscId}"
	   			, crsCreCd : "${vo.crsCreCd}"
				, qstnIds: qstnIds
				, qstnScr: qstnScr
			})
		});

		if(!isValid) return;

		// 배점을 수정하겠습니까?
   		if(!confirm("<spring:message code='exam.confirm.score.edit' />")) return false;

		var url = "/quiz/updateQuizqstnScrBatch.do";
		var data = JSON.stringify(changeScoreList);

		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				cancelScoreEditMode();

				// 점수 등록이 완료되었습니다.
				alert("<spring:message code='exam.alert.score.finish' />");

				qstnListSelect();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			// 에러가 발생했습니다!
			alert('<spring:message code="fail.common.msg" />');
		}, true, {
			  contentType: "application/json"
			, dataType: "json"
		});
	}

 	var prevInputObj = {};
 	function scoreValidation(obj) {
 		var regex = /^\./;

 		if(regex.test(obj.value)) {
 			obj.value = "0" + obj.value;
 		}

 		// 100 이하의 정수 또는 소수점인지 확인
 	    var regex = /^100(\.0+)?(\.\d{1,4})?$|^\d{0,2}(\.\d{0,1})?$/;

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
		$("#examDtlId").val(examDtlId);
		$("#qstnAddDiv").remove();

		// 문제 관리 버튼 변경
		var html = "";
		<c:forEach var="team" items="${quizTeamList }">
			if("${team.examDtlId}" == examDtlId) {
				if("${team.examQstnsCmptnyn}" == "M") {
					html += "<a href='javascript:void(0)' id='changeScoreEditModeBtn' class='ui blue small button'><spring:message code='exam.button.batch.edit.score' /></a>";/* 배점 일괄 수정 */
					html += "<a href='javascript:cancelScoreEditMode()' id='cancelScoreEditModeBtn' class='ui blue small button' style='display: none;'><spring:message code='exam.button.cancel' /></a>";/* 취소 */
					html += "<a href='javascript:editqstnScrAllAfter(\"${vo.examBscId }\")' class='ui blue small button'><spring:message code='exam.button.auto.score' /></a>";/* 자동 배점 */
					html += "<a href='javascript:quizQstnsCmptnModify(\"save\", \"dtl\")' class='ui blue small button'>출제 완료</a>";
				} else if("${team.examQstnsCmptnyn}" == "Y") {
					html += "<a href='javascript:quizQstnsCmptnModify(\"edit\", \"dtl\")' class='ui blue button'><spring:message code='exam.button.mod' /></a>";/* 수정 */
				} else {
					html += "<a href='javascript:qstnCopyPopup()' class='ui blue small button'><spring:message code='exam.label.qstn' /> <spring:message code='exam.label.copy' /></a>";/* 문제 *//* 가져오기 */
					html += "<a href='javascript:quizQstnExcelUploadPop()' class='ui blue small button'><spring:message code='exam.button.req.excel.qstn' /></a>";/* 엑셀 문항등록 */
					html += "<a href='javascript:qstnScrAutoGrnt(\"\", true)' class='ui blue small button'><spring:message code='exam.button.auto.score' /></a>";/* 자동 배점 */
					html += "<a href='javascript:quizQstnsCmptnModify(\"save\", \"dtl\")' class='ui blue small button'>출제 완료</a>";
				}
			}
		</c:forEach>
		$("#qstnBtnDiv").empty().html(html);

		qstnListSelect();
 	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">

        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

        		<div class="ui form">
        			<div class="layout2">
        				<script>
							$(document).ready(function () {
								// set location
								setLocationBar('<spring:message code="exam.label.quiz" />', '<spring:message code="eaxm.tab.qstn.manage" />'); // 퀴즈 문제 관리
							});
						</script>

		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
                            <div class="button-area">
							    <a href="javascript:quizViewMv(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
							</div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="listTab">
			                        <ul>
			                            <li class="select mw120"><a onclick="quizViewMv(1)"><spring:message code="eaxm.tab.qstn.manage" /></a></li><!-- 문제 관리 -->
			                            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
				                            <li class="mw120"><a onclick="quizViewMv(2)"><spring:message code="exam.tab.reexam.manage" /></a></li><!-- 미응시 관리 -->
			                            </c:if>
			                            <li class="mw120"><a onclick="quizViewMv(3)"><spring:message code="exam.label.info.score.manage" /></a></li><!-- 정보 및 평가 -->
			                        </ul>
			                    </div>
								<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
									<div class="title">
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
									<div class="content">
										<div class="ui segment">
											<ul class="tbl">
												<li>
													<dl>
														<dt>
															<label><spring:message code="crs.label.quiz_contents" /></label><!-- 퀴즈내용 -->
														</dt>
														<dd><pre>${vo.examCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label>응시기간</label>
														</dt>
														<dd>${examPsblSdttm } ~ ${examPsblEdttm }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="crs.label.quiz_time" /></label><!-- 퀴즈시간 -->
														</dt>
														<dd>${vo.examDtlVO.examMnts }<spring:message code="exam.label.stare.min" /></dd><!-- 분 -->
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="exam.label.score.aply.y" /></label><!-- 성적반영 -->
														</dt>
														<dd>${vo.mrkRfltyn eq 'Y' ? yes : no }</dd>
														<dt>
															<label><spring:message code="forum.label.score.ratio" /></label><!-- 성적 반영비율 -->
														</dt>
														<dd>${vo.mrkRfltyn eq 'Y' ? vo.examGbncd eq 'QUIZ_EXAM_MID' or vo.examGbncd eq 'QUIZ_EXAM_LST' ? '100' : vo.mrkRfltrt : '0' }%</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="exam.label.score.open.y" /></label><!-- 성적공개 -->
														</dt>
														<dd>${vo.mrkOyn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="exam.label.view.qstn.type" /></label><!-- 문제표시방식 -->
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.qstnDsplyGbncd eq 'ALL' }">
																	<spring:message code="exam.label.all.view.qstn" /><!-- 전체문제 표시 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="exam.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label>문제 섞기</label>
														</dt>
														<dd>${vo.qstnRndmyn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="exam.label.empl.random" /></label><!-- 보기 섞기 -->
														</dt>
														<dd>${vo.qstnVwitmRndmyn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
														</dt>
														<dd>
															<c:forEach var="list" items="${vo.fileList }">
																<button class="ui icon small button" id="file_${list.fileSn }" title="<spring:message code="asmnt.label.attachFile.download" />" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
																<script>
																	byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
																</script>
															</c:forEach>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label>팀 퀴즈</label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.examGbncd eq 'QUIZ_TEAM' }">
																	<p>학습그룹 : ${vo.lrnGrpnm }</p>
																	<div class="ui segment">
																		<p>학습그룹별 부 과제 설정 : ${vo.lrnGrpSubasmtStngyn eq 'Y' ? '사용' : '미사용' }</p>
																		<c:if test="${vo.lrnGrpSubasmtStngyn eq 'Y' }">
																			<ul class="tbl border-top-grey" id="quizSubAsmtUl">
																				<li>
																					<dl>
																						<dt class="bcLgrey">팀</dt>
																						<dd class="bcLgrey">부 과제</dd>
																						<dt class="bcLgrey">학습그룹 구성원</dt>
																					</dl>
																				</li>
																			</ul>
																		</c:if>
																	</div>
																</c:when>
																<c:otherwise>${no }</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label>재응시 사용</label>
														</dt>
														<dd>
															<p>${vo.examDtlVO.reexamyn eq 'Y' ? yes : no }</p>
															<c:if test="${vo.examDtlVO.reexamyn eq 'Y' }">
																<fmt:parseDate var="rePsblSdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.reexamPsblSdttm }" />
																<fmt:formatDate var="reexamPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${rePsblSdttmFmt }" />
																<fmt:parseDate var="rePsblEdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.reexamPsblEdttm }" />
																<fmt:formatDate var="reexamPsblEdttm" pattern="yyyy.MM.dd HH:mm" value="${rePsblEdttmFmt }" />
																<p>재응시 기간 : ${reexamPsblSdttm } ~ ${reexamPsblEdttm }</p>
																<p>재응시 적용률 : ${vo.examDtlVO.reexamMrkRfltrt }%</p>
															</c:if>
														</dd>
													</dl>
												</li>
											</ul>
										</div>
									</div>
								</div>

								<div class="btn_area option-content">
									<input type="hidden" id="examDtlId" value="${vo.examDtlVO.examDtlId }" />
									<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
										<c:forEach var="item" items="${quizTeamList }">
											<button class="ui button basic" name="teamButton" value="${item.examDtlId }" onclick="quizTeamSelect('${item.examDtlId }')">${item.teamnm }</button>
										</c:forEach>
										<c:choose>
											<c:when test="${vo.examQstnsCmptnyn eq 'Y' }">
												<a href="javascript:quizQstnsCmptnModify('edit', 'bsc')" class="ui blue small button mla">수정</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:quizQstnsCmptnModify('save', 'bsc')" class="ui blue small button mla">출제 완료</a>
											</c:otherwise>
										</c:choose>
									</c:if>
			                    </div>
								<div class="option-content header2">
									<h3>출제 <spring:message code="exam.label.qstn" /> : <span id="qstnCnt">0</span><spring:message code="exam.label.qstn" /></h3><!-- 전체 --><!-- 문제 --><!-- 문제 -->
								    <c:if test="${vo.examQstnsCmptnyn ne 'Y' || vo.examGbncd ne 'QUIZ_TEAM' }">
								    	<div class="mla" id="qstnBtnDiv">
									    	<c:choose>
									    		<c:when test="${vo.examDtlVO.examQstnsCmptnyn eq 'M'}">
										    		<a href="javascript:void(0)" id="changeScoreEditModeBtn" class="ui blue small button"><spring:message code="exam.button.batch.edit.score" /></a><!-- 배점 일괄 수정 -->
											    	<a href="javascript:cancelScoreEditMode()" id="cancelScoreEditModeBtn" class="ui blue small button" style="display: none;"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
											    	<a href="javascript:editqstnScrAllAfter('${vo.examBscId }')" class="ui blue small button"><spring:message code="exam.button.auto.score" /></a><!-- 자동 배점 -->
											    	<a href="javascript:quizQstnsCmptnModify('save', 'dtl')" class="ui blue small button">출제 완료</a>
									    		</c:when>
									    		<c:when test="${vo.examDtlVO.examQstnsCmptnyn eq 'Y'}">
									    			<a href="javascript:quizQstnsCmptnModify('edit', 'dtl')" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
									    		</c:when>
									    		<c:otherwise>
									    			<a href="javascript:qstnCopyPopup()" class="ui blue small button"><spring:message code="exam.label.qstn" /> <spring:message code="exam.label.copy" /></a><!-- 문제 --><!-- 가져오기 -->
											        <a href="javascript:quizQstnExcelUploadPop()" class="ui blue small button"><spring:message code="exam.button.req.excel.qstn" /></a><!-- 엑셀 문항등록 -->
											        <a href="javascript:qstnScrAutoGrnt('', true)" class="ui blue small button"><spring:message code="exam.button.auto.score" /></a><!-- 자동 배점 -->
											        <a href="javascript:quizQstnsCmptnModify('save', 'dtl')" class="ui blue small button">출제 완료</a>
									    		</c:otherwise>
									    	</c:choose>
								    	</div>
								    </c:if>
								</div>
								<div class="grid-content modal-type ui-sortable ml0" id="quizQstnDiv"></div>

								<div class="tc">
									<c:if test="${vo.examDtlVO.examQstnsCmptnyn ne 'Y' and vo.examDtlVO.examQstnsCmptnyn ne 'M'}">
										<a href="javascript:qstnAddFrmView()" class="ui blue small button"><spring:message code="exam.button.qstn.add" /></a><!-- 문제 추가 -->
									</c:if>
									<div class="f110 d-inline-block fr">
										<spring:message code="exam.label.gain.point" /><!-- 배점 --> <spring:message code="exam.label.sum.point" /><!-- 합게 --> : <span id="qstnTotalScore"></span> <spring:message code="exam.label.score.point" /><!-- 점 -->
									</div>
								</div>
		                	</div>
		                </div>
						<c:if test="${vo.examDtlVO.examQstnsCmptnyn ne 'Y' and vo.examDtlVO.examQstnsCmptnyn ne 'M'}">
							<div>
								<p>* 출제완료 클릭 전에는 “임시저장” 상태입니다.</p>
								<p>* 문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요.</p>
							</div>
						</c:if>
        			</div>
        		</div>
			</div>
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>