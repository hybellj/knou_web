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
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			listAbsentHsty();
		});
		
		// 결시원 신청이력 목록
		function listAbsentHsty() {
			var url  = "/exam/examAbsentList.do";
			var data = {
				"rgtrId" 		  : "${uuivo.userId}",
				"examStareTypeCd" : $("#absentStareTypeCd").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
	        		var html = "";
	        		var appCnt = 0;
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				appCnt = v.totalCnt;
	        				var apprStatNm = "";
	        				if(v.apprStat == "APPLICATE") {
	        					apprStatNm = "<spring:message code='exam.label.applicate' />";/* 신청 */
	        				} else if(v.apprStat == "RAPPLICATE") {
	        					apprStatNm = "<spring:message code='exam.label.rapplicate' />";/* 재신청 */
	        				} else if(v.apprStat == "APPROVE") {
	        					apprStatNm = "<spring:message code='exam.label.approve' />";/* 승인 */
	        				} else if(v.apprStat == "COMPANION") {
	        					apprStatNm = "<spring:message code='exam.label.companion' />";/* 반려 */
	        				}
	        				var regDttm = dateFormat("date", v.regDttm);
	        				var apprCts = v.apprCts != null ? v.apprCts : '';
	        				html += "<tr>";
	        				html += "	<td class='tc'>"+v.lineNo+"</td>";
	        				html += "	<td class='tc'>"+v.examStareTypeNm+"</td>";
	        				html += "	<td class='tc'>"+apprStatNm+"</td>";
	        				html += "	<td class='tc'>"+regDttm+"</td>";
	        				html += "	<td><pre>"+v.absentCts+"</pre></td>";
	        				html += "	<td><pre>"+apprCts+"</pre></td>";
	        				html += "</tr>";
	        			});
	        		}
	        		
	        		$("#examAbsentHstyCnt").text(appCnt);
	        		$("#examAbsentHstyList").empty().html(html);
	        		$("#examAbsentHstyTable").footable();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
			});
		}
	</script>
	
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content p10">
        		<p class="fcBlue ml10"><spring:message code="exam.label.user_id" /><!-- 학 번 --> : ${uuivo.userId }</p>
        		<p class="fcBlue ml30"><spring:message code="exam.label.user_nm" /><!-- 성 명 --> : ${uuivo.userNm }</p>
        	</div>
        	<div class="option-content mb20">
        		<h3 class="sec_head"><spring:message code="exam.label.absent.apply.hsty" /><!-- 결시원 신청이력 --></h3>
        		<span class="ml20">[ <spring:message code="exam.label.total" /><!-- 총 --> <label class="fcBlue" id="examAbsentHstyCnt"></label><spring:message code="exam.label.cnt" /><!-- 건 --> ]</span>
        		<div class="mla">
        			<select class="ui dropdown" id="absentStareTypeCd" onchange="listAbsentHsty()">
        				<option value=""><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></option>
        				<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
        				<option value="M"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></option>
        				<option value="L"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></option>
        			</select>
        		</div>
        	</div>
        	<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />" id="examAbsentHstyTable"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th class="tc"><spring:message code="main.common.number.no" /><!-- NO. --></th>
        				<th class="tc"><spring:message code="exam.label.stare.type" /><!-- 구분 --></th>
        				<th class="tc"><spring:message code="exam.label.process.status" /><!-- 처리상태 --></th>
        				<th class="tc"><spring:message code="exam.label.process.dttm" /><!-- 처리일시 --></th>
        				<th class="tc"><spring:message code="exam.label.absent.reason" /><!-- 결시 사유 --></th>
        				<th class="tc"><spring:message code="exam.label.approve.cts" /><!-- 처리의견 --></th>
        			</tr>
        		</thead>
        		<tbody id="examAbsentHstyList">
        		</tbody>
        	</table>
        	
            <div class="bottom-content mt50">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
