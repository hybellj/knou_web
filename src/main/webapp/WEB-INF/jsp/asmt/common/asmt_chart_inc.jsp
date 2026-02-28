<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">
	// 원형차트
	function makePieChart(cTitle, cLabel, cData){
        var ctx = document.getElementById("pieChart");
        var myChart = new Chart(ctx, {
            type: 'pie',
            data: {
            labels: cLabel,
            datasets: [{
                backgroundColor: [
                    '#36a2eb',
                    '#ff6384'
                ],
                borderWidth:1,
                data: cData
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
                text: cTitle,
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
                                        text: label + " : " + value + "<spring:message code='asmnt.label.person'/>",
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

	// 막대차트
	function makeBarChart(cTitle, cLabel, cData){
		var ctx = document.getElementById("barChart");
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: cLabel,
                datasets: [{
                    data: cData,
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
	                text: cTitle,
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
                            ctx.fillText(dataset.data[i], model.x, model.y + 20);
                        }
                    });
                }},
                scales: {
                    yAxes: [{
                        ticks: {
                            min: 0,
                            max: 100,
                            stepSize: 20,
                            callback: function(value){return value+ "<spring:message code='asmnt.label.point' />"}
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
</script>