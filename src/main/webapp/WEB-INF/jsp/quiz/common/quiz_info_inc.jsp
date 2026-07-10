<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function () {
		if("${vo.teamGrpSubasmtStngyn}" == "Y") {
			teamGrpSubQuizListSelect();
		}
	});

	/**
	 * 팀그룹부퀴즈목록조회
	 * @param teamGrpId		팀그룹아이디
	 * @param examBscId		시험기본아이디
	 */
	function teamGrpSubQuizListSelect() {
		const url  = "/quiz/quizTeamGrpSubQuizListAjax.do";
		const data = {
			teamGrpId : "${vo.teamGrpId}",
			examBscId : "${vo.examBscId}"
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				let returnList = data.returnList || [];
				let html = "";

        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
						html += "<tr>";
						html += "	<th rowspan='4' class='group-header'><label>" + v.teamnm + "</label></th>";
						html += "	<th><label><spring:message code='quiz.label.team.group.member' /></label></th>";/* 팀그룹 구성원 */
						html += "	<td>" + v.leadernm + " <spring:message code='msg.label.write.others' /> " + (v.teamMbrCnt - 1) + "<spring:message code='message.person' /></td>";/* 외 *//* 명 */
						html += "</tr>";
						html += "<tr>";
						html += "	<th><label><spring:message code='quiz.label.sub.title' /></label></th>";/* 부주제 */
						html += "	<td><label class='htmlText'>" + UiComm.escapeHtml(v.examTtl) + "</label></td>";
						html += "</tr>";
						html += "<tr>";
						html += "	<th><label><spring:message code='common.label.contents' /></label></th>";/* 내용 */
						html += "	<td><pre>" + v.examCts + "</pre></td>";
						html += "</tr>";
						html += "<tr>";
						html += "	<th><label><spring:message code='common.attachments' /></label></th>";/* 첨부파일 */
						html += "	<td>";
						if(v.fileList != null) {
							html += "	<div class='add_file_list'>";
							html += "		<ul class='add_file'>";
							v.fileList.forEach(function(vv, ii) {
								html += "		<li>";
								html += "			<a href='#_' class='file_down' onclick='UiFileDownloader(\""+vv.encDownParam+"\");return false;' title='File download'>"+vv.filenm+"</a>";
								html += "		</li>";
							});
							html += "		</ul>";
							html += "	</div>";
						}
						html += "	</td>";
						html += "</tr>";
        			});
        		}

        		$("#teamSubQuizTbody").append(html);
			}
		}, true);
	}
</script>

