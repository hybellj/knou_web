<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST = [];
		
		$(document).ready(function() {
			// 부서정보
			<c:forEach var="item" items="${deptList}">
				USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptId}" />'
					, deptNm: '<c:out value="${item.deptnm}" />'
				});
			</c:forEach>
			setStatus();
			changeSbjctList();
		});
		
		// 전체 학습 현황 조회
		function setStatus() {
			let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";
			
			// [전체]
			//var url = "/lesson/lessonMgr/selectLessonProgressTotalStatus.do";
			let url = "/stats/LrnPrgrtStatusAjax.do";
			let data = {
				sbjctYr		: $("#sbjctYr").val(),
				smstrChrtId	: $("#sbjctSmstr").val(),
				orgId		: $("#orgId").val(),
				deptId		: ($("#deptId").val() || "").replace("ALL", ""),
				sbjctOfrngId: ($("#sbjctOfrngId").val() || "").replace("ALL", ""),
				searchKey	: searchKey,
				searchFrom	: $("#searchFrom").val(),
				searchTo	: $("#searchTo").val(),
			};
			
			$.ajax({
				url	: url,
				type: 'GET',
				data: data,
				success: function(data) {
					if(data.result > 0) {
						let returnVO = data.returnVO || {};
						
						let wholeStdCnt = returnVO.wholeStdCnt;				// 전체 수강생 수
						let wholeAvgLrnPrgrt = returnVO.wholeAvgLrnPrgrt;	// 전체 수강생 기준 평균학습진도율
						let myStdCnt = returnVO.myStdCnt;			// 운영과목 수강생 수
						let myAvgLrnPrgrt = returnVO.myAvgLrnPrgrt;	// 운영과목 수강생 기준 평균학습진도율
						
						// [전체]
						let wholeStauts = '';
						wholeStauts += `<spring:message code='crs.learner.count' /> : \${wholeStdCnt} <spring:message code='exam.label.nm' />, `;
						wholeStauts += `<spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : \${wholeAvgLrnPrgrt} %`;
						$("#allLessonDiv").html(wholeStauts);
						
						// [운영과목]
						let myStatus = '';
						myStatus += `<spring:message code='crs.learner.count' /> : \${myStdCnt} <spring:message code='exam.label.nm' />, `;
						myStatus += `<spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : \${myAvgLrnPrgrt} %`;
						$("#myLessonDiv").html(myStatus);
						
		        	} else {
		        		alert(data.message);
		        	}
				},
				error: function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				}
			});
		}

		// 학기기수 세팅 변경
		function changeSmstrChrt() {
			let $sbjctSmstr = $('#sbjctSmstr');
			
			$sbjctSmstr.off("change");
			$sbjctSmstr.dropdown("clear");
			$sbjctSmstr.empty();
			
			let basicOptn = `<option value='ALL'><spring:message code="crs.label.open.term" /></option>`;	// 학기
			
			$.ajax({
				url  : "/crs/termMgr/smstrListByDgrsYr.do",
				data : {
					dgrsYr 	: $("#sbjctYr").val()
				<%--	,orgId	: $("#orgId").val() --%>
				},
				type : "GET",
				success: function(data) {
					if (data.result > 0) {
						let resultList = data.returnList;
						if (resultList.length > 0) {
							$sbjctSmstr.append(basicOptn);
							$.each(resultList, function(i, smstrChrtVO) {
								$sbjctSmstr.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
								/* $sbjctSmstr.append('<option'+' value="'+smstrChrtVO.smstrChrtId+'" >' + smstrChrtVO.smstrChrtnm + '</option>'); */
							})
						}
					}else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				}
			});
		}
		
		// 학과부서 변경에 따른 개설과목 목록 조회
		function changeSbjctList() {
			let $sbjctOfrngId = $('#sbjctOfrngId');
			
			$sbjctOfrngId.off("change");
			$sbjctOfrngId.dropdown("clear");
			$sbjctOfrngId.empty();
			
			let url = "/crs/creCrsMgr/sbjctOfrngList.do";
			/* var url = "/crs/creCrsHome/creCrsList.do"; */
			let data = {
				sbjctYr		: $("#sbjctYr").val(),
				sbjctSmstrId: $("#sbjctSmstr").val(),
				orgId		: $("#orgId").val(),
				deptId		: $("#deptId").val()
			};
			
			console.log(data);
			
			let basicOptn = `<option value='ALL'><spring:message code='sch.cal_course' /></option>`;	// 과목
			
			$.ajax({
				url	: url,
				data: data,
				type: "GET",
				success	: function(data) {
					if (data.result > 0) {
						let resultList = data.returnList;
						if (resultList.length > 0) {
							$sbjctOfrngId.append(basicOptn);
							$.each(resultList, function(i, SbjctOfrngVO) {
								$sbjctOfrngId.append('<option'+' value="'+SbjctOfrngVO.sbjctOfrngId+'" >' + SbjctOfrngVO.sbjctnm + '</option>');
							})
						}
					}else {
						alert(data.message);
					}
				}
			});
		}
		
		// 학습현황 목록
		function listStd() {
			let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";
			
			let url  = "/stats/lrnPrgrtStatusListAjax.do";
			let data = {
				sbjctYr		: $("#sbjctYr").val(),
				sbjctSmstrId: $("#sbjctSmstrId").val(),
				orgId		: $("#orgId").val(),
				deptId		: ($("#deptId").val() || "").replace("ALL", ""),
				sbjctOfrngId: ($("#sbjctOfrngId").val() || "").replace("ALL", ""),
				searchKey	: searchKey,
				searchFrom	: $("#searchFrom").val(),
				searchTo	: $("#searchTo").val(),
			};
			
			$.ajax({
				url	: url,
				data: data,
				type: "GET",
				success: function(data) {
					if (data.result > 0) {
						let returnList = data.returnList || [];
						let html = "";
					
						returnList.forEach(function(v, i) {	
							html +=`
								<tr>
									<td>
										<div class='ui checkbox'>
/* 											<input type='checkbox' name='stdChk' onchange='checkStd(this)' id='stdChk\${i}' user_no='\${v.userNo}' user_nm='\${v.userNm}' email='\${v.email}' mobile='\${v.mobileNo}' /> */
											<input type='checkbox' name='stdChk' onchange='checkStd(this)' id='stdChk\${i}' userId='\${v.userId}' usernm='\${v.usernm}' email='\${v.email}' mobile='\${v.mobileNo}' />
											<label for='stdChk\${i}'></label>
										</div>
									</td>
									<td>\${v.lineNo}</td>
									<td>\${v.sbjctYr}</td>
									<td>\${v.sbjctSmstr}</td>
									<td>\${v.orgnm}</td>
									<td>\${v.deptnm}</td>
									<td>\${v.sbjctnm}</td>
									<td>\${v.dvclasNo}</td>
									<td>\${v.userId}</td>
									<td>\${v.usernm}</td>
									<td>\${v.scyr}</td>
									<td>\${v.openWkCnt}</td>
									<td>\${v.lrnWkCnt}</td>
									<td>\${v.prgrt}%</td>
								</tr>
							`;
						});
					
						$("#totStdCnt").text(returnList.length);
						$("#stdTbody").empty().html(html);
						$("#stdTable").footable();
						
						setStatus();
					
						/* if(data.returnVO != null) {
							var lessonVO = data.returnVO;
							$("#allLessonDiv").html("<spring:message code='crs.learner.count' /> : "+lessonVO.allStdCnt+" <spring:message code='exam.label.nm' />, <spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : "+lessonVO.allLessonAvg+" %");
							$("#myLessonDiv").html("<spring:message code='crs.learner.count' /> : "+lessonVO.myStdCnt+" <spring:message code='exam.label.nm' />, <spring:message code='exam.label.avg' /><spring:message code='dashboard.study_prog' /> : "+lessonVO.myLessonAvg+" %");
						} */
		            } else {
		             	alert(data.message);
		            }
				},
				error : function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				}
			});
		}
		
		// 체크박스 이벤트
		function checkStd(obj) {
			if($(obj).attr("id") == "allChk") {
				$("input[name=stdChk]").prop("checked", $(obj).is(":checked"));
				if($(obj).is(":checked")) {
					$("input[name=stdChk]").closest("tr").addClass("on");
				} else {
					$("input[name=stdChk]").closest("tr").removeClass("on");
				}
			} else {
				if($(obj).is(":checked")) {
					$(obj).closest("tr").addClass("on");
				} else {
					$(obj).closest("tr").removeClass("on");
				}
				$("#allChk").prop("checked", $("input[name=stdChk]").length == $("input[name=stdChk]:checked").length);
			}
		}
	
		// 쪽지 보내기
		function sendMsg() {
			if($("#stdTbody").find("input[name=stdChk]:checked").length == 0) {
				/* 체크된 값이 없습니다. */
				alert("<spring:message code='common.alert.input.no.value' />");
				return;
			}
			let rcvUserInfoStr = "";
			let sendCnt = 0;
	
			$.each($("#stdTbody").find("input[name=stdChk]:checked"), function() {
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_no");
				rcvUserInfoStr += ";" + $(this).attr("user_nm");
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email");
			});
	
		    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	
		    let form = document.alarmForm;
		    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
		    form.target = "msgWindow";
		    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
		    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
		    form.submit();
		}
		
		// 엑셀 다운로드
		function excelDown() {
			$("form[name='excelForm']").remove();
			var excelGrid = {
			    colModel:[
			        {label:"<spring:message code='common.no' />", name:'lineNo', align:'center', width:'3000'}, /* 번호 */
			        {label:"<spring:message code='common.year' />", name:'sbjctYr', align:'center', width:'3000'}, /* 년도 */
			        {label:"<spring:message code='common.term' />", name:'sbjctSmstr', align:'center', width:'3000'}, /* 학기 */
			        {label:"<spring:message code='common.label.org' />", name:'orgId', align:'center', width:'3000'}, /* 기관 */
			        {label:"<spring:message code='common.dept_name'/>", name:'deptnm', align:'left', width:'8000'}, /* 학과 */
			        {label:"<spring:message code='common.label.crsauth.crsnm'/>", name:'sbjctnm', align:'left', width:'8000'}, /* 개설과목명 */
			        {label:"<spring:message code='common.label.decls.no' />", name:'dvclasNo', align:'center', width:'3000'}, /* 분반 */
			        {label:"<spring:message code='common.id'/>", name:'userNm', align:'center', width:'5000'}, /* 아이디 */
			        {label:"<spring:message code='common.name'/>", name:'userNm', align:'center', width:'5000'}, /* 이름 */
			        {label:"<spring:message code='common.label.userdept.grade' />", name:'scyr', align:'center', width:'3000'}, /* 학년 */
			        {label:"<spring:message code='common.label.lesson.open.week'/> (A)", name:'allScheduleCnt', align:'left', width:'5000'}, /* 오픈주차 */
			        {label:"<spring:message code='common.label.lesson.learn.week'/> (B)", name:'studyScheduleCnt', align:'left', width:'5000'}, /* 학습주차 */
			        {label:"<spring:message code='lesson.label.study.status.complete.yule'/> (A/B)", name:'studyPersent', align:'left', width:'5000'}, /* 출석율 */
			    ]
			};
			let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";
			
			let form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", "/lesson/lessonHome/lessonProgressExcelDown.do");
			form.append($('<input/>', {type: 'hidden', name: 'sbjctYr', 	value: $("#sbjctYr").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: $("#sbjctSmstr").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'orgId', 		value: $("#orgId").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'deptId', 		value: ($("#deptId").val() || "").replace("ALL", "")}));
			form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: ($("#sbjctSmstr").val() || "").replace("ALL", "")}));
			form.append($('<input/>', {type: 'hidden', name: 'searchKey', 	value: searchKey}));
			form.append($('<input/>', {type: 'hidden', name: 'searchFrom', 	value: $("#searchFrom").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'searchTo', 	value: $("#searchTo").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
		}
		
		// 학과별 전체통계 팝업
		function allProgressPop() {
			$("form[name=popForm]").remove();
			
			let form = $("<form></form>");
			form.attr("method", "GET");
			form.attr("name", "popForm");
			form.attr("target", "stdLessonIfm");
			form.attr("action", "/stats/lrnPrgrtListByDeptPopView.do");
			form.appendTo("body");
			form.submit();
			$("#stdLessonPop").modal("show");
			$('iframe').iFrameResize();
		}
	</script>
	<div id="wrap" class="main">
		<%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>
			
			<!-- 본문 content 부분 -->
			<div class="content">
				<div class="ui form">
					<div class="layout2">
						<div class="classInfo">
							<div class="mra">
								<h2 class="page-title"><spring:message code="common.label.lesson.process.manage"/></h2><!-- 학습진도관리 -->
							</div>
						</div>
						<div class="row">
							<div class="col">
								<p class="f120"><spring:message code="lesson.alert.message.manager1" /></p><!-- 운영과목에 대한 학습진도관리 할 수  있습니다. -->
								<div class="mt40">
									<p><spring:message code="lesson.alert.message.manager2" /></p><!-- 운영과목과 수강생의 학습현황을 조회할 수 있습니다. 학습 부진자 관리에 활용하시기 바랍니다. -->
									<div class="ui segment">
										<ul>
											<li>&middot; <spring:message code="lesson.alert.message.manager3" /></li><!-- 출석율은 현재 오픈 차시 중 정상 출석한 차시에 대한 비율로 표기됩니다. -->
											<li>&middot; <spring:message code="lesson.alert.message.manager4" /></li><!-- 매 주차별로 부진자 (출석율 100% 미만)에게 SMS 발송 가능합니다. -->
											<li>&middot; <spring:message code="lesson.alert.message.manager5" /></li><!-- 운영과목 수강생의 수에 따라 조회에 다소 시간이 걸릴 수 있습니다. (5~10초) -->
										</ul>
									</div>
								</div>
			            		
								<div class="option-content ui segment">
									<select class="ui dropdown" id="sbjctYr" onchange="changeSmstrChrt()">
										<option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
										<c:forEach var="item" items="${filterOptions.yearList }">
											<option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
										</c:forEach>
									</select>
									<select class="ui dropdown" id="sbjctSmstr"><!-- 개설학기 -->
										<option value=""><spring:message code="crs.label.open.term" /></option>
										<c:forEach var="list" items="${filterOptions.smstrChrtList }">
											<%-- <option value="${list.smstrChrtId }" ${list.dgrsSmstrChrt eq curSmstrChrtVO.dgrsSmstrChrt ? 'selected' : '' }>${list.smstrChrtnm }</option> --%>
											<option value="${list.smstrChrtId }">${list.smstrChrtnm }</option>
										</c:forEach>
									</select>
									<select class="ui dropdown" id="orgId" disabled><!-- 기관 -->
										<option value="">기관</option>
										<c:forEach var="list" items="${filterOptions.orgList }">
											<option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
										</c:forEach>
									</select>
									<select class="ui dropdown" id="deptId" onchange="changeSbjctList()">
										<option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
										<c:forEach var="list" items="${filterOptions.deptList }">
											<option value="${list.deptId }">${list.deptnm }</option>
										</c:forEach>
									</select>
									<select class="ui dropdown" id="sbjctOfrngId">
										<option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
									</select>
									<div class="ui checkbox">
										<input type="checkbox" id="noStudyAll" onchange="listStd()"/>
										<label for="noStudyAll"><spring:message code="std.label.nostudy_student" /><spring:message code="sys.common.search.all" /></label><!-- 미학습자전체 -->
									</div>
									<div class="mla">
										<div class="fields">
											<div class="field">
												<spring:message code="lesson.label.study.status.complete.yule" /> <!-- 출석율 -->
												<div class="ui w50 input">
													<input type="text" id="searchFrom" maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
												</div>
												% <spring:message code="common.label.over" /><!-- 이상 --> ~
											</div>
											<div class="field">
												<div class="ui w50 input">
													<input type="text" id="searchTo" maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
												</div>
												% <spring:message code="common.label.under" /><!-- 미만 -->
											</div>
											<div class="field">
												<button class="ui green button" onclick="listStd()"><spring:message code="sys.button.search" /></button>
											</div>
										</div>
									</div>
			            		</div>
			            		
								<div class="ui two stackable cards">
									<div class="card">
										<div class="ui message p0 flex">
											<div class="flex bcBlue fcWhite p4">
												<div class="flex flex-column tc p5">
													<small><spring:message code="dashboard.all" /></small><!--  전체 -->            
												</div>
											</div>
											<div class="contents flex p_w80 tc p10" id="allLessonDiv">
												<spring:message code="crs.learner.count" /><!-- 수강생 수 --> : - <spring:message code="exam.label.nm" /><!-- 명 -->, <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><!-- 평균 학습진도율 --> : - %
											</div>
										</div>
									</div>
									<div class="card">
										<div class="ui message p0 flex">
											<div class="flex bcBlue fcWhite p4">
												<div class="flex flex-column tc p5">                        
													<small><spring:message code="crs.course.crsnm" /></small><!-- 운영과목 -->
												</div>
											</div>
											<div class="contents flex p_w80 tc p10" id="myLessonDiv">
												<spring:message code="crs.learner.count" /><!-- 수강생 수 --> : - <spring:message code="exam.label.nm" /><!-- 명 -->, <spring:message code="exam.label.avg" /> <spring:message code="dashboard.study_prog" /><!-- 평균 학습진도율 --> : - %
											</div>
										</div>
									</div>
								</div>
			            		
								<div class="option-content mt20 mb10">
									<h3 class="sec_head"><spring:message code="lesson.label.study.status" /></h3><!-- 학습현황 -->
									[ <spring:message code="user.title.total.count" /><!-- 총건수 --> : <p class="fcBlue" id="totStdCnt">0</p>]
									<div class="mla">
										<button class="ui basic button" onclick="sendMsg()"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></button><!-- 메시지 -->
										<button class="ui blue button" onclick="allProgressPop()">학과별 전체 통계</button>
										<button class="ui blue button" onclick="excelDown()"><spring:message code="exam.button.excel.down" /></button><!-- 엑셀 다운로드 -->
									</div>
								</div>
								
								<table class="table type2" id="stdTable" data-sorting="false" data-paging="false" data-empty="<spring:message code="asmnt.common.empty" />.">
									<thead>
										<tr>
											<th class="w30">
												<div class="ui checkbox">
												    <input type="checkbox" name="allEvalChk" id="allChk" onchange="checkStd(this)">
												    <label class="toggle_btn" for="allChk"></label>
												</div>
											</th>
											<th class="w30"><spring:message code="common.no" /></th><!-- 번호 -->
											<th><spring:message code="common.year" /></th><!-- 년도 -->
											<th><spring:message code="common.term" /></th><!-- 학기 -->
											<th><spring:message code="common.label.org" /></th><!-- 기관 -->
											<th><spring:message code="common.dept_name" /></th><!-- 학과 -->
											<th><spring:message code="common.label.crsauth.crsnm" /></th><!-- 개설과목명 -->
											<th><spring:message code="common.label.decls.no" /></th><!-- 분반 -->
											<th><spring:message code="common.id" /></th><!-- 아이디 -->
											<th><spring:message code="common.name" /></th><!-- 이름 -->
											<th><spring:message code="common.label.userdept.grade" /></th><!-- 학년 -->
											<th><spring:message code='common.label.lesson.open.week'/> (A)</th><!-- 오픈주차 (A) -->
											<th><spring:message code='common.label.lesson.learn.week'/> (B)</th><!-- 학습주차 (B) -->
											<th><spring:message code="lesson.label.study.status.complete.yule" /> (B/A)</th><!-- 출석율 (B/A) -->
										</tr>
									</thead>
									<tbody id="stdTbody"></tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			
	        <!-- //본문 content 부분 -->
	        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
	        
	        <!-- 학과별 전체통계 모달 -->
			<div class="modal fade" id="stdLessonPop" name="stdLessonPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="lesson.label.enrolled.learning.statistics" />" aria-hidden="true">
				<div class="modal-dialog modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title"><spring:message code="lesson.label.enrolled.learning.statistics" /></h4><!-- 재학생 학습진도 전체 통계 -->
							<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='common.button.close'/>"><!-- 닫기 -->
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<iframe src="" id="stdLessonIfm" name="stdLessonIfm" width="100%" scrolling="no"></iframe>
						</div>
					</div>
				</div>
			</div>
			<!-- 전체통계 모달 -->
			<script>
				window.closeModal = function() {
					$('.modal').modal('hide');
				};
			</script>
		</div>
    </div>
</body>
</html>