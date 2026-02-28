<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    <script type="text/javascript">
	    $(document).ready(function() {
	    	searchLog();
	    	
	    	$("#searchValue").on("keyup", function(e) {
	    		if(e.keyCode == 13) {
	    			searchLog();
	    		}
	    	});
	    });
	    
	    // 성적변경이력 검색
	    function searchLog() {
	    	var url = "/score/scoreOverall/selectScoreHistList.do";
			var param = {
				  crsCreCd: '<c:out value="${creCrsVO.crsCreCd}" />'
				, searchValue: $("#searchValue").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					$.each(returnList, function(i, o){
						html += '<tr>';
						html += '    <td class="tc">' + o.lineNo + '</td>';
						html += '    <td class="tc">' + getDateFmt(o.regDttm) + '</td>';
						html += '    <td class="">' + o.chgCts + '</td>';
						html += '    <td class="">' + o.userNm + '(' + o.userId + ')</td>';
						html += '    <td class="">' + o.regNm + '(' + o.rgtrId + ')</td>';
						html += '</tr>';
					});
		
					$("#logList").empty().html(html);
					$("#logTable").footable();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
	    }
	    
	    // 엑셀 다운로드
	    function excelDown() {
	    	var maxLsnOdr;
			var excelGrid = {
			    colModel:[
		            {label:'<spring:message code="common.number.no" />'			, name:'lineNo', 	align:'right'	, width:'1000'}, // NO
		            {label:'<spring:message code="exam.label.process.dttm" />'	, name:'regDttm', 	align:'center'	, width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm'}}, // 처리일시
		            {label:'<spring:message code="score.label.log.cts" />'		, name:'chgCts', 	align:'left'	, width:'20000'}, // 토그내용
		            {label:'<spring:message code="common.object" />'			, name:'userNm', 	align:'left'	, width:'5000'}, // 대상
		            {label:'<spring:message code="common.object" /><spring:message code="common.no" />'			, name:'userId', 	align:'left'	, width:'5000'}, // 대상번호
		            {label:'<spring:message code="exam.label.process.manage" />', name:'regNm', 	align:'left'	, width:'5000'}, // 처리담당자
		            {label:'<spring:message code="exam.label.process.manage" /><spring:message code="common.no" />', name:'rgtrId', 	align:'left'	, width:'5000'}, // 처리담당자번호
	            ]
			};
			
			var url  = "/score/scoreOverall/downExcelScoreHistList.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',	value: '<c:out value="${creCrsVO.crsCreCd}" />'}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
	    }
	    
	 	// 닫기
	    function closePop() {
	    	var dataMap = {
	    		type : "close"
		    };
		    window.parent.postMessage(dataMap, "*");
	    }
	 	
	  	//날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
	    function getDateFmt(dateStr) {
	    	var fmtStr = (dateStr || "");
	    	
	    	if(fmtStr.length == 14) {
	    		fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12);
	    	} else if(fmtStr.length == 8) {
	    		fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
	    	}
	    	
	    	return fmtStr;
	    }
    </script>
</head>
<body class="modal-page">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
       	<div class="option-content mb20">
       		<div class="ui input">
        		<input type="text" class="fcBlue w150" value="${creCrsVO.crsCd }" disabled="disabled" />
        		<input type="text" class="fcBlue w250 ml10" value="${creCrsVO.deptNm }" disabled="disabled" />
        		<input type="text" class="ml10 w400" id="searchValue" placeholder="<spring:message code="common.label.student.number" />/<spring:message code="common.name" />" />
       		</div>
       		<div class="mla">
       			<button type="button" class="ui green button" onclick="searchLog()"><spring:message code="common.button.search" /><!-- 검색 --></button>
       		</div>
       	</div>
       	<div class="ui divider mt0"></div>
       	<div class="option-content">
       		<h3 class="sec_head"><spring:message code="score.label.score.change.log" /><!-- 성적변경이력 --></h3>
       		<div class="mla">
       			<button type="button" class="ui green button" onclick="excelDown()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
       		</div>
       	</div>
       	<div class="footable_box type2 max-height-350">
	       	<table id="logTable" class="table mt5" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
	       		<colgroup>
	       			<col width="3%">
	       			<col width="15%">
	       			<col width="*">
	       			<col width="15%">
	       			<col width="15%">
	       		</colgroup>
	       		<thead class="sticky top0">
	       			<tr>
	       				<th><spring:message code="common.number.no" /><!-- NO --></th>
	       				<th><spring:message code="exam.label.process.dttm" /><!-- 처리일시 --></th>
	       				<th><spring:message code="score.label.log.cts" /><!-- 로그내용 --></th>
	       				<th><spring:message code="common.object" /><!-- 대상 --></th>
	       				<th><spring:message code="exam.label.process.manage" /><!-- 처리담당자 --></th>
	       			</tr>
	       		</thead>
	       		<tbody id="logList"></tbody>
			</table>
		</div>
		<div class="bottom-content">
			<button type="button" class="ui basic button" onclick="closePop()"><spring:message code="team.common.close"/></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>