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
			listTch(1);
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listTch(1);
				}
			});
		});
		
		// 교수 리스트
		function listTch(page) {
			var url  = "/crs/creCrsHome/creCrsTchListByMenuType.do";
			var data = {
				"crsCreCd"    : "${vo.crsCreCd}",
				"pageIndex"   : page,
				"listScale"   : $("#listScale").val(),
				"searchValue" : $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var userType = v.menuType == "PROFESSOR" ? "<spring:message code='user.title.tch.professor' />" : "<spring:message code='user.title.tch.tutor' />";/* 교수 *//* 조교 */
	        				html += "<tr>";
	        				html += "	<td class='tc'>"+v.lineNo+"</td>";
	        				html += "	<td>"+v.deptNm+"</td>";
	        				html += "	<td class='tc'>"+v.userId+"</td>";
	        				html += "	<td class='tc'>"+v.userNm+"</td>";
	        				html += "	<td class='tc'>"+userType+"</td>";
	        				html += "	<td class='tc'>";
	        				if(v.menuType != "STUDENT") {
	        				html += "		<a href='javascript:addTch(\""+"ASSOCIATE"+"\", \""+v.userId+"\")' class='ui blue small button'><spring:message code='user.title.crs.insert.professor' /></a>";/* 교수추가 */
	        				}
	        				html += "		<a href='javascript:addTch(\""+"ASSISTANT"+"\", \""+v.userId+"\")' class='ui blue small button'><spring:message code='user.title.crs.insert.assistant' /></a>";/* 조교추가 */
	        				html += "	</td>";
	        				html += "</tr>";
	        			});
	        		}
	        		
	        		$("#tchlist").empty().html(html);
			    	$(".table").footable();
			    	var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.recordCountPerPage,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "listTch"
				    };
				    
				    gfn_renderPaging(params);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 조교/교수 추가
		function addTch(tchType, userId) {
			var url  = "/crs/creCrsHome/insertCrecrsTch.do";
			var data = {
				"crsCreCd"  : "${vo.crsCreCd}",
				"userId"	: userId,
				"tchType"	: tchType
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					listTch(1);
					var type = tchType == "ASSISTANT" ? tchType : "PROFESSOR";
					window.parent.crecrsTchList(type);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<h3 class="sec_head"><spring:message code="user.title.tch.insert" /></h3><!-- 교수/조교 추가 -->
        	<div class="option-content mt30 mb10">
        		<div class="ui action input search-box">
				    <input type="text" placeholder="<spring:message code='user.message.search.input.userinfo.user.no.nm' />" class="w250" id="searchValue"><!-- 학번/사번, 이름 입력 -->
				    <button class="ui icon button" onclick="listTch(1)"><i class="search icon"></i></button>
				</div>
				<div class="mla">
				    <select class="ui dropdown list-num" id="listScale" onchange="listTch(1)">
				        <option value="10">10</option>
				        <option value="20">20</option>
				        <option value="50">50</option>
				        <option value="100">100</option>
				    </select>
				</div>
        	</div>
        	<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th class='tc'><spring:message code="main.common.number.no" /></th><!-- NO. -->
        				<th class='tc'><spring:message code="user.title.userinfo.dept" /></th><!-- 학과 -->
        				<th class='tc'><spring:message code="user.title.userinfo.manage.userid" /></th><!-- 학번 -->
        				<th class='tc'><spring:message code="user.title.userinfo.manage.usernm" /></th><!-- 이름 -->
        				<th class='tc'><spring:message code="user.title.userinfo.manage.userdiv" /></th><!-- 구분 -->
        				<th class='tc'><spring:message code="user.button.add" /></th><!-- 추가 -->
        			</tr>
        		</thead>
        		<tbody id="tchlist">
        		</tbody>
        	</table>
        	<div id="paging" class="paging"></div>
	        
            <div class="bottom-content mt70">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
