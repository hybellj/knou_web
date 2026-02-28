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
		function quizStarePaperList(num,stdNo,lastYn) {
			var url  = "/quiz/quizStarePaperList.do";
			var data = {
				"examCd"      : "${vo.examCd}",
				"crsCreCd"    : '${vo.crsCreCd}',
				"stdNo"       : stdNo,
				"examQstnSns" : "${vo.examQstnSn}",
				"searchType"  : "EVAL"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		if(returnList.length > 0) {
	        			if("${vo.examQstnSn}" == "") {
		        			html += `<ul class="num-chk">`;
	        				returnList.forEach(function(v, i) {
	        					var qstnAnswerClass = v.stareAnsr != null && v.stareAnsr != "" ? "correct" : "";
		        				html += `	<li class="\${qstnAnswerClass}"><a href="#0">\${v.qstnNo}</a></li>`;
	        				});
		        			html += `</ul>`;
	        			}
	        			returnList.forEach(function(v, i) {
	        				var answerSrc = v.ansrYn == "Y" ? "/webdoc/img/quiz_true.gif" : "/webdoc/img/answer.png";
	        				html += `<div class="ui card wmax qstnDiv" id="\${v.qstnNo }_\${v.subNo}" data-examQstnSn="\${v.examQstnSn }">`;
	        				html += `	<div class="fields content header2">`;
	        				html += `		<div class="field wf100 flex-item">`;
	        				html += `			<span><spring:message code="exam.label.qstn" />\${v.qstnNo }.</span> \${v.title }`;/* 문제 */
	        				html += `			<div class="alt_icon overflow-hidden mla">`;
			            	html += `				<img class="list ul icon w30 color" src="\${answerSrc }" alt="">`;
	        				html += `			</div>`;
			            	html += `		</div>`;
				            html += `	</div>`;
	        				if(v.qstnTypeCd == 'CHOICE' || v.qstnTypeCd == 'MULTICHOICE') {
	        					var emplStr 		= v.empl1+'@#'+v.empl2+'@#'+v.empl3+'@#'+v.empl4+'@#'+v.empl5+'@#'+v.empl6+'@#'+v.empl7+'@#'+v.empl8+'@#'+v.empl9+'@#'+v.empl10;
	        					var emplArray 		= emplStr.split("@#");
	        					var rgtAnsr1 		= v.rgtAnsr1 || "";
	        					var stareAnsr 		= v.stareAnsr || "";
	        					var examOdr 		= v.examOdr || "";
	        					var rgtAnsrArray 	= rgtAnsr1.split(",");
	        					var stareAnsrArray 	= stareAnsr.split(",");
	        					var emplOdrArray 	= examOdr.split(",");
	        					var stareAnsrOdrStr = "";
	        				html += `	<div class="content">`;
	        				if(v.qstnCts != undefined) {
	        				html += `		<p>\${v.qstnCts}</p>`;
	        				}
	        					stareAnsrArray.forEach(function(vv, ii) {
	        						var asnrCnt = 0;
	        						var loop_choice_flag = false;
	        						emplOdrArray.forEach(function(vvv, iii) {
	        							if(!loop_choice_flag) {
	        								if(emplArray[vvv-1] != null && emplArray[vvv-1] != "undefined" && emplArray[vvv-1] != "") {
	        									asnrCnt += 1;
	        								}
	        								if(vv == asnrCnt) {
	        									if(stareAnsrOdrStr == "") {
	        										stareAnsrOdrStr = vvv;
	        									} else {
	        										stareAnsrOdrStr += "," + vvv;
	        									}
	        									loop_choice_flag = true;
	        								}
	        							}
	        						});
	        					});
	        					var stareAnsrOdrArray;
	        					if(stareAnsrOdrStr == undefined) {
	        						stareAnsrOdrArray = [];
	        					} else {
	        						stareAnsrOdrArray = stareAnsrOdrStr.split(",");
	        					}
	        					for(var j = 1; j <= v.emplCnt; j++) {
	        						var qstnNo  = v.qstnNo;
	        						var emplNum = j;
	        						var ansrChk = false;
	        						rgtAnsrArray.forEach(function(vv, ii) {
	        							if(vv == j) {
	        								ansrChk = true;
	        							}
	        						});
	        						var itemChk = false;
	        						stareAnsrOdrArray.forEach(function(vv, ii) {
	        							if(vv == j) {
	        								itemChk = true;
	        							}
	        						});
	        						var emplClass = v.qstnTypeCd == "MULTICHOICE" ? "multi" : "";
	        				html += `		<div class="field \${ansrChk ? `correct` : ``}" id="emplLi_\${qstnNo}_\${j}">`;
	        				html += `			<div class="ui read-only checkbox">`;
	        				html += `				<input type="checkbox" name="rgtAnsr_CHOICE_\${qstnNo}" id="rgtAnsr_\${qstnNo}_\${j}" \${itemChk ? `checked` : ``}>`;
	        				html += `				<label class="question empl \${emplClass}" data-value="\${j}">\${emplArray[j-1]}</label>`;
	        				html += `			</div>`;
	        				html += `		</div>`;
	        					}
	        				html += `	</div>`;
	        					
	        				} else if(v.qstnTypeCd == 'SHORT') {
	        				html += `	<div class="content">`;
	        				html += `		<p class="content">\${v.qstnCts == undefined ? `` : `\${v.qstnCts}`}</p>`;
	        				html += `		<div class="equal width fields">`;
	        					var ansrCnt = 5;
	        					for(var c = 1; c <= 5; c++) {
	        						var ansr = "rgtAnsr"+c;
	        						if(v[ansr] != "" && v[ansr] != undefined && v[ansr] != null) {
	        							ansrCnt = c;
	        						}
	        					}
	        					var stareAnsr 	   = v.stareAnsr || "";
	        					var stareAnsrArray = stareAnsr.split("|");
	        					for(var j = 1; j <= ansrCnt; j++) {
	        						var stareValue = stareAnsrArray[j-1];
	        						if(stareValue == undefined) {
	        							stareValue = "";
	        						}
	        				html += `			<div class="field">`;
	        				html += `				<input type="text" value="\${stareValue }" readonly="readonly" />`;
	        				html += `			</div>`;
	        					}
	        				html += `		</div>`;
	        				html += `	</div>`;
	        					
	        				} else if(v.qstnTypeCd == 'DESCRIBE') {
	        				html += `	<div class="content">`;
	        				html += `		<p>\${v.qstnCts == undefined ? `` : `\${v.qstnCts}`}</p>`;
	        				html += `		<input type="text" value="\${v.stareAnsr == undefined ? `` : `\${v.stareAnsr}` }" readonly="readonly" />`;
	        				html += `	</div>`;
	        				} else if(v.qstnTypeCd == 'OX') {
	        				html += `	<div class="content"><p>\${v.qstnCts == undefined ? `` : `\${v.qstnCts}`}</p></div>`;
	        				html += `	<div class="checkImg">`;
	        				html += `		<input id="oxChk\${v.examQstnSn}_true" type="radio" name="oxChk\${v.examQstnSn}" disabled="disabled" value="1" \${v.stareAnsr == '1'?'checked':''} onChange="changeOxQstnAnswer(this)">`;
	        				html += `		<label class="imgChk true" for="oxChk\${v.examQstnSn}_true"></label>`;
	        				html += `		<input id="oxChk\${v.examQstnSn}_false" type="radio" name="oxChk\${v.examQstnSn}" disabled="disabled" value="2" \${v.stareAnsr == '2'?'checked':''} onChange="changeOxQstnAnswer(this)">`;
	        				html += `		<label class="imgChk false" for="oxChk\${v.examQstnSn}_false"></label>`;
	        				html += `	</div>`;
	        				} else if(v.qstnTypeCd == 'MATCH') {
	        					var emplMatchStr 		= v.empl1+'@#'+v.empl2+'@#'+v.empl3+'@#'+v.empl4+'@#'+v.empl5+'@#'+v.empl6+'@#'+v.empl7+'@#'+v.empl8+'@#'+v.empl9+'@#'+v.empl10;
	        					var emplMatchArray 		= emplMatchStr.split("@#");
	        					var stareAnsr 			= v.stareAnsr || "";
	        					var stareAnsrMatchArray = stareAnsr.split("|");
	        					var examOdr 			= v.examOdr || "";
	        					var emplOdrArray 		= examOdr.split(",");
	        					var stareAnsrOdrStr = "";
	        				html += `	<div class="content">`;
	        				html += `		<p>`;
	        				if(v.qstnCts != undefined) {
	        				html += `			\${v.qstnCts}`;
	        				}
	        				html += `		</p>`;
	        				html += `		<div class="line-sortable-box">`;
	        				html += `			<div class="account-list">`;
		        				stareAnsrMatchArray.forEach(function(vv, ii) {
		        					var asnrCnt 		= 0;
		        					var loop_match_flag = false;
		        					emplOdrArray.forEach(function(vvv, iii) {
		        						if(!loop_match_flag) {
		        							if(emplMatchArray[vvv-1] != null && emplMatchArray[vvv-1] != "undefined" && emplMatchArray[vvv-1] != "") {
		        								asnrCnt += 1;
		        							}
		        							if((ii+1) == vvv) {
		        								if(stareAnsrOdrStr == "") {
		        									stareAnsrOdrStr = stareAnsrMatchArray[asnrCnt-1];
		        								} else {
		        									stareAnsrOdrStr += "," + stareAnsrMatchArray[asnrCnt-1];
		        								}
		        								loop_match_flag = true;
		        							}
		        						}
		        					});
		        				});
		        				var stareAnsrOdrArray;
	        					if(stareAnsrOdrStr == undefined) {
	        						stareAnsrOdrArray = [];
	        					} else {
	        						stareAnsrOdrArray = stareAnsrOdrStr.split(",");
	        					}
		        				for(var j = 1; j <= v.emplCnt; j++) {
		        					var qstnNo = v.qstnNo;
	        				html += `				<div class="line-box num\${j<10?'0':''}\${j}" id="emplLi_\${qstnNo}_\${j}">`;
	        				html += `					<div class="question" id="emplMatch_\${qstnNo}_\${j}" name="emplMatch_\${qstnNo}_\${j}"><span>\${emplMatchArray[j-1]}</span></div>`;
	        				html += `					<div class="slot" id="rqtAnsrMatch_\${qstnNo}_\${j}" name="rqtAnsrMatch_\${qstnNo}_\${j}">\${stareAnsrOdrArray[j-1] == undefined ? `` : `\${stareAnsrOdrArray[j-1]}`}</div>`;
	        				html += `				</div>`;
		        				}
	        				html += `			</div>`;
	        				html += `		</div>`;
	        				html += `	</div>`;
	        				}
	        				html += `	<div class="content">`;
	        				html += `		<div class="flex gap16 align-items-center mb20">`;
	        				html += `			<div class="flex flex1">`;
	        				html += `				<label class="ui label flex-none m0"><spring:message code="exam.label.answer" /></label>`;/* 정답 */
	        				if(v.qstnTypeCd == 'CHOICE' || v.qstnTypeCd == 'MULTICHOICE') {
	        				html += `				<input type="text" class="flex1" value="\${v.rgtAnsr1 }" readonly="readonly" />`;
	        				} else if(v.qstnTypeCd == 'SHORT') {
	        					if(v.multiRgtChoiceYn == "Y") {
	        						var ansrCnt = 5;
	        						for(var j = 1; j <= 5; j++) {
	        							var ansr = "rgtAnsr"+j;
	        							if(v[ansr] != "" && v[ansr] != undefined && v[ansr] != null) ansrCnt = j;
	        						}
	        						for(var j = 1; j <= ansrCnt; j++) {
	        							var ansr = "rgtAnsr"+j;
	        				html += `				<input type="text" class="flex1" value="\${v[ansr] }" readonly="readonly" />`;
	        						}
	        					} else {
	        				html += `				<input type="text" class="flex1" value="\${v.rgtAnsr1 }" readonly="readonly" />`;
	        					}
	        				} else if(v.qstnTypeCd == 'DESCRIBE') {
	        					var rgtAnsr1 = v.rgtAnsr1 || "";
	        					var rgtAnsrDescribeArray = rgtAnsr1.split("|");
	        					for(var j = 1; j <= rgtAnsrDescribeArray.length; j++) {
	        						if(j != 1) {
	        				html += `	,`;
	        						}
	        				html += `				<input type="text" class="flex1" value="\${rgtAnsrDescribeArray[j-1] }" readonly="readonly" />`;
	        					}
	        				} else if(v.qstnTypeCd == 'OX') {
	        					if(v.rgtAnsr1 == '1') {
	        				html += `				<input type="text" class="flex1" value="O" readonly="readonly" />`;
	        					} else if(v.rgtAnsr1 == '2') {
	        				html += `				<input type="text" class="flex1" value="X" readonly="readonly" />`;
	        					}
	        				} else if(v.qstnTypeCd == 'MATCH') {
	        					var rgtAnsr1 		  = v.rgtAnsr1;
	        					var rgtAnsrMatchArray = rgtAnsr1.split("|");
	        					var emplMatchNumStr   = "A@#B@#C@#D@#E@#F@#G@#H@#I@#J";
	        					var emplMatchNumArray = emplMatchNumStr.split("@#");
	        					for(var j = 1; j <= v.emplCnt; j++) {
	        				html += `				<input type="text" class="flex1" value="\${emplMatchNumArray[j-1]}-\${rgtAnsrMatchArray[j-1]}" readonly="readonly" />`;
	        					}
	        				}
	        				html += `			</div>`;
	        				html += `			<div class="flex">`;
	        				html += `				<label class="ui label flex-none m0"><spring:message code="exam.label.gain.point" /></label>`;/* 배점 */
	        				html += `				<input type="text" class="w80" value="\${v.qstnScore }" readonly="readonly">`;
	        				html += `			</div>`;
	        				html += `			<div class="flex align-items-center gap4"><spring:message code="exam.label.score" /> <input class="w50 score" value="\${v.getScore == null ? 0 : v.getScore }"> <spring:message code="exam.label.score.point" /></div>`;/* 점수 *//* 점 */
	        				html += `		</div>`;
	        				html += `	</div>`;
	        				html += `</div>`;
	        			});
	        		}
	        		$("#examPreviewQstnList_"+num).append(html);
	        		watermarkedDataURL("${examVo.rgtrId}"+"_"+"${examVo.regNm}",$("div.ui.card"));
					if('Y' == lastYn){
						quizStarePaperPrint();
						if(${empty vo.searchMenu}) {
							window.parent.closeModal();
						}
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
			$("#quizStarePaperModal").print({
				globalStyles : true,
				stylesheet : null,
				rejectWindow : true,
				noPrintSelector : ".no-print",
				append : null,
				prepend : null
			});
		}
	
		// 워터마크
		function watermarkedDataURL (text,watermarkDiv) {
			//var watermarkDiv = $("#quizStarePaperModal");		//워터마크 적용될 영역
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
        <form id="examStarePaperPrintForm" name="examStarePaperPrintForm" method="POST">
			<div id="wrap">
				<div id="quizStarePaperModal">
				<c:forEach var="items" items="${resultList}" varStatus="status">
					<div class="ui form">
						<div class="field">
							<div class="ui info message">
								<div class="header"><c:if test="${empty vo.searchMenu}">${status.count}. </c:if>'${items.userNm}'<spring:message code="exam.label.std.paper" /></div><!-- 의 시험지 -->
							</div>
						</div>
						<div class="ui divider"></div>
						<div id="examPreviewQstnList_${status.count}" class="qstnList"></div>
						<c:choose>
							<c:when test="${status.last}">
								<script type="text/javascript">quizStarePaperList('${status.count}','${items.stdNo}','Y');</script>
							</c:when>
							<c:otherwise>
								<script type="text/javascript">quizStarePaperList('${status.count}','${items.stdNo}');</script>
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
