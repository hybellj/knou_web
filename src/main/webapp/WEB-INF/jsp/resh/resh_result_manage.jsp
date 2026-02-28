<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function() {
		listReshUser();
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listReshUser();
			}
		});
		
		// 점수 가감시 +, - 변경 이벤트
		$('.toggle-icon').click(function() {
            $(this).toggleClass("ion-plus ion-minus");
        });
		
		$(".accordion").accordion();
	});
	
	// 설문 페이지 이동
	function manageResh(tab) {
		var urlMap = {
			"1" : "/resh/reshQstnManage.do",				// 설문 문항 관리 페이지
			"2" : "/resh/reshResultManage.do",				// 설문 결과 페이지
			"3" : "/resh/Form/editResh.do",					// 설문 수정 페이지
			"4" : "/resh/Form/reshList.do",					// 목록
			"8" : "/resh/reshJoinUserAnswerExcelDown.do",	// 제출 설문
			"9" : "/resh/reshResultExcelDown.do"			// 설문 결과
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',  'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 설문 참여자 리스트 조회
	function listReshUser() {
		var univGbn = "${creCrsVO.univGbn}";
		var url  = "/resh/reshJoinUserList.do";
		var data = {
			"reschCd" 	  : "${vo.reschCd}",
			"searchKey"   : $("#searchKey").val(),
			"searchType"  : $("#searchType").val(),
			"searchValue" : $("#searchValue").val(),
			"pagingYn"	  : "N"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
				
				var html = "";
				returnList.forEach(function(v, i) {
        			var regDttm  = v.joinYn == "Y" ? dateFormat("date", v.regDttm) : "";
        			var submitNm = v.joinYn == "Y" ? '<spring:message code="resh.label.join" />'/* 참여 */ : '<spring:message code="resh.label.not.join" />'/* 미참여 */;
        			html += "<tr data-stdNo='"+v.stdNo+"'>";
        			html += "	<td class='tc'>";
        			html += "		<div class='ui checkbox'>";
        			html += `			<input type="checkbox" id="userChk\${i }" name="evalChk" onchange="userCheck(this)" user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
        			html += `			<label class="toggle_btn" for="userChk\${i }"></label>`;
        			html += "		</div>";
        			html += "	</td>";
        			html += `	<td name="lineNo">\${v.lineNo}</td>`;
        			html += `	<td data-sort-value="\${v.deptNm}" class="word_break_none">\${v.deptNm }</td>`;
        			html += `	<td data-sort-value="\${v.userId}" class="tc">\${v.userId }</td>`;
        			html += `	<td data-sort-value="\${v.hy}" class="tc">\${v.hy }</td>`;
        			if(univGbn == "3" || univGbn == "4") {
						html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
					}
        			html += `	<td data-sort-value="\${v.userNm}" class="tc word_break_none">\${v.userNm }`;
        			html += 	userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
        			html += `	</td>`;
        			html += `	<td data-sort-value="\${v.entrYy}" class="tc">\${v.entrYy}</td>`;
        			html += `	<td data-sort-value="\${v.entrHy}" class="tc">\${v.entrHy}</td>`;
        			html += `	<td data-sort-value="\${v.entrGbnNm}" class="tc word_break_none">\${v.entrGbnNm}</td>`;
        			html += `	<td data-sort-value="\${v.score}" class="tc word_break_none" onclick="scoreInputForm('\${v.userId}')">`;
        			html += `		<p id="\${v.userId}_viewScore" style="display:inline-block;">\${v.score}<spring:message code="resh.label.score" /></p>`;/* 점 */
        			html += `		<input type="text" class="num" style="display:none" id="\${v.userId}_score" value="\${v.score }" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxLength="3" />`;
        			html += `	</td>`;
        			html += `	<td data-sort-value="\${submitNm}" class="tc word_break_none">\${submitNm}</td>`;
        			html += `	<td data-sort-value="\${regDttm}" class="tc word_break_none">\${regDttm }</td>`;
        			html += `	<td class="tc word_break_none">`;
        			html += `		<a href="javascript:reshPaperPop('\${v.stdNo}', '\${v.userId}')" class="ui mini basic button"><spring:message code="resh.label.resh.paper" /></a>`;/* 설문지 */
        			html += `		<a href="javascript:stdMemoForm('\${v.stdNo}', '\${v.userId}')" class="ui mini basic button"><spring:message code="resh.label.memo" /></a>`;/* 메모 */
        			html += `	</td>`;
        			html += "</tr>";
        		});
        		$("#reshJoinUserList").empty().append(html);
		    	$(".table").footable({
   					on: {
   						"after.ft.sorting": function(e, ft, sorter){
   							$("#reshJoinUserList tr").each(function(z, k){
   								$(k).find("td[name=lineNo]").html((z+1));
   							});
   						}
   					}
   				});
		    	
		    	$("#totalCntText").text(returnList.length);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		
		$.each($('#reshJoinUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
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
	
	// 설문 삭제
	function delResh() {
		var url  = "/resh/selectReshInfo.do";
		var data = {
			"crsCreCd" : "${vo.crsCreCd}",
			"reschCd"  : "${vo.reschCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var confirm = "";
        		var reshVO = data.returnVO;
        		if(reshVO.reschJoinUserCnt > 0) {
        			confirm = window.confirm(`<spring:message code="resh.confirm.exist.join.user.y" />`);/* 설문 참여자가 있습니다. 삭제 시 설문결과가 삭제됩니다.\r\n정말 삭제 하시겠습니까? */
        		} else {
        			confirm = window.confirm("<spring:message code='resh.confirm.exist.join.user.n' />");/* 설문 참여자가 없습니다. 삭제 하시겠습니까? */
        		}
        		if(confirm) {
        			var kvArr = [];
        			kvArr.push({'key' : 'reschCd',  'val' : "${vo.reschCd}"});
        			kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
        			
        			submitForm("/resh/delResh.do", "", "", kvArr);
        		}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.delete' />");/* 설문 삭제 중 에러가 발생하였습니다. */
		});
	}
	
	// 참여현황 팝업
	function reshChartPop() {
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',  'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/resh/reshResultChartPop.do", "reshPopIfm", "resultPop", kvArr);
	}
	
	// 점수 가감 아이콘 표시 확인
	function plusMinusIconControl(scoreType){
		if(scoreType == 'batch'){
			$(".link.icon.toggle-icon").hide();
		}else if(scoreType == 'addition'){
			$(".link.icon.toggle-icon").show();
		}
	}
	
	// 일괄 점수 저장
	function submitScore() {
		if($("input[name='scoreType']:checked").val() == undefined){
			alert("<spring:message code='exam.alert.select.score.type' />");/* 성적 처리 유형을 선택하세요. */
			return false;
		}
		if($("#scoreValue").val() == "" || $("#scoreValue").val() == undefined){
			alert("<spring:message code='exam.alert.input.score' />");/* 점수를 입력하세요. */
			return false;
		}
		
		if($("#scoreValue").val() > 100) {
			alert("<spring:message code='exam.alert.score.max.100' />");/* 점수는 100점 까지 입력 가능 합니다. */
			return false;
		}
		
		var userIds = "";
		var lastCnt = $('#reshJoinUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked").length;
		$.each($('#reshJoinUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function(i) {
			userIds += $(this).attr("user_id");
			if(lastCnt-1 != i) userIds += ",";
		});
		
		var score = $("#scoreValue").val();
		if($("input[name='scoreType']:checked").val() == "addition"){
			if(!$(".toggle-icon").attr("class").includes("ion-plus")){
				score = score * (-1);
			}
		}
		
		var url  = "/resh/updateReshScore.do";
		var data = {
			"reschCd"   : "${vo.reschCd}",
			"crsCreCd"  : "${vo.crsCreCd}",
			"userIds"   : userIds,
			"score"   	: score,
			"scoreType" : $("input[name='scoreType']:checked").val()
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		alert("<spring:message code='exam.alert.batch.score' />");/* 일괄 점수 등록이 완료되었습니다. */
        		$("#scoreValue").val("");
        		listReshUser();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.batch.score' />");/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		});
	}
	
	// 평가점수 폼
	function scoreInputForm(userId) {
		$("#"+userId+"_score").show();
		$("#"+userId+"_viewScore").hide();
		
		$("#"+userId+"_score").mouseout(function(e) {
			var score = parseInt($(e.target).val());
			if(score > 100) {
				score = 100;
			}
			
			var url  = "/resh/updateReshScore.do";
			var data = {
				"reschCd"   : "${vo.reschCd}",
				"crsCreCd"  : "${vo.crsCreCd}",
				"userIds"   : userId,
				"score"   	: score,
				"scoreType" : "batch"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					listReshUser();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		});
	}
	
	// 목록 엑셀 다운로드
	function joinUserExcelDown() {
		var univGbn = "${creCrsVO.univGbn}";
		var excelGrid = { colModel: [] };

		excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'}); // No.
		excelGrid.colModel.push({label: "<spring:message code='resh.label.dept.nm' />", name: 'deptNm', align: 'left', width: '5000'}); // 학과
		excelGrid.colModel.push({label: "<spring:message code='resh.label.user.no' />", name: 'userId', align: 'left', width: '5000'}); // 학번
		excelGrid.colModel.push({label: "<spring:message code='resh.label.user.grade' />", name: 'hy', align: 'center', width: '1000'}); // 학년
		if(univGbn == "3" || univGbn == "4") {
			excelGrid.colModel.push({label: '<spring:message code="common.label.grsc.degr.cors.gbn" />', name: 'grscDegrCorsGbnNm', align: 'left', width: '4000'}); // 학위과정
		}
		excelGrid.colModel.push({label: "<spring:message code='resh.label.user.nm' />", name: 'userNm', align: 'left', width: '5000'}); // 이름
		excelGrid.colModel.push({label: "<spring:message code='resh.label.admission.year' />", name: 'entrYy', align: 'left', width: '5000'}); // 입학년도
		excelGrid.colModel.push({label: "<spring:message code='resh.label.admission.grade' />", name: 'entrHy', align: 'left', width: '5000'}); // 입학학년
		excelGrid.colModel.push({label: "<spring:message code='resh.label.admission.type' />", name: 'entrGbnNm', align: 'left', width: '5000'}); // 입학구분
		excelGrid.colModel.push({label: "<spring:message code='resh.label.eval.score' />", name: 'score', align: 'right', width: '5000'}); // 평가점수
		excelGrid.colModel.push({
		    label: "<spring:message code='resh.label.join.yn' />",
		    name: 'joinYn',
		    align: 'right',
		    width: '5000',
		    codes: {
		        Y: "<spring:message code='resh.label.join' />",
		        N: "<spring:message code='resh.label.not.join' />"
		    }
		}); // 참여여부
		excelGrid.colModel.push({label: "<spring:message code='resh.label.join.dttm' />", name: 'regDttm', align: 'right', width: '5000'}); // 참여일시

		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	   'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'searchKey',   'val' : $("#searchKey").val()});
		kvArr.push({'key' : 'searchType',  'val' : $("#searchType").val()});
		kvArr.push({'key' : 'searchValue', 'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'excelGrid',   'val' : JSON.stringify(excelGrid)});
		
		submitForm("/resh/reshJoinUserExcelDown.do", "", "", kvArr);
	}
	
	// 메모 팝업
	function stdMemoForm(stdNo, userId) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',  'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
		kvArr.push({'key' : 'userId', 	'val' : userId});
		
		submitForm("/resh/reshProfMemoPop.do", "reshPopIfm", "profMemo", kvArr);
	}
	
	// 엑셀 성적 등록
	function callScoreExcelUpload() {
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',  'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/resh/reshScoreExcelUploadPop.do", "reshPopIfm", "scoreExcel", kvArr);
	}
	
	// 버튼 클릭 focused
	function btnFocuesd(stdNo) {
		$("#reshJoinUserList > tr").removeClass("focused");
		$("#reshJoinUserList > tr[data-stdNo='"+stdNo+"']").addClass("focused");
	}
	
	// 설문지 보기 팝업
	function reshPaperPop(stdNo, userId) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);
		
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',   'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'searchKey', 'val' : "list"});
		kvArr.push({'key' : 'userId',    'val' : userId});
		kvArr.push({'key' : 'stdNo',  	 'val' : stdNo});
		
		submitForm("/resh/reshPaperViewPop.do", "reshPopIfm", "viewPaper", kvArr);
	}
	
	// EZ-Grader 팝업
	function ezGraderPop() {
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',  'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/resh/ezg/ezgMainForm.do", "ezGraderPopIfm", "", kvArr);
	}
	
	// 전체 체크
	function userAllCheck(obj) {
		$("input[name=evalChk]").prop("checked", $(obj).is(":checked"));
		if(obj.checked) {
			$("input[name=evalChk]").closest("tr").addClass("on");
		} else {
			$("input[name=evalChk]").closest("tr").removeClass("on");
		}
	}
	
	// 단일 체크
	function userCheck(obj) {
		if(obj.checked) {
			$(obj).closest("tr").addClass("on");
		} else {
			$(obj).closest("tr").removeClass("on");
		}
		$("#userAllChk").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
    
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
        
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
        		<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		
        		<div class="ui form">
        			<div class="layout2">
						<script>
							$(document).ready(function () {
								// set location
								setLocationBar('<spring:message code="resh.label.resh" />', '<spring:message code="resh.label.info.manage" />'); // 설문 정보 및 평가 
							});
						</script>
							
		                <div id="info-item-box">		                
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
                            <div class="button-area">
								<a href="javascript:manageResh(3)" class="ui blue button"><spring:message code="resh.button.modify" /></a><!-- 수정 -->
								<a href="javascript:delResh()" class="ui basic button"><spring:message code="resh.button.delete" /></a><!-- 삭제 -->
								<a href="javascript:manageResh(4)" class="ui basic button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
                            </div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="listTab">
			                        <ul>
			                            <li class="mw120"><a onclick="manageResh(1)"><spring:message code="resh.tab.item.manage" /></a></li><!-- 문항 관리 -->
			                            <li class="select mw120"><a onclick="manageResh(2)"><spring:message code="resh.label.info.manage" /></a></li><!-- 설문 정보 및 평가 -->
			                        </ul>
			                    </div>
								<div class="ui styled fluid accordion week_lect_list card" style="border:none;">
									<div class="title">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<p class="lect_name">${fn:escapeXml(vo.reschTitle) }</p>
													<spring:message code="resh.common.yes" var="yes" /><!-- 예 -->
													<spring:message code="resh.common.no"  var="no" /><!-- 아니오 -->
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschStartDttm }" />
													<fmt:formatDate var="reschStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschEndDttm }" />
													<fmt:formatDate var="reschEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
													<span class="fcGrey">
														<small><spring:message code="resh.label.period" /><!-- 설문기간 --> : ${reschStartDttm } ~ ${reschEndDttm }</small> |
														<small><spring:message code="resh.label.score.aply.yn" /><!-- 성적반영 --> : ${vo.scoreAplyYn eq 'Y' ? yes : no }</small> |
														<small><spring:message code="resh.label.score.open.yn" /><!-- 성적공개 --> : ${vo.scoreOpenYn eq 'Y' ? yes : no }</small>
													</span>
												</div>
											</div>
										</div>
										<i class="dropdown icon ml20"></i>
									</div>
									<div class="content">
										<div class="ui segment">
											<ul class="tbl">
												<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="resh.label.cts" /></label><!-- 설문내용 -->
														</dt>
														<dd><pre>${vo.reschCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.period" /></label><!-- 설문기간 -->
														</dt>
														<dd>${reschStartDttm } ~ ${reschEndDttm }</dd>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.score.ratio" /></label><!-- 성적반영비율 -->
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.scoreAplyYn eq 'Y' }">
																	${vo.scoreRatio }%
																</c:when>
																<c:otherwise>
																	0%
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.ext.join.yn" /></label><!-- 지각제출 -->
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.extJoinYn eq 'Y' }">
																	<fmt:parseDate var="extEndDateFmt" pattern="yyyyMMddHHmmss" value="${vo.extEndDttm }" />
																	<fmt:formatDate var="extEndDttm" pattern="yyyy.MM.dd HH:mm" value="${extEndDateFmt }" />
																	<spring:message code="resh.label.use.y" /><!-- 사용 --> | ${extEndDttm }
																</c:when>
																<c:otherwise>
																	<spring:message code="resh.label.use.n" /><!-- 미사용 -->
																</c:otherwise>
															</c:choose>
														</dd>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.resh.item" /></label><!-- 설문문항 -->
														</dt>
														<dd>${vo.reschQstnCnt }<spring:message code="resh.label.item" /><!-- 문항 --></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.eval.cg" /></label><!-- 평가방법 -->
														</dt>
														<dd>
															<c:if test="${vo.evalCtgr eq 'P' }">
																<spring:message code="resh.label.eval.ctgr.score" /><!-- 점수형 -->
															</c:if>
															<c:if test="${vo.evalCtgr eq 'J' }">
																<spring:message code="resh.label.eval.ctgr.join" /><!-- 참여형 -->
															</c:if>
														</dd>
														<dt>
															<label for="teamLabel"><spring:message code="resh.label.allow.modi.yn" /></label><!-- 설문결과 조회가능 -->
														</dt>
														<dd>${vo.rsltTypeCd eq 'ALL' || vo.rsltTypeCd eq 'JOIN' ? yes : no }</dd>
													</dl>
												</li>
											</ul>
										</div>
									</div>
								</div>

								<div class="ui segment">
									<div class="option-content mb10">
		                				<div class="ui mla">
		                					<c:if test="${vo.evalCtgr eq 'P' && !fn:contains(authGrpCd, 'TUT') }">
										    	<a href="javascript:ezGraderPop()" class="ui basic small button">EZ-Grader</a>
		                					</c:if>
									    	<a href="javascript:callScoreExcelUpload()" class="ui basic small button"><spring:message code="resh.button.excel.upload.score" /></a><!-- 엑셀 성적등록 -->
									    	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
									    	<a href="javascript:manageResh(4)" class="ui basic small button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
									    </div>
		                			</div>
                                    <div class="option-content type2">
                                        <select class="ui dropdown" onchange="listReshUser()" id="searchKey">
											<option value=""><spring:message code="resh.label.join.yn" /><!-- 참여여부 --></option>
									        <option value="all"><spring:message code="resh.common.search.all" /></option><!-- 전체 -->
									        <option value="submit"><spring:message code="resh.label.join" /></option><!-- 참여 -->
									        <option value="noSubmit"><spring:message code="resh.label.not.join" /></option><!-- 미참여 -->
									    </select>
										<select class="ui dropdown" onchange="listReshUser()" id="searchType">
											<option value=""><spring:message code="resh.label.eval.yn" /><!-- 평가여부 --></option>
									        <option value="all"><spring:message code="resh.common.search.all" /></option><!-- 전체 -->
									        <option value="eval"><spring:message code="resh.label.eval" /></option><!-- 평가 -->
									        <option value="noEval"><spring:message code="resh.label.eval.n" /></option><!-- 미평가 -->
									    </select>
									    <div class="ui action input search-box">
									        <input type="text" placeholder="<spring:message code='resh.label.dept.nm' />, <spring:message code='resh.label.user.no' />, <spring:message code='resh.label.user.nm' /> <spring:message code='resh.label.input' />" class="w250" id="searchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
									        <button class="ui icon button" onclick="listReshUser()"><i class="search icon"></i></button>
									    </div>
                                    </div>
                                    <c:if test="${!fn:contains(authGrpCd, 'TUT') }">
	                                    <div class="ui segment score-wrap2 mt20">
	                                        <div class="flex">
	                                            <label for="fdbkValue" class="score-title"><spring:message code="common.label.batch.score.process" /><!-- 일괄 점수처리 --></label> 
	                                            <div class="score-con">
	                                                <div class="fields">
	                                                    <div class="field flex-item">
	                                                        <div class="ui radio checkbox pl10 pr10" onclick="plusMinusIconControl('batch');">
											                    <input type="radio" name="scoreType" value="batch" tabindex="0" class="hidden" checked>
											                    <label for="scoreBatch"><spring:message code="resh.label.reg.score" /></label><!-- 점수 등록 -->
											                </div>
											                <div class="ui radio checkbox" onclick="plusMinusIconControl('addition');">
											                    <input type="radio" name="scoreType" value="addition" tabindex="0" class="hidden">
											                    <label for="scoreAddition"><spring:message code="resh.label.plus.minus.score" /></label><!-- 점수 가감 -->
											                </div>
	                                                    </div>
	                                                    <div class="field ml15">
	                                                       <spring:message code="resh.label.point" /> <!-- 점수 -->
													    	<div class="ui left icon input p_w60">
														   		<i class="ion-plus link icon toggle-icon" style="display:none;"></i>
														   		<input type="text" id="scoreValue" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="w100" maxlength="3" />
													    	</div>
													    	 <spring:message code="resh.label.score" /><!-- 점 -->
	                                                    </div>
	                                                    <a href="javascript:submitScore()" class="ui blue button"><spring:message code="common.label.batch.score.save" /></a><!-- 일괄 점수저장 -->
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
                                    </c:if>
                                    <div class="option-content mb15 mt15">
								    	<a href="javascript:reshChartPop()" class="ui small blue button"><spring:message code="resh.label.status.join" /><!-- 참여현황 --></a>
								    	<h4 class="ml5">(<spring:message code="common.page.total" /><!-- 총 -->&nbsp;:&nbsp;<span id="totalCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h4>
								    	<div class="ui small blue buttons mla">
								    		<a href="javascript:manageResh(8)" class="ui button"><spring:message code="resh.button.excel.down.resh" /></a><!-- 제출 설문 엑셀다운로드 -->
											<a href="javascript:manageResh(9)" class="ui button ml5"><spring:message code="resh.button.excel.down.result" /></a><!-- 설문 결과 엑셀다운로드 -->
											<a href="javascript:joinUserExcelDown()" class="ui button ml5"><spring:message code="resh.button.excel.down" /><!-- 엑셀 다운로드 --></a>
								    	</div>
								    </div>
								    <table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='resh.common.empty' />"><!-- 등록된 내용이 없습니다. -->
										<thead>
											<tr>
												<th scope="col" class="tc" data-sortable="false">
													<div class="ui checkbox">
									                    <input type="checkbox" name="allEvalChk" id="userAllChk" onchange="userAllCheck(this)">
									                    <label class="toggle_btn" for="userAllChk"></label>
									                </div>
												</th>
												<th scope="col" data-sortable="false">No</th>
												<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="resh.label.dept.nm" /></th><!-- 학과 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.user.no" /></th><!-- 학번 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.user.grade" /></th><!-- 학년 -->
												<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
													<th scope="col" class="tc"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
												</c:if>
												<th scope="col" class="tc"><spring:message code="resh.label.user.nm" /></th><!-- 이름 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.admission.year" /></th><!-- 입학년도 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.admission.grade" /></th><!-- 입학학년 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="resh.label.admission.type" /></th><!-- 입학구분 -->
												<th scope="col" class="tc"><spring:message code="resh.label.eval.score" /><!-- 평가점수 --></th>
												<th scope="col" class="tc"><spring:message code="resh.label.join.yn" /></th><!-- 참여여부 -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="resh.label.join.dttm" /></th><!-- 참여일시 -->
												<th scope="col" class="tc" data-breakpoints="xs" data-sortable="false"><spring:message code="resh.label.manage" /><!-- 관리 --></th>
											</tr>
										</thead>
										<tbody id="reshJoinUserList">
										</tbody>
									</table>
                                </div>
                                <div class="option-content">
	                                <div class="mla">
										<a href="javascript:manageResh(3)" class="ui blue button"><spring:message code="resh.button.modify" /></a><!-- 수정 -->
										<a href="javascript:delResh()" class="ui basic button"><spring:message code="resh.button.delete" /></a><!-- 삭제 -->
										<a href="javascript:manageResh(4)" class="ui basic button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
		                            </div>
                                </div>
		                	</div>
		                </div>
        			</div>
        		</div>
			</div>
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
        
        <!-- ez grader modal pop -->
	    <div class="modal fade id" id="ezGraderPop" tabindex="-1" role="dialog" aria-labelledby="ezGrader" aria-hidden="false">
	        <div class="modal-dialog full" role="document">
	            <div class="modal-content">
	                <div class="modal-body">
	                    <iframe src="" id="ezGraderPopIfm" name="ezGraderPopIfm" width="100%" scrolling="no"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    </div>
</body>
</html>