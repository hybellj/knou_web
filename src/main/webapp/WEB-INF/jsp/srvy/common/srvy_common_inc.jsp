<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script type="text/javascript" src="/webdoc/js/chart.min.js"></script>
<script type="text/javascript" src="/webdoc/js/Chart.PieceLabel.min.js"></script>
<style type="text/css">
	.chart_wm250 {
		max-width: 250px;
		margin: auto;
	}
	.chart_wm350 {
		max-width: 350px;
		margin: auto;
	}
</style>
<script type="text/javascript">
	window.closeDialog = function() {
		dialog.close();
	};

	var reshCommon = {
		// 모달 생성
		initModal: function(type) {
			$("#reshPop").remove();
			var typeMap = {
				"join"   	  : "<spring:message code='resh.label.resh.join' />",/* 설문참여 */
				"result" 	  : "<spring:message code='resh.label.resh.join' /> <spring:message code='resh.label.result' />",/* 설문참여 *//* 결과 */
				"copyResh" 	  : "<spring:message code='resh.label.prev.resh.copy' />",/* 이전 설문 가져오기 */
				"copyHomeResh": "<spring:message code='resh.label.prev.all.resh.copy' />",/* 이전 전체설문 가져오기 */
				"copy"   	  : "<spring:message code='resh.label.resh.copy' />",/* 설문 가져오기 */
				"writePage"   : "<spring:message code='resh.button.add.page' />",/* 페이지 추가 */
				"excelUpload" : "<spring:message code='resh.button.excel.upload.qstn' />",/* 엑셀 문제 등록 */
				"reshPreview" : "<spring:message code='resh.label.resh.paper' /> <spring:message code='resh.label.preview' />",/* 설문지 *//* 미리보기 */
				"resultPop"	  : "<spring:message code='resh.label.status.join' />",/* 참여 현황 */
				"profMemo"	  : "<spring:message code='resh.label.memo' />",/* 메모 */
				"scoreExcel"  : "<spring:message code='resh.button.excel.upload.score' />",/* 엑셀 성적등록 */
				"viewPaper"	  : "<spring:message code='resh.button.resh.paper.view' />"/* 설문지 보기 */
			};
			var html  = "<div class='modal fade' id='reshPop' tabindex='-1' role='dialog' aria-labelledby='"+typeMap[type]+" 모달' aria-hidden='false'>";
				html += "	<div class='modal-dialog modal-lg' role='document'>";
				html += "		<div class='modal-content'>";
				html += "			<div class='modal-header'>";
				html += "				<button type='button' class='close' data-dismiss='modal' aria-label='<spring:message code='resh.button.close' />'>";/* 닫기 */
				html += "					<span aria-hidden='true'>&times;</span>";
				html += "				</button>";
				html += "				<h4 class='modal-title'>"+typeMap[type]+"</h4>";
				html += "			</div>";
				html += "			<div class='modal-body'>";
				html += "				<iframe src='' id='reshPopIfm' name='reshPopIfm' width='100%' scrolling='no'></iframe>";
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "</div>";
			$("#wrap").append(html);
			$('iframe').iFrameResize();
		},
		// 결과 차트 출력
		statusChartSet: function(type) {
			var cntMap = {};
			<c:forEach var="list" items="${cntnDvcTycdList}">
				cntMap["device_${list.cd}"] = "${list.cdnm}";
			</c:forEach>
			<c:forEach var="list" items="${srvyPtcpDvcStatusList }">
				cntMap["${list.cd}"] = "${list.srvyPtcpCnt}";
			</c:forEach>

			var reshFinCnt = "${srvyPtcpCnt.ptcpCnt}";
			var reshApplicantCnt = "${srvyPtcpCnt.totalCnt - srvyPtcpCnt.ptcpCnt}";

			var typeMap = {
				"status" : {
					"ctx"	 : "statPieChart",
					"text"   : "<spring:message code='resh.label.status.join' /> (%)",/* 참여현황 */
					"labels" : ["<spring:message code='resh.label.user.join.y' />", "<spring:message code='resh.label.user.join.n' />"],/* 응답자 *//* 미응답자 */
					"datas"  : [reshFinCnt, reshApplicantCnt]
				},
				"device" : {
					"ctx"	 : "devicePieChart",
					"text"   : "<spring:message code='resh.label.join.device' /> (%)",/* 접속환경 */
					"labels" : [cntMap["device_PC"], cntMap["device_MBL"]],
					"datas"  : [cntMap["PC"], cntMap["MBL"]]
				}
			};
			var ctx = document.getElementById(typeMap[type]['ctx']);
			var colorArray = ["#36a2eb", "#ff6384"];

	        var myChart = new Chart(ctx, {
	            type: 'pie',
	            data: {
	            labels: typeMap[type]['labels'],
	            datasets: [{
	                backgroundColor: colorArray,
	                borderWidth:1,
	                data: typeMap[type]['datas']
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
	                text: typeMap[type]['text'],
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
	                                        text: label + " : " + value + "<spring:message code='resh.label.nm' />",/* 명 */
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
		if(modal != "" && target != "ezGraderPopIfm") reshCommon.initModal(modal);
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
		if(target == "ezGraderPopIfm") {
			$('#ezGraderPop').modal('show');
		} else if(modal != "") {
			$('#reshPop').modal('show');
		}
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