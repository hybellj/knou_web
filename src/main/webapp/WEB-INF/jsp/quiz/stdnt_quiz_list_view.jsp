<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';	// 검색어 ( 퀴즈명 )
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';		// 현재 페이지
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';		// 목록별 퀴즈 수

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					quizListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			quizListSelect(PAGE_INDEX);
		});

		// listScale변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			quizListSelect(1);
		}

		/**
		 * 퀴즈목록조회
		 * @param pageNo	이동페이지
		 */
		function quizListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/quiz/stdntQuizListAjax.do";
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

    	        		quizListTable.clearData();
    	        		quizListTable.replaceData(dataList);
    	        		quizListTable.setPageInfo(data.pageInfo);
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
				// 진행상태
				let prgrsStatus = {
					"IN_PROGRESS" 	: "<spring:message code='quiz.label.progress' />"/* 진행 중 */,
					"PRE_EXAM"		: "<spring:message code='quiz.label.upcoming' />"/* 진행 전 */,
					"DONE"			: "<spring:message code='quiz.label.deadline' />"/* 마감 */,
					"ERROR"			: "-"
				};
				// 응시상태
				let tkexamStatus = "";
				if(v.tkexamCmptnyn == "N") tkexamStatus = v.retkexamYn == "Y" ? wrapLabel("<spring:message code='quiz.label.not.retkexam' />", "fcRed")/* 재미응시 */ : wrapLabel("<spring:message code='quiz.label.not.tkexam' />", "fcRed")/* 미응시 */;
				if(v.tkexamCmptnyn == "Y") tkexamStatus = v.retkexamYn == "Y" ? "<spring:message code='quiz.label.retkexam' />"/* 재응시 */ : "<spring:message code='quiz.label.tkexam' />"/* 응시 */;
				// 관리
				let mng = "-";
				if(v.examPrgrsSts == "IN_PROGRESS") {
					mng = "<a style='line-height: 40px;' href='javascript:quizTkexamConfirm(\"" + v.examBscId + "\", \"" + v.examDtlId + "\", \"" + v.tkexamCnt + "\")' class='btn basic small'><spring:message code='quiz.button.quiz.tkexam' /></a>"/* 퀴즈응시 */;
				} else if(v.examPrgrsSts == "DONE") {
					mng = "<a style='line-height: 40px;' href='javascript:quizEvlExampprPopup(\"" + v.examBscId + "\", \"" + v.examDtlId + "\", \"" + v.tkexamCmptnyn + "\", \"" + v.tkexamCnt + "\")' class='btn basic small'>​<spring:message code='quiz.button.evl.examppr' /></a>"/* 평가시험지 */;
				}
				dataList.push({
					no: 				v.lineNo,
					examGbnnm: 			v.examGbncd.includes("EXAM") ? wrapLabel(v.examGbnnm, "fcOrange") : v.examGbnnm,
					examTtl: 			"<a href='javascript:quizViewMv(\"" + v.examBscId + "\", \"VIEW\", \"" + v.examDtlId + "\")' class='header header-icon link'>" + UiComm.escapeHtml(v.examTtl) + "</a>",
					examMnts: 			v.examMnts + "<spring:message code='date.minute' />"/* 분 */,
					examDttm: 			UiComm.formatDate(v.examPsblSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.examPsblEdttm, "datetime2"),
					mrkRfltyn: 			v.mrkRfltyn,
					prgrsStatus: 		prgrsStatus[v.examPrgrsSts],
					tkexamStatus: 		tkexamStatus,
					totScr: 			v.evlyn == "Y" && v.mrkOyn == "Y" ? v.totScr + "<spring:message code='message.score' />"/* 점 */ : "-",
					mng: 				mng,
					examBscId: 			v.examBscId,
					reexamDttm: 		UiComm.formatDate(v.reexamPsblSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.reexamPsblEdttm, "datetime2")
				});
			});

			return dataList;
		}

		/**
		 * 퀴즈응시확인
		 * @param examBscId		시험기본아이디
		 * @param examDtlId		시험상세아이디
		 * @param sbjctId		과목아이디
		 */
		function quizTkexamConfirm(examBscId, examDtlId, tkexamCnt) {
			if(tkexamCnt > 0) {
				quizTkexamPopup(examBscId, examDtlId);
			} else {
				const data = "encParams="+EPARAM+"&examBscId="+examBscId+"&examDtlId="+examDtlId;
				dialog = UiDialog("dialog1", {
					title	: "<spring:message code='quiz.label.tkexam.instructions' />"/* 퀴즈 응시 주의사항 */,
					width	: 800,
					height	: 400,
					url		: "/quiz/stdntQuizTkexamPrepInfoPopup.do?"+data
				});
			}
		}

		/**
		 * 퀴즈응시팝업
		 * @param examBscId		시험기본아이디
		 * @param examDtlId		시험상세아이디
		 * @param sbjctId		과목아이디
		 */
		function quizTkexamPopup(examBscId, examDtlId) {
			if(dialog != undefined) closeDialog();
			const data = "encParams="+EPARAM+"&examBscId="+examBscId+"&examDtlId="+examDtlId;
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.quiz.examppr' />"/* 퀴즈 시험지 */,
				url			: "/quiz/stdntQuizTkexamPopup.do?"+data,
				fullscreen	: true
			});
		}

		/**
		 * 평가시험지팝업
		 * @param examBscId 		시험기본아이디
		 * @param examDtlId 		시험상세아이디
		 * @param tkexamCmptnyn 	시험응시완료여부
		 * @param tkexamCnt 		시험응시수
		 */
		function quizEvlExampprPopup(examBscId, examDtlId, tkexamCmptnyn, tkexamCnt) {
			if(tkexamCmptnyn == "N" && tkexamCnt == 0) {
				UiComm.showMessage("<spring:message code='quiz.alert.not.tkexam.examppr' />", "info")/* 응시한 시험지가 없습니다. */;
				return;
			}

			const data = "examBscId="+examBscId+"&examDtlId="+examDtlId;

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.evl.examppr' />"/* 평가시험지 */,
				url			: "/quiz/stdntQuizEvlExampprPopup.do?"+data,
				fullscreen	: true
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
                                <spring:message code="quiz.common.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" placeholder="<spring:message code='quiz.placeholder.input.quiz.nm' />"><!-- 퀴즈명 입력 -->
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="quizListSelect(1)"><spring:message code="common.button.search" /></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="quizListArea">
							<div class="board_top">
	                            <h3 class="board-title"><spring:message code="common.button.list" /><!-- 목록 --></h3>
	                            <div class="right-area">
									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
	                            </div>
	                        </div>

	                        <%-- 퀴즈 리스트 --%>
							<div id="list"></div>

							<%-- 게시글 리스트 카드 폼 --%>
							<div id="list_cardForm" class="lecture_box" style="display:none">
								<div class="card-header">
									#[examGbnnm]
									<div class="card-title">
										#[examTtl]
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title"><spring:message code="quiz.label.period" /><!-- 응시기간 --></label><strong>#[examDttm]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.reperiod" /><!-- 재응시기간 --></label><strong>#[reexamDttm]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.mnts" /><!-- 퀴즈시간 --></label><strong>#[examMnts]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.mrk.rfltyn" /><!-- 성적반영 --></label><strong>#[mrkRfltyn]</strong></p>
										<p><label class="label-title"><spring:message code="quiz.label.evl.scr" /><!-- 평가점수 --></label><strong>#[totScr]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let quizListTable = UiTable("list", {
									lang: "ko",
									pageFunc: quizListSelect,
									columns: [
										{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='common.type' />", 				field:"examGbnnm",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100}/* 구분 */,
										{title:"<spring:message code='quiz.common.quiz' />", 			field:"examTtl",		headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200}/* 퀴즈 */,
										{title:"<spring:message code='quiz.label.mnts' />", 			field:"examMnts", 		headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100}/* 퀴즈시간 */,
										{title:"<spring:message code='quiz.label.period' />", 			field:"examDttm", 		headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280}/* 응시기간 */,
										{title:"<spring:message code='quiz.label.mrk.rfltyn' />", 		field:"mrkRfltyn", 		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100}/* 성적반영 */,
										{title:"<spring:message code='quiz.label.progress.status' />", 	field:"prgrsStatus",	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100}/* 진행상태 */,
										{title:"<spring:message code='quiz.label.attendance' />", 		field:"tkexamStatus",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100}/* 응시여부 */,
										{title:"<spring:message code='quiz.label.evl.scr' />", 			field:"totScr", 		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80}/* 평가점수 */,
										{title:"<spring:message code='common.mgr' />", 					field:"mng", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100}/* 관리 */,
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