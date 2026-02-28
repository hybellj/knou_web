<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
 
	<script type="text/javascript">
		$(document).ready(function() { 
			$("#searchValue").on("keyup",function(key){
		         if(key.keyCode == 13) {
		        	 listPaging(1);
		         }
		     });
			
			listPaging(1);
		 });
		 
		// 공개 강좌 리스트
		function listPaging(pageIndex){
			var url = "/crs/creCrsMgr/listPagingManageCourse.do";
			var data = {
				  pageIndex 	: pageIndex
				, listScale 	: $("#listScale").val()
				, creYear 		: $("#creYear").val()
				, searchValue 	: $("#searchValue").val()
				, crsOperTypeCd : "ONLINE"
				, crsTypeCd 	: "OPEN"
			};
		
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';

					returnList.forEach(function(v, i) {
						var userNm = v.userNm ? v.userNm + "(" + v.userId + ")" : "";
						var checked = v.useYn == "Y" ? "checked" : "";
						
						html += '<tr>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td>' + v.sbjctYr + '</td>';
						html += '	<td>' + v.crsId + '</td>';
						html += '	<td>' + v.sbjctnm + '</td>';
						html += '	<td>' + userNm + '</td>';
						html += '	<td>' + v.stdTotalCnt + '<spring:message code="message.person"/></td>';
						html += '	<td>';
						html += '		<div class="ui toggle checkbox" onclick="updateUseYn(\'' + v.crsCreCd + '\', \'' + v.useYn + '\');">';
						html += '			<input type="checkbox" id="useYn_' + v.crsCreCd + '" ' + checked + ' />';
						html += '		</div>';
						html += '	</td>';
						html += '	<td>';
						html += '		<a href="javascript:moveCreTch(\'' + v.crsCreCd + '\', \'' + v.crsCd + '\');" class="ui basic small button"><spring:message code="crs.title.manager"/></a>'; // 운영자
						html += '		<a href="javascript:moveCreStd(\'' + v.crsCreCd + '\');" class="ui basic small button"><spring:message code="common.label.students"/></a>'; // 수강생
						html += '		<a href="javascript:modeDetail(\'' + v.crsCreCd + '\', \'' + v.crsCd + '\');" class="ui basic small button"><spring:message code="button.view.detail"/></a>'; // 상세보기
						html += '		<a href="javascript:moveEditForm(\'' + v.crsCreCd + '\', \'' + v.crsCd + '\');" class="ui basic small button"><spring:message code="button.edit"/></a>'; // 수정
						html += '		<a href="javascript:deleteCrsCre(\'' + v.crsCreCd + '\', \'' + v.crsCreNm + '\');" class="ui basic small button"><spring:message code="button.delete"/></a>';// 삭제
						html += '	</td>';
						html += '</tr>';
					});
					
					$("#crsList").html(html);
					$("#crsTable").footable();
					$("#crsTable").find(".ui.checkbox").checkbox();
					
					var params = {
						totalCount : data.pageInfo.totalRecordCount,
						listScale : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName : "listPaging"
					};

					gfn_renderPaging(params);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
		
		// 엑셀 다운로드
		function listExcel() {
			var excelGrid = {
				colModel:[
					{label:'<spring:message code="common.number.no"/>',   			name:'lineNo', 		align:'center', width:'1000'}, 	// No
					{label:'<spring:message code="crs.label.open.year"/>',   		name:'creYear', 	align:'center', width:'3000'}, 	// 개설년도
					{label:'<spring:message code="crs.label.crs.cd"/>',				name:'crsCd', 		align:'center',	width:'5000'}, 	// 학수번호
					{label:'<spring:message code="common.label.crsauth.crsnm"/>',   name:'crsCreNm', 	align:'left',	width:'5000'}, 	// 개설 과목명 
					{label:'<spring:message code="common.charge.professor"/>', 		name:'userNm', 		align:'left',	width:'5000'}, // 담당교수
					{label:'<spring:message code="common.charge.professor"/>', 		name:'userId', 		align:'center',	width:'5000'}, // 담당교수
					{label:'<spring:message code="common.label.use.type.yn"/>',		name:'useYn', 		align:'center',	width:'3000', codes:{Y :'<spring:message code="common.use"/>',N:'<spring:message code="button.useyn_n"/>'}}, // 사용 여부
					{label:'<spring:message code="common.label.reg.dttm"/>', 		name:'modDttm', 	align:'center',	width:'5000', formatter:'date', formatOptions:{srcformat:"yyyyMMddHHmmss", newformat:"yyyy.MM.dd(HH:mm)"}}, // 등록일시
				]
			};
			
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/crs/creCrsMgr/manageCourseExcelDown.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'creYear', value: $("#creYear").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', value: "OPEN"}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val() }));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// 공개강좌 등록 이동
		function moveAddForm() {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsOpenWriteForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 강의실 입장
		function moveCre(crsCreCd, tchTotalCnt) {
			if(tchTotalCnt > 0) {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "moveForm");
				form.attr("action", "/crs/crsHomeProf.do");
				form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
				form.append($('<input/>', {type: 'hidden', name: "type", value: "ADM"}));
				form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "LEGAL"}));
				form.appendTo("body");
				form.submit();
			} else {
				alert("<spring:message code='crs.setting.professor.then.enter'/>"); // 담당교수 설정 후 입장 가능합니다.
				return;
			}
		}
		
		// 사용여부 변경
		function updateUseYn(crsCreCd, useYn) {
			var url = "/crs/creCrsMgr/editUseYn.do";
			var data = {
				  crsCreCd: crsCreCd
				, useYn: useYn == "Y" ? "N" : "Y"
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					listPaging(1);
				}else{
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
		
		// 운영자 이동
		function moveCreTch(crsCreCd, crsCd) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/crsTchForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsCd", value: crsCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 수강생 이동
		function moveCreStd(crsCreCd) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/crsStdForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 상세보기 이동
		function modeDetail(crsCreCd, crsCd) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsOpenViewForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsCd", value: crsCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 수정 이동
		function moveEditForm(crsCreCd, crsCd) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsOpenWriteForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsCd", value: crsCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 삭제 버튼
		function deleteCrsCre(crsCreCd, crsCreNm) {
			// 삭제하시겠습니까?
			if(!confirm(crsCreNm + ' <spring:message code="common.delete.msg"/>')) return;
			
			var url = "/crs/creCrsMgr/crsCreCoDelete.do";
			var data = {
				crsCreCd: crsCreCd
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='crs.pop.open.course.delete.success'/>"); // 개설 과목 삭제 성공하였습니다.
					listPaging(1);
				}else{
					alert("<spring:message code='crs.pop.open.course.delete.fail'/>"); // 개설 과목 삭제 실패하였습니다.
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
	</script>
</head>
<body>
	<div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<div id="container">
			<!-- 본문 content 부분 -->
	        <div class="content">
	        	<div id="info-item-box">
					<h2 class="page-title flex-item">
					    <spring:message code="crs.clasOp.atndc.crtr"/><!-- 학기/과목 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="crs.open.course.manage"/><!-- 공개강좌 개설 관리 --></small>
					    </div>
					</h2>
				    <div class="button-area">
				        <a href="javascript:listExcel()" class="btn"><spring:message code="button.download.excel"/></a><!-- 엑셀다운로드 -->
				        <a href="javascript:moveAddForm();" class="btn btn-primary" ><spring:message code="common.label.open.crs" /> <spring:message code="button.write"/></a><!-- 공개강좌등록 -->
				    </div>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
				    <div class="option-content">
				       	<select name="creYear" id="creYear" onchange="listPaging(1)" class="ui compact dropdown mr5">
							<c:forEach items="${yearList}" var="year">
								<c:if test="${year == curYear}">
									<option value="${year}" selected="selected">${year}</option>
								</c:if>
								<c:if test="${year != curYear}">
									<option value="${year}">${year}</option>
								</c:if>
							</c:forEach>
						</select> 
				        <div class="ui action input search-box">
				            <input type="text" id="searchValue" placeholder="<spring:message code="common.label.crsauth.crsnm"/>/<spring:message code="contents.label.crscd" />/<spring:message code='exam.label.tch.nm' />" autocomplete="off">
				            <a class="ui icon button" onclick="listPaging(1)"><i class="search icon"></i></a>
				        </div>
				        <div class="button-area">
				            <select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
				                <option value="10">10</option>
				                <option value="20">20</option>
				                <option value="50">50</option>
				                <option value="100">100</option>
				            </select>
				        </div>
				    </div>
				    <table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.nodata.msg'/>" id="crsTable"><!-- 등록된 내용이 없습니다. -->
				    	<thead>
							<tr>
								<th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><!-- NO. -->
								<th scope="col" data-sortable="false"><spring:message code="crs.label.open.year" /></th><!-- 개설 년도-->
								<th scope="col"><spring:message code="contents.label.crscd" /></th><!-- 학수번호 -->
								<th scope="col"><spring:message code="common.label.crsauth.crsnm"/></th><!-- 개설 과목명 -->
								<th scope="col"><spring:message code="common.charge.professor"/></th><!-- 담당교수 -->
								<th scope="col" data-sortable="false"><spring:message code="common.label.students"/></th><!-- 수강생 -->
								<th scope="col" data-sortable="false"><spring:message code="common.label.use.type.yn"/></th><!-- 사용 여부 -->
								<th scope="col" data-sortable="false"><spring:message code="common.mgr"/></th><!-- 관리 -->			
							</tr>
						</thead>
						<tbody id="crsList">
						</tbody>
				    </table>
				    <div id="paging" class="paging mt10"></div>
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<!-- footer 영역 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>