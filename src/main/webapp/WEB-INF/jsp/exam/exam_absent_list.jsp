<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%-- <%@ include file="/WEB-INF/jsp/common/main_common.jsp" %> --%>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%-- <%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" /> --%>
<script type="text/javascript">
	$(document).ready(function() {
		listExamAbsent(1);
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listExamAbsent(1);
			}
		});
	});
	
	// 결시원 목록 조회
	function listExamAbsent(page) {
		var url  = "/exam/examAbsentListPaging.do";
		var data = {
			"creYear"     		: $("#creYear").val(),
			"creTerm"     		: $("#creTerm").val(),
			"examStareTypeCd"   : $("#examStareTypeCd").val(),
			"apprStat"  		: $("#apprStat").val(),
			"searchValue" 		: $("#searchValue").val(),
			"listScale"   		: $("#listScale").val(),
			"searchFrom"		: "${userId}",
			"pageIndex"			: page,
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		var appCntObj = {};
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				var regDttm    = dateFormat("date", v.regDttm);
        				var modDttm    = v.modDttm && (v.apprStat == "APPROVE" || v.apprStat == "COMPANION") ? dateFormat("date", v.modDttm) : "-";
        				var modNm	   = v.apprStat == "APPROVE" || v.apprStat == "COMPANION" ? v.modNm : "-";
        				var apprStatNm = v.apprStat == "APPLICATE" ? "<spring:message code='exam.label.applicate' />"/* 신청 */ : v.apprStat == "RAPPLICATE" ? "<spring:message code='exam.label.rapplicate' />"/* 재신청 */ : v.apprStat == "APPROVE" ? "<spring:message code='exam.label.approve' />"/* 승인 */ : v.apprStat == "COMPANION" ? "<spring:message code='exam.label.companion' />"/* 반려 */ : "";
        				/* if(v.apprStat == "APPLICATE" || v.apprStat == "RAPPLICATE") {
        					appCnt += 1;
        				} */
        				appCntObj[v.userId] = true;
        				
        				var color = "";
        				
        				if(v.apprStat == "APPLICATE" || v.apprStat == "RAPPLICATE") {
        					color = "fcBlue";
        				} else if(v.apprStat == "APPROVE") {
        					color = "fcGreen";
        				} else if(v.apprStat == "COMPANION") {
        					color = "fcRed";
        				}
        				
        				var examStareTypeNm = "";
        				
        				if(v.examStareTypeCd == "M") {
        					examStareTypeNm = '<span class="fcGreen"><spring:message code="exam.label.mid.exam" /></span>';
        				} else if(v.examStareTypeCd == "L") {
        					examStareTypeNm = '<span class="fcBrown"><spring:message code="exam.label.end.exam" /></span>';
        				}
        				
        				html += `<tr>`;
        				html += `	<td>`;
        				html += `		<div class='ui checkbox'>`;
        				html += `			<input type='checkbox' name='evalChk' id='evalChk\${v.lineNo}' onchange="checkUser(this)" user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
        				html += `			<label class='toggle_btn' for='evalChk\${v.lineNo}'></label>`;
        				html += `		</div>`;
        				html += `		\${v.lineNo}`;
        				html += `	</td>`;
        				html += `	<td>\${v.deptNm}</td>`;
        				html += `	<td>\${v.userId}</td>`;
        				html += `	<td class='word_break_none'>`;
        				html += `		<a class="fcBlue" href="javascript:viewExamAbsent('\${v.stdNo}', '\${v.crsCreCd}', '\${v.examAbsentCd}')">\${v.userNm}</a>`;
        				html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
        				html += `	</td>`;
        				html += `	<td>\${v.crsCreNm}</td>`;
        				html += `	<td>\${v.declsNo}</td>`;
        				html += `	<td><a class="\${color}" href="javascript:viewExamAbsent('\${v.stdNo}', '\${v.crsCreCd}', '\${v.examAbsentCd}')">\${apprStatNm}</a></td>`;
        				html += `	<td>\${regDttm}</td>`;
        				html += `	<td>\${examStareTypeNm}</td>`;
        				html += `	<td>\${v.examStareYn}</td>`;
        				html += `	<td>\${modDttm}</td>`;
        				html += `	<td>\${modNm}</td>`;
        				html += `</tr>`;
        			});
        		}
        		
        		$("#examAbsentCnt").text(Object.keys(appCntObj).length);
        		$("#examAbsentList").empty().html(html);
        		$(".table").footable();
        		var params = {
		    		totalCount 	  : data.pageInfo.totalRecordCount,
		    		listScale 	  : data.pageInfo.pageSize,
		    		currentPageNo : data.pageInfo.currentPageNo,
		    		eventName 	  : "listExamAbsent"
		    	};
		    		
		    	gfn_renderPaging(params);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 결시원 신청 내역 팝업
	function viewExamAbsent(stdNo, crsCreCd, examAbsentCd) {
		var kvArr = [];
		kvArr.push({'key' : 'stdNo',		'val' : stdNo});
		kvArr.push({'key' : 'crsCreCd', 	'val' : crsCreCd});
		kvArr.push({'key' : 'examAbsentCd', 'val' : examAbsentCd});
		kvArr.push({'key' : 'termCd', 		'val' : "${termVO.termCd}"});
		
		submitForm("/exam/examAbsentViewPop.do", "examPopIfm", "absent", kvArr);
	}
	
	// 결시원 엑셀 다운로드
	function examAbsentExcelDown() {
		var excelGrid = {
			colModel:[
			   {label:"<spring:message code='main.common.number.no' />", 				name:'lineNo',        	align:'center',  width:'1000'},	
			   {label:"<spring:message code='exam.label.dept' />",    					name:'deptNm',   	   	align:'left',    width:'5000'},/* 학과 */
			   {label:"<spring:message code='exam.label.user.no' />",   				name:'userId',   	   	align:'left',    width:'5000'},/* 학번 */
			   {label:"<spring:message code='exam.label.user.nm' />",    				name:'userNm',        	align:'right',   width:'5000'},/* 이름 */
			   {label:"<spring:message code='crs.label.crecrs.nm' />",  				name:'crsCreNm',   		align:'right',   width:'5000'},/* 과목명 */
			   {label:"<spring:message code='crs.label.decls' />",  					name:'declsNo',    		align:'right',   width:'5000'},/* 분반 */
			   {label:"<spring:message code='exam.label.process.status' />", 	 		name:'apprStat', 		align:'right',   width:'5000', codes:{APPLICATE:"<spring:message code='exam.label.applicate' />",RAPPLICATE:"<spring:message code='exam.label.rapplicate' />",APPROVE:"<spring:message code='exam.label.approve' />",COMPANION:"<spring:message code='exam.label.companion' />"}},/* 처리상태 *//* 신청 *//* 재신청 *//* 승인 *//* 반려 */
			   {label:"<spring:message code='exam.label.applicate.dt' />", 	 			name:'regDttm', 		align:'right',   width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}},/* 신청일 */
			   {label:"<spring:message code='exam.label.exam.stare.type' />", 	 		name:'examStareTypeNm', align:'right',   width:'5000'},/* 시험구분 */
			   {label:"<spring:message code='exam.label.real.time.exam.answer.yn' />", 	name:'examStareYn', 	align:'right',   width:'5000'},/* 실시간시험응시여부 */
			   {label:"<spring:message code='exam.label.process.dttm' />", 	 			name:'modDttm', 		align:'right',   width:'5000', formatter: 'date', formatOptions: {srcformat:'yyyyMMddHHmmss', newformat: 'yyyy.MM.dd HH:mm', defaultValue: '-'}},/* 처리일시 */
			   {label:"<spring:message code='exam.label.process.manage' />", 	 		name:'modNm', 			align:'right',   width:'5000'},/* 처리담당자 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'creYear', 		   'val' : $("#creYear").val()});
		kvArr.push({'key' : 'creTerm', 		   'val' : $("#creTerm").val()});
		kvArr.push({'key' : 'examStareTypeCd', 'val' : $("#examStareTypeCd").val()});
		kvArr.push({'key' : 'apprStat', 	   'val' : $("#apprStat").val()});
		kvArr.push({'key' : 'searchValue', 	   'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'searchFrom', 	   'val' : "${userId}"});
		kvArr.push({'key' : 'excelGrid', 	   'val' : JSON.stringify(excelGrid)});
		
		submitForm("/exam/examAbsentExcelDown.do", "", "", kvArr);
	}
	
	//사용자 정보 팝업
 	function userInfoPop(userId) {
 		var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
 		var options = 'top=100, left=150, width=1200, height=800';
 		window.open(userInfoUrl, "", options);
 	}
	
 	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		var dupCheckObj = {};
		
		$.each($('#examAbsentList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
			var userId = $(this).attr("user_id");
			
			if (dupCheckObj[userId])
				return true;
			dupCheckObj[userId] = true;
			
			sendCnt++;
			if (sendCnt > 1) rcvUserInfoStr += "|";
			rcvUserInfoStr += userId;
			rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
			rcvUserInfoStr += ";" + $(this).attr("mobile");
			rcvUserInfoStr += ";" + $(this).attr("email"); 
		});
		
		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert("<spring:message code='common.alert.sysmsg.select_user'/>");
			return;
		}
		
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

        var form = document.alarmForm;
        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
	}
 	
 	// 체크박스 이벤트
 	function checkUser(obj) {
 		if(obj.value == "all") {
 			$("input[name=evalChk]").prop("checked", obj.checked);
 		} else {
 			$("#allChk").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
 		}
 	}
 	
 	// 결시원 정리
 	function absentAllCompanion() {
 		var termCd = '<c:out value="${termVO.termCd}" />';
 		
 		if(!termCd) {
 			alert("<spring:message code='sys.alert.already.job.sch' />"); // 등록된 일정이 없습니다.
 			return;
 		}
 		
		var url = "/jobSchHome/viewSysJobSch.do";
		var data = {
			"calendarCtgr" : "00190901",
			"termCd"	   : termCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO != null) {
					var jobSchPeriodYn = returnVO.jobSchPeriodYn;
					
					if(jobSchPeriodYn == "Y") {
						var confirm = window.confirm("<spring:message code='exam.confirm.select.term.absent.batch.companion' />"); // 선택 학기 실시간 시험응시자 신청 내역을 일괄 반려 하시겠습니까?
						
						if(confirm) {
							var apprCts = "<spring:message code='exam.label.batch.companion' />";// 일괄 반려 
							
							var url  = "/exam/updateAllCompanionProf.do";
							var data = {
								"creYear" : "${termVO.haksaYear}",
								"creTerm" : "${termVO.haksaTerm}",
								"apprCts" : apprCts
							};
							
							ajaxCall(url, data, function(data) {
								if (data.result > 0) {
									alert("<spring:message code='exam.alert.batch.companion' />");// 일괄 반려 처리 완료되었습니다.
									window.parent.listExamAbsent(1);
									window.parent.closeModal();
					            } else {
					             	alert(data.message);
					            }
							}, function(xhr, status, error) {
								alert("<spring:message code='exam.error.batch.companion' />");// 일괄 반려 처리 중 에러가 발생하였습니다.
							});
						}
					} else {
						alert("<spring:message code='exam.alert.absent.approve.not.datetime' />");// 결시원 승인은 승인기간 안에만 가능합니다.
					}
				} else {
					alert("<spring:message code='sys.alert.already.job.sch' />"); // 등록된 일정이 없습니다.
				}
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
		});
	}
 	
 	// 결시원 추가 팝업
	function addAbsentPop() {
		$("#absentAddForm input[name=creYear]").val($("#creYear").val());
		$("#absentAddForm input[name=creTerm]").val($("#creTerm").val());
		
		var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'creYear', 	  'val' : $("#creYear").val()});
		kvArr.push({'key' : 'creTerm', 	  'val' : $("#creTerm").val()});
		kvArr.push({'key' : 'goUrl', 	  'val' : "/exam/examMgr/addExamAbsentPop.do"});
		kvArr.push({'key' : 'subParam',   'val' : "tempForm|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : "popup"});
		
		submitForm("/exam/examMgr/addExamAbsentPop.do", "examPopIfm", "addAbsent", kvArr);
	}
</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="main">
        <%-- <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %> --%>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		
		<div id="container">
			<%-- <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %> --%>
			
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<div class="ui form">
	        		<div class="layout2">
	        			<div class="classInfo">
                			<div class="mra">
                				<h2 class="page-title"><spring:message code="exam.label.absent" /><!-- 결시원 --></h2>
                			</div>
                		</div>
			            <div class="row">
			            	<div class="col">
					            <p class="f110"><spring:message code="exam.label.absent.info" /></p><!-- 결시원 신청 확인 및 승인 처리를 합니다 -->
					            <div class="option-content mt20">
									<select class="ui dropdown" id="creYear" onchange="listExamAbsent(1)">
										<option value=""><spring:message code="exam.label.open.year" /></option><!-- 개설년도 -->
										<c:forEach var="item" items="${yearList }">
											<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
										</c:forEach>
								    </select>
									<select class="ui dropdown" id="creTerm" onchange="listExamAbsent(1)">
										<option value=""><spring:message code="exam.label.open.term" /></option><!-- 개설학기 -->
										<c:forEach var="list" items="${termList }">
											<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
										</c:forEach>
								    </select>
									<select class="ui dropdown" id="examStareTypeCd" onchange="listExamAbsent(1)">
										<option value="ALL"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
								        <option value="M"><spring:message code="exam.label.mid.exam" /></option><!-- 중간고사 -->
								        <option value="L"><spring:message code="exam.label.end.exam" /></option><!-- 기말고사 -->
								    </select>
								    <select class="ui dropdown" id="apprStat" onchange="listExamAbsent(1)">
										<option value=""><spring:message code="exam.label.approve.yn" /></option><!-- 승인여부 -->
								        <option value="ALL"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
								        <option value="APPLICATE"><spring:message code="exam.label.applicate" /></option><!-- 신청 -->
								        <option value="APPROVE"><spring:message code="exam.label.approve" /></option><!-- 승인 -->
								        <option value="COMPANION"><spring:message code="exam.label.companion" /></option><!-- 반려 -->
								    </select>
								    <div class="ui action input search-box">
								        <input type="text" placeholder="<spring:message code='exam.label.dept' />/<spring:message code='exam.label.user.no' />/<spring:message code='exam.label.user.nm' /> <spring:message code='exam.label.input' />" id="searchValue" class="w250"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
								        <button class="ui icon button" onclick="listExamAbsent(1)"><i class="search icon"></i></button>
								    </div>
								    <div class="flex-left-auto">
								    	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
								    	<a href="javascript:absentAllCompanion()" class="ui blue button" title="해당 학기 결시원 제출한 모든 학생 결시원 상태를 반려로 변경하는 기능"><spring:message code="exam.label.absent.clean" /></a><!-- 결시원 정리 -->
								    	<a href="javascript:addAbsentPop()" class="ui blue button"><spring:message code="exam.button.add" /><!-- 추가 --></a>
								    	<a class="ui blue button" href="javascript:examAbsentExcelDown()"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
									</div>
								</div>
								<div class="mt15 mb15 tc bcYellow p10">
									<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
									<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
							    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
									<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
							    	<spring:message code="exam.label.absent" /> <spring:message code="exam.label.applicate" /> <spring:message code="exam.label.approve.dttm" /> : ${schStartDt } ~ ${schEndDt }<!-- 결시원 --><!-- 신청 --><!-- 승인기간 -->
							    </div>
							    <div class="option-content pr10 pb10">
								    <div class="flex-left-auto">
								    	[ <spring:message code="exam.label.support.cnt" /> : <span id="examAbsentCnt"></span><spring:message code="exam.label.nm" /> ] <!-- 지원인원 --><!-- 명 -->
								    	<select class="ui dropdown ml5 list-num" id="listScale" onchange="listExamAbsent(1)">
							                <option value="10">10</option>
							                <option value="20">20</option>
							                <option value="50">50</option>
							                <option value="100">100</option>
							            </select>
								    </div>
							    </div>
							    <table class="table type2 mt20" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
									<thead>
										<tr>
											<th scope="col">
												<div class="ui checkbox">
									                <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkUser(this)">
									                <label class="toggle_btn" for="allChk"></label>
									            </div>
									            NO.
											</th>
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
											<th scope="col"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
											<th scope="col"><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="crs.label.decls" /></th><!-- 분반 -->
											<th scope="col"><spring:message code="exam.label.process.status" /></th><!-- 처리상태 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.applicate" /><spring:message code="exam.label.dttm" /></th><!-- 신청 --><!-- 일자 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.exam" /><spring:message code="exam.label.stare.type" /></th><!-- 시험 --><!-- 구분 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="exam.label.real.time.exam" /><spring:message code="exam.label.answer.yn" /></th><!-- 실시간시험 --><!-- 응시여부 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="exam.label.process.dttm" /></th><!-- 처리일시 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="exam.label.process.manage" /></th><!-- 처리담당자 -->
										</tr>
									</thead>
									<tbody id="examAbsentList">
									</tbody>
								</table>
								<div id="paging" class="paging wmax"></div>
			            	</div>
			            </div>
	        		</div>
	        	</div>
	        </div>
	        <!-- //본문 content 부분 -->
	        <%-- <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %> --%>
		</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
		<form id="absentAddForm" method="POST">
			<input type="hidden" name="userId" />
			<input type="hidden" name="userNm" />
			<input type="hidden" name="creYear" />
			<input type="hidden" name="creTerm" />
			<input type="hidden" name="goUrl" value="/exam/examMgr/addExamAbsentPop.do" />
			<input type="hidden" name="subParam" value="absentAddForm|examPopIfm|examPop" />
			<input type="hidden" name="searchMenu" value="popup" />
			<input type="hidden" name="searchType" value="PROFESSOR" />
		</form>
    </div>
</body>
</html>