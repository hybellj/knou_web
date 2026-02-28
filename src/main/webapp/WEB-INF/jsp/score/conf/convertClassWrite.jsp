<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function editConvert(scorCd) {
	$("#scorCd").val(scorCd);
 	$("#convertForm").attr("action", "/score/scoreConf/editConvert.do");
	$("#convertForm").submit();
}

//사용여부
function togleUseYn(obj_id) {
	var useYn = "Y";
	if($("#"+obj_id+"").is(":checked")){
 		useYn = "N"; 
 	} 
	var scorCd = obj_id.substr(obj_id.indexOf('_')+1);
	
	var data = {
		 	"scorCd" : scorCd
		 	,"useYn" : useYn
			//,"useYn" : useYn == true ? 'Y' : 'N'
	};

	ajaxCall("/score/scoreConf/editConvertUseYn.do", data, function(data){
		if(data.result > 0){
			alert(data.message);
		}
	}, function(){});
}
</script>

<body>
	<form class="ui form" id="convertForm" name="convertForm" method="POST">
	<input type="hidden" name="scorCd" id="scorCd" value="">

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
	                            <h2 class="page-title"><spring:message code="score.base.info.manager.label"/> > <spring:message code="score.exchange.grade.label"/></h2> <!-- 성적기초정보관리> 성적환산등급 -->
	                            <div class="button-area">
	                            </div>
	                        </div>
	
	                        <!-- 영역 -->
	                        <table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='score.rel.table.empty.label'/>"><!-- 등록된 상대평가비율 정보가 없습니다. -->
	                            <thead>
	                                <tr>
	                                    <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
	                                    <th scope="col"><spring:message code="socre.grade.label"/></th>							<!-- 성적등급 -->
	                                    <th scope="col"><spring:message code="socre.grade.point.average.label"/></th>	<!-- 평점 -->
	                                    <th scope="col"><spring:message code="score.standard.label"/></th>					<!-- 기준점수 -->
	                                    <th scope="col"><spring:message code="score.start.label"/></th>							<!-- 시작점수 -->
	                                    <th scope="col" ><spring:message code="score.end.label"/></th>							<!-- 종료점수 -->
	                                    <th scope="col"><spring:message code="score.useyn.label"/></th>						<!-- 사용여부 -->
	                                    <th scope="col"><spring:message code="score.manage.label"/></th>						<!-- 관리 -->
	                                </tr>
	                            </thead>
	                            <tbody>
	                                <c:if test="${not empty editConvertClassView}">
	                                    <c:forEach items="${editConvertClassView}" var="item" varStatus="status">
	                                        <tr>
	                                            <td>
	                                                <c:out value='${fn:escapeXml(item.scorOdr)}' />
	                                            </td>
	                                            <td>
	                                                <c:out value='${fn:escapeXml(item.scorCd)}' />
	                                            </td>
	                                            <td>
	                                                <input type="text" name="avgScor" id="avgScor" value="${fn:escapeXml(item.avgScor)}">
	                                            </td>
	                                            <td>
	                                                <input type="text" name="baseScor" id="baseScor" value="${fn:escapeXml(item.baseScor)}">
	                                            </td>
	                                            <td>
	                                                <input type="text" name="startScor" id="startScor" value="${fn:escapeXml(item.startScor)}">
	                                            </td>
	                                            <td>
	                                                <input type="text" name="endScor" id="endScor" value="${fn:escapeXml(item.endScor)}">
	                                            </td>
	                                            <td>
	                                                <div class="ui toggle checkbox" onclick="togleUseYn('useYn_${item.scorCd}');">
	                                                    <input type="checkbox" id="useYn_${item.scorCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if>>
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <a href="javascript:editConvert('${fn:escapeXml(item.scorCd)}')" class="ui blue button"><spring:message code="socre.save.button" /></a> <!-- 저장 -->
	                                                <a href="/score/scoreConf/convertClassList.do" class="ui blue button"><spring:message code='socre.list.button'/></a> <!-- 목록 -->
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
