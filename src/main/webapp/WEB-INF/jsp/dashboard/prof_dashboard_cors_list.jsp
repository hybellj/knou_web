<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!-- prof_dashboard_cors_list.jsp start -->
<c:forEach var="cors" items="${corsList}" varStatus="status">
	<section class="item">
	    <div class="header">
	        <a href="<c:url value='/crs/crsHomeProf.do'/>?crsCreCd=${cors.crsCreCd}" title="강의실 이동" class="h4 <c:if test='${cors.uniCd eq "G"}'>graduSch</c:if>">
	        	<c:choose>
	        		<c:when test="${cors.univGbn eq '2'}">
	        			[<spring:message code='crs.label.special'/><!-- 특수 -->]
	        		</c:when>
	        		<c:when test="${cors.univGbn eq '3'}">
	        			[<spring:message code='crs.label.general'/><!-- 일반 -->]
	        		</c:when>
	        		<c:when test="${cors.univGbn eq '4'}">
	        			[<spring:message code='crs.label.busi'/><!-- 경영 -->]
	        		</c:when>
	        	</c:choose>
	        	${cors.crsCreNm} (${cors.declsNo}<spring:message code="dashboard.cor.dev_class"/>)</a>
	        <div class="extra1" style="letter-spacing: -0.5px"> <!-- 수강 청강 태그 변경 및 위치 이동_230517 -->
	        	<dl><dt><spring:message code="common.professor" /></dt><dd>${empty cors.profNm ? '-' : cors.profNm}</dd></dl> <!-- 교수 -->
	        	<dl><dt>조교</dt><dd>${empty cors.assistNm ? '-' : cors.assistNm}</dd></dl> <!-- 조교 -->
	        	<dl><dd>${empty cors.credit ? '-' : cors.credit}</dd><dt>학점</dt></dl> <!-- 학점 -->
	            <dl><dt><spring:message code="lesson.lecture" /></dt><dd>${cors.stdCnt}<spring:message code="resh.label.nm" /></dd></dl> <!-- 수강, 명 -->
	            <dl><dt><spring:message code="lesson.auditor" /></dt><dd>${cors.auditCnt}<spring:message code="resh.label.nm" /></dd></dl><!-- 청강, 명 -->
	            <dl><dt>${cors.assistNm}</dt><dd class="pl5">${StringUtil.getPhoneNumber(cors.assistTel)}</dd></dl>
	        </div>
	        <!--
	        <div class="item-btn">
	            <button type="button" class="btn">평가수정</button>
	            <button type="button" class="btn">평가완료</button>
	        </div>
	        -->

	    </div>
	    <!-- 진도율 -->
        <div class="prog_box">
        	<label for="allAverage_lect01" id="progBox2"><spring:message code="dashboard.all_prog" /></label>
	        <fmt:parseNumber var="totalRate" value="${cors.totalRate}" integerOnly="true" />
			<div class="ui indicating progress all_average" data-value="<c:out value="${totalRate}"/>" data-total="100" id="allAverage_lect01">
				<div class="bar">
					<div class="progress">0%</div>
				</div>
			</div>
        </div>
        <!-- //진도율 -->


	    <div class="cnt">
	    	<!-- 강의공지 -->
        	<c:choose>
            	<c:when test="${cors.noticeCnt > 0}">
            		<a class="box noti" data-label="<spring:message code='dashboard.cor.notice'/>" href="javascript:moveCrs('/bbs/bbsLect/atclList.do?bbsCd=ALARM&crsCreCd=<c:out value="${cors.crsCreCd}"/>&bbsId=<c:out value="${cors.noticeBbsId}"/>')"><span>${cors.noticeCnt}</span></a>
            	</c:when>
            	<c:otherwise>
            		<span class="box noti" data-label="<spring:message code='dashboard.cor.notice'/>">0</span>
            	</c:otherwise>
            </c:choose>

			<!-- Q&A -->
           	<c:choose>
           		<c:when test="${cors.qnaCnt > 0}">
           			<a class="box qna" data-label="<spring:message code='dashboard.cor.qna'/>" href="javascript:moveCrs('/bbs/bbsLect/atclList.do?bbsCd=ALARM&crsCreCd=<c:out value="${cors.crsCreCd}"/>&bbsId=<c:out value="${cors.qnaBbsId}"/>')"><span>${cors.qnaAnsCnt}<small>${cors.qnaCnt}</small></span></a>
           		</c:when>
           		<c:otherwise>
           			<span class="box qna" data-label="<spring:message code='dashboard.cor.qna'/>">0</span>
           		</c:otherwise>
           	</c:choose>

			<!-- 1:1상담 -->
           	<c:choose>
           		<c:when test="${cors.secretCnt > 0}">
           			<a class="box qna" data-label="<spring:message code='dashboard.cor.secret' />" href="javascript:moveCrs('/bbs/bbsLect/atclList.do?bbsCd=ALARM&crsCreCd=<c:out value="${cors.crsCreCd}"/>&bbsId=<c:out value="${cors.secretBbsId}"/>')"><span>${cors.secretAnsCnt}<small>${cors.secretCnt}</small></span></a>
           		</c:when>
           		<c:otherwise>
           			<span class="box qna" data-label="<spring:message code='dashboard.cor.secret' />">0</span>
           		</c:otherwise>
           	</c:choose>

			<!-- 과제평가 -->
           	<c:choose>
           		<c:when test="${cors.asmntCnt > 0}">
           			<a class="box" data-label="<spring:message code='asmnt.button.asmnt.eval' />" href="javascript:moveCrs('/asmt/proAsmtListView.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>&proAsmtListView.do?crsCreCd=')"><span>${cors.asmntEvalCnt}<small>${cors.asmntSbmtCnt}</small></span></a>
           		</c:when>
           		<c:otherwise>
           			<%-- <span class="box" data-label="<spring:message code='asmt.button.asmt.eval' />">0</span> --%>
           		</c:otherwise>
           	</c:choose>

			<!-- 토론평가 -->
           	<c:choose>
           		<c:when test="${cors.forumCnt > 0}">
           			<a class="box" data-label="<spring:message code='forum.button.eval' />" href="javascript:moveCrs('/forum/forumLect/Form/forumList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.forumEvalCnt}<small>${cors.forumAnsCnt}</small></span></a>
           		</c:when>
           		<c:otherwise>
           			<%-- <span class="box" data-label="토론평가">0</span> --%>
           		</c:otherwise>
           	</c:choose>

			<!-- 퀴즈평가 -->
           	<c:choose>
           		<c:when test="${cors.quizCnt > 0}">
           			<a class="box" data-label="<spring:message code='dashboard.cor.quiz.eval' />" href="javascript:moveCrs('/quiz/profQzListView.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.quizEvalCnt}<small>${cors.quizAnsCnt}</small></span></a>
           		</c:when>
           		<c:otherwise>
           			<%-- <span class="box" data-label="<spring:message code='dashboard.cor.quiz.eval' />">0</span> --%>
           		</c:otherwise>
           	</c:choose>

	        <!-- 설문 -->
           	<c:choose>
           		<c:when test="${cors.reschCnt > 0}">
           			<a class="box" data-label="<spring:message code='dashboard.cor.resch' />" href="javascript:moveCrs('/resh/Form/reshList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.reschCnt}</span></a>
           		</c:when>
           		<c:otherwise>
           			<%-- <span class="box" data-label="<spring:message code='dashboard.cor.resch' />">0</span> --%>
           		</c:otherwise>
           	</c:choose>

	        <!-- 수시평가 -->
          	<c:choose>
          		<c:when test="${cors.examAnsCnt > 0}">
          			<a class="box" data-label="<spring:message code='dashboard.cor.always.exam' />" href="javascript:moveCrs('/exam/Form/examList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>&examType=ADMISSION')"><span>${cors.examEvalCnt}<small>${cors.examAnsCnt}</small></span></a>
          		</c:when>
          		<c:otherwise>
          			<%-- <span class="box" data-label="<spring:message code='dashboard.cor.always.exam' /">0</span> --%>
          		</c:otherwise>
          	</c:choose>

	        <!-- 세미나 -->
	        <c:choose>
	        	<c:when test="${cors.seminarCnt > 0}">
	        		<a class="box" data-label="<spring:message code='dashboard.seminar'/>" href="javascript:moveCrs('/seminar/seminarHome/Form/stuSeminarList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.seminarAnsCnt}<small>${cors.seminarCnt}</small></span></a>
	        	</c:when>
           		<c:otherwise>
           			<%-- <span class="box" data-label="<spring:message code='dashboard.seminar'/>">0</span> --%>
           		</c:otherwise>
	        </c:choose>
	    </div>

		<%
		// 기관:한사대만 표시
        if (SessionInfo.isKnou(request)) {
	    	%>
		    <div class="extra2">
				<dl class="flex1" <c:if test="${not empty cors.examMid}">title="<spring:message code='dashboard.exam_mid'/>" onclick="moveCrs('/exam/Form/examList.do?crsCreCd=${cors.crsCreCd}&examType=EXAM')" style='cursor:pointer'</c:if>>
			    	<dt><spring:message code="dashboard.exam_mid"/><!-- 중간고사 --></dt>
	               	<c:set var="exam" value="${cors.examMid}"/>
	               	<c:choose>
	               		<c:when test="${not empty cors.examMid && exam.scoreRatio gt 0}">
		               		<c:choose>
		               			<c:when test="${not empty exam.examStartDttm && exam.examTypeCd eq 'EXAM' }">
						            <dd>${exam.startDttm}</dd>

						            <dd><spring:message code="dashboard.exam.stare_tm"/>: ${exam.examStareTm}<spring:message code="dashboard.exam.min"/></dd><!-- 시험시간 분-->
						            <dd>
						            	<c:choose>
						            		<c:when test="${exam.scoreOpenYn eq 'Y'}">
						            			<spring:message code="dashboard.exam.score_open_y"/><!-- 성적 공개 -->
						            		</c:when>
						            		<c:otherwise>
						            			<spring:message code="dashboard.exam.score_open_n"/><!-- 성적 비공개 -->
						            		</c:otherwise>
						            	</c:choose>
							        </dd>
		               			</c:when>
		               			<c:when test="${not empty exam.examStartDttm && exam.examTypeCd ne 'EXAM' }">
		               				<dd><spring:message code="common.etc" />(${exam.examTypeNm})</dd><!-- 기타 -->
		               			</c:when>
		               			<c:when test="${empty exam.examStartDttm && exam.examTypeCd eq 'EXAM' }">
		               				<dd>
		               					<spring:message code="crs.label.live.exam" /> <spring:message code="common.ready" />(3<spring:message code="common.schedule.now" /> <spring:message code="common.announce.schedule" />)
		               				</dd><!-- 실시간 시험 준비중 (3주차 중 발표 예정) -->
		               			</c:when>
		               			<c:when test="${empty exam.examStartDttm && exam.examTypeCd ne 'EXAM' }">
		               				<dd><spring:message code="common.etc" />(<spring:message code="common.ready" />)</dd><!-- 기타 (준비 중) -->
		               			</c:when>
		               		</c:choose>
				            <%--
				            <dd>
			                	<c:choose>
			                		<c:when test="${exam.gradeViewYn eq 'Y'}">
			                			<spring:message code="dashboard.exam.grade_open_y"/>
			                		</c:when>
			                		<c:otherwise>
			                			<spring:message code="dashboard.exam.grade_open_n"/>
			                		</c:otherwise>
			                	</c:choose>
			                </dd>
			                --%>
	               		</c:when>
	               		<c:otherwise><dd>-</dd></c:otherwise>
	               	</c:choose>
			    </dl>
				<dl class="flex1" <c:if test="${not empty cors.examLast}">title="<spring:message code='dashboard.exam_end'/>" onclick="moveCrs('/exam/Form/examList.do?crsCreCd=${cors.crsCreCd}&examType=EXAM')" style='cursor:pointer'</c:if>>
			        <dt><spring:message code="dashboard.exam_end"/><!-- 기말고사 --></dt>
	               	<c:set var="exam" value="${cors.examLast}"/>
	               	<c:choose>
	               		<c:when test="${not empty cors.examLast && exam.scoreRatio gt 0}">
		               		<c:choose>
		               			<c:when test="${not empty exam.examStartDttm && exam.examTypeCd eq 'EXAM' }">
						            <dd>${exam.startDttm}</dd>

						            <dd><spring:message code="dashboard.exam.stare_tm"/>: ${exam.examStareTm}<spring:message code="dashboard.exam.min"/></dd><!-- 시험시간 분-->
						            <dd>
						            	<c:choose>
						            		<c:when test="${exam.scoreOpenYn eq 'Y'}">
						            			<spring:message code="dashboard.exam.score_open_y"/><!-- 성적 공개 -->
						            		</c:when>
						            		<c:otherwise>
						            			<spring:message code="dashboard.exam.score_open_n"/><!-- 성적 비공개 -->
						            		</c:otherwise>
						            	</c:choose>
							        </dd>
		               			</c:when>
		               			<c:when test="${not empty exam.examStartDttm && exam.examTypeCd ne 'EXAM' }">
		               				<dd><spring:message code="common.etc" />(${exam.examTypeNm })</dd><!-- 기타 -->
		               			</c:when>
		               			<c:when test="${empty exam.examStartDttm && exam.examTypeCd eq 'EXAM' }">
		               				<dd>
		               					<spring:message code="crs.label.live.exam" /><spring:message code="common.ready" />(3<spring:message code="common.schedule.now" /><spring:message code="common.announce.schedule" />)
		               				</dd><!-- 실시간 시험 준비중 (3주차 중 발표 예정) -->
		               			</c:when>
		               			<c:when test="${empty exam.examStartDttm && exam.examTypeCd ne 'EXAM' }">
		               				<dd><spring:message code="common.etc" />(<spring:message code="common.ready" />)</dd><!-- 기타 (준비 중) -->
		               			</c:when>
		               		</c:choose>
				               <%--
				               <dd>
			                	<c:choose>
			                		<c:when test="${exam.gradeViewYn eq 'Y'}">
			                			<spring:message code="dashboard.exam.grade_open_y"/>
			                		</c:when>
			                		<c:otherwise>
			                			<spring:message code="dashboard.exam.grade_open_n"/>
			                		</c:otherwise>
			                	</c:choose>
			                	</dd>
			                	--%>
	               		</c:when>
	               		<c:otherwise><dd>-</dd></c:otherwise>
	               	</c:choose>
			    </dl>
		    </div>
		    <%
        }
		%>
	</section>
</c:forEach>

<c:if test="${empty corsList}">
	<div class="flex-container" style="min-height:300px">
		<!-- 등록된 내용이 없습니다. -->
	    <div class="cont-none fcGrey">
	    	<i class="icon-list-no ico"></i><span class="fcGrey"><spring:message code="common.content.not_found"/></span>
	    </div>
	</div>
</c:if>
<!-- prof_dashboard_cors_list.jsp end -->