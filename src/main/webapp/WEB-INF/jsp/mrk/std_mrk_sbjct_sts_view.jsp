<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="chart"/>
    </jsp:include>
</head>

<script type="text/javascript">
    const EPARAM = "${encParams}";

    $(function() {
        getScore();
    });

    function getScore() {

        let url = "/mrk/stdMrkSbjctStsSelectAjax.do"
        let param = {"encParams": EPARAM}

        $.ajax({
            url: url,
            type: "GET",
            data: param,
            success: function (data) {
                let returnVO = data.returnVO;

                let mrkDtlInfo = returnVO.stdMrkSbjctDtlInfo || {};
                let avgScrInfo = returnVO.avgScrInfoByMrkItm || {};
                let mrkRangeSts = returnVO.mrkRangeStatus || {};

                let totScr = mrkDtlInfo.totScr; // 산출 총점
                let lstScr = mrkDtlInfo.lstScr; // 최종 점수

                setScore(totScr, lstScr);
                setBarChart(avgScrInfo, mrkDtlInfo);
                setDoughnutChart(mrkRangeSts, lstScr);

                $("#totRed").html(lstScr);
            },
            error: function(xhr, status, error) {
                UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
            }
        });
    }

    // 최종점수&산출총점 표 세팅
    function setScore(totScr, lstScr) {
        $("#totScr").html(totScr);
        $("#lstScr").html(lstScr);
    }

    // Bar Chart 세팅
    function setBarChart(avgScrInfo, mrkDtlInfo) {
        // 1. 이미지처럼 여러 카테고리 데이터가 배열로 전달된다고 가정합니다.
        const mrkItemType = [
            "<spring:message code="dashboard.exam_mid"/>", /*중간고사*/
            "<spring:message code="dashboard.exam_end"/>", /*기말고사*/
            "<spring:message code="common.label.attendance"/>", /*출석*/
            "<spring:message code="common.label.asmnt"/>", /*과제*/
            "<spring:message code="common.label.discussion"/>", /*토론*/
            "<spring:message code="common.label.question"/>", /*퀴즈*/
            "<spring:message code="common.label.resh"/>", /*설문*/
            "<spring:message code="sch.seminar"/>" /*세미나*/
        ];
        const avgData = [
            avgScrInfo.MIDEXAM, avgScrInfo.LSTEXAM,
            avgScrInfo.ATNDC,  avgScrInfo.ASMT,
            avgScrInfo.DSCS, avgScrInfo.QUIZ,
            avgScrInfo.SRVY, avgScrInfo.SMNR ];

        const myData = [
            mrkDtlInfo.midexamDrvtnScr , mrkDtlInfo.lstexamDrvtnScr,
            mrkDtlInfo.atndDrvtnScr , mrkDtlInfo.asmtDrvtnScr,
            mrkDtlInfo.dscsDrvtnScr , mrkDtlInfo.quizDrvtnScr,
            mrkDtlInfo.srvyDrvtnScr , mrkDtlInfo.smnrDrvtnScr
        ];

        const ctx = document.getElementById("barChart");

        const myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: mrkItemType, // 성적항목 유형
                datasets: [{
                    label: '<spring:message code="crs.label.me" />', // 나
                    backgroundColor: "#26B99A",
                    borderWidth: 1,
                    data: myData // 학생 점수 배열
                }, {
                    label: '<spring:message code="exam.label.avg" />',	// 평균
                    backgroundColor: "rgba(0,0,0,.3)",
                    borderWidth: 1,
                    data: avgData // 평균 점수 배열
                }]
            },
            options: {
                indexAxis: 'y', // 가로 막대 차트로 변경
                maintainAspectRatio: false,
                plugins: {
                    legend: { // 범례
                        display: true,
                        position: 'bottom', // 범례 하단 배치
                        labels: { boxWidth: 20 }
                    },
                    title: { // 제목
                        display: true,
                        text: '<spring:message code="common.average.score" />',	// 평균점수
                        fontSize: 14,
                        fontColor: "#666"
                    },
                    datalabels: { // 차트막대 라벨
                        color: '#000000', // 텍스트 하얗게
                        anchor: 'end', // 막대 끝에 배치
                        align: 'end', // 막대 끝 기준 바깥으로 정렬
                        offset: 10, // 막대 끝과 텍스트 사이 간격
                        font: { size: 12, weight: 'bold' },
                        formatter: function(value) {
                            return value + '점'; // 값 뒤에 '점' 추가
                        }
                    }
                },
                scales: {
                    x: { // x축
                        min: 0,
                        max: 100,
                        ticks: {
                            stepSize: 20, // 구간 범위
                            callback: function(value) {
                                return value + "점";
                            }
                        }
                    },
                    y: { // y축
                        grid: {
                            display: true,
                        },
                        ticks: {
                            color: "#666"
                        }
                    }
                }
            },
            plugins: [ChartDataLabels] // 데이터 라벨 플러그인 활성화
        });
    }

    // Doughnut Chart 세팅
    function setDoughnutChart(mrkRangeSts, lstScr) {

        let score100 = mrkRangeSts.score100;
        let score90 = mrkRangeSts.score90;
        let score80 = mrkRangeSts.score80;
        let score70 = mrkRangeSts.score70;
        let score60 = mrkRangeSts.score60;
        let score50 = mrkRangeSts.score50;
        let stdCnt = mrkRangeSts.stdCount;

        let ctx = document.getElementById("levelChart");

        let myChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ["91~100", "81~90", "71~80", "61~70", "51~60", "<spring:message code='crs.score.less.than.fifty' />"],      // 50점 이하
                datasets: [{
                    backgroundColor: ['#9966ff', '#36a2eb', '#ff9f40', '#ff6384', '#4bc0c0', '#999'],
                    borderWidth: 1,
                    data: [score100, score90, score80, score70, score60, score50]
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    datalabels: {
                        color: '#fff',
                        formatter: function(value) {
                            // 전체 합계 대비 백분율 계산
                            let sum = stdCnt;
                            let percentage = sum === 0 ? 0 : ((value / sum) * 100).toFixed(1);
                            return percentage + '%';
                        },
                        font: { weight: 'bold' }
                    },
                    title: {
                        display: true,
                        text: '<spring:message code="common.page.final.score" /> <spring:message code="exam.label.status" /> (%)',	// 최종점수현황 %
                        color: "#666",
                        font: { size: 14 }
                    },
                    legend: { // 범례
                        display: true,
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            // 커스텀 라벨 생성 (라벨 옆에 '명'수 표시)
                            generateLabels: function(chart) {
                                const data = chart.data;
                                return data.labels.map((label, i) => {
                                    const meta = chart.getDatasetMeta(0);
                                    const style = meta.controller.getStyle(i);
                                    const value = data.datasets[0].data[i];

                                    return {
                                        text: label + " : " + value + "<spring:message code='exam.label.nm' />",
                                        fillStyle: style.backgroundColor,
                                        strokeStyle: style.borderColor,
                                        lineWidth: style.borderWidth,
                                        hidden: !chart.getDataVisibility(i),
                                        index: i
                                    };
                                });
                            }
                        }
                    }
                }
            },
            plugins: [ChartDataLabels] // 데이터 라벨 플러그인 활성화
        });
    }

    function setChart1(avgScore, getScore) {
        let ctx = document.getElementById("barChart");
        let labelText = new Array;
        let avgScoreText = new Array;
        let myScoreText = new Array;
        labelText.push("<spring:message code='crs.label.final.score' />");	// 최종성적
        avgScoreText.push((avgScore*1).toFixed(2));
        myScoreText.push((getScore*1).toFixed(2));

        let myChart = new Chart(ctx, {
            type: 'horizontalBar',
            data: {
                labels: labelText,
                datasets: [{
                    label: '<spring:message code="crs.label.me" />',		// 나
                    backgroundColor: "#26B99A",
                    borderWidth:1,
                    height:20,
                    data: myScoreText
                }, {
                    label: '<spring:message code="exam.label.avg" />',	// 평균
                    backgroundColor: "rgba(0,0,0,.3)",
                    borderWidth:1,
                    height:20,
                    data: avgScoreText
                }]
            },
            options: {
                events: false,
                showTooltips: false,
                title: {
                    display: true,
                    text: '<spring:message code="common.average.score" />',	// 평균점수
                    fontSize: 14,
                    fontColor: "#666",
                },
                maintainAspectRatio: false,
                animation: {
                    duration: 1000,
                    onComplete: function () {
                        // render the value of the chart above the bar
                        let ctx = this.chart.ctx;
                        ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
                        ctx.fillStyle = this.chart.config.options.defaultFontColor;
                        ctx.textAlign = 'center';
                        ctx.textBaseline = 'bottom';
                        this.data.datasets.forEach(function (dataset) {
                            for (let i = 0; i < dataset.data.length; i++) {
                                let model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
                                ctx.fillStyle = '#fff'; // label color
                                ctx.fillText(dataset.data[i] + '<spring:message code="exam.label.score.point" />', model.x - 20, model.y + 8);	// 점
                            }
                        });
                    }},
                scales: {
                    yAxes: [{
                        barPercentage: 0.8,
                        scaleLabel: {
                            display: true
                        }
                    }],
                    xAxes: [{
                        ticks: {
                            min: 0,
                            max: 100,
                            stepSize: 20,
                            callback: function(value){return value+ "<spring:message code='exam.label.score.point' />"}	// 점
                        }
                    }]
                },
                legend: {
                    display: true,
                    position: 'bottom',
                    labels: {
                        boxWidth: 12
                    }
                }
            }
        });
    }

