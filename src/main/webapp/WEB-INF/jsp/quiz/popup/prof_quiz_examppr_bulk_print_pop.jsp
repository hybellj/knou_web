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
						html += "<div class='qstnInfo flex-item gap-3 margin-bottom-5'>";
						returnList.forEach(function(v, i) {
							var answClass = v.answShtCts != null && v.answShtCts != "" ? "bcLblue" : "";
							html += "<div class='custom-input padding-3'>";
							html += "	<p class='checkmark padding-left-3 " + answClass + "'>" + v.qstnDsplySeqno + "</p>";
							html += "</div>";
						});
						html += "</div>";
						html += "<div class='qstnList'>";
	        			returnList.forEach(function(v, i) {
	        				var answSrc = v.ansrYn == "Y" ? "/webdoc/img/quiz_true.gif" : "/webdoc/img/answer.png";
	        				html += "<div class='board_top border-1 padding-3 margin-bottom-0'>";
	        				html += "	<span>문제 " + v.qstnDsplySeqno + ". " + UiComm.escapeHtml(v.qstnTtl) + "</span>";
	        				html += "	<div class='overflow-hidden right-area w30 d-inline-block position-relative' style='height:30px;'>";
	        				html += "		<img class='width-100-per show margin-left-auto' style='position:absolute;bottom:0;' src='" + answSrc + "' />";
	        				html += "	</div>";
	        				html += "</div>";
	        				html += "<div class='padding-3 margin-top-0 border-1 cpn'>";
	        				html += "	<div class='margin-bottom-5'>" + v.qstnCts + "</div>";
	        				// 단일, 다중선택형
	        				if(v.qstnRspnsTycd == 'ONE_CHC' || v.qstnRspnsTycd == 'MLT_CHC') {
	        					v.qstnVwitmDsplySeq.split("@#").forEach(function(el, index) {
									html += "<div class='margin-bottom-3'>";
									html += "	<span class='custom-input'>";
									var rspnsType = v.qstnRspnsTycd == "MLT_CHC" ? "checkbox" : "radio";
									var checkCrans = "";
									v.answShtCts.split("@#").forEach(function(sel, sindex) {
										if(sel == (index+1)) checkCrans = "checked";
									});
									html += "		<input type='" + rspnsType + "' name='qstn_" + v.qstnId + "' id='qstn_" + v.exampprId + "_" + index + "' " + checkCrans + " />";
									html += "		<label for='qstn_" + v.exampprId + "_" + index + "'>" + v.qstnVwitmCts.split('@#')[index] + "</label>";
									html += "	</span>";
									html += "</div>";
	        					});
	        				// OX선택형
	        				} else if(v.qstnRspnsTycd == 'OX_CHC') {
	        					v.qstnVwitmDsplySeq.split("@#").forEach(function(el, index) {
									html += "<span class='custom-input'>";
									html += "	<input type='radio' name='qstn_" + v.qstnId + "' id='qstn_" + v.exampprId + "_" + index + "' " + (v.answShtCts == (index+1) ? "checked" : "") + " />";
									html += "	<label for='qstn_" + v.exampprId + "_" + index + "'>" + v.qstnVwitmCts.split('@#')[index] + "</label>";
									html += "</span>";
	        					});
	        				// 단답형
	        				} else if(v.qstnRspnsTycd == 'SHORT_TEXT') {
								html += "<div class='flex gap-2 margin-bottom-2'>";
								v.answShtCts.split("@#").forEach(function(el, index) {
									html += "<input type='text' class='width-15per' value='" + el + "' />";
								});
								html += "</div>";
							// 서술형
	        				} else if(v.qstnRspnsTycd == 'LONG_TEXT') {
								html += "<textarea style='width:100%;height:100px;'>" + v.answShtCts + "</textarea>";
							// 연결형
	        				} else if(v.qstnRspnsTycd == 'LINK') {
								html += "<div class='line-sortable-box flex'>";
								html += "	<div class='account-list width-50per'>";
								v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									var cts = v.answShtCts == null ? "" : v.answShtCts.split("@#")[index];
									html += "	<div class='line-box border-1 margin-bottom-3 padding-3 flex'>";
									html += "		<div class='question width-30per'><span>" + el.split("|")[0] + "</span></div>";
									html += "		<div class='slot margin-left-auto border-1 text-center width-100per' style='height:30px;'>" + cts + "</div>";
									html += "	</div>";
								});
								html += "	</div>";
								html += "	<div class='inventory-list w200 margin-left-auto'>";
								html += "	</div>";
								html += "</div>";
	        				}
	        				html += "</div>";
	        				html += "<div class='border-1 margin-bottom-3 padding-3 qstnDiv'>";
	        				html += "	<div class='flex-item'>";
	        				html += "		<p class='margin-right-3'>정답</p>";
	        				html += "		<div class='margin-right-3'>";
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
								html += "		<p>" + cransNo + "</p>";
							// 단답형
	        				} else if(v.qstnRspnsTycd == 'SHORT_TEXT') {
								html += "		<p>" + v.qstnVwitmCts.replaceAll("@#", ",") + "</p>";
							// 서술형
	        				} else if(v.qstnRspnsTycd == 'LONG_TEXT') {
								html += "		<p></p>";
							// OX선택형
	        				} else if(v.qstnRspnsTycd == 'OX_CHC') {
								html += "		<p>" + v.cransCts + "</p>";
							// 연결형
	        				} else if(v.qstnRspnsTycd == 'LINK') {
								var emplMatchNumStr = "A@#B@#C@#D@#E@#F@#G@#H@#I@#J";
								var emplMatchNumArray = emplMatchNumStr.split("@#");
								var cransCts = "";
								v.qstnVwitmCts.split("@#").forEach(function(el, index) {
									if(cransCts == "") {
										cransCts = emplMatchNumArray[index] + "-" + el.split("|")[1];
									} else {
										cransCts += "," + emplMatchNumArray[index] + "-" + el.split("|")[1];
									}
								});
								html += "		<p>" + cransCts + "</p>";
	        				}
	        				html += "		</div>";
	        				html += "		<p class='margin-right-3'>배점</p>";
	        				html += "		<div class='margin-right-3'><p>" + v.qstnScr + "</p></div>";
	        				html += "		<p class='margin-right-3'>난이도</p>";
	        				html += "		<div class='margin-right-3'><p>" + v.qstnDfctlvTynm + "</p></div>";
	        				html += "		<div class='margin-left-auto flex-item'>";
	        				html += "			<p class='margin-right-3'>점수</p>";
	        				html += "			<p>" + v.scr + "</p>";
	        				html += "		</div>";
	        				html += "	</div>";
	        				html += "</div>";
	        			});
	        			html += "</div>";
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
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
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
                            <p class="txt">'${items.usernm}'<spring:message code="exam.label.std.paper" /></p><!-- 의 시험지 -->
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
