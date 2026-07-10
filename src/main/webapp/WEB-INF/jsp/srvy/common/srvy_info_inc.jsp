<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function () {
		if("${vo.byteamSubsrvyUseyn}" == "Y") {
			teamGrpSubSrvyListSelect();	// 팀그룹부설문목록조회
		}

		if(${userCtx.admin} && ${fn:contains(vo.srvyTycd, 'EXAM') }) {
			sbjctListSelect();			// 과목목록조회
		}
	});

	/**
	 * 팀그룹부설문목록조회
	 * @param teamGrpId 	- 팀그룹아이디
	 * @param srvyId 		- 설문아이디
	 */
	function teamGrpSubSrvyListSelect() {
		const url  = "/srvy/srvyTeamGrpSubAsmtListAjax.do";
		const data = {
			teamGrpId  	: "${vo.teamGrpId}",
			srvyId 		: "${vo.srvyId}"
		};

		$.ajax({
	        url 	  	: url,
	        async	  	: false,
	        type 	  	: "POST",
	        dataType  	: "json",
	        data 	  	: JSON.stringify(data),
	        contentType	: "application/json; charset=UTF-8",
	        beforeSend	: () => UiComm.showLoading(true),
            success		: function (data) {
                if (data.result > 0) {
                	let returnList = data.returnList || [];
                	let html = "";

    			    if(returnList.length > 0) {
    			    	returnList.forEach(function(v, i) {
    			    		html += "<tr>";
    						html += "	<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
    						html += "	<th><label><spring:message code='srvy.label.team.group.member' /></label></th>";/* 팀그룹 구성원 */
    						html += "	<td>" + v.leadernm + " <spring:message code='msg.label.write.others' /> " + (v.teamMbrCnt - 1) + "<spring:message code='common.label.nm' /></td>";/* 외 *//* 명 */
    						html += "</tr>";
    						html += "<tr>";
    						html += "	<th><label><spring:message code='srvy.label.sub.title' /></label></th>";/* 부주제 */
    						html += "	<td>" + UiComm.escapeHtml(v.srvyTtl) + "</td>";
    						html += "</tr>";
    						html += "<tr>";
    						html += "	<th><label><spring:message code='common.label.contents' /></label></th>";/* 내용 */
    						html += "	<td><pre>" + v.srvyCts + "</pre></td>";
    						html += "</tr>";
    			    	});
    			    }

    			    $("#teamSubSrvyTbody").append(html);
                }
            },
            error		: () => UiComm.showMessage("<spring:message code='srvy.error.copy' />", "error"),	/* 가져오기 중 에러가 발생하였습니다. */
            complete	: () => UiComm.showLoading(false)
	    });
	}

	// 과목목록조회
	function sbjctListSelect() {
		const url = "/srvy/admSrvyLctrEvlRegistSbjctListAjax.do";
		const data = {
			srvyId 	: "${vo.srvyId}"
		};
		if("${searchType}" === "SBJCTOP") data.userId = "${userCtx.userId}";

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
            	let returnList = data.returnList || [];
            	let dataList = [];
            	let html = "<option value=''><spring:message code='srvy.label.select.sbjct' /></option>";/* 과목 선택 */

        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + " (" + (v.dvclasNo || "-") + "<spring:message code='srvy.label.decls' />)</option>";/* 반 */
        				dataList.push({
        					orgnm: 		v.orgnm,
        					sbjctCd: 	v.sbjctCd,
        					sbjctnm: 	v.sbjctnm,
        					dvclasNo: 	v.dvclasNo,
        					profnm: 	v.profnm,
        					tutnm: 		v.tutnm
    					});
        			});
        		}

        		if("${searchType}" !== "SBJCTOP") {
	            	$("#sbjctId").empty().append(html);
	            	$("#sbjctId").val('').trigger("chosen:updated");
        		}

        		sbjctListTable.clearData();
        		sbjctListTable.replaceData(dataList);
            } else {
            	UiComm.showMessage(data.message, "error");
            }
		}, function(xhr, status, error) {
			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
		}, true);
	}
</script>

