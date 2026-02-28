<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
   	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    <script type="text/javascript">
	    var chkFlag = false;
	    var modRatio = 100;
	    var modCnt = Number("${resultVO.stdTotCnt}");
	    var realRatioObj = {};
	    $(function(){	
	    	//잔여비율 자동 배당 설정 이벤트 주입
	    	$("input[name=autoCalc]").on("change", function() {
	    		var calcType = '<c:out value="${resultRelVO.calcType}" />';
	    		var curRadioId = $(this).attr("id");
	    		
	    		/* $("input[name^=ratio]").each(function(){
	    			this.value = 0;
	    			$("#" + this.id + "Real").text("0%");
	    		});
	    		
	    		$("input[name^=cnt]").each(function(){
	    			this.value = 0;
	    		}); */
	    		
	    		$("#cntTotSum").text("");
	    		$("#ratioTotSum").text("");
	    		
	    		$("input[name^=ratio]").not(":last").removeClass("bcLgrey");
	    		$("input[name^=cnt]").not(":last").removeClass("bcLgrey");
	    		
	    		if(curRadioId == "actoCalcRatio") {
	    			if(calcType == "RATIO") {
	    				showLoading();
	    				
	    				$("#ratioA1").val(Number('<c:out value="${resultRelVO.ratioA1}" />' || "0"));
	    	        	$("#ratioA2").val(Number('<c:out value="${resultRelVO.ratioA2}" />' || "0"));
	    	        	$("#ratioB1").val(Number('<c:out value="${resultRelVO.ratioB1}" />' || "0"));
	    	        	$("#ratioB2").val(Number('<c:out value="${resultRelVO.ratioB2}" />' || "0"));
	    	        	$("#ratioC1").val(Number('<c:out value="${resultRelVO.ratioC1}" />' || "0"));
	    	        	$("#ratioC2").val(Number('<c:out value="${resultRelVO.ratioC2}" />' || "0"));
	    	        	$("#ratioD1").val(Number('<c:out value="${resultRelVO.ratioD1}" />' || "0"));
	    	        	$("#ratioD2").val(Number('<c:out value="${resultRelVO.ratioD2}" />' || "0"));
	    	        	$("#ratioF").val(Number('<c:out value="${resultRelVO.ratioF}" />' || "0"));
	    	        	
	    	        	setTimeout(function() {
	    	    			hideLoading();
	    				}, 300);
	    			}
	    			
	    			$("input[name^=ratio]").not(":last").removeAttr("readonly");
	    			$("input[name^=cnt]").not(":last").attr("readonly", "readonly").addClass("bcLgrey");
	    			$(".ratioReal").show();
	    			
	    			$.each($("input[name^=ratio]:not([readonly])"), function() {
	            		$(this).trigger("blur");
	            	});
	    		} else {
					if(calcType == "CNT") {
						showLoading();
						
						$("#cntA1").val(Number('<c:out value="${resultRelVO.cntA1}" />' || "0"));
			        	$("#cntA2").val(Number('<c:out value="${resultRelVO.cntA2}" />' || "0"));
			        	$("#cntB1").val(Number('<c:out value="${resultRelVO.cntB1}" />' || "0"));
			        	$("#cntB2").val(Number('<c:out value="${resultRelVO.cntB2}" />' || "0"));
			        	$("#cntC1").val(Number('<c:out value="${resultRelVO.cntC1}" />' || "0"));
			        	$("#cntC2").val(Number('<c:out value="${resultRelVO.cntC2}" />' || "0"));
			        	$("#cntD1").val(Number('<c:out value="${resultRelVO.cntD1}" />' || "0"));
			        	$("#cntD2").val(Number('<c:out value="${resultRelVO.cntD2}" />' || "0"));
			        	$("#cntF").val(Number('<c:out value="${resultRelVO.cntF}" />' || "0"));
			        	
			        	setTimeout(function() {
	    	    			hideLoading();
	    				}, 300);
	    			}
	    			
	    			$("input[name^=ratio]").not(":last").attr("readonly", "readonly").addClass("bcLgrey");
	    			$("input[name^=cnt]").not(":last").removeAttr("readonly");
	    			$(".ratioReal").hide();
	    			
	    			$.each($("input[name^=cnt]:not([readonly])"), function() {
	            		$(this).trigger("blur");
	            	});
	    		}
	    	});
	    	
	    	//비율 기준 계산 이벤트 주입
	    	$("input[name^=ratio]").not(":last").on("blur", function(){
	    		if($(this).is("[readonly]")) return;
	    		
	    		if(this.value === "") {
					this.value = 0;
				} else {
					this.value = Number(this.value);
				}
	    		
	    		onRealRatioCalc(this);
	    		
	    		if(onCalcTargetRatio($(this).attr("id")) != "" && !chkFlag){
	    			var id = $(this).attr("id");
	    			var msg = onCalcTargetRatio($(this).attr("id"));
	    			
	    			alert(msg);
	    			$(this).val("0");
	    			chkFlag = true;
	    			$(this).trigger("blur");
	    			return;
	    		} else {
	    			chkFlag = false;
	    		}
	    	});
	    	
	    	$("input[name^=ratio]").not(":last").on("focus", function(){
	    		if ($(this).val() == "0") {
					$(this).val("");
				}
	    	});
	    	
	    	//인원 기준 계산 이벤트 주입
			$("input[name^=cnt]").not(":last").on("blur", function(){
				if($(this).is("[readonly]")) return;
				
				if(this.value === "") {
					this.value = 0;
				} else {
					this.value = Number(this.value);
				}
				
				onCntCalc(this);
				
				if(modCnt <= -1){
					$(this).val(0);
					onCntCalc(this);
				}
				
				if(onCalcTargetRatio2($(this).attr("id")) != "" && !chkFlag){
	    			var id = $(this).attr("id");
	    			var msg = onCalcTargetRatio2($(this).attr("id"));
	    			
	    			alert(msg);
	    			$(this).val("0");
	    			chkFlag = true;
	    			$(this).trigger("blur");
	    			return;
	    		} else {
	    			chkFlag = false;
	    		}
	    	});
	    	
			$("input[name^=cnt]").not(":last").on("focus", function(){
	    		if ($(this).val() == "0") {
					$(this).val("");
				}
	    	});
	    	
	    	initPop();
	    	
	    	checkJobSch().done(function() {
	    		//성적환산 버튼 이벤트 주입
		    	$("#scoreBtn").on("click", function(){
		    		onSaveScore();
		    	});
	    		
	    		$("#scoreBtn").show();
	    	});
	    });
	    
	    function onSaveScore(){
	    	var totStdCnt = Number("${resultVO.stdTotCnt}");
	    	var mustFCnt = Number("${mustFCnt}");
	    	
	    	var cntA1 = Number(gfn_isNull($("#cntA1").val()) ? "0" : $("#cntA1").val());
			var cntA2 = Number(gfn_isNull($("#cntA2").val()) ? "0" : $("#cntA2").val());
			var cntB1 = Number(gfn_isNull($("#cntB1").val()) ? "0" : $("#cntB1").val());
			var cntB2 = Number(gfn_isNull($("#cntB2").val()) ? "0" : $("#cntB2").val());
			
			var cntC1 = Number(gfn_isNull($("#cntC1").val()) ? "0" : $("#cntC1").val());
			var cntC2 = Number(gfn_isNull($("#cntC2").val()) ? "0" : $("#cntC2").val());
			var cntD1 = Number(gfn_isNull($("#cntD1").val()) ? "0" : $("#cntD1").val());
			var cntD2 = Number(gfn_isNull($("#cntD2").val()) ? "0" : $("#cntD2").val());
			var cntF = Number(gfn_isNull($("#cntF").val()) ? "0" : $("#cntF").val());
			
			var emptyGrageList = [];
			
			if(cntC1 === 0) {
				emptyGrageList.push("C+");
			}
			if(cntC2 === 0) {
				emptyGrageList.push("C");
			}
			if(cntD1 === 0) {
				emptyGrageList.push("D+");
			}
			if(cntD2 === 0) {
				emptyGrageList.push("D");
			}
			
	    	var ttApRate = cntA1 / totStdCnt * 100;
	        var ttApToARate = (cntA1 + cntA2) / totStdCnt * 100;
	        var ttAbToBRate = (cntA1 + cntA2 + cntB1 + cntB2) / totStdCnt * 100;
	        
	        if (ttApRate > 20) {
	        	/* A+ 비율은 20% 이내여야 합니다. */
	        	alert('<spring:message code="score.label.ratio.two.within" />');
	            return;
	        }
	        if (ttApToARate > 40) {
	        	/* A+ ~ A 합산 비율은 40% 이내여야 합니다. */
	        	alert('<spring:message code="score.label.ratio.four.within" />');
	            return;
	        }
	        if (ttAbToBRate > 80) {
	        	/* A+ ~ B 합산 비율은 80% 이내여야 합니다. */
	        	alert('<spring:message code="score.label.ratio.eight.within" />');
	            return;
	        }
	        
	        var stdCntTotSum = Number($("#cntTotSum").text().replace(/[^0-9]/g, ""));
	        var stdTotSum = Number("${resultVO.stdTotCnt}");
	        
	        if(stdCntTotSum != stdTotSum) {
	        	/* "학생수의 총 합은 수강인원 명 과 일치해야 합니다." */
	        	alert('<spring:message code="score.label.total.number" />'+stdTotSum+'<spring:message code="score.label.match" />');
	        	return;
	        }
	        
	        if(totStdCnt - (cntA1 + cntA2 + cntB1 + cntB2 + cntC1 + cntC2 + cntD1 + cntD2) < mustFCnt) {
	        	// F등급 인원은 {0}명보다 커야합니다.
	        	alert('<spring:message code="score.label.fcnt.must.over" arguments="' + mustFCnt + '" />');
				return;
			}
	        
	        if (cntF < 0) {
		        alert('F 등급 인원이 0 이상이 되도록 조절해 주시기 바랍니다.');
		        return;
		    }
	        
	        /* 성적환산을 하시겠습니까? */
    		checkJobSch(true).done(function() {
    			getBtnStatus().done(function(scoreStatus) {
    	        	if(scoreStatus == "3") {
    	        		if(emptyGrageList.length > 0) {
    	    	        	// 등급이 0%입니다. 환산처리를 진행하시겠습니까? 기존 성적환산이 초기화됩니다.
    	    	        	if(!confirm(emptyGrageList.join(", ") + ' <spring:message code="score.label.empty.grade.convert.msg" />\n<spring:message code="score.confirm.select.msg3" />')) return;
    	    	        } else {
    	    	        	// 기존 성적환산이 초기화됩니다. 진행하시겠습니까?
    	    	        	if(!confirm('<spring:message code="score.confirm.select.msg3" /> <spring:message code="score.confirm.select.msg4" />')) return;
    	    	        }
    	        	} else {
    	        		if(emptyGrageList.length > 0) {
    	    	        	// 등급이 0%입니다. 환산처리를 진행하시겠습니까?
    	    	        	if(!confirm(emptyGrageList.join(", ") + ' <spring:message code="score.label.empty.grade.convert.msg" />')) return;
    	    	        } else {
    	    	        	// 성적환산을 하시겠습니까?
    	    	        	if(!confirm('<spring:message code="score.label.match.convert.msg" />')) return;
    	    	        }
    	        	}
    	        	
    	        	// 잔여비율 자동배당 타입
    		        $("#calcType").val($("[name=autoCalc]:checked").val());
    		        
    		   		ajaxCall("/score/scoreOverall/saveRelativeScoreConvert.do", $("#popDataForm").serialize(), function(data) {
    		   			if(data.result > 0) {
    		   				window.parent.closeModal();
    		       			//window.parent.onSearch();
    		       			if(typeof window.parent.scoreConvertCallBack === "function") {
    		    				window.parent.scoreConvertCallBack();
    		   				}
    		   			} else {
    		   				alert(data.message);
    		   			}
    		   		}, function(xhr, status, error) {
    		   			/* 성적환산중 에러가 발생했습니다! */
    		   			alert('<spring:message code="score.label.match.convert.fail.msg" />'); 
    		   		}, true);
    	        });
    		});
	    }
	
	    function initPop(){
	    	var calcType = '<c:out value="${resultRelVO.calcType}" />';
	    	
	    	if(calcType) {
	    		if(calcType == "CNT") {
	    			$("[name=autoCalc]").eq(0).prop("checked", true).trigger("change");
	    		} else if(calcType == "RATIO") {
	    			$("[name=autoCalc]").eq(1).prop("checked", true).trigger("change");
	    		}
	    		
	    		$("#ratioA1").val(Number('<c:out value="${resultRelVO.ratioA1}" />' || "0"));
	        	$("#ratioA2").val(Number('<c:out value="${resultRelVO.ratioA2}" />' || "0"));
	        	$("#ratioB1").val(Number('<c:out value="${resultRelVO.ratioB1}" />' || "0"));
	        	$("#ratioB2").val(Number('<c:out value="${resultRelVO.ratioB2}" />' || "0"));
	        	$("#ratioC1").val(Number('<c:out value="${resultRelVO.ratioC1}" />' || "0"));
	        	$("#ratioC2").val(Number('<c:out value="${resultRelVO.ratioC2}" />' || "0"));
	        	$("#ratioD1").val(Number('<c:out value="${resultRelVO.ratioD1}" />' || "0"));
	        	$("#ratioD2").val(Number('<c:out value="${resultRelVO.ratioD2}" />' || "0"));
	        	$("#ratioF").val(Number('<c:out value="${resultRelVO.ratioF}" />' || "0"));
	        	
	        	$("#cntA1").val(Number('<c:out value="${resultRelVO.cntA1}" />' || "0"));
	        	$("#cntA2").val(Number('<c:out value="${resultRelVO.cntA2}" />' || "0"));
	        	$("#cntB1").val(Number('<c:out value="${resultRelVO.cntB1}" />' || "0"));
	        	$("#cntB2").val(Number('<c:out value="${resultRelVO.cntB2}" />' || "0"));
	        	$("#cntC1").val(Number('<c:out value="${resultRelVO.cntC1}" />' || "0"));
	        	$("#cntC2").val(Number('<c:out value="${resultRelVO.cntC2}" />' || "0"));
	        	$("#cntD1").val(Number('<c:out value="${resultRelVO.cntD1}" />' || "0"));
	        	$("#cntD2").val(Number('<c:out value="${resultRelVO.cntD2}" />' || "0"));
	        	$("#cntF").val(Number('<c:out value="${resultRelVO.cntF}" />' || "0"));
	        	
	        	$.each($("input[name^=ratio]:not([readonly])"), function() {
	        		$(this).trigger("blur");
	        	});
	       		//$("input[name^=ratio]:not([readonly])").eq(0).trigger("blur");
	        	$.each($("input[name^=cnt]:not([readonly])"), function() {
	        		$(this).trigger("blur");
	        	});
	    	} else {
	    		$("[name=autoCalc]").eq(0).prop("checked", true).trigger("change");
	    	}
	    }
	    
	    // 실질적용비율 계산
	    function onRealRatioCalc(obj) {
	    	var stdTotCnt = Number("${resultVO.stdTotCnt}");
	    	var cntId = obj.id.replace("ratio", "cnt");
	    	var cnt = Math.floor((Number(obj.value) / 100) * stdTotCnt);
	    	
	    	$("#" + cntId).val(cnt);
	    	var realRatio = (cnt / stdTotCnt * 100).toFixed(2) * 1;
	    	
	    	$("#" + obj.id + "Real").text(realRatio);
	    	
	    	realRatioObj[obj.id] = realRatio;
	    	
	    	var realRatioSum = 0;
	    	var ratioTotSum = 0;
	    	var cntSum = 0;
	    	$("input[name^=ratio]").not(":last").each(function() {
	    		var cntInputId = this.id.replace("ratio", "cnt");
	    		cntSum += Number($("#" + cntInputId).val() || "0");
	    		
	    		ratioTotSum += Number(this.value) * 100;
	    		realRatioSum += (realRatioObj[this.id] || 0) * 100;
	    	});
	    	
	    	var cntF = stdTotCnt - cntSum;
	    	var ratioFReal = (100 * 100 - realRatioSum) / 100;
	    	var ratioFRealStrList = ("" + (ratioFReal || 0)).split(".");
	    	
	    	if(ratioFRealStrList.length > 1 && ratioFRealStrList[1].length > 2) {
	    		ratioFRealStrList[1] = ratioFRealStrList[1].substring(0, 2);
	    	}
	    	var ratioFRealStr = ratioFRealStrList.join(".");
	    	
	    	$("#cntF").val(stdTotCnt - cntSum);
	    	$("#ratioF").val((100 * 100 - ratioTotSum) / 100);
	    	$("#ratioFReal").text(ratioFRealStr);
	    	$("#cntTotSum").text(cntSum + cntF + '<spring:message code="message.person" />'); // 명
	    	$("#ratioTotSum").text((ratioTotSum / 100 + (100 * 100 - ratioTotSum) / 100) + "%");
	    	$("#ratioTotSumReal").text("100%");
	    	
	    	var graphId = obj.id.replace("ratio", "graph");
	    	
	    	$('#' + graphId).progress({
	            percent:  Number(obj.value),
	            text : { percent : Number(obj.value) + "%" }
	        });
	    	
	    	$('#graphF').progress({
	            percent:  Number(ratioFRealStr),
	            text : { percent : Number(ratioFRealStr) + "%" }
	        });
	    }
	    
		function onCntCalc( obj ){
			var _ratioInputId = obj.id;
	    	var _ratioInputVal = Number(obj.value);
	    	var _targetInputId = _ratioInputId.replace("cnt", "ratio");
	    	
	    	var _targetPer = Number("${resultVO.stdTotCnt}");
	    	var _targetCalCntVal = _targetPer === 0 ? 0 : Math.ceil((_ratioInputVal/_targetPer) * 100 * 100) / 100;
	    	
	    	$("#" + _targetInputId).val(_targetCalCntVal);
	    	
			// (5(인원)/10(총))* 100
	    	onAllCalc();
			
			var graphId = obj.id.replace("cnt", "graph");
	    	
	    	$('#' + graphId).progress({
	            percent:  Number(_targetCalCntVal),
	            text : { percent : Number(_targetCalCntVal) + "%" }
	        });
	    }
		
		function onAllCalc(){
			var ratioSum = 0;
			var cntSum = 0;
			var totStdCnt = Number("${resultVO.stdTotCnt}");
			
			var ratioTotSum = 0;
			var cntTotSum = 0;
			
			$("input[name^=ratio]").not(":last").each(function(){
				ratioSum += Number( $(this).val() );
			});
			
			$("input[name^=cnt]").not(":last").each(function(){
				cntSum += parseInt($(this).val());
			});
			
			ratioSum = Math.round((100 - ratioSum)*100) / 100;
			
			$("#ratioF").val(ratioSum);
			modRatio = ratioSum;
			
			$("#cntF").val(totStdCnt - cntSum);
			modCnt = totStdCnt - cntSum;
			
			$("input[name^=ratio]").each(function(){
				ratioTotSum += Number( $(this).val() );
			});
			
			$("input[name^=cnt]").each(function(){
				cntTotSum += parseInt($(this).val());
			});
			
			$("#ratioTotSum").html("100%");
			$("#cntTotSum").html(cntTotSum + '<spring:message code="message.person" />'); // 명
			
	    	$('#graphF').progress({
	            percent:  Number(ratioSum),
	            text : { percent : Number(ratioSum) + "%" }
	        });
		}
		
		function onCalcTargetRatio( id ){
			var mustFCnt = Number("${mustFCnt}");
			var totStdCnt = Number("${resultVO.stdTotCnt}");
			
			var targetRatio = 0;
			var msg = "";
			var _id = id.replace("ratio", "").toUpperCase();
			
			var ratioA1 = Number(gfn_isNull($("#ratioA1").val()) ? "0" : $("#ratioA1").val());
			var ratioA2 = Number(gfn_isNull($("#ratioA2").val()) ? "0" : $("#ratioA2").val());
			var ratioB1 = Number(gfn_isNull($("#ratioB1").val()) ? "0" : $("#ratioB1").val());
			var ratioB2 = Number(gfn_isNull($("#ratioB2").val()) ? "0" : $("#ratioB2").val());
			
			var cntA1 = Number(gfn_isNull($("#cntA1").val()) ? "0" : $("#cntA1").val());
			var cntA2 = Number(gfn_isNull($("#cntA2").val()) ? "0" : $("#cntA2").val());
			var cntB1 = Number(gfn_isNull($("#cntB1").val()) ? "0" : $("#cntB1").val());
			var cntB2 = Number(gfn_isNull($("#cntB2").val()) ? "0" : $("#cntB2").val());
			
			var cntC1 = Number(gfn_isNull($("#cntC1").val()) ? "0" : $("#cntC1").val());
			var cntC2 = Number(gfn_isNull($("#cntC2").val()) ? "0" : $("#cntC2").val());
			var cntD1 = Number(gfn_isNull($("#cntD1").val()) ? "0" : $("#cntD1").val());
			var cntD2 = Number(gfn_isNull($("#cntD2").val()) ? "0" : $("#cntD2").val());
			
			var sum = 0;
			switch (_id) {
			case "A1":
				if(ratioA1 > Number("${resultVO.initRatioA1}")) {
					var ratio = '<c:out value="${resultVO.initRatioA1}" />';
					msg = '<spring:message code="score.label.ratio.within" arguments="' + ratio + '" />'; // A+ 비율은 {0}% 이내여야 합니다.
				} else {
					if((ratioA1 + ratioA2) > Number("${resultVO.initRatioA2}") ) {
						var ratio = '<c:out value="${resultVO.initRatioA2}" />';
						msg = 'A+ ~ A <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
					}
				}
				break;
			case "A2":
				if((ratioA1 + ratioA2) > Number("${resultVO.initRatioA2}") ) {
					var ratio = '<c:out value="${resultVO.initRatioA2}" />';
					msg = 'A+ ~ A <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
				} else {
					if((ratioA1 + ratioA2 + ratioB1 + ratioB2) > Number("${resultVO.initRatioB}") ) {
						var ratio = '<c:out value="${resultVO.initRatioB}" />';
						msg = 'A+ ~ B <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
					}
				}
				break;
			case "B1":
			case "B2":
				if((ratioA1 + ratioA2 + ratioB1 + ratioB2) > Number("${resultVO.initRatioB}") ) {
					var ratio = '<c:out value="${resultVO.initRatioB}" />';
					msg = 'A+ ~ B <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
				}
				break;
			case "C1":
			case "C2":
			case "D1":
			case "D2":
			}
			
			if(!msg && (totStdCnt - (cntA1 + cntA2 + cntB1 + cntB2 + cntC1 + cntC2 + cntD1 + cntD2) < mustFCnt)) {
				// F등급 인원은 {0}명보다 커야합니다.
				msg = '<spring:message code="score.label.fcnt.must.over" arguments="' + mustFCnt + '" />';
			}
			 
			return msg;
		}
		
		function onCalcTargetRatio2( id ){
			var mustFCnt = Number("${mustFCnt}");
			var totStdCnt = Number("${resultVO.stdTotCnt}");
			var msg = "";
			var _id = id.replace("cnt", "").toUpperCase();
			
			var cntA1 = Number(gfn_isNull($("#cntA1").val()) ? "0" : $("#cntA1").val());
			var cntA2 = Number(gfn_isNull($("#cntA2").val()) ? "0" : $("#cntA2").val());
			var cntB1 = Number(gfn_isNull($("#cntB1").val()) ? "0" : $("#cntB1").val());
			var cntB2 = Number(gfn_isNull($("#cntB2").val()) ? "0" : $("#cntB2").val());
			
			var cntC1 = Number(gfn_isNull($("#cntC1").val()) ? "0" : $("#cntC1").val());
			var cntC2 = Number(gfn_isNull($("#cntC2").val()) ? "0" : $("#cntC2").val());
			var cntD1 = Number(gfn_isNull($("#cntD1").val()) ? "0" : $("#cntD1").val());
			var cntD2 = Number(gfn_isNull($("#cntD2").val()) ? "0" : $("#cntD2").val());
			
			switch (_id) {
			case "A1":
				if((cntA1 / totStdCnt * 100) > Number("${resultVO.initRatioA1}")) {
					var ratio = '<c:out value="${resultVO.initRatioA1}" />';
					msg = '<spring:message code="score.label.ratio.within" arguments="' + ratio + '" />'; // A+ 비율은 {0}% 이내여야 합니다.
				} else {
					var inRatio = (cntA1 + cntA2) / totStdCnt * 100;
					if(inRatio > Number("${resultVO.initRatioA2}") ) {
						var ratio = '<c:out value="${resultVO.initRatioA2}" />';
						msg = 'A+ ~ A <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
					}
				}
				break;
			case "A2":
				var inRatio = (cntA1 + cntA2) / totStdCnt * 100;
				if(inRatio > Number("${resultVO.initRatioA2}") ) {
					var ratio = '<c:out value="${resultVO.initRatioA2}" />';
					msg = 'A+ ~ A <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
				} else {
					var inRatio = (cntA1 + cntA2 + cntB1 + cntB2) / totStdCnt * 100;
					
					if(inRatio > Number("${resultVO.initRatioB}") ) {
						var ratio = '<c:out value="${resultVO.initRatioB}" />';
						msg = 'A+ ~ B <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
					}
				}
				break;
			case "B1":
			case "B2":
				var inRatio = (cntA1 + cntA2 + cntB1 + cntB2) / totStdCnt * 100;
				if(inRatio > Number("${resultVO.initRatioB}") ) {
					var ratio = '<c:out value="${resultVO.initRatioB}" />';
					msg = 'A+ ~ B <spring:message code="score.label.ratio.between.within" arguments="' + ratio + '" />'; // 합산 비율은 {0}% 이내여야 합니다.
				}
				break;
			case "C1":
			case "C2":
			case "D1":
			case "D2":
				break;
			}
			
			 if(!msg && (totStdCnt - (cntA1 + cntA2 + cntB1 + cntB2 + cntC1 + cntC2 + cntD1 + cntD2) < mustFCnt)) {
				// F등급 인원은 {0}명보다 커야합니다.
				msg = '<spring:message code="score.label.fcnt.must.over" arguments="' + mustFCnt + '" />';
			}
			
			return msg;
		}
		
		function getBtnStatus() {
			var deferred = $.Deferred();
			
			var url  = "/score/scoreOverall/selectBtnStatus.do";
			var param = {
				crsCreCd : "${vo.crsCreCd}"
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					deferred.resolve(returnVO.scoreStatus);
				} else {
					deferred.resolve("");
				}
			}, function(xhr, status, error) {
				deferred.resolve("");
			}, true);
			
			return deferred.promise();
		}
		
		//업무일정 체크
		function checkJobSch(isAlert) {
			var deferred = $.Deferred();
			
			var uniCd = "${creCrsVO.uniCd}";
			var calendarCtgr = "";
			
			// 성적입력기간
			if(uniCd == "G") {
				calendarCtgr = "00210207";
			} else {
				calendarCtgr = "00210206";
			}
			
			var url = "/jobSchHome/viewSysJobSch.do";
			var data = {
				"crsCreCd"     : "${creCrsVO.crsCreCd}",
				"calendarCtgr" : calendarCtgr,
				"haksaYear"	   : "${creCrsVO.creYear}",
				"haksaTerm"	   : "${creCrsVO.creTerm}",
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						var jobSchPeriodYn = returnVO.jobSchPeriodYn;
						var jobSchExcPeriodYn = returnVO.jobSchExcPeriodYn;
						var schStartDt = returnVO.schStartDt;
						var schEndDt = returnVO.schEndDt;
						
						if(jobSchPeriodYn == "Y" || jobSchExcPeriodYn == "Y") {
							deferred.resolve();
						} else {
							if(isAlert) {
								var argu = '<spring:message code="score.label.score.proc" />'; // 성적처리
								var msg = '<spring:message code="score.alert.no.job.sch.period" arguments="' + argu + '" />'; // 기간이 아닙니다.
								
								alert(msg);
							}
							deferred.reject();
						}
					} else {
						alert('<spring:message code="sys.alert.already.job.sch" />'); // 등록된 일정이 없습니다.
						deferred.reject();
					}
		    	} else {
		    		alert(data.message);
		    		deferred.reject();
		    	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
				deferred.reject();
			});
			
			return deferred.promise();
		}
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
    	<%-- <div class="info-item-box">
            <div class="page-title"><spring:message code="score.label.evaluation.stand" /></div><!-- 상대평가 환산기준 -->
        </div> --%>
        <div class="ui form">
        	<div class="ui message mb0">
				<div>* <spring:message code="score.label.process.new.msg5" /><!-- 성적정정을 고려하여 비율을 보수적으로 입력하세요. --></div>
				<div>* <spring:message code="score.label.process.new.msg6" /><!-- 각 등급별 입력 값은 동점자로 인해 환산 결과가 다를 수도 있습니다. --></div>
			</div>
        	<div class="option-content">
                <b class="sec_head"><spring:message code="score.label.evaluation.lecture" /></b><!-- 상대평가 과목 -->
                <small>
                	[ <spring:message code="score.label.target.people" /> : ${resultVO.stdTotCnt} <spring:message code="asmnt.label.person" /> ] 
                </small><!-- 대상인원, 명 출결 명 -->
            </div>
            <!-- 팝업 -->
       		<div class="ui flowing popup left center transition hidden" id="practicalRatioPop">
                <div class="w350">
                    <h3><i class="icon circle info fcBlue opacity7 mr5"></i><spring:message code="score.label.practical.ratio.guide1" /><!-- ‘실질적용비율’ 이란? --></h3>
                    <div class="ui message m0 mt10">
						<p class="fweb" style="line-height: 1.7em">
							<spring:message code="score.label.practical.ratio.guide2" /><!-- [잔여비율 자동배당 설정]을 [비율 사용]으로 입력 시에만 펼쳐지는/나타나는 참고자료로써(인원으로 하는 경우에는 보이지 않음) 자동 변환되는 인원수에 소수점이 나올 경우 소수점 아래는 적용할 수 없으므로 소수점 아래 제외 처리한 인원을 다시 비율로 표시한 값 -->
						</p>
               		</div>
                </div>
            </div>
			<script>
				$(function() {
					$("#practicalRatioPopOver").popup({
						  popup : '#practicalRatioPop'
						, hoverable  : true
						, position   : 'bottom left'
					});
				});
			</script>
			<!-- 팝업 -->
            <div class="scrollbox_x ">                    
                <table class="tBasic min-width-800">
                    <thead>
                        <tr>
                            <th><spring:message code="score.label.grade" /></th><!-- 등급 -->
                            <th><spring:message code="socre.grade.point.average.label"/></th><!-- 평점 -->
                            <th><spring:message code="score.label.grade.rato" /></th><!-- 등급분포비율 -->
                            <th colspan="2" class="p_w30">
                                	<spring:message code="score.label.ratio.dividend" /><!-- 잔여비율 자동 배당 설정 -->
                                <div class="flex tc gap8">   
                                	<div class="ui radio checkbox">
                                        <input type="radio" id="actoCalcCnt" name="autoCalc" value="CNT" >
                                        <label><spring:message code="score.label.people.use" /></label><!-- 인원 사용 -->
                                    </div>                                       
                                    <div class="ui radio checkbox">
                                        <input type="radio" id="actoCalcRatio" name="autoCalc" value="RATIO">
                                        <label><spring:message code="score.label.use.rato" /></label><!-- 비율 사용 -->
                                    </div>
                                </div>
                            </th>
                            <th id="practicalRatioPopOver" class="ratioReal" data-tooltip="Add users to your feed" data-position="top right"><spring:message code="score.label.practical.ratio" /><!-- 실질적용비율 --></th>
                            <th><spring:message code="score.label.real.time.rato" /></th><!-- 실시간 등급 분포도 비율 -->
                        </tr>
                    </thead>
                    <form id="popDataForm">
                    <input type="hidden" id="popCrsCreCd" name="crsCreCd" value="${vo.crsCreCd}"/>
                    <input type="hidden" id="calcType" name="calcType" />
                    <tbody>
                        <tr>
                            <th>A+</th>
                            <th>4.5</th>
                            <th>~ ${resultVO.initRatioA1}%</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntA1" name="cntA1" placeholder="0" value="0" tabindex="1" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioA1" name="ratioA1" placeholder="0" value="0" tabindex="9" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioA1Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphA1">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>A</th>
                            <th>4.0</th>
                            <th>~ ${resultVO.initRatioA2}%</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntA2" name="cntA2" placeholder="0" value="0" tabindex="2" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioA2" name="ratioA2" placeholder="0" value="0" tabindex="10" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioA2Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphA2">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>B+</th>
                            <th>3.5</th>
                            <th rowspan="2">~ ${resultVO.initRatioB}%</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntB1" name="cntB1" placeholder="0" value="0" tabindex="3" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioB1" name="ratioB1" placeholder="0" value="0" tabindex="11" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioB1Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphB1">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>B</th>
                            <th>3.0</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntB2" name="cntB2" placeholder="0" value="0" tabindex="4" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioB2" name="ratioB2" placeholder="0" value="0" tabindex="12" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioB2Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphB2">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>C+</th>
                            <th>2.5</th>
                            <th rowspan="4">
                            	<spring:message code="score.label.remaining.range" /><!-- 잔여 비율 범위 내에서 지정 -->
                            </th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntC1" name="cntC1" placeholder="0" value="0" tabindex="5" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioC1" name="ratioC1" placeholder="0" value="0" tabindex="13" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioC1Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphC1">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>C</th>
                            <th>2.0</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntC2" name="cntC2" placeholder="0" value="0" tabindex="6" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioC2" name="ratioC2" placeholder="0" value="0" tabindex="14" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioC2Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphC2">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>D+</th>
                            <th>1.5</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntD1" name="cntD1" placeholder="0" value="0" tabindex="7" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioD1" name="ratioD1" placeholder="0" value="0" tabindex="15" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioD1Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphD1">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th>D</th>
                            <th>1.0</th>
                            <td>
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" id="cntD2" name="cntD2" placeholder="0" value="0" tabindex="8" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td>                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" id="ratioD2" name="ratioD2" placeholder="0" value="0" tabindex="16" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td class="ratioReal tc fcGrey">(<span id="ratioD2Real">0</span>%)</td>
                            <td>
                                <div class="ui small green progress m0" id="graphD2">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="2">F</th>
                            <th rowspan="2">0.0</th>
                            <th><spring:message code="score.label.automatic.dividend" /></th><!-- 자동 배당 -->
                            <td rowspan="2">
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.number" /></label><!-- 인원입력 -->
                                    <input type="text" class="bcLgrey" id="cntF" name="cntF" readonly="readonly" placeholder="0" value="0" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>                                       
                            </td>
                            <td rowspan="2">                                        
                                <div class="ui input">
                                    <label class="blind"><spring:message code="score.label.enter.rato" /></label><!-- 비율입력 -->
                                    <input type="text" class="bcLgrey" id="ratioF" name="ratioF" readonly="readonly" placeholder="0" value="0" maxlength="5" onKeyup="inputKeyup(this)">
                                </div>
                            </td>
                            <td rowspan="2" class="ratioReal tc fcGrey">(<span id="ratioFReal">0</span>%)</td>
                            <td rowspan="2">
                                <div class="ui small green progress m0" id="graphF">
                                    <div class="bar">
                                        <div class="progress" style="left: 1px"></div>
                                    </div>
                                </div>  
                            </td>
                        </tr>
                        <tr>
                        	<th class="bcLYellow">
                        		<spring:message code="score.label.no.attend.cacl.num" arguments="${mustFCnt}" /></th><!-- 출결F<br>산출인원 -->
                        	</th>
                        </tr>
                    </tbody>
					</form>
                    <tfoot>
                        <tr>
                            <th colspan="3" class="tc"><spring:message code="message.total" /></th><!-- 합계 -->
                            <td id="cntTotSum"></td>
                            <td id="ratioTotSum"></td>
                            <td class="ratioReal tc fcGrey" id="ratioTotSumReal">0%</td>
                            <td id="graphTotSum">100%</td>
                        </tr>
                    </tfoot>
				</table>                    
            </div>
            <script>
                // 초기화 할때    
                $('.ui.progress').progress({
                    percent: 0,
                    text : { percent : '0%' } /* 소수점 표기 방법 */
                });
                $('#graphA1').progress({
                    percent:  Number("${resultRelVO.ratioA1}"),
                    text : { percent : Number("${resultRelVO.ratioA1}") + "%" }
                });
                $('#graphA2').progress({
                    percent: Number("${resultRelVO.ratioA2}"),
                    text : { percent : Number("${resultRelVO.ratioA2}") + "%" }
                });
                $('#graphB1').progress({
                    percent: Number("${resultRelVO.ratioB1}"),
                    text : { percent : Number("${resultRelVO.ratioB1}") + "%" }
                });
                $('#graphB2').progress({
                    percent: Number("${resultRelVO.ratioB2}"),
                    text : { percent : Number("${resultRelVO.ratioB2}") + "%" }
                });
                $('#graphC1').progress({
                    percent: Number("${resultRelVO.ratioC1}"),
                    text : { percent : Number("${resultRelVO.ratioC1}") + "%" }
                });
                $('#graphC2').progress({
                    percent: Number("${resultRelVO.ratioC2}"),
                    text : { percent : Number("${resultRelVO.ratioC2}") + "%" }
                });
                $('#graphD1').progress({
                    percent: Number("${resultRelVO.ratioD1}"),
                    text : { percent : Number("${resultRelVO.ratioD1}") + "%" }
                });
                $('#graphD2').progress({
                    percent: Number("${resultRelVO.ratioD2}"),
                    text : { percent : Number("${resultRelVO.ratioD2}") + "%" }
                });
                $('#graphF').progress({
                    percent: Number("${resultRelVO.ratioF}"),
                    text : { percent : Number("${resultRelVO.ratioF}") + "%" }
                });
            </script>
            <div class="bottom-content">
                <button type="button" class="ui blue button" id="scoreBtn" style="display: none;"><spring:message code="score.label.conversion" /></button><!-- 성적환산 -->
                <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="sys.button.close" /></button><!-- 닫기 -->
            </div>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>