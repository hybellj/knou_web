<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
    </jsp:include>
    <script type="text/javascript">
    var EPARAM = '<c:out value="${encParams}" />';
    var dialog;

    // 학습자 화면 이동 시 encParams를 우선 유지하고, 없을 때만 과목 ID를 fallback으로 전달한다.
    function buildLearnerUrl(path, dscsId) {
        var url = path;
        if (dscsId) {
            url += "?dscsId=" + encodeURIComponent(dscsId);
        }
        if (EPARAM) {
            url += (url.indexOf("?") > -1 ? "&" : "?") + "encParams=" + encodeURIComponent(EPARAM);
        } else if ("${dscsVO.sbjctId}" != "") {
            url += (url.indexOf("?") > -1 ? "&" : "?") + "sbjctId=" + encodeURIComponent("${dscsVO.sbjctId}");
        }
        return url;
    }

    // 토론 목록으로 이동한다.
    function viewDscsList() {
        location.href = buildLearnerUrl("/forum2/forumHome/Form/forumList.do", "");
    }

    // 토론방으로 이동한다.
    function moveToBbs() {
        location.href = buildLearnerUrl("/forum2/forumHome/Form/stdntBbsView.do", "${dscsVO.dscsId}");
    }

    // 팀 구성원을 팝업을 띄운다.
    function teamMemberView(teamId) {
        if (!teamId) {
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error");
            return;
        }
        var url = "/forum2/forumHome/teamMemberList.do";
        url += "?teamId=" + encodeURIComponent(teamId);
        url += "&encParams=" + encodeURIComponent(EPARAM);
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.label.team.member.view' />",
            width: 500,
            height: 500,
            url: url
        });
    }

    // 피드백 팝업을 띄운다.
    function feedbackView() {
        var queryString = $("#feedbackForm").serialize();
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.label.feedback'/>",
            width: 800,
            height: 600,
            url: "/forum2/forumHome/dscsFdbkPop.do?" + queryString + "&encParams=" + encodeURIComponent(EPARAM),
            modal: true
        });
    }
    </script>
</head>
<body class="class ${uiex:getTheme()}">
    <form id="feedbackForm" method="post">
        <input type="hidden" name="dscsId" value="${learnerFeedbackDscsId}">
        <input type="hidden" name="teamId" value="${learnerTeamId}">
        <input type="hidden" name="sbjctId" value="${dscsVO.sbjctId}">
    </form>

    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>

            <div id="content" class="content-wrap common">
                <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

                <div class="class_sub">
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code="forum.label.forum"/></h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="mw120 select"><a href="javascript:void(0)"><spring:message code='forum.label.forum.info.ptcp' /></a></li><%--토론정보 및 참여--%>
                                <li class="mw120"><a href="javascript:void(0)" onclick="moveToBbs()"><spring:message code='forum.label.forum.bbs'/></a></li> <%-- 토론방 --%>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code='forum.label.forum'/></h3>
                            <div class="right-area">
                                <c:if test="${dscsVO.dscsUnitTycd eq 'TEAM' and not empty learnerTeamId}">
                                    <button type="button" class="btn type2" onclick="teamMemberView('${learnerTeamId}')"><spring:message code='forum.button.team.member'/></button><%--팀 구성원--%>
                                </c:if>
                                <button type="button" class="btn type2" onclick="viewDscsList()"><spring:message code='forum.label.list'/></button><%--목록--%>
                            </div>
                        </div>

                        <jsp:include page="/WEB-INF/jsp/forum2/common/dscs_info_inc.jsp" />

                        <div class="board_top">
                            <h4 class="sub-title"><spring:message code='forum.label.forum.ptcp'/></h4><%--토론참여--%>
                            <div class="right-area">
                                <button type="button" class="btn basic small" onclick="feedbackView()"><spring:message code='forum.label.feedback'/>/<c:out value="${myJoinUserVO.dscsFdbkCnt}" default="0"/></button><%--피드백--%>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${learnerJoined}">
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-10per">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><spring:message code='forum.label.join.dt'/></th><%--참여일시--%>
                                        <td><uiex:formatDate value="${myJoinUserVO.regDttm}" type="datetime2"/></td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code='forum.label.status.join'/></th><%--참여현황--%>
                                        <td><spring:message code='forum.label.forum.atcl'/><%--토론 글--%> : <c:out value="${myJoinUserVO.actlCnt}" default="0"/>
                                            / <spring:message code='forum.label.forum.cmnt'/><%--댓글--%> : <c:out value="${myJoinUserVO.cmntCnt}" default="0"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code='forum.label.eval.score'/></th><%--평가점수--%>
                                        <td><c:out value="${myJoinUserVO.scr}" default="-"/></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            </c:when>
                            <c:otherwise>
                            <div class="msg-box">
                                <p class="txt"><strong><spring:message code='forum.label.guide'/><%--안내--%> : </strong><spring:message code='forum.label.ptcp.guide.message'/></p><%--토론 참여 전입니다. 토론 참여하시기 바랍니다.--%>
                            </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="bottom_btn mt20 text-center">
                            <button type="button" class="btn type2" onclick="moveToBbs()"><spring:message code='forum.label.forum.bbs'/><%--토론방--%></button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
