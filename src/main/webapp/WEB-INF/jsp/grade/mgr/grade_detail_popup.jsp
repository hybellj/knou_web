<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    <script type="text/javascript">
	    $(document).ready(function() {
	    });
	    
	    // 이전 팝업
	    function prevPop() {
	    	var dataMap = {
			   	crsCreCd : "${stdVO.crsCreCd}",
			   	stdNo 	 : "",
			   	action 	 : "/grade/gradeMgr/gradeStatusPopup.do",
			   	form 	 : "gradeStatusForm",
			   	type	 : "prev"
		    };
		    window.parent.postMessage(dataMap, "*");
	    }
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page">
        <div id="wrap">
        	<h3 class="sec_head"><spring:message code="common.label.students.info" /><!-- 수강생 정보 --></h3>
        	<table class="tBasic">
        		<tbody>
        			<tr>
        				<th><spring:message code="common.dept_name" /><!-- 학과 --></th>
        				<td>${stdVO.deptNm }</td>
        				<th><spring:message code="common.label.student.number" /><!-- 학번 --></th>
        				<td>${stdVO.userId }</td>
        				<th><spring:message code="user.title.userinfo.manage.user.nm" /><!-- 성명 --></th>
        				<td>${stdVO.userNm }</td>
        			</tr>
        		</tbody>
        	</table>
        	<h3 class="sec_head mt20"><spring:message code="score.label.each.item.score" /><!-- 항목별 점수 --></h3>
        	<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.content.not_found' />"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th><spring:message code="common.type" /><!-- 구분 --></th>
        				<c:if test="${gradeVo.lessonScoreRatio > 0 }"><th><spring:message code="common.label.attendance" /><!-- 출석 --></th></c:if>
        				<c:if test="${gradeVo.middleTestScoreRatio > 0 }"><th><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></th></c:if>
        				<c:if test="${gradeVo.lastTestScoreRatio > 0 }"><th><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></th></c:if>
        				<c:if test="${gradeVo.testScoreRatio > 0 }"><th><spring:message code="exam.label.always.exam" /><!-- 수시평가 --></th></c:if>
        				<c:if test="${gradeVo.assignmentScoreRatio > 0 }"><th><spring:message code="common.label.tasks" /><!-- 과제 --></th></c:if>
        				<c:if test="${gradeVo.forumScoreRatio > 0 }"><th><spring:message code="common.label.discussion" /><!-- 토론 --></th></c:if>
        				<c:if test="${gradeVo.quizScoreRatio > 0 }"><th><spring:message code="common.label.question.resch" /><!-- 퀴즈 및 설문 --></th></c:if>
        				<c:if test="${gradeVo.reshScoreRatio > 0 }"><th><spring:message code="common.etc" /><!-- 기타 --></th></c:if>
        				<th><spring:message code="message.total" /><!-- 합계 --></th>
        			</tr>
        		</thead>
        		<tbody>
        			<tr>
        				<td><spring:message code="score.label.weight" /><!-- 가중치 --></td>
        				<c:if test="${gradeVo.lessonScoreRatio > 0 }"><td>${gradeVo.lessonScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.middleTestScoreRatio > 0 }"><td>${gradeVo.middleTestScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.lastTestScoreRatio > 0 }"><td>${gradeVo.lastTestScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.testScoreRatio > 0 }"><td>${gradeVo.testScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.assignmentScoreRatio > 0 }"><td>${gradeVo.assignmentScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.forumScoreRatio > 0 }"><td>${gradeVo.forumScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.quizScoreRatio > 0 }"><td>${gradeVo.quizScoreRatio }%</td></c:if>
        				<c:if test="${gradeVo.reshScoreRatio > 0 }"><td>${gradeVo.reshScoreRatio }%</td></c:if>
        				<td>${gradeVo.totalScoreRatio }%</td>
        			</tr>
        			<tr>
        				<td><spring:message code="score.label.acquired.score" /><!-- 취득점수 --></td>
        				<c:if test="${gradeVo.lessonScoreRatio > 0 }"><td>${sovo.lessonScore }</td></c:if>
        				<c:if test="${gradeVo.middleTestScoreRatio > 0 }"><td>${sovo.middleTestScore }</td></c:if>
        				<c:if test="${gradeVo.lastTestScoreRatio > 0 }"><td>${sovo.lastTestScore }</td></c:if>
        				<c:if test="${gradeVo.testScoreRatio > 0 }"><td>${sovo.testScore }</td></c:if>
        				<c:if test="${gradeVo.assignmentScoreRatio > 0 }"><td>${sovo.assignmentScore }</td></c:if>
        				<c:if test="${gradeVo.forumScoreRatio > 0 }"><td>${sovo.forumScore }</td></c:if>
        				<c:if test="${gradeVo.quizScoreRatio > 0 }"><td>${sovo.quizScore }</td></c:if>
        				<c:if test="${gradeVo.reshScoreRatio > 0 }"><td>${sovo.reshScore }</td></c:if>
        				<td>-</td>
        			</tr>
        			<tr>
        				<td><spring:message code="score.label.calculation.score" /><!-- 산출점수 --></td>
        				<c:if test="${gradeVo.lessonScoreRatio > 0 }"><td>${sovo.lessonScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.middleTestScoreRatio > 0 }"><td>${sovo.middleTestScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.lastTestScoreRatio > 0 }"><td>${sovo.lastTestScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.testScoreRatio > 0 }"><td>${sovo.testScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.assignmentScoreRatio > 0 }"><td>${sovo.assignmentScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.forumScoreRatio > 0 }"><td>${sovo.forumScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.quizScoreRatio > 0 }"><td>${sovo.quizScoreAvg }</td></c:if>
        				<c:if test="${gradeVo.reshScoreRatio > 0 }"><td>${sovo.reshScoreAvg }</td></c:if>
        				<td>${sovo.lessonScoreAvg + sovo.middleTestScoreAvg + sovo.lastTestScoreAvg + sovo.testScoreAvg + sovo.assignmentScoreAvg + sovo.forumScoreAvg + sovo.quizScoreAvg + sovo.reshScoreAvg }</td>
        			</tr>
        			<tr>
        				<td><spring:message code="score.label.exchange.score" /><!-- 환산점수 --></td>
        				<c:if test="${gradeVo.lessonScoreRatio > 0 }"><td>${sovo.exchScrLesson }</td></c:if>
        				<c:if test="${gradeVo.middleTestScoreRatio > 0 }"><td>${sovo.exchScrMidTest }</td></c:if>
        				<c:if test="${gradeVo.lastTestScoreRatio > 0 }"><td>${sovo.exchScrLastTest }</td></c:if>
        				<c:if test="${gradeVo.testScoreRatio > 0 }"><td>${sovo.exchScrTest }</td></c:if>
        				<c:if test="${gradeVo.assignmentScoreRatio > 0 }"><td>${sovo.exchScrAsmnt }</td></c:if>
        				<c:if test="${gradeVo.forumScoreRatio > 0 }"><td>${sovo.exchScrForum }</td></c:if>
        				<c:if test="${gradeVo.quizScoreRatio > 0 }"><td>${sovo.exchScrQuiz }</td></c:if>
        				<c:if test="${gradeVo.reshScoreRatio > 0 }"><td>${sovo.exchScrResh }</td></c:if>
        				<td>${sovo.exchTotScr }</td>
        			</tr>
        		</tbody>
        	</table>
        	<h3 class="sec_head mt20"><spring:message code="forum.label.memo" /><!-- 메모 --></h3>
        	<textarea rows="5" cols="20" readonly>${sovo.profMemo }</textarea>

            <div class="bottom-content">
                <button type="button" class="ui basic button" onclick="prevPop();"><spring:message code="team.common.close"/></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
