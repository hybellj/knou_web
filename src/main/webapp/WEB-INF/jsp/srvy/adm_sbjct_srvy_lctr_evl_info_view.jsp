<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table,chart"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function () {
			sbjctListSelect();
		});

		// 과목목록조회
		function sbjctListSelect() {
			const url = "/srvy/admSrvyLctrEvlRegistSbjctListAjax.do";
			const data = {
				srvyId 	: "${vo.srvyId}",
				userId	: "${userCtx.userId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
                	let returnList = data.returnList || [];
                	let dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				dataList.push({
	        					orgnm: 		v.orgnm,
	        					sbjctCd: 	v.sbjctCd,
	        					sbjctnm: 	v.sbjctnm,
	        					dvclasNo: 	v.dvclasNo,
	        					profnm: 	v.profnm,
	        					tutnm: 		v.tutnm,
	        					sbjctId:	v.sbjctId
	    					});
	        			});

	        			sbjctPtcpListSelect();	// 과목별참여목록조회
	        		}

	        		sbjctListTable.clearData();
	        		sbjctListTable.replaceData(dataList);
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		// 과목별참여목록조회
		function sbjctPtcpListSelect() {
			const url = "/srvy/admSrvyLctrEvlSbjctPtcpListAjax.do";
			const data = {
				srvyId 	: "${vo.srvyId}",
				userId	: "${userCtx.userId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
                	let returnList = data.returnList || [];
                	let dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				dataList.push({
								no:			v.lineNo,
	        					orgnm: 		v.orgnm,
	        					sbjctYr: 	v.sbjctYr,
	        					sbjctSmstr: v.sbjctSmstr,
	        					sbjctCd: 	v.sbjctCd,
	        					sbjctnm: 	v.sbjctnm,
	        					dvclasNo: 	v.dvclasNo,
	        					profnm:		v.profnm,
	        					stdntCnt:	v.stdntCnt,
	        					ptcpCnt:	v.ptcpCnt,
	        					notPtcpCnt:	v.notPtcpCnt,
	        					view:		"<button type='button' class='btn basic small' onclick='sbjctPtcpStatus(\"" + v.upSrvyId + "\", \"" + v.sbjctId + "\")'><spring:message code='srvy.label.view.detail' /></button>"/* 상세보기 */
	    					});
	        			});
	        		}

	        		ptcpListTable.clearData();
	        		ptcpListTable.replaceData(dataList);
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		// 과목참여상세현황
		function sbjctPtcpStatus(srvyId, sbjctId) {
			const url  = "/srvy/admSrvyLctrEvlPtcpStatusAjax.do";
			const data = {
				srvyId 	: srvyId,
				sbjctId	: sbjctId,
				orgId	: "${userCtx.orgId}"
			};

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	let returnVO = data.data;
                    	let html = htmlOption.createAdmSrvyPtcpStatusHTML(returnVO);

                    	$("#statusDiv").empty().html(html);
                    	srvyCommon.statusChartSet('status', returnVO.cmmnCdList.cntnDvcTycd, returnVO.egovListMap.ptcpDvcList, returnVO.egovMap);
                		srvyCommon.statusChartSet('device', returnVO.cmmnCdList.cntnDvcTycd, returnVO.egovListMap.ptcpDvcList, returnVO.egovMap);
                		returnVO.srvypprList.forEach(function(ppr,i) {
                			returnVO.srvyQstnList.forEach(function(qstn, ii) {
	                			if(ppr.srvypprId == qstn.srvypprId && (qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC" || qstn.qstnRspnsTycd == "OX_CHC")) {
	                				var labelArray = [];
							    	var colorArray = [];
							    	var dataArray  = [];
							    	returnVO.egovListMap.chcRspnsList.forEach(function(rspns, iii) {
										if(qstn.srvyQstnId == rspns.srvyQstnId) {
											if(rspns.vwitmCts == 'ETC' && rspns.etcInptyn == 'Y') {
							            		labelArray.push("<spring:message code='srvy.label.etc' />");/* 기타 */
											} else {
							            		labelArray.push(UiComm.escapeHtml(rspns.vwitmCts));
											}
						            		colorArray.push(returnVO.colorList[rspns.vwitmSeqno-1].code);
						            		dataArray.push(rspns.joinCnt);
										}
							    	});
							        var ctx = document.getElementById("doughnut"+ppr.srvySeqno+"_"+qstn.qstnSeqno);
							        var myChart = new Chart(ctx, {
							            type: 'doughnut',
							            data: {
								            labels: labelArray,
								            datasets: [{
								                data: dataArray,
								                backgroundColor: colorArray,
								                borderWidth:1
								            }]
							            },
							            options: {
							            	responsive: true,
							                maintainAspectRatio: false,

							                plugins: {
							                    legend: {
							                        position:'bottom',
							                        labels: {
							                            usePointStyle: true,
							                            pointStyle: 'rect',

							                        font: {
							                                size: 16,
							                            },
							                        },
							                    },
							                    title: {
							                        display: false,
							                    },
							                    datalabels: {
							                        color: '#fff',
							                        font: { weight: 'bold', size: 14 },
							                        formatter: (value, context) => {
							                            const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
							                            return (value / total * 100).toFixed(1) + '%';
							                        }
							                    }
							                }
							            },
							            plugins: [ChartDataLabels]
							        });
	                			}
	                		});
                		});
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.info' />", "error"),/* 정보 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
		}
	</script>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="board_top">
							<h3 class="board-title"><spring:message code="srvy.label.lctr.evl.info" /><!-- 강의평가 정보 --></h3>
							<div class="right-area">
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMSBJCTEVLLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
							</div>
						</div>

						<!--table-type-->
						<div class="table-wrap">
							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label class="req"><spring:message code="srvy.label.org" /><!-- 기관 --></label></th>
										<td>${vo.orgnm }</td>
									</tr>
									<tr>
										<th><label class="req"><spring:message code="srvy.label.smstr" /><!-- 학기 --></label></th>
										<td>${vo.smstrChrtnm }</td>
									</tr>
									<tr>
										<th><label for="trgtWhol" class="req"><spring:message code="common.label.ctgr" /><!-- 분류 --></label></th>
										<td>${vo.srvyTrgtGbnnm }</td>
									</tr>
									<tr>
										<th colspan="2"><label class="req"><spring:message code="srvy.label.select.sbjct" /><!-- 과목 선택 --></label></th>
									</tr>
								</tbody>
							</table>
							<div id="list"></div>
							<script>
								// 리스트 테이블
								let sbjctListTable = UiTable("list", {
									lang: "ko",
									height: 250,
									columns: [
										{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm",			headerHozAlign:"center", hozAlign:"center", width:150,	minWidth:150},/* 기관 */
										{title:"<spring:message code='common.label.crsauth.crscd' />", 	field:"sbjctCd",		headerHozAlign:"center", hozAlign:"center",	width:150,	minWidth:150},/* 과목코드 */
										{title:"<spring:message code='srvy.label.sbjct.nm' />", 		field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"left", 	width:0, 	minWidth:280},/* 과목명 */
										{title:"<spring:message code='srvy.label.dvclas' />", 			field:"dvclasNo", 		headerHozAlign:"center", hozAlign:"center", width:50,	minWidth:50},/* 분반 */
										{title:"<spring:message code='common.charge.professor' />", 	field:"profnm", 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120},/* 담당교수 */
										{title:"<spring:message code='srvy.label.charge.tutor' />", 	field:"tutnm",	 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120}/* 담당튜터 */
									]
								});
							</script>
		                    <table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label for="srvyTtl" class="req"><spring:message code="srvy.label.lctr.evl.ttl" /><!-- 강의평가 제목 --></label></th>
										<td>${vo.srvyTtl }</td>
									</tr>
									<tr>
								       	<th><label for="srvyCts" class="req"><spring:message code="srvy.label.lctr.evl.cts" /><!-- 강의평가 내용 --></label></th>
								       	<td>${vo.srvyCts }</td>
									</tr>
									<tr>
										<th><label for="srvyMidExam" class="req"><spring:message code="srvy.label.lctr.evl.type" /><!-- 강의평가 구분 --></label></th>
										<td>
											<c:choose>
												<c:when test="${fn:contains(vo.srvyTycd, 'MIDEXAM') }">
													<spring:message code="srvy.label.mid.exam" /><!-- 중간고사 -->
												</c:when>
												<c:otherwise>
													<spring:message code="srvy.label.lst.exam" /><!-- 기말고사 -->
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th><label for="dateSt" class="req"><spring:message code="srvy.label.lctr.evl.period" /><!-- 강의평가기간 --></label></th>
										<td><uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/></td>
									</tr>
									<tr>
										<th><label for="srvyAcad" class="req"><spring:message code="srvy.label.manage.type" /><!-- 관리구분 --></label></th>
										<td>${vo.srvyWrtTynm }</td>
									</tr>
									<c:if test="${vo.srvyWrtTycd eq 'ACAD_LINK_SRVY' }">
										<tr>
											<th><label><spring:message code="srvy.label.sync.url" /><!-- 연동 URL --></label></th>
											<td>url</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
						<!--//table-type-->

						<div class="board_top">
							<h3 class="board-title"><spring:message code="srvy.label.sbjct.ptcp.status" /><!-- 과목별 참여현황 --></h3>
						</div>
						<div id="sbjctPtcpList"></div>
						<script>
							// 리스트 테이블
							let ptcpListTable = UiTable("sbjctPtcpList", {
								lang: "ko",
								height: 250,
								columns: [
									{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
									{title:"<spring:message code='common.label.org' />", 			field:"orgnm",			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 기관 */
									{title:"<spring:message code='common.year' />", 				field:"sbjctYr",		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 년도 */
									{title:"<spring:message code='common.term' />", 				field:"sbjctSmstr", 	headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 학기 */
									{title:"<spring:message code='common.label.crsauth.crscd' />",	field:"sbjctCd", 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120},/* 과목코드 */
									{title:"<spring:message code='common.subject' />", 				field:"sbjctnm",	 	headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:250},/* 과목 */
									{title:"<spring:message code='common.label.decls.no' />", 		field:"dvclasNo",	 	headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 분반 */
									{title:"<spring:message code='common.professor' />", 			field:"profnm",	 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120},/* 교수 */
									{title:"<spring:message code='common.label.students' />", 		field:"stdntCnt",	 	headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 수강생 */
									{title:"<spring:message code='srvy.label.ptcp' />", 			field:"ptcpCnt",	 	headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 참여 */
									{title:"<spring:message code='srvy.label.not.ptcp' />", 		field:"notPtcpCnt",	 	headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 미참여 */
									{title:"<spring:message code='srvy.label.view.detail' />",		field:"view",	 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120}/* 상세보기 */
								]
							});
						</script>
						<div id="statusDiv"></div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>