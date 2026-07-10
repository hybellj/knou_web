<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			selectOption.smstrChrt();

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					wholSrvyListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			wholSrvyListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			wholSrvyListSelect(1);
		}

		/*
		 * 전체설문목록조회
		 * @param pageNo	이동페이지
		 */
		function wholSrvyListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url 	= "/srvy/trgtWholSrvyListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue			: SEARCH_VALUE,
				pageSize 			: 10,
				dgrsYr				: $("#dgrsYr").val(),
				smstrChrtId			: $("#smstrChrtId").val(),
				orgId				: $("#orgId").val()
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
				// 결과공개
				let rsltOpenTynm = {
					"WHOL_OPEN"		: "<spring:message code='srvy.label.open.y' />"/* 공개 */,
					"WHOL_CLOSE"	: wrapLabel("<spring:message code='srvy.label.open.n' />", "fcRed")/* 비공개 */
				};
				// 관리
				let manage = "-";
				if(v.srvyPrgrsSts == "IN_PROGRESS") {
					manage = "<button type='button' class='btn basic small' onclick='popupOption.srvyPtcp(\"" + v.srvyId + "\", \"\", \"\", \"\", \"WHOL\")'><spring:message code='srvy.button.srvy.ptcp' /></button>";/* 설문참여 */
				} else if(v.srvyPrgrsSts == "DONE" && v.rsltOpenTycd == "WHOL_OPEN") {
					manage = "<button type='button' class='btn basic small' onclick='popupOption.srvyResult(\"" + v.srvyId + "\", \"\", \"" + (v.ptcpEdttm || "") + "\", \"\", \"WHOL\")'><spring:message code='srvy.button.status.submit' /></button>";/* 제출현황 */
				}
				dataList.push({
					no: 			v.lineNo,
					dgrsYr: 		v.dgrsYr,
					dgrsSmstrChrt: 	v.dgrsSmstrChrt,
					orgnm: 			v.orgnm,
					srvyTtl: 		v.srvyTtl,
					srvyDttm: 		UiComm.formatDate(v.srvySdttm, "datetime2") + " ~ " + UiComm.formatDate(v.srvyEdttm, "datetime2"),
					qstnCnt: 		v.qstnCnt,
					rsltOpenTynm: 	rsltOpenTynm[v.rsltOpenTycd],
					manage: 		manage
				});
			});

			return dataList;
		}
	</script>
</head>

<body class="home colorA ${bodyClass}">
    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
	        <jsp:param name="userId" value="${userCtx.userId}"/>
	    </jsp:include>

        <main class="common">

			<!-- gnb -->
			<c:choose>
				<c:when test="${userTycd eq 'PROF'}">
		            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
				</c:when>
				<c:otherwise>
					<jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp"/>
				</c:otherwise>
			</c:choose>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<div class="dashboard_sub">
					<div class="sub-content">
						<div class="page-info">
	                        <h2 class="page-title"><spring:message code="srvy.common.all.srvy" /><!-- 전체설문 --></h2>
	                        <uiex:navibar type="main"/>
	                    </div>

	                    <div class="search-typeA">
	                    	<div class="item">
                                <span class="item_tit"><label for="smstrChrtId"><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="dgrsYr" onchange="selectOption.smstrChrt()">
                                    	<c:forEach var="year" items="${yearList }">
                                    		<option value="${year }" ${year eq curYear ? 'selected' : '' }>${year }</option>
                                    	</c:forEach>
                                    </select>
                                    <select class="form-select wide" id="smstrChrtId" onchange="wholSrvyListSelect(1)">
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="orgId"><spring:message code="common.search.keyword" /><!-- 검색어 --></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId" onchange="wholSrvyListSelect(1)">
                                        <c:forEach var="org" items="${orgList }">
                                    		<option value="${org.orgId }" ${org.orgId eq userCtx.orgId ? 'selected' : '' }>${org.orgnm }</option>
                                    	</c:forEach>
                                    </select>
                                    <input type="text" id="searchValue" class="form-control wide" placeholder="<spring:message code='srvy.placeholder.input.srvy.ttl' />" /><!-- 설문명 입력 -->
	                            </div>
	                            <div class="button-area">
	                                <button type="button" class="btn search" onclick="wholSrvyListSelect(1)"><spring:message code="srvy.button.search" /><!-- 검색 --></button>
	                            </div>
		                    </div>
		                </div>

	                    <div id="listDiv">
							<div class="board_top">
								<h3 class="board-title"><spring:message code="srvy.common.all.srvy" /><!-- 전체설문 --></h3>

								<div class="right-area">
									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
								</div>
							</div>

							<div id="list"></div>

							<script>
								// 리스트 테이블
								let listTable = UiTable("list", {
									lang: "ko",
									pageFunc: wholSrvyListSelect,
									columns: [
										{title:"No", 													field:"no",				headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"<spring:message code='srvy.label.year' />", 			field:"dgrsYr",			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 년도 */
										{title:"<spring:message code='srvy.label.smstr' />", 			field:"dgrsSmstrChrt",	headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 학기 */
										{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm", 			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 기관 */
										{title:"<spring:message code='srvy.label.title' />", 			field:"srvyTtl", 		headerHozAlign:"center", 	hozAlign:"left",	width:0,		minWidth:250},/* 설문명 */
										{title:"<spring:message code='srvy.label.period' />", 			field:"srvyDttm", 		headerHozAlign:"center", 	hozAlign:"center",	width:280,		minWidth:280},/* 설문기간 */
										{title:"<spring:message code='srvy.label.qstn.cnt' />", 		field:"qstnCnt", 		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 문항수 */
										{title:"<spring:message code='srvy.label.result.open.y' />", 	field:"rsltOpenTynm",	headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 결과공개 */
										{title:"<spring:message code='srvy.label.manage' />", 			field:"manage", 		headerHozAlign:"center", 	hozAlign:"center",	width:130,		minWidth:130}/* 관리 */
									]
								});
							</script>
						</div>
					</div>
				</div>
            </div>
            <!-- //content -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
        </main>
    </div>
</body>
</html>