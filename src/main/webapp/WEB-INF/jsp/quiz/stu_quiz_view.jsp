<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		$(".accordion").accordion();
	});
	
	// 퀴즈 팝업
	function quizPop(hstyTypeCd) {
		if(hstyTypeCd == "COMPLETE") {
			alert("<spring:message code='exam.error.stare.finished' />"); // 시험지 제출을 이미 완료하였습니다
			return;
		}
		
		var url  = "/quiz/quizCopy.do";
		var data = {
   			examCd : "${vo.examCd}",
   			crsCreCd : "${vo.crsCreCd}",
   			stdNo : "${vo.stdNo}",
   		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO || {};
				
				if(returnVO.hstyTypeCd == "COMPLETE") {
					alert("<spring:message code='exam.error.stare.finished' />"); // 시험지 제출을 이미 완료하였습니다
					return;
				}
				
				var kvArr = [];
				kvArr.push({'key' : 'examCd', 	'val' : "${vo.examCd}"});
				kvArr.push({'key' : 'stdNo', 	'val' : "${vo.stdNo}"});
				kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
				kvArr.push({'key' : 'goUrl',	'val' : "tempForm"});
				
				submitForm("/quiz/quizJoinAlarmPop.do", "quizPopIfm", "joinInfo", kvArr); // 퀴즈
			} else {
				alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
		}, true);
	}
	
	// 제출답안 팝업
	function quizAnswerPop() {
		var url  = "/quiz/quizCopy.do";
		var data = {
   			examCd : "${vo.examCd}",
   			crsCreCd : "${vo.crsCreCd}",
   			stdNo : "${vo.stdNo}",
   		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO || {};
				
				if(returnVO.gradeViewYn != "Y") {
					alert("<spring:message code='exam.alert.quiz.grade.view.n' />"); // 시험지 비공개 퀴즈입니다.
					return;
				}
				
				if(returnVO.imdtAnsrViewYn != "Y" && returnVO.examStatus != "완료") {
					alert("<spring:message code='exam.alert.already.quiz.answer.pop' />"); // 퀴즈기간 종료 후 확인 가능합니다.
					return;
				}
				
				var kvArr = [];
				kvArr.push({'key' : 'examCd', 	'val' : "${vo.examCd}"});
				kvArr.push({'key' : 'stdNo', 	'val' : "${vo.stdNo}"});
				kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
				kvArr.push({'key' : 'goUrl',	'val' : "tempForm"});
				
				submitForm("/quiz/quizSubmitAnswerPop.do", "quizPopIfm", "answer", kvArr);
        	} else {
        		alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
		}, true);
	}
	
	// 목록
	function viewQuizList() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/quiz/Form/stuQuizList.do", "", "", kvArr);
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
        				<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="exam.label.quiz" />', '<spring:message code="exam.label.info" />');
						});
						</script>
		                <div id="info-item-box">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
                            <div class="button-area">
				                <a href="javascript:viewQuizList()" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
                            </div>
                        </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
									<div class="title active">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
													<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
													<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examEndDttm }" />
													<fmt:formatDate var="examEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
													<p class="lect_name">${fn:escapeXml(vo.examTitle) }</p>
													<span class="fcGrey">
														<small><spring:message code="exam.label.quiz" /><!-- 퀴즈 --> <spring:message code="exam.label.period" /><!-- 기간 --> : ${examStartDttm } ~ ${examEndDttm }</small> |
														<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.scoreAplyYn eq 'Y' ? yes : no }</small> |
														<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.scoreOpenYn eq 'Y' ? yes : no }</small>
													</span>
												</div>
											</div>
										</div>
										<i class="dropdown icon ml20"></i>
									</div>
									<div class="content active">
										<div class="ui segment">
											<ul class="tbl">
												<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.cts" /></label><!-- 퀴즈 --><!-- 내용 -->
														</dt>
														<dd><pre>${vo.examCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="exam.label.quiz" /><!-- 퀴즈 --><spring:message code="exam.label.period" /><!-- 기간 --></label>
														</dt>
														<dd>${examStartDttm } ~ ${examEndDttm }</dd>
														<dt>
															<label><spring:message code="exam.label.view.qstn.type" /><!-- 문제표시방식 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.viewQstnTypeCd eq 'ALL' }">
																	<spring:message code="exam.label.all.view.qstn" /><!-- 전체문제 표시 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="exam.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.time" /></label><!-- 퀴즈 --><!-- 시간 -->
														</dt>
														<dd>${vo.examStareTm }<spring:message code="exam.label.stare.min" /><!-- 분 --></dd>
														<dt>
															<label><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --></label>
														</dt>
														<dd>${vo.scoreAplyYn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
														</dt>
														<dd>
															<c:forEach var="list" items="${vo.fileList }">
																<button class="ui icon small button" id="file_${list.fileSn }" title="파일다운로드" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
																<script>
																	byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
																</script>
															</c:forEach>
														</dd>
														<dt></dt>
														<dd></dd>
													</dl>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="row" style="<%=("Y".equals(SessionInfo.getAuditYn(request)) ? "display:none" : "")%>">
									<div class="col">
										<div class="option-content">
											<h3><spring:message code="exam.button.stare.hsty" /><!-- 응시기록 --></h3>
											<div class="mla">
												<c:if test="${(vo.examStatus eq '진행' || vo.stuReExamYn eq 'Y' && vo.reExamStatus eq '진행') && vo.stareYn ne 'Y' && PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
								               		<a href="javascript:quizPop('${vo.hstyTypeCd}')" class="ui blue button">
								               			<c:choose>
								               				<c:when test="${vo.hstyTypeCd eq 'COMPLETE' }">
								               					<spring:message code="exam.button.stare.start" /> <spring:message code="exam.label.complete" /><!-- 응시 --><!-- 완료 -->
								               				</c:when>
								               				<c:otherwise>
										               			<spring:message code="exam.label.quiz" /> <spring:message code="exam.button.stare.start" /><!-- 퀴즈 --><!-- 응시 -->
								               				</c:otherwise>
								               			</c:choose>
								               		</a>
								                </c:if>
											</div>
										</div>
										<ul class="tbl-simple dt-sm pl20">
											<li>
												<dl>
													<dt><label for="teamLabel"><spring:message code="exam.label.stare.dttm" /><!-- 응시일시 --></label></dt>
													<dd>
														<c:choose>
															<c:when test="${vo.stareYn eq 'Y' }">
																<fmt:parseDate var="startFmt" pattern="yyyyMMddHHmmss" value="${vo.startDttm }" />
																<fmt:formatDate var="startDttm" pattern="yyyy.MM.dd HH:mm" value="${startFmt }" />
																${startDttm }
															</c:when>
															<c:otherwise>
																-
															</c:otherwise>
														</c:choose>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="teamLabel"><spring:message code="exam.label.stare.paper" /><!-- 응시시험지 --></label></dt>
													<dd>
														<c:choose>
															<c:when test="${((vo.hstyTypeCd eq 'COMPLETE' && vo.imdtAnsrViewYn eq 'Y') || vo.examStatus eq '완료') && PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
										               			<a href="javascript:quizAnswerPop()" class="ui blue button"><spring:message code="exam.button.review.answer" /></a><!-- 제출답안 -->
															</c:when>
															<c:otherwise>
																-
															</c:otherwise>
														</c:choose>
													</dd>
												</dl>
											</li>
											<li>
												<dl>
													<dt><label for="teamLabel"><spring:message code="exam.label.eval.stare.status" /><!-- 응시/평가현황 --></label></dt>
													<dd>
														<c:choose>
															<c:when test="${vo.stareYn eq 'Y' }">
																<c:choose>
																	<c:when test="${vo.scoreOpenYn eq 'Y' && vo.stuEvalYn eq 'Y' }">
																		${vo.totGetScore }<spring:message code="exam.label.score.point" /><!-- 점 -->
																	</c:when>
																	<c:otherwise>
																		<spring:message code="exam.label.complete.stare" /><!-- 응시완료 -->
																	</c:otherwise>
																</c:choose>
															</c:when>
															<c:otherwise>
																<spring:message code="exam.label.no.stare" /><!-- 미응시 -->
															</c:otherwise>
														</c:choose>
													</dd>
												</dl>
											</li>
										</ul>
									</div>
								</div>
		                	</div>
		                </div>
        			</div>
        		</div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>