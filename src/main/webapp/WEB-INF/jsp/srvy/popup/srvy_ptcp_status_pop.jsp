<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table,chart"/>
		</jsp:include>
    </head>

    <script type="text/javascript">
    	$(document).ready(function() {
    		UiComm.showLoading(false);
    		if("${userTycd}" == "PROF") {
	    		srvyCommon.statusChartSet('status');
	    		srvyCommon.statusChartSet('device');
    		}

    		dialogHeightChange();
    	});

    	/**
		* 설문 팀 선택
		* @param {String}  srvyId - 선택 팀에 대한 설문아이디
		*/
	 	function srvyTeamSelect(srvyId) {
			UiComm.showLoading(true);
			const data = "upSrvyId=${vo.srvyId}&srvyId="+srvyId+"&sbjctId=${vo.sbjctId}";

			window.parent.$(".ui-dialog:visible iframe").last().attr("src", "/srvy/srvyPtcpStatusPopup.do?"+data);
	 	}

		// dialog height 수정
		function dialogHeightChange() {
			// dialog창 height 길이
			const currentHeight =
				  parseFloat(window.parent.dialog[0].style.height) ||
				  parseFloat(getComputedStyle(window.parent.dialog[0]).height) ||
				  window.parent.dialog[0].getBoundingClientRect().height;

			// 팀퀴즈 or 학생퀴즈응시인 경우 0.65배율
			const ratio = "${vo.srvyGbn}" == "SRVY_TEAM" && "${userTycd}" == "PROF" ? 0.7 : 0.82;
			$(".srvy_paper_wrap")[0].style.maxHeight = (currentHeight * ratio) + "px";
			$(".srvy_paper_wrap")[0].style.overflowY = 'auto';
		}
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-body">
        <div id="wrap">
        	<c:if test="${vo.srvyGbn eq 'SRVY_TEAM' && userTycd eq 'PROF' }">
				<div class="listTab flex align-items-center">
                    <ul>
                    	<c:forEach var="item" items="${srvyTeamList }">
                    		<li class="${item.srvyId eq vo.subSrvyId ? 'select' : '' }"><a name="teamButton" value="${item.srvyId }" onclick="srvyTeamSelect('${item.srvyId }')">${item.teamnm }</a></li>
                    	</c:forEach>
                    </ul>
                </div>
			</c:if>

			<div class="srvy_paper_wrap">
				<c:if test="${userTycd eq 'PROF' }">
					<div class="course_history">
						<div class="question_area">
							<div class="scoreChart_wrap">
								<!-- chart.js -->
	                            <div class="left_chart">
	                                <div class="chart-container" style="height: 250px; position: relative; width: 100%;">
	                                    <canvas id="statPieChart"></canvas>
	                                </div>
	                            </div>
	                            <div class="right_chart">
	                                <div class="chart-container" style="height: 250px; position: relative; width: 100%;">
	                                    <canvas id="devicePieChart"></canvas>
	                                </div>
	                            </div>
	                            <!-- //chart.js -->
							</div>
						</div>
					</div>
				</c:if>

				<c:forEach var="srvyppr" items="${srvypprList }">
					<div class="course_history">
						<div class="h_top">
                            <div class="h_left">
                                <h4>${srvyppr.srvySeqno }/${fn:length(srvypprList) } ${fn:escapeXml(srvyppr.srvyTtl) }</h4>
                            </div>
                        </div>
						<c:forEach var="qstn" items="${srvyQstnList }">
							<c:if test="${srvyppr.srvypprId eq qstn.srvypprId }">
								<div class="question_area">
									<div class="question_con">
										<div class="q_top">
	                                        <div class="flex-item width-100per">
	                                            <p class="flex-none mr15"><b><spring:message code="srvy.label.qstn" /><!-- 문항 -->${srvyppr.srvySeqno }-${qstn.qstnSeqno }</b></p>
	                                            <div class="flex-1 tal">${fn:escapeXml(qstn.qstnTtl) }</div>
	                                        </div>
	                                    </div>

	                                    <div class="q_cont padding-top-5 padding-bottom-5">
	                                    	<c:choose>
												<c:when test="${fn:startsWith(fn:trim(qstn.qstnCts), '<div class=\"se-contents\"')}">
													<pre>${qstn.qstnCts }</pre>
												</c:when>
												<c:otherwise>
													<p>${qstn.qstnCts }</p>
												</c:otherwise>
											</c:choose>
											<!-- 단일선택형, 다중선택형, OX선택형 -->
											<c:if test="${qstn.qstnRspnsTycd eq 'ONE_CHC' || qstn.qstnRspnsTycd eq 'MLT_CHC' || qstn.qstnRspnsTycd eq 'OX_CHC' }">
												<div class="scoreChart_wrap align-items-center">
													<div class="left_chart">
		                                                <ol class="list_rect">
															<c:forEach var="rspns" items="${chcRspnsList }">
																<c:if test="${qstn.srvyQstnId eq rspns.srvyQstnId }">
																	<li class="flex-item margin-bottom-3">
																		<span class="${colorList[rspns.vwitmSeqno-1].title }"></span>
																		<c:choose>
																			<c:when test="${rspns.vwitmCts eq 'ETC' && rspns.etcInptyn eq 'Y' }">
																				<spring:message code="resh.label.etc" />
																			</c:when>
																			<c:otherwise>
																				${fn:escapeXml(rspns.vwitmCts)}
																			</c:otherwise>
																		</c:choose>
																	</li>
																</c:if>
															</c:forEach>
		                                                </ol>
		                                            </div>

		                                            <!-- chart.js -->
		                                             <div class="right_chart">
		                                                <div class="chart-container" style="height: 250px; position: relative;">
		                                                    <canvas id="doughnut${srvyppr.srvySeqno }_${qstn.qstnSeqno }"></canvas>
		                                                    <script>
			                                                    var labelArray = [];
														    	var colorArray = [];
														    	var dataArray  = [];
														    	<c:forEach var="rspns" items="${chcRspnsList}">
														    		<c:if test="${qstn.srvyQstnId eq rspns.srvyQstnId }">
															    		<c:set var="etc"><spring:message code="resh.label.etc" /></c:set>
													            		labelArray.push("${rspns.vwitmCts eq 'ETC' && rspns.etcInptyn eq 'Y' ? etc : fn:escapeXml(rspns.vwitmCts)}");
													            		colorArray.push("${colorList[rspns.vwitmSeqno-1].code}");
													            		dataArray.push("${rspns.joinCnt}");
														    		</c:if>
												            	</c:forEach>
														        var ctx = document.getElementById("doughnut${srvyppr.srvySeqno }_${qstn.qstnSeqno}");
														        var myChart = new Chart(ctx, {
														            type: 'doughnut',
														            data: {
															            labels: labelArray,
															            datasets: [{
															                data: dataArray,
															                backgroundColor: colorArray,
															                borderWidth:1
															            }]
														            },
														            options: {
														            	responsive: true,
														                maintainAspectRatio: false,

														                plugins: {
														                    legend: {
														                        position:'bottom',
														                        labels: {
														                            usePointStyle: true,
														                            pointStyle: 'rect',

														                        font: {
														                                size: 16,
														                            },
														                        },
														                    },
														                    title: {
														                        display: false,
														                    },
														                    datalabels: {
														                        color: '#fff',
														                        font: { weight: 'bold', size: 14 },
														                        formatter: (value, context) => {
														                            const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
														                            return (value / total * 100).toFixed(1) + '%';
														                        }
														                    }
														                }
														            },
														            plugins: [ChartDataLabels]
														        });
		                                                    </script>
		                                                </div>
		                                             </div>
		                                            <!-- //chart.js -->
		                                        </div>
											</c:if>
											<!-- 레벨형 -->
											<c:if test="${qstn.qstnRspnsTycd eq 'LEVEL' }">
												<div class="table-wrap margin-3">
									                <table class="table-type2">
									                    <colgroup>
									                        <col style="">
									                        <c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
									                        	<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
										                        	<c:set var="wPer" value="${fn:length(srvyQstnVwitmLvlList) eq 3 ? '15' : '10' }" />
										                        	<col style="width:${wPer}%">
									                        	</c:if>
									                        </c:forEach>
									                    </colgroup>
									                    <thead>
									                        <tr>
									                            <th class="text-left"><spring:message code="srvy.label.qstn" /><!-- 문항 --></th>
									                            <c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
									                            	<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
											                            <th>${lvl.lvlCts }</th>
									                            	</c:if>
									                            </c:forEach>
									                        </tr>
									                    </thead>
									                    <tbody>
									                    	<c:forEach var="vwitm" items="${srvyVwitmList }">
																<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
											                        <tr>
											                        	<td class="text-left">${vwitm.vwitmCts }</td>
											                        	<c:forEach var="rspns" items="${levelRspnsList }">
											                        		<c:if test="${qstn.srvyQstnId eq rspns.srvyQstnId && vwitm.srvyVwitmId eq rspns.srvyVwitmId }">
											                        			<td>${rspns.ratio }%</td>
											                        		</c:if>
											                        	</c:forEach>
											                        </tr>
																</c:if>
															</c:forEach>
									                    </tbody>
									                </table>
									            </div>
											</c:if>
											<!-- 서술형 -->
											<c:if test="${qstn.qstnRspnsTycd eq 'LONG_TEXT' }">
												<c:if test="${fn:length(textRspnsList) > 0 }">
													<table class="table-type2">
														<colgroup>
															<col class="width-20per" />
															<col class="" />
														</colgroup>
														<tbody>
															<c:forEach var="rspns" items="${textRspnsList }">
																<c:if test="${qstn.srvyQstnId eq rspns.srvyQstnId }">
																	<tr>
																		<th>${rspns.usernm }</th>
																		<td class="t_left">${rspns.rspns }</td>
																	</tr>
																</c:if>
															</c:forEach>
														</tbody>
													</table>
												</c:if>
											</c:if>
	                                    </div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
				</c:forEach>
			</div>

            <div class="modal_btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
