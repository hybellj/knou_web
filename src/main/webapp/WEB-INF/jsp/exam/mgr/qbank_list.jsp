<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<script type="text/javascript">
	var USER_DEPT_LIST = [];
	var CRS_CRE_LIST   = [];
	
	$(document).ready(function() {
		// 부서정보
		<c:forEach var="item" items="${deptList}">
			USER_DEPT_LIST.push({
				  deptCd: '<c:out value="${item.deptCd}" />'
				, deptNm: '<c:out value="${item.deptNm}" />'
				, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
			});
		</c:forEach>
		
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
		
		crecrsList();
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
	
	// 과정 유현 선택
	function selectCrsType(obj) {
		$(obj).toggleClass("basic active");
		crecrsList();
	}
	
	// 개설과목 리스트
	function crecrsList() {
		var crsTypeCd = "";
		$(".crsType").each(function(i, v) {
			if($(v).hasClass("active")) {
				if(crsTypeCd != "") crsTypeCd += ",";
				crsTypeCd += $(v).attr("data-crsType");
			}
		});
		var url  = "/crs/creCrsMgr/creCrsListPaging.do";
		var data = {
			"creYear"		: $("#creYear").val(),
			"creTerm"		: $("#creTerm").val(),
			"deptCd"		: ($("#deptCd").val() || "").replace("ALL", ""),
			"crsCreCd"		: ($("#crsCreCd").val() || "").replace("ALL", ""),
			"univGbn"		: ($("#univGbn").val() || "").replace("ALL", ""),
			"searchValue"	: $("#crsSearchValue").val(),
			"crsTypeCd"		: crsTypeCd,
			"pagingYn"		: "N"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = "";
				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						var deptNm   = v.deptNm != null ? v.deptNm : '-';
						var userId   = v.userId != null ? v.userId : '-';
						var credit   = v.credit != null ? v.credit : '-';
						var compDvNm = v.compDvNm != null ? v.compDvNm : '-';
						html += `<tr onclick="selectCrs(this)" class="crsList" data-crsNo="\${v.crsCd}" data-crsCreNm="\${v.crsCreNm}" data-userId="\${userId}" data-userNm="\${v.userNm}">`;
						html += `	<td class="tc p_w3">\${v.lineNo }</td>`;
						html += `	<td class="tc p_w10">\${v.orgNm}</td>`;
						html += `	<td class="tc p_w5">\${deptNm}</td>`;
						html += `	<td class="tc p_w10">\${v.crsCd}</td>`;
						html += `	<td class="tc p_w3">\${v.declsNo}</td>`;
						html += `	<td class="p_w15">\${v.crsCreNm}</td>`;
						html += `	<td class="tc p_w3">-</td>`;
						html += `	<td class="tc p_w5">\${compDvNm}</td>`;
						html += `	<td class="tc p_w3">\${credit}</td>`;
						html += `	<td class="tc p_w5">\${v.userNm}</td>`;
						html += `	<td class="tc p_w10">\${userId}</td>`;
						html += `</tr>`;
					});
				}
				$("#crsTotalCnt").text(returnList.length > 0 ? returnList[0].totalCnt : 0);
				$("#creCrsList").empty().html(html);
        		$("#qbankListDiv").css("display", "none");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert("<spring:message code='fail.common.msg' />");
		});
	}
	
	// 과목 선택
	function selectCrs(obj) {
		$(".crsList").removeClass("active");
		$(obj).addClass("active");
		
		$("#qbankListDiv").css("display", "block");
		listQbankForm();
	}
	
	// 문제 목록
	function listQbank(page) {
		var crsNo = $(".crsList.active").attr("data-crsNo");
		var url  = "/quiz/qbankList.do";
		var data = {
			"pageIndex" 		 : page,
			"listScale" 		 : $("#listScale").val(),
			"searchValue" 		 : $("#searchValue").val(),
			"parExamQbankCtgrCd" : $("#searchParExamQbankCtgrCd").val(),
			"examQbankCtgrCd" 	 : $("#searchExamQbankCtgrCd").val(),
			"crsNo" 			 : crsNo
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		html = ``;
        		
        		data.returnList.forEach(function(v, i) {
        			html += `<tr>`;
        			html += `	<td class="tc">\${v.lineNo}</td>`;
        			html += `	<td>\${v.parExamCtgrNm}</td>`;
        			html += `	<td>\${v.examCtgrNm}</td>`;
        			html += `	<td class="tc">\${v.crsNm}</td>`;
        			html += `	<td class="tc">\${v.userNm}</td>`;
        			html += `	<td class="tc"><a href="javascript:editQbankForm('\${v.examQbankQstnSn}')" class="fcBlue">\${v.title}</a></td>`;
        			html += `	<td class="tc">\${v.qstnTypeNm}</td>`;
        			html += `	<td class="tc"><a href="javascript:qbankQstnView('\${v.examQbankQstnSn}')" class="ui basic small button"><spring:message code="exam.label.qstn" /><spring:message code="exam.label.qstn.item" />​</a></td>`;/* 문제 *//* 보기 */
        			html += `</tr>`;
        		});
        		
        		$("#crsQbankList").empty().html(html);
	    		$("#selectQbankTable").footable();
	    		var params = {
			    	totalCount 	  : data.pageInfo.totalRecordCount,
			    	listScale 	  : data.pageInfo.pageSize,
			    	currentPageNo : data.pageInfo.currentPageNo,
			    	eventName 	  : "listQbank"
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
	
	// 엑셀 다운로드
	function qbankExcelDown() {
		var crsNo = $(".crsList.active").attr("data-crsNo");
		var excelGrid = {
			colModel:[
		        {label:"<spring:message code='main.common.number.no' />", name:'lineNo', align:'center', width:'1000'},/* NO */
		        {label:"<spring:message code='exam.label.upper.categori' />", name:'parExamCtgrNm', align:'left', width:'5000'},/* 상위분류 */
		        {label:"<spring:message code='exam.label.sub.categori' />", name:'examCtgrNm', align:'left', width:'5000'},/* 하위분류 */
		        {label:"<spring:message code='crs.label.crecrs' />", name:'crsNm', align:'right', width:'5000'},/* 과목 */
		        {label:"<spring:message code='exam.label.tch.rep' />", name:'userNm', align:'right', width:'5000'},/* 담당교수 */
		        {label:"<spring:message code='exam.label.title' />", name:'title', align:'right', width:'5000'},/* 제목 */
		        {label:"<spring:message code='exam.label.qstn.type' />", name:'qstnTypeNm', align:'right', width:'5000'},/* 문제유형 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'crsNo',   			  'val' : crsNo});
		kvArr.push({'key' : 'examQbankCtgrCd', 	  'val' : $("#searchExamQbankCtgrCd").val()});
		kvArr.push({'key' : 'parExamQbankCtgrCd', 'val' : $("#searchParExamQbankCtgrCd").val()});
		kvArr.push({'key' : 'searchValue',   	  'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'excelGrid', 		  'val' : JSON.stringify(excelGrid)});
		
		submitForm("/quiz/qbankExcelDown.do", "", "", kvArr);
	}
	
	// 문제보기 팝업
	function qbankQstnView(examQbankQstnSn) {
		var crsNo = $(".crsList.active").attr("data-crsNo");
		var kvArr = [];
		kvArr.push({'key' : 'crsNo',   		   'val' : crsNo});
		kvArr.push({'key' : 'examQbankQstnSn', 'val' : examQbankQstnSn});
		
		submitForm("/quiz/qbankQstnViewPop.do", "quizPopIfm", "qbankView", kvArr);
	}
	
	// 문제은행, 등록 탭 선택
	function manageQbank(type) {
		if(type == 0) {
			listQbankForm();
		} else if(type == 1) {
			writeQbankCtgrForm();
		}
	}
	
	// 문제 리스트 폼
	function listQbankForm() {
		var html  = "<div class='option-content mt30'>";
			html += "	<h3 class='sec_head'> <spring:message code='exam.label.qbank' /> <spring:message code='exam.button.list' /></h3>";/* 문제은행 *//* 목록 */
			html += "	<div class='mla'>";
			html += "		<a href='javascript:writeQbankForm()' class='ui orange button'><spring:message code='exam.label.qstn' /> <spring:message code='exam.button.reg' /></a>";/* 문제 *//* 등록 */
			html += "	</div>";
			html += "</div>";
			html += "<div class='option-content mt10'>";
			html += "	<select class='ui dropdown' id='searchParExamQbankCtgrCd' onchange='listQbankParCtgr(this)'>";
			html += "		<option value='all'><spring:message code='exam.label.upper.categori' /></option>";/* 상위분류 */
			html += "	</select>";
			html += "	<select class='ui dropdown' id='searchExamQbankCtgrCd' onchange='listQbank(1)'>";
			html += "		<option value='all'><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
			html += "	</select>";
			html += "	<div class='ui action input search-box'>";
			html += "		<input type='text' placeholder='"+"<spring:message code='exam.label.categori.nm' />"+"/"+"<spring:message code='exam.label.tch.rep' />"+"/"+"<spring:message code='exam.label.title' />"+" "+"<spring:message code='exam.label.input' />"+"' class='w250' id='searchValue'>";/* 분류명 *//* 담당교수 *//* 제목 *//* 입력 */
			html += "		<button class='ui icon button' onclick='listQbank(1)'><i class='search icon'></i></button>";
			html += "	</div>";
			html += "</div>";
			html += "<div class='option-content mt10 mb20'>";
			html += "	<div class='mla'>";
			html += "		<a href='javascript:qbankExcelDown()' class='ui green button'><spring:message code='exam.button.excel.down' /></a>";/* 엑셀 다운로드 */
			html += "		<select class='ui dropdown list-num' id='listScale' onchange='listQbank(1)'>";
			html += "			<option value='10'>10</option>";
			html += "			<option value='20'>20</option>";
			html += "			<option value='50'>50</option>";
			html += "			<option value='100'>100</option>";
			html += "		</select>";
			html += "	</div>";
			html += "</div>";
			html += "<table id='selectQbankTable' class='table' data-sorting='false' data-paging='false' data-empty=\"" + "<spring:message code='user.common.empty' />" + "\">";/* 등록된 내용이 없습니다. */
			html += "	<thead>";
			html += "		<tr>";
			html += "			<th class='tc'>NO</th>";
			html += "			<th class='tc' data-breakpoints='xs sm'><spring:message code='exam.label.upper.categori' /></th>";/* 상위분류 */
			html += "			<th class='tc' data-breakpoints='xs'><spring:message code='exam.label.sub.categori' /></th>";/* 하위분류 */
			html += "			<th class='tc'><spring:message code='crs.label.crecrs' /></th>";/* 과목 */
			html += "			<th class='tc' data-breakpoints='xs sm md'><spring:message code='exam.label.tch.rep' /></th>";/* 담당교수 */
			html += "			<th class='tc'><spring:message code='exam.label.title' /></th>";/* 제목 */
			html += "			<th class='tc'><spring:message code='exam.label.qstn.type' /></th>";/* 문제유형 */
			html += "			<th class='tc'><spring:message code='exam.label.qstn' /><spring:message code='exam.label.qstn.item' /></th>";/* 문제 *//* 보기 */
			html += "		</tr>";
			html += "	</thead>";
			html += "	<tbody id='crsQbankList'>";
			html += "	</tbody>";
			html += "</table>";
			html += "<div id='paging' class='paging'></div>";
		$("#qbankWriteDiv").empty();
		$("#qbankListForm").empty().html(html);
		$("#qbankListForm .dropdown").dropdown();
		listQbank(1);
		$("#searchValue").unbind('keyup').bind('keyup', function(e) {
			if(e.keyCode == 13) {
				listQbank(1);
			}
		});
		listQbankCtgr();
	}
	
	// 문제 등록 폼
	function writeQbankForm() {
		writeQbankQstnForm("");
	}
	
	// 문제 수정 폼
	function editQbankForm(examQbankQstnSn) {
		writeQbankQstnForm(examQbankQstnSn);
		editQbankSetValue(examQbankQstnSn);
	}
	
	var editor;
	// 문제 등록 폼
	function writeQbankQstnForm(examQbankQstnSn) {
		var crsNo 	 = $(".crsList.active").attr("data-crsNo");
		var crsCreNm = $(".crsList.active").attr("data-crsCreNm");
		var userId 	 = $(".crsList.active").attr("data-userId");
		var userNm 	 = $(".crsList.active").attr("data-userNm");
		var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"crsNo"      : crsNo,
			"searchType" : "UPPER"
		};
		
		showLoading();
		$.ajax({
		    url 	 : url,
		    type 	 : "POST",
		    async	 : false,
		    data	 : data,
		    dataType : "json"
		}).done(function(data) {
			hideLoading();
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var h3Title = examQbankQstnSn != "" ? "<spring:message code='exam.button.mod' />"/* 수정 */ : "<spring:message code='exam.button.reg' />"/* 등록 */;
				var html  = "<div class='option-content mt30'>";
					html += "	<h3 class='sec_head'> <spring:message code='exam.label.qbank' /> "+h3Title+"</h3>";/* 문제은행 */
					html += "	<div class='mla'>";
					if(examQbankQstnSn != "") {
					html += "		<a href='javascript:editQbankQstn(\""+examQbankQstnSn+"\")' class='ui green button'><spring:message code='exam.button.mod' /></a>";/* 수정 */
					html += "		<a href='javascript:delQbankQstn(\""+examQbankQstnSn+"\", \""+userId+"\")' class='ui green button'><spring:message code='exam.button.del' /></a>";/* 삭제 */
					} else {
					html += "		<a href='javascript:writeQbankQstn()' class='ui green button'><spring:message code='exam.button.save' /></a>";/* 저장 */
					}
					html += "		<a href='javascript:listQbankForm()' class='ui green button'><spring:message code='exam.button.list' /></a>";/* 목록 */
					html += "	</div>";
					html += "</div>";
					html += "<form id='qbankWriteForm' method='POST' onSubmit='return false;'>";
					html += "	<input type='hidden' name='examQbankQstnSn' value=\""+examQbankQstnSn+"\" />";
					html += "	<input type='hidden' name='editorYn' 		value='Y' />";
					html += "	<input type='hidden' name='qstnScore' 		value='0' />";
					html += "	<input type='hidden' name='qstnDiff'		value='ALL' />";
					html += "	<div class='ui form'>";
					html += "		<ul class='tbl border-top-grey'>";
					html += "			<li>";
					html += "				<dl>";
					html += "					<dt><label><spring:message code='exam.label.sel.categori' /></label></dt>";/* 분류 선택 */
					html += "					<dd>";
					html += "						<select class='ui dropdown w200' id='parCtgrCd' onchange='chgCtgrCd(this)'>";
					html += "							<option value=''><spring:message code='exam.label.upper.categori' /></option>";/* 상위분류 */
					if(returnList.length > 0) {
						returnList.forEach(function(v, i) {
					html += "							<option value=\""+v.examQbankCtgrCd+"\">"+v.parExamCtgrNm+"</option>";
						});
					}
					html += "						</select>";
					html += "						<select class='ui dropdown w200' id='ctgrCd' onchange='selectQstnNo()'>";
					html += "							<option value=''><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
					html += "						</select>";
					html += "					</dd>";
					html += "				</dl>";
					html += "			</li>";
					html += "			<li>";
					html += "				<dl>";
					html += "					<dt><label class='req'><spring:message code='exam.label.crs.cd' /></label></dt>";/* 학수 번호 */
					html += "					<dd>";
					html += "						<input type='text' class='w350' name='crsNo' value=\""+crsNo+"\" readonly />";
					html += "						( <span>"+crsCreNm+" <spring:message code='crs.label.crecrs' /></span> )";/* 과목 */
					html += "					</dd>";
					html += "				</dl>";
					html += "			</li>";
					html += "			<li>";
					html += "				<dl>";
					html += "					<dt><label class='req'><spring:message code='exam.label.tch.cd' /></label></dt>";/* 교수 번호 */
					html += "					<dd>";
					html += "						<input type='text' class='w350' name='rgtrId' value=\""+userId+"\" readonly />";
					html += "						( <span>"+userNm+" <spring:message code='exam.label.tch' /></span> )";/* 교수 */
					html += "					</dd>";
					html += "				</dl>";
					html += "			</li>";
					html += "		</ul>";
					html += "	</div>";
					html += "	<div class='flex gap4 mt20'>";
					html += "		<select class='ui dropdown' name='qstnTypeCd' id='qstnTypeSelect' onchange='qstnTypeChg()'>";
					<c:forEach var="code" items="${qstnTypeList }">
					html += "			<option value='${code.codeCd }'>${code.codeNm }</option>";
					</c:forEach>
					html += "		</select>";
					html += "		<div class='field flex1 mb0'>";
					var url  = "/quiz/selectQbankQstnNos.do";
					var data = {
						"examQbankCtgrCd" : "-",
						"crsNo"			  : crsNo
					};
					$.ajax({
					    url 	 : url,
					    type 	 : "POST",
					    async	 : false,
					    data	 : data,
					    dataType : "json"
					}).done(function(data) {
						if (data.result > 0) {
							var qstnNoStr = data.returnVO != null ? data.returnVO.qstnNo : "1";
							var subNoStr  = data.returnVO != null ? data.returnVO.subNo : "1";
					html += "			<input type='text' id='title' name='title' readonly placeholder='"+qstnNoStr+"-"+subNoStr+" "+"<spring:message code='exam.label.qstn' />"+"'>";/* 문제 */
			            } else {
			             	alert(data.message);
			            }
					}).fail(function() {
						alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
					});
					html += "		</div>";
					html += "	</div>";
                	html += "	<div class='ui small warning message'><i class='info circle icon'></i><spring:message code='exam.alert.another.title' /></div>";/* 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다. */
                	html += "	<dl style='display:table;width:100%'>";
                	html += "		<dd style='display:table-cell;height:400px'>";
                	html += "			<div style='height:100%'>";
                	html += "				<textarea name='qstnCts' id='qstnCts'></textarea>";
                	html += "			</div>";
                	html += "		</dd>";
                	html += "	</dl>";
					html += "	<div class='mt30'>";
					html += "		<ul class='tbl' id='qstnWriteForm'></ul>";
					html += "	</div>";
					html += "</form>";
				$("#qbankListForm").empty();
				$("#qbankWriteDiv").empty().html(html);
				$("#qbankWriteDiv .dropdown").dropdown();
				editor = HtmlEditor('qstnCts', THEME_MODE, '/exam');
		        $("#new_qstnCts").css("z-index", "1");
		        qstnTypeChg();
            } else {
             	alert(data.message);
            }
		}).fail(function() {
			hideLoading();
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	var formOption = {
		// 보기, 정답 개수 셀렉트 박스
		selectEmplCntForm: function(type) {
			var html  = "<li>";
				html += "	<dl>";
				html += "		<dt><label for='emplCnt'><spring:message code='exam.label.qstn.item.cnt' /></label></dt>";/* 보기 갯수 */
				html += "		<dd>";
				html += "			<select class='ui dropdown w150' id='emplCnt' onchange='qbankQstnChg(\""+type+"\")'>";
									for(var i = 2; i <= 10; i++) {
										var selected = (type == "CHOICE" || type == "MULTICHOICE") && i == 4 ? "selected" : "";
				html += "				<option value=\""+i+"\" "+selected+">"+i+"<spring:message code='exam.label.unit' /></option>";/* 개 */
									}
				html += "			</select>";
				html += "		</dd>";
				html += "	</dl>";
				html += "</li>"
			$("#qstnWriteForm").append(html);
		},
		// 보기, 정답 작성 폼
		writeEmplForm: function(type) {
			var html = "";
			if(type == "CHOICE" || type == "MULTICHOICE") {
				html += "<li>";
				html += "	<dl>";
				html += "		<dt><label for='rgtAnsr1'><spring:message code='exam.label.qstn.item' /> <spring:message code='exam.label.input' /></label></dt>";/* 보기 *//* 입력 */
				html += "		<dd>";
				html += "			<div class='ui segment'>";
				html += "				<ul class='tbl' id='qbankChoiceUl'>";
									for(var i = 1; i <= 4; i++) {
				html += "					<li class='qbankChoiceLi'>";
				html += "						<dl>";
				html += "							<dt>";
				if(type == "CHOICE") {
				html += "								<div class='ui radio checkbox'>";
				html += "									<input type='radio' id='choiceRgtAnsr"+i+"' name='rgtAnsrCheck' value=\""+i+"\">";
				} else {
				html += "								<div class='ui checkbox'>";
				html += "									<input type='checkbox' id='choiceRgtAnsr"+i+"' name='rgtAnsrCheck' value=\""+i+"\">";
				}
				html += "									<label class='toggle_btn' for='choiceRgtAnsr"+i+"'><spring:message code='exam.label.qstn.item' />"+i+"</label>";/* 보기 */
				html += "								</div>";
				html += "							</dt>";
				html += "							<dd><input type='text' class='japanInput' name='empl"+i+"'/></dd>";
				html += "						</dl>";
				html += "					</li>";
									}
				html += "				</ul>";
				html += "			</div>";
				html += "		</dd>";
				html += "	</dl>";
				html += "</li>";
			} else if(type == "MATCH") {
				html += "<li>";
				html += "	<dl>";
				html += "		<dt><label for='teamLabel'><spring:message code='exam.label.input.answer' /></label></dt>";/* 정답 입력 */
				html += "		<dd id='qbankMatchDd'>";
							for(var i = 1; i <= 2; i++) {
				html += "			<div class='line-sortable-box qbankMatchDiv'>";
				html += "				<div class='account-list p10'>";
				html += "					<div class='line-box num0"+i+"'>";
				html += "						<div class='question p20 pl45'>";
				html += "							<input type='text' name='empl"+i+"' class='japanInput' placeholder='"+"<spring:message code='exam.label.qstn.item' />"+" <spring:message code='exam.label.input' />"+"'/>";/* 보기 *//* 입력 */
				html += "						</div>";
				html += "						<div class='slot'><input type='text' name='rgtAnsrText' class='japanInput' placeholder='"+"<spring:message code='exam.label.input.answer' />"+"' /></div>";/* 정답 입력 */
				html += "					</div>";
				html += "				</div>";
				html += "			</div>";
							}
				html += "		</dd>";
				html += "	</dl>";
				html += "</li>";
			} else if(type == "OX") {
				html += "<li>";
				html += "	<dl>";
				html += "		<dt><label for='teamLabel'><spring:message code='exam.label.input.answer' /></label></dt>";/* 정답 입력 */
				html += "		<dd>";
				html += "			<div class='w150 mr15 d-inline-block ui card'>";
				html += "				<div class='checkImg'>";
				html += "					<input id='qbankQstnOX_true' name='rgtAnsrSelect' type='radio' value='1'>";
				html += "					<label class='imgChk true' for='qbankQstnOX_true'></label>";
				html += "				</div>";
				html += "			</div>";
				html += "			<div class='w150 d-inline-block ui card'>";
				html += "				<div class='checkImg'>";
				html += "					<input id='qbankQstnOX_false' name='rgtAnsrSelect' type='radio' value='2'>";
				html += "					<label class='imgChk false' for='qbankQstnOX_false'></label>";
				html += "				</div>";
				html += "			</div>";
				html += "		</dd>";
				html += "	</dl>";
				html += "</li>";
			} else if(type == "SHORT") {
				html += "<li>";
				html += "	<dl>";
				html += "		<dt><label for='teamLabel'><spring:message code='exam.label.input.answer' /></label></dt>";/* 정답 입력 */
				html += "		<dd id='addQstnDiv'>";
				html += "			<div class='ui action fluid input mt10 shortInput'>";
				for(var idx = 1; idx <= 5; idx ++) {
				html += "				<input type='text' class='japanInput' name='rgtAnsrText'>";
				}
				html += "				<button class='ui icon button' onclick='addQstnInput()'><i class='plus icon'></i></button>";
				html += "			</div>";
				html += "		</dd>";
				html += "	</dl>";
				html += "</li>";
			}
			$("#qstnWriteForm").append(html);
		},
		// 정답 유형 선택 버튼
		asnwerTypeForm: function(type) {
			var html  = "<li id='shortGubun'>";
				html += "	<dl>";
				html += "		<dt><label for='teamLabel'><spring:message code='exam.label.answer.type' /></label></dt>";/* 정답 유형 */
				html += "		<dd>";
				html += "			<div class='fields'>";
				html += "				<div class='field'>";
				html += "					<div class='ui radio checkbox'>";
				html += "						<input type='radio' id='rgtTypeA' name='multiRgtChoiceTypeCd' value='A' tabindex='0' class='hidden' checked>";
				html += "						<label for='rgtTypeA'><spring:message code='exam.label.answer.order' /></label>";/* 순서에 맞게 정답 */
				html += "					</div>";
				html += "				</div>";
				html += "				<div class='field'>";
				html += "					<div class='ui radio checkbox'>";
				html += "						<input type='radio' id='rgtTypeB' name='multiRgtChoiceTypeCd' value='B' tabindex='0' class='hidden'>";
				html += "						<label for='rgtTypeB'><spring:message code='exam.label.answer.not.order' /></label>";/* 순서에 상관없이 정답 */
				html += "					</div>";
				html += "				</div>";
				html += "			</div>";
				html += "		</dd>";
				html += "	</dl>";
				html += "</li>";
			$("#qstnWriteForm").append(html);
		}
	};
	
	// 문항 타입 변경
	function qstnTypeChg() {
		$("#qstnWriteForm").empty();
		var type = $("#qstnTypeSelect").val();
		if(type == "CHOICE" || type == "MULTICHOICE" || type == "MATCH") {
			formOption.selectEmplCntForm(type);
			formOption.writeEmplForm(type);
		} else if(type == "SHORT" || type == "OX") {
			if(type == "SHORT") {
	        	formOption.asnwerTypeForm(type);
			}
			formOption.writeEmplForm(type);
        }
		$("#qstnWriteForm .dropdown").dropdown();
		// 일본어입력기 적용
    	setJapaneseInput();
	}
	
	// 보기 갯수 변경
    function qbankQstnChg(type) {
    	// 객관식
    	if(type == "CHOICE" || type == "MULTICHOICE") {
	    	var choiceLiCnt = $(".qbankChoiceLi").length;
	    	var choiceCnt   = $("#emplCnt").val();
	    	
	    	if(choiceLiCnt < choiceCnt) {
		    	for(var i = choiceLiCnt; i < choiceCnt; i++) {
				   	var html  = "<li class='qbankChoiceLi'>";
				   		html += "	<dl>";
				   		html += "		<dt>";
				   		if(type == "CHOICE") {
				   		html += "			<div class='ui radio checkbox'>";
				   		html += "				<input type='radio' id='choiceRgtAnsr"+(i+1)+"' name='rgtAnsrCheck' value='"+(i+1)+"'>";
				   		} else {
				   		html += "			<div class='ui checkbox'>";
				   		html += "				<input type='checkbox' id='choiceRgtAnsr"+(i+1)+"' name='rgtAnsrCheck' value='"+(i+1)+"'>";
				   		}
				   		html += "				<label class='toggle_btn' for='choiceRgtAnsr"+(i+1)+"'><spring:message code='exam.label.qstn.item' />"+(i+1)+"</label>";/* 보기 */
				   		html += "			</div>";
				   		html += "		</dt>";
				   		html += "		<dd><input type='text' class='japanInput' name='empl"+(i+1)+"' /></dd>";
				   		html += "	</dl>";
				   		html += "</li>";
			    	$("#qbankChoiceUl").append(html);
		    	}
	    	} else if(choiceLiCnt > choiceCnt) {
		    	for(var i = choiceLiCnt; i > choiceCnt-1; i--) {
		    	 	$(".qbankChoiceLi:eq("+i+")").remove();
		    	}
	    	}
	    	
	    // 짝짓기형
    	} else if(type == "MATCH") {
    		var matchDivCnt = $(".qbankMatchDiv").length;
    		var matchCnt 	= $("#emplCnt").val();
    		
    		if(matchDivCnt < matchCnt) {
    			for(var i = matchDivCnt; i < matchCnt; i++) {
    				var classNm = "num0"+(i+1);
    				var html  = "<div class='line-sortable-box qbankMatchDiv'>";
    					html += "	<div class='account-list p10'>";
    					html += "		<div class='line-box "+classNm+"'>";
    					html += "			<div class='question p20 pl45'>";
    					html += "				<input type='text' name='empl"+(i+1)+"' class='japanInput' placeholder='"+"<spring:message code='exam.label.qstn.item' /> <spring:message code='exam.label.input' />"+"'/>";/* 보기 *//* 입력 */
    					html += "			</div>";
    					html += "			<div class='slot'><input type='text' name='rgtAnsrText' class='japanInput' placeholder='"+"<spring:message code='exam.label.input.answer' />"+"' /></div>";/* 정답 입력 */
    					html += "		</div>";
    					html += "	</div>";
    					html += "</div>";
    				$("#qbankMatchDd").append(html);
    			}
    		} else if(matchDivCnt > matchCnt) {
    			for(var i = matchDivCnt; i > matchCnt-1; i--) {
    				$(".qbankMatchDiv:eq("+i+")").remove();
    			}
    		}
    	}
    	
    	// 일본어입력기 적용
    	setJapaneseInput();
    }
	
 	// 주관식(단답형) 문항 추가
    function addQstnInput() {
    	var shortInputCnt = $(".shortInput").length;
    	if(shortInputCnt == 5) {
    		return false;
    	}
    	var html =  "<div class='ui action fluid input mt10 shortInput'>";
    		for(var idx = 1; idx <= 5; idx++) {
    		html += "	<input type='text' class='japanInput' name='rgtAnsrText'>";
    		}
    		html += "	<button class='ui icon button' onclick='delQstnInput(this)'><i class='minus icon'></i></button>";
    		html += "	<button class='ui icon button' onclick='addQstnInput()'><i class='plus icon'></i></button>";
    		html += "</div>";
    	$("#addQstnDiv").append(html);
    	// 일본어입력기 적용
    	setJapaneseInput();
    }
    
    // 주관식(단답형) 문항 제거
    function delQstnInput(obj) {
    	$(obj).parent().remove();
    }
    
 	// 문제 검색용 상위 분류 목록
	function listQbankCtgr() {
		var crsNo = $(".crsList.active").attr("data-crsNo");
		var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"crsNo" 	 : crsNo,
			"searchType" : "UPPER"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "<option value='all'><spring:message code='exam.label.upper.categori' /></option>";/* 상위분류 */
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
	        			html += `<option value="\${v.examQbankCtgrCd}">\${v.parExamCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#searchParExamQbankCtgrCd").empty().append(html);
        		$("#searchParExamQbankCtgrCd").dropdown("clear");
        		$("#searchParExamQbankCtgrCd option[value='all']").prop("selected", true).trigger("change");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
 	
 	// 문제 검색용 하위 분류
 	function listQbankParCtgr(obj) {
 		var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"parExamQbankCtgrCd" : $(obj).val(),
			"searchType"		 : "UNDER"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "<option value='all'><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
        		
        		if(returnList.length > 0 && $(obj).val() != "all") {
        			returnList.forEach(function(v, i) {
	        			html += `<option value="\${v.examQbankCtgrCd}">\${v.examCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#searchExamQbankCtgrCd").empty().append(html);
        		$("#searchExamQbankCtgrCd").dropdown("clear");
        		$("#searchExamQbankCtgrCd option[value='all']").prop("selected", true).trigger("change");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
 	}
    
 	// 하위 분류 목록 가져오기
    function chgCtgrCd(obj) {
    	var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"parExamQbankCtgrCd" : $(obj).val(),
			"searchType"		 : "UNDER"
		};
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "<option value=''><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
	        			html += `<option value="\${v.examQbankCtgrCd}">\${v.examCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#ctgrCd").empty().append(html);
        		//$("#ctgrCd").dropdown("clear");
        		
        		selectQstnNo();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
    }
    
    // 특정 분류코드 순서 가져오기
    function selectQstnNo() {
    	var examQbankCtgrCd = "";
    	if($("#ctgrCd").val() == "") {
    		examQbankCtgrCd = $("#parCtgrCd").val();
    	} else {
    		examQbankCtgrCd = $("#ctgrCd").val();
    	}
    	
    	var url  = "/quiz/selectQbankQstnNos.do";
		var data = {
			"examQbankCtgrCd" : examQbankCtgrCd
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnVO = data.returnVO;
        		$("#title").val(returnVO.qstnNo + "-" + returnVO.subNo + " <spring:message code='exam.label.qstn' />");/* 문제 */
        		$("#title").attr("placeholder", returnVO.qstnNo + "-" + returnVO.subNo + " <spring:message code='exam.label.qstn' />");/* 문제 */
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
    }
    
    // 문제 수정 값 적용
    function editQbankSetValue(examQbankQstnSn) {
    	var url  = "/quiz/viewQbankQstn.do";
		var data = {
			"examQbankQstnSn" : examQbankQstnSn
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnVO = data.returnVO;
        		if(returnVO != null) {
        			// 문제 분류
        			$("#parCtgrCd").val(returnVO.parExamQbankCtgrCd).trigger("change");
        			setTimeout(() => {
	        			$("#ctgrCd").val(returnVO.examQbankCtgrCd).trigger("change");
					}, 100);
        			 
        			// 제목
        			$("#title").val(returnVO.title);
        			$("#title").attr("placeholder", returnVO.qstnNo+"-"+returnVO.subNo+" <spring:message code='exam.label.qstn' />");/* 문제 */
        			// 내용
        			editor.insertHTML($.trim(returnVO.qstnCts) == "" ? " " : returnVO.qstnCts);
        			// 문제 유형
        			$("#qstnTypeSelect").val(returnVO.qstnTypeCd).trigger("change");
        			
        			var emplList   = [returnVO.empl1, returnVO.empl2, returnVO.empl3, returnVO.empl4, returnVO.empl5,
        							  returnVO.empl6, returnVO.empl7, returnVO.empl8, returnVO.empl9, returnVO.empl10];
        			// 공통
        			
        			if(returnVO.qstnTypeCd == "CHOICE" || returnVO.qstnTypeCd == "MULTICHOICE" || returnVO.qstnTypeCd == "MATCH") {
        				// 보기 갯수
        				var emplCnt = returnVO.emplCnt || 0;
        				$("#emplCnt").val(emplCnt).trigger("change");
        				// 문항 입력
        				for(var i = 0; i < emplCnt; i++) {
        					$("input[name=empl"+(i+1)+"]").val(emplList[i]);
        				}
        			}
        			
        			// 객관식
        			if(returnVO.qstnTypeCd == "CHOICE" || returnVO.qstnTypeCd == "MULTICHOICE") {
        				// 정답 체크
        				returnVO.rgtAnsr1.split(",").forEach(function(v, i) {
        					$("input[name=rgtAnsrCheck][value="+v+"]").attr("checked", true);
        				});
        			
        			// 주관식(단답형)
        			} else if(returnVO.qstnTypeCd == "SHORT") {
        				// 정답 입력
        				var ansrCnt = 5;
        				for(var i = 1; i <= 5; i++) {
        					var ansr = "rgtAnsr"+i;
        					if(returnVO[ansr] != null) ansrCnt = i;
        				}
        				for(var i = 1; i <= ansrCnt; i++) {
        					if(i > 1) addQstnInput();
        					var ansr = "rgtAnsr"+i; 
        					returnVO[ansr].split("|").forEach(function(v, j) {
        						$(".shortInput").eq(i-1).find("input[name=rgtAnsrText]:eq("+j+")").val(v);
        					});
        				}
        				// 정답 유형
        				$("input[name=multiRgtChoiceTypeCd][value="+returnVO.multiRgtChoiceTypeCd+"]").trigger("change");
        				
        			// OX형
        			} else if(returnVO.qstnTypeCd == "OX") {
        				// 정답 선택
        				$("input[name=rgtAnsrSelect][value='" + returnVO.rgtAnsr1 + "']").trigger("click");
        				
        			// 짝짓기형
        			} else if(returnVO.qstnTypeCd == "MATCH") {
        				// 정답 입력
        				returnVO.rgtAnsr1.split("|").forEach(function(v, i) {
        					$("input[name=rgtAnsrText]:eq("+i+")").val(v);
        				});
        			}
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
    }
    
    // 저장
    function writeQbankQstn() {
    	if(!validateWriteQbankQstn()) {
    		return false;
    	}
    	
    	showLoading();
		var url = "/exam/examMgr/writeQbank.do";
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#qbankWriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		alert("<spring:message code='exam.alert.insert' />");/* 정상 저장 되었습니다. */
        		listQbankForm();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.insert' />");/* 저장 중 에러가 발생하였습니다. */
        });
    }
    
    // 수정
    function editQbankQstn(examQbankQstnCd) {
    	if(!validateWriteQbankQstn()) {
    		return false;
    	}
    	
    	showLoading();
		var url = "/exam/examMgr/editQbank.do";
    	
		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#qbankWriteForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		alert("<spring:message code='exam.alert.update' />");/* 정상 수정 되었습니다. */
        		listQbankForm();
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	alert("<spring:message code='exam.error.update' />");/* 수정 중 에러가 발생하였습니다. */
        });
    }
    
    // 삭제
    function delQbankQstn(examQbankQstnSn, userId) {
    	var url  = "/quiz/delQbank.do";
		var data = {
			"examQbankQstnSn" : examQbankQstnSn,
			"mdfrId"			  : userId
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				/* 정상 삭제 되었습니다. */
				alert("<spring:message code='exam.alert.delete' />");
				listQbankForm();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			/* 삭제 중 에러가 발생하였습니다. */
			alert("<spring:message code='exam.error.delete' />");
		});
    }
    
    // 유효성 검사
    function validateWriteQbankQstn() {
    	$("#qbankWriteForm").find("input[name=examQbankCtgrCd]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr1]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr2]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr3]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr4]").remove();
    	$("#qbankWriteForm").find("input[name=rgtAnsr5]").remove();
    	$("#qbankWriteForm").find("input[name=multiRgtChoiceYn]").remove();
    	$("#qbankWriteForm").find("input[name=qstnNo]").remove();
    	$("#qbankWriteForm").find("input[name=subNo]").remove();
    	
    	var isValid = true;
    	
    	var titleHolder = $("#title").attr("placeholder").split(/:|\-| /);
    	var qstnNo 		= titleHolder[0];
    	var subNo 		= titleHolder[1];
    	
    	// 문제 번호 적용
    	$("#qbankWriteForm").append("<input type='hidden' name='qstnNo' value='" + qstnNo + "' />");
    	$("#qbankWriteForm").append("<input type='hidden' name='subNo' value='" + subNo + "' />");
    	
    	// 문제은행 분류코드 적용
    	if($("#parCtgrCd").val() == "") {
    		$("#qbankWriteForm").append("<input type='hidden' name='examQbankCtgrCd' value='-' />");
    	} else {
    		if($("#ctgrCd").val() == "") {
    			$("#qbankWriteForm").append("<input type='hidden' name='examQbankCtgrCd' value='" + $("#parCtgrCd").val() + "' />");
    		} else {
    			$("#qbankWriteForm").append("<input type='hidden' name='examQbankCtgrCd' value='" + $("#ctgrCd").val() + "' />");
    		}
    	}
    	
    	var qstnTypeCd = $("#qstnTypeSelect").val();
    	// 객관식 체크
    	if(qstnTypeCd == "CHOICE" || qstnTypeCd == "MULTICHOICE") {
    		var rgtAnsrChkLen = $("input[name=rgtAnsrCheck]:checked").length;
    		if(rgtAnsrChkLen == 0) {
    			alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
        		return false;
    		} else {
    			var multiRgtChoiceYn = rgtAnsrChkLen > 1 ? "Y" : "N";
    			$("#qbankWriteForm").append("<input type='hidden' name='multiRgtChoiceYn' value='" + multiRgtChoiceYn + "' />");
				var rgtAnsr1 = "";
    			$("input[name=rgtAnsrCheck]:checked").each(function(i) {
    				if(i > 0) {
    					rgtAnsr1 += ",";
    				}
    				rgtAnsr1 += $(this).val();
    			});
    			$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr1' value='" + rgtAnsr1 + "' />");
    		}
    		
    		// 문항 입력 체크
    		var emplCnt = $("#emplCnt").val();
    		for(var i = 1; i <= emplCnt; i++) {
    			if($.trim($("input[name=empl"+i+"]").val()) == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    		}
    		
    	// 주관식(단답형) 체크
    	} else if(qstnTypeCd == "SHORT") {
    		$(".shortInput").each(function(i) {
    			var rgtAnsr = "";
    			if($(this).find("input[name=rgtAnsrText]").val() == "") {
    				alert((i+1)+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				return false;
    			}
    			$(this).find("input[name=rgtAnsrText]").each(function(ii) {
    				if($.trim($(this).val()) != "") {
    					if(rgtAnsr != "") {
    						rgtAnsr += "|";
    					}
    					rgtAnsr += $(this).val();
    				}
    			});
    			$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr"+(i+1)+"' value='" + rgtAnsr +"' />");
    		});
    		var multiRgtChoiceYn = $(".shortInput").length > 1 ? "Y" : "N";
    		$("#qbankWriteForm").append("<input type='hidden' name='multiRgtChoiceYn' value=\"" + multiRgtChoiceYn + "\" />");
    		
    	// OX형 체크
    	} else if(qstnTypeCd == "OX") {
    		// 정답 선택 체크
    		if($("input[name=rgtAnsrSelect]:checked").val() == undefined) {
    			alert("<spring:message code='exam.alert.select.answer' />");/* 정답을 선택하세요. */
    			return false;
    		} else {
    			$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr1' value='" + $("input[name=rgtAnsrSelect]:checked").val() +"' />");
    		}
    		
    	// 짝짓기형 체크
    	} else if(qstnTypeCd == "MATCH") {
    		// 문항 입력 체크
    		var matchCnt = $("#emplCnt").val();
    		for(var i = 1; i <= matchCnt; i++) {
    			if($.trim($("input[name=empl"+i+"]").val()) == "") {
    				alert(i+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    		}
    		// 정답 입력 체크
    		var rgtAnsr = "";
    		$("input[name=rgtAnsrText]").each(function(i) {
    			if($.trim($(this).val()) == "") {
    				alert((i+1)+"<spring:message code='exam.alert.input.qstn' />");/* 번 항목을 입력하세요. */
    				isValid = false;
    				return false;
    			}
    			if(i > 0) {
    				rgtAnsr += "|";
    			}
    			rgtAnsr += $.trim($(this).val());
    		});
    		$("#qbankWriteForm").append("<input type='hidden' name='rgtAnsr1' value='" + rgtAnsr +"' />");
    	}
    	return isValid;
    }
	
	// 분류코드 등록 폼
	function writeQbankCtgrForm() {
		var kvArr = [];
		kvArr.push({'key' : 'crsNo',  'val' : $(".crsList.active").attr("data-crsNo")});
		kvArr.push({'key' : 'crsNm',  'val' : $(".crsList.active").attr("data-crsCreNm")});
		kvArr.push({'key' : 'userId', 'val' : $(".crsList.active").attr("data-userId")});
		kvArr.push({'key' : 'userNm', 'val' : $(".crsList.active").attr("data-userNm")});
		
		submitForm("/exam/examMgr/Form/writeQbankCtgr.do", "", "", kvArr);
	}
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.class.management.tool" /><!-- 수업운영도구 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="exam.label.qbank" /><!-- 문제은행 --></small>
                                </div>
                            </h2>
		                    <div class="option-content mt20" style="<%if(!SessionInfo.isKnou(request)){%>display:none<%}%>">
		                    	<div class="ui basic buttons mb10">
			                    	<button class="ui basic blue button crsType" data-crsType="UNI" onclick="selectCrsType(this)"><spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
			                    	<%-- <button class="ui basic blue button crsType" data-crsType="CO" onclick="selectCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button>
			                    	<button class="ui basic blue button crsType" data-crsType="LEGAL" onclick="selectCrsType(this)"><spring:message code="crs.label.crs.legal" /><!-- 법정교육 --></button>
			                    	<button class="ui basic blue button crsType" data-crsType="OPEN" onclick="selectCrsType(this)"><spring:message code="crs.label.crs.open" /><!-- 공개강좌 --></button> --%>
		                    	</div>
		                    </div>
		                    <div class="option-content mt20">
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
									<select id="univGbn" class="ui dropdown mr5">
					                   	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
					                   	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
					                   	<c:forEach var="item" items="${univGbnList}">
											<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
										</c:forEach>
					                </select>
				                </c:if>
				                <select id="deptCd" class="ui dropdown mr5 w250">
		                        	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
		                        </select> 
		                        <select id="crsCreCd" class="ui dropdown mr5 w250">
				                	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
				                </select>
		                    	<div class="ui action">
								    <input type="text" placeholder="<spring:message code='user.message.search.input.crs.cd.tch.nm' />" class="w250" id="crsSearchValue"><!-- 학수번호/과목명/교수명 입력 -->
								</div>
								<div class="mla">
								    <button class="ui green button" onclick="crecrsList()"><spring:message code="exam.button.search" /><!-- 검색 --></button>
								</div>
		                    </div>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="option-content mb20">
			                		<h3 class="sec_head"> <spring:message code="crs.label.open.crs" /><!-- 개설과목 --></h3>
			                		<div class="mla">
			                			[ <spring:message code="user.title.total" /><!-- 총 --> <span class="fcBlue" id="crsTotalCnt">0</span><spring:message code="user.title.count" /><!-- 건 --> ]
			                		</div>
		                		</div>
		                		<table id="creCrsTable" class="tbl type2 scrolltable select-list checkbox" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
		                			<thead>
		                				<tr>
		                					<th class="tc p_w3"><spring:message code="main.common.number.no" /><!-- NO --></th>
		                					<th class="tc p_w10"><spring:message code="user.title.userinfo.manage.userdiv" /><!-- 구분 --></th>
		                					<th class="tc p_w5"><spring:message code="crs.label.open.dept" /><!-- 개설학과 --></th>
		                					<th class="tc p_w10"><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
		                					<th class="tc p_w3"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
		                					<th class="tc p_w15"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
		                					<th class="tc p_w3"><spring:message code="user.title.userinfo.grade" /><!-- 학년 --></th>
		                					<th class="tc p_w5"><spring:message code="crs.label.compdv" /><!-- 이수구분 --></th>
		                					<th class="tc p_w3"><spring:message code="crs.label.credit" /><!-- 학점 --></th>
		                					<th class="tc p_w5"><spring:message code="user.title.tch.req.professor" /><!-- 메인교수 --></th>
		                					<th class="tc p_w10"><spring:message code="user.title.tch.professor.no" /><!-- 교수번호 --></th>
		                				</tr>
		                			</thead>
		                			<tbody id="creCrsList" class="max-height-450">
		                			</tbody>
		                		</table>
		        			</div>
		        		</div>
		        		<div class="row" id="qbankListDiv" style="display:none;">
		        			<div class="col">
			                	<div class="listTab mt30">
					                <ul>
					                    <li class="select mw120 mla"><a onclick="manageQbank(0)"><spring:message code="exam.label.qbank" /><!-- 문제은행 --></a></li>
					                    <li class="mw120"><a onclick="manageQbank(1)"><spring:message code="exam.label.categori.code" /><!-- 분류코드 --> <spring:message code="exam.button.reg" /><!-- 등록 --></a></li>
					                </ul>
					            </div>
					            <div id="qbankListForm">
					            </div>
					            <div id="qbankWriteDiv">
					            </div>
		        			</div>
		        		</div>
        			</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>