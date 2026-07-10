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

			// 일괄 성적처리 아이콘 변경
			$('#scr-toggle-icon').click(function() {
	            $(this).children("i").toggleClass("xi-plus xi-minus");
	        });

			$("#scoreBatch").trigger("click");
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
				let mng = "<a href='javascript:quizExampprInit(\"" + v.tkexamId + "\", \"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='quiz.button.reset' /></a>"/* 퀴즈초기화 */;
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
					examDtlId:			v.examDtlId,
					tkexamId:			v.tkexamId
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
		* 퀴즈시험지초기화
		* @param tkexamId 	- 시험응시아이디
		* @param examDtlId 	- 시험상세아이디
		* @param userId 	- 사용자아이디
		*/
		function quizExampprInit(tkexamId, examDtlId, userId) {
			if("${vo.examQstnsCmptnyn}" == "Y") {
				UiComm.showMessage("<spring:message code='quiz.confirm.reset' />", "confirm")/* 퀴즈 초기화를 하시겠습니까? */
				.then(function(result) {
					if (result) {
						const url  = "/quiz/profQuizExampprInitAjax.do";
						const data = {
							tkexamId  	: tkexamId,
							examBscId 	: "${vo.examBscId}",
							examDtlId 	: examDtlId,
							userId 		: userId
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
			                    	UiComm.showMessage("<spring:message code='quiz.alert.reset' />", "success");/* 퀴즈 초기화가 완료되었습니다. */
						    		quizTkexamListSelect();
			                    } else {
			                    	UiComm.showMessage(data.message, "error");
			                    }
			                },
			                error		: () => UiComm.showMessage("<spring:message code='quiz.error.reset' />", "error"),/* 초기화 중 에러가 발생하였습니다. */
			                complete	: () => UiComm.showLoading(false)
					    });
					}
				});
			} else {
				UiComm.showMessage("<spring:message code='quiz.alert.already.qstns.emptn' />", "info");/* 문제 출제 완료 후 가능합니다. */
			}
		}

		// 점수 가감 아이콘 표시 확인
		function plusMinusIconControl(scoreType){
			$("#scr-toggle-icon").toggle(scoreType === "addition");
		}

		/**
		* 평가점수일괄수정
		*/
		function EvlScrBulkModify() {
			let validator = UiValidator("scoreForm");
			validator.then(function(result) {
				if (result) {
					if(userListTable.getSelectedData("userId").length == 0) {
						UiComm.showMessage("<spring:message code='quiz.alert.batch.score.select' />", "info");/* 일괄 성적처리할 학습자를 선택해주세요. */
						return;
					}

					let score = $("#scoreValue").val();
					if($("input[name='scoreType']:checked").val() == "addition"){
						if(!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")){
							score = score * (-1);
						}
					}

					const scrList = [];	// 점수 목록

					for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
						scrList.push({
							examDtlId 	: userListTable.getSelectedData("examDtlId")[i],	// 시험상세아이디
							tkexamId 	: userListTable.getSelectedData("tkexamId")[i],		// 시험응시아이디
							userId		: userListTable.getSelectedData("userId")[i],		// 사용자아이디
							scr			: score,											// 점수
							scoreType	: $("input[name='scoreType']:checked").val()		// 점수유형
						});
					}

					$.ajax({
		                url			: "/quiz/profQuizEvlScrBulkModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(scrList),
		                dataType	: "json",
		                beforeSend	: () => UiComm.showLoading(true),
		                success		: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='quiz.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#scoreValue").val("");
				        		quizTkexamListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                },
		                error		: () => UiComm.showMessage("<spring:message code='quiz.error.batch.score' />", "error"),/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		                complete	: () => UiComm.showLoading(false)
		            });
				}
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

		// 엑셀성적등록팝업
		function excelScrRegistPopup() {
			const data = "examBscId=${vo.examBscId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.excel.upload.score' />"/* 엑셀 성적등록 */,
				width		: 600,
				height		: 500,
				url			: "/quiz/profQuizExcelScrRegistPopup.do?"+data,
				autoresize	: true
			});
		}

		/**
		 * 퀴즈응시현황엑셀다운로드
		 */
		function quizTkexamStatusExcelDown() {
			let examGbncd = "${vo.examGbncd}";
			let ldrynObj  = {Y: "<spring:message code='common.team.leader' />"/* 팀장 */, N: "<spring:message code='common.team.members' />"/* 팀원 */};
			let tkexamCmptnObj = {
				  INIT			: "<spring:message code='quiz.label.reset' />"/* 초기화 */
				, NOTKEXAM		: "<spring:message code='quiz.label.not.tkexam' />"/* 미응시 */
				, NORETKEXAM	: "<spring:message code='quiz.label.not.retkexam' />"/* 재미응시 */
				, COMPLETED		: "<spring:message code='quiz.label.tkexam.completed' />"/* 응시완료 */
				, RECOMPLETED	: "<spring:message code='quiz.label.retkexam.completed' />"/* 재응시완료 */
				, TKEXAMING		: "<spring:message code='quiz.label.Attempting' />"/* 응시 중 */
			};

			let excelGrid = { colModel: [] };

			excelGrid.colModel.push({label: 'No.', 														name: 'lineNo', 			align: 'center', 	width: '1000'});
			if(examGbncd == "QUIZ_TEAM") {
				excelGrid.colModel.push({label: "<spring:message code='common.team.name' />", 			name: 'teamnm', 			align: 'left', 		width: '4000'});/* 팀명 */
			}
			excelGrid.colModel.push({label: "<spring:message code='common.dept_name' />", 				name: 'deptnm', 			align: 'left', 		width: '5000'});/* 학과 */
			excelGrid.colModel.push({label: "<spring:message code='common.label.student.number' />", 	name: 'stdntNo', 			align: 'center', 	width: '5000'});/* 학번 */
			excelGrid.colModel.push({label: "<spring:message code='common.name' />", 					name: 'usernm', 			align: 'center', 	width: '5000'});/* 이름 */
			if(examGbncd == "QUIZ_TEAM") {
				excelGrid.colModel.push({label: "<spring:message code='common.label.user.role' />", 	name: 'ldryn', 				align: 'left', 		width: '5000', 	codes: ldrynObj});/* 역할 */
			}
			excelGrid.colModel.push({label: "<spring:message code='quiz.label.quiz.scr' />", 			name: 'quizScr', 			align: 'center', 	width: '3000'});/* 퀴즈점수 */
			excelGrid.colModel.push({label: "<spring:message code='quiz.label.evl.scr' />", 			name: 'totScr', 			align: 'center', 	width: '3000'});/* 평가점수 */
			excelGrid.colModel.push({label: "<spring:message code='quiz.label.tkexam.status' />", 		name: 'tkexamCmptnGbncd', 	align: 'left', 		width: '5000', 	codes: tkexamCmptnObj});/* 응시상태 */
			excelGrid.colModel.push({label: "<spring:message code='quiz.label.tkexam.cnt' />", 			name: 'tkexamCnt', 			align: 'center', 	width: '3000'});/* 응시횟수 */
			excelGrid.colModel.push({label: "<spring:message code='quiz.label.evlyn' />", 				name: 'evlyn', 				align: 'left', 		width: '5000'});/* 평가여부 */

			let kvArr = [];
			kvArr.push({'key' : 'examBscId', 	   	'val' : "${vo.examBscId}"});
			kvArr.push({'key' : 'tkexamCmptnyn', 	'val' : $("#tkexamCmptnyn").val()});
			kvArr.push({'key' : 'evlyn', 			'val' : $("#evlyn").val()});
			kvArr.push({'key' : 'searchValue', 		'val' : $("#searchValue").val()});
			kvArr.push({'key' : 'excelGrid',   		'val' : JSON.stringify(excelGrid)});

			submitForm("/quiz/profQuizTkexamStatusExcelDown.do", kvArr);
		}

		/**
		 * 퀴즈시험지일괄엑셀다운로드
		 */
		function quizExampprBlukExcelDown() {
			let kvArr = [];
			kvArr.push({'key' : 'examBscId', 	'val' : "${vo.examBscId}"});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm("/quiz/profQuizExampprBulkExcelDown.do", kvArr);
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

			if (userListTable.getSelectedData("userId").length == 0) {
				UiComm.showMessage("<spring:message code='common.alert.sysmsg.select_user'/>", "info");	/* 메시지 발송 대상자를 선택하세요. */
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

		/**
		 * 퀴즈 삭제
		 */
		function quizDelete() {
			let confirm = "<spring:message code='quiz.confirm.delete.answer.user.n' />";/* 퀴즈 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			if("${vo.tkexamStrtUserCnt}" > 0) {
				confirm = "<spring:message code='quiz.confirm.delete.answer.user.y' />";/* 퀴즈 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					const url  = "/quiz/quizDeleteAjax.do";
					const data = {
						examBscId 	: "${vo.examBscId}",
						delyn		: "Y"
					};

					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='quiz.alert.delete' />", "success");	/* 정상 삭제 되었습니다. */
			        		quizViewMv("${vo.examBscId}", "LIST");	// 퀴즈 목록 화면
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='quiz.error.delete' />", "error");	/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		/**
		 * 퀴즈응시현황팝업
		 */
		function quizChartPop() {
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.attendance.status' />"/* 응시현황 */,
				width		: 800,
				height		: 400,
				url			: "/quiz/profQuizTkexamStatusPopup.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams({examBscId : "${vo.examBscId}"}),
				autoresize	: true
			});
		}

		// 퀴즈시험지일괄인쇄
		function quizExampprBulkPrintPopup() {
			const data = "examBscId=${vo.examBscId}&tkexamCmptnyn="+$("#tkexamCmptnyn").val()+"&evlyn="+$("#evlyn").val()+"&searchValue="+$("#searchValue").val();

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.label.examppr.print' />"/* 시험지 인쇄 */,
				width		: 600,
				height		: 500,
				url			: "/quiz/profQuizExampprBulkPrintPopup.do?"+data,
				autoresize	: true
			});
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
					            <li class="select"><a onclick="quizViewMv('${vo.examBscId}', 'EVL')"><spring:message code="quiz.tab.evl" /><!-- 퀴즈정보 및 평가 --></a></li>
					            <li><a onclick="quizViewMv('${vo.examBscId}', 'QSTN')"><spring:message code="quiz.tab.qstn" /><!-- 문항관리 --></a></li>
					            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
						            <li><a onclick="quizViewMv('${vo.examBscId}', 'RETKEXAM')"><spring:message code="quiz.tab.retkexam" /><!-- 재응시 관리 --></a></li>
					            </c:if>
					        </ul>
					    </div>

				        <div class="board_top">
				        	<h3 class="board-title"><spring:message code="quiz.tab.evl" /><!-- 퀴즈정보 및 평가 --></h3>
					        <div class="right-area">
					        	<a href="javascript:quizViewMv('${vo.examBscId}', 'MODIFY')" class="btn type1 big"><spring:message code="common.button.modify" /></a><!-- 수정 -->
								<a href="javascript:quizDelete()" class="btn type2 big"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
								<a href="javascript:quizViewMv('${vo.examBscId}', 'LIST')" class="btn type2 big"><spring:message code="common.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

				        <%--퀴즈 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/quiz/common/quiz_info_inc.jsp"/>
	                    <%--퀴즈 정보--%>

						<div>
							<div class="board_top mb0">
	                            <h4 class="sub-title"><spring:message code="quiz.button.evl" /><!-- 퀴즈평가 --></h4>
	                            <div class="right-area">
	                                <button type="button" class="btn type2" onclick="excelScrRegistPopup()"><spring:message code="quiz.button.excel.upload.score" /><!-- 엑셀 성적등록 --></button>
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

	                        <div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
	                                    <tr>
	                                        <th><label><spring:message code="quiz.label.batch.score.processing" /><!-- 일괄 성적처리 --></label></th>
	                                        <td>
	                                            <div class="form-inline">
	                                                <span class="custom-input">
	                                                    <input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true">
	                                                    <label for="scoreBatch"><spring:message code="quiz.label.reg.scoring" /><!-- 점수 등록 --></label>
	                                                </span>
	                                                <span class="custom-input ml5">
	                                                    <input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true">
	                                                    <label for="scoreAddition"><spring:message code="quiz.label.plus.minus.scoring" /><!-- 점수 가감 --></label>
	                                                </span>
	                                                <div class="custom-txt">
	                                                    <span class="tit"><spring:message code="common.score" /><!-- 점수 --> :</span>
	                                                    <button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
	                                                    <div class="input_btn">
	                                                        <input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
	                                                        <label for="scoreValue"><spring:message code="message.score" /><!-- 점 --></label>
	                                                    </div>
	                                                </div>
	                                                <button type="button" class="btn type1" onclick="EvlScrBulkModify()"><spring:message code="common.button.save" /><!-- 저장 --></button>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                </tbody>
	                            </table>
	                        </div>

	                        <div class="board_top">
	                            <div class="right-area">
	                                <button type="button" class="btn basic" onclick="quizExampprBulkPrintPopup()"><spring:message code="quiz.button.bulk.examppr.print" /><!-- 시험지 일괄 인쇄 --></button>
	                                <button type="button" class="btn basic" onclick="quizExampprBlukExcelDown()"><spring:message code="quiz.button.bulk.examppr.excel.down" /><!-- 시험지 일괄 엑셀로 다운로드 --></button>
	                                <button type="button" class="btn basic" onclick="quizTkexamStatusExcelDown()"><spring:message code="quiz.button.excel.down" /><!-- 엑셀로 다운로드 --></button>
	                                <button type="button" class="btn type2" onclick="quizChartPop()"><spring:message code="quiz.button.attendance.status.graph" /><!-- 응시현황 그래프 --></button>
	                            </div>
	                        </div>

							<div id="list"></div>

							<script>
								let userListTable = UiTable("list", {
									lang: "ko",
									selectRow: "checkbox",
									columns: [
										{title:"No", 																					field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										("${vo.examGbncd}" == "QUIZ_TEAM" ? {title: "<spring:message code='common.team.name' />", 		field: "teamnm", 			headerHozAlign:"center", hozAlign:"center", width: 0, 	minWidth: 80} : null),/* 팀명 */
										{title:"<spring:message code='common.dept_name' />", 											field:"deptnm",				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},/* 학과 */
										{title:"<spring:message code='common.label.student.number' />", 								field:"stdntNo", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},/* 학번 */
										{title:"<spring:message code='common.name' />", 												field:"usernm", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},/* 이름 */
										("${vo.examGbncd}" == "QUIZ_TEAM" ? {title: "<spring:message code='common.label.user.role' />", field: "ldryn", 			headerHozAlign:"center", hozAlign:"center", width: 0, 	minWidth: 80} : null),/* 역할 */
										{title:"<spring:message code='quiz.label.quiz.scr' />", 										field:"quizScr", 			headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},/* 퀴즈점수 */
										{title:"<spring:message code='quiz.label.evl.scr' />", 											field:"totScr", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 평가점수 */
										{title:"<spring:message code='quiz.label.tkexam.status' />", 									field:"tkexamCmptnGbnnm", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 응시상태 */
										{title:"<spring:message code='quiz.label.tkexam.cnt' />", 										field:"tkexamCnt", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 응시횟수 */
										{title:"<spring:message code='quiz.label.evlyn' />", 											field:"evlyn", 				headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},/* 평가여부 */
										{title:"<spring:message code='common.mgr' />", 													field:"mng", 				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:300},/* 관리 */
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