<!--accordion-->
<div class="elements_wrap">
    <ul class="accordion">
    	<spring:message code="srvy.common.yes" var="yes" /><!-- 예 -->
		<spring:message code="srvy.common.no" var="no" /><!-- 아니오 -->
        <li class=""><!-- 클릭시 active 추가 -->
            <div class="title-wrap">
                <a class="title" href="#">
                    <div class="lecture_tit">
                        <strong>${fn:escapeXml(vo.srvyTtl) }</strong>
                        <p class="desc">
                        	<c:choose>
                        		<c:when test="${fn:contains(vo.srvyTycd, 'EXAM') }">
                        			<span><spring:message code="srvy.label.lctr.evl.period" /><!-- 강의평가기간 --> :<strong><uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/></strong></span>
                                    <c:if test="${userCtx.student }"><span><spring:message code="srvy.label.lctr.evl.score.view" /><!-- 강의평가 후 성적조회 --> :<strong>${vo.mrkOyn eq 'Y' ? yes : no }</strong></span></c:if>
                        		</c:when>
                        		<c:when test="${vo.srvyTycd eq 'SRVY_WHOL' }">
                        			<span><spring:message code="srvy.label.all.srvy.period" /><!-- 전체설문기간 --> :<strong><uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/></strong></span>
                        		</c:when>
                        		<c:otherwise>
                        			<span><spring:message code="srvy.label.period" /><!-- 설문기간 --> :<strong><uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/></strong></span>
		                            <span><spring:message code="srvy.label.score.aply.yn" /><!-- 성적반영 --> :<strong>${vo.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
		                            <span><spring:message code="srvy.label.score.open.yn" /><!-- 성적공개 --> :<strong>${vo.mrkOyn eq 'Y' ? yes : no }</strong></span>
                        		</c:otherwise>
                        	</c:choose>
                        </p>
                    </div>
                    <i class="arrow xi-angle-down"></i>
                </a>
            </div>
            <div class="cont">
            	<table class="table-type5">
            		<colgroup>
            			<col class="width-20per" />
            			<col class="" />
            			<col class="width-20per" />
            			<col class="" />
            		</colgroup>
            		<tbody>
            			<c:if test="${vo.srvyTycd eq 'SRVY_WHOL' }">
            				<tr>
                                <th><spring:message code="srvy.label.org" /><!-- 기관 --></th>
                                <td colspan="3">${vo.orgnm }</td>
                            </tr>
                            <tr>
                                <th><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></th>
                                <td colspan="3">${vo.smstrChrtnm }</td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.object" /><!-- 대상 --></th>
                                <td colspan="3">
                                	<c:choose>
                                		<c:when test="${vo.srvyTrgtTycd eq 'ALL' }">
                                			<spring:message code="srvy.common.all" /><!-- 전체 -->
                                		</c:when>
                                		<c:otherwise>
		                                	${vo.srvyTrgtTynm }
                                		</c:otherwise>
                                	</c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code="srvy.label.all.srvy.ttl" /><!-- 전체설문 제목 --></th>
                                <td colspan="3">${fn:escapeXml(vo.srvyTtl) }</td>
                            </tr>
            			</c:if>
            			<c:if test="${fn:contains(vo.srvyTycd, 'EXAM') && userCtx.admin }">
            				<tr>
                                <th>기관</th>
                                <td colspan="3">${vo.orgnm }</td>
                            </tr>
                            <tr>
                                <th>년도/학기(기수)</th>
                                <td colspan="3">${vo.smstrChrtnm }</td>
                            </tr>
                            <tr>
                                <th>분류</th>
                                <td colspan="3">${vo.srvyTrgtGbnnm }</td>
                            </tr>
                            <tr class="teamView">
                                <td colspan="4">
                                    <table class="table-type5">
                                        <tbody>
                                            <tr>
                                                <th colspan="6">과목 선택</th>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <div id="sbjctList"></div>
                                    <script>
	                                    let sbjctListTable = UiTable("sbjctList", {
	                       				lang: "ko",
	                       				height: 200,
	                       				columns: [
	                       					{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm",		headerHozAlign:"center", 	hozAlign:"center", 	width:100,	minWidth:100},/* 기관 */
	                       					{title:"<spring:message code='common.label.crsauth.crscd' />", 	field:"sbjctCd", 	headerHozAlign:"center", 	hozAlign:"center", 	width:100, 	minWidth:100},/* 과목코드 */
	                       					{title:"<spring:message code='srvy.label.sbjct.nm' />", 		field:"sbjctnm", 	headerHozAlign:"center", 	hozAlign:"left", 	width:0,	minWidth:100},/* 과목명 */
	                       					{title:"<spring:message code='srvy.label.dvclas' />", 			field:"dvclasNo", 	headerHozAlign:"center", 	hozAlign:"center", 	width:80,	minWidth:80},/* 분반 */
	                       					{title:"<spring:message code='common.charge.professor' />", 	field:"profnm", 	headerHozAlign:"center", 	hozAlign:"center",	width:120,	minWidth:120},/* 담당교수 */
	                       					{title:"<spring:message code='srvy.label.charge.tutor' />", 	field:"tutnm", 		headerHozAlign:"center", 	hozAlign:"center",	width:120,	minWidth:120},/* 담당튜터 */
	                       				]
	                       			});
                                    </script>
                                </td>
                            </tr>
                            <tr>
                                <th>강의평가 제목</th>
                                <td colspan="3">${fn:escapeXml(vo.srvyTtl) }</td>
                            </tr>
            			</c:if>
            			<tr>
                			<th>
                				<c:choose>
	                        		<c:when test="${fn:contains(vo.srvyTycd, 'EXAM') }">
	                        			<spring:message code="srvy.label.lctr.evl.cts" /><!-- 강의평가 내용 -->
	                        		</c:when>
	                        		<c:when test="${vo.srvyTycd eq 'SRVY_WHOL' }">
	                        			<spring:message code="srvy.label.all.srvy.cts" /><!-- 전체설문 설명 -->
	                        		</c:when>
	                        		<c:otherwise>
	                        			<spring:message code="srvy.label.cts" /><!-- 설문내용 -->
	                        		</c:otherwise>
	                        	</c:choose>
                			</th>
                			<td colspan="3">
                				<div class="tb_content htmlText">
                					<c:out value="${vo.srvyCts }" escapeXml="false"/>
                                </div>
                			</td>
            			</tr>
            			<c:if test="${fn:contains(vo.srvyTycd, 'EXAM') }">
            				<tr>
                            	<th><spring:message code="srvy.label.lctr.evl.type" /><!-- 강의평가 구분 --></th>
                            	<td colspan="3">
                            		<c:choose>
                            			<c:when test="${fn:contains(vo.srvyTycd, 'MIDEXAM') }">
                            				<spring:message code="srvy.label.mid.exam" /><!-- 중간고사 -->
                            			</c:when>
                            			<c:otherwise>
                            				<spring:message code="srvy.label.lst.exam" /><!-- 기말고사 -->
                            			</c:otherwise>
                            		</c:choose>
                            	</td>
                            </tr>
            			</c:if>
            			<tr>
            				<th>
            					<c:choose>
	                        		<c:when test="${fn:contains(vo.srvyTycd, 'EXAM') }">
	                        			<spring:message code="srvy.label.lctr.evl.period" /><!-- 강의평가기간 -->
	                        		</c:when>
	                        		<c:when test="${vo.srvyTycd eq 'SRVY_WHOL' }">
	                        			<spring:message code="srvy.label.all.srvy.period" /><!-- 전체설문기간 -->
	                        		</c:when>
	                        		<c:otherwise>
	                        			<spring:message code="srvy.label.period" /><!-- 설문기간 -->
	                        		</c:otherwise>
	                        	</c:choose>
            				</th>
            				<td colspan="3">
            					<uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/>
            				</td>
            			</tr>
            			<c:choose>
	                    	<c:when test="${fn:contains(vo.srvyTycd, 'EXAM') }">
	                    		<c:if test="${userCtx.admin }">
	                    			<tr>
                                        <th>관리 구분</th>
                                        <td colspan="3">${vo.srvyWrtTynm }</td>
                                    </tr>
	                    		</c:if>
	                    		<tr>
                                    <th><spring:message code="srvy.label.lctr.evl.score.view" /><!-- 강의평가 후 성적조회 --></th>
                                    <td colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
                                </tr>
                                <tr>
                                    <th><spring:message code="srvy.label.lctr.evl.view.result" /><!-- 강의평가 결과조회 --></th>
                                    <td colspan="3">${vo.rsltOpenTycd eq 'WHOL_OPEN' ? yes : no }</td>
                                </tr>
	                    	</c:when>
	                    	<c:when test="${vo.srvyTycd eq 'SRVY_WHOL' }">
	                    		<tr>
                                    <th><spring:message code="srvy.label.view.result" /><!-- 결과조회 --></th>
                                    <td colspan="3">${vo.rsltOpenTycd eq 'WHOL_OPEN' ? yes : no }</td>
                                </tr>
	                    	</c:when>
	                    	<c:otherwise>
		            			<tr>
		                            <th><spring:message code="srvy.label.score.aply.yn" /><!-- 성적반영 --></th>
		                            <td ${userCtx.student ? 'colspan="3"' : '' }>${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
		                            <c:if test="${userCtx.professor }">
			                            <th><spring:message code="srvy.label.score.ratio" /><!-- 성적 반영비율 --></th>
			                            <td>${vo.mrkRfltyn eq 'Y' ? vo.mrkRfltrt : '0' }%</td>
		                            </c:if>
		                        </tr>
		                        <tr>
		                            <th><spring:message code="srvy.label.score.open.yn" /><!-- 성적공개 --></th>
		                            <td colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
		                        </tr>
		                        <tr>
		                            <th><spring:message code="srvy.label.evl.method" /><!-- 평가방법 --></th>
		                            <td colspan="3">
		                            	<c:choose>
											<c:when test="${vo.evlScrTycd eq 'SCR' }">
												<spring:message code="srvy.label.evl.ctgr.score" /><!-- 점수형 -->
											</c:when>
											<c:otherwise>
												<spring:message code="srvy.label.evl.ctgr.ptcp" /><!-- 참여형 --> <small class="note ml10">( <spring:message code="srvy.label.evl.ctgr.info" /><!-- 설문 참여 : 100점, 미참여 : 0점 자동배점 --> )</small>
											</c:otherwise>
										</c:choose>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th><spring:message code="srvy.label.view.result.yn" /><!-- 설문결과 조회가능 --></th>
		                            <td colspan="3">${vo.rsltOpenTycd eq 'WHOL_OPEN' ? yes : no }</td>
		                        </tr>
		                        <tr>
		                        	<th><spring:message code="srvy.label.team.srvy" /><!-- 팀 설문 --></th>
		                        	<td colspan="3" class="in_table">
		                        		<c:choose>
											<c:when test="${vo.srvyGbn eq 'SRVY_TEAM' }">
												<div class="view_con">
		                                            ${yes }<br>
		                                            <spring:message code="srvy.label.team.group" /><!-- 팀그룹 --> : ${vo.teamGrpnm }<br>
		                                            <spring:message code="srvy.label.team.group.set.srvy" /><!-- 팀그룹별 설문 설정 --> :
		                                            <c:choose>
		                                            	<c:when test="${vo.byteamSubsrvyUseyn eq 'Y' }">
		                                            		<spring:message code="srvy.label.use.y" /><!-- 사용 -->
		                                            	</c:when>
		                                            	<c:otherwise>
		                                            		<spring:message code="srvy.label.use.n" /><!-- 미사용 -->
		                                            	</c:otherwise>
		                                            </c:choose>
		                                        </div>
		                                        <!-- 팀그룹별 설문 설정 -->
												<c:if test="${vo.byteamSubsrvyUseyn eq 'Y' }">
													<div class="table-wrap mb30">
														<table class="table-type5 in-table">
															<colgroup>
																<col class="width-5per" />
		                                                        <col class="width-15per" />
		                                                        <col class="" />
															</colgroup>
															<tbody id="teamSubSrvyTbody">
															</tbody>
														</table>
													</div>
												</c:if>
												<!-- //팀그룹별 설문 설정 -->
											</c:when>
											<c:otherwise>
												<div class="view_con">${no }</div>
											</c:otherwise>
										</c:choose>
		                        	</td>
		                        </tr>
	                    	</c:otherwise>
	                    </c:choose>
            		</tbody>
            	</table>
            </div>
        </li>
    </ul>
</div>
<!--//accordion-->