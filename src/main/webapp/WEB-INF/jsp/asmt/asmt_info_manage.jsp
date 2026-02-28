<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>

<script type="text/javascript">
    $(document).ready(function () {
        if ("${vo.indvAsmtyn}" == 'Y') {
            listAsmntUser();
        }
    });

    function manageAsmnt(tab) {
        var urlMap = {
            "0": "/asmtProfAsmtSelectView.do",	// 과제 상세 정보 페이지
            "1": "/asmtProfAsmtEvlView.do"	// 과제 평가 관리 페이지
        };

        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

        submitForm(urlMap[tab], "", kvArr);
    }

    // 과제 수정
    function editAsmnt() {
        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});
        kvArr.push({'key': 'asmtId', 'val': "${vo.asmtId}"});

        submitForm("/asmtProfAsmtRegistView.do", "", kvArr);
    }

    // 과제 삭제
    function deleteAsmnt() {
        var confirm = "";
        if (true) {
            //학습중인 학습자가 있습니다 삭제 시 학습정보가 삭제됩니다.
            //정말 삭제 하시겠습니까?
            confirm = window.confirm("<spring:message code='asmnt.message.warning.del1'/>\r\n<spring:message code='asmnt.message.warning.del2'/>");
        } else {
            //학습중인 학습자가 없습니다. 삭제 하시겠습니까?
            confirm = window.confirm("<spring:message code='asmnt.message.warning.del3'/>");
        }
        if (confirm) {
            var url = "/asmtProfAsmtDelete.do";
            var data = {
                "asmtId": "${vo.asmtId}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    //정상 삭제되었습니다.
                    alert("<spring:message code='asmnt.message.del'/>");
                    viewAsmntList();
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                /* 삭제 중 오류가 발생하였습니다.  잠시 후 다시 진행해 주세요. */
                alert("<spring:message code='asmnt.message.error.del'/>");
            }, true);
        }
    }

    // 목록
    function viewAsmntList() {
        var kvArr = [];
        kvArr.push({'key': 'crsCreCd', 'val': "${vo.crsCreCd}"});

        submitForm("/asmt/profAsmtListView.do", "", kvArr);
    }

    // 팀 구성원 보기
    function teamMemberView(lrnGrpId) {
        var modalId = "Ap06";
        initModal(modalId);

        var kvArr = [];
        kvArr.push({'key': 'lrnGrpId', 'val': lrnGrpId});

        submitForm("/forum/forumLect/teamMemberList.do", modalId + "ModalIfm", kvArr);
    }

    // 과제 평가 참여자 리스트 조회
    function listAsmntUser() {
        var url = "/asmt/profAsmtSbmsnPtcpntSelect.do";

        var data = {
            "selectType": "LIST",
            "crsCreCd": "${vo.crsCreCd}",
            "asmtId": "${vo.asmtId}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var html = "";
                data.returnList.forEach(function (o, i) {
                    html += "<button class='ui grey small button'>" + o.userNm + "(" + o.userId + ")" + "</button>";
                });

                $("#sindvAsmtList").empty().append(html);

            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            //에러가 발생했습니다!
            alert("<spring:message code='fail.common.msg'/>");
        }, true);
    }
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<div id="wrap" class="pusher">
    <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
    <div id="container">
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
        <div class="content stu_section">
            <%@ include file="/WEB-INF/jsp/common/class_location.jsp" %>
            <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

            <div class="ui form">
                <div class="layout2">

                    <div id="info-item-box">
                        <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                            <spring:message code="crs.label.asmnt"/>
                            <div class="ui breadcrumb small">
                                <small class="section"><spring:message
                                        code="asmnt.label.asmnt.info.management"/></small> <!-- 과제정보 및 관리 -->
                                <i class="right chevron icon divider"></i>
                                <small class="section">
                                    <spring:message code="asmnt.label.asmnt.info"/><!-- 과제정보 --></small>
                            </div>
                        </h2>
                        <div class="button-area">
                            <a href="javascript:editAsmnt()" class="ui basic button">
                                <spring:message code='asmnt.button.mod'/><!-- 수정 --></a>
                            <a href="javascript:deleteAsmnt()" class="ui basic button">
                                <spring:message code='asmnt.button.del'/><!-- 삭제 --></a>
                            <a href="javascript:viewAsmntList()" class="ui basic button">
                                <spring:message code='asmnt.button.list'/><!-- 목록 --></a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">

                            <div class="listTab">
                                <ul class="">
                                    <li class="select mw120">
                                        <a onclick="manageAsmnt(0)">
                                            <spring:message code="asmnt.label.asmnt.info"/><!-- 과제정보 --></a>
                                    </li>

                                    <c:if test="${vo.mrkRfltyn eq 'Y'}">
                                        <li class="mw120">
                                            <a onclick="manageAsmnt(1)">
                                                <spring:message code="asmnt.label.scr.eval"/><!-- 성적평가 --></a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>


                            <div class="ui grid stretched mt10 mb10">
                                <div class="sixteen wide tablet eight wide computer column">
                                    <div class="ui segment">
                                        <ul class="tbl">
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="titleLabel">
                                                            <spring:message code="asmnt.label.asmnt.title"/><!-- 과제명 --></label>
                                                    </dt>
                                                    <dd>${vo.asmtTtl }</dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="ctsLabel">
                                                            <spring:message code="asmnt.label.asmnt.content"/><!-- 과제내용 --></label>
                                                    </dt>
                                                    <dd>
                                                        <pre>${vo.asmtCts }</pre>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss"
                                                               value="${vo.asmtSbmsnSdttm }"/>
                                                <fmt:formatDate var="asmtSbmsnSdttm" pattern="yyyy.MM.dd HH:mm"
                                                                value="${startDateFmt }"/>
                                                <fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss"
                                                               value="${vo.sendEndDttm }"/>
                                                <fmt:formatDate var="sendEndDttm" pattern="yyyy.MM.dd HH:mm"
                                                                value="${endDateFmt }"/>
                                                <dl>
                                                    <dt>
                                                        <label for="sendLabel">
                                                            <spring:message code="asmnt.label.send.date"/><!-- 제출기간 --></label>
                                                    </dt>
                                                    <dd>${asmtSbmsnSdttm } ~ ${sendEndDttm }</dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="scoreAplyLabel">
                                                            <spring:message code="asmnt.label.scr.yn"/><!-- 성적 반영 여부 --></label>
                                                    </dt>
                                                    <dd>
                                                        <c:choose>
                                                            <c:when test="${vo.mrkRfltyn eq 'Y'}">
                                                                <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code="asmnt.common.no"/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="extSendLabel">
                                                            <spring:message code="asmnt.label.late.send.use"/><!-- 지각제출 사용 --></label>
                                                    </dt>
                                                    <fmt:parseDate var="extSendFmt" pattern="yyyyMMddHHmmss"
                                                                   value="${vo.extdSbmsnSdttm }"/>
                                                    <fmt:formatDate var="extdSbmsnSdttm" pattern="yyyy.MM.dd HH:mm"
                                                                    value="${extSendFmt }"/>
                                                    <dd>
                                                        <c:choose>
                                                            <c:when test="${vo.extdSbmsnPrmyn eq 'R'}">
                                                                extdSbmsnSdttm
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code="asmnt.label.use.n"/><!-- 미사용 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="evalLabel">
                                                            <spring:message code="asmnt.label.eval.type"/><!-- 평가 방식 --></label>
                                                    </dt>
                                                    <dd>
                                                        <c:choose>
                                                            <c:when test="${vo.evalCtgr eq 'R'}">
                                                                <spring:message
                                                                        code="asmnt.label.rubric"/><!-- 루브릭 --> ( ${vo.evalTitle} )
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message
                                                                        code="asmnt.label.point.type"/><!-- 점수형 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="scoreRatioLabel">
                                                            <spring:message code="asmnt.label.scr.ratio"/><!-- 점수 반영 비율 --></label>
                                                    </dt>
                                                    <dd>${vo.mrkRfltyn eq 'Y' ? vo.mrkRfltrt += ' %' : '-' } </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="prtcLabel">
                                                            <spring:message code="asmnt.label.prtc.asmnt"/><!-- 실기과제 --></label>
                                                    </dt>
                                                    <dd>
                                                        <c:choose>
                                                            <c:when test="${vo.asmtPrctcyn eq 'Y'}">
                                                                <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code="asmnt.common.no"/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="contLabel">
                                                            <spring:message code="asmnt.label.attach.file"/><!-- 첨부파일 --></label>
                                                    </dt>
                                                    <dd>
                                                        <c:forEach items="${vo.fileList }" var="item"
                                                                   varStatus="status">
                                                            <button class="ui icon small button"
                                                                    id="file_${item.fileSn}"
                                                                    title="<spring:message code='asmnt.label.attachFile.download'/>"
                                                                    onclick="fileDown('${item.fileSn}', '${item.repoCd }')">
                                                                <i class="ion-android-download"></i>
                                                            </button>
                                                            <script>
                                                                byteConvertor("${item.fileSize}", "${item.fileNm}", "file_${item.fileSn}");
                                                            </script>
                                                        </c:forEach>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="teamAsmntCfgLabel">
                                                            <spring:message code="asmnt.label.team.asmnt.yn"/><!-- 팀 과제 여부 --></label>
                                                    </dt>
                                                    <dd>
                                                        <c:choose>
                                                            <c:when test="${vo.teamAsmtStngyn eq 'Y'}">
                                                                <spring:message
                                                                        code="asmnt.common.yes"/><!-- 예 --> | ${vo.crsCreNm}
                                                                <spring:message
                                                                        code="asmnt.label.decls.name"/><!-- 반 -->
                                                                <spring:message
                                                                        code="asmnt.label.team.config"/><!-- 팀구성 -->
                                                                <button class="ui icon small button"
                                                                        onclick="teamMemberView('${vo.lrnGrpId}')">
                                                                    <spring:message code="asmnt.label.team.config.view"/><!-- 팀구성원 보기 --></button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code='asmnt.common.no'/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </dd>
                                                </dl>
                                            </li>
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="indLabel">
                                                            <spring:message code="asmnt.label.ind.asmnt.yn"/><!-- 개별과제 여부 --></label>
                                                    </dt>
                                                    <dd>
                                                        <c:choose>
                                                            <c:when test="${vo.indvAsmtyn eq 'Y'}">
                                                                <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code='asmnt.common.no'/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div id="sindvAsmtList"></div>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="sixteen wide tablet eight wide computer column">
                                    <div class="ui segment">
                                        <ul class="tbl-simple">
                                            <li>
                                                <dl>
                                                    <dt>
                                                        <label for="taskTypeLabel">
                                                            <spring:message code="asmnt.label.option"/><!-- 옵션 --></label>
                                                    </dt>
                                                    <dd></dd>
                                                </dl>
                                            </li>
                                        </ul>
                                        <div class="ui segment">
                                            <ul class="tbl-simple">
                                                <li>
                                                    <ul class="num-chk d-inline-block">
                                                        <li>
                                                            <a class="${vo.sbasmtOstdOyn eq 'Y' ? 'bcGreen' : 'bcLgrey' }"></a>
                                                        </li>
                                                    </ul>
                                                    <!-- 과제읽기 허용 -->
                                                    <label for="sbmtOpenLabel"><spring:message
                                                            code="asmnt.label.read.allow"/></label> :
                                                    <c:choose>
                                                        <c:when test="${vo.sbasmtOstdOyn eq 'Y'}">
                                                            <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                        </c:when>
                                                        <c:otherwise>
                                                            <spring:message code="asmnt.common.no"/><!-- 아니오 -->
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                                <c:if test="${vo.sbasmtOstdOyn eq 'Y'}">
                                                    <li>
                                                        <!-- 과제 읽기 허용기간 -->
                                                        <label for="sbmtOpenDttmLabel"><spring:message
                                                                code="asmnt.label.read.allow.dt"/></label> :
                                                        <fmt:parseDate var="sbmtStartFmt" pattern="yyyyMMddHHmmss"
                                                                       value="${vo.sbasmtOstdOpenSdttm }"/>
                                                        <fmt:formatDate var="sbasmtOstdOpenSdttm"
                                                                        pattern="yyyy.MM.dd HH:mm"
                                                                        value="${sbmtStartFmt }"/>
                                                        <fmt:parseDate var="sbmtEndFmt" pattern="yyyyMMddHHmmss"
                                                                       value="${vo.sbasmtOstdOpenEdttm }"/>
                                                        <fmt:formatDate var="sbasmtOstdOpenEdttm"
                                                                        pattern="yyyy.MM.dd HH:mm"
                                                                        value="${sbmtEndFmt }"/>
                                                            ${sbasmtOstdOpenSdttm} ~ ${sbasmtOstdOpenEdttm }
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>
                                        <div class="ui segment">
                                            <ul class="tbl-simple">
                                                <li>
                                                    <ul class="num-chk d-inline-block">
                                                        <li>
                                                            <a class="${vo.mrkOyn eq 'Y' ? 'bcGreen' : 'bcLgrey' }"></a>
                                                        </li>
                                                    </ul>
                                                    <!-- 성적공개 -->
                                                    <label for="scoreOpenLabel"><spring:message
                                                            code='asmnt.label.scr.open'/></label> :
                                                    <c:choose>
                                                        <c:when test="${vo.mrkOyn eq 'Y'}">
                                                            <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                        </c:when>
                                                        <c:otherwise>
                                                            <spring:message code="asmnt.common.no"/><!-- 아니오 -->
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="ui segment">
                                            <ul class="tbl-simple">
                                                <li>
                                                    <ul class="num-chk d-inline-block">
                                                        <li>
                                                            <a class="${vo.evlRfltyn eq 'Y' ? 'bcGreen' : 'bcLgrey'}"></a>
                                                        </li>
                                                    </ul>
                                                    <!-- 상호평가 -->
                                                    <label for="evalUseLabel"><spring:message
                                                            code='asmnt.label.mut.eval'/></label> :
                                                    <c:choose>
                                                        <c:when test="${vo.evlRfltyn eq 'Y'}">
                                                            <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                        </c:when>
                                                        <c:otherwise>
                                                            <spring:message code="asmnt.common.no"/><!-- 아니오 -->
                                                        </c:otherwise>
                                                    </c:choose>
                                                </li>
                                                <c:if test="${vo.evlRfltyn eq 'Y'}">
                                                    <li>
                                                        <!-- 평가기간 -->
                                                        <label for="evalStartDttmLabel"><spring:message
                                                                code='asmnt.label.eval.date'/></label> :
                                                        <fmt:parseDate var="evalStartFmt" pattern="yyyyMMddHHmmss"
                                                                       value="${vo.evlSdttm }"/>
                                                        <fmt:formatDate var="evlSdttm" pattern="yyyy.MM.dd HH:mm"
                                                                        value="${evalStartFmt }"/>
                                                        <fmt:parseDate var="evalEndFmt" pattern="yyyyMMddHHmmss"
                                                                       value="${vo.evlEdttm }"/>
                                                        <fmt:formatDate var="evlEdttm" pattern="yyyy.MM.dd HH:mm"
                                                                        value="${evalEndFmt }"/>
                                                            ${evlSdttm } ~ ${evlEdttm }
                                                    </li>
                                                    <li>
                                                        <!-- 결과 공개 -->
                                                        <label for="evalRsltOpenLabel"><spring:message
                                                                code='asmnt.label.result.open'/></label> :
                                                        <c:choose>
                                                            <c:when test="${vo.evlRsltOyn eq 'Y'}">
                                                                <spring:message code="asmnt.common.yes"/><!-- 예 -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <spring:message code="asmnt.common.no"/><!-- 아니오 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div><!-- //col -->
                    </div><!-- //row -->

                </div>
            </div>

        </div><!-- //content -->
    </div><!-- //container -->
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
</div><!-- //pusher -->
</body>
</html>