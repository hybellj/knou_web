<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/score/common/score_common_inc.jsp" %>
<script type="text/javascript">
	var USER_DEPT_LIST = [];
	var CRS_CRE_LIST;
	var SEARCH_LIST;
	var SEARCH_OBJ; // 검색조건 저장
	var SORT_OBJ = {
		  score01: "ASC"
		, score02: "ASC"
		, score03: "ASC"
		, score04: "ASC"
		, score05: "ASC"
		, score06: "ASC"
		, score07: "ASC"
		, score08: "ASC"
		, score09: "ASC"
		, totalScore: "ASC"
	}; // 테이블 sort
	
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
		// 주차 초기화
		$("#lsnOdr").off("change");
		$("#lsnOdr").dropdown("clear");
		
		// 대학구분 초기화
		$("#univGbn").off("change");
		$("#univGbn").dropdown("clear");
		
		// 부서 초기화
		$("#deptCd").dropdown("clear");
		
		// 테이블 초기화
		$("#operateScoreList").html("");
		$("#totalCntText").text("0");
		
		var url = "/crs/termHome/listTermLessonByHaksa.do";
		var data = {
			  haksaYear	: $("#haksaYear").val()
			, haksaTerm	: $("#haksaTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				
				//html += '<option value="ALL"><spring:message code="common.all" /></option>'; // 전체
				returnList.forEach(function(v, i) {
					html += '<option value="' + v.lsnOdr + '">' + v.lsnOdr + '<spring:message code="common.week" /></option>';
				});
				
				$("#lsnOdr").html(html);
				$("#lsnOdr").dropdown("clear");
				$("#lsnOdr").on("change", function() {
					list();
				});
				
				getCrsCreList(); // 과목 목록 조회
				//list();
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
		var url = "/score/scoreMgr/listOprScoreAssistWrite.do";
		var param = {
			  haksaYear		: $("#haksaYear").val()
			, haksaTerm		: $("#haksaTerm").val()
			, lsnOdr		: ($("#lsnOdr").val() || "").replace("ALL", "")
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
					html += '<tr class="' + (v.delYn == "Y" ? "fcRed" : "") + '">';
					html += '	<td>';
					html += '		<div class="ui checkbox">';
					html += '			<input type="checkbox" id="checkbox_' + v.lineNo + '" name="userIds" value="' + v.userId + '" data-line-no="' + v.lineNo + '" data-lesson-schedule-id="' + v.lessonScheduleId + '" data-crs-cre-cd="' + v.crsCreCd + '" data-user-nm="' + v.userNm + '" data-email="' + v.email + '" data-mobile-no="' + v.mobileNo + '" />';
					html += '		</div>';
					html += '	</td>';
					html += '	<td>' + v.lineNo + '</td>';
					html += '	<td>' + v.univGbnNm + '</td>';
					html += '	<td data-dept-nm="' + (v.deptNm || "") + '">' + (v.deptNm || '-') + '</td>';
					html += '	<td class="tc">' + v.crsCd + '</td>';
					html += '	<td data-crs-cre-nm="' + (v.crsCreNm || "") + '">' + v.crsCreNm + '</td>';
					html += '	<td class="tc">' + v.declsNo + '</td>';
					html += '	<td class="tc">' + v.lsnOdr + '</td>';
					html += '	<td class="tc">' + v.userId + '</td>';
					html += '	<td>' + v.userNm + '</td>';
					html += '	<td><input type="text" class="tr" id="score03_' + v.lineNo + '" name="score03" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score03 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score04_' + v.lineNo + '" name="score04" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score04 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score05_' + v.lineNo + '" name="score05" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score05 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score06_' + v.lineNo + '" name="score06" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score06 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score07_' + v.lineNo + '" name="score07" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score07 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score08_' + v.lineNo + '" name="score08" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score08 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score09_' + v.lineNo + '" name="score09" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score09 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score01_' + v.lineNo + '" name="score01" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score01 + '" /></td>';
					html += '	<td><input type="text" class="tr" id="score02_' + v.lineNo + '" name="score02" oninput="this.value=scoreCommon.floatFormat(this.value, true, true, 3, 1)" onblur="scoreCommon.normalizeFloat(this); checkValidScore(this); sumTotScore(\'' + v.lineNo + '\'); autoCheck(\'' + v.lineNo + '\');" onfocus="this.select()" value="' + v.score02 + '" /></td>';
					html += '	<td class="tr w50"><span id="totScoreText_' + v.lineNo + '">' + v.totScore + '</span></td>';
					html += '</tr>';
				});
				
				$("#operateScoreList").html(html);
				//$("#operateScoreTable").footable();
				$("#operateScoreTable").find(".ui.checkbox").checkbox();
				
				// 종건수 세팅
				$("#totalCntText").text(returnList.length);
				
				SEARCH_LIST = returnList;
				SEARCH_OBJ = param;
				
				// 조회조건 Text
				SEARCH_OBJ.haksaTermNm = $("#haksaTerm > option:selected")[0].innerText;
				SEARCH_OBJ.lsnOdrNm = SEARCH_OBJ.lsnOdr ? $("#lsnOdr > option:selected")[0].innerText : '<spring:message code="common.all" />';
				SEARCH_OBJ.uniNm = SEARCH_OBJ.univGbn ? $("#univGbn > option:selected")[0].innerText : '<spring:message code="common.all" />';
				SEARCH_OBJ.deptNm = SEARCH_OBJ.deptCd ? $("#deptCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
        	
				$("#checkAll")[0].checked = false;
			} else {
        		alert(data.message);
        		$("#operateScoreList").html("");
				$("#totalCntText").text("0");
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			$("#operateScoreList").html("");
			$("#totalCntText").text("0");
		}, true);
	}
	
	// 조교 수업운영 평가기준 모달
	function oprScoreAssistCriteriaModal() {
		$("#oprScoreAssistCriteriaForm").attr("target", "oprScoreAssistCriteriaIfm");
        $("#oprScoreAssistCriteriaForm").attr("action", "/score/scoreMgr/oprScoreAssistCriteriaPop.do");
        $("#oprScoreAssistCriteriaForm").submit();
        $('#oprScoreAssistCriteriaModal').modal('show');
	}
	
	// 교직원 검색
    function selectProfessorList() {
    	var kvArr = [];
		kvArr.push({'key' : 'userId', 'val' : ""});
		kvArr.push({'key' : 'userNm', 'val' : ""});
		kvArr.push({'key' : 'goUrl', 'val' : ""});
		kvArr.push({'key' : 'subParam', 'val' : "searchProfessor|examPopIfm|examPop"});
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
 	
 	// 수정
 	function saveScore() {
		var dataList = [];
 		
 		$.each($("#operateScoreTable").find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
   			var lineNo = $(this).data("lineNo");
 			
 			var userId = this.value;
			var lessonScheduleId = $(this).data("lessonScheduleId");
			var crsCreCd = $(this).data("crsCreCd");
			
			var score01 = $("#score01_" + lineNo).val();
			var score02 = $("#score02_" + lineNo).val();
			var score03 = $("#score03_" + lineNo).val();
			var score04 = $("#score04_" + lineNo).val();
			var score05 = $("#score05_" + lineNo).val();
			var score06 = $("#score06_" + lineNo).val();
			var score07 = $("#score07_" + lineNo).val();
			var score08 = $("#score08_" + lineNo).val();
			var score09 = $("#score09_" + lineNo).val();
			
			dataList.push({
				  lineNo			: lineNo
				, lessonScheduleId	: lessonScheduleId
				, userId			: userId
				, crsCreCd			: crsCreCd
				, score01			: score01
				, score02			: score02
				, score03			: score03
				, score04			: score04
				, score05			: score05
				, score06			: score06
				, score07			: score07
				, score08			: score08
				, score09			: score09
			});
   		});
 		
 		if(dataList.length == 0) {
 			alert('<spring:message code="score.alert.no.select" />'); // 선택된 데이터가 없습니다.
 			return;
 		}
 		
 		var url = "/score/scoreMgr/saveOprScoreAssist.do";
		var data = JSON.stringify(dataList);
		
		$.ajax({
			url: url,
			type: "POST",
			contentType: "application/json",
			data: data,
			dataType: "json",
			beforeSend : function() {
				showLoading();
			},
			success: function(data) {
				if(data.result === 1) {
					alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
					setTimeout(function() {
						list();
					}, 0);
				} else {
					alert(data.message);
				}
			},
			error: function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			},
			complete: function() {
				hideLoading();
			},
		});
 	}
 	
 	// 삭제
	function deleteScore() {
		var dataList = [];
 		
 		$.each($("#operateScoreTable").find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
 			var userId = this.value;
			var lessonScheduleId = $(this).data("lessonScheduleId");
			var crsCreCd = $(this).data("crsCreCd");
		
			dataList.push({
				  lessonScheduleId	: lessonScheduleId
				, userId			: userId
				, crsCreCd			: crsCreCd
			});
   		});
 		
 		if(dataList.length == 0) {
 			alert('<spring:message code="score.alert.no.select" />'); // 선택된 데이터가 없습니다.
 			return;
 		}
 		
 		/* 선택된 데이터를 삭제하겠습니까?. */
 		if(!confirm('<spring:message code="score.confirm.select.delete" />')) return;
 		
 		var url = "/score/scoreMgr/deleteOprScoreAssist.do";
		var data = JSON.stringify(dataList);
		
		$.ajax({
			url: url,
			type: "POST",
			contentType: "application/json",
			data: data,
			dataType: "json",
			beforeSend : function() {
				showLoading();
			},
			success: function(data) {
				if(data.result === 1) {
					alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
					setTimeout(function() {
						list();
					}, 0);
				} else {
					alert(data.message);
				}
			},
			error: function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			},
			complete: function() {
				hideLoading();
			},
		});
 	}
 	
	// 입력할 수 있는 점수인지 체크
	function checkValidScore(el) {
		if(el.value == "") {
			el.value = 0;
			return;
		}
		
		var minusScore = {
			  score01: '<spring:message code="score.label.assist.oper.score01" />' // 주간운영 보고서
			, score02: '<spring:message code="score.label.assist.oper.score02" />' // 콘텐츠 검수
			, score03: '<spring:message code="score.label.assist.oper.score03" />' // 강의Q&A
			, score04: '<spring:message code="score.label.assist.oper.score04" />' // 1:1상담
		};
		
		var plusScore = {
			  score05: '<spring:message code="score.label.assist.oper.score05" />' // 강의자료실
			, score06: '<spring:message code="score.label.assist.oper.score06" />' // 메일발송
			, score07: '<spring:message code="score.label.assist.oper.score07" />' // SMS발송
			, score08: '<spring:message code="score.label.assist.oper.score08" />' // PUSH발송
			, score09: '<spring:message code="score.label.assist.oper.score09" />' // 쪽지발송
		};
		
		var name = el.name;
		
		if(minusScore[name] && 1 * el.value > 0) {
			alert("<spring:message code='score.errors.input.zero.minus' arguments='" + minusScore[name] + "'/>");
			el.value = 0;
			return;
		}
		
		if(plusScore[name] && 1 * el.value < 0) {
			alert("<spring:message code='score.errors.input.zero.plus' arguments='" + plusScore[name] + "'/>");
			el.value = 0;
			return;
		}
	}
	
	// 총점 계산
	function sumTotScore(lineNo) {
		var score01 = 1 * $("#score01_" + lineNo).val();
		var score02 = 1 * $("#score02_" + lineNo).val();
		var score03 = 1 * $("#score03_" + lineNo).val();
		var score04 = 1 * $("#score04_" + lineNo).val();
		var score05 = 1 * $("#score05_" + lineNo).val();
		var score06 = 1 * $("#score06_" + lineNo).val();
		var score07 = 1 * $("#score07_" + lineNo).val();
		var score08 = 1 * $("#score08_" + lineNo).val();
		var score09 = 1 * $("#score09_" + lineNo).val();
		
		var totScore = score01 + score02 + score03 + score04 + score05
			+ score06 + score07 + score08 + score09;
		
		$("#totScoreText_" + lineNo).text(totScore);
	}
	
	// 자동체크
	function autoCheck(lineNo) {
		var originObj = SEARCH_LIST[lineNo - 1];
		
		var isChanged = 1 * originObj.score01 != 1 * $("#score01_" + lineNo).val()
		|| 1 * originObj.score02 != 1 * $("#score02_" + lineNo).val()
		|| 1 * originObj.score03 != 1 * $("#score03_" + lineNo).val()
		|| 1 * originObj.score04 != 1 * $("#score04_" + lineNo).val()
		|| 1 * originObj.score05 != 1 * $("#score05_" + lineNo).val()
		|| 1 * originObj.score06 != 1 * $("#score06_" + lineNo).val()
		|| 1 * originObj.score07 != 1 * $("#score07_" + lineNo).val()
		|| 1 * originObj.score08 != 1 * $("#score08_" + lineNo).val()
		|| 1 * originObj.score09 != 1 * $("#score09_" + lineNo).val();
		
		
		if(isChanged) {
			$("#checkbox_" + lineNo).prop("checked", true);
		}
	}
	
	// 엑셀 다운로드
	function downExcel() {
		var excelGrid = {
		    colModel:[
	            {label:'<spring:message code="common.number.no"/>', name:'lineNo', align:'right', width:'1000'},	
	            {label:'<spring:message code="score.label.univ.gbn1" />', name:'univGbnNm', align:'left', width:'3500'},	// 계열/대학원
	            {label:'<spring:message code="common.dept_name" />', name:'deptNm', align:'left', width:'7000'},	// 학과
	            {label:'<spring:message code="score.label.crs.cd" />', name:'crsCd', align:'center', width:'2500'}, 	// 학수번호
	            {label:'<spring:message code="score.label.crs.cre.nm" />', name:'crsCreNm', align:'left', width:'7000'}, 	// 과목명
	            {label:'<spring:message code="common.label.decls.no" />', name:'declsNo', align:'center', width:'2500'}, 	// 분반
	            {label:'<spring:message code="common.week" />', name:'lsnOdr', align:'right', width:'2500'}, 	// 주차
	            {label:'<spring:message code="common.teaching.assistant" /><spring:message code="score.label.hr.no" />', name:'userId', align:'center', width:'5000'}, // 조교 인사번호
	            {label:'<spring:message code="common.teaching.assistant" />', 	name:'userNm', align:'left', width:'5000'}, 	// 조교
	            {label:'<spring:message code="score.label.assist.oper.score03" />', name:'score03', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score04" />', name:'score04', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score05" />', name:'score05', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score06" />', name:'score06', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score07" />', name:'score07', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score08" />', name:'score08', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score09" />', name:'score09', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score01" />', name:'score01', align:'right', width:'5000'},
	            {label:'<spring:message code="score.label.assist.oper.score02" />', name:'score02', align:'right', width:'5000'},
	            {label:'<spring:message code="common.label.total.point" />', name:'totScore', align:'right', width:'5000'},
            ]
		};
			
		var url  = "/score/scoreMgr/downExcelOprScoreAssistWrite.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		
		form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: $("#haksaYear").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: $("#haksaTerm").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'lsnOdr', 		value: $("#lsnOdr").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ.univGbn}));
		form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ.deptCd}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ.searchValue}));
		form.append($('<input/>', {type: 'hidden', name: 'userId', 		value: SEARCH_OBJ.userId}));
		form.append($('<input/>', {type: 'hidden', name: 'userNm', 		value: SEARCH_OBJ.userNm}));
		form.append($('<input/>', {type: 'hidden', name: 'penaltyYn', 	value: SEARCH_OBJ.penaltyYn}));
		// 검색조건 Text
		form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',	value: SEARCH_OBJ.haksaTermNm}));
		form.append($('<input/>', {type: 'hidden', name: 'lsnOdrNm',	value: SEARCH_OBJ.lsnOdrNm}));
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
			if (dupCheckObj[this.value])
				return true;
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

		if (sendCnt == 0) {
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
 	
	// 테이블 정렬
	function sortTable(col) {
		$.each(Object.keys(SORT_OBJ), function(i, key) {
			var order = SORT_OBJ[key];
			if(key == col) {
				SORT_OBJ[key] = (order == "ASC" ? "DESC" : "ASC");
			} else {
				SORT_OBJ[key] = "ASC";
			}
		});
		
		var $row = $("#operateScoreList").find('tr');
		
		$row.sort(function(a, b) {
			var aDeptNm = $(a).find('[data-dept-nm]').data("deptNm") || "";
			var aCrsCreNm = $(a).find('[data-crs-cre-nm]').data("crsCreNm") || "";
			
			var bDeptNm = $(b).find('[data-dept-nm]').data("deptNm") || "";
			var bCrsCreNm = $(b).find('[data-crs-cre-nm]').data("crsCreNm") || "";
			
			if(aDeptNm > bDeptNm) return 1;
			if(aDeptNm < bDeptNm) return -1;
			if(aDeptNm == bDeptNm) {
				if(aCrsCreNm > bCrsCreNm) return 1;
				if(aCrsCreNm < bCrsCreNm) return -1;
			}
			return 0;
		});
		
		$row.sort(function(a, b) {
			var $aInputList = $(a).find('td > input');
			var $bInputList = $(b).find('td > input');
			
			var aVal = 0;
			var bVal = 0;
			
			if(col == "totalScore") {
				$.each($aInputList, function() {
					aVal = aVal * 1 + (this.value || 0) * 1;
				});
				
				$.each($bInputList, function() {
					bVal = bVal * 1 + (this.value || 0) * 1;
				});
			} else {
				$.each($aInputList, function() {
					if(this.name == col) {
						aVal = this.value * 1;
					}
				});
				
				$.each($bInputList, function() {
					if(this.name == col) {
						bVal = this.value * 1;
					}
				});
			}
	
			if(SORT_OBJ[col] == "ASC") {
				if(aVal > bVal) return 1;
				if(aVal < bVal) return -1;
			} else {
				if(aVal > bVal) return -1;
				if(aVal < bVal) return 1;
			}
			return 0;
		});
		
		
		showLoading();
		setTimeout(function() {
			$("#operateScoreList").html('');
			$.each($row, function() {
				$("#operateScoreList").append(this);
			});
			$("#operateScoreTable").find(".ui.checkbox").checkbox();
			hideLoading();
		}, 0);
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
					        <small class="section"><spring:message code='score.label.assist.write' /><!-- 수업운영 점수등록(조교) --></small>
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
	                   	<select class="ui dropdown mr5" id="lsnOdr" onchange="">
	                   		<option value=""><spring:message code="common.week" /><!-- 주차 --></option>
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
							<input type="text" id="searchTchNo" name="userId" placeholder="<spring:message code="score.label.hr.no" />" class="w150 ml10 bcLgrey" /><!-- 교수 -->
					        <input type="text" id="searchTchNm" name="userNm" placeholder="<spring:message code='exam.label.user.nm' />" class="w100 bcLgrey" autocomplete="off" oninput="$('#searchTchNo').val('')" /><!-- 이름 -->
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
	   					<h3 class="sec_head"><spring:message code='score.label.assist.write' /><!-- 수업운영 점수등록(조교) --></h3>
	   					<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	   					<div class="mla">
	   						<a href="javascript:void(0)" class="ui basic button" onclick="sendMsg(1);return false;" title="메시지 보내기"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /><!-- 메시지 --></a>
	   						<a class="ui basic button" href="javascript:oprScoreAssistCriteriaModal()"><spring:message code='score.button.assist.oper.criteria.table' /><!-- 조교 수업운영 평가기준 안내표 --></a>
		   					<!-- <a class="ui basic button" href="javascript:"><span class="fcRed">점수 산정</span></a> -->
		   					<a class="ui black button" href="javascript:deleteScore()"><spring:message code="common.button.delete" /><!-- 삭제 --></a>
		   					<a class="ui blue button" href="javascript:saveScore()"><spring:message code="common.button.modify" /><!-- 수정 --></a>
	   						<a class="ui green button" href="javascript:downExcel()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
	   					</div>
	   				</div>
	   				<div class="footable_box type2 max-height-550">
	   					<table class="tBasic" data-empty="<spring:message code='common.content.not_found' />" id="operateScoreTable"><!-- 등록된 내용이 없습니다. -->
		  					<thead class="sticky top0">
			    				<tr>
			    					<th scope="col" data-sortable="false" class="chk tc" rowspan="2">
			                            <div class="ui checkbox">
			                                <input type="checkbox" id="checkAll" onchange="checkAll(this.checked)" />
			                            </div>
			                        </th>
			    					<th class="tc" rowspan="2"><spring:message code="common.number.no"/></th>
			    					<th class="tc" rowspan="2"><spring:message code="score.label.univ.gbn1" /><!-- 계열/대학원 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.dept_name" /><!-- 학과 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="score.label.crs.cd" /><!-- 학수번호 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="score.label.crs.cre.nm" /><!-- 과목명 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.label.decls.no" /><!-- 분반 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.week" /><!-- 주차 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.teaching.assistant" /><br /><spring:message code="score.label.hr.no" /><!-- 인사번호 --></th>
			    					<th class="tc" rowspan="2"><spring:message code="common.teaching.assistant" /><!-- 조교 --></th>
			    					<th class="tc" colspan="14"><spring:message code="score.label.assist.oper.score" /><!-- 수업운영점수 --></th>
			    				</tr>
			    				<tr>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score03" /><!-- 강의Q&A --><a href="javascript:sortTable('score03')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score04" /><!-- 1:1상담 --><a href="javascript:sortTable('score04')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score05" /><!-- 강의자료실 --><a href="javascript:sortTable('score05')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score06" /><!-- 메일발송 --><a href="javascript:sortTable('score06')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score07" /><!-- SMS발송 --><a href="javascript:sortTable('score07')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score08" /><!-- PUSH발송 --><a href="javascript:sortTable('score08')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score09" /><!-- 쪽지발송 --><a href="javascript:sortTable('score08')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score01" /><!-- 주간운영 보고서 --><a href="javascript:sortTable('score01')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w100"><spring:message code="score.label.assist.oper.score02" /><!-- 콘텐츠 검수 --><a href="javascript:sortTable('score02')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    					<th class="tc"><div class="w50"><spring:message code="common.label.total.point" /><!-- 총점 --><a href="javascript:sortTable('totalScore')"><i class="fooicon fooicon-sort"></i></a></div></th>
			    				</tr>
			    			</thead>
			    			<tbody id="operateScoreList">
			    			</tbody>
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
    
    <!-- 조교 수업운영 평가기준 팝업 -->
    <form id="oprScoreAssistCriteriaForm" name="oprScoreAssistCriteriaForm">
	</form>
    <div class="modal fade in" id="oprScoreAssistCriteriaModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="score.label.assist.oper.criteria"/><!-- 조교 수업운영 평가기준 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="oprScoreAssistCriteriaIfm" name="oprScoreAssistCriteriaIfm"></iframe>
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