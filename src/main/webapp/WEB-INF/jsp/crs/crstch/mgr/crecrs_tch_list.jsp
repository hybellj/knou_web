<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST = [];
	
		$(document).ready(function () {
			// 부서정보
			<c:forEach var="item" items="${deptList}">
			USER_DEPT_LIST.push({
				  deptCd: '<c:out value="${item.deptCd}" />'
				, deptNm: '<c:out value="${item.deptNm}" />'
				, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
			});
			</c:forEach>
			
			USER_DEPT_LIST = USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			$("#searchValue").on("keyup", function(e){
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});
			
			changeTerm();
			listPaging(1);
		});
		
		// 교수/조교 리스트
		function listPaging(pageIndex) {
			selectCreCrsTable.clearData();
			
			var crsTypeCdList = [];
			var url  = "/crs/creCrsMgr/listTchStatus.do";
			var data = {
				  creYear		: $("#creYear").val()
				, creTerm		: $("#creTerm").val()
				, crsTypeCds	: crsTypeCdList.join(",")
				, univGbn		: ($("#univGbn").val() || "").replace("ALL", "")
				, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
				, crsCreCd		: ($("#crsCreCd").val() || "").replace("ALL", "")
				, searchValue	: $("#searchValue").val()
				, pageIndex		: pageIndex
				, listScale		: $("#listScale").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var dataList = [];
					
					returnList.forEach(function(v, i) {
						dataList.push({						
							lineNo: v.lineNo, 
							crsCd: v.crsCd,
							crsCreNm: v.crsCreNm +' (' + v.declsNo + '<spring:message code="crs.label.room" />)',
							mngDept: (v.deptNm || '-'),
							professorNm: (v.professorNm || '-'),
							professorNo: (v.professorNo || '-'),
							associateNm: (v.associateNm || '-'),
							tutorNm: (v.tutorNm || '-'),
							tutorNo: (v.tutorNo || '-'),
							manage:"<a class='ui basic mini button' href=\"javascript:editTchForm(\'" + v.crsCreCd + "\')\"><spring:message code='user.button.mod'/></a>",
						});
					});
					
					selectCreCrsTable.addData(dataList);
					selectCreCrsTable.redraw();
					
					var params = {
						totalCount 	  : data.pageInfo.totalRecordCount,
						listScale 	  : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName 	  : "listPaging"
					};
					
					gfn_renderPaging(params);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			}, true);
		}
	
		// 선택 과목 엑셀다운로드
		function selectCreCrsExcelDown() {
			$("form[name=excelForm]").remove();
			
			var excelGrid = {
				colModel:[
					  {label:"<spring:message code='common.number.no'/>", 			name:'lineNo', 		align:'center', width:'3000'}
					, {label:"<spring:message code='crs.label.crs.cd' />", 			name:'crsCd', 		align:'center',	width:'2500'} // 학수번호
					, {label:"<spring:message code='crs.label.crecrs.nm' />", 		name:'crsCreNm', 	align:'left',	width:'10000'} // 과목명
					, {label:"<spring:message code='crs.label.decls' />",			name:'declsNo', 	align:'center',	width:'2500'} // 분반
					, {label:"<spring:message code='common.label.mng.dept' />",		name:'deptNm',		align:'left',	width:'7000'} // 관장학과
					, {label:"<spring:message code='common.teaching.professor'/>", 	name:'professorNm',	align:'left',	width:'5000'} // 대표교수
					, {label:"<spring:message code='common.label.prof.no'/>", 		name:'professorNo',	align:'center',	width:'5000'} // 교수사번
					, {label:"<spring:message code='user.title.tch.associate' />",	name:'associateNm',	align:'left',	width:'5000'} // 공동교수
					, {label:"<spring:message code='common.label.prof.no' />",		name:'associateNo',	align:'center',	width:'5000'} // 교수사번
					, {label:"<spring:message code='crs.label.rep.assistant' />", 	name:'tutorNm',	 	align:'left',	width:'5000'} // 담당조교
					, {label:"<spring:message code='crs.label.rep.assistant.no' />",name:'tutorNo',	 	align:'center',	width:'5000'} // 조교사번
				]
			};
			
			var crsTypeCdList = [];
			
			$.each($("[data-crs-type-cd]"), function() {
				if($(this).hasClass("active")) {
					crsTypeCdList.push($(this).data("crsTypeCd"));
				}
			});
	
			var excelForm = $('<form name="excelForm" method="post"></form>');
			excelForm.attr("action", "/crs/creCrsMgr/tchStatuExcelDown.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'creYear', 		value: $("#creYear").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'creTerm', 		value: $("#creTerm").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCds', 	value: crsTypeCdList.join(",")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: ($("#univGbn").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: ($("#deptCd").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 		value: ($("#crsCreCd").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value: JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();
		}
		
		// 교수/조교 정보 수정 페이지
		function editTchForm(crsCreCd) {
			var url  = "/crs/creCrsMgr/Form/editCreCrsTch.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "editForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: crsCreCd}));
			form.appendTo("body");
			form.submit();
		}
		
		// 강의실 타입 변경
		function changeCrsTypeCd(el) {
			$(el).toggleClass("active");
			
			if($(el).hasClass("active")) {
				$(el).removeClass("basic");
			} else {
				$(el).removeClass("basic").addClass("basic");
			}
		}
		
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
	</script>
