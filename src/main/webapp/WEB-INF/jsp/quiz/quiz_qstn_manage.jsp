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
		$("#changeScoreEditModeBtn").on("click", function() {
			changeScoreEditMode();
		});

		listQuizQstn();

		$(".accordion").accordion();
	});
	var editorMap = {};

	var formOption = {
		// 타이틀 추가
		addHeader: function(parentId, formId, editorId) {
			var html  = "<form id=\"" + formId + "\">";
    			html += "	<input type='hidden' name='examCd' />";
    			html += "	<input type='hidden' name='examQstnSn' />";
    			html += "	<input type='hidden' name='qstnScore'   value='0' />";
    			html += "	<input type='hidden' name='qstnNo' />";
    			html += "	<input type='hidden' name='subNo' />";
    			html += "	<input type='hidden' name='qstnDiff'    value='ALL' />";
    			html += "	<input type='hidden' name='searchGubun' value='ADD' />";
    			html += "	<div class='flex gap4 mb10'>";
    			html += "		<select class='ui dropdown' name='qstnTypeCd' onchange='qstnTypeChg(\"" + parentId + "\", \"" + formId + "\")'>";
    							<c:forEach var="code" items="${qstnTypeList }">
    			html += "			<option value='${code.codeCd }'>${code.codeNm }</option>";
    							</c:forEach>
    			html += "		</select>";
    			html += "		<div class='field flex1 mb0'>";
    			html += "			<input type='text' name='title'>";
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
	    		html += "<div class='ui small error message' id='shortInfoDiv'><i class='info circle icon'></i><spring:message code='exam.label.qstn.short.info' /></div>";/* 유사답안 입력은 5개 까지 가능합니다. */

	    		html += "<div class='mt20 tr'>";
	    		html += "<div id='japanInputCheckBox' class='ui checkbox checked'>";
	    		html += "<input id='japanInputCheck' type='checkbox' tabindex='0' class='hidden'>";
	    		html += "<label for='japanInputCheck'><spring:message code='common.button.japanese'/><!-- 일본어 --></label>";
	    		html += "</div></div>";

	    		html += "<div class='field mt20 qstnTypeDiv'>";
	    		html += "	<ul class='tbl border-top-grey'></ul>";
	    		html += "</div>"
    		$("#"+parentId+" .ui.form.content").append(html);

    		$("#japanInputCheck").change(function(){
    	        if($("#japanInputCheck").is(":checked")){
    	            $(".button.japanInput").show();
    	        } else{
    	        	$(".button.japanInput").hide();
    	        }
    	    });
		},
		// 등록 폼 버튼 추가
		addBtn: function(parentId, formId) {
			var html  = "<div class='option-content'>";
	    		html += "	<div class='mla'>";
	    		html += "		<a href='javascript:writeQuizQstn(\"" + parentId + "\", \"" + formId + "\")' class='ui blue button addBtn'><spring:message code='exam.button.save' /></a>";/* 저장 */
	    		html += "		<a href='javascript:writeQuizQstnCancel(\"" + parentId + "\")' class='ui basic button'><spring:message code='exam.button.cancel' /></a>";/* 취소 */
	    		html += "	</div>";
	    		html += "</div>";
	    	$("#"+parentId+" .ui.form.content").append(html);
		},
		// 보기 개수 박스 추가
		addEmplCnt: function(parentId, formId) {
			var type = $("#"+formId+" select[name=qstnTypeCd]").val();
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.qstn.item.cnt' /></label>";/* 보기 갯수 */
	    		html += "		</dt>";
	    		html += "		<dd>";
	    		html += "			<select class='ui dropdown w150' name='emplCnt' onchange='quizQstnChg(\"" + parentId + "\", \"" + formId + "\")'>";
	    							for(var idx = 2; idx <= 10; idx++) {
	    								var selected = (type == "CHOICE" || type == "MULTICHOICE") && idx == 4 ? "selected" : "";
	    		html += "				<option value=\"" + idx + "\" " + selected + ">" + idx + "<spring:message code='exam.label.unit' /></option>";/* 개 */
	    							}
	    		html += "			</select>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
	    	$("#"+parentId+" .qstnTypeDiv > ul .dropdown").dropdown();
		},
		// 단일 선택, 선다형 보기 폼
		addChoiceForm: function(parentId) {
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
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		// 단답형 입력 폼
		addShortForm: function(parentId, formId) {
			var rgtAnsrCnt = $("#"+parentId+" .shortInput").length + 1;
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
	    		html += "		</dt>";
	    		html += "		<dd id='"+formId+"QstnDiv'>";
	    		html += "			<div class='ui action fluid input mt10 shortInput gap8 flex-wrap'>";
	    		for(var i = 0; i < 5; i++) {
	    		html += "				<input type='text' name='rgtAnsr"+rgtAnsrCnt+"' class='japanInput' style='max-width:8em'>";
	    		}
	    		html += "				<button class='ui icon button' onclick='formOption.addQstnInput(\""+formId+"\")'><i class='plus icon'></i></button>";
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
	    		html += "						<input type='radio' name='multiRgtChoiceTypeCd' id='"+formId+"multiTypeA' tabindex='0' class='hidden' value='A' checked>";
	    		html += "						<label for='"+formId+"multiTypeA'><spring:message code='exam.label.answer.order' /></label>";/* 순서에 맞게 정답 */
	    		html += "					</div>";
	    		html += "				</div>";
	    		html += "				<div class='field'>";
	    		html += "					<div class='ui radio checkbox'>";
	    		html += "						<input type='radio' name='multiRgtChoiceTypeCd' id='"+formId+"multiTypeB' tabindex='0' class='hidden' value='B'>";
	    		html += "						<label for='"+formId+"multiTypeB'><spring:message code='exam.label.answer.not.order' /></label>";/* 순서에 상관없이 정답 */
	    		html += "					</div>";
	    		html += "				</div>";
	    		html += "			</div>";
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
    		$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		// OX형 선택 폼
		addOXForm: function(parentId, formId) {
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
	    		html += "					<input id='"+formId+"_"+oxClass+"' name='rgtAnsr1' type='radio' value=\"" + idx + "\">";
	    		html += "					<label class='imgChk "+oxClass+"' for='"+formId+"_"+oxClass+"'></label>";
	    		html += "				</div>";
	    		html += "			</div>";
	    						}
	    		html += "		</dd>";
	    		html += "	</dl>";
	    		html += "</li>";
	    	$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		// 짝짓기 선택 폼
		addMatchForm: function(parentId, formId) {
			var html  = "<li>";
	    		html += "	<dl>";
	    		html += "		<dt>";
	    		html += "			<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
	    		html += "		</dt>";
	    		html += "		<dd id='"+formId+"MatchDd'></dd>";
	    		html += "	</dl>";
	    		html += "</li>";
    		$("#"+parentId+" .qstnTypeDiv > ul").append(html);
		},
		// 주관식(단답형) 문항 추가
		addQstnInput: function(formId) {
			var shortInputCnt = $(".shortInput").length;
			if(shortInputCnt == 5) {
				return false;
			}
			var html  = "<div class='ui action fluid input mt10 shortInput addShort gap8 flex-wrap' id='"+formId+"shortInput"+shortInputCnt+"'>";
				for(var i = 0; i < 5; i ++) {
				html += "	<input type='text' name='rgtAnsr"+(shortInputCnt+1)+"' class='japanInput' style='max-width:8em' />";
				}
				html += "	<button class='ui icon button' onclick='formOption.delQstnInput(\""+formId+"\", "+shortInputCnt+")'><i class='minus icon'></i></button>";
				html += "	<button class='ui icon button' onclick='formOption.addQstnInput(\""+formId+"\")'><i class='plus icon'></i></button>";
				html += "</div>";
			$("#"+formId+"QstnDiv").append(html);
			// 일본어입력기 적용
	    	setJapaneseInput();
		},
		// 주관식(단답형) 문항 제거
	    delQstnInput: function(formId, cnt) {
	    	$("#"+formId+"QstnDiv input[name^=rgtAnsr]").each(function(i, v) {
	    		var thisCnt = $(v).attr("name").substring(7);
	    		if(thisCnt > (parseInt(cnt)+1)) {
	    			$(v).attr("name", "rgtAnsr"+(parseInt(thisCnt)-1));
	    		}
	    	});
	    	$("#"+formId+"shortInput"+cnt).remove();
	    }
	};

	var previewOption = {
		addPreview: function(item) {
			var html = '';
			html += '<div class="ui form qstnList mt10">';
			html += '	<div class="ui card wmax qstnDiv question-box">';
			html += '		<div class="fields content header2">';
			html += '			<div class="field wf100">';
			if(item.subNo == "1") {
				html += '				<span><spring:message code="exam.label.qstn" /> ' + item.qstnNo;
			} else {
				html += '				<span><spring:message code="exam.label.qstn" /> ' + item.qstnNo + '-' + item.subNo;
			}
			if(item.qstnTypeCd == "MATCH") {
				html += '			(<spring:message code="exam.label.qstn.match.info" /><!-- 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. -->)';
			}
			html += '			</div>';
			html += '		</div>';
			html += '		<div class="content">'
			html += '			<div class="mb20">' + item.qstnCts + '</div>';
			if(item.qstnTypeCd == "CHOICE" || item.qstnTypeCd == "MULTICHOICE") {
				html += '		<div class="ui divider"></div>';
				for(var i = 1; i <= item.emplCnt; i++) {
					html += '		<div class="field">';
					html += '			<div class="ui checkbox">';
					var checked = "";
					var rgtAnsr1List = (item.rgtAnsr1 || '').split(',');
					rgtAnsr1List.forEach(function(answer) {
						if(answer == i) checked = "checked";
					});
					html += '				<input type="' + (item.qstnTypeCd == 'MULTICHOICE' ? 'checkbox' : 'radio') + '" name="preview_CHOICE_' + item.qstnNo + '_' + item.subNo + '" ' + checked + ' />';
					html += '				<label class="question ' + (item.qstnTypeCd == 'MULTICHOICE' ? 'multi' : '') + ' empl" data-value="' + i + '">' + item['empl' + i] + '</label>';
					html += '			</div>';
					html += '		</div>';
				}
			} else if(item.qstnTypeCd == "DESCRIBE") {
				html += '		<textarea rows="3" maxlength="500"></textarea>';
			} else if(item.qstnTypeCd == "MATCH") {
				html += '		<div class="line-sortable-box" id="previewMatchContainer' + item.examQstnSn + '">';
				html += '			<div class="account-list">';
				for(var i = 1; i <= item.emplCnt; i++) {
					html += '			<div class="line-box num0' + i + '">';
					html += '				<div class="question"><span>' + item['empl' + i] + '</span></div>';
					html += '				<div class="slot" name="match' + item.examQstnSn + '"></div>';
					html += '			</div>';
				}
				html += '			</div>';
				html += '			<div class="inventory-list w200">';
				((item.rgtAnsr1 || "").split('|')).forEach(function(opposite) {
					html += '			<div class="slot" name="opposite' + item.examQstnSn + '"><span style="min-width:160px;"><i class="ion-arrow-move"></i>' + opposite + '</span></div>';
				});
				html += '			</div>';
				html += '		</div>';
			} else if(item.qstnTypeCd == "OX") {
				html += '		<div class="checkImg">';
				html += '			<input id="preview_oxChk' + item.qstnNo + '_' + item.subNo + '_true" type="radio" name="preview_oxChk' + item.qstnNo + '_' + item.subNo + '" ' + (item.rgtAnsr1 == '1' ? 'checked' : '') + ' />';
				html += '			<label class="imgChk true" for="preview_oxChk' + item.qstnNo + '_' + item.subNo + '_true"></label>';
				html += '			<input id="preview_oxChk' + item.qstnNo + '_' + item.subNo + '_false" type="radio" name="preview_oxChk' + item.qstnNo + '_' + item.subNo + '" ' + (item.rgtAnsr1 == '2' ? 'checked' : '') + ' />';
				html += '			<label class="imgChk false" for="preview_oxChk' + item.qstnNo + '_' + item.subNo + '_false"></label>';
				html += '		</div>';
			} else if(item.qstnTypeCd == "SHORT") {
				html += '		<div class="equal width fields">';
				var ansrCnt = 0;
				for(var i = 1; i <= 5; i++) {
					if(item['rgtAnsr' + i]) {
						ansrCnt = i;
					}
				}
				for(var i = 1; i <= ansrCnt; i++) {
					html += '		<div class="field">';
					html += '			<input type="text" class="japanInput" value="' + item['rgtAnsr' + i] + '" maxlength="40" placeholder="' + i + '<spring:message code="exam.label.answer.no" />" />'; // 번 답
					html += '		</div>';
				}
				html += '		 </div>';
			}
			html += '		</div>';
			html += '	</div>';
			html += '</div>';

			return html;
		},
		createSortable: function(examQtsnNo) {
			var invalid 	= false;
	        var $containner = $("#previewMatchContainer" + examQtsnNo);
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
		}
	}

	function manageQuiz(tab) {
		var urlMap = {
			"1" : "/quiz/quizQstnManage.do",	// 퀴즈 문제 관리 페이지
			"2" : "/quiz/quizRetakeManage.do",	// 퀴즈 재응시 관리 페이지
			"3" : "/quiz/quizScoreManage.do",	// 퀴즈 평가 관리 페이지
			"9" : "/quiz/profQzListView.do"		// 목록
		};

		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm(urlMap[tab], "", "", kvArr);
	}

    // 보기 갯수 변경
    function quizQstnChg(parentId, formId) {
    	var type = $("#"+formId+" select[name=qstnTypeCd]").val();
    	// 객관식
    	if(type == "CHOICE" || type == "MULTICHOICE") {
	    	var emplLiCnt = $("#"+parentId+" .qstnItemUl .emplLi").length;
	    	var emplCnt   = $("#"+parentId+" .qstnTypeDiv select[name=emplCnt]").val();

	    	if(emplLiCnt < emplCnt) {
		    	for(var i = emplLiCnt; i < emplCnt; i++) {
				   	var html  = "<li class='emplLi'>";
				   		html += "	<dl>";
				   		html += "		<dt>";
				   		if(type == "MULTICHOICE") {
				   		html += "			<div class='ui checkbox'>";
				   		html += "				<input type='checkbox' name='rgtAnsr1' id='"+formId+"RgtAnsr"+(i+1)+"' value='"+(i+1)+"'>";
				   		} else if(type == "CHOICE") {
				   		html += "			<div class='ui radio checkbox'>";
				   		html += "				<input type='radio' name='rgtAnsr1' id='"+formId+"RgtAnsr"+(i+1)+"' value='"+(i+1)+"'>";
				   		}
				   		html += "				<label class='toggle_btn' for='"+formId+"RgtAnsr"+(i+1)+"'><spring:message code='exam.label.qstn.item' />"+(i+1)+"</label>";/* 보기 */
				   		html += "			</div>";
				   		html += "		</dt>";
				   		html += "		<dd><input type='text' name='empl_"+(i+1)+"' class='japanInput' id='"+formId+"Empl_"+(i+1)+"' /></dd>";
				   		html += "	</dl>";
				   		html += "</li>";
			    	$("#"+parentId+" .qstnItemUl").append(html);
		    	}
	    	} else if(emplLiCnt > emplCnt) {
		    	for(var i = emplLiCnt; i > emplCnt-1; i--) {
		    	 	$("#"+parentId+" .qstnItemUl .emplLi:eq("+i+")").remove();
		    	}
	    	}

	    // 짝짓기형
    	} else if(type == "MATCH") {
    		var emplDivCnt = $("#"+formId+"MatchDd .emplDiv").length;
    		var emplCnt    = $("#"+parentId+" .qstnTypeDiv select[name=emplCnt]").val();

    		if(emplDivCnt < emplCnt) {
    			for(var i = emplDivCnt; i < emplCnt; i++) {
    				var classNm = "num0"+(i+1);
    				var html  = "<div class='line-sortable-box emplDiv'>";
    					html += "	<div class='account-list p10'>";
    					html += "		<div class='line-box "+classNm+"'>";
    					html += "			<div class='question p20 pl45'>";
    					html += "				<input type='text' name='empl"+(i+1)+"' class='japanInput' id='"+formId+"Empl_"+(i+1)+"' placeholder='"+"<spring:message code='exam.label.qstn.item' /> <spring:message code='exam.label.input' />"+"'/>";/* 보기 *//* 입력 */
    					html += "			</div>";
    					html += "			<div class='slot'><input type='text' name='rgtAnsr1' class='japanInput' id='"+formId+"RgtAnsr_"+(i+1)+"' placeholder='"+"<spring:message code='exam.label.input.answer' />"+"' /></div>";/* 정답 입력 */
    					html += "		</div>";
    					html += "	</div>";
    					html += "</div>";
    				$("#"+formId+"MatchDd").append(html);
    			}
    		} else if(emplDivCnt > emplCnt) {
    			for(var i = emplDivCnt; i > emplCnt-1; i--) {
    				$("#"+formId+"MatchDd .emplDiv:eq("+i+")").remove();
    			}
    		}
    	}

    	// 일본어입력기 적용
    	setJapaneseInput();

    	if($("#japanInputCheck").is(":checked")){
            $(".button.japanInput").show();
        } else{
        	$(".button.japanInput").hide();
        }
    }

    // 문항 타입 변경
    function qstnTypeChg(parentId, formId) {
    	$("#"+parentId+" #shortInfoDiv").hide();
    	$("#"+parentId+" .qstnTypeDiv > ul").empty();
        var type = $("#"+formId+" select[name=qstnTypeCd]").val();
        if(type == "CHOICE" || type == "MULTICHOICE") {
        	formOption.addEmplCnt(parentId, formId);
        	formOption.addChoiceForm(parentId);
        	quizQstnChg(parentId, formId);
        } else if(type == "SHORT") {
        	formOption.addShortForm(parentId, formId);
        	$("#"+parentId+" #shortInfoDiv").show();
        } else if(type == "OX") {
        	formOption.addOXForm(parentId, formId);
        } else if(type == "MATCH") {
        	formOption.addEmplCnt(parentId, formId);
        	formOption.addMatchForm(parentId, formId);
        	quizQstnChg(parentId, formId);
        }

     	// 일본어입력기 적용
    	setJapaneseInput();
    }

    // 문제 폼 생성
    function initForm(qstnNo, examCd, examQstnSn) {
    	var qstnFormId  = qstnNo == undefined ? "qstnAddForm" : "qstnAddForm_"+qstnNo;
    	var qstnHeader  = qstnNo == undefined ? "<spring:message code='exam.button.qstn.add' />"/* 문제 추가 */ : "<spring:message code='exam.button.qstn.sub.add' />";/* 후보 문제 추가 */
    	var addFormId   = qstnNo == undefined ? "qstnWriteForm" : "qstnWriteForm_"+qstnNo;
    	var editorKey   = qstnNo == undefined ? "editor" : "editor_"+qstnNo;
    	var editorId    = qstnNo == undefined ? "qstnCts" : "qstnCts"+qstnNo;
    	var appendClass = qstnNo == undefined ? "layout2" : "qstn_"+qstnNo;
    	$("#"+qstnFormId).remove();
    	var html  = "<div class='row wmax qstnFormDiv' id=\"" + qstnFormId + "\">";
    		html += "	<div class='col'>";
    		html += "		<div class='option-content header2'>";
    		html += "			<h3 class='qstnTitle'>" + qstnHeader + "</h3>";
    		html += "		</div>";
    		html += "		<div class='ui form content'>";
    		html += "		</div>";
    		html += "	</div>";
    		html += "</div>";
		$("."+appendClass).append(html);
		formOption.addHeader(qstnFormId, addFormId, editorId);
		formOption.addBtn(qstnFormId, addFormId);
		// html 에디터 생성
		editorMap[editorKey] = HtmlEditor(editorId, THEME_MODE, '/quiz', 'Y', 50);
		$("div[id^=new_]").css("z-index", "1");
		$("#"+qstnFormId+" .dropdown").dropdown();
		qstnTypeChg(qstnFormId, addFormId);
    }

    // 문제 추가 폼 출력
    function addQstnForm(qstnNo) {
    	if(!quizStartCheck("unsubmit")) {
    		return false;
    	}
    	initForm(qstnNo, "", "");
    	var formId  = qstnNo != undefined ? "qstnWriteForm_"+qstnNo : "qstnWriteForm";
    	var btnId   = qstnNo != undefined ? "qstnAddForm_"+qstnNo : "qstnAddForm";
    	var qstnCnt = qstnNo != undefined ? qstnNo : $(".quizQstnList").length + 1;
    	var subNo   = qstnNo != undefined ? $(".quizQstnList[data-qstnNo="+qstnNo+"]").find("div.quizQstnSubList").length + 1 : 1;
    	var score   = qstnNo != undefined ? $(".quizQstnList[data-qstnNo="+qstnNo+"]").find("input[name=qstnScore]").val() : 0;
    	$("#"+formId+" input[name=examCd]").val("${vo.examCd}");
    	$("#"+formId+" input[name=examQstnSn]").val("");
    	$("#"+formId+" input[name=qstnNo]").val(qstnCnt);
    	$("#"+formId+" input[name=subNo]").val(subNo);
    	$("#"+formId+" input[name=title]").val(qstnCnt+"-"+subNo+" <spring:message code='exam.label.qstn' />");/* 문제 */
    	$("#"+formId+" input[name=qstnScore]").val(score);
    	$("#"+btnId+" .addBtn").attr("href", "javascript:writeQuizQstn(\"" + btnId + "\", \"" + formId + "\", \"" + (qstnNo || "") + "\")");
    }

    // 문제 수정 체크
    function editQstnCheck(examCd, examQstnSn) {
    	if(!quizStartCheck("all")) {
    		return false;
    	}

    	var qstnNo = $(".quizQstnSubList[data-qstnSn='"+examQstnSn+"']").attr("data-qstnNo");
    	if($("#qstnAddForm_"+qstnNo).length == 0) {
    		editQstnForm(examCd, examQstnSn, "");
    	} else {
    		$("#qstnAddForm_"+qstnNo).remove();
    	}
    }

    // 문제 수정 폼 출력
    function editQstnForm(examCd, examQstnSn, type) {
    	$(".qstnFormDiv").remove();
    	var qstnNo    = $(".quizQstnSubList[data-qstnSn='"+examQstnSn+"']").attr("data-qstnNo");
    	var subNo     = $(".quizQstnSubList[data-qstnSn='"+examQstnSn+"']").attr("data-subNo");
    	var qstnScore = $(".quizQstnList[data-qstnNo='"+qstnNo+"']").find("input[name=qstnScore]").val();
    	initForm(qstnNo, examCd, examQstnSn);
    	$("#qstnWriteForm_"+qstnNo+" input[name=qstnNo]").val(qstnNo);
    	$("#qstnWriteForm_"+qstnNo+" input[name=subNo]").val(subNo);
    	$("#qstnWriteForm_"+qstnNo+" input[name=qstnScore]").val(qstnScore);
    	$("#qstnWriteForm_"+qstnNo+" input[name=title]").val(qstnNo+"-"+subNo+" <spring:message code='exam.label.qstn' />");/* 문제 */
    	$("#qstnWriteForm_"+qstnNo+" input[name=examCd]").val(examCd);
    	$("#qstnWriteForm_"+qstnNo+" input[name=examQstnSn]").val(examQstnSn);
    	$("#qstnAddForm_"+qstnNo+" .addBtn").attr("href", "javascript:editQuizQstn(\"" + qstnNo + "\")");
    	var editTitle = "<spring:message code='exam.button.qstn.edit' />";

    	if(subNo > 1) {
    		editTitle = "<spring:message code='exam.button.qstn.sub.edit' />";
    	}
    	$("#qstnAddForm_"+qstnNo+" .qstnTitle").text(editTitle);
    	$("#qstnAddForm_"+qstnNo+" .se-contents").focus();

    	var url  = "/quiz/selectQuizQstn.do";
		var data = {
			"examCd" 	 : examCd,
			"examQstnSn" : examQstnSn
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var qstn = data.returnVO;
        		// 공통 값 적용
        		$("#qstnWriteForm_"+qstnNo+" input[name=title]").val(qstn.title);
        		$("#qstnWriteForm_"+qstnNo+" select[name=qstnTypeCd]").val(qstn.qstnTypeCd).trigger("change");
        		editorMap["editor_"+qstnNo].insertHTML($.trim(qstn.qstnCts) == "" ? " " : qstn.qstnCts);
        		// 객관식
        		if(qstn.qstnTypeCd == "CHOICE" || qstn.qstnTypeCd == "MULTICHOICE") {
        			$("#qstnAddForm_"+qstnNo+" select[name=emplCnt]").val(qstn.emplCnt).trigger("change");
        			for(var i = 1; i <= qstn.emplCnt; i++) {
        				var emplStr = "empl"+i;
        				$("#qstnWriteForm_"+qstnNo+"Empl_"+i).val(_.unescape(qstn[emplStr]));
        			}
        			if(qstn.qstnTypeCd == "CHOICE") {
        				$("#qstnAddForm_"+qstnNo+" input[name=rgtAnsr1]").each(function() {
            				if(this.value == qstn.rgtAnsr1) {
            					$(this).prop("checked", true);
            				}
            			});
        			} else {
			        	qstn.rgtAnsr1.split(",").forEach(function(el, index) {
			        		$("#qstnAddForm_"+qstnNo+" input:checkbox[name='rgtAnsr1']:checkbox[value=\""+el+"\"]").prop("checked",true);
			        	});
        			}
        		// OX형
        		} else if(qstn.qstnTypeCd == "OX") {
        			if(qstn.rgtAnsr1 == 1) {
        				$("#qstnWriteForm_"+qstnNo+"_true").trigger("click");
        			} else {
        				$("#qstnWriteForm_"+qstnNo+"_false").trigger("click");
        			}
        		// 짝짓기형
        		} else if(qstn.qstnTypeCd == "MATCH") {
        			$("#qstnAddForm_"+qstnNo+" select[name=emplCnt]").val(qstn.emplCnt).trigger("change");
        			for(var i = 1; i <= qstn.emplCnt; i++) {
        				var emplStr = "empl"+i;
        				$("#qstnWriteForm_"+qstnNo+"Empl_"+i).val(_.unescape(qstn[emplStr]));
        			}
        			qstn.rgtAnsr1.split("|").forEach(function(el, index) {
    					$("#qstnWriteForm_"+qstnNo+"RgtAnsr_"+(index+1)).val(el);
    				});
        		// 주관식(단답형)
        		} else if(qstn.qstnTypeCd == "SHORT") {
	        		$("#qstnAddForm_"+qstnNo+" input[name=multiRgtChoiceTypeCd]:input[value='"+qstn.multiRgtChoiceTypeCd+"']").trigger("click");
	        		for(var idx = 1; idx <= 5; idx++) {
	        			var rgtAnsr = "rgtAnsr" + idx;
	        			if(qstn[rgtAnsr] == null || qstn[rgtAnsr] == "") {
	        				return false;
	        			}
	        			if(idx != 1) {
	        				formOption.addQstnInput("qstnWriteForm_"+qstnNo);
	        			}
	        			qstn[rgtAnsr].split("|").forEach(function(el, index) {
	        				$("#qstnWriteForm_"+qstnNo+"QstnDiv .shortInput:nth-child("+idx+")").find("input[name^=rgtAnsr]:eq("+index+")").val(el);
	        			});
	        		}
        		}
        		if("${vo.examSubmitYn}" == "M" && ("${today}" > "${vo.examStartDttm}" || "${vo.examStartUserCnt}" > 0)) {
        			$("#qstnWriteForm_"+qstnNo+" select[name=qstnTypeCd]").closest("div.dropdown").css("pointer-events", "none");
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
    }

    // 문제 가져오기
    function copyQstnList() {
    	if(!quizStartCheck("unsubmit")) {
    		return false;
    	}
    	var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'crsCd', 	'val' : "${creCrsVO.crsCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});

		submitForm("/quiz/quizQstnCopyPop.do", "quizPopIfm", "copyQstn", kvArr);
    }

    // 문제 리스트 가져오기
    function listQuizQstn() {
    	var url  = "/quiz/listQuizQstn.do";
		var data = {
			"examCd" : "${vo.examCd}"
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var qstnList = data.returnList || [];
        		var isExamSubmit = "${vo.examSubmitYn}" == "M" || "${vo.examSubmitYn}" == "Y";
        		var matchQstnList = [];

        		if(qstnList.length > 0) {
        			var html 	   = "";
        			var totalScore = 0;
        			var qstnScore  = 0;
        			$("#quizQstnTotalCnt").text(qstnList[0].qstnCnt);

        			for(var i = 1; i <= qstnList[0].qstnCnt; i++) {
        				var qstnNos = "";
        				qstnList.forEach(function(v, ii) {
        					if(i == v.qstnNo) {
        						qstnNos += v.examQstnSn + "|";
        					}
        				});
        				qstnNos = qstnNos.substring(0, qstnNos.length-1);
        				if(qstnNos != "") {
	        				qstnList.forEach(function(v, ii) {
	        					if(i == v.qstnNo && 1 == v.subNo) {
	        						totalScore = Math.round((totalScore + v.qstnScore) * 10) / 10;
	        						qstnScore = v.qstnScore;
	        					}
	        				});
		        				html += `<div class='grid-content-box menu-nth-wrap quizQstnList qstn_\${i}' data-qstnScore="\${qstnScore}" data-qstnNo="\${i}" data-qstnSn="\${qstnNos}">`;
		        				html += "	<div class='option-content gap8'>";
		        				html += "		<div class='more-btn'>";
		        				html += "			<i class='expand arrows alternate icon icon-sort ui-sortable-handle'></i>";
		        				html += "			"+i+"<spring:message code='exam.label.qstn' />"; // 문제
		        				if(${today < vo.examStartDttm }) {
		        				html += `			<a href="javascript:addQstnForm(\${i})" class="ui basic small button ml10"><spring:message code="exam.button.sub.qstn.add" /></a>`; // 후보 문항 추가
		        				}
		        				html += "		</div>";
		        				html += "		<div class='mla'>";
		        				if(isExamSubmit) {
		        					html += "		<div class='ui input mr10' id='scoreDisplayDiv" + i + "'>";
			        				html += "			<span>" + qstnScore + "<spring:message code='exam.label.score.point' /></span>"; // 점
			        				html += "		</div>";
			        				html += "		<div class='ui input mr10' id='scoreInputDiv" + i + "' style='display:none;'>";
			        				html += "			<input type='text' id='editScore" + i + "' name='editScore' value='" + qstnScore + "' data-edit-qstn-nos='" + qstnNos + "' class='num' maxlength='4' onKeyup='scoreValidation(this);' onblur='scoreValidation(this); calcTotEditScore();' onfocus='this.select()' />";
			        				html += "			<input type='hidden' id='originScore" + i + "' value='" + qstnScore + "' />";
			        				html += "			<label class='ui label flex-none m0'><spring:message code='exam.label.score.point' /></label>"; // 점
			        				html += "		</div>";
		        				} else {
		        					html += "		<div class='ui input mr10' onclick='scoreFormChg(this)'>";
			        				html += "			<span>" + qstnScore + "<spring:message code='exam.label.score.point' /></span>"; // 점
			        				html += "			<input type='number' name='qstnScore' style='display:none;' step='0.1' class='num' value='" + qstnScore + "' />";
			        				html += "		</div>";
		        				}
		        				html += "		</div>";
		        				html += "	</div>";
		        				html += "	<div class='mt10 sub-content wmax pl15 ui-sortable'>";
		        			qstnList.forEach(function(v, ii) {
		        				if(i == v.qstnNo) {
		        				html += `		<div class='sub-content-box ui form m5 quizQstnSubList' data-qstnNo="\${v.qstnNo}" data-subNo="\${v.subNo}" data-qstnSn="\${v.examQstnSn}">`;
		        				html += "			<div class='fields m0 align-items-center gap8'>";
		        				html += "				<i class='arrows alternate vertical icon icon-chg'></i>";
		        				html += "				<div class='field fourteen wide tl'>";
		        				html += `					<a class="fcBlue" href="javascript:editQstnCheck('\${v.examCd }' , '\${v.examQstnSn }')">\${v.qstnNo }.\${v.subNo }</a>`;
		        				html += "				</div>";
		        				html += "				<div class='field three wide tr'>";
		        				html += `					\${v.qstnTypeNm }`;
		        				html += "				</div>";
		        				if(isExamSubmit) {
		        					html += "			<div class='field two wide tc'></div>";
		        				} else {
		        					html += "			<div class='field two wide tc'>";
			        				html += `				<a href="javascript:delQuizQstn('\${v.examCd}', '\${v.examQstnSn}')" class="ui basic small button"><spring:message code="exam.button.del" /></a>`; // 삭제
			        				html += "			</div>";
		        				}
		        				html += "			</div>";
		        				html += 			previewOption.addPreview(v);
		        				if(v.qstnTypeCd == "MATCH") {
		        					matchQstnList.push(v.examQstnSn);
		        				}
		        				html += "		</div>";
		        				}
		        			});
		        				html += "	</div>";
		        				html += "</div>";
        				}
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
        	            	chgQstnNo(ui.item);
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
        	            	chgSubNo(ui.item);
        	            }
        	        });

        			// 미리보기 설정
        			matchQstnList.forEach(function(examQstnSn) {
       					setTimeout(function() {
       						previewOption.createSortable(examQstnSn);
						}, 0);
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

    // 퀴즈 문제 번호 변경
    function chgQstnNo(item) {
    	if(!quizStartCheck("unsubmit")) {
    		listQuizQstn();
    		return false;
    	}
    	var qstnNo 	  = item.attr("data-qstnNo");
    	var qstnSns   = item.attr("data-qstnSn");
    	var newQstnNo = 1;

    	$("div.quizQstnList").each(function(i) {
    		if(qstnNo == $(this).attr("data-qstnNo")) {
    			newQstnNo = i + 1;
    		}
    	});

    	if(qstnNo != newQstnNo) {
    		var searchKey = qstnNo > newQstnNo ? "UP" : "DOWN";

    		var url  = "/quiz/editQuizQstnNo.do";
    		var data = {
    			"examCd" 	  : "${vo.examCd}",
    			"examQstnSns" : qstnSns,
    			"qstnNo" 	  : qstnNo,
    			"newQstnNo"   : newQstnNo,
    			"searchKey"	  : searchKey
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		listQuizQstn();
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.qstn.sort' />");/* 문제 번호 변경 중 에러가 발생하였습니다. */
    		});
    	}
    }

    // 퀴즈 후보 문항 순서 변경
    function chgSubNo(item) {
    	if(!quizStartCheck("unsubmit")) {
    		listQuizQstn();
    		return false;
    	}
    	var qstnSn   = item.attr("data-qstnSn");
    	var qstnNo   = item.attr("data-qstnNo");
    	var subNo    = item.attr("data-subNo");
    	var newSubNo = 1;

    	$("div.qstn_"+qstnNo+" div.quizQstnSubList").each(function(i) {
    		if(subNo == $(this).attr("data-subNo")) {
    			newSubNo = i + 1;
    		}
    	});

    	if(subNo != newSubNo) {
    		var searchKey = subNo > newSubNo ? "UP" : "DOWN";

    		var url  = "/quiz/editQuizSubNo.do";
    		var data = {
    			"examCd"	 : "${vo.examCd}",
    			"examQstnSn" : qstnSn,
    			"qstnNo"	 : qstnNo,
    			"subNo" 	 : subNo,
    			"newSubNo" 	 : newSubNo,
    			"searchKey"	 : searchKey
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		listQuizQstn();
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.sub.qstn.sort' />");/* 후보 문항 순서 변경 중 에러가 발생하였습니다. */
    		});
    	}
    }

    // 문항 등록
    function writeQuizQstn(parentId, formId, qstnNo) {
    	if(!validateWriteQuizQstn(qstnNo || "")) {
    		return false;
    	}

    	// 강의실 코드 파라미터 추가
    	if($("#"+formId).find("input[name='crsCreCd']").length == 0) {
    		$("#"+formId).append("<input type='hidden' name='crsCreCd' value='${crsCreCd}' />");
    	}

    	showLoading();
    	var url = "/quiz/writeQuizQstn.do";

		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#"+formId).serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		editQstnScoreAll("${vo.examCd}");
        		$("#"+parentId).remove();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.qstn.insert' />");/* 문항 등록 중 에러가 발생하였습니다. */
        });
    }

    // 문항 수정
    function editQuizQstn(qstnNo) {
    	if(!validateWriteQuizQstn(qstnNo)) {
    		return false;
    	}

    	if("${vo.examSubmitYn}" == "M" && ("${today}" > "${vo.examStartDttm}" || "${vo.examStartUserCnt}" > 0)) {
    		var kvArr = [];
    		kvArr.push({'key' : 'qstnNo', 'val' : qstnNo});

    		submitForm("/quiz/quizQstnEditOptionPop.do", "quizPopIfm", "qstnOption", kvArr);
    	} else {
	    	showLoading();
			var url = "/quiz/editQuizQstn.do";

			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : $("#qstnWriteForm_"+qstnNo).serialize(),
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		listQuizQstn();
	        		$("#qstnAddForm_"+qstnNo).remove();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='exam.error.qstn.update' />");/* 문항 수정 중 에러가 발생하였습니다. */
	        });
    	}
    }

    // 문항 수정 옵션 포함
    function editQuizQstnOption(qstnNo, type) {
    	$("#qstnWriteForm_"+qstnNo).append("<input type='hidden' name='searchKey' value='"+type+"' />");
    	showLoading();
		var url = "/quiz/editQuizQstnOption.do";

		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#qstnWriteForm_"+qstnNo).serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		listQuizQstn();
        		$("#qstnAddForm_"+qstnNo).remove();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.qstn.update' />");/* 문항 수정 중 에러가 발생하였습니다. */
        });
    }

    // 문항 삭제
    function delQuizQstn(examCd, examQstnSns) {
    	if(!quizStartCheck("unsubmit")) {
    		return false;
    	}
    	var url  = "/quiz/quizCopy.do";
		var data = {
    			"examCd"   : examCd,
    			"crsCreCd" : "${vo.crsCreCd}"
    		};

		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
        		var confirm = "";
        		if(data.returnVO.examStartUserCnt > 0) {
        			confirm = window.confirm(`<spring:message code="exam.label.quiz" /> <spring:message code="exam.confirm.exist.answer.user.y" />`);/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.\r\n정말 삭제하시겠습니까? */
        		} else {
        			confirm = window.confirm("<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />");/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
        		}

        		if(confirm) {
        			var url  = "/quiz/delQuizQstn.do";
        			var data = {
        	    			"examCd"	  : examCd,
        	    			"examQstnSns" : examQstnSns
        	    		};

        			ajaxCall(url, data, function(data) {
        				if (data.result > 0) {
        	        		alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
        	        		editQstnScoreAll("${vo.examCd}");
        	            } else {
        	             	alert(data.message);
        	            }
            		}, function(xhr, status, error) {
            			alert("<spring:message code='exam.error.qstn.delete' />");/* 문항 삭제 중 에러가 발생하였습니다. */
            		});
        		}
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.qstn.delete' />");/* 문항 삭제 중 에러가 발생하였습니다. */
		});
    }

    // 퀴즈 문항 점수 자동 배점
    function editQstnScoreAll(examCd, isConfirm) {
    	if(!quizStartCheck("unsubmit")) {
    		return false;
    	}

    	if(isConfirm) {
    		// 배점을 수정하겠습니까?
    		if(!confirm("<spring:message code='exam.confirm.score.edit' />")) return false;
    	}

    	var url  = "/quiz/updateQuizQstnScore.do";
    	var data = {
    		  "examCd" : examCd
   			, "crsCreCd" : "${vo.crsCreCd}"
   		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		listQuizQstn();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.qstn.score.update' />");/* 점수 수정 중 에러가 발생하였습니다. */
		}, true);
    }

 	// 퀴즈 문항 점수 자동 배점 (출제 완료 후)
    function editQstnScoreAllAfter() {
   		// 배점을 수정하겠습니까?
   		if(!confirm("<spring:message code='exam.confirm.score.edit' />")) return false;

    	var url  = "/quiz/updateQuizQstnScore.do";
    	var data = {
      		  "examCd" : "${vo.examCd}"
  			, "crsCreCd" : "${vo.crsCreCd}"
  		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				cancelScoreEditMode();
        		listQuizQstn();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.qstn.score.update' />"); // 점수 수정 중 에러가 발생하였습니다.
		}, true);
    }

    // 퀴즈 문항 점수 전부 1점 부여
    function editQstnScoreAll1(examCd) {
    	if(!quizStartCheck("unsubmit")) {
    		return false;
    	}

    	var url  = "/quiz/updateQuizQstnScore1.do";
		var data = {
    		  "examCd" : examCd
   			, "crsCreCd" : "${vo.crsCreCd}"
   		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		listQuizQstn();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.qstn.score.update' />");/* 점수 수정 중 에러가 발생하였습니다. */
		});
    }

    // 퀴즈 문항 유효성 검사
    function validateWriteQuizQstn(qstnNo) {
    	var parentId = qstnNo == "" ? "qstnAddForm" : "qstnAddForm_"+qstnNo;
    	var formId   = qstnNo == "" ? "qstnWriteForm" : "qstnWriteForm_"+qstnNo;
    	var editor   = editorMap[qstnNo == "" ? "editor" : "editor_"+qstnNo];
    	$("#"+formId).find("input[name=rgtAnsr1]").remove();
    	$("#"+formId).find("input[name=rgtAnsr2]").remove();
    	$("#"+formId).find("input[name=rgtAnsr3]").remove();
    	$("#"+formId).find("input[name=rgtAnsr4]").remove();
    	$("#"+formId).find("input[name=rgtAnsr5]").remove();
    	$("#"+formId).find("input[name=multiRgtChoiceYn]").remove();
    	$("#"+formId).find("input[name=multiRgtChoiceTypeCd]").remove();
    	for(var i = 1; i <= 10; i++) {
	    	$("#"+formId).find("input[name=empl"+i+"]").remove();
    	}

    	var isValid 	   = true;
    	var quizQstnTypeCd = $("#"+formId+" select[name=qstnTypeCd]").val();

    	if(editor.isEmpty() || editor.getTextContent().trim() === "") {
    		alert("<spring:message code='exam.alert.input.contents' />");/* 내용을 입력하세요. */
    		return false;
    	}

    	// 객관식
    	if(quizQstnTypeCd == "CHOICE" || quizQstnTypeCd == "MULTICHOICE") {
    		if($("#"+parentId).find("input[name=rgtAnsr1]:checked").length == 0) {
				alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
				return false;
			} else {
				var multiRgtChoiceYn = $("#"+parentId).find("input[name=rgtAnsr1]:checked").length > 1 ? "Y" : "N";
				$("#"+formId).append("<input type='hidden' name='multiRgtChoiceYn' value=\"" + multiRgtChoiceYn + "\" />");
				var rgtAnsr1 = "";
				$("#"+parentId).find("input[name=rgtAnsr1]:checked").each(function(i) {
					if(i > 0) {
						rgtAnsr1 += ",";
					}
					rgtAnsr1 += $(this).val();
				});
				$("#"+formId).append("<input type='hidden' name='rgtAnsr1' value='" + rgtAnsr1 +"' />");
			}
    		var emplCnt = $("#"+parentId+" select[name=emplCnt]").val();
    		for(var i = 1; i <= emplCnt; i++) {
    			if($("#"+formId+"Empl_"+i).val() == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				break;
    			}

    			$("#"+formId).append("<input type='hidden' name='empl"+i+"' value=\"" + _.escape($("#"+formId+"Empl_"+i).val()) + "\" />");
    		}
    		if(!isValid) {
				return false;
			}

    	// 주관식(단답형)
    	} else if(quizQstnTypeCd == "SHORT") {
    		$("#"+parentId+" .shortInput").each(function(i) {
	    		var rgtAnsr = "";
    			if($(this).find("input[name^=rgtAnsr]").val() == "") {
    				alert((i+1)+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			$(this).find("input[name^=rgtAnsr]").each(function(ii) {
    				if($.trim($(this).val()) != "") {
    					if(rgtAnsr != "") {
    						rgtAnsr += "|";
    					}
    					rgtAnsr += $(this).val();
    				}
    			});
    			$("#"+formId).append("<input type='hidden' name='rgtAnsr"+(i+1)+"' value=\"" + rgtAnsr + "\" />");
    		});
    		var multiRgtChoiceYn = $("#"+parentId+" .shortInput").length > 1 ? "Y" : "N";
    		$("#"+formId).append("<input type='hidden' name='multiRgtChoiceYn' value=\"" + multiRgtChoiceYn + "\" />");
    		$("#"+formId).append("<input type='hidden' name='multiRgtChoiceTypeCd' value=\"" + $("#"+parentId+" input[name=multiRgtChoiceTypeCd]:checked").val() + "\" />");

    	// OX형
    	} else if(quizQstnTypeCd == "OX") {
    		if($("#"+parentId).find("input[name=rgtAnsr1]:checked").length == 0) {
    			alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
    			return false;
    		} else {
    			$("#"+formId).append("<input type='hidden' name='rgtAnsr1' value=\"" + $("#"+parentId).find($("input[name=rgtAnsr1]:checked")).val() + "\" />");
    		}

    	// 짝짓기형
    	} else if(quizQstnTypeCd == "MATCH") {
    		var emplCnt = $("#"+parentId+" select[name=emplCnt]").val();
    		var rgtAnsr1 = "";
    		for(var i = 1; i <= emplCnt; i++) {
    			if($("#"+formId+"Empl_"+i).val() == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			if($("#"+formId+"RgtAnsr_"+i).val() == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			if(i > 1) {
    				rgtAnsr1 += "|";
    			}
    			rgtAnsr1 += $("#"+formId+"RgtAnsr_"+i).val();

    			$("#"+formId).append("<input type='hidden' name='empl"+i+"' value=\"" + $("#"+formId+"Empl_"+i).val() + "\" />");
    		}
    		$("#"+formId).append("<input type='hidden' name='rgtAnsr1' value=\"" + rgtAnsr1 + "\" />");
    	}

    	return isValid;
    }

    // 점수 수정 폼 변경
    function scoreFormChg(obj) {
    	if(!quizStartCheck("unsubmit")) {
    		return false;
    	}
    	$(obj).children("input").show();
    	$(obj).children("span").hide();
    	$(obj).children("input").focus();

    	$(obj).children("input").on("keyup", function(e) {
    		if(e.keyCode == "13") {
    			changeScoreInput();
    		}
    	});

    	$(obj).children("input").on("blur", function(e) {
   			changeScoreInput();
    	});
    }

    // 점수 수정
    function changeScoreInput() {
    	$("input[name=qstnScore]:visible").each(function(i, v) {
			var qstnNo 		 = $(v).parents(".quizQstnList").attr("data-qstnNo");
        	var examQstnSns  = $(".quizQstnList[data-qstnNo="+qstnNo+"]").attr("data-qstnSn");
        	var qstnScore 	 = $(".quizQstnList[data-qstnNo="+qstnNo+"]").find("input[name=qstnScore]").val();
        	var isBoolean	 = true;
        	if(qstnScore == "") {
        		alert("<spring:message code='exam.alert.input.score' />"); // 점수를 입력하세요.
        		isBoolean = false;
        	} else if(qstnScore < 0 || qstnScore > 100) {
        		alert("<spring:message code='exam.alert.score.max.100' />"); // 점수는 100점 까지 입력 가능 합니다.
        		isBoolean = false;
        	}
        	if(!isBoolean) {
        		listQuizQstn();
        	} else {
	        	var url  = "/quiz/updateQuizQstnScore.do";
	    		var data = {
	        			"examCd"	  : "${vo.examCd}",
	        			"examQstnSns" : examQstnSns,
	        			"qstnScores"  : qstnScore
	        		};

	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	    				if((i+1) == $("input[name=qstnScore]:visible").length) {
    	    				listQuizQstn();
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

    // 출제 완료
    function updateExamSubmitYn(type) {
		if($("#qstnTotalScore").text() != "100" && type == "save") {
			alert("<spring:message code='exam.alert.score.ratio.100' />");/* 배점 점수가 100점과 맞지 않습니다. 다시 확인해 주세요. */
			return false;
		}

		if(SCORE_EDIT_MODE == true) {
			alert("<spring:message code='exam.alert.score.edit.not.complete' />");// 배점 일괄 수정 중입니다. <br/>배점 일괄 저장 또는 취소후 저장및출제 가능합니다.
			return false;
		}

		if(quizStartCheck("submit")) {
			if(type == "edit" && "${vo.examStartUserCnt}" > 0) {
				var kvArr = [];
				kvArr.push({'key' : 'examCd', 	   'val' : "${vo.examCd}"});
				kvArr.push({'key' : 'crsCreCd',    'val' : "${creCrsVO.crsCreCd}"});
				kvArr.push({'key' : 'searchKey',   'val' : "QUIZ"});
				kvArr.push({'key' : 'searchGubun', 'val' : type});

				submitForm("/quiz/editExamSubmitYnPop.do", "quizPopIfm", "qstnEdit", kvArr);
			} else {
				var confirmMsg = "<spring:message code='exam.confirm.exam.qstn.submit' />"; // 문제를 출제하시겠습니까?
				if(type == "edit") {
					confirmMsg = "<spring:message code='exam.confirm.exam.qstn.edit' />"; // 문제를 수정하시겠습니까?
				}

				if(window.confirm(confirmMsg)) {
					var url  = "/quiz/editExamSubmitYn.do";
					var data = {
						"examCd"      : "${vo.examCd}",
						"crsCreCd"    : "${creCrsVO.crsCreCd }",
						"searchKey"   : "QUIZ",
						"searchGubun" : type
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
						   	location.reload();
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

	// 엑셀 문항 등록
 	function quizQstnExcelUploadPop() {
 		if(!quizStartCheck("unsubmit")) {
 			return false;
 		}
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 'val' : "${vo.examCd}"});

		submitForm("/quiz/quizQstnExcelUploadPop.do", "quizPopIfm", "excelUpload", kvArr);
 	}

	// 퀴즈 시작 여부 확인
	function quizStartCheck(type) {
		// 출제 완료 여부
		var isSubmit = "${vo.examSubmitYn}" == "Y";
		// 제출 후 수정 여부
		var isTemp	 = "${vo.examSubmitYn}" == "M";
		// 퀴즈 대기 여부
		var isWait   = "${today}" > "${vo.examStartDttm}";
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


	// 문항 추가 폼 취소
 	function writeQuizQstnCancel(id) {
 		$("#"+id).remove();
 	}

 	// 퀴즈 시험지 미리보기
	function quizQstnPreview(examCd) {
		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : examCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});

		submitForm("/quiz/quizQstnPreviewPop.do", "quizPopIfm", "quizPreview", kvArr);
	}

 	// 퀴즈 정보 조회
	function getQuizInfo() {
		var deferred = $.Deferred();

		var url = "/quiz/quizCopy.do";
		var data = {
   			"examCd"   : "${vo.examCd}",
   			"crsCreCd" : "${vo.crsCreCd}"
   		};

		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				deferred.resolve(data.returnVO || {});
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

 		if("${vo.examSubmitYn}" == "Y") {
 			if(!quizStartCheck("unsubmit")) {
 	    		return false;
 	    	}
 		}

 		getQuizInfo().done(function(returnVO) {
 			if(returnVO.examStartUserCnt > 0) {
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

			var examQstnSns = "" + $(this).data("editQstnNos")
			var qstnScore = this.value;

			changeScoreList.push({
				  examCd   : "${vo.examCd}"
	   			, crsCreCd : "${vo.crsCreCd}"
				, examQstnSns: examQstnSns
				, qstnScore: qstnScore
			})
		});

		if(!isValid) return;

		// 배점을 수정하겠습니까?
   		if(!confirm("<spring:message code='exam.confirm.score.edit' />")) return false;

		var url = "/quiz/updateQuizQstnScoreBatch.do";
		var data = JSON.stringify(changeScoreList);

		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				cancelScoreEditMode();

				// 점수 등록이 완료되었습니다.
				alert("<spring:message code='exam.alert.score.finish' />");

				listQuizQstn();
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
                            	<a href="javascript:quizQstnPreview('${vo.examCd }')" class="ui orange button"><spring:message code="exam.label.preview" /></a><!-- 미리보기 -->
                            	<c:choose>
                            		<c:when test="${vo.examSubmitYn ne 'Y' }">
		                            	<a href="javascript:updateExamSubmitYn('save')" class="ui orange button"><spring:message code="exam.button.qstn.submit" /></a><!-- 저장및출제 -->
                            		</c:when>
                            		<c:otherwise>
		                            	<a href="javascript:updateExamSubmitYn('edit')" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
                            		</c:otherwise>
                            	</c:choose>
							    <a href="javascript:manageQuiz(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
							</div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="listTab">
			                        <ul>
			                            <li class="select mw120"><a onclick="manageQuiz(1)"><spring:message code="eaxm.tab.qstn.manage" /></a></li><!-- 문제 관리 -->
			                            <c:if test="${vo.reExamYn eq 'Y'}">
				                            <li class="mw120"><a onclick="manageQuiz(2)"><spring:message code="exam.tab.reexam.manage" /></a></li><!-- 미응시 관리 -->
			                            </c:if>
			                            <li class="mw120"><a onclick="manageQuiz(3)"><spring:message code="exam.label.info.score.manage" /></a></li><!-- 정보 및 평가 -->
			                        </ul>
			                    </div>
								<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
									<div class="title">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
													<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
													<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examEndDttm }" />
													<fmt:formatDate var="examEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
													<p class="lect_name">${fn:escapeXml(vo.examTitle) }</p>
													<span class="fcGrey">
														<small><spring:message code="crs.label.quiz_period" /><!-- 퀴즈기간 --> : ${examStartDttm } ~ ${examEndDttm }</small> |
														<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.scoreAplyYn eq 'Y' ? yes : no }</small> |
														<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.scoreOpenYn eq 'Y' ? yes : no }</small> |
														<small>
															<spring:message code="exam.label.qstn.status" /><!-- 문제출제상태 --> :
															<c:choose>
																<c:when test="${vo.examSubmitYn eq 'Y' or vo.examSubmitYn eq 'M'}">
																	<span><spring:message code="exam.label.qstn.submit.y" /><!-- 출제완료 --></span>
																</c:when>
																<c:otherwise>
																	<span class="fcRed"><spring:message code="exam.label.qstn.temp.save" /><!-- 임시저장 --></span>
																</c:otherwise>
															</c:choose>
														</small>
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
															<label for="subjectLabel"><spring:message code="crs.label.quiz_contents" /></label><!-- 퀴즈내용 -->
														</dt>
														<dd><pre>${vo.examCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="crs.label.quiz_period" /></label><!-- 퀴즈기간 -->
														</dt>
														<dd>${examStartDttm } ~ ${examEndDttm }</dd>
														<dt>
															<label><spring:message code="exam.label.view.qstn.type" /></label><!-- 문제표시방식 -->
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.viewQstnTypeCd eq 'ALL' }">
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
															<label for="teamLabel"><spring:message code="crs.label.quiz_time" /></label><!-- 퀴즈시간 -->
														</dt>
														<dd>${vo.examStareTm }<spring:message code="exam.label.stare.min" /></dd><!-- 분 -->
														<dt>
															<label><spring:message code="exam.label.empl.random" /></label><!-- 보기 섞기 -->
														</dt>
														<dd>${vo.emplRandomYn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="forum.label.score.ratio" /></label><!-- 성적 반영비율 -->
														</dt>
														<dd>${vo.scoreAplyYn eq 'Y' ? vo.examStareTypeCd eq 'M' or vo.examStareTypeCd eq 'L' ? '100' : vo.scoreRatio : '0' }%</dd>
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
											</ul>
										</div>
									</div>
								</div>

								<div class="option-content header2">
									<h3><spring:message code="exam.common.search.all" /> <spring:message code="exam.label.qstn" /> : <span id="quizQstnTotalCnt">${qstnCnt }</span><spring:message code="exam.label.qstn" /></h3><!-- 전체 --><!-- 문제 --><!-- 문제 -->
								    <div class="mla">
								    	<c:choose>
								    		<c:when test="${vo.examSubmitYn eq 'Y' or vo.examSubmitYn eq 'M'}">
								    			<c:if test="${vo.examSubmitYn eq 'M'}">
								    				<a href="javascript:void(0)" id="changeScoreEditModeBtn" class="ui blue small button"><spring:message code="exam.button.batch.edit.score" /></a><!-- 배점 일괄 수정 -->
									    			<a href="javascript:cancelScoreEditMode()" id="cancelScoreEditModeBtn" class="ui blue small button" style="display: none;"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
									    			<a href="javascript:editQstnScoreAllAfter('${vo.examCd }')" class="ui blue small button"><spring:message code="exam.button.auto.score" /></a><!-- 자동 배점 -->
								    			</c:if>
								    		</c:when>
								    		<c:otherwise>
								    			<a href="javascript:copyQstnList()" class="ui blue small button"><spring:message code="exam.label.qstn" /> <spring:message code="exam.label.copy" /></a><!-- 문제 --><!-- 가져오기 -->
										        <%-- <a href="javascript:quizQstnExcelUploadPop()" class="ui blue small button"><spring:message code="exam.button.req.excel.qstn" /></a><!-- 엑셀 문항등록 --> --%>
										        <a href="javascript:editQstnScoreAll('${vo.examCd }', true)" class="ui blue small button"><spring:message code="exam.button.auto.score" /></a><!-- 자동 배점 -->
										        <%-- <a href="javascript:editQstnScoreAll1('${vo.examCd }')" class="ui blue small button">1</a> --%>
								    		</c:otherwise>
								    	</c:choose>
								    </div>
								</div>
								<c:if test="${vo.examSubmitYn ne 'Y' and vo.examSubmitYn ne 'M'}">
								<div class="option-content">
									<div class="mla">
										<div class="ui error message p5 mb10">
											<i class="info circle icon"></i><spring:message code="exam.alert.already.qstn.submit.n" /><!-- 임시저장 상태입니다. [저장및출제] 버튼을 클릭해야 출제가 완료됩니다. -->
										</div>
									</div>
								</div>
								</c:if>
								<div class="grid-content modal-type ui-sortable ml0" id="quizQstnDiv"></div>

								<div class="tc">
									<c:if test="${vo.examSubmitYn ne 'Y' and vo.examSubmitYn ne 'M'}">
										<a href="javascript:addQstnForm()" class="ui blue small button"><spring:message code="exam.button.qstn.add" /></a><!-- 문제 추가 -->
									</c:if>
									<div class="f110 d-inline-block fr">
										<spring:message code="exam.label.gain.point" /><!-- 배점 --> <spring:message code="exam.label.sum.point" /><!-- 합게 --> : <span id="qstnTotalScore">${totalScore }</span> <spring:message code="exam.label.score.point" /><!-- 점 -->
									</div>
								</div>
								<c:if test="${vo.examSubmitYn ne 'Y' and vo.examSubmitYn ne 'M'}">
								<div class="option-content mt10">
									<div class="mla">
										<div class="ui error message p5 mb0">
											<i class="info circle icon"></i><spring:message code="exam.alert.already.qstn.submit.n" /><!-- 임시저장 상태입니다. [저장및출제] 버튼을 클릭해야 출제가 완료됩니다. -->
										</div>
									</div>
								</div>
								</c:if>
								<div class="option-content mt40">
									<div class="mla">
		                            	<c:choose>
		                            		<c:when test="${vo.examSubmitYn ne 'Y' }">
				                            	<a href="javascript:updateExamSubmitYn('save')" class="ui orange button"><spring:message code="exam.button.qstn.submit" /></a><!-- 저장및출제 -->
		                            		</c:when>
		                            		<c:otherwise>
				                            	<a href="javascript:updateExamSubmitYn('edit')" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
		                            		</c:otherwise>
		                            	</c:choose>
									    <a href="javascript:manageQuiz(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
									</div>
								</div>
		                	</div>
		                </div>
        			</div>
        		</div>
			</div>
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>