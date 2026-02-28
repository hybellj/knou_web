<%@page import="knou.framework.util.ValidationUtils"%>
<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
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
	    var examStareTimmer;
	    var LANG = "ko";
		$(document).ready(function() {
			<c:if test="${not empty processResultVO && not empty processResultVO.result && processResultVO.result > 0}">
			$("#submitBtn").hide();
			var submitBtnYn = "Y";
			$("#submittedAnswerBlock").find("div.content > a").each(function(i, v) {
	        	if(!$(v).hasClass("grey")) {
	        		submitBtnYn = "N";
	        	}
	        });
	        if(submitBtnYn == "Y") {
	        	$("#submitBtn").css("display", "inline-block");
	        }
	        var viewTmTypeCd = '${resultVO.examInfo.viewTmTypeCd}';
	        var userIdtiSec  = [30, 20]; // 설정된 초가 남았을 때 학습자에게 알림을 노출한다.
	        var startTime    = ${resultVO.stareTm};
	        console.log('startTime == ' + startTime);
	        var endTime = ${resultVO.examInfo.examStareTm};
	        if (viewTmTypeCd == 'LEFT') {
	            startTime = startTime - 1;
	            endTime   = 0;
	        } else {
	            startTime = startTime + 1;
	            endTime   = endTime * 60;
	        }
	        var minFormatted = '';
	        var secFormatted = '';
	        var min = 0;
	        var sec = 0;

	        examStareTimmer = setInterval(function() {
	            min = Math.floor(startTime/60);
	            sec = startTime%60;
	            minFormatted = min < 10 ? '0' + min : '' + min;
	            secFormatted = sec < 10 ? '0' + sec : '' + sec;

	            $('#timmerBlock').html("<i class='clock icon'></i>" + minFormatted + ":" + secFormatted + " <spring:message code='exam.label.stare.min' />");/* 분 */

	            if (viewTmTypeCd == 'LEFT') {
	                startTime--;
	                for(var i = 0; i < userIdtiSec.length; i++) {
	                    if (startTime - endTime == userIdtiSec[i]) {
	                    	alert('<spring:message code="exam.alert.finish.noti" arguments="' + userIdtiSec[i] + '" />');/* 시험 종료 {0}초 전입니다. */
	                    }
	                }

	                if (startTime < endTime) {
	                    clearInterval(examStareTimmer);
	                    autoSubmitExamStare();
	                }
	            } else {
	                startTime++;
	                for(var i = 0; i < userIdtiSec.length; i++) {
	                    if (endTime - startTime == userIdtiSec[i]) {
	                    	alert('<spring:message code="exam.alert.finish.noti" arguments="' + userIdtiSec[i] + '" />');/* 시험 종료 {0}초 전입니다. */
	                    }
	                }

	                if (startTime > endTime) {
	                    clearInterval(examStareTimmer);
	                    autoSubmitExamStare();
	                }
	            }
	            
	            sessionCheck();
	            
	        }, 1000);
	        </c:if>
	        
	        controllNextPrevBtn();
	        
	        window.parent.$(".modal-header > button").on("click", function() {
	        	if(!(${empty processResultVO || empty processResultVO.result || processResultVO.result < 0})) {
		        	//saveTempExamStare("close");
	        	}
	        	clearInterval(examStareTimmer);
	        });
	        
	     	// 일본어입력기 적용
	    	setJapaneseInput();
		});
		
		// 세션 체크
		function sessionCheck() {
			var url  = "/common/checkSession.do";
			
			ajaxCall(url, null, function(data) {
				if(!(data == "Y")) {
					alert("세션이 만료되었습니다. 다시 로그인 해주세요.");
					clearInterval(examStareTimmer);
				}
    		}, function(xhr, status, error) {
    			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
    		});
		}
		
		// 자동 제출
		function autoSubmitExamStare() {
	          alert("<spring:message code='exam.alert.expire.time' />");/* 시험 시간이 종료되었습니다. */
	          submitExamStare("auto");
	    }
		
		// 임시 저장
		function saveTempExamStare(obj) {
			var url = "/quiz/quizSaveTempStare.do";
			
			$.ajax({
	            type 	 : "POST",
	            async	 : false,
	            dataType : "json",
	            data 	 : $("#stuExamPaperForm").serialize(),
	            url 	 : url,
	            success  : function(data){
	                if(data.result > 0) {
	                	if (!obj) {
	                		alert("<spring:message code='exam.alert.ok.tempsave' />");/* 임시저장하였습니다. */
	                	}
	                } else {
	                    alert(data.message);
	                }
	            },
	        });
		}
		
		// 제출
		function submitExamStare(type) {
			var confirm = true;
			if(type == "self") {
				confirm = window.confirm("<spring:message code='exam.confirm.exam.submit.stare.paper' />");/* 시험지를 제출하시겠습니까? 제출 후 재응시 불가능합니다. */
			}
			if(confirm) {
				var url = "/quiz/quizCompleteStare.do";
				
				$.ajax({
		            type 	 : "POST",
		            async	 : false,
		            dataType : "json",
		            data 	 : $("#stuExamPaperForm").serialize(),
		            url 	 : url,
		            success  : function(data){
		                if(data.result > 0) {
		                	alert("<spring:message code='exam.alert.exam.stare.complete' />");/* 제출 완료되었습니다. */
		                    clearInterval(examStareTimmer);
		                	window.parent.location.reload();
		                    window.parent.closeModal();
		                } else {
		                    alert(data.message);
		                }
		            },
		        });
			}
		}
		
		/**
	     *  이전 다음 버튼 표시
	     */
	    function controllNextPrevBtn() {
	        var curQstnNo = Number($("div.question-box:visible").attr("data-qstnNo"));
	        var qstnCnt   = $("div.question-box").length;
	        $("#btnPrevQstn").hide();
	        $("#btnNextQstn").hide();
	        if (curQstnNo > 1) {
	            $("#btnPrevQstn").show();
	        }
	        if (curQstnNo < qstnCnt) {
	            $("#btnNextQstn").show();
	        }
	    }

	    /**
	     *  이전 버튼 클릭 시 앞 문제로 이동
	     */
	    function goPrevQstn() {
	    	$("#submitBtn").hide();
	        var curQstn   = $("div.question-box:visible");
	        var curQstnNo = Number(curQstn.attr("data-qstnNo"));
	        if (curQstnNo > 1) {
	            $("#btnNextQstn").show();
	            $("div.question-box").hide();
	            $("div.question-box[data-qstnNo=" + (curQstnNo - 1) + "]").show();
	            if (curQstnNo - 1 == 1) {
	                $("#btnPrevQstn").hide();
	            }
	            saveTempExamStare(curQstn);
	        }
	    }

	    /**
	     *  다음 버튼 클릭 시 뒤 문제로 이동
	     */
	    function goNextQstn() {
	        var curQstn   = $("div.question-box:visible");
	        var curQstnNo = Number(curQstn.attr("data-qstnNo"));

	        var qstnCnt = $("div.question-box").length;
	        if (curQstnNo < qstnCnt) {
	            $("#btnPrevQstn").show();
	            $("div.question-box").hide();
	            $("div.question-box[data-qstnNo=" + (curQstnNo + 1) + "]").show();
	            if (curQstnNo + 1 == qstnCnt) {
	                $("#btnNextQstn").hide();
	                $("#submitBtn").css("display", "inline-block");
	            }
	            saveTempExamStare(curQstn);
	        }
	    }
		
		/**
	     *  선택한 번호의 문제로 이동
	     */
	    function goQstnByNo(qstnNo) {
	    	var viewMode = '${resultVO.examInfo.viewQstnTypeCd}';
	        var qstnCnt  = $("div.question-box").length;
	        $("#btnPrevQstn").hide();
	        $("#btnNextQstn").hide();
	        if (qstnNo > 1) {
	            $("#btnPrevQstn").show();
	        }
	        if (qstnNo < qstnCnt) {
	            $("#btnNextQstn").show();
	        }

	        var $targetQtsn = $("div.question-box[data-qstnNo=" + qstnNo + "]");
	        if (viewMode == 'EACH') {
	            $("div.question-box").hide();
	            $targetQtsn.show();
	        } else {
	            $('.modal-body').animate({ scrollTop: $targetQtsn.offset().top }, 500);
	        }
	    }
		
		/**
	     *  선긋기 sortable 셍성
	     */
	    function createSortable(examQtsnNo) {
	        var invalid  	= false;
	        var $answers 	= $("div.slot[name=match" + examQtsnNo + "], div.slot[name=opposite" + examQtsnNo + "]");
	        var $containner = $answers.closest("div.line-sortable-box");
	        $answers.sortable({
	            placeholder: "",
	            opacity: 0.7,
	            zIndex: 9999,
	            connectWith: ".inventory-list .slot, .account-list .slot",
	            containment: $containner,
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
	                changeMatchQstnAnswer(ui.item);
	            }
	        });
	    }
		
	    /**
	     *  짝짓기 문제 풀이  account-list
	     */
	    function changeMatchQstnAnswer(obj) {
	        var answers 	   = '';
	        var $answers 	   = $(obj).closest("div.question-box").find("div[name^=match]");
	        var answerTotalCnt = $answers.length;
	        var index 	  	   = 0;
	        $answers.each(function(idx) {
	            if ($.trim($(this).text()) != '') {
	                if (index > 0) {
	                    answers += '|';
	                }
	                answers += $.trim($(this).text());
	                index++;
	            }
	        });

	        if ( answerTotalCnt != index) {
	            answers = '';
	        }

	        $(obj).closest("div.question-box").find("input:hidden[name='stareAnsrList']").val(answers);
	        var examQstnSn = $(obj).closest("div.question-box").find("input:hidden[name='examQstnSnList']").val();
	        displaySubmittedAnswer(examQstnSn, answers);
	        tempOneSave(obj);
	    }

	    /**
	     *  객관식 문제 풀이
	     */
	    function changeChoiceQstnAnswer(obj) {

	        var answers 		 = '';
	        var formattedAnswers = '';
	        var $answers 		 = $(obj).closest("div.question-box").find("input[name^=choice]:checked");
	        $answers.each(function(idx) {
	            if (idx > 0) {
	                answers += ',';
	                formattedAnswers += ',';
	            }
	            answers += $(this).val();
	            formattedAnswers += $(this).val();
	        });

	        $(obj).closest("div.question-box").find("input:hidden[name='stareAnsrList']").val(answers);
	        var examQstnSn = $(obj).closest("div.question-box").find("input:hidden[name='examQstnSnList']").val();
	        displaySubmittedAnswer(examQstnSn, formattedAnswers);
	        tempOneSave(obj);
	    }

	    /**
	     *  OX 문제 풀이
	     */
	    function changeOxQstnAnswer(obj) {
	        var answers 		 = $(obj).val();
	        var formattedAnswers = '';
	        if (answers == '1') {
	            formattedAnswers = 'O';
	        } else if (answers == '2') {
	            formattedAnswers = 'X';
	        }

	        $(obj).closest("div.question-box").find("input:hidden[name='stareAnsrList']").val(answers);
	        var examQstnSn = $(obj).closest("div.question-box").find("input:hidden[name='examQstnSnList']").val();
	        displaySubmittedAnswer(examQstnSn, formattedAnswers);
	        tempOneSave(obj);
	    }

	    /**
	     *  단답형 문제 풀이
	     */
	    function changeShortQstnAnswer(obj) {
	        var answers  = '';
	        var $answers = $(obj).closest("div.question-box").find("input[name^=short]");
	        var index    = 0;
	        $answers.each(function(idx) {
	            if ($.trim($(this).val()) != '') {
	                if (index > 0) {
	                    answers += '|';
	                }
	                answers += $.trim($(this).val());
	                index++;
	            }
	        });

	        $(obj).closest("div.question-box").find("input:hidden[name='stareAnsrList']").val(answers);
	        var examQstnSn = $(obj).closest("div.question-box").find("input:hidden[name='examQstnSnList']").val();
	        displaySubmittedAnswer(examQstnSn, answers);
	        tempOneSave(obj);
	    }

	    /**
	     *  서술형 문제 풀이
	     */
	    function changeDescQstnAnswer(obj) {
	        var answers = $(obj).val();

	        $(obj).closest("div.question-box").find("input:hidden[name='stareAnsrList']").val(answers);
	        var examQstnSn = $(obj).closest("div.question-box").find("input:hidden[name='examQstnSnList']").val();
	        displaySubmittedAnswer(examQstnSn, answers);
	        tempOneSave(obj);
	    }

	    /**
	     *  제출 답안 표시
	     */
	    function displaySubmittedAnswer(examQstnSn, formattedAnswers) {
	    	var submitBtnYn = "Y";
	        var $submittedQstn = $("#submittedAnswerBlock").find("div[name=submittedQstn" + examQstnSn + "]");
	        var $submittedQstnNo = $submittedQstn.find("div.content > a");
	        $submittedQstn.find("span.flex-highlight").empty();
	        if (formattedAnswers == '') {
	            $submittedQstnNo.removeClass("grey");
	        } else {
	            $submittedQstnNo.addClass("grey");
	            $submittedQstn.find("span.flex-highlight").text(formattedAnswers);
	        }
	        $("#submittedAnswerBlock").find("div.content > a").each(function(i, v) {
	        	if(!$(v).hasClass("grey")) {
	        		submitBtnYn = "N";
	        	}
	        });
	        if(submitBtnYn == "Y") {
	        	$("#submitBtn").css("display", "inline-block");
	        }
	    }
	    
	    // 문제별 임시저장 실행
	    function tempOneSave(obj) {
	    	$("#tempSaveForm").empty();
	    	$("#tempSaveForm").append($('<input/>', {type: 'hidden', name: 'examCd', 		 value: "${vo.examCd}"}));
	    	$("#tempSaveForm").append($('<input/>', {type: 'hidden', name: 'stdNo',  		 value: "${vo.stdNo}"}));
	    	$("#tempSaveForm").append($('<input/>', {type: 'hidden', name: 'crsCreCd',  	 value: "${vo.crsCreCd}"}));
	    	$("#tempSaveForm").append($('<input/>', {type: 'hidden', name: 'searchFrom',	 value: "ONE"}));
	    	$("#tempSaveForm").append($('<input/>', {type: 'hidden', name: 'stareAnsrList',  value: $(obj).closest("div.question-box").find("input:hidden[name='stareAnsrList']").val()}));
	    	$("#tempSaveForm").append($('<input/>', {type: 'hidden', name: 'examQstnSnList', value: $(obj).closest("div.question-box").find("input:hidden[name='examQstnSnList']").val()}));
	    	
			var url = "/quiz/quizSaveTempStare.do";
			
			$.ajax({
	            type 	 : "POST",
	            async	 : false,
	            dataType : "json",
	            data 	 : $("#tempSaveForm").serialize(),
	            url 	 : url,
	            success  : function(data){
	                if(data.result > 0) {
	                } else {
	                    alert(data.message);
	                }
	            },
	        });
	    }
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<c:choose>
	<c:when test="${empty processResultVO || empty processResultVO.result || processResultVO.result < 0}">
		<script type="text/javascript">
			alert("${processResultVO.message}");
			window.parent.closeModal();
		</script>
	</c:when>
	<c:otherwise>
		<div id="loading_page">
		    <p><i class="notched circle loading icon"></i></p>
		</div>
        <div id="wrap">
        	<div class="ui message info-item-box gap4">
		        <div class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="exam.label.decls" /><!-- 반 -->)</div>
		        <div class="mla fcBlue">
		            <b>${stareVO.deptNm} ${stareVO.userId} ${stareVO.userNm }</b>
		        </div>
		    </div>
			<div class="option-content">
	            <p class="sec_head">${vo.examTitle }</p>
	            <div class="mla">
                       <span class="ui black label test-time" id="timmerBlock"><i class="clock icon"></i>00:00 <spring:message code="exam.label.stare.min" /></span><!-- 분 -->
                   </div>
			</div>
			<form id="tempSaveForm">
			</form>
			
			<form id="stuExamPaperForm" name="stuExamPaperForm" onsubmit="return false;">
				<input type="hidden" name="examCd" value="${vo.examCd}" />
               	<input type="hidden" name="stdNo" value="${vo.stdNo}" />
               	<input type="hidden" name="crsCreCd" value="${vo.crsCreCd}" />
	            <div class="ui form mt10 qstnList">
	            	<div class="fields">
	            		<div class="field p_w70">
	            			<c:forEach var="item" items="${resultVO.qstns }" varStatus="varStatus">
	            				<div class="ui card wmax qstnDiv question-box" data-qstnNo="${item.qstnNo}" style="display:${resultVO.examInfo.viewQstnTypeCd == 'ALL' || item.currYn == 'Y'?'block':'none'}">
					                <div class="fields content header2">
					                    <div class="field wf100">
					                        <span><spring:message code="exam.label.qstn" /><!-- 문제 -->${item.qstnNo }</span>
					                        <c:if test="${item.qstnTypeCd eq 'MATCH' }">(<spring:message code="exam.label.qstn.match.info" /><!-- 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. -->)</c:if>
					                    </div>
					                    <input type="hidden" name="examQstnSnList" value="${item.examQstnSn}" />
                                        <input type="hidden" name="stareAnsrList" value="${item.stareAnsr}" />
					                </div>
					                <div class="content">
					                    <div class="mb20">${item.qstnCts}</div>
					                    <div class="ui divider"></div>
					                    <c:if test="${item.qstnTypeCd eq 'CHOICE' || item.qstnTypeCd eq 'MULTICHOICE' }">
					                    	<c:forEach items="${item.choiceList}" var="choiceQstn" varStatus="idx">
		                                        <c:set var="isChecked" value="N" />
		                                        <div class="field">
		                                            <div class="ui checkbox mb10">
				                                        <c:if test="${not empty item.arrAnswer}">
				                                            <c:forEach items="${item.arrAnswer}" var="answer" varStatus="offset">
				                                                <c:if test="${answer == choiceQstn.qstnNo}">
				                                                    <c:set var="isChecked" value="Y" />
				                                                </c:if>
				                                            </c:forEach>
				                                        </c:if>
		                                                <input id="qz_${varStatus.count}_${idx.count}" type="${item.qstnTypeCd eq 'MULTICHOICE' ? 'checkbox' : 'radio'}" name="choice${item.examQstnSn}" 
		                                                    value="${choiceQstn.qstnNo}" ${isChecked=='Y'?'checked':''} onChange="changeChoiceQstnAnswer(this)">
			                                            <label for="qz_${varStatus.count}_${idx.count}" class="question ${item.qstnTypeCd eq 'MULTICHOICE' ? 'multi' : '' } empl" data-value="${choiceQstn.qstnNo}">${choiceQstn.title}</label>
		                                            </div>
		                                        </div>
		                                    </c:forEach>
					                    </c:if>
					                    <c:if test="${item.qstnTypeCd eq 'SHORT' }">
	                                        <div class="equal width fields">
	                                        	<c:set var="ansrCnt" value="5" />
	                                        	<c:forEach var="idx" begin="1" end="5" step="1">
	                                        		<c:set var="rgtAnsr" value="rgtAnsr${idx }" />
	                                        		<c:if test="${not empty item[rgtAnsr] }"><c:set var="ansrCnt" value="${idx - 1 }" /></c:if>
	                                        	</c:forEach>
			                                    <c:forEach var="idx" begin="0" end="${ansrCnt }">
			                                        <c:set var="shortAnswer" value="" />
			                                        <c:if test="${not empty item.arrAnswer}">
			                                            <c:forEach items="${item.arrAnswer}" var="answer" varStatus="offset">
			                                                <c:if test="${idx == offset.index}">
			                                                    <c:set var="shortAnswer" value="${answer}" />
			                                                </c:if>
			                                            </c:forEach>
			                                        </c:if>
			                                        <div class="field">
			                                        	<label for="short${item.examQstnSn}" class="hide">answer</label>
			                                            <input id="short${item.examQstnSn}" type="text" name="short${item.examQstnSn}" maxlength="40" placeholder="${idx+1}<spring:message code='exam.label.answer.no' />"
			                                                value="<c:out value='${shortAnswer}' />" class="japanInput" onChange="changeShortQstnAnswer(this)"><!-- 번 답 -->
			                                        </div>
			                                    </c:forEach>
	                                        </div>
					                    </c:if>
					                    <c:if test="${item.qstnTypeCd eq 'DESCRIBE' }">
					                    	<label for="desc${item.examQstnSn}" class="hide">answer</label>
					                    	<textarea id="desc${item.examQstnSn}" rows="3" name="desc${item.examQstnSn}" onChange="changeDescQstnAnswer(this)"><c:out value='${item.stareAnsr}' /></textarea>
					                    </c:if>
					                    <c:if test="${item.qstnTypeCd eq 'OX' }">
	                                        <div class="checkImg">
	                                            <input id="oxChk${item.examQstnSn}_true" type="radio" name="oxChk${item.examQstnSn}" 
	                                                value="1" ${item.stareAnsr == '1'?'checked':''} onChange="changeOxQstnAnswer(this)">
	                                            <label class="imgChk true m0 mr40" for="oxChk${item.examQstnSn}_true"></label>
	                                            <input id="oxChk${item.examQstnSn}_false" type="radio" name="oxChk${item.examQstnSn}" 
	                                                value="2" ${item.stareAnsr == '2'?'checked':''} onChange="changeOxQstnAnswer(this)">
	                                            <label class="imgChk false m0" for="oxChk${item.examQstnSn}_false"></label>
	                                        </div>
					                    </c:if>
					                    <c:if test="${item.qstnTypeCd eq 'MATCH' }">
					                    	<div class="line-sortable-box">
	                                            <div class="account-list">
	                                    			<c:forEach items="${item.choiceList}" var="choiceQstn" varStatus="idx">
	                                    				<c:set var="qstnClassNm" value="num0${choiceQstn.qstnNo }" />
				                                    <div class="line-box ${qstnClassNm }">
				                                        <c:set var="matchAnswer" value="" />
				                                        <c:if test="${not empty item.arrAnswer}">
				                                            <c:forEach items="${item.arrAnswer}" var="answer" varStatus="offset">
				                                                <c:if test="${idx.index == offset.index}">
				                                                    <c:set var="matchAnswer" value="${answer}" />
				                                                </c:if>
				                                            </c:forEach>
				                                        </c:if>
	                                                    <div class="question"><span>${choiceQstn.title}</span></div>
		                                                <c:if test="${not empty matchAnswer && matchAnswer != ''}">
		                                                    <div class="slot" name="match${item.examQstnSn}">
		                                                        <span class="ui-sortable-handle" style="position: relative; opacity: 1; left: 0px; top: 0px;"><i class="ion-arrow-move"></i>
		                                                            <c:out value='${matchAnswer}' />
		                                                        </span>
		                                                    </div>
		                                                </c:if>
		                                                <c:if test="${empty matchAnswer || matchAnswer == ''}">
		                                                    <div class="slot" name="match${item.examQstnSn}"></div>
		                                                </c:if>
	                                                </div>
	                                    			</c:forEach>
	                                            </div>
	                                            <div class="inventory-list w200">
				                                    <c:if test="${not empty item.arrAnswer}">
				                                        <c:forEach items="${item.arrAnswer}" var="answer" varStatus="offset">
				                                                <div class="slot" name="opposite${item.examQstnSn}"></div>
				                                        </c:forEach>
				                                    </c:if>
				                                    <c:if test="${empty item.arrAnswer}">
				                                        <c:forEach items="${item.oppositeList}" var="opposite" varStatus="idx">
				                                                <div class="slot" name="opposite${item.examQstnSn}"><span><i class="ion-arrow-move"></i><c:out value='${opposite.title}' /></span></div>
				                                        </c:forEach>
				                                    </c:if>
	                                            </div>
	                                        </div>
	                                        <script>
	                                            createSortable('${item.examQstnSn}');
	                                        </script>
					                    </c:if>
					                </div>
					            </div>
	            			</c:forEach>
	            		</div>
	            		<div class="field p_w30">
	            			<div class="ui card wmax">
	            				<div class="fields content">
			                        <div class="field wmax">
			                            <span><spring:message code="exam.label.submit.answer" /></span><!-- 제출 답안 -->
			                        </div>
			                    </div>
			                    <div class="ui relaxed divided list content" id="submittedAnswerBlock">
		                            <c:forEach items="${resultVO.qstns}" var="item" varStatus="status">
		                                <div class="item" name="submittedQstn${item.examQstnSn}">
		                                    <div class="content flex-item">
		                                        <a href="javascript:goQstnByNo(${item.qstnNo});" class="ui ${empty item.stareAnsr?'':'grey'} circular small label mr10">${item.qstnNo}</a>
		                                        <span class="flex-highlight text-truncate">
		                                    <c:if test="${item.qstnTypeCd == 'OX'}">
		                                        <c:if test="${item.stareAnsr == '1'}">
		                                            O
		                                        </c:if>
		                                        <c:if test="${item.stareAnsr == '2'}">
		                                            X
		                                        </c:if>
		                                    </c:if>
		                                    <c:if test="${item.qstnTypeCd == 'CHOICE' || item.qstnTypeCd == 'MULTICHOICE'}">
		                                        <c:out value='${item.formattedStareAnsr}' />
		                                    </c:if>
		                                    <c:if test="${item.qstnTypeCd != 'OX' && item.qstnTypeCd != 'CHOICE' && item.qstnTypeCd != 'MULTICHOICE' }">
		                                        <c:out value='${item.stareAnsr}' />
		                                    </c:if>
		                                        </span>
		                                    </div>
		                                </div>
		                            </c:forEach>
                            	</div>
	            			</div>
	            		</div>
	            	</div>
	            </div>
			</form>
            
            <div class="bottom-content">
            	<c:if test="${resultVO.examInfo.viewQstnTypeCd eq 'EACH'}">
                    <a href="javascript:goPrevQstn();" class="ui button blue" id="btnPrevQstn"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
                </c:if>
            	<a class="ui button blue" href="javascript:saveTempExamStare()"><spring:message code="exam.label.qstn.temp.save" /></a><!-- 임시저장 -->
            	<a class="ui button blue" id="submitBtn" href="javascript:submitExamStare('self')"><spring:message code="exam.label.submit.y" /></a><!-- 제출 -->
            	<c:if test="${resultVO.examInfo.viewQstnTypeCd eq 'EACH'}">
                    <a href="javascript:goNextQstn();" class="ui button blue" id="btnNextQstn"><spring:message code="exam.label.next" /></a><!-- 다음 -->
                </c:if>
            </div>
        </div>
	</c:otherwise>
</c:choose>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
