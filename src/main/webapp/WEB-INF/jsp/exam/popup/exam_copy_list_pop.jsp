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
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					copyExamList(1);
				}
			});
		});
		
		// 시험 리스트 가져오기
    	function copyExamList(page) {
    		var url  = "/exam/examCopyList.do";
    		var data = {
    			"pageIndex"   : page,
    			"termCd" 	  : $("#termCd").val(),
    			"crsCreCd" 	  : $("#crsCreCd").val(),
    			"listScale"   : $("#listScale").val(),
    			"searchValue" : $("#searchValue").val(),
    			"examCtgrCd"  : "EXAM",
    			"rgtrId"		  : "${vo.userId}",
    			"examType"	  : "${vo.examType}"
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = ``;
            		
            		if(returnList.length > 0) {
            			returnList.forEach(function(v, i) {
            				html += `<tr>`;
            				html += `	<td>\${v.lineNo}</td>`;
            				html += `	<td>\${v.examStareTypeNm}</td>`;
            				html += `	<td class="tl">\${v.examTitle}</td>`;
            				html += `	<td>`;
            				html += `		<a href="javascript:window.parent.copyExam('\${v.examCd }')" class="ui blue button roundBtntype2"><spring:message code="exam.button.select" />​</a>`;/* 선택 */
            				html += `	</td>`;
            				html += `</tr>`;
            			});
            		}
            		
            		$("#copyList").empty().html(html);
	    	    	$(".table").footable();
	    	    	var params = {
	    					totalCount 	  : data.pageInfo.totalRecordCount,
	    					listScale 	  : data.pageInfo.pageSize,
	    					currentPageNo : data.pageInfo.currentPageNo,
	    					eventName 	  : "copyExamList"
	    				};
	    				
	    				gfn_renderPaging(params);
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
		
    	// 선택 학기로 과목 가져오기
    	function copyCreCrsList() {
    		var url  = "/crs/creCrsHome/listTchCrsCreByTerm.do";
    		var data = {
    			"termCd" : $("#termCd").val(),
    			"userId" : "${vo.userId}"
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = "";
            		
            		if(returnList.length > 0) {
            			html += "<option value=''><spring:message code='crs.label.crecrs.sel' /></option>";/* 과목 선택 */
            			returnList.forEach(function(v, i) {
            				html += `<option value="\${v.crsCreCd}">\${v.crsCreNm} (\${v.declsNo}<spring:message code="exam.label.decls" />)</option>`;/* 반 */
            			});
            		}
            		
            		$("#crsCreCd").empty().html(html);
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
        	<p class="ui small error message">
                <i class="info circle icon"></i><spring:message code="exam.label.select.copy.info" /><!-- 선택 시 정보가 복사됩니다. -->
            </p>
            
            <div class="option-content mb10 mt20">
                <select class="ui dropdown mr5 w250" id="termCd" onchange="copyCreCrsList()">
                	<option value="" hidden><spring:message code="exam.label.crs.year.term" /> <spring:message code="exam.button.select" /></option><!-- 학년도_학기 --><!-- 선택 -->
                	<c:forEach var="list" items="${termList }">
                		<option value="${list.termCd }">${list.termNm }</option>
                	</c:forEach>
                </select>
                <select class="ui dropdown mr5 w250" id="crsCreCd" onchange="copyExamList(1)">
                	<option value="" hidden><spring:message code="crs.label.crecrs.sel" /></option><!-- 과목 선택 -->
                </select>
                
                <div class="ui action input search-box mr5">
                    <input type="text" placeholder="<spring:message code="exam.alert.input.examnm.input" />" id="searchValue"><!-- 시험명 입력 -->
                    <button class="ui black icon button" onclick="copyExamList(1)"><i class="search icon"></i></button>
                </div>
                
                <div class="mla">
	                <select class="ui dropdown mr5 list-num" id="listScale" onchange="copyExamList(1)">
	                    <option value="10">10</option>
	                    <option value="20">20</option>
	                    <option value="50">50</option>
	                    <option value="100">100</option>
	                </select>
                </div>
            </div>
            
            <div class="ui form">
	            <table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
	            	<colgroup>
	            		<col width="7%">
	            		<col width="12%">
	            		<col width="*">
	            		<col width="10%">
	            	</colgroup>
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="main.common.number.no" /></th><!-- NO -->
							<th scope="col" class="tc"><spring:message code="exam.label.exam.stare.typem" /></th><!-- 시험 구분 -->
							<th scope="col"><spring:message code="exam.label.exam.nm" /></th><!-- 시험명 -->
							<th scope="col" class="tc"><spring:message code="exam.button.select" /></th><!-- 선택 -->
						</tr>
					</thead>
					<tbody id="copyList">
					</tbody>
				</table>
				<div id="paging" class="paging"></div>
            </div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
