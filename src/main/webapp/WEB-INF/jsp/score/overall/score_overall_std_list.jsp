<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		$(function() {
			getScore();
		});
		
		function getScore() {
			var lectEvalYn = "${lectEvalYn}";
			
			if(lectEvalYn == "Y") {
				checkLectEvalApi().done(function(isComplete) {
					if(isComplete) {
						var url  = "/score/scoreOverall/selectStdCourseScore.do";
						var param = {
							crsCreCd: "${crsCreCd}"
						};
						
						ajaxCall(url, param, function(data) {
							if (data.result > 0) {
								var returnVO = data.returnVO;
								var stdInfo = returnVO.stdInfo;
								var avgScoreInfo = returnVO.avgScoreInfo;
								var chartScoreList = returnVO.chartScoreList;
								
								var totScore = stdInfo.totScore || '-';
								var scoreGrade = stdInfo.scoreGrade || '-';
								var finalScore = stdInfo.finalScore || '-';
								
								var avgScore = avgScoreInfo.avgScore || "0";
								var getScore = avgScoreInfo.getScore || "0";
								
								setScore(totScore, scoreGrade, finalScore);
								setChart(avgScore, getScore);
								//setChart2(chartScoreList);
								alert("totScore====>"+totScore);
								$("#totRed").html(totScore);
					        } else {
					        	setEmpty();
					        }
						}, function(xhr, status, error) {
							setEmpty();
						});
					} else {
						var evalHtml = '<i class="icon circle info"></i><spring:message code="score.label.lect.eval.oper.msg1" />'; // 강의평가 후 성적조회 가능합니다.
						evalHtml += '<a class="ui basic button small ml5 blinking-button" href="<c:out value="${lectEvalUrl}" />" target="_blank"><spring:message code="common.button.lect.eval" />'; // 강의평가
						
						$("#scoreObjtDiv").html(evalHtml).show();
						
						setInterval(function() {
							$(".blinking-button").toggleClass("basic");
							$(".blinking-button").toggleClass("red");
						}, 1000);
						
						setEmpty();
					}
				}).fail(function() {
					setEmpty();
				});
			} else {
				var url  = "/score/scoreOverall/selectStdCourseScore.do";
				var param = {
					crsCreCd: "${crsCreCd}"
				};
				
				ajaxCall(url, param, function(data) {
					if (data.result > 0) {
						var returnVO = data.returnVO;
						var stdInfo = returnVO.stdInfo || {};
						var avgScoreInfo = returnVO.avgScoreInfo || {};
						var chartScoreList = returnVO.chartScoreList || [];
						
						var totScore = stdInfo.totScore || '-';
						var scoreGrade = stdInfo.scoreGrade || '-';
						var finalScore = stdInfo.finalScore || '-';
						
						var avgScore = avgScoreInfo.avgScore || "0";
						var getScore = avgScoreInfo.getScore || "0";
						
						setScore(totScore, scoreGrade, finalScore);
						setChart(avgScore, getScore);
						//setChart2(chartScoreList);
						
						$("#totRed").html(totScore);
			        } else {
			        	setEmpty();
			        }
				}, function(xhr, status, error) {
					setEmpty();
				});
			}
		}
		
		function setEmpty() {
			setScore("-", "-", "-");
			setChart("0", "0");
			//setChart2();
			$("#totRed").html("-");
		}
		
		function setScore(totScore, scoreGrade, finalScore) {
			$("#totScore").html(totScore);
			$("#scoreGrade").html(scoreGrade);
			//$("#finalScore").html(finalScore);
		}
		
		function setChart(avgScore, getScore) {
			var ctx = document.getElementById("barChart");
            var labelText = new Array;
            var avgScoreText = new Array;
            var myScoreText = new Array;
            labelText.push("<spring:message code='crs.label.final.score' />");	// 최종성적
        	avgScoreText.push((avgScore*1).toFixed(2));
        	myScoreText.push((getScore*1).toFixed(2));
            
            var myChart = new Chart(ctx, {
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
                            var ctx = this.chart.ctx;
                            ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
                            ctx.fillStyle = this.chart.config.options.defaultFontColor;
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'bottom';
                            this.data.datasets.forEach(function (dataset) {
                                for (var i = 0; i < dataset.data.length; i++) {
                                    var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
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
		
		/*
		function setChart2(chartScoreList) {
			var chartScoreInfo = chartScoreList && chartScoreList[0];
			
			var score100 = chartScoreInfo && chartScoreInfo.score100 || 0;
			var score90 = chartScoreInfo && chartScoreInfo.score90 || 0;
			var score80 = chartScoreInfo && chartScoreInfo.score80 || 0;
			var score70 = chartScoreInfo && chartScoreInfo.score70 || 0;
			var score60 = chartScoreInfo && chartScoreInfo.score60 || 0;
			var score50 = chartScoreInfo && chartScoreInfo.score50 || 0;
			
			var ctx = document.getElementById("levelChart");
            var myChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                  labels: ["91~100", "81~90", "71~80", "61~70", "51~60", "<spring:message code='crs.score.less.than.fifty' />"],	// 50점 이하
                  datasets: [{
                    backgroundColor: [
                        '#9966ff',
                        '#36a2eb',
                        '#ff9f40',
                        '#ff6384',
                        '#4bc0c0',
                        '#999'
                    ],
                    borderWidth:1,
                    data: [score100
                	 , score90
                	 , score80
                	 , score70
                	 , score60
                	 , score50]
                  }]
                },

                options: {
                    pieceLabel: {
                      render: function (args) {
                        args // {value: 123, label: 'Something', percentage: 50 }
                        return args.percentage + '%';
                      },
                      //precision: 2,
                      fontColor : '#fff'
                    },
                    title: {
                      display: true,
                      text: '<spring:message code="common.page.final.score" /> <spring:message code="exam.label.status" /> (%)',	// 최종점수현황 %
                      fontSize: 14,
                      fontColor: "#666",
                    },
                    maintainAspectRatio: false,
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
                                            text: label + " : " + value + "<spring:message code='exam.label.nm' />",// 명
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
		*/
		
		// 강의평가 완료체크
		function checkLectEvalApi() {
			var deferred = $.Deferred();
			
			var lectEvalYn = '<c:out value="${lectEvalYn}" />';
			var userId = "<%=SessionInfo.getUserId(request)%>";
            var url = "<%=CommConst.ERP_API_LECT_EVAL_KEY%>" + userId + "/findLtApprUnRunLtCnt"; 
            
            var data = {};
     
           	$.ajax({
                url : url
                , type: "GET"
                //, data : data
                , beforeSend: function (xhr) {
                    xhr.setRequestHeader("Content-type","application/json");
                    xhr.setRequestHeader("ApiValue", "${langApiHeader}");
                }                
                , success: function (data) {
                	var isComplete = true;
                	
                	if (data.code == "1") {
						if (parseInt(data.result) > 0) {
							isComplete = false;
						}
					}
                	
                	deferred.resolve(isComplete);
                }
                , error: function (jqXHR) 
                { 
                    deferred.resolve(false);
                }
            });
           
            return deferred.promise();
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">									
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
        
		<div id="container">											
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            		
			<div class="content stu_section">							
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
            	
				<div class="ui form">
					<div class="layout2">

                        <div id="info-item-box">
                        	<script>
							$(document).ready(function () {
								// set location
								setLocationBar("<spring:message code='score.label.university.score' />" , "<spring:message code='common.check.grades' />");	// 종합성적, 성적조회
							});
							</script>
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16 mra">
								<spring:message code="common.check.grades" /><!-- 성적조회 -->
                            </h2>
                            <div class="button-area">
                            	<div class="ui info message mr10" id='scoreObjtDiv' style="display: none;">
                            		
			                    </div>
                                <!-- <a href="#0" class="ui basic button">목록</a> -->
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col">
                            	<!-- 종합성적 처리 -->
                                <div class="flex-item mt15">
                                	<b class="">
                                		<spring:message code="forum.label.record" /><!-- 성적 -->
                                	</b>
                                </div>
                                <ul class="tbl dt-sm">
			                        <li>
			                            <dl>
			                                <dt><spring:message code="crs.label.final.score" /></dt><!-- 최종성적 -->
			                                <dd id="totScore"></dd>
			                                <dt><spring:message code="crs.socre.grade" /></dt><!-- 성적등급 -->
			                                <dd id="scoreGrade"></dd>
			                                <%-- <dt><spring:message code="exam.label.total.score.point" /></dt><!-- 총점 -->
			                                <dd id="finalScore"></dd> --%>
			                            </dl>
			                        </li>
			                    </ul>
                                <div class="flex-item mt15">
                                	<b class="">
                                		<spring:message code="crs.title.score.present.condition" /><!-- 성적 현황 -->
                                	</b>
                                </div>
                                <div class="ui stackable grid mt0 mb0 p_w100">
                                    <div class="eight wide column pt0">
                                    	<div class="chart-container" style="height:350px;">
                                        	<canvas id="barChart"></canvas>
                                        </div>
                                    </div>
                                    <div class="eight wide column pt0 flex-item-center">
                                        <!-- <div class="chart-container" style="height:300px;">
                                            <canvas id="levelChart" ></canvas>
                                        </div> -->
                                        <p class="tc mt10 mb20 f170"><spring:message code="score.label.ect.eval.oper.msg5_1" /><span class="fcRed" id="totRed">-</span><spring:message code="score.label.ect.eval.oper.msg5_2" /></p><!-- 나의 최종점수는 점입니다. -->
                                    </div>                                    
                                </div>
							</div>
                    	</div>
                    </div>
		        </div><!-- //ui form -->
            </div><!-- //content -->
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div><!-- //container -->
    </div><!-- //pusher -->
</body>
</html>