<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
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
		// 제출 답안 시험문제 리스트
		function quizStarePaperList(num, tkexamId, userId, lastYn) {
			const url  = "/quiz/profTkexamExampprAnswShtListAjax.do";
			const data = {
				tkexamId	: tkexamId,
				userId    	: userId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let returnList = data.returnList || [];
	        		let html = "";
	        		if(returnList.length > 0) {
						// 번호영역
						html += "<div class='quiz_paper_wrap'>";
						html += "	<div class='board_top'>";
						html += "		<div class='quiz_paper_list'>";
						html += "			<ol>";
						returnList.forEach(function(v, i) {
							let answClass = v.answShtCts != null && v.answShtCts != "" ? "active" : "";
							html += "			<li class='" + answClass + "'><span>" + v.qstnDsplySeqno + "</span></li>";
						});
						html += "			</ol>";
						html += "		</div>";
						html += "	</div>";
						html += "</div>";
	        			returnList.forEach(function(v, i) {
	        				html += "<div class='course_history bd0 cpn'>";
	        				html += "	<div class='question_area pd0'>";
	        				html += "		<div class='question_con'>";
	        				// 문제번호,제목영역
	        				html += "			<div class='q_top'>";
	        				html += "				<div class='flex-item width-100per'>";
	        				html += "					<p class='flex-none mr15'><b><spring:message code='quiz.label.qstn' />" + v.qstnDsplySeqno + "</b></p>";/* 문제 */
	        				html += "					<div class='flex-1 tal'>" + UiComm.escapeHtml(v.qstnTtl) + "</div>";
	        				if(v.ansrYn == "Y") {
								html += "				<div class='q_result correct'>";
								html += "					<i class='xi-radiobox-blank icon'></i>";
								html += "				</div>";
	        				} else {
								html += "				<div class='q_result incorrect'>";
								html += "					<i class='xi-close icon'></i>";
								html += "				</div>";
	        				}
	        				html += "				</div>";
	        				html += "			</div>";
	        				// 문제내용영역
	        				html += "			<div class='q_cont'>";
	        				if(v.qstnCts.trimStart().startsWith('<div class="se-contents"')) {
		        				html += "			<pre>" + v.qstnCts + "</pre>";
	        				} else {
		        				html += "			<p>" + v.qstnCts + "</p>";
	        				}
	        				// 단일, 다중선택형
	        				if(v.qstnRspnsTycd == 'ONE_CHC' || v.qstnRspnsTycd == 'MLT_CHC') {
								html += "			<ol class='q_cont_ans'>";
								v.qstnVwitmDsplySeq.split("@#").forEach(function(el, index) {
									let rspnsType = v.qstnRspnsTycd == "MLT_CHC" ? "checkbox" : "radio";
									let checkCrans = "";
									let answShtCts = v.answShtCts || "";
									answShtCts.split("@#").forEach(function(sel, sindex) {
										if(sel == (index+1)) checkCrans = "checked";
									});
									html += "			<li>";
									html += "				<input type='" + rspnsType + "' name='qstn_" + v.qstnId + "' id='qstn_" + v.exampprId + "_" + index + "' " + checkCrans + " />";
									html += "				<label for='qstn_" + v.exampprId + "_" + index + "'><span class='ansNum'>" + (index+1) + "</span>" + v.qstnVwitmCts.split('@#')[index] + "</label>";
									html += "			</li>";
								});
								html += "			</ol>";
							// OX선택형
	        				} else if(v.qstnRspnsTycd == 'OX_CHC') {
								html += "			<div class='q_cont_ans ox_quiz justify-content-center'>";
								v.qstnVwitmDsplySeq.split("@#").forEach(function(el, index) {
									html += "			<div class='ox_item'>";
									html += "				<input type='radio' class='ox_input' name='qstn_" + v.qstnId + "' id='qstn_" + v.exampprId + "_" + index + "' " + (v.answShtCts == (index+1) ? "checked" : "") + " />";
									html += "				<label for='qstn_" + v.exampprId + "_" + index + "' class='btn basic'>";
									if(v.qstnVwitmCts.split('@#')[index] == "O") {
										html += "				<i class='xi-radiobox-blank icon'></i>";
									} else {
										html += "				<i class='xi-close icon'></i>";
									}
									html += "				</label>";
									html += "			</div>";
	        					});
								html += "			</div>";
							// 단답형
	        				} else if(v.qstnRspnsTycd == 'SHORT_TEXT') {
	        					let answShtCts = v.answShtCts || "";
		        				html += "			<div class='q_cont_ans shortAnswerList'>";
								answShtCts.split("@#").forEach(function(el, index) {
									html += "			<label><input type='text' class='form-control' value='" + el + "' /></label>";
								});
		        				html += "			</div>";
		        			// 서술형
	        				} else if(v.qstnRspnsTycd == 'LONG_TEXT') {
		        				html += "			<div class='q_cont_ans'>";
		        				html += "				<textarea style='width:100%;height:100px;'>" + v.answShtCts + "</textarea>";
		        				html += "			</div>";
		        			// 연결형
	        				} else if(v.qstnRspnsTycd == 'LINK') {
								const alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		        				html += "			<div class='q_cont_ans matching_form'>";
		        				html += "				<ol class='matching_list'>";
		        				v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									var cts = v.answShtCts == null ? "" : v.answShtCts.split("@#")[index];
									html += "				<li class='matching_item'>";
									html += "					<div class='q_box'>";
									html += "						<label>";
									html += "							<span>" + alphabets[index] + "</span>";
									html += "							<input type='text' value='" + el.split("|")[0] + "'>";
									html += "						</label>";
									html += "					</div>";
									html += "					<div class='a_box'>";
									html += "						<label>";
									html += "							<input type='text' value='" + cts + "'>";
									html += "						</label>";
									html += "					</div>";
									html += "				</li>";
								});
		        				html += "				</ol>";
		        				html += "			</div>";
	        				}
	        				html += "			</div>";

	        				html += "		</div>";
	        				html += "	</div>";
	        				html += "</div>";
							// 결과영역
							html += "<div class='ans_cont qstnDiv'>";
							html += "	<div class='board_top align-items-center'>";
							html += "		<ol class='ans_cont_list'>";
							html += "			<li><spring:message code='quiz.label.crans' />";/* 정답 */
							html += "				<span>";
							// 단일, 다중선택형
	        				if(v.qstnRspnsTycd == 'ONE_CHC' || v.qstnRspnsTycd == 'MLT_CHC') {
	        					let cransNo = "";
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
								html += 				cransNo;
							// 단답형
	        				} else if(v.qstnRspnsTycd == 'SHORT_TEXT') {
								html += 				v.qstnVwitmCts.replaceAll("@#", ",");
							// OX선택형
	        				} else if(v.qstnRspnsTycd == 'OX_CHC') {
								html += 				v.cransCts;
							// 연결형
	        				} else if(v.qstnRspnsTycd == 'LINK') {
	        					let emplMatchNumStr = "A@#B@#C@#D@#E@#F@#G@#H@#I@#J";
	        					let emplMatchNumArray = emplMatchNumStr.split("@#");
	        					let cransCts = "";
								v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									if(cransCts == "") {
										cransCts = emplMatchNumArray[index] + "-" + el.split("|")[1];
									} else {
										cransCts += "," + emplMatchNumArray[index] + "-" + el.split("|")[1];
									}
								});
								html += 				cransCts;
	        				}
							html += "				</span>";
							html += "			</li>";
							html += "			<li><spring:message code='message.marks' /><span>" + v.qstnScr + "</span></li>";/* 배점 */
							html += "			<li><spring:message code='quiz.label.dfctlv' /><span>" + v.qstnDfctlvTynm + "</span></li>";/* 난이도 */
							html += "			<li><spring:message code='common.score' /><span>" + v.scr + "</span></li>";/* 점수 */
							html += "		</ol>";
							html += "	</div>";
							html += "</div>";
	        			});
	        		}
	        		$("#examPreviewQstnList_"+num).append(html);
	        		watermarkedDataURL("${examBscVO.rgtrId}"+"_"+"${examBscVO.rgtrnm}",$("div.qstnList"));
					if('Y' == lastYn){
						quizStarePaperPrint();
					}
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='quiz.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}


		// 인쇄
		function quizStarePaperPrint() {
			window.print();
			/* $("#exampprModal").print({
				globalStyles : true,
				stylesheet : null,
				rejectWindow : true,
				noPrintSelector : ".no-print",
				append : null,
				prepend : null
			}); */
		}

		// 워터마크
		function watermarkedDataURL (text,watermarkDiv) {
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

	<body class="modal-page">
        <form id="exampprPrintForm" name="exampprPrintForm" method="POST">
			<div id="wrap">
				<div id="exampprModal">
					<c:forEach var="items" items="${quizTkexamList}" varStatus="status">
						<div class="msg-box info">
                            <p class="txt">'${items.usernm}'<spring:message code="quiz.label.is.examppr" /></p><!-- 의 시험지 -->
                        </div>
						<div id="examPreviewQstnList_${status.count}" class="qstnList"></div>
						<c:choose>
							<c:when test="${status.last}">
								<script type="text/javascript">quizStarePaperList('${status.count}', '${items.tkexamId}', '${items.userId}','Y');</script>
							</c:when>
							<c:otherwise>
								<script type="text/javascript">quizStarePaperList('${status.count}', '${items.tkexamId}', '${items.userId}');</script>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</div>
			</div>
		</form>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
