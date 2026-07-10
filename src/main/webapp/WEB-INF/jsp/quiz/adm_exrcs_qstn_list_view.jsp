<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/exrcs_sddn_common_inc.jsp" %>
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
				selectOption.smstrChrt('')
			    .then(() => selectOption.sbjct(''))
			    .then(() => exrcsQstnListSelect(1))
			    .catch(() => {});
		    });

			// 학기기수
			$('#smstrChrtId').on('change', function() {
				selectOption.sbjct('')
			    .then(() => exrcsQstnListSelect(1))
			    .catch(() => {});
		    });

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					exrcsQstnListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			selectOption.smstrChrt('')
		    .then(() => selectOption.sbjct(''))
		    .then(() => exrcsQstnListSelect(1))
		    .catch(() => {});
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			exrcsQstnListSelect(1);
		}

		/**
		 * 연습문제 목록 조회
		 * @param pageNo	이동페이지
		 */
		function exrcsQstnListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url 	= "/quiz/admExrcsSddnQstnBscListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				qstnGbncd			: "EXRCS_QSTN",
				orgId				: $("#orgId").val(),
				dgrsYr				: $("#dgrsYr").val(),
				smstrChrtId			: $("#smstrChrtId").val(),
				sbjctId				: $("#sbjctId").val()
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
                error		: () => UiComm.showMessage("<spring:message code='quiz.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				// 출제상태
				let qstnsCmptnyn = wrapLabel("<spring:message code='quiz.label.qstn.temp.save' />", "fcRed");/* 임시저장 */
				if(v.qstnsCmptnyn == 'Y') {
					qstnsCmptnyn = "<spring:message code='quiz.label.qstn.submit.y' />";/* 출제완료 */
				}
				// 미리보기
				let manage = "-";
				if(v.qstnsCmptnyn == 'Y') {
					manage = "<a href='javascript:exrcsQstnExampprPreviewPopup(\"" + v.exrcsSddnQstnBscId + "\")' class='btn basic small'><spring:message code='quiz.button.view.examppr' /></a>";/* 시험지보기 */
				}
				dataList.push({
					no: 				v.lineNo,
					orgnm: 				v.orgnm,
					dgrsYr: 			v.dgrsYr,
					dgrsSmstrChrt: 		v.dgrsSmstrChrt + "<spring:message code='common.term' />",/* 학기 */
					sbjctnm: 			v.sbjctnm,
					gbnnm: 				"<spring:message code='quiz.common.exrcs.qstn' />",/* 연습문제 */
					qstnTtl: 			"<a href='javascript:exrcsSddnViewMv(\""+v.exrcsSddnQstnBscId+"\", \"ADMEXRCSMODIFY\", \"EXRCS_QSTN\", \""+v.sbjctId+"\")' class='header header-icon link'>" + UiComm.escapeHtml(v.qstnTtl) + "</a>",
					qstnCnt: 			v.qstnCnt,
					qstnsCmptnyn: 		qstnsCmptnyn,
					rgtrnm: 			v.rgtrnm,
					manage: 			manage
				});
			});

			return dataList;
		}

		/**
		 * 연습문제시험지미리보기팝업
		 * @param exrcsSddnQstnBscId - 연습돌발문항기본아이디
		 */
		function exrcsQstnExampprPreviewPopup(exrcsSddnQstnBscId) {
			var extData = {
				exrcsSddnQstnBscId 	: exrcsSddnQstnBscId,
				qstnGbncd			: "EXRCS_QSTN"
			};

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.exrcs.qstn.preview.examppr' />",/* 연습문제 시험지 미리보기 */
				url			: "/quiz/admExrcsQstnExampprPreviewPopup.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData),
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
                                <span class="item_tit"><label for="orgId"><spring:message code="common.label.org" /><!-- 기관 --></label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="orgId" disabled="true">
                                        <c:forEach var="org" items="${orgList }">
                                    		<option value="${org.orgId }" ${org.orgId eq userCtx.orgId ? 'selected' : '' }>${org.orgnm }</option>
                                    	</c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="smstrChrtId"><spring:message code="quiz.label.year.smstr" /><!-- 학사년도/학기 --></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="dgrsYr">
                                    	<c:forEach var="year" items="${yearList }">
                                    		<option value="${year }" ${year eq curYear ? 'selected' : '' }>${year }</option>
                                    	</c:forEach>
                                    </select>
                                    <select class="form-select wide" id="smstrChrtId">
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><spring:message code="common.subject" /><!-- 과목 --></label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="sbjctId" onchange="exrcsQstnListSelect(1)">
                                        <option value=""><spring:message code="common.subject" /><!-- 과목 --></option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code="common.label.search.setence" /><!-- 검색어 --></label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='quiz.placeholder.input.examppr.nm' />"><!-- 시험지제목 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="exrcsQstnListSelect(1)"><spring:message code="common.button.search" /><!-- 검색 --></button>
                            </div>
                        </div>

                        <div id="listDiv">
							<div class="board_top">
								<h3 class="board-title"><spring:message code="common.button.list" /><!-- 목록 --></h3>
								<div class="right-area">
									<button type="button" class="btn type1 small" id="authrtRegistBtn" onclick="exrcsSddnViewMv('', 'ADMEXRCSREGIST', 'EXRCS_QSTN')"><spring:message code="quiz.button.exrcs.qstn.regist" /><!-- 연습문제 등록 --></button>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
								</div>
							</div>

							<div id="list"></div>

							<script>
								// 리스트 테이블
								let listTable = UiTable("list", {
									lang: "ko",
									pageFunc: exrcsQstnListSelect,
									columns: [
										{title:"No", 													field:"no",				headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"<spring:message code='common.label.org' />", 			field:"orgnm",			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 기관 */
										{title:"<spring:message code='quiz.label.smstr.year' />", 		field:"dgrsYr",			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 학사년도 */
										{title:"<spring:message code='common.term' />", 				field:"dgrsSmstrChrt", 	headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 학기 */
										{title:"<spring:message code='common.subject' />", 				field:"sbjctnm", 		headerHozAlign:"center", 	hozAlign:"center",	width:0,		minWidth:250},/* 과목 */
										{title:"<spring:message code='quiz.label.type' />", 			field:"gbnnm", 			headerHozAlign:"center", 	hozAlign:"center",	width:80,		minWidth:80},/* 종류 */
										{title:"<spring:message code='quiz.label.examppr.ttl' />", 		field:"qstnTtl", 		headerHozAlign:"center", 	hozAlign:"left",	width:0,		minWidth:250},/* 시험지 제목 */
										{title:"<spring:message code='quiz.label.qstn' />", 			field:"qstnCnt", 		headerHozAlign:"center", 	hozAlign:"center",	width:60,		minWidth:60},/* 문제 */
										{title:"<spring:message code='quiz.label.submit.status' />", 	field:"qstnsCmptnyn", 	headerHozAlign:"center", 	hozAlign:"center",	width:80,		minWidth:80},/* 출제상태 */
										{title:"<spring:message code='common.draftsman' />", 			field:"rgtrnm", 		headerHozAlign:"center", 	hozAlign:"center",	width:0,		minWidth:120},/* 작성자 */
										{title:"<spring:message code='common.mgr' />", 					field:"manage", 		headerHozAlign:"center", 	hozAlign:"center",	width:120,		minWidth:120},/* 관리 */
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