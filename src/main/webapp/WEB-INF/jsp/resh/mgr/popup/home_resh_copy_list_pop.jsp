<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		copyReshList(1);
    		
    		$("#searchValue").on("keyup", function(e) {
    			if(e.keyCode == 13) {
    				copyReshList(1);
    			}
    		})
    	});
    	
    	// 설문 리스트 가져오기
    	function copyReshList(page) {
    		var url  = "/resh/reshListPaging.do";
    		var data = {
    			"reschTypeCd" : "HOME",
    			"pageIndex"   : page,
    			"listScale"   : $("#listScale").val(),
    			"searchValue" : $("#searchValue").val(),
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if(data.result > 0) {
    				var returnList = data.returnList || [];
            		var html = "";
            		
            		if(returnList.length > 0) {
            			returnList.forEach(function(v, i) {
            				html += "<tr>";
            				html += "	<td class='tc'>" + v.lineNo + "</td>";
            				html += "	<td class='tl'>" + v.reschTitle + "</td>";
            				html += "	<td class='tc'>";
            				html += "		<a href='javascript:window.parent.copyResh(\"" + v.reschCd + "\")' class='ui blue button'><spring:message code='resh.button.select' />​</a>";/* 선택 */
            				html += "	</td>";
            				html += "</tr>";
            			});
            		}
            		
            		$("#copyReshTable").empty().html(html);
	    	    	$(".table").footable();
	    	    	var params = {
	    					totalCount 	  : data.pageInfo.totalRecordCount,
	    					listScale     : data.pageInfo.pageSize,
	    					currentPageNo : data.pageInfo.currentPageNo,
	    					eventName 	  : "copyReshList"
	    				};
	    				
	    				gfn_renderPaging(params);
            	} else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <p class="page-title fcRed tc"><spring:message code="resh.label.sel.copy.resh.home.info" /><!-- 선택 시 전체설문 정보가 복사됩니다. --></p>
            
            <div class="option-content mb10 mt20">
                <select class="ui dropdown mr5" id="creYear">
                	<option value=""><spring:message code="resh.label.term.year" /><!-- 학사년도 --></option>
                </select>
                <select class="ui dropdown mr5" id="creTerm">
                	<option value=""><spring:message code="resh.label.term" /><!-- 학기 --></option>
                </select>
                
                <div class="ui action input search-box mr5">
                    <input type="text" placeholder="<spring:message code='resh.label.resh.home.title' /> <spring:message code='resh.label.input' />" id="searchValue"><!-- 전체설문명 --><!-- 입력 -->
                    <button class="ui icon button" onclick="copyReshList(1)"><i class="search icon"></i></button>
                </div>
                
                <div class="mla">
	                <select class="ui dropdown mr5 list-num" id="listScale" onchange="copyReshList(1)">
	                    <option value="10">10</option>
	                    <option value="20">20</option>
	                    <option value="50">50</option>
	                    <option value="100">100</option>
	                </select>
                </div>
            </div>
            
            <div class="ui form">
	            <table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='resh.common.empty' />"><!-- 등록된 내용이 없습니다. -->
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
							<th scope="col" class="tc"><spring:message code="resh.label.resh.home.title" /><!-- 전체설문명 --></th>
							<th scope="col" class="tc w100"><spring:message code="resh.button.select" /></th><!-- 선택 -->
						</tr>
					</thead>
					<tbody id="copyReshTable">
					</tbody>
				</table>
				<div id="paging" class="paging"></div>
            </div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
