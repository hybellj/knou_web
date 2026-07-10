<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="admin ${bodyClass}">
    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <c:set var="weekCrtrExists" value="${not empty vo.atndMinPrgrt or not empty vo.lateMinPrgrt or not empty vo.lateRecgRate or not empty vo.absentRecgRate}"/>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="common.button.detailinfo"/></h3>
                            <div class="right-area">
                                <button type="button" class="btn type1" onclick="fn_edit();"><spring:message code="common.button.modify"/></button>
                                <button type="button" class="btn type2" onclick="fn_list();"><spring:message code="common.button.list"/></button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per"/>
                                    <col/>
                                    <col class="width-15per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><label><spring:message code="crs.atndc.crtr.label.org"/></label></th>
                                        <td class="t_left" colspan="3"><pre><c:out value="${empty vo.orgNm ? vo.orgnm : vo.orgNm}"/></pre></td>
                                    </tr>
                                    <tr>
                                        <th><label><spring:message code="crs.atndc.crtr.label.year"/></label></th>
                                        <td class="t_left"><pre><c:out value="${vo.haksaYear}"/></pre></td>
                                        <th><label><spring:message code="crs.atndc.crtr.label.term"/></label></th>
                                        <td class="t_left"><pre><c:out value="${empty vo.haksaTermNm ? vo.haksaTerm : vo.haksaTermNm}"/></pre></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top mt30">
                            <h3 class="board-title"><spring:message code="crs.atndc.crtr.section.criteria"/></h3>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:8%">
                                    <col style="width:3%">
                                    <col>
                                    <col style="width:15%">
                                    <col>
                                    <col style="width:5%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col" colspan="6"><spring:message code="crs.atndc.crtr.section.criteria"/></th>
                                    </tr>
                                    <tr>
                                        <th scope="col"><spring:message code="crs.atndc.crtr.label.category"/></th>
                                        <th scope="col" colspan="2"><spring:message code="crs.atndc.crtr.label.condition"/></th>
                                        <th scope="col"><spring:message code="crs.atndc.crtr.label.progress.recognition.rate"/></th>
                                        <th scope="col"><spring:message code="crs.atndc.crtr.label.attendance.criteria"/></th>
                                        <th scope="col"><spring:message code="crs.atndc.crtr.label.attendance.mark"/></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>">배속 인정</th>
                                        <td data-th="<spring:message code='crs.atndc.crtr.label.category'/>" colspan="5" class="t_left">
                                            <c:choose>
                                                <c:when test="${vo.playRateRecgYn eq 'N'}">아니오</c:when>
                                                <c:otherwise>예</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <c:choose>
                                        <c:when test="${weekCrtrExists}">
                                            <tr>
                                                <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>" rowspan="3"><spring:message code="crs.atndc.crtr.label.each.week"/></th>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>">1</td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.study.period.progress"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.progress.recognition.rate'/>" class="t_left"><spring:message code="crs.common.progress.rate"/> 100% <spring:message code="crs.atndc.crtr.label.recognition"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.criteria'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.first.progress"/> <fmt:formatNumber value="${vo.atndMinPrgrt}" pattern="0.##"/>% <spring:message code="crs.atndc.crtr.label.more.than"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.mark'/>"><span class="fcBlue"><spring:message code="crs.atndc.crtr.label.attendance"/></span></td>
                                            </tr>
                                            <tr>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>">2</td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.late.period.progress"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.progress.recognition.rate'/>" class="t_left"><spring:message code="crs.common.progress.rate"/> <fmt:formatNumber value="${vo.lateRecgRate}" pattern="0.##"/>% <spring:message code="crs.atndc.crtr.label.recognition"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.criteria'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.first.progress"/> <fmt:formatNumber value="${vo.atndMinPrgrt}" pattern="0.##"/>% <spring:message code="crs.atndc.crtr.label.less.than"/>, (1+2)<spring:message code="crs.atndc.crtr.label.first.progress"/> <fmt:formatNumber value="${vo.lateMinPrgrt}" pattern="0.##"/>% <spring:message code="crs.atndc.crtr.label.more.than"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.mark'/>"><span class="fcNot"><spring:message code="crs.atndc.crtr.label.late"/></span></td>
                                            </tr>
                                            <tr>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>">3</td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.condition'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.other"/> <spring:message code="crs.atndc.crtr.label.study.period.progress"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.progress.recognition.rate'/>" class="t_left"><spring:message code="crs.common.progress.rate"/> <fmt:formatNumber value="${vo.absentRecgRate}" pattern="0.##"/>% <spring:message code="crs.atndc.crtr.label.recognition"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.criteria'/>" class="t_left"><spring:message code="crs.atndc.crtr.label.other"/></td>
                                                <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.mark'/>"><span class="fcRed"><spring:message code="crs.atndc.crtr.label.absence"/></span></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6"><spring:message code="crs.atndc.crtr.message.empty.criteria"/></td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <table class="table-type3">
                            <colgroup>
                                <col style="width:8%">
                                <col>
                                <col>
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" colspan="4"><spring:message code="crs.atndc.crtr.formula.score"/></th>
                                </tr>
                                <tr>
                                    <th scope="col"><spring:message code="crs.atndc.crtr.label.category"/></th>
                                    <th scope="col"><spring:message code="crs.atndc.crtr.label.rate.condition"/></th>
                                    <th scope="col"><spring:message code="crs.atndc.crtr.label.attendance.score"/></th>
                                    <th scope="col"><spring:message code="crs.atndc.crtr.label.manage"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>"><span class="fcBlue"><spring:message code="crs.atndc.crtr.label.attendance"/></span></th>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.rate.condition'/>" class="t_left"><span class="fcBlue"><spring:message code="crs.atndc.crtr.label.attendance"/></span></td>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.score'/>" class="t_left"><fmt:formatNumber value="${vo.attendanceScore}" pattern="0.##"/><spring:message code="crs.atndc.crtr.label.point"/></td>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.manage'/>"></td>
                                </tr>
                                <tr>
                                    <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>"><span class="fcNot"><spring:message code="crs.atndc.crtr.label.late"/></span></th>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.rate.condition'/>" class="t_left"><span class="fcNot"><spring:message code="crs.atndc.crtr.label.late"/></span></td>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.score'/>" class="t_left"><fmt:formatNumber value="${vo.lateScore}" pattern="0.##"/><spring:message code="crs.atndc.crtr.label.point"/></td>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.manage'/>"></td>
                                </tr>
                                <tr>
                                    <th data-th="<spring:message code='crs.atndc.crtr.label.category'/>"><span class="fcRed"><spring:message code="crs.atndc.crtr.label.absence"/></span></th>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.rate.condition'/>" class="t_left"><span class="fcRed"><spring:message code="crs.atndc.crtr.label.absence"/></span></td>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.attendance.score'/>" class="t_left"><fmt:formatNumber value="${vo.absenceScore}" pattern="0.##"/><spring:message code="crs.atndc.crtr.label.point"/></td>
                                    <td data-th="<spring:message code='crs.atndc.crtr.label.manage'/>"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script type="text/javascript">
        var EPARAM = '<c:out value="${encParams}" />';
        var MENU_ID = '<c:out value="${vo.menuId}" />';
        var CTX = '<%=request.getContextPath()%>';
        var SMSTR_CHRT_ID = '<c:out value="${vo.smstrChrtId}" />';

        function fn_list() {
            location.href = fn_appendMenuId(CTX + '/atndcrtr/admAtndCrtrList.do?encParams=' + encodeURIComponent(EPARAM));
        }

        function fn_edit() {
            var addParams = UiComm.makeEncParams({ smstrChrtId: SMSTR_CHRT_ID });
            location.href = fn_appendMenuId(CTX + '/atndcrtr/admAtndCrtrWrite.do?encParams=' + encodeURIComponent(EPARAM) + '&addParams=' + encodeURIComponent(addParams));
        }

        function fn_appendMenuId(url) {
            if (!MENU_ID) {
                return url;
            }
            return url + (url.indexOf('?') > -1 ? '&' : '?') + 'menuId=' + encodeURIComponent(MENU_ID);
        }
    </script>
</body>
</html>
