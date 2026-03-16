<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<c:set var="initTab" value="${empty param.tab ? 'weekly' : param.tab}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="home colorA">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">전체수업현황</h2>
                        <div class="navi_bar">
                            <ul>
                                <li>
                                    <i class="xi-home-o" aria-hidden="true"></i>
                                    <span class="sr-only">Home</span>
                                </li>
                                <li>강의</li>
                                <li>
                                    <a href="<%=request.getContextPath()%>/cls/selectClsListView.do" style="color:inherit;">
                                        전체수업현황
                                    </a>
                                </li>
                                <li><span class="current" id="crumbTitle">주차별 수업현황</span></li>
                            </ul>
                        </div>
                    </div>

                    <!-- 과목명 + 탭 + 목록버튼 -->
                    <div class="board_top">
                        <h3 class="board-title">
                            <span id="hdrSbjctNm">과목명</span>
                            <span style="margin-left:6px;"><b id="hdrDvclasNo"></b>반</span>
                        </h3>

                        <div class="right-area">
                            <div class="tab_btn" id="clsTab">
                                <a href="#tabWeekly" class="current" data-tab="weekly">주차별 수업현황</a>
                                <a href="#tabElement" data-tab="element">학습요소 참여현황</a>
                            </div>
                            <button type="button" class="btn type2"
                                    onclick="location.href='<%=request.getContextPath()%>/cls/selectClsListView.do'">
                                목록
                            </button>
                        </div>
                    </div>

                    <!-- ========================= -->
                    <!-- 주차별 수업현황 -->
                    <!-- ========================= -->
                    <div id="tabWeekly" class="tab-content">
                        <div class="board_top" style="margin-top:10px;">
                            <h3 class="board-title">주차별 미학습자 비율</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic icon" onclick="reloadAll()">
                                    <i class="xi-refresh"></i>
                                </button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:6%">
                                    <c:forEach begin="1" end="15">
                                        <col style="width:6%">
                                    </c:forEach>
                                    <col style="width:8%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>구분</th>
                                    <c:forEach begin="1" end="15" var="w">
                                        <th>${w}</th>
                                    </c:forEach>
                                    <th>평균</th>
                                </tr>
                                </thead>
                                <tbody id="wklyBody">
                                <tr>
                                    <td colspan="17" class="t_center">
                                        <spring:message code="common.no.data.result"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top" style="margin-top:16px;">
                            <h3 class="board-title">
                                학습자 학습현황
                                <span class="note2">[총 건수 : <b id="stdntTotalCnt">0</b>건]</span>
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="openSendMsg()">
                                    <spring:message code="button.msg.send"/>
                                </button>
                                <button type="button" class="btn basic" onclick="downloadExcel()">
                                    <spring:message code="button.download.excel"/>
                                </button>
                            </div>
                        </div>

                        <div class="search-typeA" style="margin-top:8px;">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchKeyword2">검색</label>
                                </span>
                                <div class="itemList">
                                    <input class="form-control wide"
                                           type="text"
                                           id="srchKeyword2"
                                           placeholder="이름/학번/학과 검색어를 입력하세요.">
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit">
                                    <label for="absnWknoFrom">결석주차</label>
                                </span>
                                <div class="itemList">
                                    <select class="form-control" id="absnWknoFrom" style="width:90px;">
                                        <option value="0">전체</option>
                                        <c:forEach begin="1" end="15" var="w">
                                            <option value="${w}">${w}주차</option>
                                        </c:forEach>
                                    </select>
                                    <span class="txt-sort">~</span>
                                    <select class="form-control" id="absnWknoTo" style="width:90px;">
                                        <option value="0">전체</option>
                                        <c:forEach begin="1" end="15" var="w">
                                            <option value="${w}">${w}주차</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" onclick="searchStdntList(1)">
                                    <spring:message code="button.search"/>
                                </button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:4%">
                                    <col style="width:9%">
                                    <col style="width:9%">
                                    <col style="width:9%">
                                    <col style="width:6%">
                                    <col style="width:6%">
                                    <c:forEach begin="1" end="15">
                                        <col style="width:3%">
                                    </c:forEach>
                                    <col style="width:9%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>No</th>
                                    <th>학과</th>
                                    <th>학번</th>
                                    <th>이름</th>
                                    <th>입학년도</th>
                                    <th>학년</th>
                                    <c:forEach begin="1" end="15" var="w">
                                        <th>${w}</th>
                                    </c:forEach>
                                    <th>출석/지각/결석</th>
                                </tr>
                                </thead>
                                <tbody id="stdntBody">
                                <tr>
                                    <td colspan="22" class="t_center">
                                        <spring:message code="common.no.data.result"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b id="stdntTotalCnt2">0</b>건</span>
                                <span class="current_page">
                                    현재 페이지 <strong id="stdntCurPage">1</strong>/<span id="stdntTotalPage">1</span>
                                </span>
                            </div>

                            <div class="board_pager">
                                <span class="inner">
                                    <a href="#none" class="page_first" title="첫페이지" onclick="searchStdntList(1)">
                                        <i class="xi-angle-left-min"></i><i class="xi-angle-left-min" style="margin-left:-8px;"></i><span class="sr_only">첫페이지</span>
                                    </a>
                                    <a href="#none" class="page_prev" title="이전페이지" onclick="moveStdntPage('prev')">
                                        <i class="xi-angle-left-min"></i><span class="sr_only">이전페이지</span>
                                    </a>
                                    <a href="#none" class="page_now" title="현재페이지">
                                        <strong id="stdntCurPage2">1</strong>
                                    </a>
                                    <a href="#none" class="page_next" title="다음페이지" onclick="moveStdntPage('next')">
                                        <i class="xi-angle-right-min"></i><span class="sr_only">다음페이지</span>
                                    </a>
                                    <a href="#none" class="page_last" title="마지막페이지" onclick="searchStdntList(stdntTotalPageCount)">
                                        <i class="xi-angle-right-min"></i><i class="xi-angle-right-min" style="margin-left:-8px;"></i><span class="sr_only">마지막페이지</span>
                                    </a>
                                </span>
                            </div>
                        </div>

                        <div style="height:120px;"></div>
                    </div>

                    <!-- ========================= -->
                    <!-- 학습요소 참여현황 -->
                    <!-- ========================= -->
                    <div id="tabElement" class="tab-content" style="display:none;">
                        <div class="board_top" style="margin-top:16px;">
                            <h3 class="board-title">
                                학습요소 참여현황
                                <span class="note2">[총 <b id="elemStdntTotalCnt">0</b>명]</span>
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="openElemSendMsg()">
                                    <spring:message code="button.msg.send"/>
                                </button>
                                <button type="button" class="btn basic" onclick="downloadElemStdntExcel()">
                                    <spring:message code="button.download.excel"/>
                                </button>
                            </div>
                        </div>

                        <div class="search-typeA" style="margin-top:8px;">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="elemStdntKeyword">검색</label>
                                </span>
                                <div class="itemList">
                                    <input class="form-control wide"
                                           type="text"
                                           id="elemStdntKeyword"
                                           placeholder="이름/학번/학과 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="searchElemStdntList(1)">
                                    <spring:message code="button.search"/>
                                </button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:9%">
                                    <col style="width:7%">
                                    <col style="width:8%">
                                    <col style="width:8%">
                                    <col style="width:8%">
                                    <col style="width:8%">
                                    <col style="width:7%">
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>No</th>
                                    <th>학과</th>
                                    <th>학번</th>
                                    <th>이름</th>
                                    <th>Q&amp;A<br/>(답변/등록)</th>
                                    <th>토론방<br/>(댓글수)</th>
                                    <th>과제<br/>(제출/전체)</th>
                                    <th>퀴즈<br/>(제출/전체)</th>
                                    <th>설문<br/>(제출/전체)</th>
                                    <th>토론<br/>(제출/전체)</th>
                                    <th>중간고사</th>
                                    <th>기말고사</th>
                                </tr>
                                </thead>
                                <tbody id="elemStdntBody">
                                <tr>
                                    <td colspan="12" class="t_center">
                                        <spring:message code="common.no.data.result"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b id="elemStdntTotalCnt2">0</b>명</span>
                                <span class="current_page">
                                    현재 페이지 <strong id="elemStdntCurPage">1</strong>/<span id="elemStdntTotalPage">1</span>
                                </span>
                            </div>
                            <div class="board_pager">
                                <span class="inner">
                                    <a href="#none" class="page_first" title="첫페이지" onclick="searchElemStdntList(1)">
                                        <i class="xi-angle-left-min"></i><i class="xi-angle-left-min" style="margin-left:-8px;"></i><span class="sr_only">첫페이지</span>
                                    </a>
                                    <a href="#none" class="page_prev" title="이전페이지" onclick="return false;">
                                        <i class="xi-angle-left-min"></i><span class="sr_only">이전페이지</span>
                                    </a>
                                    <a href="#none" class="page_now" title="현재페이지">
                                        <strong id="elemStdntCurPage2">1</strong>
                                    </a>
                                    <a href="#none" class="page_next" title="다음페이지" onclick="return false;">
                                        <i class="xi-angle-right-min"></i><span class="sr_only">다음페이지</span>
                                    </a>
                                    <a href="#none" class="page_last" title="마지막페이지" onclick="return false;">
                                        <i class="xi-angle-right-min"></i><i class="xi-angle-right-min" style="margin-left:-8px;"></i><span class="sr_only">마지막페이지</span>
                                    </a>
                                </span>
                            </div>
                        </div>

                        <div style="height:120px;"></div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
    </main>
