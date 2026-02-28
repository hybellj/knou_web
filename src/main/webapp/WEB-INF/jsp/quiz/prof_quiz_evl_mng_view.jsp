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
		var dialog;

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

			$(".accordion").accordion();
			const title = document.querySelector('.accordion .title');

			document.querySelector('.accordion .title').addEventListener('click', () => {
			  	const content = title.nextElementSibling;
			  	content.classList.toggle('hide');
			});

			$("#scoreBatch").trigger("click");
		});

		/**
		 * 퀴즈 화면 이동
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function quizViewMv(tab) {
			var urlMap = {
				"1" : "/quiz/profQuizQstnMngView.do",		// 퀴즈 문항 관리 화면
				"2" : "/quiz/profQuizRetkexamMngView.do",	// 퀴즈 재응시 관리 페이지
				"3" : "/quiz/profQuizEvlMngView.do",		// 퀴즈 평가 관리 페이지
				"4" : "/quiz/profQuizModifyView.do",		// 퀴즈 수정 화면
				"9" : "/quiz/profQuizListView.do"			// 퀴즈 목록 화면
			};

			var kvArr = [];
			kvArr.push({'key' : 'examBscId',   	'val' : "${vo.examBscId}"});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(urlMap[tab], "", "", kvArr);
		}

		/**
		* 퀴즈응시목록조회
		* @param {String}  examBscId 		- 시험기본아이디
		* @param {String}  tkexamCmptnyn 	- 응시여부
		* @param {String}  evlyn 			- 평가여부
		* @param {String}  searchValue 	- 검색어(학과, 학번, 이름)
		* @returns {list} 퀴즈응시목록
		*/
		function quizTkexamListSelect() {
			UiComm.showLoading(true);
			var url  = "/quiz/profQuizTkexamListAjax.do";
			var data = {
				"examBscId" 	: "${vo.examBscId}",
				"tkexamCmptnyn" : $("#tkexamCmptnyn").val(),
				"evlyn"    		: $("#evlyn").val(),
				"searchValue" 	: $("#searchValue").val()
			};

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		   		UiComm.showLoading(false);
		    	if (data.result > 0) {
		    		var returnList = data.returnList || [];
		       		var dataList = createUserListHTML(returnList);	// 수강생 리스트 HTML 생성

		       		userListTable.clearData();
		       		userListTable.replaceData(dataList);
		        } else {
		       		UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
			   	UiComm.showLoading(false);
			   	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		    });
		}

		// 수강생 리스트 HTML 생성
		function createUserListHTML(userList) {
			let dataList = [];

			if(userList.length == 0) {
				return dataList;
			} else {
				userList.forEach(function(v,i) {
					var tkexamCmptnyn = "";
					var quizScr = v.quizScr;
					var totScr = v.totScr;
					if(v.tkexamSdttm == null) {
						tkexamCmptnyn = v.retkexamYn == "Y" ? "초기화" : "미응시";
						quizScr = "-";
						totScr = v.evlyn == "Y" ? v.totScr : "-";
					} else if(v.tkexamCmptnyn == "Y") {
						tkexamCmptnyn = "응시완료";
					} else {
						tkexamCmptnyn = "응시중";
					}
					var ldryn = v.ldryn == "Y" ? "팀장" : "팀원";
					var mng = "<a href='javascript:quizExampprInit(\"" + v.tkexamId + "\", \"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'>퀴즈초기화</a>";
					if(v.tkexamSdttm != null) {
						mng += "<a href='javascript:quizExampprEvlPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'>시험지보기</a>";
					}
					mng += "<a href='javascript:quizTkexamHstryPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'>응시기록</a>";
					mng += "<a href='javascript:memoPopup(\"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'>메모</a>";

					dataList.push({
						no: 			v.lineNo,
						deptnm: 		v.deptnm,
						userRprsId: 	v.userRprsId,
						stdntNo: 		v.stdntNo,
						usernm: 		v.usernm,
						quizScr: 		quizScr,
						totScr: 		totScr,
						tkexamCmptnyn: 	tkexamCmptnyn,
						tkexamCnt: 		v.tkexamCnt + "회",
						evlyn: 			v.evlyn,
						mng: 			mng,
						ldryn:			ldryn,
						teamnm:			v.teamnm,
						userId:			v.userId,
						examDtlId:		v.examDtlId,
						tkexamId:		v.tkexamId
					});
				});
			}

			return dataList;
		}

		/**
		 * 퀴즈시험지평가팝업
		 * @param {String}  examBscId 		- 시험기본아이디
		 * @param {String}  examDtlId 		- 시험상세아이디
		 * @param {String}  userId 			- 사용자아이디
		 * @param {String}  evlyn 			- 평가여부
		 * @param {String}  evlyn 			- 시험응시완료여부
		 * @param {String}  searchValue 	- 검색어(학과, 학번, 이름)
		 */
		function quizExampprEvlPopup(examDtlId, userId) {
			var data = "examBscId=${vo.examBscId}&examDtlId="+examDtlId+"&userId="+userId+"&evlyn="+$("#evlyn").val()+"&tkexamCmptnyn=Y&searchValue="+$("#searchValue").val();

			dialog = UiDialog("dialog1", {
				title: "시험지 및 평가",
				width: 600,
				height: 500,
				url: "/quiz/profQuizExampprEvlPopup.do?"+data,
				autoresize: true
			});
		}

		/**
		 * 퀴즈응시이력팝업
		 * @param {String}  examDtlId 	- 시험상세아이디
		 * @param {String}  userId 		- 사용자아이디
		 */
		function quizTkexamHstryPopup(examDtlId, userId) {
			var data = "examDtlId="+examDtlId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title: "응시기록 보기",
				width: 600,
				height: 500,
				url: "/quiz/profQuizTkexamHstryPopup.do?"+data,
				autoresize: true
			});
		}

		/**
		* 퀴즈시험지초기화
		* @param {String}  tkexamId 	- 시험응시아이디
		* @param {String}  examBscId 	- 시험기본아이디
		* @param {String}  examDtlId 	- 시험상세아이디
		* @param {String}  userId 		- 사용자아이디
		*/
		function quizExampprInit(tkexamId, examDtlId, userId) {
			if("${vo.examQstnsCmptnyn}" == "Y") {
				UiComm.showMessage("퀴즈 초기화를 하시겠습니까?", "confirm")
				.then(function(result) {
					if (result) {
						UiComm.showLoading(true);
						var url  = "/quiz/profQuizExampprInitAjax.do";
						var data = {
							"tkexamId"  : tkexamId,
							"examBscId" : "${vo.examBscId}",
							"examDtlId" : examDtlId,
							"userId" 	: userId
						};

						$.ajax({
					        url 	  : url,
					        async	  : false,
					        type 	  : "POST",
					        dataType : "json",
					        data 	  : JSON.stringify(data),
					        contentType: "application/json; charset=UTF-8",
					    }).done(function(data) {
					   		UiComm.showLoading(false);
					    	if (data.result > 0) {
					    		UiComm.showMessage("퀴즈 초기화가 완료되었습니다.", "success");
					    		quizTkexamListSelect();
					        } else {
					       		UiComm.showMessage(data.message, "error");
					        }
					    }).fail(function() {
						   	UiComm.showLoading(false);
						   	UiComm.showMessage("초기화 중 에러가 발생하였습니다.", "error");
					    });
					}
				});
			} else {
				UiComm.showMessage("문제 출제 완료 후 가능합니다.", "info");
			}
		}

		// 점수 가감 아이콘 표시 확인
		function plusMinusIconControl(scoreType){
			if(scoreType == 'batch'){
				$("#scr-toggle-icon").hide();
			}else if(scoreType == 'addition'){
				$("#scr-toggle-icon").show();
			}
		}

		/**
		* 평가점수일괄수정
		* @param {String}  tkexamId 	- 시험응시아이디
		* @param {String}  examBscId 	- 시험기본아이디
		* @param {String}  examDtlId 	- 시험상세아이디
		* @param {String}  userId 		- 사용자아이디
		*/
		function EvlScrBulkModify() {
			let validator = UiValidator("scoreForm");
			validator.then(function(result) {
				if (result) {
					if(userListTable.getSelectedData("userId").length == 0) {
						UiComm.showMessage("일괄 성적처리할 학습자를 선택해주세요.", "info");
						return;
					}

					var score = $("#scoreValue").val();
					if($("input[name='scoreType']:checked").val() == "addition"){
						if(!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")){
							score = score * (-1);
						}
					}

					var scrList = [];	// 점수 목록

					for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
						var scr = {
							examDtlId 		: userListTable.getSelectedData("examDtlId")[i],	// 시험상세아이디
							tkexamId 		: userListTable.getSelectedData("tkexamId")[i],		// 시험응시아이디
							userId			: userListTable.getSelectedData("userId")[i],		// 사용자아이디
							scr				: score,											// 점수
							scoreType		: $("input[name='scoreType']:checked").val()		// 점수유형
						};
						scrList.push(scr);
					}

					$.ajax({
		                url: "/quiz/profQuizEvlScrBulkModifyAjax.do",
		                type: "POST",
		                contentType: "application/json",
		                data: JSON.stringify(scrList),
		                dataType: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#scoreValue").val("");
				        		quizTkexamListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                    UiComm.showLoading(false);
		                },
		                error: function (xhr, status, error) {
		                	UiComm.showMessage("<spring:message code='exam.error.batch.score' />", "error");/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		                },
		                complete: function () {
		                	UiComm.showLoading(false);
		                },
		            });
				}
			});
		}

		/**
		 * 메모팝업
		 * @param {String}  tkexamId 	- 시험응시아이디
		 * @param {String}  userId 		- 사용자아이디
		 */
		function memoPopup(tkexamId, userId) {
			var data = "examBscId=${vo.examBscId}&tkexamId="+tkexamId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title: "메모",
				width: 600,
				height: 500,
				url: "/quiz/profQuizMemoPopup.do?"+data,
				autoresize: true
			});
		}

		// 엑셀 성적 등록
		function callScoreExcelUpload() {
			var data = "examBscId=${vo.examBscId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title: "엑셀 성적등록",
				width: 600,
				height: 500,
				url: "/quiz/quizScoreExcelUploadPop.do?"+data,
				autoresize: true
			});
		}

		// 엑셀 다운로드
		function quizStatusExcelDown() {
			var univGbn = "${creCrsVO.univGbn}";
			var hstyTypeCdObj = {
				  SET: "<spring:message code='exam.label.no.stare' />" // 미응시
				, REEXAM: "<spring:message code='exam.label.reexam.no.stare' />" // 재응시미완료
				, START: "<spring:message code='exam.label.complete.stare' />" // 응시완료
				, RESTORE: "<spring:message code='exam.label.complete.stare' />" // 응시완료
				, COMPLETE: "<spring:message code='exam.label.complete.stare' />" // 응시완료
			};

			var excelGrid = { colModel: [] };

			excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'}); // No.
			excelGrid.colModel.push({label: "<spring:message code='exam.label.dept' />", name: 'deptNm', align: 'left', width: '5000'}); // 학과
			excelGrid.colModel.push({label: "<spring:message code='exam.label.user.no' />", name: 'userId', align: 'left', width: '5000'}); // 학번
			excelGrid.colModel.push({label: "<spring:message code='exam.label.user.grade' />", name: 'hy', align: 'center', width: '1000'}); // 학년
			if(univGbn == "3" || univGbn == "4") {
				excelGrid.colModel.push({label: '<spring:message code="common.label.grsc.degr.cors.gbn" />', name: 'grscDegrCorsGbnNm', align: 'left', width: '4000'}); // 학위과정
			}
			excelGrid.colModel.push({label: "<spring:message code='exam.label.user.nm' />", name: 'userNm', align: 'right', width: '5000'}); // 이름
			excelGrid.colModel.push({label: "<spring:message code='exam.label.admission.year' />", name: 'entrYy', align: 'left', width: '5000'}); // 입학년도
			excelGrid.colModel.push({label: "<spring:message code='exam.label.admission.grade' />", name: 'entrHy', align: 'left', width: '5000'}); // 입학학년
			excelGrid.colModel.push({label: "<spring:message code='exam.label.admission.type' />", name: 'entrGbnNm', align: 'left', width: '5000'}); // 입학구분
			excelGrid.colModel.push({label: "<spring:message code='exam.label.eval.score' />", name: 'stareScore', align: 'right', width: '5000'}); // 평가점수
			excelGrid.colModel.push({label: "<spring:message code='exam.label.situation' />", name: 'hstyTypeCd', align: 'right', width: '5000', codes: hstyTypeCdObj}); // 상황
			excelGrid.colModel.push({label: "<spring:message code='exam.label.stare.count' />", name: 'stareCnt', align: 'right', width: '5000'}); // 응시횟수


			var kvArr = [];
			kvArr.push({'key' : 'examCd', 	   'val' : "${vo.examBscId}"});
			kvArr.push({'key' : 'stdNos', 	   'val' : $("#stdNos").val()});
			kvArr.push({'key' : 'searchValue', 'val' : $("#searchValue").val()});
			kvArr.push({'key' : 'excelGrid',   'val' : JSON.stringify(excelGrid)});

			submitForm("/quiz/quizStatusExcelDown.do", "", "", kvArr);
		}

		// 시험지 일괄 엑셀 다운로드
		function allQuizPaperExcelDown() {
			var kvArr = [];
			kvArr.push({'key' : 'examCd', 'val' : "${vo.examBscId}"});

			submitForm("/quiz/allQuizPaperExcelDown.do", "", "", kvArr);
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

		/**
		 * 퀴즈 삭제
		 * @param {String}  examBscId 		- 시험기본아이디
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  delyn 			- 삭제여부
		 */
		function quizDelete() {
			var confirm = "";
			if("${vo.tkexamStrtUserCnt}" > 0) {
				confirm = "<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.y' />";/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.정말 삭제하시겠습니까? */
			} else {
				confirm = "<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />";/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					var url  = "/quiz/quizDeleteAjax.do";
					var data = {
						  examBscId 	: "${vo.examBscId}"
						, "sbjctId"		: "${vo.sbjctId}"
						, "delyn"		: "Y"
					};

					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
			        		alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
			        		quizViewMv(9);
			            } else {
			             	alert(data.message);
			            }
		    		}, function(xhr, status, error) {
		    			alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		/**
		 * 퀴즈응시현황팝업
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function quizChartPop() {
			var data = "examBscId=${vo.examBscId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title: "응시현황",
				width: 600,
				height: 500,
				url: "/quiz/profQuizTkexamStatusPopup.do?"+data,
				autoresize: true
			});
		}

		// 팝업 점수 저장
		function qstnScoreEdit() {
			quizTkexamListSelect();
		}
	</script>
</head>

<body class="class colorA">
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
            	<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<div class="class_sub">
					<div class="sub-content">
						<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:quizViewMv(4)" class="btn type2"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
								<a href="javascript:quizDelete()" class="btn type2"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
								<a href="javascript:quizViewMv(9)" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li class="mw120 select"><a onclick="quizViewMv(3)">퀴즈정보 및 평가</a></li>
					            <li class="mw120"><a onclick="quizViewMv(1)">문항관리</a></li>
					            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
						            <li class="mw120"><a onclick="quizViewMv(2)">재응시 관리</a></li>
					            </c:if>
					        </ul>
					    </div>

					    <div class="accordion">
							<div class="title flex">
								<div class="title_cont">
									<div class="left_cont">
										<div class="lectTit_box">
											<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
											<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
											<fmt:parseDate var="psblSdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.examPsblSdttm }" />
											<fmt:formatDate var="examPsblSdttm" pattern="yyyy.MM.dd HH:mm" value="${psblSdttmFmt }" />
											<fmt:parseDate var="psblEdttmFmt" pattern="yyyyMMddHHmmss" value="${vo.examDtlVO.examPsblEdttm }" />
											<fmt:formatDate var="examPsblEdttm" pattern="yyyy.MM.dd HH:mm" value="${psblEdttmFmt }" />
											<p class="lect_name">${fn:escapeXml(vo.examTtl) }</p>
											<span class="fcGrey">
												<small>응시기간 : ${examPsblSdttm } ~ ${examPsblEdttm }</small> |
												<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.mrkRfltyn eq 'Y' ? yes : no }</small> |
												<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.mrkOyn eq 'Y' ? yes : no }</small>
											</span>
										</div>
									</div>
								</div>
								<i class="dropdown icon ml20"></i>
							</div>
							<div class="content" style="padding:0;">
								<!--table-type-->
				        		<div class="table-wrap">
				        			<table class="table-type2">
				        				<colgroup>
				        					<col class="width-20per" />
				        					<col class="" />
				        				</colgroup>
				        				<tbody>
				        					<tr>
				        						<th><label>퀴즈내용</label></th>
				        						<td class="t_left" colspan="3"><pre>${vo.examCts }</pre></td>
				        					</tr>
				        					<tr>
				        						<th><label>응시기간</label></th>
				        						<td class="t_left" colspan="3">${examPsblSdttm } ~ ${examPsblEdttm }</td>
				        					</tr>
				        					<tr>
				        						<th><label>퀴즈시간</label></th>
				        						<td class="t_left" colspan="3">${vo.examDtlVO.examMnts }분</td>
				        					</tr>
				        					<tr>
				        						<th><label>성적반영</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
				        						<th><label>성적 반영비율</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? vo.examGbncd eq 'QUIZ_EXAM_MID' or vo.examGbncd eq 'QUIZ_EXAM_LST' ? '100' : vo.mrkRfltrt : '0' }%</td>
				        					</tr>
				        					<tr>
				        						<th><label>성적공개</label></th>
				        						<td class="t_left" colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>문제표시방식</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.qstnDsplyGbncd eq 'ALL' }">
															<spring:message code="exam.label.all.view.qstn" /><!-- 전체문제 표시 -->
														</c:when>
														<c:otherwise>
															<spring:message code="exam.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
														</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>문제 섞기</label></th>
				        						<td class="t_left" colspan="3">${vo.qstnRndmyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>보기 섞기</label></th>
				        						<td class="t_left" colspan="3">${vo.qstnVwitmRndmyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>첨부파일</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:forEach var="list" items="${vo.fileList }">
														<button class="ui icon small button" id="file_${list.fileSn }" title="<spring:message code="asmnt.label.attachFile.download" />" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
														<script>
															byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
														</script>
													</c:forEach>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>팀 퀴즈</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.examGbncd eq 'QUIZ_TEAM' }">

															<p>학습그룹 : ${vo.lrnGrpnm }</p>
															<p>학습그룹별 부 과제 설정 : ${vo.lrnGrpSubasmtStngyn eq 'Y' ? '사용' : '미사용' }</p>
															<c:if test="${vo.lrnGrpSubasmtStngyn eq 'Y' }">
																<table class="table-type2">
											        				<colgroup>
											        					<col class="width-10per" />
											        					<col class="" />
											        					<col class="width-20per" />
											        				</colgroup>
											        				<tbody id="quizSubAsmtTbody">
											        					<tr>
											        						<th><label>팀</label></th>
											        						<th><label>부주제</label></th>
											        						<th><label>학습그룹 구성원</label></th>
											        					</tr>
											        				</tbody>
											        			</table>
															</c:if>
														</c:when>
														<c:otherwise>${no }</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        				</tbody>
				        			</table>
				        		</div>
							</div>
						</div>

						<div class="board_top margin-top-4 padding-2 bcLgrey4">
							<h4>퀴즈평가</h4>
							<div class="right-area">
								<a href="javascript:callScoreExcelUpload()" class="btn basic small"><spring:message code="exam.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
								<a href="javascript:sendMsg()" class="btn basic small">보내기</a>
							</div>
						</div>
						<div class="search-typeA margin-bottom-4">
                            <div class="text-center">
                                <select class="form-select" id="tkexamCmptnyn" onchange="quizTkexamListSelect()">
                                    <option value="">응시여부</option>
									<option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
									<option value="N">미응시</option>
									<option value="Y">응시완료</option>
                                </select>
                                <select class="form-select" id="evlyn" onchange="quizTkexamListSelect()">
                                    <option value="">평가여부</option>
									<option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
									<option value="Y">평가</option>
									<option value="N">미평가</option>
                                </select>
                                <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
	                            <button type="button" class="btn type1" onclick="quizTkexamListSelect()">검색</button>
	                            <button type="button" class="btn type1" onclick="resetListSelect()">수강생 전체</button>
                            </div>
                        </div>
                        <table class="table-type1 fs-14px">
                        	<colgroup>
                        		<col class="width-20per" />
                        		<col class="" />
                        	</colgroup>
                        	<tbody>
                        		<tr>
                        			<th>일괄 성적처리</th>
                        			<td>
                        				<form id="scoreForm" onsubmit="return false;">
	                        				<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true" />
													<label for="scoreBatch">점수 등록</label>
												</span>
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true" />
													<label for="scoreAddition">점수 가감</label>
												</span>
												점수
												<button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
												<input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
												점
												<a href="javascript:EvlScrBulkModify()" class="btn type7">저장</a>
	                        				</div>
                        				</form>
                        			</td>
                        		</tr>
                        	</tbody>
                        </table>
                        <div class="board_top margin-top-4">
							<div class="right-area">
								<a href="javascript:void(0)" class="btn type1">시험지 일괄 인쇄</a>
								<a href="javascript:allQuizPaperExcelDown()" class="btn type1">시험지 일괄 엑셀 다운로드</a>
								<a href="javascript:quizStatusExcelDown()" class="btn type1">엑셀 다운로드</a>
								<a href="javascript:quizChartPop()" class="btn type1">응시현황 그래프</a>
							</div>
						</div>

						<div id="list"></div>

						<script>
							let userListTable = UiTable("list", {
								lang: "ko",
								selectRow: "checkbox",
								columns: [
									{title:"No", 		field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
									("${vo.examGbncd}" == "QUIZ_TEAM" ? {title: "팀명", field: "teamnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
									{title:"학과", 		field:"deptnm",			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
									{title:"대표아이디", 	field:"userRprsId", 	headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:100},
									{title:"학번", 		field:"stdntNo", 		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
									{title:"이름", 		field:"usernm", 		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
									("${vo.examGbncd}" == "QUIZ_TEAM" ? {title: "역할", field: "ldryn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
									{title:"퀴즈점수", 	field:"quizScr", 		headerHozAlign:"center", hozAlign:"center", width:80,	minWidth:80},
									{title:"평가점수", 	field:"totScr", 		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"응시상태", 	field:"tkexamCmptnyn", 	headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"응시횟수", 	field:"tkexamCnt", 		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"평가여부", 	field:"evlyn", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"관리", 		field:"mng", 			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},
								].filter(function(col) {return col !== null;})
							});
						</script>
					</div>
				</div>
			</div>
			<!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>