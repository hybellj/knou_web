<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					srvyListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			srvyListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			srvyListSelect(1);
		}

		// 설문목록조회
		function srvyListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/srvy/stdntSrvyListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				sbjctId				: "${vo.sbjctId}"
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
				// 설문구분
				let srvyGbnnm = {
					"SRVY"		: "<spring:message code='srvy.common.srvy' />"/* 설문 */,
					"SRVY_TEAM"	: "<spring:message code='srvy.common.srvy.team' />"/* 설문 팀 */
				};
				// 진행상태
				let prgrsStatus = {
					"IN_PROGRESS" 	: "<spring:message code='srvy.label.progress' />"/* 진행 중 */,
					"PRE_SRVY"		: "<spring:message code='srvy.label.upcoming' />"/* 진행 전 */,
					"DONE"			: "<spring:message code='srvy.label.deadline' />"/* 마감 */,
					"ERROR"			: "-"
				};
				// 관리
				let mng = "-";
				if(v.srvyPrgrsSts == "IN_PROGRESS") {
					mng = "<a style='line-height: 40px;' href='javascript:popupOption.srvyPtcp(\"" + v.srvyId + "\", \"" + v.upSrvyId + "\", \"" + (v.srvyPtcpId || "") + "\", \"" + v.sbjctId + "\", \"SRVY\")' class='btn basic small'>" + (v.ptcpSdttm == null ? "<spring:message code='srvy.button.ptcp' />"/* 참여하기 */ : "<spring:message code='srvy.button.edit' />"/* 수정하기 */) + "</a>";
				} else if(v.srvyPrgrsSts == "DONE") {
					mng = "<a style='line-height: 40px;' href='javascript:popupOption.srvyResult(\"" + v.srvyId + "\", \"\", \"" + (v.ptcpEdttm || "") + "\", \"" + v.sbjctId + "\", \"SRVY\")' class='btn basic small'><spring:message code='srvy.button.srvy.result' />​</a>";/* 설문결과 */
				}
				dataList.push({
					no: 				v.lineNo,
					srvyGbnnm: 			srvyGbnnm[v.srvyGbn],
					srvyTtl: 			"<a href='javascript:srvyViewMv(\""+v.srvyId+"\", \"STDVIEW\", \"" + v.upSrvyId + "\")' class='header header-icon link'>" + UiComm.escapeHtml(v.srvyTtl) + "</a>",
					srvyDttm: 			UiComm.formatDate(v.srvySdttm, "datetime2") + " ~ " + UiComm.formatDate(v.srvyEdttm, "datetime2"),
					mrkRfltyn: 			v.mrkRfltyn,
					prgrsStatus: 		prgrsStatus[v.srvyPrgrsSts],
					ptcpStatus: 		v.ptcpEdttm != null ? "<spring:message code='srvy.label.ptcp' />"/* 참여 */ : wrapLabel("<spring:message code='srvy.label.not.ptcp' />", "fcRed")/* 미참여 */,
					ptcpEvlScr: 		v.srvyPtcpEvlyn == "Y" ? v.ptcpEvlScr + "<spring:message code='srvy.label.score.point' />"/* 점 */ : "-",
					mng: 				mng,
					srvyId: 			v.srvyId,
					upSrvyId:			v.upSrvyId
				});
			});

			return dataList;
		}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

		        <div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

		        	<div class="sub-content">
				        <div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="srvy.common.srvy" /><!-- 설문 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" placeholder="<spring:message code='srvy.placeholder.input.srvy.ttl' />"><!-- 설문명 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="srvyListSelect(1)"><spring:message code='srvy.button.search'/><!-- 검색 --></button>
                            </div>
                        </div>

						<div id="srvyListArea">
							<div class="board_top">
	                            <h3 class="board-title"><spring:message code="srvy.label.list" /><!-- 목록 --></h3>
	                            <div class="right-area">
									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
	                            </div>
	                        </div>

	                        <%-- 설문 리스트 --%>
							<div id="list"></div>

							<%-- 게시글 리스트 카드 폼 --%>
							<div id="list_cardForm" class="lecture_box" style="display:none">
								<div class="card-header">
									#[srvyGbnnm]
									<div class="card-title">
										#[srvyTtl]
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title"><spring:message code="srvy.label.period" /><!-- 설문기간 --></label><strong>#[srvyDttm]</strong></p>
										<p><label class="label-title"><spring:message code="srvy.label.score.ratio" /><!-- 성적 반영비율 --></label><strong>#[mrkRfltrt]</strong></p>
										<p><label class="label-title"><spring:message code="srvy.label.evl.status" /><!-- 평가현황 --></label><strong>#[evlStatus]</strong></p>
										<p><label class="label-title"><spring:message code="srvy.label.score.open.yn" /><!-- 성적공개 --></label><strong>#[mrkOyn]</strong></p>
									</div>
								</div>
							</div>

							<script>
								let listTable = UiTable("list", {
									lang: "ko",
									pageFunc: srvyListSelect,
									columns: [
										{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='srvy.label.type' />", 			field:"srvyGbnnm",		headerHozAlign:"center", hozAlign:"left",	width:100,	minWidth:100},/* 구분 */
										{title:"<spring:message code='srvy.common.srvy' />", 			field:"srvyTtl",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},/* 설문 */
										{title:"<spring:message code='srvy.label.period' />", 			field:"srvyDttm", 		headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},/* 설문기간 */
										{title:"<spring:message code='srvy.label.score.aply.yn' />", 	field:"mrkRfltyn", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 성적반영 */
										{title:"<spring:message code='srvy.label.progress.status' />", 	field:"prgrsStatus",	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 진행상태 */
										{title:"<spring:message code='srvy.label.ptcp.yn' />", 			field:"ptcpStatus",	 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 참여여부 */
										{title:"<spring:message code='srvy.label.evl.score' />", 		field:"ptcpEvlScr", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 평가점수 */
										{title:"<spring:message code='srvy.label.manage' />", 			field:"mng", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 관리 */
									]
								});
							</script>
						</div>
		        	</div>
		        </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>