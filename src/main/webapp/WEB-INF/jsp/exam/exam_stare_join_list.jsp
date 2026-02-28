<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		examStareJoinList();
		if("${vo.examType}" == "EXAM") {
			if("${waitVO.midExamWaitYn}" == "N")  chartSet('M');
			if("${waitVO.lastExamWaitYn}" == "N") chartSet('L');
		} else {
			chartSet('A');
		}
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				examStareJoinList();
			}
		});
		
		$("#searchKey").closest("div").css("z-index", "999");
		$("#searchFrom").closest("div").css("z-index", "999");
	});
	
	// 시험 목록 페이지
	function examListForm() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});
		kvArr.push({'key' : 'examType', 'val' : "${vo.examType}"});
		
		submitForm("/exam/Form/examList.do", "", "", kvArr);
	}
	
	// 중간/기말/수시 참여현황 목록 조회
	function examStareJoinList() {
		var url  = "/exam/examStareJoinList.do";
		var data = {
			"examCd"	  : "${vo.examCd}",
			"examType"	  : "${vo.examType}",
			"crsCreCd" 	  : "${creCrsVO.crsCreCd}",
			"searchValue" : $("#searchValue").val(),
			"searchKey"   : $("#searchKey").val(),
			"searchFrom"  : $("#searchFrom").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				var midReplaceColor = v.midApprStat == "APPLICATE" || v.midApprStat == "RAPPLICATE" ? "fcGreen" : v.midApprStat == "APPROVE" ? "fcBlue" : v.midApprStat == "COMPANION" ? "fcRed" : "";
        				var endReplaceColor = v.endApprStat == "APPLICATE" || v.endApprStat == "RAPPLICATE" ? "fcGreen" : v.endApprStat == "APPROVE" ? "fcBlue" : v.endApprStat == "COMPANION" ? "fcRed" : "";
        				html += `<tr>`;
        				html += `	<td class="tc">`;
        				html += `		<div class="ui checkbox">`;
        				html += `			<input type="checkbox" name="stdChk" id="chk_std\${v.lineNo}" data-stdNo="\${v.stdNo}" onchange="userCheck(this)" user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}' />`;
        				html += `			<label class="toggle_btn" for="chk_std\${v.lineNo}"></label>`;
        				html += `		</div>`;
        				html += `	</td>`;
        				html += `	<td class="tc lineNo">\${v.lineNo}</td>`;
        				html += `	<td>\${v.deptNm}</td>`;
        				html += `	<td>\${v.userId}</td>`;
        				html += `	<td>\${v.hy}</td>`;
        				html += `	<td data-sort-value="\${v.userNm}">`;
        				html += `		<a class="fcBlue" href="javascript:studyStatusModal('\${v.stdNo}')">\${v.userNm}</a>`;
        				html +=			userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
        				html += `	</td>`;
        				html += `	<td class="tc">\${v.entrYy}</td>`;
        				html += `	<td class="tc">\${v.entrHy}</td>`;
        				html += `	<td class="tc">\${v.entrGbnNm}</td>`;
        				if("${vo.examType}" == "EXAM") {
        				var midScoreSort = v.midScore == "미응시" || v.midScore == "-" ? "-1" : Math.round(v.midScore);
        				var midReplScoreSort = v.midReplaceScore == "미응시" || v.midReplaceScore == "-" ? "-1" : Math.round(v.midReplaceScore);
        				var midEtcScoreSort = v.midEtcScore == "미응시" || v.midEtcScore == "-" ? "-1" : Math.round(v.midEtcScore);
        				var endScoreSort = v.endScore == "미응시" || v.endScore == "-" ? "-1" : Math.round(v.endScore);
        				var endReplScoreSort = v.endReplaceScore == "미응시" || v.endReplaceScore == "-" ? "-1" : Math.round(v.endReplaceScore);
        				var endEtcScoreSort = v.endEtcScore == "미응시" || v.endEtcScore == "-" ? "-1" : Math.round(v.endEtcScore);
        				var midScore = v.midEvalYn == "N" && midScoreSort > -1 ? "채점 미완료" : v.midScore;
        				var endScore = v.endEvalYn == "N" && endScoreSort > -1 ? "채점 미완료" : v.endScore;
        				html += `	<td class="tc" data-sort-value="\${midScoreSort}">\${midScore}</td>`;
        				html += `	<td class="tc \${midReplaceColor}" data-sort-value="\${midReplScoreSort}">\${v.midReplaceScore}</td>`;
        				html += `	<td class="tc" data-sort-value="\${midEtcScoreSort}">\${v.midEtcScore}</td>`;
        				html += `	<td class="tc" data-sort-value="\${endScoreSort}">\${endScore}</td>`;
        				html += `	<td class="tc \${endReplaceColor}" data-sort-value="\${endReplScoreSort}">\${v.endReplaceScore}</td>`;
        				html += `	<td class="tc" data-sort-value="\${endEtcScoreSort}">\${v.endEtcScore}</td>`;
        				} else {
        				var addScoreSort = v.admissionScore == "미응시" || v.admissionScore == "-" ? "-1" : Math.round(v.admissionScore);
            			var addEtcScoreSort = v.admissionEtcScore == "미응시" || v.admissionEtcScore == "-" ? "-1" : Math.round(v.admissionEtcScore);
        				html += `	<td class="tc" data-sort-value="\${addScoreSort}">\${v.admissionScore}</td>`;
        				html += `	<td class="tc" data-sort-value="\${addEtcScoreSort}">\${v.admissionEtcScore}</td>`;
        				}
        				html += `</tr>`;
        			});
        		}
        		
        		$("#straeJoinCnt").text(returnList.length);
        		$("#stareJoinList").empty().html(html);
        		$("#stareJoinListTable").footable();
        		$("#stareJoinListTable").parent("div").addClass("max-height-500");
        		
        		// 정렬후 No 재설정
				$('#stareJoinListTable').on('after.ft.sorting', function(e) {
					var tbList = $('#stareJoinListTable').find("td.lineNo");
			    	if (tbList.length > 0) {
			    		for (var i=0; i < tbList.length; i++) {
			    			$(tbList[i]).html(i+1);
			    		}
			    	}
				});
        		
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	/// 차트 출력
	function chartSet(type) {
		setChartForm(type);
		horizontalBarChartSet(type);
		barChartSet(type);
	}
	
	// 차트 폼 생성
	function setChartForm(type) {
		var typeNm	  = type == "M" ? "<spring:message code='exam.label.mid.exam' />"/* 중간고사 */ : type == "L" ? "<spring:message code='exam.label.end.exam' />"/* 기말고사 */ : "<spring:message code='exam.label.always.exam' />"/* 수시평가 */;
		var typeStr	  = type == "M" ? "mid" : type == "L" ? "end" : "adm";
		var html  = "<div class='row' id='"+typeStr+"Row'>";
			html += "	<div class='col'>";
			html += "		<div class='ui segment' style='height:100%;'>";
			html += "			<h3 class='sec_head'>"+typeNm+" <spring:message code='exam.label.distribution.grades' /></h3>";/* 성적분포도 */
			html += "			<div class='column'>";
			html += "				<canvas id='"+typeStr+"HoriBarChart' height='100'></canvas>";
			html += "			</div>";
			html += "			<table class='table' id='"+typeStr+"StatusTable' data-paging='false' data-empty='"+"<spring:message code='exam.common.empty' />"+"'>";/* 등록된 내용이 없습니다. */
			html += "				<thead>";
			html += "					<tr>";
			html += "						<th class='tc'><spring:message code='exam.label.gain.point' /></th>";/* 배점 */
			html += "						<th class='tc'><spring:message code='exam.label.avg' /></th>";/* 평균 */
			html += "						<th class='tc'><spring:message code='exam.label.avg.upper.10' /></th>";/* 상위10%평균 */
			html += "						<th class='tc'><spring:message code='exam.label.max' /><spring:message code='exam.label.score.point' /></th>";/* 최고 *//* 점 */
			html += "						<th class='tc'><spring:message code='exam.label.min' /><spring:message code='exam.label.score.point' /></th>";/* 최저 *//* 점 */
			html += "						<th class='tc'><spring:message code='exam.label.total.join.user' /></th>";
			html += "					</tr>";
			html += "				</thead>";
			html += "				<tbody id='"+typeStr+"Status'></tbody>";
			html += "			</table>";
			html += "			<div class='column'>";
			html += "				<canvas id='"+typeStr+"BarChart' height='100'></canvas>";
			html += "			</div>";
			html += "		</div>";
			html += "	</div>";
			html += "</div>";
	    $(".layout2").append(html);
	}
	
	// 가로 바 차트 출력
	function horizontalBarChartSet(type) {
		var url  = "/exam/viewExamScoreHorizontalBarChart.do";
		var data = {
			"crsCreCd"   	  : "${creCrsVO.crsCreCd}",
			"searchMenu" 	  : "termExam",
			"examStareTypeCd" : type,
			"examCd"		  : "${vo.examCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				if(returnList.length > 0) {
					examCommon.horizontalBarChartSet(returnList, type);
				}
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 세로 바 차트 출력
	function barChartSet(type) {
		var url  = "/exam/viewExamScoreBarChart.do";
		var data = {
			"crsCreCd"   	  : "${creCrsVO.crsCreCd}",
			"searchMenu" 	  : "termExam",
			"examStareTypeCd" : type,
			"examCd"		  : "${vo.examCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				var typeNm = type == "M" ? "mid" : type == "L" ? "end" : "adm";
				
				if(returnVO != null) {
					examCommon.barChartSet(returnVO, type);
				    
				    var	html  = `<tr>`;
				    	html += `	<td class="tc">100</td>`;
				    	html += `	<td class="tc">\${returnVO.avgScore }</td>`;
				    	html += `	<td class="tc">\${returnVO.topAvgScore }</td>`;
				    	html += `	<td class="tc">\${returnVO.maxScore }</td>`;
				    	html += `	<td class="tc">\${returnVO.minScore }</td>`;
				    	html += `	<td class="tc">\${returnVO.noStareCnt + returnVO.tempSaveCnt + returnVO.completeCnt }</td>`;
				    	html += `</tr>`;
				    	
				    $("#"+typeNm+"Status").html(html);
				    $("#"+typeNm+"StatusTable").footable();
				} else {
					$("#"+typeNm+"Row").css("display", "none");
				}
			} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 엑셀 다운로드
	function examStareExcelDown() {
		$("form[name=excelForm]").remove();
		var excelGrid = {
			colModel:[
		        {label:'No.',    													name:'lineNo',        	align:'center',  width:'1000'},	
		        {label:"<spring:message code='exam.label.dept' />",    				name:'deptNm',   	   	align:'left',    width:'5000'},/* 학과 */
		        {label:"<spring:message code='exam.label.user.no' />",   			name:'userId',   	   	align:'left',    width:'5000'},/* 학번 */
		        {label:"<spring:message code='exam.label.user.grade' />",   		name:'hy',   	   		align:'left',    width:'5000'},/* 학년 */
		        {label:"<spring:message code='exam.label.user.nm' />",    			name:'userNm',        	align:'right',   width:'5000'},/* 이름 */
		        {label:"<spring:message code='exam.label.admission.year' />",  		name:'entrYy',   		align:'right',   width:'5000'},/* 입학년도 */
		        {label:"<spring:message code='exam.label.admission.grade' />",  	name:'entrHy',    		align:'right',   width:'5000'},/* 입학학년 */
		        {label:"<spring:message code='exam.label.admission.type' />", 	 	name:'entrGbnNm', 		align:'right',   width:'5000'},/* 입학구분 */
		        <c:if test="${vo.examType eq 'EXAM'}">
		        {label:"<spring:message code='exam.label.mid.exam.real.time' />",	name:'midScore', 	   	align:'right',   width:'5000'},/* 중간고사(실시간) */
		        {label:"<spring:message code='exam.label.mid.exam.ins' />",			name:'midReplaceScore',	align:'right',   width:'5000'},/* 중간고사(대체) */
		        {label:"<spring:message code='exam.label.mid.exam.etc' />",  		name:'midEtcScore', 	align:'right',   width:'5000'},/* 중간고사(기타) */
		        {label:"<spring:message code='exam.label.end.exam.real.time' />",  	name:'endScore', 	   	align:'right',   width:'5000'},/* 기말고사(실시간) */
		        {label:"<spring:message code='exam.label.end.exam.ins' />",  		name:'endReplaceScore',	align:'right',   width:'5000'},/* 기말고사(대체) */
		        {label:"<spring:message code='exam.label.end.exam.etc' />",  		name:'endEtcScore', 	align:'right',   width:'5000'},/* 기말고사(기타) */
		        </c:if>
		        <c:if test="${vo.examType eq 'ADMISSION'}">
		        {label:"<spring:message code='exam.label.adm.exam.real.time' />",  	name:'admissionScore', 	   	align:'right',   width:'5000'},/* 수시평가(실시간) */
		        {label:"<spring:message code='exam.label.adm.exam.etc' />",  		name:'admissionEtcScore', 	align:'right',   width:'5000'},/* 수시평가(퀴즈) */
		        </c:if>
			]
		};
			
		var stdNos = "";
		$("input[name=stdChk]:checked").each(function(i) {
			if(i > 0) {
				stdNos += ",";
			}
			stdNos += $(this).attr("data-stdNo");
		});
		
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd',    'val' : "${creCrsVO.crsCreCd}"});
		kvArr.push({'key' : 'examType',    'val' : "${vo.examType}"});
		kvArr.push({'key' : 'examCd', 	   'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'searchValue', 'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'stdNos', 	   'val' : stdNos});
		kvArr.push({'key' : 'excelGrid',   'val' : JSON.stringify(excelGrid)});
		
		submitForm("/exam/examStareExcelDown.do", "", "", kvArr);
	}
	
	// 수강생 학습현황 팝업
	function studyStatusModal(stdNo) {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${creCrsVO.crsCreCd}"});
		kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
		
		submitForm("/std/stdPop/studyStatusPop.do", "examPopIfm", "stdStat", kvArr);
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
		
		$.each($('#stareJoinList').find("input:checkbox[name=stdChk]:not(:disabled):checked"), function() {
			sendCnt++;
			if (sendCnt > 1) rcvUserInfoStr += "|";
			rcvUserInfoStr += $(this).attr("user_id");
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
 	
 	// 전체 선택
 	function userAllCheck(obj) {
 		$("input[name=stdChk]").prop("checked", obj.checked);
 		
 		if(obj.checked) {
 			$("input[name=stdChk]").closest("tr").addClass("on");
 		} else {
 			$("input[name=stdChk]").closest("tr").removeClass("on");
 		}
 	}
 	
 	// 개별 선택
 	function userCheck(obj) {
 		if(obj.checked) {
 			$(obj).closest("tr").addClass("on");
 		} else {
 			$(obj).closest("tr").removeClass("on");
 		}
 		
 		$("#allChk").prop("checked", $("input[name=stdChk]").length == $("input[name=stdChk]:checked").length);
 	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
        				<c:set var="examTypeStr" ><spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 --></c:set>
        				<c:if test="${vo.examType eq 'ADMISSION' }"><c:set var="examTypeStr"><spring:message code="exam.label.always.exam" /><!-- 수시평가 --></c:set></c:if>
        				<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="exam.label.exam" />', '${examTypeStr}');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">${examTypeStr }</h2>
		                    <div class="button-area">
		                        <a href="javascript:examListForm()" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <h3 class="sec_head">
				                	<c:if test="${vo.examType eq 'EXAM' }"><spring:message code="exam.label.mid.end.stare.status" /><!-- 중간/기말고사 응시현황 --></c:if>
				                	<c:if test="${vo.examType eq 'ADMISSION' }"><spring:message code="exam.label.admission.stare.status" /><!-- 수시평가 응시현황 --></c:if>
				                	( <spring:message code="exam.label.total" /><!-- 총 --> : <span id="straeJoinCnt"></span><spring:message code="exam.label.nm" /><!-- 명 --> )
				                </h3>
				                <div class="option-content pb10 pt10">
				                	<c:if test="${vo.examType eq 'EXAM' }">
				                		<select class="ui dropdown mr5" id="searchFrom" onchange="examStareJoinList()">
					                		<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
					                		<option value="M"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></option>
					                		<option value="L"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></option>
					                	</select>
				                	</c:if>
				                	<select class="ui dropdown mr5" id="searchKey" onchange="examStareJoinList()">
				                		<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
				                		<option value="stare"><spring:message code="exam.button.stare.start" /><!-- 응시 --></option>
				                		<option value="noStare"><spring:message code="exam.label.no.stare" /><!-- 미응시 --></option>
				                	</select>
									<div class="ui action input search-box">
									    <input type="text" placeholder="<spring:message code='exam.label.user.nm' />/<spring:message code='exam.label.user.no' />/<spring:message code='exam.label.dept' /> <spring:message code='exam.label.input' />" class="w250" id="searchValue"><!-- 이름 --><!-- 학번 --><!-- 학과 --><!-- 입력 -->
									    <button class="ui icon button" onclick="examStareJoinList()"><i class="search icon"></i></button>
									</div>
									<div class="mla">
										<a href="javascript:examStareExcelDown()" class="ui small basic button"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
										<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
									</div>
								</div>
								<table class="table type2" id="stareJoinListTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
									<thead>
										<tr class="ui native sticky top0">
											<th scope="col">
												<div class="ui checkbox">
									                <input type="checkbox" name="allStdChk" id="allChk" value="all" onchange="userAllCheck(this)">
									                <label class="toggle_btn" for="allChk"></label>
									            </div>
											</th>
											<th scope="col" class="tc num">NO.</th>
											<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
											<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
											<th scope="col" class="tc" data-breakpoints="xs sm md" style="white-space:nowrap"><spring:message code="exam.label.user.grade" /></th><!-- 학년 -->
											<th scope="col" class="tc"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
											<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.admission.year" /></th><!-- 입학년도 -->
											<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.admission.grade" /></th><!-- 입학학년 -->
											<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.admission.type" /></th><!-- 입학구분 -->
											<c:if test="${vo.examType eq 'EXAM' }">
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.mid.exam.real.time" /></th><!-- 중간고사(실시간) -->
												<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.mid.exam.ins" /></th><!-- 중간고사(대체) -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.mid.exam.etc" /></th><!-- 중간고사(기타) -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.end.exam.real.time" /></th><!-- 기말고사(실시간) -->
												<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.end.exam.ins" /></th><!-- 기말고사(대체) -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.end.exam.etc" /></th><!-- 기말고사(기타) -->
											</c:if>
											<c:if test="${vo.examType eq 'ADMISSION' }">
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.always.exam" /><!-- 수시평가 -->(<spring:message code="exam.label.real.time" /><!-- 실시간 -->)</th>
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.etc" /><!-- 기타 -->(<spring:message code="exam.label.quiz" /><!-- 퀴즈 -->)</th>
											</c:if>
										</tr>
									</thead>
									<tbody id="stareJoinList">
									</tbody>
								</table>
		                	</div>
		                </div>
        			</div>
        		</div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>