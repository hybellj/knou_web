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
                    closeSbjctOfringBasicInfoPop();
                });
                return;
            }
            formatPopDttmText();
            formatPopPeriodText();
        });

        // 값이 없을 때 팝업 기본 표시값을 반환한다.
        function emptyText(value) {
            return value ? value : "-";
        }

        // yyyyMMddHHmmss 값을 yyyy.MM.dd HH:mm 형식으로 변환한다.
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

        // 팝업 일시 텍스트를 변환한다.
        function formatPopDttmText() {
            $(".js-dttm").each(function() {
                $(this).text(emptyText(formatDttm($(this).attr("data-value"))));
            });
        }

        // 팝업 기간 텍스트를 변환한다.
        function formatPopPeriodText() {
            $(".js-period").each(function() {
                var startText = formatDttm($(this).attr("data-start"));
                var endText = formatDttm($(this).attr("data-end"));
                if(!startText && !endText) {
                    $(this).text("-");
                    return;
                }
                $(this).text(emptyText(startText) + " ~ " + emptyText(endText));
            });
        }

        // 부모 UiDialog가 있으면 닫고, 단독 창이면 window.close를 시도한다.
        function closeSbjctOfringBasicInfoPop() {
            if(window.parent && window.parent !== window && typeof window.parent.closeDialog === "function") {
                window.parent.closeDialog();
                return;
            }
            window.close();
        }

        // 과목개설 상세 화면으로 이동한다.
        function viewSbjctOfringDetail() {
            if(window.parent && window.parent !== window && typeof window.parent.viewSbjctOfringDetail === "function") {
                window.parent.viewSbjctOfringDetail(SBJCT_ID);
                return;
            }
            location.href = "/crs/sbjctOfring/admSbjctOfringDetailView.do?sbjctId=" + encodeURIComponent(SBJCT_ID || "") + "&encParams=" + EPARAM;
        }
    </script>
    <style>
        .ofring-pop-wrap { padding: 12px; }
        .ofring-pop-title { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
        .ofring-pop-title h3 { margin: 0; font-size: 18px; font-weight: 700; }
        .ofring-pop-wrap .btns { margin-top: 14px; text-align: center; }
    </style>
</head>
<body class="modal-page">
    <div class="ofring-pop-wrap">
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

            <div class="ofring-pop-title">
                <h3>
                    <c:out value="${empty sbjctVO.sbjctnm ? '-' : sbjctVO.sbjctnm}" />
                    <c:if test="${not empty sbjctVO.dvclasNo}">
                        / <c:out value="${sbjctVO.dvclasNo}" /><spring:message code="crs.sbjct.ofring.label.class.suffix"/><%--반--%>
                        <c:if test="${not empty sbjctVO.dvclasNcknm}">(<c:out value="${sbjctVO.dvclasNcknm}" />)</c:if>
                    </c:if>
                </h3>
                <button type="button" class="btn type2" onclick="viewSbjctOfringDetail();"><spring:message code="crs.button.go.lecture"/><%--강의실 입장--%></button>
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
                    <li><c:out value="${empty sbjctVO.crdts ? '-' : sbjctVO.crdts}" /><c:if test="${not empty sbjctVO.crdts}"><spring:message code="crs.label.credit"/><%--학점--%></c:if></li>
                    <li class="head"><label></label></li>
                    <li></li>
                </ul>
            </div>

            <div class="board_top mt30">
                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.lctr.info"/><%--강의 정보--%></h3>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lctr.evl"/><%--강의평가--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${sbjctVO.lctrEvlyn eq 'Y'}"><spring:message code="crs.sbjct.ofring.label.yes"/><%--예--%></c:when>
                            <c:when test="${sbjctVO.lctrEvlyn eq 'N'}"><spring:message code="crs.sbjct.ofring.label.no"/><%--아니오--%></c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </li>
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lctr.frmt"/><%--강의형식--%></label></li>
                    <li><c:out value="${empty sbjctVO.lctrFrmtGbncdnm ? '-' : sbjctVO.lctrFrmtGbncdnm}" /></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lrn.cntrl"/><%--학습제어--%></label></li>
                    <li><c:out value="${empty sbjctVO.lrnCntrlGbncdnm ? '-' : sbjctVO.lrnCntrlGbncdnm}" /></li>
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lctr.prvw.wkno"/><%--강의미리보기주차--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${empty sbjctVO.lctrPrvwWkno}">-</c:when>
                            <c:otherwise><c:out value="${sbjctVO.lctrPrvwWkno}" /><spring:message code="crs.sbjct.ofring.label.week.suffix"/><%--주차--%></c:otherwise>
                        </c:choose>
                    </li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.certificate.print.use"/><%--수료증 출력사용--%></label></li>
                    <li>-</li>
                    <li class="head"><label><spring:message code="crs.completion.condition"/><%--수료 조건--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sbjctVO.fnshScr}"><c:out value="${sbjctVO.fnshScr}" /></c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>

            <div class="board_top mt30">
                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.atndlc.info"/><%--수강 신청 정보--%></h3>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.atndlc.aply.mthd"/><%--수강신청 변경--%></label></li>
                    <li><c:out value="${empty sbjctVO.atndlcAplyMthdCdnm ? '-' : sbjctVO.atndlcAplyMthdCdnm}" /></li>
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.atndlc.cert.sts"/><%--수강인증상태--%></label></li>
                    <li><c:out value="${empty sbjctVO.atndlcCertStscdnm ? '-' : sbjctVO.atndlcCertStscdnm}" /></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.limit.yn"/><%--인원제한--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sbjctVO.atndlcQuota and sbjctVO.atndlcQuota gt 0}"><spring:message code="crs.sbjct.ofring.label.yes"/><%--예--%></c:when>
                            <c:otherwise><spring:message code="crs.sbjct.ofring.label.no"/><%--아니오--%></c:otherwise>
                        </c:choose>
                    </li>
                    <li class="head"><label><spring:message code="common.label.students"/><%--수강생--%></label></li>
                    <li>
                        <c:choose>
                            <c:when test="${not empty sbjctVO.atndlcQuota and sbjctVO.atndlcQuota gt 0}">
                                <c:out value="${sbjctVO.atndlcQuota}" /><spring:message code="crs.sbjct.ofring.label.person"/><%--명--%>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>

            <div class="board_top mt30">
                <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.period.info"/><%--강의 기간 정보--%></h3>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.lecture.request.period"/><%--수강 신청 기간--%></label></li>
                    <li><span class="js-period" data-start="<c:out value='${sbjctVO.atndlcAplySdttm}' />" data-end="<c:out value='${sbjctVO.atndlcAplyEdttm}' />">-</span></li>
                    <li class="head"><label><spring:message code="common.label.lecture.period"/><%--강의 기간--%></label></li>
                    <li><span class="js-period" data-start="<c:out value='${sbjctVO.sbjctLctrSdttm}' />" data-end="<c:out value='${sbjctVO.sbjctLctrEdttm}' />">-</span></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.audit.end.dttm"/><%--청강 종료 일시--%></label></li>
                    <li><span class="js-dttm" data-value="<c:out value='${sbjctVO.auditEdttm}' />">-</span></li>
                    <li class="head"><label><spring:message code="crs.score.process.period"/><%--성적 처리 기간--%></label></li>
                    <li><span class="js-period" data-start="<c:out value='${sbjctVO.mrkProcSdttm}' />" data-end="<c:out value='${sbjctVO.mrkProcEdttm}' />">-</span></li>
                </ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="crs.sbjct.ofring.label.review.period"/><%--복습기간--%></label></li>
                    <li>
                        <c:out value="${empty sbjctVO.rvwPsblGbncdnm ? '-' : sbjctVO.rvwPsblGbncdnm}" />
                        <c:if test="${sbjctVO.rvwPsblGbncd eq 'PRD_STNG'}">
                            : <span class="js-period" data-start="<c:out value='${sbjctVO.rvwSdttm}' />" data-end="<c:out value='${sbjctVO.rvwEdttm}' />">-</span>
                        </c:if>
                    </li>
                    <li class="head"><label></label></li>
                    <li></li>
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
            <button type="button" class="btn type2" onclick="closeSbjctOfringBasicInfoPop();"><spring:message code="button.close" /></button><%-- 닫기 --%>
        </div>
    </div>
    <script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
