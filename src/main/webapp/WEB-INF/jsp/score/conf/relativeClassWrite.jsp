<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function editRelative(scorRelCd) {

	$("#scorRelCd").val(scorRelCd);
	$("#relativeForm").attr("action", "/score/scoreConf/editRelative.do");
	$("#relativeForm").submit();
}

//사용여부
function togleUseYn(obj_id) {
	var useYn = "Y";
	if($("#"+obj_id+"").is(":checked")){
 		useYn = "N"; 
 	} 
	var scorRelCd = obj_id.substr(obj_id.indexOf('_')+1);
	
	var data = {
		 	"scorRelCd" : scorRelCd
		 	,"useYn" : useYn
			//,"useYn" : useYn == true ? 'Y' : 'N'
	};

	ajaxCall("/score/scoreConf/editRelativeUseYn.do", data, function(data){
		if(data.result > 0){
			alert(data.message);
		}
	}, function(){});
}
</script>

<body>
    <form class="ui form" id="relativeForm" name="relativeForm" method="POST">
    <input type="hidden" name="scorRelCd" id="scorRelCd" value="">

    <div id="wrap" class="pusher">
    
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		<!-- //header -->

		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->
        
        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content">

				<!-- admin_location -->
				<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
				<!-- //admin_location -->

                <div class="ui segment">
                    <div class="ui form">
                        <div class="layout2">
                            <!-- 타이틀 -->
                            <div id="info-item-box">
                                <h2 class="page-title"><spring:message code="score.base.info.manager.label"/> > <spring:message code="score.relative.evaluation.label"/></h2> <!-- 성적기초정보관리 > 상대평가비율 -->
                                <div class="button-area">
                                </div>
                            </div>

                            <!-- 영역 -->
                            <table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='score.rel.table.empty.label'/>"><!-- 등록된 상대평가비율 정보가 없습니다. -->
                                <thead>
                                    <tr>
                                        <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
                                        <th scope="col"><spring:message code="socre.start.grade.label" /></th>					<!-- 시작등급 -->
                                        <th scope="col"><spring:message code="socre.end.grade.label" /></th>					<!-- 종료등급 -->
                                        <th scope="col"><spring:message code="score.start.percentage.label" />(%)</th>	<!-- 시작백분율(%) -->
                                        <th scope="col"><spring:message code="score.end.percentage.label" />(%)</th>	<!-- 종료백분율(%) -->
                                        <th scope="col"><spring:message code="score.useyn.label" /></th>						<!-- 사용여부 -->
                                        <th scope="col"><spring:message code="score.manage.label" /></th>					<!-- 관리 -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${not empty editRelativeClassView}">
                                        <c:forEach items="${editRelativeClassView}" var="item" varStatus="status">
                                            <tr>
                                                <td>
                                                    <c:out value='${fn:escapeXml(item.scorOdr)}' />
                                                </td>
                                                <td>
                                                    <select class="" name="startScorCd" id="startScorCd" title="<spring:message code="socre.start.grade.label" />">
                                                        <option value="A+" <c:if test="${item.startScorCd eq 'A+'}">selected</c:if>>A+</option>
                                                        <option value="A" <c:if test="${item.startScorCd eq 'A'}">selected</c:if>>A</option>
                                                        <option value="B+" <c:if test="${item.startScorCd eq 'B+'}">selected</c:if>>B+</option>
                                                        <option value="B" <c:if test="${item.startScorCd eq 'B'}">selected</c:if>>B</option>
                                                        <option value="C+" <c:if test="${item.startScorCd eq 'C+'}">selected</c:if>>C+</option>
                                                        <option value="C" <c:if test="${item.startScorCd eq 'C'}">selected</c:if>>C</option>
                                                        <option value="D+" <c:if test="${item.startScorCd eq 'D+'}">selected</c:if>>D+</option>
                                                        <option value="D" <c:if test="${item.startScorCd eq 'D'}">selected</c:if>>D</option>
                                                        <option value="F" <c:if test="${item.startScorCd eq 'F'}">selected</c:if>>F</option>
                                                        <option value="P" <c:if test="${item.startScorCd eq 'P'}">selected</c:if>>P</option>
                                                    </select>
                                                </td>
                                                <td>
                                                        <select class="" name="endScorCd" id="endScorCd" title="<spring:message code="socre.end.grade.label" />">
                                                        <option value="A+" <c:if test="${item.endScorCd eq 'A+'}">selected</c:if>>A+</option>
                                                        <option value="A" <c:if test="${item.endScorCd eq 'A'}">selected</c:if>>A</option>
                                                        <option value="B+" <c:if test="${item.endScorCd eq 'B+'}">selected</c:if>>B+</option>
                                                        <option value="B" <c:if test="${item.endScorCd eq 'B'}">selected</c:if>>B</option>
                                                        <option value="C+" <c:if test="${item.endScorCd eq 'C+'}">selected</c:if>>C+</option>
                                                        <option value="C" <c:if test="${item.endScorCd eq 'C'}">selected</c:if>>C</option>
                                                        <option value="D+" <c:if test="${item.endScorCd eq 'D+'}">selected</c:if>>D+</option>
                                                        <option value="D" <c:if test="${item.endScorCd eq 'D'}">selected</c:if>>D</option>
                                                        <option value="F" <c:if test="${item.endScorCd eq 'F'}">selected</c:if>>F</option>
                                                        <option value="P" <c:if test="${item.endScorCd eq 'P'}">selected</c:if>>P</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <input type="text" name="startRatio" id="startRatio" value="${fn:escapeXml(item.startRatio)}">
                                                </td>
                                                <td>
                                                    <input type="text" name="endRatio" id="endRatio" value="${fn:escapeXml(item.endRatio)}">
                                                </td>
                                                <td>
                                                    <div class="ui toggle checkbox" onclick="togleUseYn('useYn_${item.scorRelCd}');">
                                                        <input type="checkbox" id="useYn_${item.scorRelCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if>>
                                                    </div> 
                                                </td>
                                                <td>
                                                    <a href="javascript:editRelative('${fn:escapeXml(item.scorRelCd)}')" class="ui blue button"><spring:message code="socre.save.button" /></a> <!-- 저장 -->
                                                    <a href="/score/scoreConf/relativeClassList.do" class="ui blue button"><spring:message code='socre.list.button'/></a> <!-- 목록 -->
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div><!-- //container -->
                </div>
            </div>
        </div>
        <!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    </form>
</body>
</html>
