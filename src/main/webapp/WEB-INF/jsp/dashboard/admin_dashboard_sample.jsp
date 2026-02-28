<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var ACTIVE_TAB = "1"; // 선택된 탭
		var CRS_CRE_LIST_1 = [];
		var CRS_CRE_LIST_2 = [];
		var CRS_CRE_LIST_3 = [];
		var SEARCH_OBJ_1; // 검색조건 저장
		var SEARCH_OBJ_2; // 검색조건 저장
		var IS_INIT_TAB_1 = false; // 탭 한번 초기화
		var IS_INIT_TAB_2 = false; // 탭 한번 초기화
		var IS_INIT_TAB_3 = false; // 탭 한번 초기화
		var IS_KNOU = <%=SessionInfo.isKnou(request)%>;
		var CLASS_TEAM_YN = '<c:out value="${classTeamYn}" />'; // 수업팀 여부
	
		$(document).ready(function() {
			// 부서정보
			<c:forEach var="item" items="${deptList}">
				USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptCd}" />'
					, deptNm: '<c:out value="${item.deptNm}" />'
					, deptCdOdr: Number('<c:out value="${item.deptCdOdr}" />' || 0)
				});
			</c:forEach>
			
			$("#searchValue1").on("keydown", function(e) {
				if(e.keyCode == 13) {
					// 과목별 학습현황
					listLessonStatusByCrs();
				}
			});
			
			$("#searchValue2").on("keydown", function(e) {
				if(e.keyCode == 13) {
					// 학생별 학습현황
					listLessonStatusByStd();
					
				}
			});
			
			$("#searchValue3").on("keydown", function(e) {
				if(e.keyCode == 13) {
					// 사용자 검색
					listAdminDashUser(1);
				}
			});
			
			// 부서 정렬
			USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			// 학기변경
			changeTab("1");
		});
		
		// 탭변경
		function changeTab(tab) {
			if(tab == "1" && !IS_INIT_TAB_1) {
				IS_INIT_TAB_1 = true;
				changeTerm();
			} else if(tab == "2" && !IS_INIT_TAB_2) {
				IS_INIT_TAB_2 = true;
				changeTerm();
			} if(tab == "3" && !IS_INIT_TAB_3) {
				IS_INIT_TAB_3 = true;
				changeTerm();
			}
			
			ACTIVE_TAB = tab;
		}
		
		// 학기변경
		function changeTerm() {
			console.log("");
			// 대학구분 초기화
			$("#univGbn" + ACTIVE_TAB).off("change");
			$("#univGbn" + ACTIVE_TAB).dropdown("clear");
			
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
					
					// 대학 구분 변경
					changeUnivGbn("ALL");
					
					$("#univGbn" + ACTIVE_TAB).on("change", function() {
						changeUnivGbn(this.value);
					});
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
			
			var html = '';
			if(ACTIVE_TAB == "1") {
				html += '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
			}
			if(ACTIVE_TAB == "2" || ACTIVE_TAB == "3") {
				html += '<option value="ALL"><spring:message code="common.all" /></option>'; // 전체
			}
			USER_DEPT_LIST.forEach(function(v, i) {
				if(deptCdObj[v.deptCd]) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				}
			});
			
			// 부서 초기화
			$("#deptCd" + ACTIVE_TAB).html(html);
			$("#deptCd" + ACTIVE_TAB).dropdown("clear");
			$("#deptCd" + ACTIVE_TAB).on("change", function() {
				if(ACTIVE_TAB == "2" || ACTIVE_TAB == "1") {
					// 부서변경
					changeDeptCd(this.value, ACTIVE_TAB);
				}
			});
			
			if(ACTIVE_TAB == "2" || ACTIVE_TAB == "1") {
				// 학과 초기화
				$("#crsCreCd"+ACTIVE_TAB).empty();
				$("#crsCreCd"+ACTIVE_TAB).dropdown("clear");
				
				// 부서변경
				changeDeptCd("ALL", ACTIVE_TAB);
			}
		}
		
		// 부서변경 (TAB_1, TAB_2)
		function changeDeptCd(deptCd, tab) {
			var univGbn = ($("#univGbn"+tab).val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			if(tab == "1") {
				CRS_CRE_LIST_1.forEach(function(v, i) {
					if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
						var declsNo = v.declsNo;
						declsNo = '(' + declsNo + ')';
						
						html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
					}
				});
			} else {
				CRS_CRE_LIST_2.forEach(function(v, i) {
					if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
						var declsNo = v.declsNo;
						declsNo = '(' + declsNo + ')';
						
						html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
					}
				});
			}
			
			$("#crsCreCd"+tab).html(html);
			$("#crsCreCd"+tab).dropdown("clear");
		}
	
		// tab1.과목별 학습현황
		function listLessonStatusByCrs() {
			/* 
			if(!$("#searchValue1").val() && (!$("#deptCd1").val() || $("#deptCd1").val() == "ALL")) {
				alert('<spring:message code="dashboard.alert.search.cond" />'); // 학과선택 또는 검색어를 입력하세요.
				return;
			}
			*/
			
			lessonStatusByCrsTable.clearData();
			
			var url = "/dashboard/listLessonStatusByCrs.do";
			var param = {
				  haksaYear		: $("#haksaYear1").val()
				, haksaTerm		: $("#haksaTerm1").val()
				, univGbn		: ($("#univGbn1").val() || "").replace("ALL", "")
				, deptCd		: ($("#deptCd1").val() || "").replace("ALL", "")
				, crsCreCd		: ($("#crsCreCd1").val() || "").replace("ALL", "")
				, searchValue	: $("#searchValue1").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var dataList = [];
					
					if(returnList.length == 0) {
						$("#tableResultNone1").show();
					} else {
						$("#tableResultNone1").hide();
					}
					
					var html = '';
					returnList.forEach(function(v, i) {
						//var uniNm = "-";
						
						//if(v.uniCd == "C") {
						//	uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						//} else if(v.uniCd == "G") {
						//	uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						//}
						
						var assistInfo = "-";
						if(v.assistNo) {
							assistInfo = v.assistNm + '<br />' + (v.assistOfceTelno ? formatPhoneNumber(v.assistOfceTelno) : '-');
						}
						
						var qnaCntList = (v.qnaCnt || "0/0").split('/');
						var secretCntList = (v.secretCnt || "0/0").split('/');
						var asmntCntList = (v.asmntCnt || "0/0").split('/');
						var forumCntList = (v.forumCnt || "0/0").split('/');
						var quizCntList = (v.quizCnt || "0/0").split('/');
						var reschCntList = (v.reschCnt || "0/0").split('/');
						var aexamCntList = (v.aexamCnt || "0/0").split('/');
						
						var midExamInfo = '-';
						if(v.midExamScoreRatio > 0) {
							if(v.midExamTypeCd == "EXAM") {
								var examStartDttmFmt = (v.midExamStartDttm || "").length == 14 ? v.midExamStartDttm.substring(0, 4) + '.' + v.midExamStartDttm.substring(4, 6) + '.' + v.midExamStartDttm.substring(6, 8) + ' ' + v.midExamStartDttm.substring(8, 10) + ':' + v.midExamStartDttm.substring(10, 12) : (v.midExamStartDttm || '-');
								var examStartTm = (v.midExamStareTm || '-') + '<spring:message code="date.minute" />'; // 분
								var scoreOpenYn = v.midScoreOpenYn == "Y" ? '<spring:message code="dashboard.label.score.open.y" />' : '<spring:message code="dashboard.label.score.open.n" />'; // 성적공개, 성적비공개
								var gradeViewYn = v.midGradeViewYn == "Y" ? '<spring:message code="dashboard.label.grade.view.y" />' : '<spring:message code="dashboard.label.grade.view.n" />'; // 시험지공개, 시험지비공개
								
								midExamInfo = '<span class="f080">' + examStartDttmFmt + ' ' + examStartTm;
								midExamInfo += '<br />';
								midExamInfo += scoreOpenYn + ' / ' + gradeViewYn + '</span>';
							
							} else {
							
								if(v.midInsRefCd) {
									var midExamCnt = '-';
									
									if(v.midExamCnt) {
										var midExamCntList = v.midExamCnt.split("/");
										midExamCnt = '<span class="fcBlue">' + midExamCntList[0] + '</span>/' + midExamCntList[1];
									}
									
									if (v.midExamTypeCd == "ASMNT") {
										midExamInfo = '<spring:message code="dashboard.cor.etc" /> (<spring:message code="dashboard.cor.asmnt" />: ' + midExamCnt + ')'; // 기타 과제
									} else if (v.midExamTypeCd == "FORUM") {
										midExamInfo = '<spring:message code="dashboard.cor.etc" /> (<spring:message code="dashboard.cor.forum" />: ' + midExamCnt + ')'; // 기타 토론
									} else if (v.midExamTypeCd == "QUIZ") {
										midExamInfo = '<spring:message code="dashboard.cor.etc" /> (<spring:message code="dashboard.cor.quiz" />: ' + midExamCnt + ')'; // 기타 퀴즈
									}
								} else {
									midExamInfo = '<spring:message code="dashboard.cor.etc" /> (-)'; // 기타
								}
							}
						}
						
						var lastExamInfo = '-';
						if(v.lastExamScoreRatio > 0) {
							if(v.lastExamTypeCd == "EXAM") {
								var examStartDttmFmt = (v.lastExamStartDttm || "").length >= 14 ? v.lastExamStartDttm.substring(0, 4) + '.' + v.lastExamStartDttm.substring(4, 6) + '.' + v.lastExamStartDttm.substring(6, 8) + ' ' + v.lastExamStartDttm.substring(8, 10) + ':' + v.lastExamStartDttm.substring(10, 12) : (v.lastExamStartDttm || '-');
								var examStartTm = (v.lastExamStareTm || '-') + '<spring:message code="date.minute" />'; // 분
								var scoreOpenYn = v.lastScoreOpenYn == "Y" ? '<spring:message code="dashboard.label.score.open.y" />' : '<spring:message code="dashboard.label.score.open.n" />'; // 성적공개, 성적비공개
								var gradeViewYn = v.lastGradeViewYn == "Y" ? '<spring:message code="dashboard.label.grade.view.y" />' : '<spring:message code="dashboard.label.grade.view.n" />'; // 시험지공개, 시험지비공개
								
								lastExamInfo = '<span class="f080">' + examStartDttmFmt + ' ' + examStartTm;
								lastExamInfo += '<br />';
								lastExamInfo += scoreOpenYn + ' / ' + gradeViewYn + '</span>';
							
							} else {
							
								if(v.lastInsRefCd) {
									var lastExamCnt = '-';
									
									if(v.lastExamCnt) {
										var lastExamCntList = v.lastExamCnt.split("/");
										lastExamCnt = '<span class="fcBlue">' + lastExamCntList[0] + '</span>/' + lastExamCntList[1];
									}
									
									if (v.lastExamTypeCd == "ASMNT") {
										lastExamInfo = '<spring:message code="dashboard.cor.etc" /> (<spring:message code="dashboard.cor.asmnt" />: ' + lastExamCnt + ')'; // 기타 과제
									} else if (v.lastExamTypeCd == "FORUM") {
										lastExamInfo = '<spring:message code="dashboard.cor.etc" /> (<spring:message code="dashboard.cor.forum" />: ' + lastExamCnt + ')'; // 기타 토론
									} else if (v.lastExamTypeCd == "QUIZ") {
										lastExamInfo = '<spring:message code="dashboard.cor.etc" /> (<spring:message code="dashboard.cor.quiz" />: ' + lastExamCnt + ')'; // 기타 퀴즈
									}
								} else {
									lastExamInfo = '<spring:message code="dashboard.cor.etc" /> (-)'; // 기타
								}
							}
						}
						
						dataList.push({
							univGbnNm:(v.univGbnNm || '-'), deptNm:(v.deptNm || '-'), crsCd:v.crsCd, 
							crsCreNm:'<a href="javascript:moveCreWin(\'' + v.crsCreCd + '\')" class="fcBlue">' + v.crsCreNm + ' (' + v.declsNo + ')</a>',
							userNm:(v.userNm || "-"), assistInfo:assistInfo, stdCnt:v.stdCnt, auditCnt:v.auditCnt,
							lsnPlanUrl:'<button type="button" class="ui button small basic" onclick="viewLessonPlan(\'' + v.lsnPlanUrl + '\')">보기</button>',
							noticeCnt:v.noticeCnt, qnaCnt:qnaCntList[0] + '</span>/' + qnaCntList[1], 
							qnaCnt:qnaCntList[0] + '</span>/' + qnaCntList[1],
							secretCnt:secretCntList[0] + '</span>/' + secretCntList[1],
							asmntCnt:asmntCntList[0] + '</span>/' + asmntCntList[1],
							forumCnt:forumCntList[0] + '</span>/' + forumCntList[1],
							quizCnt:quizCntList[0] + '</span>/' + quizCntList[1],
							reschCnt:reschCntList[0] + '</span>/' + reschCntList[1],
							aexamCnt:aexamCntList[0] + '</span>/' + aexamCntList[1],
							midExamInfo:midExamInfo, lastExamInfo:lastExamInfo,
							valUserId:v.userId, valUserNm:v.userNm, valEmail:v.email, valMobileNo:v.mobileNo
						});
					});
					
					lessonStatusByCrsTable.addData(dataList);
					lessonStatusByCrsTable.redraw();
					
					SEARCH_OBJ_1 = param;
					
					SEARCH_OBJ_1.haksaTermNm = $("#haksaTerm1 > option:selected")[0].innerText;
					SEARCH_OBJ_1.uniNm = SEARCH_OBJ_1.univGbn ? $("#univGbn1 > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ_1.deptNm = SEARCH_OBJ_1.deptCd ? $("#deptCd1 > option:selected")[0].innerText : '<spring:message code="common.all" />';;
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// tab1.엑셀 다운로드
		function downExcel1() {
			if(!SEARCH_OBJ_1) {
				alert('<spring:message code="dashboard.alert.please.search" />'); // 먼저 검색을 하세요.
				return;
			}
			
			var excelGrid = {
			    colModel:[
		            {label:'<spring:message code="common.number.no" />',    			name:'lineNo',     		align:'right', 		width:'1000'},
		            //{label:'<spring:message code="common.type" />',						name:'uniCd',			align:'left',    	width:'2500', codes:{C: "<spring:message code='common.label.uni.college' />", G: "<spring:message code='common.label.uni.graduate' />"}},	// 대학교,대학원
		            {label:'<spring:message code="common.type" />',						name:'univGbnNm',		align:'left',    	width:'3000'},	// 대학교,대학원
		            {label:'<spring:message code="common.dept_name" />',  				name:'deptNm',			align:'left',    	width:'7000'}, // 학과
		            {label:'<spring:message code="common.crs.cd" />',    				name:'crsCd',			align:'left',   	width:'3000'}, // 학수번호
		            {label:'<spring:message code="review.label.crscrenm" />',  			name:'crsCreNm',   		align:'left',   	width:'7000'}, // 과목명
		            {label:'<spring:message code="review.label.decls" />',  			name:'declsNo',   		align:'center',   	width:'2500'}, // 분반
		            {label:'<spring:message code="common.professor" />',  				name:'userNm',   		align:'left',   	width:'5000'}, // 교수
		            {label:'<spring:message code="common.teaching.assistant"/>',  		name:'assistNm',   		align:'left',   	width:'5000'}, // 조교
		            {label:'<spring:message code="common.teaching.assistant"/> <spring:message code="user.title.userinfo.phoneno" />', name:'assistOfceTelno',  align:'center',   	width:'5000'}, 	// 조교
		            {label:'<spring:message code="std.label.learner" />',  				name:'stdCnt',   		align:'right',   	width:'2500'}, 	// 수강생
		            {label:'<spring:message code="std.label.auditor" />',  				name:'auditCnt',   		align:'right',   	width:'2500'}, 	// 청강생
		            {label:'<spring:message code="common.label.lec.announcement" />',  	name:'noticeCnt',   	align:'center',   	width:'2500'}, 	// 강의공지
		            {label:'<spring:message code="dashboard.qna" />',  					name:'qnaCnt',   		align:'center',   	width:'2500'}, 	//  Q&A
		            {label:'<spring:message code="dashboard.councel" /><spring:message code="common.label.evaluation" />',  		name:'secretCnt',   	align:'center',   	width:'2500'}, 	// 1:1상담
		            {label:'<spring:message code="common.label.tasks" /><spring:message code="common.label.evaluation" />',  		name:'asmntCnt',   		align:'center',   	width:'2500'}, 	// 과제평가
		            {label:'<spring:message code="common.label.discussion" /><spring:message code="common.label.evaluation" />',  	name:'forumCnt',   		align:'center',   	width:'2500'}, 	// 토론평가
		            {label:'<spring:message code="common.label.question" /><spring:message code="common.label.evaluation" />',  	name:'quizCnt',   		align:'center',   	width:'2500'}, 	// 퀴즈평가
		            {label:'<spring:message code="common.label.resh" /><spring:message code="common.label.evaluation" />',  		name:'reschCnt',   		align:'center',   	width:'2500'}, 	// 설문평가
		            {label:'<spring:message code="dashboard.cor.always.exam" />',  													name:'aexamCnt',   		align:'center',   	width:'2500'}, 	// 수시평가
		            {label:'<spring:message code="dashboard.exam_mid" />',  														name:'midExamInfo',   	align:'center',   	width:'12000'}, // 중간고사
		            {label:'<spring:message code="dashboard.exam_end" />',  														name:'lastExamInfo',   	align:'center',   	width:'12000'}, // 기말고사
	            ]
			};
			
			var url  = "/dashboard/downExcelLessonStatusByCrs.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: SEARCH_OBJ_1.haksaYear}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: SEARCH_OBJ_1.haksaTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ_1.univGbn}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ_1.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ_1.searchValue}));
			// 검색조건 Text
			form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',	value: SEARCH_OBJ_1.haksaTermNm}));
			form.append($('<input/>', {type: 'hidden', name: 'uniNm',		value: SEARCH_OBJ_1.uniNm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptNm',		value: SEARCH_OBJ_1.deptNm}));
			
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// 수업계획서 보기
		function viewLessonPlan(url) {
	    	window.open(url, "lessonPLan", "scrollbars=yes,width=900,height=950,location=no,resizable=yes");
		}
	
		// tab2.학생별 학습현황
		function listLessonStatusByStd() {
			if(!$("#crsCreCd2").val() || $("#crsCreCd2").val() == "ALL") {
				if(!$("#searchValue2").val()) {
					alert('<spring:message code="dashboard.alert.search.cond2" />'); // 과목선택 또는 검색어를 입력하세요.
					return;
				} else if ($("#searchValue2").val().length < 2) {
					alert('<spring:message code="dashboard.alert.empty.search.cond" />'); // 최소 2자이상 입력하세요.
					return;
				}
			}
			
			lessonStatusStdTable.clearData();
			
			var url = "/dashboard/listLessonStatusByStd.do";
			var param = {
				  haksaYear		: $("#haksaYear2").val()
				, haksaTerm		: $("#haksaTerm2").val()
				, univGbn		: ($("#univGbn2").val() || "").replace("ALL", "")
				, deptCd		: ($("#deptCd2").val() || "").replace("ALL", "")
				, crsCreCd		: ($("#crsCreCd2").val() || "").replace("ALL", "")
				, searchValue 	: $("#searchValue2").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					if(returnList.length == 0) {
						$("#tableResultNone2").show();
					} else {
						$("#tableResultNone2").hide();
					}
					
					var dataList = [];
					
					returnList.forEach(function(v, i) {
						var entrYy = v.entrYy;
						var entrHy = v.entrHy;
						var enterDt = "-";
						
						if(entrYy && entrHy) {
							enterDt = entrYy + "-" + entrHy;
						}
						
						var iconMap = {
							  COMPLETE	: '<i class="ico icon-solid-circle fcBlue"></i>'
							, LATE		: '<i class="ico icon-triangle fcYellow"></i>'
							, STUDY		: '<i class="ico icon-hyphen"></i>'
							, NOSTUDY	: '<i class="ico icon-cross fcRed"></i>'
							, READY		: '<i class="ico icon-slash"></i>'
						};
						
						var emptyIcon = '<i class="ico icon-slash"></i>';
						
						var icon1 = iconMap[v.studyStatusCd1] || emptyIcon;
						var icon2 = iconMap[v.studyStatusCd2] || emptyIcon;
						var icon3 = iconMap[v.studyStatusCd3] || emptyIcon;
						var icon4 = iconMap[v.studyStatusCd4] || emptyIcon;
						var icon5 = iconMap[v.studyStatusCd5] || emptyIcon;
						var icon6 = iconMap[v.studyStatusCd6] || emptyIcon;
						var icon7 = iconMap[v.studyStatusCd7] || emptyIcon;
						var icon8 = iconMap[v.studyStatusCd8] || emptyIcon;
						var icon9 = iconMap[v.studyStatusCd9] || emptyIcon;
						var icon10 = iconMap[v.studyStatusCd10] || emptyIcon;
						var icon11 = iconMap[v.studyStatusCd11] || emptyIcon;
						var icon12 = iconMap[v.studyStatusCd12] || emptyIcon;
						var icon13 = iconMap[v.studyStatusCd13] || emptyIcon;
						var icon14 = iconMap[v.studyStatusCd14] || emptyIcon;
						var icon15 = iconMap[v.studyStatusCd15] || emptyIcon;
						
						var examCntList = (v.examCnt || "0/0").split('/');
						var qnaCntList = (v.qnaCnt || "0/0").split('/');
						var secretCntList = (v.secretCnt || "0/0").split('/');
						var asmntCntList = (v.asmntCnt || "0/0").split('/');
						var forumCntList = (v.forumCnt || "0/0").split('/');
						var quizCntList = (v.quizCnt || "0/0").split('/');
						var reschCntList = (v.reschCnt || "0/0").split('/');
						var aexamCntList = (v.aexamCnt || "0/0").split('/');
						var seminarCntList = (v.seminarCnt || "0/0").split('/');
						
						dataList.push({
							hy:(v.hy || '-'), 
							enterDt:enterDt,
							userNm:'<i style="display:none">'+v.userNm+'</i><a href="javascript:lessonStatusPopModal(\'' + param.haksaYear + '\', \'' + param.haksaTerm + '\', \'' + v.userId + '\')" class="fcBlue">' + v.userNm + '</a>' + userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')"),
							userId:v.userId,
							deptNm:(v.deptNm || '-'),
							crsCreNm:'<i style="display:none">'+v.crsCreNm+'</i><a href="javascript:moveCreWin(\'' + v.crsCreCd + '\')" class="fcBlue">' + v.crsCreNm + ' (' + v.declsNo + ')</a>',
							week1:"<div class='weektop'>"+icon1+"</div><div class='weekBot'>"+icon9+"</div>",
							week2:"<div class='weektop'>"+icon2+"</div><div class='weekBot'>"+icon10+"</div>",
							week3:"<div class='weektop'>"+icon3+"</div><div class='weekBot'>"+icon11+"</div>",
							week4:"<div class='weektop'>"+icon4+"</div><div class='weekBot'>"+icon12+"</div>",
							week5:"<div class='weektop'>"+icon5+"</div><div class='weekBot'>"+icon13+"</div>",
							week6:"<div class='weektop'>"+icon6+"</div><div class='weekBot'>"+icon14+"</div>",
							week7:"<div class='weektop'>"+icon7+"</div><div class='weekBot'>"+icon15+"</div>",
							studyRate:v.studyRate + "%",
							examCnt:'<span class="fcBlue">' + examCntList[0] + '</span>/' + examCntList[1],
							qnaCnt:'<span class="fcBlue">' + qnaCntList[0] + '</span>/' + qnaCntList[1],
							secretCnt:'<span class="fcBlue">' + secretCntList[0] + '</span>/' + secretCntList[1],
							asmntCnt:'<span class="fcBlue">' + asmntCntList[0] + '</span>/' + asmntCntList[1],
							forumCnt:'<span class="fcBlue">' + forumCntList[0] + '</span>/' + forumCntList[1],
							quizCnt:'<span class="fcBlue">' + quizCntList[0] + '</span>/' + quizCntList[1],
							reschCnt:'<span class="fcBlue">' + reschCntList[0] + '</span>/' + reschCntList[1],
							aexamCnt:'<span class="fcBlue">' + aexamCntList[0] + '</span>/' + aexamCntList[1],
							seminarCnt:'<span class="fcBlue">' + seminarCntList[0] + '</span>/' + seminarCntList[1],
							valUserId:v.userId,
							valCrsCreCd:v.crsCreCd,
							valUserNm:v.userNm,
							valMobileNo:v.mobileNo,
							valEmail:v.email
						});
					});
					
					lessonStatusStdTable.addData(dataList);
					lessonStatusStdTable.redraw();
					
					SEARCH_OBJ_2 = param;
					SEARCH_OBJ_2.haksaTermNm = $("#haksaTerm2 > option:selected")[0].innerText;
					SEARCH_OBJ_2.uniNm = SEARCH_OBJ_2.univGbn ? $("#univGbn2 > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ_2.deptNm = SEARCH_OBJ_2.deptCd ? $("#deptCd2 > option:selected")[0].innerText : '<spring:message code="common.all" />';
					SEARCH_OBJ_2.crsCreNm = SEARCH_OBJ_2.crsCreCd ? $("#crsCreCd2 > option:selected")[0].innerText : '<spring:message code="common.all" />';
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// tab2.엑셀 다운로드
		function downExcel2() {
			if(!SEARCH_OBJ_2) {
				alert('<spring:message code="dashboard.alert.please.search" />'); // 먼저 검색을 하세요.
				return;
			}
			
			var statusIconMap = {
				  COMPLETE	: '○'
				, LATE		: '△'
				, STUDY		: '-'
				, NOSTUDY	: 'Ⅹ'
				, READY		: '/'
			}
			
			var excelGrid = {
				    colModel:[
			            {label:'<spring:message code="common.number.no" />',    		name:'lineNo',     		align:'right', 		width:'1000'},	// NO
			            {label:'<spring:message code="common.label.userdept.grade" />',	name:'hy',				align:'center',    	width:'2500'},	// 학년
			            {label:'<spring:message code="common.label.entrance" />',		name:'entrYy',			align:'center',    	width:'2500'},	// 입학
			            {label:'<spring:message code="common.label.entrance" />',		name:'entrHy',			align:'center',    	width:'2500'},	// 입학
			            {label:'<spring:message code="common.name" />',  				name:'userNm',			align:'left',    	width:'7000'}, 	// 이름
			            {label:'<spring:message code="common.label.student.number" />', name:'userId',			align:'left',    	width:'4000'}, 	// 학번
			            {label:'<spring:message code="common.dept_name" />',  			name:'deptNm',			align:'left',    	width:'7000'}, 	// 학과
			            {label:'<spring:message code="review.label.decls" />',  		name:'declsNo',   		align:'center',   	width:'2500'}, 	// 분반
			            {label:'<spring:message code="review.label.crscrenm" />',  		name:'crsCreNm',		align:'left',   	width:'7000'}, 	// 과목명
			            
			            {label:'1<spring:message code="common.week" />',  				name:'studyStatusCd1',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'2<spring:message code="common.week" />',  				name:'studyStatusCd2',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'3<spring:message code="common.week" />',  				name:'studyStatusCd3',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'4<spring:message code="common.week" />',  				name:'studyStatusCd4',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'5<spring:message code="common.week" />',  				name:'studyStatusCd5',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'6<spring:message code="common.week" />',  				name:'studyStatusCd6',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'7<spring:message code="common.week" />',  				name:'studyStatusCd7',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'8<spring:message code="common.week" />',  				name:'studyStatusCd8',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'9<spring:message code="common.week" />',  				name:'studyStatusCd9',   align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'10<spring:message code="common.week" />',  				name:'studyStatusCd10',  align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'11<spring:message code="common.week" />',  				name:'studyStatusCd11',  align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'12<spring:message code="common.week" />',  				name:'studyStatusCd12',  align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'13<spring:message code="common.week" />',  				name:'studyStatusCd13',  align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'14<spring:message code="common.week" />',  				name:'studyStatusCd14',  align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            {label:'15<spring:message code="common.week" />',  				name:'studyStatusCd15',  align:'center',   	width:'2000', codes: statusIconMap, defaultValue: "/"}, // 주차
			            
			            {label:'<spring:message code="dashboard.prog" />',  			name:'studyRate',   	align:'right',   	width:'2500'}, 	// 진도율
			            {label:'<spring:message code="dashboard.cor.exam" />',			name:'examCnt',   		align:'center',   	width:'2500', defaultValue: "0/0"}, // 시험
			            {label:'<spring:message code="dashboard.cor.qna" />',			name:'qnaCnt',   		align:'center',   	width:'2500'}, 	// Q&A
			            {label:'<spring:message code="dashboard.cor.councel" />',		name:'secretCnt',   	align:'center',   	width:'2500'}, 	// 1:1
			            {label:'<spring:message code="common.label.asmnt" />',			name:'asmntCnt',   		align:'center',   	width:'2500'}, 	// 과제
			            {label:'<spring:message code="common.label.forum" />',			name:'forumCnt',   		align:'center',   	width:'2500'}, 	// 토론
			            {label:'<spring:message code="common.label.question" />',		name:'quizCnt',   		align:'center',   	width:'2500'}, 	// 퀴즈
			            {label:'<spring:message code="common.label.resh" />',			name:'reschCnt',   		align:'center',   	width:'2500'}, 	// 설문
			            {label:'<spring:message code="dashboard.cor.admission" />',		name:'aexamCnt',   		align:'center',   	width:'2500'}, 	// 수시
			            {label:'<spring:message code="dashboard.seminar" />',			name:'seminarCnt',   	align:'center',   	width:'2500'}, 	// 세미나
		            ]
				};
			
			var url  = "/dashboard/downExcelLessonStatusByStd.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			
			form.append($('<input/>', {type: 'hidden', name: 'haksaYear',	value: SEARCH_OBJ_2.haksaYear}));
			form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', 	value: SEARCH_OBJ_2.haksaTerm}));
			form.append($('<input/>', {type: 'hidden', name: 'univGbn', 	value: SEARCH_OBJ_2.univGbn}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: SEARCH_OBJ_2.deptCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 	value: SEARCH_OBJ_2.crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: SEARCH_OBJ_2.searchValue}));

			// 검색조건 Text
			form.append($('<input/>', {type: 'hidden', name: 'haksaTermNm',	value: SEARCH_OBJ_2.haksaTermNm}));
			form.append($('<input/>', {type: 'hidden', name: 'uniNm',		value: SEARCH_OBJ_2.uniNm}));
			form.append($('<input/>', {type: 'hidden', name: 'deptNm',		value: SEARCH_OBJ_2.deptNm}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreNm',	value: SEARCH_OBJ_2.crsCreNm}));
			
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
			
			$("form[name=excelForm]").remove();
		}
		
		// tab2.학생별 학습현황 팝업
		function lessonStatusPopModal(haksaYear, haksaTerm, userId) {
			$("#lessonStatusPopForm > input[name='haksaYear']").val(haksaYear);
			$("#lessonStatusPopForm > input[name='haksaTerm']").val(haksaTerm);
			$("#lessonStatusPopForm > input[name='userId']").val(userId);
			$("#lessonStatusPopForm").attr("target", "lessonStatusPopIfm");
	        $("#lessonStatusPopForm").attr("action", "/dashboard/lessonStatusPop.do");
	        $("#lessonStatusPopForm").submit();
	        $('#lessonStatusPopModal').modal('show');
	        
	        $("#lessonStatusPopForm > input[name='haksaYear']").val("");
	        $("#lessonStatusPopForm > input[name='haksaTerm']").val("");
			$("#lessonStatusPopForm > input[name='userId']").val("");
		}
		
		// tab3.사용자 검색
		function listAdminDashUser(pageIndex) {
			var url = "/dashboard/listAdminDashUser.do";
			var data = {
				  haksaYear		: $("#haksaYear3").val()
				, haksaTerm		: $("#haksaTerm3").val()
				, deptCd			: ($("#deptCd3").val() || "").replace("ALL", "")
				, searchValue 	: $("#searchValue3").val()
				, pageIndex		: pageIndex
				, listScale			: 10
			};
			
			adminDashUserTable.clearData();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					if(returnList.length == 0) {
						$("#tableResultNone3").show();
					} else {
						$("#tableResultNone3").hide();
					}
					
					var dataList = [];
					var html = '';
					returnList.forEach(function(v, i) {
						var userInfoBtn = '';
						// TODO
						if(1 != 1) {
							userInfoBtn = '<a href="javascript:userInfoPop(\'' + v.userId + '\')"><i class="ico icon-info"></i></a>';
						}
						
						dataList.push({
							authGrpNm:v.authGrpNm, deptNm:v.deptNm, userId:v.userId + userInfoBtn,
							userNm:v.userNm, userGrade:(v.userGrade || '-'),
							//mobileNo:formatPhoneNumber(v.mobileNo), 
							//email:v.email,
							schregGbn:(v.schregGbn || '-'),
							linkHycu:(v.hycuUserId != null ? v.hycuUserNm+" ("+v.hycuUserId+")" : "-"),
							login:'<a href="javascript:loginByAdmin(\'' + v.userId + '\', \'' + v.userId + '\');" class="ui basic small button"><spring:message code="user.button.login" /></a>'
							
						});
					});
					
					adminDashUserTable.addData(dataList);
					adminDashUserTable.redraw();
					
					var params = {
						totalCount : data.pageInfo.totalRecordCount,
						listScale : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName : "listAdminDashUser"
					};
					
					gfn_renderPaging(params);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
	
		// 사용자 로그인
		function loginByAdmin(userId, userId, goUrl) {
		    var userSupportWin = window.open("", "userSupportWin");
			$("#userMoveForm").attr("action","/user/userHome/loginUserByAdmin.do");
			$("#userMoveForm > input[name='userId']").val(userId);
			$("#userMoveForm > input[name='userId']").val(userId);
			$("#userMoveForm > input[name='goUrl']").val(goUrl);
			$('#userMoveForm').submit();
			$("#virtualSupport").show();
			
			var closeUserTimer = setInterval(function() {
				if (userSupportWin.closed) {
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
					clearInterval(closeUserTimer);
				}
			}, 1000);
		};
	
		// 사용자 상세 정보
		function infoUserBar(userId) {
		    var url  = "/dashboard/dashboardUserView.do";
		    var form = $("<form></form>");
		    form.attr("method", "POST");
		    form.attr("name", "viewForm");
		    form.attr("action", url);
		    form.append($('<input/>', {type: 'hidden', name: 'userId', value: userId}));
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
		
		// 전체선택
		function checkAll(checked) {
			if(ACTIVE_TAB == 1) {
				$("#lessonStatusByCrsTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
			} else if(ACTIVE_TAB == 2) {
				$("#lessonStatusByStdTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
			} else if(ACTIVE_TAB == 3) {
				
			}
		}
		
		// 보내기
		function sendMsg(type) {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var dupCheckObj = {};
			var selectList = [];
			if (type == "crs") {
				selectList = lessonStatusByCrsTable.getSelectedRows();
			}
			else if (type == "std") {
				selectList = lessonStatusStdTable.getSelectedRows();
			}
			var $table;
			
			if(ACTIVE_TAB == 1) {
				$table = $("#lessonStatusByCrsTable");
			} else if(ACTIVE_TAB == 2) {
				$table = $("#lessonStatusByStdTable");
			} else if(ACTIVE_TAB == 3) {
				
			}
			
			var userMap = {};
			
			for(var i=0; i<selectList.length; i++) {
				var data = selectList[i].getData();
				if (data.valUserId == null) {
					continue;
				} 
				if (userMap[data.valUserId] == undefined) {
					userMap[data.valUserId] = 1;
				}
				else {
					continue;
				}
					
				sendCnt++;
				if (sendCnt > 1) {
					rcvUserInfoStr += "|";
				}
				
				rcvUserInfoStr += data.valUserId;
				rcvUserInfoStr += ";" + data.valUserNm;
				rcvUserInfoStr += ";" + data.valMobileNo;
				rcvUserInfoStr += ";" + data.valEmail;
			}

			if (selectList.length == 0) {
				/* 선택된 사용자가 없습니다. */
				alert('<spring:message code="std.alert.no_select_user" />');
				return;
			}
			
			//console.log(rcvUserInfoStr);
			
			var form = window.parent.alarmForm;
			form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	        form.submit();
	   	}
		
		// 전화번호 형식 변환
		function formatPhoneNumber(phoneNumber) {
		    if(!phoneNumber) {
		    	return "";
		    }
		    
		    var cleanInput = phoneNumber.replaceAll(/[^0-9]/g, "");
		    var result = "";
		    var length = cleanInput.length;
		    
		    if(length === 8) {
		        result = cleanInput.replace(/(\d{4})(\d{4})/, '$1-$2');
		    } else if(cleanInput.startsWith("02") && (length === 9 || length === 10)) {
		        result = cleanInput.replace(/(\d{2})(\d{3,4})(\d{4})/, '$1-$2-$3');
		    } else if(!cleanInput.startsWith("02") && (length === 10 || length === 11)) {
		        result = cleanInput.replace(/(\d{3})(\d{3,4})(\d{4})/, '$1-$2-$3');
		    } else {
		        result = phoneNumber;
		    }
		    
		    return result;
		}
		
	</script>

	<style>
		.weekTop {
		
		}
		.weekBot {
			border-top:1px dotted #d3d3d3;
		}
		.tabulator-col[tabulator-field="week1"] .tabulator-col-content,
		.tabulator-col[tabulator-field="week2"] .tabulator-col-content,
		.tabulator-col[tabulator-field="week3"] .tabulator-col-content,
		.tabulator-col[tabulator-field="week4"] .tabulator-col-content,
		.tabulator-col[tabulator-field="week5"] .tabulator-col-content,
		.tabulator-col[tabulator-field="week6"] .tabulator-col-content,
		.tabulator-col[tabulator-field="week7"] .tabulator-col-content,
		.tabulator-cell[tabulator-field="week1"],
		.tabulator-cell[tabulator-field="week2"],
		.tabulator-cell[tabulator-field="week3"],
		.tabulator-cell[tabulator-field="week4"],
		.tabulator-cell[tabulator-field="week5"],
		.tabulator-cell[tabulator-field="week6"],
		.tabulator-cell[tabulator-field="week7"] {
			padding-left:0 !important;
			padding-right:0 !important;
		}
		
	</style>
</head>
<body>
    <div id="wrap" class="pusher">

 		<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

		<!-- lnb / 사이드메뉴 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->
        
		<div id="container">
			<!-- 본문 content 부분 -->
			<div class="content">
				<div class="ui divider mt0"></div>
				
				<!--Tabs will be placed here-->
				<ul class="nav nav-tabs" id="tab_"></ul>
				
				<!--content of the tabs will be here-->
				<div id="tabContent_"></div>
						
			</div>
			<!-- //본문 content 부분 -->
		</div>
			
		<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %> --%>
    </div>
    
    <!-- 학생별 학습현황 팝업 -->
    <form id="lessonStatusPopForm" name="lessonStatusPopForm">
    	<input type="hidden" name="haksaYear" />
    	<input type="hidden" name="haksaTerm" />
    	<input type="hidden" name="userId" />
	</form>
    <div class="modal fade in" id="lessonStatusPopModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="dashboard.label.lesson.status.std"/>" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="dashboard.label.lesson.status.std"/><!-- 학생별 학습현황 --></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="lessonStatusPopIfm" name="lessonStatusPopIfm"></iframe>
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
    
   	<form id="creMoveForm" name="creMoveForm" method="post" target="creSupportWin">
		<input type="hidden" name="crsCreCd" value=""/>
		<input type="hidden" name="type" value="ADM"/>	
	</form>

   	<form id="userMoveForm" name="userMoveForm" method="post" target="userSupportWin">
		<input type="hidden" name="userId" value=""/>
		<input type="hidden" name="userId" value=""/>
		<input type="hidden" name="modChgFromMenuCd" value="ADM0000000001"/>
		<input type="hidden" name="goUrl" value=""/>
	</form>
</body>
</html>