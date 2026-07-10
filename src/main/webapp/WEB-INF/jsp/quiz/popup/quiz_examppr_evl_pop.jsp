<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="chart"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			// dialog창 height 길이
			const currentHeight =
				  parseFloat(window.parent.dialog[0].style.height) ||
				  parseFloat(getComputedStyle(window.parent.dialog[0]).height) ||
				  window.parent.dialog[0].getBoundingClientRect().height;

			const ratio = 0.65;
			$("#exampprQstnDiv")[0].style.maxHeight = (currentHeight * ratio) + "px";
			$("#exampprQstnDiv")[0].style.overflowY = 'auto';

			document.querySelectorAll('.quiz_paper_list li').forEach(function(li) {
			    li.addEventListener('click', function() {
			        let seqno = this.querySelector('span').textContent.trim();

			        // 해당 question_area 찾아서 표시 후 스크롤
			        var target = document.querySelector('.question_area[data-qstnseqno="' + seqno + '"]');

			        if (target) {
			            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
			        }
			    });
			});
		});

		// 결과 통계보기 버튼
		function viewStatus(obj, qstnId, exampprId, qstnRspnsTycd) {
			const parentDiv = $("div.qstnDiv[data-qstnid='"+qstnId+"']");
			const chartDiv = parentDiv.find('div.resultStatus').first();

			$(obj).find('i').toggleClass('open');

			if(chartDiv.is(":visible")) {
				chartDiv.hide();
			} else {
				chartDiv.show();

				if($(obj).hasClass("already")) {
					return;
				}

				// 퀴즈문항상태차트조회
				const url  = "/quiz/quizQstnStatusChartAjax.do";
				const data = {
					examDtlId 	: $("#evlExamDtlId").val(),
					qstnId 		: qstnId,
					exampprId	: exampprId
				};

				$.ajax({
				    url 	 	: url,
				    async	 	: false,
				    type 	 	: "POST",
				    data	 	: JSON.stringify(data),
				    dataType 	: "json",
				    contentType	: "application/json; charset=UTF-8",
				    beforeSend: function () {
		            	UiComm.showLoading(true);
		            },
		            success: function (data) {
		            	// pie 차트
						var cransStatus 	= data.data.resultMap.pieChart;
						var pieData 		= JSON.parse(cransStatus.returnList[0].emplMap);
						var pieLabelsArray 	= new Array();
						var pieDataArray 	= new Array();
						if(Object.keys(pieData).length > 0){
							for (var i = 0; i < Object.keys(pieData).length; i++) {
								pieLabelsArray.push(Object.keys(pieData)[i].toUpperCase());
							}
							pieDataArray = Object.values(pieData);
						}

						new Chart(document.getElementById(qstnId+'_pieChart'), {
	                        type: 'pie',
	                        data: {
	                            labels: pieLabelsArray,
	                            datasets: [{
	                                data: pieDataArray,
	                                backgroundColor: ['rgba(54, 162, 235, .8)', 'rgba(255, 99, 132, .8)'],
	                                borderWidth: 1,
	                            }]
	                        },
	                        options: {
	                            responsive: true,
	                            maintainAspectRatio: false,
	                            plugins: {
	                            	legend: { position: 'bottom' },
	                            	title: { display: true, text: '정답 비율 (%)', font: { size: 16 }, color: '#333' },
	                            	datalabels: {
	                                    color: '#fff',
	                                    font: { weight: 'bold', size: 11 },
	                                    formatter: (value, context) => {
	                                        const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
	                                        return (value / total * 100).toFixed(1) + '%';
	                                    }
	                                }
	                            }
	                        },
	                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
	                    });

						// bar차트
						var qstnDistribution 	= data.data.resultMap.barChart;
						var barData 		   	= JSON.parse(qstnDistribution.returnList[0].emplMap);
						var barLabelsArray 	   	= new Array();
						var barDataArray 		= new Array();
						var oxLabel 		   	= ['O', 'X'];
						if(Object.keys(barData).length > 0){
							for (var i = 0; i < Object.keys(barData).length; i++) {
								if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
									barLabelsArray.push(i+1);
								} else if(qstnRspnsTycd == "OX_CHC") {
									barLabelsArray.push(oxLabel[i]);
								} else {
									barLabelsArray.push(Object.keys(barData)[i].toUpperCase());
								}
							}
							barDataArray = Object.values(barData);
						}

	                    new Chart(document.getElementById(qstnId+'_barChart'), {
	                        type: 'bar',
	                        data: {
	                            labels: barLabelsArray,
	                            datasets: [{
	                                data: barDataArray,
	                                backgroundColor: 'rgba(54, 162, 235, 0.7)',
	                                borderWidth: 1,
	                                barThickness: 30
	                            }]
	                        },
	                        options: {
	                            indexAxis: 'y', // 가로 막대
	                            responsive: true,
	                            maintainAspectRatio: false,
	                            plugins: {
	                                legend: { display: false },
	                                title: { display: true, text: '보기 분포 현황(%)', font: { size: 16 }, color: '#333' },
	                                datalabels: {
	                                    display: true,
	                                    anchor: 'end',        // 막대 끝에 붙이기
	                                    align: 'right',       // 오른쪽으로 정렬
	                                    formatter: (value, context) => {
	                                        const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
	                                        return (value / total * 100).toFixed(1) + '%';
	                                    }
	                                }
	                            },
	                            scales: {
	                                x: {
	                                    beginAtZero: true,
	                                    max: Math.max(...barDataArray) * 1.2, // 막대 끝에 라벨 공간 확보
	                                    ticks: { color: '#666' },
	                                    title: { display: false, text: '인원수' },
	                                    grid: { color: '#eee' }
	                                },
	                                y: {
	                                    reverse: true,
	                                    ticks: { color: '#666', font: { size: 11 } },
	                                }
	                            }
	                        },
	                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
	                    });

						$(obj).addClass("already");
		            },
		            error: function (xhr, status, error) {
		            	UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
		            },
		            complete: function () {
		            	UiComm.showLoading(false);
		            },
				});
			}
		}

		// 점수 저장
		function saveScore(userId) {
			const scrList	= [];	// 점수 목록
			const qstn 		= document.querySelectorAll('div.qstnDiv');

			qstn.forEach(item => {
				let score 		= item.querySelector(".score").value
				let maxScore 	= item.querySelector(".score").dataset.maxscore;
				if(score == "") score = "0";
				if(parseInt(score) > parseInt(maxScore)) score = maxScore;
				let scr = {
					userId			: "${quizExamnee.userId}",
					exampprId		: item.dataset.exampprid,
					qstnId			: item.dataset.qstnid,
					tkexamAnswShtId	: item.dataset.tkexamanswshtid,
					scr				: score
				};

				scrList.push(scr);
			});

			$.ajax({
                url			: "/quiz/quizExampprScrModifyAjax.do",
                type		: "POST",
                contentType	: "application/json",
                data		: JSON.stringify(scrList),
                dataType	: "json",
                beforeSend: function () {
                	UiComm.showLoading(true);
                },
                success: function (data) {
                    if (data.result > 0) {
                    	UiComm.showMessage("<spring:message code='exam.alert.save.score' />", "success");	/* 점수 저장이 완료되었습니다. */
                    	window.parent.quizTkexamListSelect();
			    		location.reload();
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                    UiComm.showLoading(false);
                },
                error: function (xhr, status, error) {
                	UiComm.showMessage("<spring:message code='exam.error.qstn.score.insert' />", "error");	/* 점수 저장 중 에러가 발생하였습니다. */
                },
                complete: function () {
                	UiComm.showLoading(false);
                },
            });
		}

		// 이전, 다음 평가정보
		function chgUserEval(type) {
			let target = {};
			let userList = [];
			<c:forEach var="list" items="${quizTkexamList}">
				userList.push({
					  userId 	: "${list.userId}"
					, examDtlId : "${list.examDtlId}"
				});
			</c:forEach>

			for(var i = 0; i < userList.length; i++) {
				if(userList[i].userId == "${quizExamnee.userId}") {
					if(type == "prev") {
						if(i == 0) {
							target = userList[userList.length - 1];
						} else {
							target = userList[i-1];
						}
					} else if(type == "next") {
						if(i == userList.length-1) {
							target = userList[0];
						} else {
							target = userList[i+1];
						}
					}
				}
			}

			$("#evalUserId").val(target.userId);
			$("#evlExamDtlId").val(target.examDtlId);
	        $("#quizEvalForm").attr("action", "/quiz/profQuizExampprEvlPopup.do");
	        $("#quizEvalForm").submit();
		}

		// 시험지 인쇄
		function quizExampprPrint() {
			$("#quizEvalForm").attr("action", "/quiz/profQuizExampprBulkPrintPopup.do");
	        $("#quizEvalForm").submit();
		}
	</script>

	<body class="modal-body">
		<form name="quizEvalForm" id="quizEvalForm" method="POST">
			<input type="hidden" name="examBscId" 		value="${vo.examBscId }" />
			<input type="hidden" name="examDtlId" 		value="${vo.examDtlVO.examDtlId }"	id="evlExamDtlId" />
			<input type="hidden" name="userId" 			value="${quizExamnee.userId }"		id="evalUserId" />
			<input type="hidden" name="evlyn" 			value="${params.evlyn }" />
			<input type="hidden" name="tkexamCmptnyn"	value="${params.tkexamCmptnyn }" />
			<input type="hidden" name="searchValue" 	value="${params.searchValue }" />
		</form>
    	<div class="board_top class">
    		<c:if test="${fn:length(quizTkexamList) > 1 && userTycd eq 'PROF' }">
                <button type="button" class="btn type2" onclick="chgUserEval('prev')"><i class="xi-angle-left-min"></i><spring:message code="exam.label.prev" /><!-- 이전 --></button>
                <button type="button" class="btn type2" onclick="chgUserEval('next')"><spring:message code="exam.label.next" /><!-- 다음 --><i class="xi-angle-right-min"></i></button>
    		</c:if>
            <div class="right-area">
                <div class="feedback-info">
                    <p class="desc">
                        <span><strong>${quizExamnee.deptnm }</strong></span>
                        <span><strong>${quizExamnee.stdntNo }</strong></span>
                        <span><strong>${quizExamnee.usernm }</strong></span>
                        <span class="score"><strong>${userTycd eq 'PROF' || vo.mrkOyn eq 'Y' ? quizExamnee.totScr : '-' }<spring:message code="exam.label.score.point" /><!-- 점 --></strong></span>
                    </p>
                </div>
            </div>
        </div>

        <div class="quiz_paper_wrap">
        	<div class="board_top">
                <div class="quiz_paper_list">
                    <ol>
                    	<c:forEach var="item" items="${tkexamExampprAnswShtList }" varStatus="varStatus">
                    		<li ${not empty item.answShtCts ? 'class="active"' : '' }><span>${varStatus.count }</span></li>
						</c:forEach>
                    </ol>
                </div>

				<c:if test="${userTycd eq 'PROF' }">
	                <div class="right-area">
	                    <button type="button" class="btn basic" onclick="quizExampprPrint()"><spring:message code="exam.button.print.paper" /><!-- 시험지 인쇄 --></button>
	                    <button type="button" class="btn type1" onclick="saveScore('${quizExamnee.userId }')">점수 저장</button>
	                    <button type="button" class="btn type2" onclick="window.parent.closeDialog()"><spring:message code="exam.button.cancel" /><!-- 취소 --></button>
	                </div>
				</c:if>
            </div>
        </div>

		<div id="exampprQstnDiv">
			<c:forEach var="item" items="${tkexamExampprAnswShtList }" varStatus="varStatus">
				<div class="course_history bd0">
					<div class="question_area pd0" data-qstnSeqno="${varStatus.count }">
						<div class="question_con">
							<!-- 문제번호,제목영역 -->
							<div class="q_top">
	                            <div class="flex-item width-100per">
	                                <p class="flex-none mr15"><b>문제${varStatus.count }</b></p>
	                                <div class="flex-1 tal">${fn:escapeXml(item.qstnTtl) }</div>
	                                <c:choose>
	                                	<c:when test="${item.ansrYn eq 'Y' }">
		                                    <div class="q_result correct">
		                                        <i class="xi-radiobox-blank icon"></i>
		                                    </div>
	                                	</c:when>
	                                	<c:otherwise>
		                                    <div class="q_result incorrect">
		                                    	<i class="xi-close icon"></i>
		                                    </div>
	                                	</c:otherwise>
	                                </c:choose>
	                            </div>
	                        </div>
	                        <!-- //문제번호,제목영역 -->
	                        <!-- 문제내용영역 -->
	                        <div class="q_cont">
	                        	<c:choose>
									<c:when test="${fn:startsWith(fn:trim(item.qstnCts), '<div class=\"se-contents\"')}">
										<pre>${item.qstnCts }</pre>
									</c:when>
									<c:otherwise>
										<p>${item.qstnCts }</p>
									</c:otherwise>
								</c:choose>
	                        	<c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
	                        		<ol class="q_cont_ans">
							    		<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
							    			<li>
							    				<input type="${item.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" name="qstn_${item.qstnId }" id="qstn_${item.exampprId }_${emplItem}" <c:forEach var="crans" items="${fn:split(item.answShtCts,'@#') }"><c:if test="${crans eq emplItem }">checked</c:if></c:forEach> />
							    				<label for="qstn_${item.exampprId }_${emplItem}"><span class="ansNum">${emplItem}</span>${fn:split(item.qstnVwitmCts,'@#')[emplItem-1] }</label>
							    			</li>
							    		</c:forEach>
	                        		</ol>
						    	</c:if>
						    	<c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
						    		<div class="q_cont_ans ox_quiz justify-content-center">
						    			<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
								    		<div class="ox_item">
								    			<input type="radio" class="ox_input" name="qstn_${item.qstnId }" id="qstn_${item.exampprId }_${emplItem}" <c:if test="${item.answShtCts eq emplItem }">checked</c:if> />
								    			<label for="qstn_${item.exampprId }_${emplItem}" class="btn basic">
								    				<c:choose>
								    					<c:when test="${fn:split(item.qstnVwitmCts,'@#')[emplItem-1] eq 'O' }">
								    						<i class="xi-radiobox-blank icon"></i>
								    					</c:when>
								    					<c:otherwise>
								    						<i class="xi-close icon"></i>
								    					</c:otherwise>
								    				</c:choose>
								    			</label>
								    		</div>
							    		</c:forEach>
	                                </div>
						    	</c:if>
						    	<c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
						    		<div class="q_cont_ans shortAnswerList">
						    			<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
						    				<label><input type="text" class="form-control" inputmask="byte" maxLen="4000" value="${fn:split(item.answShtCts, '@#')[emplItem-1] }" readonly="true" /></label>
						    			</c:forEach>
	                                </div>
						    	</c:if>
						    	<c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
						    		<div class="q_cont_ans">
							    		<textarea style="width:100%;height:100px" maxLenCheck="byte,4000,true,true" readonly="true">${item.answShtCts }</textarea>
	                                </div>
						    	</c:if>
						    	<c:if test="${item.qstnRspnsTycd eq 'LINK' }">
						    		<div class="q_cont_ans matching_form">
	                                    <c:set var="alphabets" value="ABCDEFGHIJKLMNOPQRSTUVWXYZ" />
	                                    <ol class="matching_list">
	                                    	<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
	                                            <li class="matching_item">
	                                                <div class="q_box">
	                                                    <label>
	                                                        <span class="index">${fn:substring(alphabets, emplItem-1, emplItem)}</span>
	                                                        <input type="text" value="${fn:split(fn:split(item.qstnVwitmCts,'@#')[emplItem-1],'\\|')[0]}" readonly="true">
	                                                    </label>
	                                                </div>
	                                                <div class="a_box">
	                                                    <label>
	                                                        <input type="text" value="${fn:split(item.answShtCts,'@#')[emplItem-1]}" readonly="true">
	                                                    </label>
	                                                </div>
	                                            </li>
	                                    	</c:forEach>
	                                    </ol>
	                                </div>
						    	</c:if>
	                        </div>
	                        <!-- //문제내용영역 -->
	                        <!-- 결과영역 -->
	                        <div class="ans_cont qstnDiv" data-exampprid="${item.exampprId }" data-qstnId="${item.qstnId }" data-tkexamAnswShtId="${item.tkexamAnswShtId }">
	                            <div class="board_top align-items-center">
	                                <ol class="ans_cont_list">
	                                    <li>정답
	                                    	<span>
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
													${cransNo }
								                </c:if>
								                <c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
								                	${fn:replace(item.qstnVwitmCts,'@#',',') }
								                </c:if>
								                <c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
								                	${item.qstnVwitmCts }
								                </c:if>
								                <c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
								                	${item.cransCts }
								                </c:if>
								                <c:if test="${item.qstnRspnsTycd eq 'LINK' }">
													<c:set var="emplMatchNumStr"   value="A@#B@#C@#D@#E@#F@#G@#H@#I@#J" />
													<c:set var="emplMatchNumArray" value="${fn:split(emplMatchNumStr,'@#')}" />
													<c:set var="cransCts" value="" />
													<c:forEach var="emplItem" items="${fn:split(item.qstnVwitmCts,'@#')}" varStatus="mstat">
														<c:choose>
															<c:when test="${empty cransCts }">
																<c:set var="cransCts" value="${emplMatchNumArray[mstat.index]}-${fn:split(emplItem, '|')[1]}" />
															</c:when>
															<c:otherwise>
																<c:set var="cransCts" value="${cransCts},${emplMatchNumArray[mstat.index]}-${fn:split(emplItem, '|')[1]}" />
															</c:otherwise>
														</c:choose>
													</c:forEach>
													${cransCts }
								                </c:if>
	                                    	</span>
	                                    </li>
	                                    <c:if test="${userTycd eq 'PROF' }">
		                                    <li>배점<span>${item.qstnScr }</span></li>
		                                    <li>난이도<span>${item.qstnDfctlvTynm }</span></li>
		                                    <li class="ans_list_score">
		                                        점수
		                                        <span>
		                                            <div class="input_btn">
		                                                <input type="text" class="score w50" inputmask="numeric" data-maxscore="${item.qstnScr }" mask="999.99" maxVal="${item.qstnScr }" value="${empty item.scr ? 0 : item.scr }">
		                                                <label>점</label>
		                                            </div>
		                                        </span>
		                                    </li>
	                                    </c:if>
	                                </ol>
	                                <div class="right-area">
	                                    <button type="button" class="btn basic" onclick="viewStatus(this, '${item.qstnId}', '${item.exampprId }', '${item.qstnRspnsTycd }')"><spring:message code="exam.label.view.result.status" /><!-- 결과 통계 보기 --><i class="icon-svg-arrow-down"></i></button>
	                                </div>
	                            </div>
		                        <div class="resultStatus" style="display:none;">
		                            <div class="flex">
		                                <div class="left_chart">
		                                    <div class="chart-container" style="height: 250px;">
		                                        <canvas id="${item.qstnId }_pieChart"></canvas>
		                                    </div>
		                                </div>
		                                <div class="right_chart">
		                                    <div class="chart-container" style="height: 250px;">
		                                        <canvas id="${item.qstnId }_barChart"></canvas>
		                                    </div>
		                                </div>
		                            </div>
		                        </div>
	                        </div>
	                        <!-- //결과영역 -->
						</div>
					</div>
				</div>
			</c:forEach>
		</div>

        <div class="modal_btns">
            <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
