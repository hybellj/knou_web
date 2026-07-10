<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>

    <script type="text/javascript">
        var EPARAM = '<c:out value="${encParams}" />';
        var SBJCT_ID = '<c:out value="${sbjctVO.sbjctId}" />';

        $(document).ready(function() {
            formatDetailPeriodText();
        });

        // 상세 화면에서 값이 없을 때 표시할 기본 문자를 반환한다.
        function emptyText(value) {
            return value ? value : "-";
        }

        // yyyyMMddHHmmss 저장값을 상세 화면 표시 형식으로 변환한다.
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

        // 공개강좌 강의기간 표시 영역을 시작일 ~ 종료일 형태로 변환한다.
        function formatDetailPeriodText() {
            $(".js-period").each(function() {
                var startText = formatDttm($(this).attr("data-start"));
                var endText = formatDttm($(this).attr("data-end"));
                if(!startText && !endText) {
                    $(this).text("<spring:message code='crs.sbjct.ofring.label.permanent'/><%--영구--%>");
                    return;
                }
                $(this).text(emptyText(startText) + " ~ " + emptyText(endText));
            });
        }

        // 공개강좌개설 목록으로 이동한다.
        function viewOpenLctrOfringList() {
            location.href = '/crs/openLctrOfring/admOpenLctrOfringListView.do?encParams=' + EPARAM;
        }

        // 현재 공개강좌의 수정 화면으로 이동한다.
        function viewOpenLctrOfringModify() {
            location.href = '/crs/openLctrOfring/admOpenLctrOfringRegistView.do?sbjctId=' + encodeURIComponent(SBJCT_ID || '') + '&encParams=' + EPARAM;
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">
    <form id="moveForm" method="post"></form>
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>

    <main class="common">
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="box">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="crs.open.lctr.ofring.detail"/><%--공개강좌개설 상세보기--%></h3>
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
                                <li><spring:message code="crs.open.lctr.ofring.label.open.lctr"/><%--공개강좌--%></li>
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
                            <h3 class="board-title"><spring:message code="crs.sbjct.ofring.section.period.info"/><%--강의 기간 정보--%></h3>
                        </div>
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label><spring:message code="common.label.lecture.period"/><%--강의 기간--%></label></li>
                                <li><span class="js-period" data-start="<c:out value='${sbjctVO.sbjctLctrSdttm}' />" data-end="<c:out value='${sbjctVO.sbjctLctrEdttm}' />">-</span></li>
                            </ul>
                        </div>
                    </div>

                    <div class="btns">
                        <button type="button" class="btn type1" onclick="viewOpenLctrOfringModify();"><spring:message code="sys.button.modify"/><%--수정--%></button>
                        <button type="button" class="btn type2" onclick="viewOpenLctrOfringList();"><spring:message code="button.list"/><%--목록--%></button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
