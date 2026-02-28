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
					copySeminarList(1);
				}
			});
		});
		
		// 세미나 리스트 가져오기
		function copySeminarList(page) {
			var url = "/seminar/seminarHome/seminarListPaging.do";
			if($("#listScale").val() == "0") {
				url = "/seminar/seminarHome/seminarList.do";
			}
    		var data = {
    			"pageIndex" 	: page,
    			"seminarId" 	: "${vo.seminarId}",
    			"crsCreCd"  	: $("#crsCreCd").val(),
    			"searchValue" 	: $("#searchValue").val(),
    			"creYear"		: $("#creYear").val(),
    			"creTerm"		: $("#creTerm").val(),
    			"listScale" 	: $("#listScale").val()
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = "";
            		
            		if(returnList.length > 0) {
            			returnList.forEach(function(v, i) {
            				html += "<tr>";
            				html += "	<td class='tc'>"+v.lineNo+"</td>";
            				html += "	<td class='tc'>"+v.seminarCtgrNm+"</td>";
            				html += "	<td>"+v.seminarNm+"</td>";
            				html += "	<td class='tc'><a href='javascript:window.parent.copySeminar(\""+v.seminarId+"\")' class='ui blue button roundBtntype2'><spring:message code='seminar.button.select' /></a></td>";/* 선택 */
            				html += "</tr>";
            			});
            		}
            		
            		$("#copyList").empty().html(html);
            		$(".table").footable();
            		if($("#listScale").val() != "0") {
	            		var params = {
		    		    	totalCount 	  : data.pageInfo.totalRecordCount,
		    		    	listScale 	  : data.pageInfo.pageSize,
		    		    	currentPageNo : data.pageInfo.currentPageNo,
		    		    	eventName 	  : "copySeminarList"
		    		    };
		    		    
		    		    gfn_renderPaging(params);
            		}
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 선택 학기로 과목 가져오기
    	function copyCreCrsList() {
    		var url  = "/crs/creCrsHome/listAuthCrsCreByTerm.do";
    		var data = {
    			"creYear"	 : $("#creYear").val(),
    			"creTerm"	 : $("#creTerm").val(),
    			"userId"	 : "${vo.userId}",
    			"searchMenu" : "selectYear"
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = "";
            		
            		if(returnList.length > 0) {
            			html += "<option value=''><spring:message code='seminar.label.crs.select' /></option>";/* 과목 선택 */
            			returnList.forEach(function(v, i) {
            				html += "<option value=\""+v.crsCreCd+"\">"+v.crsCreNm+" ("+v.declsNo+"<spring:message code='seminar.label.decls' />)</option>";/* 반 */
            			});
            		}
            		
            		$("#crsCreCd").empty().html(html);
            		$("#crsCreCd").dropdown("clear");
            		$("#crsCreCd").trigger("change");
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='seminar.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<p class="ui small error message">
                <i class="info circle icon"></i><spring:message code="seminar.message.select.seminar.copy.info" /><!-- 선택 시 세미나 정보가 복사 됩니다. -->
            </p>
            <div class="option-content mb10 mt20">
            	<select class="ui dropdown mr5" id="creYear" onchange="copyCreCrsList()">
            		<option value=" "><spring:message code="crs.label.open.year" /><!-- 개설년도 --></option>
            		<c:forEach var="item" items="${creYearList }">
            			<option value="${item.haksaYear }">${item.haksaYear }</option>
            		</c:forEach>
            	</select>
            	<select class="ui dropdown mr5" id="creTerm" onchange="copyCreCrsList()">
            		<option value=" "><spring:message code="crs.label.open.term" /><!-- 개설학기 --></option>
            		<c:forEach var="item" items="${termList }">
            			<option value="${item.codeCd }">${item.codeNm }</option>
            		</c:forEach>
            	</select>
                <select class="ui dropdown w250 mr5" id="crsCreCd" onchange="copySeminarList(1)">
                	<option value=""><spring:message code='seminar.label.crs.select' /></option><!-- 과목 선택 -->
                </select>
                
                <div class="ui action input search-box mr5">
                    <input type="text" placeholder="<spring:message code='seminar.label.seminar.nm' /> <spring:message code='seminar.button.input' />" id="searchValue"><!-- 세미나명 --><!-- 입력 -->
                    <button class="ui black icon button" onclick="copySeminarList(1)"><i class="search icon"></i></button>
                </div>
                
                <div class="mla">
	                <select class="ui dropdown mr5 list-num" id="listScale" onchange="copySeminarList(1)">
	                    <option value="10">10</option>
	                    <option value="20">20</option>
	                    <option value="50">50</option>
	                    <option value="100">100</option>
	                    <option value="0"><spring:message code="seminar.common.search.all" /><!-- 전체 --></option>
	                </select>
                </div>
            </div>
            <div class="ui form">
	            <table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='seminar.common.empty' />"><!-- 등록된 내용이 없습니다. -->
	            	<colgroup>
	            		<col width="7%">
	            		<col width="15%">
	            		<col width="*">
	            		<col width="10%">
	            	</colgroup>
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
							<th scope="col" class="tc"><spring:message code="seminar.label.seminar.ctgr" /><!-- 세미나 구분 --></th>
							<th scope="col" class="tc"><spring:message code="seminar.label.seminar.nm" /><!-- 세미나명 --></th>
							<th scope="col" class="tc"><spring:message code="seminar.button.select" /></th><!-- 선택 -->
						</tr>
					</thead>
					<tbody id="copyList">
					</tbody>
				</table>
				<div id="paging" class="paging"></div>
            </div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="seminar.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
