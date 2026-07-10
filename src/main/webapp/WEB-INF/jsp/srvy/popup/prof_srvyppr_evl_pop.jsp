<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table,chart"/>
		</jsp:include>
    </head>

    <script type="text/javascript">
    	$(document).ready(function(){
    		if(${fn:length(srvypprList) > 1}) {
    			initSrvyppr();
			}
    	});

    	function initSrvyppr() {
    		showSrvyppr(1);
    	}

    	// 해당 순번 설문지 표시 및 버튼 제어
    	function showSrvyppr(seqno) {
    		let srvypprCnt = $("div.srvypprDiv").length;

    		$("div.srvypprDiv").hide();
    		$("div.srvypprDiv[data-seqno=" + seqno + "]").show();

    		$("#btnPrevSrvyppr").toggle(seqno > 1);
    		$("#btnNextSrvyppr").toggle(seqno < srvypprCnt);
    		dialogHeightChange();
    	}

    	// 이전 설문지로 이동
    	function goPrevSrvyppr() {
    		let curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));

    		if (curSeqno > 1) {
    			showSrvyppr(curSeqno - 1);
    		}
    	}

    	// 다음 설문지로 이동
    	function goNextSrvyppr() {
    		let curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
    		let srvypprCnt = $("div.srvypprDiv").length;

    		if (curSeqno < srvypprCnt) {
    			showSrvyppr(curSeqno + 1);
    		}
    	}

    	// 이전, 다음 평가정보
		function chgUserEval(type) {
			let targetUser 	= null;
			let userList 	= [];
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
				const url  = "/srvy/srvyQstnDistributionChartAjax.do";
				const data = {
					srvyId 		: $("#srvyEvalForm input[name=srvyId]").val(),
					srvyQstnId	: srvyQstnId,
					srvypprId	: srvypprId,
					sbjctId		: "${vo.sbjctId}"
				};

				$.ajax({
				    url 	 	: url,
				    async	 	: false,
				    type 	 	: "POST",
				    data	 	: JSON.stringify(data),
				    dataType 	: "json",
				    contentType	: "application/json; charset=UTF-8",
				    beforeSend	: () => UiComm.showLoading(true),
		            success		: function (data) {
		            	if (data.result > 0) {
							if(data.data != null) {
								var srvyMainView = data.data;
								var rspnsList = srvyMainView.egovList;		// 설문문항답변분포목록
								var colorList = srvyMainView.colorList;		// 색상배열목록

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
									type: 'bar',
									data: {
										labels: labelsArray,
										datasets: [{
											data: ratioArray,
											backgroundColor: colorArray,
											borderWidth: 1,
											barThickness: 30
										}]
									},
									options: {
										indexAxis: 'y', // 가로 막대
										responsive: true,
			                            maintainAspectRatio: false,
			                            plugins: {
			                                legend: { display: false },
			                                title: { display: true, text: "<spring:message code='srvy.label.option.distribution.status' />(%)", font: { size: 16 }, color: '#333' },/* 보기 분포 현황 */
			                                datalabels: {
			                                    display: true,
			                                    anchor: 'end',        // 막대 끝에 붙이기
			                                    align: 'right',       // 오른쪽으로 정렬
			                                    formatter: (value, context) => {
			                                        const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
			                                        return (value / total * 100).toFixed(1) + '%';
			                                    }
			                                }
			                            },
			                            scales: {
			                                x: {
			                                    beginAtZero: true,
			                                    max: Math.max(...rspnsArray) * 1.2, // 막대 끝에 라벨 공간 확보
			                                    ticks: { color: '#666' },
			                                    title: { display: false, text: "<spring:message code='srvy.label.people.cnt' />" },/* 인원수 */
			                                    grid: { color: '#eee' }
			                                },
			                                y: {
			                                    reverse: true,
			                                    ticks: { color: '#666', font: { size: 11 } },
			                                }
			                            }
									},
			                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
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
			                            responsive: true,
			                            maintainAspectRatio: false,
			                            plugins: {
			                            	legend: { position: 'bottom' },
			                            	title: { display: true, text: "<spring:message code='srvy.label.srvy.statistics' /> (%)", font: { size: 16 }, color: '#333' },/* 설문통계 */
			                            	datalabels: {
			                                    color: '#fff',
			                                    font: { weight: 'bold', size: 11 },
			                                    formatter: (value, context) => {
			                                        const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
			                                        return (value / total * 100).toFixed(1) + '%';
			                                    }
			                                }
			                            }
			                        },
			                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
								});
							}
					    } else {
					    	UiComm.showMessage(data.message, "error");
					    }
						$(obj).next("div.resultStatus").css("display", "block");
		            },
		            error		: () => UiComm.showMessage("<spring:message code='fail.common.msg' />", "error"),	/* 에러가 발생했습니다! */
		            complete	: () => UiComm.showLoading(false)
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
        	<div class="board_top class">
        		<c:if test="${fn:length(srvyPtcpList) > 1 }">
        			<button type="button" class="btn type2" onclick="chgUserEval('prev')"><i class="xi-angle-left-min"></i><spring:message code="srvy.button.prev" /><!-- 이전 --></button>
	                <button type="button" class="btn type2" onclick="chgUserEval('next')"><spring:message code="srvy.button.next" /><!-- 다음 --><i class="xi-angle-right-min"></i></button>
		        </c:if>
		        <div class="right-area">
                    <div class="feedback-info">
                        <p class="desc">
                            <span><strong>${srvyPtcpnt.deptnm }</strong></span>
                            <span><strong>${srvyPtcpnt.stdntNo }</strong></span>
                            <span><strong>${srvyPtcpnt.usernm }</strong></span>
                            <span class="score"><strong>${srvyPtcpnt.totScr }<spring:message code="srvy.label.score.point" /><!-- 점 --></strong></span>
                        </p>
                    </div>
                </div>
        	</div>

			<div class="quiz_paper_wrap">
            	<div class="board_top">
                    <div class="right-area">
                        <button type="button" class="btn basic" onclick="srvypprPrint()"><spring:message code="srvy.button.srvy.print" /><!-- 설문지 인쇄 --></button>
                        <button type="button" class="btn type2" onclick="window.parent.closeDialog()"><spring:message code="srvy.button.cancel" /><!-- 취소 --></button>
                    </div>
                </div>
            </div>

			<%@ include file="/WEB-INF/jsp/srvy/common/srvy_qstn_inc.jsp" %>

            <div class="modal_btns">
            	<c:if test="${fn:length(srvypprList) > 1}">
            		<a href="javascript:goPrevSrvyppr();" class="btn type2" id="btnPrevSrvyppr"><spring:message code="srvy.button.prev" /><!-- 이전 --></a>
            		<a href="javascript:goNextSrvyppr();" class="btn type2" id="btnNextSrvyppr"><spring:message code="srvy.button.next" /><!-- 다음 --></a>
            	</c:if>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
