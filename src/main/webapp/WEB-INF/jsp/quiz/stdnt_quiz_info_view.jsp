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
		$(document).ready(function () {
			if("${vo.examPrgrsSts }" != "DONE") {
				tkexamHstryListSelect();
			}
		});

		// 응시이력목록조회
		function tkexamHstryListSelect() {
			const url  = "/quiz/stdntQuizTkexamHstryListAjax.do";
			const data = {
				examDtlId : "${vo.examDtlId}"
			};

			ajaxCall(url, data, function (data) {
	            if (data.result > 0) {
	            	let returnList = data.returnList || [];
	            	let dataList = createListHTML(returnList);	// 목록 HTML 생성

	            	hstryListTable.clearData();
	        		hstryListTable.replaceData(dataList);

	        		$("#tkexamDiv > .msg-box").toggle(returnList.length == 0);
	        		$("#tkexamDiv > #hstryList").toggle(returnList.length > 0);
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        }, true);
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				let minutes 	= Math.floor(v.tkexamMnts / 60);
				let seconds 	= v.tkexamMnts % 60;
				let tkexamMnts	= (minutes != 0 ? String(minutes).padStart(2, '0') : "-") + "<spring:message code='date.minute' /> "/* 분 */ + (seconds != 0 ? String(seconds).padStart(2, '0') : "-") + "<spring:message code='date.second' />"/* 초 */;

				dataList.push({
					no: 			v.lineNo,
					hstryGbnnm:		v.hstryGbnnm,
					tkexamSdttm: 	UiComm.formatDate(v.tkexamSdttm, "datetime"),
					tkexamEdttm: 	v.tkexamEdttm != null ? UiComm.formatDate(v.tkexamEdttm, "datetime") : "-",
					tkexamMnts: 	tkexamMnts
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
		function quizTkexamConfirm() {
			if("${rsltVO.tkexamCnt}" > "0") {
				quizTkexamPopup("${vo.examBscId}", "${vo.examDtlId}");
			} else {
				const data = "encParams="+EPARAM+"&examBscId=${vo.examBscId}&examDtlId=${vo.examDtlId}";
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
		 * @param examBscId 	시험기본아이디
		 * @param examDtlId 	험상세아이디
		 * @param sbjctId		과목아이디
		 */
		function quizTkexamPopup(examBscId, examDtlId, tkexamId) {
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
		function quizEvlExampprPopup() {
			if("${rsltVO.tkexamCmptnyn}" == "N" && "${rsltVO.tkexamCnt}" == "0") {
				UiComm.showMessage("<spring:message code='quiz.alert.not.tkexam.examppr' />", "info");/* 응시한 시험지가 없습니다. */
				return;
			}

			const data = "examBscId=${vo.examBscId}&examDtlId=${vo.examDtlId}";

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.evl.examppr' />"/* 평가시험지 */,
				url			: "/quiz/stdntQuizEvlExampprPopup.do?"+data,
				fullscreen	: true
			});
		}

		// 팀구성원팝업
		function teamMbrPopup() {
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.team.members' />"/* 팀 구성원 */,
				width		: 400,
				height		: 500,
				url			: "/quiz/quizTeamMbrPopup.do?teamCd=${vo.teamId}"
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

						<div class="listTab">
					        <ul>
					            <li class="select"><a onclick="quizViewMv('${vo.examBscId}', 'VIEW', '${vo.examDtlId }')"><spring:message code="quiz.tab.tkexam" /><!-- 퀴즈정보 및 응시 --></a></li>
					        </ul>
					    </div>

					    <div class="board_top">
				        	<h3 class="board-title"><spring:message code="quiz.tab.tkexam" /><!-- 퀴즈정보 및 응시 --></h3>
					        <div class="right-area">
					        	<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
						        	<a href="javascript:teamMbrPopup()" class="btn type2 big"><spring:message code="quiz.label.team.members" /><!-- 팀 구성원 --></a>
					        	</c:if>
								<a href="javascript:quizViewMv('${vo.examBscId}', 'STDLIST')" class="btn type2 big"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

				        <%--퀴즈 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/quiz/common/quiz_info_inc.jsp"/>
	                    <%--퀴즈 정보--%>

                        <div class="board_top">
                            <h4 class="sub-title"><spring:message code="quiz.label.quiz.tkexam" /><!-- 퀴즈 응시 --></h4>
                        </div>

                        <div id="tkexamDiv">
                        	<c:choose>
                        		<c:when test="${vo.examPrgrsSts ne 'DONE' }">
		                        	<div class="msg-box">
										<p class="txt"><strong><spring:message code="quiz.label.notice" /><!-- 안내 --> : </strong><spring:message code="quiz.label.quiz.tkexam.notice" /><!-- 퀴즈 응시 전입니다. 퀴즈 응시하시기 바랍니다. --></p>
									</div>
		                        	<div id="hstryList"></div>
			                        <script>
										// 리스트 테이블
										let hstryListTable = UiTable("hstryList", {
											lang: "ko",
											columns: [
												{title:"<spring:message code='common.no' />", 				field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},/* 번호 */
												{title:"<spring:message code='common.type' />", 			field:"hstryGbnnm",		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:200},/* 구분 */
												{title:"<spring:message code='quiz.label.quiz.start' />", 	field:"tkexamSdttm",	headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},/* 퀴즈 시작 */
												{title:"<spring:message code='quiz.label.quiz.end' />", 	field:"tkexamEdttm",	headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},/* 퀴즈 종료 */
												{title:"<spring:message code='quiz.label.tkexam.mnts' />", 	field:"tkexamMnts", 	headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:200},/* 응시 시간 */
											]
										});
									</script>
                        		</c:when>
                        		<c:otherwise>
                        			<table class="table-type5">
	                                    <colgroup>
	                                    	<col class="width-15per" />
	                                    	<col class="" />
	                                    </colgroup>
	                                    <tbody>
	                                    	<tr>
		                                   		<th><spring:message code="quiz.label.tkexam.dttm" /><!-- 응시 일시 --></th>
		                                   		<td><uiex:formatDate value="${rsltVO.tkexamSdttm}" type="datetime2"/></td>
	                                    	</tr>
	                                    	<tr>
	                                    		<th><spring:message code="quiz.button.evl.examppr" /><!-- 평가시험지 --></th>
	                                    		<td>
	                                    			<button type="button" class="btn type1 small" onclick="quizEvlExampprPopup()"><spring:message code="quiz.button.evl.examppr" /><!-- 평가시험지 --></button>
	                                    		</td>
	                                    	</tr>
	                                    	<tr>
	                                    		<th><spring:message code="quiz.label.evl.scr" /><!-- 평가점수 --></th>
	                                    		<td>${rsltVO.evlyn eq 'Y' && vo.mrkOyn eq 'Y' ? rsltVO.totScr : '-' }<spring:message code="message.score" /><!-- 점 --></td>
	                                    	</tr>
	                                    </tbody>
	                            	</table>
                        		</c:otherwise>
                        	</c:choose>
                        </div>

                        <c:if test="${vo.examPrgrsSts eq 'IN_PROGRESS' && vo.tkexamCmptnyn eq 'N' }">
	                        <div class="btns">
	                            <button type="button" class="btn type1" onclick="quizTkexamConfirm()"><spring:message code="quiz.button.tkexam" /><!-- 응시하기 --></button>
	                        </div>
                        </c:if>
		        	</div>
		        </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>