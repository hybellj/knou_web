<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(function(){
	listEtcExam();
});

//시험 수시평가 목록 조회
function listEtcExam() {
	var url  = "/exam/examListByEtc.do";
	var data = {
		"crsCreCd" 		  : "${vo.crsCreCd2}",
		"examStareTypeCd" : "A",
		"searchValue"     :$("#searchValue1").val() 
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var returnList = data.returnList || [];
    		var html = "";
    		
    		if(returnList.length > 0) {
    			returnList.forEach(function(v, i) {
    				var examStartDttm = v.examStartDttm.substring(0, 4) + "." + v.examStartDttm.substring(4, 6) + "." + v.examStartDttm.substring(6, 8) + " " + v.examStartDttm.substring(8, 10) + ":" + v.examStartDttm.substring(10, 12);
    				var scoreOpenDttm = v.scoreOpenYn == "Y" ? v.scoreOpenDttm.substring(0, 4) + "." + v.scoreOpenDttm.substring(4, 6) + "." + v.scoreOpenDttm.substring(6, 8) + " " + v.scoreOpenDttm.substring(8, 10) + ":" + v.scoreOpenDttm.substring(10, 12) : "-";
    				var scoreOpen	  = v.scoreOpenYn == "Y" ? "<spring:message code='exam.label.open.y' />"/* 공개 */ : "<spring:message code='exam.label.open.n' />";/* 비공개 */
    				var examSubmit	  = v.examSubmitYn == "Y" || v.examSubmitYn == "M" ? "<spring:message code='exam.label.exam.submit.y' />"/* 출제 */ : "<spring:message code='exam.label.exam.submit.n' />";/* 미출제 */
    				var scoreRatio	  = v.scoreAplyYn == "Y" ? v.scoreRatio : "-";
    				var examTypeCd	  = v.examTypeCd == "QUIZ" ? "LMS" : "<spring:message code='exam.label.real.time' />"/* 실시간 */;
    				var checkYn = {
    					"Y" : "",
    					"M" : "",
    					"N" : "class='fcRed'"
    				};
    				html += "<tr>";
    				html += "	<td>"+v.lineNo+"</td>";
    				html += "	<td>-</td>";
    				html += "	<td>"+v.examTitle+"</td>";
    				html += "	<td>";
    				if(v.scoreAplyYn == 'N') {
        			html += "			0%";
        			} else {
        			html += "			<div class='scoreInputDiv ui input'>";
        			html += "				<input type='number' class='scoreRatio w50' data-examCd=\""+v.examCd+"\" value=\""+scoreRatio+"\" />";
        			html += "			</div>";
        			html += "			<div class='scoreRatioDiv'>"+scoreRatio+"%</div>";
        			}
    				html += "	</td>";
    				html += "	<td>"+examStartDttm+"</td>";
    				html += "	<td>"+v.examStareTm+"<spring:message code='exam.label.stare.min' /></td>";/* 분 */
    				html += "	<td>"+examTypeCd+"</td>";
    				html += "	<td "+checkYn[v.scoreOpenYn]+">"+scoreOpen+"</td>";
    				html += "	<td>"+scoreOpenDttm+"</td>";
    				html += "	<td "+checkYn[v.examSubmitYn]+">"+examSubmit+"</td>";
    				html += "</tr>";
    			});
    		}
    		
    		$("#examEtcList").empty().html(html);
    		$("#examEtcListTable").footable();
    		chgScoreRatio(0);
    	} else {
    		alert(data.message);
    	}
	}, function(xhr, status, error) {
		/* 리스트 조회 중 에러가 발생하였습니다. */
		alert("<spring:message code='exam.error.list' />");
	});
}

//성적 반영비율 입력 폼 변환
function chgScoreRatio(type) {
	if(type == 1) {
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
	var isChk = true;
	var scoreRatio = 0;	// 시험 반영 점수
	var examCds = "";
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
			/* 점수는 100점 까지 입력 가능 합니다. */
			alert("<spring:message code='exam.alert.score.max.100' />");
			isChk = false;
			return false;
		}
	});
	
	if(isChk) {
		if(Number(scoreRatio) != 100 && $(".scoreRatio").length > 0) {
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
	        		listEtcExam();
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

</script>

<body>
	<div class="ui form">
		<div class="option-content pt10 pb10">
			<%-- <h3 class="graduSch"> <spring:message code="exam.label.always.exam" /><!-- 수시평가 --></h3> --%>
			<div class="ui action input search-box mr5">
			    <input type="text" id="searchValue1" placeholder="<spring:message code="crs.label.exam_name" /><spring:message code="exam.label.input" />">
			    <button class="ui icon button" onclick="listEtcExam();"><i class="search icon"></i></button>
			</div>
			<div class="mla">
				<div class="chgScoreRatioDiv">
                   	<a href="javascript:saveScoreRatio()" class="ui basic button"><spring:message code="forum.button.scoreRatio.save" /></a><!-- 성적반영 비율 저장 -->
                   	<a href="javascript:chgScoreRatio(2)" class="ui basic button"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
                </div>
				<a href="javascript:chgScoreRatio(1)" id="chgScoreRatioBtn" class="ui basic button"><spring:message code="forum.button.scoreRatio.change" /></a><!-- 성적반영 비율 조정 -->
			</div>
		</div>
		<table class="table listTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />" id="examEtcListTable"><!-- 등록된 내용이 없습니다. -->
			<thead>
				<tr>
					<th><spring:message code="common.number.no" /><!-- NO --></th>
					<th><spring:message code="exam.label.schedule" /><!-- 주차 --></th>
					<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.nm" /><!-- 명 -->(<spring:message code="exam.label.schedule.nm" /><!-- 주차명 -->)</th>
					<th><spring:message code="exam.label.grade" /><!-- 성적 --><spring:message code="exam.label.score.aply.rate" /><!-- 반영비율 --></th>
					<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.dttm" /><!-- 일시 --></th>
					<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.period" /><!-- 기간 --></th>
					<th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.type" /><!-- 유형 --></th>
					<th><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --></th>
					<th><spring:message code="exam.label.score.open.dttm" /><!-- 성적공개일시 --></th>
					<th><spring:message code="exam.label.qstn.submit.status" /><!-- 출제상태 --></th>
				</tr>
			</thead>
			<tbody id="examEtcList">
			</tbody>
		</table>
	</div>
</body>
</html>
