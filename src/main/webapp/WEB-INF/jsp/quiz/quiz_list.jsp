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
			"crsCreCd"    : "${vo.crsCreCd}",
			"examCtgrCd"  : "QUIZ",
			"searchValue" : $("#searchValue").val()
		};
		
		showLoading();
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : data,
        }).done(function(data) {
        	hideLoading();
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
        		chgScoreRatio(0);
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
        });
	}
	
	// 성적 반영비율 입력 폼 변환
	function chgScoreRatio(type) {
		if(type == 1) {
			if($("#listType i").hasClass("list")) {
				$("#listType").trigger("click");
			}
			$("#chgScoreRatioBtn").hide();
			$(".chgScoreRatioDiv").css("display", "inline-block");
			$(".scoreInputDiv").show();
			$(".scoreRatioDiv").hide();
		} else {
			$("#chgScoreRatioBtn").css("display", "inline-block");
			$(".chgScoreRatioDiv").hide();
			$(".scoreInputDiv").hide();
			$(".scoreRatioDiv").show();
		}
	}
	
	// 성적 반영비율 저장
	function saveScoreRatio() {
		var isChk 		= true;
		var scoreRatio  = 0;
		var examCds 	= "";
		var scoreRatios = "";
		
		$(".scoreRatio").each(function(i) {
			scoreRatio += parseInt($(this).val());
			if(i > 0) {
				examCds += "|";
				scoreRatios += "|";
			}
			examCds += $(this).attr("data-examCd");
			scoreRatios += $(this).val();
			if(Number($(this).val()) < 0 || Number($(this).val()) > 100) {
				alert("<spring:message code='exam.alert.score.max.100' />");/* 점수는 100점 까지 입력 가능 합니다. */
				isChk = false;
				return false;
			}
			if(Number($(this).val()) == 0) {
				alert("<spring:message code='exam.alert.score.ratio.0' />");/* 0점은 입력할 수 없습니다. 다른 값을 입력해주세요. */
				isChk = false;
				return false;
			}
		});
		if($(".scoreRatio").length == 0) {
			isChk = false;
			listQuiz();
		}
		
		if(isChk) {
			if(Number(scoreRatio) != 100 && $(".scoreRatio[data-examStareTypeCd=A]").length > 0) {
				alert("["+scoreRatio+"] <spring:message code='exam.alert.always.exam.score.ratio.100' />");/* 상시 성적 반영 비율이 100%여야 합니다. */
				return false;
			} else {
				var url  = "/quiz/editQuizAjax.do";
				var data = {
					"examCds" 	  : examCds,
					"scoreRatios" : scoreRatios
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
		        		alert("<spring:message code='exam.alert.insert' />");/* 정상 저장 되었습니다. */
		        		listQuiz();
		            } else {
		             	alert(data.message);
		            }
	    		}, function(xhr, status, error) {
	    			alert("<spring:message code='exam.error.score.ratio' />");/* 반영 비율 저장 중 에러가 발생하였습니다. */
	    		});
			}
		}
	}
	
	// 성적 공개 변경
	function chgScoreOpen(obj, examSubmitYn) {
		if(examSubmitYn == "N") {
			if(obj.checked) {
				alert("<spring:message code='exam.alert.already.qstn.submit' />");/* 문항 출제 완료 후 성적 공개가 가능합니다. */
				$(obj).prop("checked", false);
			}
		}
		var examCd 		= $(obj).val();
		var scoreOpenYn = obj.checked ? "Y" : "N";
		var url  = "/exam/editExamScoreOpen.do";
		var data = {
			"examCd" 	  : examCd,
			"scoreOpenYn" : scoreOpenYn,
			"gradeViewYn" : "Y"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		listQuiz();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.score.open' />");/* 성적 공개 변경 중 에러가 발생하였습니다. */
		});
	}
	
	// 문제은행 페이지
	function viewQbank() {
		var kvArr = [];
		kvArr.push({'key' : 'crsNo',    'val' : "${creCrsVO.crsCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});
		
		submitForm("/quiz/Form/qbankList.do", "", "", kvArr);
	}
	
	// 퀴즈 정보 페이지
	function viewQuiz(examCd, tab) {
		var urlMap = {
			"1" : "/quiz/quizQstnManage.do",	// 퀴즈 문항 관리 페이지
			"2" : "/quiz/quizRetakeManage.do",	// 퀴즈 재응시 관리 페이지
			"3" : "/quiz/quizScoreManage.do",	// 퀴즈 평가 관리 페이지
			"8" : "/quiz/Form/writeQuiz.do", 	// 퀴즈 등록 페이지
			"9" : "/quiz/Form/editQuiz.do" 		// 퀴즈 수정 페이지
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : examCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 퀴즈 시험지 미리보기
	function quizQstnPreview(examCd) {
		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : examCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/quiz/quizQstnPreviewPop.do", "quizPopIfm", "quizPreview", kvArr);
	}
	
	// 퀴즈 삭제
	function delQuiz(examCd, joinCnt) {
		var confirm = "";
		if(joinCnt > 0) {
			confirm = window.confirm("<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.y' />");/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.정말 삭제하시겠습니까? */
		} else {
			confirm = window.confirm("<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />");/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
		}
		if(confirm) {
			var url  = "/quiz/delQuiz.do";
			var data = {
				  examCd 	: examCd
				, crsCreCd	: "${vo.crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
	        		listQuiz();
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
    		});
		}
	}
	
	// 퀴즈 리스트 생성
	function createQuizListHTML(quizList) {
		var html = ``;
		var quizMap = {};
		
		quizList.forEach(function(v, i) {
			var examTitle	  = escapeHtml(v.examTitle);
			var examStartDttm = dateFormat("date", v.examStartDttm);
			var examEndDttm   = dateFormat("date", v.examEndDttm);
			var reExamStartDttm = v.reExamYn == "Y" && v.reExamStartDttm != null ? dateFormat("date", v.reExamStartDttm) : '';
			var reExamEndDttm   = v.reExamYn == "Y" && v.reExamEndDttm != null ? dateFormat("date", v.reExamEndDttm) : '';
			var examTypeNm = "<spring:message code='exam.label.basic.quiz' />"/* 일반퀴즈 */;
			if(v.examTypeCd == "EXAM" || v.examTypeCd == "SUBS") {
				examTypeNm = v.examStareTypeCd == "M" ? "<spring:message code='exam.label.mid.exam' />"/* 중간고사 */ : v.examStareTypeCd == "L" ? "<spring:message code='exam.label.end.exam' />"/* 기말고사 */ : "<spring:message code='exam.label.always.exam' />"/* 수시평가 */;
			}
			var scoreRatio  = v.scoreRatio != null ? v.scoreRatio : 0;
			var examStatus = "";
			if(v.examStatus == "대기") examStatus = "<spring:message code='exam.label.open.n' />";/* 비공개 */
			if(v.examStatus == "진행") examStatus = "<spring:message code='exam.label.proceeding' />";/* 진행중 */
			if(v.examStatus == "완료") examStatus = "<spring:message code='exam.label.end' />";/* 마감 */
			var map = {
				"title" : examTitle, "startDttm" : examStartDttm, "endDttm" : examEndDttm, "reStartDttm" : reExamStartDttm, "reEndDttm" : reExamEndDttm, "type" : examTypeNm, "score" : scoreRatio, "status" : examStatus, "examStareTypeCd" : v.examStareTypeCd
			};
			quizMap[v.examCd] = map;
		});
		
		if($("#listType i").hasClass("th")){
			html += `<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />">`;/* 등록된 내용이 없습니다. */
			html += `	<thead>`;
			html += `		<tr>`;
			html += `			<th scope="col" class="tc num"><spring:message code="common.number.no" /></th>`;/* NO. */
			html += `			<th scope="col" class="tc"><spring:message code="exam.label.stare.type" /></th>`;/* 구분 */
			html += `			<th scope="col" class="tc"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></th>`;/* 퀴즈 *//* 명 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.time" /></th>`;/* 퀴즈 *//* 시간 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.period" /></th>`;/* 퀴즈 *//* 기간 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.grade.score" /><spring:message code="exam.label.score.aply.rate" /></th>`;/* 성적 *//* 반영비율 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.stare.status" /></th>`;/* 응시현황 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.cnt.eval" />/<spring:message code="exam.label.cnt.stare" /></th>`;/* 평가수 *//* 응시수 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.qstn.status" /></th>`;/* 문제출제상태 */
			html += `			<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.score.open.y" /></th>`;/* 성적공개 */
			html += `			<th scope="col" class="tc"><spring:message code="exam.label.preview" /></th>`;/* 미리보기 */
			html += `		</tr>`;
			html += `	</thead>`;
			html += `	<tbody>`;
			quizList.forEach(function(v, i) {
				html += `	<tr>`;
				html += `		<td class="tc">\${v.lineNo }</td>`;
				html += '		<td class="tc">';
				if(quizMap[v.examCd]["examStareTypeCd"] == "M" || quizMap[v.examCd]["examStareTypeCd"] == "L") {
					html += '		<label class="ui pink label">' + quizMap[v.examCd]["type"] + '</label>';
				} else {
					html += 		quizMap[v.examCd]["type"];
				}
				html += '		</td>';
				html += `		<td><a href="javascript:viewQuiz('\${v.examCd}', 3)" class="header header-icon link">\${quizMap[v.examCd]["title"] }</a></td>`;
				html += `		<td class="tc">\${v.examStareTm }<spring:message code="exam.label.stare.min" /></td>`;/* 분 */
				html += `		<td class="tc">\${quizMap[v.examCd]["startDttm"] } ~<br> \${quizMap[v.examCd]["endDttm"] }</td>`;
				html += `		<td class="tc">`;
				if(v.examStareTypeCd == "M" || v.examStareTypeCd == "L" || v.examTypeCd == "EXAM" || v.examTypeCd == "SUBS") {
				html += `			\${quizMap[v.examCd]["type"]}`;
				} else if(v.scoreAplyYn == 'N') {
				html += `			0%`;
				} else {
				html += `			<div class="scoreInputDiv ui input">`;
				html += `				<input type="number" class="scoreRatio w50" data-examStareTypeCd="\${v.examStareTypeCd}" data-examCd="\${v.examCd}" value="\${quizMap[v.examCd]['score'] }" />`;
				html += `			</div>`;
				html += `			<div class="scoreRatioDiv">\${quizMap[v.examCd]["score"] }%</div>`;
				}
				html += `		</td>`;
				html += `		<td class="tc">\${v.examJoinUserCnt }/\${v.examTotalUserCnt }</td>`;
				html += `		<td class="tc"><a href="javascript:viewQuiz('\${v.examCd}', 3)" class="fcBlue">\${v.examEvalCnt }/\${v.examJoinUserCnt }</a></td>`;
				html += `		<td class="tc">`;
				if(v.examSubmitYn == 'Y' || v.examSubmitYn == 'M') {
				html += `			<spring:message code="exam.label.qstn.submit.y" />`;/* 출제완료 */
				} else {
				html += `			<span class="fcRed"><spring:message code="exam.label.qstn.temp.save" /></span>`;/* 임시저장 */
				}
				html += `		</td>`;
				html += `		<td class="tc">`;
				if(v.scoreAplyYn == 'N') {
				html += `			-`;
				} else {
				html += `			<div class="ui toggle checkbox">`;
				html += `				<input type="checkbox" value="\${v.examCd}" onclick="chgScoreOpen(this, '\${v.examSubmitYn}')" \${v.scoreOpenYn == 'Y' ? `checked`:`` }>`;
				html += `				<label></label>`;
				html += `			</div>`;
				}
				html += `		</td>`;
				html += `		<td class="tc"><a href="javascript:quizQstnPreview('\${v.examCd}')" class="ui basic small button"><spring:message code="exam.label.preview" />​</a></td>`;/* 미리보기 */
				html += `	</tr>`;
			});
			html += `	</tbody>`;
			html += `</table>`;
		} else {
			if(quizList.length > 0) {
				html += "<div class='ui two stackable cards info-type mt10'>";
				quizList.forEach(function(v, i) {
					html += `<div class="card">`;
					html += `	<div class="content card-item-center">`;
					html += `		<div class="title-box">`;
					html += `			<label class="ui purple label active">\${quizMap[v.examCd]["type"]}</label>`;
					html += `			<a href="javascript:viewQuiz('\${v.examCd}', 3)" class="header header-icon link">\${quizMap[v.examCd]["title"] }</a>`;
					html += `		</div>`;
					html += `		<div class="ui top right pointing dropdown right-box">`;
					html += `			<span class="bars"><spring:message code="exam.label.menu" /></span>`;/* 메뉴 */
					html += `			<div class="menu">`;
					html += `				<a href="javascript:quizQstnPreview('\${v.examCd}')" class="item"><spring:message code="exam.label.preview" /></a>`;/* 미리보기 */
					html += `				<a href="javascript:viewQuiz('\${v.examCd}', 1)" class="item"><spring:message code="eaxm.tab.qstn.manage" /></a>`;/* 문항 관리 */
					if(v.reExamYn == 'Y') {
					html += `				<a href="javascript:viewQuiz('\${v.examCd}', 2)" class="item fcBlue"><spring:message code="exam.tab.reexam.manage" /></a>`;/* 미응시 관리 */
					}
					html += `				<a href="javascript:viewQuiz('\${v.examCd}', 3)" class="item"><spring:message code="exam.label.quiz" /><spring:message code="exam.tab.eval" /></a>`;/* 퀴즈 *//* 평가 */
					html += `				<a href="javascript:viewQuiz('\${v.examCd}', 9)" class="item"><spring:message code="exam.button.mod" /></a>`;/* 수정 */
					html += `				<a href="javascript:delQuiz('\${v.examCd}', \${v.examJoinUserCnt})" class="item"><spring:message code="exam.button.del" /></a>`;/* 삭제 */
					html += `			</div>`;
					html += `		</div>`;
					html += `	</div>`;
					html += `	<div class="sum-box">`;
					html += `		<ul class="process-bar">`;
					html += `			<li class="bar-blue" style="width: \${(v.examJoinUserCnt * 100) / v.examTotalUserCnt}%;">\${v.examJoinUserCnt }<spring:message code="exam.label.nm" /></li>`;/* 명 */
					html += `			<li class="bar-softgrey" style="width: \${((v.examTotalUserCnt - v.examJoinUserCnt) * 100) / v.examTotalUserCnt}%;">\${v.examTotalUserCnt - v.examJoinUserCnt }<spring:message code="exam.label.nm" /></li>`;/* 명 */
					html += `		</ul>`;
					html += `		<span class='ui mini blue label'>\${quizMap[v.examCd]["status"]}</span>`;
					html += `	</div>`;
					html += `	<div class="content ui form equal width">`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.period" /></label>`;/* 퀴즈 *//* 기간 */
					html += `				<i>\${quizMap[v.examCd]["startDttm"] } ~ \${quizMap[v.examCd]["endDttm"] }</i>`;
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.reexam.period" /></label>`;/* 재응시 기간 */
					if(v.reExamYn == "Y" && v.reExamStartDttm != "" && v.reExamStartDttm != null) {
					html += `				<i>\${quizMap[v.examCd]["reStartDttm"] } ~ \${quizMap[v.examCd]["reEndDttm"] }</i>`;
					} else {
					html += `				<i>-</i>`;
					}
					html += `			</div>`;
					html += `		</div>`;
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
					html += `				<label class="label-title-lg"><spring:message code="exam.label.score.open.y" /></label>`;/* 성적공개 */
					if(v.scoreAplyYn == 'N') {
					html += `				<i>-</i>`;
					} else {
					html += `				<div class="ui toggle checkbox">`;
					html += `					<input type="checkbox" value="\${v.examCd}" onclick="chgScoreOpen(this, '\${v.examSubmitYn}')" \${v.scoreOpenYn == 'Y' ? `checked`:`` }>`;
					html += `					<label></label>`;
					html += `				</div>`;
					}
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="fields">`;
					html += `			<div class="inline field">`;
					html += `				<label class="label-title-lg"><spring:message code="exam.label.grade.score" /> <spring:message code="exam.label.score.aply.rate" /></label>`;/* 성적 *//* 반영비율 */
					if(v.examStareTypeCd == "M" || v.examStareTypeCd == "L" || v.examTypeCd == "EXAM" || v.examTypeCd == "SUBS") {
					html += `				<i>\${quizMap[v.examCd]["type"]}</i>`;
					} else if(v.scoreAplyYn == 'N') {
					html += `				<i>\${quizMap[v.examCd]["score"] }%</i>`;
					} else {
					html += `				<div class="scoreInputDiv ui input">`;
					html += `					<input type="number" class="scoreRatio" data-examStareTypeCd="\${v.examStareTypeCd}" data-examCd="\${v.examCd}" class="w50" value="\${quizMap[v.examCd]['score'] }" />`;
					html += `				</div>`;
					html += `				<div class="scoreRatioDiv"><i>\${quizMap[v.examCd]["score"] }%</i></div>`;
					}
					html += `			</div>`;
					html += `		</div>`;
					html += `		<div class="tr">`;
					html += `			<a href="javascript:viewQuiz('\${v.examCd}', 3)" class="ui basic small button mra"><spring:message code="exam.tab.eval" /> \${v.examEvalCnt }/\${v.examJoinUserCnt }</a>`;/* 평가 */
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
				            <div class="button-area">
				                <a href="javascript:viewQuiz('', 8)" class="ui blue button"><spring:message code="exam.label.quiz" /><spring:message code="exam.button.reg" /></a><!-- 퀴즈 --><!-- 등록 -->
				                <a href="javascript:viewQbank()" class="ui blue button"><spring:message code="exam.label.qbank" /></a><!-- 문제은행 -->
				            </div>
				        </div>
				        <div class="row">
				        	<div class="col">
				                <div class="option-content mb10">
				                    <button class="ui basic icon button" id="listType" title="리스트형 출력"><i class="th ul icon"></i></button>
				                    <div class="ui action input search-box mr5">
				                    	<label for="searchValue" class="hide"><spring:message code='exam.label.quiz' /></label>
				                        <input type="text" id="searchValue" placeholder="<spring:message code='exam.label.quiz' /><spring:message code='exam.label.nm' /> <spring:message code='exam.label.input' />"><!-- 퀴즈 --><!-- 명 --><!-- 입력 -->
				                        <button class="ui icon button" onclick="listQuiz()"><i class="search icon"></i></button>
				                    </div>
				                    <div class="mla">
				                    	<div class="option-content">
					                    	<div class="chgScoreRatioDiv">
						                    	<a href="javascript:saveScoreRatio()" class="ui blue button"><spring:message code="exam.label.grade.score" /> <spring:message code="exam.label.score.aply.rate" /> <spring:message code="exam.button.save" /></a><!-- 성적 --><!-- 반영비율 --><!-- 저장 -->
						                    	<a href="javascript:chgScoreRatio(2)" class="ui basic button"><spring:message code="exam.button.cancel" /></a>
					                    	</div>
					                    	<a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn" class="ui blue button"><spring:message code="exam.label.grade.score" /> <spring:message code="exam.label.score.aply.rate" /> <spring:message code="exam.button.adju" /></a><!-- 성적 --><!-- 반영비율 --><!-- 조정 -->
				                    	</div>
				                    </div>
				                </div>
				                <div id="list"></div>
				                <div class="option-content">
				                	<div class="mla">
						                <a href="javascript:viewQuiz('', 8)" class="ui blue button"><spring:message code="exam.label.quiz" /><spring:message code="exam.button.reg" /></a><!-- 퀴즈 --><!-- 등록 -->
						                <a href="javascript:viewQbank()" class="ui blue button"><spring:message code="exam.label.qbank" /></a><!-- 문제은행 -->
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