</div>

<script>
    var CTX = "<%=request.getContextPath()%>";

    var sbjctId  = "${param.sbjctId}";
    var dvclasNo = "${param.dvclasNo}";
    var initTab  = "${initTab}";

    // TAB1 페이징 변수
    var stdntCurrentPageNo  = 1;
    var stdntTotalPageCount = 1;

    // TAB2 페이징 변수
    var elemStdntCurrentPageNo  = 1;
    var elemStdntTotalPageCount = 1;

    var lastStdntUserIds = [];
    var lastElemUserIds  = [];

    window._lastStdntUserIds = lastStdntUserIds;
    window._lastElemUserIds  = lastElemUserIds;

    function showMsg(msg, type) {
        try {
            if (window.UiComm && typeof UiComm.showMessage === "function") {
                return UiComm.showMessage(msg, type || "info");
            }
        } catch (e) {}
        alert(msg);
    }

    $(function () {

        $("#clsTab a").on("click", function (e) {
            e.preventDefault();

            $("#clsTab a").removeClass("current");
            $(this).addClass("current");

            var target = $(this).attr("href");
            $(".tab-content").hide();
            $(target).show();

            var tabKey = $(this).data("tab");
            $("#crumbTitle").text(tabKey === "element" ? "학습요소 참여현황" : "주차별 수업현황");

            if (tabKey === "weekly") {
                loadWklyStats();
                searchStdntList(1);
            } else {
                searchElemStdntList(1);
            }
        });

        loadHeader();  /* ★ 탭 이벤트 등록 후 호출 */

        $("#srchKeyword2").on("keydown", function (e) {
            if (e.keyCode === 13) {
                e.preventDefault();
                searchStdntList(1);
            }
        });

        $("#elemStdntKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) {
                e.preventDefault();
                searchElemStdntList(1);
            }
        });

        if (initTab === "element") {
            $('#clsTab a[href="#tabElement"]').trigger("click");
        } else {
            $('#clsTab a[href="#tabWeekly"]').trigger("click");
        }
    });

    function loadHeader() {
        /* ★ URLSearchParams로 직접 파싱
           → Controller forward 여부, EL 인코딩 문제 전부 무관하게 동작 */
        var params  = new URLSearchParams(location.search);
        var sbjctnm = params.get("sbjctnm")  || "";
        var dvclsNo = params.get("dvclasNo") || "";

        $("#hdrSbjctNm").text(sbjctnm || "과목명");
        if (dvclsNo) $("#hdrDvclasNo").text(dvclsNo);
    }

    function reloadAll() {
        loadWklyStats();
        searchStdntList(1);
    }

    /* ===========================
       주차별 미학습자 비율
       =========================== */
    function loadWklyStats() {
        $.ajax({
            url: CTX + "/cls/selectClsWklyStats.do",
            type: "GET",
            dataType: "json",
            data: { sbjctId: sbjctId },
            success: function (res) {
                var $body = $("#wklyBody").empty();

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    $body.append('<tr><td colspan="17" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                var rates = new Array(15).fill(null);

                res.returnList.forEach(function (r) {
                    var wk = parseInt(r.wkNo, 10);
                    if (wk >= 1 && wk <= 15) {
                        rates[wk - 1] = (r.notLrnnRt == null ? null : Number(r.notLrnnRt));
                    }
                });

                var nums = rates.filter(function (v) {
                    return typeof v === "number" && !isNaN(v);
                });

                var avg = nums.length
                    ? (nums.reduce(function (a, b) { return a + b; }, 0) / nums.length)
                    : null;

                var tr = '<tr><td class="t_center"><b>비율</b></td>';

                for (var i = 0; i < 15; i++) {
                    if (typeof rates[i] === "number") {
                        tr += '<td class="t_center"><a href="#_" onclick="openNotLrnnList(' + (i + 1) + ');return false;">' + rates[i].toFixed(2) + '</a></td>';
                    } else {
                        tr += '<td class="t_center">-</td>';
                    }
                }

                tr += '<td class="t_center">' + (avg == null ? '-' : avg.toFixed(2)) + '</td></tr>';
                $body.append(tr);
            }
        });
    }

    function openNotLrnnList(wkNo) {
        UiDialog("notLrnnPop", {
            title: wkNo + "주차 미학습자 현황",
            width: 1100,
            height: 800,
            url: CTX + "/cls/selectNotLrnnPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&wkNo=" + wkNo
        });
    }

    /* ===========================
       학습자 학습현황 목록
       =========================== */
    function searchStdntList(page) {
        stdntCurrentPageNo = page;

        $.ajax({
            url: CTX + "/cls/selectClsStdntListPaging.do",
            type: "GET",
            dataType: "json",
            data: {
                sbjctId:      sbjctId,
                srchKeyword:  $("#srchKeyword2").val(),
                absnWknoFrom: parseInt($("#absnWknoFrom").val()) || 0,
                absnWknoTo:   parseInt($("#absnWknoTo").val())   || 0,
                pageIndex:    page
            },
            success: function (res) {
                var $body = $("#stdntBody").empty();

                var cnt = res && res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                stdntTotalPageCount = res && res.pageInfo ? res.pageInfo.totalPageCount : 1;

                $("#stdntTotalCnt").text(cnt);
                $("#stdntTotalCnt2").text(cnt);
                $("#stdntCurPage").text(page);
                $("#stdntCurPage2").text(page);
                $("#stdntTotalPage").text(stdntTotalPageCount);

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    lastStdntUserIds = [];
                    window._lastStdntUserIds = lastStdntUserIds;
                    $body.append('<tr><td colspan="22" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                var list = res.returnList || [];

                lastStdntUserIds = list.map(function (x) {
                    return x.userId;
                }).filter(Boolean);

                window._lastStdntUserIds = lastStdntUserIds;

                var perPage = (res.pageInfo && res.pageInfo.recordCountPerPage)
                    ? res.pageInfo.recordCountPerPage
                    : 20;

                function sts(v) {
                    if (v === 'O')  return '<b style="color:#2185D0;">O</b>';
                    if (v === '△') return '<b style="color:#F2711C;">△</b>';
                    if (v === 'X')  return '<b style="color:#DB2828;">X</b>';
                    return '-';
                }

                function wkCell(uid, wkNo, v) {
                    return '<td class="t_center">'
                        + '<a href="#_" class="wkCell" data-user-id="' + uid + '" data-wk-no="' + wkNo + '" onclick="return false;">'
                        + sts(v)
                        + '</a></td>';
                }

                list.forEach(function (item, idx) {
                    var no  = ((stdntCurrentPageNo - 1) * perPage) + idx + 1;
                    var uid = (item.userId || '');

                    var row = '<tr>'
                        + '<td class="t_center">' + no + '</td>'
                        + '<td class="t_center">' + (item.deptnm  || '') + '</td>'
                        + '<td class="t_center">' + (item.stdntNo || '') + '</td>'
                        + '<td class="t_center"><a href="#_" class="stdntName" data-user-id="' + uid + '" onclick="return false;">' + (item.usernm || '') + '</a></td>'
                        + '<td class="t_center">' + (item.entyR || '-') + '</td>'
                        + '<td class="t_center">' + (item.scyr  || '-') + '</td>'
                        + wkCell(uid,  1, item.wk1Sts)
                        + wkCell(uid,  2, item.wk2Sts)
                        + wkCell(uid,  3, item.wk3Sts)
                        + wkCell(uid,  4, item.wk4Sts)
                        + wkCell(uid,  5, item.wk5Sts)
                        + wkCell(uid,  6, item.wk6Sts)
                        + wkCell(uid,  7, item.wk7Sts)
                        + wkCell(uid,  8, item.wk8Sts)
                        + wkCell(uid,  9, item.wk9Sts)
                        + wkCell(uid, 10, item.wk10Sts)
                        + wkCell(uid, 11, item.wk11Sts)
                        + wkCell(uid, 12, item.wk12Sts)
                        + wkCell(uid, 13, item.wk13Sts)
                        + wkCell(uid, 14, item.wk14Sts)
                        + wkCell(uid, 15, item.wk15Sts)
                        + '<td class="t_center">'
                        + '<span style="display:inline-block;background:#2185D0;color:#fff;border-radius:50%;min-width:22px;height:22px;line-height:22px;text-align:center;font-weight:700;margin:0 2px;">' + (item.atndCnt || 0) + '</span>'
                        + '<span style="display:inline-block;background:#F2711C;color:#fff;border-radius:50%;min-width:22px;height:22px;line-height:22px;text-align:center;font-weight:700;margin:0 2px;">' + (item.lateCnt || 0) + '</span>'
                        + '<span style="display:inline-block;background:#DB2828;color:#fff;border-radius:50%;min-width:22px;height:22px;line-height:22px;text-align:center;font-weight:700;margin:0 2px;">' + (item.absnCnt || 0) + '</span>'
                        + '</td>'
                        + '</tr>';

                    $body.append(row);
                });
            }
        });
    }

    function moveStdntPage(direction) {
        if (direction === 'prev' && stdntCurrentPageNo > 1) {
            searchStdntList(stdntCurrentPageNo - 1);
        } else if (direction === 'next' && stdntCurrentPageNo < stdntTotalPageCount) {
            searchStdntList(stdntCurrentPageNo + 1);
        }
    }

    /* =============================================
       이름 클릭 → 학습자 학습현황 팝업
       ============================================= */
    $(document).on("click", ".stdntName", function (e) {
        e.preventDefault();

        var userId = $(this).data("userId");
        if (!userId) { showMsg("userId가 없습니다.", "warning"); return; }

        UiDialog("stdntWkPop", {
            title: "학습자 학습현황",
            width: 1140,
            height: 820,
            url: CTX + "/cls/selectStdntWkPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo=1"
        });
    });

    /* =============================================
       주차 셀 클릭 → 주차별 학습기록 팝업
       ============================================= */
    $(document).on("click", ".wkCell", function (e) {
        e.preventDefault();

        var userId = $(this).data("userId");
        var wkNo   = $(this).data("wkNo");

        if (!userId) { showMsg("userId가 없습니다.", "warning"); return; }

        UiDialog("stdntWkDetailPop", {
            title: "학습자 주차별 학습현황",
            width: 1140,
            height: 820,
            url: CTX + "/cls/selectStdntWkDetailPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo="     + wkNo
        });
    });

    function openSendMsg() {
        if (!lastStdntUserIds || lastStdntUserIds.length === 0) {
            showMsg("현재 조회된 학습자가 없습니다.", "warning");
            return;
        }
        showMsg("현재 조회된 학습자: " + lastStdntUserIds.length + "명\n(보내기 기능 연결 예정)", "info");
    }

    function downloadExcel() {
        var excelGrid = {
            colModel: [
                {label:'No',       name:'lineNo',   align:'center', width:'3000'},
                {label:'학과',     name:'deptnm',   align:'center', width:'7000'},
                {label:'학번',     name:'stdntNo',  align:'center', width:'7000'},
                {label:'이름',     name:'usernm',   align:'center', width:'6000'},
                {label:'입학년도', name:'entyR',    align:'center', width:'5000'},
                {label:'학년',     name:'scyr',     align:'center', width:'3000'},
                {label:'1',  name:'wk1Sts',  align:'center', width:'2500'},
                {label:'2',  name:'wk2Sts',  align:'center', width:'2500'},
                {label:'3',  name:'wk3Sts',  align:'center', width:'2500'},
                {label:'4',  name:'wk4Sts',  align:'center', width:'2500'},
                {label:'5',  name:'wk5Sts',  align:'center', width:'2500'},
                {label:'6',  name:'wk6Sts',  align:'center', width:'2500'},
                {label:'7',  name:'wk7Sts',  align:'center', width:'2500'},
                {label:'8',  name:'wk8Sts',  align:'center', width:'2500'},
                {label:'9',  name:'wk9Sts',  align:'center', width:'2500'},
                {label:'10', name:'wk10Sts', align:'center', width:'2500'},
                {label:'11', name:'wk11Sts', align:'center', width:'2500'},
                {label:'12', name:'wk12Sts', align:'center', width:'2500'},
                {label:'13', name:'wk13Sts', align:'center', width:'2500'},
                {label:'14', name:'wk14Sts', align:'center', width:'2500'},
                {label:'15', name:'wk15Sts', align:'center', width:'2500'},
                {label:'출석', name:'atndCnt', align:'center', width:'3000'},
                {label:'지각', name:'lateCnt', align:'center', width:'3000'},
                {label:'결석', name:'absnCnt', align:'center', width:'3000'}
            ]
        };

        $("form[name=excelForm]").remove();
        var excelForm = $('<form name="excelForm" method="post"></form>');
        excelForm.attr("action", CTX + "/cls/selectClsStdntListExcelDown.do");
        excelForm.append($('<input/>', {type:'hidden', name:'sbjctId',      value: sbjctId}));
        excelForm.append($('<input/>', {type:'hidden', name:'srchKeyword',  value: $("#srchKeyword2").val()}));
        excelForm.append($('<input/>', {type:'hidden', name:'absnWknoFrom', value: parseInt($("#absnWknoFrom").val()) || 0}));
        excelForm.append($('<input/>', {type:'hidden', name:'absnWknoTo',   value: parseInt($("#absnWknoTo").val())   || 0}));
        excelForm.append($('<input/>', {type:'hidden', name:'excelGrid',    value: JSON.stringify(excelGrid)}));
        excelForm.appendTo("body").submit();
    }

    /* ===========================
       학습요소 참여현황
       =========================== */
    function searchElemStdntList(page) {
        elemStdntCurrentPageNo = page;

        $.ajax({
            url: CTX + "/cls/selectClsElemStats.do",
            type: "GET",
            dataType: "json",
            data: {
                sbjctId: sbjctId,
                keyword: $("#elemStdntKeyword").val()
            },
            success: function (res) {
                var $body = $("#elemStdntBody").empty();
                var list  = (res && res.returnList) ? res.returnList : [];
                var cnt   = list.length;

                elemStdntTotalPageCount = 1;
                $("#elemStdntTotalCnt").text(cnt);
                $("#elemStdntTotalCnt2").text(cnt);
                $("#elemStdntCurPage").text(1);
                $("#elemStdntCurPage2").text(1);
                $("#elemStdntTotalPage").text(1);

                lastElemUserIds = list.map(function (x) { return x.userId; }).filter(Boolean);
                window._lastElemUserIds = lastElemUserIds;

                if (!res || res.result !== 1 || cnt === 0) {
                    $body.append('<tr><td colspan="12" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                function linkCount(uid, text, elemType) {
                    return '<a href="#_" onclick="openStdntElemPopup(\'' + uid + '\',\'' + elemType + '\');return false;">' + text + '</a>';
                }

                list.forEach(function (r, idx) {
                    var uid  = (r.userId || '');
                    var qa   = (r.qaAnsCnt     || 0) + '/' + (r.qaRegCnt    || 0);
                    var asmt = (r.asmtSbmsnCnt || 0) + '/' + (r.asmtTrgtCnt || 0);
                    var quiz = (r.quizSbmsnCnt || 0) + '/' + (r.quizTrgtCnt || 0);
                    var srvy = (r.srvySbmsnCnt || 0) + '/' + (r.srvyTrgtCnt || 0);
                    var dscc = (r.dsccSbmsnCnt || 0) + '/' + (r.dsccTrgtCnt || 0);

                    $body.append(
                        '<tr>'
                        + '<td class="t_center">' + (idx + 1) + '</td>'
                        + '<td class="t_center">' + (r.deptnm  || '') + '</td>'
                        + '<td class="t_center">' + (r.stdntNo || '') + '</td>'
                        + '<td class="t_center"><a href="#_" class="elemStdntName" data-user-id="' + uid + '" onclick="return false;">' + (r.usernm || '') + '</a></td>'
                        + '<td class="t_center">' + linkCount(uid, qa,   'QNA')  + '</td>'
                        + '<td class="t_center">' + (r.talkReplyCnt == null ? '0' : r.talkReplyCnt) + '</td>'
                        + '<td class="t_center">' + linkCount(uid, asmt, 'ASMT') + '</td>'
                        + '<td class="t_center">' + linkCount(uid, quiz, 'QUIZ') + '</td>'
                        + '<td class="t_center">' + linkCount(uid, srvy, 'SRVY') + '</td>'
                        + '<td class="t_center">' + linkCount(uid, dscc, 'DSCC') + '</td>'
                        + '<td class="t_center">' + (r.midScore   == null ? '-' : r.midScore)   + '</td>'
                        + '<td class="t_center">' + (r.finalScore == null ? '-' : r.finalScore) + '</td>'
                        + '</tr>'
                    );
                });
            },
            error: function () {
                $("#elemStdntBody").html('<tr><td colspan="12" class="t_center"><spring:message code="fail.common.msg"/></td></tr>');
            }
        });
    }

    $(document).on("click", ".elemStdntName", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        if (!userId) { showMsg("userId가 없습니다.", "warning"); return; }
        openStdntElemPopup(userId, "ASMT");
    });

    function openStdntElemPopup(userId, elemType) {
        UiDialog("stdntElemPop", {
            title: "학습자 참여현황",
            width: 1140,
            height: 820,
            url: CTX + "/cls/selectStdntElemPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&elemType=" + encodeURIComponent(elemType || "ASMT")
        });
    }

    function openElemSendMsg() {
        if (!lastElemUserIds || lastElemUserIds.length === 0) {
            showMsg("현재 조회된 학습자가 없습니다.", "warning");
            return;
        }
        showMsg("현재 조회된 학습자: " + lastElemUserIds.length + "명\n(보내기 기능 연결 예정)", "info");
    }

    function downloadElemStdntExcel() {
        var excelGrid = {
            colModel: [
                {label:'No',              name:'lineNo',       align:'center', width:'3000'},
                {label:'학과',            name:'deptnm',       align:'center', width:'7000'},
                {label:'학번',            name:'stdntNo',      align:'center', width:'7000'},
                {label:'이름',            name:'usernm',       align:'center', width:'6000'},
                {label:'Q&A(답변/등록)',  name:'qaText',       align:'center', width:'6000'},
                {label:'토론방(댓글수)',  name:'talkReplyCnt', align:'center', width:'4000'},
                {label:'과제(제출/전체)', name:'asmtText',     align:'center', width:'6000'},
                {label:'퀴즈(제출/전체)', name:'quizText',     align:'center', width:'6000'},
                {label:'설문(제출/전체)', name:'srvyText',     align:'center', width:'6000'},
                {label:'토론(제출/전체)', name:'dsccText',     align:'center', width:'6000'},
                {label:'중간고사',        name:'midScore',     align:'center', width:'4000'},
                {label:'기말고사',        name:'finalScore',   align:'center', width:'4000'}
            ]
        };

        $("form[name=excelForm]").remove();
        var excelForm = $('<form name="excelForm" method="post"></form>');
        excelForm.attr("action", CTX + "/cls/selectClsElemStatsExcelDown.do");
        excelForm.append($('<input/>', {type:'hidden', name:'sbjctId',   value: sbjctId}));
        excelForm.append($('<input/>', {type:'hidden', name:'keyword',   value: $("#elemStdntKeyword").val()}));
        excelForm.append($('<input/>', {type:'hidden', name:'excelGrid', value: JSON.stringify(excelGrid)}));
        excelForm.appendTo("body").submit();
    }
</script>
</body>
</html>