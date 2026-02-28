<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		$(".accordion").accordion();
	});
	
	// 설문 팝업
	function reshPop(type) {
		var typeMap = {
			"join"   : {"modal" : "join",      "url" : "/resh/reshJoinPop.do"},		// 설문 첫 참여
			"edit"   : {"modal" : "join",      "url" : "/resh/reshEditPop.do"},		// 설문 재 참여
			"result" : {"modal" : "result",    "url" : "/resh/reshResultPop.do"},	// 설문 결과
			"paper"	 : {"modal" : "viewPaper", "url" : "/resh/reshPaperViewPop.do"}	// 제출 설문지
		};
		
		var searchKey = type == "paper" ? "list" : "view";
		var kvArr = [];
		kvArr.push({'key' : 'reschCd', 	 'val' : "${vo.reschCd}"});
		kvArr.push({'key' : 'searchKey', 'val' : searchKey});
		kvArr.push({'key' : 'userId', 	 'val' : "${stdVO.userId }"});
		kvArr.push({'key' : 'stdNo', 	 'val' : "${stdVO.stdNo }"});
		
		submitForm(typeMap[type]["url"], "reshPopIfm", typeMap[type]["modal"], kvArr);
	}
	
	// 목록
	function viewReshList() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/resh/Form/stuReshList.do", "", "", kvArr);
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
							setLocationBar('<spring:message code="resh.label.resh" />', '<spring:message code="resh.label.resh.info" />');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
                            <div class="button-area">
                            	<c:if test="${vo.reschStatus eq '진행' && vo.joinYn eq 'N' && PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
					                <a href="javascript:reshPop('join')" class="ui blue button"><spring:message code="resh.label.resh.join" /></a><!-- 설문참여 -->
				                </c:if>
				                <c:if test="${vo.reschStatus eq '진행' && vo.joinYn eq 'Y' && PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
					                <a href="javascript:reshPop('edit')" class="ui blue button"><spring:message code="resh.label.resh.edit" /></a><!-- 설문수정 -->
				                </c:if>
				                <c:if test="${vo.reschStatus eq '완료' && (vo.rsltTypeCd eq 'ALL' || (vo.rsltTypeCd eq 'JOIN' && vo.joinYn eq 'Y')) && vo.reschQstnCnt > 0 }">
					            	<a href="javascript:reshPop('result')" class="ui basic button"><spring:message code="resh.label.resh.result" /></a><!-- 설문결과 -->
				                </c:if>
				                <a href="javascript:viewReshList()" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
                            </div>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
		        					<spring:message code="resh.common.yes" var="yes" /><!-- 예 -->
                                    <spring:message code="resh.common.no"  var="no" /><!-- 아니오 -->
		        					<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschStartDttm }" />
									<fmt:formatDate var="reschStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
									<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.reschEndDttm }" />
									<fmt:formatDate var="reschEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
                                    <div class="title active">
                                        <div class="title_cont">
                                            <div class="left_cont">
                                                <div class="lectTit_box">
                                                    <p class="lect_name">${fn:escapeXml(vo.reschTitle) }</p>
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
                                    <div class="content active">
                                        <div class="ui segment transition visible">
                                            <ul class="tbl">
                                                <li>
					                				<dl>
					                					<dt><spring:message code="resh.label.cts" /><!-- 설문내용 --></dt>
					                					<dd><pre>${vo.reschCts }</pre></dd>
					                				</dl>
					                			</li>
					                			<li>
					                				<dl>
					                					<dt><spring:message code="resh.label.period" /><!-- 설문기간 --></dt>
					                					<dd>${reschStartDttm } ~ ${reschEndDttm }</dd>
					                					<dt><spring:message code="resh.label.resh.item" /><!-- 설문문항 --></dt>
					                					<dd>${vo.reschQstnCnt }<spring:message code="resh.label.item" /><!-- 문항 --></dd>
					                				</dl>
					                			</li>
					                			<li>
					                				<dl>
					                					<dt><spring:message code="resh.label.ext.join.yn" /><!-- 지각제출 --></dt>
					                					<dd>
					                						<c:choose>
					                							<c:when test="${vo.extJoinYn eq 'Y' && not empty vo.extEndDttm }">
					                								<fmt:parseDate var="extEndDateFmt" pattern="yyyyMMddHHmmss" value="${vo.extEndDttm }" />
																	<fmt:formatDate var="extEndDttm" pattern="yyyy.MM.dd HH:mm" value="${extEndDateFmt }" />
																	${extEndDttm }
					                							</c:when>
					                							<c:otherwise>
					                								-
					                							</c:otherwise>
					                						</c:choose>
					                					</dd>
					                					<dt><spring:message code="resh.label.allow.modi.yn" /><!-- 설문결과 조회가능 --></dt>
					                					<dd>${vo.rsltTypeCd eq 'ALL' || (vo.rsltTypeCd eq 'JOIN' && vo.joinYn eq 'Y') ? yes : no }</dd>
					                				</dl>
					                			</li>
					                			<li>
					                				<dl>
					                					<dt><spring:message code="resh.label.eval.cg" /><!-- 평가방법 --></dt>
					                					<dd>
					                						<c:choose>
					                							<c:when test="${vo.evalCtgr eq 'P' }">
					                								<spring:message code="resh.label.eval.ctgr.score" /><!-- 점수형 -->
					                							</c:when>
					                							<c:otherwise>
					                								<spring:message code="resh.label.eval.ctgr.join" /><!-- 참여형 -->
					                							</c:otherwise>
					                						</c:choose>
					                					</dd>
					                					<dt></dt>
					                					<dd></dd>
					                				</dl>
					                			</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
		        			</div>
		        		</div>
				        <div class="row" style="<%=("Y".equals(SessionInfo.getAuditYn(request)) ? "display:none" : "")%>">
				        	<div class="col">
				        		<div class="option-content">
					       			<h3 class="sec_head"><spring:message code="resh.label.submit.hsty" /><!-- 제출 기록 --></h3>
				        			<div class="mla">
				        				<c:if test="${vo.reschStatus eq '진행' && vo.joinYn eq 'N' && PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
							                <a href="javascript:reshPop('join')" class="ui blue button"><spring:message code="resh.label.resh.join" /></a><!-- 설문참여 -->
						                </c:if>
						                <c:if test="${vo.reschStatus eq '진행' && vo.joinYn eq 'Y' && PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
							                <a href="javascript:reshPop('edit')" class="ui blue button"><spring:message code="resh.label.resh.edit" /></a><!-- 설문수정 -->
						                </c:if>
						                <c:if test="${vo.reschStatus eq '완료' && (vo.rsltTypeCd eq 'ALL' || (vo.rsltTypeCd eq 'JOIN' && vo.joinYn eq 'Y')) && vo.reschQstnCnt > 0 }">
							            	<a href="javascript:reshPop('result')" class="ui blue button"><spring:message code="resh.label.resh.result" /></a><!-- 설문결과 -->
						                </c:if>
				        			</div>
				        		</div>
				        		<ul class="tbl-simple dt-sm pl20">
				        			<li>
				        				<dl>
				        					<dt><spring:message code="resh.label.submit.dttm" /><!-- 제출 일시 --></dt>
				        					<dd>
				        						<c:choose>
				        							<c:when test="${vo.joinYn eq 'Y' }">
				        								<fmt:parseDate var="joinDateFmt" pattern="yyyyMMddHHmmss" value="${vo.joinDttm }" />
														<fmt:formatDate var="joinDttm" pattern="yyyy.MM.dd HH:mm" value="${joinDateFmt }" />
														${joinDttm }
				        							</c:when>
				        							<c:otherwise>
				        								-
				        							</c:otherwise>
				        						</c:choose>
				        					</dd>
				        				</dl>
				        			</li>
				        			<li>
				        				<dl>
				        					<dt><spring:message code="resh.label.submit.resh.paper" /><!-- 제출설문지 --></dt>
				        					<dd>
				        						<c:choose>
				        							<c:when test="${vo.joinYn eq 'Y' }">
				        								<a href="javascript:reshPop('paper')" class="ui blue button"><spring:message code="resh.label.submit.resh.paper" /><!-- 제출설문지 --></a>
				        							</c:when>
				        							<c:otherwise>
				        								-
				        							</c:otherwise>
				        						</c:choose>
				        					</dd>
				        				</dl>
				        			</li>
				        			<li>
				        				<dl>
				        					<dt><spring:message code="resh.label.status.submit.eval" /><!-- 제출/평가현황 --></dt>
				        					<dd>
				        						<c:choose>
				        							<c:when test="${vo.joinYn eq 'Y' }">
				        								<c:choose>
				        									<c:when test="${vo.scoreOpenYn eq 'Y' }">
				        										${vo.score }<spring:message code="resh.label.score" /><!-- 점 -->
				        									</c:when>
				        									<c:otherwise>
				        										<spring:message code="resh.label.submit.y" /><!-- 제출완료 -->
				        									</c:otherwise>
				        								</c:choose>
				        							</c:when>
				        							<c:otherwise>
				        								<spring:message code="resh.label.submit.n" /><!-- 미제출 -->
				        							</c:otherwise>
				        						</c:choose>
				        					</dd>
				        				</dl>
				        			</li>
				        		</ul>
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