</head>
<body>
	<div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		<!-- //header -->
		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->
		<div id="container">
			<!-- 본문 content 부분 -->
			<div class="content">
				<!-- 타이틀 -->
				<div id="info-item-box">
					<h2 class="page-title flex-item">
						<spring:message code="user.title.tch.info" /><!-- 교수/조교 정보 --> 
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<div class="ui segment searchArea">
						<%
						if (SessionInfo.isKnou(request)) {
							%>
							<div class="ui buttons mb10">
								<button type="button" class="ui blue button active" data-crs-type-cd="UNI" onclick="changeCrsTypeCd(this)"><spring:message code="common.button.uni" /><!-- 학기제 --></button>
								<button type="button" class="ui basic blue button" data-crs-type-cd="LEGAL" onclick="changeCrsTypeCd(this)"><spring:message code="common.button.legal" /><!-- 법정교육 --></button>
								<%-- <button type="button" class="ui basic blue button" data-crs-type-cd="OPEN" onclick="changeCrsTypeCd(this)"><spring:message code="common.button.open" /><!-- 공개강좌 --></button> --%>
							</div>
							<%
						}
						%>
						<div class="fields">
							<div class="two wide field">
								<!-- 개설년도 -->
								<select class="ui fluid dropdown selection" id="creYear" onchange="changeTerm()">
									<c:forEach var="item" items="${yearList }">
										<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
									</c:forEach>
								</select>
							</div>
							<div class="two wide field">
								<!-- 개설학기 -->
								<select class="ui fluid dropdown selection" id="creTerm" onchange="changeTerm()">
									<c:forEach var="item" items="${termList}">
										<option value="${item.codeCd}" ${item.codeCd eq termVO.haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
									</c:forEach>
								</select>
							</div>
							<c:if test="${orgId eq 'ORG0000001'}">
								<div class="two wide field">
									<!-- 대학구분 -->
									<select class="ui fluid dropdown selection" id="univGbn">
										<option value=""><spring:message code="exam.label.org.type" /></option>
										<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
			                    		<c:forEach var="item" items="${univGbnList}">
											<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
										</c:forEach>
									</select>
								</div>
							</c:if>
							<!-- 학과 선택 -->
							<div class="three wide field">
								<select class="ui fluid dropdown selection" id="deptCd" onchange="changeDeptCd(this.value)">
									<option value=""><spring:message code="user.title.userdept.select" /></option>
									<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
									<c:forEach var="item" items="${deptCdList}">
										<option value="${item.deptCd}">${item.deptNm}</option>
									</c:forEach>
								</select>
							</div>
							<!-- 과목 선택 -->
							<div class="four wide field">
								<select class="ui fluid dropdown selection" id="crsCreCd">
									<option value=""><spring:message code="common.subject.select" /></option>
								</select>
							</div>
							<div class="three wide field">
								<div class="ui input">
									<input id="searchValue" type="text" placeholder="<spring:message code='user.message.search.input.crs.cd.tch.nm' />" class="w250" /><!-- 학수번호/과목명/교수명 입력 -->
								</div>
							</div>
						</div>
						<div class="button-area mt10 tc">
							<a href="javascript:void(0)" onclick="listPaging(1)" class="ui blue button w100"><spring:message code="common.button.search" /></a><!-- 검색 -->
						</div>
					</div>
					<div class="mb10">
						<div class="ui bottom attached segment">
							<div class="option-content mb20">
								<h3 class="sec_head"> <spring:message code="user.title.tch.status" /></h3><!-- 교수/조교 현황 -->
								<div class="mla">
									<a href="javascript:selectCreCrsExcelDown()" class="ui green button"><spring:message code="user.title.download.excel" /></a><!-- 엑셀 다운로드 -->
									<select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
										<option value="10">10</option>
										<option value="20">20</option>
										<option value="50">50</option>
										<option value="100">100</option>
									</select>
								</div>
							</div>
							
							<div id="selectCreCrsTable" ></div>
							<script>
		                        // 교수 목록 테이블
		                        var selectCreCrsTable = new Tabulator("#selectCreCrsTable", {
		                        		maxHeight: "500px",
		                        		minHeight: "100px",
		                        		layout: "fitColumns",
		                        		selectableRows: false,
		                        		headerSortClickElement: "icon",
		                        		placeholder:"<spring:message code='common.content.not_found'/>",
		                        		columns: [
		                        			{title:"<spring:message code='common.number.no'/>", 			field:"lineNo", 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60, 		formatter:"plaintext", 	headerSort:false},
		                        			{title:"<spring:message code='crs.label.crs.cd'/>", 			field:"crsCd", 			headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80,	formatter:"plaintext", 	headerSort:false}, // 학수번호
		                        			{title:"<spring:message code='lesson.label.crs.cre.nm'/>",		field:"crsCreNm", 		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:200, 	formatter:"plaintext", 	headerSort:false}, // 과목명
		                        		    {title:"<spring:message code='common.label.mng.dept'/>",		field:"mngDept", 		headerHozAlign:"center", hozAlign:"left", 	vertAlign:"middle", minWidth:150, 	formatter:"plaintext", 	headerSort:false}, // 관장학과
		                        		    {title:"<spring:message code='common.teaching.professor'/>", 	field:"professorNm",	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext", 	headerSort:false}, // 대표교수
		                        		    {title:"<spring:message code='common.label.prof.no'/>", 		field:"professorNo", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext",	headerSort:false}, // 교수사번
		                        		    {title:"<spring:message code='user.title.tch.associate'/>", 	field:"associateNm",	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext", 	headerSort:false}, // 공동교수
		                        		    {title:"<spring:message code='common.label.prof.no'/>", 		field:"associateNo", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext",	headerSort:false}, // 교수사번
		                        		    {title:"<spring:message code='crs.label.rep.assistant'/>", 		field:"tutorNm",		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext", 	headerSort:false}, // 담당조교
		                        		    {title:"<spring:message code='crs.label.rep.assistant.no'/>", 	field:"tutorNo", 		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext",	headerSort:false}, // 조교사번
		                        		    {title:"<spring:message code='user.title.manage'/>", 			field:"manage", 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80, 		formatter:"html",		headerSort:false}  // 관리			                        		    
		                        		]
	                        	});
	                        </script>
							<div id="paging" class="paging mt10"></div>
						</div>
					</div>
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