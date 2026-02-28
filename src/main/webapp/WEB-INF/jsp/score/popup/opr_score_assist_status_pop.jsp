<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/score/common/score_common_inc.jsp" %>
	
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
   		var TERM_LESSON_LIST = [];
   	
	   	$(document).ready(function() {
			<c:forEach var="item" items="${listTermLesson}">
				TERM_LESSON_LIST.push({
					lsnOdr: '<c:out value="${item.lsnOdr}" />'
				});
			</c:forEach>
			
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					list();
				}
			});
	   		list();
		});
	   	
	 	// 목록조회
		function list() {
			var maxLsnOdr;
			var tableHtml = '';
			
			tableHtml += '<thead class="sticky top0">';
			tableHtml += '	<tr>';
			tableHtml += '		<th class="tc p5" rowspan="2"><spring:message code="common.number.no" /><!-- NO. --></th>';
			tableHtml += '		<th class="tc p5" rowspan="2" style="min-width: 100px"><spring:message code="score.label.crs.cre.nm" /><!-- 과목명 --></th>';
			tableHtml += '		<th class="tc p5" rowspan="2" style="min-width: 50px"><spring:message code="common.label.decls.no" /><!-- 분반 --></th>';
			tableHtml += '		<th class="tc p5" rowspan="2" style="min-width: 80px"><spring:message code="score.label.hr.no" /><!-- 인사번호 --></th>';
			tableHtml += '		<th class="tc p5" rowspan="2" style="min-width: 80px"><spring:message code="common.teaching.assistant" /><!-- 조교 --></th>';
			TERM_LESSON_LIST.forEach(function(v, j) {
				tableHtml += '	<th class="tc p5" colspan="2">' + v.lsnOdr + '<spring:message code="common.week" /></th>';	// 주차
				
				maxLsnOdr = v.lsnOdr;
			});
			tableHtml += '		<th class="tc p5" colspan="3">1~' + maxLsnOdr + '<spring:message code="score.label.week.sum" /></th>'; // 주차 합계
			tableHtml += '		<th class="tc p5" rowspan="2" style="min-width: 80px">1~' + maxLsnOdr + '<spring:message code="score.label.week.minus.cnt" /></th>'; // 주차 벌점횟수
			tableHtml += '	</tr>';
			tableHtml += '	<tr>';
			TERM_LESSON_LIST.forEach(function(v, j) {
				tableHtml += '	<th class="tc" style="min-width: 40px"><spring:message code="score.label.plus.score" /></th>'; // 상점
				tableHtml += '	<th class="tc" style="min-width: 40px"><spring:message code="score.label.minus.score" /></th>'; // 벌점
			});
			tableHtml += '		<th class="tc" style="min-width: 40px"><spring:message code="score.label.plus.score" /></th>'; // 상점
			tableHtml += '		<th class="tc" style="min-width: 40px"><spring:message code="score.label.minus.score" /></th>'; // 벌점
			tableHtml += '		<th class="tc" style="min-width: 40px"><spring:message code="common.label.total.point" /></th>'; // 총점
			tableHtml += '	</tr>';
			tableHtml += '</thead>';
			tableHtml += '<tbody id="operateScoreList"></tbody>';
			
			$("#operateScoreTable").empty().html(tableHtml);
			
			var url = "/score/scoreHome/listOprScoreAssistTotal.do";
			var param = {
				  termCd		: '<c:out value="${vo.termCd}" />'
				, searchValue	: $("#searchValue").val()
				, searchKey		: "scoreAssistStatusPop"
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						html += '<tr>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td class="word_break_none">' + v.crsCreNm + '</td>';
						html += '	<td class="tc">' + v.declsNo + '</td>';
						html += '	<td class="tc word_break_none">' + v.userId + '</td>';
						html += '	<td class="word_break_none">' + v.userNm + '</td>';
						TERM_LESSON_LIST.forEach(function(vv, j) {
							html += '<td class="tc"><a href="javascript:oprScoreAssistDetailModal(\'' + v.crsCreCd + '\', \'' + v["lessonScheduleId" + vv.lsnOdr] + '\', \'' + v.userId + '\')" class="fcBlue">' + (typeof v["plusScore" + vv.lsnOdr] === "undefined" || v["plusScore" + vv.lsnOdr] === null ? '-' : v["plusScore" + vv.lsnOdr]) + '</a></td>';
							html += '<td class="tc"><a href="javascript:oprScoreAssistDetailModal(\'' + v.crsCreCd + '\', \'' + v["lessonScheduleId" + vv.lsnOdr] + '\', \'' + v.userId + '\')" class="fcBlue">' + (typeof v["minusScore" + vv.lsnOdr] === "undefined" || v["plusScore" + vv.lsnOdr] === null ? '-' : v["minusScore" + vv.lsnOdr]) + '</a></td>';
						});
						html += '	<td class="tc"><a href="javascript:oprScoreAssistDetailModal(\'' + v.crsCreCd + '\', \'\', \'' + v.userId + '\')" class="fcBlue">' + (typeof v.plusScore === "undefined" ? '-' : v.plusScore) + '</a></td>';
						html += '	<td class="tc"><a href="javascript:oprScoreAssistDetailModal(\'' + v.crsCreCd + '\', \'\', \'' + v.userId + '\')"><span class="fcRed">' + (typeof v.minusScore === "undefined" ? '-' : v.minusScore) + '</span></a></td>';
						html += '	<td class="tc">' + (typeof v.totScore === "undefined" ? '-' : v.totScore) + '</td>';
						html += '	<td class="tc"><span class="fcRed">' + v.minusCnt + '<spring:message code="exam.label.times" /></span></td>'; // 회
						html += '</tr>';
					});
					
					$("#operateScoreList").html(html);
					
					if(returnList.length > 0) {
						$("#tableResultNone").hide();
					} else {
						$("#tableResultNone").show();
					}
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
	 	
	 	
		function oprScoreAssistDetailModal(crsCreCd, lessonScheduleId, userId) {
			parent.oprScoreAssistDetailModal(crsCreCd, lessonScheduleId, userId);
		}
		
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<div class="ui form">
			<div class="option-content mb10">
				<div class="ui action input search-box">
					<input id="searchValue" type="text" placeholder="<spring:message code="socre.common.placeholder.oper.score.pop" />" value="" />
					<button class="ui icon button" type="button" onclick="list()">
						<i class="search icon"></i>
					</button>
				</div>
			</div>
			<div class="footable_box type2 max-height-550">
				<table class="tBasic" data-empty="<spring:message code='common.content.not_found' />" id="operateScoreTable"><!-- 등록된 내용이 없습니다. -->
				</table>
				<div class="none tc pt10" id="tableResultNone">
					<span><spring:message code="common.nodata.msg"/></span><!-- 등록된 내용이 없습니다. -->
				</div>
			</div>
		</div>
		<div class="bottom-content tr">
			<button type="button" class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>

</body>
</html>