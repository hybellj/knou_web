<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
    <style>
        body { background: #fff; }

        .pop-body { padding: 20px; }

        /* ── 팝업 상단: 이전/다음 + 보내기 (화면정의서 슬라이드6: ①이전 ②다음 ③보내기) ── */
        .pop-nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3b6dbf;
        }
        .pop-nav .sbjct-title {
            font-size: 17px;
            font-weight: bold;
            color: #1a1a1a;
        }
        .pop-nav .nav-btns { display: flex; gap: 6px; align-items: center; }
        .btn-prev-next {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 5px 12px;
            border: 1px solid #3b6dbf;
            border-radius: 4px;
            background: #fff;
            color: #3b6dbf;
            font-size: 13px;
            cursor: pointer;
        }
        .btn-prev-next:hover { background: #eef2fb; }

        /* ── 섹션 타이틀 ── */
        .sec-title {
            background: #f4f6fb;
            border-left: 4px solid #3b6dbf;
            padding: 7px 12px;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 10px;
            margin-top: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .sec-title .legend {
            font-size: 12px;
            font-weight: normal;
            color: #555;
        }

        /* ── 수강생 정보 카드 ── */
        .stdnt-info-card {
            display: flex;
            gap: 20px;
            align-items: flex-start;
            border: 1px solid #dde3ee;
            border-radius: 6px;
            padding: 16px;
            background: #fafbfd;
            position: relative;
        }
        .stdnt-photo-placeholder {
            width: 80px;
            height: 100px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #e8eaf0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #aaa;
            font-size: 12px;
            flex-shrink: 0;
        }
        .stdnt-details { flex: 1; }
        .stdnt-details table { width: 100%; border: none; }
        .stdnt-details table td {
            padding: 4px 8px;
            font-size: 13px;
            border: none;
            background: transparent;
        }
        .stdnt-details table td:first-child {
            color: #666;
            width: 90px;
        }
        .stdnt-details table td:last-child { font-weight: 500; }
        .stdnt-card-send {
            position: absolute;
            top: 12px;
            right: 12px;
        }

        /* ── 학습현황 주차 테이블 ── */
        .wk-info-row {
            font-size: 12px;
            color: #444;
            margin-bottom: 6px;
        }
        .table-type2 th, .table-type2 td {
            text-align: center;
            padding: 6px 4px;
            font-size: 12px;
        }
        .badge-circle {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            font-size: 12px;
            font-weight: bold;
            color: #fff;
        }
        .badge-atnd  { background: #2185D0; }
        .badge-late  { background: #F2711C; }
        .badge-absn  { background: #DB2828; }
        .sts-O   { color: #2185D0; font-weight: bold; }
        .sts-TRI { color: #F2711C; font-weight: bold; }
        .sts-X   { color: #DB2828; font-weight: bold; }

        /* ── 학습요소 테이블 ── */
        .elem-table th { background: #f0f3fa; }

        /* ── 차트 영역 - 화면정의서 슬라이드6: ④ 현재 월 기준 ── */
        .chart-wrap {
            border: 1px solid #dde3ee;
            border-radius: 6px;
            padding: 14px;
            background: #fff;
        }

        /* ── 강의실 활동기록 ── */
        .act-search-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .act-search-row .left { display: flex; gap: 6px; }

        /* ── 닫기 푸터 ── */
        .pop-footer {
            text-align: center;
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid #eee;
        }

        /* ── 페이저 ── */
        .act-pager { text-align: center; margin-top: 10px; }
        .act-pager a {
            display: inline-block;
            padding: 3px 8px;
            margin: 0 2px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 12px;
            color: #333;
            cursor: pointer;
        }
        .act-pager a.on { background: #3b6dbf; color: #fff; border-color: #3b6dbf; }
    </style>
</head>
<body>
<div class="pop-body">

    <!-- ① 이전 / 다음 + 보내기
         화면정의서 슬라이드6: ①이전 학습자 이동, ②다음 학습자 이동, ③메시지보내기 레이어 팝업 -->
    <div class="pop-nav">
        <span class="sbjct-title" id="popSbjctNm">과목명</span>
        <div class="nav-btns">
            <button type="button" class="btn-prev-next" id="btnPrev" onclick="movePrev()">
                <i class="xi-angle-left-thin"></i> <spring:message code="button.previous"/><%-- 이전 --%>
            </button>
            <button type="button" class="btn-prev-next" id="btnNext" onclick="moveNext()">
                <spring:message code="button.next"/><%-- 다음 --%> <i class="xi-angle-right-thin"></i>
            </button>
        </div>
    </div>

    <!-- ② 수강생 정보 -->
    <div class="sec-title">수강생 정보
        <div class="stdnt-card-send" style="position:static;">
            <button type="button" class="btn basic" id="btnSendMsg" onclick="doSendMsg()">
                <i class="xi-mail-o"></i> 보내기
            </button>
        </div>
    </div>
    <div class="stdnt-info-card">
        <div class="stdnt-photo-placeholder" id="stdntPhoto">
            <i class="xi-user" style="font-size:32px;"></i>
        </div>
        <div class="stdnt-details">
            <table>
                <tr><td>기관</td>     <td id="infoOrg">-</td></tr>
                <tr><td>이름</td>     <td id="infoNm" style="color:#e74c3c;font-weight:bold;">-</td></tr>
                <tr><td>학번</td>     <td id="infoStdntNo">-</td></tr>
                <tr><td>아이디</td>   <td id="infoUserId">-</td></tr>
                <tr><td>휴대폰번호</td><td id="infoMobile">-</td></tr>
                <tr><td>사용 이메일</td><td id="infoEmail">-</td></tr>
            </table>
        </div>
    </div>

    <!-- ③ 학습 현황 (주차별) -->
    <div class="sec-title">
        학습 현황
        <span class="legend">
            <b class="sts-O">O</b> : 출석&nbsp;&nbsp;
            <b class="sts-TRI">△</b> : 지각&nbsp;&nbsp;
            <b class="sts-X">X</b> : 결석
        </span>
    </div>
    <div class="wk-info-row" id="wkInfoRow"></div>
    <div style="overflow-x:auto;">
        <table class="table-type2" style="min-width:700px;">
            <colgroup>
                <col style="width:80px">
                <c:forEach begin="1" end="15"><col></c:forEach>
                <col style="width:110px">
            </colgroup>
            <thead>
            <tr>
                <th>주차</th>
                <c:forEach begin="1" end="15" var="w">
                    <th>${w}</th>
                </c:forEach>
                <th>출석/지각/결석</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <th></th>
                <c:forEach begin="1" end="15" var="w">
                    <td id="wkSts${w}">-</td>
                </c:forEach>
                <td id="wkSummary">-</td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- 학습요소 -->
    <table class="table-type2 elem-table" style="margin-top:12px;min-width:600px;">
        <colgroup>
            <col style="width:80px">
            <col><col><col><col><col><col>
        </colgroup>
        <thead>
        <tr>
            <th>학습요소</th>
            <th>Q&amp;A<br/>(답변/등록)</th>
            <th>토론방<br/>(댓글수)</th>
            <th>과제<br/>(제출/전체)</th>
            <th>퀴즈<br/>(제출/전체)</th>
            <th>설문<br/>(제출/전체)</th>
            <th>토론<br/>(제출/전체)</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th></th>
            <td id="elemQa">-</td>
            <td id="elemTalk">-</td>
            <td id="elemAsmt">-</td>
            <td id="elemQuiz">-</td>
            <td id="elemSrvy">-</td>
            <td id="elemDscc">-</td>
        </tr>
        </tbody>
    </table>

    <!-- 중간/기말 -->
    <table class="table-type2" style="margin-top:8px;min-width:600px;">
        <colgroup>
            <col style="width:80px">
            <col><col><col><col><col><col>
        </colgroup>
        <thead>
        <tr>
            <th>중간/기말</th>
            <th>중간고사<br/>(실시간)</th>
            <th>중간고사<br/>(대체)</th>
            <th>중간고사<br/>(기타)</th>
            <th>기말고사<br/>(실시간)</th>
            <th>기말고사<br/>(대체)</th>
            <th>기말고사<br/>(기타)</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <th></th>
            <td id="examMidLive">-</td>
            <td id="examMidAlt">-</td>
            <td id="examMidEtc">-</td>
            <td id="examFinalLive">-</td>
            <td id="examFinalAlt">-</td>
            <td id="examFinalEtc">-</td>
        </tr>
        </tbody>
    </table>

    <!-- ④ 강의실 접속 현황 차트
         화면정의서 슬라이드6: ④ 현재 월 기준 -->
    <div class="sec-title" id="chartTitle">강의실 접속 현황</div>
    <div class="chart-wrap">
        <canvas id="accessChart" height="120"></canvas>
        <div style="text-align:center;margin-top:8px;font-size:12px;">
            <span style="display:inline-block;width:14px;height:14px;background:#ccc;vertical-align:middle;margin-right:3px;"></span>지난달
            <span style="display:inline-block;width:14px;height:14px;background:#e8a0a0;vertical-align:middle;margin:0 3px 0 12px;"></span>학습자
            <span style="display:inline-block;width:14px;height:14px;background:#90b8e0;vertical-align:middle;margin:0 3px 0 12px;"></span>평균
        </div>
    </div>

    <!-- ⑤ 강의실 활동기록
         화면정의서 슬라이드6: ⑤ 강의실 활동기록 전체 엑셀다운로드 -->
    <div class="sec-title">강의실 활동기록</div>
    <div class="act-search-row">
        <div class="left">
            <input class="form-control" type="text" id="actKeyword" placeholder="이름/학번/학과 입력" style="width:220px;">
            <button type="button" class="btn basic" onclick="loadActivityLog(1)"><i class="xi-search"></i></button>
        </div>
        <div>
            <button type="button" class="btn basic" id="btnActExcel" onclick="downloadActExcel()"><spring:message code="button.download.excel"/></button><%-- 엑셀 다운로드 --%>
            <select class="form-select" id="actListScale" style="width:60px;" onchange="loadActivityLog(1)">
                <option value="10" selected>10</option>
                <option value="20">20</option>
                <option value="30">30</option>
            </select>
        </div>
    </div>
    <table class="table-type2">
        <colgroup>
            <col style="width:8%">
            <col style="width:28%">
            <col style="width:28%">
            <col style="width:18%">
            <col style="width:18%">
        </colgroup>
        <thead>
        <tr>
            <th>No</th>
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
    <div class="act-pager" id="actPager"></div>

    <!-- 닫기 -->
    <div class="pop-footer">
        <button type="button" class="btn type2" onclick="doClose()"><spring:message code="button.close"/></button><%-- 닫기 --%>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var sbjctId  = "${sbjctId}";
    var dvclasNo = "${dvclasNo}";
    var userId   = "${userId}";
    var initWkNo = parseInt("${wkNo}", 10) || 1;

    /* ★ 수정: window.parent._lastStdntUserIds 로 접근
       cls_weekly.jsp 에서 window._lastStdntUserIds 로 노출하므로
       팝업(iframe)에서는 window.parent._lastStdntUserIds 로 접근
       기존: window.parent.lastStdntUserIds (노출 안 됨) → 항상 undefined */
    var stdntUserIds = [];
    var curIdx = 0;

    var actCurrentPage  = 1;
    var actTotalPage    = 1;

    var accessChartObj = null;

    /* =========================================
       초기화
       ========================================= */
    $(function () {
        /* ★ 수정: _lastStdntUserIds 로 접근 */
        try {
            if (window.parent && window.parent._lastStdntUserIds && window.parent._lastStdntUserIds.length > 0) {
                stdntUserIds = window.parent._lastStdntUserIds;
            } else if (window.opener && window.opener._lastStdntUserIds) {
                stdntUserIds = window.opener._lastStdntUserIds;
            }
        } catch(e) {}
        curIdx = stdntUserIds.indexOf(userId);

        /* 이전/다음 버튼 상태 */
        updateNavBtns();

        loadSubjectName();
        loadStdntInfo();
        loadWklyData();
        loadElemData();
        loadChart();
        loadActivityLog(1);

        $("#actKeyword").on("keydown", function(e) {
            if (e.keyCode === 13) loadActivityLog(1);
        });
    });

    /* 이전/다음 버튼 비활성화 처리 */
    function updateNavBtns() {
        if (stdntUserIds.length === 0) {
            $("#btnPrev, #btnNext").prop("disabled", true).css("opacity", "0.4");
            return;
        }
        $("#btnPrev").prop("disabled", curIdx <= 0).css("opacity", curIdx <= 0 ? "0.4" : "1");
        $("#btnNext").prop("disabled", curIdx >= stdntUserIds.length - 1).css("opacity", curIdx >= stdntUserIds.length - 1 ? "0.4" : "1");
    }

    /* =========================================
       과목명 로드
       ========================================= */
    function loadSubjectName() {
        $.ajax({
            url: CTX + "/cls/selectClsDetail.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId },
            success: function(res) {
                if (res && res.result === 1 && res.returnVO) {
                    var nm = (res.returnVO.sbjctnm || "") + " " + (dvclasNo || "") + "반";
                    $("#popSbjctNm").text(nm);
                    /* 화면정의서 슬라이드6: ④ 현재 월 기준 - 차트 제목에 월 표시 */
                    var now = new Date();
                    var yyyymm = now.getFullYear() + "." + String(now.getMonth() + 1).padStart(2, "0");
                    var lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
                    var chartPeriod = yyyymm + ".01 ~ " + yyyymm + "." + String(lastDay).padStart(2, "0");
                    $("#chartTitle").text("강의실 접속 현황 (" + chartPeriod + ")");
                }
            }
        });
    }

    /* =========================================
       수강생 기본정보 로드
       ========================================= */
    function loadStdntInfo() {
        $.ajax({
            url: CTX + "/cls/selectClsStdntInfo.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function(res) {
                if (res && res.result === 1 && res.returnVO) {
                    var v = res.returnVO;
                    $("#infoOrg").text(v.orgNm   || "-");
                    $("#infoNm").text(v.usernm   || "-");
                    $("#infoStdntNo").text(v.stdntNo || "-");
                    $("#infoUserId").text(v.userId   || "-");
                    $("#infoMobile").text(v.mobileNo || "-");
                    $("#infoEmail").text(v.email     || "-");
                }
            }
        });
    }

    /* =========================================
       주차별 학습현황 로드
       ========================================= */
    function loadWklyData() {
        $.ajax({
            url: CTX + "/cls/selectClsStdntListPaging.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, pageIndex: 1, listScale: 1 },
            success: function(res) {
                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) return;
                var d = res.returnList[0];

                if ($("#infoNm").text() === "-" && d.usernm) $("#infoNm").text(d.usernm);
                if ($("#infoStdntNo").text() === "-" && d.stdntNo) $("#infoStdntNo").text(d.stdntNo);

                var info = "";
                if (d.stdntNo) info += "학번 " + d.stdntNo;
                if (d.entyR && d.entyR !== "-") info += " / 입학년도 " + d.entyR;
                if (d.scyr  && d.scyr  !== "-") info += " / " + d.scyr + "학년";
                $("#wkInfoRow").text(info);

                var wkKeys = ['wk1Sts','wk2Sts','wk3Sts','wk4Sts','wk5Sts','wk6Sts','wk7Sts',
                              'wk8Sts','wk9Sts','wk10Sts','wk11Sts','wk12Sts','wk13Sts','wk14Sts','wk15Sts'];
                wkKeys.forEach(function(k, i) {
                    var wkNo = i + 1;
                    var v = d[k] || "-";
                    var cls = "";
                    if (v === "O")  cls = "sts-O";
                    if (v === "△") cls = "sts-TRI";
                    if (v === "X")  cls = "sts-X";
                    var html = cls ? '<b class="' + cls + '">' + v + '</b>' : v;
                    if (wkNo === initWkNo) html = '<span style="background:#fff9c4;border-radius:3px;padding:0 2px;">' + html + '</span>';
                    $("#wkSts" + wkNo).html(html);
                });

                var summary =
                    '<span class="badge-circle badge-atnd">' + (d.atndCnt || 0) + '</span>' +
                    '<span class="badge-circle badge-late" style="margin:0 3px;">' + (d.lateCnt || 0) + '</span>' +
                    '<span class="badge-circle badge-absn">' + (d.absnCnt || 0) + '</span>';
                $("#wkSummary").html(summary);
            }
        });
    }

    /* =========================================
       학습요소 참여현황 로드
       ========================================= */
    function loadElemData() {
        $.ajax({
            url: CTX + "/cls/selectClsElemStats.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function(res) {
                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    resetElem(); return;
                }
                var list = res.returnList;
                var d = null;
                for (var i = 0; i < list.length; i++) {
                    if (list[i].userId === userId) { d = list[i]; break; }
                }
                if (!d) { resetElem(); return; }

                $("#elemQa").text((d.qaAnsCnt   || 0) + "/" + (d.qaRegCnt   || 0));
                $("#elemTalk").text(d.talkReplyCnt || 0);
                $("#elemAsmt").text((d.asmtSbmsnCnt || 0) + "/" + (d.asmtTrgtCnt || 0));
                $("#elemQuiz").text((d.quizSbmsnCnt || 0) + "/" + (d.quizTrgtCnt || 0));
                $("#elemSrvy").text((d.srvySbmsnCnt || 0) + "/" + (d.srvyTrgtCnt || 0));
                $("#elemDscc").text((d.dsccSbmsnCnt || 0) + "/" + (d.dsccTrgtCnt || 0));

                $("#examMidLive").text(d.midScore   != null ? d.midScore   : "-");
                $("#examMidAlt").text("-");
                $("#examMidEtc").text("-");
                $("#examFinalLive").text(d.finalScore != null ? d.finalScore : "-");
                $("#examFinalAlt").text("-");
                $("#examFinalEtc").text("-");
            },
            error: function() { resetElem(); }
        });
    }

    function resetElem() {
        ["elemQa","elemTalk","elemAsmt","elemQuiz","elemSrvy","elemDscc",
         "examMidLive","examMidAlt","examMidEtc","examFinalLive","examFinalAlt","examFinalEtc"]
        .forEach(function(id) { $("#" + id).text("-"); });
    }

    /* =========================================
       강의실 접속 현황 차트 - 화면정의서 슬라이드6: ④ 현재 월 기준
       ========================================= */
    function loadChart() {
        $.ajax({
            url: CTX + "/cls/selectStdntAccessChart.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function(res) {
                var days = [];
                var prevData = [], stdntData = [], avgData = [];

                if (res && res.result === 1 && res.returnList && res.returnList.length > 0) {
                    res.returnList.forEach(function(r) {
                        days.push(r.day);
                        prevData.push(r.prevCnt  || 0);
                        stdntData.push(r.stdntCnt || 0);
                        avgData.push(r.avgCnt    || 0);
                    });
                } else {
                    for (var d = 1; d <= 31; d++) {
                        days.push(d);
                        prevData.push(0); stdntData.push(0); avgData.push(0);
                    }
                }

                renderChart(days, prevData, stdntData, avgData);
            },
            error: function() {
                var days = [], p = [], s = [], a = [];
                for (var d = 1; d <= 31; d++) { days.push(d); p.push(0); s.push(0); a.push(0); }
                renderChart(days, p, s, a);
            }
        });
    }

    function renderChart(labels, prevData, stdntData, avgData) {
        var ctx = document.getElementById("accessChart").getContext("2d");
        if (accessChartObj) { accessChartObj.destroy(); }
        accessChartObj = new Chart(ctx, {
            type: "bar",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "지난달",
                        data: prevData,
                        backgroundColor: "rgba(180,180,180,0.6)",
                        borderColor: "rgba(150,150,150,1)",
                        borderWidth: 1,
                        order: 3
                    },
                    {
                        label: "학습자",
                        data: stdntData,
                        backgroundColor: "rgba(220,120,120,0.7)",
                        borderColor: "rgba(200,80,80,1)",
                        borderWidth: 1,
                        order: 2
                    },
                    {
                        label: "평균",
                        data: avgData,
                        type: "line",
                        borderColor: "#3b6dbf",
                        backgroundColor: "rgba(59,109,191,0.15)",
                        borderWidth: 2,
                        pointRadius: 3,
                        fill: false,
                        tension: 0.3,
                        order: 1
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                return ctx.dataset.label + ": " + ctx.parsed.y + "건";
                            }
                        }
                    }
                },
                scales: {
                    x: { ticks: { font: { size: 11 } } },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1,
                            font: { size: 11 },
                            callback: function(v) { return v + "건"; }
                        }
                    }
                }
            }
        });
    }

    /* =========================================
       강의실 활동기록 - 화면정의서 슬라이드6: ⑤ 엑셀다운로드
       ========================================= */
    function loadActivityLog(page) {
        actCurrentPage = page;
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
            success: function(res) {
                renderActivityLog(res, page, scale);
            },
            error: function() {
                $("#actBody").html('<tr><td colspan="5" class="t_center"><spring:message code="fail.common.msg"/></td></tr>'); // 조회 중 오류가 발생했습니다.
                $("#actPager").empty();
            }
        });
    }

    function renderActivityLog(res, page, scale) {
        var $body  = $("#actBody").empty();
        var $pager = $("#actPager").empty();

        if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
            $body.append('<tr><td colspan="5" class="t_center"><spring:message code="common.no.data.result"/></td></tr>'); // 조회된 데이터가 없습니다.
            return;
        }

        var list = res.returnList;
        actTotalPage = (res.pageInfo && res.pageInfo.totalPageCount) ? res.pageInfo.totalPageCount : 1;

        list.forEach(function(r, idx) {
            var no = ((page - 1) * scale) + idx + 1;
            $body.append(
                '<tr>'
                + '<td>' + no + '</td>'
                + '<td>' + escHtml(r.actDttm   || "") + '</td>'
                + '<td>' + escHtml(r.actConts  || "") + '</td>'
                + '<td>' + escHtml(r.deviceNm  || "") + '</td>'
                + '<td>' + escHtml(r.ipAddr    || "") + '</td>'
                + '</tr>'
            );
        });

        var html = "";
        html += '<a onclick="loadActivityLog(1)" title="첫페이지">&#x23EE;</a>';
        html += '<a onclick="loadActivityLog(' + Math.max(1, page - 1) + ')" title="이전">&#x276E;</a>';
        for (var p = 1; p <= actTotalPage; p++) {
            html += '<a onclick="loadActivityLog(' + p + ')" class="' + (p === page ? 'on' : '') + '">' + p + '</a>';
        }
        html += '<a onclick="loadActivityLog(' + Math.min(actTotalPage, page + 1) + ')" title="다음">&#x276F;</a>';
        html += '<a onclick="loadActivityLog(' + actTotalPage + ')" title="마지막">&#x23ED;</a>';
        $pager.html(html);
    }

    /* =========================================
       이전 / 다음 학습자 이동
       화면정의서 슬라이드6: ① 이전 학습자 이동, ② 다음 학습자 이동
       ========================================= */
    function movePrev() {
        if (curIdx <= 0 || stdntUserIds.length === 0) {
            alert("이전 학습자가 없습니다.");
            return;
        }
        curIdx--;
        reloadForUser(stdntUserIds[curIdx]);
    }

    function moveNext() {
        if (curIdx < 0 || curIdx >= stdntUserIds.length - 1) {
            alert("다음 학습자가 없습니다.");
            return;
        }
        curIdx++;
        reloadForUser(stdntUserIds[curIdx]);
    }

    function reloadForUser(newUserId) {
        userId = newUserId;
        updateNavBtns();

        /* 초기화 */
        for (var w = 1; w <= 15; w++) { $("#wkSts" + w).text("-"); }
        $("#wkSummary, #wkInfoRow").text("");
        resetElem();
        $("#actBody").html('<tr><td colspan="5" class="t_center">조회 중...</td></tr>');
        $("#actPager").empty();
        ["infoOrg","infoNm","infoStdntNo","infoUserId","infoMobile","infoEmail"]
            .forEach(function(id) { $("#" + id).text("-"); });

        /* 재조회 */
        loadStdntInfo();
        loadWklyData();
        loadElemData();
        loadChart();
        loadActivityLog(1);
    }

    /* =========================================
       보내기 - 화면정의서 슬라이드6: ③ 메시지보내기 레이어 팝업
       ========================================= */
    function doSendMsg() {
        if (!userId) { alert("학습자 정보가 없습니다."); return; }
        /* TODO: 메시지 보내기 레이어 팝업 연결 */
        alert("메시지 보내기 기능 연결 예정 (userId: " + userId + ")");
    }

    /* =========================================
       엑셀 다운로드 (활동기록) - 화면정의서 슬라이드6: ⑤ 전체 엑셀다운로드
       ========================================= */
    function downloadActExcel() {
        var excelGrid = {
            colModel: [
                {label:'No',       name:'lineNo',   align:'center', width:'3000'},
                {label:'일시',     name:'actDttm',  align:'center', width:'8000'},
                {label:'활동 내용',name:'actConts', align:'left',   width:'8000'},
                {label:'접근 장비',name:'deviceNm', align:'center', width:'5000'},
                {label:'IP',       name:'ipAddr',   align:'center', width:'6000'}
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

    /* =========================================
       닫기
       ========================================= */
    function doClose() {
        try {
            if (window.parent && typeof window.parent.UiDialog === "function") {
                window.parent.UiDialog.close("stdntWkPop");
            } else { window.close(); }
        } catch(e) { window.close(); }
    }

    function escHtml(v) {
        return String(v)
            .replace(/&/g,"&amp;").replace(/</g,"&lt;")
            .replace(/>/g,"&gt;").replace(/"/g,"&quot;");
    }
</script>
</body>
</html>
