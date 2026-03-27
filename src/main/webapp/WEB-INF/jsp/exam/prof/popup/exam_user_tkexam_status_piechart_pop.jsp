<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
        $(document).ready(function() {
            scorePieChart("${chartMap.completeCnt + chartMap.tempSaveCnt}", "${chartMap.noTkexamCnt }");
            scoreBarChart("${chartMap.avgScore}", "${chartMap.maxScore}", "${chartMap.minScore}");
        });
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="border-1 padding-3">
				<div>
					<canvas id="pieChart" class="chart_wm350" height="100"></canvas>
				</div>
				<div>
					<canvas id="barChart" class="chart_wm350" height="100"></canvas>
				</div>
			</div>

            <div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
