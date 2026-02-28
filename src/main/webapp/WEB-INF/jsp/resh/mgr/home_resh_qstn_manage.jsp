<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		listReshPageQstn();
	});
	
	var checkOption = {
		// 필수 선택
		reqCheck: function(vo, type) {
			if(vo.reqChoiceYn == "Y") {
				$("#"+type+"Req").prop("checked", true);
				$("#"+type+"Req").parents().addClass("checked");
			} else {
				$("#"+type+"Req").prop("checked", false);
				$("#"+type+"Req").parents().removeClass("checked");
			}
		},
		// 기타 항목
		etcCheck: function(vo, type) {
			var selectList  = $("#"+type+"Cnt").siblings("div.menu").children();
			var qstnItemCnt = vo.reschQstnItemList.length;
			if(vo.etcOpinionYn == "Y") {
				qstnItemCnt -= 1;
				$("#"+type+"Etc").prop("checked", true).trigger("change");
				$("#"+type+"Etc").parents().addClass("checked");
			} else {
				$("#"+type+"Etc").prop("checked", false).trigger("change");
				$("#"+type+"Etc").parents().removeClass("checked");
			}
			selectList.each(function() {
				if($(this).attr("data-value") == qstnItemCnt) {
    				$(this).trigger("click");
    			}
			});
		}
	};
	
	var editorMap = {};
	
	var formOption = {
		// 타이틀 폼
		addHeader: function(reschPageCd) {
			var html  = "<div class='ui card wmax reshAddForm' id='"+reschPageCd+"QstnForm'>";
				html += "	<div class='flex content'>";
				html += "		<h3><spring:message code='resh.button.add.item' /></h3>";/* 문항 추가 */
				html += "	</div>";
				html += "	<div class='ui form content'>";
				html += "		<form id='"+reschPageCd+"WriteForm'>";
				html += "			<input type='hidden' name='reschPageCd' />";
				html += "			<input type='hidden' name='reschQstnCd' />";
				html += "			<div class='flex gap4'>";
				html += "				<select class='ui dropdown' name='reschQstnTypeCd' onchange='qstnTypeChg(\""+reschPageCd+"\")'>";
										<c:forEach var="code" items="${qstnTypeList }">
				html += "					<option value='${code.codeCd }'>${code.codeNm }</option>";
										</c:forEach>
				html += "				</select>";
				html += "				<div class='field flex1 mb0'>";
				html += "					<input type='text' name='reschQstnTitle'>";
				html += "				</div>";
				html += "			</div>";
				html += "			<div class='ui small warning message'>";
				html += "				<i class='info circle icon'></i>";
				html += "				<spring:message code='resh.alert.another.title' />";/* 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다. */
				html += "			</div>";
				html += "			<dl style='display:table;width:100%'>";
				html += "				<dd style='display:table-cell;height:400px'>";
				html += "					<div style='height:100%'>";
				html += "						<textarea name='reschQstnCts' id='"+reschPageCd+"QstnCts'></textarea>";
				html += "					</div>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</form>";
				html += "		<form name='reshQstnForm'></form>";
				html += "		<div class='option-content'>";
				html += "			<div class='mla'>";
				html += "				<a href='javascript:writeReshQstn(\""+reschPageCd+"\")' id='"+reschPageCd+"WriteBtn' class='ui blue button'><spring:message code='resh.button.save' /></a>";/* 저장 */
				html += "				<a href='javascript:writeReshQstnCancel(\""+reschPageCd+"\")' class='ui basic button'><spring:message code='resh.button.cancel' /></a>";/* 취소 */
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "</div>";
			$(".page_"+reschPageCd).append(html);
			editorMap[reschPageCd] = HtmlEditor(reschPageCd+'QstnCts', THEME_MODE, '/resh/${vo.reschCd }');
		},
		// 단일, 다중선택형 보기 폼
		addChoiceForm: function(reschPageCd) {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<ul class='tbl border-top-grey'>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='"+reschPageCd+"EmplCnt'><spring:message code='resh.label.qstn.item.cnt' /></label>";/* 보기 갯수 */
				html += "				</dt>";
				html += "				<dd>";
				html += "					<select class='ui dropdown w150' name='emplCnt' id='"+reschPageCd+"EmplCnt' onchange='formOption.reshQstnChg(\""+reschPageCd+"\")'>";
											for(var idx = 2; idx <= 10; idx++) {
												var selected = idx == 4 ? "selected" : "";
				html += "						<option value=\""+idx+"\" "+selected+">"+idx+"<spring:message code='resh.label.unit' /></option>";/* 개 */
											}
				html += "					</select>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='contLabel'><spring:message code='resh.label.qstn.item.input' /></label>";/* 보기 입력 */
				html += "				</dt>";
				html += "				<dd>";
				html += "					<ul class='tbl-simple dt-sm border-top-grey' id='"+reschPageCd+"EmplUl'></ul>";
				html += "					<div class='field mt10'>";
				html += "						<span><spring:message code='resh.label.choice.etc' /></span>";/* 기타 항목 */
				html += "						<div class='ui toggle checkbox ml20'>";
				html += "							<input type='checkbox' id='"+reschPageCd+"Etc' checked>";
				html += "							<label for='"+reschPageCd+"Etc'></label>";
				html += "						</div>";
				html += "					</div>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "		<li>";
				html += "			<div class='fields toggleDiv mt20 mb20'></div>";
				html += "		</li>";
				html += "	</ul>";
				html += "</div>";
			$("#"+reschPageCd+"QstnForm form[name=reshQstnForm]").append(html);
		},
		// 척도형 보기 폼
		addScaleForm: function(reschPageCd) {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<div class='ui form'>";
				html += "		<p><spring:message code='resh.label.eval.qstn' /></p>";/* 평가 문항 */
				html += "		<div id='"+reschPageCd+"ItemDiv'>";
				html += "			<div class='ui input pb10 scaleMut'>";
				html += "				<div class='ui label mr0'>1</div>";
				html += "				<input type='text' name='reschQstnItemTitle'>";
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "	<div class='fields'>";
				html += "		<div class='field'>";
				html += "			<spring:message code='resh.label.eval.grade' />";/* 평가 등급 */
				html += "		</div>";
				html += "		<div class='field'>";
				html += "			<div class='ui radio checkbox'>";
				html += "				<input type='radio' id='"+reschPageCd+"FiveGrade' value='5' name='reschScaleLvl' onchange='formOption.scaleLvlChg(\""+reschPageCd+"\")' checked/> <label for='"+reschPageCd+"FiveGrade'>5<spring:message code='resh.label.scale.score' /></label>";/* 점 척도 */
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='field'>";
				html += "			<div class='ui radio checkbox'>";
				html += "				<input type='radio' id='"+reschPageCd+"ThreeGrade' value='3' name='reschScaleLvl' onchange='formOption.scaleLvlChg(\""+reschPageCd+"\")' /> <label for='"+reschPageCd+"ThreeGrade'>3<spring:message code='resh.label.scale.score' /></label>";/* 점 척도 */
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "	<ul class='tbl'>";
				html += "		<li id='"+reschPageCd+"GradeLi'></li>";
				html += "	</ul>";
				html += "	<div class='fields toggleDiv mt20 mb20'></div>";
				html += "</div>";
			$("#"+reschPageCd+"QstnForm form[name=reshQstnForm]").append(html);
		},
		// ox형 보기 폼
		addOXForm: function(reschPageCd) {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<ul class='tbl'>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='teamLabel'><spring:message code='resh.label.qstn.item.input' /></label>";/* 보기 입력 */
				html += "				</dt>";
				html += "				<dd>";
				html += "					<div class='ui fields'>";
											for(var i = 1; i <= 2; i++) {
												var oxValue = i == 1 ? "O" : "X";
												var oxClass = i == 1 ? "true" : "false";
				html += "						<div class='field'>";
				html += "							<div class='w100 d-inline-block ui card'>";
				html += "								<div class='checkImg'>";
				html += "									<input id='"+reschPageCd+"OX_"+oxClass+"' name='reshQstnOX' type='radio' value=\""+oxValue+"\">";
				html += "									<label class='imgChk "+oxClass+"' for='"+reschPageCd+"OX_"+oxClass+"'></label>";
				html += "								</div>";
				html += "							</div>";
				html += "						</div>";
											}
				html += "					</div>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "		<li>";
				html += "			<div class='fields toggleDiv mt20 mb20'></div>";
				html += "		</li>";
				html += "	</ul>";
				html += "</div>";
			$("#"+reschPageCd+"QstnForm form[name=reshQstnForm]").append(html);
		},
		// 서술형 보기 폼
		addTextForm: function(reschPageCd) {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<div class='fields toggleDiv mt20 mb20'></div>";
				html += "</div>";
			$("#"+reschPageCd+"QstnForm form[name=reshQstnForm]").append(html);
		},
	 	// 척도형 평가 등급 변경
	    scaleLvlChg: function(reschPageCd, itemList) {
	    	var cnt  = $("#"+reschPageCd+"QstnForm input[name=reschScaleLvl]:checked").val();
	    	var scaleList = <spring:message code='resh.scale.5' />;/* {"5":"매우 그렇다","4":"그렇다","3":"보통","2":"아니다","1":"매우 아니다"} */
	    	if(cnt == 3) {
	    		scaleList = <spring:message code='resh.scale.3' />;/* {"3":"그렇다","2":"보통","1":"아니다"} */
	    	}
	    	if(itemList != null) {
	    		scaleList = itemList;
	    	}
	    	var html = "";
	    	for(var i = cnt; i >= 1; i--) {
	    		var listCnt = itemList != null && cnt == 3 ? i : itemList != null && cnt == 5 ? i - 1 : i;
		    	html += "<dl>";
			    html += "	<dt>";
			    html += "		<div class='ui input'>";
			    html += "			<input type='text' name='scaleScore' class='tc p_w80' value='"+i+"'>";
			    html += "			<div class='ui basic label'><spring:message code='resh.label.score' /></div>";/* 점 */
			    html += "		</div>";
			    html += "	</dt>";
			    html += "	<dd>";
			    html += "		<input type='text' name='scaleTitle' value='"+scaleList[listCnt]+"' />";
			    html += "	</dd>";
			    html += "</dl>";
	    	}
	    	$("#"+reschPageCd+"GradeLi").empty().append(html);
	    },
	 	// 보기 갯수 변경
	    reshQstnChg: function(reschPageCd) {
	    	var emplLiCnt = $("#"+reschPageCd+"QstnForm .emplLi").length;
			var emplCnt   = $("#"+reschPageCd+"QstnForm select[name=emplCnt]").val();
			
			if(emplLiCnt < emplCnt) {
				for(var i = emplLiCnt; i < emplCnt; i++) {
			   	var html  = "<li class='emplLi'>";
			   		html += "	<dl>";
			   		html += "		<dt><spring:message code='resh.label.qstn.item' />"+(i+1)+"</dt>";/* 보기 */
			   		html += "		<dd>";
			   		html += "			<input type='text' name='reschQstnItemTitle' />";
			   		html += "       </dd>";
			   		html += "	</dl>";
			   		html += "</li>";
			 	$("#"+reschPageCd+"EmplUl").append(html);
				}
			} else if(emplLiCnt > emplCnt) {
				for(var i = emplLiCnt; i > emplCnt-1; i--) {
				 	$("#"+reschPageCd+"QstnForm .emplLi:eq("+i+")").remove();
				}
			}
	    },
	    // 필수 선택 버튼
	    toggleReqForm: function(reschPageCd) {
	    	var html  = `<div class="field">`;
	    		html += `	<span><spring:message code="resh.label.choice.mandatory" /></span>`;/* 필수 선택 */
	    		html += `	<div class="ui toggle checkbox ml20">`;
	    		html += `		<input type="checkbox" id="\${reschPageCd}Req">`;
	    		html += `		<label for="\${reschPageCd}Req"></label>`;
	    		html += `	</div>`;
	    		html += `</div>`;
	    	$("#"+reschPageCd+"QstnForm .toggleDiv").append(html);
	    }
	};
	
	// 페이지 이동
	function manageResh(tab) {
		var urlMap = {
			"0" : "/resh/reshMgr/homeReshInfoManage.do",	// 전체설문 정보 상세 페이지
			"1" : "/resh/reshMgr/homeReshQstnManage.do",	// 전체설문 문항 관리 페이지
			"2" : "/resh/reshMgr/homeReshResultManage.do",	// 전체설문 결과 페이지
			"9" : "/resh/reshMgr/Form/homeReshList.do"		// 목록
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	 'val' : "${vo.reschCd}"});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 설문 문항 리스트 불러오기
	function listReshPageQstn() {
		var url  = "/resh/listReshPage.do";
		var data = {
			"reschCd" : "${vo.reschCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var pageList = data.returnList;
        		var qstnCnt = 0;
        		if(pageList.length > 0) {
        			var html = "";
        			pageList.forEach(function(v, i) {
        				var pageTitle = escapeHtml(v.reschPageTitle);
	        				html += `<div class='grid-content-box menu-nth-wrap reschPage page_\${v.reschPageCd}' style='width: calc(100% - 10px)' data-pageCd="\${v.reschPageCd}" data-pageOdr="\${v.reschPageOdr}">`;
	        				html += "	<div class='option-content'>";
	        				html += "		<div class='more-btn'>";
	        				html += "			<i class='expand arrows alternate icon icon-sort'></i>";
	        				html += `			<span>\${v.reschPageOdr }</span>. \${pageTitle }`;
	        				html += "		</div>";
	        				html += "		<div class='mla'>";
	        				html += `			<a href="javascript:addQstnForm('\${v.reschPageCd}')" class="ui blue small button"><spring:message code="resh.button.add.item" /></a>`;/* 문항 추가 */
	        				html += `			<a href="javascript:editQstnPagePop('\${v.reschPageCd }')" class="ui blue small button"><spring:message code="resh.button.modi.page" /></a>`;/* 섹션 수정 */
	        				html += `			<a href="javascript:delReshPage('\${v.reschCd}', '\${v.reschPageCd}', '\${v.reschPageOdr}')" class="ui blue small button"><spring:message code="resh.button.delete" /></a>`;/* 삭제 */
	        				html += "		</div>";
	        				html += "	</div>";
	        				html += `	<div class='mt10 sub-content wmax pl15 sort-qstn\${i}'>`;
        				v.reschQstnList.forEach(function(vv, ii) {
        					qstnCnt += 1;
	        				var qstnTitle = escapeHtml(vv.reschQstnTitle);
        					html += `		<div class='sub-content-box ui form m5 reschQstn' data-qstnCd="\${vv.reschQstnCd}" data-qstnOdr="\${vv.reschQstnOdr}" data-pageCd="\${v.reschPageCd}">`;
        					html += "			<div class='fields m0'>";
        					html += "				<i class='arrows alternate vertical icon icon-chg'></i>";
        					html += "				<div class='field one wide tc'>";
        					html += `					\${v.reschPageOdr }.\${vv.reschQstnOdr }`;
        					html += "				</div>";
        					html += "				<div class='field fourteen wide'>";
        					html += `					<a href="javascript:editQstnForm('\${v.reschPageCd}', '\${vv.reschQstnCd }')">\${qstnTitle }</a>`;
        					html += "				</div>";
        					html += "				<div class='field two wide tc'>";
        					html += `					<a href="javascript:delReshQstn('\${v.reschPageCd}', '\${vv.reschQstnCd}', \${vv.reschQstnOdr})" class="ui basic small button"><spring:message code="resh.button.delete" /></a>`;/* 삭제 */
        					html += "				</div>";
        					html += "			</div>";
        					html += "		</div>";
        				});
        					html += "	</div>";
        					html += "</div>";
        			});
        			$("#reschPageDiv").empty().html(html);
        			$("#reschQstnCnt").text(qstnCnt);
        			
        			$('.grid-content').sortable({
        	            connectWith: '.grid-content',
        	            placeholderClass: '.grid-content-box',
        	            placeholder: "portlet-placeholder",
        	            handle: ".icon-sort",
        	            opacity: 0.6,
        	            stop: function(event, ui) {
        	            	chgPageOdr(ui.item);
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
        	            	chgQstnOdr(ui.item);
        	            }
        	        });
        		} else {
        			$("#reschPageDiv").empty();
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
    
    // 문항 타입 변경
    function qstnTypeChg(reschPageCd) {
    	$("#"+reschPageCd+"QstnForm form[name=reshQstnForm]").empty();
        var type = $("#"+reschPageCd+"WriteForm select[name=reschQstnTypeCd]").val();
        if(type == "SINGLE" || type == "MULTI") {
        	formOption.addChoiceForm(reschPageCd);
        	formOption.toggleReqForm(reschPageCd);
        	formOption.reshQstnChg(reschPageCd);
        } else if(type == "SCALE") {
        	formOption.addScaleForm(reschPageCd);
        	formOption.toggleReqForm(reschPageCd);
        	$("#"+reschPageCd+"QstnForm input[name=reschScaleLvl]").trigger("change");
        } else if(type == "TEXT") {
        	formOption.addTextForm(reschPageCd);
        	formOption.toggleReqForm(reschPageCd);
        } else if(type == "OX") {
        	formOption.addOXForm(reschPageCd);
        	formOption.toggleReqForm(reschPageCd);
        }
        $("#"+reschPageCd+"QstnForm .dropdown").dropdown();
    }
    
    // 문제 폼 초기화
    function initForm(reschPageCd, reschQstnCd) {
    	$("#"+reschPageCd+"QstnForm").remove();
    	formOption.addHeader(reschPageCd);
    	$("div[id^=new_]").css("z-index", "1");
    	qstnTypeChg(reschPageCd);
    	$("#"+reschPageCd+"WriteForm input[name=reschPageCd]").val(reschPageCd);
    	reschQstnCd = reschQstnCd != undefined ? reschQstnCd : "";
    	$("#"+reschPageCd+"WriteForm input[name=reschQstnCd]").val(reschQstnCd);
    	var pageOdr = $(".page_"+reschPageCd).attr("data-pageOdr");
    	var qstnOdr = $(".page_"+reschPageCd).find("div.reschQstn").length+1;
    	$("#"+reschPageCd+"WriteForm input[name=reschQstnTitle]").attr("placeholder", pageOdr+"-"+qstnOdr+" <spring:message code='resh.label.item' />");/* 문항 */
    }
    
    // 문제 추가 폼 출력
    function addQstnForm(reschPageCd) {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	initForm(reschPageCd);
    	$("#"+reschPageCd+"WriteBtn").attr("href", "javascript:writeReshQstn(\""+reschPageCd+"\")");
    }
    
    // 문제 수정 폼 출력
    function editQstnForm(reschPageCd, reschQstnCd) {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	initForm(reschPageCd, reschQstnCd);
    	$("#"+reschPageCd+"WriteBtn").attr("href", "javascript:editReshQstn(\""+reschPageCd+"\")");
    	var url  = "/resh/selectReshQstn.do";
		var data = {
			"reschQstnCd" : reschQstnCd
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var qstnVO = data.returnVO;
        		$("#"+reschPageCd+"WriteForm input[name=reschQstnTitle]").val(qstnVO.reschQstnTitle);
        		editorMap[reschPageCd].insertHTML($.trim(qstnVO.reschQstnCts) == "" ? " " : qstnVO.reschQstnCts);
        		var qstnSelectList = $("#"+reschPageCd+"WriteForm select[name=reschQstnTypeCd]").siblings("div.menu").children();
        		qstnSelectList.each(function() {
        			if($(this).attr("data-value") == qstnVO.reschQstnTypeCd) {
        				$(this).trigger("click");
        			}
        		});
        		// 선택형 적용
        		if(qstnVO.reschQstnTypeCd == "SINGLE" || qstnVO.reschQstnTypeCd == "MULTI") {
        			$("#"+reschPageCd+"QstnForm #"+reschPageCd+"Req").prop("checked", qstnVO.reqChoiceYn == "Y");
        			$("#"+reschPageCd+"QstnForm #"+reschPageCd+"Etc").prop("checked", qstnVO.etcOpinionYn == "Y");
        			var emplCnt = qstnVO.reschQstnItemList.length;
        			qstnVO.reschQstnItemList.forEach(function(v, i) {
        				if(v.reschQstnItemTitle == "SINGLE_ETC_ITEM") {
        					emplCnt -= 1;
        				}
        			});
        			$("#"+reschPageCd+"EmplCnt option[value="+emplCnt+"]").attr("selected", true).trigger("change");
        			qstnVO.reschQstnItemList.forEach(function(v, i) {
        				if(v.reschQstnItemTitle != "SINGLE_ETC_ITEM") {
        					$("#"+reschPageCd+"EmplUl .emplLi").eq(i).find("input[name=reschQstnItemTitle]").val(v.reschQstnItemTitle);
        				}
        			});
        			
        		// 척도형 적용
        		} else if(qstnVO.reschQstnTypeCd == "SCALE") {
        			$("#"+reschPageCd+"QstnForm #"+reschPageCd+"Req").prop("checked", qstnVO.reqChoiceYn == "Y");
        			qstnVO.reschQstnItemList.forEach(function(v, i) {
        				$("#"+reschPageCd+"ItemDiv > .scaleMut:eq("+i+")").find("input[name=reschQstnItemTitle]").val(v.reschQstnItemTitle);
        			});
        			
        			var scaleItemList = [];
        			qstnVO.reschScaleList.forEach(function(v, i) {
        				var idx = i;
        				if(qstnVO.reschScaleList.length == 3) {
        					idx = i + 1;
        					if(i == 2) {
        						scaleItemList[4] = '';
        					}
        				}
        				scaleItemList[idx] = v.scaleTitle;
        			});
        			scaleItemList.reverse();
        			if(qstnVO.reschScaleLvl == 3) {
        				$("#"+reschPageCd+"ThreeGrade").prop("checked", true);
        				formOption.scaleLvlChg(reschPageCd, scaleItemList);
        			} else if(qstnVO.reschScaleLvl == 5) {
        				$("#"+reschPageCd+"FiveGrade").prop("checked", true);
        				formOption.scaleLvlChg(reschPageCd, scaleItemList);
        			}
        		// OX형 적용
        		} else if(qstnVO.reschQstnTypeCd == "OX") {
        			$("#"+reschPageCd+"QstnForm #"+reschPageCd+"Req").prop("checked", qstnVO.reqChoiceYn == "Y");
        		// 서술형 적용
        		} else if(qstnVO.reschQstnTypeCd == "TEXT") {
        			$("#"+reschPageCd+"QstnForm #"+reschPageCd+"Req").prop("checked", qstnVO.reqChoiceYn == "Y");
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
    	if(!reshStartCheck()) {
    		return false;
    	}
    	var kvArr = [];
		kvArr.push({'key' : 'reschTypeCd', 'val' : "HOME"});
		
		submitForm("/resh/reshQstnCopyPop.do", "reshPopIfm", "copy", kvArr);
    }
    
    // 페이지 추가
    function writeQstnPagePop() {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	var kvArr = [];
		kvArr.push({'key' : 'reschCd', 'val' : "${vo.reschCd}"});
		
		submitForm("/resh/reshQstnWritePagePop.do", "reshPopIfm", "writePage", kvArr);
    }
    
    // 페이지 수정
    function editQstnPagePop(reschPageCd) {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	   'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'reschPageCd', 'val' : reschPageCd});
		
		submitForm("/resh/reshQstnEditPagePop.do", "reshPopIfm", "writePage", kvArr);
    }
    
    // 페이지 삭제
    function delReshPage(reschCd, reschPageCd, reschPageOdr) {
    	if(!reshStartCheck()) {
    		return false;
    	}
		var reschQstnCd = "";
		$(".page_"+reschPageCd+" .reschQstn").each(function(i) {
			if(i > 0) {
				reschQstnCd += "|";
			}
			reschQstnCd += $(this).attr("data-qstnCd");
		});
		var confirm = window.confirm(reshQstnJoinCnt(reschQstnCd));
		if(confirm) {
			var url  = "/resh/deleteReshPage.do";
			var data = {
				"reschCd" 	  : reschCd,
				"reschPageCd" : reschPageCd,
				"reschPageOdr": reschPageOdr
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
			 		alert("<spring:message code='resh.alert.delete' />");/* 정상 삭제되었습니다. */
			 		listReshPageQstn();
			     } else {
			      	alert(data.message);
			     }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.page.delete' />");/* 설문 페이지 삭제 중 에러가 발생하였습니다. */
    		});
		}
    }
    
    // 설문 페이지 순서 변경
    function chgPageOdr(item) {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	var pageCd     = item.attr("data-pageCd");
    	var pageOdr    = item.attr("data-pageOdr");
    	var newPageOdr = 1;
    	$("div.reschPage").each(function(i) {
    		if(pageCd == $(this).attr("data-pageCd")) {
    			newPageOdr = i + 1;
    		}
    	});
    	
    	if(pageOdr != newPageOdr) {
    		var searchKey = pageOdr > newPageOdr ? "UP" : "DOWN";

    		var url  = "/resh/editReshPageOdr.do";
    		var data = {
    			"reschCd" 		  : "${vo.reschCd}",
    			"reschPageCd" 	  : pageCd,
    			"reschPageOdr" 	  : pageOdr,
    			"newReschPageOdr" : newPageOdr,
    			"searchKey"		  : searchKey
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		listReshPageQstn();
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.page.sort' />");/* 설문 페이지 순서 변경 중 에러가 발생하였습니다. */
    		});
    	}
    }
    
    // 설문 문항 순서 변경
    function chgQstnOdr(item) {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	var pageCd  = item.attr("data-pageCd");
    	var qstnCd  = item.attr("data-qstnCd");
    	var qstnOdr = item.attr("data-qstnOdr");
    	var newQstnOdr = 1;
    	
    	$("div.page_"+pageCd+" div.reschQstn").each(function(i) {
    		if(qstnCd == $(this).attr("data-qstnCd")) {
    			newQstnOdr = i + 1;
    		}
    	});
    	
    	if(qstnOdr != newQstnOdr) {
    		var searchKey = qstnOdr > newQstnOdr ? "UP" : "DOWN";
    		
    		var url = "/resh/editReshQstnOdr.do";
    		var data = {
    			"reschPageCd" 	  : pageCd,
    			"reschQstnCd"	  : qstnCd,
    			"reschQstnOdr" 	  : qstnOdr,
    			"newReschQstnOdr" : newQstnOdr,
    			"searchKey"		  : searchKey
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		listReshPageQstn();
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.qstn.sort' />");/* 설문 문항 순서 변경 중 에러가 발생하였습니다. */
    		});
    	}
    }
    
    // 설문 문항 저장
    function writeReshQstn(reschPageCd) {
    	if(!validateWriteReshQstnItem(reschPageCd)) {
    		return false;
    	}
    	
    	showLoading();
    	var url = "/resh/writeReshQstn.do";
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data     : $("#"+reschPageCd+"WriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		listReshPageQstn();
        		$(".reshAddForm").remove();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='resh.error.qstn.insert' />");/* 설문 문항 추가 중 에러가 발생하였습니다. */
        });
    }
    
 	// 설문 문항 수정
    function editReshQstn(reschPageCd) {
    	if(!validateWriteReshQstnItem(reschPageCd)) {
    		return false;
    	}
    	
    	showLoading();
    	var url = "/resh/editReshQstn.do";
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#"+reschPageCd+"WriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		listReshPageQstn();
        		$(".reshAddForm").remove();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='resh.error.qstn.update' />");/* 설문 문항 수정 중 에러가 발생하였습니다. */
        });
    }
    
 	// 설문 문항 삭제
    function delReshQstn(reschPageCd, reschQstnCd, reschQstnOdr) {
    	if(!reshStartCheck()) {
    		return false;
    	}
    	var url  = "/resh/selectReshInfo.do";
		var data = {
			"reschTypeCd" : "HOME",
			"reschCd"  	  : "${vo.reschCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var confirm = "";
        		var reshVO  = data.returnVO;
        		if(reshVO.reschJoinUserCnt > 0) {
        			confirm = window.confirm(`<spring:message code="resh.comfirm.home.resh.exist.join.user.y" />`);/* 전체설문 참여자가 있습니다. 삭제 시 전체설문결과가 삭제됩니다.\r\n정말 삭제 하시겠습니까? */
        		} else {
        			confirm = window.confirm("<spring:message code='resh.comfirm.home.resh.exist.join.user.n' />");/* 전체설문 참여자가 없습니다. 삭제 하시겠습니까? */
        		}
        		
        		if(confirm) {
        	    	var url  = "/resh/deleteReshQstn.do";
        			var data = {
        				"reschPageCd"  : reschPageCd,
        				"reschQstnCd"  : reschQstnCd,
        				"reschQstnOdr" : reschQstnOdr
        			};
        			
        			ajaxCall(url, data, function(data) {
        				if (data.result > 0) {
        	        		alert("<spring:message code='resh.alert.delete' />");/* 정상 삭제되었습니다. */
        	        		listReshPageQstn();
        	            } else {
        	             	alert(data.message);
        	            }
            		}, function(xhr, status, error) {
            			alert("<spring:message code='resh.error.qstn.delete' />");/* 설문 문항 삭제 중 에러가 발생하였습니다. */
            		});
            	}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.qstn.delete' />");/* 설문 문항 삭제 중 에러가 발생하였습니다. */
		});
    }
 	
 	// 설문 문항 참여자 수 조회
 	function reshQstnJoinCnt(reschQstnCd) {
 		var message = "";
 		var url     = "/resh/reshQstnJoinUserCnt.do";
		var data    = {
			"reschQstnCd" : reschQstnCd
		};
		
		showLoading();
		$.ajax({
            url  : url,
            type : "get",
            async: false,
            data : data,
        }).done(function(data) {
        	hideLoading();
        	if(data.result == 0) {
        		message = "<spring:message code='resh.confirm.exist.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
        	} else if(data.result > 0) {
        		message = `<spring:message code='resh.confirm.exist.answer.user.y' />`;/* 설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.\r\n정말 삭제하시겠습니까? */
        	}
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        });
		
		return message;
 	}
    
    // 설문 문항 유효성 체크
    function validateWriteReshQstnItem(reschPageCd) {
    	$("#"+reschPageCd+"WriteForm").find("input[name=reschQstnItemTitles]").remove();
        $("#"+reschPageCd+"WriteForm").find("input[name=scaleTitles]").remove();
        $("#"+reschPageCd+"WriteForm").find("input[name=scaleScores]").remove();
        $("#"+reschPageCd+"WriteForm").find("input[name=reschScaleLvl]").remove();
        $("#"+reschPageCd+"WriteForm").find("input[name=reqChoiceYn]").remove();
        $("#"+reschPageCd+"WriteForm").find("input[name=etcOpinionYn]").remove();
        $("#"+reschPageCd+"WriteForm").find("input[name=jumpChoiceYn]").remove();
    	
    	var isValid 		= true;
    	var reschQstnTypeCd = $("#"+reschPageCd+"WriteForm select[name=reschQstnTypeCd]").val();
    	var reschPageCd     = $("#"+reschPageCd+"WriteForm input[name=reschPageCd]").val();
    	
    	if($.trim($("#"+reschPageCd+"WriteForm input[name=reschQstnTitle]").val()) == "") {
    		$("#"+reschPageCd+"WriteForm input[name=reschQstnTitle]").val($("#"+reschPageCd+"WriteForm input[name=reschQstnTitle]").attr("placeholder"));
    	}
    	
    	if(editorMap[reschPageCd].isEmpty() || editorMap[reschPageCd].getTextContent().trim() === "") {
    		alert("<spring:message code='resh.alert.input.contents' />");/* 내용을 입력하세요. */
    		return false;
    	}
    	
    	// 단일, 다중 선택형
		if(reschQstnTypeCd == "SINGLE" || reschQstnTypeCd == "MULTI") {
			$("#"+reschPageCd+"QstnForm").find($("input[name=reschQstnItemTitle]")).each(function(i) {
				if($(this).val() == "") {
					alert("<spring:message code='resh.alert.qstn.item' />");/* 보기를 입력하세요. */
					isValid = false;
					return false;
				}
				$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reschQstnItemTitles' value='"+ $(this).val() +"' />");
			});
			var reqChoiceYn = $("#"+reschPageCd+"QstnForm").find($("#"+reschPageCd+"Req")).is(":checked") ? "Y" : "N";
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reqChoiceYn' value='"+reqChoiceYn+"' />");
			var etcOpinionYn = $("#"+reschPageCd+"QstnForm").find($("#"+reschPageCd+"Etc")).is(":checked") ? "Y" : "N";
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='etcOpinionYn' value='"+etcOpinionYn+"' />");
			if($("#"+reschPageCd+"QstnForm").find($("#"+reschPageCd+"Etc")).is(":checked")) {
				$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reschQstnItemTitles' value='SINGLE_ETC_ITEM' />");
			}
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='jumpChoiceYn' value='N' />")
    	}
    	
    	// 척도형
    	if(reschQstnTypeCd == "SCALE") {
			$("#"+reschPageCd+"QstnForm").find($("input[name=reschQstnItemTitle]")).each(function(i) {
				if($(this).val() == "") {
					alert("<spring:message code='resh.alert.input.title' />");/* 제목을 입력하세요. */
					isValid = false;
					return false;
				}
				$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reschQstnItemTitles' value='" + $(this).val() +"' />");
			});
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reschScaleLvl' value='"+ $("#"+reschPageCd+"QstnForm").find("input[name=reschScaleLvl]:checked").val() +"' />");
			$("#"+reschPageCd+"QstnForm").find($("input[name=scaleScore]")).each(function(i) {
				if($(this).val() == "") {
					alert("<spring:message code='resh.alert.scale.score' />");/* 척도 점수를 입력하세요. */
					isValid = false;
					return false;
				}
				$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='scaleScores' value='" + $(this).val() +"' />");
			});
			$("#"+reschPageCd+"GradeLi").find($("input[name=scaleTitle]")).each(function(i) {
				if($(this).val() == "") {
					alert("<spring:message code='resh.alert.input.title' />");/* 제목을 입력하세요. */
					isValid = false;
					return false;
				}
				$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='scaleTitles' value='" + $(this).val() +"' />");
			});
			var reqChoiceYn = $("#"+reschPageCd+"QstnForm").find($("#"+reschPageCd+"Req")).is(":checked") ? "Y" : "N";
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reqChoiceYn' value='"+reqChoiceYn+"' />");
    	}
    	
    	// OX형
    	if(reschQstnTypeCd == "OX") {
			$("#"+reschPageCd+"QstnForm").find($("input[name=reshQstnOX]")).each(function(i) {
				$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reschQstnItemTitles' value='" + $(this).val() +"' />");
			});
			var reqChoiceYn = $("#"+reschPageCd+"QstnForm").find($("#"+reschPageCd+"Req")).is(":checked") ? "Y" : "N";
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reqChoiceYn' value='"+reqChoiceYn+"' />");
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='jumpChoiceYn' value='N' />");
		}
    	
    	// 서술형
    	if(reschQstnTypeCd == "TEXT") {
    		var reqChoiceYn = $("#"+reschPageCd+"QstnForm").find($("#"+reschPageCd+"Req")).is(":checked") ? "Y" : "N";
			$("#"+reschPageCd+"WriteForm").append("<input type='hidden' name='reqChoiceYn' value='"+reqChoiceYn+"' />");
    	}
    	
    	return isValid;
    }
    
    // 설문 출제 완료 처리
    function updateReshSubmitYn(type) {
    	if(reshStartCheck(type)) {
	    	if($(".reschQstn").length == 0) {
	    		alert("<spring:message code='resh.alert.qstn.item.submit' />");/* 설문 문항 추가 후 출제완료 가능합니다. */
	    		return false;
	    	}
	    	var url  = "/resh/editReshSubmitYn.do";
			var data = {
				"reschCd"     : "${vo.reschCd}",
				"searchGubun" : type
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(type == "save") {
		        		alert("<spring:message code='resh.alert.qstn.submit.y' />");/* 문항 출제가 완료되었습니다. */
					}
	        		location.reload();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='resh.error.qstn.submit' />");/* 설문 문항 출제 중 에러가 발생하였습니다. */
			});
    	}
    }
 	
 	// 엑셀 문항 등록
 	function reshQstnExcelUploadPop() {
 		if(!reshStartCheck()) {
    		return false;
    	}
 		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 'val' : "${vo.reschCd}"});
		
		submitForm("/resh/reshQstnExcelUploadPop.do", "reshPopIfm", "excelUpload", kvArr);
 	}
 	
 	// 설문 시작 여부 확인
 	function reshStartCheck(type) {
 		// 출제 완료 여부
		var isSubmit = "${vo.reschSubmitYn}" == "Y";
		// 시작 전 여부
		var isWait	 = "${vo.reschStatus}" == "대기";
		// 제출자 여부
		var isJoin   = parseInt("${vo.reschJoinUserCnt}") > 0;
		if(isSubmit && type != "edit") {
			alert("<spring:message code='exam.alert.click.edit.submit.btn' />");/* 수정 버튼 클릭 후 문제 수정이 가능합니다. */
			return false;
		}
		if(isSubmit && type == "edit" && isWait && isJoin) {
			var confirm = window.confirm("<spring:message code='resh.confirm.answer.user.y.edit.item' />");/* 설문 응시자가 있습니다. 설문 문항을 수정하시겠습니까? */
			if(confirm) {
				return true;
			} else {
				return false;
			}
		}
		
		return true;
 	}
 	
 	// 문항 추가 폼 취소
 	function writeReshQstnCancel(reschPageCd) {
 		$("#"+reschPageCd+"QstnForm").hide();
 	}
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

		<div id="container">
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
		       	<div class="ui form">
		       		<div class="layout2">
				        <div id="info-item-box">
				        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh.home" /><!-- 전체설문 -->
                            </h2>
                            <div class="button-area">
                            	<c:choose>
                            		<c:when test="${vo.reschSubmitYn ne 'Y' }">
                            			<a href="javascript:updateReshSubmitYn('save')" class="ui blue button"><spring:message code="resh.button.qstn.submit" /></a><!-- 저장 및 출제 -->
                            		</c:when>
                            		<c:otherwise>
                            			<a href="javascript:updateReshSubmitYn('edit')" class="ui blue button"><spring:message code="resh.button.modify" /></a><!-- 수정 -->
                            		</c:otherwise>
                            	</c:choose>
								<a href="javascript:manageResh(9)" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
                            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
				        		<div class="listTab">
					                <ul>
					                    <li class="mw120"><a onclick="manageResh(0)"><spring:message code="resh.label.resh.home.info" /><!-- 전체설문정보 --></a></li>
					                    <li class="select mw120"><a onclick="manageResh(1)"><spring:message code="resh.tab.item.manage" /></a></li><!-- 문항 관리 -->
					                    <li class="mw120"><a onclick="manageResh(2)"><spring:message code="resh.label.resh.home.result" /><!-- 전체설문결과 --></a></li>
					                </ul>
					            </div>
					            <div class="ui styled fluid accordion week_lect_list mt15" style="border: none;">
                                    <div class="title active flex">
                                        <div class="title_cont wmax">
                                            <div class="left_cont">
                                                <div class="lectTit_box">
                                                	<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschStartDttm }" />
													<fmt:formatDate var="reschStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschEndDttm }" />
													<fmt:formatDate var="reschEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
                                                    <p class="lect_name">${vo.reschTitle }</p>
                                                    <span class="fcGrey"><small><spring:message code="resh.label.resh.home.period" /><!-- 전체설문 기간 --> : ${reschStartDttm } ~ ${reschEndDttm }</small></span>
                                                </div>
                                            </div>
                                        </div>
                                        <i class="dropdown icon ml20"></i>
                                    </div>
                                    <div class="content p0 active">
                                        <div class="ui segment transition visible">
                                            <ul class="tbl">
                                            	<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="resh.label.resh.home.cts" /><!-- 전체설문 내용 --></label>
														</dt>
														<dd><pre>${vo.reschCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.resh.home.result" /><!-- 전체설문결과 --> <spring:message code="resh.label.open.y" /><!-- 공개 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.rsltTypeCd eq 'ALL' || vo.rsltTypeCd eq 'JOIN' }">
																	<spring:message code="resh.common.yes" /><!-- 예 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="resh.common.no" /><!-- 아니오 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
				        	</div>
				        </div>
				        
					    <div class="ui segment">
							<div class="flex mb10">
								<h3><spring:message code="resh.common.search.all" /> : <span id="reschQstnCnt">${vo.reschQstnCnt }</span><spring:message code="resh.label.item" /></h3><!-- 전체 --><!-- 문항 -->
							    <div class="button-area mla">
							        <a href="javascript:writeQstnPagePop()" class="ui blue small button"><spring:message code="resh.button.add.page" /></a><!-- 섹션 추가 -->
							        <a href="javascript:copyQstnList()" class="ui blue small button"><spring:message code="resh.label.resh.copy" /></a><!-- 설문 가져오기 -->
							        <a href="javascript:reshQstnExcelUploadPop()" class="ui blue small button"><spring:message code="resh.button.reg.file" /></a><!-- 엑셀로 등록 -->
							    </div>
							</div>
							<div class="grid-content modal-type ui-sortable" id="reschPageDiv">
							</div>
							<div class="ui small error message">
								<p>
			                        <i class="info circle icon"></i>
			                        <spring:message code="resh.label.qstn.submit.info1" /><!-- 출제완료 클릭 전에는 임시저장 상태입니다. -->
		                        </p>
		                        <p>
			                        <i class="info circle icon"></i>
			                        <spring:message code="resh.label.qstn.submit.info2" /><!-- 문항 출제완료되면 '출제완료' 버튼을 반드시 클릭해 주세요. -->
		                        </p>
		                    </div>
						</div>
						<div class="option-content">
							<div class="mla">
                            	<c:choose>
                            		<c:when test="${vo.reschSubmitYn ne 'Y' }">
                            			<a href="javascript:updateReshSubmitYn('save')" class="ui blue button"><spring:message code="resh.button.qstn.submit" /></a><!-- 저장 및 출제 -->
                            		</c:when>
                            		<c:otherwise>
                            			<a href="javascript:updateReshSubmitYn('edit')" class="ui blue button"><spring:message code="resh.button.modify" /></a><!-- 수정 -->
                            		</c:otherwise>
                            	</c:choose>
								<a href="javascript:manageResh(9)" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
                            </div>
						</div>
		       		</div>
		       	</div>
			</div>
	        <!-- //본문 content 부분 -->
	        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	    </div>
    </div>

</body>

</html>