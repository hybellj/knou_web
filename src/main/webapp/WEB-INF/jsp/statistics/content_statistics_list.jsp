<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var SEARCH_OBJ_1; // 검색조건 저장
		var SEARCH_OBJ_2; // 검색조건 저장
		var SEARCH_OBJ_3; // 검색조건 저장
		var IS_INIT_TAB_1 = false; // 탭 한번 초기화
		var IS_INIT_TAB_2 = false; // 탭 한번 초기화
		var IS_INIT_TAB_3 = false; // 탭 한번 초기화 
		var ACTIVE_TAB = "1"; // 선택된 탭
		var CRS_CRE_LIST_1 = [];
		var CRS_CRE_LIST_2 = [];
		var CRS_CRE_LIST_3 = [];
		
		$(document).ready(function() {
			// 부서정보
			<c:forEach var="item" items="${deptCdList}">
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
			
			$("#searchValue1").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listTab1(1);
				}
			});
			
			$("#searchValue2").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listTab2(1);
				}
			});
			
			$("#searchValue3").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listTab3(1);
				}
			});
			
			// 학기변경
			changeTab("1");
		});
		
		// 탭변경
		function changeTab(tab) {
			if(tab == "1" && !IS_INIT_TAB_1) {
				IS_INIT_TAB_1 = true;
				changeTerm();
				//listTab1(1);
			} else if(tab == "2" && !IS_INIT_TAB_2) {
				IS_INIT_TAB_2 = true;
				changeTerm();
				//listTab2(1);
			} if(tab == "3" && !IS_INIT_TAB_3) {
				IS_INIT_TAB_3 = true;
				changeTerm();
				//listTab3(1);
			}
			
			ACTIVE_TAB = tab;
		}
		
		// 학기변경
		function changeTerm() {
			// 학기 과목정보 조회
			var url = "/crs/creCrsHome/listCrsCreDropdown.do";			
			var data = {
				  creYear	: $("#haksaYear" + ACTIVE_TAB).val()
				, creTerm	: $("#haksaTerm" + ACTIVE_TAB).val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					this["CRS_CRE_LIST_" + ACTIVE_TAB] = returnList.sort(function(a, b) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;
						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
						return 0;
					});
					
					if(ACTIVE_TAB == "1") {
						setUserDeptCd(1);
					} else if(ACTIVE_TAB == "2") {
						$("#univGbn" + ACTIVE_TAB).dropdown("clear");
						changeUnivGbn("ALL");
					} else if(ACTIVE_TAB == "3") {
						setUserDeptCd("ALL");
					}
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
			
			this["CRS_CRE_LIST_" + ACTIVE_TAB].forEach(function(v, i) {
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
			$("#deptCd" + ACTIVE_TAB).html(html);
			$("#deptCd" + ACTIVE_TAB).dropdown("clear");
			$("#deptCd" + ACTIVE_TAB).on("change", function() {
				changeDeptCd(this.value);
			});
			
			// 학과 초기화
			$("#crsCreCd" + ACTIVE_TAB).empty();
			$("#crsCreCd" + ACTIVE_TAB).dropdown("clear");
			
			// 부서변경
			changeDeptCd("ALL");
		}
		
		// 학과 변경
		function changeDeptCd(deptCd) {
			var univGbn = ($("#univGbn" + ACTIVE_TAB).val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			this["CRS_CRE_LIST_" + ACTIVE_TAB].forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			$("#crsCreCd" + ACTIVE_TAB).html(html);
			$("#crsCreCd" + ACTIVE_TAB).dropdown("clear");
		}
		
		// 부서 세팅
		function setUserDeptCd() {
			var html = '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
		
			USER_DEPT_LIST.forEach(function(v, i) {
				html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
			});
			
			$("#deptCd" + ACTIVE_TAB).html(html);
			$("#deptCd" + ACTIVE_TAB).dropdown("clear");
		}
		
		// 주차별 목록 조회
		function listTab1(pageIndex) {
			var url = "/statistics/statisticsMgr/listContentStatistics.do";
			var param = {
			      creYear 		: $("#haksaYear1").val()
			    , creTerm 		: $("#haksaTerm1").val()
			    , deptCd 		: ($("#deptCd1").val() || "").replace("ALL", "")
				, searchValue	: $("#searchValue1").val()
				, pagingYn		: "Y"
				, pageIndex 	: pageIndex
				, listScale 	: $("#listScale1").val()
				, searchGubun	: "WEEK"
			};

			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						html += '<tr>';
						html += '	<td class="tc w50">' + v.lineNo + '</td>';
						html += '	<td class="tc word_break_none">' + v.userId + '</td>';
						html += '	<td class="word_break_none">' + v.userNm + '</td>';
						html += '	<td class="tc w50">' + v.ltWeek + '</td>';
						//html += '	<td class="tc p_w10">' + v.enrHp + '</td>';
						html += '	<td class="tc w100">' + v.connDay + '</td>';
						html += '	<td class="tc p_w10">' + v.connTmSum + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTmAvg + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTmDev + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTermAvg + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTermDev + '</td>';
						html += '	<td class="tc p_w10">' + v.connDayRatio + '</td>';
						html += '	<td class="tc p_w10">' + v.connWeekdayRatio + '</td>';
						html += '</tr>';
					});

					$("#list1").html(html);
					//$("#table1").footable();
					$("#totalCntText1").text(data.pageInfo.totalRecordCount);
					
					var params = {
						totalCount : data.pageInfo.totalRecordCount,
						listScale : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName : "listTab1", 
						pagingDivId: "paging1",
					};
					
					gfn_renderPaging(params);
					
					if(returnList.length > 0) {
						$("#tableResultNone1").hide();
					} else {
						$("#tableResultNone1").show();
					}
					
					var termText = "";
					if(param.creTerm == "10") {
						termText = "1";
					} else if(param.creTerm == "20") {
						termText = "2";
					}
					
					var title = param.creYear + "년 " + 1 * termText + "학기";				
					$("#title1").text(title);
					
					SEARCH_OBJ_1 = param;
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		function downExcel1() {
			if(!SEARCH_OBJ_1) {
				alert('<spring:message code="lesson.alert.first.search" />'); // 먼저 검색을 하세요.
				return;
			}
			
			var excelGrid = {
			    colModel:[
		              {label:'<spring:message code="common.number.no" />', name:'lineNo', align:'right', width:'2000'} // NO
		            , {label:'<spring:message code="common.label.student.number" />', name:'userId', align:'left', width:'4000'} // 학번
		            , {label:'<spring:message code="common.name" />', name:'userNm', align:'left', width:'5000'} // 이름
		            , {label:'<spring:message code="common.week" />', name:'ltWeek', align:'right', width:'2500'} // 주차
		            , {label:'접속일수', name:'connDay', align:'right', width:'2500'} // 접속일수
		            , {label:'접속시간합계', name:'connTmSum', align:'right', width:'4000'} // 접속시간합계
		            , {label:'일접속시간평균', name:'dayTmAvg', align:'right', width:'4000'} // 일접속시간평균
		            , {label:'일접속시간 표준편차', name:'dayTmDev', align:'right', width:'4000'} // 일접속시간 표준편차
		            , {label:'접속일간격평균', name:'dayTermAvg', align:'right', width:'4000'} // 접속일간격평균
		            , {label:'접속일간격표준편차', name:'dayTermDev', align:'right', width:'4000'} // 접속일간격표준편차
		            , {label:'주간접속비율', name:'connDayRatio', align:'right', width:'4000'} // 주간접속비율
		            , {label:'주중접속비율', name:'connWeekdayRatio', align:'right', width:'4000'} // 주중접속비율
	            ]
			};
			
			var url  = "/statistics/statisticsMgr/downExcelContentStatistics.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'creYear',		value: SEARCH_OBJ_1.creYear}));
			form.append($('<input/>', {type: 'hidden', name: 'creTerm', 	value: SEARCH_OBJ_1.creTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ_1.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ_1.searchValue}));
			form.append($('<input/>', {type: 'hidden', name: 'pagingYn', 	value: "N"}));
			form.append($('<input/>', {type: 'hidden', name: 'searchGubun', value: SEARCH_OBJ_1.searchGubun}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// 과목별 목록 조회
		function listTab2(pageIndex) {
			var url = "/statistics/statisticsMgr/listContentStatistics.do";
			var param = {
			      creYear 		: $("#haksaYear2").val()
			    , creTerm 		: $("#haksaTerm2").val()
			    , univGbn 		: ($("#univGbn2").val() || "").replace("ALL", "")
			    , deptCd 		: ($("#deptCd2").val() || "").replace("ALL", "")
			    , crsCreCd 		: ($("#crsCreCd2").val() || "").replace("ALL", "")
				, searchValue	: $("#searchValue2").val()
				, pagingYn		: "Y"
				, pageIndex 	: pageIndex
				, listScale 	: $("#listScale2").val()
				, searchGubun	: "COURSE"
			};

			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						html += '<tr>';
						html += '	<td class="tc w50">' + v.lineNo + '</td>';
						html += '	<td class="tc w100">' + v.crsCd + '</td>';
						html += '	<td class="word_break_none">' + v.crsCreNm + '</td>';
						html += '	<td class="tc p_w10">' + v.userId + '</td>';
						html += '	<td class="word_break_none">' + v.userNm + '</td>';
						html += '	<td class="tc w50">' + v.declsNo + '</td>';
						//html += '	<td class="tc p_w10">' + v.enrHp + '</td>';
						html += '	<td class="tc w100">' + v.connDay + '</td>';
						html += '	<td class="tc p_w10">' + v.connTmSum + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTmAvg + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTmDev + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTermAvg + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTermDev + '</td>';
						html += '	<td class="tc p_w10">' + v.connDayRatio + '</td>';
						html += '	<td class="tc p_w10">' + v.connWeekdayRatio + '</td>';
						html += '</tr>';
					});

					$("#list2").html(html);
					//$("#table2").footable();
					$("#totalCntText2").text(data.pageInfo.totalRecordCount);
					
					var params = {
						totalCount : data.pageInfo.totalRecordCount,
						listScale : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName : "listTab2", 
						pagingDivId: "paging2",
					};
					
					gfn_renderPaging(params);
					
					var termText = "";
					if(param.creTerm == "10") {
						termText = "1";
					} else if(param.creTerm == "20") {
						termText = "2";
					}
					
					var title = param.creYear + "년 " + 1 * termText + "학기";				
					$("#title2").text(title);
					
					if(returnList.length > 0) {
						$("#tableResultNone2").hide();
					} else {
						$("#tableResultNone2").show();
					}
					
					SEARCH_OBJ_2 = param;
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		function downExcel2() {
			if(!SEARCH_OBJ_2) {
				alert('<spring:message code="lesson.alert.first.search" />'); // 먼저 검색을 하세요.
				return;
			}
			
			var excelGrid = {
			    colModel:[
		              {label:'<spring:message code="common.number.no" />', name:'lineNo', align:'right', width:'2000'} // NO
		            , {label:'<spring:message code="common.crs.cd" />', name:'crsCd', align:'center', width:'2500'} // 학수번호
			        , {label:'<spring:message code="common.subject" />', name:'crsCreNm', align:'left', width:'7000'} // 과목
		            , {label:'<spring:message code="common.label.student.number" />', name:'userId', align:'left', width:'4000'} // 학번
		            , {label:'<spring:message code="common.name" />', name:'userNm', align:'left', width:'5000'} // 이름
		            , {label:'<spring:message code="common.label.decls.no" />', name:'declsNo', align:'center', width:'2500'} // 분반
		            , {label:'접속일수', name:'connDay', align:'right', width:'2500'} // 접속일수
		            , {label:'접속시간합계', name:'connTmSum', align:'right', width:'4000'} // 접속시간합계
		            , {label:'일접속시간평균', name:'dayTmAvg', align:'right', width:'4000'} // 일접속시간평균
		            , {label:'일접속시간 표준편차', name:'dayTmDev', align:'right', width:'4000'} // 일접속시간 표준편차
		            , {label:'접속일간격평균', name:'dayTermAvg', align:'right', width:'4000'} // 접속일간격평균
		            , {label:'접속일간격표준편차', name:'dayTermDev', align:'right', width:'4000'} // 접속일간격표준편차
		            , {label:'주간접속비율', name:'connDayRatio', align:'right', width:'4000'} // 주간접속비율
		            , {label:'주중접속비율', name:'connWeekdayRatio', align:'right', width:'4000'} // 주중접속비율
	            ]
			};
			
			var url  = "/statistics/statisticsMgr/downExcelContentStatistics.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'creYear',		value: SEARCH_OBJ_2.creYear}));
			form.append($('<input/>', {type: 'hidden', name: 'creTerm', 	value: SEARCH_OBJ_2.creTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ_2.univGbn}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ_2.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 	value: SEARCH_OBJ_2.crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ_2.searchValue}));
			form.append($('<input/>', {type: 'hidden', name: 'pagingYn', 	value: "N"}));
			form.append($('<input/>', {type: 'hidden', name: 'searchGubun', value: SEARCH_OBJ_2.searchGubun}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// 전체누계 목록 조회
		function listTab3(pageIndex) {
			var url = "/statistics/statisticsMgr/listContentStatistics.do";
			var param = {
			      creYear 		: $("#haksaYear3").val()
			    , creTerm 		: $("#haksaTerm3").val()
			    , deptCd 		: ($("#deptCd3").val() || "").replace("ALL", "")
				, searchValue	: $("#searchValue3").val()
				, pagingYn		: "Y"
				, pageIndex 	: pageIndex
				, listScale 	: $("#listScale3").val()
				, searchGubun	: "ALL"
			};

			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						html += '<tr>';
						html += '	<td class="tc w50">' + v.lineNo + '</td>';
						html += '	<td class="tc word_break_none">' + v.userId + '</td>';
						html += '	<td class="word_break_none">' + v.userNm + '</td>';
						//html += '	<td class="tc p_w10">' + v.enrHp + '</td>';
						html += '	<td class="tc w100">' + v.connDay + '</td>';
						html += '	<td class="tc p_w10">' + v.connTmSum + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTmAvg + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTmDev + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTermAvg + '</td>';
						html += '	<td class="tc p_w10">' + v.dayTermDev + '</td>';
						html += '	<td class="tc p_w10">' + v.connDayRatio + '</td>';
						html += '	<td class="tc p_w10">' + v.connWeekdayRatio + '</td>';
						html += '</tr>';
					});

					$("#list3").html(html);
					//$("#table3").footable();
					$("#totalCntText3").text(data.pageInfo.totalRecordCount);
					
					var params = {
						totalCount : data.pageInfo.totalRecordCount,
						listScale : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName : "listTab3", 
						pagingDivId: "paging3",
					};
					
					gfn_renderPaging(params);
					
					var termText = "";
					if(param.creTerm == "10") {
						termText = "1";
					} else if(param.creTerm == "20") {
						termText = "2";
					}
					
					var title = param.creYear + "년 " + 1 * termText + "학기";
					$("#title3").text(title);
					
					if(returnList.length > 0) {
						$("#tableResultNone3").hide();
					} else {
						$("#tableResultNone3").show();
					}
					
					SEARCH_OBJ_3 = param;
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		function downExcel3() {
			if(!SEARCH_OBJ_3) {
				alert('<spring:message code="lesson.alert.first.search" />'); // 먼저 검색을 하세요.
				return;
			}
			
			var excelGrid = {
			    colModel:[
		              {label:'<spring:message code="common.number.no" />', name:'lineNo', align:'right', width:'2000'} // NO
		            , {label:'<spring:message code="common.label.student.number" />', name:'userId', align:'left', width:'4000'} // 학번
		            , {label:'<spring:message code="common.name" />', name:'userNm', align:'left', width:'5000'} // 이름
		            , {label:'접속일수', name:'connDay', align:'right', width:'2500'} // 접속일수
		            , {label:'접속시간합계', name:'connTmSum', align:'right', width:'4000'} // 접속시간합계
		            , {label:'일접속시간평균', name:'dayTmAvg', align:'right', width:'4000'} // 일접속시간평균
		            , {label:'일접속시간 표준편차', name:'dayTmDev', align:'right', width:'4000'} // 일접속시간 표준편차
		            , {label:'접속일간격평균', name:'dayTermAvg', align:'right', width:'4000'} // 접속일간격평균
		            , {label:'접속일간격표준편차', name:'dayTermDev', align:'right', width:'4000'} // 접속일간격표준편차
		            , {label:'주간접속비율', name:'connDayRatio', align:'right', width:'4000'} // 주간접속비율
		            , {label:'주중접속비율', name:'connWeekdayRatio', align:'right', width:'4000'} // 주중접속비율
	            ]
			};
			
			var url  = "/statistics/statisticsMgr/downExcelContentStatistics.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'creYear',		value: SEARCH_OBJ_3.creYear}));
			form.append($('<input/>', {type: 'hidden', name: 'creTerm', 	value: SEARCH_OBJ_3.creTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ_3.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ_3.searchValue}));
			form.append($('<input/>', {type: 'hidden', name: 'pagingYn', 	value: "N"}));
			form.append($('<input/>', {type: 'hidden', name: 'searchGubun', value: SEARCH_OBJ_3.searchGubun}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
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
			<div class="content">
				<div id="info-item-box">
                	<h2 class="page-title flex-item">
					   	 수강통계
					    <div class="ui breadcrumb small">
					        <small class="section">학습자별 콘텐츠수강통계</small>
					    </div>
					</h2>
				</div>
				<div class="ui divider mt0"></div>
					<!-- ui form -->
					<div class="ui form">
						<div class="option-content gap4">
							<div class="ui pointing secondary tabmenu menu">
								<a class="item pt0 active" data-tab="1" onclick="changeTab('1')">주차별</a><!-- 주차별 -->
								<a class="item pt0" data-tab="2" onclick="changeTab('2')">과목별</a><!-- 과목별 -->
								<a class="item pt0" data-tab="3" onclick="changeTab('3')">전체누계</a><!-- 전체누계 -->
							</div>
						</div>
						<!-- 탭 콘텐츠 -->
						<div class="ui tab active" data-tab="1">
							<div class="ui segment searchArea">
								<!-- 학기구분 -->
								<select class="ui dropdown" id="haksaYear1" onchange="changeTerm()">
			                   		<c:forEach var="item" begin="${termVO.haksaYear - 4}" end="${termVO.haksaYear + 2}" step="1">
										<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
									</c:forEach>
			                   	</select>
			                   	<select class="ui dropdown" id="haksaTerm1" onchange="changeTerm()">
			                   		<option value=""><spring:message code="common.term" /><!-- 학기 --></option>
									<c:forEach var="item" items="${haksaTermList}">
										<c:if test="${item.codeCd eq '10' or item.codeCd eq '20'}">
											<c:set var="haksaTerm" value="${termVO.haksaTerm}" />
											<c:if test="${termVO.haksaTerm eq '11'}">
												<c:set var="haksaTerm" value="10" />
											</c:if>
											<c:if test="${termVO.haksaTerm eq '21'}">
												<c:set var="haksaTerm" value="20" />
											</c:if>
											<option value="${item.codeCd}" ${item.codeCd eq haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
										</c:if>
									</c:forEach>
			                   	</select>
			                   	<!-- 학과 선택 -->
                            	<select id="deptCd1" class="ui dropdown w250">
									<option value=""><spring:message code="user.title.userdept.select" /></option>
									<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
                            	</select>
                            	<div class="ui input">
									<input id="searchValue1" type="text" placeholder="학번/이름" />
							    </div>
							    <div class="button-area mt10 tc">
									<a href="javascript:void(0)" class="ui blue button w100" onclick="listTab1(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
								</div>
							</div>
							<div class="option-content gap4">
								<h3 class="sec_head" id="title1"></h3>
	   							<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText1">0</label> ]</span>
		       					<div class="mla">
		       						<a class="ui green button" href="javascript:downExcel1()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
		       						<select class="ui dropdown list-num" id="listScale1" onchange="listTab1(1)">
							            <option value="15">15</option>
							            <option value="30">30</option>
							            <option value="45">45</option>
							            <option value="60">60</option>
							            <option value="150">150</option>
							        </select>
		       					</div>
							</div>
							<div class="footable_box type2 max-height-550">
								<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg' />" id="table1"><!-- 등록된 내용이 없습니다. -->
									<thead class="sticky top0">
										<tr>
											<th class="tc w50"><spring:message code="common.number.no"/></th><!-- NO -->
											<th class="tc"><spring:message code="common.label.student.number" /><!-- 학번 --></th>
											<th class="tc"><spring:message code="common.name" /><!-- 이름 --></th>
											<th class="tc w50"><spring:message code="common.week" /><!-- 주차 --></th>																
											<%-- <th class="tc p_w10"><spring:message code="user.title.userinfo.date" /><spring:message code="crs.label.credit" /><!-- 신청학점 --></th> --%>
											<th class="tc w100"><spring:message code="user.title.manage.userinfo.conn.dttm" /><!-- 접속일수 --></th>
											<th class="tc p_w10">접속시간합계<!-- 접속시간합계 --></th>
											<th class="tc p_w10">일접속시간평균<!-- 일접속시간평균 --></th>
											<th class="tc p_w10">일접속시간 표준편차<!-- 일접속시간 표준편차 --></th>
											<th class="tc p_w10">접속일간격평균<!-- 접속일간격평균 --></th>
											<th class="tc p_w10">접속일간격표준편차<!-- 접속일간격평균표준편차 --></th>
											<th class="tc p_w10">주간접속비율<!-- 접속일간격평균 --></th>
											<th class="tc p_w10">주중접속비율<!-- 주중접속비율 --></th>
										</tr>
									</thead>
									<tbody id="list1">
									</tbody>
								</table>
								<div class="none tc pt10" id="tableResultNone1" style="display: none;">
									<span><spring:message code="common.nodata.msg"/></span><!-- 등록된 내용이 없습니다. -->
								</div>
							</div>
							<div id="paging1" class="paging mt10"></div>
						</div>
						<div class="ui tab" data-tab="2">
							<div class="ui segment searchArea">
								<!-- 학기구분 -->
								<select class="ui dropdown" id="haksaYear2" onchange="changeTerm()">
			                   		<c:forEach var="item" begin="${termVO.haksaYear - 4}" end="${termVO.haksaYear + 2}" step="1">
										<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
									</c:forEach>
			                   	</select>
			                   	<select class="ui dropdown" id="haksaTerm2" onchange="changeTerm()">
			                   		<option value=""><spring:message code="common.term" /><!-- 학기 --></option>
									<c:forEach var="item" items="${haksaTermList}">
										<c:if test="${item.codeCd eq '10' or item.codeCd eq '20'}">
											<c:set var="haksaTerm" value="${termVO.haksaTerm}" />
											<c:if test="${termVO.haksaTerm eq '11'}">
												<c:set var="haksaTerm" value="10" />
											</c:if>
											<c:if test="${termVO.haksaTerm eq '21'}">
												<c:set var="haksaTerm" value="20" />
											</c:if>
											<option value="${item.codeCd}" ${item.codeCd eq haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
										</c:if>
									</c:forEach>
			                   	</select>
			                   	<!-- 대학구분 -->
	                            <select class="ui dropdown" id="univGbn2" onchange="changeUnivGbn(this.value)">
	                    			<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
	                    			<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
	                    			<c:forEach var="item" items="${univGbnList}">
										<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
									</c:forEach>
	                    		</select>
                        		<!-- 학과 선택 -->
						  		<select id="deptCd2" class="ui dropdown w250" onchange="changeDeptCd(this.value)">
									<option value=""><spring:message code="user.title.userdept.select" /></option>
									<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
                            	</select>
                            	<!-- 과목 선택 -->
                            	<select id="crsCreCd2" class="ui dropdown w250">
		                    		<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
		                    	</select>
								<div class="ui input w250">
									<input id="searchValue2" type="text" placeholder="<spring:message code="contents.label.crscrenm" />/<spring:message code="common.label.prof.nm" />/<spring:message code="contents.label.crscd" />" />
							    </div>
							    <div class="button-area mt10 tc">
									<a href="javascript:void(0)" class="ui blue button w100" onclick="listTab2(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
								</div>
							</div>
							<div class="option-content gap4">
								<h3 class="sec_head" id="title2"></h3>
	   							<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText2">0</label> ]</span>
		       					<div class="mla">
		       						<a class="ui green button" href="javascript:downExcel2()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
		       						<select class="ui dropdown list-num" id="listScale2" onchange="listTab2(1)">
							            <option value="10">10</option>
							            <option value="20">20</option>
							            <option value="50">50</option>
							            <option value="100">100</option>
							        </select>
		       					</div>
							</div>
							<div class="footable_box type2 max-height-550">
								<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg' />" id="table2"><!-- 등록된 내용이 없습니다. -->
									<thead class="sticky top0">
										<tr>
											<th class="tc w50"><spring:message code="common.number.no"/></th><!-- NO -->
											<th class="tc w100"><spring:message code="common.crs.cd" /><!-- 학수번호 --></th>	
											<th class="tc"><spring:message code="common.subject" /><!-- 과목 --></th>
											<th class="tc p_w10"><spring:message code="common.label.student.number" /><!-- 학번 --></th>
											<th class="tc"><spring:message code="common.name" /><!-- 이름 --></th>
											<th class="tc w50"><spring:message code="common.label.decls.no" /><!-- 분반 --></th>																								
											<%-- <th class="tc p_w10"><spring:message code="user.title.userinfo.date" /><spring:message code="crs.label.credit" /><!-- 신청학점 --></th> --%>
											<th class="tc w100"><spring:message code="user.title.manage.userinfo.conn.dttm" /><!-- 접속일수 --></th>
											<th class="tc p_w10">접속시간합계<!-- 접속시간합계 --></th>
											<th class="tc p_w10">일접속시간평균<!-- 일접속시간평균 --></th>
											<th class="tc p_w10">일접속시간 표준편차<!-- 일접속시간 표준편차 --></th>
											<th class="tc p_w10">접속일간격평균<!-- 접속일간격평균 --></th>
											<th class="tc p_w10">접속일간격표준편차<!-- 접속일간격평균표준편차 --></th>
											<th class="tc p_w10">주간접속비율<!-- 접속일간격평균 --></th>
											<th class="tc p_w10">주중접속비율<!-- 주중접속비율 --></th>
										</tr>
									</thead>
									<tbody id="list2">
									</tbody>
								</table>
								<div class="none tc pt10" id="tableResultNone2" style="display: none;">
									<span><spring:message code="common.nodata.msg"/></span><!-- 등록된 내용이 없습니다. -->
								</div>
							</div>
							<div id="paging2" class="paging mt10"></div>
						</div>
						<div class="ui tab" data-tab="3">
							<div class="ui segment searchArea">
								<!-- 학기구분 -->
								<select class="ui dropdown" id="haksaYear3" onchange="changeTerm()">
			                   		<c:forEach var="item" begin="${termVO.haksaYear - 4}" end="${termVO.haksaYear + 2}" step="1">
										<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
									</c:forEach>
			                   	</select>
			                   	<select class="ui dropdown" id="haksaTerm3" onchange="changeTerm()">
			                   		<option value=""><spring:message code="common.term" /><!-- 학기 --></option>
									<c:forEach var="item" items="${haksaTermList}">
										<c:if test="${item.codeCd eq '10' or item.codeCd eq '20'}">
											<c:set var="haksaTerm" value="${termVO.haksaTerm}" />
											<c:if test="${termVO.haksaTerm eq '11'}">
												<c:set var="haksaTerm" value="10" />
											</c:if>
											<c:if test="${termVO.haksaTerm eq '21'}">
												<c:set var="haksaTerm" value="20" />
											</c:if>
											<option value="${item.codeCd}" ${item.codeCd eq haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
										</c:if>
									</c:forEach>
			                   	</select>
			                   	<!-- 학과 선택 -->
                            	<select id="deptCd3" class="ui dropdown w250">
									<option value=""><spring:message code="user.title.userdept.select" /></option>
									<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
                            	</select>
                            	<div class="ui input">
									<input id="searchValue3" type="text" placeholder="학번/이름" />
							    </div>
							    <div class="button-area mt10 tc">
									<a href="javascript:void(0)" class="ui blue button w100" onclick="listTab3(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
								</div>
							</div>
							<div class="option-content gap4">
								<h3 class="sec_head" id="title3"></h3>
	   							<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText3">0</label> ]</span>
		       					<div class="mla">
		       						<a class="ui green button" href="javascript:downExcel3()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
		       						<select class="ui dropdown list-num" id="listScale3" onchange="listTab3(1)">
							            <option value="10">10</option>
							            <option value="20">20</option>
							            <option value="50">50</option>
							            <option value="100">100</option>
							        </select>
		       					</div>
							</div>
							<div class="footable_box type2 max-height-550">
								<table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg' />" id="table3"><!-- 등록된 내용이 없습니다. -->
									<thead class="sticky top0">
										<tr>
											<th class="tc w50"><spring:message code="common.number.no"/></th><!-- NO -->
											<th class="tc"><spring:message code="common.label.student.number" /><!-- 학번 --></th>
											<th class="tc"><spring:message code="common.name" /><!-- 이름 --></th>
											<%-- <th class="tc p_w10"><spring:message code="user.title.userinfo.date" /><spring:message code="crs.label.credit" /><!-- 신청학점 --></th> --%>
											<th class="tc w100"><spring:message code="user.title.manage.userinfo.conn.dttm" /><!-- 접속일수 --></th>
											<th class="tc p_w10">접속시간합계<!-- 접속시간합계 --></th>
											<th class="tc p_w10">일접속시간평균<!-- 일접속시간평균 --></th>
											<th class="tc p_w10">일접속시간 표준편차<!-- 일접속시간 표준편차 --></th>
											<th class="tc p_w10">접속일간격평균<!-- 접속일간격평균 --></th>
											<th class="tc p_w10">접속일간격표준편차<!-- 접속일간격평균표준편차 --></th>
											<th class="tc p_w10">주간접속비율<!-- 접속일간격평균 --></th>
											<th class="tc p_w10">주중접속비율<!-- 주중접속비율 --></th>
										</tr>
									</thead>
									<tbody id="list3">
									</tbody>
								</table>
								<div class="none tc pt10" id="tableResultNone3" style="display: none;">
									<span><spring:message code="common.nodata.msg"/></span><!-- 등록된 내용이 없습니다. -->
								</div>
							</div>
							<div id="paging3" class="paging mt10"></div>
						</div>
                        <script> 
                            //초기화 방법 1__일반적인 형식
                            $('.tabmenu.menu .item').tab(); 

                            //초기화 방법 2__탭을 선택해 초기화 할 경우
                            //$('.tabmenu.menu .item').tab('change tab', 'tabcont2'); 
                        </script>
                   </div>
                   <!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>