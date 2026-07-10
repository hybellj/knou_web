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
	<link rel="stylesheet" href="../../webdoc/assets/css/classroom.css">

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />' || 20;

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					srvyLctrEvlRsltListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			selectOption.smstrChrt()
		    .then(() => selectOption.sbjct())
		    .then(() => srvyLctrEvlRsltListSelect(1))
		    .catch(() => {});
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			srvyLctrEvlRsltListSelect(1);
		}

		/*
		 * 강의평가결과 목록 조회
		 * @param pageNo	이동페이지
		 */
		function srvyLctrEvlRsltListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url 	= "/srvy/admSrvyLctrEvlRsltListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				orgId				: $("#orgId").val(),
				smstrChrtId			: $("#smstrChrtId").val(),
				sbjctId				: $("#sbjctId").val(),
				srvyPtcp			: $("#srvyPtcp").val(),
				srvyId				: "${vo.srvyId}",
				userId				: "${userCtx.userId}"
			};

			$.ajax({
                url			: url,
                type		: "POST",
                data		: param,
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function(data) {
                    if (data.result > 0) {
    	            	let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

    	            	listTable.clearData();
    	        		listTable.replaceData(dataList);
    	        		listTable.setPageInfo(data.pageInfo);

    	        		srvyLctrEvlStatus();	// 설문강의평가현황
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				dataList.push({
					no: 			v.lineNo,
					orgnm: 			v.orgnm,
					userTynm: 		v.userTynm,
					userId: 		v.userId,
					usernm: 		v.usernm,
					ptcpYn: 		v.ptcpEdttm == null ? wrapLabel("<spring:message code='srvy.label.not.ptcp' />", "fcRed")/* 미참여 */ : "<spring:message code='srvy.label.ptcp' />"/* 참여 */,
					ptcpSdttm: 		v.ptcpEdttm == null ? "-" : UiComm.formatDate(v.ptcpSdttm, "datetime2")
				});
			});

			return dataList;
		}

		// 설문강의평가현황
		function srvyLctrEvlStatus() {
			const url  = "/srvy/admSrvyLctrEvlPtcpStatusAjax.do";
			const data = {
				orgId 		: $("#orgId").val(),
				smstrChrtId : $("#smstrChrtId").val(),
				sbjctId		: $("#sbjctId").val(),
				srvyPtcp	: $("#srvyPtcp").val(),
				searchValue	: $("#searchValue").val(),
				srvyId		: "${vo.srvyId}"
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
                    	var html = htmlOption.createAdmSrvyPtcpStatusHTML(returnVO);

                    	$("#srvyStatusDiv").empty().html(html);
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

		/*
		 * 강의평가지엑셀다운로드
		 * @param srvyId		설문아이디
		 */
		function srvyRspnsExcelDown() {
	    	let kvArr = [];
			kvArr.push({'key' : 'srvyId', 	'val' : "${vo.srvyId}"});

			submitForm("/srvy/admLctrEvlRspnsStatusExcelDown.do", kvArr);
		}

		/*
		 * 강의평가결과엑셀다운로드
		 * @param srvyId		설문아이디
		 */
		function srvyPtcpStatusExcelDown() {
			let kvArr = [];
			kvArr.push({'key' : 'srvyId', 	'val' : "${vo.srvyId}"});

			submitForm("/srvy/admLctrEvlPtcpStatusExcelDown.do", kvArr);
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
							<h3 class="board-title"><spring:message code="srvy.button.lctr.evl.result.view" /><!-- 강의평가 결과보기 --></h3>
							<div class="right-area">
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMEVLRSLTLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
							</div>
						</div>

						<%--설문 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/srvy/common/srvy_info_inc.jsp"/>
	                    <%--설문 정보--%>

						<div class="board_top">
							<h3>수강생</h3>
							<div class="right-area">
								<button type="button" class="btn type2" onclick="srvyRspnsExcelDown()"><spring:message code="srvy.button.excel.down.lctr.evl.srvyppr" /><!-- 강의평가지 엑셀다운로드 --></button>
								<button type="button" class="btn type2" onclick="srvyPtcpStatusExcelDown()"><spring:message code="srvy.button.excel.down.lctr.evl.result" /><!-- 강의평가 결과 엑셀다운로드 --></button>
							</div>
						</div>

						<div class="board_top">
                            <select class="form-select wide" id="dgrsYr" disabled="true">
                            	<c:forEach var="year" items="${yearList }">
                            		<option value="${year }" ${year eq vo.dgrsYr ? 'selected' : '' }>${year }</option>
                            	</c:forEach>
                            </select>
                            <select class="form-select" id="smstrChrtId" disabled="true">
                            </select>
                            <select class="form-select" id="orgId" disabled="true">
                                <c:forEach var="org" items="${orgList }">
                                	<option value="${org.orgId }" ${org.orgId eq userCtx.orgId ? 'selected' : '' }>${org.orgnm }</option>
                                </c:forEach>
                            </select>
                            <select class="form-select wide" id="sbjctId" onchange="srvyLctrEvlRsltListSelect(1)">
                            </select>
                            <select class="form-select wide" id="srvyPtcp" onchange="srvyLctrEvlRsltListSelect(1)">
                            	<option value=""><spring:message code="srvy.common.all" /><!-- 전체 --></option>
                            	<option value="COMPLETED"><spring:message code="srvy.label.ptcp" /><!-- 참여 --></option>
                            	<option value="NOPTCP"><spring:message code="srvy.label.not.ptcp" /><!-- 미참여 --></option>
                            </select>
                            <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='srvy.placeholder.input.name.id' />"><!-- 이름/학번 입력 -->
                            <button type="button" class="btn basic icon search" aria-label="검색" onclick="srvyLctrEvlRsltListSelect(1)"><i class="icon-svg-search"></i></button>

                            <div class="right-area">
                                <button type="button" class="btn basic"><spring:message code="srvy.button.message.send" /><!-- 메세지 보내기 --></button>

                                <%-- 목록 스케일 선택 --%>
								<uiex:listScale func="changeListScale" value="${vo.listScale}" />
                            </div>
                        </div>

                        <div>
                        	<div id="list"></div>

							<script>
								// 리스트 테이블
								let listTable = UiTable("list", {
									lang: "ko",
									pageFunc: srvyLctrEvlRsltListSelect,
									selectRow: "checkbox",
									columns: [
										{title:"No", 												field:"no",				headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"<spring:message code='srvy.label.org' />", 			field:"orgnm",			headerHozAlign:"center", 	hozAlign:"center",	width:120,		minWidth:120},/* 기관 */
										{title:"<spring:message code='srvy.label.user.type' />", 	field:"userTynm", 		headerHozAlign:"center", 	hozAlign:"center",	width:150,		minWidth:150},/* 사용자 구분 */
										{title:"<spring:message code='srvy.label.user.id' />", 		field:"userId", 		headerHozAlign:"center", 	hozAlign:"center",	width:150,		minWidth:150},/* 학번/사번 */
										{title:"<spring:message code='srvy.label.user.nm' />", 		field:"usernm",		 	headerHozAlign:"center", 	hozAlign:"center",	width:150,		minWidth:150},/* 이름 */
										{title:"<spring:message code='srvy.label.ptcp.yn' />", 		field:"ptcpYn", 		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 참여여부 */
										{title:"<spring:message code='srvy.label.ptcp.dt' />", 		field:"ptcpSdttm", 		headerHozAlign:"center", 	hozAlign:"center",	width:180,		minWidth:180},/* 참여일시 */
									]
								});
							</script>
                        </div>

                        <div class="srvy_paper_wrap" id="srvyStatusDiv">
						</div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>