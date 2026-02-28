<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed;width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>

   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			listLrnPrgrtBydept();
		});
		
		// 학기기수 세팅 변경
		function changeSmstrChrt() {
			var $sbjctSmstr = $('#sbjctSmstr');
			
			$sbjctSmstr.off("change");
			$sbjctSmstr.dropdown("clear");
			$sbjctSmstr.empty();
			
			let basicOptn = `<option value='ALL'><spring:message code="crs.label.open.term" /></option>`;	// 학기
			
			$.ajax({
				url  : "/crs/termMgr/smstrListByDgrsYr.do",
				data : {
					dgrsYr 	: $("#sbjctYr").val()
				<%--	,orgId	: $("#orgId").val() --%>
				},
				type : "GET",
				success: function(data) {
					if (data.result > 0) {
						var resultList = data.returnList;
						if (resultList.length > 0) {
							$sbjctSmstr.append(basicOptn);
							$.each(resultList, function(i, smstrChrtVO) {
								$sbjctSmstr.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
								/* $sbjctSmstr.append('<option'+' value="'+smstrChrtVO.smstrChrtId+'" >' + smstrChrtVO.smstrChrtnm + '</option>'); */
							})
						}
					}else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				}
			});
		}
		   
		// 학과별 전체통계 목록 조회
		function listLrnPrgrtBydept () {
			let url	 = "/lesson/lessonHome/lrnPrgrtListByDept.do";
			let data = {
				orgId	: $("#orgId").val(),
				sbjctYr	: $("#sbjctYr").val(),
				smstrChrtId : $("#sbjctSmstr").val()
			};
			
			$.ajax({
				url : url,
				data: data,
				type: "GET",
				success: function(data) {
					if (data.result > 0) {
						let returnList = data.returnList || [];
						let html = "";
						
						returnList.forEach(function(v, i) {
							html +=`
								<tr>
									<td>\${v.lineNo}</td>
									<td>\${v.sbjctYr}</td>
									<td>\${v.sbjctSmstr}</td>
									<td>\${v.orgnm}</td>
									<td>\${v.deptnm}</td>
									<td>\${v.allUserCnt}</td>
									<td>\${v.avgPrgrtByDept}</td>
								</tr>
							`;
						});
						$("#deptTable").empty().html(html);
						$("#deptTable").footable();
					}else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				}
			});
		} 
	</script>
</head>
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap">
		<div class="option-content ui segment">
			<select class="ui dropdown" id="sbjctYr" onchange="changeSmstrChrt()">
				<option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
				<c:forEach var="item" items="${yearList }">
					<option value="${item }" ${item eq curSmstrChrtVO.dgrsYr ? 'selected' : '' }>${item }</option>
				</c:forEach>
			</select>
			<select class="ui dropdown" id="sbjctSmstr" onchange="listLrnPrgrtBydept()"><!-- 개설학기 -->
				<option value=""><spring:message code="crs.label.open.term" /></option>
				<c:forEach var="list" items="${smstrChrtList }">
					<%-- <option value="${list.smstrChrtId }" ${list.dgrsSmstrChrt eq curSmstrChrtVO.dgrsSmstrChrt ? 'selected' : '' }>${list.smstrChrtnm }</option> --%>
					<option value="${list.smstrChrtId }">${list.smstrChrtnm }</option>
				</c:forEach>
			</select>
			<select class="ui dropdown" id="orgId" disabled><!-- 기관 -->
				<option value="">기관</option>
				<c:forEach var="list" items="${orgList }">
					<option value="${list.orgId }" ${list.orgId eq curSmstrChrtVO.orgId ? 'selected' : '' }>${list.orgnm }</option>
				</c:forEach>
			</select>
		</div>
		<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg'/>">
			<thead>
				<tr>
					<th class="w30"><spring:message code="common.no" /></th><!-- 번호 -->
					<th><spring:message code="common.year" /></th><!-- 년도 -->
					<th><spring:message code="common.term" /></th><!-- 학기 -->
					<th><spring:message code="common.label.org" /></th><!-- 기관 -->
					<th><spring:message code="common.dept_name" /></th><!-- 학과 -->
					<th><spring:message code="crs.learner.count" /></th><!-- 수강생 수 -->
					<th><spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /></th><!-- 평균학습진도율 -->
				</tr>
			</thead>
			<tbody id="#deptTable">
			</tbody>
		</table>
		<div class="bottom-content tc">
			<button class="ui basic button w100" type="button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	
</body>
</html>