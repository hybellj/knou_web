<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<script type="text/javascript">
	var USER_DEPT_LIST;
	var CRS_CRE_LIST;
	var SEARCH_OBJ; // 검색조건 저장

	$(document).ready(function() {
		// 학기변경
		changeTerm();
		
		// 부서 목록 조회
		getUserDeptList();
	});
	
	// 부서 목록 조회
	function getUserDeptList() {
		var url = "/user/userMgr/deptList.do";
		var data = {
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				USER_DEPT_LIST = returnList.sort(function(a, b) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
					return 0;
				});
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
		});
	}
	
	// 학기변경
	function changeTerm() {
		// 대학구분 초기화
		$("#uniCd").off("change");
		$("#uniCd").dropdown("clear");
		
		// 부서 초기화
		$("#deptCd").off("change");
		$("#deptCd").empty();
		$("#deptCd").dropdown("clear");
		
		// 학과 초기화
		$("#crsCreCd").empty();
		$("#crsCreCd").dropdown("clear");
		
		var url = "/crs/creCrsMgr/listCrsCre.do";
		var data = {
			  creYear	: $("#haksaYear").val()
			, creTerm	: $("#haksaTerm").val()
			, uniCd 	: ""
			, useYn		: "Y"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				CRS_CRE_LIST = returnList.sort(function(a, b) {
					if(a.crsCreNm < b.crsCreNm) return -1;
					if(a.crsCreNm > b.crsCreNm) return 1;
					if(a.crsCreNm == b.crsCreNm) {
						if(a.declsNo < b.declsNo) return -1;
						if(a.declsNo > b.declsNo) return 1;
					}
					return 0;
				});
				
				$("#uniCd").on("change", function() {
					changeUniCd(this.value);
				});
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
		}, true);
	}
	
	// 대학 구분 변경
	function changeUniCd(uniCd) {
		var uniCd = uniCd;
		
		var deptCdObj = {};
		
		CRS_CRE_LIST.forEach(function(v, i) {
			if(v.uniCd == uniCd && v.deptCd) {
				deptCdObj[v.deptCd] = true;
			}
		});
		
		var html = '';
		
		USER_DEPT_LIST.forEach(function(v, i) {
			if(deptCdObj[v.deptCd]) {
				html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
			}
		});
		
		// 부서 초기화
		$("#deptCd").off("change");
		$("#deptCd").html(html);
		$("#deptCd").dropdown("clear");
		$("#deptCd").on("change", function() {
			changeDeptCd(this.value);
		});
		
		// 학과 초기화
		$("#crsCreCd").empty();
		$("#crsCreCd").dropdown("clear");
	}
	
	// 학과 변경
	function changeDeptCd(deptCd) {
		var uniCd = $("#uniCd").val();
		var html = '<option value=" "><spring:message code="common.all" /></option>'; // 전체
		
		CRS_CRE_LIST.forEach(function(v, i) {
			if(v.uniCd == uniCd && v.deptCd == deptCd) {
				var declsNo = v.declsNo;
				declsNo = '(' + declsNo + ')';
				
				html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
			}
		});
		
		$("#crsCreCd").html(html);
		$("#crsCreCd").dropdown("clear");
	}
	
	// 목록 조회
	function listPaging(pageIndex) {
		if(!$("#uniCd").val()) {
			var arguments = '<spring:message code="exam.label.org.type" />'; // 대학구분
			alert('<spring:message code="exam.alert.select" arguments="' + arguments + '" />'); // {0}을 선택하세요.
			return;
		}
		
		if(!$("#deptCd").val()) {
			var arguments = '<spring:message code="exam.label.dept" />'; // 학과
			alert('<spring:message code="exam.alert.select" arguments="' + arguments + '" />'); // {0}을 선택하세요.
			return;
		}
		
		if(!$("#crsCreCd").val()) {
			var arguments = '<spring:message code="common.subject" />'; // 과목
			alert('<spring:message code="exam.alert.select" arguments="' + arguments + '" />'); // {0}을 선택하세요.
			return;
		}
		
		var url = "/exam/examMgr/reExamStdListPaging.do";
		var param = {
			  pageIndex		: pageIndex
			, listScale			: $("#listScale").val()
			, haksaYear		: $("#haksaYear").val()
			, haksaTerm		: $("#haksaTerm").val()
		 	, uniCd				: $("#uniCd").val()
			, deptCd			: $("#deptCd").val()
			, crsCreCd			: $("#crsCreCd").val()
			, examStareTypeCd	: $("#examStareTypeCd").val()
			, apprStat			: $("#apprStat").val().trim()
			, userId			: $("#searchUserId").val()
			, userNm			: $("#searchUserId").val() ? '' : $("#searchUserNm").val()
			, tchNo				: $("#searchTchNo").val()
			, tchNm				: $("#searchTchNo").val() ? '' : $("#searchTchNm").val()
		};
		
		ajaxCall(url, param, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var pageInfo = data.pageInfo;
				var html = '';
				
				if(pageInfo.totalRecordCount == 0) {
					html += '<tr>';
					html += '	<td colspan="15">';
					html += '		<div class="none tc">';
					html += '			<span><spring:message code="common.content.not_found" /></span>';
					html += '		</div>';
					html += '	</td>';
					html += '</tr>';
				} else {
					returnList.forEach(function(v, i) {
						var examStartDttmFmt = (v.examStartDttm || "").length == 14 ? v.examStartDttm.substring(0, 4) + '.' + v.examStartDttm.substring(4, 6) + '.' + v.examStartDttm.substring(6, 8) + ' ' + v.examStartDttm.substring(8, 10) + ':' + v.examStartDttm.substring(10, 12) : v.examStartDttm;
						
						var uniNm = "-";
						
						if(v.uniCd == "C") {
							uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						} else if(v.uniCd == "G") {
							uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						}
						
						var examStareTypeNm = "-";
						
						if(v.examStareTypeCd == "M") {
							examStareTypeNm = '<spring:message code="exam.label.mid.exam" />'; // 중간고사
						} else if(v.examStareTypeCd == "L") {
							examStareTypeNm = '<spring:message code="exam.label.end.exam" />'; // 기말고사
						}
						
						var apprStat = "-";
						
						if(v.apprStat) {
							if(v.apprStat == "APPROVE") {
								apprStat = '<spring:message code="common.submission" />(<spring:message code="common.label.approve" />)'; // 제출(승인)
							} else if(v.apprStat == "COMPANION ") {
								apprStat = '<spring:message code="common.submission" />(<spring:message code="common.label.reject" />)'; // 제출(반려)
							} else {
								apprStat = '<spring:message code="common.submission" />(<spring:message code="common.label.request" />)'; // 제출(신청)
							}
						} else {
							apprStat = '<spring:message code="common.not.submission" />'; // 미제출
						}
						
						html += '<tr>';
						html += '	<td>' + (pageInfo.recordCountPerPage * (pageIndex - 1) + (i + 1)) + '</td>';
						html += '	<td>' + uniNm + '</td>';
						html += '	<td>' + examStareTypeNm + '</td>';
						html += '	<td>' + examStartDttmFmt + '</td>';
						html += '	<td>' + (v.examStareTm || '0') + '<spring:message code="exam.label.min.time" /></td>'; // 분
						html += '	<td>' + v.deptNm + '</td>';
						html += '	<td>' + v.userId + '</td>';
						html += '	<td>' + v.userNm + '</td>';
						html += '	<td>' + v.crsCd + '</td>';
						html += '	<td>' + v.crsCreDeptNm + '</td>';
						html += '	<td>' + v.declsNo + '</td>';
						html += '	<td>' + v.crsCreNm + '</td>';
						html += '	<td>' + apprStat + '</td>';
						html += '	<td>' + (v.tchNo || '-') + '</td>';
						html += '	<td>' + (v.tchNm || '-') + '</td>';
						html += '</tr>';
					});
				}
				
				$("#reExamConfigList").html(html);
				//$("#reExamConfigTable").footable();
				
				var params = {
   					totalCount : pageInfo.totalRecordCount,
   					listScale : pageInfo.recordCountPerPage,
   					currentPageNo : pageInfo.currentPageNo,
   					eventName : "listPaging"
   				};
    			
    			gfn_renderPaging(params);
	    			
				$("#totalCntText").text(pageInfo.totalRecordCount);
				
				SEARCH_OBJ = param;
				SEARCH_OBJ.userNm = $("#searchUserNm").val();
				SEARCH_OBJ.tchNm = $("#searchTchNm").val();
				
				// 조회조건 Text
				SEARCH_OBJ.haksaTermNm = $("#haksaTerm > option:selected")[0].innerText;
				SEARCH_OBJ.uniNm = SEARCH_OBJ.uniCd ? $("#uniCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
				SEARCH_OBJ.deptNm = SEARCH_OBJ.deptCd ? $("#deptCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
				SEARCH_OBJ.crsCreNm = SEARCH_OBJ.crsCreCd ? $("#crsCreCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
				SEARCH_OBJ.examStareTypeNm = $("#examStareTypeCd > option:selected")[0].innerText;
				SEARCH_OBJ.apprStatNm = SEARCH_OBJ.apprStat ? $("#apprStat > option:selected")[0].innerText : '<spring:message code="common.all" />';
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		}, true);
	}
	
	// 사용자 검색
	function selectUserList() {
		var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'goUrl', 	  'val' : ""});
		kvArr.push({'key' : 'subParam',   'val' : "searchUser|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : ""});
		
		submitForm("/user/userMgr/studentSearchListPop.do", "examPopIfm", "stdSearch", kvArr);
	}
	
	// 교직원 검색
    function selectProfessorList() {
    	var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'goUrl', 	  'val' : ""});
		kvArr.push({'key' : 'subParam',   'val' : "searchProfessor|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : ""});
		
		submitForm("/user/userMgr/professorSearchListPop.do", "examPopIfm", "profSearch", kvArr);
    }
	
	// 재시험 등록관리 팝업
	function reExamConfigPop() {
		var kvArr = [];
		//kvArr.push({'key' : 'userId', 	  'val' : ""});
		submitForm("/exam/examMgr/reExamConfigPop.do", "examPopIfm", "reExamConfig", kvArr);
	}
	
	// 엑셀 다운로드
	function downExcel() {
		if(!SEARCH_OBJ) {
			alert('<spring:message code="exam.alert.please.search" />'); // 검색 후 이용할 수 있습니다.
			return;
		}
		
	    var excelGrid = {
		    colModel:[
		        {label:'<spring:message code="main.common.number.no" />', name:'lineNo', align:'right', width:'1000'},// NO
		        {label:'<spring:message code="exam.label.org.type" />', name:'uniCd', align:'left', width:'3000', codes: {
		              'C': '<spring:message code="common.label.uni.college" />' // 대학교
		            , 'G': '<spring:message code="common.label.uni.graduate" />' // 대학원
		        }}, // 대학구분
		        {label:'<spring:message code="exam.label.exam.stare.type" />', name:'examStareTypeNm', align:'center', width:'3000'}, // 시험구분
		        {label:'<spring:message code="exam.label.exam.date" />', name:'examStartDttm', align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}}, // 시험일자
		        {label:'<spring:message code="exam.label.exam.time" />', name:'examStareTm', align:'left', width:'2500', suffix: '<spring:message code="exam.label.min.time" />'}, // 시험시간
		        {label:'<spring:message code="exam.label.dept" />', name:'deptNm', align:'left', width:'7000'}, // 학과
		        {label:'<spring:message code="exam.label.user.no" />', name:'userId', align:'center', width:'3000'}, // 학번
		        {label:'<spring:message code="exam.label.user.nm" />', name:'userNm', align:'left', width:'5000'}, // 이름
		        {label:'<spring:message code="crs.label.crs.cd" />', name:'crsCd', align:'center', width:'3000'}, // 학수번호
		        {label:"<spring:message code="exam.label.crs.dept" />", name:'crsCreDeptNm', align:'left', width:'7000'}, // 관장학과
		        {label:'<spring:message code="crs.label.decls" />', name:'declsNo', align:'center', width:'2500'}, // 분반
		        {label:'<spring:message code="crs.label.crecrs.nm" />', name:'crsCreNm', align:'left', width:'7000'}, // 과목명
		        {label:'<spring:message code="exam.label.exam.absent.submit.status" />', name:'apprStat', align:'left', width:'3000', codes: {
		              'APPROVE': '<spring:message code="common.submission" />(<spring:message code="common.label.approve" />)' // 제출(승인)
		            , 'COMPANION': '<spring:message code="common.submission" />(<spring:message code="common.label.reject" />)' // 제출(반려)
		            , 'APPLICATE': '<spring:message code="common.submission" />(<spring:message code="common.label.request" />)' // 제출(신청)
		            , 'REAPPLICATE': '<spring:message code="common.submission" />(<spring:message code="common.label.request" />)' // 제출(신청)
		            , '': '<spring:message code="common.not.submission" />' // 미제출
		        }
		        }, // 결시원 제출상태
		        {label:'<spring:message code="exam.label.tch" /><spring:message code="exam.label.tch.no" />', name:'tchNo', align:'center', width:'3000'}, // 교수사번
		        {label:'<spring:message code="exam.label.tch.nm" />', name:'tchNm', align:'left', width:'5000'}, // 교수명
			]
		};
		
		var url  = "/exam/examMgr/downExcelReExamStdList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		// 검색조건
		form.append($('<input/>', {type: 'hidden', name: 'haksaYear',		value: SEARCH_OBJ.haksaYear}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaTerm',		value: SEARCH_OBJ.haksaTerm}));
		form.append($('<input/>', {type: 'hidden', name: 'uniCd',			value: SEARCH_OBJ.uniCd}));
		form.append($('<input/>', {type: 'hidden', name: 'deptCd',			value: SEARCH_OBJ.deptCd}));
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',		value: SEARCH_OBJ.crsCreCd}));
		form.append($('<input/>', {type: 'hidden', name: 'examStareTypeCd',	value: SEARCH_OBJ.examStareTypeCd}));
		form.append($('<input/>', {type: 'hidden', name: 'apprStat',		value: SEARCH_OBJ.apprStat}));
		// 검색조건2
		form.append($('<input/>', {type: 'hidden', name: 'userId',			value: SEARCH_OBJ.userId}));
		form.append($('<input/>', {type: 'hidden', name: 'tchNo',			value: SEARCH_OBJ.tchNo}));
		
		// 검색조건 Text
		form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',		value: SEARCH_OBJ.haksaTermNm}));
		form.append($('<input/>', {type: 'hidden', name: 'uniNm',			value: SEARCH_OBJ.uniNm}));
		form.append($('<input/>', {type: 'hidden', name: 'deptNm',			value: SEARCH_OBJ.deptNm}));
		form.append($('<input/>', {type: 'hidden', name: 'crsCreNm',		value: SEARCH_OBJ.crsCreNm}));
		form.append($('<input/>', {type: 'hidden', name: 'examStareTypeNm',	value: SEARCH_OBJ.examStareTypeNm}));
		form.append($('<input/>', {type: 'hidden', name: 'apprStatNm',		value: SEARCH_OBJ.apprStatNm}));
		// 검색조건2 Text
		form.append($('<input/>', {type: 'hidden', name: 'userNm',			value: SEARCH_OBJ.userNm}));
		form.append($('<input/>', {type: 'hidden', name: 'tchNm',			value: SEARCH_OBJ.tchNm}));
		
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',		value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
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
                <div id="info-item-box">
                	<h2 class="page-title flex-item">
					    <spring:message code="exam.label.study" /><!-- 수업 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="exam.label.re.exam.config.list" /><!-- 미응시자 재시험설정 --></small>
					    </div>
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<div class="option-content gap4">
						<select class="ui dropdown mr5" id="haksaYear" onchange="changeTerm()">
	                   		<c:forEach var="item" begin="${termVO.haksaYear - 2}" end="${termVO.haksaYear + 2}" step="1">
								<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
							</c:forEach>
	                   	</select>
	                   	<select class="ui dropdown mr5" id="haksaTerm" onchange="changeTerm()">
	                   		<option value=""><spring:message code="exam.label.term" /><!-- 학기 --></option>
							<c:forEach var="item" items="${haksaTermList}">
								<option value="${item.codeCd}" ${item.codeCd eq termVO.haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
							</c:forEach>
	                   	</select>
                    	<select class="ui dropdown mr5" id="uniCd">
                    		<option value=""><spring:message code="exam.label.org.type" /><!-- 대학구분 --></option>
                    		<option value="C"><spring:message code="common.label.uni.college" /><!-- 대학교 --></option>
                    		<option value="G"><spring:message code="common.label.uni.graduate" /><!-- 대학원 --></option>
                    	</select>
                    	<select class="ui dropdown mr5 w250" id="deptCd">
                    		<option value=""><spring:message code="exam.label.crs.dept" /><!-- 관장학과 --></option>
                    	</select>
                    	<select class="ui dropdown mr5 w250" id="crsCreCd">
                    		<option value=""><spring:message code="common.subject" /><!-- 과목 --></option>
                    	</select>
                    	<select class="ui dropdown mr5" id="examStareTypeCd">
                    		<option value="M"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></option>
                    		<option value="L"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></option>
                    	</select>
                    	<select class="ui dropdown" id="apprStat">
                    		<option value=""><spring:message code="exam.label.exam.absent.submit.status" /><!-- 결시원 제출상태 --></option>
                    		<option value=" "><spring:message code="common.all" /><!-- 전체 --></option>
                    		<option value="APPROVE"><spring:message code="common.submission" /><!-- 제출 -->(<spring:message code="common.label.approve" />)<!-- 승인 --></option>
                    		<option value="COMPANION"><spring:message code="common.submission" /><!-- 제출 -->(<spring:message code="common.label.reject" />)<!-- 반려 --></option>
                    		<option value="APPLICATE"><spring:message code="common.submission" /><!-- 제출 -->(<spring:message code="common.label.request" />)<!-- 신청 --></option>
                    		<option value="NOAPPLICATE"><spring:message code="common.not.submission" /><!-- 미제출 --></option>
                    	</select>
					</div>
					<div class="ui segment searchArea">
	                	<div class="fields">
	                		<div class="ui action input search-box" id="searchUser">
								<input type="text" id="searchUserId" name="userId" placeholder="<spring:message code='exam.label.user.no' />" readonly="readonly" class="w150 ml10 bcLgrey" /><!-- 학번 -->
						        <input type="text" id="searchUserNm" name="userNm" placeholder="<spring:message code='exam.label.user.nm' />" class="w100 bcLgrey" autocomplete="off" oninput="$('#searchUserId').val('')" /><!-- 이름 -->
							    <button type="button" class="ui icon button" onclick="selectUserList()"><i class="search icon"></i></button>
							</div>
							<div class="ui action input search-box" id="searchProfessor">
								<input type="text" id="searchTchNo" name="userId" placeholder="<spring:message code='exam.label.tch' />" readonly="readonly" class="w150 ml10 bcLgrey" /><!-- 교수 -->
						        <input type="text" id="searchTchNm" name="userNm" placeholder="<spring:message code='exam.label.user.nm' />" class="w100 bcLgrey" autocomplete="off" oninput="$('#searchTchNo').val('')" /><!-- 이름 -->
							    <button type="button" class="ui icon button" onclick="selectProfessorList()"><i class="search icon"></i></button>
							</div>
	                	</div>
	                	<div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="listPaging(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
	                </div>
	   				<div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code="exam.label.re.exam.user.status" /><!-- 시험 미응시자 현황 --></h3>
	   					<span class="pl10">[ <spring:message code="exam.label.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	   					<div class="mla">
	   						<a class="ui orange button" href="javascript:reExamConfigPop()"><spring:message code="exam.button.re.exam.config" /><!-- 재시험 등록관리 --></a>
	   						<a class="ui green button" href="javascript:downExcel()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
	   						<select class="ui dropdown list-num" id="listScale">
					            <option value="10">10</option>
					            <option value="20">20</option>
					            <option value="50">50</option>
					            <option value="100">100</option>
					        </select>
	   					</div>
	   				</div>
					<table class="tBasic" data-empty="<spring:message code='exam.common.empty' />" id="reExamConfigTable"><!-- 등록된 내용이 없습니다. -->
	  					<thead>
		    				<tr>
		    					<th class="tc p_w3"><spring:message code="main.common.number.no" /><!-- NO --></th>
		    					<th class="tc p_w5" data-breakpoints="xs sm"><spring:message code="exam.label.org.type" /><!-- 대학구분 --></th>
		    					<th class="tc p_w10" data-breakpoints="xs sm"><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></th>
		    					<th class="tc p_w15" data-breakpoints="xs sm"><spring:message code="exam.label.exam.date" /><!-- 시험일자 --></th>
		    					<th class="tc p_w10" data-breakpoints="xs sm"><spring:message code="exam.label.exam.time" /><!-- 시험시간 --></th>
		    					<th class="tc p_w10" data-breakpoints="xs sm"><spring:message code="exam.label.user.dept" /><!-- 소속학과 --></th>
		    					<th class="tc p_w10"><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
		    					<th class="tc p_w10"><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
		    					<th class="tc p_w15" data-breakpoints="xs sm"><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
								<th class="tc p_w10" data-breakpoints="xs sm"><spring:message code="exam.label.crs.dept" /><!-- 관장학과 --></th>
		    					<th class="tc p_w3" data-breakpoints="xs sm"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
		    					<th class="tc p_w15" data-breakpoints="xs sm"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
		    					<th class="tc p_w0" data-breakpoints="xs sm"><spring:message code="exam.label.exam.absent.submit.status" /><!-- 결시원 제출상태 --></th>
		    					<th class="tc p_w10" data-breakpoints="xs sm"><spring:message code="exam.label.tch" /><!-- 교수 --><spring:message code="exam.label.tch.no" /><!-- 사번 --></th>
		    					<th class="tc p_w10" data-breakpoints="xs sm"><spring:message code="exam.label.tch.nm" /><!-- 교수명 --></th>
		    				</tr>
		    			</thead>
		    			<tbody id="reExamConfigList">
		    				<tr>
								<td colspan="15">
									<div class="none tc">
										<span><spring:message code="common.content.not_found" /></span>
									</div>
								</td>
							</tr>
		    			</tbody>
	  				</table>
	  				<div id="paging" class="paging mt20"></div>
	  				<!-- //콘텐츠 영역 -->
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