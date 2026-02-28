<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			scorePieChart("${chartMap.completeCnt + chartMap.tempSaveCnt}", "${chartMap.noStareCnt }");
 			scoreBarChart("${chartMap.avgScore}", "${chartMap.maxScore}", "${chartMap.minScore}");
		});
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="row">
				<div class="col">
					<div class="ui segment" style="height:100%;">
						 <p><spring:message code="exam.label.quiz" /> <spring:message code="exam.label.status" /></p><!-- 퀴즈 --><!-- 현황 -->
						<div class="ui stackable equal width grid">
							<div class="column">
				                <canvas id="pieChart" height="250"></canvas>
				            </div>
				        	<div class="column">
				                <canvas id="barChart" height="250"></canvas>
				            </div>
				        </div>
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
