<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- 관리자 공통 head -->
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>

    <script type="text/javascript">
        var EPARAM = '<c:out value="${encParams}" />';
        var SBJCT_ID = '<c:out value="${sbjctVO.sbjctId}" />';

        $(document).ready(function() {
            formatDetailDttmText();
            formatDetailPeriodText();
        });

        // 값이 없을 때 상세 화면 기본 표시값을 반환한다.
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

        // 상세 화면 일시 텍스트를 변환한다.
        function formatDetailDttmText() {
            $(".js-dttm").each(function() {
                $(this).text(emptyText(formatDttm($(this).attr("data-value"))));
            });
        }

        // 상세 화면 기간 텍스트를 변환한다.
        function formatDetailPeriodText() {
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

        // 과목개설 목록으로 이동한다.
        function viewSbjctOfringList() {
            location.href = '/crs/sbjctOfring/admSbjctOfringListView.do?encParams=' + EPARAM;
        }

        // 과목개설 수정 화면으로 이동한다.
        function viewSbjctOfringModify() {
            location.href = '/crs/sbjctOfring/admSbjctOfringRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">

    <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
    <form id="moveForm" method="post"></form>

    <%-- 관리자 상단 헤더 --%>
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <main class="common">
        <%-- 관리자 좌측 메뉴(aside) --%>
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">

                    <!-- 페이지 타이틀 -->
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 현재 메뉴명 --%>
                        <uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>

                    <div class="box">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="crs.sbjct.ofring.detail"/><%--과목개설 상세보기--%></h3>
                        </div>

                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="common.label.org"/><%--기관--%></label></li>
                                <li><c:out value="${empty sbjctVO.orgnm ? '-' : sbjctVO.orgnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.semester"/><%--학기/기수--%></label></li>
                                <li><c:out value="${empty sbjctVO.termNm ? '-' : sbjctVO.termNm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.course.division"/><%--과정구분--%></label></li>
                                <li><c:out value="${empty sbjctVO.crsGbncdnm ? '-' : sbjctVO.crsGbncdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.subject.type"/><%--과목분류--%></label></li>
                                <li><c:out value="${empty sbjctVO.sbjctTycdnm ? '-' : sbjctVO.sbjctTycdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.crsopertypecd"/><%--강의형태--%></label></li>
                                <li><c:out value="${empty sbjctVO.lctrGbncdnm ? '-' : sbjctVO.lctrGbncdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.subject.code"/><%--과목코드--%></label></li>
                                <li><c:out value="${empty sbjctVO.sbjctCd ? '-' : sbjctVO.sbjctCd}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.subject.ko"/><%--과목명(KO)--%></label></li>
                                <li><c:out value="${empty sbjctVO.sbjctnm ? '-' : sbjctVO.sbjctnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.subject.en"/><%--과목명(EN)--%></label></li>
                                <li><c:out value="${empty sbjctVO.sbjctEnnm ? '-' : sbjctVO.sbjctEnnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="common.label.decls.no"/><%--분반--%></label></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${empty sbjctVO.dvclasNo}">-</c:when>
                                        <c:otherwise><c:out value="${sbjctVO.dvclasNo}" /><spring:message code="crs.sbjct.ofring.label.class.suffix"/><%--반--%></c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.dvclas.alias"/><%--분반 별칭--%></label></li>
                                <li><c:out value="${empty sbjctVO.dvclasNcknm ? '-' : sbjctVO.dvclasNcknm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.credit"/><%--학점--%></label></li>
                                <li><c:out value="${empty sbjctVO.crdts ? '-' : sbjctVO.crdts}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.subject.description"/><%--과목설명--%></label></li>
                                <li><div class="tb_content htmlText"><c:out value="${empty sbjctVO.sbjctExpln ? '-' : sbjctVO.sbjctExpln}" escapeXml="false"/></div></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="main.common.use.yn"/><%--사용여부--%></label></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${sbjctVO.useyn eq 'Y'}"><spring:message code="common.use"/><%--사용--%></c:when>
                                        <c:when test="${sbjctVO.useyn eq 'N'}"><spring:message code="common.use.not"/><%--사용 안 함--%></c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="box">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.lctr.info"/><%--강의 정보--%></h3>
                        </div>

                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.compdv"/><%--이수구분--%></label></li>
                                <li><c:out value="${empty sbjctVO.cmcrsGbnnm ? '-' : sbjctVO.cmcrsGbnnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.label.eval.method"/><%--평가방법--%></label></li>
                                <li>
                                    <c:out value="${empty sbjctVO.evlGbncdnm ? '-' : sbjctVO.evlGbncdnm}" />
                                    <c:if test="${sbjctVO.evlGbncd eq 'PASSFAIL' and not empty sbjctVO.passfailScr}">
                                        ( <spring:message code="crs.sbjct.ofring.label.passfail.scr"/><%--PASS/FAIL--%> : <c:out value="${sbjctVO.passfailScr}" /> )
                                    </c:if>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lctr.frmt"/><%--강의형식--%></label></li>
                                <li><c:out value="${empty sbjctVO.lctrFrmtGbncdnm ? '-' : sbjctVO.lctrFrmtGbncdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lrn.cntrl"/><%--학습제어--%></label></li>
                                <li><c:out value="${empty sbjctVO.lrnCntrlGbncdnm ? '-' : sbjctVO.lrnCntrlGbncdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lctr.evl"/><%--강의 평가--%></label></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${sbjctVO.lctrEvlyn eq 'Y'}"><spring:message code="crs.sbjct.ofring.label.yes"/><%--예--%></c:when>
                                        <c:when test="${sbjctVO.lctrEvlyn eq 'N'}"><spring:message code="crs.sbjct.ofring.label.no"/><%--아니오--%></c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.lctr.prvw.wkno"/><%--강의미리보기주차--%></label></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${empty sbjctVO.lctrPrvwWkno}">-</c:when>
                                        <c:otherwise><c:out value="${sbjctVO.lctrPrvwWkno}" /><spring:message code="crs.sbjct.ofring.label.week.suffix"/><%--주차--%></c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="box">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.atndlc.info"/><%--수강 신청 정보--%></h3>
                        </div>

                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.atndlc.aply.mthd"/><%--수강신청 변경--%></label></li>
                                <li><c:out value="${empty sbjctVO.atndlcAplyMthdCdnm ? '-' : sbjctVO.atndlcAplyMthdCdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.atndlc.cert.sts"/><%--수강인증상태--%></label></li>
                                <li><c:out value="${empty sbjctVO.atndlcCertStscdnm ? '-' : sbjctVO.atndlcCertStscdnm}" /></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.limit.yn"/><%--인원제한--%></label></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${not empty sbjctVO.atndlcQuota and sbjctVO.atndlcQuota gt 0}">
                                            <spring:message code="crs.sbjct.ofring.label.yes"/><%--예--%> / <c:out value="${sbjctVO.atndlcQuota}" /><spring:message code="crs.sbjct.ofring.label.person"/><%--명--%>
                                        </c:when>
                                        <c:otherwise><spring:message code="crs.sbjct.ofring.label.no"/><%--아니오--%></c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="box">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.period.info"/><%--강의 기간 정보--%></h3>
                        </div>

                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.lecture.request.period"/><%--수강 신청 기간--%></label></li>
                                <li><span class="js-period" data-start="<c:out value='${sbjctVO.atndlcAplySdttm}' />" data-end="<c:out value='${sbjctVO.atndlcAplyEdttm}' />">-</span></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="common.label.lecture.period"/><%--강의 기간--%></label></li>
                                <li><span class="js-period" data-start="<c:out value='${sbjctVO.sbjctLctrSdttm}' />" data-end="<c:out value='${sbjctVO.sbjctLctrEdttm}' />">-</span></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.late.recg.dttm"/><%--지각 인정 일시--%></label></li>
                                <li><span class="js-dttm" data-value="<c:out value='${sbjctVO.sbjctLateRecgDttm}' />">-</span></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.score.process.period"/><%--성적 처리 기간--%></label></li>
                                <li><span class="js-period" data-start="<c:out value='${sbjctVO.mrkProcSdttm}' />" data-end="<c:out value='${sbjctVO.mrkProcEdttm}' />">-</span></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.audit.end.dttm"/><%--청강 종료 일시--%></label></li>
                                <li><span class="js-dttm" data-value="<c:out value='${sbjctVO.auditEdttm}' />">-</span></li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label><spring:message code="crs.sbjct.ofring.label.review.period"/><%--복습기간--%></label></li>
                                <li>
                                    <c:out value="${empty sbjctVO.rvwPsblGbncdnm ? '-' : sbjctVO.rvwPsblGbncdnm}" />
                                    <c:if test="${sbjctVO.rvwPsblGbncd eq 'PRD_STNG'}">
                                        : <span class="js-period" data-start="<c:out value='${sbjctVO.rvwSdttm}' />" data-end="<c:out value='${sbjctVO.rvwEdttm}' />">-</span>
                                    </c:if>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="btns">
                        <button type="button" class="btn type1" onclick="viewSbjctOfringModify();"><spring:message code="sys.button.modify"/><%--수정--%></button>
                        <button type="button" class="btn type2" onclick="viewSbjctOfringList();"><spring:message code="button.list"/><%--목록--%></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
