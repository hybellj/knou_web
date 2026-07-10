<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<body class="class ${uiex:getTheme()}">
<div id="wrap" class="main">

    <%-- 헤더 --%>
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

    <main class="common">

        <%-- 교수 GNB --%>
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">

            <%-- 강의실 상단 영역 --%>
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

            <div class="class_sub">

                <%-- 강의실 과목 공통 정보 --%>
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="crs.title.subject.info"/><%-- 과목정보 --%></h2>
                    </div>

                    <c:choose>
                        <%-- 과목정보가 없을 때 --%>
                        <c:when test="${empty sbjctInfo}">
                            <div class="table-wrap">
                                <table class="table-type1">
                                    <tbody>
                                    <tr>
                                        <td class="t_center"><spring:message code="crs.empty.subject.info"/><%-- 과목정보가 없습니다. --%></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>

                        <%-- 과목정보가 있을 때 --%>
                        <c:otherwise>

                            <%-- 1. 상세정보 영역 --%>
                            <div class="board_top">
                                <h4 class="sub-title"><spring:message code="crs.title.subject.detail"/><%-- 상세정보 --%></h4>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.org"/><%-- 기관 --%></th>
                                        <td><c:out value="${empty sbjctInfo.orgNm ? sbjctInfo.orgId : sbjctInfo.orgNm}"/></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.year.term"/><%-- 연도/학기(기수) --%></th>
                                        <td><c:out value="${sbjctInfo.creYear}"/><spring:message code="date.year"/><%-- 년 --%>/<c:out value="${sbjctInfo.creTerm}"/><spring:message code="crs.label.term"/><%-- 학기 --%></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.subject.name"/><%-- 과목명 --%></th>
                                        <td>
                                            <c:out value="${sbjctInfo.sbjctnm}"/>
                                            <c:if test="${not empty sbjctInfo.dvclasNo}">
                                                <c:out value=" ${sbjctInfo.dvclasNo}"/><spring:message code="crs.label.dvclas.suffix"/><%-- 반 --%>
                                            </c:if>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.subject.code"/><%-- 과목코드 --%></th>
                                        <td><c:out value="${sbjctInfo.sbjctCd}"/></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.subject.type"/><%-- 과목분류 --%></th>
                                        <td>
                                            <c:set var="sbjctTycdNm" value="${sbjctInfo.sbjctTycd}"/>
                                            <c:forEach var="code" items="${sbjctTycdList}">
                                                <c:if test="${code.cd eq sbjctInfo.sbjctTycd}">
                                                    <c:set var="sbjctTycdNm" value="${code.cdnm}"/>
                                                </c:if>
                                            </c:forEach>
                                            <c:out value="${sbjctTycdNm}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.crsopertypecd"/><%-- 강의형태 --%></th>
                                        <td>
                                            <c:set var="lctrGbncdNm" value="${sbjctInfo.lctrGbncd}"/>
                                            <c:forEach var="code" items="${lctrGbncdList}">
                                                <c:if test="${code.cd eq sbjctInfo.lctrGbncd}">
                                                    <c:set var="lctrGbncdNm" value="${code.cdnm}"/>
                                                </c:if>
                                            </c:forEach>
                                            <c:out value="${lctrGbncdNm}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="common.use.yn"/><%-- 사용여부 --%></th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sbjctInfo.useYn eq 'Y'}"><spring:message code="common.use"/><%-- 사용 --%></c:when>
                                                <c:otherwise><spring:message code="common.not_use"/><%-- 미사용 --%></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.subject.description"/><%-- 과목설명 --%></th>
                                        <td class="t_left">
                                            <c:choose>
                                                <c:when test="${not empty sbjctInfo.sbjctExpln}">
                                                    <div class="form-control wmax min-height-120px padding-3">
                                                        <div class="htmlText">
                                                            <c:out value="${sbjctInfo.sbjctExpln}" escapeXml="false"/>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.low.contents"/><%-- 저화질 콘텐츠 --%></th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty sbjctInfo.lowFileNm}">
                                                    <div class="file-wrap">
                                                        <ul class="add_file">
                                                            <li>
                                                                <span class="file_down">
                                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                    <span class="text"><c:out value="${sbjctInfo.lowFileNm}"/></span>
                                                                    <c:if test="${not empty sbjctInfo.lowFileSize}">
                                                                        <span class="fileSize">(<c:out value="${sbjctInfo.lowFileSize}"/>)</span>
                                                                    </c:if>
                                                                </span>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.high.contents"/><%-- 고화질 콘텐츠 --%></th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty sbjctInfo.highFileNm}">
                                                    <div class="file-wrap">
                                                        <ul class="add_file">
                                                            <li>
                                                                <span class="file_down">
                                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                    <span class="text"><c:out value="${sbjctInfo.highFileNm}"/></span>
                                                                    <c:if test="${not empty sbjctInfo.highFileSize}">
                                                                        <span class="fileSize">(<c:out value="${sbjctInfo.highFileSize}"/>)</span>
                                                                    </c:if>
                                                                </span>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code="crs.label.play.time"/><%-- 재생시간 --%></th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty sbjctInfo.totalPlaySec and sbjctInfo.totalPlaySec > 0}">
                                                    <c:out value="${sbjctInfo.playMin}"/><spring:message code="date.minute"/><%-- 분 --%>
                                                    <c:out value="${sbjctInfo.playSec}"/><spring:message code="date.second"/><%-- 초 --%>
                                                    (<spring:message code="common.page.total"/><%-- 총 --%> <c:out value="${sbjctInfo.totalPlaySec}"/><spring:message code="date.second"/><%-- 초 --%>)
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <%-- 2. 돌발퀴즈 영역 --%>
                            <div class="table-wrap" style="margin-top:16px;">
                                <table class="table-type2">
                                    <colgroup>
                                        <col class="width-15per">
                                        <col>
                                        <col style="width:150px">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th colspan="3"><spring:message code="crs.title.surprise.quiz"/><%-- 돌발퀴즈 --%></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty quizList}">
                                            <tr>
                                                <td colspan="3" class="t_center"><spring:message code="crs.empty.surprise.quiz.info"/><%-- 돌발퀴즈 정보가 없습니다. --%></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="row" items="${quizList}">
                                                <tr>
                                                    <td class="t_center">
                                                        <c:choose>
                                                            <c:when test="${not empty row.quizSec}">
                                                                <c:out value="${row.quizSec}"/><spring:message code="date.second"/><%-- 초 --%>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-left"><c:out value="${row.quizTtl}"/></td>
                                                    <td class="t_center">
                                                        <a class="btn type2 quizPreviewBtn" href="#_" data-quiz-id="<c:out value='${row.quizId}'/>"><spring:message code="crs.button.surprise.quiz.view"/><%-- 돌발퀴즈 보기 --%></a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <%-- 3. 다국어 자막(스크립트) 영역 --%>
                            <div class="table-wrap" style="margin-top:16px;">
                                <table class="table-type2">
                                    <colgroup>
                                        <col style="width:8%">
                                        <col style="width:12%">
                                        <col>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th colspan="3"><spring:message code="crs.title.subtitle.script"/><%-- 다국어 자막 (스크립트) --%></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty srtList}">
                                            <tr>
                                                <td colspan="3" class="t_center"><spring:message code="crs.empty.subtitle.script.info"/><%-- 다국어 자막(스크립트) 정보가 없습니다. --%></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="srt" items="${srtList}" varStatus="st">
                                                <tr>
                                                    <td class="t_center" rowspan="2"><c:out value="${st.count}"/></td>
                                                    <th class="t_center"><spring:message code="crs.label.language"/><%-- 언어 --%></th>
                                                    <td class="t_left"><c:out value="${srt.langCd}"/></td>
                                                </tr>
                                                <tr>
                                                    <th class="t_center"><spring:message code="crs.label.srt.file"/><%-- SRT자막 파일 --%></th>
                                                    <td class="t_left"><c:out value="${srt.keyMsg}"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <%-- 4. 분반 별칭 관리 영역 --%>
                            <div class="board_top" style="margin-top:16px;">
                                <h3 class="board-title"><spring:message code="crs.title.dvclas.alias.management"/><%-- 분반 별칭 관리 --%></h3>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type2">
                                    <colgroup>
                                        <col style="width:18%">
                                        <col style="">
                                        <col style="width:12%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th><spring:message code="crs.label.dvclas"/><%-- 분반 --%></th>
                                        <th><spring:message code="crs.label.alias"/><%-- 별칭 --%></th>
                                        <th><spring:message code="crs.label.management"/><%-- 관리 --%></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty aliasList}">
                                            <tr>
                                                <td colspan="3" class="t_center"><spring:message code="crs.empty.dvclas.info"/><%-- 분반 정보가 없습니다. --%></td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="row" items="${aliasList}">
                                                <tr>
                                                    <td class="t_center"><c:out value="${row.dvclasNo}"/><spring:message code="crs.label.dvclas.suffix"/><%-- 반 --%></td>
                                                    <td class="t_left">
                                                        <div id="aliasView_${row.dvclasNo}">
                                                                <span id="aliasText_${row.dvclasNo}">
                                                                    <c:out value="${empty row.dvclasNcknm ? '-' : row.dvclasNcknm}"/>
                                                                </span>
                                                        </div>
                                                        <div id="aliasEdit_${row.dvclasNo}" style="display:none;">
                                                            <input type="hidden" id="originDvclasNcknm_${row.dvclasNo}" value="<c:out value='${row.dvclasNcknm}'/>"/>
                                                            <input type="text" id="dvclasNcknm_${row.dvclasNo}" value="<c:out value='${row.dvclasNcknm}'/>" class="form-control" maxlength="200"/>
                                                        </div>
                                                    </td>
                                                    <td class="t_center">
                                                        <button type="button" class="btn type2 aliasEditBtn" id="btnEdit_${row.dvclasNo}" data-dvclas-no="<c:out value='${row.dvclasNo}'/>"><spring:message code="crs.button.dvclas.alias.edit"/><%-- 분반 별칭 수정 --%></button>
                                                        <button type="button" class="btn type2 aliasSaveBtn" id="btnSave_${row.dvclasNo}" style="display:none;" data-sbjct-id="<c:out value='${row.sbjctId}'/>" data-dvclas-no="<c:out value='${row.dvclasNo}'/>"><spring:message code="common.button.save"/><%-- 저장 --%></button>
                                                        <button type="button" class="btn type2 aliasCancelBtn" id="btnCancel_${row.dvclasNo}" style="display:none;" data-dvclas-no="<c:out value='${row.dvclasNo}'/>"><spring:message code="common.button.cancel"/><%-- 취소 --%></button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>

                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var EPARAM = '<c:out value="${encParams}" />';
    var sbjctId = '<c:out value="${sbjctInfo.sbjctId}" />';

    $(function () {
        $(".quizPreviewBtn").on("click", function (e) {
            e.preventDefault();
            openQuizPreviewPop($(this).attr("data-quiz-id"));
        });
        $(".aliasEditBtn").on("click", function () {
            enterAliasEdit($(this).attr("data-dvclas-no"));
        });
        $(".aliasSaveBtn").on("click", function () {
            saveAlias($(this).attr("data-sbjct-id"), $(this).attr("data-dvclas-no"));
        });
        $(".aliasCancelBtn").on("click", function () {
            cancelAliasEdit($(this).attr("data-dvclas-no"));
        });
    });

    function normalizeDialogCloseButton() {
        setTimeout(function () {
            $(".ui-dialog:visible").last().find(".ui-dialog-titlebar-close")
                .removeAttr("title")
                .attr("aria-label", '<spring:message code="common.button.close"/><%-- 닫기 --%>');
        }, 100);
    }

    /* 공통 UiDialog 레이어 팝업: 돌발퀴즈 미리보기 */
    function openQuizPreviewPop(quizId) {
        UiDialog("sbjctinfoQuizPreviewPop", {
            title: "<spring:message code='crs.title.surprise'/><%-- 돌발 --%> <spring:message code='crs.title.quiz'/><%-- 퀴즈 --%>",
            width: 720,
            height: 600,
            url: CTX + "/sbjctinfo/quizPreview.do?quizId="
                + encodeURIComponent(quizId)
                + "&sbjctId=" + encodeURIComponent(sbjctId)
                + "&encParams=" + encodeURIComponent(EPARAM)
        });
        normalizeDialogCloseButton();
    }

    function closeDialog() {
        $("#UI_DIALOG_sbjctinfoQuizPreviewPop").dialog("close");
    }

    // 수정모드 진입
    function enterAliasEdit(dvclasNo) {
        $("#dvclasNcknm_" + dvclasNo).val($("#originDvclasNcknm_" + dvclasNo).val());
        $("#aliasView_" + dvclasNo).hide();
        $("#aliasEdit_" + dvclasNo).show();
        $("#btnEdit_" + dvclasNo).hide();
        $("#btnSave_" + dvclasNo).show();
        $("#btnCancel_" + dvclasNo).show();
    }

    // 수정 취소
    function cancelAliasEdit(dvclasNo) {
        $("#dvclasNcknm_" + dvclasNo).val($("#originDvclasNcknm_" + dvclasNo).val());
        $("#aliasEdit_" + dvclasNo).hide();
        $("#aliasView_" + dvclasNo).show();
        $("#btnSave_" + dvclasNo).hide();
        $("#btnCancel_" + dvclasNo).hide();
        $("#btnEdit_" + dvclasNo).show();
    }

    // 분반 별칭 저장
    function saveAlias(sbjctId, dvclasNo) {
        var ncknm = $("#dvclasNcknm_" + dvclasNo).val();
        var extData = {
            sbjctId: sbjctId,
            dvclasNo: dvclasNo,
            dvclasNcknm: ncknm
        };

        var param = {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall(CTX + "/sbjctinfo/aliasSave.do", param, function(res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                }
                if (res && res.result > 0) {
                    $("#originDvclasNcknm_" + dvclasNo).val(ncknm);
                    $("#aliasText_" + dvclasNo).text($.trim(ncknm) === "" ? "-" : ncknm);
                    cancelAliasEdit(dvclasNo);
                    UiComm.showMessage('<spring:message code="success.common.save"/><%-- 정상적으로 저장되었습니다. --%>', "success");
                } else {
                    UiComm.showMessage('<spring:message code="fail.common.update"/><%-- 수정이 실패하였습니다. --%>', "error");
                }
        }, function() {
                UiComm.showMessage("<spring:message code='crs.error.alias.save'/><%-- 저장 중 오류가 발생하였습니다. --%>", "error");
        }, true);
    }
</script>
</body>
</html>
