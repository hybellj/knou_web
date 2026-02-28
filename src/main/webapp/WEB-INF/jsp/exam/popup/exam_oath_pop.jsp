<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			listOath(1);
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listOath(1);
				}
			});
		});
		
		// 서약서 리스트 조회
		function listOath(page) {
			var url  = "/exam/oathListPaging.do";
			var data = {
				"crsCreCd"    : "${vo.crsCreCd}",
				"pageIndex"   : page,
				"listScale"   : $("#listScale").val(),
				"searchValue" : $("#searchValue").val(),
				"haksaYear"	  : "${termVO.haksaYear}",
				"haksaTerm"   : "${termVO.haksaTerm}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		html = ``;
	        		if(returnList.length > 0) {
	        			$("#totStdCnt").text(returnList[0].totStdCnt);
	        			returnList.forEach(function(v, i) {
	        				var regDttm = dateFormat("date", v.regDttm);
	        				var deptNm  = v.deptNm != null ? v.deptNm : "";
		        			html += `<tr>`;
		        			html += `	<td class="tc">\${v.lineNo}</td>`;
		        			html += `	<td>\${deptNm}</td>`;
		        			html += `	<td class="tc">\${v.userId}</td>`;
		        			html += `	<td class="tc">\${v.userNm}</td>`;
		        			html += `	<td class="tc">\${v.midOath}</td>`;
		        			html += `	<td class="tc">\${regDttm}</td>`;
		        			html += `	<td class="tc"><a href="javascript:viewOath('\${v.oathCd}', '\${v.stdNo}')" class="ui button small orange"><spring:message code="exam.label.oath" /> <spring:message code="exam.label.qstn.item" /></a></td>`;/* 서약서 *//* 보기 */
		        			html += `</tr>`;
	        			});
	        		}
	        		
	        		$("#submitStdCnt").text(returnList.length);
	        		$("#oathList").empty().html(html);
			    	$(".table").footable();
			    	var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.pageSize,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "listOath"
				    };
				    
				    gfn_renderPaging(params);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				/* 리스트 조회 중 에러가 발생하였습니다. */
				alert("<spring:message code='exam.error.list' />");
			});
		}
	
		// 서약서 보기
		function viewOath(oathCd, stdNo) {
			var form = parent.$("form[name=tempForm]");
			form.children("input[name=oathCd]").val(oathCd);
			form.children("input[name=stdNo]").val(stdNo);
			$(form).attr("target", "examPopIfm");
			$(form).attr("action", "/exam/examOathViewPop.do");
			form.submit();
		}
		
		// 서약서 다운로드
		function oathExcelDown() {
			$("form[name=excelForm]").remove();
			var excelGrid = {
				colModel:[
				   {label:"<spring:message code='main.common.number.no' />", name:'lineNo', align:'center', width:'1000'},/* NO */
				   {label:"<spring:message code='exam.label.dept' />", name:'deptNm', align:'left', width:'5000'},/* 학과 */
				   {label:"<spring:message code='exam.label.user.no' />", name:'userId', align:'left', width:'5000'},/* 학번 */
				   {label:"<spring:message code='exam.label.user.nm' />", name:'userNm', align:'right', width:'5000'},/* 이름 */
				   {label:"<spring:message code='exam.label.submit.yn' />",	name:'midOath', align:'right', width:'5000'},/* 제출여부 */
				   {label:"<spring:message code='exam.label.submit.dttm' />",  name:'regDttm', align:'right', width:'5000'},/* 제출일시 */
				]
			};
			
			var url  = "/exam/oathExcelDown.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.attr("target", "excelDownloadIfm");
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value: JSON.stringify(excelGrid)}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 	value: "${vo.crsCreCd}"}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaYear', 	value: "${termVO.haksaYear}"}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: "${termVO.haksaTerm}"}));
			form.appendTo("body");
			form.submit();
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content pb15">
        		<h3>
        			[ ${termVO.haksaYear }<spring:message code="exam.label.year" /><!-- 년 -->
        			<c:forEach var="code" items="${termList }">
        				<c:if test="${termVO.haksaTerm eq code.codeCd }">${code.codeNm }</c:if>
        			</c:forEach>
        			${vo.examStareTypeNm } ( ${vo.examTitle } ) 
        			<spring:message code="exam.label.real.time.exam" /><!-- 실시간시험 --> ]
        		</h3>
        		<div class="mla">
        			<a href="javascript:oathExcelDown()" class="ui basic button"><spring:message code="exam.button.batch.excel.down.oath" /></a><!-- 서약서 전체 다운로드 -->
        		</div>
        	</div>
        	<hr/>
        	<div class="option-content pb10">
			    <div class="ui action input search-box">
			        <input type="text" placeholder="<spring:message code="lesson.common.placeholder" />" class="w250" id="searchValue"><!-- 이름/학번/학과 입력-->
			        <button class="ui icon button" onclick="listOath(1)"><i class="search icon"></i></button>
			    </div>
			    <div class="mla">
			    	[ <span id="submitStdCnt"></span><spring:message code="exam.label.nm" /> / <span id="totStdCnt"></span><spring:message code="exam.label.nm" /> ]<!-- 명 --><!-- 명 -->
			    	<select class="ui dropdown mr5 ml10 list-num" id="listScale" onchange="listOath(1)">
	                    <option value="10">10</option>
	                    <option value="20">20</option>
	                    <option value="50">50</option>
	                    <option value="100">100</option>
	                </select>
				</div>
			</div>
			<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
				<thead>
					<tr>
						<th scope="col" class="num tc"><spring:message code="main.common.number.no" /></th><!-- NO -->
						<th scope="col" class="tc"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
						<th scope="col" class="tc"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
						<th scope="col" class="tc"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
						<th scope="col" class="tc"><spring:message code="exam.label.submit.yn" /></th><!-- 제출여부 -->
						<th scope="col" class="tc"><spring:message code="exam.label.submit.dttm" /></th><!-- 제출일시 -->
						<th scope="col" class="tc"><spring:message code="exam.label.oath" /></th><!-- 서약서 -->
					</tr>
				</thead>
				<tbody id="oathList">
				</tbody>
			</table>
			<div id="paging" class="paging"></div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
	<!-- 엑셀 다운로드 -->
	<iframe  width="100%" scrolling="no" id="excelDownloadIfm" name="excelDownloadIfm" style="display: none;"></iframe>
</html>
