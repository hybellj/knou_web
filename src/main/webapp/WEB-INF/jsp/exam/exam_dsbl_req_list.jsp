<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%-- <%@ include file="/WEB-INF/jsp/common/main_common.jsp" %> --%>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<%-- <%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %> --%>
<!-- <link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" /> -->
<script type="text/javascript">
	$(document).ready(function() {
		listCreCrsCd();
		listExamDsblReq();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listExamDsblReq();
			}
		});
	});
	
	// 학기별 과목 목록 조회
	function listCreCrsCd() {
		var url = "/crs/creCrsHome/listTchCrsCreByTerm.do";
		var data = {
			"searchMenu" : "selectYear",
			"creYear"    : $("#creYear").val(),
			"creTerm"    : $("#creTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		
        		html += "<option value='ALL'><spring:message code='exam.common.search.all' /></option>";/* 전체 */
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				html += "<option value=\""+v.crsCreCd+"\">"+v.crsCreNm+"</option>";
        			});
        		}
        		$("#selectCrsCreCd").empty().append(html);
        		$("#selectCrsCreCd").siblings("div").attr("style", "color:#2185d0 !important;");
        		listExamDsblReq();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 전체 장애 학생 목록 조회
	function listExamDsblReq() {
		var url  = "/exam/allExamDsblReqList.do";
		var data = {
			creYear     	: $("#creYear").val(),
			creTerm     	: $("#creTerm").val(),
			crsCreCd		: ($("#selectCrsCreCd").val() || "").replace("ALL", ""),
			examStareTypeCd	: ($("#examStareTypeCd").val() || "").replace("ALL", ""),
			apprStat  		: ($("#apprStat").val() || "").replace("ALL", ""),
			searchValue 	: $("#searchValue").val(),
			searchFrom  	: "${userId}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		
       			returnList.forEach(function(v, i) {
       				var dsblReqCd      = v.midApprStat != null ? v.dsblReqCd : '';
       				var disabilityCdNm = v.disabilityCdNm == null ? "-" : v.disabilityCdNm;
       				
       				var appliExamList = [];
       				var examReqList = [];
       				var addTimeList = [];
       				
       				if(v.disablilityExamYn == "Y") {
       					if(v.midExamYn == "Y") {
        					appliExamList.push("<spring:message code='exam.label.mid' />"); // 중간
        					examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
        				}
       					
       					if(v.lastExamYn == "Y") {
        					appliExamList.push("<spring:message code='exam.label.final' />"); // 기말
        					examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
        				}
       					
       					if(v.midApprStat || v.endApprStat) {
       						if(v.midExamYn == "Y") {
       							addTimeList.push("<spring:message code='exam.label.late' />("+v.midAddTime+"<spring:message code='exam.label.stare.min' />)"); // 연장 분
       						} 
       						
       						if(v.lastExamYn == "Y") {
       							addTimeList.push("<spring:message code='exam.label.late' />("+v.endAddTime+"<spring:message code='exam.label.stare.min' />)"); // 연장 분
       						}
       					}
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
       				html += `	<td>`;
       				if(v.disablilityExamYn == "Y") {
       				html += `		<a class="fcBlue" href="javascript:viewExamDsblReq('\${v.stdNo}', '\${v.crsCreCd}', '\${dsblReqCd}')">\${v.userNm}</a>`;
       				} else {
       				html += `		\${v.userNm}`;
       				}
       				html += `	</td>`;
       				html += `	<td>\${v.crsCreNm}</td>`;
       				html += `	<td>\${v.declsNo}</td>`;
       				html += `	<td>\${v.schregGbn ? v.schregGbn : '-'}</td>`;
       				html += `	<td>\${disabilityCdNm}</td>`;
       				html += `	<td>\${v.disabilityLvNm}</td>`;
       				html += '	<td>' + (appliExamList.join("/") || "-") + '</td>';
       				html += '	<td>' + (examReqList.join("/") || "-") + '</td>';
       				html += '	<td>' + (addTimeList.join("/") || "-") + '</td>';
       				html += '</tr>';
       			});
        		
        		$("#examDsblReqCnt").text(returnList.length);
        		$("#examDsblReqList").empty().html(html);
        		$(".table").footable();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			/* 리스트 조회 중 에러가 발생하였습니다. */
			alert("<spring:message code='exam.error.list' />");
		});
	}
	
	// 지원 신청 정보 팝업
	function viewExamDsblReq(stdNo, crsCreCd, dsblReqCd) {
		var url = "/jobSchHome/viewSysJobSch.do";
		var data = {
			"crsCreCd"     : crsCreCd,
			"calendarCtgr" : "00190806", // 시험지원요청(교수)
			"termCd"	   : "${termVO.termCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO != null) {
					var jobSchPeriodYn = returnVO.jobSchPeriodYn;
					var jobSchExcPeriodYn = returnVO.jobSchExcPeriodYn;
					
					if(jobSchPeriodYn == "Y" || jobSchExcPeriodYn == "Y") {
						var kvArr = [];
						kvArr.push({'key' : 'stdNo', 	 'val' : stdNo});
						kvArr.push({'key' : 'crsCreCd',  'val' : crsCreCd});
						kvArr.push({'key' : 'dsblReqCd', 'val' : dsblReqCd});
						
						submitForm("/exam/viewExamDsblReqPop.do", "examPopIfm", "dsblReq", kvArr);
					} else {
						/* 시험지원 승인은 승인기간 안에만 가능합니다. */
						alert("<spring:message code='exam.alert.dsbl.req.approve.not.datetime' />");
					}
				} else {
					/* 등록된 일정이 없습니다. */
					alert("<spring:message code='sys.alert.already.job.sch' />");
				}
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			/* 정보 조회 중 에러가 발생하였습니다. */
			alert("<spring:message code='exam.error.info' />");
		});
	}
	
	// 장애 시험 지원 엑셀 다운로드
	function examDsblReqExcelDown() {
		var excelGrid = {
		    colModel:[
		       {label:"<spring:message code='main.common.number.no' />",        name:'lineNo',          align:'right',  width:'1000'},/* NO */
		       {label:"<spring:message code='exam.label.dept' />",    			name:'deptNm',     		align:'left',	width:'5000'},/* 학과 */
		       {label:"<spring:message code='exam.label.user.no' />",   		name:'userId',     		align:'left',	width:'5000'},/* 학번 */
		       {label:"<spring:message code='exam.label.user.nm' />",    		name:'userNm',     		align:'left',   width:'5000'},/* 이름 */
		       {label:"<spring:message code='crs.label.crecrs.nm' />",  		name:'crsCreNm',   		align:'left',	width:'5000'},/* 과목명 */
		       {label:"<spring:message code='crs.label.decls' />",  			name:'declsNo',    		align:'left',   width:'5000'},/* 분반 */
		       {label:"<spring:message code='exam.label.academic.status' />", 	name:'schregGbn',		align:'left',	width:'5000'},/* 학적상태 */
		       {label:"<spring:message code='exam.label.dsbl.req.type' />", 	name:'disabilityCdNm',	align:'left',	width:'5000'},/* 장애종류 */
		       {label:"<spring:message code='exam.label.dsbl.req.degree' />", 	name:'disabilityLvNm',	align:'left',	width:'5000'},/* 장애정도 */
		       //{label:"<spring:message code='exam.label.applicate.term' />", 	name:'registerTerm',	align:'right',   width:'5000'},/* 신청학기 */
		       //{label:"<spring:message code='exam.label.std.request' />", 		name:'stdRequest',		align:'right',   width:'5000'},/* 학생요청사항 */
		       //{label:"<spring:message code='exam.label.request.result' />", 	name:'addTime',			align:'right',   width:'5000'},/* 요청결과 */
		       {label:"<spring:message code='exam.label.late.time.mid.exam' />", name:'midAddTime', 	align:'center', width:'5000'},/* 연장시간(분) 중간고사 */
			   {label:"<spring:message code='exam.label.late.time.end.exam' />", name:'endAddTime', 	align:'center', width:'5000'},/* 연장시간(분) 기말고사 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'creYear', 	   		'val' : $("#creYear").val()});
		kvArr.push({'key' : 'creTerm', 	   		'val' : $("#creTerm").val()});
		kvArr.push({'key' : 'crsCreCd',    		'val' : ($("#selectCrsCreCd").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'examStareTypeCd',	'val' : ($("#examStareTypeCd").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'apprStat',  		'val' : ($("#apprStat").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'searchValue', 		'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'searchFrom',  		'val' : "${userId}"});
		kvArr.push({'key' : 'excelGrid',   		'val' : JSON.stringify(excelGrid)});
		
		submitForm("/exam/examDsblReqExcelDown.do", "", "", kvArr);
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
		
		$.each($('#examDsblReqList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
			if(!rcvUserInfoStr.includes($(this).attr("user_id"))) {
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_id");
				rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email"); 
			}
		});
		
		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert('<spring:message code="common.alert.sysmsg.select_user" />');
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
</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="main">
        <%-- <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %> --%>
		<!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->
        <!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->
        
		<div id="container">
			<%-- <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %> --%>
			
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<div class="ui form">
	        		<div class="layout2">
	        			<div class="classInfo">
                			<div class="mra">
                				<h2 class="page-title"><spring:message code="exam.label.dsbl.req" /><!-- 장애인 시험지원 --></h2>
                			</div>
                		</div>
		        		<div class="row">
		        			<div class="col">
					            <p class="f110 ml50"><spring:message code="exam.label.dsbl.req.info" /></p><!-- 장애 학생 시험 지원요청 확인 및 승인 처리를 합니다 -->
					            <div class="mt15 mb15 tc bcYellow p10">
					            	<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
									<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
							    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
									<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
							    	<spring:message code="exam.label.dsbl.req.approve.dttm" /> : ${schStartDt } ~ ${schEndDt }<!-- 장애 학생 시험지원 승인기간 -->
							    </div>
							    <%--
							    <div class="p20">
								    <p>* <spring:message code="exam.label.dsbl.req.msg1" /> <!-- 자세한 장애인 등급 판정기준은 보건복지부 > 장애인 정책 > 알림마당 -->
								    	<a class="fcBlue" href="http://www.mohw.go.kr/react/policy/index.jsp?PAR_MENU_ID=06&MENU_ID=06370111&PAGE=11&topTitle=%EC%9E%A5%EC%95%A0%EC%9D%B8%EB%93%B1%EB%A1%9D/%EC%9E%A5%EC%95%A0%EC%A0%95%EB%8F%84%20%EC%8B%AC%EC%82%AC%EC%A0%9C%EB%8F%84">[<spring:message code="exam.button.short.cut" />]</a><!-- 바로가기 -->
								    	<spring:message code="exam.label.dsbl.req.msg2" /></p><!-- 를 참조하세요. -->
								    <p>* <spring:message code="exam.label.dsbl.req.msg3" /></p><!-- 청각장애학생이 자막/스크립트가 없는 과목 수강 시 추가 제공이 가능합니다. 청각장애 학생 요청 시 콘텐츠 개발팀으로 문의해 주세요. -->
							    </div>
							    --%>
							    <div class="option-content pl10 mt40">
								    <h3 class="sec_head inline-block pr20"><spring:message code="exam.label.std" /></h3><!-- 학습자 -->
								    <span>[ <spring:message code="exam.label.total.cnt" /> : <label id="examDsblReqCnt" class="fcBlue"></label> ]</span><!-- 총 건수 -->
							    </div>
					            <div class="option-content p10">
									<select class="ui dropdown" id="creYear" onchange="listCreCrsCd()">
										<option value=""><spring:message code="exam.label.open.year" /></option><!-- 개설년도 -->
										<c:forEach var="item" items="${yearList }">
											<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
										</c:forEach>
								    </select>
									<select class="ui dropdown" id="creTerm" onchange="listCreCrsCd()">
										<option value=""><spring:message code="exam.label.open.term" /></option><!-- 개설학기 -->
										<c:forEach var="list" items="${termList }">
											<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
										</c:forEach>
								    </select>
									<select class="ui dropdown" id="examStareTypeCd" onchange="listExamDsblReq()">
										<option value="ALL"><spring:message code="exam.label.exam.stare.type" /></option><!-- 시험구분 -->
								        <option value="M"><spring:message code="exam.label.mid.exam" /></option><!-- 중간고사 -->
								        <option value="L"><spring:message code="exam.label.end.exam" /></option><!-- 기말고사 -->
								    </select>
								    <select class="ui dropdown" id="apprStat" onchange="listExamDsblReq()">
										<option value=""><spring:message code="exam.label.process.yn" /></option><!-- 처리여부 -->
								        <option value="ALL"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
								        <option value="WAIT"><spring:message code="exam.label.applicate.n" /></option><!-- 미신청자 -->
								        <option value="COMPL"><spring:message code="exam.label.applicate.y" /></option><!-- 신청자 -->
								    </select>
								    <select class="ui dropdown fcBlue" id="selectCrsCreCd" onchange="listExamDsblReq()">
								    	<option value=""><spring:message code="exam.label.sel.crs" /></option><!-- 과목 선택 -->
								    </select>
								    <div class="ui action input search-box">
								        <input type="text" placeholder="<spring:message code="team.popup.search.placeholder" />" id="searchValue" class="w250"><!-- 학과, 학번, 이름 입력 -->
								        <button class="ui icon button" onclick="listExamDsblReq()"><i class="search icon"></i></button>
								    </div>
								    <div class="flex-left-auto">
								    	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
								    	<a class="ui blue button" href="javascript:examDsblReqExcelDown()"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
									</div>
								</div>
							    <table class="table type2 mt20" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
							    	<caption class="hide">list table</caption>
									<thead>
										<tr>
											<th scope="col">
												<div class="ui checkbox">
									                <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkUser(this)">
									                <label class="toggle_btn" for="allChk"></label>
									            </div>
									            <spring:message code="common.number.no" />
											</th>
											<th scope="col" data-breakpoints="xs sm"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
											<th scope="col"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
											<th scope="col"><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
											<th scope="col" data-breakpoints="xs sm"><spring:message code="crs.label.decls" /></th><!-- 분반 -->
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.academic" /><spring:message code="exam.label.situation" /></th><!-- 학적 --><!-- 상태 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.dsbl.req.type" /></th><!-- 장애종류 -->
											<th scope="col" data-breakpoints="xs"><spring:message code="exam.label.dsbl.req.degree" /></th><!-- 장애정도 -->
											<th scope="col" data-breakpoints="xs sm md"><spring:message code="exam.label.applicate" /><spring:message code="exam.label.term" /></th><!-- 신청 --><!-- 학기 -->
											<th scope="col"><spring:message code="exam.label.std.request" /></th><!-- 학생요청사항 -->
											<th scope="col"><spring:message code="exam.label.request.result" /></th><!-- 요청결과 -->
										</tr>
									</thead>
									<tbody id="examDsblReqList">
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
    </div>
    
</body>
</html>