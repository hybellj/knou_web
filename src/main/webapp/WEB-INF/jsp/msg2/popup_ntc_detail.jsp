<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
    </jsp:include>
</head>

<script type="text/javascript">
    let PNTTIME_MAP = {
        'BFLGN': '<spring:message code="msg.popupNtc.label.bflgn"/>',
        'AFLGN': '<spring:message code="msg.popupNtc.label.aflgn"/>'
    };

    let TRGT_MAP = {
        'ALL': '<spring:message code="msg.popupNtc.label.trgtAll"/>',
        'PROF': '<spring:message code="msg.popupNtc.label.trgtProf"/>',
        'TUTOR': '<spring:message code="msg.popupNtc.label.trgtTutor"/>',
        'STDNT': '<spring:message code="msg.popupNtc.label.trgtStdnt"/>'
    };

    $(document).ready(function() {
        let pnttimeGbncd = '${detailVO.popupPnttimeGbncd}';
        $('#pnttimeText').text(PNTTIME_MAP[pnttimeGbncd] || pnttimeGbncd);

        let trgtStr = '${detailVO.popupNtcTrgt}';
        if (trgtStr) {
            let codes = trgtStr.split(',');
            let names = [];
            codes.forEach(function(code) {
                let name = TRGT_MAP[code.trim()];
                if (name) names.push(name);
            });
            $('#trgtText').text(names.join(', '));
        }
    });

    function fn_goModify() {
        location.href = '/popupNtcModify.do?popupNtcId=${detailVO.popupNtcId}';
    }

    function fn_goList() {
        location.href = '/popupNtcList.do';
    }
</script>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <!-- page info -->
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code="msg.popupNtc.label.title"/></h2>
                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="msg.popupNtc.label.detail"/></h3>
                            </div>

                            <!-- detail table -->
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.ttl"/></th>
                                            <td><c:out value="${detailVO.popupNtcTtl}"/></td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.size"/></th>
                                            <td>
                                                <spring:message code="msg.popupNtc.label.wdth"/> <c:out value="${detailVO.popupWinWdthsz}"/>px
                                                / <spring:message code="msg.popupNtc.label.hght"/> <c:out value="${detailVO.popupWinHght}"/>px
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.pstn"/></th>
                                            <td>
                                                <spring:message code="msg.popupNtc.label.xcrd"/> <c:out value="${detailVO.popupWinXcrd}"/>
                                                / <spring:message code="msg.popupNtc.label.ycrd"/> <c:out value="${detailVO.popupWinYcrd}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.pnttime"/></th>
                                            <td><span id="pnttimeText"></span></td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.trgt"/></th>
                                            <td><span id="trgtText"></span></td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.period"/></th>
                                            <td>
                                                <uiex:formatDate value="${detailVO.popupNtcSdttm}" type="datetime"/>
                                                ~ <uiex:formatDate value="${detailVO.popupNtcEdttm}" type="datetime"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.tdstop"/></th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${detailVO.popupNtcTdstopUseyn == 'Y'}"><spring:message code="msg.popupNtc.label.tdstopUse"/></c:when>
                                                    <c:otherwise><spring:message code="msg.popupNtc.label.tdstopNotUse"/></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><spring:message code="msg.popupNtc.label.cts"/></th>
                                            <td>
                                                <div class="view-content">${detailVO.popupNtcCts}</div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="fn_goModify();"><spring:message code="msg.popupNtc.label.modify"/></button>
                            <button type="button" class="btn type2" onclick="fn_goList();"><spring:message code="msg.popupNtc.label.list"/></button>
                        </div>

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>
</body>
</html>
