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
    		$("#searchValue").on("keyup", function(e) {
    			if(e.keyCode == 13) {
    				copyReshList(1);
    			}
    		})
    	});
    	
    	// 설문 리스트 가져오기
    	function copyReshList(page) {
    		var pagingYn = $("#listScale").val() == "200" ? "N" : "Y";
    		var url  = "/resh/copyReshList.do";
    		var data = {
    			"pageIndex"   : page,
    			"creYear" 	  : $("#creYear").val(),
    			"creTerm" 	  : $("#creTerm").val(),
    			"crsCreCd" 	  : $("#crsCreCd").val(),
    			"listScale"   : $("#listScale").val(),
    			"searchValue" : $("#searchValue").val(),
    			"rgtrId"		  : "${creCrsVO.repUserId}",
    			"pagingYn"	  : pagingYn
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if(data.result > 0) {
    				var returnList = data.returnList || [];
            		var html = "";
            		
            		if(returnList.length > 0) {
            			returnList.forEach(function(v, i) {
            				html += "<tr>";
            				html += "	<td>" + v.lineNo + "</td>";
            				html += "	<td class='word_break_none'>" + v.crsCreNm + "(" + v.declsNo + ")<spring:message code='crs.label.room' />)</td>"; // 반
            				html += "	<td class='tl'>" + v.reschTitle + "</td>";
            				html += "	<td>";
            				html += `		<a href="javascript:window.parent.copyResh('\${v.reschCd }')" class="ui blue button roundBtntype2"><spring:message code="resh.button.select" />​</a>`; // 선택
            				html += "	</td>";
            				html += "</tr>";
            			});
            		}
            		
            		$("#copyReshTable").empty().html(html);
	    	    	$(".table").footable();
	    	    	if($("#listScale").val() != "200") {
	    	    		$("#paging").show();
		    	    	var params = {
			    			totalCount 	  : data.pageInfo.totalRecordCount,
			    			listScale     : data.pageInfo.pageSize,
			    			currentPageNo : data.pageInfo.currentPageNo,
			    			eventName 	  : "copyReshList"
			    		};
			    		
			    		gfn_renderPaging(params);
	    	    	} else {
	    	    		$("#paging").hide();
	    	    	}
            	} else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
    	
    	// 선택 학기로 과목 가져오기
    	function copyCreCrsList() {
    		var url  = "/crs/creCrsHome/listRepUserCrsCreByTerm.do";
    		var data = {
    			"creYear"	 : $("#creYear").val(),
    			"creTerm"	 : $("#creTerm").val(),
    			"repUserId"	 : "${creCrsVO.repUserId}",
    			"searchMenu" : "selectYear"
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var returnList = data.returnList || [];
            		var html = "";
            		
            		if(returnList.length > 0) {
            			html += "<option value=' '><spring:message code='resh.common.search.all' /></option>";/* 전체 */
            			returnList.forEach(function(v, i) {
            				html += `<option value="\${v.crsCreCd}">\${v.crsCreNm} (\${v.declsNo}<spring:message code="crs.label.room" />)</option>`;/* 반 */
            			});
            		}
            		
            		$("#crsCreCd").empty().html(html);
            		$("#crsCreCd").dropdown("clear");
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
    		});
    	}
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<p class="ui small error message">
                <i class="info circle icon"></i><spring:message code="resh.label.sel.copy.resh.info" /><!-- 선택 시 설문 정보가 복사됩니다. -->
            </p>
            
            <div class="option-content mb10 mt20">
            	<select class="ui dropdown mr5" id="creYear" onchange="copyCreCrsList()">
            		<option value=" "><spring:message code="crs.label.open.year" /><!-- 개설년도 --></option>
            		<c:forEach var="item" items="${creYearList }">
            			<option value="${item.haksaYear }">${item.haksaYear }</option>
            		</c:forEach>
            	</select>
            	<select class="ui dropdown mr5" id="creYear" onchange="copyCreCrsList()">
            		<option value=" "><spring:message code="crs.label.open.term" /><!-- 개설학기 --></option>
            		<c:forEach var="item" items="${termList }">
            			<option value="${item.codeCd }">${item.codeNm }</option>
            		</c:forEach>
            	</select>
                <select class="ui dropdown mr5 w250" id="crsCreCd" onchange="copyReshList(1)">
                	<option value=""><spring:message code="resh.common.search.all" /></option><!-- 전체 -->
                </select>
                
                <div class="ui action input search-box mr5">
                    <input type="text" placeholder="<spring:message code='resh.label.title' /> <spring:message code='resh.label.input' />" id="searchValue"><!-- 설문명 --><!-- 입력 -->
                    <button class="ui black icon button" onclick="copyReshList(1)"><i class="search icon"></i></button>
                </div>
                
                <div class="mla">
	                <select class="ui dropdown mr5 list-num" id="listScale" onchange="copyReshList(1)">
	                    <option value="10">10</option>
	                    <option value="20">20</option>
	                    <option value="50">50</option>
	                    <option value="100">100</option>
	                    <option value="200"><spring:message code="resh.common.search.all" /><!-- 전체 --></option>
	                </select>
                </div>
            </div>
            
            <div class="ui form">
	            <table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='resh.common.empty' />"><!-- 등록된 내용이 없습니다. -->
	            	<colgroup>
	            		<col width="7%">
	            		<col width="15%">
	            		<col width="50%">
	            		<col width="10%">
	            	</colgroup>
					<thead>
						<tr>
							<th scope="col" class="num tc"><spring:message code="main.common.number.no" /><!-- NO --></th>
							<th scope="col" class="tc"><spring:message code="resh.label.crs.nm.decls" /><!-- 과목명(분반) --></th>
							<th scope="col"><spring:message code="resh.label.title" /></th><!-- 설문명 -->
							<th scope="col" class="tc"><spring:message code="resh.button.select" /></th><!-- 선택 -->
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
