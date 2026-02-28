<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		chartSet();
    	});
    	
    	/// 차트 출력
    	function chartSet() {
    		horizontalBarChartSet();
    		barChartSet();
    	}
    	
    	// 가로 바 차트 출력
    	function horizontalBarChartSet() {
    		var url  = "/exam/viewExamScoreHorizontalBarChart.do";
    		var data = {
    			  "examCd" : "${vo.examCd}"
    			, "crsCreCd" : "${vo.crsCreCd}"
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if(data.result > 0) {
    				var returnList = data.returnList || [];
    				
    				if(returnList.length > 0) {
    					examCommon.horizontalBarChartSet(returnList, "N");
    				}
            	} else {
            		alert(data.message);
            	}
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
    		});
    	}
    	
    	// 세로 바 차트 출력
    	function barChartSet() {
    		var url  = "/exam/viewExamScoreBarChart.do";
    		var data = {
    			  "examCd" : "${vo.examCd}"
    			, "crsCreCd" : "${vo.crsCreCd}"
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if(data.result > 0) {
    				var returnVO = data.returnVO;
    				
    				if(returnVO != null) {
    					examCommon.barChartSet(returnVO, "N");
    				    
    				    var	html  = `<tr>`;
    				    	html += `	<td class="tc">100</td>`;
    				    	html += `	<td class="tc">\${returnVO.avgScore }</td>`;
    				    	html += `	<td class="tc">\${returnVO.topAvgScore }</td>`;
    				    	html += `	<td class="tc">\${returnVO.maxScore }</td>`;
    				    	html += `	<td class="tc">\${returnVO.minScore }</td>`;
    				    	html += `	<td class="tc">\${returnVO.noStareCnt + returnVO.tempSaveCnt + returnVO.completeCnt }</td>`;
    				    	html += `</tr>`;
    				    	
    				    $("#scoreStatusCnt").text(returnVO.noStareCnt + returnVO.tempSaveCnt + returnVO.completeCnt);
    				    $("#status").html(html);
    				    $("#statusTable").footable();
    				}
    			} else {
            		alert(data.message);
            	}
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
    		});
    	}
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
			<div class="p20 m10">
				<div class="option-content">
					<p class="sec_head"><spring:message code="exam.label.distribution.grades" /></p><!-- 성적 분포도 -->
					<div class="mla">
						<p class="fcBlue"><spring:message code="exam.label.stare.user.cnt" /> : <span id="scoreStatusCnt"></span><spring:message code="exam.label.nm" /></p><!-- 대상인원 --><!-- 명 -->
					</div>
				</div>
				<div class="ui segment" style="height:100%;">
					 <div class="column">
					     <canvas id="horiBarChart" height="100"></canvas>
					 </div>
					 <table class="table" id="statusTable" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
					 	<thead>
					 		<tr>
					 			<th class="tc"><spring:message code="exam.label.gain.point" /></th><!-- 배점 -->
					 			<th class="tc"><spring:message code="exam.label.avg" /></th><!-- 평균 -->
					 			<th class="tc"><spring:message code="exam.label.avg.upper.10" /></th><!-- 상위10%평균 -->
					 			<th class="tc"><spring:message code="exam.label.max" /><spring:message code="exam.label.score.point" /></th><!-- 최고 --><!-- 점 -->
					 			<th class="tc"><spring:message code="exam.label.min" /><spring:message code="exam.label.score.point" /></th><!-- 최저 --><!-- 점 -->
					 			<th class="tc"><spring:message code="exam.label.total.join.user" /></th><!-- 총응시자수 -->
					 		</tr>
					 	</thead>
					 	<tbody id="status">
					 	</tbody>
					 </table>
					 <div class="column">
					     <canvas id="barChart" height="100"></canvas>
					 </div>
				</div>
			</div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