</script>

<body class="class ${uiex:getTheme()}  ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
<div id="wrap" class="main">

    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
    <!-- //common header -->

    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
        <!-- //gnb -->

        <!-- 본문 content 부분 -->
        <div id="content" class="content-wrap common">
            <!-- class_sub_top -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
            <!-- //class_sub_top -->

            <div class="class_sub">
                <!-- class_info -->
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                <!-- //class_info -->

                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="listTab">
                            <ul>
                                <li class="select"><a href="#"><spring:message code="common.check.grades" /><!-- 성적조회 --></a></li>
                                <li><a href="/mrk/lec/stdMrkOjctAplyView.do?encParams=${encParams}"><spring:message code="common.label.score.objection.yn"/> <%--성적 이의 신청--%></a></li>
                            </ul>
                        </div>

                        <div class="alert alert-warning text-center" role="alert" style="background-color: #ffe38b;padding: 15px 0px;margin-bottom: 30px;">
                            <p>성적이의 신청기간 : <uiex:formatDate value="${taskSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${taskEdttm}" type="datetime2"/></p>
                        </div>

                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>최종점수</label></li>
                                <li id="lstScr"></li>
                                <li class="head"><label>산출 총점</label></li>
                                <li id="totScr"></li>
                            </ul>
                        </div>

                        <div class="table_list" style="margin-top: 20px;">
                            <ul class="list">
                                <li class="head" style="width: 100%"><label>성적 현황</label></li>
                            </ul>
                        </div>

                        <div style="display: flex">
                            <div style="flex: 1">
                                <div class="chart-container" style="height:400px;">
                                    <canvas id="barChart"></canvas>
                                </div>
                            </div>
                            <div style="flex: 1; justify-items: center;">
                                <div class="chart-container" style="height:350px;">
                                    <canvas id="levelChart" ></canvas>
                                </div>
                                <br/>
                                <p><spring:message code="score.label.ect.eval.oper.msg5_1" /><span class="fcRed" id="totRed">-</span><spring:message code="score.label.ect.eval.oper.msg5_2" /></p><!-- 나의 최종점수는 점입니다. -->
                            </div>
                        </div>


                    </div><!-- //sub-content -->
                </div><!-- //dashbord_sub -->
            </div><!-- // class_sub -->
        </div><!-- //content -->
    </main><!-- //container -->

</div><!-- //pusher -->
</body>
</html>