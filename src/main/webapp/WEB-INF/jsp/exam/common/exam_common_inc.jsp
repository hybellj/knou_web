<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">
	window.closeModal = function() {
	    $('.modal').modal('hide');
	};

	var examCommon = {
		// 모달 생성
		initModal: function(type) {
			$("#examPop").remove();
			var typeMap = {
				"quizAnswer"      : "<spring:message code='exam.label.submit.answer' />",/* 제출 답안 */
				"asmntSubmit"     : "<spring:message code='exam.button.asmnt.answer' />",/* 제출정보 */
				"forumSubmit"     : "<spring:message code='exam.button.forum.my.submit' />",/* 나의 제출정보 */
				"quizJoin"        : "<spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' />",/* 퀴즈 *//* 시험지 */
				"asmntJoin"       : "<spring:message code='asmnt.log.asmnt.submit' />",/* 과제 제출 */
				"forumJoin"       : "<spring:message code='forum.label.forum' /><spring:message code='exam.label.submit' />",/* 토론 *//* 참여 */
				"examOath"        : "<spring:message code='exam.label.oath' />",/* 서약서 */
				"absentAppl"      : "<spring:message code='exam.label.absent' /> <spring:message code='exam.label.applicate' />",/* 결시원 *//* 신청 */
				"absentView"      : "<spring:message code='exam.label.absent.list' />",/* 결시내역 */
				"qstnEval"  	  : "<spring:message code='exam.label.paper.eval' />",/* 시험지 및 평가 */
				"recordView" 	  : "<spring:message code='exam.button.stare.hsty' /> <spring:message code='exam.label.qstn.item' />",/* 응시기록 *//* 보기 */
				"paperPrint" 	  : "<spring:message code='exam.button.batch.print.paper' />",/* 시험지 일괄 인쇄 */
				"examScoreStatus" : "<spring:message code='exam.label.view.grade.status' />",/* 성적통계보기 */
				"profMemo" 		  : "<spring:message code='exam.label.memo' />",/* 메모 */
				"scoreExcel"	  : "<spring:message code='exam.button.reg.excel.score' />",/* 엑셀 성적등록 */
				"copy"   	  	  : "<spring:message code='exam.label.qstn' /> <spring:message code='exam.label.copy' />",/* 문제 *//* 가져오기 */
				"excelUpload" 	  : "<spring:message code='exam.button.req.excel.qstn' />",/* 엑셀 문항등록 */
				"examOathList"    : "<spring:message code='exam.label.oath.submit.list' />",/* 서약서 제출 목록 */
				"absent" 	  	  : "<spring:message code='exam.label.absent.apply.list.approve' />",/* 결시원 신청 내역 및 승인처리 */
				"dsblReq" 	  	  : "<spring:message code='exam.label.dsbl.req.support.list' />",/* 장애인 지원 요청 내역 상세 */
				"quizPreview" 	  : "<spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' />",/* 시험지 *//* 미리보기 */
				"copyExam"  	  : "<spring:message code='exam.button.prev.exam.copy' />",/* 이전  시험 가져오기 */
				"copyAdmission"	  : "<spring:message code='exam.button.admission.copy' />",/* 수시평가 가져오기 */
				"QUIZ"			  : "<spring:message code='exam.label.mid.end.exam' /> <spring:message code='exam.label.quiz' /> <spring:message code='exam.button.reg' />",/* 중간/기말 *//* 퀴즈 *//* 등록 */
				"ASMNT" 		  : "<spring:message code='exam.label.mid.end.exam' /> <spring:message code='asmnt.label.asmnt' /> <spring:message code='exam.button.reg' />",/* 중간/기말 *//* 과제 *//* 등록 */
				"FORUM" 		  : "<spring:message code='exam.label.mid.end.exam' /> <spring:message code='forum.label.forum' /> <spring:message code='exam.button.reg' />",/* 중간/기말 *//* 토론 *//* 등록 */
				"stdStat"		  : "<spring:message code='exam.label.std.learning.status' />",/* 수강생 학습 현황 */
				"allFeedback"	  : "<spring:message code='forum.button.all.feedback' />",/* 일괄 피드백 */
				"absentApplHsty"  : "<spring:message code='exam.label.absent.apply.hsty' />",/* 결시원 신청이력 */
				"addAbsent"		  : "<spring:message code='exam.label.absent.add' />",/* 결시원 추가 */
				"stdSearch"		  : "<spring:message code='user.title.userinfo.student.search' />",/* 학생검색 */
				"profSearch"	  : "<spring:message code='user.title.userinfo.professor.search' />",/* 교직원검색 */
				"reExamConfig"	  : "<spring:message code='exam.label.re.exam.config.pop' />",/* 재시험 등록관리 */
				"addMutEval"	  : "<spring:message code='crs.label.eval_criteria_reg'/>",/* 평가기준 등록 */
				"joinInfo"		  : "<spring:message code='exam.label.quiz.stare.info' />",/* 퀴즈 응시 주의사항 */
				"examInsTarget"	  : "<spring:message code='exam.label.ins.target.set.ifm' />",/* 대체평가 대상자 설정 */
				"examInsLink"	  : "<spring:message code='exam.label.subs.link' />"/* 평가요소 변경 */
			};
			var modalName = typeMap[type] || type;
			var html  = "<div class='modal fade' id='examPop' tabindex='-1' role='dialog' aria-labelledby='"+modalName+" 모달' aria-hidden='false'>";
				html += "	<div class='modal-dialog modal-lg' role='document'>";
				html += "		<div class='modal-content'>";
				html += "			<div class='modal-header'>";
				html += "				<button type='button' class='close' data-dismiss='modal' aria-label='닫기'>";
				html += "					<span aria-hidden='true'>&times;</span>";
				html += "				</button>";
				html += "				<h4 class='modal-title'>"+modalName+"</h4>";
				html += "			</div>";
				html += "			<div class='modal-body'>";
				html += "				<iframe src='' id='examPopIfm' name='examPopIfm' width='100%' scrolling='no'></iframe>";
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "</div>";
			$("#wrap").append(html);
			$('iframe').iFrameResize();
		},
		// 가로 바 차트 출력
		horizontalBarChartSet: function(list, type) {
			var ctxMap = {
				"M" : "midHoriBarChart",
				"L" : "endHoriBarChart",
				"A" : "admHoriBarChart",
				"N" : "horiBarChart"
			}
			var stareCnt = 0;
			var labelsArray = new Array();
			var dataArray   = new Array();
			var colorArray  = new Array();
			
			list.forEach(function(v, i) {
				stareCnt += v.cnt;
				labelsArray.push(v.label);
				dataArray.push(v.cnt);
				colorArray.push('rgba(54, 162, 235, .6)');
			});
			var ctx = document.getElementById(ctxMap[type]);
	        var myChart = new Chart(ctx, {
	            type: 'horizontalBar',
	            data: {
	            labels: labelsArray,
	            datasets: [{
	                backgroundColor: colorArray,
	                borderWidth:1,
	                data: dataArray
	            }]
	            },
	            options: {
					events: false,
					showTooltips: false,
					title: {
					  display: true,
					  text: "<spring:message code='exam.label.distribution.ratio' /> (%)",/* 분포도비율 */
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
								var persent = Math.floor(dataset.data[i]/stareCnt*100);
								persent = isFinite(persent) ? persent : 0;
								ctx.fillStyle = '#000';
								ctx.fillText(dataset.data[i] + "<spring:message code='exam.label.nm' />(" + persent + '%)', model.x + 30, model.y + 8);/* 명 */
							}
						});
					}},
					scales: {
						yAxes: [{
							barPercentage: 0.6,
							scaleLabel: {
								display: true
							}
						}],
						xAxes: [{
							ticks: {
								min: 0,
								max: stareCnt,
								stepSize: 10,
								callback: function(value){return value}
							}
						}]
					},
					legend: {
						display: false
					}
				}
	        });
		},
		// 세로바 차트 출력
		barChartSet: function(vo, type) {
			var ctxMap = {
				"M" : "midBarChart",
				"L" : "endBarChart",
				"A" : "admBarChart",
				"N" : "barChart"
			}
			var ctx = document.getElementById(ctxMap[type]);
		    var myChart = new Chart(ctx, {
		        type: 'bar',
		        data: {
		            labels: ["<spring:message code='exam.label.avg' />", "<spring:message code='exam.label.avg.upper.10' />", "<spring:message code='exam.label.max' /><spring:message code='exam.label.score.point' />", "<spring:message code='exam.label.min' /><spring:message code='exam.label.score.point' />"],/* 평균 *//* 상위10%평균 *//* 최고 *//* 점 *//* 최저 *//* 점 */
		            datasets: [{
		                data: [vo.avgScore, vo.topAvgScore, vo.maxScore, vo.minScore],
		                backgroundColor: [
		                    'rgba(54, 162, 235, .6)',
		                    'rgba(54, 162, 235, .6)',
		                    'rgba(54, 162, 235, .6)',
		                    'rgba(54, 162, 235, .6)'
		                ],
		                borderWidth: 1
		            }]
		        },
		        options: {
		            events: false,
		            showTooltips: false,
		            title: {
		            display: true,
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
		                        ctx.fillText(dataset.data[i], model.x, model.y - 10);
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
	}
	
	// 파일 다운로드
	function fileDown(fileSn, repoCd) {
		var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : fileSn,
			"repoCd" : repoCd
		};
		
		ajaxCall(url, data, function(data) {
			$("#downloadForm").remove();
			// download용 iframe이 없으면 만든다.
			if ( $("#downloadIfm").length == 0 ) {
				$("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;'></iframe>");
			}
			
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "downloadForm");
			form.attr("id", "downloadForm");
			form.attr("target", "downloadIfm");
			form.attr("action", data);
			form.appendTo("body");
			form.submit();
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 파일 바이트 계산
	function byteConvertor(bytes, fileNm, fileSn) {
		bytes = parseInt(bytes);
		var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(bytes)/Math.log(1024));
		if(e == "-Infinity") {
			$("#file_"+fileSn).append(fileNm + " 0 "+s[0]);
		} else {
			$("#file_"+fileSn).append(fileNm + " " + (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e]);
		}
	}
	
	// 성적 통계 pie 차트
	function scorePieChart(completeCnt, noStareCnt) {
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
                data: [completeCnt, noStareCnt]
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
	
	// 날짜 포맷
	function dateFormat(formatter, date) {
		// yyyy.MM.dd HH:mm:ss
		if(formatter == "date") {
			return date.substring(0, 4) + "." + date.substring(4, 6) + "." + date.substring(6, 8) + " " + date.substring(8, 10) + ":" + date.substring(10, 12);
		} else if(formatter == "dt") {
			return date.substring(0, 4) + "." + date.substring(4, 6) + "." + date.substring(6, 8);
		} else if(formatter == "dateWeek") {
			var week = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
			var dt = new Date(date.substring(0, 4), date.substring(4, 6)-1, date.substring(6, 8));
			return date.substring(0, 4) + "." + date.substring(4, 6) + "." + date.substring(6, 8) + " " + date.substring(8, 10) + ":" + date.substring(10, 12) + "("+week[dt.getDay()]+")";
		}
	}
	
	// 페이지 이동
	function submitForm(action, target, modal, kvArr){
		if(modal != "") examCommon.initModal(modal);
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("id", "tempForm");
		form.attr("action", action);
		form.attr("target", target);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
		if(modal != "") $('#examPop').modal('show');
		if(modal == "stdSearch") $("#examPop > .modal-dialog").removeClass("modal-lg").addClass("modal-extra-lg");
	};
	
	// 캘린더 설정
	function initExamCalendar(startId, endId, type) {
		if(type == "start") {
			$('#'+startId).calendar({
				type: 'date',
				endCalendar: $('#'+endId),
				formatter: {
					date: function (date, settings) {
					if (!date) return '';
					var day = (date.getDate()) + '';
						if (day.length < 2) {
							day = '0' + day;
						}
					var month= (date.getMonth() + 1) + '';
						if (month.length < 2) {
							month = '0' + month;
						}
					var year = date.getFullYear();
					return year + '.' + month + '.' + day;
					}
				}
			});
		} else {
			$('#'+startId).calendar({
				type: 'date',
				startCalendar: $('#'+endId),
				formatter: {
					date: function (date, settings) {
					if (!date) return '';
					var day = (date.getDate()) + '';
					if (day.length < 2) {
						day = '0' + day;
					}
					var month = (date.getMonth() + 1) + '';
					if (month.length < 2) {
						month = '0' + month;
					}
					var year = date.getFullYear();
					return year + '.' + month + '.' + day;
					}
				}
			});
		}
	}

    // html 태그 제거
    function escapeHtml(str) {
        var map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return str.replace(/[&<>"']/g, function(m) { return map[m]; });
    }
</script>