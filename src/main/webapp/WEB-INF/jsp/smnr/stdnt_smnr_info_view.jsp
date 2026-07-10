<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/smnr/common/smnr_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function () {
			if("${vo.byteamSubsmnrUseyn}" == "Y") {
				// 팀그룹부세미나목록조회
				teamGrpSubSmnrListSelect("${vo.teamGrpId}", "${vo.upSmnrId}");
			}

			if("${vo.smnrGbncd}" == "ONLN_SMNR") {
				smnrAtndHstryListSelect();
			}
		});

		// 참여이력목록조회
		function smnrAtndHstryListSelect() {
			const url  = "/smnr/smnrAtndHstryListAjax.do";
			const data = {
				smnrId : "${vo.smnrId}"
			};

			ajaxCall(url, data, function (data) {
	            if (data.result > 0) {
	            	let dataList = createAtndHstryListHTML(data.returnList);	// 참여이력 리스트 HTML 생성

	            	hstryListTable.clearData();
	        		hstryListTable.replaceData(dataList);
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        }, true);
		}

		// 참여이력 리스트 HTML 생성
		function createAtndHstryListHTML(hstryList) {
			let dataList = [];

			if(hstryList.length == 0) {
				return dataList;
			} else {
				hstryList.forEach(function(v,i) {
					let atndScnds = "";
					let hours = Math.floor(v.atndScnds / 3600);
                    let minutes = Math.floor((v.atndScnds % 3600) / 60);
                    let seconds = v.atndScnds % 60;
                    atndScnds = hours > 0 ? hours + "시간 " : "";
                    atndScnds += minutes > 0 ? minutes + "분 " : "";
                    atndScnds += seconds + "초";
					dataList.push({
						no: 			v.lineNo,
						atndSdttm:		UiComm.formatDate(v.atndSdttm, "datetime"),
						atndEdttm: 		UiComm.formatDate(v.atndEdttm, "datetime"),
						atndScnds: 		atndScnds
					});
				});

			}

			return dataList;
		}

		// 팀구성원팝업
		function teamMbrPopup() {
			const data = "teamCd=${vo.teamId}";

			dialog = UiDialog("dialog1", {
				title		: "팀 구성원",
				width		: 400,
				height		: 500,
				url			: "/quiz/quizTeamMbrPopup.do?"+data
			});
		}

		// 피드백 팝업
        function fdbkPopup() {
            const data = "smnrId=${vo.smnrId}&userId=${vo.userId}";
            dialog = UiDialog("dialog1", {
                title		: "피드백",
                width		: 1000,
                height		: 350,
                url			: "/smnr/smnrFdbkPopup.do?" + data,
                autoresize	: true
            });
        }

     	// ZOOM 참여자 시작
		function zoomUserStart() {
			const url  = "/zoom/zoomUserUrlSelectAjax.do";
			const data = {
	   			smnrId : "${vo.smnrId}"
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					let windowOpener = window.open();
					windowOpener.location = data.data.trgtrCntnUrl;
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
			}, true);
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
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
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
                                세미나
                            </h2>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li class="select"><a onclick="smnrViewMv('${vo.smnrId}', 'VIEW', '${vo.upSmnrId }')">세미나정보 및 평가</a></li>
					        </ul>
					    </div>

					    <div class="board_top">
				        	<h3 class="board-title">세미나정보 및 평가</h3>
					        <div class="right-area">
					        	<c:if test="${vo.smnrGbn eq 'SMNR_TEAM' }">
						        	<a href="javascript:teamMbrPopup()" class="btn type2 big">팀 구성원</a>
					        	</c:if>
								<a href="javascript:smnrViewMv('${vo.smnrId}', 'STDLIST')" class="btn type2 big"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

				        <!--accordion-->
	                    <div class="elements_wrap">
	                        <ul class="accordion">
	                        	<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
								<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
	                            <li class=""><!-- 클릭시 active 추가 -->
	                                <div class="title-wrap">
	                                    <a class="title" href="#">
	                                        <div class="lecture_tit">
	                                            <strong>${fn:escapeXml(vo.smnrnm) }</strong>
	                                            <p class="desc">
	                                                <span>세미나일시 :<strong><uiex:formatDate type="datetime" value="${vo.smnrSdttm }"/></strong></span>
	                                                <span>
	                                                	<strong>
															<c:set var="mntsHour" value="${vo.smnrMnts / 60 }"/>
															<c:set var="mntsMin"><fmt:formatNumber value="${vo.smnrMnts % 60}" type="number" pattern="#"/></c:set>
															<c:if test="${vo.smnrMnts >= 60 }">${mntsHour }시간 </c:if>
															${mntsMin }분
	                                                	</strong>
	                                                </span>
	                                                <span><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> :<strong>${vo.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
	                                            </p>
	                                        </div>
	                                        <i class="arrow xi-angle-down"></i>
	                                    </a>
	                                </div>
	                                <div class="cont">
	                                	<table class="table-type5">
	                                		<colgroup>
	                                			<col class="width-15per" />
	                                			<col class="" />
	                                			<col class="width-15per" />
	                                			<col class="" />
	                                		</colgroup>
	                                		<tbody>
	                                			<tr>
			                                        <th>세미나방식</th>
			                                        <td colspan="3">
			                                            <c:forEach var="code" items="${smnrGbncdList }">
			                                                <c:if test="${code.cd eq vo.smnrGbncd }">${code.cdnm }</c:if>
			                                            </c:forEach>
			                                        </td>
			                                    </tr>
	                                			<tr>
		                                			<th>세미나내용</th>
		                                			<td colspan="3">
		                                				<div class="tb_content">
		                                                    ${vo.smnrCts }
		                                                </div>
		                                			</td>
	                                			</tr>
	                                			<tr>
	                                				<th>세미나일시</th>
	                                				<td colspan="3">
	                                					<uiex:formatDate type="datetime" value="${vo.smnrSdttm }"/>
	                                				</td>
	                                			</tr>
	                                			<tr>
	                                				<th>진행시간</th>
	                                				<td colspan="3">
	                                					<c:if test="${vo.smnrMnts >= 60 }">${mntsHour }시간 </c:if>
	                                            		${mntsMin }분
	                                				</td>
	                                			</tr>
	                                			<tr>
	                                                <th>성적반영</th>
	                                                <td colspan="3">${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
	                                            </tr>
	                                            <tr>
	                                                <th>성적공개</th>
	                                                <td colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
	                                            </tr>
	                                            <tr>
	                                                <th>평가방법</th>
	                                                <td colspan="3">
	                                                	<c:choose>
			                                                <c:when test="${vo.evlScrTycd eq 'SCR' }">
			                                                    점수형
			                                                </c:when>
			                                                <c:otherwise>
			                                                    참여형 <span class="fcBlue">( 설문 참여 : 100점, 미참여 : 0점 자동배점 )</span>
			                                                </c:otherwise>
			                                            </c:choose>
	                                                </td>
	                                            </tr>
	                                            <tr>
	                                                <th>파일 첨부</th>
	                                                <td colspan="3">
	                                                	<c:if test="${not empty vo.fileList}">
														<div class="add_file_list">
															<uiex:filedownload fileList="${vo.fileList}"/>
														</div>
													</c:if>
	                                                </td>
	                                            </tr>
	                                            <tr>
	                                            	<th>팀 세미나</th>
	                                            	<td colspan="3" class="in_table">
	                                            		<c:choose>
														<c:when test="${vo.byteamSubsmnrUseyn eq 'Y' }">
															<div class="view_con">
				                                                팀그룹 : ${vo.teamGrpnm }
				                                            </div>
				                                            <!-- 팀그룹별 세미나 설정 -->
															<div class="table-wrap mb30">
																<table class="table-type5 in-table">
																	<colgroup>
																		<col class="width-5per" />
						                                                <col class="width-15per" />
						                                                <col class="" />
																	</colgroup>
																	<tbody id="smnrSubSmnrTbody">
																	</tbody>
																</table>
															</div>
															<!-- //팀그룹별 세미나 설정 -->
														</c:when>
														<c:otherwise>
															<div class="view_con">${no }</div>
														</c:otherwise>
													</c:choose>
	                                            	</td>
	                                            </tr>
	                                            <c:if test="${vo.smnrGbncd eq 'ONLN_SMNR' }">
			                                        <tr>
			                                            <th>ZOOM 설정</th>
			                                            <th class="text-right" colspan="3">
			                                                <button class="btn type2" onclick="zoomUserStart()">ZOOM 시작</button>
			                                            </th>
			                                        </tr>
			                                        <tr>
			                                            <th>ZOOM 회의 ID</th>
			                                            <td colspan="3">${vo.meetngrmId }</td>
			                                        </tr>
			                                        <tr>
			                                            <th>ZOOM 회의 녹화</th>
			                                            <td colspan="3">${vo.autoRcdyn eq 'Y' ? yes : no }</td>
			                                        </tr>
			                                    </c:if>
	                                		</tbody>
	                                	</table>
	                                </div>
	                            </li>
	                        </ul>
	                    </div>
	                    <!--//accordion-->

	                    <div class="board_top">
		                    <h4 class="sub-title">세미나 참여</h4>
		                </div>

						<div id="atndDiv">
							<c:if test="${vo.smnrPrgrsSts eq 'DONE' }">
								<table class="table-type5">
	                                <colgroup>
	                                	<col class="width-15per" />
	                                	<col class="" />
	                                </colgroup>
	                                <tbody>
	                                	<tr>
	                                		<th colspan="2">
	                                			<div class="flex-item">
		                                			<b>세미나 참여</b>
		                                			<button type="button" class="btn type1 big flex-left-auto" onclick="fdbkPopup()">피드백 / ${vo.fdbkCnt }</button>
	                                			</div>
	                                		</th>
	                                	</tr>
	                                	<tr>
		                               		<th>참여 일시</th>
		                               		<td><uiex:formatDate value="${vo.atndSdttm}" type="datetime2"/></td>
	                                	</tr>
	                                	<tr>
	                                		<th>참여 시간</th>
	                                		<td>
												<c:set var="atndHour"><fmt:formatNumber value="${vo.atndScnds / 3600}" type="number" pattern="#"/></c:set>
												<c:set var="atndMin"><fmt:formatNumber value="${(vo.atndScnds % 3600) / 60}" type="number" pattern="#"/></c:set>
												<c:set var="atndSec"><fmt:formatNumber value="${vo.atndScnds % 60}" type="number" pattern="#"/></c:set>
												<c:if test="${atndHour > 0 }">${atndHour }시간 </c:if>
												<c:if test="${atndMin > 0 }">${atndMin }분 </c:if>
												${atndSec }초
	                                		</td>
	                                	</tr>
	                                	<tr>
	                                		<th>평가 점수</th>
	                                		<td>${vo.atndEvlyn eq 'Y' && vo.mrkOyn eq 'Y' ? vo.atndEvlScr : '-' }점</td>
	                                	</tr>
	                                </tbody>
	                           </table>
							</c:if>
							<c:if test="${vo.smnrPrgrsSts ne 'DONE' && vo.smnrGbncd eq 'ONLN_SMNR' }">
								<div class="flex-item gap-3 margin-bottom-3">
									<button type="button" class="btn type1 width-16em" onclick="zoomUserStart()"><i class="xi-desktop fs-32px"></i><spring:message code="seminar.button.video.seminar.part" /><!-- 화상 세미나<br>참여하기 --></button>
									<ol class="list-dot">
										<li>진행일시 : <uiex:formatDate type="datetime" value="${vo.smnrSdttm }"/></li>
										<li>진행시간 : <c:if test="${vo.smnrMnts >= 60 }">${mntsHour }시간 </c:if>${mntsMin }분</li>
									</ol>
								</div>
								<div class="msg-box success">
		                            <p><spring:message code="seminar.message.zoom.info1" /><!-- * [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요. --></p>
		                            <p class="fcRed">Zoom 프로그램이 아닌 브라우저 상의 “브라우저에서 참가”를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다.</p>
		                        </div>
		                        <div class="msg-box basic">
		                            <ul>
		                                <li><spring:message code="seminar.message.zoom.info3" /><!-- * 참가에 실패하는 경우 --></li>
		                                <li><spring:message code="seminar.message.zoom.info4" /><!-- 화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다. --></li>
		                                <li><spring:message code="seminar.message.zoom.info5" /><!-- 참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다. --></li>
		                                <li><button type="button" class="btn type2 big">이메일 주소 직접 등록하여 참가</button></li>
		                                <li><spring:message code="seminar.message.zoom.info6" /><!-- 참가 등록시 입력할 이메일 주소 --> : <span class="fcBlue">학번@knou.ac.kr</span></li>
		                            </ul>
		                        </div>
							</c:if>
							<c:if test="${vo.smnrGbncd eq 'ONLN_SMNR' }">
								<div class="board_top margin-top-3">
				                    <h4 class="sub-title">참여 이력</h4>
				                    <c:if test="${vo.autoRcdyn eq 'Y' }">
					                    <div class="right-area">
					                    	<button type="button" class="btn type1 big">녹화영상보기</button>
					                    </div>
				                    </c:if>
				                </div>
				                <div id="hstryList"></div>
				                <script>
									// 리스트 테이블
									let hstryListTable = UiTable("hstryList", {
										lang: "ko",
										columns: [
											{title:"번호", 			field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
											{title:"참여 시작 일시", 	field:"atndSdttm",		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:200},
											{title:"참여 종료 일시", 	field:"atndEdttm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},
											{title:"참여 시간", 		field:"atndScnds",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},
										]
									});
								</script>
							</c:if>
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