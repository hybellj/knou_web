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
		listQuiz();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listQuiz();
			}
		});
		
		$("#listType").on("click", function() {
			$(this).children("i").toggleClass("list th");
			listQuiz();
		});
	});

	// 리스트 조회
	function listQuiz() {
		var url = "/quiz/quizList.do";
		var data = {
			"crsCreCd"     : "${vo.crsCreCd}",
			"examCtgrCd"   : "QUIZ",
			"examSubmitYn" : "Y",
			"searchValue"  : $("#searchValue").val(),
			"searchMenu"   : "LEARNER",
			"stdNo"		   : "${stdVO.stdNo}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = createQuizListHTML(returnList);
        		
        		$("#list").empty().html(html);
        		if($("#listType i").hasClass("th")){
	    			$(".table").footable();
        		} else {
        			$(".ui.dropdown").dropdown();
        			$(".card-item-center .title-box label").unbind('click').bind('click', function(e) {
        		        $(".card-item-center .title-box label").toggleClass('active');
        		    });
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 퀴즈 정보 페이지
	function viewQuiz(examCd) {
		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : examCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/quiz/stuQuizView.do", "", "", kvArr);
	}
	
	// 퀴즈 리스트 생성
	function createQuizListHTML(quizList) {
		var html = ``;
		var quizMap = {};
		
		// 값 설정
		quizList.forEach(function(v, i) {
			var examTitle	  = escapeHtml(v.examTitle);
			var examStartDttm = dateFormat("date", v.examStartDttm);
			var examEndDttm   = dateFormat("date", v.examEndDttm);
			var reExamStartDttm = v.reExamYn == "Y" && v.reExamStartDttm != null ? dateFormat("date", v.reExamStartDttm) : "";
			var reExamEndDttm 	= v.reExamYn == "Y" && v.reExamEndDttm != null ? dateFormat("date", v.reExamEndDttm) : "";
			var scoreAplyNm	  = v.scoreAplyYn == "Y" ? "<spring:message code='exam.common.yes' />"/* 예 */ : "<spring:message code='exam.common.no' />";/* 아니오 */
			var examStatus 	  = "<spring:message code='exam.label.ready' />";/* 대기 */
			if(v.examStatus == "진행" && (v.examSubmitYn == "Y" || v.examSubmitYn == "M")) examStatus = "<spring:message code='exam.label.proceeding' />";/* 진행중 */
			if(v.examStatus == "완료") examStatus = "<spring:message code='exam.label.end' />";/* 마감 */
			var examTypeNm    = "<spring:message code='exam.label.basic.quiz' />"/* 일반퀴즈 */;
			if(v.examTypeCd == "EXAM" || v.examTypeCd == "SUBS") {
				examTypeNm    = v.examStareTypeCd == "M" ? "<spring:message code='exam.label.mid.exam' />"/* 중간고사 */ : v.examStareTypeCd == "L" ? "<spring:message code='exam.label.end.exam' />"/* 기말고사 */ : "<spring:message code='exam.label.always.exam' />"/* 수시평가 */;
			}
			var evalNm 		  = v.stareYn == "Y" || v.stareStatusCd == "C" ? v.examStatus == "완료" && v.scoreOpenYn == "Y" && v.stuEvalYn == "Y" ? "<spring:message code='exam.label.yes.stare' /> / "/* 응시 */+v.totGetScore+"<spring:message code='exam.label.score.point' />"/* 점 */ : "<spring:message code='exam.label.yes.stare' />"/* 응시 */ : "<spring:message code='exam.label.no.stare' />"/* 미응시 */;
			
			var map = {
				"title" : examTitle, "startDttm" : examStartDttm, "endDttm" : examEndDttm, "reStartDttm" : reExamStartDttm, "reEndDttm" : reExamEndDttm, "aply" : scoreAplyNm, "status" : examStatus, "type" : examTypeNm, "eval" : evalNm
			};
			quizMap[v.examCd] = map;
		});
		
		if($("#listType i").hasClass("th")){
			html += `<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />">`;/* 등록된 내용이 없습니다. */
			html += `	<thead>`;
			html += `		<tr>`;
			html += `			<th scope="col" class="num tc"><spring:message code="common.number.no" /></th>`;
			html += `			<th scope="col" class="tc"><spring:message code="exam.label.stare.type" /></th>`;/* 구분 */
			html += `			<th scope="col" class="tc"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></th>`;/* 퀴즈 *//* 명 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.time" /></th>`;/* 퀴즈 *//* 시간 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.period" /></th>`;/* 퀴즈 *//* 기간 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.score.aply.y" /></th>`;/* 성적반영 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.progress.status" /></th>`;/* 진행상태 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.eval.stare.status" /></th>`;/* 응시/평가현황 */
			html += `			<th scope="col" class="tc"><spring:message code="exam.label.manage" /></th>`;/* 관리 */
			html += `		</tr>`;
			html += `	</thead>`;
			html += `	<tbody>`;
			quizList.forEach(function(v, i) {
				html += `<tr>`;
				html += `	<td class="tc">\${v.lineNo }</td>`;
				html += `	<td class="tc">\${quizMap[v.examCd]["type"]}</td>`;
				html += `	<td><a href="javascript:viewQuiz('\${v.examCd}')" class="header header-icon link">\${quizMap[v.examCd]["title"] }</a></td>`;
				html += `	<td class="tc">\${v.examStareTm }<spring:message code="exam.label.stare.min" /></td>`;/* 분 */
				html += `	<td class="tc">\${quizMap[v.examCd]["startDttm"] } ~<br> \${quizMap[v.examCd]["endDttm"] }</td>`;
				html += `	<td class="tc">\${quizMap[v.examCd]["aply"]}</td>`;
				html += `	<td class="tc">\${quizMap[v.examCd]["status"] }</td>`;
				if("${auditYn}" == "Y") {
				html += `	<td class="tc">-</td>`;
				} else {
				html += `	<td class="tc">\${quizMap[v.examCd]["eval"]}</td>`;
				}
				html += `	<td class="tc">`;
				if(PROFESSOR_VIRTUAL_LOGIN_YN == "Y" || v.examStatus == "대기" || (v.examSubmitYn || "N") == "N" || "${auditYn}" == "Y") {
				html += `		-`;
				} else if((v.examStatus == "진행" || (v.stuReExamYn == "Y" && v.reExamStatus == "진행"))) {
					if(v.stareYn != "Y") {
						if(v.hstyTypeCd == "COMPLETE") {
							if(v.imdtAnsrViewYn == "Y") {
								html += `<a href="javascript:quizAnswerPop('\${v.examCd }')" class="ui blue small button"><spring:message code="exam.button.review.answer" /></a>`/* 제출답안 */;
							} else {
								// 시험지 제출을 이미 완료하였습니다
								html += `<a href="javascript:alert('<spring:message code='exam.error.stare.finished' />')" class="ui blue small button"><spring:message code="exam.button.stare.start" /> <spring:message code="exam.label.complete" /></a>`; // 응시 완료
							}
						} else {
							html += `<a href="javascript:quizPop('\${v.examCd }')" class="ui blue small button"><spring:message code="exam.label.quiz" /> <spring:message code="exam.button.stare.start" /></a>`; // 퀴즈  응시
						}
					} else {
						if(v.imdtAnsrViewYn == "Y") {
							html += `<a href="javascript:quizAnswerPop('\${v.examCd }')" class="ui blue small button"><spring:message code="exam.button.review.answer" /></a>`/* 제출답안 */;
						}
					}
				} else if(v.examStatus == "완료") {
					html += `		<a href="javascript:quizAnswerPop('\${v.examCd }')" class="ui blue small button"><spring:message code="exam.button.review.answer" /></a>`/* 제출답안 */;
				}
				html += `	</td>`;
				html += `</tr>`;
			});
			html += `	</tbody>`;
			html += `</table>`;
		} else {
			if(quizList.length > 0) {
				html += `<div class='ui two stackable cards info-type mt10'>`;
				quizList.forEach(function(v, i) {
					html += `<div class="card">`;
					html += `	<div class="content card-item-center">`;
					html += `		<div class="title-box">`;
					html += `			<label class="ui purple label active">\${quizMap[v.examCd]["type"]}​</label>`;
					html += `			<a href="javascript:viewQuiz('\${v.examCd}')" class="header header-icon link">\${quizMap[v.examCd]["title"] }</a>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `	<div class="sum-box">`;
					html += `		<ul class="process-bar">`;
					html += `			<li \${v.examStatus == '대기' || v.examStatus == '진행' ? `class="bar-blue"` : `class="bar-softgrey"`}>`;
					html += `				\${quizMap[v.examCd]["status"]} (\${quizMap[v.examCd]["eval"]})`;
					html += `			</li>`;
					html += `		</ul>`;
					html += `	</div>`;
					html += `	<div class="content ui form equal width">`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.period" /></label>`;/* 퀴즈 *//* 기간 */
					html += `				<i>\${quizMap[v.examCd]["startDttm"] } ~ \${quizMap[v.examCd]["endDttm"] }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					if(v.stuReExamYn == "Y" && v.reExamStartDttm != null && v.reExamStartDttm != "") {
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.reexam.period" /></label>`;/* 재응시기간 */
					html += `				<i>\${quizMap[v.examCd]["reStartDttm"] } ~ \${quizMap[v.examCd]["reEndDttm"] }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					}
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.time" /></label>`;/* 퀴즈 *//* 시간 */
					html += `				<i>\${v.examStareTm }<spring:message code="exam.label.stare.min" /></i>`;/* 분 */
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.item.cnt" /></label>`;/* 문항수 */
					html += `				<i>\${v.examQstnCnt }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.score.aply.y" /></label>`;/* 성적반영 */
					html += `				<i>\${quizMap[v.examCd]["aply"]}</i>`;
					if(PROFESSOR_VIRTUAL_LOGIN_YN != "Y" && "${auditYn}" != "Y" && (v.examSubmitYn || "N") != "N") {
						if((v.examStatus == "진행" || (v.stuReExamYn == "Y" && v.reExamStatus == "진행"))) {
							if(v.stareYn != "Y") {
								if(v.hstyTypeCd == "COMPLETE") {
									if(v.imdtAnsrViewYn == "Y") {
										html += `<a href="javascript:quizAnswerPop('\${v.examCd }')" class="ui blue small button w100"><spring:message code="exam.button.review.answer" /></a><!-- 제출답안 -->`;
									} else {
										// 시험지 제출을 이미 완료하였습니다
										html += `<a href="javascript:alert('<spring:message code='exam.error.stare.finished' />')" class="ui blue small button w100"><spring:message code="exam.button.stare.start" /> <spring:message code="exam.label.complete" /></a>`; // 응시 완료
									}
								} else {
									html += `<a href="javascript:quizPop('\${v.examCd }')" class="ui blue small button w100"><spring:message code="exam.label.quiz" /> <spring:message code="exam.button.stare.start" /></a>`; // 퀴즈  응시 
								}
							} else {
								if(v.imdtAnsrViewYn == "Y") {
									html += `<a href="javascript:quizAnswerPop('\${v.examCd }')" class="ui blue small button w100"><spring:message code="exam.button.review.answer" /></a><!-- 제출답안 -->`;
								}
							}
						} else if(v.examStatus == "완료") {
							html += `		<a href="javascript:quizAnswerPop('\${v.examCd }')" class="ui blue small button w100"><spring:message code="exam.button.review.answer" /></a><!-- 제출답안 -->`;
						}
					}
					html += `			</div>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `</div>`;
				});
				html += `</div>`;
			} else {
				html += "<div class='flex-container'>";
				html += "	<div class='no_content'>";
				html += "		<i class='icon-cont-none ico f170'></i>";
				html += "		<span><spring:message code='exam.common.empty' /></span>";/* 등록된 내용이 없습니다. */
				html += "	</div>";
				html += "</div>";
			}
		}
		
		return html;
	}
	
	// 퀴즈 팝업
	function quizPop(examCd) {
		var url  = "/quiz/quizCopy.do";
		var data = {
   			examCd : examCd,
   			crsCreCd : "${vo.crsCreCd}",
   			stdNo : "${stdVO.stdNo}",
   		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO || {};
				
				if(returnVO.hstyTypeCd == "COMPLETE") {
					alert("<spring:message code='exam.error.stare.finished' />"); // 시험지 제출을 이미 완료하였습니다
					return;
				}
				
				var kvArr = [];
				kvArr.push({'key' : 'examCd', 	'val' : examCd});
				kvArr.push({'key' : 'stdNo', 	'val' : "${stdVO.stdNo}"});
				kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
				kvArr.push({'key' : 'goUrl',    'val' : "tempForm"});
				
				submitForm("/quiz/quizJoinAlarmPop.do", "quizPopIfm", "joinInfo", kvArr); // 퀴즈 응시
        	} else {
        		alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
		}, true);
	}
	
	// 제출답안 팝업
	function quizAnswerPop(examCd) {
		var url  = "/quiz/quizCopy.do";
		var data = {
   			examCd : examCd,
   			crsCreCd : "${vo.crsCreCd}",
   			stdNo : "${stdVO.stdNo}",
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
				kvArr.push({'key' : 'examCd', 	'val' : examCd});
				kvArr.push({'key' : 'stdNo', 	'val' : "${stdVO.stdNo}"});
				kvArr.push({'key' : 'crsCreCd', 'val' : "${crsCreCd}"});
				kvArr.push({'key' : 'goUrl',    'val' : "tempForm"});
				
				submitForm("/quiz/quizSubmitAnswerPop.do", "quizPopIfm", "answer", kvArr);
        	} else {
        		alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
		}, true);
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
							setLocationBar('<spring:message code="exam.label.quiz" />', '<spring:message code="exam.button.list" />');
						});
						</script>
		                <div id="info-item-box">
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="option-content mb10">
				                    <button class="ui basic icon button" id="listType" title="<spring:message code="asmnt.label.title.list" />"><i class="list ul icon"></i></button>
				                    <div class="ui action input search-box">
				                    	<label for="searchValue" class="hide"><spring:message code='exam.label.quiz' /></label>
				                        <input type="text" id="searchValue" placeholder="<spring:message code="crs.label.quiz_name" /><spring:message code='exam.label.input' />"><!-- 퀴즈명 입력 -->
				                        <button class="ui icon button" onclick="listQuiz(1)"><i class="search icon"></i></button>
				                    </div>
				                </div>
				                <div id="list"></div>
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