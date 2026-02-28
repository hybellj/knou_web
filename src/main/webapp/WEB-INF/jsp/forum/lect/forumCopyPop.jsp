<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<style>
		@media all and (min-width:768px) {
			.ui.selection.dropdown .menu {
			    max-height: 13rem;
			}
		}
	</style>
	<script type="text/javascript">
		var IS_PAGE_INIT = false;
		
		$(document).ready(function() {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					copyForumList(1);
				}
			});
			
			changeTerm($("#termCd").val());
		});
		
		// 토론 리스트 가져오기
		function copyForumList(page) {
			var url  = "/forum/forumLect/Form/forumCopyList.do";
			var data = {
				"pageIndex"   : page,
				"termCd" 	  : $("#termCd").val(),
				"crsCreCd" 	  : ($("#crsCreCd").val() || "").replace("ALL", ""),
				"listScale"   : $("#listScale").val(),
				"searchValue" : $("#searchValue").val(),
				"rgtrId"		  : "${repUserId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = ``;
					
					returnList.forEach(function(v, i) {
						html += `<tr>`;
						html += `	<td>\${data.pageInfo.totalRecordCount - v.lineNo + 1}</td>`;
						html += `	<td>\${v.crsCreNm}(\${v.declsNo})</td>`;
						html += `	<td>\${v.forumCtgrNm || v.forumCtgrCd}</td>`;
						html += `	<td class="tl">\${v.forumTitle}</td>`;
						html += `	<td>`;
						html += `		<a href="javascript:window.parent.copyForum('\${v.forumCd }')" class="ui blue button roundBtntype2"><spring:message code='forum.button.selection'/>​</a>`; // 선택
						html += `	</td>`;
						html += `</tr>`;
					});
		
					$("#copyList").empty().html(html);
					$(".table").footable();
					var params = {
						totalCount 	  : data.pageInfo.totalRecordCount,
						listScale 	  : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName 	  : "copyForumList"
					};
		
					gfn_renderPaging(params);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
			}, true);
		}
		
		// 학기 변경 - 강의실 세팅
		function changeTerm(termCd) {
			setEmptyList();
			
			var url = "/crs/creCrsHome/listRepUserCrsCreByTerm.do";
			var data = {
				  termCd: termCd
				, repUserId: '<c:out value="${repUserId}" />'
			};
			
			ajaxCall(url, data, function(data) {
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = '';
	        		
	        		html += '<option value="ALL"><spring:message code="forum.label.subject.select" /></option>';
	           		returnList.forEach(function(v, i) {
	           			html += '<option value="' + v.crsCreCd + '" >' + v.crsCreNm + ' (' + v.declsNo + ')</option>';
	           		});
	        		
	        		$("#crsCreCd").empty().html(html);
	           		$("#crsCreCd").dropdown("clear");
	           		
	           		if(!IS_PAGE_INIT) {
	           			$("#crsCreCd").on("change", function(e) {
							copyForumList(1);
						});
	           			
	           			IS_PAGE_INIT = true;
	           		}
	            } else {
	             	alert(data.message);
	             	setEmptyList();
	            }
	        }, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
			}, true);
		}
		
		function setEmptyList() {
			$("#atclListArea").empty().html(createEmptyHTML());
		}
		
		// 빈 내용 생성
		function createEmptyHTML() {
			var html = '';
			
			html += '<div class="flex-container">';
			html += '	<div class="cont-none">';
			html += '		<span><spring:message code="common.content.not_found" /></span>';
			html += '	</div>';
			html += '</div>';
			
			return html;
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<p class="ui small error message"><i class="info circle icon"></i><spring:message code='forum.label.select.copy'/><!-- 선택 시 토론 정보가 복사됩니다. --></p>
	
		<div class="option-content mb10 mt20">
			<!-- 학기선택 -->
			<select id="termCd" class="ui dropdown mr10 w200" onchange="changeTerm(this.value)">
	            <option value=""><spring:message code="bbs.label.select_term" /></option><!-- 학년도 학기 선택 -->
	        <c:forEach items="${termList}" var="row" varStatus="status">
	        	<option value="<c:out value="${row.termCd}" />" <c:if test="${status.index eq 0}">selected</c:if> ><c:out value="${row.termNm}" /></option>
	        </c:forEach>
	        </select>
			<select class="ui dropdown mr5 w250" id="crsCreCd">
				<option value=""><spring:message code='forum.label.subject.select'/><!-- 과목 선택--></option>
			</select>
	
			<div class="ui action input search-box mr5">
				<input type="text" placeholder="<spring:message code='forum.button.forumNm.input'/>" id="searchValue"><!-- 토론명 입력 -->
				<button class="ui icon button" onclick="copyForumList(1)"><i class="search icon"></i></button>
			</div>
	
			<div class="mla">
				<select class="ui dropdown mr5 list-num" id="listScale" onchange="copyForumList(1)">
					<option value="10">10</option>
					<option value="20">20</option>
					<option value="50">50</option>
				</select>
			</div>
		</div>
	
		<div class="ui form">
			<table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.empty'/>"><!-- 등록된 내용이 없습니다. -->
				<colgroup>
					<col width="7%">
					<col width="20%">
					<col width="20%">
					<col width="*">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col" class="num tc"><spring:message code="common.number.no" /><!-- NO. --></th>
						<th scope="col"><spring:message code='forum.label.crsCreNm.declsNo'/><!-- 과목명(분반) --></th>
						<th scope="col"><spring:message code='forum.label.forum.type'/><!-- 토론 구분 --></th>
						<th scope="col"><spring:message code='forum.label.forum.title'/><!-- 토론명 --></th>
						<th scope="col" class="tc"><spring:message code='forum.button.selection'/><!-- 선택 --></th>
					</tr>
				</thead>
				<tbody id="copyList">
				</tbody>
			</table>
			<div id="paging" class="paging"></div>
		</div>
	
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>