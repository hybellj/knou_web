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
	</script>

	<body class="modal-page">
		<div class="sub-box">
	       	<div class="scoreChart_wrap">
	       		<div class="left_chart">
	       			<div class="chart-container" style="height: 250px;">
	                    	<canvas id="pieChart"></canvas>
	                    </div>
	                    <script>
	                        // PIE CHART용 데이터
	                        const pieData = {
	                            labels: ["<spring:message code='common.submission' />"/* 제출 */, "<spring:message code='common.not.submission' />"/* 미제출 */],
	                            datasets: [{
	                                data: ["${chartMap.completeCnt + chartMap.tempSaveCnt}", "${chartMap.noTkexamCnt }"],
	                                backgroundColor: [
	                                    'rgba(54, 162, 235, .8)',
	                                    'rgba(255, 99, 132, .8)'
	                                ],
	                                borderWidth: 1
	                            }]
	                        };

	                        // PIE CHART 설정
	                        const pieConfig = {
	                            type: 'pie',
	                            data: pieData,
	                            options: {
	                                responsive: true,
	                                maintainAspectRatio: false,
	                                plugins: {
	                                    legend: {
	                                        position: 'bottom',
	                                        labels: {
	                                            formatter: function(value, ctx) {
	                                                const index = ctx.dataIndex;
	                                                const dataset = ctx.dataset;
	                                                return `${ctx.label} : ${dataset.data[index]}<spring:message code="message.person" />`/* 명 */;
	                                            }
	                                        }
	                                    },
	                                    title: {
	                                        display: true,
	                                        text: "<spring:message code='quiz.label.quiz.submit.status' /> (%)",/* 퀴즈 제출상태 */
	                                        font: { size: 16 },
	                                        color: '#333'
	                                    },
	                                    datalabels: {
	                                        color: '#fff',
	                                        font: {
	                                            weight: 'bold',
	                                            size: 11
	                                        },
	                                        formatter: function(value, context) {
	                                            const data = context.chart.data.datasets[0].data;
	                                            const total = data.reduce((a, b) => a + b, 0);
	                                            const percent = (value / total * 100).toFixed(1);
	                                            return percent + '%';
	                                        }
	                                    }
	                                }
	                            },
	                            plugins: [ChartDataLabels]
	                        };

	                        // 생성
	                        new Chart(document.getElementById('pieChart'), pieConfig);
	                    </script>
	       		</div>
	       		<div class="right_chart">
	       			<div class="chart-container" style="height: 250px;">
	                    	<canvas id="barChart"></canvas>
	                    </div>
	                    <script>
	                        const barUtils = ChartUtils.init();
	                        const BAR_COUNT = 3;
	                        const NUMBER_BAR = {
	                            count: BAR_COUNT,
	                            min: 0,
	                            max: 100
	                        };
	                        const BarLabels = ["<spring:message code='common.label.average.score' />"/* 평균점수 */, "<spring:message code='common.label.highest.score' />"/* 최고점수 */, "<spring:message code='common.label.lowest.score' />"/* 최저점수 */];
	                        const barData = {
	                            labels: BarLabels,
	                            datasets: [{
	                                data: ["${chartMap.avgScore}", "${chartMap.maxScore}", "${chartMap.minScore}"],
	                                backgroundColor: [
	                                    'rgba(75, 192, 192, .6)',
	                                    'rgba(54, 162, 235, .6)',
	                                    'rgba(255, 99, 132, .6)'
	                                ],
	                                borderWidth: 1,
	                                barThickness: 30
	                            }]
	                        };
	                        const barConfig = {
	                            type: 'bar',
	                            data: barData,
	                            options: {
	                                responsive: true,
	                                maintainAspectRatio: false,
	                                plugins: {
	                                    legend: { display: false },
	                                    title: {
	                                        display: true,
	                                        text: "<spring:message code='quiz.label.dev.score.status' />",/* 성적 분포 현황 */
	                                        font: { size: 16 },
	                                        color: '#333'
	                                    },
	                                    datalabels: {
	                                        anchor: 'end',   // 막대 끝 기준
	                                        align: 'top',
	                                        offset: -2,
	                                        color: '#666',
	                                        font: {
	                                            weight: 'bold',
	                                            size: 11
	                                        },
	                                        formatter: function(value) {
	                                            return value; // 표시할 값
	                                        }
	                                    }
	                                },
	                                scales: {
	                                    y: {
	                                        ticks: { color: '#666', font: { size: 12 }, stepSize: 20 },
	                                        title: { display: true, text: "<spring:message code='common.score' />"/* 점수 */ }
	                                    },
	                                    x: {
	                                        ticks: { color: '#666', font: { size: 12 } },
	                                    }
	                                }
	                            },
	                            plugins: [ChartDataLabels] // datalabels 플러그인 활성화
	                        };
	                        new Chart(document.getElementById('barChart'), barConfig);
	                    </script>
	       			</div>
	       		</div>
	       	</div>

	        <div class="modal_btns">
	            <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
	        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
