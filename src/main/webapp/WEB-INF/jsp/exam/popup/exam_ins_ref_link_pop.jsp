<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		// 대체평가 목록
		function listInsRef() {
			var url  = "/exam/listSetInsRef.do";
			var data = {
				"examTypeCd" : $("input[name=examTypeCd]:checked").val(),
				"crsCreCd"	 : "${creCrsVO.crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							var startDt = v.startDt.substring(0,4) + "." + v.startDt.substring(4,6) + "." + v.startDt.substring(6,8) + " " + v.startDt.substring(8,10) + ":" + v.startDt.substring(10,12) + ":" + v.startDt.substring(12,14);
							var endDt   = v.endDt.substring(0,4) + "." + v.endDt.substring(4,6) + "." + v.endDt.substring(6,8) + " " + v.endDt.substring(8,10) + ":" + v.endDt.substring(10,12) + ":" + v.endDt.substring(12,14);
							html += "<tr>";
							html += "	<td>" + v.stareTypeNm + "</td>";
							html += "	<td>" + v.title + "</td>";
							html += "	<td>" + startDt + "</td>";
							html += "	<td>" + endDt + "</td>";
							html += "	<td><button type='button' class='ui small basic button' onclick='setInsRef(\""+v.stareType+"\", \""+v.code+"\", \""+v.submitYn+"\", \""+v.startDt+"\", \""+v.endDt+"\")'><spring:message code='exam.button.select' /></button></td>";/* 선택 */
							html += "</tr>";
						});
					}
					
					$("#insTbody").empty().html(html);
					$("#insTable").footable();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 선택
		function setInsRef(stareType, code, submitYn, startDt, endDt) {
			var url  = "/exam/setInsRef.do";
			var data = {
				"examTypeCd" 		: stareType,
				"insRefCd"	 		: code,
				"examSubmitYn" 		: submitYn,
				"examStartDttm" 	: startDt,
				"examEndDttm" 		: endDt,
				"examCd"			: "${vo.examCd}",
				"examStareTypeCd" 	: "${vo.examStareTypeCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.subs.link.y' />");/* 대체평가 연결이 완료되었습니다. */
					window.parent.closeModal();
					window.parent.location.reload();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="header2">
        		<h3>[ ${creCrsVO.creYear }<spring:message code="exam.label.year" /><!-- 년 --> ${creCrsVO.creTermNm } ${vo.examStareTypeNm } ]</h3>
        	</div>
        	<div class="ui small message">
	            <i class="info circle icon"></i>
	            <c:set var="examStr"><spring:message code='exam.label.mid.exam' /></c:set>
	            <c:if test="${vo.examStareTypeCd eq 'L' }"><c:set var="examStr"><spring:message code='exam.label.end.exam' /></c:set></c:if>
	            <spring:message code="exam.label.set.ins.ref.link.info" arguments="${examStr }" /><!-- 학습활동에서 진행한 과제/토론/퀴즈를 {0}로 변경(또는 해제)할 수 있습니다. -->
	        </div>
        	<div class="option-content mt20 mb20">
        		<div class="ui radio checkbox mr5">
        			<input type="radio" id="typeAsmnt" name="examTypeCd" value="ASMNT" onchange="listInsRef()" />
        			<label for="typeAsmnt"><spring:message code="common.label.tasks" /><!-- 과제 --></label>
        		</div>
        		<div class="ui radio checkbox">
        			<input type="radio" id="typeForum" name="examTypeCd" value="FORUM" onchange="listInsRef()" />
        			<label for="typeForum"><spring:message code="common.label.discussion" /><!-- 토론 --></label>
        		</div>
        		<div class="ui radio checkbox mr5">
        			<input type="radio" id="typeQuiz" name="examTypeCd" value="QUIZ" onchange="listInsRef()" />
        			<label for="typeQuiz"><spring:message code="common.label.question" /><!-- 퀴즈 --></label>
        		</div>
        	</div>
        	<table class="table type2" id="insTable" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th><spring:message code="exam.label.stare.type" /><!-- 구분 --></th>
        				<th><spring:message code="exam.label.title" /><!-- 제목 --></th>
        				<th><spring:message code="exam.label.start.dt" /><!-- 시작일 --></th>
        				<th><spring:message code="exam.label.end.dt" /><!-- 종료일 --></th>
        				<th><spring:message code="exam.button.select" /><!-- 선택 --></th>
        			</tr>
        		</thead>
        		<tbody id="insTbody"></tbody>
        	</table>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
