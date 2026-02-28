<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<script type="text/javascript">
	var USER_DEPT_LIST = [];
	var CRS_CRE_LIST;
	var TERM_LESSON_LIST;
	var SEARCH_OBJ; // 검색조건 저장

	$(document).ready(function() {
		// 부서정보
		<c:forEach var="item" items="${deptList}">
			USER_DEPT_LIST.push({
				  deptCd: '<c:out value="${item.deptCd}" />'
				, deptNm: '<c:out value="${item.deptNm}" />'
				, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
			});
		</c:forEach>
		
		USER_DEPT_LIST.sort(function(a, b) {
			if(a.deptCdOdr < b.deptCdOdr) return -1;
			if(a.deptCdOdr > b.deptCdOdr) return 1;
			if(a.deptCdOdr == b.deptCdOdr) {
				if(a.deptNm < b.deptNm) return -1;
				if(a.deptNm > b.deptNm) return 1;
			}
			return 0;
		});
		
		changeTerm(); // 학기 변경
	});
	
	// 과목 목록 조회
	function getCrsCreList() {
		var url = "/crs/creCrsHome/listCrsCreDropdown.do";
		var data = {
			  creYear	: $("#haksaYear").val()
			, creTerm	: $("#haksaTerm").val()
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
	
	// 학기 변경
	function changeTerm() {
		$("#univGbn").off("change");
		$("#univGbn").dropdown("clear");
		
		$("#deptCd").dropdown("clear");
		
		getCrsCreList(); // 과목 목록 조회
		
		var url = "/crs/termHome/listTermLessonByHaksa.do";
		var data = {
			  haksaYear	: $("#haksaYear").val()
			, haksaTerm	: $("#haksaTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				TERM_LESSON_LIST = returnList;
				
				list();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		}, true);
	}
	
	// 대학 구분 변경
	function changeUnivGbn(univGbn) {
		var deptCdObj = {};
		
		CRS_CRE_LIST.forEach(function(v, i) {
			if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
				deptCdObj[v.deptCd] = true;
			}
		});
		
		var html = '';
		html += '<option value="ALL"><spring:message code="common.all" /></option>'; // 전체
		USER_DEPT_LIST.forEach(function(v, i) {
			if(deptCdObj[v.deptCd]) {
				html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
			}
		});
		
		// 부서 초기화
		$("#deptCd").html(html);
		$("#deptCd").dropdown("clear");
	}
	
	// 목록조회
	function list() {
		var maxLsnOdr;
		var tableHtml = '';
		
		tableHtml += '<thead class="sticky top0">';
		tableHtml += '	<tr>';
		tableHtml += '		<th scope="col" data-sortable="false" class="chk tc" rowspan="2">';
		tableHtml += '			<div class="ui checkbox">';
		tableHtml += '				<input type="checkbox" onchange="checkAll(this.checked)"  />';
		tableHtml += '			</div>';
		tableHtml += '		</th>';
		tableHtml += '		<th class="tc" rowspan="2">No</th>';
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="score.label.univ.gbn1" /></th>';	// 계열/대학원
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="common.dept_name" /></th>';	// 학과
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="score.label.crs.cd" /></th>';	// 학수번호
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="score.label.crs.cre.nm" /></th>';	// 과목명
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="common.label.decls.no" /></th>';// 분반
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="score.label.rep.professor" /><br /><spring:message code="score.label.hr.no" /></th>';	// // 교수인사번호
		tableHtml += '		<th class="tc" rowspan="2"><spring:message code="common.professor" /></th>'; // 교수
		TERM_LESSON_LIST.forEach(function(v, j) {
			tableHtml += '	<th class="tc" colspan="2">' + v.lsnOdr + '<spring:message code="common.week" /></th>';// 주차
		
			maxLsnOdr = v.lsnOdr;
		});
		tableHtml += '		<th class="tc" colspan="3">1~' + maxLsnOdr + '<spring:message code="score.label.week.sum" /></th>'; // 주차 합계
		tableHtml += '		<th class="tc" rowspan="2">1~' + maxLsnOdr + '<spring:message code="score.label.week.minus.cnt" /></th>'; // 주차 벌점횟수
		tableHtml += '	</tr>';
		tableHtml += '	<tr>';
		TERM_LESSON_LIST.forEach(function(v, j) {
			tableHtml += '	<th class="tc" style="min-width: 70px"><spring:message code="score.label.plus.score" /></th>'; // 상점
			tableHtml += '	<th class="tc" style="min-width: 70px"><spring:message code="score.label.minus.score" /></th>'; // 벌점
		});
		tableHtml += '		<th class="tc" style="min-width: 70px"><spring:message code="score.label.plus.score" /></th>'; // 상점
		tableHtml += '		<th class="tc" style="min-width: 70px"><spring:message code="score.label.minus.score" /></th>'; // 벌점
		tableHtml += '		<th class="tc" style="min-width: 70px"><spring:message code="common.label.total.point" /></th>';// 총점
		tableHtml += '	</tr>';
		tableHtml += '	</thead>';
		tableHtml += '	<tbody id="operateScoreList"></tbody>';
		
		$("#operateScoreTable").empty().html(tableHtml);
		
		var url = "/score/scoreMgr/listOprScoreProfTotal.do";
		var param = {
			  haksaYear		: $("#haksaYear").val()
			, haksaTerm		: $("#haksaTerm").val()
			, univGbn		: ($("#univGbn").val() || "").replace("ALL", "")
			, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
			, searchValue 	: $("#searchValue").val()
			, userId		: $("#searchTchNo").val()
			, userNm		: $("#searchTchNm").val()
			, penaltyYn		: $("#penaltyYn").is(":checked") ? "Y" : "N"
		};
		
		ajaxCall(url, param, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				
				returnList.forEach(function(v, i) {
					html += '<tr>';
					html += '	<td>';
					html += '		<div class="ui checkbox">';
					html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" data-crs-cre-cd="' + v.crsCreCd + '" data-user-nm="' + v.userNm + '" data-email="' + v.email + '" data-mobile-no="' + v.mobileNo + '" />';
					html += '		</div>';
					html += '	</td>';
					html += '	<td>' + v.lineNo + '</td>';
					html += '	<td>' + v.univGbnNm + '</td>';
					html += '	<td>' + (v.deptNm || '-') + '</td>';
					html += '	<td class="tc">' + v.crsCd + '</td>';
					html += '	<td>' + v.crsCreNm + '</td>';
					html += '	<td class="tc">' + v.declsNo + '</td>';
					html += '	<td class="tc">' + v.userId + '</td>';
					html += '	<td>' + v.userNm + '</td>';
					TERM_LESSON_LIST.forEach(function(vv, j) {
						html += '<td class="tc"><a href="javascript:profOperateEvalWriteModal(\'' + v.crsCreCd + '\', \'' + v["lessonScheduleId" + vv.lsnOdr] + '\', \'' + v.userId + '\')" class="fcBlue">' + (typeof v["plusScore" + vv.lsnOdr] === "undefined" || v["plusScore" + vv.lsnOdr] === null ? '-' : v["plusScore" + vv.lsnOdr]) + '</a></td>';
						html += '<td class="tc"><a href="javascript:profOperateEvalWriteModal(\'' + v.crsCreCd + '\', \'' + v["lessonScheduleId" + vv.lsnOdr] + '\', \'' + v.userId + '\')" class="fcBlue">' + (typeof v["minusScore" + vv.lsnOdr] === "undefined" || v["plusScore" + vv.lsnOdr] === null ? '-' : v["minusScore" + vv.lsnOdr]) + '</a></td>';
					});
					html += '	<td class="tc"><a href="javascript:profOperateEvalTotalModal(\'' + v.crsCreCd + '\', \'' + v.userId + '\')" class="fcBlue">' + (typeof v.plusScore === "undefined" ? '-' : v.plusScore) + '</a></td>';
					html += '	<td class="tc"><a href="javascript:profOperateEvalTotalModal(\'' + v.crsCreCd + '\', \'' + v.userId + '\')" class="fcRed">' + (typeof v.minusScore === "undefined" ? '-' : v.minusScore) + '</a></td>';
					html += '	<td class="tc">' + (typeof v.totScore === "undefined" ? '-' : v.totScore) + '</td>';
					html += '	<td class="tc"><span class="fcRed">' + v.minusCnt + '<spring:message code="message.number" /></span></td>';	// 회
					html += '</tr>';
				});
				
				$("#operateScoreList").html(html);
				// $("#operateScoreTable").footable();
				$("#operateScoreTable").find(".ui.checkbox").checkbox();
				
				// 종건수 세팅
				$("#totalCntText").text(returnList.length);
				
				SEARCH_OBJ = param;
				
				// 조회조건 Text
				SEARCH_OBJ.haksaTermNm = $("#haksaTerm > option:selected")[0].innerText;
				SEARCH_OBJ.uniNm = SEARCH_OBJ.univGbn ? $("#univGbn > option:selected")[0].innerText : '<spring:message code="common.all" />';
				SEARCH_OBJ.deptNm = SEARCH_OBJ.deptCd ? $("#deptCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
        	} else {
        		alert(data.message);
        		$("#operateScoreList").html("");
				$("#totalCntText").text("0");
        	}
		}, function(xhr, status, error) {
			 /* 에러가 발생했습니다!*/
			alert('<spring:message code="fail.common.msg" />');
			$("#operateScoreList").html("");
			$("#totalCntText").text("0");
		}, true);
	}
	
	// 교수 수업운영 평가등록 모달
	function profOperateEvalWriteModal(crsCreCd, lessonScheduleId, userId) {
		$("#oprProfWriteForm > input[name='crsCreCd']").val(crsCreCd);
		$("#oprProfWriteForm > input[name='lessonScheduleId']").val(lessonScheduleId);
		$("#oprProfWriteForm > input[name='userId']").val(userId);
		$("#oprProfWriteForm").attr("target", "oprProfWriteIfm");
        $("#oprProfWriteForm").attr("action", "/score/scoreMgr/oprScoreProfWritePop.do");
        $("#oprProfWriteForm").submit();
        $('#oprProfWriteModal').modal('show');
        
        $("#oprProfWriteForm > input[name='crsCreCd']").val("");
        $("#oprProfWriteForm > input[name='lessonScheduleId']").val("");
		$("#oprProfWriteForm > input[name='userId']").val("");
	}
	
	// 교수 수업운영 평가등록 모달(전체보기)
	function profOperateEvalTotalModal(crsCreCd, userId) {
		$("#oprProfWriteForm > input[name='crsCreCd']").val(crsCreCd);
		$("#oprProfWriteForm > input[name='userId']").val(userId);
		$("#oprProfWriteForm").attr("target", "oprProfWriteIfm");
        $("#oprProfWriteForm").attr("action", "/score/scoreMgr/oprScoreProfWritePop.do");
        $("#oprProfWriteForm").submit();
        $('#oprProfWriteModal').modal('show');
        
        $("#oprProfWriteForm > input[name='crsCreCd']").val("");
        $("#oprProfWriteForm > input[name='lessonScheduleId']").val("");
		$("#oprProfWriteForm > input[name='userId']").val("");
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
	
    if(window.addEventListener) {
		window.addEventListener("message", receiveMessage, false);
	} else {
		if(window.attachEvent) {
			window.attachEvent("onmessage", receiveMessage);
		}
	}
    
    function receiveMessage(event) {
		var data = event.data;
		if(data.type == "close") {
			closeModal();
		} else if(data.type == "search") {
			$("#searchProfessor input[name=userId]").val(data.userId);
			$("#searchProfessor input[name=userNm]").val(data.userNm);
		}
	}
	
 	// 전체선택
   	function checkAll(checked) {
		$("#operateScoreTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
	}
 	
 	// 교수 수업운영 평가 등록 팝업 콜백
 	function oprScoreProfWritePopCallback() {
 		list();
 	}
 	
 	// 엑셀 다운로드
	function downExcel() {
		var maxLsnOdr;
		var excelGrid = {
		    colModel:[
	            {label:'<spring:message code="common.number.no" />', name:'lineNo', align:'right', width:'1000'},	
	            {label:'<spring:message code="score.label.univ.gbn1" />', name:'univGbnNm', align:'left', width:'3500'},	// 계열/대학원
	            {label:'<spring:message code="common.dept_name" />',	 name:'deptNm', align:'left', width:'7000'},	// 학과
	            {label:'<spring:message code="score.label.crs.cd" />', name:'crsCd', align:'center', width:'2500'}, 	// 학수번호
	            {label:'<spring:message code="score.label.crs.cre.nm" />', name:'crsCreNm', align:'left', width:'7000'}, 	// 과목명
	            {label:'<spring:message code="common.label.decls.no" />', name:'declsNo', align:'center', width:'2500'}, 	// 분반
	            {label:'<spring:message code="score.label.rep.professor" /> <spring:message code="score.label.hr.no" />',  	name:'userId',   		align:'center',   	width:'5000'}, // 대표교수 인사번호
	            {label:'<spring:message code="common.professor" />', name:'userNm',   		align:'left',   	width:'5000'}, 	// 교수
            ]
		};
		
		TERM_LESSON_LIST.forEach(function(v, j) {
			var weekName = v.lsnOdr + '<spring:message code="common.week" /> '; // 주차
			maxLsnOdr = v.lsnOdr;
			
			excelGrid.colModel.push({label: weekName + '<spring:message code="score.label.plus.score" />',	name: "plusScore" + v.lsnOdr,   	align:'right',   	width:'2500', defaultValue:'-'})
			excelGrid.colModel.push({label: weekName + '<spring:message code="score.label.minus.score" />',	name: "minusScore" + v.lsnOdr,   	align:'right',   	width:'2500', defaultValue:'-'})
		});
		
		excelGrid.colModel.push({label: '<spring:message code="score.label.plus.score" />',		name: "plusScore",   	align:'right',   	width:'2500', defaultValue:'-'}) // 상점
		excelGrid.colModel.push({label: '<spring:message code="score.label.minus.score" />',	name: "minusScore",   	align:'right',   	width:'2500', defaultValue:'-'}) // 벌점
		excelGrid.colModel.push({label: '<spring:message code="common.label.total.point" />',	name: "totScore",   	align:'right',   	width:'2500', defaultValue:'-'}) // 총점
			
		excelGrid.colModel.push({label: '1~' + maxLsnOdr +  ' <spring:message code="score.label.week.minus.cnt" />',	name: "minusCnt", align:'right', width:'5000', defaultValue:'-'}) // 주차 벌점횟수
		
		
		var url  = "/score/scoreMgr/downExcelOprScoreProfTotal.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		
		form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: $("#haksaYear").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: $("#haksaTerm").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ.univGbn}));
		form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ.deptCd}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ.searchValue}));
		form.append($('<input/>', {type: 'hidden', name: 'userId', 		value: SEARCH_OBJ.userId}));
		form.append($('<input/>', {type: 'hidden', name: 'userNm', 		value: SEARCH_OBJ.userNm}));
		form.append($('<input/>', {type: 'hidden', name: 'penaltyYn', 	value: SEARCH_OBJ.penaltyYn}));
		// 검색조건 Text
		form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',	value: SEARCH_OBJ.haksaTermNm}));
		form.append($('<input/>', {type: 'hidden', name: 'uniNm',		value: SEARCH_OBJ.uniNm}));
		form.append($('<input/>', {type: 'hidden', name: 'deptNm',		value: SEARCH_OBJ.deptNm}));
		
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}
 	
	// 벌점원인 다운로드
	function minusReasonDownExcel() {
		var excelGrid = {
		    colModel:[
	            {label:'<spring:message code='common.number.no'/>',					name:'lineNo',		align:'right',	width:'1000'},	
	            {label:'<spring:message code="score.label.univ.gbn1" />', 			name:'univGbnNm', 	align:'left', 	width:'3500'},	// 계열/대학원
	            {label:'<spring:message code="common.dept_name" />',				name:'deptNm',		align:'left',	width:'7000'},	// 학과
	            {label:'<spring:message code="score.label.crs.cd" />',  			name:'crsCd',		align:'center',	width:'2500'}, 	// 학수번호
	            {label:'<spring:message code="score.label.crs.cre.nm" />',    		name:'crsCreNm',	align:'left',	width:'7000'}, 	// 과목명
	            {label:'<spring:message code="common.label.decls.no" />',  			name:'declsNo',   	align:'center',	width:'2500'}, 	// 분반
	            {label:'<spring:message code="score.label.rep.professor" /> <spring:message code="score.label.hr.no" />',	name:'userId',	align:'center',	width:'5000'}, // 대표교수 인사번호
	            {label:'<spring:message code="common.professor" />',  				name:'userNm',   	align:'left',	width:'5000'}, 	// 교수
            ]
		};
		
		TERM_LESSON_LIST.forEach(function(v, j) {
			excelGrid.colModel.push({label: v.lsnOdr + '<spring:message code="common.week" />',	name: "reason" + v.lsnOdr, align:'left', width:'5000'});
		});
			
		var url  = "/score/scoreMgr/downExcelOprScoreProfPanaltyReason.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		
		form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: $("#haksaYear").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: $("#haksaTerm").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ.univGbn}));
		form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ.deptCd}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ.searchValue}));
		form.append($('<input/>', {type: 'hidden', name: 'userId', 		value: SEARCH_OBJ.userId}));
		form.append($('<input/>', {type: 'hidden', name: 'userNm', 		value: SEARCH_OBJ.userNm}));
		// 검색조건 Text
		form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',	value: SEARCH_OBJ.haksaTermNm}));
		form.append($('<input/>', {type: 'hidden', name: 'uniNm',		value: SEARCH_OBJ.uniNm}));
		form.append($('<input/>', {type: 'hidden', name: 'deptNm',		value: SEARCH_OBJ.deptNm}));
		
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}
	
	// 교수별 통계 엑셀 다운로드
	function statusByProfDownExcel() {
		var excelGrid = {
			    colModel:[
		            {label:'<spring:message code='common.number.no'/>',					name:'lineNo',		align:'right',	width:'1000'},	
		            {label:'<spring:message code="score.label.univ.gbn1" />', 			name:'univGbnNm', 	align:'left', 	width:'3500'},	// 계열/대학원
		            {label:'<spring:message code="common.dept_name" />',				name:'deptNm',		align:'left',	width:'7000'},	// 학과
		            {label:'<spring:message code="score.label.rep.professor" /> <spring:message code="score.label.hr.no" />',	name:'userId',	align:'center',	width:'5000'}, // 대표교수 인사번호
		            {label:'<spring:message code="common.professor" />',  				name:'userNm',   	align:'left',	width:'5000'}, 	// 교수
		            {label:'<spring:message code="score.label.prof.oper.score01" />',	name:'score01',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score02" />',	name:'score02',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score03" />',	name:'score03',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score04" />',	name:'score04',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score05" />',	name:'score05',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score06" />',	name:'score06',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score07" />',	name:'score07',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score08" />',	name:'score08',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score09" />',	name:'score09',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score10" />',	name:'score10',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score14" />',	name:'score14',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score11" />',	name:'score11',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score12" />',	name:'score12',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.prof.oper.score13" />',	name:'score13',   	align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.plus.score" />',			name:'plusScore',   align:'right',	width:'5000'},
		            {label:'<spring:message code="score.label.minus.score" />',			name:'minusScore',	align:'right',	width:'5000'},
		            {label:'<spring:message code="common.label.total.point" />',		name:'totScore',   	align:'right',	width:'5000'},
	            ]
			};
				
			var url  = "/score/scoreMgr/downExcelOprScoreStatusByProf.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: $("#haksaYear").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: $("#haksaTerm").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ.univGbn}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ.searchValue}));
			form.append($('<input/>', {type: 'hidden', name: 'userId', 		value: SEARCH_OBJ.userId}));
			form.append($('<input/>', {type: 'hidden', name: 'userNm', 		value: SEARCH_OBJ.userNm}));
			// 검색조건 Text
			form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',	value: SEARCH_OBJ.haksaTermNm}));
			form.append($('<input/>', {type: 'hidden', name: 'uniNm',		value: SEARCH_OBJ.uniNm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptNm',		value: SEARCH_OBJ.deptNm}));
			
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
	}
 	
 	// 보내기
   	function sendMsg() {
   		var rcvUserInfoStr = "";
   		var sendCnt = 0;
   		var dupCheckObj = {};
   		
   		$.each($("#operateScoreTable").find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
   			if(dupCheckObj[this.value]) return true;
   			dupCheckObj[this.value] = true;
   			
   			var userId = this.value;
			var userNm = $(this).data("userNm");
			var mobileNo = $(this).data("mobileNo");
			var email = $(this).data("email");
			
			sendCnt++;
			
			if (sendCnt > 1)
				rcvUserInfoStr += "|";
			rcvUserInfoStr += userId;
			rcvUserInfoStr += ";" + userNm;
			rcvUserInfoStr += ";" + mobileNo;
			rcvUserInfoStr += ";" + email;
   		});
   		
   		if(sendCnt == 0) {
			alert('<spring:message code="std.alert.no_select_user" />'); // 선택된 사용자가 없습니다.
 			return;
		}
   		
   		var form = window.parent.alarmForm;
		form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
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
					    <spring:message code='score.label.lecture.oper.tool' /><!-- 수업운영도구 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code='score.label.prof.oper.total' /><!-- 수업운영 점수전체(교수) --></small>
					    </div>
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<div class="ui buttons mb10">
						<button type="button" class="ui blue button active"><spring:message code="common.label.semester.sys" /></button><!-- 학기제 -->
					</div>
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
					</div>
					<div class="ui segment searchArea">
						<select class="ui dropdown mr5" id="univGbn">
                    		<option value=""><spring:message code="exam.label.org.type" /><!-- 대학구분 --></option>
                    		<option value=" "><spring:message code="common.all" /><!-- 전체 --></option>
                    		<c:forEach var="item" items="${univGbnList}">
								<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
							</c:forEach>
                    	</select>
                    	<select class="ui dropdown mr5 w250" id="deptCd">
                    		<option value=""><spring:message code="common.dept_name" /><!-- 학과 --></option>
                    	</select>
                    	<div class="ui input">
							<input id="searchValue" type="text" placeholder="<spring:message code="socre.common.placeholder.oper.score" />" value="" class="w250" />
						</div>
						<div class="ui action input search-box" id="searchProfessor">
							<input type="text" id="searchTchNo" name="userId" placeholder="<spring:message code="score.label.hr.no" />" class="w150 ml10 bcLgrey" /><!-- 인사번호 -->
					        <input type="text" id="searchTchNm" name="userNm" placeholder="<spring:message code='common.name' />" class="w100 bcLgrey" autocomplete="off" oninput="$('#searchTchNo').val('')" /><!-- 이름 -->
						    <button type="button" class="ui icon button" onclick="selectProfessorList()"><i class="search icon"></i></button>
						</div>
						<div class="ui checkbox ml5">
                            <input type="checkbox" class="hidden" id="penaltyYn" />
                            <label><spring:message code="score.label.penalty.yn" /><!-- 벌점 발생 여부 --></label>
                        </div>
	                	<div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="list()"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
	                </div>
	   				<div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code='score.label.prof.oper.total' /><!-- 수업운영 점수전체(교수) --></h3>
	   					<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	   					<div class="mla">
	   						<a href="javascript:void(0)" class="ui basic button" onclick="sendMsg(1);return false;" title="메시지 보내기"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /><!-- 메시지 --></a>
	   						<a class="ui green button" href="javascript:downExcel()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
	   						<a class="ui green button" href="javascript:minusReasonDownExcel()"><spring:message code="score.label.panalty.reason" /> <spring:message code="exam.button.excel.down" /></a><!-- 벌점원인 엑셀 다운로드 -->
	   						<a class="ui green button" href="javascript:statusByProfDownExcel()"><spring:message code="score.label.status.by.prof" /> <spring:message code="exam.button.excel.down" /></a><!-- 교수별 통계 엑셀 다운로드 -->
	   					</div>
	   				</div>
	   				<div class="footable_box type2 max-height-550">
	   					<table class="tBasic" data-empty="<spring:message code='common.content.not_found' />" id="operateScoreTable"><!-- 등록된 내용이 없습니다. -->
		  					<%-- 
		  					<thead>
			    				<tr>
			    					<th scope="col" data-sortable="false" class="chk tc" rowspan="2">
			                            <div class="ui checkbox">
			                                <input type="checkbox" onchange="checkAll(this.checked)" />
			                            </div>
			                        </th>
			    					<th class="tc" rowspan="2">No</th>
			    					<th class="tc" rowspan="2"><spring:message code="common.dept_name" /><!-- 학과 --></th>
			    					<th class="tc" rowspan="2">학수번호<!-- 학수번호 --></th>
			    					<th class="tc" rowspan="2">과목명<!-- 과목명 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.label.decls.no" /><!-- 분반 --></th>
			    					<th class="tc" rowspan="2">대표교수<br />인사번호<!-- 인사번호 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.professor" /><!-- 교수 --></th>
			    					<c:forEach begin="1" end="15" var="num">
			    						<th class="tc" colspan="2">${num}<spring:message code="common.week" /><!-- 주차 --></th>
			    					</c:forEach>
			    					<th class="tc" colspan="3">1~15주차 합계</th>
			    					<th class="tc" rowspan="2">1~15주차 벌점횟수</th>
			    				</tr>
			    				<tr>
			    					<c:forEach begin="1" end="15" var="num">
			    						<th class="tc" style="min-width: 70px">상점</th>
				    					<th class="tc" style="min-width: 70px">벌점</th>
			    					</c:forEach>
			    					<th class="tc w50">상점</th>
			    					<th class="tc w50">벌점</th>
			    					<th class="tc w50"><spring:message code="common.label.total.point" /><!-- 총점 --></th>
			    				</tr>
			    			</thead>
			    			<tbody id="operateScoreList"></tbody>
			    			 --%>
		  				</table>
	  				</div>
	  				<!-- //콘텐츠 영역 -->
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
        </div>
        <!-- footer 영역 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    
    <!-- 교수 수업운영 평가기준 등록 팝업 -->
    <form id="oprProfWriteForm" name="oprProfWriteForm">
    	<input type="hidden" name="crsCreCd" value="" />
    	<input type="hidden" name="lessonScheduleId" value="" />
    	<input type="hidden" name="userId" value="" />
	</form>
    <div class="modal fade in" id="oprProfWriteModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code='score.label.prof.oper.criteria.write' /><!-- 교수 수업운영 평가기준 등록 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="oprProfWriteIfm" name="oprProfWriteIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>
</html>