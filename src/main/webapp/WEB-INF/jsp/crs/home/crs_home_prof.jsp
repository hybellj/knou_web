<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=4"/>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="">

    <jsp:include page="/WEB-INF/jsp/common/class_lnb.jsp">
        <jsp:param name="param" value="new"/>
    </jsp:include>

    <div id="container" class="ui form">

        <!-- class_top 인클루드  -->
        <jsp:include page="/WEB-INF/jsp/common/class_header.jsp"/>

        <!-- 본문 content 부분 -->
        <div class="content stu_section st2">

            <div class="ui form">
                <div class="layout2">
                    <div class="row bcNone">

                        <div class="info-right">

                            <!-- 공지글 -->
                            <div class="component33 off" data-medi-ui="more-off"
                                 data-ctrl-off="<spring:message code="common.label.view.more" />"><!-- 더보기 -->

                                <!-- 탭메뉴 -->
                                <div class="listTab2 noti" data-target="tab_contents1">
                                    <div data-target="#tab1" class="active"><fmt:message
                                            key="dashboard.notice_course"/><%-- 강의 공지--%></div>
                                    <div data-target="#tab2"><fmt:message key="dashboard.course_qna"/><%-- 강의 Q&A --%>
                                        <span class="msg_num">${not empty qnaNoAnsInfo ? qnaNoAnsInfo.noAnsCnt : 0}</span>
                                    </div>
                                    <div data-target="#tab3"><fmt:message key="dashboard.councel"/><%-- 1:1 상담 --%>
                                        <span class="msg_num">${not empty secretNoAnsInfo ? secretNoAnsInfo.noAnsCnt : 0}</span>
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
                                                    class="ion-plus"></i></button><!-- 더보기 -->
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
                                                                        <!-- 조회 -->
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
                                                    class="ion-plus"></i></button><!-- 더보기 -->
                                        </div>
                                        <div class="cont_body">
                                            <c:if test="${not empty cosQnaList}">
                                                <ul class="list_line_S2">
                                                    <c:forEach var="notice" items="${cosQnaList}" varStatus="status">
                                                        <c:if test="${status.index < 3}">
                                                            <li>
                                                                <a href="/bbs/bbsLect/Form/atclView.do?bbsCd=ALARM&crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}&tab=2"
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
                                                    class="ion-plus"></i></button><!-- 더보기 -->
                                        </div>
                                        <div class="cont_body">
                                            <c:if test="${not empty cosSecretList}">
                                                <ul class="list_line_S2">
                                                    <c:set var="secretViewYn">
                                                        <%=(SessionInfo.getAuthrtCd(request).contains("TUT") == true ? "N" : "Y") %>
                                                    </c:set>
                                                    <c:forEach var="notice" items="${cosSecretList}" varStatus="status">
                                                        <c:if test="${status.index < 3}">
                                                            <li>
                                                                <c:choose>
                                                                <c:when test="${secretViewYn eq 'Y'}">
                                                                <a href="/bbs/bbsLect/Form/atclView.do?bbsCd=ALARM&crsCreCd=${notice.crsCreCd}&bbsId=${notice.bbsId}&atclId=${notice.atclId}&tab=2"
                                                                   title="<c:out value="${notice.atclTitle}"/>">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                    <a href="javascript:alert('<spring:message code="bbs.alert.no.auth.atcl"/>')"
                                                                       title="<c:out value="${notice.atclTitle}"/>">
                                                                        </c:otherwise>
                                                                        </c:choose>
                                                                        <div class="n_tit <c:if test="${notice.viewYn eq 'Y'}">opacity7</c:if>">
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

                            <div class="info-cnt">
                                <div class="grid five columns gap10 infoIconSet color_bar" data-mobile-columns="3">

                                    <!-- 과제 -->
                                    <a class="info" href="javascript:moveAsmnt()"
                                       title="<spring:message code="crs.label.asmnt" />">
                                        <span class="tooltiptext tooltip-top"><spring:message
                                                code="crs.label.asmnt"/></span>
                                        <!-- <div class="alt_icon"><i class="icon-paper-pencil ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${profElementStatus.asmntCnt}"/></div>
                                    </a>

                                    <!-- 실기과제 -->
                                    <%-- <a class="info" href="/asmt/profAsmtListView.do" title="<spring:message code="asmt.label.practice.asmt" />">
                                    <span class="tooltiptext tooltip-top"><spring:message code="asmt.label.practice.asmt" /></span>
                                    <!-- <div class="alt_icon"><i class="icon-paper-plus ico" aria-hidden="true"></i></div> -->
                                    <div class="alt_txt"><c:out value="${profElementStatus.prctAsmntCnt}"/></div>
                                    </a> --%>

                                    <%
                                        if(SessionInfo.isKnou(request)) {
                                    %>
                                    <!-- 시험 -->
                                    <a class="info" href="javascript:moveExam('EXAM')"
                                       title="<spring:message code="crs.button.exam" />">
                                        <span class="tooltiptext tooltip-top"><spring:message
                                                code="crs.button.exam"/></span>
                                        <!-- <div class="alt_icon"><i class="icon-paper-text ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${profElementStatus.insExamCnt}"/></div>
                                    </a>
                                    <%
                                        }
                                    %>

                                    <!-- 토론 -->
                                    <a class="info" href="javascript:moveForum()"
                                       title="<spring:message code="crs.label.forum" />">
                                        <span class="tooltiptext tooltip-top"><spring:message
                                                code="crs.label.forum"/></span>
                                        <!-- <div class="alt_icon"><i class="icon-talk-talk ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${profElementStatus.forumCnt}"/></div>
                                    </a>

                                    <!-- 퀴즈 -->
                                    <a class="info" href="javascript:moveQuiz()"
                                       title="<spring:message code="crs.label.quiz" />">
                                        <span class="tooltiptext tooltip-top"><spring:message
                                                code="crs.label.quiz"/></span>
                                        <!-- <div class="alt_icon"><i class="icon-paper-check ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${profElementStatus.quizCnt}"/></div>
                                    </a>

                                    <!-- 설문 -->
                                    <a class="info" href="javascript:moveResch()"
                                       title="<spring:message code="crs.label.resch" />">
                                        <div class="tooltiptext tooltip-top"><spring:message
                                                code="crs.label.resch"/></div>
                                        <!-- <div class="alt_icon"><i class="icon-dubblebox-check ico" aria-hidden="true"></i></div> -->
                                        <div class="alt_txt"><c:out value="${profElementStatus.reschCnt}"/></div>
                                    </a>

                                    <%
                                        if(SessionInfo.isKnou(request)) {
                                    %>
                                    <!-- 세미나, 대학원 일때만 세미나가 있음 -->
                                    <c:if test="${creCrsVO.uniCd eq 'G'}">
                                        <a class="info" href="javascript:moveSeminar()"
                                           title="<spring:message code="dashboard.seminar" />">
                                            <span class="tooltiptext tooltip-top"><spring:message
                                                    code="dashboard.seminar"/></span>
                                            <!-- <div class="alt_icon"><i class="icon-microphone ico" aria-hidden="true"></i></div> -->
                                            <div class="alt_txt"><c:out value="${profElementStatus.seminarCnt}"/></div>
                                        </a>
                                    </c:if>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>

                            <div class="info-set">
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
                                                value="${lessonScheduleOrder}"/></b><spring:message
                                                code="exam.label.schedule"/></span><!-- 주차 -->
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

                                    <li class="info fcWhite bcDarkblueAlpha85">
                                        <div class="tooltiptext tooltip-top alertToggle"><spring:message
                                                code="crs.site.access.state"/><i class="ion-ios-arrow-down"></i></div>
                                        <!-- 접속현황 -->
                                        <div class="alt_icon"><i class="icon-users ico fcWhite" aria-hidden="true"></i>
                                        </div>
                                        <div class="alt_txt">${fn:length(userConnList)}<span>${stdCnt}</span></div>
                                        <!-- alert_modal -->
                                        <div class="alert_modal">
                                            <div class="sort_btn">
                                                <button type="button" onclick="sortUserConnList('USER_NM')">
                                                    <spring:message code="exam.label.user.nm"/><i
                                                        class="sort amount up icon"></i></button><!-- 이름 -->
                                                <button type="button" onclick="sortUserConnList('USER_ID')">
                                                    <spring:message code="exam.label.user.no"/><i
                                                        class="sort amount up icon"></i></button><!-- 학번 -->
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
                                                                <span class="fcGrey">${user.userId}</span>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <%
                                                                    if(SessionInfo.isKnou(request)) {
                                                                %>
                                                                <button type="button" class=""
                                                                        onclick="viewUserInfo('${user.userId}');return false;"
                                                                        title="<spring:message code="forum_ezg.button.info" />">
                                                                    <i class="xi-info-o"></i></button>
                                                                <button type="button" class=""
                                                                        onclick="viewSendMsg('${user.userId}','${user.userNm}','${user.mobileNo}','${user.email}');return false;"
                                                                        title="<spring:message code="common.button.message.send" />">
                                                                    <i class="xi-bell-o"></i></button>
                                                                <%
                                                                    }
                                                                %>
                                                            </div>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                        <!-- //alert_modal -->
                                    </li>
                                </ul>

                                <div class="grid five columns gap10 infoIconSet" data-mobile-columns="2">
                                    <%
                                        if(SessionInfo.isKnou(request)) {
                                    %>
                                    <!-- 결시원 -->
                                    <c:if test="${examAbsentPeroidYn eq 'Y' or 1==1}">
                                        <a class="info" href="javascript:moveExam('ABSENT')"
                                           title="<spring:message code="dashboard.absent" />">
                                            <span class="tooltiptext tooltip-top"
                                                  style="word-break:break-all;"><spring:message
                                                    code="dashboard.absent"/></span>
                                            <div class="alt_txt"><c:out
                                                    value="${profElementStatus.examAbsentApproveCnt}"/><span><c:out
                                                    value="${profElementStatus.examAbsentCnt}"/></span></div>
                                            <div class="alt_icon"><i class="icon-user-no ico" aria-hidden="true"></i>
                                            </div>
                                        </a>
                                    </c:if>

                                    <!-- 성적재확인 -->
                                    <c:if test="${scoreObjtPeriodYn eq 'Y' or 1==1}">
                                        <a class="info" href="javascript:moveScoreOverallObjt();"
                                           title="<spring:message code="common.label.score.reconfirm" />">
                                            <span class="tooltiptext tooltip-top"
                                                  style="<%=("".equals(SessionInfo.getLocaleKey(request)) ? "word-break:normal;" : "" )%>"><spring:message
                                                    code="common.label.score.reconfirm"/></span>
                                            <div class="alt_txt"><c:out
                                                    value="${profElementStatus.scoreObjtProcCnt}"/><span><c:out
                                                    value="${profElementStatus.scoreObjtCnt}"/></span></div>
                                            <div class="alt_icon"><i class="icon-user-question ico"
                                                                     aria-hidden="true"></i></div>
                                        </a>
                                    </c:if>

                                    <!-- 장애인지원 -->
                                    <c:if test="${dsblReqPeriodYn eq 'Y' or 1==1}">
                                        <a class="info" href="javascript:moveExam('DSBL')"
                                           title="<spring:message code="dashboard.dsbl_support" />">
                                            <span class="tooltiptext tooltip-top"
                                                  style="<%=("".equals(SessionInfo.getLocaleKey(request)) ? "word-break:normal;" : "" )%>"><spring:message
                                                    code="dashboard.dsbl_support"/></span>
                                            <div class="alt_txt"><c:out
                                                    value="${profElementStatus.examDsblReqApproveCnt}"/><span><c:out
                                                    value="${profElementStatus.examDsblReqCnt}"/></span></div>
                                            <div class="alt_icon"><i class="icon-wheelchair ico" aria-hidden="true"></i>
                                            </div>
                                        </a>
                                    </c:if>

                                    <!-- 이수위험 -->
                                    <%--
                                       <a class="info" href="javascript:void(0)" title="<spring:message code="dashboard.course.risk.danager" />">
                                        <span class="tooltiptext tooltip-top" style="<%=("".equals(SessionInfo.getLocaleKey(request)) ? "word-break:normal;" : "" )%>"><spring:message code="dashboard.course.risk.danager" /></span>
                                        <div class="alt_txt"><c:out value="${profElementStatus.stdRiskCnt}" /><span><c:out value="${profElementStatus.stdCnt}" /></span></div>
                                        <div class="alt_icon"><i class="icon-timewatch ico" aria-hidden="true"></i></div>
                                    </a>
                                     --%>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 주차목록 -->
                    <c:import url="/crs/crsProfLessonList.do">
                        <c:param name="crsCreCd" value="${curCrsCreCd}"/>
                        <c:param name="wdork" value="new"/>
                        <c:param name="lcdmsLinkYn" value="${creCrsVO.lcdmsLinkYn}"/>
                    </c:import>

                </div>
            </div>
        </div>

        <script type="text/javascript">
            var $userConnList;
            var userIdOrder = "ASC";
            var userNmOrder = "ASC";

            $(document).ready(function () {
                $userConnList = $(".u_list > li"); // 접속현황 목록
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

                    if (sortKey == "USER_ID") {
                        if (connUserId1 < connUserId2) return -1;
                        if (connUserId1 > connUserId2) return 1;
                        if (connUserId1 == connUserId2) return 0;
                    } else if (sortKey == "USER_NM") {
                        if (connUserNm1 < connUserNm2) return -1;
                        if (connUserNm1 > connUserNm2) return 1;
                        if (connUserNm1 == connUserNm2) {
                            if (connUserId1 < connUserId2) return -1;
                            if (connUserId1 > connUserId2) return 1;

                            return 0;
                        }
                    }
                });

                if (sortKey == "USER_ID") {
                    userIdOrder = (userIdOrder == "ASC") ? "DESC" : "ASC";
                    userNmOrder = "DESC";

                    if (userIdOrder == "DESC") {
                        list = list.reverse();
                    }
                } else if (sortKey == "USER_NM") {
                    userIdOrder = "DESC";
                    userNmOrder = (userNmOrder == "ASC") ? "DESC" : "ASC";

                    if (userNmOrder == "DESC") {
                        list = list.reverse();
                    }
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

                        userIdOrder = "ASC";
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

            // 메시지보내기 팝업
            function viewSendMsg(userId, userNm, mobile, email) {
                var rcvUserInfoStr = userId + ";" + userNm + ";" + mobile + ";" + email;

                window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

                var form = document.alarmForm;
                form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
                form.target = "msgWindow";
                form[name = 'alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
                form[name = 'rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
                form.submit();
            }

            // 게시판 이동
            function moveBbs(type) {
                if (moveBbsInfo != null && moveBbsInfo[type] != null) {
                    var info = moveBbsInfo[type];
                    console.log(info);
                    moveMenu('/bbs/bbsLect/atclList.do', info[0], 'ALARM', info[1], info[2]);
                }
            }

            // 과제이동
            function moveAsmnt() {
                var url = "/asmt/profAsmtListView.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
            }

            // 토론이동
            function moveForum() {
                var url = "/forum/forumLect/Form/forumList.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
            }

            // 퀴즈 이동
            function moveQuiz() {
                var url = "/quiz/profQzListView.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
            }

            // 설문이동
            function moveResch() {
                var url = "/resh/Form/reshList.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
            }

            // 세미나 이동
            function moveSeminar() {
                var url = "/seminar/seminarHome/Form/seminarList.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.appendTo("body");
                form.submit();

                $("form[name='moveform']").remove();
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

            // 시험 이동
            function moveExam(type) {
                var url = "/exam/Form/examList.do";

                var form = $("<form></form>");
                form.attr("method", "POST");
                form.attr("name", "moveform");
                form.attr("action", url);
                form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: '<c:out value="${crsCreCd}" />'}));
                form.append($('<input/>', {type: 'hidden', name: "examType", value: type}));
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