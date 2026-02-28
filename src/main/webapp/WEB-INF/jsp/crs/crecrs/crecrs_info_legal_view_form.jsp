<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<script type="text/javascript">
		$(document).ready(function() { 
		});
		
		//수정
		function creCrsEdit(){
		   	var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsLegalWriteForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${vo.crsCreCd}" />'}));
			form.appendTo("body");
			form.submit();
		}
		
		//목록
		function moveList() {
		   	var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsLegalListForm.do");
			form.appendTo("body");
			form.submit();
		}
		
		// 다운로드
		function fileDown(fileSn, repoCd) {
			var url  = "/common/fileInfoView.do";
			var data = {
				"fileSn" : fileSn,
				"repoCd" : repoCd
			};
			
			ajaxCall(url, data, function(data) {
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "downloadForm");
				form.attr("id", "downloadForm");
				form.attr("target", "downloadIfm");
				form.attr("action", data);
				form.appendTo("body");
				form.submit();
				
				$("#downloadForm").remove();
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
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
					        <small class="section"><spring:message code="crs.label.crs.court" /> <spring:message code="crs.button.termlink.course"/><!-- 법정교육 과목 정보 --></small>
					    </div>
					</h2>
				    <div class="button-area">
				    	<a href="javascript:creCrsEdit()" class="btn"><spring:message code="button.edit"/></a> <!-- 수정 -->
				        <a href="javascript:moveList()" class="btn"><spring:message code="button.list"/></a> <!-- 목록 -->
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
									<label class="label-title"><spring:message code="common.subject"/></label>
									<span>${creCrsVO.crsNm}</span><!-- 과목 -->
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="common.label.crsauth.crsnm"/><spring:message code="crs.common.lang.ko"/></label>
									<span>${creCrsVO.crsCreNm}</span><!-- 과목명 --> <!-- (KO) -->
								</div>
								<div class="inline field">
									<label class="label-title"><spring:message code="common.label.crsauth.crsnm"/><spring:message code="crs.common.lang.en"/></label>
									<span>${creCrsVO.crsCreNmEng}</span><!-- 과목명 --> <!-- (EN) -->
								</div>
			                	<div class="inline field">
			                    	<label class="label-title"><spring:message code="common.label.lecture.desc"/></label><!-- 강의 설명 -->
									<div class="ui message">${creCrsVO.crsCreDesc}</div>
			               		</div>
			               		<c:if test="${not empty fileList and fileList.size() > 0}">
			               		<div class="inline field">
			                    	<label class="label-title"><spring:message code="crs.label.atch.content"/></label><!-- 콘텐츠 첨부 -->
			               			<div class="ui message">
			               				<ul>
			               					<c:forEach items="${fileList}" var="row">
                                            <li>                                                  
                                                <a href="javascript:void(0)" onclick="fileDown('<c:out value="${row.fileSn}" />', '<c:out value="${row.repoCd }" />')"><c:out value="${row.fileNm}" /><span class="f080 ml5">(<c:out value="${row.fileSizeStr}" />)</span></a>
                                            </li>
                                            </c:forEach>
                                        </ul>
			               			</div>
			               		</div>
			               		</c:if>
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
						</div>
			        	<div class="sixteen wide tablet eight wide computer column">
			        		<div class="ui attached message">
								<div class="header"><spring:message code="crs.common.lecture.config"/><!-- 강의설정 --></div>
							</div>
							<div class="ui attached segment">
								<div class="inline field">
			                    	<label class="label-title"><spring:message code="crs.common.scoreratetype"/></label><!-- 평가방법 -->
			                    	<span>${creCrsVO.scoreEvalTypeNm}</span>
			                	</div>
							</div>
							<div class="ui attached message">
								<div class="header"><spring:message code="common.label.register.course"/><!-- 수강신청 --></div>
							</div>
							<div class="ui attached segment">
								 <div class="inline field">
				                    <label class="label-title"><spring:message code="crs.request.method"/></label><!-- 신청 방법-->
				                    <c:if test="${empty creCrsVO.enrlAplcMthd or creCrsVO.enrlAplcMthd eq 'ADMIN'}"><spring:message code="crs.manager.approve"/></c:if><!-- 관리자 승인 -->
				                    <c:if test="${creCrsVO.enrlAplcMthd eq 'USER'}"><spring:message code="crs.request.learner"/></c:if><!-- 학습자 신청 -->
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
								<%-- 
				                <div class="inline field">
				                    <label class="label-title">
				                    	<spring:message code="crs.lecture.person.limit"/><!-- 수강인원 제한 -->
				                    </label>
				                    <c:choose>
				                    	<c:when test="${creCrsVo.nopLimitYn eq 'Y'}">
				                    		${creCrsVO.enrlNop}<spring:message code="message.person"/><!-- 수강인원 제한 --> <!-- 명 -->
				                    	</c:when>
				                    	<c:otherwise>
				                    		<spring:message code="common.label.no.limit"/>
				                    	</c:otherwise>
				                    </c:choose>                 
				                </div>
				                 --%>
				                 <%-- 
				                <div class="inline field">
				                    <label class="label-title"><spring:message code="crs.completion.process.method"/></label><!-- 수료 처리 방법 -->
				                     <c:if test="${creCrsVO.cpltHandlType eq 'MA'}"><spring:message code="crs.manager.process"/></c:if><!-- 관리자 처리 -->
				                     <c:if test="${creCrsVO.cpltHandlType eq 'AT'}"><spring:message code="crs.auto.process"/></c:if><!-- 자동 처리 -->
				                </div>
				                 --%>
							</div>
							<div class="ui attached message">
								<div class="header"><spring:message code="common.label.lecture.period"/><!-- 강의 기간 --></div>
							</div>
							<div class="ui attached segment">
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
	<iframe id="downloadIfm" name="downloadIfm" style="visibility: none; display: none;" title="downloadIfm"></iframe>
</body>
</html>