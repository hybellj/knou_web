<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script type="text/javascript" src="/webdoc/js/chart.min.js"></script>
<script type="text/javascript" src="/webdoc/js/Chart.PieceLabel.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
	// dialog 닫기
	window.closeDialog = function() {
		dialog.close();
	};

	// 성적 통계 pie 차트
	function scorePieChart(completeCnt, noTkexamCnt) {
		var ctx = document.getElementById("pieChart");
        var myChart = new Chart(ctx, {
            type: 'pie',
            data: {
            labels: ["<spring:message code='exam.label.submit.y' />", "<spring:message code='exam.label.submit.n' />"],/* 제출 *//* 미제출 */
            datasets: [{
                backgroundColor: [
                    '#36a2eb',
                    '#ff6384'
                ],
                borderWidth:1,
                data: [completeCnt, noTkexamCnt]
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
                text: "<spring:message code='exam.label.exam' /> <spring:message code='exam.label.submit.status' /> (%)",/* 시험 *//* 참여현황 */
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
	}

	// 성적 통계 bar 차트
	function scoreBarChart(avgScore, maxScore, minScore) {
		var ctx = document.getElementById("barChart");
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ["<spring:message code='exam.label.avg' />", "<spring:message code='exam.label.max' />", "<spring:message code='exam.label.min' />"],/* 평균 *//* 최고 *//* 최저 */
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
                events: false,
                showTooltips: false,
                title: {
                display: true,
                text: "<spring:message code='exam.label.dev.score.status' />",/* 성적 분포 현황 */
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
                            ctx.fillStyle = '#fff';
                            ctx.fillText(dataset.data[i], model.x, model.y);
                        }
                    });
                }},
                scales: {
                    yAxes: [{
                        ticks: {
                            min: 0,
                            max: 100,
                            stepSize: 20,
                            callback: function(value){return value+ "<spring:message code='exam.label.score.point' />"}/* 점 */
                        },
                        scaleLabel: {
                            display: true
                        }
                    }],
                    xAxes: [{
                        barPercentage: 0.6
                    }]
                },
                legend: {
                    display: false
                }
            }
        });
	}

	// 페이지 이동
	function submitForm(action, kvArr){
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
	};
</script>