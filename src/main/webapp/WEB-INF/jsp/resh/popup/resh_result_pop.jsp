<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
		    <c:forEach var="pageList" items="${reschAnswerList }">
		    	<div class="ui form mt10">
			        <h2 class="page-title tc">${pageList.reschPageOdr }/${fn:length(reschAnswerList) } <spring:message code="resh.label.page" /></h2><!-- 페이지 -->
			        <pre>${pageList.reschPageArtl }</pre>
					<hr/>
					<c:forEach var="qstnList" items="${pageList.reschQstnList }">
						<div class="ui card wmax">
							<c:if test="${qstnList.reschQstnTypeCd eq 'SINGLE' || qstnList.reschQstnTypeCd eq 'MULTI' || qstnList.reschQstnTypeCd eq 'OX' }">
								<div class="fields content">
									<div class="field p_w70">
										<p>${pageList.reschPageOdr }-${qstnList.reschQstnOdr } ${qstnList.reschQstnTitle }</p>
										<pre>${qstnList.reschQstnCts }</pre>
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
								            <canvas id="pieChart${pageList.reschPageOdr }_${qstnList.reschQstnOdr }" class="chart_wm250" height="200"></canvas>
								            <script>
								            	var labelArray = [];
								            	var colorArray = [];
								            	var dataArray  = [];
								            	<c:forEach var="itemList" items="${qstnList.reschAnswerList}" varStatus="itemStatus">
								            		<c:set var="etc"><spring:message code="resh.label.etc" /></c:set>
								            		labelArray.push("${itemList.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? etc : fn:escapeXml(itemList.reschQstnItemTitle)}");	// 기타
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
					                    <pre>${qstnList.reschQstnCts }</pre>
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
					                	<pre>${qstnList.reschQstnCts }</pre>
					                </div>
					            </div>
					            <div class="content">
					            	<ul class="tbl type2 dt-sm">
										<c:forEach var="textList" items="${qstnList.reschAnswerList }">
											<li>
												<dl>
													<dt>${textList.userNm }</dt>
													<dd class="content_pre">${textList.etcOpinion }</dd>
												</dl>
											</li>
										</c:forEach>
									</ul>
					            </div>
							</c:if>
						</div>
					</c:forEach>
			     </div>
		    </c:forEach>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