<!--accordion-->
<div class="elements_wrap">
    <ul class="accordion">
    	<spring:message code="quiz.common.yes" var="yes" /><!-- 예 -->
		<spring:message code="quiz.common.no" var="no" /><!-- 아니오 -->
		<c:set var="examSdttm" 	value="${userCtx.professor ? vo.examDtlVO.examPsblSdttm : vo.examPsblSdttm}" />
		<c:set var="examEdttm" 	value="${userCtx.professor ? vo.examDtlVO.examPsblEdttm : vo.examPsblEdttm}" />
        <li class=""><!-- 클릭시 active 추가 -->
            <div class="title-wrap">
                <a class="title" href="#">
                    <div class="lecture_tit">
                        <strong>${fn:escapeXml(vo.examTtl) }</strong>
                        <p class="desc">
                            <span><spring:message code="quiz.label.period" /><!-- 응시기간 --> : <strong><uiex:formatDate value="${examSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examEdttm}" type="datetime2"/></strong></span>
                            <span><spring:message code="quiz.label.mrk.rfltyn" /><!-- 성적반영 --> :<strong>${vo.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
                            <span><spring:message code="quiz.label.mrk.oyn" /><!-- 성적공개 --> :<strong>${vo.mrkOyn eq 'Y' ? yes : no }</strong></span>
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
                			<th><spring:message code="quiz.label.cts" /><!-- 퀴즈내용 --></th>
                			<td colspan="3">
                				<div class="tb_content htmlText">
                					<c:out value="${vo.examCts }" escapeXml="false"/>
                                </div>
                			</td>
            			</tr>
            			<tr>
            				<th><spring:message code="quiz.label.period" /><!-- 응시기간 --></th>
            				<td colspan="3"><uiex:formatDate value="${examSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examEdttm}" type="datetime2"/></td>
            			</tr>
            			<tr>
            				<th><spring:message code="quiz.label.mnts" /><!-- 퀴즈시간 --></th>
            				<td colspan="3">${userCtx.professor ? vo.examDtlVO.examMnts : vo.examMnts}<spring:message code="date.minute" /><!-- 분 --></td>
            			</tr>
            			<tr>
                            <th><spring:message code="quiz.label.mrk.rfltyn" /><!-- 성적반영 --></th>
                            <td>${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
                            <th><spring:message code="quiz.label.mrk.rfltrt" /><!-- 성적반영비율 --></th>
                            <td>${vo.mrkRfltyn eq 'Y' ? vo.examGbncd eq 'QUIZ_EXAM_MID' or vo.examGbncd eq 'QUIZ_EXAM_LST' ? '100' : vo.mrkRfltrt : '0' }%</td>
                        </tr>
                        <tr>
                            <th><spring:message code="quiz.label.mrk.oyn" /><!-- 성적공개 --></th>
                            <td colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
                        </tr>
                        <tr>
                            <th><spring:message code="quiz.label.qstn.dsply.mode" /><!-- 문제표시방식 --></th>
                            <td colspan="3">
                            	<c:choose>
									<c:when test="${vo.qstnDsplyGbncd eq 'ALL' }">
										<spring:message code="quiz.label.all.view.qstn" /><!-- 전체문제 표시 -->
									</c:when>
									<c:otherwise>
										<spring:message code="quiz.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
									</c:otherwise>
								</c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="quiz.label.qstn.shuffle" /><!-- 문제 섞기 --></th>
                            <td colspan="3">${vo.qstnRndmyn eq 'Y' ? yes : no }</td>
                        </tr>
                        <tr>
                            <th><spring:message code="quiz.label.vwitm.shuffle" /><!-- 보기 섞기 --></th>
                            <td colspan="3">${vo.qstnVwitmRndmyn eq 'Y' ? yes : no }</td>
                        </tr>
                        <tr>
                            <th><spring:message code="quiz.label.attach.file" /><!-- 파일 첨부 --></th>
                            <td colspan="3">
                            	<c:if test="${not empty vo.fileList}">
									<div class="add_file_list">
										<uiex:filedownload fileList="${vo.fileList}"/>
									</div>
								</c:if>
                            </td>
                        </tr>
                        <tr>
                        	<th><spring:message code="quiz.common.team.quiz" /><!-- 팀 퀴즈 --></th>
                        	<td colspan="3" class="in_table">
                        		<c:choose>
									<c:when test="${vo.examGbncd eq 'QUIZ_TEAM' }">
										<div class="view_con">
                                            ${yes }<br>
                                            <spring:message code="quiz.label.team.group" /><!-- 팀그룹 --> : ${vo.teamGrpnm }<br>
                                            <spring:message code="quiz.label.team.group.set.quiz" /><!-- 팀그룹별 퀴즈 설정 --> :
                                            <c:choose>
                                            	<c:when test="${vo.teamGrpSubasmtStngyn eq 'Y' }">
                                            		<spring:message code="common.use" /><!-- 사용 -->
                                            	</c:when>
                                            	<c:otherwise>
                                            		<spring:message code="common.not_use" /><!-- 미사용 -->
                                            	</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <!-- 팀그룹별 퀴즈 설정 -->
										<c:if test="${vo.teamGrpSubasmtStngyn eq 'Y' }">
											<div class="table-wrap mb30">
												<table class="table-type5 in-table">
													<colgroup>
														<col class="width-5per" />
                                                        <col class="width-15per" />
                                                        <col class="" />
													</colgroup>
													<tbody id="teamSubQuizTbody">
													</tbody>
												</table>
											</div>
										</c:if>
										<!-- //팀그룹별 퀴즈 설정 -->
									</c:when>
									<c:otherwise>
										<div class="view_con">${no }</div>
									</c:otherwise>
								</c:choose>
                        	</td>
                        </tr>
                        <tr>
                        	<th><spring:message code="quiz.label.retkexam.allow" /><!-- 재응시 사용 --></th>
                        	<td colspan="3">
                        		<c:set var="reexamYn"    	value="${userCtx.professor ? vo.examDtlVO.reexamyn         : vo.reexamyn}" />
								<c:set var="reexamSdttm" 	value="${userCtx.professor ? vo.examDtlVO.reexamPsblSdttm  : vo.reexamPsblSdttm}" />
								<c:set var="reexamEdttm" 	value="${userCtx.professor ? vo.examDtlVO.reexamPsblEdttm  : vo.reexamPsblEdttm}" />
								<c:set var="reexamRfltrt" 	value="${userCtx.professor ? vo.examDtlVO.reexamMrkRfltrt  : vo.reexamMrkRfltrt}" />
		                        ${reexamYn eq 'Y' ? yes : no }
								<c:if test="${reexamYn eq 'Y' }">
									<br>
									<spring:message code="quiz.label.reperiod" /><!-- 재응시기간 --> : <uiex:formatDate value="${reexamSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${reexamEdttm}" type="datetime2"/><br>
									<spring:message code="quiz.label.retkexam.scr.weight" /><!-- 재응시 적용률 --> : ${reexamRfltrt}%
								</c:if>
                        	</td>
                        </tr>
            		</tbody>
            	</table>
            </div>
        </li>
    </ul>
</div>
<!--//accordion-->