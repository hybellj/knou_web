<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/exrcs_sddn_common_inc.jsp" %>
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
					sddnQuizListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			sddnQuizListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			sddnQuizListSelect(1);
		}

		/**
		 * 돌발퀴즈 목록 조회
		 * @param pageNo	이동페이지
		 */
		function sddnQuizListSelect(pageNo) {
			PAGE_INDEX 		= pageNo || PAGE_INDEX;
			SEARCH_VALUE 	= $("#searchValue").val();

			const url   = "/quiz/profExrcsSddnQstnBscListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				sbjctId				: "${vo.sbjctId}",
				qstnGbncd			: "SURPRISE_QUIZ"
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

    	        		sddnQuizListTable.clearData();
    	        		sddnQuizListTable.replaceData(dataList);
    	        		sddnQuizListTable.setPageInfo(data.pageInfo);
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
				dataList.push({
					no: 			v.lineNo,
					gbnnm: 			"<spring:message code='quiz.common.sddn.quiz' />"/* 돌발퀴즈 */,
					dgrsYr: 		v.dgrsYr,
					dgrsSmstrChrt: 	v.dgrsSmstrChrt + "<spring:message code='common.term' />"/* 학기 */,
					lctrWkno: 		v.lctrWkno,
					qstnSeqno: 		v.qstnSeqno,
					qstnTtl: 		"<a href='javascript:exrcsSddnViewMv(\""+v.exrcsSddnQstnBscId+"\", \"PROFSDDNMODIFY\", \"SURPRISE_QUIZ\")' class='header header-icon link'>" + UiComm.escapeHtml(v.qstnTtl) + "</a>",
					qstnCnt: 		v.qstnCnt,
					regDttm: 		UiComm.formatDate(v.regDttm, "date"),
					rgtrnm: 		v.rgtrnm,
					manage: 		"<a href='javascript:sddnQuizExampprPreviewPopup(\"" + v.exrcsSddnQstnBscId + "\")' class='btn basic small'><spring:message code='quiz.button.view.examppr' /></a>"/* 시험지보기 */
				});
			});

			return dataList;
		}

		/**
		 * 돌발퀴즈시험지미리보기팝업
		 * @param exrcsSddnQstnBscId 	- 연습돌발문항기본아이디
		 */
		function sddnQuizExampprPreviewPopup(exrcsSddnQstnBscId) {
			var extData = {
				exrcsSddnQstnBscId 	: exrcsSddnQstnBscId,
				qstnGbncd			: "SURPRISE_QUIZ"
			};

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.sddn.quiz.preview.examppr' />"/* 돌발퀴즈 시험지 미리보기 */,
				width		: 600,
				height		: 500,
				url			: "/quiz/profExrcsQstnExampprPreviewPopup.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData),
				autoresize	: true
			});
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
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
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
                                <spring:message code="quiz.common.sddn.quiz" /><!-- 돌발퀴즈 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" placeholder="<spring:message code='quiz.placeholder.input.sddn.quiz.nm' />"><!-- 돌발퀴즈명 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="sddnQuizListSelect(1)"><spring:message code="common.button.search"/></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="sddnQuizListArea">
							<div class="board_top">
	                            <h3 class="board-title"><spring:message code="common.button.list" /><!-- 목록 --></h3>
	                            <div class="right-area">
						            <a href="javascript:exrcsSddnViewMv('', 'PROFSDDNREGIST', 'SURPRISE_QUIZ')" class="btn type2"><spring:message code="quiz.button.sddn.quiz.regist" /><!-- 돌발퀴즈 등록 --></a>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
	                            </div>
	                        </div>

	                        <%-- 연습문제 리스트 --%>
							<div id="list"></div>

							<script>
								// 리스트 테이블
								let sddnQuizListTable = UiTable("list", {
									lang: "ko",
									pageFunc: sddnQuizListSelect,
									columns: [
										{title:"No", 													field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='quiz.label.type' />", 			field:"gbnnm",				headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 종류 */
										{title:"<spring:message code='common.year' />", 				field:"dgrsYr",				headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 년도 */
										{title:"<spring:message code='common.term' />", 				field:"dgrsSmstrChrt", 		headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 학기 */
										{title:"<spring:message code='quiz.label.lctr.wkno' />", 		field:"lctrWkno", 			headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 강의주차 */
										{title:"<spring:message code='common.no' />", 					field:"qstnSeqno", 			headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100},/* 번호 */
										{title:"<spring:message code='quiz.label.sddn.quiz.ttl' />", 	field:"qstnTtl", 			headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:280},/* 돌발퀴즈 제목 */
										{title:"<spring:message code='quiz.label.create.date' />", 		field:"regDttm",	 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 작성일자 */
										{title:"<spring:message code='common.draftsman' />", 			field:"rgtrnm",	 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 작성자 */
										{title:"<spring:message code='common.mgr' />", 					field:"manage", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 관리 */
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