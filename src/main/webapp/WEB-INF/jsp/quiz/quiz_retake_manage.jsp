<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function() {
		listQuizUser();

		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listQuizUser();
			}
		});

		$(".accordion").accordion();
		$("#reExamYn").parent().css("z-index", "1001");
	});

	function manageQuiz(tab) {
		var urlMap = {
			"1" : "/quiz/quizQstnManage.do",	// 퀴즈 문제 관리 페이지
			"2" : "/quiz/quizRetakeManage.do",	// 퀴즈 재응시 관리 페이지
			"3" : "/quiz/quizScoreManage.do",	// 퀴즈 평가 관리 페이지
			"9" : "/quiz/profQzListView.do"		// 목록
		};

		var kvArr = [];
		kvArr.push({'key' : 'examCd',   'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm(urlMap[tab], "", "", kvArr);
	}

	// 퀴즈 재응시 참여자 리스트 조회
	function listQuizUser() {
		var url  = "/quiz/quizStareUserList.do";
		var data = {
			"examCd" 	  : "${vo.examCd}",
			"searchValue" : $("#searchValue").val(),
			"pagingYn"	  : "N",
			"examTypeCd"  : "${vo.examTypeCd}",
			"searchFrom"  : "REEXAM",
			"reExamYn"    : $("#reExamYn").val()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var html = ``;
        		data.returnList.forEach(function(v, i) {
        			var regDttm     = v.regDttm != null && v.hstyTypeCd == 'COMPLETE' ? dateFormat("date", v.regDttm) : "";
        			var totGetScore = v.totGetScore == null ? 0 : v.totGetScore;
        			var hstyTypeNm  = "<spring:message code='exam.label.no.stare' />"/* 미응시 */;
        			if(v.hstyTypeCd == "REEXAM") hstyTypeNm = "<spring:message code='exam.label.reexam.no.stare' />"/* 재응시미완료 */;
        			if(v.hstyTypeCd == "COMPLETE" || v.hstyTypeCd == "START" || v.hstyTypeCd == "RESTORE") {
        				hstyTypeNm  = v.reExamYn == "Y" ? "<spring:message code='exam.label.reexam.complete.stare' />"/* 재응시완료 */ : "<spring:message code='exam.label.complete.stare' />"/* 응시완료 */;
        			}
        			html += `<tr data-stdNo="\${v.stdNo}">`;
        			html += `	<td class="tc">`;
        			html += `		<div class='ui checkbox'>`;
        			html += `			<input type="checkbox" tabindex="0" id="chk\${v.lineNo }" name="evalChk" value="\${v.stdNo}" class="chk" onchange="userCheck(this)" user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
        			html += `			<label class="toggle_btn" for="chk\${v.lineNo }">\${v.lineNo }</label>`;
        			html += `		</div>`;
        			html += `	</td>`;
        			html += `	<td class="tc word_break_none">\${v.deptNm }</td>`;
        			html += `	<td class="tc">\${v.userId }</td>`;
        			html += `	<td class="tc">\${v.hy }</td>`;
        			html += `	<td class="tc word_break_none">\${v.userNm }<a href="javascript:userInfoPop('\${v.userId}')" class='ml5'><i class='ico icon-info'></i></a></td>`;
        			html += `	<td class="tc">\${v.entrYy}</td>`;
        			html += `	<td class="tc">\${v.entrHy}</td>`;
        			html += `	<td class="tc word_break_none">\${v.entrGbnNm}</td>`;
        			html += `	<td class="tc">\${totGetScore }<spring:message code="exam.label.score.point" /></td>`;/* 점 */
        			html += `	<td class="tc">\${v.reExamYn}</td>`;
        			html += `	<td class="tc">\${hstyTypeNm }</td>`;
        			html += `	<td class="tc word_break_none">\${regDttm }</td>`;
        			html += `	<td class="tc word_break_none">`;
        			html += `		<a href="javascript:quizQstnEvalPop('\${v.examCd }', '\${v.stdNo }')" class="ui basic mini button"><spring:message code="exam.label.paper" />​</a>`;/* 시험지 */
        			html += `		<a href="javascript:quizRecordViewPop('\${v.examCd }', '\${v.stdNo }')" class="ui basic mini button"><spring:message code="exam.button.stare.hsty" />​</a>`;/* 응시기록 */
        			html += `	</td>`;
        			html += `</tr>`;
        		});
        		$("#quizStareUserList").empty().append(html);

		    	$(".table").footable();
		    	$(".table").parent("div").addClass("max-height-550");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}

	// 버튼 클릭 focused
	function btnFocuesd(stdNo) {
		$("#quizStareUserList > tr").removeClass("focused");
		$("#quizStareUserList > tr[data-stdNo='"+stdNo+"']").addClass("focused");
	}

	// 퀴즈 시험지 보기
	function quizQstnEvalPop(examCd, stdNo) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);

		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	   'val' : examCd});
		kvArr.push({'key' : 'stdNo', 	   'val' : stdNo});
		kvArr.push({'key' : 'searchValue', 'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'crsCreCd',    'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizQstnEvalPop.do", "quizPopIfm", "qstnEval", kvArr);
	}

	// 응시 기록 보기
	function quizRecordViewPop(examCd, stdNo) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);

		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : examCd});
		kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizRecordViewPop.do", "quizPopIfm", "recordView", kvArr);
	}

	// 퀴즈 재응시 설정
	function reQuizStare() {
		if($("#reExamStartFmt").val() == "") {
    		alert("<spring:message code='exam.alert.input.reexam.start.dttm' />");/* 재응시 시작일자를 입력하세요. */
    		return false;
    	}
		if($("#reExamStartHH").val() == " ") {
			alert("<spring:message code='exam.alert.input.reexam.start.dttm.hour'/>");/* 재응시 시작시간을 입력하세요. */
			return false;
		}
		if($("#reExamStartMM").val() == " ") {
			alert("<spring:message code='exam.alert.input.reexam.start.dttm.min'/>");/* 재응시 시작분을 입력하세요. */
			return false;
		}
    	if($("#reExamEndFmt").val() == "") {
    		alert("<spring:message code='exam.alert.input.reexam.end.dttm' />");/* 재응시 종료일자를 입력하세요. */
    		return false;
    	}
    	if($("#reExamEndHH").val() == " ") {
			alert("<spring:message code='exam.alert.input.reexam.end.dttm.hour'/>");/* 재응시 종료시간을 입력하세요. */
			return false;
		}
		if($("#reExamEndMM").val() == " ") {
			alert("<spring:message code='exam.alert.input.reexam.end.dttm.min'/>");/* 재응시 종료분을 입력하세요. */
			return false;
		}
		if($("#reExamAplyRatio").val() < 0 || $("#reExamAplyRatio").val() > 100 || $("#reExamAplyRatio").val() == "") {
			alert("<spring:message code='exam.alert.input.reexam.aply.ratio.0.100' />");/* 재응시 적용률을 0 ~ 100% 사이로 입력해주세요. */
			return false;
		}
		var reExamStartDttm = $("#reExamStartFmt").val().replaceAll(".","") + $("#reExamStartHH").val() + $("#reExamStartMM").val() + "00";
		var reExamEndDttm   = $("#reExamEndFmt").val().replaceAll(".","") + $("#reExamEndHH").val() + $("#reExamEndMM").val() + "00";

		var stdNos = "";
		$(".chk:checked").each(function(i) {
			if(i > 0) {
				stdNos += ",";
			}
			stdNos += $(this).val();
		});

		var url  = "/quiz/editReQuizStare.do";
		var data = {
			"examCd" : "${vo.examCd}",
			"stdNos" : stdNos,
			"reExamStartDttm" : reExamStartDttm,
			"reExamEndDttm"	  : reExamEndDttm,
			"reExamAplyRatio" : $("#reExamAplyRatio").val()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		alert("<spring:message code='exam.alert.reexam' />");/* 재응시 설정이 완료되었습니다. */
        		listQuizUser();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.reexam' />");/* 재응시 설정 중 에러가 발생하였습니다. */
		});
	}

	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;

		$.each($('#quizStareUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
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

	// 팝업 점수 저장
	function qstnScoreEdit() {
		listQuizUser();
	}

	// 체크 이벤트
	function userCheck(obj) {
		if(obj.value == "all") {
			$("input[name=evalChk]").prop("checked", obj.checked);
			if(obj.checked) {
				$("input[name=evalChk]").closest("tr").addClass("on");
			} else {
				$("input[name=evalChk]").closest("tr").removeClass("on");
			}
		} else {
			if(obj.checked) {
				$(obj).closest("tr").addClass("on");
			} else {
				$(obj).closest("tr").removeClass("on");
			}
			$("#stuAllChk").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
		}
	}
</script>
</head>
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
								setLocationBar('<spring:message code="exam.label.quiz" />', '<spring:message code="exam.tab.reexam.manage" />'); // 퀴즈 미응시 관리
							});
						</script>

		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
                            <div class="button-area">
                            	<a href="javascript:reQuizStare()" class="ui blue button"><spring:message code="exam.button.reexam" /></a><!-- 재응시 설정 -->
								<a href="javascript:manageQuiz(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
                            </div>
		                </div>
		                <div class="row">
		                	<div class="col">
								<div class="listTab">
			                        <ul>
			                            <li class="mw120"><a onclick="manageQuiz(1)"><spring:message code="eaxm.tab.qstn.manage" /></a></li><!-- 문제 관리 -->
			                            <c:if test="${vo.reExamYn eq 'Y'}">
				                            <li class="select mw120"><a onclick="manageQuiz(2)"><spring:message code="exam.tab.reexam.manage" /></a></li><!-- 미응시 관리 -->
			                            </c:if>
			                            <li class="mw120"><a onclick="manageQuiz(3)"><spring:message code="exam.label.info.score.manage" /></a></li><!-- 정보 및 평가 -->
			                        </ul>
			                    </div>
								<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
									<div class="title">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
													<spring:message code="exam.common.no"  var="no" /><!-- 아니오 -->
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
													<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examEndDttm }" />
													<fmt:formatDate var="examEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
													<p class="lect_name">${fn:escapeXml(vo.examTitle) }</p>
													<span class="fcGrey">
														<small><spring:message code="crs.label.quiz_period" /><!-- 퀴즈기간 --> : ${examStartDttm } ~ ${examEndDttm }</small> |
														<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.scoreAplyYn eq 'Y' ? yes : no }</small> |
														<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.scoreOpenYn eq 'Y' ? yes : no }</small> |
														<small>
															<spring:message code="exam.label.qstn.status" /><!-- 문제출제상태 --> :
															<c:choose>
																<c:when test="${vo.examSubmitYn eq 'Y' or vo.examSubmitYn eq 'M'}">
																	<span><spring:message code="exam.label.qstn.submit.y" /><!-- 출제완료 --></span>
																</c:when>
																<c:otherwise>
																	<span class="fcRed"><spring:message code="exam.label.qstn.temp.save" /><!-- 임시저장 --></span>
																</c:otherwise>
															</c:choose>
														</small>
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
															<label for="subjectLabel"><spring:message code="crs.label.quiz_contents" /></label><!-- 퀴즈내용 -->
														</dt>
														<dd><pre>${vo.examCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="crs.label.quiz_period" /></label><!-- 퀴즈기간 -->
														</dt>
														<dd>${examStartDttm } ~ ${examEndDttm }</dd>
														<dt>
															<label><spring:message code="exam.label.view.qstn.type" /></label><!-- 문제표시방식 -->
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.viewQstnTypeCd eq 'ALL' }">
																	<spring:message code="exam.label.all.view.qstn" /><!-- 전체문제 표시 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="exam.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="crs.label.quiz_time" /></label><!-- 퀴즈시간 -->
														</dt>
														<dd>${vo.examStareTm }<spring:message code="exam.label.stare.min" /><!-- 분 --></dd>
														<dt>
															<label><spring:message code="exam.label.empl.random" /><!-- 보기 섞기 --></label>
														</dt>
														<dd>${vo.emplRandomYn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="forum.label.score.ratio" /></label><!-- 성적 반영비율 -->
														</dt>
														<dd>${vo.scoreAplyYn eq 'Y' ? vo.scoreRatio : '0' }%</dd>
														<dt>
															<label for="contLabel"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
														</dt>
														<dd>
															<c:forEach var="list" items="${vo.fileList }">
																<button class="ui icon small button" id="file_${list.fileSn }" title="<spring:message code="forum.label.attachFile.download" />" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
																<script>
																	byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
																</script>
															</c:forEach>
														</dd>
													</dl>
												</li>
											</ul>
										</div>
									</div>
								</div>
		                		<div class="ui message mt0 flex align-items-start gap4">
		                            <div>
		                                <ul class="tbl-simple dt-sm">
		                                    <li>
		                                    	<dl>
		                                    		<dt><spring:message code="std.label.quiz_period" /><!-- 응시 기간 --></dt>
		                                    		<dd>
		                                    			<div class="fields gap4">
					                                        <div class="field flex">
					                                           <!-- 시작일시 -->
					                                           <uiex:ui-calendar dateId="reExamStartFmt" hourId="reExamStartHH" minId="reExamStartMM"
					                                           		rangeType="start" rangeTarget="reExamEndFmt" value="${vo.reExamStartDttm}"/>
					                                        </div>
					                                        <div class="field p0 flex-item desktop-elem">~</div>
					                                        <div class="field flex">
					                                       	   <!-- 종료일시 -->
					                                           <uiex:ui-calendar dateId="reExamEndFmt" hourId="reExamEndHH" minId="reExamEndMM"
					                                           		rangeType="end" rangeTarget="reExamStartFmt" value="${vo.reExamEndDttm}"/>
					                                        </div>
					                                    </div>
		                                    		</dd>
		                                    	</dl>
		                                    </li>
		                                    <li>
		                                    	<dl>
		                                    		<dt><spring:message code="exam.label.score.aply.rate" /><!-- 반영비율 --></dt>
		                                    		<dd>
		                                    			<div class="fields">
		                                    				<div class="field">
		                                    					<div class="ui input p_w60">
					                                    			<input type="text" class="num" id="reExamAplyRatio" value="${vo.reExamAplyRatio }" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxLength="3" />
		                                    					</div>
		                                    					%
		                                    				</div>
		                                    			</div>
		                                    		</dd>
		                                    	</dl>
		                                    </li>
		                                </ul>
		                            </div>
		                        </div>

		                		<div class="ui segment">
									<div class="option-content mb15">
										<select class="ui dropdown mr5" id="reExamYn" onchange="listQuizUser()">
											<option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
											<option value="Y"><spring:message code="exam.label.grant" /><!-- 부여 --></option>
											<option value="N"><spring:message code="exam.label.not.grant" /><!-- 미부여 --></option>
										</select>
										<div class="ui action input search-box">
									        <input type="text" id="searchValue" class="w250" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
									        <button class="ui icon button" onclick="listQuizUser()"><i class="search icon"></i></button>
									    </div>
									    <div class="mla">
									    	<a href="javascript:sendMsg()" class="ui small basic button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
									    </div>
									</div>
									<table class="table type2 mt20" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
										<thead>
											<tr class="ui native sticky top0">
												<th scope="col" class="tc">
													<div class="ui checkbox">
														<input type="checkbox" name="allCheck" id="stuAllChk" value="all" tabindex="0" onchange="userCheck(this)">
														<label class="toggle_btn" for="stuAllChk"></label><!-- NO. -->
													</div>
												</th>
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
												<th scope="col" class="tc"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.user.grade" /></th><!-- 학년 -->
												<th scope="col" class="tc"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.admission.year" /></th><!-- 입학년도 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.admission.grade" /></th><!-- 입학학년 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.admission.type" /></th><!-- 입학구분 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.eval.score" /></th><!-- 평가점수 -->
												<th scope="col" class="tc"><spring:message code="exam.button.reexam" /></th><!-- 재응시 설정 -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.stare.situation" /></th><!-- 응시상태 -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.reexam.dttm" /></th><!-- 재응시일시 -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.manage" /></th><!-- 관리 -->
											</tr>
										</thead>
										<tbody id="quizStareUserList">
										</tbody>
									</table>
									<div id="paging" class="paging"></div>
								</div>
								<div class="option-content">
									<div class="mla">
		                            	<a href="javascript:reQuizStare()" class="ui blue button"><spring:message code="exam.button.reexam" /></a><!-- 재응시 설정 -->
										<a href="javascript:manageQuiz(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
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
    </div>
</body>
</html>