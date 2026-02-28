<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
	window.closeModal = function() {
	    $('.modal').modal('hide');
	};

	window.closeDialog = function() {
		dialog.close();
	};

	var quizCommon = {
		// 모달 생성
		initModal: function(type) {
			$("#quizPop").remove();
			var typeMap = {
				"join"        : "<spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' />",/* 퀴즈 *//* 시험지 */
				"answer"      : "<spring:message code='exam.label.submit.answer' />",/* 제출 답안 */
				"qstnEval"    : "<spring:message code='exam.label.paper.eval' />",/* 시험지 및 평가 */
				"recordView"  : "<spring:message code='exam.button.stare.hsty' /> <spring:message code='exam.label.qstn.item' />",/* 응시기록 *//* 보기 */
				"paperPrint"  : "<spring:message code='exam.button.batch.print.paper' />",/* 시험지 일괄 인쇄 */
				"profMemo"    : "<spring:message code='exam.label.memo' />",/* 메모 */
				"scoreExcel"  : "<spring:message code='exam.button.reg.excel.score' />",/* 엑셀 성적등록 */
				"quizPreview" : "<spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' />",/* 퀴즈 *//* 시험지 *//* 미리보기 */
				"qbankCtgr"   : "<spring:message code='exam.label.categori' /> <spring:message code='exam.button.reg' />",/* 분류 *//* 등록 */
				"qbankView"   : "<spring:message code='exam.label.qstn' /> <spring:message code='exam.label.qstn.item' />",/* 문제 *//* 보기 */
				"copy"		  : "<spring:message code='exam.label.prev' /> <spring:message code='exam.label.quiz' /> <spring:message code='exam.label.copy' />",/* 이전 *//* 퀴즈 *//* 가져오기 */
				"copyQstn" 	  : "<spring:message code='exam.label.qstn' /> <spring:message code='exam.label.copy' />",/* 문제 *//* 가져오기 */
				"excelUpload" : "<spring:message code='exam.button.req.excel.qstn' />",/* 엑셀 문항등록 */
				"qstnPrint"	  : "<spring:message code='exam.button.qstn.print.paper' />",/* 문항 인쇄 */
				"starePop"    : "<spring:message code='exam.label.stare.status' />",/* 응시현황 */
				"qstnOption"  : "<spring:message code='exam.label.qstn.edit.option' />",/* 재채점 옵션 선택 */
				"joinInfo"    : "<spring:message code='exam.label.quiz.stare.info' />",/* 퀴즈 응시 주의사항 */
				"qstnEdit"	  : "<spring:message code='exam.label.qstn' /> <spring:message code='exam.button.mod' />",/* 문제 *//* 수정 */
				"examInsTarget"	  : "<spring:message code='exam.label.ins.target.set.ifm' />",/* 대체평가 대상자 설정 */
				"teamGrpChoice"  : "학습그룹지정",
			};
			var html  = "<div class='modal fade' id='quizPop' tabindex='-1' role='dialog' aria-labelledby='"+typeMap[type]+" 모달' aria-hidden='false'>";
				html += "	<div class='modal-dialog modal-lg' role='document'>";
				html += "		<div class='modal-content'>";
				html += "			<div class='modal-header'>";
				html += "				<button type='button' class='close' data-dismiss='modal' aria-label='닫기'>";
				html += "					<span aria-hidden='true'>&times;</span>";
				html += "				</button>";
				html += "				<h4 class='modal-title'>"+typeMap[type]+"</h4>";
				html += "			</div>";
				html += "			<div class='modal-body'>";
				html += "				<iframe src='' id='quizPopIfm' name='quizPopIfm' width='100%' scrolling='no' title='quiz pop'></iframe>";
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "</div>";
			$("#wrap").append(html);
			$('iframe').iFrameResize();
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
				$("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;' title='download'></iframe>");
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

	// 날짜 포맷
	function dateFormat(formatter, date) {
		// yyyy.MM.dd HH:mm:ss
		if(formatter == "date") {
			return date.substring(0, 4) + "." + date.substring(4, 6) + "." + date.substring(6, 8) + " " + date.substring(8, 10) + ":" + date.substring(10, 12);
		}
	}

	// 페이지 이동
	function submitForm(action, target, modal, kvArr){
		if(modal != "") quizCommon.initModal(modal);
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);
		form.attr("target", target);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
		if(modal != "") $('#quizPop').modal('show');
	};

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