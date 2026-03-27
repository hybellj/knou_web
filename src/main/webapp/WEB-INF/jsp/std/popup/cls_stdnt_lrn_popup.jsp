<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="chart"/>
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<body>
<div id="wrap">

    <!-- ① 과목명 + 이전/다음 -->
    <div class="board_top class">
        <h3 class="board-title" id="popSbjctNm">과목명</h3>
        <div class="right-area">
            <button type="button" class="btn type2" id="btnPrev" onclick="movePrev()">
                <i class="xi-angle-left-min"></i> 이전
            </button>
            <button type="button" class="btn type2" id="btnNext" onclick="moveNext()">
                다음 <i class="xi-angle-right-min"></i>
            </button>
        </div>
    </div>

    <!-- ② 수강생 정보 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">수강생 정보</h3>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()">메시지 보내기</button>
            </div>
        </div>
        <div class="user-wrap mb30">
            <div class="user-img">
                <div class="user-photo">
                    <i class="xi-user" style="font-size:32px; color:#ccc;"></i>
                </div>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label>기관</label></li>
                    <li id="infoOrg">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>이름</label></li>
                    <li id="infoNm">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>학번</label></li>
                    <li id="infoStdntNo">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>아이디</label></li>
                    <li id="infoUserId">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>휴대폰번호</label></li>
                    <li id="infoMobile">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>사용 이메일</label></li>
                    <li id="infoEmail">-</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- ③ 학습 현황 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">학습 현황</h3>
            <div class="right-area">
                <div class="state-txt-label">
                    <p><span class="state_ok" aria-label="출석">○</span> 출석</p>
                    <p><span class="state_late" aria-label="지각">△</span> 지각</p>
                    <p><span class="state_no" aria-label="결석">X</span> 결석</p>
                </div>
            </div>
        </div>

        <!-- 주차별 출결 -->
        <div class="table-wrap">
            <table class="table-type1">
                <colgroup>
                    <col style="width:8%">
                    <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}"><col style="width:5.2%"></c:forEach>
                    <col style="">
                </colgroup>
                <thead>
                <tr>
                    <th>구분</th>
                    <c:forEach begin="1" end="${wkCnt}" var="w"><th>${w}</th></c:forEach>
                    <th>출석/지각/결석</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th data-th="구분">주차</th>
                    <c:forEach begin="1" end="${wkCnt}" var="w">
                        <td class="t_center" data-th="${w}주차" id="wkSts${w}">-</td>
                    </c:forEach>
                    <td class="t_center" data-th="출석/지각/결석" id="wkSummary">-</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- 학습요소 -->
        <div class="table-wrap">
            <table class="table-type1">
                <colgroup>
                    <col style="">
                    <col style="width:15%"><col style="width:15%">
                    <col style="width:15%"><col style="width:15%">
                    <col style="width:15%"><col style="width:15%">
                </colgroup>
                <thead>
                <tr>
                    <th>구분</th>
                    <th>Q&amp;A<span class="fs-sm">(답변/등록)</span></th>
                    <th>토론방<span class="fs-sm">(댓글수)</span></th>
                    <th>과제<span class="fs-sm">(제출/전체)</span></th>
                    <th>퀴즈<span class="fs-sm">(제출/전체)</span></th>
                    <th>설문<span class="fs-sm">(제출/전체)</span></th>
                    <th>토론<span class="fs-sm">(제출/전체)</span></th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th data-th="구분">학습요소</th>
                    <td class="t_center" data-th="Q&A(답변/등록)" id="elemQa">-</td>
                    <td class="t_center" data-th="토론방(댓글수)" id="elemTalk">-</td>
                    <td class="t_center" data-th="과제(제출/전체)" id="elemAsmt">-</td>
                    <td class="t_center" data-th="퀴즈(제출/전체)" id="elemQuiz">-</td>
                    <td class="t_center" data-th="설문(제출/전체)" id="elemSrvy">-</td>
                    <td class="t_center" data-th="토론(제출/전체)" id="elemDscc">-</td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- 중간/기말 -->
        <div class="table-wrap">
            <table class="table-type1">
                <colgroup>
                    <col style="">
                    <col style="width:15%"><col style="width:15%">
                    <col style="width:15%"><col style="width:15%">
                    <col style="width:15%"><col style="width:15%">
                </colgroup>
                <thead>
                <tr>
                    <th>구분</th>
                    <th>중간고사<span class="fs-sm">(실시간)</span></th>
                    <th>중간고사<span class="fs-sm">(대체)</span></th>
                    <th>중간고사<span class="fs-sm">(기타)</span></th>
                    <th>기말고사<span class="fs-sm">(실시간)</span></th>
                    <th>기말고사<span class="fs-sm">(대체)</span></th>
                    <th>기말고사<span class="fs-sm">(기타)</span></th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th data-th="구분">중간/기말</th>
                    <td class="t_center" data-th="중간고사(실시간)" id="examMidLive">-</td>
                    <td class="t_center" data-th="중간고사(대체)"   id="examMidAlt">-</td>
                    <td class="t_center" data-th="중간고사(기타)"   id="examMidEtc">-</td>
                    <td class="t_center" data-th="기말고사(실시간)" id="examFinalLive">-</td>
                    <td class="t_center" data-th="기말고사(대체)"   id="examFinalAlt">-</td>
                    <td class="t_center" data-th="기말고사(기타)"   id="examFinalEtc">-</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ④ 강의실 접속 현황 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">강의실 접속 현황</h3>
            <span class="total_num" id="chartPeriod"></span>
        </div>
        <div class="chart-container" style="height:300px;">
            <canvas id="lineChartUser"></canvas>
        </div>
    </div>

    <!-- ⑤ 강의실 활동기록 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">강의실 활동기록</h3>
            <div class="right-area">
                <div class="search-typeC">
                    <input class="form-control" type="text" id="actKeyword" placeholder="검색어 입력">
                    <button type="button" class="btn basic icon search" onclick="loadActivityLog(1)">
                        <i class="icon-svg-search"></i>
                    </button>
                </div>
                <button type="button" class="btn basic" onclick="downloadActExcel()">
                    <spring:message code="button.download.excel"/>
                </button>
                <select class="form-select type-num" id="actListScale"
                        title="페이지당 리스트수를 선택하세요." onchange="loadActivityLog(1)">
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                    <option value="30">30</option>
                </select>
            </div>
        </div>

        <div class="table-wrap">
            <table class="table-type2">
                <colgroup>
                    <col style="width:10%">
                    <col style="width:22%">
                    <col style="width:16%">
                    <col style="width:20%">
                    <col style="">
                </colgroup>
                <thead>
                <tr>
                    <th>번호</th>
                    <th>일시</th>
                    <th>활동 내용</th>
                    <th>접근 장비</th>
                    <th>IP</th>
                </tr>
                </thead>
                <tbody id="actBody">
                <tr><td colspan="5" class="t_center">조회 중...</td></tr>
                </tbody>
            </table>
        </div>

        <div class="board_foot">
            <div class="page_info">
                <span class="total_page">전체 <b id="actTotalCnt">0</b>건</span>
                <span class="current_page">현재 페이지 <strong id="actCurPage">1</strong>/<span id="actTotalPage">1</span></span>
            </div>
            <div class="board_pager">
                <span class="inner">
                    <button class="page" type="button" role="button"
                            aria-label="First Page" title="처음 페이지"
                            onclick="loadActivityLog(1)">
                        <i class="icon-page-first"></i>
                    </button>
                    <button class="page" type="button" role="button"
                            aria-label="Prev Page" title="이전 페이지"
                            onclick="moveActPage('prev')">
                        <i class="icon-page-prev"></i>
                    </button>
                    <span class="pages" id="actPagerPages"></span>
                    <button class="page" type="button" role="button"
                            aria-label="Next Page" title="다음 페이지"
                            onclick="moveActPage('next')">
                        <i class="icon-page-next"></i>
                    </button>
                    <button class="page" type="button" role="button"
                            aria-label="Last Page" title="마지막 페이지"
                            onclick="loadActivityLog(actTotalPageCount)">
                        <i class="icon-page-last"></i>
                    </button>
                </span>
            </div>
        </div>
    </div>

    <!-- 닫기 -->
    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="closePopup()">닫기</button>
    </div>

