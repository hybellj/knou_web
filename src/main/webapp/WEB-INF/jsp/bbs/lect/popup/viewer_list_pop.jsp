<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
   	<!-- 게시판 공통 -->
	<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript">
   	
	   	$(document).ready(function() {
	   		list();
		});
   	
   		function list() {
   			var url = "/bbs/bbsLect/listViewer.do";
   			var data = {
   				  crsCreCd		: '<c:out value="${vo.crsCreCd}" />'
   				, atclId		: '<c:out value="${vo.atclId}" />'
   			};
   			
   			$.ajax({
   		        url : url,
   		        type : "get",
   		        data: data,
   		    }).done(function(data) {
   		    	if (data.result > 0) {
   		    		var returnList = data && data.returnList || [];
   		    		var pageInfo = data.pageInfo;
   		    		var html = '';
   		    		
   		    		returnList.forEach(function(v, i) {
   		    			var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' ' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) : v.regDttm;
   		    			
   		    			html += '<tr>';
   	   		    		html += '	<td>' + v.lineNo + '</td>';
   	   		    		html += '	<td>' + (v.deptNm || "") + '</td>';
   	   		    		html += '	<td>' + v.userId + '</td>';
   	   		    		html += '	<td class="flex flex-wrap">';
   	   		    		html += 		v.userNm;
   	   		    		if(v.studentYn == "Y") {
	   	   		    		html += '	<div class="ml5">';
	   	   		    		html += '		<a href="javascript:void(0)" onclick="userInfoPop(\''+ v.userId +'\')"><i class="ico icon-info"></i></a>';
	   	   		  			html += '	</div>';
   	   		    		}
  		    			html += '	</td>';
	   		    		html += '	<td class="tc">' + (regDttmFmt ? regDttmFmt : '-') + '</td>';
	   		    		html += '</tr>';
   		    		});
   		    		
   		    		$("#viewerList").empty().html(html);
   		    		
   		    		$("#viewerListTable").footable();
   	            } else {
   	             	alert(data.message);
   	            }
   		    }).fail(function() {
   		    	alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
   		    });
   		}
   		
   		// 엑셀다운로드
   		function downExcel() {
   			var excelGrid = {
			    colModel:[
			    	{label:'<spring:message code="common.number.no" />', name:'lineNo', align:'right', width:'1000'}, // NO
			    	{label:'<spring:message code="bbs.label.dept" />', name:'deptNm', align:'left', width:'5000'}, // 학과
			    	{label:'<spring:message code="bbs.label.stu_num" />', name:'userId', align:'center', width:'5000'}, // 학번
			    	{label:'<spring:message code="bbs.label.name" />', name:'userNm', align:'left', width:'5000'}, // 이름
			    	{label:'<spring:message code="bbs.label.view_date" />', name:'regDttm', align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}}, // 조회일시
	    		]
			};
   			
   			var url  = "/bbs/bbsLect/viewerListExcelDown.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 	value: '<c:out value="${vo.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'atclId', 		value: '<c:out value="${vo.atclId}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
   		}
   	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div class="ui segment">
	<c:choose>
		<c:when test="${bbsAtclVO.bbsCd eq 'TEAM'}">
			<span class="fcBlue">[<c:out value="${bbsAtclVO.teamCtgrNm}" />&nbsp;>&nbsp;<c:out value="${bbsAtclVO.teamNm}" />]</span>
		</c:when>
		<c:otherwise>
			<span class="fcBlue">[<c:out value="${bbsAtclVO.bbsNm}" />]</span>
		</c:otherwise>
	</c:choose>
			<c:out value="${bbsAtclVO.atclTitle}" />
		<c:if test="${bbsAtclVO.isNew eq 'Y'}">
			<i class="text-new ml0"><spring:message code="bbs.label.new_atcl" /></i><!-- 새글 -->
		</c:if>
		</div>
	
		<div class="ui segment">
			<div class="flex mb10">
				<spring:message code="bbs.label.viewr" /><!-- 조회자 -->&nbsp;<c:out value="${totalCnt}" /><spring:message code="bbs.label.people_cnt" /><!-- 명 -->
				<div class="flex-left-auto">
					<c:if test="${PROFESSOR_YN eq 'Y' and not empty bbsAtclVO.crsCreCd}">
						<a href="javascript:void(0)" onclick="downExcel()" class="ui basic button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
					</c:if>
				</div>
			</div>
			<div class="body-content">
				<table id="viewerListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.nodata.msg'/>">
					<caption>Content table</caption>
					<thead>
						<tr>
							<th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th>
							<th scope="col" data-breakpoints="xs"><spring:message code="bbs.label.dept" /><!-- 학과 --></th>
							<th scope="col"><spring:message code="bbs.label.stu_num" /><!-- 학번 --></th>
							<th scope="col"><spring:message code="bbs.label.name" /><!-- 이름 --></th>
							<%-- <th scope="col" data-breakpoints="xs"><spring:message code="bbs.label.grade" /><!-- 학년 --></th> --%>
							<th scope="col" data-breakpoints="xs"><spring:message code="bbs.label.view_date" /><!-- 조회일시 --></th>
						</tr>
					</thead>
					<tbody id="viewerList">
					</tbody>
				</table>
			</div>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>