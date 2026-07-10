<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function() {
			quizTkexamListSelect();

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					quizTkexamListSelect();
				}
			});
		});

		/**
		 * 퀴즈응시목록조회
		 */
		function quizTkexamListSelect() {
			const url  = "/quiz/profQuizTkexamListAjax.do";
			const data = {
				examBscId 		: "${vo.examBscId}",
				tkexamCmptnyn 	: $("#tkexamCmptnyn").val(),
				evlyn    		: $("#evlyn").val(),
				searchValue 	: $("#searchValue").val()
			};

			$.ajax({
		    	url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
	            success		: function (data) {
	            	if (data.result > 0) {
	    	     		let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

	    	     		userListTable.clearData();
	    	     		userListTable.replaceData(dataList);
	                } else {
	                	UiComm.showMessage(data.message, "error");
	                }
	             },
	             error		: () => UiComm.showMessage("<spring:message code='quiz.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
	             complete	: () => UiComm.showLoading(false)
		     });
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				// 응시상태
				let tkexamCmptnStatus = {
					"INIT" 			: wrapLabel("<spring:message code='quiz.label.reset' />", "fcNot")/* 초기화 */,
					"NOTKEXAM"		: wrapLabel("<spring:message code='quiz.label.not.tkexam' />", "fcRed")/* 미응시 */,
					"NORETKEXAM"	: wrapLabel("<spring:message code='quiz.label.not.retkexam' />", "fcRed")/* 재미응시 */,
					"COMPLETED"		: "<spring:message code='quiz.label.tkexam.completed' />"/* 응시완료 */,
					"RECOMPLETED"	: "<spring:message code='quiz.label.retkexam.completed' />"/* 재응시완료 */,
					"TKEXAMING"		: "<spring:message code='quiz.label.Attempting' />"/* 응시 중 */
				};
				// 역할
				let ldryn = {
					"Y" : "<spring:message code='common.team.leader' />"/* 팀장 */,
					"N" : "<spring:message code='common.team.members' />"/* 팀원 */
				};
				// 관리
				let mng = "";
				if(v.tkexamSdttm != null) {
					mng += "<a href='javascript:quizExampprEvlPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='quiz.button.view.examppr' /></a>"/* 시험지보기 */;
				}
				mng += "<a href='javascript:quizTkexamHstryPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='quiz.button.tkexam.hstry' /></a>"/* 응시기록 */;
				mng += "<a href='javascript:memoPopup(\"" + v.examDtlId + "\", \"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='quiz.button.memo' /></a>"/* 메모 */;

				dataList.push({
					no: 				v.lineNo,
					deptnm: 			v.deptnm,
					stdntNo: 			v.stdntNo,
					usernm: 			v.usernm,
					quizScr: 			v.tkexamSdttm == null ? "-" : v.quizScr,
					totScr: 			v.evlyn == "Y" ? wrapLabel(v.totScr, "fcBlue") : "-",
					tkexamCmptnGbnnm: 	tkexamCmptnStatus[v.tkexamCmptnGbncd],
					tkexamCnt: 			v.tkexamCnt + "<spring:message code='message.number' />"/* 회 */,
					evlyn: 				v.evlyn == "N" ? wrapLabel(v.evlyn, "fcRed") : v.evlyn,
					mng: 				mng,
					ldryn:				ldryn[v.ldryn],
					teamnm:				v.teamnm,
					userId:				v.userId,
					examDtlId:			v.examDtlId
				});
			});

			return dataList;
		}

		/**
		 * 퀴즈시험지평가팝업
		 * @param examDtlId - 시험상세아이디
		 * @param userId 	- 사용자아이디
		 */
		function quizExampprEvlPopup(examDtlId, userId) {
			const data = "examBscId=${vo.examBscId}&examDtlId="+examDtlId+"&userId="+userId+"&evlyn="+$("#evlyn").val()+"&tkexamCmptnyn=Y&searchValue="+$("#searchValue").val();

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.examppr.evl' />"/* 시험지 및 평가 */,
				url			: "/quiz/profQuizExampprEvlPopup.do?"+data,
				fullscreen	: true
			});
		}

		/**
		 * 퀴즈응시이력팝업
		 * @param examDtlId - 시험상세아이디
		 * @param userId 	- 사용자아이디
		 */
		function quizTkexamHstryPopup(examDtlId, userId) {
			const data = "examDtlId="+examDtlId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.tkexam.hstry.view' />"/* 응시기록 보기 */,
				width		: 1000,
				height		: 300,
				url			: "/quiz/profQuizTkexamHstryPopup.do?"+data,
				autoresize	: true
			});
		}

		 /**
		 * 메모팝업
		 * @param examDtlId - 시험상세아이디
		 * @param tkexamId 	- 시험응시아이디
		 * @param userId 	- 사용자아이디
		 */
		function memoPopup(examDtlId, tkexamId, userId) {
			const data = "examBscId=${vo.examBscId}&examDtlId="+examDtlId+"&tkexamId="+tkexamId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.memo' />"/* 메모 */,
				width		: 600,
				height		: 350,
				url			: "/quiz/profQuizMemoPopup.do?"+data,
				autoresize	: true
			});
		}

		// 퀴즈 재응시 설정
		function quizRetkexamSetting() {
			if("${vo.examQstnsCmptnyn}" == "Y") {
				let validator = UiValidator("retkexamForm");
				validator.then(function(result) {
					if (result) {
						if(userListTable.getSelectedData("userId").length == 0) {
							UiComm.showMessage("<spring:message code='quiz.alert.select.retkexam.stdnt' />", "info")/* 재응시 설정할 학습자를 선택해주세요. */;
							return;
						}

						const retkexamList = [];	// 재응시 설정 목록

						for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
							retkexamList.push({
								examBscId		: "${vo.examBscId}",									// 시험기본아이디
								examDtlId 		: userListTable.getSelectedData("examDtlId")[i],		// 시험상세아이디
								userId			: userListTable.getSelectedData("userId")[i],			// 사용자아이디
								reexamyn		: "Y",													// 재시험여부
								reexamPsblSdttm	: UiComm.getDateTimeVal("redateSt", "retimeSt")+"00",	// 재시험가능시작일시
								reexamPsblEdttm	: UiComm.getDateTimeVal("redateEd", "retimeEd")+"59",	// 재시험가능종료일시
								reexamMrkRfltrt	: $("#reexamMrkRfltrt").val()							// 재시험성적반영비율
							});
						}

						$.ajax({
			                url			: "/quiz/quizRetkexamSettingAjax.do",
			                type		: "POST",
			                contentType	: "application/json",
			                data		: JSON.stringify(retkexamList),
			                dataType	: "json",
			                beforeSend	: () => UiComm.showLoading(true),
			                success		: function (data) {
			                    if (data.result > 0) {
			                    	UiComm.showMessage("<spring:message code='quiz.alert.retkexam' />", "success");/* 재응시 설정이 완료되었습니다. */
					        		quizTkexamListSelect();
			                    } else {
			                    	UiComm.showMessage(data.message, "error");
			                    }
			                    UiComm.showLoading(false);
			                },
			                error		: () => UiComm.showMessage("<spring:message code='quiz.error.retkexam' />", "error"),/* 재응시 설정 중 에러가 발생하였습니다. */
			                complete	: () => UiComm.showLoading(false)
			            });
					}
				});
			} else {
				UiComm.showMessage("<spring:message code='quiz.alert.already.qstns.emptn' />", "info");/* 문제 출제 완료 후 가능합니다. */
			}
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
				UiComm.showMessage("<spring:message code='common.alert.sysmsg.select_user'/>", "info");// 메시지 발송 대상자를 선택하세요.
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

		// 수강생 전체 버튼
		function resetListSelect() {
			$("#tkexamCmptnyn").val('').trigger('chosen:updated');
			$("#evlyn").val('').trigger("chosen:updated");
			$("#searchValue").val("");
			quizTkexamListSelect();
		}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
		<!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

		<!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

					<div class="sub-content">
						<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.common.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li><a onclick="quizViewMv('${vo.examBscId}', 'EVL')"><spring:message code="quiz.tab.evl" /><!-- 퀴즈정보 및 평가 --></a></li>
					            <li><a onclick="quizViewMv('${vo.examBscId}', 'QSTN')"><spring:message code="quiz.tab.qstn" /><!-- 문항관리 --></a></li>
					            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
						            <li class="select"><a onclick="quizViewMv('${vo.examBscId}', 'RETKEXAM')"><spring:message code="quiz.tab.retkexam" /><!-- 재응시 관리 --></a></li>
					            </c:if>
					        </ul>
					    </div>

				        <div class="board_top">
				        	<h3 class="board-title"><spring:message code="quiz.tab.retkexam" /><!-- 재응시 관리 --></h3>
					        <div class="right-area">
					        	<a href="javascript:quizRetkexamSetting()" class="btn type1 big"><spring:message code="quiz.button.retkexam" /></a><!-- 재응시 설정 -->
								<a href="javascript:quizViewMv('${vo.examBscId}', 'LIST')" class="btn type2 big"><spring:message code="common.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

					    <%--퀴즈 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/quiz/common/quiz_info_inc.jsp"/>
	                    <%--퀴즈 정보--%>

						<div>
							<div class="board_top mb0">
	                            <h4 class="sub-title"><spring:message code="common.label.students" /><!-- 수강생 --></h4>
	                            <div class="right-area">
	                                <button type="button" class="btn basic" onclick="sendMsg()"><spring:message code="common.button.message.send" /><!-- 메세지 보내기 --></button>
	                            </div>
	                        </div>

	                        <div class="board_top in_table">
	                            <select class="form-select" id="tkexamCmptnyn" onchange="quizTkexamListSelect()">
	                                <option value=""><spring:message code="quiz.label.attendance" /><!-- 응시여부 --></option>
									<option value="all"><spring:message code="quiz.common.all" /><!-- 전체 --></option>
									<option value="N"><spring:message code="quiz.label.not.tkexam" /><!-- 미응시 --></option>
									<option value="Y"><spring:message code="quiz.label.tkexam.completed" /><!-- 응시완료 --></option>
	                            </select>
	                            <select class="form-select" id="evlyn" onchange="quizTkexamListSelect()">
	                                <option value=""><spring:message code="quiz.label.evlyn" /><!-- 평가여부 --></option>
									<option value="all"><spring:message code="quiz.common.all" /><!-- 전체 --></option>
									<option value="Y"><spring:message code="quiz.label.evl" /><!-- 평가 --></option>
									<option value="N"><spring:message code="quiz.label.not.evl" /><!-- 미평가 --></option>
	                            </select>
	                            <!-- search small -->
	                            <div class="search-typeC">
	                                <input class="form-control" type="text" id="searchValue" placeholder="<spring:message code='quiz.placeholder.input.deptnm.userid.usernm' />"><!-- 학과/학번/성명 입력 -->
	                                <button type="button" class="btn basic icon search" aria-label="검색" onclick="quizTkexamListSelect()"><i class="icon-svg-search"></i></button>
	                            </div>
	                            <button type="button" class="btn search" onclick="resetListSelect()"><spring:message code="quiz.button.all.learners" /><!-- 수강생 전체 --></button>
	                        </div>

	                        <form id="retkexamForm" class="table-wrap margin-bottom-5">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label><spring:message code="quiz.label.reperiod" /><!-- 재응시기간 --></label></th>
											<td>
												<input id="redateSt" type="text" name="redateSt" class="datepicker" timeId="retimeSt" toDate="redateEd" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,0,8)}">
												<input id="retimeSt" type="text" name="retimeSt" class="timepicker" dateId="redateSt" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,8,12)}">
												<span class="txt-sort">~</span>
												<input id="redateEd" type="text" name="redateEd" class="datepicker" timeId="retimeEd" fromDate="redateSt" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,0,8)}">
												<input id="retimeEd" type="text" name="retimeEd" class="timepicker" dateId="redateEd" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,8,12)}">
											</td>
										</tr>
										<tr>
											<th><label><spring:message code="quiz.label.retkexam.scr.weight" /><!-- 재응시 적용률 --></label></th>
											<td>
												<div class="form-row">
													<div class="input_btn">
														<input class="form-control md" name="reexamMrkRfltrt" id="reexamMrkRfltrt" type="text" required="true" inputmask="numeric" maxVal="100" value="${vo.examDtlVO.reexamMrkRfltrt }" autocomplete="off"><label>%</label>
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</form>

							<div id="list"></div>

							<script>
								let userListTable = UiTable("list", {
									lang: "ko",
									selectRow: "checkbox",
									columns: [
										{title:"No", 																					field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										("${vo.examGbncd}" == "QUIZ_TEAM" ? {title: "<spring:message code='common.team.name' />", 		field: "teamnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),/* 팀명 */
										{title:"<spring:message code='common.dept_name' />", 											field:"deptnm",				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},/* 학과 */
										{title:"<spring:message code='common.label.student.number' />", 								field:"stdntNo", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},/* 학번 */
										{title:"<spring:message code='common.name' />", 												field:"usernm", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},/* 이름 */
										("${vo.examGbncd}" == "QUIZ_TEAM" ? {title: "<spring:message code='common.label.user.role' />", field: "ldryn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),/* 역할 */
										{title:"<spring:message code='quiz.label.quiz.scr' />", 										field:"quizScr", 			headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 퀴즈점수 */
										{title:"<spring:message code='quiz.label.evl.scr' />", 											field:"totScr", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 평가점수 */
										{title:"<spring:message code='quiz.label.tkexam.status' />", 									field:"tkexamCmptnGbnnm", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 응시상태 */
										{title:"<spring:message code='quiz.label.tkexam.cnt' />", 										field:"tkexamCnt", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 응시횟수 */
										{title:"<spring:message code='quiz.label.evlyn' />", 											field:"evlyn", 				headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 평가여부 */
										{title:"<spring:message code='common.mgr' />", 													field:"mng", 				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},/* 관리 */
									].filter(function(col) {return col !== null;})
								});
							</script>
						</div>
					</div>
				</div>
			</div>
			<!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>