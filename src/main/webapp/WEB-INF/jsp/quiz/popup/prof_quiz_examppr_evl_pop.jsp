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
		function viewStatus(obj, qstnId, exampprId, qstnRspnsTycd) {
			if($(obj).hasClass("on")) {
				$(obj).next("div.resultStatus").css("display", "none");
			} else {
				var url  = "/quiz/quizQstnDistributionBarChartAjax.do";
				var data = {
					"examDtlId" : "${vo.examDtlVO.examDtlId }",
					"qstnId" 	: qstnId,
					"exampprId"	: exampprId
				};

				showLoading();
				$.ajax({
				    url 	 : url,
				    async	 : false,
				    type 	 : "POST",
				    data	 : JSON.stringify(data),
				    dataType : "json",
				    contentType: "application/json; charset=UTF-8"
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
									if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
										labelsArray.push(i+1);
									} else if(qstnRspnsTycd == "OX_CHC") {
										labelsArray.push(oxLabel[i]);
									} else {
										labelsArray.push(Object.keys(emplMap)[i].toUpperCase());
									}
								}
								emplStareAnsrArray = Object.values(emplMap);
							}

							var backgroundColorArray = JSON.parse(data.returnList[0].backgroundColorArray);

							var ctx = document.getElementById(qstnId+"_barChart");
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

				var url  = "/quiz/quizQstnCransStatusPieChartAjax.do";
				var data = {
					"examDtlId" : "${vo.examDtlVO.examDtlId }",
					"qstnId" 	: qstnId,
					"exampprId"	: exampprId
				};

				showLoading();
				$.ajax({
				    url 	 : url,
				    async	 : false,
				    type 	 : "POST",
				    data	 : JSON.stringify(data),
				    dataType : "json",
				    contentType: "application/json; charset=UTF-8"
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

					var ctx = document.getElementById(qstnId+"_pieChart");
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
		function saveScore(userId) {
			var scrList = [];	// 점수 목록

			const qstn = document.querySelectorAll('div.ui.card.qstnDiv');

			qstn.forEach(item => {
				var score = item.querySelector(".score").value
				var maxScore = item.querySelector(".score").dataset.maxscore;
				if(score == "") score = "0";
				if(parseInt(score) > parseInt(maxScore)) score = maxScore;
				var scr = {
					  userId			: "${quizExamnee.userId}"
					, exampprId			: item.id
					, qstnId			: item.dataset.qstnid
					, tkexamAnswShtId	: item.dataset.tkexamanswshtid
					, scr				: score
				};

				scrList.push(scr);
			});

			$.ajax({
                url: "/quiz/quizExampprScrModifyAjax.do",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(scrList),
                dataType: "json",
                beforeSend: function () {
                	showLoading();
                },
                success: function (data) {
                    if (data.result > 0) {
                    	alert("<spring:message code='exam.alert.save.score' />");/* 점수 저장이 완료되었습니다. */
                    	window.parent.qstnScoreEdit();
			    		location.reload();
                    } else {
						alert(data.message);
                    }
                    hideLoading();
                },
                error: function (xhr, status, error) {
                	alert("<spring:message code='exam.error.qstn.score.insert' />");/* 점수 저장 중 에러가 발생하였습니다. */
                },
                complete: function () {
                	hideLoading();
                },
            });
		}

		// 이전, 다음 평가정보
		function chgUserEval(type) {
			showLoading();
			var userId 	  = "";
			var userList = [];
			<c:forEach var="list" items="${quizTkexamList}">
				userList.push("${list.userId}");
			</c:forEach>

			for(var i = 0; i < userList.length; i++) {
				if(userList[i] == "${quizExamnee.userId}") {
					if(type == "prev") {
						if(i == 0) {
							userId = userList[userList.length-1];
						} else {
							userId = userList[i-1];
						}
					} else if(type == "next") {
						if(i == userList.length-1) {
							userId = userList[0];
						} else {
							userId = userList[i+1];
						}
					}
				}
			}

			$("#evalUserId").val(userId);
	        $("#quizEvalForm").attr("action", "/quiz/profQuizExampprEvlPopup.do");
	        $("#quizEvalForm").submit();
		}

		// 포커스 이동
		function focusMove(exampprId) {
			var locate = parseInt($("#"+exampprId).offset().top);
			$(window.parent.document.getElementsByClassName("modal fade in")).scrollTop(locate);
		}

		// 시험지 인쇄
		function quizExampprPrint() {
			$("#quizEvalForm").attr("action", "/quiz/profQuizExampprBulkPrintPopup.do");
	        $("#quizEvalForm").submit();
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
		<form name="quizEvalForm" id="quizEvalForm" method="POST">
			<input type="hidden" name="examBscId" 		value="${vo.examBscId }" />
			<input type="hidden" name="examDtlId" 		value="${vo.examDtlVO.examDtlId }" />
			<input type="hidden" name="userId" 			value="${quizExamnee.userId }"		id="evalUserId" />
			<input type="hidden" name="evlyn" 			value="${params.evlyn }" />
			<input type="hidden" name="tkexamCmptnyn"	value="${params.tkexamCmptnyn }" />
			<input type="hidden" name="searchValue" 	value="${params.searchValue }" />
		</form>
        <div id="wrap">
        	<div class="ui message info-item-box gap4">
		        <div class="mla fcBlue">
		            <b>${quizExamnee.deptnm } ${quizExamnee.stdntNo } ${quizExamnee.usernm } <span class="f150">${quizExamnee.totScr }<spring:message code="exam.label.score.point" /></span><!-- 점 --></b>
		        </div>
		        <c:if test="${fn:length(quizTkexamList) > 1 }">
			        <div class="option-content">
						<div class="mla">
							<a href="javascript:chgUserEval('prev')" class="ui small basic button"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
							<a href="javascript:chgUserEval('next')" class="ui small basic button"><spring:message code="exam.label.next" /></a><!-- 다음 -->
						</div>
			        </div>
		        </c:if>
		    </div>

		    <div class="qstnInfo">
			    <div class="option-content">
			        <p class="sec_head">${vo.examTtl }</p>
			        <div class="mla">
			        	<a href="javascript:quizExampprPrint()" class="ui blue small button"><spring:message code="exam.button.print.paper" /></a><!-- 시험지 인쇄 -->
			        	<a href="javascript:saveScore('${quizExamnee.userId }')" class="ui blue small button">점수 저장</a>
			        	<a href="javascript:window.parent.closeDialog()" class="ui blue small button"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
			        </div>
			    </div>
		        <c:if test="${vo.examQstnsCmptnyn ne 'Y' && vo.examQstnsCmptnyn ne 'M' }">
		        	<div class="ui small error message">
		                <i class="info circle icon"></i>
		                <spring:message code="exam.alert.already.qstn.submit.n" /><!-- 문제 출제가 완료되지 않았습니다. -->
		            </div>
		        </c:if>
			    <ul class="num-chk" aria-label="문제로 바로가기 버튼">
			    	<c:forEach var="item" items="${tkexamExampprAnswShtList }" varStatus="varStatus">
		        		<li ${not empty item.answShtCts ? 'class="correct"' : '' }><a href="javascript:focusMove('${item.exampprId }')">${varStatus.count }</a></li>
		        	</c:forEach>
			    </ul>
		    </div>

            <div class="ui form qstnList mt10">
            	<c:forEach var="item" items="${tkexamExampprAnswShtList }" varStatus="varStatus">
            		<div class="ui card wmax qstnDiv" id="${item.exampprId }" data-qstnId="${item.qstnId }" data-tkexamAnswShtId="${item.tkexamAnswShtId }">
            			<div class="fields content header2">
			                <div class="field wf100 flex-item">
			                    <span><spring:message code="exam.label.qstn" /><!-- 문제 --> ${varStatus.count }</span>
			                    <c:if test="${item.qstnRspnsTycd eq 'LINK' }">(<spring:message code="exam.label.qstn.match.info" /><!-- 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. -->)</c:if>
		            			<div class="alt_icon overflow-hidden mla">
		            				<c:set var="imgSrc" value="/webdoc/img/answer.png" />
		            				<c:if test="${item.ansrYn eq 'Y' }">
		            					<c:set var="imgSrc" value="/webdoc/img/quiz_true.gif" />
		            				</c:if>
			            			<img class="list ul icon w30 color" src="${imgSrc }" alt="">
			                	</div>
			                </div>
            			</div>
		                <div class="content">
	                    	<p>${item.qstnCts}</p>
		                    <c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
								<div class="ui divider"></div>
								<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
									<c:set var="qstnDsplySeqno" value="${item.qstnDsplySeqno}"/>
									<div id="emplLi_${qstnDsplySeqno}_${emplItem}" class="field">
										<div class="ui read-only checkbox">
											<input type="checkbox" name="rgtAnsr_CHOICE_${qstnDsplySeqno}" id="rgtAnsr_${qstnDsplySeqno}_${emplItem}" <c:forEach var="crans" items="${fn:split(item.answShtCts,'@#') }"><c:if test="${crans eq emplItem }">checked</c:if></c:forEach>>
											<label for="rgtAnsr_${qstnDsplySeqno}_${emplItem}" class="question ${item.qstnRspnsTycd eq 'MLT_CHC' ? 'multi' : '' } empl" data-value="${emplItem }">${fn:split(item.qstnVwitmCts,'@#')[emplItem-1] }</label>
										</div>
									</div>
								</c:forEach>
		                    </c:if>
		                    <c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
		                    	<div class="equal width fields">
		                    		<c:set var="ansrCnt" value="${fn:length(fn:split(item.qstnVwitmDsplySeq, '@#')) }" />
			                    	<c:forEach var="ansrItem" begin="1" end="${ansrCnt }" step="1" varStatus="anStatus">
			                    		<div class="field">
			                    			<label for="shot_${varStatus.count}_${anStatus.count}" class="hide">answer</label>
			                    			<input id="shot_${varStatus.count}_${anStatus.count}" type="text" value="${fn:split(item.answShtCts, '@#')[ansrItem-1] }" readonly="readonly" />
			                    		</div>
			                    	</c:forEach>
		                    	</div>
		                    </c:if>
		                    <c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
		                    	<textarea rows="5" cols="20" readonly="readonly">${item.answShtCts }</textarea>
		                    </c:if>
		                    <c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
		                        <div class="checkImg">
		                        	<c:forEach var="emplItem" items="${fn:split(item.qstnVwitmDsplySeq, '@#') }">
		                        		<c:set var="oxClass" value="${emplItem eq 1 ? 'true' : 'false' }" />
			                            <input id="oxChk${item.qstnId}_${oxClass}" type="radio" name="oxChk${item.qstnId}" disabled="disabled"
			                                value="${emplItem }" ${item.answShtCts == emplItem ? 'checked' : ''} onChange="changeOxQstnAnswer(this)">
			                            <label class="imgChk ${oxClass }" for="oxChk${item.qstnId}_${oxClass}"></label>
		                        	</c:forEach>
		                        </div>
		                    </c:if>
		                    <c:if test="${item.qstnRspnsTycd eq 'LINK' }">
								<div class="ui divider"></div>
								<div class="line-sortable-box">
									<div class="account-list">
										<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
											<c:set var="qstnDsplySeqno" value="${item.qstnDsplySeqno}"/>
											<div class="line-box num0${emplItem}" id="emplLi_${qstnNo}_${emplItem}">
										 		<div class="question" id="emplMatch_${qstnDsplySeqno}_${emplItem}" name="emplMatch_${qstnDsplySeqno}_${emplItem}"><span>${fn:split(fn:split(item.qstnVwitmCts,'@#')[emplItem-1],'\\|')[0]}</span></div>
												<div class="slot" id="rqtAnsrMatch_${qstnDsplySeqno}_${emplItem}" name="rqtAnsrMatch_${qstnDsplySeqno}_${emplItem}">${fn:split(item.answShtCts,'@#')[emplItem-1]}</div>
											</div>
										</c:forEach>
									</div>
								</div>
		                    </c:if>
	                    </div>
		                <div class="content">
		                 	<div class="flex gap16 align-items-center mb20">
				                 <div class="flex">
				                 	<div class="flex align-items-center gap4">
					            		<p class="m0">정답</p>
					                     <c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
					                     	<c:set var="cransNo" value="" />
											<c:forEach var="emplItem" items="${fn:split(item.cransNo,'@#')}">
											    <c:forEach var="seqItem" items="${fn:split(item.qstnVwitmDsplySeq,'@#')}" varStatus="cransStatus">
											        <c:if test="${emplItem == seqItem}">
											            <c:choose>
											                <c:when test="${empty cransNo}">
											                    <c:set var="cransNo" value="${cransStatus.count}" />
											                </c:when>
											                <c:otherwise>
											                    <c:set var="cransNo" value="${cransNo},${cransStatus.count}" />
											                </c:otherwise>
											            </c:choose>
											        </c:if>
											    </c:forEach>
											</c:forEach>
											<p style="padding: 0.715em 1em 0.715em;">${cransNo }</p>
			                 			</c:if>
			                 			<c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
			                 				<p style="padding: 0.715em 1em 0.715em;">${fn:replace(item.qstnVwitmCts,'@#',',') }</p>
			                 			</c:if>
			                 			<c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
			                 				<p style="padding: 0.715em 1em 0.715em;">${item.qstnVwitmCts }</p>
			                 			</c:if>
			                 			<c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
			                 				<p style="padding: 0.715em 1em 0.715em;">${item.cransCts }</p>
			                 			</c:if>
			                 			<c:if test="${item.qstnRspnsTycd eq 'LINK' }">
											<c:set var="emplMatchNumStr"   value="A@#B@#C@#D@#E@#F@#G@#H@#I@#J" />
											<c:set var="emplMatchNumArray" value="${fn:split(emplMatchNumStr,'@#')}" />
											<c:set var="cransCts" value="" />
											<c:forEach var="emplItem" items="${fn:split(item.answShtCts,'@#')}" varStatus="mstat">
												<c:choose>
													<c:when test="${empty cransCts }">
														<c:set var="cransCts" value="${emplMatchNumArray[mstat.index]}-${emplItem}" />
													</c:when>
													<c:otherwise>
														<c:set var="cransCts" value="${cransCts},${emplMatchNumArray[mstat.index]}-${emplItem}" />
													</c:otherwise>
												</c:choose>
											</c:forEach>
											<p style="padding: 0.715em 1em 0.715em;">${cransCts }</p>
			                 			</c:if>
					            	</div>
				                 </div>
					             <div class="flex">
					            	<div class="flex align-items-center gap4">
					            		<p class="m0">배점</p>
					            		<p>${item.qstnScr }</p>
					            	</div>
					             </div>
					             <div class="flex">
					             	<div class="flex align-items-center gap4">
					            		<p class="m0">난이도</p>
					            		<p>${item.qstnDfctlvTynm }</p>
					            	</div>
					             </div>
					             <div class="flex align-items-center gap4 mla">
					             	점수 <input class="w50 score" data-maxscore="${item.qstnScr }" style="height:22.5px;" type="number" step="0.1" value="${empty item.scr ? 0 : item.scr }"> 점
					             </div>
				             </div>
		                 	<button class="ui basic small button ml_auto" onclick="viewStatus(this, '${item.qstnId}', '${item.exampprId }', '${item.qstnRspnsTycd }')"><spring:message code="exam.label.view.result.status" /> <i class="angle up icon tr"></i></button><!-- 결과 통계 보기 -->
		                 	<div class="ui stackable equal width grid resultStatus" style="display:none;">
		                 		<div class="column">
		                             <canvas id="${item.qstnId }_barChart" height="130"></canvas>
		                         </div>
		                         <div class="column">
		                             <canvas id="${item.qstnId }_pieChart" height="130"></canvas>
		                         </div>
		                     </div>
		                 </div>
		            </div>
            	</c:forEach>
            </div>

            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
