<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
   	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    <script type="text/javascript">
	    $(function(){
	    	var lessonTotCnt = Number("${lessonInfo.lessonTotCnt}");
	    	var absentCnt = Number("${lessonInfo.absentCnt}");
	    	var lateCnt = Number("${lessonInfo.lateCnt}");
	    	
	    	var baseScore = 100;
	    	var latePer = 0;
	    	
	    	switch (absentCnt) {
				case 0:
					baseScore = 100;
					break;
				case 1:
					baseScore = 80;
					break;
				case 2:
					baseScore = 70;
					break;
				case 3:
					baseScore = 60;
					break;
				default:
					baseScore = 0;
					break;
			}
	    	
	    	switch (lateCnt) {
				case 0:
					latePer = 0;
					break;
				case 2:
				case 3:
					latePer = 5;
					break;
				case 4:
				case 5:
					latePer = 10;
					break;
				case 6:
				case 7:
					latePer = 20;
					break;
				case 8:
				case 9:
					latePer = 30;
					break;
				case 10:
				case 11:
					latePer = 40;
					break;
				case 12:
				case 13:
					latePer = 50;
					break;
			}
	    	
	    	var lateScore = (baseScore/100) * latePer;
	    	var lessonCalScore = baseScore - lateScore;
	    	
	    	//$("#lessonCalScore").html(lessonCalScore);
	    });
	    
	    //메세지 보내기
	    function sendMsg() {
	    	var rcvUserInfoStr = "";
	
	    	rcvUserInfoStr += "${stdInfo.userId}";
			rcvUserInfoStr += ";" + "${stdInfo.userNm}";
			rcvUserInfoStr += ";" + "${stdInfo.userMobileNo}";
			rcvUserInfoStr += ";" + "${stdInfo.userEmail}";
	
	        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	
	        var form = document.alarmForm;
	        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.submit();
	    }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
        <div class="option-content gap4 ">
            <div class="sec_head mra"><spring:message code="crs.button.termlink.learner" /></div><!-- 수강생 정보 -->
            <a href="javascript:;" onclick="sendMsg();return false;" class="ui basic small button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
        </div>
		<div class="ui form">
			<div class="fields">
				<div class="two wide field">
					<div class="initial-img border-radius0">
						<c:choose>
	       					<c:when test="${not empty rVo.phtFile}">
								<img alt='<spring:message code="forum.common.user.img" />' style="max-width:100%;max-height:100%" src='${phtFile}'>
	       					</c:when>
        					<c:otherwise>
        						<img alt="<spring:message code="forum.common.user.img" />" style="max-width:100%;min-width:60%;max-height:100%" src="/webdoc/img/icon-hycu-symbol-grey.svg">
        					</c:otherwise>
						</c:choose>
					</div>                                            
				</div>
                <ul class="fourteen wide field tbl dt-sm">
                    <li>
                        <dl>
                            <dt><spring:message code="forum.label.user_id" /></dt><!-- 아이디 -->
                            <dd>${stdInfo.userId}</dd>
                            <dt><spring:message code="forum.label.user_nm" /></dt><!-- 이름 -->
                            <dd>${stdInfo.userNm}</dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="lesson.label.dept" /></dt><!-- 학과 -->
                            <dd>${stdInfo.deptNm}</dd>
                            <dt><spring:message code="user.title.userinfo.mobileno" /></dt><!-- 휴대폰번호 -->
                            <dd>${stdInfo.userMobileNo}</dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><spring:message code="common.email" /></dt><!-- 이메일 -->
                            <dd>${stdInfo.userEmail}</dd>
                        </dl>
                    </li>
                </ul>
			</div>
            <div class="option-content mt15">
                <b class="sec_head"><spring:message code="score.label.information" /></b> <!-- 성적 정보 -->
            </div>
            <table class="grid-table type2 ">
                <thead>
                    <tr>                                
                        <c:if test="${stdInfo.middleTestScoreRatio != '0'}">
                         <th scope="col" class=""><spring:message code="std.label.mid_exam" /></th><!-- 중간고사 -->
                        </c:if>
                        <c:if test="${stdInfo.lastTestScoreRatio != '0'}">
                        <th scope="col" class=""><spring:message code="std.label.final_exam" /></th><!-- 기말고사 -->
                        </c:if>
                        <c:if test="${stdInfo.testScoreRatio != '0'}"> 
                        <th scope="col" class=""><spring:message code="crs.label.nomal_exam" /></th><!-- 수시평가 -->
                        </c:if>
                        <c:if test="${stdInfo.lessonScoreRatio != '0'}"> 
                        <th scope="col" class=""><spring:message code='crs.label.attend' />/<spring:message code='dashboard.lesson' /></th> <!-- 출석/강의 -->
                        </c:if>
                        <c:if test="${stdInfo.assignmentScoreRatio != '0'}">
                        <th scope="col" class=""><spring:message code="crs.label.asmnt" /></th><!-- 과제 -->
                        </c:if>
                        <c:if test="${stdInfo.forumScoreRatio != '0'}">
                        <th scope="col" class=""><spring:message code="crs.label.forum" /></th><!-- 토론 -->
                        </c:if>
                        <c:if test="${stdInfo.quizScoreRatio != '0'}">
                        <th scope="col" class=""><spring:message code="crs.label.quiz" /></th><!-- 퀴즈 -->
                        </c:if>
                        <c:if test="${stdInfo.reshScoreRatio != '0'}">
                        <th scope="col" class=""><spring:message code="crs.label.resch" /></th><!-- 설문 -->
                        </c:if>
                        <th scope="col" class=""><spring:message code='common.label.production' /><spring:message code="common.label.total.point" /></th><!-- 산출총점 -->
                        <th scope="col" class=""><spring:message code="common.label.total.include.point" /></th><!-- 가산점 -->
                        <th scope="col" class=""><spring:message code='common.label.final' /><spring:message code="common.score" /></th><!-- 최종점수 -->
                    </tr>
                </thead>
                <tbody>
                    <tr>                                
                        <c:if test="${stdInfo.middleTestScoreRatio != '0'}"><!-- 중간고사 -->
                        	<td data-label="<spring:message code="dashboard.exam_mid" />">${stdInfo.middleTestScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.lastTestScoreRatio != '0'}"><!-- 기말고사 -->
                        	<td data-label="<spring:message code="dashboard.exam_end" />">${stdInfo.lastTestScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.testScoreRatio != '0'}"><!-- 수시평가 -->
                        	<td data-label="<spring:message code="dashboard.cor.always.exam" />">${stdInfo.testScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.lessonScoreRatio != '0'}"><!-- 출석/강의 -->
                        	<td data-label="<spring:message code='crs.label.attend' />/<spring:message code='dashboard.lesson' />">${stdInfo.lessonScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.assignmentScoreRatio != '0'}"><!-- 과제 -->
                        	<td data-label="<spring:message code="filemgr.label.crsauth.asmt" />">${stdInfo.assignmentScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.forumScoreRatio != '0'}"><!-- 토론 -->
                        	<td data-label="<spring:message code="std.label.forum" />">${stdInfo.forumScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.quizScoreRatio != '0'}"><!-- 퀴즈 -->
                        	<td data-label="<spring:message code="std.label.quiz" />">${stdInfo.quizScoreAvg}</td>
                        </c:if>
                        <c:if test="${stdInfo.reshScoreRatio != '0'}"><!-- 퀴즈 -->
                        	<td data-label="<spring:message code="std.label.resch" />">${stdInfo.reshScoreAvg}</td>
                        </c:if>
                        <td data-label="<spring:message code='common.label.production' /><spring:message code="common.label.total.point" />">${stdInfo.finalScore}</td><!-- 산출총점 -->
                        <td data-label="<spring:message code="common.label.total.include.point" />">${stdInfo.etcScore}</td><!-- 가산점 -->
                        <td data-label="<spring:message code='common.label.final' /><spring:message code="common.score" />">${stdInfo.totScore}</td><!-- 최종점수 -->
                    </tr>
                </tbody>
            </table>
            <div class="option-content mt15">
                <b class="sec_head"><spring:message code="score.label.status" /></b> <!-- 성적 현황 -->
            </div>
            <div class="ui stackable grid mt5 mb0">
                <div class="eight wide column pt0">
                 <div class="chart-container">
                    	<canvas id="barChart" ></canvas>
                    	<script>
                            var ctx = document.getElementById("barChart");
                            var labelText = new Array;
                            var avgScoreText = new Array;
                            var myScoreText = new Array;
                            <c:forEach items="${avgScoreList}" var="avgScoreItem">
                            	var scoreItemNm = "${avgScoreItem.scoreItemNm}";
                            	
                            	if(scoreItemNm == "강의") {
                            		scoreItemNm = "출석";
                            	}
                            
                                labelText.push(scoreItemNm);
                            	avgScoreText.push(("${avgScoreItem.avgScore}"*1).toFixed(2));
                            	myScoreText.push(("${avgScoreItem.getScore}"*1).toFixed(2));
                            </c:forEach>
                            
                            var myChart = new Chart(ctx, {
                                type: 'horizontalBar',
                                data: {
                                  labels: labelText,
                                  datasets: [{
                                    label: '<spring:message code="crs.label.me" />',	// 나
                                    backgroundColor: "#26B99A",
                                    borderWidth:1,
                                    data: myScoreText
                                  }, {
                                    label: '<spring:message code="exam.label.avg" />',	// 평균
                                    backgroundColor: "rgba(0,0,0,.3)",
                                    borderWidth:1,
                                    data: avgScoreText
                                  }]
                                },
                                options: {
                                    events: false,
                                    showTooltips: false,
                                    title: {
                                      display: true,
                                      text: '<spring:message code="common.average.score" />', // 평균 점수
                                      fontSize: 14,
                                      fontColor: "#666",
                                    },
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
                                                ctx.fillText(dataset.data[i] + '<spring:message code="message.score" />', model.x - 20, model.y + 8);// 점
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
                                                callback: function(value){return value+ "<spring:message code='message.score' />"}// 점
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
                            </script>
                    </div>
                </div>
                <div class="eight wide column pt0">
                	<div class="chart-container">
                    <canvas id="levelChart" ></canvas>
                    <script>
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
                                    data: ["${chartScoreList[0].score100 }"
                                	 , "${chartScoreList[0].score90 }"
                                	 , "${chartScoreList[0].score80 }"
                                	 , "${chartScoreList[0].score70 }"
                                	 , "${chartScoreList[0].score60 }"
                                	 , "${chartScoreList[0].score50 }"]
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
                                      text: '<spring:message code="crs.final.score.present.condition.percent" />',		// 최종점수 현황 (%)
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
                                                            text: label + " : " + value + "<spring:message code='exam.label.nm' />",	// 명
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
                <p class="tc mt10"><spring:message code="score.label.ect.eval.oper.msg5" /><span class="fcRed">${chartScoreList[0].myFinalScore }</span><spring:message code="score.label.ect.eval.oper.msg5_2" /></p><!-- 최종점수는 점입니다. -->
                </div>                                    
            </div>

            <!-- 성적 산출 -->
            <div class="option-content mt15">
                <b class="sec_head"><spring:message code="crs.title.score.production" /></b><!-- 성적 산출 -->
            </div>
			<c:if test="${stdInfo.lessonScoreRatio != '0'}">
                <div class="">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="seminar.label.online" /><spring:message code="sch.lesson" /></div><!-- 온라인강의 -->
                            <spring:message code="crs.evaluation.rate" /><!-- 평가비율 --> : ${stdInfo.lessonScoreRatio}%
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <div class="ui info message f080">
                            <i class="info circle icon"></i><spring:message code="crs.label.scoring.method" /><!-- 배점 방식 -->
                            <ul class="list">
                                <li><b><spring:message code="dashboard.state.noattend" /> - </b> 
                                	<spring:message code="score.label.attendance.week" /> : 100<spring:message code="forum.label.point" />																		<!-- 점 -->
                                	/  1<spring:message code="message.number" /> <spring:message code="dashboard.state.noattend" /> : 80<spring:message code="forum.label.point" />  	<!-- 점 1회 결석 -->
                                	/  3<spring:message code="message.number" /> <spring:message code="dashboard.state.noattend" /> : 60<spring:message code="forum.label.point" />  	<!-- 점 3회 결석 -->
                                	/  4<spring:message code="message.number" /> <spring:message code="dashboard.state.lt.noattend" />: 0<spring:message code="forum.label.point" />  	<!-- 점 4회 이상결석 -->
                                </li>
                                <li><b><spring:message code="score.label.deduction.for.late" /> - </b> 
                                	1<spring:message code="message.number" /> : 0%  /  
                                	2~3<spring:message code="message.number" /> : 5%  /  
                                	4~5<spring:message code="message.number" /> : 10%  /  
                                	6~7<spring:message code="message.number" /> : 20%  /  
                                	8~9<spring:message code="message.number" /> : 30%  /  
                                	10~11<spring:message code="message.number" /> : 40%  /  
                                	12~13<spring:message code="message.number" /> : 50% (<spring:message code="score.based.on.points" />)	<!-- 획득점수 기준 -->
                                </li>
                            </ul>
                        </div>
                        <ul class="tbl dt-sm">
                            <li>
                                <dl>
                                    <dt><spring:message code="seminar.label.attend.status" /></dt><!-- 출결현황 -->
                                    <dd><spring:message code="lesson.button.all.lesson.schedule" /><!-- 전체 주차 --> : ${lessonInfo.lessonTotCnt}<spring:message code="bbs.label.week" /></dd>
                                    <dd><spring:message code="common.label.absence" /><!-- 결석 --> : ${lessonInfo.absentCnt}<spring:message code="exam.label.times" /></dd>
                                    <dd><spring:message code="common.label.lateness" /><!-- 지각 --> : ${lessonInfo.lateCnt}<spring:message code="exam.label.times" /></dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${lessonInfo.lessonScore}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.lessonScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
			<c:if test="${stdInfo.middleTestScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="crs.label.mid_exam" /></div><!-- 중간고사 -->
                            <spring:message code="crs.evaluation.rate" /><!-- 평가비율 --> : ${stdInfo.middleTestScoreRatio} %
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                        	<c:forEach items="${midTestList}" var="item" varStatus="i">
                            <li>
                                <dl>
                                    <dt>${i.count}.${item.typeNm}</dt>
                                    <dd><spring:message code="forum.label.reflect.rate" /><!-- 반영 비율 --> : ${item.scoreRatio}%</dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${item.score}<spring:message code="forum.label.point" /><span class="tooltip vm" data-content="실시간시험/대체과제/대체퀴즈 등 받은 점수"></span></dd>
                                    <dd><spring:message code="asmnt.label.exchange.score" /><!-- 환산점수 --> : ${item.scoreAvg}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.middleTestScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
			<c:if test="${stdInfo.lastTestScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="crs.label.final_exam" /></div><!-- 기말고사 -->
                            평가비율 : ${stdInfo.lastTestScoreRatio}%
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                            <c:forEach items="${lastTestList}" var="item" varStatus="i">
                            <li>
                                <dl>
                                    <dt>${i.count}.${item.typeNm}</dt>
                                    <dd><spring:message code="asmnt.label.reflect.rate" /><!-- 반영 비율 --> : ${item.scoreRatio}%</dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${item.score}<spring:message code="forum.label.point" /><span class="tooltip vm" data-content="실시간시험/대체과제/대체퀴즈 등 받은 점수"></span></dd>
                                    <dd><spring:message code="asmnt.label.exchange.score" /><!-- 환산점수 --> : ${item.scoreAvg}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.lastTestScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
			<c:if test="${stdInfo.testScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="dashboard.cor.always.exam" /><!-- 수시평가 --></div>
                            평가비율 : ${stdInfo.testScoreRatio}%
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                            <c:forEach items="${testList}" var="item" varStatus="i">
                            <li>
                                <dl>
                                    <dt>${i.count}.${item.typeNm}</dt>
                                    <dd><spring:message code="asmnt.label.reflect.rate" /><!-- 반영 비율 --> : ${item.scoreRatio}%</dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${item.score}<spring:message code="forum.label.point" /><span class="tooltip vm" data-content="실시간시험/대체과제/대체퀴즈 등 받은 점수"></span></dd>
                                    <dd><spring:message code="asmnt.label.exchange.score" /><!-- 환산점수 --> : ${item.scoreAvg}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.testScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
			<c:if test="${stdInfo.assignmentScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code='dashboard.cor.asmnt' /><!-- 과제 --></div>
                            평가비율 : ${stdInfo.assignmentScoreRatio}%
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                        	<c:forEach items="${asmntList}" var="item" varStatus="i">
                            <li>
                                <dl>
                                    <dt>${i.count}.${item.typeNm}</dt>
                                    <dd><spring:message code="asmnt.label.reflect.rate" /><!-- 반영 비율 --> : ${item.scoreRatio}%</dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${item.score}<spring:message code="forum.label.point" /><span class="tooltip vm" data-content="실시간시험/대체과제/대체퀴즈 등 받은 점수"></span></dd>
                                    <dd><spring:message code="asmnt.label.exchange.score" /><!-- 환산점수 --> : ${item.scoreAvg}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.assignmentScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
			<c:if test="${stdInfo.forumScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="crs.label.forum" /></div><!-- 토론 -->
                            <spring:message code="crs.evaluation.rate" /><!-- 평가비율 --> : ${stdInfo.forumScoreRatio}%
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                            <c:forEach items="${forumList}" var="item" varStatus="i">
                            <li>
                                <dl>
                                    <dt>${i.count}.${item.typeNm}</dt>
                                    <dd><spring:message code="asmnt.label.reflect.rate" /><!-- 반영 비율 --> : ${item.scoreRatio}%</dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${item.score}<spring:message code="forum.label.point" /><span class="tooltip vm" data-content="실시간시험/대체과제/대체퀴즈 등 받은 점수"></span></dd>
                                    <dd><spring:message code="asmnt.label.exchange.score" /><!-- 환산점수 --> : ${item.scoreAvg}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.forumScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>

			<c:if test="${stdInfo.quizScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="common.label.question" /></div><!-- 퀴즈 -->
                            <spring:message code="crs.evaluation.rate" /><!-- 평가비율 --> : ${stdInfo.quizScoreRatio}%
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                            <c:forEach items="${quizList}" var="item" varStatus="i">
                            <li>
                                <dl>
                                    <dt>${i.count}.${item.typeNm}</dt>
                                    <dd><spring:message code="asmnt.label.reflect.rate" /><!-- 반영 비율 --> : ${item.scoreRatio}%</dd>
                                    <dd><spring:message code="forum.label.acquisition.score" /><!-- 취득점수 --> : ${item.score}<spring:message code="forum.label.point" /><span class="tooltip vm" data-content=""></span></dd>
                                    <dd><spring:message code="asmnt.label.exchange.score" /><!-- 환산점수 --> : ${item.scoreAvg}<spring:message code="forum.label.point" /></dd>
                                </dl>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.quizScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
			<c:if test="${stdInfo.reshScoreRatio != '0'}">
                <div class="mt5">
                    <div class="ui attached message">
                        <div class="flex">
                            <div class="mra"><spring:message code="crs.label.resch" /><!-- 설문 --></div>
                            <spring:message code="crs.evaluation.rate" /> : ${stdInfo.reshScoreRatio}%	<!-- 평가비율 -->
                        </div>
                    </div>
                    <div class="ui bottom attached segment">
                        <ul class="tbl dt-sm">
                        </ul>
                        <div class="ui divider"></div>
                        <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.reshScoreAvg}<spring:message code="forum.label.point" /></strong>
                    </div>
                </div>
			</c:if>
                
            <div class="mt5">
                <div class="ui attached message">
                    <div class="flex">
                        <div class="mra"><spring:message code="common.label.total.include.point" /><!-- 가산점 --></div>
                    </div>
                    <strong><spring:message code="score.calculated.label" /><!-- 산출 점수 --> : ${stdInfo.etcScore}<spring:message code="forum.label.point" /></strong>
                </div>
                <%-- 
                <div class="ui bottom attached segment">
                    <ul class="tbl dt-sm">
                    </ul>
                    <div class="ui divider"></div>
                    <strong><spring:message code="score.calculated.label" /><!-- 산출점수 --> : ${stdInfo.etcScore}<spring:message code="forum.label.point" /></strong>
                </div> 
                --%>
            </div>
        </div>
        <div class="bottom-content">
            <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
        </div>
    </div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>