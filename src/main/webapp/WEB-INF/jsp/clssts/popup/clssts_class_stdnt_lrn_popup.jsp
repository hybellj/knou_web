<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="chart,table"/>
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<body>
<div id="wrap">

    <!-- ① 과목명 + 이전/다음 -->
    <div class="board_top class">
        <h3 class="board-title" id="popSbjctNm"><spring:message code="cls.label.subject.name"/><%-- 과목명 --%></h3>
        <div class="right-area">
            <button type="button" class="btn type2" id="btnPrev" onclick="movePrev()">
                <i class="xi-angle-left-min"></i> <spring:message code="cls.button.prev"/><%-- 이전 --%>
            </button>
            <button type="button" class="btn type2" id="btnNext" onclick="moveNext()">
                <spring:message code="cls.button.next"/><%-- 다음 --%> <i class="xi-angle-right-min"></i>
            </button>
        </div>
    </div>

    <!-- ② 수강생 정보 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.student.info"/><%-- 수강생 정보 --%></h3>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()"><spring:message code="cls.button.send.message"/><%-- 메시지 보내기 --%></button>
            </div>
        </div>
        <div class="user-wrap mb30">
            <div class="user-img">
                <div class="user-photo">
                    <img id="infoPhoto" src="" alt="photo" hidden style="width:100%; height:100%; object-fit:cover;">
                </div>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label><spring:message code="cls.label.org"/><%-- 기관 --%></label></li><li id="infoOrg">-</li></ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="common.name"/></label></li><%-- 이름 --%><li id="infoNm">-</li></ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="cls.label.student.no"/><%-- 학번 --%></label></li><li id="infoStdntNo">-</li></ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="common.id"/></label></li><%-- 아이디 --%><li id="infoUserId">-</li></ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="cls.label.mobile.number"/><%-- 휴대폰번호 --%></label></li><li id="infoMobile">-</li></ul>
                <ul class="list">
                    <li class="head"><label><spring:message code="cls.label.user.email"/><%-- 사용자 이메일 --%></label></li><li id="infoEmail">-</li></ul>
            </div>
        </div>
    </div>

    <!-- ③ 학습 현황 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.learning.status"/><%-- 학습 현황 --%></h3>
            <div class="right-area">
                <div class="state-txt-label">
                    <p><span class="state_ok" aria-label='<spring:message code="cls.label.attendance"/><%-- 출석 --%>'>○</span><spring:message code="cls.label.attendance"/><%-- 출석 --%></p>
                    <p><span class="state_late" aria-label='<spring:message code="cls.label.late"/><%-- 지각 --%>'>△</span> <spring:message code="cls.label.late"/><%-- 지각 --%></p>
                    <p><span class="state_no" aria-label='<spring:message code="cls.label.absence"/><%-- 결석 --%>'>X</span> <spring:message code="cls.label.absence"/><%-- 결석 --%></p>
                </div>
            </div>
        </div>

        <!-- 주차별 출결 -->
        <div class="table-wrap">
            <table class="table-type1">
                <colgroup>
                    <col style="width:8%">
                    <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}">
                        <col style="width:5.2%">
                    </c:forEach>
                    <col style="">
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="common.type"/></th><%-- 구분 --%>
                    <c:forEach begin="1" end="${wkCnt}" var="w">
                        <th>${w}</th>
                    </c:forEach>
                    <th><spring:message code="cls.label.attendance.status"/><%-- 출석/지각/결석 --%></th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th data-th="<spring:message code='common.type'/>"><spring:message code="common.week"/></th><%--구분--%><%--주차--%>
                    <c:forEach begin="1" end="${wkCnt}" var="w">
                        <td class="t_center" data-th="${w}<spring:message code='common.week'/>" id="wkSts${w}">-</td><%-- N주차 --%>
                    </c:forEach>
                    <td class="t_center" data-th="<spring:message code='cls.label.attendance.status'/>" id="wkSummary">-</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- 학습요소 -->
        <div class="table-wrap">
            <table class="table-type1">
                <colgroup>
                    <col style="">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="common.type"/></th><%--구분--%>
                    <th><spring:message code="cls.label.qna"/><%--Q&A--%><span class="fs-sm">(<spring:message code="cls.label.reply"/><%--답변--%>/<spring:message code="cls.label.register"/><%--등록--%>)</span></th>
                    <th><spring:message code="cls.label.discussion.board"/><%--토론방--%><span class="fs-sm">(<spring:message code="cls.label.comment.count"/><%--댓글수--%>)</span></th>
                    <th><spring:message code="cls.label.assignment"/><%--과제--%><span class="fs-sm">(<spring:message code="cls.label.submit"/><%--제출--%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                    <th><spring:message code="cls.label.quiz"/><%--퀴즈--%><span class="fs-sm">(<spring:message code="cls.label.stare"/><%--응시--%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                    <th><spring:message code="cls.label.survey"/><%--설문--%><span class="fs-sm">(<spring:message code="common.label.join"/><%--참여--%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                    <th><spring:message code="cls.label.discussion"/><%--토론--%><span class="fs-sm">(<spring:message code="common.label.join"/><%--참여--%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th data-th="<spring:message code='common.type'/>"><spring:message code="cls.label.learning.element"/><%-- 학습요소 --%></th><%--구분--%>
                    <td class="t_center" data-th="<spring:message code='cls.label.qna'/>(<spring:message code='cls.label.reply'/>/<spring:message code='cls.label.register'/>)" id="elemQa">-</td><%--Q&A(답변/등록)--%>
                    <td class="t_center" data-th="<spring:message code='cls.label.discussion.board'/>(<spring:message code='cls.label.comment.count'/>)" id="elemTalk">-</td><%--토론방(댓글수)--%>
                    <td class="t_center" data-th="<spring:message code='cls.label.assignment'/><%-- 과제 --%>(<spring:message code='cls.label.submit'/><%-- 제출 --%>/<spring:message code='common.all'/><%-- 전체 --%>)" id="elemAsmt">-</td>
                    <td class="t_center" data-th="<spring:message code='cls.label.quiz'/><%-- 퀴즈 --%>(<spring:message code='cls.label.stare'/><%-- 응시 --%>/<spring:message code='common.all'/><%-- 전체 --%>)" id="elemQuiz">-</td>
                    <td class="t_center" data-th="<spring:message code='cls.label.survey'/><%-- 설문 --%>(<spring:message code='common.label.join'/><%-- 참여 --%>/<spring:message code='common.all'/><%-- 전체 --%>)" id="elemSrvy">-</td>
                    <td class="t_center" data-th="<spring:message code='cls.label.discussion'/><%-- 토론 --%>(<spring:message code='common.label.join'/><%-- 참여 --%>/<spring:message code='common.all'/><%-- 전체 --%>)" id="elemDscs">-</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- 중간/기말 -->
        <div class="table-wrap">
            <table class="table-type1">
                <colgroup>
                    <col style="">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                    <col style="width:15%">
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="common.type"/></th><%-- 구분 --%>
                    <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%><span class="fs-sm">(<spring:message code="cls.label.realtime"/>)</span></th><%-- 실시간 --%>
                    <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%><span class="fs-sm">(<spring:message code="cls.label.alternative"/>)</span></th><%-- 대체 --%>
                    <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%><span class="fs-sm">(<spring:message code="common.etc"/>)</span></th><%-- 기타 --%>
                    <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%><span class="fs-sm">(<spring:message code="cls.label.realtime"/>)</span></th><%-- 실시간 --%>
                    <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%><span class="fs-sm">(<spring:message code="cls.label.alternative"/>)</span></th><%-- 대체 --%>
                    <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%><span class="fs-sm">(<spring:message code="common.etc"/>)</span></th><%-- 기타 --%>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th data-th="<spring:message code='common.type'/>"><spring:message code="cls.label.midterm.final"/><%-- 중간/기말 --%></th><%-- 구분 --%>
                    <td class="t_center" data-th="<spring:message code='cls.label.midterm'/>(<spring:message code='cls.label.realtime'/>)" id="examMidLive">-</td><%-- 중간고사(실시간) --%>
                    <td class="t_center" data-th="<spring:message code='cls.label.midterm'/>(<spring:message code='cls.label.alternative'/>)" id="examMidAlt">-</td><%-- 중간고사(대체) --%>
                    <td class="t_center" data-th="<spring:message code='cls.label.midterm'/>(<spring:message code='common.etc'/>)" id="examMidEtc">-</td><%-- 중간고사(기타) --%>
                    <td class="t_center" data-th="<spring:message code='cls.label.finalterm'/>(<spring:message code='cls.label.realtime'/>)" id="examFinalLive">-</td><%-- 기말고사(실시간) --%>
                    <td class="t_center" data-th="<spring:message code='cls.label.finalterm'/>(<spring:message code='cls.label.alternative'/>)" id="examFinalAlt">-</td><%-- 기말고사(대체) --%>
                    <td class="t_center" data-th="<spring:message code='cls.label.finalterm'/>(<spring:message code='common.etc'/>)" id="examFinalEtc">-</td><%-- 기말고사(기타) --%>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ④ 강의실 접속 현황 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.class.access.history"/></h3><%--강의실 접속 현황--%>
            <span class="total_num" id="chartPeriod"></span>
        </div>
        <div class="chart-container" style="height:300px;">
            <canvas id="lineChartUser"></canvas>
        </div>
    </div>

    <!-- ⑤ 강의실 활동기록 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.class.activity.history"/></h3><%--강의실 활동기록--%>
            <div class="right-area">
                <div class="search-typeC">
                    <input class="form-control" type="text" id="actKeyword" placeholder="<spring:message code='cls.placeholder.keyword.input'/><%-- 검색어 입력 --%>">
                    <button type="button" class="btn basic icon search" onclick="loadActivityLog(1)">
                        <i class="icon-svg-search"></i>
                    </button>
                </div>
                <button type="button" class="btn basic" onclick="downloadActExcel()">
                    <spring:message code="button.download.excel"/><%--엑셀 다운로드--%>
                </button>
                <input type="hidden" id="actListScale" value="10"/>
                <uiex:listScale func="changeActListScale" value="10"/>
            </div>
        </div>
        <div class="table-wrap">
            <div id="activityLogTable"></div>
        </div>
    </div>

    <!-- 닫기 -->
    <div class="modal_btns">
        <button type="button" class="btn type2" id="btnPrev2" onclick="movePrev()">
            <i class="xi-angle-left-min"></i> <spring:message code="cls.button.prev"/><%-- 이전 --%>
        </button>
        <button type="button" class="btn type2" id="btnNext2" onclick="moveNext()">
            <spring:message code="cls.button.next"/><%-- 다음 --%> <i class="xi-angle-right-min"></i>
        </button>

        <button type="button" class="btn type2" onclick="closePopup()"><spring:message code="button.close"/><%-- 닫기 --%></button>
    </div>

</div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var _p = new URLSearchParams(location.search);
    var sbjctId = _p.get("sbjctId") || "";
    var dvclasNo = _p.get("dvclasNo") || "";
    var userId = _p.get("userId") || "";
    var initWkNo = parseInt(_p.get("wkNo") || "1", 10) || 1;

    var stdntUserIds = (_p.get("userIds") || "").split(",").filter(function (id) { return !!id; });
    var curIdx = 0;
    var activityLogTable = null;
    var accessChartObj = null;
    var WK_CNT = ${not empty wkCnt ? wkCnt : 15};

    $(function () {
        curIdx = stdntUserIds.indexOf(userId);
        updateNavBtns();

        initActivityLogTable();

        loadSubjectName();
        loadStdntInfo();
        loadWklyData();
        loadElemData();
        loadChart();
        loadActivityLog(1);

        $("#actKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) loadActivityLog(1);
        });
    });

    function closePopup() {
        try {
            // UiDialog 반환값 기반 닫기
            var dlgId = null;
            if (window.frameElement) {
                dlgId = $(window.frameElement).closest('[data-dialog-id]').data('dialog-id');
            }
            if (dlgId && window.parent && typeof window.parent.UiDialog === 'function') {
                var dlg = window.parent.UiDialog(dlgId);
                if (dlg && typeof dlg.close === 'function') {
                    dlg.close();
                    return;
                }
            }
            // fallback: X버튼 트리거
            $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
        } catch (e) {
            window.close();
        }
    }

    function updateNavBtns() {
        if (stdntUserIds.length === 0) {
            $("#btnPrev, #btnNext, #btnPrev2, #btnNext2").prop("disabled", true).css("opacity", "0.4");
            return;
        }
        $("#btnPrev, #btnPrev2").prop("disabled", curIdx <= 0)
            .css("opacity", curIdx <= 0 ? "0.4" : "1");
        $("#btnNext, #btnNext2").prop("disabled", curIdx >= stdntUserIds.length - 1)
            .css("opacity", curIdx >= stdntUserIds.length - 1 ? "0.4" : "1");
    }

    function movePrev() {
        if (curIdx <= 0 || stdntUserIds.length === 0) {
            UiComm.showMessage('<spring:message code="cls.alert.no.prev.student"/><%-- 이전 학습자가 없습니다. --%>', "warning");
            return;
        }

        curIdx--;
        reloadForUser(stdntUserIds[curIdx]);
    }

    function moveNext() {
        if (curIdx < 0 || curIdx >= stdntUserIds.length - 1) {
            UiComm.showMessage('<spring:message code="cls.alert.no.next.student"/><%-- 다음 학습자가 없습니다. --%>', "warning");
            return;
        }
        curIdx++;
        reloadForUser(stdntUserIds[curIdx]);
    }

    function reloadForUser(newUserId) {
        userId = newUserId;
        updateNavBtns();

        for (var w = 1; w <= WK_CNT; w++) {
            $("#wkSts" + w).text("-");
        }
        $("#wkSummary").text("-");
        resetElem();
        if (activityLogTable) {
            activityLogTable.replaceData([]);
        }
        ["infoOrg", "infoNm", "infoStdntNo", "infoUserId", "infoMobile", "infoEmail"]
            .forEach(function (id) {
                $("#" + id).text("-");
            });
        $("#infoPhoto").off("error").prop("hidden", true).attr("src", "");
        loadStdntInfo();
        loadWklyData();
        loadElemData();
        loadChart();
        loadActivityLog(1);
    }

    function loadSubjectName() {
        ajaxCall(CTX + "/clssts/selectClsStsClassDetail.do", {sbjctId: sbjctId}, function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var nm = (res.returnVO.sbjctnm || "");
                    if (dvclasNo) nm += " " + dvclasNo + '<spring:message code="cls.label.decls.name"/><%-- 반 --%>';
                    $("#popSbjctNm").text(nm);
                    var now = new Date();
                    var yyyy = now.getFullYear();
                    var mm = String(now.getMonth() + 1).padStart(2, "0");
                    var lastDay = new Date(yyyy, now.getMonth() + 1, 0).getDate();
                    $("#chartPeriod").text(yyyy + "." + mm + ".01 ~ " + yyyy + "." + mm + "." + String(lastDay).padStart(2, "0"));
                }
            },
            null,
            false
        );
    }

    function loadStdntInfo() {
        ajaxCall(CTX + "/clssts/selectClsStsClassStdntInfo.do", {sbjctId: sbjctId, userId: userId}, function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var v = res.returnVO;
                    $("#infoOrg").text(v.orgnm || "-");
                    $("#infoNm").text(v.usernm || "-");
                    $("#infoStdntNo").text(v.stdntNo || "-");
                    $("#infoUserId").text(v.userId || "-");
                    $("#infoMobile").text(v.mobileNo || "-");
                    $("#infoEmail").text(v.email || "-");
                    renderProfilePhoto(v.photoFileId);
                }
            },
            null,
            false
        );
    }

    function renderProfilePhoto(photoFileId) {
        if (isRenderablePhotoFileId(photoFileId)) {
            $("#infoPhoto")
                .off("error")
                .on("error", function () {
                    $(this).prop("hidden", true).attr("src", "");
                })
                .attr("src", photoFileId)
                .prop("hidden", false);
        } else {
            $("#infoPhoto").off("error").prop("hidden", true).attr("src", "");
        }
    }

    function isRenderablePhotoFileId(photoFileId) {
        if (!photoFileId) return false;
        var normalized = String(photoFileId).trim();
        if (!normalized || normalized === "user_img") return false;
        if (normalized.indexOf("photo_user_sample") !== -1) return false;
        if (normalized.indexOf("user_no_img") !== -1) return false;
        return normalized.indexOf("data:image") === 0
            || normalized.indexOf("/") === 0
            || normalized.indexOf("http://") === 0
            || normalized.indexOf("https://") === 0
            || normalized.indexOf("blob:") === 0;
    }

    /* 추가 - 학습자 주차별 학습현황 단건 조회 */
    function loadWklyData() {
        ajaxCall(CTX + "/clssts/selectClsStsClassStdntWeeklyInfo.do", {
                sbjctId: sbjctId,
                userId: userId
            },
            function (res) {
                if (!res || res.result !== 1 || !res.returnVO) return;

                var d = res.returnVO;

                var wkMap = {};
                (d.wkStsList || []).forEach(function (x) {
                    wkMap[x.wkNo] = x.atndSts;
                });

                for (var w = 1; w <= WK_CNT; w++) {
                    var v = wkMap[w] || null;
                    var html;

                    if (!v) {
                        html = '-';
                    } else if (v === 'ATND') {
                        html = '<span class="state_ok" aria-label=\'<spring:message code="cls.label.attendance"/><%-- 출석 --%>\'>○</span>';
                    } else if (v === 'LATE') {
                        html = '<span class="state_late" aria-label=\'<spring:message code="cls.label.late"/><%-- 지각 --%>\'>△</span>';
                    } else if (v === 'ABSNT') {
                        html = '<span class="state_no" aria-label=\'<spring:message code="cls.label.absence"/><%-- 결석 --%>\'>X</span>';
                    } else if (v === 'NOTSTARTED' || v === 'STUDY') {
                        html = '<span class="state_none" aria-label=\'<spring:message code="cls.label.study.notlearned"/><%-- 미학습 --%>\'>-</span>';
                    } else {
                        html = '-';
                    }
                    $("#wkSts" + w).html(html);
                }

                    $("#wkSummary").html(
                        '<span class="state_ok total_label" aria-label=\'<spring:message code="cls.label.attendance"/><%-- 출석 --%>\'>' + (d.atndCnt || 0) + '</span>'
                        + '<span class="state_late total_label" aria-label=\'<spring:message code="cls.label.late"/><%-- 지각 --%>\'>' + (d.lateCnt || 0) + '</span>'
                        + '<span class="state_no total_label" aria-label=\'<spring:message code="cls.label.absence"/><%-- 결석 --%>\'>' + (d.absnCnt || 0) + '</span>'
                    );
            },
            null,
            false
        );
    }

    function loadElemData() {
        ajaxCall(CTX + "/clssts/selectClsStsClassElemStats.do", {sbjctId: sbjctId, userId: userId}, function (res) {
                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    resetElem();
                    return;
                }
                var d = res.returnList[0];
                if (!d) {
                    resetElem();
                    return;
                }
                $("#elemQa").text((d.qaAnsCnt || 0) + "/" + (d.qaRegCnt || 0));
                $("#elemTalk").text(d.talkReplyCnt || 0);
                $("#elemAsmt").text((d.asmtSbmsnCnt || 0) + "/" + (d.asmtTrgtCnt || 0));
                $("#elemQuiz").text((d.quizSbmsnCnt || 0) + "/" + (d.quizTrgtCnt || 0));
                $("#elemSrvy").text((d.srvySbmsnCnt || 0) + "/" + (d.srvyTrgtCnt || 0));
                $("#elemDscs").text((d.dscsSbmsnCnt || 0) + "/" + (d.dscsTrgtCnt || 0));

                $("#examMidLive").text(d.midLiveScore != null && d.midLiveScore !== "" ? d.midLiveScore : "-");
                $("#examMidAlt").text(d.midAltScore != null && d.midAltScore !== "" ? d.midAltScore : "-");
                $("#examMidEtc").text(d.midEtcScore != null && d.midEtcScore !== "" ? d.midEtcScore : "-");
                $("#examFinalLive").text(d.finalLiveScore != null && d.finalLiveScore !== "" ? d.finalLiveScore : "-");
                $("#examFinalAlt").text(d.finalAltScore != null && d.finalAltScore !== "" ? d.finalAltScore : "-");
                $("#examFinalEtc").text(d.finalEtcScore != null && d.finalEtcScore !== "" ? d.finalEtcScore : "-");

            },
            function () {
                resetElem();
            },
            false
        );
    }

    function resetElem() {
        ["elemQa", "elemTalk", "elemAsmt", "elemQuiz", "elemSrvy", "elemDscs",
            "examMidLive", "examMidAlt", "examMidEtc", "examFinalLive", "examFinalAlt", "examFinalEtc"]
            .forEach(function (id) {
                $("#" + id).text("-");
            });
    }

    function loadChart() {
        ajaxCall(CTX + "/clssts/selectClsStsClassStdntAccessChart.do", {sbjctId: sbjctId, userId: userId}, function (res) {
                var days = [], prevData = [], stdntData = [], avgData = [];
                if (res && res.result === 1 && res.returnList && res.returnList.length > 0) {
                    res.returnList.forEach(function (r) {
                        days.push(r.day);
                        prevData.push(r.prevCnt || 0);
                        stdntData.push(r.stdntCnt || 0);
                        avgData.push(r.avgCnt || 0);
                    });
                } else {
                    for (var d = 1, lastDay = getChartLastDay(); d <= lastDay; d++) {
                        days.push(d);
                        prevData.push(0);
                        stdntData.push(0);
                        avgData.push(0);
                    }
                }
                renderChart(days, prevData, stdntData, avgData);
            },
            function () {
                var days = [], p = [], s = [], a = [];
                for (var d = 1, lastDay = getChartLastDay(); d <= lastDay; d++) {
                    days.push(d);
                    p.push(0);
                    s.push(0);
                    a.push(0);
                }
                renderChart(days, p, s, a);
            },
            false
        );
    }

    function getChartLastDay() {
        var now = new Date();
        return new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
    }

    function renderChart(labels, prevData, stdntData, avgData) {
        if (typeof Chart === 'undefined') return;
        var ctx = document.getElementById("lineChartUser").getContext("2d");
        if (accessChartObj) accessChartObj.destroy();
        accessChartObj = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: '<spring:message code="cls.label.prev.month"/><%-- 지난달 --%>',
                        data: prevData,
                        fill: false, lineTension: 0,
                        backgroundColor: "rgba(172,172,172,0.4)",
                        borderColor: "rgba(172,172,172,1)",
                        pointBorderColor: "rgba(172,172,172,1)",
                        pointBackgroundColor: "#fff",
                        pointRadius: 2, pointHoverRadius: 5,
                        borderWidth: 1, spanGaps: false
                    },
                    {
                        label: '<spring:message code="common.label.learner"/><%-- 학습자 --%>',
                        data: stdntData,
                        fill: false, lineTension: 0,
                        backgroundColor: "rgba(246,92,158,0.4)",
                        borderColor: "rgba(246,92,158,1)",
                        pointBorderColor: "rgba(246,92,158,1)",
                        pointBackgroundColor: "#fff",
                        pointRadius: 2, pointHoverRadius: 5,
                        borderWidth: 1, spanGaps: false
                    },
                    {
                        label: '<spring:message code="cls.label.average"/><%-- 평균 --%>',
                        data: avgData,
                        fill: false, lineTension: 0,
                        backgroundColor: "rgba(85,154,226,0.6)",
                        borderColor: "rgba(54,162,235,1)",
                        pointBorderColor: "rgba(54,162,235,1)",
                        pointBackgroundColor: "#fff",
                        pointRadius: 2, pointHoverRadius: 5,
                        borderWidth: 1, spanGaps: false
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {boxWidth: 15}
                    }
                },
                scales: {
                    y: {
                        fontColor: '#333',
                        fontSize: 12,
                        display: true,
                        min: 0,
                        suggestedMax: 10,
                        ticks: {
                            stepSize: 1,
                            callback: function (value) {
                                return value + '<spring:message code="common.page.total_count"/><%-- 건 --%>';
                            }
                        }
                    }
                }
            }
        });
    }

    function initActivityLogTable() {
        activityLogTable = UiTable("activityLogTable", {
            lang: "ko",
            pageFunc: loadActivityLog,
            placeholder: '<spring:message code="common.no.data.result"/>',
            columns: [
                { title: '<spring:message code="common.number.no"/>', field: "lineNo", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90 },
                { title: '<spring:message code="cls.label.datetime"/>', field: "actDttm", headerHozAlign: "center", hozAlign: "center", width: 180, minWidth: 180 },
                { title: '<spring:message code="cls.label.activity.content"/>', field: "actConts", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 260 },
                { title: '<spring:message code="cls.label.access.device"/>', field: "deviceNm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150 },
                { title: '<spring:message code="cls.label.ip"/>', field: "ipAddr", headerHozAlign: "center", hozAlign: "center", width: 160, minWidth: 160 }
            ]
        });
    }

    function loadActivityLog(page) {
        var scale = parseInt($("#actListScale").val(), 10) || 10;

        ajaxCall(CTX + "/clssts/selectClsStsClassStdntActivityLog.do", {
                sbjctId: sbjctId,
                userId: userId,
                keyword: $("#actKeyword").val(),
                pageIndex: page,
                listScale: scale
            },
            function (res) {
                if (res && res.result === 1) {
                    activityLogTable.replaceData(createActivityLogData(res.returnList || [], page, scale));
                    if (res.pageInfo) {
                        activityLogTable.setPageInfo(res.pageInfo);
                    }
                    return;
                }

                activityLogTable.replaceData([]);
                activityLogTable.setPageInfo({
                    currentPageNo: 1,
                    firstPageNoOnPageList: 1,
                    lastPageNoOnPageList: 1,
                    lastPageNo: 1,
                    totalPageCount: 1,
                    totalRecordCount: 0
                });
            },
            function () {
                UiComm.showMessage('<spring:message code="fail.common.msg"/><%-- 에러가 발생하였습니다 --%>', "warning");
                activityLogTable.replaceData([]);
                activityLogTable.setPageInfo({
                    currentPageNo: 1,
                    firstPageNoOnPageList: 1,
                    lastPageNoOnPageList: 1,
                    lastPageNo: 1,
                    totalPageCount: 1,
                    totalRecordCount: 0
                });
            },
            false
        );
    }

    function createActivityLogData(list, page, scale) {
        if (!list || list.length === 0) return [];

        return list.map(function (r, idx) {
            return {
                lineNo: r.lineNo || (((page - 1) * scale) + idx + 1),
                actDttm: UiComm.escapeHtml(r.actDttm || ""),
                actConts: UiComm.escapeHtml(r.actConts || ""),
                deviceNm: UiComm.escapeHtml(r.deviceNm || ""),
                ipAddr: UiComm.escapeHtml(r.ipAddr || "")
            };
        });
    }

    function changeActListScale(scale) {
        $("#actListScale").val(scale || 10);
        loadActivityLog(1);
    }

    function downloadActExcel() {
        var excelGrid = {
            colModel: [
                {label: '<spring:message code="common.number.no"/><%-- 번호 --%>', name: 'lineNo', align: 'center', width: '3000'},
                {label: '<spring:message code="cls.label.datetime"/><%-- 일시 --%>', name: 'actDttm', align: 'center', width: '8000'},
                {label: '<spring:message code="cls.label.activity.content"/><%-- 활동 내용 --%>', name: 'actConts', align: 'left', width: '8000'},
                {label: '<spring:message code="cls.label.access.device"/><%-- 접근장비 --%>', name: 'deviceNm', align: 'center', width: '5000'},
                {label: '<spring:message code="cls.label.ip"/><%-- IP --%>', name: 'ipAddr', align: 'center', width: '6000'}
            ]
        };
        $("form[name=actExcelForm]").remove();
        var $form = $('<form name="actExcelForm" method="post"></form>');
        $form.attr("action", CTX + "/clssts/selectClsStsClassStdntActivityLogExcelDown.do");
        $form.append($('<input/>', {type: 'hidden', name: 'sbjctId', value: sbjctId}));
        $form.append($('<input/>', {type: 'hidden', name: 'userId', value: userId}));
        $form.append($('<input/>', {type: 'hidden', name: 'keyword', value: $("#actKeyword").val()}));
        $form.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    function doSendMsg() {
        if (!userId) {
            UiComm.showMessage('<spring:message code="cls.empty.student.info"/><%-- 학습자 정보가 없습니다. --%>', "warning");
            return;
        }
        var usernm = $("#infoNm").text() || "";
        var rcvUserInfoStr = userId + ";" + usernm + ";;";
        var form = getParentAlarmForm();

        if (!form) {
            UiComm.showMessage('<spring:message code="cls.alert.message.form.notfound"/><%-- 메시지 발송 폼을 찾을 수 없습니다. --%>', "warning");
            return;
        }

        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    function getParentAlarmForm() {
        try {
            return window.parent && window.parent !== window && window.parent.alarmForm ? window.parent.alarmForm : null;
        } catch (e) {
            return null;
        }
    }

    function callParentCallback(callbackName) {
        try {
            if (window.parent && window.parent !== window && typeof window.parent[callbackName] === "function") {
                window.parent[callbackName]();
            }
        } catch (e) {}
    }

    // 콜백 추가
    function saveForcedAttendCallBack() {
        loadWklyData();
        callParentCallback("saveForcedAttendCallBack");
    }

    function cancelForcedAttendCallBack() {
        loadWklyData();
        callParentCallback("cancelForcedAttendCallBack");
    }
</script>
</body>
</html>
