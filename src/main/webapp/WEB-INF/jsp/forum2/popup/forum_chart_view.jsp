<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/forum_common_inc.jsp" %>
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
		listForumUser();
		scoreChartSet();
	});

	// 참여자 리스트 조회
	function listForumUser(page) {
		var url  = "/forum2/forumLect/forumJoinUserList.do";

		var data = {
			"forumCd" 	  : "${forumVo.forumCd}",
			"crsCreCd"	  : "${forumVo.crsCreCd}",
			"teamCd"	  : $("#teamCd").val(),
			"forumCtgrCd"     : "${forumVo.forumCtgrCd}",
			"byteamDscsUseyn" : "${forumVo.byteamDscsUseyn}",
			"pageIndex"   : page,
			"listScale"   : $("#listScale").val(),
			"searchKey"   : $("#searchKey").val(),
			"searchValue" : $("#searchValue").val(),
			"searchLeng"  : $("#searchLeng").val()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var html = "";
				var joinStatusY = 0;
				var joinStatusN = 0;

				data.returnList.forEach(function(v, i) {

					if(v.joinStatus == "미참여") {
						joinStatusN++;
					} else {
						joinStatusY++;
					}
				});

				if("${forumVo.prosConsForumCfg}" == 'N') {
					forumChartSet(joinStatusY, joinStatusN);
				}
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
		}, true);
	}

	// 토론 참여 현황 차트
	function forumChartSet(joinStatusY, joinStatusN) {
		var ctx = document.getElementById("pieChart");
		var myChart = new Chart(ctx, {
			type: 'pie',
			data: {
				labels: ["<spring:message code='forum.label.join'/>", "<spring:message code='forum.label.not.join'/>"], // 참여, 미참여
				datasets: [{
					backgroundColor: [
						'#36a2eb',
						'#ff6384',
						'#ff9f40'
					],
					borderWidth:1,
					data: [joinStatusY, joinStatusN]
				}]
			},

			options: {
				pieceLabel: {
					render: function (args) {
						return args.percentage + '%';
					},
					//precision: 2,
					fontColor : '#fff'
				},
				title: {
					display: true,
					text: "<spring:message code='forum.label.partici.statistic'/> (%)", // 토론 참여 현황
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

									// We get the value of the current label
									var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];

									return {
										// Instead of `text: label,`
										// We add the value to the string
										text: label + " : " + value + "<spring:message code='forum.label.person'/>", // 명
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
	}

	// 성적 통계 차트
	function scoreChartSet() {
		var minScore = 0;
		var maxScore = 0;
		var avgScore = 0;

		if("${forumVo.forumCtgrCd}" == "TEAM") {
			$.ajax({
				type: "post",
				// url: "/team/teamHome/viewScoreChart.do",
				url: "/forum2/forumLect/viewScoreChart.do",
				async: false,
				dataType: "json",
				data: {
					// "teamCtgrCd" : $("#teamCtgrCd").val(),
					"forumCd" : "${forumVo.forumCd}",
				},
				error: function(data) {
					alert("<spring:message code='forum.alert.team.count.select_fail'/>"); // 팀 수를 조회하는 데에 실패하였습니다. 다시 시도해주시기 바랍니다.
					return false;
				},
				success: function(data) {
					var returnVO = data.returnVO;

					if(returnVO == null) {
						minScore = 0;
						maxScore = 0;
						avgScore = 0;
					} else {
						minScore = returnVO.minScore;
						maxScore = returnVO.maxScore;
						avgScore = returnVO.avgScore;
					}
				}
			});
		} else {
			minScore = "${minScore}";
			maxScore = "${maxScore}";
			avgScore = "${avgScore}";
		}

		var ctx = document.getElementById("barChart");
		var ctx = document.getElementById("barChart");
		var myChart = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: ["<spring:message code='forum.label.avg.score'/>", "<spring:message code='forum.label.max.score'/>", "<spring:message code='forum.label.min.score'/>"],
				datasets: [{
					data: [avgScore, maxScore, minScore],
					backgroundColor: [
						'rgba(75, 192, 192, .6)',
						'rgba(54, 162, 235, .6)',
						'rgba(255, 99, 132, .6)'
					],
					borderWidth: 1
				}]
			},
			options: {
				// events: false 대신 빈 배열 사용
				events: [],
				plugins: {
					tooltip: { enabled: false }, // showTooltips 대신 사용
					legend: { display: false },
					title: {
						display: true,
						text: '<spring:message code="forum.label.score.chart.status"/>',
						color: "#666",
						font: { size: 14 }
					}
				},
				animation: {
					duration: 1000,
					onComplete: function () {
						var chartInstance = this;
						var ctx = chartInstance.ctx;
						ctx.textAlign = 'center';
						ctx.textBaseline = 'bottom';
						ctx.font = 'normal 12px sans-serif'; // 폰트 설정

						chartInstance.data.datasets.forEach(function (dataset, i) {
							var meta = chartInstance.getDatasetMeta(i);
							meta.data.forEach(function (bar, index) {
								var data = dataset.data[index];
								ctx.fillStyle = '#fff'; // 숫자 색상
								// bar.x, bar.y로 위치 직접 접근 (v4 방식)
								ctx.fillText(data, bar.x, bar.y + 20);
							});
						});
					}
				},
				scales: {
					y: { // yAxes -> y 로 변경
						min: 0,
						max: 100,
						ticks: {
							stepSize: 20,
							callback: function(value) { return value + "<spring:message code='forum.label.point'/>" }
						}
					},
					x: { // xAxes -> x 로 변경
						grid: { display: false }
					}
				}
			}
		});
	}
	</script>

	<form id="forumUploadForm" name="forumUploadForm" method="POST">
        <input type="hidden" name="forumCd" value="${vo.forumCd}" />
        <input type="hidden" name="crsCreCd" value="${vo.crsCreCd}"/>
        <input type="hidden" name="forumCtgrCd" value="${vo.forumCtgrCd}"/>
        <input type="hidden" name="excelGrid" value="" id="excelGrid"/>
    </form>

	<body class="modal-page">
		<div id="wrap" class="flex flex-column">
			<div class="ui form" style="height:auto;">
				<div class="ui segment" style="height:100%;">
					<p><spring:message code="forum.label.forum.status" /> <!-- 토론 현황 -->
					<table style="width:100%; table-layout:fixed;"><tr>
						<td style="width:50%; vertical-align:top; padding:4px;">
							<c:if test="${forumVo.prosConsForumCfg eq 'Y'}">
								<canvas id="pieChart" height="250"></canvas>
								<script>
									var ctx = document.getElementById("pieChart");
									var myChart = new Chart(ctx, {
										type: 'pie',
										data: {
											labels: ["<spring:message code='forum.label.pros'/>", "<spring:message code='forum.label.cons'/>"], // 찬성, 반대
											datasets: [{
												backgroundColor: [
													'#36a2eb',
													'#ff6384',
													'#ff9f40'
												],
												borderWidth:1,
												data: ["${forumVo.forumAtclPorsCnt}", "${forumVo.forumAtclConsCnt}"]
											}]
										},
										options: {
											pieceLabel: {
												render: function (args) {
													return args.percentage + '%';
												},
												//precision: 2,
												fontColor : '#fff'
											},
											title: {
												display: true,
												text: "<spring:message code='forum.label.pros.cons.status'/> (%)", // 찬반 현황
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

																// We get the value of the current label
																var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];

																return {
																	// Instead of `text: label,`
																	// We add the value to the string
																	text: label + " : " + value + "<spring:message code='forum.label.person'/>", // 명
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
							</c:if>
							<c:if test="${forumVo.prosConsForumCfg eq 'N'}">
								<canvas id="pieChart" height="250"></canvas>
							</c:if>
						</td>
						<td style="width:50%; vertical-align:top; padding:4px;">
							<canvas id="barChart" height="250"></canvas>
						</td>
					</tr></table>
				</div>
			</div>
			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="forum.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
<%--		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>--%>
	</body>
	
	<!-- 엑셀 샘플 -->
    <%--<iframe width="100%" scrolling="no" id="forumpleExcelDownloadIfm" name="forumpleExcelDownloadIfm" style="display: none;"></iframe>--%>
</html>
