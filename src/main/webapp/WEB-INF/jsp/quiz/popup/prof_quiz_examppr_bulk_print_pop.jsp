<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
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
    	</style>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		// 제출 답안 시험문제 리스트
		function quizStarePaperList(num, tkexamId, userId, lastYn) {
			var url  = "/quiz/profTkexamExampprAnswShtListAjax.do";
			var data = {
				"tkexamId"	: tkexamId,
				"userId"    : userId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		if(returnList.length > 0) {
						html += "<ul class='num-chk'>";
						returnList.forEach(function(v, i) {
							var qstnAnswerClass = v.answShtCts != null && v.answShtCts != "" ? "correct" : "";
							html += "<li class='" + qstnAnswerClass + "'><a href='#0'>" + v.qstnDsplySeqno + "</a></li>";
						});
	        			returnList.forEach(function(v, i) {
	        				var answerSrc = v.ansrYn == "Y" ? "/webdoc/img/quiz_true.gif" : "/webdoc/img/answer.png";
	        				html += "<div class='ui card wmax qstnDiv'>";
	        				html += "	<div class='fields content header2'>";
	        				html += "		<div class='field wf100 flex-item'>";
	        				html += "			<span>문제" + v.qstnDsplySeqno + ".</span> " + v.qstnTtl;
	        				html += "			<div class='alt_icon overflow-hidden mla'>";
	        				html += "				<img class='list ul icon w30 color' src='" + answerSrc + "' />";
	        				html += "			</div>";
	        				html += "		</div>";
	        				html += "	</div>";
							html += "	<div class='content'>";
							if(v.qstnCts != undefined) {
								html += "	<p>" + v.qstnCts + "</p>";
							}
							// 단일, 다중선택형
	        				if(v.qstnRspnsTycd == 'ONE_CHC' || v.qstnRspnsTycd == 'MLT_CHC') {
								var emplClass = v.qstnRspnsTycd == "MLT_CHC" ? "multi" : "";
								v.qstnVwitmDsplySeq.split("@#").forEach(function(el, index) {
									html += "<div class='field' id='emplLi_" + v.qstnDsplySeqno +"'>";
									html += "	<div class='ui read-only checkbox'>";
									var checkCrans = "";
									v.answShtCts.split("@#").forEach(function(sel, sindex) {
										if(sel == (index+1)) checkCrans = "checked";
									});
									html += "		<input type='checkbox' name='rgtAnsr_CHOICE_" + v.qstnDsplySeqno + "' id='rgtAnsr_" + v.qstnDsplySeqno + "' " + checkCrans + " />";
			        				html += "		<label class='question empl " + emplClass + "'>" + v.qstnVwitmCts.split('@#')[index] + "</label>";
		        					html += "	</div>";
		        					html += "</div>";
			        			});

							// 단답형
	        				} else if(v.qstnRspnsTycd == 'SHORT_TEXT') {
								html += "	<div class='equal width fields'>";
								v.answShtCts.split("@#").forEach(function(el, index) {
									html += "	<div class='field'>";
									html += "		<input type='text' value='" + el + "' readonly='readonly' />";
									html += "	</div>";
								});
	        					html += "	</div>";

	        				// 서술형
	        				} else if(v.qstnRspnsTycd == 'LONG_TEXT') {
								html += "	<input type='text' value='" + v.answShtCts + "' readonly='readonly' />";

							// OX선택형
	        				} else if(v.qstnRspnsTycd == 'OX_CHC') {
								html += "	<div class='checkImg'>";
								v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									var oxClass = el == "O" ? "true" : "false";
									html += "	<input id='oxChk" + v.qstnId + "_" + oxClass + "' type='radio' name='oxChk" + v.qstnId + "' disabled='disabled' value='" + v.qstnVwitmDsplySeq.split('@#')[index] + "' " + (v.answShtCts == (index+1) ? "checked" : "") + " />";
									html += "	<label class='imgChk " + oxClass + "' for='oxChk" + v.qstnId + "_" + oxClass + "'></label>";
								});
								html += "	</div>";

							// 연결형
	        				} else if(v.qstnRspnsTycd == 'LINK') {
								html += "	<div class='line-sortable-box'>";
								html += "		<div class='account-list'>";
								v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									html += "		<div class='line-box num" + (index < 10 ? '0':'') + (index+1) + " id='emplLi_" + v.qstnDsplySeqno + "_" + index + "'>";
									html += "			<div class='question' id='emplMatch_" + v.qstnDsplySeqno + "_" + index +"' name='emplMatch_" + v.qstnDsplySeqno + "_" + index +"'><span>" + el.split("|")[0] + "</span></div>";
									html += "			<div class='slot' id='rqtAnsrMatch_" + v.qstnDsplySeqno + "_" + index +"' name='rqtAnsrMatch_" + v.qstnDsplySeqno + "_" + index +"'>" + v.answShtCts.split("@#")[index] + "</div>";
									html += "		</div>";
								});
	        					html += "		</div>";
	        					html += "	</div>";
	        				}
	        				html += "	</div>";
	        				html += "	<div class='content'>";
	        				html += "		<div class='flex gap16 align-items-center mb20'>";
	        				html += "			<div class='flex flex1'>";
	        				html += "				<label class='ui label flex-none m0'>정답</label>";
	        				// 단일, 다중선택형
	        				if(v.qstnRspnsTycd == 'ONE_CHC' || v.qstnRspnsTycd == 'MLT_CHC') {
								var cransNo = "";
								v.cransNo.split("@#").forEach(function(el, index) {
									v.qstnVwitmDsplySeq.split("@#").forEach(function(sel, sindex) {
										if(sel == el) {
											if(cransNo == "") {
												cransNo = sindex + 1;
											} else {
												cransNo += "," + (sindex + 1);
											}
										}
									});
								});
								html += "			<input type='text' class='flex1' value='" + cransNo + "' readonly='readonly' />";

							// 단답형
	        				} else if(v.qstnRspnsTycd == 'SHORT_TEXT') {
	        					v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									html += "		<input type='text' class='flex1' value='" + el + "' readonly='readonly' />";
	        					});

	        				// 서술형
	        				} else if(v.qstnRspnsTycd == 'LONG_TEXT') {
								html += "			<input type='text' class='flex1' value='' readonly='readonly' />";

							// OX선택형
	        				} else if(v.qstnRspnsTycd == 'OX_CHC') {
								html += "			<input type='text' class='flex' value='" + v.cransCts + "' readonly='readonly' />";

	        				// 연결형
	        				} else if(v.qstnRspnsTycd == 'LINK') {
	        					v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									html += "		<input type='text' class='flex1' value='" + el.split("|")[0] + " - " + el.split("|")[1] + "' readonly='readonly' />";
	        					});
	        				}
	        				html += "			</div>";
	        				html += "			<div class='flex'>";
	        				html += "				<label class='ui label flex-none m0'>배점</label>";
	        				html += "				<input type='text' class='w80' value='" + v.qstnScr + "' readonly='readonly' />";
	        				html += "			</div>";
	        				html += "			<div class='flex align-items-center gap4'>점수 <input class='w50 score' value='" + v.scr + "' /> 점</div>";
	        				html += "		</div>";
	        				html += "	</div>";
	        				html += "</div>";
	        			});
	        		}
	        		$("#examPreviewQstnList_"+num).append(html);
	        		watermarkedDataURL("${examBscVO.rgtrId}"+"_"+"${examBscVO.rgtrnm}",$("div.ui.card"));
					if('Y' == lastYn){
						quizStarePaperPrint();
					}
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}


		// 인쇄
		function quizStarePaperPrint() {
			$("#exampprModal").print({
				globalStyles : true,
				stylesheet : null,
				rejectWindow : true,
				noPrintSelector : ".no-print",
				append : null,
				prepend : null
			});

			//window.parent.closeDialog();
		}

		// 워터마크
		function watermarkedDataURL (text,watermarkDiv) {
			//var watermarkDiv = $("#exampprModal");		//워터마크 적용될 영역
			var tempCanvas=document.createElement('canvas');	//워터마크 사용될 임의의 캔버스
			var tempCtx=tempCanvas.getContext('2d');			//캔버스 2d 컨텐츠
			var cw,ch;
			cw=tempCanvas.width=watermarkDiv.outerWidth(true);	//영역의 넓이
			ch=tempCanvas.height=watermarkDiv.outerHeight(true);//영역의 높이
			// height is font size
			tempCtx.font="24px verdana";						//폰트 및 글꼴
			var metrics   = tempCtx.measureText(text);			//가변글자 객체
			var textWidth = metrics.width;						//가변글자 넓이
			var height    = 24;									//글자 높이

			tempCtx.fillStyle   ='gray'							//글자 색상
			tempCtx.globalAlpha = "0.2";						//글자 투명도

			//각도 45도 임으로 피타고라스정의에의해 밑에식 구현
			var xStep = Math.sqrt(textWidth * textWidth/2);

			//시계반대방향 45도 기울임
			tempCtx.rotate(Math.PI / 180 * -45);

			for (var y = 0; y < ch; y += xStep) {
				var x = 0
		        for (; x < cw; x += xStep) {
					tempCtx.translate(xStep, xStep);
					tempCtx.strokeText(text,-xStep,y);
		        }
		        tempCtx.translate(-x-xStep*2, -(x-xStep));
			}

			var dataUrl = tempCanvas.toDataURL();				//data Url화
			watermarkDiv.attr("style","background:url("+dataUrl+"); -webkit-print-color-adjust:exact;");
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <form id="exampprPrintForm" name="exampprPrintForm" method="POST">
			<div id="wrap">
				<div id="exampprModal">
				<c:forEach var="items" items="${quizTkexamList}" varStatus="status">
					<div class="ui form">
						<div class="field">
							<div class="ui info message">
								<div class="header">'${items.usernm}'<spring:message code="exam.label.std.paper" /></div><!-- 의 시험지 -->
							</div>
						</div>
						<div class="ui divider"></div>
						<div id="examPreviewQstnList_${status.count}" class="qstnList"></div>
						<c:choose>
							<c:when test="${status.last}">
								<script type="text/javascript">quizStarePaperList('${status.count}', '${items.tkexamId}', '${items.userId}','Y');</script>
							</c:when>
							<c:otherwise>
								<script type="text/javascript">quizStarePaperList('${status.count}', '${items.tkexamId}', '${items.userId}');</script>
							</c:otherwise>
						</c:choose>
					</div>

				</c:forEach>
				</div>
			</div>
		</form>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
