<%@ page import="knou.framework.common.SubjectInfo" %>
<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="fileUploader"/>
    </jsp:include>
</head>

<body class="modal-page">
    <div id="wrap">
        <div class="ui form">
            <div class="board_top">
                <%
                    String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
                %>
                <h3 class="board-title"><%=sbjctnm%></h3>
                <div class="right-area">
                    <div class="feedback-info learner-feedback-info">
                        <p class="desc">
                            <span class="dept-info"><strong>${examUserInfo.deptnm}</strong></span>
                            <span class="user-id-info"><strong>${examUserInfo.stdntNo}</strong></span>
                            <span class="user-name-info"><strong>${examUserInfo.usernm}</strong></span>
                            <span class="score">
                                <strong>
                                    <c:choose>
                                        <c:when test="${not empty examUserInfo.asmtScr}">
                                            ${examUserInfo.asmtScr}<spring:message code="forum.label.point"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </strong>
                            </span>
                        </p>
                    </div>
                </div>
            </div>

            <div id="feedbackList" class="mt10">
                <c:choose>
                    <c:when test="${not empty fdbkList}">
                        <c:forEach var="item" items="${fdbkList}" varStatus="status">
                            <div class="feedback-item mt10">
                                <div class="board_top">
                                    <h5 class="sub-title-sm">
                                        <i class="xi-comment-o icon" aria-hidden="true"></i>
                                        ${fn:substring(item.regDttm, 0, 4)}.${fn:substring(item.regDttm, 4, 6)}.${fn:substring(item.regDttm, 6, 8)} ${fn:substring(item.regDttm, 8, 10)}:${fn:substring(item.regDttm, 10, 12)}
                                    </h5>
                                </div>
                                <div class="table_list">
                                    <ul class="list">
                                        <li class="head"><label><spring:message code="forum.label.feedback"/></label></li>
                                        <li>
                                            <div class="tb_content">
                                                <div class="view_con" style="white-space:pre-wrap;word-break:break-word;max-height:200px;overflow:auto;">${item.fdbkCts}</div>
                                                <c:if test="${item.fileCnt > 0}">
                                                    <div class="mt10">
                                                        <div class="add_file_list">
                                                            <ul class="add_file">
                                                                <c:forEach var="file" items="${item.fileList}">
                                                                    <c:if test="${file.fileExt ne 'mp3'}">
                                                                        <li>
                                                                            <a href="#_" onclick="UiFileDownloader('${file.encDownParam}');return false;" class="file_down">
                                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                                <span class="text">${file.filenm}</span>
                                                                            </a>
                                                                        </li>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="flex-container m-hAuto">
                            <div class="no_content">
                                <i class="icon-cont-none ico f170"></i>
                                <span><spring:message code="team.common.empty"/></span>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="bottom-content text-center mt10">
            <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="forum.button.close"/></button>
        </div>
    </div>

    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>