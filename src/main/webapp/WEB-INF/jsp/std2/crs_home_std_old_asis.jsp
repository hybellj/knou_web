<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=4"/>

<%
    String resultErrorCode = (String) request.getAttribute("resultErrorCode");
%>
<script type="text/javascript">
    if ("fail_study_log" == "<%=(String)request.getAttribute("resultErrorCode")%>") {
        alert("<fmt:message key='dashboard.alert.studyactlog_fail'/>1");
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="">

    <jsp:include page="/WEB-INF/jsp/common/class_lnb.jsp">
        <jsp:param name="param" value="new"/>
    </jsp:include>

    <div id="container" class="ui form">

        <!-- class_top 인클루드  -->
        <jsp:include page="/WEB-INF/jsp/common/class_header.jsp"/>


        <!-- 본문 content 부분 -->
        <div class="content stu_section st2"
             style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "padding-top:0" : "")%>">

            <div class="ui form">
                <div class="layout2">
                    <div class="row bcNone">

                        <div class="info-right">

                            <!-- 공지글 -->
                            <div class="component33 off" data-medi-ui="more-off"
                                 data-ctrl-off="<spring:message code="common.label.view.more" />">

                                <!-- 탭메뉴 -->
                                <div class="listTab2 noti" data-target="tab_contents1">
                                    <div data-target="#tab1" class="active"><fmt:message
                                            key="dashboard.notice_course"/><%-- 강의 공지--%></div>
                                    <div data-target="#tab2"><fmt:message key="dashboard.course_qna"/><%-- 강의 Q&A --%>
                                        <span class="msg_num">${not empty qnaNoAnsInfo ? qnaNoAnsInfo.ansCnt : 0}/${not empty qnaNoAnsInfo ? qnaNoAnsInfo.totalCnt : 0}</span>
                                    </div>
                                    <div data-target="#tab3"><fmt:message key="dashboard.councel"/><%-- 1:1 상담 --%>
                                        <span class="msg_num">${not empty secretNoAnsInfo ? secretNoAnsInfo.ansCnt : 0}/${not empty secretNoAnsInfo ? secretNoAnsInfo.totalCnt : 0}</span>
                                    </div>
                                </div>
                                <!-- //탭메뉴 -->

                                <!-- 탭메뉴_콘텐츠 -->
                                <div class="tab_contents1">
                                    <div id="tab1" class="tab_content on">
                                        <div class="cont_header">
                                            <button class="btn-icon more"
                                                    aria-label="<spring:message code="common.label.view.more" />"
                                                    onclick="moveBbs('NOTICE');return false;"
                                                    title="<spring:message code="common.label.view.more" />"><i
                                                    class="ion-plus"></i></button>
                                        </div>
                                        <div class="cont_body">
                                            <c:if test="${not empty cosNoticeList}">
                                                <ul class="list_line_S2">
                                                    <c:forEach var="notice" items="${cosNoticeList}" varStatus="status">
                                                        <c:if test="${status.index < 3}">
                                                            <li>
                                                                <a href="/bbs/bbsLect/Form/atclView.do?bbsCd=ALARM&crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}&tab=1"
                                                                   title="<c:out value="${notice.atclTitle}"/>">
                                                                    <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
                                                                        <p class="head">
                                                                            <span>${notice.atclTitle}</span>
                                                                            <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
                                                                                <i class="ui pink circular mini label f045"></i>
                                                                            </c:if>
                                                                        </p>
                                                                    </div>
                                                                    <div class="n_date">
                                                                        <small class=""><spring:message
                                                                                code="bbs.label.view"/> : <c:out
                                                                                value="${notice.hits}"/></small>
                                                                        <small class=""><uiex:formatDate
                                                                                value="${notice.regDttm}"
                                                                                type="date"/></small>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </c:if>
                                            <c:if test="${empty cosNoticeList}">
                                                <div class="flex-container">
                                                    <!-- 등록된 내용이 없습니다. -->
                                                    <div class="cont-none"><i
                                                            class="icon-list-no ico"></i><span><fmt:message
                                                            key="common.content.not_found"/></span></div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div id="tab2" class="tab_content">
                                        <div class="cont_header">
                                            <button class="btn-icon more"
                                                    aria-label="<spring:message code="common.label.view.more" />"
                                                    onclick="moveBbs('QNA');return false;"
                                                    title="<spring:message code="common.label.view.more" />"><i
                                                    class="ion-plus"></i></button>
                                        </div>
                                        <div class="cont_body">
                                            <c:if test="${not empty cosQnaList}">
                                                <ul class="list_line_S2">
                                                    <c:forEach var="notice" items="${cosQnaList}" varStatus="status">
                                                        <c:if test="${status.index < 3}">
                                                            <li>
                                                                <a href="/bbs/bbsLect/Form/atclView.do?bbsCd=ALARM&crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}&tab=2"
                                                                   title="<c:out value="${notice.atclTitle}"/>">
                                                                    <div class="n_tit <c:if test="${notice.ansViewYn eq 'Y'}">opacity7</c:if>">
                                                                        <p class="head">
                                                                            <span>${notice.atclTitle}</span>
                                                                            <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
                                                                                <i class="ui pink circular mini label f045"></i>
                                                                            </c:if>
                                                                        </p>
                                                                    </div>

                                                                    <div class="n_date">
                                                                        <c:choose>
                                                                            <c:when test="${notice.answerYn eq 'Y'}">
                                                                                <small class="ui green small label">
                                                                                    <fmt:message key="dashboard.qna.answer"/><!-- 답변 --></small>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <small class="ui orange small label">
                                                                                    <fmt:message key="dashboard.qna.wait"/><!-- 미답변 --></small>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <small class=""><uiex:formatDate
                                                                                value="${notice.regDttm}"
                                                                                type="date"/></small>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </c:if>
                                            <c:if test="${empty cosQnaList}">
                                                <div class="flex-container">
                                                    <!-- 등록된 내용이 없습니다. -->
                                                    <div class="cont-none"><i
                                                            class="icon-list-no ico"></i><span><fmt:message
                                                            key="common.content.not_found"/></span></div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div id="tab3" class="tab_content">
                                        <div class="cont_header">
                                            <button class="btn-icon more"
                                                    aria-label="<spring:message code="common.label.view.more" />"
                                                    onclick="moveBbs('SECRET');return false;"
                                                    title="<spring:message code="common.label.view.more" />"><i
                                                    class="ion-plus"></i></button>
                                        </div>
                                        <div class="cont_body">
                                            <c:if test="${not empty cosSecretList}">
                                                <ul class="list_line_S2">
                                                    <c:forEach var="notice" items="${cosSecretList}" varStatus="status">
                                                        <c:if test="${status.index < 3}">
                                                            <li>
                                                                <a href="/bbs/bbsLect/Form/atclView.do?bbsCd=ALARM&crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}&tab=2"
                                                                   title="<c:out value="${notice.atclTitle}"/>">
                                                                    <div class="n_tit <c:if test="${notice.ansViewYn eq 'Y'}">opacity7</c:if>">
                                                                        <p class="head">
                                                                            <span>${notice.atclTitle}</span>
                                                                            <c:if test="${notice.isNew eq 'Y' and notice.viewYn ne 'Y'}">
                                                                                <i class="ui pink circular mini label f045"></i>
                                                                            </c:if>
                                                                        </p>
                                                                    </div>

                                                                    <div class="n_date">
                                                                        <c:choose>
                                                                            <c:when test="${notice.answerYn eq 'Y'}">
                                                                                <small class="ui green small label">
                                                                                    <fmt:message key="dashboard.qna.answer"/><!-- 답변 --></small>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <small class="ui orange small label">
                                                                                    <fmt:message key="dashboard.qna.wait"/><!-- 미답변 --></small>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <small class=""><uiex:formatDate
                                                                                value="${notice.regDttm}"
                                                                                type="date"/></small>
                                                                    </div>
                                                                </a>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </c:if>
                                            <c:if test="${empty cosSecretList}">
                                                <div class="flex-container">
                                                    <!-- 등록된 내용이 없습니다. -->
                                                    <div class="cont-none"><i
                                                            class="icon-list-no ico"></i><span><fmt:message
                                                            key="common.content.not_found"/></span></div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <!-- //탭메뉴_콘텐츠 -->
                            </div>
                            <!-- //공지글 -->
                        </div>

                        <div class="info-left">
                            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

                            <div class="info-cnt"
                                 style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) || "Y".equals(SessionInfo.getAuditYn(request)) ? "display:none" : "")%>">
                                <div class="grid five columns gap10 infoIconSet color_bar" data-mobile-columns="3">

                                    <!-- 출결 -->
                                    <a href="nolink" class="info" onclick="return false;">
                                        <span class="tooltiptext tooltip-top"><spring:message
                                                code="dashboard.cor.attend"/></span><!-- 출결 -->
                                        <!-- <div class="alt_icon"><i class="icon-paper-check ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${JoinStatus.attendJoinCnt}"/><span><c:out
                                                value="${JoinStatus.attendCnt}"/></span></div>
                                    </a>

                                    <!-- 과제 -->
                                    <c:if test="${JoinStatus.asmntCnt > 0}">
                                        <a class="info" href="/asmt/stu/listView.do?crsCreCd=${crsCreCd}"
                                           title="<spring:message code="common.label.asmnt" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="common.label.asmnt"/></span><!-- 과제 -->
                                            <!-- <div class="alt_icon"><i class="icon-paper-pencil ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out value="${JoinStatus.asmntJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.asmntCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                    <!-- 실기과제 -->
                                    <%-- <c:if test="${JoinStatus.prctAsmntCnt > 0}">
                                        <a class="info" href="/asmt/stu/listView.do" title="<spring:message code="asmt.label.practice.asmt" />">
                                        <span class="tooltiptext tooltip-top"><spring:message code="asmt.label.practice.asmt" /></span><!-- 실기과제 -->
                                        <!-- <div class="alt_icon"><i class="icon-paper-plus ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${JoinStatus.prctAsmntJoinCnt}"/><span><c:out value="${JoinStatus.prctAsmntCnt}"/></span></div>
                                        </a>
                                    </c:if> --%>

                                    <!-- 시험 -->
                                    <c:if test="${JoinStatus.insExamCnt > 0}">
                                        <a class="info"
                                           href="/exam/Form/stuExamList.do?crsCreCd=${crsCreCd}&examType=EXAM"
                                           title="<spring:message code="crs.button.exam" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="crs.button.exam"/></span><!-- 시험 -->
                                            <!-- <div class="alt_icon"><i class="icon-paper-text ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out
                                                    value="${JoinStatus.insExamJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.insExamCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                    <!-- 토론 -->
                                    <c:if test="${JoinStatus.forumCnt > 0}">
                                        <a class="info" href="/forum/forumHome/Form/forumList.do?crsCreCd=${crsCreCd}"
                                           title="<spring:message code="dashboard.cor.forum" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="dashboard.cor.forum"/></span><!-- 토론 -->
                                            <!-- <div class="alt_icon"><i class="icon-talk-talk ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out value="${JoinStatus.forumJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.forumCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                    <!-- 퀴즈 -->
                                    <c:if test="${JoinStatus.quizCnt > 0}">
                                        <a class="info" href="/quiz/Form/stuQuizList.do?crsCreCd=${crsCreCd}"
                                           title="<spring:message code="dashboard.cor.quiz" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="dashboard.cor.quiz"/></span><!-- 퀴즈 -->
                                            <!-- <div class="alt_icon"><i class="icon-paper-check ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out value="${JoinStatus.quizJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.quizCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                    <!-- 설문 -->
                                    <c:if test="${JoinStatus.reschCnt > 0}">
                                        <a class="info" href="/resh/Form/stuReshList.do?crsCreCd=${crsCreCd}"
                                           title="<spring:message code="dashboard.cor.resch" />">
                                            <div class="tooltiptext tooltip-top"><spring:message
                                                    code="dashboard.cor.resch"/></div><!-- 설문 -->
                                            <!-- <div class="alt_icon"><i class="icon-dubblebox-check ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out value="${JoinStatus.reschJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.reschCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                    <c:if test="${JoinStatus.alwaysExamCnt > 0}">
                                        <a class="info"
                                           href="/exam/Form/stuExamList.do?crsCreCd=${crsCreCd}&examType=ADMISSION"
                                           title="<spring:message code="dashboard.cor.admission" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="dashboard.cor.admission"/></span><!-- 수시 -->
                                            <!-- <div class="alt_icon"><i class="icon-paper-text ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out
                                                    value="${JoinStatus.alwaysExamJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.alwaysExamCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                    <!-- 세미나, 대학원 일때만 세미나가 있음 -->
                                    <c:if test="${creCrsVO.uniCd eq 'G' and JoinStatus.seminarCnt > 0}">
                                        <a class="info"
                                           href="/seminar/seminarHome/Form/stuSeminarList.do?crsCreCd=${crsCreCd}"
                                           title="<spring:message code="dashboard.seminar" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="dashboard.seminar"/></span><!-- 세미나 -->
                                            <!-- <div class="alt_icon"><i class="icon-microphone ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out
                                                    value="${JoinStatus.seminarJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.seminarCnt}"/></span></div>
                                        </a>
                                    </c:if>

                                </div>
                            </div>

                            <div class="info-set"
                                 style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
                                <ul class="grid two columns gap10 infoIconSet" data-mobile-columns="2">
                                    <c:set var="lessonScheduleOrder" value="-"/>
                                    <c:if test="${not empty crsHomeCurrentWeek}">
                                        <c:choose>
                                            <c:when test="${crsHomeCurrentWeek.lessonScheduleOrderMin eq crsHomeCurrentWeek.lessonScheduleOrderMax}">
                                                <c:set var="lessonScheduleOrder"
                                                       value="${crsHomeCurrentWeek.lessonScheduleOrderMin}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="lessonScheduleOrder"
                                                       value="${crsHomeCurrentWeek.lessonScheduleOrderMin}~${crsHomeCurrentWeek.lessonScheduleOrderMax}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <fmt:parseDate var="lessonStartDtFmt" pattern="yyyyMMdd"
                                                       value="${crsHomeCurrentWeek.lessonStartDtMin}"/>
                                        <fmt:formatDate var="lessonStartDt" pattern="yyyy.MM.dd"
                                                        value="${lessonStartDtFmt}"/>
                                        <fmt:parseDate var="lessonEndDtFmt" pattern="yyyyMMdd"
                                                       value="${crsHomeCurrentWeek.lessonEndDtMax}"/>
                                        <fmt:formatDate var="lessonEndDt" pattern="MM.dd" value="${lessonEndDtFmt}"/>
                                    </c:if>
                                    <li class="info fcWhite bcPurpleAlpha85">
                                        <span class="tooltiptext tooltip-top"><b><c:out
                                                value="${lessonScheduleOrder}"/></b><spring:message code="common.week"/></span>
                                        <!-- 주차 -->
                                        <div class="alt_icon">
                                            <i class="icon-calender-check ico fcWhite" aria-hidden="true"></i>
                                        </div>
                                        <div class="alt_txt flex-item">
                                            <c:if test="${not empty crsHomeCurrentWeek}">
                                                <small class=""><c:out value="${lessonStartDt}"/> ~ <c:out
                                                        value="${lessonEndDt}"/></small>
                                            </c:if>
                                        </div>
                                    </li>
                                    <li class="info fcWhite bcDarkblueAlpha85 connStat">
                                        <div class="tooltiptext tooltip-top alertToggle"><spring:message
                                                code="crs.site.access.state"/> <i class="ion-ios-arrow-down"></i></div>
                                        <!-- 접속현황 -->
                                        <div class="alt_icon"><i class="icon-users ico fcWhite" aria-hidden="true"></i>
                                        </div>
                                        <div class="alt_txt">${fn:length(userConnList)}<span>${stdCnt}</span></div>
                                        <!-- alert_modal -->
                                        <div class="alert_modal">
                                            <div class="sort_btn">
                                                <button type="button" onclick="sortUserConnList('USER_NM')">
                                                    <spring:message code="common.name"/><i
                                                        class="sort amount up icon"></i></button><!-- 이름 -->
                                            </div>
                                            <div class="scrollbox">
                                                <ul class="u_list" id="userConnList">
                                                    <c:forEach var="user" items="${userConnList}">
                                                        <li data-conn-user-no="${user.userId}"
                                                            data-conn-user-nm="${user.userNm}">
                                                            <div class="initial-img sm bcLgrey">
                                                                <c:if test="${not empty user.phtFile}">
                                                                    <img src="${user.phtFile}" alt="photo">
                                                                </c:if>
                                                                <c:if test="${empty user.phtFile}">
                                                                    <img src="/webdoc/img/icon-hycu-symbol-grey.svg"
                                                                         alt="photo">
                                                                </c:if>
                                                            </div>
                                                            <div>
                                                                <span class="u_name">${user.userNm}</span>
                                                            </div>
                                                            <div class="btn_wrap">
                                                            </div>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                        <!-- //alert_modal -->
                                    </li>
                                </ul>

                                <%
                                    if(SessionInfo.isKnou(request)) { // 한사대만
                                %>
                                <div class="grid five columns gap10 infoIconSet" data-mobile-columns="2"
                                     style="<%=("Y".equals(SessionInfo.getAuditYn(request)) ? "display:none" : "") %>">
                                    <!-- 결시원 -->
                                    <c:if test="${examAbsentPeroidYn eq 'Y' or 1==1}">
                                        <a class="info"
                                           href="/exam/Form/stuExamList.do?crsCreCd=${crsCreCd}&examType=ABSENT"
                                           title="<spring:message code="dashboard.absent" />">
                                            <span class="tooltiptext tooltip-top"
                                                  style="word-break:break-all;"><spring:message
                                                    code="dashboard.absent"/></span><!-- 결시원 -->
                                            <div class="alt_txt"><c:out
                                                    value="${JoinStatus.examAbsentJoinCnt}"/><span><c:out
                                                    value="${JoinStatus.examAbsentCnt}"/></span></div>
                                            <div class="alt_icon"><i class="icon-user-no ico" aria-hidden="true"></i>
                                            </div>
                                        </a>
                                    </c:if>

                                    <!-- 성적재확인 -->
                                    <c:if test="${scoreObjtPeriodYn eq 'Y' or 1==1}">
                                        <a class="info" href="javascript:moveScoreOverallObjt()"
                                           title="<spring:message code="common.label.score.reconfirm" />">
                                            <span class="tooltiptext tooltip-top"
                                                  style="<%=("".equals(SessionInfo.getLocaleKey(request)) ? "word-break:normal;" : "" )%>"><spring:message
                                                    code="common.label.score.reconfirm"/></span><!-- 재확인 -->
                                            <div class="alt_txt"><c:out
                                                    value="${JoinStatus.scoreObjtProcCnt}"/><span><c:out
                                                    value="${JoinStatus.scoreObjtCnt}"/></span></div>
                                            <div class="alt_icon"><i class="icon-user-question ico"
                                                                     aria-hidden="true"></i></div>
                                        </a>
                                    </c:if>

                                    <!-- 장애인지원 -->
                                    <c:if test="${dsblReqPeriodYn eq 'Y'}">
                                        <a class="info"
                                           href="/exam/Form/stuExamList.do?crsCreCd=${crsCreCd}&examType=DSBL"
                                           title="<spring:message code="dashboard.dsbl_support" />"><!-- 장애인지원 -->
                                            <span class="tooltiptext tooltip-top"
                                                  style="<%=("".equals(SessionInfo.getLocaleKey(request)) ? "word-break:normal;" : "" )%>"><spring:message
                                                    code="dashboard.dsbl_support"/></span><!-- 장애인지원 -->
                                            <div class="alt_txt"><c:out
                                                    value="${JoinStatus.examDsblReqApproveCnt}"/><span><c:out
                                                    value="${JoinStatus.examDsblReqCnt}"/></span></div>
                                            <div class="alt_icon"><i class="icon-wheelchair ico" aria-hidden="true"></i>
                                            </div>
                                        </a>
                                    </c:if>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>

                    <!-- 주차목록 -->
                    <c:import url="/crs/crsStuLessonList.do">
                        <c:param name="crsCreCd" value="${crsCreCd}"/>
                        <c:param name="stdNo" value="${stdNo}"/>
                    </c:import>

                </div>
            </div>
        </div>

        <script type="text/javascript">
            var $userConnList;
            var userNmOrder = "ASC";

            $(document).ready(function () {
                $userConnList = $(".u_list > li"); // 접속현황 목록
            });

            // 활동 로그 등록
            $(".connStat").on("click", function (e) {
                if ($(this).children("div.tooltiptext.tooltip-top.alertToggle").hasClass("on")) {
                    var url = "/logLesson/saveLessonActnHsty.do";
                    var data = {
                        actnHstyCd: "LECTURE_HOME"
                        , actnHstyCts: "<spring:message code='crs.site.access.state.check' />" // <!-- 접속현황 확인 -->
                        , crsCreCd: "${crsCreCd}"
                    };

                    ajaxCall(url, data, function (data) {
                        if (data.result > 0) {
                        } else {
                            alert(data.message);
                        }
                    }, function (xhr, status, error) {
                        console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                    });
                }
            });

            // 접속현황 목록 정렬
            function sortUserConnList(sortKey) {
                if ($userConnList.length == 0) return;
                var list = [];

                $.each($userConnList, function () {
                    list.push(this);
                });

                // 오름차순 정렬
                list.sort(function (a, b) {
                    var connUserId1 = $(a).data("connUserId");
                    var connUserId2 = $(b).data("connUserId");
                    var connUserNm1 = $(a).data("connUserNm");
                    var connUserNm2 = $(b).data("connUserNm");

                    if (connUserNm1 < connUserNm2) return -1;
                    if (connUserNm1 > connUserNm2) return 1;
                    if (connUserNm1 == connUserNm2) {
                        if (connUserId1 < connUserId2) return -1;
                        if (connUserId1 > connUserId2) return 1;

                        return 0;
                    }
                });

                userNmOrder = (userNmOrder == "ASC") ? "DESC" : "ASC";

                if (userNmOrder == "DESC") {
                    list = list.reverse();
                }

                $("#userConnList").empty();
                $.each(list, function () {
                    $("#userConnList").append(this);
                });
            }

            $(".listTab2 > * ").on('click', function (e) {
                this.parentNode.querySelectorAll(".listTab2 > * ").forEach(elem => {
                    elem.classList.remove("active");
                });
                $(this).addClass("active");

                [...document.querySelector("." + this.parentNode.dataset.target).children].map(elem => elem.classList.remove("on"));
                $($(this).data('target')).addClass("on");

                if (this.parentNode.parentNode.classList.contains("off")) {
                    this.parentNode.parentNode.classList.remove("off");
                }
            });

            var alertToggleClose = false;
            $(".alertToggle").unbind('click').bind('click', function (e) {
                if ($(this).hasClass("on")) {
                    $(this).removeClass("on");
                    alertToggleClose = false;
                } else {
                    if (!alertToggleClose) {
                        $(this).addClass("on");
                        $('.alert_modal').slideToggle();

                        // 정렬전 원본 리스트 세팅
                        $("#userConnList").empty();
                        $.each($userConnList, function () {
                            $("#userConnList").append(this);
                        });

                        userNmOrder = "ASC";
                    }

                    alertToggleClose = false;
                }
            });

            // 외부영역 클릭 시 접속현황 닫기
            $(document).off("mouseup.alertModal").on("mouseup.alertModal", function (e) {
                var alertModal = e.target.closest(".alert_modal");

                if (!alertModal) {
                    if ($('.alert_modal').is(':visible') == true) {
                        $(".alertToggle").removeClass("on");
                        $('.alert_modal').slideUp();
                        alertToggleClose = true;

                        setTimeout(function () {
                            alertToggleClose = false;
                        }, 200);
                    }
                }
            });

            // 게시판 이동
            function moveBbs(type) {
                if (moveBbsInfo != null && moveBbsInfo[type] != null) {
                    var info = moveBbsInfo[type];
                    moveMenu('/bbs/bbsLect/atclList.do', info[0], null, info[1], info[2]);
                }
            }

            // 성적재확인신청 이동
            function moveScoreOverallObjt() {
                var url = "/score/scoreOverallLect/Form/scoreOverallObjtMain.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
            }
        </script>

        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div>
</div>
</body>
</html>