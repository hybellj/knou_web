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

			// 학습그룹부과제설정시 퀴즈 부 과제 목록 조회
			if("${vo.lrnGrpSubasmtStngyn}" == "Y") {
				quizSubAsmtListSelect();
			}

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					quizTkexamListSelect();
				}
			});

			$(".accordion").accordion();
			const title = document.querySelector('.accordion .title');

			document.querySelector('.accordion .title').addEventListener('click', () => {
			  	const content = title.nextElementSibling;
			  	content.classList.toggle('hide');
			});
		});

		/**
		 * 퀴즈 화면 이동
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function quizViewMv(tab) {
			var urlMap = {
				"1" : "/quiz/profQuizQstnMngView.do",		// 퀴즈 문항 관리 화면
				"2" : "/quiz/profQuizRetkexamMngView.do",	// 퀴즈 재응시 관리 화면
				"3" : "/quiz/profQuizEvlMngView.do",		// 퀴즈 평가 관리 화면
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
					var mng = "";
					if(v.tkexamSdttm != null) {
						mng += "<a href='javascript:quizExampprEvlPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'>시험지보기</a>";
					}
					mng += "<a href='javascript:quizTkexamHstryPopup(\"" + v.examDtlId + "\", \"" + v.userId + "\")' class='btn basic small'>응시기록</a>";
					mng += "<a href='javascript:memoPopup(\"" + v.examDtlId + "\", \"" + v.tkexamId + "\", \"" + v.userId + "\")' class='btn basic small'>메모</a>";

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
						examDtlId:		v.examDtlId
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
		 * @param {String}  tkexamCmptnyn 	- 시험응시완료여부
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
				width: 800,
				height: 300,
				url: "/quiz/profQuizTkexamHstryPopup.do?"+data,
				autoresize: true
			});
		}

		 /**
		 * 메모팝업
		 * @param {String}  examDtlId 	- 시험상세아이디
		 * @param {String}  tkexamId 	- 시험응시아이디
		 * @param {String}  userId 		- 사용자아이디
		 */
		function memoPopup(examDtlId, tkexamId, userId) {
			var data = "examBscId=${vo.examBscId}&examDtlId="+examDtlId+"&tkexamId="+tkexamId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title: "메모",
				width: 600,
				height: 350,
				url: "/quiz/profQuizMemoPopup.do?"+data
			});
		}

		// 퀴즈 재응시 설정
		function quizRetkexamSetting() {
			if("${vo.examQstnsCmptnyn}" == "Y") {
				let validator = UiValidator("retkexamForm");
				validator.then(function(result) {
					if (result) {
						if(userListTable.getSelectedData("userId").length == 0) {
							UiComm.showMessage("재응시 설정할 학습자를 선택해주세요.", "info");
							return;
						}

						var retkexamList = [];	// 재응시 설정 목록

						for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
							var retkexam = {
								examBscId		: "${vo.examBscId}",									// 시험기본아이디
								examDtlId 		: userListTable.getSelectedData("examDtlId")[i],		// 시험상세아이디
								userId			: userListTable.getSelectedData("userId")[i],			// 사용자아이디
								reexamyn		: "Y",													// 재시험여부
								reexamPsblSdttm	: UiComm.getDateTimeVal("redateSt", "retimeSt")+"00",	// 재시험가능시작일시
								reexamPsblEdttm	: UiComm.getDateTimeVal("redateEd", "retimeEd")+"59",	// 재시험가능종료일시
								reexamMrkRfltrt	: $("#reexamMrkRfltrt").val()							// 재시험성적반영비율
							};
							retkexamList.push(retkexam);
						}

						$.ajax({
			                url: "/quiz/quizRetkexamSettingAjax.do",
			                type: "POST",
			                contentType: "application/json",
			                data: JSON.stringify(retkexamList),
			                dataType: "json",
			                beforeSend: function () {
			                	UiComm.showLoading(true);
			                },
			                success: function (data) {
			                    if (data.result > 0) {
			                    	UiComm.showMessage("<spring:message code='exam.alert.reexam' />", "success");/* 재응시 설정이 완료되었습니다. */
					        		quizTkexamListSelect();
			                    } else {
			                    	UiComm.showMessage(data.message, "error");
			                    }
			                    UiComm.showLoading(false);
			                },
			                error: function (xhr, status, error) {
			                	UiComm.showMessage("<spring:message code='exam.error.reexam' />", "error");/* 재응시 설정 중 에러가 발생하였습니다. */
			                },
			                complete: function () {
			                	UiComm.showLoading(false);
			                },
			            });
					}
				});
			} else {
				UiComm.showMessage("문제 출제 완료 후 가능합니다.", "info");
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

		// 팝업 점수 저장
		function qstnScoreEdit() {
			quizTkexamListSelect();
		}

		// 수강생 전체 버튼
		function resetListSelect() {
			$("#tkexamCmptnyn").val('').trigger('chosen:updated');
			$("#evlyn").val('').trigger("chosen:updated");
			$("#searchValue").val("");
			quizTkexamListSelect();
		}

		/**
		 * 퀴즈 부 과제 목록 조회
		 * @param {String}  lrnGrpId 	- 학습그룹아이디
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @returns {list} 부 과제 목록
		 */
		function quizSubAsmtListSelect() {
			var url  = "/quiz/quizLrnGrpSubAsmtListAjax.do";
			var data = {
				lrnGrpId  : "${vo.lrnGrpId}",
				examBscId : "${vo.examBscId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
							html += "<tr>";
							html += "	<th>" + v.teamnm + "</th>";
							html += "	<td>";
							html += "		<table class='table-type2'>";
							html += "			<colgroup>";
							html += "				<col class='width-10per' />";
							html += "				<col class='' />";
							html += "			</colgroup>";
							html += "			<tbody>";
							html += "				<tr>";
							html += "					<th>주제</th>";
							html += "					<td class='t_left'>" + v.examTtl + "</td>";
							html += "				</tr>";
							html += "				<tr>";
							html += "					<th>내용</th>";
							html += "					<td class='t_left'><pre>" + v.examCts + "</pre></td>";
							html += "				</tr>";
							html += "				<tr>";
							html += "					<th>첨부파일</th>";
							html += "					<td class='t_left'>";
							//html += "						<button class='ui icon small button' id='file_fileSn' title='파일다운로드' onclick='fileDown(\"" + ${list.fileSn } + "\", \"" + ${list.repoCd } + "\")'><i class='ion-android-download'></i></button>";
							html += "					</td>";
							html += "				</tr>";
							html += "			</tbody>";
							html += "		</table>";
							html += "	</td>";
							html += "	<td>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</td>";
							html += "</tr>";
	        			});
	        		}
					/* byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}"); */

	        		$("#quizSubAsmtTbody").append(html);
				}
			}, true);
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
					        	<a href="javascript:quizRetkexamSetting()" class="btn type2"><spring:message code="exam.button.reexam" /></a><!-- 재응시 설정 -->
								<a href="javascript:quizViewMv(9)" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

						<div class="listTab">
					        <ul>
					            <li class="mw120"><a onclick="quizViewMv(3)">퀴즈정보 및 평가</a></li>
					            <li class="mw120"><a onclick="quizViewMv(1)">문항관리</a></li>
					            <c:if test="${vo.examDtlVO.reexamyn eq 'Y'}">
						            <li class="select mw120"><a onclick="quizViewMv(2)">재응시 관리</a></li>
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
				        							<c:if test="${not empty vo.fileList}">
														<div class="add_file_list">
															<uiex:filedownload fileList="${vo.fileList}"/>
														</div>
													</c:if>
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

						<form id="retkexamForm">
							<table class="table-type5 margin-top-5">
								<colgroup>
									<col class="width-20per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr class="bcLgrey9">
										<td colspan="2">옵션</td>
									</tr>
									<tr>
										<th><label>재응시 사용</label></th>
										<td>
											<%-- <div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="reexamyn" id="reexamynY" value="Y" required="true" ${vo.examDtlVO.reexamyn eq 'Y' ? 'checked' : ''}>
													<label for="reexamynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="reexamyn" id="reexamynN" value="N" required="true" ${empty vo.examBscId || vo.examDtlVO.reexamyn eq 'N' ? 'checked' : ''}>
													<label for="reexamynN">아니오</label>
												</span>
											</div> --%>
											<div id="reexamDiv" style="<c:if test="${empty vo.examBscId || vo.examDtlVO.reexamyn ne 'Y'}">display: none;</c:if>">
												<table class="table-type5">
										        	<colgroup>
										        		<col class="width-20per" />
										        		<col class="" />
										        	</colgroup>
										        	<tbody>
										        		<tr>
										        			<th><label>재응시 기간</label></th>
										        			<td>
										        				<input id="redateSt" type="text" name="redateSt" class="datepicker" timeId="retimeSt" toDate="redateEd" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,0,8)}">
																<input id="retimeSt" type="text" name="retimeSt" class="timepicker" dateId="redateSt" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,8,12)}">
																<span class="txt-sort">~</span>
																<input id="redateEd" type="text" name="redateEd" class="datepicker" timeId="retimeEd" fromDate="redateSt" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,0,8)}">
																<input id="retimeEd" type="text" name="retimeEd" class="timepicker" dateId="redateEd" required="true" value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,8,12)}">
										        			</td>
										        		</tr>
										        		<tr>
										        			<th><label>재응시 적용률</label></th>
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
									        </div>
										</td>
									</tr>
								</tbody>
							</table>
						</form>

						<div class="board_top margin-top-4 padding-2 bcLgrey4">
							<h4>수강생</h4>
							<div class="right-area">
								<a href="javascript:sendMsg()" class="btn basic small">보내기</a>
							</div>
						</div>
						<div class="search-typeA">
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