<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    <script type="text/javascript">
	    $(function(){
	    });
    </script>
</head>    
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<div class="option-content mb10 gap4">
				<div class="mra">
					<b class="sec_head"><spring:message code="common.label.students.info" /></b> <!-- 수강생 정보 -->
	 			</div>
               	<div class="button-area">
					<%-- <a href="javascript:getExcel()" class="ui basic button"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 --> --%>
				</div>
			</div>
			<ul class="tbl dt-sm">
                <li>
                    <dl>
                        <dt><spring:message code="exam.label.dept" /></dt><!-- 학과 -->
                        <dd>${rVo.deptNm}</dd>
                        <dt><spring:message code="exam.label.user.no" /></dt><!-- 학번 -->
                        <dd>${rVo.userId}</dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt><spring:message code="exam.label.usernm" /></dt><!-- 성명 -->
                        <dd>${rVo.userNm}</dd>
                    </dl>
                </li>
            </ul>
			<div class="option-content mt15 mb10 gap4">
                <div class="mra">
                    <b class="sec_head"><spring:message code="forum.label.itemize.score" /></b><!-- 항목별 점수 -->
                </div>
            </div>
			<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code="exam.common.empty" />">
				<thead>
                    <tr>
                        <th scope="col"><spring:message code="exam.label.stare.type" /></th><!-- 구분 -->
                        <th scope="col" data-breakpoints="xs sm"><spring:message code="std.label.mid_exam" /></th><!-- 중간고사 -->
                        <th scope="col" data-breakpoints="xs sm"><spring:message code="std.label.final_exam" /></th><!-- 기말고사 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="crs.label.nomal_exam" /></th><!-- 수시평가 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="crs.label.attend" />/<spring:message code="dashboard.lesson" /></th><!-- 출석/강의 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="dashboard.cor.asmnt" /></th><!-- 과제 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="dashboard.cor.forum" /></th><!-- 토론 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="dashboard.cor.quiz" /></th><!-- 퀴즈 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="dashboard.cor.resch" /></th><!-- 설문 -->
                        <th scope="col" data-breakpoints="xs sm "><spring:message code="exam.label.sum.point" /></th><!-- 합계 -->
                    </tr>
                </thead>
				<tbody>
	                <tr>
	                    <td><spring:message code="forum.label.weight" /></td><!-- 가중치 -->
	                    <td>${rVo.middleTestScoreRatio}</td>
	                    <td>${rVo.lastTestScoreRatio}</td>
	                    <td>${rVo.testScoreRatio}</td>
	                    <td>${rVo.lessonScoreRatio}</td>
	                    <td>${rVo.assignmentScoreRatio}</td>
	                    <td>${rVo.forumScoreRatio}</td>
	                    <td>${rVo.quizScoreRatio}</td>
	                    <td>${rVo.reshScoreRatio}</td>
	                    <td>${rVo.middleTestScoreRatio + rVo.lastTestScoreRatio + rVo.testScoreRatio + rVo.lessonScoreRatio + rVo.assignmentScoreRatio + rVo.forumScoreRatio + rVo.quizScoreRatio + rVo.reshScoreRatio}%</td>                         
	                </tr>
	                <tr>
	                    <td><spring:message code="forum.label.acquisition.score" /></td><!-- 취득점수 -->
	                    <td>${rVo.middleTestScore}</td>
	                    <td>${rVo.lastTestScore}</td>
	                    <td>${rVo.testScore}</td>
	                    <td>${rVo.lessonScore}</td>
	                    <td>${rVo.assignmentScore}</td>
	                    <td>${rVo.forumScore}</td>
	                    <td>${rVo.quizScore}</td>
	                    <td>${rVo.reshScore}</td>
	                    <td>-</td>                         
	                </tr>
	                <tr>
	                    <td><spring:message code="forum.label.production.score" /></td><!-- 산출점수 -->
	                    <td>${rVo.middleTestScoreAvg}</td>
	                    <td>${rVo.lastTestScoreAvg}</td>
	                    <td>${rVo.testScoreAvg}</td>
	                    <td>${rVo.lessonScoreAvg}</td>
	                    <td>${rVo.assignmentScoreAvg}</td>
	                    <td>${rVo.forumScoreAvg}</td>
	                    <td>${rVo.quizScoreAvg}</td>
	                    <td>${rVo.reshScoreAvg}</td>
	                    <td>${rVo.avgScore}</td>                         
	                </tr>
	                <tr>
	                    <td><spring:message code="asmnt.label.exchange.score" /></td><!-- 환산점수 -->
	                    <td>${rVo.exchScrMidTest}</td>
	                    <td>${rVo.exchScrLastTest}</td>
	                    <td>${rVo.exchScrTest}</td>
	                    <td>${rVo.exchScrLesson}</td>
	                    <td>${rVo.exchScrAsmnt}</td>
	                    <td>${rVo.exchScrForum}</td>
	                    <td>${rVo.exchScrQuiz}</td>
	                    <td>${rVo.exchScrResh}</td>
	                    <td>${rVo.exchTotScr}</td>                         
	                </tr>
	            </tbody>
	        </table>
	        <div class="option-content">
	            <b class="sec_head"><spring:message code="lesson.label.memo" /></b><!-- 메모 -->
	        </div>  
	        <textarea rows="5" readonly="readonly">${rVo.profMemo}</textarea>
	    </div>
	    <div class="bottom-content">
	        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
	    </div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
