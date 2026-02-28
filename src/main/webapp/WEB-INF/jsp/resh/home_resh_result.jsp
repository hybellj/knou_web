<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		reshCommon.statusChartSet('status');
		reshCommon.statusChartSet('device');
	});
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content">
        	<div class="ui form">
        		<div class="layout2">
		        	<div id="info-item-box">
		        		<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="resh.label.home.resh" /><!-- 전체 설문 -->
                        </h2>
		            </div>
		            <div class="row">
		            	<div class="col">
				            <p class="f110 ml50 mb40"><spring:message code="resh.label.home.resh.info" /></p><!-- 전체 설문 참여 및 결과 확인이 가능합니다. -->
				            <div class="ui form m10 p10">
								<h3 class="sec_head"><spring:message code="resh.label.status.submit" /></h3><!-- 제출 현황 -->
								<div class="ui segment">
									<div class="ui stackable equal width grid">
										<div class="column">
								            <canvas id="statPieChart" class="chart_wm350" height="250"></canvas>
								        </div>
										<div class="column">
								            <canvas id="devicePieChart" class="chart_wm350" height="250"></canvas>
								        </div>
								    </div>
								</div>
							</div>
				            
				        	<c:forEach var="pageList" items="${reschAnswerList }">
						    	<div class="ui form m10 p10">
							       <h3 class="page-title">${pageList.reschPageOdr }/${fn:length(reschAnswerList) } <spring:message code="resh.label.page" /></h3><!-- 페이지 -->
									<c:forEach var="qstnList" items="${pageList.reschQstnList }">
										<div class="ui card wmax">
											<c:if test="${qstnList.reschQstnTypeCd eq 'SINGLE' || qstnList.reschQstnTypeCd eq 'MULTI' || qstnList.reschQstnTypeCd eq 'OX' }">
												<div class="fields content">
													<div class="field p_w70">
														<p>${pageList.reschPageOdr }-${qstnList.reschQstnOdr } ${qstnList.reschQstnTitle }</p>
														<ul>
															<c:forEach var="qstnItemList" items="${qstnList.reschAnswerList }" varStatus="itemStatus">
																<li class="m10">
																	<label class="mr10 w20 d-inline-block ${colorList[itemStatus.index].title }" style="height:20px;"></label>
																	<c:choose>
																	    <c:when test="${qstnItemList.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'}">
																	    	<spring:message code="resh.label.etc" />
																	    </c:when>
																	    <c:otherwise>
																	        ${fn:escapeXml(qstnItemList.reschQstnItemTitle)}
																	    </c:otherwise>
																	</c:choose>
																</li>
															</c:forEach>
														</ul>
													</div>
													<div class="field p_w30">
														<div class="column">
												            <canvas id="pieChart${pageList.reschPageOdr }_${qstnList.reschQstnOdr }" height="200" style="max-width:250px;margin:auto;"></canvas>
												            <script>
												            	var labelArray = [];
												            	var colorArray = [];
												            	var dataArray  = [];
												            	<c:forEach var="itemList" items="${qstnList.reschAnswerList}" varStatus="itemStatus">
												            		<c:set var="etc"><spring:message code="resh.label.etc" /></c:set>
												            		labelArray.push("${itemList.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? etc : fn:escapeXml(itemList.reschQstnItemTitle)}");
												            		colorArray.push("${colorList[itemStatus.index].code}");
												            		dataArray.push("${itemList.joinCnt}");
										                    	</c:forEach>
												                var ctx = document.getElementById("pieChart${pageList.reschPageOdr }_${qstnList.reschQstnOdr}");
												                var myChart = new Chart(ctx, {
												                    type: 'pie',
												                    data: {
												                    labels: labelArray,
												                    datasets: [{
												                        backgroundColor: colorArray,
												                        borderWidth:1,
												                        data: dataArray
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
												                                                text: value + "<spring:message code='resh.label.nm' />",/* 명 */
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
												            </script>
												        </div>
													</div>
												</div>
											</c:if>
											<c:if test="${qstnList.reschQstnTypeCd eq 'SCALE' }">
												<div class="fields content">
									                <div class="field wf100">
									                    <span>${pageList.reschPageOdr }-${qstnList.reschQstnOdr }.</span> ${qstnList.reschQstnTitle }
									                </div>
									            </div>
									            <div class="content">
									                <table class="table">
									                	<thead>
									                		<tr>
									                			<th><span class="pl10"><spring:message code="resh.label.item" /></span></th><!-- 문항 -->
									                			<c:forEach var="scaleList" items="${qstnList.reschScaleList }">
									                  			<th class="tc">${scaleList.scaleTitle }</th>
									                			</c:forEach>
									                		</tr>
									                	</thead>
									                	<tbody>
									                		<c:forEach var="answerList" items="${qstnList.reschAnswerList }">
									                  		<tr>
									                  			<td class="tl">${answerList.reschQstnItemTitle }</td>
									                  			<c:forEach var="scaleItemList" begin="1" end="${fn:length(qstnList.reschScaleList) }" step="1">
									                   			<c:set var="ratio" value="ratio${scaleItemList}" />
									                  				<td class="tc">${answerList[ratio] }%</td>
									                  			</c:forEach>
									                  		</tr>
									                		</c:forEach>
									                	</tbody>
									                </table>
									            </div>
											</c:if>
											<c:if test="${qstnList.reschQstnTypeCd eq 'TEXT' }">
												<div class="fields content">
									                 <div class="field wf100">
									                     <span>${pageList.reschPageOdr }-${qstnList.reschQstnOdr }.</span> ${qstnList.reschQstnTitle }
									                 </div>
									            </div>
									            <div class="content">
													<c:forEach var="textList" items="${qstnList.reschAnswerList }">
														<div>
															${textList.rnum }. ${textList.etcOpinion }
														</div>
													</c:forEach>
									            </div>
											</c:if>
										</div>
									</c:forEach>
							     </div>
						    </c:forEach>
		            	</div>
		            </div>
        		</div>
        	</div>
        </div>
        <!-- //본문 content 부분 -->
    </div>
	<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
</body>
</html>