<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			// 학사년도
			$('#dgrsYr').on('change', function() {
				selectOption.smstrChrt()
			    .then(() => srvyListSelect(1))
			    .catch(() => {});
		    });

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					srvyListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			selectOption.smstrChrt()
		    .then(() => srvyListSelect(PAGE_INDEX))
		    .catch(() => {});
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			srvyListSelect(1);
		}

		/*
		 * 전체설문목록조회
		 * @param pageNo	이동페이지
		 */
		function srvyListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url 	= "/srvy/admSrvyListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				dgrsYr				: $("#dgrsYr").val(),
				orgId				: $("#orgId").val(),
				smstrChrtId			: $("#smstrChrtId").val()
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
		function createListHTML(srvyList) {
			let dataList = [];

			if(srvyList.length == 0) return dataList;

			srvyList.forEach(function(v,i) {
				// 결과조회
				let rsltOpenTynm = {
					"WHOL_OPEN"		: "<spring:message code='common.label.allow' />"/* 허용 */,
					"WHOL_CLOSE"	: wrapLabel("<spring:message code='common.label.not.allow' />", "fcRed")/* 비허용 */
				};
				// 진행상태
				let prgrsStatus = {
					"IN_PROGRESS" 	: "<spring:message code='srvy.label.progress' />",/* 진행 중 */
					"PRE_SRVY"		: "<spring:message code='srvy.label.upcoming' />",/* 진행 전 */
					"DONE"			: "<spring:message code='srvy.label.deadline' />",/* 마감 */
					"ERROR"			: "-"
				};
				// 전체설문관리
				let manage  = "<a href='javascript:lctrEvlMngPopup(\"" + v.srvyId + "\")' class='btn basic small'><spring:message code='srvy.button.all.srvy.popup' /></a>";/* 전체설문 팝업관리 */
					manage += "<a href='javascript:srvypprPreviewPopup(\"" + v.srvyId + "\")' class='btn basic small'><spring:message code='srvy.button.preview' /></a>";/* 미리보기 */
					manage += "<a href='javascript:srvyViewMv(\"" + v.srvyId + "\", \"ADMQSTN\")' class='btn basic small'><spring:message code='srvy.button.qstn' /></a>";/* 문항관리 */
				dataList.push({
					no: 				v.lineNo,
					orgnm: 				v.orgnm,
					srvyTrgtTynm: 		v.srvyTrgtTycd == "ALL" ? "<spring:message code='srvy.common.all' />"/* 전체 */ : v.srvyTrgtTynm,
					srvyTtl: 			"<a href='javascript:srvyViewMv(\""+v.srvyId+"\", \"ADMVIEW\")' class='header header-icon link'>" + UiComm.escapeHtml(v.srvyTtl) + "</a>",
					srvyDttm: 			UiComm.formatDate(v.srvySdttm, "datetime2") + " ~ " + UiComm.formatDate(v.srvyEdttm, "datetime2"),
					rsltOpenTycd: 		rsltOpenTynm[v.rsltOpenTycd],
					prgrsStatus: 		prgrsStatus[v.srvyPrgrsSts],
					manage: 			manage
				});
			});

			return dataList;
		}

		/*
		 * 설문지미리보기팝업
		 * @param srvyId	설문아이디
		 */
		function srvypprPreviewPopup(srvyId) {
			 dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.label.preview.all.srvy.srvyppr' />",/* 전체설문 설문지 미리보기 */
				url			: "/srvy/admSrvypprPreviewPopup.do?upSrvyId="+srvyId+"&srvyId="+srvyId+"&searchValue=WHOL",
				fullscreen	: true
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

                        <div class="search-typeB">
                            <div class="item">
                                <span class="item_tit"><label for="orgId"><spring:message code="srvy.label.org" /></label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="orgId" disabled="true">
                                        <c:forEach var="org" items="${orgList }">
                                    		<option value="${org.orgId }" ${org.orgId eq userCtx.orgId ? 'selected' : '' }>${org.orgnm }</option>
                                    	</c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="smstrChrtId"><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="dgrsYr">
                                    	<c:forEach var="year" items="${yearList }">
                                    		<option value="${year }" ${year eq curYear ? 'selected' : '' }>${year }</option>
                                    	</c:forEach>
                                    </select>
                                    <select class="form-select wide" id="smstrChrtId" onchange="srvyListSelect(1)">
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code="common.label.search.setence" /><!-- 검색어 --></label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='srvy.placeholder.input.ttl' />"><!-- 제목 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="srvyListSelect(1)"><spring:message code="srvy.button.search" /><!-- 검색 --></button>
                            </div>
                        </div>

                        <div id="listDiv">
							<div class="board_top">
								<h3 class="board-title"><spring:message code="srvy.label.list" /></h3>
								<div class="right-area">
									<button type="button" class="btn type1 small" id="authrtRegistBtn" onclick="srvyViewMv('', 'ADMREGIST')"><spring:message code="srvy.button.write" /><!-- 등록 --></button>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
								</div>
							</div>

							<div id="list"></div>

							<script>
								// 리스트 테이블
								let listTable = UiTable("list", {
									lang: "ko",
									pageFunc: srvyListSelect,
									columns: [
										{title:"No", 													field:"no",				headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm",			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 기관 */
										{title:"<spring:message code='common.object' />", 				field:"srvyTrgtTynm",	headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 대상 */
										{title:"<spring:message code='srvy.label.all.srvy.ttl' />", 	field:"srvyTtl", 		headerHozAlign:"center", 	hozAlign:"left",	width:0,		minWidth:200},/* 전체설문 제목 */
										{title:"<spring:message code='srvy.label.all.srvy.period' />", 	field:"srvyDttm", 		headerHozAlign:"center", 	hozAlign:"center",	width:280,		minWidth:280},/* 전체설문기간 */
										{title:"<spring:message code='srvy.label.view.result' />", 		field:"rsltOpenTycd", 	headerHozAlign:"center", 	hozAlign:"center",	width:80,		minWidth:80},/* 결과조회 */
										{title:"<spring:message code='srvy.label.progress.status' />", 	field:"prgrsStatus", 	headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 진행상태 */
										{title:"<spring:message code='srvy.label.all.srvy.manage' />", 	field:"manage", 		headerHozAlign:"center", 	hozAlign:"center",	width:300,		minWidth:300},/* 전체설문 관리 */
									]
								});
							</script>
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