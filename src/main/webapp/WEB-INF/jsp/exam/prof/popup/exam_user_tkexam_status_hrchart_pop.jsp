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
        var	html  = `<tr>`;
            html += `	<td class="tc">100</td>`;
            html += `	<td class="tc">${chartMap.avgScore}</td>`;
            html += `	<td class="tc">${chartMap.topAvgScore}</td>`;
            html += `	<td class="tc">${chartMap.maxScore}</td>`;
            html += `	<td class="tc">${chartMap.minScore}</td>`;
            html += `	<td class="tc">${chartMap.noTkexamCnt + chartMap.tempSaveCnt + chartMap.completeCnt}</td>`;
            html += `</tr>`;

		$(document).ready(function() {
            examCommon.horizontalBarChartSet([
                <c:forEach var="item" items="${chartList}" varStatus="loop">
                { label: "${item.label}", cnt: ${item.cnt} }<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ], "N");
            examCommon.barChartSet({
                avgScore: ${chartMap.avgScore},
                topAvgScore: ${chartMap.topAvgScore},
                maxScore: ${chartMap.maxScore},
                minScore: ${chartMap.minScore}
            }, "M");

            $('#status').html(html);
        });
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="border-1 padding-3">
                <div class="ui segment" style="height:100%;">
                    <div class="column">
                        <canvas id="horiBarChart" height="100"></canvas>
                    </div>
                    <table class="table-type2" id="statusTable" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
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
                        <canvas id="midBarChart" height="100"></canvas>
                    </div>
                </div>
			</div>

            <div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
