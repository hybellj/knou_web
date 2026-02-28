<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		var SEARCH_OBJ; // 상단 검색조건
		var SEARCH_OBJ_2; // 탭2 검색조건
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
			
			USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					searchLessonProgress();
				}
			});
			
			// 학기변경
			changeTerm();
		});
		
		//학기 변경
		function changeTerm() {
			// 학기 과목정보 조회
			var url = "/crs/creCrsHome/listCrsCreDropdown.do";
			var data = {
				  creYear	: $("#haksaYear").val()
				, creTerm	: $("#haksaTerm").val()
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
					
					$("#univGbn").dropdown("clear");
					
					// 대학 구분 변경
					changeUnivGbn("ALL");
					
					$("#univGbn").off("change").on("change", function() {
						changeUnivGbn(this.value);
					});
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
			
			getLessonProgressTotalStatus();
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
			$("#deptCd").off("change");
			$("#deptCd").html(html);
			$("#deptCd").dropdown("clear");
			$("#deptCd").on("change", function() {
				changeDeptCd(this.value);
			});
			
			// 학수번호 초기화
			$("#crsCd").off("change");
			$("#crsCd").empty();
			$("#crsCd").dropdown("clear");
			$("#crsCd").on("change", function() {
				changeCrsCd(this.value);
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
			var crsCdObj = {};
			var crsCdHtml = '<option value="ALL"><spring:message code="common.crs.cd" /> <spring:message code="common.select" /></option>'; // 학수번호 선택
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
					
					if(!crsCdObj[v.crsCd] && (v.crsCd == "CHY164" || v.crsCd == "CHY165")) {
						crsCdObj[v.crsCd] = true;
						crsCdHtml += '<option value="' + v.crsCd + '">' + v.crsCreNm + '(' + v.crsCd + ')</option>';
					}
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
			
			// 학수번호
			$("#crsCd").off("change");
			$("#crsCd").html(crsCdHtml);
			$("#crsCd").dropdown("clear");
			$("#crsCd").on("change", function() {
				changeCrsCd(this.value);
			});
		}
		
		// 학수번호 변경
		function changeCrsCd(crsCd) {
			var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
			var deptCd = ($("#deptCd").val() || "").replace("ALL", "");
			var crsCd = (crsCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd) && (!crsCd || v.crsCd == crsCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
		}
		
		// 부서세팅
		function setDeptList() {
			var url = "/user/userHome/listByStdHaksaTerm.do";
			var data = {
				  haksaYear	: $("#haksaYear").val()
				, haksaTerm	: $("#haksaTerm").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					// 학과 세팅
					var html = '';
					html += '<option value="ALL"><spring:message code="std.label.select_dept" /></option>'; // 학과선택
					returnList.forEach(function(v, i) {
						html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
					});
					$("#deptCd").html(html);
					
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 학습진도관리 전체현황
		function getLessonProgressTotalStatus() {
			// 재학생수
			$("#stdCntTotal").text("-");
			$("#stdCntC").text("-");
			$("#stdCntG").text("-");
			
			// 미학습자수
			$("#nostudyCntTotal").text("-");
			$("#nostudyCntC").text("-");
			$("#nostudyCntG").text("-");
			
			// 평균학습진도
			$("#avgRateTotal").text("-");
			$("#avgRateC").text("-");
			$("#avgRateG").text("-");
			
			var url = "/lesson/lessonMgr/selectLessonProgressTotalStatus.do";
			var data = {
				  haksaYear	: $("#haksaYear").val()
				, haksaTerm	: $("#haksaTerm").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO || {};
					
					var stdCntTotal = returnVO.stdCntTotal;
					var stdCntC = returnVO.stdCntC;
					var stdCntG = returnVO.stdCntG;
					
					var nostudyCntTotal = returnVO.nostudyCntTotal;
					var nostudyCntC = returnVO.nostudyCntC;
					var nostudyCntG = returnVO.nostudyCntG;
					
					var avgRateTotal = returnVO.avgRateTotal;
					var avgRateC = returnVO.avgRateC;
					var avgRateG = returnVO.avgRateG;
					
					// 재학생수
					$("#stdCntTotal").text(stdCntTotal);
					$("#stdCntC").text(stdCntC);
					$("#stdCntG").text(stdCntG);
					
					// 미학습자수
					$("#nostudyCntTotal").text(nostudyCntTotal);
					$("#nostudyCntC").text(nostudyCntC);
					$("#nostudyCntG").text(nostudyCntG);
					
					// 평균학습진도
					$("#avgRateTotal").text(avgRateTotal);
					$("#avgRateC").text(avgRateC);
					$("#avgRateG").text(avgRateG);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 검색
		function searchLessonProgress() {
			//var checkSearchValue = ($("#deptCd").val() || "").replace("ALL", "") 
			//	|| $("#searchValue").val()
			//	|| $("#searchFrom").val()
			//	|| $("#searchTo").val()
			//	|| ($("#crsCreCd").val() || "").replace("ALL", "") 
			//	|| $("#nostudyAll").is(":checked");
			//
			//if(!checkSearchValue) {
			//	/* 검색조건을 선택 또는 입력하세요. */
			//	alert('<spring:message code="common.search.keyword.condition.input.msg" />');
			//	return;
			//}
			
			// 리스트 초기화
			tabTable1.clearData();
			tabTable2.clearData();
			$("#totalCntText1").html('');
			$("#totalCntText2").html('');
			
			$("#tableResultNone1").show();
			$("#tableResultNone2").show();
			
			// 탭2 검색조건 초기화
			SEARCH_OBJ_2 = null;
			
			// 미학습자 전체 체크된경우
			if($("#nostudy1").is(":checked")) {
				$("#searchFrom").val("");
				$("#searchTo").val("");
			}
			
			// 학습현황 목록
			listTab1();
			
			// 학습현황 목록 주차
			if($("#lessonScheduleOrder").val()) {
				listTab2()
			}
		}

		// 학습현황 목록
		function listTab1() {
			// 학기 과목정보 조회
			var url = "/lesson/lessonMgr/listLessonProgressStatus.do";
			var param = {
				  haksaYear		: $("#haksaYear").val()
				, haksaTerm		: $("#haksaTerm").val()
				, univGbn		: ($("#univGbn").val() || "").replace("ALL", "")
				, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
				, crsCd			: ($("#crsCd").val() || "").replace("ALL", "")
				, crsCreCd		: ($("#crsCreCd").val() || "").replace("ALL", "")
				, searchValue 	: $("#searchValue").val()
				, searchFrom	: $("#searchFrom").val()
				, searchTo		: $("#searchTo").val()
				, searchText	: $("#nostudy1").is(":checked") ? "0" : null
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					/* returnList.sort(function(a, b) {
						if(a.userNm < b.userNm) return -1;
						if(a.userNm > b.userNm) return 1;
						return 0;
					}); */
					
					var lineNo = 0;
					var dataList = [];
					
					returnList.forEach(function(v, i) {
						var modDttmFmt = (v.modDttm || "").length >= 12 ? v.modDttm.substring(0, 4) + '.' + v.modDttm.substring(4, 6) + '.' + v.modDttm.substring(6, 8) + ' ' + v.modDttm.substring(8, 10) + ':' + v.modDttm.substring(10, 12) : v.modDttm;
						
						/*
						var uniNm = "-";
						
						if(v.uniCd == "C") {
							uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						} else if(v.uniCd == "G") {
							uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						}
						*/
						dataList.push({
							univGbnNm: v.univGbnNm, 
							deptNm: v.deptNm, 
							userId: v.userId, 
							userNm: v.userNm+userInfoIcon("<%=SessionInfo.isKnou(request)%>","userInfoPop('"+v.userId+"')"),
							entrYy: (v.entrYy || '-'), 
							entrTmGbn: (v.entrTmGbn || '-'), 
							entrGbnNm: (v.entrGbnNm || '-'),
							hy: (v.hy || '-'), 
							crsCnt: v.crsCnt, 
							totWeekCnt: v.totWeekCnt, 
							cmplWeekCnt: v.cmplWeekCnt,
							progRatio: v.progRatio, 
							modDttm: modDttmFmt, 
							valUserNm: v.userNm, 
							valMobileNo: v.mobileNo, 
							valEmail:v.email
						});
					});
										
					tabTable1.addData(dataList);
					tabTable1.redraw();
					$("#totalCntText1").text(tabTable1.getDataCount());
					
					SEARCH_OBJ = param;
					
					// 조회조건 Text
					SEARCH_OBJ.haksaTermNm = $("#haksaTerm > option:selected")[0].innerText;
					SEARCH_OBJ.univGbnNm = SEARCH_OBJ.univGbn ? $("#univGbn > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ.deptNm = SEARCH_OBJ.deptCd ? $("#deptCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ.crsNm = SEARCH_OBJ.crsCd ? $("#crsCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ.crsCreNm = SEARCH_OBJ.crsCreCd ? $("#crsCreCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}

		
		// 엑셀 다운로드
		function downExcel1() {
			if(!SEARCH_OBJ) {
				alert('<spring:message code="lesson.alert.first.search" />'); // 먼저 검색을 하세요.
				return;
			}
			var excelGrid = {colModel:[]};
			excelGrid.colModel.push({label:'<spring:message code="common.number.no" />', name:'lineNo', align:'right', width:'1000'}); // NO
			excelGrid.colModel.push({label:'<spring:message code="common.type" />', name:'univGbnNm', align:'left', width:'3500'}); // 구분
			if(SEARCH_OBJ.crsCd) {
				excelGrid.colModel.push({label:'<spring:message code="lesson.label.crs.cre.nm" />', name:'crsCreNm', align:'left', width:'7000'}); // 과목명
				excelGrid.colModel.push({label:'<spring:message code="common.label.decls.no" />', name:'declsNo', align:'center', width:'2500'}); // 분반
			}
			excelGrid.colModel.push({label:'<spring:message code="common.dept_name" />', name:'deptNm', align:'left', width:'7000'}); // 학과
			excelGrid.colModel.push({label:'<spring:message code="common.label.student.number" />', name:'userId', align:'center', width:'5000'}); // 학번
			excelGrid.colModel.push({label:'<spring:message code="common.name" />', name:'userNm', align:'left', width:'5000'}); // 이름
			excelGrid.colModel.push({label:'<spring:message code="common.label.entrance" /> <spring:message code="lesson.label.year" />', name:'entrYy', align:'center', width:'2500'}); // 입학 년도
			excelGrid.colModel.push({label:'<spring:message code="common.label.entrance" /> <spring:message code="common.term" />', name:'entrTmGbn', align:'center', width:'2500'}); // 입학 학기
			excelGrid.colModel.push({label:'<spring:message code="common.label.entrance" /> <spring:message code="common.type" />', name:'entrGbnNm', align:'left', width:'5000'}); // 입학 구분
			excelGrid.colModel.push({label:'<spring:message code="common.label.userdept.grade" />', name:'hy', align:'center', width:'2500'}); // 학년
			excelGrid.colModel.push({label:'<spring:message code="lesson.lecture" /> <spring:message code="lesson.label.crs.cnt" />', name:'crsCnt', align:'right', width:'3000'}); // 수강 과목수
			excelGrid.colModel.push({label:'<spring:message code="lesson.label.open" /> <spring:message code="common.week" />', name:'totWeekCnt', align:'right', width:'3000'}); // 오픈 주차
			excelGrid.colModel.push({label:'<spring:message code="lesson.label.study" /> <spring:message code="common.week" />', name:'cmplWeekCnt', align:'right', width:'3000'}); // 학습 주차
			excelGrid.colModel.push({label:'<spring:message code="lesson.label.study.status.complete.yule" />', name:'progRatio', align:'right', width:'2500'}); // 출석율
			excelGrid.colModel.push({label:'<spring:message code="lesson.label.check.date" />', name:'modDttm', align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmm', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}});
			
			var url  = "/lesson/lessonMgr/downExcelLessonProgressStatus.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: SEARCH_OBJ.haksaYear}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: SEARCH_OBJ.haksaTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ.univGbn}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCd', 		value: SEARCH_OBJ.crsCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 	value: SEARCH_OBJ.crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ.searchValue}));
			// 검색조건 Text
			form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm', value: SEARCH_OBJ.haksaTermNm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbnNm', 	value: SEARCH_OBJ.univGbnNm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptNm', 		value: SEARCH_OBJ.deptNm}));
			form.append($('<input/>', {type: 'hidden', name: 'crsNm', 		value: SEARCH_OBJ.crsNm}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreNm', 	value: SEARCH_OBJ.crsCreNm}));
			// 탭1 검색조건
			form.append($('<input/>', {type: 'hidden', name: 'searchFrom', 	value: SEARCH_OBJ.searchFrom}));
			form.append($('<input/>', {type: 'hidden', name: 'searchTo', 	value: SEARCH_OBJ.searchTo}));
			form.append($('<input/>', {type: 'hidden', name: 'searchText', 	value: SEARCH_OBJ.searchText}));
			
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		/* TAB-2 */
		
		// 학습현황 목록
		function listTab2() {
			if(!$("#lessonScheduleOrder").val()) {
				alert('<spring:message code="lesson.alert.select.lesson.schedule" />'); // 주차를 선택하세요.
				return;
			}
			
			// 탭2 리스트 세팅
			setListTab2();
		}

		
		// 탭2 리스트 세팅
		function setListTab2() {
			// 학기 과목정보 조회
			var url = "/lesson/lessonMgr/listLessonProgressStatus.do";
			var param = {
				  haksaYear				: $("#haksaYear").val()
				, haksaTerm				: $("#haksaTerm").val()
				, univGbn				: ($("#univGbn").val() || "").replace("ALL", "")
				, deptCd				: ($("#deptCd").val() || "").replace("ALL", "")
				, crsCd					: ($("#crsCd").val() || "").replace("ALL", "")
				, crsCreCd				: ($("#crsCreCd").val() || "").replace("ALL", "")
				, searchValue 			: $("#searchValue").val()
				, searchText			: $("#nostudy2").is(":checked") ? "0" : null
				, lessonScheduleOrder	: $("#lessonScheduleOrder").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					var html = '';
					var lineNo = 0;
					var dataList = [];
					
					returnList.forEach(function(v, i) {
						var modDttmFmt = (v.modDttm || "").length >= 14 ? v.modDttm.substring(0, 4) + '.' + v.modDttm.substring(4, 6) + '.' + v.modDttm.substring(6, 8) + ' ' + v.modDttm.substring(8, 10) + ':' + v.modDttm.substring(10, 12) : v.modDttm;
						/*
						var uniNm = "-";
						
						if(v.uniCd == "C") {
							uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						} else if(v.uniCd == "G") {
							uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						}
						*/
						dataList.push({
							univGbnNm: v.univGbnNm, 
							deptNm: v.deptNm, 
							userId: v.userId, 
							userNm: v.userNm+userInfoIcon("<%=SessionInfo.isKnou(request)%>","userInfoPop('"+v.userId+"')"),
							entrYy: (v.entrYy || '-'), 
							entrTmGbn: (v.entrTmGbn || '-'), 
							entrGbnNm: (v.entrGbnNm || '-'),
							hy: (v.hy || '-'), 
							crsCnt: v.crsCnt, 
							underCrsCnt: v.under50CrsCnt, 
							modDttm: modDttmFmt, 
							valUserNm: v.userNm, 
							valMobileNo: v.mobileNo, 
							valEmail: v.email
						});
					});
					
					tabTable2.addData(dataList);
					tabTable2.redraw();
					$("#totalCntText2").text(tabTable2.getDataCount());
					
					SEARCH_OBJ_2 = param;
					
					// 조회조건 Text
					SEARCH_OBJ_2.haksaTermNm = $("#haksaTerm > option:selected")[0].innerText;
					SEARCH_OBJ_2.univGbnNm = SEARCH_OBJ_2.univGbn ? $("#univGbn > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ_2.deptNm = SEARCH_OBJ_2.deptCd ? $("#deptCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ_2.crsNm = SEARCH_OBJ_2.crsCd ? $("#crsCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ_2.crsCreNm = SEARCH_OBJ_2.crsCreCd ? $("#crsCreCd > option:selected")[0].innerText : '<spring:message code="common.all" />';
				} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 엑셀 다운로드
		function downExcel2() {
			if(!SEARCH_OBJ_2) {
				alert('<spring:message code="lesson.alert.select.lesson.schedule" />'); // 주차를 선택하세요.
				return;
			}
			
			var excelGrid = {colModel:[]};
			excelGrid.colModel.push({label:'No.', name:'lineNo', align:'right', width:'1000'});
			excelGrid.colModel.push({label:'<spring:message code="common.type" />', name:'univGbnNm', align:'left', width:'3500'}); // 구분
			if(SEARCH_OBJ_2.crsCd) {
				excelGrid.colModel.push({label:'<spring:message code="lesson.label.crs.cre.nm" />', name:'crsCreNm', align:'left', width:'7000'}); // 과목명
				excelGrid.colModel.push({label:'<spring:message code="common.label.decls.no" />', name:'declsNo', align:'center', width:'2500'}); // 분반
			}
			excelGrid.colModel.push({label:'<spring:message code="common.dept_name" />', name:'deptNm', align:'left', width:'7000'}); // 학과
			excelGrid.colModel.push({label:'<spring:message code="common.label.student.number" />', name:'userId', align:'center', width:'5000'}); // 학번
			excelGrid.colModel.push({label:'<spring:message code="common.name" />', name:'userNm', align:'left', width:'5000'}); // 이름
			excelGrid.colModel.push({label:'<spring:message code="common.label.entrance" /> <spring:message code="lesson.label.year" />', name:'entrYy', align:'center', width:'2500'}); // 입학 년도
			excelGrid.colModel.push({label:'<spring:message code="common.label.entrance" /> <spring:message code="common.term" />', name:'entrTmGbn', align:'center', width:'2500'}); // 입학 학기
			excelGrid.colModel.push({label:'<spring:message code="common.label.entrance" /> <spring:message code="common.type" />', name:'entrGbnNm', align:'left', width:'5000'}); // 입학 구분
			excelGrid.colModel.push({label:'<spring:message code="common.label.userdept.grade" />', name:'hy', align:'center', width:'2500'}); // 학년
			excelGrid.colModel.push({label:'<spring:message code="lesson.lecture" /> <spring:message code="lesson.label.crs.cnt" />', name:'crsCnt', align:'right', width:'3000'}); // 수강 과목수
			excelGrid.colModel.push({label:'<spring:message code="lesson.label.attend.lower" /> <spring:message code="lesson.label.crs.cnt" />', name:'under50CrsCnt', align:'right', width:'6000'}); // 출석50%미만 과목수
			excelGrid.colModel.push({label:'<spring:message code="lesson.label.check.date" />', name:'modDttm', align:'center', width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmm', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}});
			
			var url  = "/lesson/lessonMgr/downExcelLessonProgressStatus.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: SEARCH_OBJ_2.haksaYear}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: SEARCH_OBJ_2.haksaTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ_2.univGbn}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ_2.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCd', 		value: SEARCH_OBJ_2.crsCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 	value: SEARCH_OBJ_2.crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ_2.searchValue}));
			// 검색조건 Text
			form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm', value: SEARCH_OBJ_2.haksaTermNm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbnNm', 	value: SEARCH_OBJ_2.univGbnNm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptNm', 		value: SEARCH_OBJ_2.deptNm}));
			form.append($('<input/>', {type: 'hidden', name: 'crsNm', 		value: SEARCH_OBJ_2.crsNm}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreNm', 	value: SEARCH_OBJ_2.crsCreNm}));
			// 탭2 검색조건
			form.append($('<input/>', {type: 'hidden', name: 'lessonScheduleOrder', value: SEARCH_OBJ_2.lessonScheduleOrder}));
			form.append($('<input/>', {type: 'hidden', name: 'searchText', 			value: SEARCH_OBJ_2.searchText}));
			
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// 미학습자 전체 선택시 초기화
		function clearSearchFromTo(checked) {
			if(checked) {
				$("#searchFrom").val("");
				$("#searchTo").val("");
			}
		}
		
		// 메세지 보내기
		function sendMsg(tab) {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var selectList = null; 
			
			if (tab == 1) {
				selectList = tabTable1.getSelectedRows();
			}
			else if (tab == 2) {
				selectList = tabTable2.getSelectedRows();
			}
			
			if (selectList == null) {
				return;
			}
			
			for(var i=0; i<selectList.length; i++) {
				sendCnt++;
				if (sendCnt > 1)
					rcvUserInfoStr += "|";
				
				var data = selectList[i].getData();
				rcvUserInfoStr += data.userId;
				rcvUserInfoStr += ";" + data.valUserNm;
				rcvUserInfoStr += ";" + data.valMobileNo;
				rcvUserInfoStr += ";" + data.valEmail;
			}
			
			if (sendCnt == 0) {
				/* 메시지 발송 대상자를 선택하세요. */
				alert("<spring:message code='common.alert.sysmsg.select_user'/>");
				return;
			}

			window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

			var form = document.alarmForm;
			form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.submit();
		}
		
		// 메세지 보내기 (직접보내기)
		function directSendMsg(tab) {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var exCnt = 0;

			$.each($('#tabTable' + tab).find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
				var mobileNo = $(this).data("mobileNo");
				if (mobileNo == "") {
					exCnt++;
				}
				else {
					sendCnt++;
					if (sendCnt > 1) rcvUserInfoStr += "|";
					rcvUserInfoStr += $(this).val();
					rcvUserInfoStr += ";" + $(this).data("userNm");
					rcvUserInfoStr += ";" + mobileNo; 
					//rcvUserInfoStr += ";" + $(this).data("email");
				}
			});
	
			if (sendCnt == 0) {
				/* 메시지 발송 대상자를 선택하세요. */
				alert("<spring:message code='common.alert.sysmsg.select_user'/>");
				return;
			}
			
			$("#directSendMsgForm > input[name='sendCnt']").val(sendCnt);
			$("#directSendMsgForm > input[name='rcvUserInfoStr']").val(rcvUserInfoStr);
			$("#directSendMsgForm").attr("target", "directSendMsgIfm");
			$("#directSendMsgForm").attr("action", "/erp/directSendMsgPop.do");
			$("#directSendMsgForm").submit();
			$('#directSendMsgPop').modal('show');
			
		}
	</script>
</head>
<body>
    <div id="wrap" class="pusher">

        <!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

        <!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->

        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content" >
				<div id="info-item-box">
                	<h2 class="page-title flex-item">
					    <spring:message code='lesson.label.classroom.operations.means' /><!-- 수업운영도구 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code='lesson.label.progress.title' /><!-- 학습진도관리 --></small>
					    </div>
					</h2>
				</div>
             	<div class="ui divider mt0"></div>
                <div class="ui form">
                	<div class="ui buttons mb10">
                		<%
                		if (SessionInfo.isKnou(request)) {
                			%>
		            		<button class="ui blue button active" data-crs-type-cd="UNI"><spring:message code="common.button.uni" /><!-- 학기제 --></button>
		            		<%
                		}
		            	%>
		        	</div>
		        	<div class="ui segment searchArea">
						<select class="ui dropdown" id="haksaYear" onchange="changeTerm()">
	                   		<c:forEach var="item" begin="${termVO.haksaYear - 2}" end="${termVO.haksaYear + 2}" step="1">
								<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
							</c:forEach>
	                   	</select>
	                   	<select class="ui dropdown" id="haksaTerm" onchange="changeTerm()">
	                   		<option value=""><spring:message code="exam.label.term" /><!-- 학기 --></option>
							<c:forEach var="item" items="${haksaTermList}">
								<option value="${item.codeCd}" ${item.codeCd eq termVO.haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
							</c:forEach>
	                   	</select>
	                   	<!-- 대학구분 -->
						<select id="univGbn" class="ui dropdown">
							<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
							<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
                    		<c:forEach var="item" items="${univGbnList}">
								<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
							</c:forEach>
                   		</select>
                   		<!-- 학과 선택 -->
                       	<select id="deptCd" class="ui dropdown w250">
                           	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
                       	</select>
                       	<select id="crsCd" class="ui dropdown w250">
                           	<option value=""><spring:message code="common.crs.cd" /><!-- 학수번호 -->  <spring:message code="common.select" /><!-- 선택 --></option>
                       	</select>
                       	<select id="crsCreCd" class="ui dropdown w250">
                           	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
                       	</select>
                       	<div class="ui input search-box">
							<input id="searchValue" type="text" placeholder="<spring:message code="lesson.common.placeholder4" />" /><!-- 학번/이름 -->
					    </div>
					    <div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="searchLessonProgress()"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
					</div>
					
					<div class="ui segment">
						<div class="flex gap4 mra">
                            <div class="sec_head"><spring:message code="lesson.label.learning.condition" /><!-- 전체 현황 --></div>
                        </div>
						<table class="tbl type2 mt10">
                            <thead>
                                <tr>
                                    <th class="p_w25"><spring:message code="lesson.label.type" /><!-- 구분 --></th>
                                    <th class="p_w25"><spring:message code="lesson.label.enrolled.student.cnt" /><!-- 재학생수 --></th>
                                    <th class="p_w25"><spring:message code="lesson.label.non.learning.cnt" /><!-- 미학습자수 --></th>
                                    <th class="p_w25"><spring:message code="lesson.label.avg.learning.progress" /><!-- 평균학습진도 --></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="tc"><spring:message code="common.all" /><!-- 전체 --></td>
                                    <td class="tc"><span id="stdCntTotal">-</span></td>
                                    <td class="tc"><span id="nostudyCntTotal">-</span></td>
                                    <td class="tc"><span id="avgRateTotal">-</span>%</td>
                                </tr>
                                <tr>
                                    <td class="tc"><spring:message code="lesson.label.undergraduate.studies" /><!-- 학부 --></td>
                                    <td class="tc"><span id="stdCntC">-</span></td>
                                    <td class="tc"><span id="nostudyCntC">-</span></td>
                                    <td class="tc"><span id="avgRateC">-</span>%</td>
                                </tr>
                                <tr>
                                    <td class="tc"><spring:message code="common.label.uni.g" /><!-- 대학원 --></td>
                                    <td class="tc"><span id="stdCntG">-</span></td>
                                    <td class="tc"><span id="nostudyCntG">-</span></td>
                                    <td class="tc"><span id="avgRateG">-</span>%</td>
                                </tr>
                            </tbody>
                        </table>
					</div>
				        	
                    <div class="ui segment">
                    	<div class="ui pointing secondary tabmenu menu">
							<a class="item pt0 active" data-tab="1"><spring:message code="common.all" /><!-- 전체 --></a>
							<a class="item pt0" data-tab="2"><spring:message code="common.week" /><!-- 주차 --></a>
						</div>
						
						<!-- 탭 콘텐츠 -->
						<div class="ui tab active" data-tab="1">
							<div class="flex gap4 mra">
                                <div class="sec_head"><spring:message code="lesson.label.learning.status.total" /><!-- 전체 학습현황 --></div>
                                <div class="fcGrey">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <span id="totalCntText1">0</span> ]</div>
                            </div>
                            <div class="flex-item mt10">
	                      		<input id="searchFrom" class="ui input w50" maxlength="3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); $('nostudy1').prop('checked', false);" />
	                      		<span class="m-w60 ml5">% <spring:message code="common.label.over" /><!-- 이상 --> ~</span>
	                      		<input id="searchTo" class="ui input w50" maxlength="3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');  $('nostudy1').prop('checked', false);" />
	                      		<span class="ml5 mr5">% <spring:message code="common.label.under" /><!-- 미만 --></span>
	                      		<div class="ui checkbox ml10">
			                        <input type="checkbox" class="hidden" id="nostudy1" name="nostudyAll" onchange="clearSearchFromTo(this.value)" />
			                        <label for=""><spring:message code='lesson.label.non.learning.person' /><!-- 미학습자 --> <spring:message code='common.all' /><!-- 전체 --></label>
			                    </div>
		                        <a class="ui icon button ml20" onclick="searchLessonProgress()"><i class="search icon"></i></a>
		                        <div class="mla">
		                        	<!-- 직접 메시지 발송 작업.... 임시기능 -->
		                        	<%-- 
		                        	<a href="javascript:void(0)" class="ui basic button" onclick="directSendMsg(1);return false;" title="메세지 보내기"><i class="paper plane outline icon"></i> 메시지(SMS)</a>
		                        	--%>
							    	<uiex:msgSendBtn func="sendMsg(1)" styleClass="ui basic button"/><!-- 메시지 -->
			   						<a href="javascript:void(0)" class="ui green button" onclick="downExcel1()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
							    </div>
	                         </div>
                            <div class="mt10">
								<div id="tabTable1"></div>
								<script>
			                        // 학습현황 목록 테이블1
			                        var tabTable1 = new Tabulator("#tabTable1", {
			                        		//maxHeight: "500px",
			                        		//minHeight: "200px",
			                        		height: "500px",
			                        		layout: "fitColumns",
			                        		selectableRows: "highlight",
			                        		headerSortClickElement: "icon",
			                        		placeholder:"<spring:message code='common.nodata.msg'/>",
			                        		columns: [
			                        			{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:50, cellClick:function(e,cell){cell.getRow().toggleSelect();}, headerSort:false}, // check
			                        		    {title:"<spring:message code='common.number.no'/>", 													field:"lineNo", 	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"rownum",		headerSort:false},
			                        		    {title:"<spring:message code='common.type'/>", 															field:"univGbnNm", 	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='common.dept_name'/>", 													field:"deptNm", 	headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:180,	formatter:"plaintext",	headerSort:true, sorter:"string", sorterParams:{locale:"en"}},
			                        		    {title:"<spring:message code='common.label.student.number'/>",											field:"userId", 	headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:100,	formatter:"plaintext",	headerSort:true},
			                        		    {title:"<spring:message code='common.name'/>", 															field:"userNm", 	headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:150,	formatter:"html",		headerSort:true, sorter:"string", sorterParams:{locale:"en"}},
			                        		    {title:"<spring:message code='common.label.entrance'/><br><spring:message code='lesson.label.year'/>",	field:"entrYy",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='common.label.entrance'/><br><spring:message code='common.term'/>", 		field:"entrTmGbn",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='common.label.entrance'/><br><spring:message code='common.type'/>",		field:"entrGbnNm",	headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:120,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='common.label.userdept.grade'/>", 											field:"hy", 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='lesson.lecture'/><br><spring:message code='lesson.label.crs.cnt'/>", 		field:"crsCnt", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='lesson.label.open'/><br><spring:message code='common.week'/>", 			field:"totWeekCnt", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='lesson.label.study'/><br><spring:message code='common.week'/>", 			field:"cmplWeekCnt",headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='lesson.label.study.status.complete.yule'/>", 								field:"progRatio",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:75,		formatter:"plaintext",	headerSort:false},
			                        		    {title:"<spring:message code='lesson.label.check.date'/>", 												field:"modDttm",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:120,		formatter:"plaintext",	headerSort:false}
			                        		]
		                        	});
		                        </script>
                            </div>
                            
						</div>
						<div class="ui tab" data-tab="2">
							<div class="flex gap4 mra">
                                <div class="sec_head"><spring:message code="common.week" /> <spring:message code="lesson.label.study.status" /><!-- 학습현황 --></div>
                                <div class="fcGrey">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <span id="totalCntText2">0</span> ]</div>
                            </div>
                            <div class="flex gap4 mra mt10">
                            	<div class="flex-item">
                            		<select id="lessonScheduleOrder" class="ui dropdown upward">
			                    		<option value=""><spring:message code="seminar.label.schedule.select" /><!-- 주차선택 --></option>
			                    		<c:forEach begin="1" end="15" var="num">
			                    			<option value="<c:out value="${num}" />"><c:out value="${num}" /><spring:message code="common.week" /><!-- 주차 --></option>
			                    		</c:forEach>
			                    	</select>
			                    	<div class="ui checkbox ml10">
			                            <input type="checkbox" class="hidden" id="nostudy2" name="nostudyAll" onchange="clearSearchFromTo(this.value)" />
			                            <label for=""><spring:message code='lesson.label.non.learning.person' /><!-- 미학습자 --> <spring:message code='common.all' /><!-- 전체 --></label>
			                        </div>
			                        <a class="ui icon button ml20" onclick="setListTab2()"><i class="search icon"></i></a>
                            	</div>
                                <div class="mla">
                                	<!-- 직접 메시지 발송 작업.... 임시기능 -->
                                	<%-- 
		                        	<a href="javascript:void(0)" class="ui basic button" onclick="directSendMsg(2);return false;" title="메세지 보내기"><i class="paper plane outline icon"></i> 메시지(SMS)</a>
		                        	--%>
							    	<uiex:msgSendBtn func="sendMsg(2)" styleClass="ui basic small button"/><!-- 메시지 -->
			   						<a href="javascript:void(0)" class="ui green button" onclick="downExcel2()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
							    </div>
                            </div>
                            <div class="mt10">
								<div id="tabTable2"></div>
								<script>
			                        // 학습현황 목록 테이블1
			                        var tabTable2 = new Tabulator("#tabTable2", {
			                        		//maxHeight: "500px",
			                        		//minHeight: "200px",
			                        		height: "500px",
			                        		layout: "fitColumns",
			                        		selectableRows: "highlight",
			                        		headerSortClickElement: "icon",
			                        		placeholder:"<spring:message code='common.nodata.msg'/>",
			                        		columns: [
			                        			{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:50, cellClick:function(e,cell){cell.getRow().toggleSelect();}, headerSort:false}, // check
			                        		    {title:"<spring:message code='common.number.no'/>",																field:"lineNo",			headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"rownum",		headerSort:false}, // NO
			                        		    {title:"<spring:message code='common.type'/>",																	field:"univGbnNm",		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:90,		formatter:"plaintext",	headerSort:false}, // 구분
			                        		    {title:"<spring:message code='common.dept_name'/>",																field:"deptNm",			headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:180,	formatter:"plaintext",	headerSort:true, sorter:"string", sorterParams:{locale:"en"}},  // 학과
			                        		    {title:"<spring:message code='common.label.student.number'/>",													field:"userId",			headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:100,	formatter:"plaintext",	headerSort:true},  // 학번
			                        		    {title:"<spring:message code='common.name'/>",																	field:"userNm",			headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:150,	formatter:"html",		headerSort:true, sorter:"string", sorterParams:{locale:"en"}},  // 이름
			                        		    {title:"<spring:message code='common.label.entrance'/><br><spring:message code='lesson.label.year'/>",			field:"entrYy",			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false}, // 입학년도
			                        		    {title:"<spring:message code='common.label.entrance'/><br><spring:message code='common.term'/>",				field:"entrTmGbn",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false}, // 입학학기
			                        		    {title:"<spring:message code='common.label.entrance'/><br><spring:message code='common.type'/>",				field:"entrGbnNm",		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:120,		formatter:"plaintext",	headerSort:false}, // 입학구분
			                        		    {title:"<spring:message code='common.label.userdept.grade'/>",													field:"hy",				headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:65,		formatter:"plaintext",	headerSort:false}, // 학년
			                        		    {title:"<spring:message code='lesson.lecture'/><br><spring:message code='lesson.label.crs.cnt'/>",				field:"crsCnt",			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:75,		formatter:"plaintext",	headerSort:false}, // 수강과목수
			                        		    {title:"<spring:message code='lesson.label.attend.lower'/><br><spring:message code='lesson.label.crs.cnt'/>",	field:"underCrsCnt",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"plaintext",	headerSort:false}, // 출석50%미만 과목수
			                        		    {title:"<spring:message code='lesson.label.check.date'/>",														field:"modDttm",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:120,		formatter:"plaintext",	headerSort:false}  // 확인일
			                        		]
		                        	});
		                        </script>
                            </div>
						</div>
                        <script> 
                            //초기화 방법 1__일반적인 형식
                            $('.tabmenu.menu .item').tab(); 

                            //초기화 방법 2__탭을 선택해 초기화 할 경우
                            //$('.tabmenu.menu .item').tab('change tab', 'tabcont2'); 
                        </script>
                    </div>

                </div>
            </div>
        </div>
        
	<!-- 메시지 직접 보내기 팝업 -->
	<form id="directSendMsgForm" name="directSendMsgForm" method="post">
		<input type="hidden" name="rcvUserInfoStr" />
		<input type="hidden" name="sendCnt" />
	</form>
    <div class="modal fade" id="directSendMsgPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.my.information" /><spring:message code="common.mgr" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">메시지 보내기(SMS)</h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="directSendMsgIfm" name="directSendMsgIfm" width="100%" scrolling="no" title="메시지 보내기(SMS)"></iframe>
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
        
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>