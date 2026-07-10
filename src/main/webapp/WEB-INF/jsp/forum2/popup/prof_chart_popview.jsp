<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="chart"/>
	</jsp:include>
	<script type="text/javascript">
		if (Chart && Chart.helpers && typeof Chart.helpers.getValueAtIndexOrDefault !== "function") {
			Chart.helpers.getValueAtIndexOrDefault = function(value, index, defaultValue) {
				if (Array.isArray(value)) {
					return typeof value[index] !== "undefined" ? value[index] : defaultValue;
				}

				return typeof value !== "undefined" ? value : defaultValue;
			};
		}

		function createForumChartLegendLabels(chart) {
			var data = chart.data;

			if (!(data.labels.length && data.datasets.length)) {
				return [];
			}

			return data.labels.map(function(label, i) {
				var meta = chart.getDatasetMeta(0);
				var ds = data.datasets[0];
				var fill = Array.isArray(ds.backgroundColor) ? ds.backgroundColor[i] : ds.backgroundColor;
				var stroke = Array.isArray(ds.borderColor) ? ds.borderColor[i] : ds.borderColor;
				var bw = Array.isArray(ds.borderWidth) ? ds.borderWidth[i] : ds.borderWidth;

				return {
					text: label + " : " + ds.data[i] + "<spring:message code='forum.label.person'/>",
					fillStyle: fill,
					strokeStyle: stroke,
					lineWidth: bw,
					hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
					index: i
				};
			});
		}

		function createForumPieChartOptions(titleText) {
			return {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					tooltip: {
						callbacks: {
							label: function(context) {
								return context.label + " : " + context.parsed + "<spring:message code='forum.label.person'/>";/*명*/
							}
						}
					},
					legend: {
						display: true,
						position: "bottom",
						labels: {
							boxWidth: 12,
							padding: 16,
							font: {
								size: 12
							},
							generateLabels: createForumChartLegendLabels
						}
					},
					title: {
						display: true,
						text: titleText,
						color: "#333",
						font: {
							size: 16
						},
						padding: {
							bottom: 14
						}
					},
					datalabels: {
						color: "#fff",
						font: {
							weight: "bold",
							size: 11
						},
						formatter: function(value, context) {
							var data = context.chart.data.datasets[0].data;
							var total = data.reduce(function(sum, current) {
								return Number(sum) + Number(current);
							}, 0);

							if (!total) {
								return "0%";
							}

							return (value / total * 100).toFixed(1) + "%";
						}
					}
				}
			};
		}

		// Pie chart
		function renderForumPieChart(labels, values, titleText) {
			var normalizedValues = (values || []).map(function(value) {
				var parsed = Number(value);
				return isNaN(parsed) ? 0 : parsed;
			});

			var currentChart = Chart.getChart("pieChart");

			if (currentChart) {
				currentChart.destroy();
			}

			return new Chart(document.getElementById("pieChart"), {
				type: "pie",
				data: {
					labels: labels,
					datasets: [{
						backgroundColor: [
							"#36a2eb",
							"#ff6384",
							"#ff9f40"
						],
						borderWidth: 1,
						data: normalizedValues
					}]
				},
				options: createForumPieChartOptions(titleText),
				plugins: [ChartDataLabels]
			});
		}

		// 찬반토론 차트
		function loadForumProsConsChart() {
			ajaxCall("/forum2/forumLect/ptcpSummaryChartAjax.do", {
				"dscsId": "${dscsVO.dscsId}",
				"sbjctId": "${dscsVO.sbjctId}"
			}, function(response) {
				if (response.result > 0 && response.returnVO) {
					renderForumPieChart(
							["<spring:message code='forum.label.pros'/>"/*찬성*/, "<spring:message code='forum.label.cons'/>"/*반대*/],
							[
								response.returnVO.dscsAtclPorsCnt || 0,
								response.returnVO.dscsAtclConsCnt || 0
							],
							"<spring:message code='forum.label.pros.cons.status'/> (%)"/*찬반 현황*/
					);
				} else {
					UiComm.showMessage(response.message, "error");
				}
			}, function() {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error");
			}, true);
		}

		// 성적 분포 현황 차트
		function renderForumBarChart() {
			var minScore = 0;
			var maxScore = 0;
			var avgScore = 0;

			if ("${dscsVO.dscsUnitTycd}" == "TEAM") {
				$.ajax({
					type: "post",
					url: "/forum2/forumLect/scoreSummaryChartAjax.do",
					async: false,
					dataType: "json",
					data: {
						"dscsId": "${dscsVO.dscsId}"
					},
					error: function() {
						UiComm.showMessage("<spring:message code='forum.alert.team.count.select_fail'/>", "error");
					},
					success: function(data) {
						var returnVO = data.returnVO;

						if (returnVO) {
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

			var currentChart = Chart.getChart("barChart");

			if (currentChart) {
				currentChart.destroy();
			}

			new Chart(document.getElementById("barChart"), {
				type: "bar",
				data: {
					labels: [
						"<spring:message code='forum.label.avg.score'/>",/*평균점수*/
						"<spring:message code='forum.label.max.score'/>",/*최고점수*/
						"<spring:message code='forum.label.min.score'/>"/*최저점수*/
					],
					datasets: [{
						data: [avgScore, maxScore, minScore],
						backgroundColor: [
							"rgba(75, 192, 192, .6)",
							"rgba(54, 162, 235, .6)",
							"rgba(255, 99, 132, .6)"
						],
						borderWidth: 1,
						barThickness: 30,
						borderRadius: 6
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					plugins: {
						tooltip: {
							enabled: false
						},
						legend: {
							display: false
						},
						title: {
							display: true,
							text: "<spring:message code='forum.label.score.chart.status'/>",/*성적 분포 현황*/
							color: "#333",
							font: {
								size: 16
							},
							padding: {
								bottom: 14
							}
						},
						datalabels: {
							anchor: "end",
							align: "top",
							offset: -2,
							color: "#666",
							font: {
								weight: "bold",
								size: 11
							},
							formatter: function(value) {
								return value;
							}
						}
					},
					scales: {
						y: {
							min: 0,
							max: 100,
							ticks: {
								color: "#666",
								font: {
									size: 12
								},
								stepSize: 20,
								callback: function(value) {
									return value + "<spring:message code='forum.label.point'/>";/*점*/
								}
							}
						},
						x: {
							grid: {
								display: false
							},
							ticks: {
								color: "#666",
								font: {
									size: 12
								}
							}
						}
					}
				},
				plugins: [ChartDataLabels]
			});
		}

		function isForumNotJoinStatus(item) {
			var joinStatus = (item && item.joinStatus ? item.joinStatus : "").toString();
			var joinStatusCd = (item && item.joinStatusCd ? item.joinStatusCd : "").toString().toUpperCase();

			return joinStatusCd === "NOTJOIN" || joinStatus === "\uBBF8\uCC38\uC5EC";
		}

		function loadForumJoinChart() {
			var data = {
				"dscsId": "${dscsVO.dscsId}",
				"sbjctId": "${dscsVO.sbjctId}",
				"teamId": ($("[name='teamId']").val() || "${dscsVO.teamId}"),
				"dscsUnitTycd": "${dscsVO.dscsUnitTycd}",
				"pageIndex": 1
			};

			ajaxCall("/forum2/forumLect/dscsJoinUserList.do", data, function(response) {
				if (response.result > 0) {
					var joinStatusY = 0;
					var joinStatusN = 0;

					(response.returnList || []).forEach(function(item) {
						if (isForumNotJoinStatus(item)) {
							joinStatusN++;
						} else {
							joinStatusY++;
						}
					});

					renderForumPieChart(
							["<spring:message code='forum.label.submit.y'/>"/*제출*/, "<spring:message code='forum.label.submit.n'/>"/*미제출*/],
							[joinStatusY, joinStatusN],
							"<spring:message code='forum.label.partici.statistic'/> (%)"/*토론 참여 현황*/
					);
				} else {
					UiComm.showMessage(response.message, "error");
				}
			}, function() {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error");
			}, true);
		}

		// chart 데이터 로드
		function refreshForumChartModal() {
			if ("${dscsVO.oknokStngyn}" == "Y") {
				loadForumProsConsChart();
			} else {
				loadForumJoinChart();
			}

			renderForumBarChart();
		}

		// chart 닫기
		function closeForumChartView() {
			if (window.parent && typeof window.parent.closeDialog === "function") {
				window.parent.closeDialog();
			} else {
				window.close();
			}
		}

		$(document).ready(function() {
			refreshForumChartModal();
		});
	</script>
	<style type="text/css">
		.chart-table {
			width: 100%;
			table-layout: fixed;
			border-collapse: separate;
			border-spacing: 24px 0;
			margin: 0 -12px;
		}

		.chart-table .chart-cell {
			width: 50%;
			vertical-align: top;
			padding: 0 12px;
		}

		.chart-table .chart-container {
			width: 100%;
			height: 250px;
		}

		.chart-table canvas {
			display: block;
			width: 100% !important;
			height: 100% !important;
		}
	</style>
</head>
<body class="modal-page ${uiex:getTheme()}">
	<div id="wrap" class="flex flex-column">
		<div class="board_top">
			<h3 class="board-title"><spring:message code="forum.label.partici.statistic" /></h3>
		</div>
		<div class="sub-box">
			<table class="chart-table">
				<tbody>
					<tr>
						<td class="chart-cell">
							<div class="chart-container">
								<canvas id="pieChart"></canvas>
							</div>
						</td>
						<td class="chart-cell">
							<div class="chart-container">
								<canvas id="barChart"></canvas>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btns">
			<button class="btn type2" onclick="closeForumChartView();"><spring:message code="forum.button.close" /></button>
		</div>
	</div>
</body>
</html>
