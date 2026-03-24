<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <script type="text/javascript">
    	$(document).ready(function(){
    		if(${fn:length(srvypprList) > 1}) {
				controllNextPrevBtn();
			}
    	});

    	/**
		 *  이전 다음 버튼 표시
		 */
		function controllNextPrevBtn() {
		    var curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
		    var srvypprCnt   = $("div.srvypprDiv").length;

		    $("div.srvypprDiv").hide();
		    $("div.srvypprDiv[data-seqno=1]").show();
		    $("#btnPrevSrvyppr").hide();
		    $("#btnNextSrvyppr").hide();
		    if (curSeqno > 1) {
		        $("#btnPrevSrvyppr").show();
		    }
		    if (curSeqno < srvypprCnt) {
		        $("#btnNextSrvyppr").show();
		    }
		}

    	/**
		 *  이전 버튼 클릭 시 앞 설문지로 이동
		 */
		function goPrevSrvyppr() {
		    var curSrvyppr   = $("div.srvypprDiv:visible");
		    var curSrvySeqno = Number(curSrvyppr.attr("data-seqno"));
		    if (curSrvySeqno > 1) {
		        $("#btnNextSrvyppr").show();
		        $("div.srvypprDiv").hide();
		        $("div.srvypprDiv[data-seqno=" + (curSrvySeqno - 1) + "]").show();
		        if (curSrvySeqno - 1 == 1) {
		            $("#btnPrevSrvyppr").hide();
		        }
		    }
		}

		/**
		 *  다음 버튼 클릭 시 뒤 설문지로 이동
		 */
		function goNextSrvyppr() {
		    var curSrvyppr   = $("div.srvypprDiv:visible");
		    var curSrvySeqno = Number(curSrvyppr.attr("data-seqno"));

		    var srvypprCnt = $("div.srvypprDiv").length;
		    if (curSrvySeqno < srvypprCnt) {
		        $("#btnPrevSrvyppr").show();
		        $("div.srvypprDiv").hide();
		        $("div.srvypprDiv[data-seqno=" + (curSrvySeqno + 1) + "]").show();
		        if (curSrvySeqno + 1 == srvypprCnt) {
		            $("#btnNextSrvyppr").hide();
		        }
		    }
		}

    	// 이전, 다음 평가정보
		function chgUserEval(type) {
			var targetUser 	= null;
			var userList 	= [];
			<c:forEach var="list" items="${srvyPtcpList}">
				userList.push({
			        srvyId    : "${list.srvyId}",
			        srvyPtcpId: "${list.srvyPtcpId}",
			        userId    : "${list.userId}"
			    });
			</c:forEach>

			for(var i = 0; i < userList.length; i++) {
				if(userList[i].userId == "${srvyPtcpnt.userId}") {
					if(type == "prev") {
						if(i == 0) {
							targetUser = userList[userList.length-1];
						} else {
							targetUser = userList[i-1];
						}
					} else if(type == "next") {
						if(i == userList.length-1) {
							targetUser = userList[0];
						} else {
							targetUser = userList[i+1];
						}
					}
				}
			}

			$("#srvyEvalForm input[name=srvyId]").val(targetUser.srvyId);
			$("#srvyEvalForm input[name=srvyPtcpId]").val(targetUser.srvyPtcpId);
			$("#srvyEvalForm input[name=userId]").val(targetUser.userId);
	        $("#srvyEvalForm").attr("action", "/srvy/profSrvypprEvlPopup.do");
	        $("#srvyEvalForm").submit();
		}

		// 결과 통계보기 버튼
		function viewStatus(obj, srvyQstnId, srvypprId, qstnRspnsTycd) {
			if($(obj).hasClass("on")) {
				$(obj).next("div.resultStatus").css("display", "none");
			} else {
				var url  = "/srvy/srvyQstnDistributionChartAjax.do";
				var data = {
					"srvyId" 	: $("#srvyEvalForm input[name=srvyId]").val(),
					"srvyQstnId": srvyQstnId,
					"srvypprId"	: srvypprId,
					"sbjctId"	: "${vo.sbjctId}"
				};

				UiComm.showLoading(true);
				$.ajax({
				    url 	 : url,
				    async	 : false,
				    type 	 : "POST",
				    data	 : JSON.stringify(data),
				    dataType : "json",
				    contentType: "application/json; charset=UTF-8"
				}).done(function(data) {
					UiComm.showLoading(false);
					if (data.result > 0) {
						if(data.returnVO != null) {
							var srvyMainView = data.returnVO;
							var rspnsList = srvyMainView.srvyQstnRspnsDistributionList;	// 설문문항답변분포목록
							var colorList = srvyMainView.colorList;						// 색상배열목록

							var labelsArray	= new Array();
							var rspnsArray  = new Array();
							var ratioArray	= new Array();
							var colorArray	= new Array();

							for(const rspns of rspnsList) {
								if(rspns.qstnRspnsTycd == "ONE_CHC" || rspns.qstnRspnsTycd == "MLT_CHC" || rspns.qstnRspnsTycd == "OX_CHC") {
									labelsArray.push(rspns.qstnRspnsTycd == "OX_CHC" ? rspns.vwitmCts : rspns.vwitmSeqno);
									rspnsArray.push(rspns.joinCnt);
									ratioArray.push(rspns.ratio);
								}
							}

							for(const color of colorList) {
								colorArray.push(color.code);
							}

							// bar차트
							var ctx = document.getElementById(srvyQstnId+"_barChart");
							var myChart = new Chart(ctx, {
								type: 'horizontalBar',
								data: {
									labels: labelsArray,
									datasets: [{
										data: ratioArray,
										backgroundColor: colorArray,
										borderWidth: 1
									}]
								},
								options: {
									events: false,
									showTooltips: false,
									title: {
									  display: true,
									  text: "<spring:message code='exam.label.dev.qstn.status' /> (%)",/* 보기 분포 현황 */
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
												ctx.fillStyle = '#fff'; // label color
												ctx.fillText(dataset.data[i] + '%', model.x, model.y + 8);
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
												max: 100,
												stepSize: 20,
												callback: function(value){return value+ "%"}
											}
										}]
									},
									legend: {
										display: false
									}
								}
							});

							// pie차트
							var ctx = document.getElementById(srvyQstnId+"_pieChart");
							var myChart = new Chart(ctx, {
								type: 'pie',
								data: {
								  labels: labelsArray,
								  datasets: [{
									backgroundColor: colorArray,
									borderWidth:1,
									data: rspnsArray
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
									  text: "설문통계 (%)",
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
				    } else {
				    	UiComm.showMessage(data.message, "error");
				    }
					$(obj).next("div.resultStatus").css("display", "block");
				}).fail(function() {
					UiComm.showLoading(false);
					UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");	/* 에러가 발생했습니다! */
				});
			}
			$(obj).toggleClass("on");
			$(obj).children("i").toggleClass("xi-angle-up xi-angle-down");
		}

		// 설문지 인쇄
		function srvypprPrint() {
			$("#srvyEvalForm input[name=searchKey]").val("PRINT");
			$("#srvyEvalForm").attr("action", "/srvy/profSrvypprPrintPopup.do");
	        $("#srvyEvalForm").submit();
		}
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page">
		<form name="srvyEvalForm" id="srvyEvalForm" method="POST">
			<input type="hidden" name="upSrvyId" 		value="${params.upSrvyId }" />
			<input type="hidden" name="srvyId" 			value="${params.srvyId }" />
			<input type="hidden" name="srvyPtcpId" 		value="${params.srvyPtcpId }" />
			<input type="hidden" name="userId" 			value="${srvyPtcpnt.userId }" />
			<input type="hidden" name="srvyPtcpEvlyn" 	value="${params.srvyPtcpEvlyn }" />
			<input type="hidden" name="ptcpyn"			value="${params.ptcpyn }" />
			<input type="hidden" name="searchValue" 	value="${params.searchValue }" />
			<input type="hidden" name="searchKey"		value="${params.searchKey }" />
		</form>
        <div id="wrap">
        	<div class="board_top">
        		<c:if test="${fn:length(srvyPtcpList) > 1 }">
					<a href="javascript:chgUserEval('prev')" class="btn basic small"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
					<a href="javascript:chgUserEval('next')" class="btn basic small"><spring:message code="exam.label.next" /></a><!-- 다음 -->
		        </c:if>
	        	<div class="right-area fcBlue">
			    	<b>${srvyPtcpnt.deptnm } ${srvyPtcpnt.stdntNo } ${srvyPtcpnt.usernm } <span class="f150">${srvyPtcpnt.ptcpEvlScr }<spring:message code="exam.label.score.point" /></span><!-- 점 --></b>
			    </div>
        	</div>

        	<div class="board_top">
        		<div class="right-area">
        			<a href="javascript:srvypprPrint()" class="btn type1">설문지 인쇄</a>
        			<a href="javascript:window.parent.closeDialog()" class="btn type1">취소</a>
        		</div>
        	</div>

			<jsp:include page="/WEB-INF/jsp/srvy/common/srvy_qstn_inc.jsp" />

            <div class="btns">
            	<c:if test="${fn:length(srvypprList) > 1}">
            		<a href="javascript:goPrevSrvyppr();" class="btn type2" id="btnPrevSrvyppr">이전</a>
            		<a href="javascript:goNextSrvyppr();" class="btn type2" id="btnNextSrvyppr">다음</a>
            	</c:if>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
