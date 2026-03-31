<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
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
		});

		// 결과 통계보기 버튼
		function viewStatus(obj, qstnId, exampprId, qstnRspnsTycd) {
			if($(obj).hasClass("on")) {
				$(obj).next("div.resultStatus").css("display", "none");
			} else {
				if($(obj).hasClass("already")) {
					$(obj).next("div.resultStatus").css("display", "block");
					$(obj).toggleClass("on");
					$(obj).children("i").toggleClass("xi-angle-up xi-angle-down");
					return;
				}
				// bar차트
				var url  = "/quiz/quizQstnDistributionBarChartAjax.do";
				var data = {
					"examDtlId" : "${vo.examDtlVO.examDtlId }",
					"qstnId" 	: qstnId,
					"exampprId"	: exampprId
				};

				UiComm.showLoading(true);
				$.ajax({
				    url 	 : url,
				    async	 : false,
				    type 	 : "POST",
				    data	 : JSON.stringify(data),
				    dataType : "json",
				    contentType: "application/json; charset=UTF-8"
				}).done(function(data) {
					UiComm.showLoading(false);
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

                            // 총합 계산
                            const total = emplStareAnsrArray.reduce((a, b) => a + b, 0);

                            new Chart(document.getElementById(qstnId+'_barChart'), {
                                type: 'bar',
                                data: {
                                    labels: labelsArray,
                                    datasets: [{
                                        label: '인원수',
                                        data: emplStareAnsrArray,
                                        backgroundColor: 'rgba(54, 162, 235, 0.7)',
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        borderWidth: 1,
                                        barThickness: 18
                                    }]
                                },
                                options: {
                                    indexAxis: 'y', // 가로 막대
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: { display: false },
                                        title: {
                                            display: true,
                                            text: '보기 분포 현황 (%)',
                                            font: { size: 16 },
                                            color: '#333'
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: function(context) {
                                                    const count = context.raw;
                                                    const percent = ((count / total) * 100).toFixed(1);
                                                    return count + '명 (' + percent + '%)';
                                                }
                                            }
                                        },
                                        // 막대 옆 데이터 라벨 표시
                                        datalabels: {
                                            display: true,
                                            anchor: 'end',        // 막대 끝에 붙이기
                                            align: 'right',       // 오른쪽으로 정렬
                                            formatter: (value) => {
                                                const percent = ((value / total) * 100).toFixed(1);
                                                return value + '명 (' + percent + '%)';
                                            },
                                            color: '#666',
                                            font: { weight: 'bold', size: 11 }
                                        }
                                    },
                                    scales: {
                                        x: {
                                            beginAtZero: true,
                                            max: Math.max(...emplStareAnsrArray) * 1.2, // 막대 끝에 라벨 공간 확보
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
						}
				    } else {
				    	UiComm.showMessage(data.message, "error");
				    }
				}).fail(function() {
					UiComm.showLoading(false);
					UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
				});

				// pie차트
				var url  = "/quiz/quizQstnCransStatusPieChartAjax.do";
				var data = {
					"examDtlId" : "${vo.examDtlVO.examDtlId }",
					"qstnId" 	: qstnId,
					"exampprId"	: exampprId
				};

				UiComm.showLoading(true);
				$.ajax({
				    url 	 : url,
				    async	 : false,
				    type 	 : "POST",
				    data	 : JSON.stringify(data),
				    dataType : "json",
				    contentType: "application/json; charset=UTF-8"
				}).done(function(data) {
					UiComm.showLoading(false);
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

					// 총합 계산
                    const total = emplStareAnsrArray.reduce((a, b) => a + b, 0);

					new Chart(document.getElementById(qstnId+'_pieChart'), {
                        type: 'pie',
                        data: {
                            labels: labelsArray,
                            datasets: [{
                                label: '인원수',
                                data: emplStareAnsrArray,
                                backgroundColor: backgroundColorArray,
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1,
                                barThickness: 18
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { display: false },
                                title: {
                                    display: true,
                                    text: '정답비율 (%)',
                                    font: { size: 16 },
                                    color: '#333'
                                },
                                // 막대 옆 데이터 라벨 표시
                                datalabels: {
                                    display: true,
                                    anchor: 'end',        // 막대 끝에 붙이기
                                    align: 'right',       // 오른쪽으로 정렬
                                    formatter: (value) => {
                                        const percent = ((value / total) * 100).toFixed(1);
                                        return value + '명 (' + percent + '%)';
                                    },
                                    color: '#666',
                                    font: { weight: 'bold', size: 11 }
                                }
                            }
                        },
                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
                    });
				}).fail(function() {
					UiComm.showLoading(false);
					UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
				});
				$(obj).next("div.resultStatus").css("display", "block");
				$(obj).addClass("already");
			}
			$(obj).toggleClass("on");
			$(obj).children("i").toggleClass("xi-angle-up xi-angle-down");
		}

		// 점수 저장
		function saveScore(userId) {
			var scrList = [];	// 점수 목록

			const qstn = document.querySelectorAll('div.qstnDiv');

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
                	UiComm.showLoading(true);
                },
                success: function (data) {
                    if (data.result > 0) {
                    	UiComm.showMessage("<spring:message code='exam.alert.save.score' />", "success");	/* 점수 저장이 완료되었습니다. */
                    	window.parent.qstnScoreEdit();
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
			UiComm.showLoading(true);
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

		// 시험지 인쇄
		function quizExampprPrint() {
			$("#quizEvalForm").attr("action", "/quiz/profQuizExampprBulkPrintPopup.do");
	        $("#quizEvalForm").submit();
		}
	</script>

	<body class="modal-page">
		<form name="quizEvalForm" id="quizEvalForm" method="POST">
			<input type="hidden" name="examBscId" 		value="${vo.examBscId }" />
			<input type="hidden" name="examDtlId" 		value="${vo.examDtlVO.examDtlId }" />
			<input type="hidden" name="userId" 			value="${quizExamnee.userId }"		id="evalUserId" />
			<input type="hidden" name="evlyn" 			value="${params.evlyn }" />
			<input type="hidden" name="tkexamCmptnyn"	value="${params.tkexamCmptnyn }" />
			<input type="hidden" name="searchValue" 	value="${params.searchValue }" />
		</form>
        <div id="wrap">
        	<div class="board_top">
        		<c:if test="${fn:length(quizTkexamList) > 1 }">
					<a href="javascript:chgUserEval('prev')" class="btn small basic"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
					<a href="javascript:chgUserEval('next')" class="btn small basic"><spring:message code="exam.label.next" /></a><!-- 다음 -->
		        </c:if>
		        <div class="right-area fcBlue">
		        	<b class="flex-item gap-2">${quizExamnee.deptnm } ${quizExamnee.stdntNo } ${quizExamnee.usernm } <span class="fs-22px">${quizExamnee.totScr }<spring:message code="exam.label.score.point" /></span><!-- 점 --></b>
		        </div>
        	</div>

        	<div class="board_top">
        		<div class="right-area">
        			<a href="javascript:quizExampprPrint()" class="btn type1"><spring:message code="exam.button.print.paper" /></a><!-- 시험지 인쇄 -->
			        <a href="javascript:saveScore('${quizExamnee.userId }')" class="btn type1">점수 저장</a>
			        <a href="javascript:window.parent.closeDialog()" class="btn type1"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
        		</div>
        	</div>

		    <div class="qstnInfo flex-item gap-3 margin-bottom-5">
		        <c:if test="${vo.examQstnsCmptnyn ne 'Y' && vo.examQstnsCmptnyn ne 'M' }">
			    	<div class="msg-box">
	                    <p class="txt">
	                    	<i class="icon-svg-warning" aria-hidden="true"></i>
	                    	<spring:message code="exam.alert.already.qstn.submit.n" /><!-- 문제 출제가 완료되지 않았습니다. -->
	                    </p>
	                </div>
		        </c:if>
		        <c:forEach var="item" items="${tkexamExampprAnswShtList }" varStatus="varStatus">
		        	<div class="custom-input padding-3">
				       	<p class="checkmark padding-left-3 ${not empty item.answShtCts ? 'bcLblue' : '' }">${varStatus.count }</p>
		        	</div>
				</c:forEach>
		    </div>

		    <div class="qstnList">
		    	<c:forEach var="item" items="${tkexamExampprAnswShtList }" varStatus="varStatus">
			    	<div class="board_top border-1 padding-3 margin-bottom-0">
			    		<span>문제 ${varStatus.count }. ${item.qstnTtl }</span>
			    		<div class="overflow-hidden right-area w30 d-inline-block position-relative" style="height:30px;">
			            	<c:set var="imgSrc" value="/webdoc/img/answer.png" />
			            	<c:if test="${item.ansrYn eq 'Y' }">
			            		<c:set var="imgSrc" value="/webdoc/img/quiz_true.gif" />
			            	</c:if>
				           	<img class="width-100per show margin-left-auto" style="position: absolute; bottom:0;" src="${imgSrc }" alt="">
			            </div>
			    	</div>
				    <div class="padding-3 margin-top-0 border-1 cpn">
				    	<div class="margin-bottom-5">${item.qstnCts }</div>
				    	<c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
				    		<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
				    			<div class="margin-bottom-3">
				    				<span class="custom-input">
				    					<input type="${item.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" name="qstn_${item.qstnId }" id="qstn_${item.exampprId }_${emplItem}" <c:forEach var="crans" items="${fn:split(item.answShtCts,'@#') }"><c:if test="${crans eq emplItem }">checked</c:if></c:forEach> />
				    					<label for="qstn_${item.exampprId }_${emplItem}">${fn:split(item.qstnVwitmCts,'@#')[emplItem-1] }</label>
				    				</span>
				    			</div>
				    		</c:forEach>
				    	</c:if>
				    	<c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
				    		<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
					    		<span class="custom-input">
					    			<input type="radio" name="qstn_${item.qstnId }" id="qstn_${item.exampprId }_${emplItem}" <c:if test="${item.answShtCts eq emplItem }">checked</c:if> />
					    			<label for="qstn_${item.exampprId }_${emplItem}">${fn:split(item.qstnVwitmCts,'@#')[emplItem-1] }</label>
					    		</span>
				    		</c:forEach>
				    	</c:if>
				    	<c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
				    		<div class="flex gap-2 margin-bottom-2">
				    			<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
				    				<input type="text" class="width-15per" inputmask="byte" maxLen="4000" value="${fn:split(item.answShtCts, '@#')[emplItem-1] }" />
				    			</c:forEach>
				    		</div>
				    	</c:if>
				    	<c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
				    		<textarea style="width:100%;height:100px" maxLenCheck="byte,4000,true,true">${item.answShtCts }</textarea>
				    	</c:if>
				    	<c:if test="${item.qstnRspnsTycd eq 'LINK' }">
				    		<div class="line-sortable-box flex">
				    			<div class="account-list width-50per">
				    				<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
				    					<div class="line-box border-1 margin-bottom-3 padding-3 flex">
				    						<div class="question width-30per"><span>${fn:split(fn:split(item.qstnVwitmCts,'@#')[emplItem-1],'\\|')[0]}</span></div>
				    						<div class="slot margin-left-auto border-1 text-center width-100per" style="height:30px;">${fn:split(item.answShtCts,'@#')[emplItem-1]}</div>
				    					</div>
				    				</c:forEach>
				    			</div>
				    			<div class="inventory-list w200 margin-left-auto">
				    				<c:forEach var="emplItem" step="1" begin="1" end="${fn:length(item.qstnVwitmDsplySeq.split('@#')) }">
				    				</c:forEach>
				    			</div>
				    		</div>
				    	</c:if>
				    </div>
				    <div class="border-1 margin-bottom-3 padding-3 qstnDiv" data-qstnId="${item.qstnId }" data-tkexamAnswShtId="${item.tkexamAnswShtId }">
				    	<div class="flex-item">
					    	<p class="margin-right-3">정답</p>
					    	<div class="margin-right-3">
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
									<p>${cransNo }</p>
				                </c:if>
				                <c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
				                	<p>${fn:replace(item.qstnVwitmCts,'@#',',') }</p>
				                </c:if>
				                <c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
				                	<p>${item.qstnVwitmCts }</p>
				                </c:if>
				                <c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
				                	<p>${item.cransCts }</p>
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
									<p>${cransCts }</p>
				                </c:if>
					    	</div>
					    	<p class="margin-right-3">배점</p>
					    	<div class="margin-right-3"><p>${item.qstnScr }</p></div>
					    	<p class="margin-right-3">난이도</p>
					    	<div class="margin-right-3"><p>${item.qstnDfctlvTynm }</p></div>
					    	<div class="margin-left-auto flex-item">
					    		<p class="margin-right-3">점수</p>
					    		<input type="text" class="score w50" inputmask="numeric" data-maxscore="${item.qstnScr }" mask="999.99" maxVal="${item.qstnScr }" value="${empty item.scr ? 0 : item.scr }"> 점
					    	</div>
				    	</div>
				    	<button class="btn basic small" onclick="viewStatus(this, '${item.qstnId}', '${item.exampprId }', '${item.qstnRspnsTycd }')"><spring:message code="exam.label.view.result.status" /> <i class="xi-angle-down"></i></button><!-- 결과 통계 보기 -->
		                <div class="resultStatus" style="display:none;">
		                	<div class="column">
		                        <canvas id="${item.qstnId }_barChart" height="130"></canvas>
		                    </div>
		                    <div class="column">
		                        <canvas id="${item.qstnId }_pieChart" height="130"></canvas>
		                    </div>
		                </div>
				    </div>
		    	</c:forEach>
		    </div>

            <div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
