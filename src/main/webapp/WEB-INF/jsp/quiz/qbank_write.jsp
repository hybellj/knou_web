<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		qstnTypeChg();
		
		if(${not empty vo.examQbankCtgrCd}) {
			editSetValue();
		}
	});
	
	var formOption = {
		// 단일 선택, 선다형 보기 폼
		addChoiceForm: function() {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<ul class='tbl border-top-grey'>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='rgtAnsr1'><spring:message code='exam.label.qstn.item.input' /></label>";/* 보기 입력 */
				html += "				</dt>";
				html += "				<dd>";
				html += "					<ul class='tbl-simple dt-sm border-top-grey' id='emplUl'></ul>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "	</ul>";
				html += "</div>";
			$("#qbankWriteDiv").append(html);
		},
		// 단답형 입력 폼
		addShortForm: function() {
			var	html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<div class='ui small error message'><i class='info circle icon'></i><spring:message code='exam.label.qstn.short.info' /></div>";/* 유사답안 입력은 5개 까지 가능합니다. */
				html += "	<ul class='tbl border-top-grey'>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
				html += "				</dt>";
				html += "				<dd id='addQstnDiv'>";
				html += "					<div class='ui action fluid input mt10 shortInput gap8 flex-wrap'>";
				for(var i = 0; i < 5; i ++) {
				html += "						<input type='text' name='rgtAnsr1' class='japanInput' style='max-width:8em'>";
				}
				html += "						<button class='ui icon button' onclick='addQstnInput()'><i class='plus icon'></i></button>";
				html += "					</div>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "		<li id='shortGubun'>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='teamLabel'><spring:message code='exam.label.answer.type' /></label>";/* 정답 유형 */
				html += "				</dt>";
				html += "				<dd>";
				html += "					<div class='fields'>";
				html += "						<div class='field'>";
				html += "							<div class='ui radio checkbox'>";
				html += "								<input type='radio' id='rgtTypeA' name='multiRgtChoiceTypeCd' value='A' tabindex='0' class='hidden' checked>";
				html += "								<label for='rgtTypeA'><spring:message code='exam.label.answer.order' /></label>";/* 순서에 맞게 정답 */
				html += "							</div>";
				html += "						</div>";
				html += "						<div class='field'>";
				html += "							<div class='ui radio checkbox'>";
				html += "								<input type='radio' id='rgtTypeB' name='multiRgtChoiceTypeCd' value='B' tabindex='0' class='hidden'>";
				html += "								<label for='rgtTypeB'><spring:message code='exam.label.answer.not.order' /></label>";/* 순서에 상관없이 정답 */
				html += "							</div>";
				html += "						</div>";
				html += "					</div>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "	</ul>";
				html += "</div>";
			$("#qbankWriteDiv").append(html);			
		},
		// OX형 선택 홈
		addOXForm: function() {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<ul class='tbl border-top-grey'>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
				html += "				</dt>";
				html += "				<dd>";
											for(var i = 1; i <= 2; i++) {
												var classStr = i == 1 ? "true" : "false";
				html += "					<div class='w100 mr15 d-inline-block ui card'>";
				html += "						<div class='checkImg'>";
				html += "							<input id='qbankQstnOX_"+classStr+"' name='rgtAnsr1' type='radio' value="+i+">";
				html += "							<label class='imgChk "+classStr+"' for='qbankQstnOX_"+classStr+"'></label>";
				html += "						</div>";
				html += "					</div>";
											}
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "	</ul>";
				html += "</div>";
			$("#qbankWriteDiv").append(html);
		},
		// 짝짓기 선택 폼
		addMatchForm: function() {
			var html  = "<div class='field mt20 qstnTypeDiv'>";
				html += "	<ul class='tbl border-top-grey'>";
				html += "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='teamLabel'><spring:message code='exam.label.input.answer' /></label>";/* 정답 입력 */
				html += "				</dt>";
				html += "				<dd id='emplDd'></dd>";
				html += "			</dl>";
				html += "		</li>";
				html += "	</ul>";
				html += "</div>";
			$("#qbankWriteDiv").append(html);
		},
		// 보기 개수 박스 추가
		addEmplCnt: function(type) {
			var	html  = "		<li>";
				html += "			<dl>";
				html += "				<dt>";
				html += "					<label for='emplCnt'><spring:message code='exam.label.qstn.item.cnt' /></label>";/* 보기 갯수 */
				html += "				</dt>";
				html += "				<dd>";
				html += "					<select class='ui dropdown w150' id='emplCnt' name='emplCnt' onchange='qbankQstnChg()'>";
											for(var i = 2; i <= 10; i++) {
												var selected = (type == "CHOICE" || type == "MULTICHOICE") && i == 4 ? "selected" : "";
				html += "						<option value="+i+" "+selected+">"+i+"<spring:message code='exam.label.unit' /></option>";/* 개 */
											}
				html += "					</select>";
				html += "				</dd>";
				html += "			</dl>";
				html += "		</li>";
			$(".qstnTypeDiv > ul.tbl.border-top-grey").prepend(html);
			qbankQstnChg();
		}
	};
	
 	// 분류코드 등록 팝업
	function writeQbankCtgr() {
 		var kvArr = [];
		kvArr.push({'key' : 'crsNo', 	'val' : "${vo.crsNo}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});
		
		submitForm("/quiz/writeQbankCtgrPop.do", "quizPopIfm", "qbankCtgr", kvArr);
	}
 	
 	// 수정 시 값 적용
 	function editSetValue() {
 		var ctgrCd = "${vo.parExamQbankCtgrCd}" != "" ? "${vo.parExamQbankCtgrCd}" : "${vo.examQbankCtgrCd}";
 		$("#parCtgrCd").val(ctgrCd).trigger("change");
 		$("#title").attr("placeholder", "${vo.qstnNo}-${vo.subNo} <spring:message code='exam.label.qstn' />");/* 문제 */
		$("#qstnTypeSelect").val("${vo.qstnTypeCd}").trigger("change");

		var qstnTypeCd = "${vo.qstnTypeCd}";
		var emplList   = [
			  _.unescape('${vo.empl1}')
			, _.unescape('${vo.empl2}')
			, _.unescape('${vo.empl3}')
			, _.unescape('${vo.empl4}')
			, _.unescape('${vo.empl5}')
			, _.unescape('${vo.empl6}')
			, _.unescape('${vo.empl7}')
			, _.unescape('${vo.empl8}')
			, _.unescape('${vo.empl9}')
			, _.unescape('${vo.empl10}')];
		console.log(emplList)
		// 객관식
		if(qstnTypeCd == "CHOICE" || qstnTypeCd == "MULTICHOICE") {
			$("#emplCnt").val("${vo.emplCnt}").trigger("change");
			var rgtAnsr1 = "${vo.rgtAnsr1}".split(",");
			rgtAnsr1.forEach(function(v, i) {
				$("input[name=rgtAnsr1][value="+v+"]").attr("checked", true);
			});
			var emplCnt = 0;
			if(${not empty vo.emplCnt}) {
				emplCnt = "${vo.emplCnt}";
			}
			for(var i = 0; i < emplCnt; i++) {
				$("input[name=empl"+(i+1)+"]").val(emplList[i]);
			}
		
		// 주관식(단답형)
		} else if(qstnTypeCd == "SHORT") {
			$("input[name=multiRgtChoiceTypeCd][value=${vo.multiRgtChoiceTypeCd}]").trigger("click");
			var rgtAnsrArr = ["${vo.rgtAnsr1}", "${vo.rgtAnsr2}", "${vo.rgtAnsr3}", "${vo.rgtAnsr4}", "${vo.rgtAnsr5}"];
			rgtAnsrArr.forEach(function(v, i) {
				if(v == "") {
					return;
				}
				if(i > 0) {
					addQstnInput();
				}
				v.split("|").forEach(function(vv, ii) {
					$(".shortInput").eq(i).find("input[name^=rgtAnsr]:eq("+ii+")").val(vv);
				});
			});
			
		// OX형
		} else if(qstnTypeCd == "OX") {
			$("input[name=rgtAnsr1][value='${vo.rgtAnsr1}']").trigger("click");
			
		// 짝짓기형
		} else if(qstnTypeCd == "MATCH") {
			$("#emplCnt").val("${vo.emplCnt}").trigger("change");
			var emplCnt = 0;
			if(${not empty vo.emplCnt}) {
				emplCnt = "${vo.emplCnt}";
			}
			for(var i = 0; i < emplCnt; i++) {
				$("input[name=empl"+(i+1)+"]").val(emplList[i]);
			}
			var rgtAnsr1 = "${vo.rgtAnsr1}".split("|");
			rgtAnsr1.forEach(function(v, i) {
				$("input[name=rgtAnsr1]:eq("+i+")").val(v);
			});
		}
 	}
    
	// 보기 갯수 변경
    function qbankQstnChg() {
    	var type = $("#qstnTypeSelect").val();
    	var emplCnt = $("#emplCnt").val();
    	// 객관식
    	if(type == "CHOICE" || type == "MULTICHOICE") {
	    	var emplLiCnt = $(".emplLi").length;
	    	
	    	if(emplLiCnt < emplCnt) {
		    	for(var i = emplLiCnt; i < emplCnt; i++) {
				   	var html  = "<li class='emplLi'>";
				   		html += "	<dl>";
				   		html += "		<dt>";
				   		if(type == "CHOICE") {
				   		html += "			<div class='ui radio checkbox'>";
				   		html += "				<input type='radio' id='rgtAnsr"+(i+1)+"' name='rgtAnsr1' value='"+(i+1)+"'>";
				   		} else if(type == "MULTICHOICE") {
				   		html += "			<div class='ui checkbox'>";
				   		html += "				<input type='checkbox' id='rgtAnsr"+(i+1)+"' name='rgtAnsr1' value='"+(i+1)+"'>";
				   		}
				   		html += "				<label class='toggle_btn' for='rgtAnsr"+(i+1)+"'><spring:message code='exam.label.qstn.item' />"+(i+1)+"</label>";/* 보기 */
				   		html += "			</div>";
				   		html += "		</dt>";
				   		html += "		<dd><input type='text' name='empl"+(i+1)+"' class='japanInput' /></dd>";
				   		html += "	</dl>";
				   		html += "</li>";
			    	$("#emplUl").append(html);
		    	}
	    	} else if(emplLiCnt > emplCnt) {
		    	for(var i = emplLiCnt; i > emplCnt-1; i--) {
		    	 	$(".emplLi:eq("+i+")").remove();
		    	}
	    	}
	    	
	    // 짝짓기형
    	} else if(type == "MATCH") {
    		var emplDivCnt = $(".emplDiv").length;
    		
    		if(emplDivCnt < emplCnt) {
    			for(var i = emplDivCnt; i < emplCnt; i++) {
    				var classNm = "num0"+(i+1);
    				var html  = "<div class='line-sortable-box emplDiv'>";
    					html += "	<div class='account-list p10'>";
    					html += "		<div class='line-box "+classNm+"'>";
    					html += "			<div class='question p20 pl45'>";
    					html += "				<input type='text' name='empl"+(i+1)+"' class='japanInput' placeholder='"+"<spring:message code='exam.label.qstn.item' /> <spring:message code='exam.label.input' />"+"'/>";/* 보기 *//* 입력 */
    					html += "			</div>";
    					html += "			<div class='slot'><input type='text' name='rgtAnsr1' class='japanInput' placeholder='"+"<spring:message code='exam.label.input.answer' />"+"' /></div>";/* 정답 입력 */
    					html += "		</div>";
    					html += "	</div>";
    					html += "</div>";
    				$("#emplDd").append(html);
    			}
    		} else if(emplDivCnt > emplCnt) {
    			for(var i = emplDivCnt; i > emplCnt-1; i--) {
    				$(".emplDiv:eq("+i+")").remove();
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
    function qstnTypeChg() {
    	$(".qstnTypeDiv").remove();
        var type = $("#qstnTypeSelect").val();
        if(type == "CHOICE" || type == "MULTICHOICE") {
        	formOption.addChoiceForm();
        	formOption.addEmplCnt(type);
        } else if(type == "SHORT") {
        	formOption.addShortForm();
        } else if(type == "OX") {
        	formOption.addOXForm();
        } else if(type == "MATCH") {
        	formOption.addMatchForm();
        	formOption.addEmplCnt(type);
        }
        $(".qstnTypeDiv .dropdown").dropdown();
        
     	// 일본어입력기 적용
    	setJapaneseInput();
    }
    
    // 주관식(단답형) 문항 추가
    function addQstnInput() {
    	var shortInputCnt = $(".shortInput").length;
    	if(shortInputCnt == 5) {
    		return false;
    	}
    	var html =  "<div class='ui action fluid input mt10 shortInput gap8 flex-wrap'>";
    		for(var i = 0; i < 5; i++) {
    		html += "	<input type='text' name='rgtAnsr"+(shortInputCnt+1)+"' class='japanInput' style='max-width:8em'>";
    		}
    		html += "	<button class='ui icon button' onclick='delQstnInput(this)'><i class='minus icon'></i></button>";
    		html += "	<button class='ui icon button' onclick='addQstnInput()'><i class='plus icon'></i></button>";
    		html += "</div>";
    	$("#addQstnDiv").append(html);
    	// 일본어입력기 적용
    	setJapaneseInput();
    }
    
    // 주관식(단답형) 문항 제거
    function delQstnInput(obj) {
    	var delCnt = $(obj).siblings("div").children("input").attr("name").substring(7);
    	$("input[name^=rgtAnsr]").each(function(i, v) {
    		var thisCnt = $(v).attr("name").substring(7);
    		if(thisCnt > delCnt) {
    			$(v).attr("name", "rgtAnsr"+(parseInt(thisCnt)-1));
    		}
    	});
    	$(obj).parent().remove();
    }
    
    // 목록
    function listQbank() { 
    	var kvArr = [];
    	kvArr.push({'key' : 'crsNo', 	'val' : "${vo.crsNo}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});
		
		submitForm("/quiz/Form/qbankList.do", "", "", kvArr);
    }
    
    // 하위 분류 목록 가져오기
    function chgCtgrCd(obj) {
    	var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"parExamQbankCtgrCd" : $(obj).val(),
			"userId"			 : "${creCrsVO.userId}",
			"searchType"		 : "UNDER"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		html = "<option value=''><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
	        			html += `<option value="\${v.examQbankCtgrCd}">\${v.examCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#ctgrCd").empty().append(html);
        		$("#ctgrCd").dropdown("clear");
        		$("#ctgrCd").trigger("change");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
    }
    
    // 특정 분류코드 순서 가져오기
    function selectQstnNo() {
    	var examQbankCtgrCd = "";
    	if($("#ctgrCd").val() == "") {
    		examQbankCtgrCd = $("#parCtgrCd").val();
    	} else {
    		examQbankCtgrCd = $("#ctgrCd").val();
    	}
    	
    	var url  = "/quiz/selectQbankQstnNos.do";
		var data = {
			"examQbankCtgrCd" : examQbankCtgrCd
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnVO = data.returnVO;
        		$("#title").attr("placeholder", returnVO.qstnNo + "-" + returnVO.subNo + " <spring:message code='exam.label.qstn' />");/* 문제 */
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
    }
    
    // 문제은행 등록, 수정
    function saveQbankQstn() {
    	if(!validateWriteQbankQstn()) {
    		return false;
    	}
    	
    	var url = "";
    	if(${empty vo.examQbankQstnSn }) {
    		url = "/quiz/writeQbank.do";
    	} else {
    		url = "/quiz/editQbank.do";
    	}
    	
    	var data = $("#qbankWriteForm").serialize();
    	
    	ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var form = $("<form></form>");
        		form.attr("method", "POST");
        		form.attr("name", "moveform");
        		form.attr("action", "/quiz/Form/qbankList.do");
        		form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '${creCrsVO.crsCreCd}'}));
        		form.append($('<input/>', {type: 'hidden', name: "crsNo", value: '${crsVO.crsCd}'}));
        		form.appendTo("body");
        		form.submit();
        		
        		$("form[name='moveform']").remove();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
		});
    }
    
    // 문제은행 삭제
    function delQbankQstn(examQbankQstnSn) {
    	var url  = "/quiz/delQbank.do";
		var data = {
    			"examQbankQstnSn" : examQbankQstnSn,
    			"mdfrId"			  : "${creCrsVO.userId }"
    		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
        		listQbank();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
		});
    }
    
    // 문제은행 유효성 검사
    function validateWriteQbankQstn() {
    	$("#qbankWriteForm").find("input[name=examQbankCtgrCd]").remove();
    	$("#qbankWriteForm").find("input[name=title]").remove();
    	$("#qbankWriteForm").find("input[name=qstnTypeCd]").remove();
    	$("#qbankWriteForm").find("input[name=multiRgtChoiceYn]").remove();
    	$("#qbankWriteForm").find("input[name=multiRgtChoiceTypeCd]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr1]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr2]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr3]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr4]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr5]").remove();
    	$("#qbankWriteForm").find("input[name=qstnNo]").remove();
    	$("#qbankWriteForm").find("input[name=subNo]").remove();
    	$("#qbankWriteForm").find("input[name=qstnCts]").remove();
    	for(var i = 1; i <= 10; i++) {
	    	$("#qbankWriteForm").find("input[name=empl"+i+"]").remove();
    	}
    	var isValid = true;
    	
    	var titleHolder = $("#title").attr("placeholder").split(/:|\-| /);
    	var qstnNo 		= titleHolder[0];
    	var subNo 		= titleHolder[1];
    	
    	$("#qbankWriteForm").append("<input type='hidden' name='qstnNo' value='" + qstnNo + "' />");
    	$("#qbankWriteForm").append("<input type='hidden' name='subNo' value='" + subNo + "' />");
    	
    	if($("#parCtgrCd").val() == "" || $("#parCtgrCd").val() == null) {
    		$("#qbankWriteForm").append("<input type='hidden' name='examQbankCtgrCd' value='-' />");
    	} else {
    		if($("#ctgrCd").val() == "") {
    			$("#qbankWriteForm").append("<input type='hidden' name='examQbankCtgrCd' value='" + $("#parCtgrCd").val() + "' />");
    		} else {
    			$("#qbankWriteForm").append("<input type='hidden' name='examQbankCtgrCd' value='" + $("#ctgrCd").val() + "' />");
    		}
    	}
    	
    	if($.trim($("#title").val()) == "") {
    		$("#qbankWriteForm").append("<input type='hidden' name='title' value='" + $("#title").attr("placeholder") + "' />");
    	} else {
    		$("#qbankWriteForm").append("<input type='hidden' name='title' value='" + $("#title").val() + "' />");
    	}
    	
    	var qstnTypeCd = $("#qstnTypeSelect").val();
    	$("#qbankWriteForm").append("<input type='hidden' name='qstnTypeCd' value='" + qstnTypeCd + "' />");
    	
    	// 객관식
    	if(qstnTypeCd == "CHOICE" || qstnTypeCd == "MULTICHOICE") {
    		var rgtAnsrChkLen = $("input[name=rgtAnsr1]:checked").length;
    		if(rgtAnsrChkLen == 0) {
    			alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
        		return false;
    		} else {
    			var multiRgtChoiceYn = rgtAnsrChkLen > 1 ? "Y" : "N";
    			$("#qbankWriteForm").append("<input type='hidden' name='multiRgtChoiceYn' value='" + multiRgtChoiceYn + "' />");
				var rgtAnsr1 = "";
    			$("input[name=rgtAnsr1]:checked").each(function(i) {
    				if(i > 0) {
    					rgtAnsr1 += ",";
    				}
    				rgtAnsr1 += $(this).val();
    			});
    			$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr1' value='" + rgtAnsr1 + "' />");
    		}
    		
    		var emplCnt = $("#emplCnt").val();
    		for(var i = 1; i <= emplCnt; i++) {
    			if($.trim($("input[name=empl"+i+"]").val()) == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			$("#qbankWriteForm").append("<input type='hidden' name='empl"+i+"' value='" + $.trim($("input[name=empl"+i+"]").val()) +"' />");
    		}
    		
    	// 주관식(단답형)
    	} else if(qstnTypeCd == "SHORT") {
    		$(".shortInput").each(function(i) {
    			var rgtAnsr = "";
    			if($(this).find("input[name^=rgtAnsr]").val() == "") {
    				alert((i+1)+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
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
    			$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr"+(i+1)+"' value='" + rgtAnsr +"' />");
    		});
    		var multiRgtChoiceYn = $(".shortInput").length > 1 ? "Y" : "N";
    		$("#qbankWriteForm").append("<input type='hidden' name='multiRgtChoiceYn' value=\"" + multiRgtChoiceYn + "\" />");
    		$("#qbankWriteForm").append("<input type='hidden' name='multiRgtChoiceTypeCd' value='" + $("input[name=multiRgtChoiceTypeCd]:checked").val() +"' />");
    		
    	// OX형
    	} else if(qstnTypeCd == "OX") {
    		if($("input[name=rgtAnsr1]:checked").val() == undefined) {
    			alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
    			return false;
    		} else {
    			$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr1' value='" + $("input[name=rgtAnsr1]:checked").val() +"' />");
    		}
    		
    	// 짝짓기형
    	} else if(qstnTypeCd == "MATCH") {
    		var matchCnt = $("#emplCnt").val();
    		for(var i = 1; i <= matchCnt; i++) {
    			if($.trim($("input[name=empl"+i+"]").val()) == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			$("#qbankWriteForm").append("<input type='hidden' name='empl"+i+"' value='" + $.trim($("input[name=empl"+i+"]").val()) +"' />");
    		}
    		var rgtAnsr1 = "";
    		$("input[name=rgtAnsr1]").each(function(i) {
    			if($.trim($(this).val()) == "") {
    				alert((i+1)+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			if(i > 0) {
    				rgtAnsr1 += "|";
    			}
    			rgtAnsr1 += $.trim($(this).val());
    		});
    		$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr1' value='" + rgtAnsr1 +"' />");
    	}
    	if(isValid) {
    		$("#qbankWriteForm").append("<input type='hidden' name='qstnCts' />");
    		$("#qbankWriteForm input[name=qstnCts]").val(editor.getPublishingHtml());
    	}
    	return isValid;
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
        				<spring:message code='exam.button.reg' var="save" /><!-- 등록 -->
        				<spring:message code='exam.button.mod' var="modify" /><!-- 수정 -->
        				<c:set var="qbankInfo"><spring:message code='exam.label.qstn' /> ${empty vo.examQbankQstnSn ? save : modify }</c:set>
        				<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="exam.label.qbank" />', '${qbankInfo}');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.qbank" /> <!-- 문제은행 -->
                            </h2>
		                    <div class="button-area mla">
		                    	<a href="javascript:writeQbankCtgr()" class="ui blue button"><spring:message code="exam.label.categori.code" /> <spring:message code="exam.button.reg" /></a><!-- 분류코드 --><!-- 등록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="option-content mb20">
					                <div class="mla">
					                	<a href="javascript:saveQbankQstn()" class="ui blue button">${empty vo.examQbankQstnSn ? save : modify }</a>
					                	<c:if test="${not empty vo.examQbankQstnSn }">
					                		<a href="javascript:delQbankQstn('${vo.examQbankQstnSn }')" class="ui blue button"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
					                	</c:if>
					                    <a href="javascript:listQbank()" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					                </div>
				                </div>
				                <form name="qbankWriteForm" id="qbankWriteForm" method="POST">
				                	<input type="hidden" name="crsNo" 			value="${crsVO.crsCd }" />
				                	<input type="hidden" name="crsCreCd" 		value="${creCrsVO.crsCreCd }" />
				                	<input type="hidden" name="examQbankQstnSn" value="${vo.examQbankQstnSn }" />
				                	<input type="hidden" name="rgtrId" 			value="${creCrsVO.userId }" />
				                	<input type="hidden" name="editorYn" 		value="Y" />
				                	<input type="hidden" name="qstnScore" 		value="0" />
				                	<input type="hidden" name="qstnDiff"		value="ALL" />
				                </form>
				                <div class="ui form" id="qbankWriteDiv">
									<ul class="tbl border-top-grey">
										<li>
											<dl>
												<dt><label><spring:message code="exam.label.sel.categori" /></label></dt><!-- 분류 선택 -->
												<dd>
													<select class="ui dropdown w200" id="parCtgrCd" onchange="chgCtgrCd(this)">
											            <option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
											            <c:forEach var="item" items="${ctgrList }">
											            	<option value="${item.examQbankCtgrCd }">${item.parExamCtgrNm }</option>
											            </c:forEach>
											        </select>
													<select class="ui dropdown w200" id="ctgrCd" onchange="selectQstnNo()">
											            <option value=""><spring:message code="exam.label.sub.categori" /></option><!-- 하위분류 -->
											        </select>
												</dd>
											</dl>
										</li>
										<li>
											<dl>
												<dt><label class="req"><spring:message code="exam.label.crs.cd" /></label></dt><!-- 학수 번호 -->
												<dd>
													<input type="text" value="${crsVO.crsCd }" name="crsNo" class="w350" disabled="disabled" /> (${crsVO.crsNm })
												</dd>
											</dl>
										</li>
										<li>
											<dl>
												<dt><label class="req"><spring:message code="exam.label.tch.cd" /></label></dt><!-- 교수 번호 -->
												<dd>
													<input type="text" value="${creCrsVO.userId }" name="userId" class="w350" disabled="disabled" /> (${creCrsVO.userNm } <spring:message code="exam.label.tch" />)
												</dd>
											</dl>
										</li>
									</ul>
									<div class="flex gap4 mt20">
									    <select class="ui dropdown" name="qstnTypeCd" id="qstnTypeSelect" onchange="qstnTypeChg()">
									    	<c:forEach var="code" items="${qstnTypeList }">
									    		<option value="${code.codeCd }">${code.codeNm }</option>
									    	</c:forEach>
									    </select>
										<div class="field flex1 mb0">
											<input type="text" id="title" value="${vo.title }" placeholder="${not empty qstnVO ? qstnVO.qstnNo : '1' }-${not empty qstnVO ? qstnVO.subNo : '1' } <spring:message code='exam.label.qstn' />"><!-- 문제 -->
										</div>
									</div>
									<div class="ui small warning message">
				                        <i class="info circle icon"></i>
				                        <spring:message code="exam.alert.another.title" /><!-- 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다. -->
				                    </div>
									<dl style="display:table;width:100%">
										<dd style="display:table-cell;height:400px">
			            					<div style="height:100%">
										    	<textarea name="qstnCts" id="qstnCts">${vo.qstnCts }</textarea>
										    	<script>
											        // html 에디터 생성
											      	var editor = HtmlEditor('qstnCts', THEME_MODE, '/quiz', 'Y', 50);
											        $("#new_qstnCts").css("z-index", "1");
										    	</script>
										    </div>
										</dd>
									</dl>
									
									<!-- 일본어 입력 체크 -->
									<div class="mt20 tr">
										<div id="japanInputCheckBox" class="ui checkbox checked">
											<input id="japanInputCheck" type="checkbox" name="bb1" tabindex="0" class="hidden">
											<label for="japanInputCheck"><spring:message code="common.button.japanese"/><!-- 일본어 --></label>
										</div>
										<script>
											$("#japanInputCheck").change(function(){
										        if($("#japanInputCheck").is(":checked")){
										            $(".button.japanInput").show();
										        } else{
										        	$(".button.japanInput").hide();
										        }
										    });
										</script>
									</div>
								</div>
								<div class="option-content mt20">
					                <div class="mla">
					                	<a href="javascript:saveQbankQstn()" class="ui blue button">${empty vo.examQbankQstnSn ? save : modify }</a>
					                	<c:if test="${not empty vo.examQbankQstnSn }">
					                		<a href="javascript:delQbankQstn('${vo.examQbankQstnSn }')" class="ui blue button"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
					                	</c:if>
					                    <a href="javascript:listQbank()" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
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