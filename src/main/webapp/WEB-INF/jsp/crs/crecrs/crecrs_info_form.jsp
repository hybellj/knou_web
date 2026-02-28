<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
 <!DOCTYPE html>
 <html lang="ko">
 <head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
 
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST   = [];
	
		$(document).ready(function(){
			// 부서정보
			<c:forEach var="item" items="${deptList}">
				USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptCd}" />'
					, deptNm: '<c:out value="${item.deptNm}" />'
					, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
				});
			</c:forEach>
			
			$("#searchValue").on("keyup",function(key){
				if(key.keyCode==13) {
					listPaging(1); 
				}
			});
			
			// 부서명 정렬
			USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			listPaging(1);
			changeTerm();
		});
		
		// 학기 변경
		function changeTerm() {
			// 학기 과목정보 조회
			var url = "/crs/creCrsHome/listCrsCreDropdown.do";
			var data = {
				  creYear	: $("#creYear").val()
				, creTerm	: $("#creTerm").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					this["CRS_CRE_LIST"] = returnList.sort(function(a, b) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;
						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
						return 0;
					});
					
					// 대학 구분 변경
					changeUnivGbn("ALL");
					
					$("#univGbn").on("change", function() {
						changeUnivGbn(this.value);
					});
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 대학구분 변경
		function changeUnivGbn(univGbn) {
			var deptCdObj = {};
			
			this["CRS_CRE_LIST"].forEach(function(v, i) {
				if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
					deptCdObj[v.deptCd] = true;
				}
			});
			
			var html = '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
			USER_DEPT_LIST.forEach(function(v, i) {
				if(deptCdObj[v.deptCd]) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				}
			});
			
			// 부서 초기화
			$("#deptCd").html(html);
			$("#deptCd").dropdown("clear");
			$("#deptCd").on("change", function() {
				changeDeptCd(this.value);
			});
			
			// 학과 초기화
			$("#crsCreCd").empty();
			$("#crsCreCd").dropdown("clear");
			
			// 부서변경
			changeDeptCd("ALL");
		}
		
		// 학과 변경
		function changeDeptCd(deptCd) {
			var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
		}
		
		function listPaging(pageIndex) {
			var url = "/crs/creCrsMgr/listPagingManageCourse.do";
			var data = {
				  pageIndex 	: pageIndex
				, listScale 	: $("#listScale").val()
				, creYear 		: $("#creYear").val()
				, creTerm 		: $("#creTerm").val()
				, univGbn 		: ($("#univGbn").val() || "").replace("ALL", "")
				, deptCd 		: ($("#deptCd").val() || "").replace("ALL", "")
				, crsCreCd 		: ($("#crsCreCd").val() || "").replace("ALL", "")
				, searchValue 	: $("#searchValue").val()
				, crsTypeCd 	: "UNI"
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';

					returnList.forEach(function(v, i) {
						var userNm = v.userNm ? v.userNm + "(" + v.userId + ")" : "";
						var checked = v.useYn == "Y" ? "checked" : "";
						
						html += '<tr>';
						html += '	<td>' + (data.pageInfo.totalRecordCount - v.lineNo + 1) + '</td>';
						html += '	<td>' + v.crsCd + '</td>';
						html += '	<td><a href="javascript:moveCreWin(\'' + v.crsCreCd + '\', \'' + v.tchTotalCnt + '\');" class="link">' + v.crsCreNm + '</a></td>';
						html += '	<td>' + v.declsNo + '</td>';
						html += '	<td>' + v.deptNm + '</td>';
						html += '	<td>' + userNm + '</td>';
						html += '	<td>' + v.stdTotalCnt + '<spring:message code="message.person"/></td>';
						html += '	<td>';
						html += '		<div class="ui toggle checkbox" onclick="updateUseYn(\'' + v.crsCreCd + '\', \'' + v.useYn + '\');">';
						html += '			<input type="checkbox" id="useYn_' + v.crsCreCd + '" ' + checked + ' />';
						html += '		</div>';
						html += '	</td>';
						html += '	<td>';
						html += '		<a href="javascript:moveCreTch(\'' + v.crsCreCd + '\');" class="ui basic small button"><spring:message code="crs.title.manager"/></a>'; // 운영자
						html += '		<a href="javascript:moveCreStd(\'' + v.crsCreCd + '\');" class="ui basic small button"><spring:message code="common.label.students"/></a>'; // 수강생
						html += '		<a href="javascript:modeDetail(\'' + v.crsCreCd + '\');" class="ui basic small button"><spring:message code="button.view.detail"/></a>'; // 상세보기
						html += '		<a href="javascript:moveEditForm(\'' + v.crsCreCd + '\');" class="ui basic small button"><spring:message code="button.edit"/></a>'; // 수정
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
			}, true);
		}
		
		function listExcel() {
			var excelGrid = {
				colModel:[
					{label:"<spring:message code='common.number.no'/>",   name:'lineNo', align:'center', width:'1000'}, // NO
					{label:"<spring:message code="contents.label.crscd" />",   name:'crsCd', align:'left',   width:'8000'}, // 학수번호
					{label:"<spring:message code='common.label.crsauth.crsnm'/>",   name:'crsCreNm', align:'left',   width:'8000'}, // 과목명
					{label:"<spring:message code='common.label.decls.no'/>", name:'declsNo', align:'center',  width:'2000'}, // 분반
					{label:"<spring:message code='crs.common.deptnm'/>", name:'deptNm', align:'left',  width:'5000'}, // 개설학과
					// {label:"<spring:message code='common.label.credit'/>", name:'credit', align:'center',  width:'2000',  formatter:'number', formatOptions:{pattern:'#,###', defaultValue: '0'}}, // 학점
					// 이수구분, 교양필수, 교양선택, 계열기초, 전공필수, 전공선택
					// {label:"<spring:message code='common.label.crsauth.comtype'/>", name:'compDvCd', align:'center',  width:'5000', codes:{1:"<spring:message code='common.label.refine.essential'/>",2:"<spring:message code='common.label.refine.choice'/>",3:"<spring:message code='common.label.major.essential'/>",4:"<spring:message code='common.label.major.choice'/>"}},
					// 교육형태, 온라인, 오프라인, 혼합
					// {label:"<spring:message code='common.label.edu.form'/>", name:'crsOperTypeCd', align:'center',  width:'5000', codes:{ONLINE:"<spring:message code='common.label.online'/>",OFFLINE:"<spring:message code='common.label.offline'/>",MIX:"<spring:message code='common.label.blend'/>"}}, 
					/* {label:"<spring:message code='crs.evaluation.method.pass.fail'/>", name:'scoreEvalType', align:'center',  width:'5000', codes:{PF:'Pass/Fail'}}, // 평가방법(P/F 여부) */
					{label:"<spring:message code='common.charge.professor'/>", name:'userNm', align:'left',  width:'5000'}, // 담당교수
					{label:"<spring:message code='crs.learner.person'/>", name:'stdTotalCnt', align:'right',  width:'5000'}, // 수강생(명)
					{label:'<spring:message code="common.use.yn"/>', name:'useYn', align:'center',  width:'4000', codes:{Y :'<spring:message code="common.use"/>',N:'<spring:message code="button.useyn_n"/>'}}, <%-- 사용 여부 --%>
				]
			};
		
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/crs/creCrsMgr/manageCourseExcelDown.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'termCd', value: $("#termCd").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val() }));
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', value: "UNI"}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// 학기제 과목등록 이동
		function moveAddForm(){
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/addForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: ""}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "UNI"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 과목지원 호출
		function moveCreWin(crsCreCd) {
			var creSupportWin = window.open("", "creSupportWin");
			$("#creMoveForm").attr("action","/crs/crsHomeProf.do");
			$("#creMoveForm > input[name='crsCreCd']").val(crsCreCd);
			$('#creMoveForm').submit();
			$("#virtualSupport").show();
			
			var closeTimer = setInterval(function() {
				if (creSupportWin.closed) {
					$.ajax({
						url : "/dashboard/closeVirtualSession.do",
						type: "POST",
						success : function(data, status, xr){
							$("#virtualSupport").hide();
						},
						error : function(xhr, status, error){
							$("#virtualSupport").hide();
						},
						timeout:3000	
					});
					clearInterval(closeTimer);
				}
			}, 1000);
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
		function moveCreTch(crsCreCd) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/crsTchForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "UNI"}));
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
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "UNI"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 상세보기 이동
		function modeDetail(crsCreCd){
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsInfoDetail.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "termCdVal", value: $("#termCd").val()}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "UNI"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 수정 이동
		function moveEditForm(crsCreCd){
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/addForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "gubun", value: "E"}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "UNI"}));
			form.appendTo("body");
			form.submit();
		}
		
		// 삭제
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
				<div class="ui form">
					<div id="info-item-box">
						<h2 class="page-title flex-item">
						    <spring:message code="common.term.subject"/><!-- 학기/과목 -->
						    <div class="ui breadcrumb small">
						        <small class="section"><spring:message code="crs.title.subject.setup.management"/><!-- 학기제 과목 개설 관리 --></small>
						    </div>
						</h2>
					    <div class="button-area">
					        <a href="javascript:listExcel()" class="btn"><spring:message code="button.download.excel"/></a><!-- 엑셀다운로드 -->
					        <a href="javascript:moveAddForm();" class="btn btn-primary" ><spring:message code="common.button.uni" /> <spring:message code="common.subject"/><spring:message code="button.write"/></a><!-- 학기제 과목등록 -->
					    </div>
					</div>
					<div class="ui divider mt0"></div>
					<div class="ui form" id="list">
						<div class="option-content">
							<select class="ui dropdown mr5" id="creYear" onchange="changeTerm()">
								<c:forEach var="item" items="${yearList}" varStatus="status">
									<option value="${item}" <c:if test="${item eq termVO.haksaYear}">selected</c:if>>${item}</option>
								</c:forEach>
							</select>
							<select class="ui dropdown mr5" id="creTerm" onchange="changeTerm()">
								<c:forEach var="item" items="${termList }">
									<option value="${item.codeCd }" <c:if test="${item.codeCd eq termVO.haksaTerm}">selected</c:if>>${item.codeNm }</option>
								</c:forEach>
							</select>
							<c:if test="${orgId eq 'ORG0000001'}">
								<select id="univGbn" class="ui dropdown mr5" onchange="changeUnivGbn()">
				                   	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
				                   	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
				                   	<c:forEach var="item" items="${univGbnList}">
										<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
									</c:forEach>
				                </select>
			                </c:if>
			                <select id="deptCd" class="ui dropdown w250" onchange="changeDeptCd()">
	                        	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
	                        </select> 
	                        <select id="crsCreCd" class="ui dropdown mr5 w250" onchange="listPaging(1)">
			                	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
			                </select>
							<div class="ui input search-box">
								<input type="text" placeholder="<spring:message code="contents.label.crscrenm" />/<spring:message code="contents.label.crscd" />/<spring:message code='exam.label.tch.nm' />" name="searchValue" id="searchValue" autocomplete="off"> <!-- 검색 -->
							</div>
							<div class="button-area">
								<button class="ui green button" onclick="listPaging(1)"><spring:message code="common.button.search" /><!-- 검색 --></button>
								<select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50">50</option>
									<option value="100">100</option>
									<option value="300">300</option>
									<option value="500">500</option>
									<option value="1000">1000</option>
								</select>
							</div>
						</div>
						<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.nodata.msg'/>" id="crsTable"><!-- 등록된 내용이 없습니다. -->
					    	<thead>
								<tr>
									<th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><!-- NO. -->
									<th scope="col"><spring:message code="contents.label.crscd" /></th><!-- 학수번호 -->
									<th scope="col"><spring:message code="common.label.crsauth.crsnm"/></th><!-- 개설 과목명 -->
									<th scope="col"><spring:message code="common.label.decls.no"/></th> <!-- 분반 -->
									<th scope="col" data-breakpoints="xs"><spring:message code="crs.common.deptnm"/></th> <!-- 개설학과 -->
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
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<!-- footer 영역 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
	
	<form id="creMoveForm" name="creMoveForm" method="post" target="creSupportWin">
		<input type="hidden" name="crsCreCd" value=""/>
		<input type="hidden" name="type" value="ADM"/>	
	</form>
</body>
</html>