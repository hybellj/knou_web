<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		var isSbmsn = false;
		var tkexamTimmer;
		$(document).ready(function() {
			if(${not empty msg}) {
				window.parent.msgPop("${msg}");
			}

			controllSubmitBtn();

			let userIdtiSec = [30, 20]; 					// 설정된 초가 남았을 때 학습자에게 알림을 노출한다.
			let remainderTm	= "${tkexamInfo.remainderTm}";	// 남은시간
			let minFormatted = "";
	        let secFormatted = "";
	        let min = 0;
	        let sec = 0;

			tkexamTimmer = setInterval(function() {
	            min = Math.floor(remainderTm / 60);
	            sec = remainderTm % 60;
	            minFormatted = min < 10 ? '0' + min : '' + min;
	            secFormatted = sec < 10 ? '0' + sec : '' + sec;

	            $("#leftTm").empty().append(minFormatted + ":" + secFormatted);

	            remainderTm--;
	            for(var i = 0; i < userIdtiSec.length; i++) {
                    if (remainderTm == userIdtiSec[i]) {
                    	UiComm.showMessage('<spring:message code="quiz.alert.finish.noti" arguments="' + userIdtiSec[i] + '" />', "info");	/* 퀴즈 종료 {0}초 전입니다. */
                    }
                }

                if (remainderTm < 0) {
                    clearInterval(tkexamTimmer);
                    exampprAutoSbmsn();
                }

	            sessionCheck();

	        }, 1000);

			if(${vo.qstnDsplyGbncd eq 'EACH'}) {
				showQuestion(1);
			}

			// dialog 닫기시 퀴즈응시시간수정
			window.parent.$(".ui-dialog-titlebar > button")[0]
	        .addEventListener("click", function() {
	            clearInterval(tkexamTimmer);
	            quizTkexamMntsModify();
	        }, true);

			if(${fn:length(answShtList)} > 0) {
				setRspns();
			}
		});

		// 세션 체크
		function sessionCheck() {
			const url  = "/common/checkSession.do";

			ajaxCall(url, null, function(data) {
				if(!(data == "Y")) {
					UiComm.showMessage("<spring:message code='system.fail.session.expire' />", "info");/* 세션이 만료되었습니다. */
					clearInterval(tkexamTimmer);
				}
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
    		});
		}

		// 시험지자동제출
		function exampprAutoSbmsn() {
			UiComm.showMessage("<spring:message code='quiz.alert.expire.time' />", "info", 500)	/* 퀴즈 시간이 종료되었습니다. */
        	.then(function(result) {
        		exampprSbmsn("auto");
        	});
	    }

		// 시험지제출
		function exampprSbmsn(type) {
			let confirm = true;
			if(type == "self") {
				UiComm.showMessage("<spring:message code='quiz.confirm.examppr.submit' />", "confirm")	/* 시험지를 제출하시겠습니까? 제출 후 재응시 불가능합니다. */
				.then(function(result) {
					confirm = result;
				});
			}
			if(confirm) {
				const raw 	= $("#qstnRspnsFrm input[name=rspns]").val();
				const rspns = raw ? JSON.parse(raw) : [];

				if(rspns.length > 0) {
					const url = "/quiz/stdntQuizExampprSbmsnAjax.do";

					$.ajax({
				        url 	  	: url,
				        async	  	: false,
				        type 	  	: "POST",
				        dataType 	: "json",
				        data 	  	: JSON.stringify({
							rspns 		: rspns,
							tkexamId	: "${tkexamInfo.tkexamId}"
				        }),
				        contentType	: "application/json; charset=UTF-8",
				        success  	: function(data){
			                if(data.result > 0) {
			                	UiComm.showMessage("<spring:message code='quiz.alert.examppr.complete' />", "success", 500)	/* 제출 완료되었습니다. */
			                	.then(function(result) {
			                		isSbmsn = true;
				                    clearInterval(tkexamTimmer);
				                	window.parent.location.reload();
				                    window.parent.closeDialog();
			                	});
			                } else {
			                	UiComm.showMessage(data.message, "error");
			                }
			            },
				    });
				}
			}
		}

		// 제출 버튼 표시
		function controllSubmitBtn() {
			let $rspns 		= $(".quiz_paper_list").find("li[id^=rspns]");
			let allActive 	= $rspns.length === $rspns.filter(".active").length;

			if (!allActive) {
				$("#submitBtn").hide();
			} else {
				$("#submitBtn").css("display", "inline-block");
			}
		}

		// 현재문항순번반환
		function getCurSeqno() {
		    return Number($("div.question_area:visible").attr("data-qstnSeqno"));
		}

		// 전체문항수반환
		function getQstnCnt() {
		    return $("div.question_area").length;
		}

		// 해당 순번 문항 표시 및 버튼 제어
		function showQuestion(seqno) {
		    const total = getQstnCnt();

		    $("div.question_area").hide();
		    $("div.question_area[data-qstnSeqno="+seqno+"]").show();

		    $("#btnPrevQstn").toggle(seqno > 1);
		    $("#btnNextQstn").toggle(seqno < total);
		}

		// 이전 문항으로 이동
		function goPrevQstn() {
		    const cur = getCurSeqno();
		    if (cur > 1) {
		    	showQuestion(cur - 1);
		    	qstnBulkTempSave($("div.question_area:visible"));
		    }
		}

		// 다음 문항으로 이동
		function goNextQstn() {
		    const cur = getCurSeqno();
		    if (cur < getQstnCnt()) {
		    	showQuestion(cur + 1);
		    	qstnBulkTempSave($("div.question_area:visible"));
		    }
		}

	 	// 문항일괄임시저장
		function qstnBulkTempSave(obj) {
			const raw 	= $("#qstnRspnsFrm input[name=rspns]").val();
			const rspns = raw ? JSON.parse(raw) : [];

			if(rspns.length > 0) {
				const url = "/quiz/stdntQstnBulkTempSaveAjax.do";

				$.ajax({
			        url 	  	: url,
			        async	  	: false,
			        type 	  	: "POST",
			        dataType 	: "json",
			        data 	  	: JSON.stringify({
						rspns 		: rspns,
						tkexamId	: "${tkexamInfo.tkexamId}"
			        }),
			        contentType	: "application/json; charset=UTF-8",
			        success  	: function(data){
		                if(data.result > 0) {
		                	if (!obj) {
		                		UiComm.showMessage("<spring:message code='quiz.alert.tempsave' />", "success");	/* 임시저장하였습니다. */
		                	}
		                } else {
		                	UiComm.showMessage(data.message, "error");
		                }
		            },
			    });
			}
		}

	 	// 단일문항임시저장
	    function ssnlQstnTempSave(map) {
			map.tkexamId = "${tkexamInfo.tkexamId}";

			const url = "/quiz/stdntSsnlQstnTempSaveAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(map),
		        contentType	: "application/json; charset=UTF-8",
		        success  	: function(data){
	                if(data.result > 0) {
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	            },
		    });
	    }

	 	// 퀴즈응시시간수정
	 	function quizTkexamMntsModify() {
	 		const url = "/quiz/stdntQuizTkexamMntsModifyAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify({
					examDtlId	: "${vo.examDtlId}",
					tkexamId	: "${tkexamInfo.tkexamId}"
		        }),
		        contentType	: "application/json; charset=UTF-8",
		        success  	: function(data){
	                if(data.result > 0) {
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	            },
		    });
	 	}

	 	// 제출답안 채우기
	 	function setRspns() {
			let obj = "";				// 문항최상위객체
			let qstnRspnsTycd = "";		// 문항답변유형코드
			let displayAnsw = "";
			<c:forEach var="answ" items="${answShtList}">
				obj = $(".quiz-layout-wrapper .question_area[data-qstnId=${answ.qstnId}]")[0];
				qstnRspnsTycd = obj.dataset.rspnstycd;

				// 단일, 다중선택형
				if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
					qstnAnswSht(obj.querySelector(".q_cont_ans input[name^=qstn]"), qstnRspnsTycd, "SET");
				// OX선택형
				} else if(qstnRspnsTycd == "OX_CHC") {
					qstnAnswSht(obj.querySelector(".ox_quiz input[name^=qstn]"), qstnRspnsTycd, "SET");
				// 단답형
				} else if(qstnRspnsTycd == "SHORT_TEXT") {
					qstnAnswSht(obj.querySelector(".shortAnswerList input[name^=qstn]"), qstnRspnsTycd, "SET");
				// 서술형
				} else if(qstnRspnsTycd == "LONG_TEXT") {
					qstnAnswSht(obj.querySelector(".q_cont_ans textarea[name^=qstn]"), qstnRspnsTycd, "SET");
				// 연결형
				} else if(qstnRspnsTycd == "LINK") {
					qstnAnswSht(obj.querySelector(".matching_form .account-list div[name^=link]"), qstnRspnsTycd, "SET");
				}
			</c:forEach>
	 	}
	</script>

	<body class="modal-body">
		<%
            String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
        %>
        <div class="board_top class">
            <h3 class="board-title"><%=sbjctnm%></h3>
            <div class="right-area">
                <div class="feedback-info">
                    <p class="desc">
                        <span><strong>${vo.deptnm }</strong></span>
                        <span><strong>${vo.userId }</strong></span>
                        <span><strong>${vo.usernm }</strong></span>
                    </p>
                </div>
            </div>
        </div>

        <div class="board_top">
            <h3 class="board-title">${vo.examTtl }</h3>
            <div class="right-area">
                <div class="btn basic">
                    <i class="xi-alarm-o icon"></i>
                    <label id="leftTm"></label> <spring:message code="date.minute" /><!-- 분 -->
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/jsp/quiz/common/quiz_preview_inc.jsp" %>

		<div class="modal_btns">
			<c:if test="${vo.qstnDsplyGbncd eq 'EACH'}">
	        	<button type="button" class="btn type1" onclick="goPrevQstn();" id="btnPrevQstn"><spring:message code="quiz.button.prev" /></button><!-- 이전 -->
            </c:if>
	        <button type="button" class="btn type1" onclick="qstnBulkTempSave();"><spring:message code="quiz.label.qstn.temp.save" /></button><!-- 임시저장 -->
	        <button type="button" class="btn type1" onclick="exampprSbmsn('self');" id="submitBtn"><spring:message code="common.submission" /></button><!-- 제출 -->
            <c:if test="${vo.qstnDsplyGbncd eq 'EACH'}">
	        	<button type="button" class="btn type1" onclick="goNextQstn();" id="btnNextQstn"><spring:message code="quiz.button.next" /></button><!-- 다음 -->
            </c:if>
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
