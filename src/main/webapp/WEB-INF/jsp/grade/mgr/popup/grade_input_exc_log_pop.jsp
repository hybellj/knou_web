<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    <script type="text/javascript">
	    $(document).ready(function() {
	    	listLog();
	    	
	    	$("#searchValue").on("keyup", function(e) {
	    		if(e.keyCode == 13) {
	    			listLog();
	    		}
	    	});
	    });
	    
	    // 로그 목록
	    function listLog() {
	    	var url  = "/logSysJobSchExc/schExcList.do";
			var data = {
				"creYear" 	  : $("#creYear").val(),
				"creTerm" 	  : $("#creTerm").val(),
				"univGbn"	  : $("#univGbn").val(),
				"mngtDeptCd"  : $("#mngtDeptCd").val(),
				"searchValue" : $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
							var regDttm = v.regDttm.substring(0,4) + "." + v.regDttm.substring(4,6) + "." + v.regDttm.substring(6,8) + " " + v.regDttm.substring(8,10) + ":" + v.regDttm.substring(10,12);
							html += "<tr>";
							html += "	<td>" + v.lineNo + "</td>";
							html += "	<td>" + v.deptNm + "</td>";
							html += "	<td>" + v.crsCreNm + "</td>";
							html += "	<td>" + v.crsCd + "</td>";
							html += "	<td>" + v.declsNo + "</td>";
							html += "	<td>" + v.tchNm + "</td>";
							html += "	<td>" + v.tchNo + "</td>";
							html += "	<td>" + v.excLogCts + "</td>";
							html += "	<td>" + v.rgtrId + "</td>";
							html += "	<td>" + regDttm + "</td>";
							html += "</tr>";
						});
					}
					
					$("#totalCnt").text(returnList.length > 0 ? returnList.length : 0);
					$("#logTbody").empty().html(html);
					$("#logTable").footable();
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
    		});
	    }
	    
	    // 엑셀 다운로드
	    function excelDown() {
	    	var excelGrid = {
		    	colModel:[
		    		{label:'<spring:message code="common.number.no"/>', 				name:'lineNo', 		align:'left', 	width:'1000'},	// NO
		    		{label:'<spring:message code="common.phy.dept_name" />', 			name:'deptNm', 		align:'left', 	width:'5000'},	// 관상학과
		    		{label:'<spring:message code="crs.label.crecrs.nm" />', 			name:'crsCreNm', 	align:'left', 	width:'7000'},	// 과목명
		    		{label:'<spring:message code="common.crs.cd" />', 					name:'crsCd', 		align:'left', 	width:'5000'},	// 학수번호
		    		{label:'<spring:message code="common.label.decls.no" />', 			name:'declsNo', 	align:'left', 	width:'3000'},	// 분반
		    		{label:'<spring:message code="common.charge.professor" />', 		name:'tchNm', 		align:'center', width:'3000'},	// 담당교수
		    		{label:'<spring:message code="common.label.prof.no" />', 			name:'tchNo', 		align:'center', width:'5000'},	// 교수사번
		    		{label:'<spring:message code="score.label.process.detail" />', 		name:'excLogCts', 	align:'center', width:'10000'},	// 처리내역
		    		{label:'<spring:message code="score.label.process.handler" />', 	name:'rgtrId', 		align:'left',	width:'3000'},	// 처리자
		    		{label:'<spring:message code="score.label.process.date" />', 		name:'regDttm', 	align:'center', width:'4000'},	// 처리일시
		    	]
		    };
		    	
		    $("form[name='excelForm']").remove();
		    var excelForm = $('<form></form>');
		    excelForm.attr("name","excelForm");
		    excelForm.attr("action","/logSysJobSchExc/schExcListExcelDown.do");
		    excelForm.append($('<input/>', {type: 'hidden', name: 'creYear', 		value: $("#creYear").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'creTerm', 		value: $("#creTerm").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: $("#univGbn").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'mngtDeptCd', 	value: $("#mngtDeptCd").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
		    excelForm.appendTo('body');
		    excelForm.submit();
	    }
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page">
        <div id="wrap">
        	<div class="option-content mb20">
        		<select class="ui dropdown mr5" id="creYear" onchange="listLog()">
        			<c:forEach var="item" items="${yearList }">
        				<option value="${item }" ${item eq vo.creYear ? 'selected' : '' }>${item }</option>
        			</c:forEach>
        		</select>
        		<select class="ui dropdown mr5" id="creTerm" onchange="listLog()">
        			<c:forEach var="item" items="${termList }">
        				<option value="${item.codeCd }" ${item.codeCd eq vo.creTerm ? 'selected' : '' }>${item.codeNm }</option>
        			</c:forEach>
        		</select>
        		<c:if test="${orgId eq 'ORG0000001' }">
			    	<select class="ui dropdown mr5" id="univGbn" onchange="listLog()">
			    		<option value="ALL" ${vo.univGbn eq 'ALL' ? 'selected' : '' }><spring:message code="common.label.uni.type" /><!-- 대학구분 --></option>
			    		<c:forEach var="item" items="${univGbnList}">
							<option value="${item.codeCd}" <c:if test="${item.codeCd eq vo.univGbn}">selected</c:if> ><c:out value="${item.codeNm}" /></option>
						</c:forEach>
			    	</select>
		        </c:if>
        		<select class="ui dropdown mr5" id="mngtDeptCd" onchange="listLog()">
        			<option value="ALL" ${vo.mngtDeptCd eq 'ALL' ? 'selected' : '' }><spring:message code="common.dept_name" /><!-- 학과 --></option>
        			<c:forEach var="item" items="${usrDeptCdList }">
        				<option value="${item.deptCd }" ${vo.mngtDeptCd eq item.deptCd ? 'selected' : '' }>${item.deptNm }</option>
        			</c:forEach>
        		</select>
        		<div class="ui input">
                    <input id="searchValue" type="text" placeholder="과목명/학수번호/교수명 입력" autocomplete="off" value="${vo.searchValue }">
                </div>
	            <button type="button" class="ui green button mla" onclick="listLog()"><spring:message code="common.button.search" /><!-- 검색 --></button>
        	</div>
        	<div class="option-content mb20">
        		<h3><spring:message code="score.label.grade.input.date.exc.log" /><!-- 성적입력기간 예외처리 로그 --></h3>
        		<p class="ml20">[ <spring:message code="common.page.total" /><!-- 총 --> <span class="fcBlue" id="totalCnt">0</span><spring:message code="common.page.total_count" /><!-- 건 --> ]</p>
        		<button type="button" class="ui green small button mla" onclick="excelDown()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
        	</div>
        	<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.content.not_found' />" id="logTable"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th>No</th>
        				<th><spring:message code="common.phy.dept_name" /><!-- 관장학과 --></th>
        				<th><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
        				<th><spring:message code="common.crs.cd" /><!-- 학수번호 --></th>
        				<th><spring:message code="common.label.decls.no" /><!-- 분반 --></th>
        				<th><spring:message code="common.charge.professor" /><!-- 담당교수 --></th>
			           	<th><spring:message code="common.label.prof.no" /><!-- 교수사번 --></th>
        				<th><spring:message code="score.label.process.detail" /><!-- 처리내역 --></th>
        				<th><spring:message code="score.label.process.handler" /><!-- 처리자 --></th>
        				<th><spring:message code="score.label.process.date" /><!-- 처리일시 --></th>
        			</tr>
        		</thead>
        		<tbody id="logTbody"></tbody>
        	</table>

            <div class="bottom-content">
                <button type="button" class="ui basic button" onclick="window.parent.closeModal()"><spring:message code="team.common.close"/></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
