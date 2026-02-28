<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	crsTermList(1);

	$("#searchValue").on("keydown", function(e){
		if(e.keyCode == 13) {
			crsTermList(1);
		}
	});
});

function crsTermList(page) {
	var listScale = $("#listScale option:selected").val();
	var termType =  $('#termType').val();
	var searchValue = $('#searchValue').val();
	var termStatus = $("#termStatus option:selected").val();

	$("#list").load("/crs/termMgr/crsTermList.do", 
		{
			"pageIndex" : page,
			"listScale" : $("#listScale").val(),
			"searchValue" : searchValue,
			"termType" : termType,
			"termStatus" : termStatus,
			"type" : "0"
		}
		,function (){
		$(".table").footable();
	});
}

// 엑셀 다운로드
function listExcel() {
	var excelGrid = {
		colModel:[
				{label:'<spring:message code="common.number.no"/>', name:'lineNo', align:'center', width:'1000'}, // No.
				{label:'<spring:message code="crs.title.term.name"/>', name:'termNm', align:'left',   width:'8000'}, // 학기명
				{label:'<spring:message code="crs.label.school.year"/>', name:'haksaYear', align:'center',   width:'3000'}, // 학사년도
				{label:'<spring:message code="common.term"/>', name:'haksaTermNm', align:'center',   width:'3000'}, // 학기
				{label:'<spring:message code="common.term.status"/>', name:'termStatus', align:'left',  width:'3000', codes:{FINISH:'종료',SERVICE:'운영',WAIT:'대기'}},
				{label:'<spring:message code="crs.label.course.connected"/>', name:'termLinkYn', align:'center',  width:'2000', codes:{Y:'<spring:message code="message.yes"/>',N:'<spring:message code="message.no"/>'}}, // 학사연동, 예, 아니오 
				{label:'<spring:message code="crs.label.course.count"/>', name:'crsCount', align:'right',  width:'2500'}, // 과목수(개)
				{id:'svcStartDttm', label:'<spring:message code="lesson.label.lesson.start.dttm" />', name:'svcStartDttm', align:'center',  width:'4000', formatter:'date', formatOptions:{srcformat:"yyyyMMddHHmmss", newformat:"yyyy.MM.dd HH:mm"}}, // <!-- 강의시작일자 -->
				{id:'svcEndDttm', label:'<spring:message code="review.lecture.EndDttm"/>', name:'svcEndDttm', align:'center',  width:'4000', formatter:'date', formatOptions:{srcformat:"yyyyMMddHHmmss", newformat:"yyyy.MM.dd HH:mm"}}, // <!-- 복습기간종료일자 -->
				]
		};
	
	var excelForm = $('<form></form>');
	excelForm.attr("name","excelForm");
	excelForm.attr("action","/crs/termMgr/termListExcel.do");
	var termTypeVal = $("#termType option:selected").val();
	excelForm.append($('<input/>', {type: 'hidden', name: 'termType', value: termTypeVal}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val() }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));

	excelForm.appendTo('body');
	excelForm.submit();
}
</script>

<body>
   	<div id="wrap" class="pusher">

		<!-- class_top 인클루드  -->
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <!-- //header -->
	
		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->
        
        <div id="container">
        
			<div class="content">
			
				<div id="info-item-box">
					<h2 class="page-title"><spring:message code="common.term"/>/<spring:message code="common.week"/> <spring:message code="common.mgr"/></h2> <%-- 학기 관리 --%>
					<div class="button-area">
						<a href="javascript:listExcel()" class="btn"><spring:message code="button.download.excel"/></a> <%-- 엑셀다운로드 --%>
						<a href="/crs/termMgr/Form/crsTermInfoWrite.do" class="btn btn-primary"><spring:message code="button.write"/></a> <%-- 등록 --%>
					</div>
				</div>

				<div class="ui form">
					
					<div class="option-content">
					
						<!-- 과정구분 -->
						<%--
						<select class="ui dropdown mr5" id="termType" onchange="crsTermList(1)">
							<option value=""><spring:message code="crs.title.course.division"/></option>
							<c:forEach var="crsOperUniItem"  items="${crsOperUniList}" varStatus="crsOperUniStatus">
								<option value="${crsOperUniItem.codeCd}" <c:if test="${termVo.termType eq crsOperUniItem.codeCd }">selected</c:if>>${crsOperUniItem.codeNm}</option>
							</c:forEach>
						</select>
						--%>
						
						<!-- 운영 상태 -->
						<select class="ui dropdown mr5" id="termStatus" onchange="crsTermList(1)">
							<option value=" "><spring:message code="common.term.status"/></option>
							<c:forEach var="termStatusitem"  items="${termStatusList}" varStatus="termStatusStatus">
								<option value="${termStatusitem.codeCd}" >${termStatusitem.codeNm}</option>
							</c:forEach>
						</select>
						
						<div class="ui action input search-box">
							<input type="text" placeholder="<spring:message code="crs.title.term.name"/>" name="searchValue" id="searchValue" >
							<button class="ui icon button" onclick="crsTermList(1)"><i class="search icon" ></i></button>
						</div>
						
						<div class="button-area">
							<select class="ui dropdown list-num" id="listScale" onchange="crsTermList(1)">
								<option value="10">10</option>
								<option value="20">20</option>
								<option value="50">50</option>
								<option value="100">100</option>
							</select>
						</div>
					</div>
					<div id="list"></div>
				</div>
			</div>
		</div>
    </div>
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</body>
</html>