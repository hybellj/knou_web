<%@page import="knou.framework.common.SessionInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<c:forEach var="cors" items="${corsList}" varStatus="status">
    <c:set var="lessonList" value="${cors.lessonScheduleList}"/>

    <section class="item">
        <div class="header">
            <div class="option-content">
                <c:set var="lang" value="<%=SessionInfo.getLocaleKey(request)%>"/>
                <a href="javascript:checkEnter('${cors.crsCreCd}', '<c:url value='/crs/crsHomeStd.do'/>?sbjctOfrngId=${cors.crsCreCd}')"
                   title="<spring:message code="bbs.label.bbs_lect_move" />" class="h4">
                    <c:if test="${cors.auditYn eq 'Y'}">
                        <c:choose>
                            <c:when test="${cors.gvupYn eq 'Y'}">[<spring:message
                                    code="crs.label.giveup"/>]<!-- 수강포기 --></c:when>
                            <c:otherwise>[<spring:message code="crs.label.audit"/>]<!-- 청강 --></c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${cors.repeatYn eq 'Y'}">[<spring:message code="crs.label.repeat"/>]<!-- 재수강 --></c:if>
                    <c:if test="${cors.tmswPreScYn eq 'Y'}">[<spring:message code="crs.label.pre_course2"/>]<!-- 선수강 --></c:if>
                    <c:choose>
                        <c:when test="${cors.preScYn eq 'Y'}">
                            [<spring:message code="crs.label.pre_course"/>]<!-- 선수 -->
                        </c:when>
                        <c:when test="${cors.suppScYn eq 'Y'}">
                            [<spring:message code="crs.label.sup_course"/>]<!-- 보충 -->
                        </c:when>
                    </c:choose>
                    <c:choose>
                        <c:when test="${lang == 'en'}">${cors.crsCreNmEng}</c:when>
                        <c:otherwise>${cors.crsCreNm}</c:otherwise>
                    </c:choose>
                    (${cors.declsNo}<spring:message code="dashboard.cor.dev_class"/>)</a>
                <c:if test="${not empty cors.lsnPlanUrl}">
                    <%
                        if(SessionInfo.isKnou(request)) { // 수업계획서
                    %>
                    <a href="#0" onclick="viewLessonPlan('${cors.lsnPlanUrl}');return false;" class="ui small button"
                       title="<spring:message code="common.label.class.plan" />"><i class="icon-paper3 ico"
                                                                                    aria-hidden="true"></i><span
                            class="blind"><spring:message code="common.label.class.plan"/></span></a><!-- 수업계획서 -->
                    <%
                        }
                    %>
                </c:if>
            </div>
            <div class="extra1"
                 style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
                <dl>
                    <dt><spring:message code="user.title.tch.professor"/></dt>
                    <dd>${cors.profNm}</dd>
                        <%--<dd>${cors.profTel}</dd>--%></dl><!-- 교수 -->
                <dl>
                    <dt>
                        <c:choose>
                            <c:when test="${cors.crsCd eq 'CHY164'}">
                                <spring:message code="crs.label.acad.coach"/><!-- 학업코치 -->
                            </c:when>
                            <c:otherwise>
                                <spring:message code="user.title.tch.tutor"/><!-- 조교 -->
                            </c:otherwise>
                        </c:choose>
                    </dt>
                    <dd>${cors.assistNm}</dd>
                    <dd class="pl5">(${StringUtil.getPhoneNumber(cors.assistTel)})</dd>
                </dl>
            </div>
        </div>

        <c:if test="${cors.auditYn eq 'N' }">
            <div class="cnt">
                <!-- 공지사항 -->
                <c:choose>
                    <c:when test="${cors.noticeCnt > 0}"><a class="box noti"
                                                            data-label="<spring:message code='dashboard.cor.notice'/>"
                                                            href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/bbs/bbsLect/atclList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>&bbsId=<c:out value="${cors.noticeBbsId}"/>')"><span>${cors.noticeReadCnt}<small>${cors.noticeCnt}</small></span></a>
                    </c:when>
                    <c:otherwise><a class="box noti" data-label="<spring:message code='dashboard.cor.notice'/>"
                                    href="#0"><span>-</span></a></c:otherwise>
                </c:choose>

                <!-- Q&A -->
                <c:choose>
                    <c:when test="${cors.qnaCnt > 0}"><a class="box qna"
                                                         data-label="<spring:message code='dashboard.cor.qna'/>"
                                                         href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/bbs/bbsLect/atclList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>&bbsId=<c:out value="${cors.qnaBbsId}"/>')"><span>${cors.qnaAnsCnt}<small>${cors.qnaCnt}</small></span></a>
                    </c:when>
                    <c:otherwise><a class="box qna" data-label="<spring:message code='dashboard.cor.qna'/>"
                                    href="#0"><span>-</span></a></c:otherwise>
                </c:choose>

                <!-- 1:1상담 -->
                <c:choose>
                    <c:when test="${cors.secretCnt > 0}"><a class="box qna"
                                                            data-label="<spring:message code='dashboard.cor.councel'/>"
                                                            href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/bbs/bbsLect/atclList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>&bbsId=<c:out value="${cors.secretBbsId}"/>')"><span>${cors.secretAnsCnt}<small>${cors.secretCnt}</small></span></a>
                    </c:when>
                    <c:otherwise><a class="box qna" data-label="<spring:message code='dashboard.cor.councel'/>"
                                    href="#0"><span>-</span></a></c:otherwise>
                </c:choose>

                <!-- 과제 -->
                <c:choose>
                    <c:when test="${cors.asmntCnt > 0}"><a class="box"
                                                           data-label="<spring:message code='dashboard.cor.asmnt'/>"
                                                           href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/asmt/stu/listView.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.asmntSbmtCnt}<small>${cors.asmntCnt}</small></span></a>
                    </c:when>
                    <c:otherwise></c:otherwise>
                </c:choose>

                <!-- 토론 -->
                <c:choose>
                    <c:when test="${cors.forumCnt > 0}"><a class="box"
                                                           data-label="<spring:message code='dashboard.cor.forum'/>"
                                                           href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/forum/forumHome/Form/forumList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.forumAnsCnt}<small>${cors.forumCnt}</small></span></a>
                    </c:when>
                    <c:otherwise></c:otherwise>
                </c:choose>

                <!-- 퀴즈 -->
                <c:choose>
                    <c:when test="${cors.quizCnt > 0}"><a class="box"
                                                          data-label="<spring:message code='dashboard.cor.quiz'/>"
                                                          href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/quiz/Form/stuQuizList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.quizAnsCnt}<small>${cors.quizCnt}</small></span></a>
                    </c:when>
                    <c:otherwise></c:otherwise>
                </c:choose>

                <!-- 설문 -->
                <c:choose>
                    <c:when test="${cors.reschCnt > 0}"><a class="box"
                                                           data-label="<spring:message code='dashboard.cor.resch'/>"
                                                           href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/resh/Form/stuReshList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.reschAnsCnt}<small>${cors.reschCnt}</small></span></a>
                    </c:when>
                    <c:otherwise></c:otherwise>
                </c:choose>

                <!-- 수시평가 -->
                <c:choose>
                    <c:when test="${cors.alwaysExamCnt > 0}"><a class="box"
                                                                data-label="<spring:message code='dashboard.cor.always.exam'/>"
                                                                href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/exam/Form/stuExamList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>&examType=ADMISSION')"><span>${cors.alwaysExamAnsCnt}<small>${cors.alwaysExamCnt}</small></span></a>
                    </c:when>
                    <c:otherwise></c:otherwise>
                </c:choose>

                <!-- 세미나 -->
                <c:choose>
                    <c:when test="${cors.seminarCnt > 0}"><a class="box"
                                                             data-label="<spring:message code='dashboard.seminar'/>"
                                                             href="javascript:checkEnterMoveCrs('<c:out value="${cors.crsCreCd}"/>', '/seminar/seminarHome/Form/stuSeminarList.do?crsCreCd=<c:out value="${cors.crsCreCd}"/>')"><span>${cors.seminarAnsCnt}<small>${cors.seminarCnt}</small></span></a>
                    </c:when>
                    <c:otherwise></c:otherwise>
                </c:choose>

            </div>
        </c:if>

        <%
            // 기관:한사대만 표시
            if(SessionInfo.isKnou(request)) {
        %>
        <div class="extra2">
            <dl class="flex1"
                <c:if test="${not empty cors.examMid}">title="<spring:message code='dashboard.exam_mid'/>"
                onclick="checkEnterMoveCrs('${cors.crsCreCd}', '/exam/Form/stuExamList.do?examType=EXAM&crsCreCd=${cors.crsCreCd}')"
                style='cursor:pointer'
            </c:if>>
                <dt><spring:message code="dashboard.exam_mid"/><!-- 중간고사 --></dt>
                <c:set var="exam" value="${cors.examMid}"/>
                <c:choose>
                    <c:when test="${not empty cors.examMid and exam.scoreRatio > 0}">
                        <c:choose>
                            <c:when test="${exam.examTypeCd eq 'EXAM' && not empty exam.startDttm}">
                                <dd>${exam.startDttm}</dd>
                                <dd><spring:message code="dashboard.exam.stare_tm"/>: ${exam.examStareTm}<spring:message
                                        code="dashboard.exam.min"/></dd>
                                <dd>
                                    <c:choose>
                                        <c:when test="${exam.scoreOpenYn eq 'Y'}"><spring:message
                                                code="dashboard.exam.score_open_y"/></c:when>
                                        <c:otherwise><spring:message code="dashboard.exam.score_open_n"/></c:otherwise>
                                    </c:choose>
                                </dd>
                                <%-- <dd>
                                    <c:choose>
                                        <c:when test="${exam.gradeViewYn eq 'Y'}"><spring:message code="dashboard.exam.grade_open_y"/></c:when>
                                        <c:otherwise><spring:message code="dashboard.exam.grade_open_n"/></c:otherwise>
                                    </c:choose>
                                </dd> --%>
                            </c:when>
                            <c:when test="${exam.examTypeCd eq 'EXAM' && empty exam.startDttm}">
                                <dd>
                                    <spring:message code="crs.label.live.exam"/> <spring:message code="common.ready"/>(3<spring:message
                                        code="common.schedule.now"/> <spring:message code="common.announce.schedule"/>)
                                </dd>
                                <!-- 실시간 시험 준비중 (3주차 중 발표 예정) -->
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${not empty exam.insRefCd}">
                                        <c:choose>
                                            <c:when test="${exam.examTypeCd eq 'QUIZ'}">
                                                <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                        code="dashboard.cor.quiz"/>)
                                                </dd>
                                                <!-- 기타 --><!-- 퀴즈 -->
                                                <dd>${exam.insStartDttm} ~ ${exam.insEndDttm}</dd>
                                            </c:when>
                                            <c:when test="${exam.examTypeCd eq 'ASMNT'}">
                                                <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                        code="dashboard.cor.asmnt"/>)
                                                </dd>
                                                <!-- 기타 --><!-- 과제 -->
                                                <dd>${exam.insStartDttm} ~ ${exam.insEndDttm}</dd>
                                            </c:when>
                                            <c:when test="${exam.examTypeCd eq 'FORUM'}">
                                                <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                        code="dashboard.cor.forum"/>)
                                                </dd>
                                                <!-- 기타 --><!-- 토론 -->
                                                <dd>${exam.insStartDttm} ~ ${exam.insEndDttm}</dd>
                                            </c:when>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                code="common.ready"/>)
                                        </dd>
                                        <!-- 기타 (준비 중) -->
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <dd>-</dd>
                    </c:otherwise>
                </c:choose>
            </dl>
            <dl class="flex1"
                <c:if test="${not empty cors.examLast}">title="<spring:message code='dashboard.exam_end'/>"
                onclick="checkEnterMoveCrs('${cors.crsCreCd}', '/exam/Form/stuExamList.do?examType=EXAM&crsCreCd=${cors.crsCreCd}')"
                style='cursor:pointer'
            </c:if>>
                <dt><spring:message code="dashboard.exam_end"/><!-- 기말고사 --></dt>
                <c:set var="exam" value="${cors.examLast}"/>
                <c:choose>
                    <c:when test="${not empty cors.examLast and exam.scoreRatio > 0}">
                        <c:choose>
                            <c:when test="${exam.examTypeCd eq 'EXAM' && not empty exam.examStartDttm}">
                                <dd>${exam.startDttm}</dd>
                                <dd><spring:message code="dashboard.exam.stare_tm"/>: ${exam.examStareTm}<spring:message
                                        code="dashboard.exam.min"/></dd>
                                <dd>
                                    <c:choose>
                                        <c:when test="${exam.scoreOpenYn eq 'Y'}"><spring:message
                                                code="dashboard.exam.score_open_y"/></c:when>
                                        <c:otherwise><spring:message code="dashboard.exam.score_open_n"/></c:otherwise>
                                    </c:choose>
                                </dd>
                                <%-- <dd>
                                       <c:choose>
                                           <c:when test="${exam.gradeViewYn eq 'Y'}"><spring:message code="dashboard.exam.grade_open_y"/></c:when>
                                           <c:otherwise><spring:message code="dashboard.exam.grade_open_n"/></c:otherwise>
                                       </c:choose>
                                   </dd> --%>
                            </c:when>
                            <c:when test="${exam.examTypeCd eq 'EXAM' && empty exam.examStartDttm}">
                                <dd>
                                    <spring:message code="crs.label.live.exam"/><spring:message
                                        code="common.ready"/>(3<spring:message
                                        code="common.schedule.now"/><spring:message code="common.announce.schedule"/>)
                                </dd>
                                <!-- 실시간 시험 준비중 (3주차 중 발표 예정) -->
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${not empty exam.insRefCd}">
                                        <c:choose>
                                            <c:when test="${exam.examTypeCd eq 'QUIZ'}">
                                                <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                        code="dashboard.cor.quiz"/>)
                                                </dd>
                                                <!-- 기타 --><!-- 퀴즈 -->
                                                <dd>${exam.insStartDttm} ~ ${exam.insEndDttm}</dd>
                                            </c:when>
                                            <c:when test="${exam.examTypeCd eq 'ASMNT'}">
                                                <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                        code="dashboard.cor.asmnt"/>)
                                                </dd>
                                                <!-- 기타 --><!-- 과제 -->
                                                <dd>${exam.insStartDttm} ~ ${exam.insEndDttm}</dd>
                                            </c:when>
                                            <c:when test="${exam.examTypeCd eq 'FORUM'}">
                                                <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                        code="dashboard.cor.forum"/>)
                                                </dd>
                                                <!-- 기타 --><!-- 토론 -->
                                                <dd>${exam.insStartDttm} ~ ${exam.insEndDttm}</dd>
                                            </c:when>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <dd><spring:message code="dashboard.cor.etc"/> (<spring:message
                                                code="common.ready"/>)
                                        </dd>
                                        <!-- 기타 (준비 중) -->
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <dd>-</dd>
                    </c:otherwise>
                </c:choose>
            </dl>

            <div class="item-btn">
                    <%--
                    <button type="button" class="btn"><spring:message code="resh.label.lect.eval" /></button> 강의평가
                    <button type="button" class="btn"><spring:message code="resh.button.lect.eval.edit" /></button> 강의평가 수정
                    <div class="tip1 right">
                        <button type="button" class="close ico icon-info" data-medi-ui="tip" data-target="tip1" title="<spring:message code="resh.label.lect.eval" /><spring:message code="common.information" />"></button>
                        <div class="description">
                            <p class="title">
                                <spring:message code="resh.label.lect.eval" /> <button type="button" class="close ico icon-cross" data-medi-ui="tip" data-target="tip1" title="Close"></button>
                            </p>
                            <p>2022.04.16 16:00 ~ 2022.04.16 18:00</p>
                        </div>
                    </div>
                    --%>
            </div>
        </div>
        <%
            }
        %>

        <div class="sch2 wf100">
            <c:forEach var="lesn" items="${lessonList}" varStatus="weekStatus">
            <c:choose>
            <c:when test="${lesn.wekClsfGbn ne '04' and lesn.wekClsfGbn ne '05'}">
            <c:set var="ingClass" value=""/>
            <c:if test="${lesn.lessonScheduleProgress eq 'PROGRESS'}">
                <c:set var="ingClass" value="state_now"/>
            </c:if>
            <c:choose>
            <c:when test="${lesn.startDtYn eq 'Y' and (lesn.prgrVideoCnt > 0 or (lesn.videoCnt > 0 and cors.grdtScYn eq 'Y'))}">
            <a href="#0"
               onclick="checkEnterMoveCrs('${lesn.crsCreCd}', '/crs/crsHomeStdRedirect.do?crsCreCd=${lesn.crsCreCd}&viewLessonScheduleId=${lesn.lessonScheduleId}');return false"
               title="<spring:message code="common.label.studying.screen.move" />"><!-- 학습화면 이동 -->
                </c:when>
                <c:when test="${lesn.startDtYn eq 'Y' and (lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03') }">
                <a href="#0"
                   onclick="checkEnterMoveCrs('${lesn.crsCreCd}', '/seminar/seminarHome/Form/stuSeminarList.do?crsCreCd=${lesn.crsCreCd}');return false"
                   title="<spring:message code="common.label.studying.screen.move" />"><!-- 학습화면 이동 -->
                    </c:when>
                    <c:otherwise>
                    <a href="#0" onclick="return false;" style="cursor: default;">
                        </c:otherwise>
                        </c:choose>
                        <c:choose>
                            <c:when test="${!(lesn.wekClsfGbn eq '02' or lesn.wekClsfGbn eq '03') and lesn.prgrVideoCnt eq 0}">
                                <c:choose>
                                    <c:when test="${lesn.startDtYn eq 'N'}">
                                        <div class="td state_wait <c:out value="${ingClass}"/>"
                                             data-label="${weekStatus.index+1}"><i class="ico opacity2"
                                                                                   title="<spring:message code="crs.label.ready" />"></i>
                                        </div>
                                        <!-- 대기 -->
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${lesn.videoCnt > 0 and cors.grdtScYn eq 'Y'}">
                                                <div class="td state_open2 <c:out value="${ingClass}"/>"
                                                     data-label="${weekStatus.index+1}"><i class="ico"
                                                                                           title="<spring:message code="std.label.study.possible" />(<spring:message code="lesson.label.stdy.prgr.n" />)"></i>
                                                </div>
                                                <!-- 학습가능 --><!-- 출결대상 아님 -->
                                            </c:when>
                                            <c:otherwise>
                                                <div class="td state_exam <c:out value="${ingClass}"/>"
                                                     data-label="${weekStatus.index+1}"><i class="ico"
                                                                                           title="<spring:message code="contents.label.null" />"></i>
                                                </div>
                                                <!-- 콘텐츠없음 -->
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${lesn.studyStatusCd eq 'COMPLETE'}">
                                <div class="td state_ok <c:out value="${ingClass}"/>"
                                     data-label="${weekStatus.index+1}"><i class="ico"
                                                                           title="<spring:message code="crs.label.end" />"></i>
                                </div>
                                <!-- 완료 -->
                            </c:when>
                            <c:when test="${lesn.studyStatusCd eq 'LATE'}">
                                <div class="td state_norm <c:out value="${ingClass}"/>"
                                     data-label="${weekStatus.index+1}"><i class="ico"
                                                                           title="<spring:message code="dashboard.state.late" />"></i>
                                </div>
                                <!-- 지각 -->
                            </c:when>
                            <c:when test="${lesn.startDtYn eq 'N'}">
                                <div class="td state_wait <c:out value="${ingClass}"/>"
                                     data-label="${weekStatus.index+1}"><i class="ico opacity2"
                                                                           title="<spring:message code="exam.label.ready" />"></i>
                                </div>
                                <!-- 대기 -->
                            </c:when>
                            <c:when test="${lesn.startDtYn eq 'Y' and lesn.endDtYn eq 'N'}">
                                <c:choose>
                                    <c:when test="${lesn.wekClsfGbn eq '02'}">
                                        <div class="td state_seminar <c:out value="${ingClass}"/>"
                                             data-label="${weekStatus.index+1}"><i class="ico"
                                                                                   title="<spring:message code="dashboard.online.seminar" />"></i>
                                        </div>
                                        <!-- 온라인 세미나 -->
                                    </c:when>
                                    <c:when test="${lesn.wekClsfGbn eq '03'}">
                                        <div class="td state_seminar <c:out value="${ingClass}"/>"
                                             data-label="${weekStatus.index+1}"><i class="ico"
                                                                                   title="<spring:message code="dashboard.offline.seminar" />"></i>
                                        </div>
                                        <!-- 오프라인 세미나 -->
                                    </c:when>
                                    <c:otherwise>
                                        <div class="td state_open2 <c:out value="${ingClass}"/>"
                                             data-label="${weekStatus.index+1}"><i class="ico"
                                                                                   title="<spring:message code="std.label.study.possible" />"></i>
                                        </div>
                                        <!-- 학습가능 -->
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:set var="auditClass" value="state_bad"/>
                                <c:if test="${cors.auditYn eq 'Y' }"><c:set var="auditClass" value="state_exam"/></c:if>
                                <div class="td ${auditClass } <c:out value="${ingClass}"/>"
                                     data-label="${weekStatus.index+1}"><i class="ico"
                                                                           title="<spring:message code="std.label.noattend" />"></i>
                                </div>
                                <!-- 결석 -->
                            </c:otherwise>
                        </c:choose>
                        <span class="blind"><spring:message code="common.label.studying.screen.move"/></span></a>
                    <!-- 학습화면이동 -->
                    </c:when>
                    <c:otherwise>
                        <spring:message code="lesson.label.exam" var="label_exam"/>
                        <spring:message code="lesson.label.mid_short" var="label_mid_short"/>
                        <spring:message code="lesson.label.mid_title" var="label_mid_title"/>
                        <spring:message code="lesson.label.final_short" var="label_final_short"/>
                        <spring:message code="lesson.label.final_title" var="label_final_title"/>

                        <c:set var="weekLabel" value="${weekStatus.index+1}"/>
                        <c:set var="weekTitle" value="${label_exam}"/>
                    <c:if test="${lesn.wekClsfGbn eq '04'}">
                        <c:set var="weekLabel" value="${label_mid_short}"/>
                        <c:set var="weekTitle" value="${label_mid_title}"/>
                    </c:if>
                    <c:if test="${lesn.wekClsfGbn eq '05'}">
                        <c:set var="weekLabel" value="${label_final_short}"/>
                        <c:set var="weekTitle" value="${label_final_title}"/>
                    </c:if>
                    <a href="#0" onclick="return false;" style="cursor: unset">
                        <div class="td state_exam" data-label="${weekLabel}"><i class="ico"
                                                                                title="${weekTitle}"></i><span
                                class="blind">${weekTitle}</span></div>
                    </a>
                    </c:otherwise>
                    </c:choose>
                    </c:forEach>
        </div>

    </section>
</c:forEach>

<script>
    // 수업계획서 보기
    function viewLessonPlan(goUrl) {
        <%
        String agentS = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "";
        String appIos = "N";
        if (agentS.indexOf("hycuapp") > -1 && (agentS.indexOf("iPhone") > -1 || agentS.indexOf("iPad") > -1)) {
            appIos = "Y";
        }
        %>
        var appIos = "<%=appIos%>";
        if (appIos == "Y") {
            document.location.href = goUrl;
        } else {
            window.open(goUrl, "lessonPLan", "scrollbars=yes,width=900,height=950,location=no,resizable=yes");
        }
    }
</script>