</div>

<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var _p       = new URLSearchParams(location.search);
    var sbjctId  = _p.get("sbjctId")  || "";
    var dvclasNo = _p.get("dvclasNo") || "";
    var userId   = _p.get("userId")   || "";
    var initWkNo = parseInt(_p.get("wkNo") || "1", 10) || 1;

    var stdntUserIds      = [];
    var curIdx            = 0;
    var actCurrentPageNo  = 1;
    var actTotalPageCount = 1;
    var accessChartObj    = null;
    var WK_CNT = ${not empty wkCnt ? wkCnt : 15}

    $(function () {
        try {
            var parentIds = null;
            if (window.parent && window.parent._lastStdntUserIds && window.parent._lastStdntUserIds.length > 0) {
                parentIds = window.parent._lastStdntUserIds;
            } else if (window.parent && window.parent._lastElemUserIds && window.parent._lastElemUserIds.length > 0) {
                parentIds = window.parent._lastElemUserIds;
            } else if (window.opener && window.opener._lastStdntUserIds) {
                parentIds = window.opener._lastStdntUserIds;
            }
            if (parentIds) stdntUserIds = parentIds;
        } catch(e) {}

        curIdx = stdntUserIds.indexOf(userId);
        updateNavBtns();

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
                if (dlg && typeof dlg.close === 'function') { dlg.close(); return; }
            }
            // fallback: X버튼 트리거
            $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
        } catch(e) {
            window.close();
        }
    }

    function updateNavBtns() {
        if (stdntUserIds.length === 0) {
            $("#btnPrev, #btnNext").prop("disabled", true).css("opacity", "0.4");
            return;
        }
        $("#btnPrev").prop("disabled", curIdx <= 0)
            .css("opacity", curIdx <= 0 ? "0.4" : "1");
        $("#btnNext").prop("disabled", curIdx >= stdntUserIds.length - 1)
            .css("opacity", curIdx >= stdntUserIds.length - 1 ? "0.4" : "1");
    }

    function movePrev() {
        if (curIdx <= 0 || stdntUserIds.length === 0) {
            UiComm.showMessage("이전 학습자가 없습니다.", "warning");
            return;
        }

        curIdx--;
        reloadForUser(stdntUserIds[curIdx]);
    }
    function moveNext() {
        if (curIdx < 0 || curIdx >= stdntUserIds.length - 1) {
            UiComm.showMessage("다음 학습자가 없습니다.", "warning");
            return;
        }
        curIdx++;
        reloadForUser(stdntUserIds[curIdx]);
    }

    function reloadForUser(newUserId) {
        userId = newUserId;
        updateNavBtns();

        for (var w = 1; w <= WK_CNT; w++) { $("#wkSts" + w).text("-"); }
        $("#wkSummary").text("-");
        resetElem();
        $("#actBody").html('<tr><td colspan="5" class="t_center">조회 중...</td></tr>');
        $("#actPagerPages").empty();
        ["infoOrg","infoNm","infoStdntNo","infoUserId","infoMobile","infoEmail"]
            .forEach(function (id) { $("#" + id).text("-"); });
        loadStdntInfo();
        loadWklyData();
        loadElemData();
        loadChart();
        loadActivityLog(1);
    }

    function loadSubjectName() {
        $.ajax({
            url: CTX + "/cls/selectClsDetail.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId },
            success: function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var nm = (res.returnVO.sbjctnm || "") + " " + (dvclasNo || "") + "반";
                    $("#popSbjctNm").text(nm);
                    var now     = new Date();
                    var yyyy    = now.getFullYear();
                    var mm      = String(now.getMonth() + 1).padStart(2, "0");
                    var lastDay = new Date(yyyy, now.getMonth() + 1, 0).getDate();
                    $("#chartPeriod").text(yyyy + "." + mm + ".01 ~ " + yyyy + "." + mm + "." + String(lastDay).padStart(2, "0"));
                }
            }
        });
    }

    function loadStdntInfo() {
        $.ajax({
            url: CTX + "/cls/selectClsStdntInfo.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var v = res.returnVO;
                    $("#infoOrg").text(v.orgNm    || "-");
                    $("#infoNm").text(v.usernm    || "-");
                    $("#infoStdntNo").text(v.stdntNo || "-");
                    $("#infoUserId").text(v.userId   || "-");
                    $("#infoMobile").text(v.mobileNo || "-");
                    $("#infoEmail").text(v.email     || "-");
                }
            }
        });
    }

    /* 추가 - 학습자 주차별 학습현황 단건 조회 */
    function loadWklyData() {
        $.ajax({
            url: CTX + "/cls/selectClsStdntWeeklyInfo.do",
            type: "GET",
            dataType: "json",
            data: {
                sbjctId: sbjctId,
                userId: userId
            },
            success: function (res) {
                if (!res || res.result !== 1 || !res.returnVO) return;

                var d = res.returnVO;
                for (var w = 1; w <= WK_CNT; w++) {
                    var v = d['wk' + w + 'Sts'] || null;
                    var html;

                    if (!v) {
                        html = '-';
                    } else if (v === 'ATND') {
                        html = '<span class="state_ok" aria-label="출석">○</span>';
                    } else if (v === 'LATE') {
                        html = '<span class="state_late" aria-label="지각">△</span>';
                    } else if (v === 'ABSNT') {
                        html = '<span class="state_no" aria-label="결석">X</span>';
                    } else {
                        html = '-';
                    }
                    $("#wkSts" + w).html(html);
                }

                $("#wkSummary").html(
                    '<span class="state_ok total_label" aria-label="출석">' + (d.atndCnt || 0) + '</span>'
                    + '<span class="state_late total_label" aria-label="지각">' + (d.lateCnt || 0) + '</span>'
                    + '<span class="state_no total_label" aria-label="결석">' + (d.absnCnt || 0) + '</span>'
                );
            }
        });
    }

    function loadElemData() {
        $.ajax({
            url: CTX + "/cls/selectClsElemStats.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function (res) {
                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) { resetElem(); return; }
                var d = res.returnList[0];
                if (!d) { resetElem(); return; }
                $("#elemQa").text((d.qaAnsCnt      || 0) + "/" + (d.qaRegCnt    || 0));
                $("#elemTalk").text(d.talkReplyCnt || 0);
                $("#elemAsmt").text((d.asmtSbmsnCnt || 0) + "/" + (d.asmtTrgtCnt || 0));
                $("#elemQuiz").text((d.quizSbmsnCnt || 0) + "/" + (d.quizTrgtCnt || 0));
                $("#elemSrvy").text((d.srvySbmsnCnt || 0) + "/" + (d.srvyTrgtCnt || 0));
                $("#elemDscc").text((d.dsccSbmsnCnt || 0) + "/" + (d.dsccTrgtCnt || 0));

                $("#examMidLive").text(d.midLiveScore != null && d.midLiveScore !== "" ? d.midLiveScore : "-");
                $("#examMidAlt").text(d.midAltScore != null && d.midAltScore !== "" ? d.midAltScore : "-");
                $("#examMidEtc").text(d.midEtcScore != null && d.midEtcScore !== "" ? d.midEtcScore : "-");
                $("#examFinalLive").text(d.finalLiveScore != null && d.finalLiveScore !== "" ? d.finalLiveScore : "-");
                $("#examFinalAlt").text(d.finalAltScore != null && d.finalAltScore !== "" ? d.finalAltScore : "-");
                $("#examFinalEtc").text(d.finalEtcScore != null && d.finalEtcScore !== "" ? d.finalEtcScore : "-");

            },
            error: function () { resetElem(); }
        });
    }

    function resetElem() {
        ["elemQa","elemTalk","elemAsmt","elemQuiz","elemSrvy","elemDscc",
            "examMidLive","examMidAlt","examMidEtc","examFinalLive","examFinalAlt","examFinalEtc"]
            .forEach(function (id) { $("#" + id).text("-"); });
    }

    function loadChart() {
        $.ajax({
            url: CTX + "/cls/selectStdntAccessChart.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function (res) {
                var days = [], prevData = [], stdntData = [], avgData = [];
                if (res && res.result === 1 && res.returnList && res.returnList.length > 0) {
                    res.returnList.forEach(function (r) {
                        days.push(r.day);
                        prevData.push(r.prevCnt   || 0);
                        stdntData.push(r.stdntCnt || 0);
                        avgData.push(r.avgCnt     || 0);
                    });
                } else {
                    for (var d = 1; d <= 31; d++) { days.push(d); prevData.push(0); stdntData.push(0); avgData.push(0); }
                }
                renderChart(days, prevData, stdntData, avgData);
            },
            error: function () {
                var days = [], p = [], s = [], a = [];
                for (var d = 1; d <= 31; d++) { days.push(d); p.push(0); s.push(0); a.push(0); }
                renderChart(days, p, s, a);
            }
        });
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
                        label: "지난달",
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
                        label: "학습자",
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
                        label: "평균",
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
                        labels: { boxWidth: 15 }
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
                                return value + "건";
                            }
                        }
                    }
                }
            }
        });
    }

    function loadActivityLog(page) {
        actCurrentPageNo = page;
        var scale = parseInt($("#actListScale").val(), 10) || 10;

        $.ajax({
            url: CTX + "/cls/selectStdntActivityLog.do",
            type: "GET", dataType: "json",
            data: {
                sbjctId:   sbjctId,
                userId:    userId,
                keyword:   $("#actKeyword").val(),
                pageIndex: page,
                listScale: scale
            },
            success: function (res) {
                var $body  = $("#actBody").empty();
                var $pages = $("#actPagerPages").empty();

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    $body.append('<tr><td colspan="5" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    $("#actTotalCnt").text("0");
                    return;
                }

                var list          = res.returnList;
                actTotalPageCount = (res.pageInfo && res.pageInfo.totalPageCount)    ? res.pageInfo.totalPageCount    : 1;
                var totalCnt      = (res.pageInfo && res.pageInfo.totalRecordCount)  ? res.pageInfo.totalRecordCount  : list.length;

                $("#actTotalCnt").text(totalCnt);
                $("#actCurPage").text(page);
                $("#actTotalPage").text(actTotalPageCount);

                var pageSize  = 5;
                var startPage = Math.floor((page - 1) / pageSize) * pageSize + 1;
                var endPage   = Math.min(startPage + pageSize - 1, actTotalPageCount);
                var pagerHtml = '';
                for (var p = startPage; p <= endPage; p++) {
                    pagerHtml += '<button class="page' + (p === page ? ' active' : '') + '" type="button"'
                        + ' role="button" aria-label="Page ' + p + '" title="' + p + ' 페이지" data-page="' + p + '"'
                        + ' onclick="loadActivityLog(' + p + ')">' + p + '</button>';
                }
                $pages.html(pagerHtml);

                list.forEach(function (r, idx) {
                    var no = ((page - 1) * scale) + idx + 1;
                    $body.append(
                        '<tr>'
                        + '<td class="t_center" data-th="번호">'     + no + '</td>'
                        + '<td class="t_center" data-th="일시">'      + escHtml(r.actDttm  || "") + '</td>'
                        + '<td data-th="활동 내용">'                   + escHtml(r.actConts || "") + '</td>'
                        + '<td class="t_center" data-th="접근 장비">'  + escHtml(r.deviceNm || "") + '</td>'
                        + '<td class="t_center" data-th="IP">'         + escHtml(r.ipAddr   || "") + '</td>'
                        + '</tr>'
                    );
                });
            },
            error: function () {
                $("#actBody").html('<tr><td colspan="5" class="t_center"><spring:message code="fail.common.msg"/></td></tr>');
            }
        });
    }

    function moveActPage(direction) {
        if (direction === 'prev' && actCurrentPageNo > 1) {
            loadActivityLog(actCurrentPageNo - 1);
        } else if (direction === 'next' && actCurrentPageNo < actTotalPageCount) {
            loadActivityLog(actCurrentPageNo + 1);
        }
    }

    function downloadActExcel() {
        var excelGrid = {
            colModel: [
                {label:'No',        name:'lineNo',   align:'center', width:'3000'},
                {label:'일시',      name:'actDttm',  align:'center', width:'8000'},
                {label:'활동 내용', name:'actConts', align:'left',   width:'8000'},
                {label:'접근 장비', name:'deviceNm', align:'center', width:'5000'},
                {label:'IP',        name:'ipAddr',   align:'center', width:'6000'}
            ]
        };
        $("form[name=actExcelForm]").remove();
        var $form = $('<form name="actExcelForm" method="post"></form>');
        $form.attr("action", CTX + "/cls/selectStdntActivityLogExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',   value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'userId',    value: userId}));
        $form.append($('<input/>', {type:'hidden', name:'keyword',   value: $("#actKeyword").val()}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    function doSendMsg() {
        if (!userId) { UiComm.showMessage("학습자 정보가 없습니다.", "warning"); return; }
        var usernm = $("#infoNm").text() || "";
        var rcvUserInfoStr = userId + ";" + usernm + ";;";
        var form = window.parent && window.parent.alarmForm;
        if (!form) {
            UiComm.showMessage("메시지 발송 폼을 찾을 수 없습니다.", "warning");
            return;
        }
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }
    function escHtml(v) {
        return String(v)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }
    // 콜백 추가
    function saveForcedAttendCallBack() {
        loadWklyData();

        try {
            if (window.parent && typeof window.parent.saveForcedAttendCallBack === "function") {
                window.parent.saveForcedAttendCallBack();
            }
        } catch (e) {
            console.error("saveForcedAttendCallBack relay fail", e);
        }
    }

    function cancelForcedAttendCallBack() {
        loadWklyData();

        try {
            if (window.parent && typeof window.parent.cancelForcedAttendCallBack === "function") {
                window.parent.cancelForcedAttendCallBack();
            }
        } catch (e) {
            console.error("cancelForcedAttendCallBack relay fail", e);
        }
    }
</script>
</body>
</html>