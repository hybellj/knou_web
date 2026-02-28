<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
<style>
    .list-num-circle {
        display: inline-block;
        width: 19px;
        height: 19px;
        line-height: 19px;
        text-align: center;
        border-radius: 50%;
        margin-right: 8px;
        font-size: 0.64em;
        font-weight: bold;
        text-rendering: geometricPrecision;
        background-color: var(--dark5);
        color: white;
    }

    #hyLightPc .list-num-circle {
        position: relative;
        top: -1px;
    }

    #hyLightMobile .list-num-circle {
        position: relative;
        top: 1.5px;
    }

    .dark .list-num-circle {
        background-color: var(--darkF2);
        color: black;
    }

    #hyLightMobile {
        display: none;
    }

    @media only screen and (max-width: 768px) {
        #hyLightMobile {
            display: block;
        }

        #hyLightPc {
            display: none;
        }
    }
</style>
<script type="text/javascript">
    $(document).ready(function () {
    });

    // 목록
    function viewAsmntList() {
        var url = "/asmt/stu/listView.do";
        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "listForm");
        form.attr("action", url);
        form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${vo.crsCreCd}"}));
        form.appendTo("body");
        form.submit();
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">

<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="nowFmt" pattern="yyyyMMddhhmmss" value="${now}"/>

<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

    <div id="container">

        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <!-- 본문 content 부분 -->
        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">
                    <script>
                        $(document).ready(function () {
                            // set location
                            setLocationBar('<spring:message code="asmnt.label.asmnt"/>', '<spring:message code="asmnt.label.asmnt.info" />');
                        });
                    </script>

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="asmnt.label.asmnt"/><!-- 과제 -->
                        </h2>
                        <div class="button-area">
                            <a href="javascript:viewAsmntList()" class="ui basic button" id="btnList"><spring:message
                                    code="bbs.label.list"/></a><!-- 목록 -->
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <div class="listTab">
                                <ul class="">
                                    <li class="select mw120">
                                        <a onclick="manageAsmnt(0)">
                                            <spring:message code='asmnt.label.asmnt.info'/><!-- 과제정보 --></a>
                                    </li>

                                    <c:set var="auditYn"><%=SessionInfo.getAuditYn(request) %>
                                    </c:set>
                                    <c:if test="${vo.evalUseYn eq 'Y' && auditYn ne 'Y'}">
                                        <li class="mw120">
                                            <a onclick="manageAsmnt(1)">
                                                <spring:message code="common.label.mut.evaluation" /><!-- 상호평가 --></a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                            <div class="ui segment">
                                <div class="flex">
                                    <div class="mla">
                                        <a href="https://cdp.hycu.ac.kr/dashboard" target="_blank"
                                           class="ui green small button">학업진로설계 과제 안내</a>
                                        <a href="https://cdp.hycu.ac.kr/dashboard" target="_blank"
                                           class="ui green small button">학업진로설계 과제 안내</a>
                                    </div>
                                </div>
                                <div class="ui segment transition visible">

                                    <div class="ui card wmax" id="hyLightMobile">
                                        <div class="content"><b>학업진로설계 활동 (* 필수항목)</b></div>
                                        <div class="ui divider p0 m0"></div>
                                        <div class="content ui form equal width">
                                            <ul class="sixteen wide field tbl dt-sm">
                                                <li>
                                                    <dl>
                                                        <dt class="fweb flex wmax">나의 이해<span class="mla">작성여부</span>
                                                        </dt>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">1</label><a
                                                                class="fcBlue underline" target="_blank"
                                                                href="https://cdp.hycu.ac.kr/dashboard">내 인생의 10대
                                                            뉴스*</a>
                                                            <span class="mla w50 tc">Y</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">2</label><a
                                                                class="fcBlue underline" target="_blank"
                                                                href="https://cdp.hycu.ac.kr/dashboard">학습경험*</a>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">3</label><a
                                                                class="fcBlue underline" target="_blank"
                                                                href="https://cdp.hycu.ac.kr/dashboard">SWOT분석*</a>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">4</label><a
                                                                class="fcBlue underline" target="_blank"
                                                                href="https://cdp.hycu.ac.kr/dashboard">생애목표*</a>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">5</label><a
                                                                class="fcBlue underline" target="_blank"
                                                                href="https://cdp.hycu.ac.kr/dashboard">회망직업 분석*</a>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dt class="fweb flex wmax">로드맵<span class="mla">작성여부</span></dt>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">6</label><span
                                                                class="underline">평생학습 로드맵</span>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">7</label><span
                                                                class="underline">학업계획 로드맵</span>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dt class="fweb flex wmax">역량-학습 진단<span class="mla">작성여부</span>
                                                        </dt>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">8</label><a
                                                                class="fcBlue underline" target="_blank"
                                                                href="https://cdp.hycu.ac.kr/dashboard">역량진단검사*</a>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">9</label><span
                                                                class="underline">학습정향성검사</span>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                        <dd class="flex">
                                                            <label class="list-num-circle">10</label><span
                                                                class="underline">한사인유형진단검사</span>
                                                            <span class="mla w50 tc">N</span>
                                                        </dd>
                                                    </dl>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <table class="tBasic" id="hyLightPc">
                                        <thead>
                                        <tr>
                                            <th colspan="2" class="tc">학업진로설계 활동 (* 필수항목)</th>
                                            <th class="tc">작성 여부</th>
                                            <th class="tc">작성 일시</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td rowspan="5" class="tc f110">나의 이해</td>
                                            <td><label class="list-num-circle">1</label><a class="fcBlue underline"
                                                                                           target="_blank"
                                                                                           href="https://cdp.hycu.ac.kr/dashboard">내
                                                인생의 10대 뉴스*</a></td>
                                            <td class="tc">Y</td>
                                            <td class="tc">2025.01.01 00:00</td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">2</label><a class="fcBlue underline"
                                                                                           target="_blank"
                                                                                           href="https://cdp.hycu.ac.kr/dashboard">학습경험*</a>
                                            </td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">3</label><a class="fcBlue underline"
                                                                                           target="_blank"
                                                                                           href="https://cdp.hycu.ac.kr/dashboard">SWOT분석*</a>
                                            </td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">4</label><a class="fcBlue underline"
                                                                                           target="_blank"
                                                                                           href="https://cdp.hycu.ac.kr/dashboard">생애목표*</a>
                                            </td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">5</label><a class="fcBlue underline"
                                                                                           target="_blank"
                                                                                           href="https://cdp.hycu.ac.kr/dashboard">회망직업
                                                분석*</a></td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td rowspan="2" class="tc f110">로드맵</td>
                                            <td><label class="list-num-circle">6</label><span
                                                    class="underline">평생학습 로드맵</span></td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">7</label><span
                                                    class="underline">학업계획 로드맵</span></td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td rowspan="3" class="tc f110">역량-학습 진단</td>
                                            <td><label class="list-num-circle">8</label><a class="fcBlue underline"
                                                                                           target="_blank"
                                                                                           href="https://cdp.hycu.ac.kr/dashboard">역량진단검사*</a>
                                            </td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">9</label><span
                                                    class="underline">학습정향성검사</span></td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="list-num-circle">10</label><span class="underline">한사인유형진단검사</span>
                                            </td>
                                            <td class="tc">N</td>
                                            <td class="tc"></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </div><!-- //content -->
        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div><!-- //container -->
</div><!-- //pusher -->
</body>
</html>