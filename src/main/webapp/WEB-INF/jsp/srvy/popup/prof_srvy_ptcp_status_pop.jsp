<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <script type="text/javascript">
    	$(document).ready(function() {
    		reshCommon.statusChartSet('status');
    		reshCommon.statusChartSet('device');
    	});

    	/**
		* 설문 팀 선택
		* @param {String}  srvyId - 선택 팀에 대한 설문아이디
		*/
	 	function srvyTeamSelect(srvyId) {
			var data = "upSrvyId=${vo.srvyId}&srvyId="+srvyId+"&sbjctId=${vo.sbjctId}";

			window.parent.$(".ui-dialog:visible iframe").last().attr("src", "/srvy/profSrvyPtcpStatusPopup.do?"+data);
	 	}
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page">
        <div id="wrap">
        	<c:if test="${vo.srvyGbn eq 'SRVY_TEAM' }">
				<div class="top-content margin-bottom-3">
					<c:forEach var="item" items="${srvyTeamList }">
						<button class="btn ${item.srvyId eq vo.subSrvyId ? 'type1' : 'type2' }" name="teamButton" value="${item.srvyId }" onclick="srvyTeamSelect('${item.srvyId }')">${item.teamnm }</button>
					</c:forEach>
				</div>
			</c:if>

			<div class="flex-item-center border-1 padding-3">
				<div>
					<canvas id="statPieChart" class="chart_wm350" height="100"></canvas>
				</div>
				<div>
					<canvas id="devicePieChart" class="chart_wm350" height="100"></canvas>
				</div>
			</div>

			<c:forEach var="srvyppr" items="${srvypprList }">
				<div class="board_top margin-top-3">
					<b>${srvyppr.srvySeqno }/${fn:length(srvypprList) }. ${srvyppr.srvyTtl }</b>
				</div>
				<c:forEach var="qstn" items="${srvyQstnList }">
					<c:if test="${srvyppr.srvypprId eq qstn.srvypprId }">
						<div class="border-1 padding-3 margin-top-3">
							<span>${srvyppr.srvySeqno }-${qstn.qstnSeqno }. ${qstn.qstnTtl }</span>
							<pre>${qstn.qstnCts }</pre>
							<div class="padding-3 board_top">
								<!-- 단일선택형, 다중선택형, OX선택형 -->
								<c:if test="${qstn.qstnRspnsTycd eq 'ONE_CHC' || qstn.qstnRspnsTycd eq 'MLT_CHC' || qstn.qstnRspnsTycd eq 'OX_CHC' }">
									<div>
										<ul>
											<c:forEach var="rspns" items="${srvyChcQstnRspnsStatusList }">
												<c:if test="${qstn.srvyQstnId eq rspns.srvyQstnId }">
													<li class="flex-item margin-bottom-3">
														<label class="mr10 w20 ${colorList[rspns.vwitmSeqno-1].title }" style="height:20px;"></label>
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
										</ul>
									</div>
									<div class="right-area">
										<canvas id="pieChart${srvyppr.srvySeqno }_${qstn.qstnSeqno }" class="chart_wm250" height="200"></canvas>
										<script>
									    	var labelArray = [];
									    	var colorArray = [];
									    	var dataArray  = [];
									    	<c:forEach var="rspns" items="${srvyChcQstnRspnsStatusList}">
									    		<c:if test="${qstn.srvyQstnId eq rspns.srvyQstnId }">
										    		<c:set var="etc"><spring:message code="resh.label.etc" /></c:set>
								            		labelArray.push("${rspns.vwitmCts eq 'ETC' && rspns.etcInptyn eq 'Y' ? etc : fn:escapeXml(rspns.vwitmCts)}");
								            		colorArray.push("${colorList[rspns.vwitmSeqno-1].code}");
								            		dataArray.push("${rspns.joinCnt}");
									    		</c:if>
							            	</c:forEach>
									        var ctx = document.getElementById("pieChart${srvyppr.srvySeqno }_${qstn.qstnSeqno}");
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
						                            <th class="text-left">문항</th>
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
								                        	<c:forEach var="rspns" items="${srvyLevelQstnRspnsStatusList }">
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
									<c:if test="${fn:length(srvyTextQstnRspnsStatusList) > 0 }">
										<table class="table-type2">
											<colgroup>
												<col class="width-20per" />
												<col class="" />
											</colgroup>
											<tbody>
												<c:forEach var="rspns" items="${srvyTextQstnRspnsStatusList }">
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
					</c:if>
				</c:forEach>
			</c:forEach>

            <div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
