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
		$(document).ready(function() {
			hideLoading();
		});
		
		// 결과 통계보기 버튼
		function viewStatus(obj, examQstnSn, qstnTypeCd) {
			if($(obj).hasClass("on")) {
				$(obj).next("div.resultStatus").css("display", "none");
			} else {
				var url  = "/quiz/viewQuizQstnBarChart.do";
				var data = {
					"examCd" 	 : "${vo.examCd}",
					"examQstnSn" : examQstnSn,
				};
				
				showLoading();
				$.ajax({
				    url 	 : url,
				    type 	 : "get",
				    data	 : data,
				    dataType : "json"
				}).done(function(data) {
					hideLoading();
					if (data.result > 0) {
						if(data.returnList != null) {
							var emplMap 		   = JSON.parse(data.returnList[0].emplMap);
							var labelsArray 	   = new Array();
							var emplStareAnsrArray = new Array();
							var oxLabel 		   = ['O', 'X'];
							if(Object.keys(emplMap).length > 0){
								for (var i = 0; i < Object.keys(emplMap).length; i++) {
									if(qstnTypeCd == "CHOICE" || qstnTypeCd == "MULTICHOICE") {
										labelsArray.push(i+1);
									} else if(qstnTypeCd == "OX") {
										labelsArray.push(oxLabel[i]);
									} else {
										labelsArray.push(Object.keys(emplMap)[i].toUpperCase());
									}
								}
								emplStareAnsrArray = Object.values(emplMap);
							}
							
							var backgroundColorArray = JSON.parse(data.returnList[0].backgroundColorArray);
							
							var ctx = document.getElementById(examQstnSn+"_barChart");
							var myChart = new Chart(ctx, {
								type: 'horizontalBar',
								data: {
									labels: labelsArray,
									datasets: [{
										data: emplStareAnsrArray,
										backgroundColor: backgroundColorArray,
										borderWidth: 0
									}]
								},
								options: {
									events: false,
									showTooltips: false,
									title: {
									  display: true,
									  text: "<spring:message code='exam.label.dev.qstn.status' /> (%)",/* 보기 분포 현황 */
									  fontSize: 14,
									  fontColor: "#666",
									},
									animation: {
									duration: 1000,
									onComplete: function () {
										var ctx = this.chart.ctx;
										ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
										ctx.fillStyle = this.chart.config.options.defaultFontColor;
										ctx.textAlign = 'center';
										ctx.textBaseline = 'bottom';
										this.data.datasets.forEach(function (dataset) {
											for (var i = 0; i < dataset.data.length; i++) {
												var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
												ctx.fillStyle = '#fff'; // label color
												ctx.fillText(dataset.data[i] + '%', model.x, model.y + 8);
											}
										});
									}},
									scales: {
										yAxes: [{
											barPercentage: 0.6,
											scaleLabel: {
												display: true
											}
										}],
										xAxes: [{
											ticks: {
												min: 0,
												max: 100,
												stepSize: 20,
												callback: function(value){return value+ "%"}
											}
										}]
									},
									legend: {
										display: false
									}
								}
							});
						}
				    } else {
				     	alert(data.message);
				    }
				}).fail(function() {
					hideLoading();
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
				
				var url  = "/quiz/viewQuizQstnPieChart.do";
				var data = {
					"examCd" 	 : "${vo.examCd}",
					"examQstnSn" : examQstnSn,
				};
				
				showLoading();
				$.ajax({
				    url 	 : url,
				    type 	 : "get",
				    data	 : data,
				    dataType : "json"
				}).done(function(data) {
					hideLoading();
					var emplMap 		   = JSON.parse(data.returnList[0].emplMap);
					var labelsArray 	   = new Array();
					var emplStareAnsrArray = new Array();
					if(Object.keys(emplMap).length > 0){
						for (var i = 0; i < Object.keys(emplMap).length; i++) {
							labelsArray.push(Object.keys(emplMap)[i].toUpperCase());
						}
						emplStareAnsrArray = Object.values(emplMap);
					}
					
					var backgroundColorArray = JSON.parse(data.returnList[0].backgroundColorArray);
					
					var ctx = document.getElementById(examQstnSn+"_pieChart");
					var myChart = new Chart(ctx, {
						type: 'pie',
						data: {
						  labels: labelsArray,
						  datasets: [{
							backgroundColor: backgroundColorArray,
							borderWidth:1,
							data: emplStareAnsrArray
						  }]
						},
						options: {
							pieceLabel: {
							  render: function (args) {
								return args.percentage + '%';
							  },
							  fontColor : '#fff'
							},
							title: {
							  display: true,
							  text: "<spring:message code='exam.label.answer.status' /> (%)",/* 정답현황 */
							  fontSize: 14,
							  fontColor: "#666",
							},
							legend: {
								display: true,
								position: 'bottom',
								labels: {
									boxWidth: 12,
									generateLabels: function(chart) {
										var data = chart.data;
										if (data.labels.length && data.datasets.length) {
											return data.labels.map(function(label, i) {
												var meta = chart.getDatasetMeta(0);
												var ds = data.datasets[0];
												var arc = meta.data[i];
												var custom = arc && arc.custom || {};
												var getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
												var arcOpts = chart.options.elements.arc;
												var fill = custom.backgroundColor ? custom.backgroundColor : getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
												var stroke = custom.borderColor ? custom.borderColor : getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
												var bw = custom.borderWidth ? custom.borderWidth : getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
												var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];

												return {
													text: label + " : " + value + "<spring:message code='exam.label.nm' />",/* 명 */
													fillStyle: fill,
													strokeStyle: stroke,
													lineWidth: bw,
													hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
													index: i
												};
											});
										} else {
											return [];
										}
									}
								}
							}
						}
					});
					$(obj).next("div.resultStatus").css("display", "flex");
				}).fail(function() {
					hideLoading();
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
			$(obj).toggleClass("on");
			$(obj).children("i").toggleClass("up down");
		}
		
		// 점수 저장
		function saveScore(examQstnSn) {
			var score = $("div.ui.card[data-examQstnSn="+examQstnSn+"] .score").val();
			var maxScore = $("div.ui.card[data-examQstnSn="+examQstnSn+"] .score").attr("data-maxScore");
			if(score == "") {
				alert("<spring:message code='exam.alert.input.score' />");/* 점수를 입력하세요. */
				return false;
			} else if(parseFloat(score) > parseFloat(maxScore)) {
				alert("<spring:message code='exam.alert.max.point.out' />");/* 점수가 최대 배점을 초과하였습니다. */
				return false;
			}
			var stdScores = examQstnSn + "|" + score;
			var url  = "/quiz/updateQstnPaperScore.do";
			var data = {
				"examCd" 	: "${vo.examCd}",
				"stdNo"  	: "${vo.stdNo}",
				"stdScores" : stdScores
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
			    		alert("<spring:message code='exam.alert.save.score' />");/* 점수 저장이 완료되었습니다. */
			    		window.parent.qstnScoreEdit();
			    		location.reload();
			        } else {
			         	alert(data.message);
			        }
		    }, function(xhr, status, error) {
		    	alert("<spring:message code='exam.error.qstn.score.insert' />");/* 점수 저장 중 에러가 발생하였습니다. */
		    });
		}
		
		// 이전, 다음 평가정보
		function chgUserEval(type) {
			showLoading();
			var stdNo 	  = "";
			var stdNoList = [];
			<c:forEach var="list" items="${stdList}" varStatus="status">
				stdNoList.push("${list.stdNo}");
			</c:forEach>
			
			for(var i = 0; i < stdNoList.length; i++) {
				if(stdNoList[i] == "${vo.stdNo}") {
					if(type == "prev") {
						if(i == 0) {
							stdNo = stdNoList[stdNoList.length-1];
						} else {
							stdNo = stdNoList[i-1];
						}
					} else if(type == "next") {
						if(i == stdNoList.length-1) {
							stdNo = stdNoList[0];
						} else {
							stdNo = stdNoList[i+1];
						}
					}
				}
			}
			
			$("#evalStdNo").val(stdNo);
	        $("#quizEvalForm").attr("action", "/quiz/quizQstnEvalPop.do");
	        $("#quizEvalForm").submit();
		}
		
		// 포커스 이동
		function focusMove(qstnNo, subNo) {
			var locate = parseInt($("#"+qstnNo+"_"+subNo).offset().top);
			$(window.parent.document.getElementsByClassName("modal fade in")).scrollTop(locate);
		}
		
		// 시험지 인쇄
		function quizStarePaperPrint() {
			$("#quizPrintForm").attr("target", "quizPopIfm");
	    	$("#quizPrintForm").attr("action", "/quiz/quizStarePaperListPrintPop.do");
	    	$("#quizPrintForm").submit();
	    	$('#quizPop').modal('show');
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
		<form name="quizEvalForm" id="quizEvalForm" method="POST">
			<input type="hidden" name="examCd" 		value="${vo.examCd }" 	   id="evalExamCd" />
			<input type="hidden" name="stdNo" 		value=""				   id="evalStdNo" />
			<input type="hidden" name="searchKey" 	value="${vo.searchKey }" />
			<input type="hidden" name="searchValue" value="${vo.searchValue }" />
			<input type="hidden" name="crsCreCd"	value="${creCrsVO.crsCreCd }" />
		</form>
		<form name="quizPrintForm" id="quizPrintForm" method="POST">
	        <input type="hidden" name="examCd" 	   value="${vo.examCd}"/>
	        <input type="hidden" name="stdNos" 	   value="${stareVO.stdNo }" />
	        <input type="hidden" name="searchMenu" value="PRINT" />
	    </form>
        <div id="wrap">
        	<div class="ui message info-item-box gap4">
		        <div class="page-title">${creCrsVO.crsCreNm } (${creCrsVO.declsNo }<spring:message code="exam.label.decls" /><!-- 반 -->)</div>
		        <div class="mla fcBlue">
		            <b>${stareVO.deptNm } ${stareVO.userId } ${stareVO.userNm }
		            	<c:if test="${menuType eq 'PROFESSOR' || (vo.scoreOpenYn eq 'Y' && stareVO.evalYn eq 'Y') }">
		            		<span class="f150">${stareVO.totGetScore }<spring:message code="exam.label.score.point" /></span><!-- 점 -->
		            	</c:if>
		            </b>
		        </div>
		        <div class="option-content">
		            <c:if test="${menuType eq 'PROFESSOR' }">
				        <div class="mla">
				        	<a href="javascript:chgUserEval('prev')" class="ui small basic button"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
				        	<a href="javascript:chgUserEval('next')" class="ui small basic button"><spring:message code="exam.label.next" /></a><!-- 다음 -->
				        </div>
			        </c:if>
		        </div>
		    </div>
		    
		    <div class="qstnInfo">
			    <div class="option-content">
			        <p class="sec_head">${vo.examTitle }</p>
			        <c:if test="${menuType eq 'PROFESSOR' }">
			            <div class="mla">
			            	<a href="javascript:quizStarePaperPrint()" class="ui blue button"><spring:message code="exam.button.print.paper" /></a><!-- 시험지 인쇄 -->
			            	<a href="javascript:window.parent.closeModal()" class="ui grey button"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
			            </div>
		            </c:if>
			    </div>
		        <c:if test="${vo.examSubmitYn ne 'Y' && vo.examSubmitYn ne 'M' }">
		        	<div class="ui small error message">
		                <i class="info circle icon"></i>
		                <spring:message code="exam.alert.already.qstn.submit.n" /><!-- 문제 출제가 완료되지 않았습니다. -->
		            </div>
		        </c:if>
			    <ul class="num-chk" aria-label="문제로 바로가기 버튼">
			    	<c:forEach var="item" items="${paperList }">
		        		<li ${not empty item.stareAnsr ? 'class="correct"' : '' }><a href="javascript:focusMove('${item.qstnNo }', '${item.subNo }')">${item.qstnNo }</a></li>
		        	</c:forEach>
			    </ul>
		    </div>
            
            <div class="ui form qstnList mt10">
            	<c:forEach var="item" items="${paperList }" varStatus="varStatus">
            		<div class="ui card wmax qstnDiv" id="${item.qstnNo }_${item.subNo}" data-examQstnSn="${item.examQstnSn }">
            			<div class="fields content header2">
			                <div class="field wf100 flex-item">
			                    <span><spring:message code="exam.label.qstn" /><!-- 문제 --> ${item.qstnNo }</span>
			                    <c:if test="${item.qstnTypeCd eq 'MATCH' }">(<spring:message code="exam.label.qstn.match.info" /><!-- 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. -->)</c:if>
		            			<div class="alt_icon overflow-hidden mla">
		            				<c:set var="imgSrc" value="/webdoc/img/answer.png" />
		            				<c:if test="${item.ansrYn eq 'Y' }">
		            					<c:set var="imgSrc" value="/webdoc/img/quiz_true.gif" />
		            				</c:if>
		            				<c:if test="${(menuType eq 'PROFESSOR' || vo.scoreOpenYn eq 'Y') && quizCompleteYn eq 'Y'}">
			            				<img class="list ul icon w30 color" src="${imgSrc }" alt="">
		            				</c:if>
			                	</div>
			                </div>
            			</div>
		                <div class="content">
	                    	<p>${item.qstnCts}</p>
		                    <c:if test="${item.qstnTypeCd eq 'CHOICE' || item.qstnTypeCd eq 'MULTICHOICE' }">
								<div class="ui divider"></div>
								<c:set var="emplStr" 		 value="${item.empl1}@#${item.empl2}@#${item.empl3}@#${item.empl4}@#${item.empl5}@#${item.empl6}@#${item.empl7}@#${item.empl8}@#${item.empl9}@#${item.empl10}"/>
								<c:set var="emplArray" 		 value="${fn:split(emplStr,'@#')}" />
								<c:set var="rgtAnsrArray"    value="${fn:split(item.rgtAnsr1,',')}" />
								<c:set var="stareAnsrArray"  value="${fn:split(item.stareAnsr,',')}" />
								<c:set var="emplOdrArray" 	 value="${fn:split(item.examOdr,',')}" />
								<c:set var="stareAnsrOdrStr" value=""/>
								<c:set var="odrItem"	 value="" />
								
								<c:forEach var="odr" items="${emplOdrArray }">
									<c:if test="${odr <= item.emplCnt }">
										<c:choose>
											<c:when test="${odrItem == ''}">
												<c:set var="odrItem" value="${odr}"/>
											</c:when>
											<c:otherwise>
												<c:set var="odrItem" value="${odrItem},${odr}"/>
											</c:otherwise>
										</c:choose>
									</c:if>
								</c:forEach>
								<c:set var="odrItemArray" value="${fn:split(odrItem, ',') }" />
								
								<c:forEach var="stareAnsrItem" items="${stareAnsrArray}" varStatus="stareStatus">
									<fmt:formatNumber var="cnt" value="0" />
									<fmt:parseNumber var="asnrCnt" integerOnly="true" value="${cnt}" />
									<c:set var="loop_choice_flag" value="false" />
									<c:forEach var="emplItem" items="${emplOdrArray}" >
										<c:if test="${not loop_choice_flag }">
											<c:if test="${emplArray[emplItem-1] != null}">
												<fmt:parseNumber var="asnrCnt" integerOnly="true" value="${asnrCnt+1}" />
											</c:if>
											<c:if test="${stareAnsrItem == asnrCnt}">
												<c:choose>
													<c:when test="${stareAnsrOdrStr == ''}">
														<c:set var="stareAnsrOdrStr" value="${emplItem}"/>
													</c:when>
													<c:otherwise>
														<c:set var="stareAnsrOdrStr" value="${stareAnsrOdrStr},${emplItem}"/>
													</c:otherwise>
												</c:choose>
												<c:set var="loop_choice_flag" value="true" />
											</c:if>
											<%-- 랜덤보기문항 : ${item.examOdr}</br>
											답안포문현상태값 : ${stareAnsrItem }</br>
											답안포문카운트 : ${stareStatus.count}</br>
											랜덤보기순서상태값 : ${item }</br>
											랜덤보기순서카운트 : ${asnrCnt}</br>
											답안포문현상태값 = 랜덤보기순서카운트 : ${stareAnsrItem} = ${asnrCnt}</br>
											답안표기 : ${stareAnsrOdrStr }</br> 
											</br> --%>
										</c:if>
									</c:forEach>
								</c:forEach>
								<c:set var="stareAnsrOdrArray" value="${fn:split(stareAnsrOdrStr,',')}" />
								
								<c:forEach var="emplItem" step="1" begin="1" end="${item.emplCnt}">
									<c:set var="qstnNo" value="${item.qstnNo}"/>
									<c:set var="odrItem" value="${odrItemArray[emplItem-1] }" />
									<div id="emplLi_${qstnNo}_${emplItem}" class="field 
										<c:if test="${menuType eq 'PROFESSOR' || vo.scoreOpenYn eq 'Y' }">
											<c:forEach var="ansritem" items="${rgtAnsrArray}"><c:if test="${ansritem eq odrItem and quizCompleteYn eq 'Y'}">correct</c:if></c:forEach>
										</c:if>
									">
										<div class="ui read-only checkbox">
											<input type="checkbox" name="rgtAnsr_CHOICE_${qstnNo}" id="rgtAnsr_${qstnNo}_${emplItem}" <c:forEach var="stareAnsrItem" items="${stareAnsrOdrArray}"> <c:if test="${stareAnsrItem eq odrItem}">checked</c:if></c:forEach>>
											<label for="rgtAnsr_${qstnNo}_${emplItem}" class="question ${item.qstnTypeCd eq 'MULTICHOICE' ? 'multi' : '' } empl" data-value="${emplItem }">${emplArray[odrItem-1]}</label>
										</div>
									</div>
								</c:forEach>
		                    </c:if>
		                    <c:if test="${item.qstnTypeCd eq 'SHORT' }">
		                    	<div class="equal width fields">
		                    		<c:set var="ansrCnt" value="5" />
		                    		<c:forEach var="idx" begin="1" end="5" step="1">
		                    			<c:set var="rgtAnsr" value="rgtAnsr${idx }" />
		                    			<c:if test="${not empty item[rgtAnsr] }"><c:set var="ansrCnt" value="${idx }" /></c:if>
		                    		</c:forEach>
			                    	<c:forEach var="ansrItem" begin="1" end="${ansrCnt }" step="1" varStatus="anStatus">
			                    		<div class="field">
			                    			<label for="shot_${varStatus.count}_${anStatus.count}" class="hide">answer</label>
			                    			<input id="shot_${varStatus.count}_${anStatus.count}" type="text" value="${fn:split(item.stareAnsr, '|')[ansrItem-1] }" readonly="readonly" />
			                    		</div>
			                    	</c:forEach>
		                    	</div>
		                    </c:if>
		                    <c:if test="${item.qstnTypeCd eq 'DESCRIBE' }">
		                    	<textarea rows="5" cols="20" readonly="readonly">${item.stareAnsr }</textarea>
		                    </c:if>
		                    <c:if test="${item.qstnTypeCd eq 'OX' }">
		                        <div class="checkImg">
		                            <input id="oxChk${item.examQstnSn}_true" type="radio" name="oxChk${item.examQstnSn}" disabled="disabled"
		                                value="1" ${item.stareAnsr == '1'?'checked':''} onChange="changeOxQstnAnswer(this)">
		                            <label class="imgChk true" for="oxChk${item.examQstnSn}_true"></label>
		                            <input id="oxChk${item.examQstnSn}_false" type="radio" name="oxChk${item.examQstnSn}" disabled="disabled"
		                                value="2" ${item.stareAnsr == '2'?'checked':''} onChange="changeOxQstnAnswer(this)">
		                            <label class="imgChk false" for="oxChk${item.examQstnSn}_false"></label>
		                        </div>
		                    </c:if>
		                    <c:if test="${item.qstnTypeCd eq 'MATCH' }">
								<div class="ui divider"></div>
								<div class="line-sortable-box">
									<div class="account-list">
										<c:set var="emplMatchStr" 		 value="${item.empl1}@#${item.empl2}@#${item.empl3}@#${item.empl4}@#${item.empl5}@#${item.empl6}@#${item.empl7}@#${item.empl8}@#${item.empl9}@#${item.empl10}"/>
										<c:set var="emplMatchArray" 	 value="${fn:split(emplMatchStr,'@#')}" />
										<c:set var="stareAnsrMatchArray" value="${fn:split(item.stareAnsr,'|')}" />
										<c:set var="emplOdrArray" 		 value="${fn:split(item.examOdr,',')}" />
										<c:set var="stareAnsrOdrStr" 	 value=""/>
										<c:forEach var="stareAnsrItem" items="${stareAnsrMatchArray}" varStatus="stareStatus">
											<fmt:formatNumber var="cnt" value="0" />
											<fmt:parseNumber var="asnrCnt" integerOnly="true" value="${cnt}" />
											<c:set var="loop_match_flag" value="false" />
											<c:forEach var="emplItem" items="${emplOdrArray}">
												<c:if test="${not loop_match_flag }">
													<c:if test="${emplMatchArray[emplItem-1] != null}">
														<fmt:parseNumber var="asnrCnt" integerOnly="true" value="${asnrCnt+1}" />
													</c:if>
													<c:if test="${stareStatus.count == emplItem}">
														<c:choose>
															<c:when test="${stareAnsrOdrStr == ''}">
																<c:set var="stareAnsrOdrStr" value="${stareAnsrMatchArray[asnrCnt-1]}"/>
															</c:when>
															<c:otherwise>
																<c:set var="stareAnsrOdrStr" value="${stareAnsrOdrStr},${stareAnsrMatchArray[asnrCnt-1]}"/>
															</c:otherwise>
														</c:choose>
														<c:set var="loop_match_flag" value="true" />
														<%-- 랜덤보기문항 : ${item.examOdr}</br>
														답안포문현상태값 : ${stareAnsrItem }</br>
														답안포문카운트 : ${stareStatus.count}</br>
														랜덤보기순서상태값 : ${item }</br>
														랜덤보기순서카운트 : ${asnrCnt}</br>
														답안포문카운트 = 랜덤보기순서카운트 : ${stareStatus.count} = ${asnrCnt}</br>
														답안표기 : ${stareAnsrOdrStr }</br>
														</br> --%>
													</c:if>
												</c:if>
											</c:forEach>
										</c:forEach>
										<c:set var="stareAnsrOdrArray" value="${fn:split(stareAnsrOdrStr,',')}" />
										<c:forEach var="emplItem" step="1" begin="1" end="${item.emplCnt}">
											<c:set var="qstnNo" value="${item.qstnNo}"/>
											<div class="line-box num0${emplItem}" id="emplLi_${qstnNo}_${emplItem}">
										 		<div class="question" id="emplMatch_${qstnNo}_${emplItem}" name="emplMatch_${qstnNo}_${emplItem}"><span>${emplMatchArray[emplItem-1]}</span></div>
												<div class="slot" id="rqtAnsrMatch_${qstnNo}_${emplItem}" name="rqtAnsrMatch_${qstnNo}_${emplItem}">${stareAnsrOdrArray[emplItem-1]}</div>
											</div>
										</c:forEach>
									</div>
								</div>
		                    </c:if>
	                    </div>
	                    <c:if test="${(menuType eq 'PROFESSOR' || vo.scoreOpenYn eq 'Y') && quizCompleteYn eq 'Y'}">
		                    <div class="content">
		                    	<div class="flex gap16 align-items-center mb20">
				                    <div class="flex flex1">
				                        <label for="anschk_${varStatus.count}" class="ui label flex-none m0"><spring:message code="exam.label.answer" /><!-- 정답 --></label>
				                        <c:if test="${item.qstnTypeCd eq 'CHOICE' || item.qstnTypeCd eq 'MULTICHOICE' }">
				                        	<c:set var="emplOdrArray" 	 value="${fn:split(item.examOdr,',')}" />
											<c:set var="odrItem"	 	 value="" />
											<c:set var="rgtItem"	 	 value="" />
											<c:forEach var="odr" items="${emplOdrArray }">
												<c:if test="${odr <= item.emplCnt }">
													<c:choose>
														<c:when test="${odrItem == ''}">
															<c:set var="odrItem" value="${odr}"/>
														</c:when>
														<c:otherwise>
															<c:set var="odrItem" value="${odrItem},${odr}"/>
														</c:otherwise>
													</c:choose>
												</c:if>
											</c:forEach>
											<c:set var="odrItemArray" value="${fn:split(odrItem, ',') }" />
											<c:forEach var="odrArr" items="${odrItemArray }" varStatus="status">
												<c:forEach var="rgtArr" items="${fn:split(item.rgtAnsr1, ',') }">
													<c:if test="${rgtArr eq odrArr }">
														<c:choose>
															<c:when test="${rgtItem == '' }">
																<c:set var="rgtItem" value="${status.count }" />
															</c:when>
															<c:otherwise>
																<c:set var="rgtItem" value="${rgtItem },${status.count }" />
															</c:otherwise>
														</c:choose>
													</c:if>
												</c:forEach>
											</c:forEach>
				                        	<input id="anschk_${varStatus.count}" type="text" class="flex1" value="${rgtItem }" readonly="readonly" />
		                    			</c:if>
		                    			<c:if test="${item.qstnTypeCd eq 'SHORT' }">
		                    				<c:choose>
												<c:when test="${item.multiRgtChoiceYn eq 'Y' }">
													<c:set var="ansrCnt" value="5" />
													<c:forEach var="idx" begin="1" end="5" step="1">
														<c:set var="rgtAnsr" value="rgtAnsr${idx }" />
														<c:if test="${not empty item[rgtAnsr] }"><c:set var="ansrCnt" value="${idx }" /></c:if>
													</c:forEach>
													<c:forEach var="rgtItem" step="1" begin="1" end="${ansrCnt }" varStatus="shStat">
														<c:set var="rgtAnsr" value="rgtAnsr${rgtItem }" />
														<label for="short_${varStatus.count}_${shStat.count}" class="hide">short</label>
														<input id="short_${varStatus.count}_${shStat.count}" type="text" class="flex1" value="${item[rgtAnsr] }" readonly="readonly" />
													</c:forEach>
												</c:when>
												<c:otherwise>
													<input id="anschk_${varStatus.count}" type="text" class="flex1" value="${item.rgtAnsr1 }" readonly="readonly" />
												</c:otherwise>
											</c:choose>
		                    			</c:if>
		                    			<c:if test="${item.qstnTypeCd eq 'DESCRIBE' }">
		                    				<c:set var="rgtAnsrDescribeArray" value="${fn:split(item.rgtAnsr1,'|')}" />
											<c:forEach var="rgtItem" step="1" begin="1" end="${fn:length(rgtAnsrDescribeArray)}">
												<c:if test="${rgtItem != 1}">,</c:if>
												<label for="desc_${varStatus.count}" class="hide">describe</label>
												<input id="desc_${varStatus.count}" type="text" class="flex1" value="${rgtAnsrDescribeArray[rgtItem-1] }" readonly="readonly" />
											</c:forEach>
		                    			</c:if>
		                    			<c:if test="${item.qstnTypeCd eq 'OX' }">
		                    				<c:choose>
												<c:when test="${item.rgtAnsr1 eq '1'}"><input id="anschk_${varStatus.count}" type="text" class="flex1" value="O" readonly="readonly" /></c:when>
												<c:when test="${item.rgtAnsr1 eq '2'}"><input id="anschk_${varStatus.count}" type="text" class="flex1" value="X" readonly="readonly" /></c:when>
											</c:choose>
		                    			</c:if>
		                    			<c:if test="${item.qstnTypeCd eq 'MATCH' }">
		                    				<c:set var="rgtAnsrMatchArray" value="${fn:split(item.rgtAnsr1,'|')}" />
											<c:set var="emplMatchNumStr"   value="A@#B@#C@#D@#E@#F@#G@#H@#I@#J" />
											<c:set var="emplMatchNumArray" value="${fn:split(emplMatchNumStr,'@#')}" />
											<c:forEach var="emplItem" step="1" begin="1" end="${item.emplCnt}" varStatus="mstat">
												<label for="mat_${varStatus.count}_${mstat.count}" class="hide">match</label>
												<input id="mat_${varStatus.count}_${mstat.count}" type="text" class="flex1" value="${emplMatchNumArray[emplItem-1]}-${rgtAnsrMatchArray[emplItem-1]}" readonly="readonly" />
											</c:forEach>
		                    			</c:if>
				                    </div>
				                    <c:if test="${menuType eq 'PROFESSOR' || vo.scoreOpenYn eq 'Y' }">
					                    <div class="flex">
					                    	<label for="scochk_${varStatus.count}" class="hide">score</label>
					                        <input id="scochk_${varStatus.count}" type="text" class="w80" value="${item.qstnScore }" readonly="readonly">
					                    </div>
				                    </c:if>
				                    <c:if test="${menuType eq 'PROFESSOR' }">
					                    <div class="flex align-items-center gap4"><spring:message code="exam.label.score" /><!-- 점수 --> <input class="w50 score" data-maxscore="${item.qstnScore }" style="height:22.5px;" type="number" step="0.1" value="${empty item.getScore ? 0 : item.getScore }"> <spring:message code="exam.label.score.point" /><!-- 점 --></div>
					                    <div class="flex align-items-center">
					                        <a href="javascript:saveScore('${item.examQstnSn }')" class="ui blue small button"><spring:message code="exam.label.score" /><!-- 점수 --> <spring:message code="exam.button.save" /><!-- 저장 --></a>
					                    </div>
				                    </c:if>
				                </div>
		                    	<button class="ui basic small button ml_auto" onclick="viewStatus(this, '${item.examQstnSn}', '${item.qstnTypeCd }')"><spring:message code="exam.label.view.result.status" /> <i class="angle up icon tr"></i></button><!-- 결과 통계 보기 -->
		                    	<div class="ui stackable equal width grid resultStatus" style="display:none;">
		                    		<div class="column">
		                                <canvas id="${item.examQstnSn }_barChart" height="130"></canvas>
		                            </div>
		                            <div class="column">
		                                <canvas id="${item.examQstnSn }_pieChart" height="130"></canvas>
		                            </div>
		                        </div>
		                    </div>
	                    </c:if>
		            </div>
            	</c:forEach>
            </div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
