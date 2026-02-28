<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<script type="text/javascript">
		$(document).ready(function(){
		});
		 
		// 수정
		function moveEdit(){
		   	var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/addForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${vo.crsCreCd}" />'}));
			form.appendTo("body");
			form.submit();
		}
		 
		// 목록
		function moveList(){
		   	var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsListForm.do");
			form.appendTo("body");
			form.submit();
		}
	</script>
</head>
<body>
	<div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

		<div id="container">
			<!-- 본문 content 부분 -->
			<div class="content">
				<div id="info-item-box">
					<h2 class="page-title flex-item">
					    <spring:message code="common.term.subject"/><!-- 학기/과목 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="user.title.crs.uni" /> <spring:message code="std.label.info" /><!-- 학기제 과목 정보 --></small>
					    </div>
					</h2>
				    <div class="button-area">
				    	<a href="javascript:moveEdit();" class="btn"><spring:message code="button.edit"/></a><!-- 수정 -->
			            <a href="javascript:moveList();" class="btn"><spring:message code="button.list"/></a><!-- 목록 -->
				    </div>
				</div>
				<div class="ui divider mt0"></div>
			    <div class="ui form">
			        <div class="ui grid stretched row">
			            <div class="sixteen wide tablet eight wide computer column">
			                <div class="ui segment">
			                    <div class="inline field">
									<label class="label-title"><spring:message code="crs.label.open.year" /></label>
									<span>${creCrsVO.creYear}</span><!-- 개설년도 -->
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.label.open.term" /></label>
									<span>${creCrsVO.creTermNm}</span><!-- 개설학기 -->
								</div>
			                    <div class="inline field">
			                        <label class="label-title"><spring:message code="common.subject"/></label><span>${creCrsVO.crsNm}</span><!-- 과목 -->
			                    </div>
								<div class="inline field">
			                        <label class="label-title"><spring:message code="common.label.crsauth.crsnm"/><spring:message code="crs.common.lang.ko"/></label><span>${creCrsVO.crsCreNm}</span><!-- 과목명 --> <!-- (KO) -->
			                    </div>
			                    <div class="inline field">
			                        <label class="label-title"><spring:message code="common.label.crsauth.crsnm"/><spring:message code="crs.common.lang.en"/></label><span>${creCrsVO.crsCreNmEng}</span><!-- 과목명 --> <!-- (EN) -->
			                    </div>
			                    <div class="inline field">
			                        <label class="label-title"><spring:message code="common.label.decls.no"/></label><span>${creCrsVO.declsNo}</span><!-- 분반 -->
			                    </div>
			                	<div class="inline field">
					                <label class="label-title"><spring:message code="crs.lecture.explain"/></label><!-- 과목설명 -->
					                <div class="ui message">${creCrsVO.crsCreDesc}</div>
					            </div>
			                    <div class="inline field ">
			                        <label class="label-title"><spring:message code="crs.common.deptnm"/></label><!-- 개설학과 -->
			                        <span>${creCrsVO.deptNm}</span>
			                    </div>
			                    <%-- 
			                    <div class="inline field">
			                        <label class="label-title"><spring:message code="crs.label.credit" /></label><span>${creCrsVO.credit}</span><!-- 학점 -->
			                    </div>
			                     --%>
			                    <div class="inline field">
			                        <label class="label-title"><spring:message code="crs.label.compdv" /></label><span>${creCrsVO.compDvCdNm}</span><!-- 이수구분 -->
			                    </div>
			                    <div class="inline field">
			                        <label class="label-title"><spring:message code="crs.title.education.method" /></label><span>${creCrsVO.crsOperTypeCdNm}</span><!-- 강의 형태 -->
			                    </div>
			                    <div class="inline field">
					                <label class="label-title">LCDMS 연동여부</label><!-- LCDMS 연동여부 -->
				                    <span>
					                    <c:choose>
						                    <c:when test="${creCrsVO.lcdmsLinkYn eq 'Y'}"><spring:message code="message.yes"/><!-- 예 --></c:when>
						                    <c:otherwise><spring:message code="message.no"/><!-- 아니요 --></c:otherwise>
					                    </c:choose>
				                    </span>
				                </div>
					            <div class="inline field">
					                <label class="label-title"><spring:message code="common.use.yn"/></label><!-- 사용여부 -->
				                    <span>
					                    <c:choose>
						                    <c:when test="${creCrsVO.useYn eq 'Y'}"><spring:message code="message.yes"/><!-- 예 --></c:when>
						                    <c:otherwise><spring:message code="message.no"/><!-- 아니요 --></c:otherwise>
					                    </c:choose>
				                    </span>
				                </div>
				            </div>
				            
				            <%-- 선수강과목 이관 --%>
				            <c:if test="${(creCrsVO.tmswPreScYn eq 'Y') and (creCrsVO.creTerm eq '10' or creCrsVO.creTerm eq '20')}">
						        <div class="ui attached message">
					        		선수강과목 이전학기 자료 이관
					        	</div>
					        	<div class="ui attached segment">
									<div class="inline field">
										<label class="label-title">상태</label>
										<c:if test="${creCrsVO.tmswPreTransYn eq 'Y'}">
											<span class="fcBlue">이관 완료</span>
											<button class="ui basic small button ml20" onclick="transPrevTermCorsData()">이전 학기 자료 이관</button>
										</c:if>
										<c:if test="${creCrsVO.tmswPreTransYn ne 'Y'}">
											<span>이관 안함</span>
											<button class="ui blue small button ml20" onclick="transPrevTermCorsData()">이전 학기 자료 이관</button>
										</c:if>
									</div>
								</div>
								<script type="text/javascript">
								// 선수강과목 이전학기 자료 이관
								function transPrevTermCorsData() {
									var confirmMsg = "선수강과목의 이전학기 자료를 현재학기 과목으로 이관하시겠습니까?";
									if ("Y" == "${creCrsVO.tmswPreTransYn}") {
										confirmMsg = "선수강과목의 이전학기 자료를 현재학기 과목으로 이미 이관 완료하였습니다.\n재이관 하시겠습니까?";
									}
									var cnfm = confirm(confirmMsg);
									
									if (cnfm) {
										var url  = "/crs/creCrsMgr/transPrevTermCorsData.do";
										var param = {
											  crsCd			: '${creCrsVO.crsCd}'
											, crsCreCd		: '${creCrsVO.crsCreCd}'
											, creYear 		: '${creCrsVO.creYear}'
											, creTerm 		: '${creCrsVO.creTerm}'
										};
										
										ajaxCall(url, param, function(data) {
											if (data.result > 0) {
												alert("선수강과목의 이전학기 자료를 현재학기 과목으로 이관하였습니다.");
												document.location.reload();
											}
											else if (data.result == -1) {
												alert("시스템 오류가 발생하여 이전학기 자료를 이관하지 못했습니다.");
											}
											else if (data.result == -2) {
												alert("이관할 수 없는 학기의 과목입니다.");
											}
										}, function(xhr, status, error) {
											alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
										}, true);
									}
								}
								</script>
								
							</c:if>
							
							<%-- JLPT 과목 이관 --%>
							<c:if test="${(creCrsVO.crsCd eq 'JLPTN4' or creCrsVO.crsCd eq 'JLPTN5') and (creCrsVO.creTerm eq '10' or creCrsVO.creTerm eq '20')}">
						        <div class="ui attached message">
					        		JLPT 과목 이관
					        	</div>
					        	<div class="ui attached segment">
									<div class="inline field">
										<span>JLPT 과목을 다른 학기로 이관합니다.</span>
										<button class="ui blue small button ml20" onclick="transJlptCorsDialog()">JLPT 과목 이관</button>
									</div>
								</div>
								<script type="text/javascript">
								// JLPT 과목 이관 Dialog
								function transJlptCorsDialog() {
									$('#jlptTransModal').modal('show');
								}
								
								// JLPT 과목 이관
								function transJlptCors() {
									var jlptTermCd = $("#jlptTermCd").val();
									if (jlptTermCd == "") {
										alert("학기를 선택하세요.");
										return;
									}
									
									var confirmMsg = "JLPT 과목을 지정된 학기로 이관하시겠습니까?";
									var cnfm = confirm(confirmMsg);
									if (cnfm) {
										var url  = "/crs/creCrsMgr/transJlptCorsData.do";
										var param = {
											  crsCreCd		: '${creCrsVO.crsCreCd}'
											, termCd		: '${creCrsVO.termCd}'
											, transTermCd 	: jlptTermCd
										};
										
										ajaxCall(url, param, function(data) {
											if (data.result > 0) {
												alert("JLPT 과목을 이관하였습니다.");
												document.location.reload();
											}
											else if (data.result == -1) {
												alert("시스템 오류가 발생하여 과목을 이관하지 못했습니다.");
											}
										}, function(xhr, status, error) {
											alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
										}, true);
									}
								} 
								
								</script>
								
								<div class="modal fade in" id="jlptTransModal" tabindex="-1" role="dialog" aria-labelledby="JLPT" aria-hidden="false" style="display: none; padding-right: 17px;">
								    <div class="modal-dialog" role="document">
								        <div class="modal-content">
								            <div class="modal-header">
								                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="resh.button.close" />">
								                    <span aria-hidden="true">&times;</span>
								                </button>
								                <h4 class="modal-title">JLPT 과목 이관</h4>
								            </div>
								            <div class="modal-body">
												<div class="ui segment_">
													<div class="ui small warning message">
														JLPT 과목을 다른 학기로 이관합니다.<br>
														주의 : 다른 학기로 과목을 이관하면 현재학기에서는 과목이 삭제되며, 모든 학습활동 이력도 삭제됩니다.
													</div>
													<ul class="tbl">
														<li>
															<dl>
																<dt>
																	<label for="jlptTermCd">학기</label>
																</dt>
																<dd>
																	<select id="jlptTermCd" class="ui fluid search selection dropdown w300 " id="termCd" name="termCd">
																		<option value=""><spring:message code="common.alert.select.term"/></option> <%-- 학기를 선택하세요 --%>
																		<c:forEach var="item" items="${creTermList}"  varStatus="status">
																			<c:if test="${item.termCd gt creCrsVO.termCd and (item.haksaTerm eq '10' or item.haksaTerm eq '20')}">
																				<option value="${item.termCd}">${item.termNm}</option>
																			</c:if>
																		</c:forEach>
																	</select>
																</dd>
															</dl>
														</li>
													</ul>
													<div class="bottom-content">
														<button class="ui blue button" type="button" onclick="transJlptCors();">과목 이관</button>
														<button class="ui grey cancel button" type="button" onclick="$('#jlptTransModal').modal('hide');"><spring:message code="button.cancel" /></button>
													</div>
												</div>
								            </div>
								        </div>
								    </div>
								</div>
							</c:if>
							<%-- //JLPT 과목 이관 --%>
				            
				        </div>
						<div class="sixteen wide tablet eight wide computer column">
							<div class="ui attached message">
								<div class="header"><spring:message code="crs.common.lecture.config"/><!-- 강의설정 --></div>
							</div>
							<div class="ui attached segment">
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.title.evaluation.method" /><!-- 평가 방법 --></label>
									<span>${creCrsVO.scoreEvalTypeNm}</span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.study.form" /><!-- 강의형식 --></label>
									<span><tagutil:codename code="${creCrsVO.progressTypeCd}" category="PROGRESS_TYPE"/></span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.study.control" /><!-- 학습제어 --></label>
									<span><tagutil:codename code="${creCrsVO.learningControl}" category="LEARNING_CONTROL"/></span>
								</div>
							</div>
							<div class="ui attached message">
								<div class="header"><spring:message code="common.label.register.course"/><!-- 수강신청 --></div>
							</div>
							<div class="ui attached segment">
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.request.method" /><!-- 신청 방법 --></label>
									<span>
										<c:choose>
						                    <c:when test="${empty creCrsVO.enrlAplcMthd or creCrsVO.enrlAplcMthd eq 'ADMIN'}">
						                        <spring:message code="crs.manager.regist"/><!-- 관리자가 등록 -->
						                    </c:when>
											<c:when test="${creCrsVO.enrlAplcMthd eq 'USER'}">
						                        <spring:message code="crs.request.learner"/><!-- 학습자 신청 -->
						                    </c:when>
						                    <c:otherwise>
												-
						                    </c:otherwise>
					                    </c:choose>
									</span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.certification.status" /><!-- 인증 상태 --></label>
									<span>
										<c:choose>
						                    <c:when test="${creCrsVO.enrlCertStatus eq 'NORMAL'}">
						                        <spring:message code="button.confirm"/><!-- 승인 -->
						                    </c:when>
											<c:when test="${creCrsVO.enrlCertStatus eq 'REGIST'}">
												<spring:message code="common.label.ready"/><!-- 대기 -->
						                    </c:when>
						                    <c:otherwise>
												-
						                    </c:otherwise>
					                    </c:choose>
									</span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.lecture.person.limit" /><!-- 수강인원 제한 --></label>
									<span>
										<c:choose>
						                    <c:when test="${creCrsVO.nopLimitYn eq 'Y'}">
						                    	<spring:message code="message.yes"/><!-- 예 -->
						                    </c:when>
											<c:otherwise>
						                    	<spring:message code="message.no"/><!-- 아니오 -->
						                    </c:otherwise>
					                    </c:choose>
									</span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="common.limited.number" /><!-- 제한인원 --></label>
									<span>
										<c:choose>
							                <c:when test="${creCrsVO.nopLimitYn eq 'Y'}">
												<c:out value="${creCrsVO.enrlNop}" default="0"/><spring:message code="message.person"/><!-- 명 -->
							                </c:when>
							                <c:otherwise>
												-
							                </c:otherwise>
						                </c:choose>
									</span>
								</div>
							</div>
							
							<%-- 
							<div class="ui attached message">
								<div class="header"><spring:message code="common.label.lecture.period"/><!-- 강의 기간 --></div>
							</div>
							<div class="ui attached segment">
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.lecture.request.period" /><!-- 수강 신청 기간 --></label>
									<span>
										<c:choose>
						                    <c:when test="${empty creCrsVO.enrlAplcStartDttm or empty creCrsVO.enrlAplcEndDttm}">
						                    	<spring:message code="crs.lecture.request.period.invalid.yn" /><!-- 수강 신청 기간 미등록 -->
						                    </c:when>
						                    <c:otherwise>
						                    	<fmt:parseDate  var="enrlAplcStartDttmFmt"  pattern="yyyyMMddHHmmss" value="${creCrsVO.enrlAplcStartDttm}" />
			                            		<fmt:formatDate var="enrlAplcStartDt" pattern="yyyy.MM.dd" value="${enrlAplcStartDttmFmt}" />
			                            		<fmt:parseDate  var="enrlAplcEndDttmFmt"  pattern="yyyyMMddHHmmss" value="${creCrsVO.enrlAplcEndDttm}" />
			                            		<fmt:formatDate var="enrlAplcEndDt" pattern="yyyy.MM.dd" value="${enrlAplcEndDttmFmt}" />
			                            		<c:out value="${enrlAplcStartDt}" /> ~ <c:out value="${enrlAplcEndDt}" />
						                    </c:otherwise>
					                    </c:choose>
									</span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="common.label.lecture.period" /><!-- 강의 기간 --></label>
									<span>
										<c:choose>
						                    <c:when test="${empty creCrsVO.enrlStartDttm or empty creCrsVO.enrlEndDttm}">
						                    	<spring:message code="common.label.lecture.period.invalid.yn" /><!-- 강의 기간 미등록 -->
						                    </c:when>
						                    <c:otherwise>
						                    	<fmt:parseDate  var="enrlStartDttmFmt"  pattern="yyyyMMddHHmmss" value="${creCrsVO.enrlStartDttm}" />
			                            		<fmt:formatDate var="enrlStartDt" pattern="yyyy.MM.dd" value="${enrlStartDttmFmt}" />
			                            		<fmt:parseDate  var="enrlEndDttmFmt"  pattern="yyyyMMddHHmmss" value="${creCrsVO.enrlEndDttm}" />
			                            		<fmt:formatDate var="enrlEndDt" pattern="yyyy.MM.dd" value="${enrlEndDttmFmt}" />
			                            		<c:out value="${enrlStartDt}" /> ~ <c:out value="${enrlEndDt}" />
						                    </c:otherwise>
					                    </c:choose>
									</span>
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="crs.score.process.period" /><!-- 성적 처리 기간 --></label>
									<span>
										<c:choose>
						                    <c:when test="${empty creCrsVO.scoreHandlStartDttm or empty creCrsVO.scoreHandlEndDttm}">
						                    	<spring:message code="crs.score.process.period.invalid.yn" /><!-- 성적 처리 기간 미등록 -->
						                    </c:when>
											<c:otherwise>
												<fmt:parseDate  var="scoreHandlStartDttmFmt"  pattern="yyyyMMddHHmmss" value="${creCrsVO.scoreHandlStartDttm}" />
			                            		<fmt:formatDate var="scoreHandlStartDt" pattern="yyyy.MM.dd" value="${scoreHandlStartDttmFmt}" />
			                            		<fmt:parseDate  var="scoreHandlEndDttmFmt"  pattern="yyyyMMddHHmmss" value="${creCrsVO.scoreHandlEndDttm}" />
			                            		<fmt:formatDate var="scoreHandlEndDt" pattern="yyyy.MM.dd" value="${scoreHandlEndDttmFmt}" />
			                            		<c:out value="${scoreHandlStartDt}" /> ~ <c:out value="${scoreHandlEndDt}" />
											</c:otherwise>
										</c:choose>
									</span>
								</div>
								--%>
				            </div>
				        </div>
				    </div>
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<!-- footer 영역 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>