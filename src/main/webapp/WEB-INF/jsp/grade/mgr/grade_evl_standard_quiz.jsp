<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(function(){
	listQuiz(1);
	
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			listQuiz(1);
		}
	});
});

//리스트 조회
function listQuiz(page) {
	var url  = "/quiz/quizListPaging.do";
	var data = {
		"crsCreCd"    : "${vo.crsCreCd2}",
		"pageIndex"   : page,
		"examCtgrCd"  : "QUIZ",
		"listScale"   : $("#listScale").val(),
		"searchValue" : $("#searchValue1").val()
	};
	
	$.ajax({
        url 	 : url,
        async	 : false,
        type 	 : "POST",
        dataType : "json",
        data 	 : data,
    }).done(function(data) {
    	if (data.result > 0) {
    		var returnList = data.returnList || [];
    		var html = createQuizListHTML(returnList);
    		
    		$("#list").empty().html(html);
    		if($("#listType i").hasClass("th")){
    			$(".table").footable();
    			var params = {
	    			totalCount 	  : data.pageInfo.totalRecordCount,
	    			listScale 	  : data.pageInfo.pageSize,
	    			currentPageNo : data.pageInfo.currentPageNo,
	    			eventName 	  : "listQuiz"
	    		};
	    		
	    		gfn_renderPaging(params);
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
    	/* 리스트 조회 중 에러가 발생하였습니다. */
    	alert("<spring:message code='exam.error.list' />");
    });
}

// 성적 반영비율 입력 폼 변환
function chgScoreRatio(type) {
	if(type == 1) {
		if($("#listType i").hasClass("list")) {
			listQuizType();
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
	var scoreRatioM = 0;	// 중간고사 점수
	var scoreRatioL = 0;	// 기말고사 점수
	var scoreRatioA = 0;	// 상시 점수
	var examCds 	= "";
	var scoreRatios = "";
	
	$(".scoreRatio").each(function(i) {
		var examStareTypeCd = $(this).attr("data-examStareTypeCd");
		if(examStareTypeCd == "M") {
			scoreRatioM += $(this).val();
		} else if(examStareTypeCd == "L") {
			scoreRatioL += $(this).val();
		} else if(examStareTypeCd == "A") {
			scoreRatioA += $(this).val();
		}
		if(i > 0) {
			examCds += "|";
			scoreRatios += "|";
		}
		examCds += $(this).attr("data-examCd");
		scoreRatios += $(this).val();
		if(Number($(this).val()) < 0 || Number($(this).val()) > 100) {
			/* 점수는 100점 까지 입력 가능 합니다. */
			alert("<spring:message code='exam.alert.score.max.100' />");
			isChk = false;
			return false;
		}
	});
	
	if(isChk) {
		if(Number(scoreRatioM) != 100 && $(".scoreRatio[data-examStareTypeCd=M]").length > 0) {
			/* 중간고사 성적 반영 비율이 100%여야 합니다. */
			alert("<spring:message code='exam.alert.mid.exam.score.ratio.100' />");
			return false;
		} else if(Number(scoreRatioL) != 100 && $(".scoreRatio[data-examStareTypeCd=L]").length > 0) {
			/* 기말고사 성적 반영 비율이 100%여야 합니다. */
			alert("<spring:message code='exam.alert.end.exam.score.ratio.100' />");
			return false;
		} else if(Number(scoreRatioA) != 100 && $(".scoreRatio[data-examStareTypeCd=A]").length > 0) {
			/* 상시 성적 반영 비율이 100%여야 합니다. */
			alert("<spring:message code='exam.alert.always.exam.score.ratio.100' />");
			return false;
		} else {
			var url  = "/quiz/editQuizAjax.do";
			var data = {
				"examCds" 	  : examCds,
				"scoreRatios" : scoreRatios
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					/* 정상 저장 되었습니다. */
	        		alert("<spring:message code='exam.alert.insert' />");
	        		listQuiz(1);
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			/* 반영 비율 저장 중 에러가 발생하였습니다. */
    			alert("<spring:message code='exam.error.score.ratio' />");
    		});
		}
	}
}

// 성적 공개 변경
function chgScoreOpen(obj) {
	var examCd 		= $(obj).val();
	var scoreOpenYn = "";
	var gradeViewYn = "";
	if(obj.checked) {
		scoreOpenYn = "Y";
		gradeViewYn = "Y";
	} else {
		scoreOpenYn = "N";
		gradeViewYn = "N";
	}
	var url  = "/quiz/editQuizAjax.do";
	var data = {
		"examCd" 	  : examCd,
		"scoreOpenYn" : scoreOpenYn,
		"gradeViewYn" : gradeViewYn
	};
	
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
    		listQuiz(1);
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
		/* 성적 공개 변경 중 에러가 발생하였습니다. */
		alert("<spring:message code='exam.error.score.open' />");
	});
}

//퀴즈 정보 페이지
function viewQuiz(examCd, tab) {
	var urlMap = {
		"1" : "/quiz/quizQstnManage.do",	// 퀴즈 문항 관리 페이지
		"2" : "/quiz/quizRetakeManage.do",	// 퀴즈 재응시 관리 페이지
		"3" : "/quiz/quizScoreManage.do"	// 퀴즈 평가 관리 페이지
	};
	
	var url  = urlMap[tab];
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "viewForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${vo.crsCreCd2}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'examCd',   value: examCd}));
	form.appendTo("body");
	form.submit();
}

// 퀴즈 시험지 미리보기
function quizQstnPreview(examCd) {
	quizCommon.initModal("quizPreview");
	$("#previewExamCd").val(examCd);
	$("#quizQstnPreviewForm").attr("target", "quizPopIfm");
    $("#quizQstnPreviewForm").attr("action", "/quiz/quizQstnPreviewPop.do");
    $("#quizQstnPreviewForm").submit();
    $('#quizPop').modal('show');
}

//퀴즈 리스트 생성
function createQuizListHTML(quizList) {
	if(quizList.length == 0) {
		return `
			<div class="flex-container">
	            <div class="cont-none">
	                <span><spring:message code="exam.common.empty" /></span>
	            </div>
	        </div>
		`;/* 등록된 내용이 없습니다. */
	} else {
		var html = ``;
		
		html += `<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />">`;/* 등록된 내용이 없습니다. */
		html += `	<thead>`;
		html += `		<tr>`;
		html += `			<th scope="col" class="num"><spring:message code="main.common.number.no"/></th>`;/* NO. */
		html += `			<th scope="col"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.nm" /></th>`;/* 퀴즈 *//* 명 */
		html += `			<th scope="col"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.time" /></th>`;/* 퀴즈 *//* 시간 */
		html += `			<th scope="col"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.period" /></th>`;/* 퀴즈 *//* 기간 */
		html += `			<th scope="col"><spring:message code="exam.label.grade" /><spring:message code="exam.label.score.aply.rate" /></th>`;/* 성적 *//* 반영비율 */
		html += `			<th scope="col"><spring:message code="exam.label.stare.status" /></th>`;/* 응시현황 */
		html += `			<th scope="col"><spring:message code="exam.label.eval.status" /></th>`;/* 평가현황 */
		html += `			<th scope="col"><spring:message code="exam.label.qstn.status" /></th>`;/* 문제출제상태 */
		html += `			<th scope="col"><spring:message code="exam.label.score.open.y" /></th>`;/* 성적공개 */
		html += `			<th scope="col"><spring:message code="exam.label.preview" /></th>`;/* 미리보기 */
		html += `		</tr>`;
		html += `	</thead>`;
		html += `	<tbody>`;
		quizList.forEach(function(v, i) {
			var examStartDttm = v.examStartDttm.substring(0, 4) + '.' + v.examStartDttm.substring(4, 6) + '.' + v.examStartDttm.substring(6, 8) + ' ' + v.examStartDttm.substring(8, 10) + ':' + v.examStartDttm.substring(10, 12);
			var examEndDttm   = v.examEndDttm.substring(0, 4) + '.' + v.examEndDttm.substring(4, 6) + '.' + v.examEndDttm.substring(6, 8) + ' ' + v.examEndDttm.substring(8, 10) + ':' + v.examEndDttm.substring(10, 12);
			html += `	<tr>`;
			html += `		<td>\${v.lineNo }</td>`;
			html += `		<td>\${v.examTitle }</td>`;
			html += `		<td>\${v.examStareTm }<spring:message code="exam.label.stare.min" /></td>`;/* 분 */
			html += `		<td>\${examStartDttm } ~<br> \${examEndDttm }</td>`;
			html += `		<td>`;
			if(v.scoreAplyYn == 'N') {
			html += `			0%`;
			} else {
			html += `			<div class="scoreInputDiv ui input">`;
			html += `				<input type="number" class="scoreRatio w50" data-examStareTypeCd="\${v.examStareTypeCd}" data-examCd="\${v.examCd}" value="\${v.scoreRatio != null ? v.scoreRatio : 0 }" />`;
			html += `			</div>`;
			html += `			<div class="scoreRatioDiv">\${v.scoreRatio != null ? v.scoreRatio : 0 }%</div>`;
			}
			html += `		</td>`;
			html += `		<td>\${v.examJoinUserCnt }/\${v.examTotalUserCnt }</td>`;
			html += `		<td>\${v.examEvalCnt }/\${v.examJoinUserCnt }</td>`;
			html += `		<td>`;
			if(v.examSubmitYn == 'Y' || v.examSubmitYn == 'M') {
			html += `			<spring:message code="exam.label.qstn.submit.y" />`;/* 출제완료 */
			} else {
			html += `			<span class="fcRed"><spring:message code="exam.label.qstn.temp.save" /></span>`;/* 임시저장 */
			}
			html += `		</td>`;
			html += `		<td>`;
			if(v.scoreAplyYn == 'N') {
			html += `			-`;
			} else {
			html += `			<div class="ui toggle checkbox">`;
			html += `				<input type="checkbox" value="\${v.examCd}" onclick="chgScoreOpen(this)" \${v.scoreOpenYn == 'Y' ? `checked`:`` }>`;
			html += `				<label></label>`;
			html += `			</div>`;
			}
			html += `		</td>`;
			html += `		<td><a href="javascript:quizQstnPreview('\${v.examCd}')" class="ui basic small button"><spring:message code="exam.label.preview" />​</a></td>`;/* 미리보기 */
			html += `	</tr>`;
		});
		html += `	</tbody>`;
		html += `</table>`;
		html += `<div id="paging" class="paging"></div>`;
		
		return html;
	}
}
</script>

<body>
	<form id="quizQstnPreviewForm" name="quizQstnPreviewForm" method="POST">
		<input type="hidden" name="examCd" value="" id="previewExamCd" />
		<input type="hidden" name="crsCreCd" value="${vo.crsCreCd2 }" />
	</form>
	<div class="option-content mb10">
		<div class="ui action input search-box mr5">
			<input type="text" id="searchValue1" placeholder="<spring:message code="crs.label.quiz_name" /><spring:message code='exam.label.input' />"><!-- 퀴즈명 --><!-- 입력 -->
			<button class="ui icon button" onclick="listQuiz(1)"><i class="search icon"></i></button>
		</div>
		<div class="button-area flex-left-auto">
			<div class="chgScoreRatioDiv">
				<a href="javascript:saveScoreRatio()" class="ui basic button"><spring:message code="forum.button.scoreRatio.save" /></a><!-- 성적반영 비율 저장 -->
				<a href="javascript:chgScoreRatio(2)" class="ui basic button"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
			</div>
			<a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn" class="ui basic button"><spring:message code="forum.button.scoreRatio.change" /></a><!-- 성적반영 비율 조정 -->
			<select class="ui dropdown mr5 list-num" id="listScale" onchange="listQuiz(1)">
				<option value="10">10</option>
				<option value="20">20</option>
				<option value="50">50</option>
			</select>
		</div>
	</div>
	<div id="list"></div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
