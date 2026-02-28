<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function() {
			crecrsList(1);
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					crecrsList(1);
				}
			});
		});
		
		// 과목 목록
		function crecrsList(page) {
			var pagingYn = $("#listScale").val() == "200" ? "N" : "Y";
			var url  = "/crs/creCrsHome/listCrecrsByUserDept.do";
			var data = {
				"userId"		: "${vo.userId}",
				"creYear"		: $("#creYear").val(),
				"creTerm"		: $("#creTerm").val(),
				"pageIndex"   	: page,
				"listScale"   	: $("#listScale").val(),
				"searchValue" 	: $("#searchValue").val(),
				"pagingYn"		: pagingYn,
				"authGrpCd"		: "${vo.authGrpCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		var totalCnt = 0;
	        		
	        		if(returnList.length > 0) {
	        			totalCnt = returnList[0].totalCnt;
	        			returnList.forEach(function(v, i) {
	        				var tchNm = v.tchNm != null ? v.tchNm : "";
	        				var tutorNm = v.tutorNm != null ? v.tutorNm : "";
	        				var monitoringChk = v.monitoringYn == "Y" ? "checked" : "";
	        				html += "<tr>";
							html += "	<td>" + v.lineNo + "</td>";
							html += "	<td>" + v.crsTypeNm + "</td>";
							html += "	<td>" + v.crsOperTypeNm + "</td>";
							html += "	<td>" + v.deptNm + "</td>";
							html += "	<td>" + v.crsCd + "</td>";
							html += "	<td>" + v.crsCreNm + "(" + v.declsNo + ")" + "</td>";
							html += "	<td>" + tchNm + "</td>";
							html += "	<td>" + tutorNm + "</td>";
							html += "	<td>";
							html += "		<div class='ui toggle checkbox ml20'>";
							html += "			<input type='checkbox' tabindex='0' " + monitoringChk + " onchange='monitoringSet(\"" + v.crsCreCd + "\", this)'>";
							html += "			<label></label>";
							html += "		</div>";
							html += "	</td>";
							html += "</tr>";
						});
					}

					$("#crecrsCnt").text(totalCnt);
					$("#crecrsList").empty().html(html);
					$(".table").footable();
					if ($("#listScale").val() != "200") {
						var params = {
							totalCount : data.pageInfo.totalRecordCount,
							listScale : data.pageInfo.recordCountPerPage,
							currentPageNo : data.pageInfo.currentPageNo,
							eventName : "crecrsList"
						};

						gfn_renderPaging(params);
					}
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert("<spring:message code='fail.common.msg' />");
			}, true);
		}

		// 모니터링 설정
		function monitoringSet(crsCreCd, obj) {
			var url = "";
			if (obj.checked) {
				url = "/crs/creCrsHome/insertCrecrsTch.do";
			} else {
				url = "/crs/creCrsHome/deleteCrecrsTch.do";
			}
			var data = {
				"crsCreCd" : crsCreCd,
				"userId" : "${vo.userId}",
				"tchType" : "MONITORING"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
				}
			}, function(xhr, status, error) {
				/* 모니터링 과목설정에 실패하였습니다. 다시 시도 해 주세요. */
				alert("<spring:message code='user.message.monitoring.chg.failed' />");
			}, true);
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
       	<div class="option-content">
        	<h3 class="sec_head mr30"><spring:message code='user.title.userinfo.monitoring.crecrs.pop' /></h3><!-- 모니터링 과목설정 -->
        	<p>[ <spring:message code="user.title.total.count" /> : <span id="crecrsCnt" class="fcBlue"></span> ]</p><!-- 총건수 -->
       	</div>
       	<div class="option-content mt10 mb10">
	    	<select class="ui dropdown" id="creYear" onchange="crecrsList(1)">
				<option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
				<c:forEach var="item" items="${yearList }">
					<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
				</c:forEach>
			</select>
			<select class="ui dropdown" id="creTerm" onchange="crecrsList(1)">
				<option value=""><spring:message code="crs.label.open.term" /></option><!-- 개설학기 -->
				<c:forEach var="list" items="${termList }">
					<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
				</c:forEach>
			</select>
	    	<div class="ui action input search-box">
			    <input type="text" placeholder="<spring:message code='user.message.search.input.crscd.tchnm.crsnm' />" class="w250" id="searchValue"><!-- 과목명/교수명/학수번호 입력 -->
			    <button class="ui icon button" onclick="crecrsList(1)"><i class="search icon"></i></button>
			</div>
			<div class="mla">
				<select class="ui dropdown list-num" id="listScale" onchange="crecrsList(1)">
					<option value="10">10</option>
					<option value="20">20</option>
					<option value="50">50</option>
					<option value="100">100</option>
				</select>
			</div>
	    </div>
	    <table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
	    	<thead>
	    		<tr>
	    			<th><spring:message code="common.number.no" /></th><!-- NO. -->
	    			<th><spring:message code="crs.label.crecrs.ctgr" /></th><!-- 과목분류 -->
	    			<th><spring:message code="user.title.userinfo.manage.userdiv" /></th><!-- 구분 -->
	    			<th><spring:message code="user.title.userinfo.dept" /></th><!-- 학과 -->
	    			<th><spring:message code="crs.label.crs.cd" /></th><!-- 학수번호 -->
	    			<th><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
	    			<th><spring:message code="crs.label.rep.professor" /></th><!-- 담당교수 -->
	    			<th><spring:message code="crs.label.rep.assistant" /></th><!-- 담당조교 -->
	    			<th><spring:message code="user.title.userinfo.manage.monitoring" /></th><!-- 모니터링 -->
	    		</tr>
	    	</thead>
	    	<tbody id="crecrsList">
	    	</tbody>
	    </table>
	    <div id="paging" class="paging"></div>
       	
	    <div class="bottom-content">
	        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="user.button.close" /></button><!-- 닫기 -->
	    </div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
