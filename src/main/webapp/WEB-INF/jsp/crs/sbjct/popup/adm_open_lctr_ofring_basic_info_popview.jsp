<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
    <script type="text/javascript">
        var SBJCT_ID = '<c:out value="${sbjctVO.sbjctId}" />';
        var EPARAM = '<c:out value="${encParams}" />';

        $(document).ready(function() {
            if("${empty message ? '' : message}" != "") {
                UiComm.showMessage("${message}", "warning").then(function() {
                    closeOpenLctrBasicInfoPop();
                });
                return;
            }
            formatPopPeriodText();
        });

        // 팝업 화면에서 값이 없을 때 표시할 기본 문자를 반환한다.
        function emptyText(value) {
            return value ? value : "-";
        }

        // yyyyMMddHHmmss 저장값을 팝업 표시 형식으로 변환한다.
        function formatDttm(value) {
            value = String(value || "").replace(/[^0-9]/g, "");
            if(value.length < 8) {
                return "";
            }
            var text = value.substring(0, 4) + "." + value.substring(4, 6) + "." + value.substring(6, 8);
            if(value.length >= 12) {
                text += " " + value.substring(8, 10) + ":" + value.substring(10, 12);
            }
            return text;
        }

        // 팝업의 공개강좌 강의기간 표시 영역을 시작일 ~ 종료일 형태로 변환한다.
        function formatPopPeriodText() {
            $(".js-period").each(function() {
                var startText = formatDttm($(this).attr("data-start"));
                var endText = formatDttm($(this).attr("data-end"));
                if(!startText && !endText) {
                    $(this).text("영구");
                    return;
                }
                $(this).text(emptyText(startText) + " ~ " + emptyText(endText));
            });
        }

        // 부모 UiDialog가 있으면 닫고, 단독 창이면 window.close를 시도한다.
        function closeOpenLctrBasicInfoPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
                return;
            }
            window.close();
        }

        // 공개강좌 미리보기 콘텐츠 URL을 새 창으로 연다.
        function openOpenLctrPreview(el) {
            var url = $(el).attr("data-url");
            if(!url) {
                return;
            }
            window.open(url, "_blank");
        }
    </script>
    <style>
        .open-lctr-pop-wrap { padding: 12px; }
        .open-lctr-pop-title { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
        .open-lctr-pop-title h3 { margin: 0; font-size: 18px; font-weight: 700; }
        .open-lctr-pop-wrap .btns { margin-top: 14px; text-align: center; }
    </style>
</head>
<body class="modal-page">
    <div class="open-lctr-pop-wrap">
        <c:if test="${empty message}">
            <c:set var="profText" value="-" />
            <c:set var="coprofText" value="-" />
            <c:set var="tutText" value="-" />
            <c:set var="assiText" value="-" />
            <c:set var="grdtnExamQstnsProfText" value="-" />
            <c:set var="grdtnExamEvalProfText" value="-" />
            <c:forEach var="adm" items="${admList}">
                <c:set var="admText"><c:out value="${empty adm.usernm ? '-' : adm.usernm}" /> / <c:out value="${empty adm.userId ? '-' : adm.userId}" /></c:set>
                <c:choose>
                    <c:when test="${adm.sbjctAdmTycd eq 'PROF'}"><c:set var="profText" value="${admText}" /></c:when>
                    <c:when test="${adm.sbjctAdmTycd eq 'COPROF'}"><c:set var="coprofText" value="${admText}" /></c:when>
                    <c:when test="${adm.sbjctAdmTycd eq 'TUT'}"><c:set var="tutText" value="${admText}" /></c:when>
                    <c:when test="${adm.sbjctAdmTycd eq 'ASSI'}"><c:set var="assiText" value="${admText}" /></c:when>
                    <c:when test="${adm.sbjctAdmTycd eq 'GRDTN_EXAM_QSTNS_PROF'}"><c:set var="grdtnExamQstnsProfText" value="${admText}" /></c:when>
                    <c:when test="${adm.sbjctAdmTycd eq 'GRDTN_EXAM_EVAL_PROF'}"><c:set var="grdtnExamEvalProfText" value="${admText}" /></c:when>
                </c:choose>
            </c:forEach>

            <div class="open-lctr-pop-title">
                <h3><c:out value="${empty sbjctVO.sbjctnm ? '-' : sbjctVO.sbjctnm}" /></h3>
                <c:if test="${not empty sbjctVO.lessonCntsUrl}">
                    <button type="button" class="btn type2" onclick="openOpenLctrPreview(this);" data-url="<c:out value='${sbjctVO.lessonCntsUrl}' />"><spring:message code="common.label.lecture.preview"/><%--강의 미리보기--%></button>
                </c:if>
            </div>

            <div class="board_top">
                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.basic.info"/><%--기본정보--%></h3>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.label.subject.code"/><%--과목코드--%></label></li>
                    <li><c:out value="${empty sbjctVO.sbjctCd ? '-' : sbjctVO.sbjctCd}" /></li>
                    <li class="head"><label><spring:message code="crs.label.crsopertypecd"/><%--강의형태--%></label></li>
                    <li><c:out value="${empty sbjctVO.lctrGbncdnm ? '-' : sbjctVO.lctrGbncdnm}" /></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.label.compdv"/><%--이수구분--%></label></li>
                    <li><c:out value="${empty sbjctVO.cmcrsGbnnm ? '-' : sbjctVO.cmcrsGbnnm}" /></li>
                    <li class="head"><label><spring:message code="common.label.decls.no"/><%--분반--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${empty sbjctVO.dvclasNo}">-</c:when>
                            <c:otherwise>
                                <c:out value="${sbjctVO.dvclasNo}" /><spring:message code="crs.sbjct.ofring.label.class.suffix"/><%--반--%>
                                <c:if test="${not empty sbjctVO.dvclasNcknm}">(<c:out value="${sbjctVO.dvclasNcknm}" />)</c:if>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.label.credit"/><%--학점--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sbjctVO.crdts and sbjctVO.crdts gt 0}"><c:out value="${sbjctVO.crdts}" /><spring:message code="crs.label.credit"/><%--학점--%></c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </li>
                    <li class="head"><label></label></li>
                    <li></li>
                </ul>
            </div>

            <div class="board_top mt30">
                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.period.info"/><%--강의 기간 정보--%></h3>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="common.label.lecture.period"/><%--강의 기간--%></label></li>
                    <li><span class="js-period" data-start="<c:out value='${sbjctVO.sbjctLctrSdttm}' />" data-end="<c:out value='${sbjctVO.sbjctLctrEdttm}' />">-</span></li>
                </ul>
            </div>

            <div class="board_top mt30">
                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.subject.manager"/><%--과목관리자--%></h3>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.prof.no"/><%--담당교수/사번--%></label></li>
                    <li><c:out value="${profText}" /></li>
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.coprof.no"/><%--공동교수/사번--%></label></li>
                    <li><c:out value="${coprofText}" /></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.tutor.no"/><%--튜터/사번--%></label></li>
                    <li><c:out value="${tutText}" /></li>
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.assistant.no"/><%--조교/사번--%></label></li>
                    <li><c:out value="${assiText}" /></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.grdtn.exam.qstns.prof.no"/><%--졸업시험출제교수/사번--%></label></li>
                    <li><c:out value="${grdtnExamQstnsProfText}" /></li>
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.grdtn.exam.eval.prof.no"/><%--졸업시험채점교수/사번--%></label></li>
                    <li><c:out value="${grdtnExamEvalProfText}" /></li>
                </ul>
            </div>
        </c:if>

        <div class="btns">
            <button type="button" class="btn type2" onclick="closeOpenLctrBasicInfoPop();"><spring:message code="button.close" /><%--닫기--%></button>
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
