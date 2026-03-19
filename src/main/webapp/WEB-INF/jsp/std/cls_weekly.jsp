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

<body class="home colorA ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title">전체수업현황</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
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
                    <div class="board_top class">
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
                    <!-- TAB1: 주차별 수업현황     -->
                    <!-- ========================= -->
                    <div id="tabWeekly" class="tab-content">

                        <!-- 주차별 미학습자 비율 -->
                        <div class="board_top">
                            <h4 class="sub-title">주차별 미학습자 비율</h4>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:7%">
                                    <c:forEach begin="1" end="${wkCnt}">
                                        <col>
                                    </c:forEach>
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>구분</th>
                                    <c:forEach begin="1" end="${wkCnt}" var="w">
                                        <th>${w}</th>
                                    </c:forEach>
                                    <th>평균</th>
                                </tr>
                                </thead>
                                <tbody id="wklyBody">
                                <tr>
                                    <td colspan="${wkCnt + 2}" class="t_center">
                                        <spring:message code="common.no.data.result"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 학습자 학습현황 헤더 -->
                        <div class="board_top" style="margin-top:16px;">
                            <h4 class="sub-title">
                                학습자 학습현황
                                <span class="total_num">총 <strong id="stdntTotalCnt">0</strong>명</span>
                            </h4>

                            <%-- 범례 --%>
                            <div class="state-txt-label">
                                <p><span class="state_ok" aria-label="출석">○</span> 출석</p>
                                <p><span class="state_late" aria-label="지각">△</span> 지각</p>
                                <p><span class="state_no" aria-label="결석">X</span> 결석</p>
                            </div>

                            <div class="right-area">
                                <%-- 결석주차 필터 --%>
                                <select class="form-select" id="absnWknoFrom" title="결석주차 시작">
                                    <option value="0">결석주차</option>
                                    <c:forEach begin="1" end="${wkCnt}" var="w">
                                        <option value="${w}">${w}주차</option>
                                    </c:forEach>
                                </select>
                                <span class="txt-sort">~</span>
                                <select class="form-select" id="absnWknoTo" title="결석주차 종료">
                                    <option value="0">결석주차</option>
                                    <c:forEach begin="1" end="${wkCnt}" var="w">
                                        <option value="${w}">${w}주차</option>
                                    </c:forEach>
                                </select>

                                <!-- 검색 -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="srchKeyword2"
                                           placeholder="이름/학번/학과 입력">
                                    <button type="button" class="btn basic icon search"
                                            onclick="searchStdntList(1)">
                                        <i class="icon-svg-search"></i>
                                    </button>
                                </div>

                                <!-- 메시지 보내기 -->
                                <button type="button" class="btn basic" onclick="openSendMsg()">
                                    <spring:message code="button.msg.send"/>
                                </button>

                                <!-- 엑셀 다운로드 -->
                                <button type="button" class="btn type2" onclick="downloadExcel()">
                                    <spring:message code="button.download.excel"/>
                                </button>
                            </div>
                        </div>

                        <!-- 학습자 목록 테이블 -->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:8%">
                                    <col style="width:9%">
                                    <col style="width:8%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <c:forEach begin="1" end="${wkCnt}">
                                        <col>
                                    </c:forEach>
                                    <col style="width:9%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chkStdntAll">
                                                <label for="chkStdntAll"></label>
                                            </span>
                                    </th>
                                    <th>No</th>
                                    <th>학과</th>
                                    <th>학번</th>
                                    <th>이름</th>
                                    <th>입학년도</th>
                                    <th>학년</th>
                                    <c:forEach begin="1" end="${wkCnt}" var="w">
                                        <th>${w}</th>
                                    </c:forEach>
                                    <th>출석/지각/결석</th>
                                </tr>
                                </thead>
                                <tbody id="stdntBody">
                                <tr>
                                    <td colspan="${wkCnt + 8}" class="t_center">
                                        <spring:message code="common.no.data.result"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 페이징 -->
                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b id="stdntTotalCnt2">0</b>건</span>
                                <span class="current_page">현재 페이지 <strong id="stdntCurPage">1</strong>/<span id="stdntTotalPage">1</span></span>
                            </div>
                            <div class="board_pager">
                                <span class="inner">
                                    <button class="page" type="button" title="처음 페이지" onclick="searchStdntList(1)">
                                        <i class="icon-page-first"></i>
                                    </button>
                                    <button class="page" type="button" title="이전 페이지" onclick="moveStdntPage('prev')">
                                        <i class="icon-page-prev"></i>
                                    </button>
                                    <span class="pages" id="stdntPagerPages"></span>
                                    <button class="page" type="button" title="다음 페이지" onclick="moveStdntPage('next')">
                                        <i class="icon-page-next"></i>
                                    </button>
                                    <button class="page" type="button" title="마지막 페이지" onclick="searchStdntList(stdntTotalPageCount)">
                                        <i class="icon-page-last"></i>
                                    </button>
                                </span>
                            </div>
                        </div>

                        <div style="height:120px;"></div>
                    </div>

                    <!-- ========================= -->
                    <!-- TAB2: 학습요소 참여현황   -->
                    <!-- ========================= -->
                    <div id="tabElement" class="tab-content" style="display:none;">

                        <div class="board_top" style="margin-top:16px;">
                            <h4 class="sub-title">
                                학습요소 참여현황
                                <span class="total_num">총 <strong id="elemStdntTotalCnt">0</strong>명</span>
                            </h4>
                            <div class="right-area">
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="elemStdntKeyword"
                                           placeholder="이름/학번/학과 입력">
                                    <button type="button" class="btn basic icon search"
                                            onclick="searchElemStdntList(1)">
                                        <i class="icon-svg-search"></i>
                                    </button>
                                </div>
                                <button type="button" class="btn basic" onclick="openElemSendMsg()">
                                    <spring:message code="button.msg.send"/>
                                </button>
                                <button type="button" class="btn type2" onclick="downloadElemStdntExcel()">
                                    <spring:message code="button.download.excel"/>
                                </button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:4%">
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
                                    <th>
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chkElemAll">
                                                <label for="chkElemAll"></label>
                                            </span>
                                    </th>
                                    <th>No</th>
                                    <th>학과</th>
                                    <th>학번</th>
                                    <th>이름</th>
                                    <th>Q&amp;A<br/><span class="fs-sm">(답변/등록)</span></th>
                                    <th>토론방<br/><span class="fs-sm">(댓글수)</span></th>
                                    <th>과제<br/><span class="fs-sm">(제출/전체)</span></th>
                                    <th>퀴즈<br/><span class="fs-sm">(제출/전체)</span></th>
                                    <th>설문<br/><span class="fs-sm">(제출/전체)</span></th>
                                    <th>토론<br/><span class="fs-sm">(제출/전체)</span></th>
                                    <th>중간고사</th>
                                    <th>기말고사</th>
                                </tr>
                                </thead>
                                <tbody id="elemStdntBody">
                                <tr>
                                    <td colspan="13" class="t_center">
                                        <spring:message code="common.no.data.result"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 페이징 -->
                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b id="elemStdntTotalCnt2">0</b>명</span>
                                <span class="current_page">현재 페이지 <strong id="elemStdntCurPage">1</strong>/<span id="elemStdntTotalPage">1</span></span>
                            </div>
                            <div class="board_pager">
                                <span class="inner">
                                    <button class="page" type="button" title="처음 페이지" onclick="searchElemStdntList(1)">
                                        <i class="icon-page-first"></i>
                                    </button>
                                    <button class="page" type="button" title="이전 페이지" onclick="moveElemPage('prev')">
                                        <i class="icon-page-prev"></i>
                                    </button>
                                    <span class="pages" id="elemPagerPages"></span>
                                    <button class="page" type="button" title="다음 페이지" onclick="moveElemPage('next')">
                                        <i class="icon-page-next"></i>
                                    </button>
                                    <button class="page" type="button" title="마지막 페이지" onclick="searchElemStdntList(elemStdntTotalPageCount)">
                                        <i class="icon-page-last"></i>
                                    </button>
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

<%-- ★ 메시지 보내기 공통 폼 (팝업에서 window.parent.alarmForm 으로 접근) --%>
<form name="alarmForm" method="POST" target="msgWindow">
    <input type="hidden" name="alarmType"      value="S"/>
    <input type="hidden" name="sysCd"          value="LMS"/>
    <input type="hidden" name="orgId"          value="${orgId}"/>
    <input type="hidden" name="bussGbn"        value="LMS"/>
    <input type="hidden" name="smsSndType"     value="P"/>
    <input type="hidden" name="rcvUserInfoStr" value=""/>
</form>

<script>
    var CTX     = "<%=request.getContextPath()%>";
    var sbjctId  = "${param.sbjctId}";
    var dvclasNo = "${param.dvclasNo}";
    var initTab  = "${initTab}";

    // ★ 동적 주차 수
    var MAX_WK = ${not empty wkCnt ? wkCnt : 15};

    // TAB1 페이징
    var stdntCurrentPageNo  = 1;
    var stdntTotalPageCount = 1;

    // TAB2 페이징
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
        } catch(e) {}
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

        loadHeader();

        // 전체 체크박스
        $("#chkStdntAll").on("change", function () {
            $("#stdntBody input[type=checkbox]").prop("checked", $(this).is(":checked"));
        });
        $("#chkElemAll").on("change", function () {
            $("#elemStdntBody input[type=checkbox]").prop("checked", $(this).is(":checked"));
        });

        $("#srchKeyword2").on("keydown", function (e) {
            if (e.keyCode === 13) { e.preventDefault(); searchStdntList(1); }
        });
        $("#elemStdntKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) { e.preventDefault(); searchElemStdntList(1); }
        });

        if (initTab === "element") {
            $('#clsTab a[href="#tabElement"]').trigger("click");
        } else {
            $('#clsTab a[href="#tabWeekly"]').trigger("click");
        }
    });

    function loadHeader() {
        var params  = new URLSearchParams(location.search);
        var sbjctnm = params.get("sbjctnm")  || "";
        var dvclsNo = params.get("dvclasNo") || "";
        $("#hdrSbjctNm").text(sbjctnm || "과목명");
        if (dvclsNo) $("#hdrDvclasNo").text(dvclsNo);
    }

    /* ===========================
       주차별 미학습자 비율
       =========================== */
    function loadWklyStats() {
        $.ajax({
            url: CTX + "/cls/selectClsWklyStats.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId },
            success: function (res) {
                var $body = $("#wklyBody").empty();
                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    $body.append('<tr><td colspan="' + (MAX_WK + 2) + '" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                var rates = new Array(MAX_WK).fill(null);
                res.returnList.forEach(function (r) {
                    var wk = parseInt(r.wkNo, 10);
                    if (wk >= 1 && wk <= MAX_WK) {
                        rates[wk - 1] = (r.notLrnnRt == null ? null : Number(r.notLrnnRt));
                    }
                });

                var nums = rates.filter(function (v) { return typeof v === "number" && !isNaN(v); });
                var avg  = nums.length ? nums.reduce(function (a, b) { return a + b; }, 0) / nums.length : null;

                var tr = '<tr><td class="t_center" data-th="구분">비율</td>';
                for (var i = 0; i < MAX_WK; i++) {
                    if (typeof rates[i] === "number") {
                        tr += '<td class="t_center" data-th="' + (i+1) + '주차">'
                            + '<a href="#_" class="link" onclick="openNotLrnnList(' + (i+1) + ');return false;">'
                            + rates[i].toFixed(2) + '</a></td>';
                    } else {
                        tr += '<td class="t_center">-</td>';
                    }
                }
                tr += '<td class="t_center" data-th="평균">' + (avg == null ? '-' : avg.toFixed(2)) + '</td></tr>';
                $body.append(tr);
            }
        });
    }

    function openNotLrnnList(wkNo) {
        UiDialog("notLrnnPop", {
            title: wkNo + "주차 미학습자 현황",
            width: 1100, height: 800,
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
            type: "GET", dataType: "json",
            data: {
                sbjctId:      sbjctId,
                srchKeyword:  $("#srchKeyword2").val(),
                absnWknoFrom: parseInt($("#absnWknoFrom").val()) || 0,
                absnWknoTo:   parseInt($("#absnWknoTo").val())   || 0,
                pageIndex:    page
            },
            success: function (res) {
                var $body = $("#stdntBody").empty();
                var cnt   = res && res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                stdntTotalPageCount = res && res.pageInfo ? res.pageInfo.totalPageCount : 1;

                $("#stdntTotalCnt").text(cnt);
                $("#stdntTotalCnt2").text(cnt);
                $("#stdntCurPage").text(page);
                $("#stdntTotalPage").text(stdntTotalPageCount);
                renderStdntPager(page, stdntTotalPageCount);

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    lastStdntUserIds = [];
                    window._lastStdntUserIds = lastStdntUserIds;
                    $body.append('<tr><td colspan="' + (MAX_WK + 8) + '" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                var list    = res.returnList || [];
                var perPage = (res.pageInfo && res.pageInfo.recordCountPerPage) ? res.pageInfo.recordCountPerPage : 20;

                lastStdntUserIds = list.map(function (x) { return x.userId; }).filter(Boolean);
                window._lastStdntUserIds = lastStdntUserIds;

                // 출석 상태 span (공통 class 사용)
                function sts(v) {
                    if (v === 'O')  return '<span class="state_ok" aria-label="출석">○</span>';
                    if (v === '△') return '<span class="state_late" aria-label="지각">△</span>';
                    if (v === 'X')  return '<span class="state_no" aria-label="결석">X</span>';
                    return '-';
                }

                function wkCell(uid, wkNo, v) {
                    var val = v || null;
                    return '<td class="t_center" data-th="' + wkNo + '주차">'
                        + (val ? '<a href="#_" class="wkCell" data-user-id="' + uid + '" data-wk-no="' + wkNo + '">' + sts(val) + '</a>' : '-')
                        + '</td>';
                }

                list.forEach(function (item, idx) {
                    var no  = ((stdntCurrentPageNo - 1) * perPage) + idx + 1;
                    var uid = (item.userId || '');
                    var chkId = 'chkStdnt_' + idx;

                    var row = '<tr>'
                        + '<td class="t_center"><span class="custom-input onlychk"><input type="checkbox" id="' + chkId + '" data-user-id="' + uid + '"><label for="' + chkId + '"></label></span></td>'
                        + '<td class="t_center" data-th="번호">' + no + '</td>'
                        + '<td class="t_center" data-th="학과">' + (item.deptnm  || '') + '</td>'
                        + '<td class="t_center" data-th="학번">' + (item.stdntNo || '') + '</td>'
                        + '<td class="t_center" data-th="이름"><a href="#_" class="link stdntName" data-user-id="' + uid + '">' + (item.usernm || '') + '</a></td>'
                        + '<td class="t_center" data-th="입학년도">' + (item.entyR || '-') + '</td>'
                        + '<td class="t_center" data-th="학년">'    + (item.scyr  || '-') + '</td>';

                    for (var w = 1; w <= MAX_WK; w++) {
                        row += wkCell(uid, w, item['wk' + w + 'Sts']);
                    }

                    // 출석/지각/결석 합계 — 공통 total_label class
                    row += '<td class="t_center" data-th="출석/지각/결석">'
                        + '<span class="state_ok total_label" aria-label="출석">'  + (item.atndCnt || 0) + '</span>'
                        + '<span class="state_late total_label" aria-label="지각">' + (item.lateCnt || 0) + '</span>'
                        + '<span class="state_no total_label" aria-label="결석">'  + (item.absnCnt || 0) + '</span>'
                        + '</td></tr>';

                    $body.append(row);
                });
            }
        });
    }

    // 페이저 버튼 렌더링
    function renderStdntPager(cur, total) {
        var html = '';
        var pageSize = 5;
        var startPage = Math.floor((cur - 1) / pageSize) * pageSize + 1;
        var endPage   = Math.min(startPage + pageSize - 1, total);
        for (var p = startPage; p <= endPage; p++) {
            html += '<button class="page' + (p === cur ? ' active' : '') + '" type="button"'
                + ' onclick="searchStdntList(' + p + ')">' + p + '</button>';
        }
        $("#stdntPagerPages").html(html);
    }

    function moveStdntPage(direction) {
        if (direction === 'prev' && stdntCurrentPageNo > 1) {
            searchStdntList(stdntCurrentPageNo - 1);
        } else if (direction === 'next' && stdntCurrentPageNo < stdntTotalPageCount) {
            searchStdntList(stdntCurrentPageNo + 1);
        }
    }

    // 이름 클릭 → 학습자 학습현황 팝업
    $(document).on("click", ".stdntName", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        if (!userId) { showMsg("userId가 없습니다.", "warning"); return; }
        UiDialog("stdntWkPop", {
            title: "학습자 학습현황",
            width: 1140, height: 820,
            url: CTX + "/cls/selectStdntWkPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo=1"
        });
    });

    // 주차 셀 클릭 → 주차별 학습기록 팝업
    $(document).on("click", ".wkCell", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        var wkNo   = $(this).data("wkNo");
        if (!userId) { showMsg("userId가 없습니다.", "warning"); return; }
        UiDialog("stdntWkDetailPop_" + userId + "_" + wkNo, {
            title: "학습자 주차별 학습현황",
            width: 1140, height: 820,
            url: CTX + "/cls/selectStdntWkDetailPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo="     + wkNo
        });
    });

    function openSendMsg() {
        var checkedIds = [];
        $("#stdntBody input[type=checkbox]:checked").each(function () {
            var uid = $(this).data("userId");
            if (uid) checkedIds.push(uid);
        });
        var targets = checkedIds.length > 0 ? checkedIds : lastStdntUserIds;
        if (!targets || targets.length === 0) {
            showMsg("현재 조회된 학습자가 없습니다.", "warning"); return;
        }
        showMsg("학습자 " + targets.length + "명\n(보내기 기능 연결 예정)", "info");
    }

    function downloadExcel() {
        var colModel = [
            {label:'No',       name:'lineNo',  align:'center', width:'3000'},
            {label:'학과',     name:'deptnm',  align:'center', width:'7000'},
            {label:'학번',     name:'stdntNo', align:'center', width:'7000'},
            {label:'이름',     name:'usernm',  align:'center', width:'6000'},
            {label:'입학년도', name:'entyR',   align:'center', width:'5000'},
            {label:'학년',     name:'scyr',    align:'center', width:'3000'}
        ];
        for (var w = 1; w <= MAX_WK; w++) {
            colModel.push({label: String(w), name: 'wk' + w + 'Sts', align:'center', width:'2500'});
        }
        colModel.push(
            {label:'출석', name:'atndCnt', align:'center', width:'3000'},
            {label:'지각', name:'lateCnt', align:'center', width:'3000'},
            {label:'결석', name:'absnCnt', align:'center', width:'3000'}
        );
        $("form[name=excelForm]").remove();
        var $form = $('<form name="excelForm" method="post"></form>');
        $form.attr("action", CTX + "/cls/selectClsStdntListExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',      value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'srchKeyword',  value: $("#srchKeyword2").val()}));
        $form.append($('<input/>', {type:'hidden', name:'absnWknoFrom', value: parseInt($("#absnWknoFrom").val()) || 0}));
        $form.append($('<input/>', {type:'hidden', name:'absnWknoTo',   value: parseInt($("#absnWknoTo").val())   || 0}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid',    value: JSON.stringify({colModel: colModel})}));
        $form.appendTo("body").submit();
    }

    /* ===========================
       학습요소 참여현황
       =========================== */
    function searchElemStdntList(page) {
        elemStdntCurrentPageNo = page;
        $.ajax({
            url: CTX + "/cls/selectClsElemStats.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, keyword: $("#elemStdntKeyword").val() },
            success: function (res) {
                var $body = $("#elemStdntBody").empty();
                var list  = (res && res.returnList) ? res.returnList : [];
                var cnt   = list.length;

                elemStdntTotalPageCount = 1;
                $("#elemStdntTotalCnt").text(cnt);
                $("#elemStdntTotalCnt2").text(cnt);
                $("#elemStdntCurPage").text(1);
                $("#elemStdntTotalPage").text(1);
                $("#elemPagerPages").html('<button class="page active" type="button">1</button>');

                lastElemUserIds = list.map(function (x) { return x.userId; }).filter(Boolean);
                window._lastElemUserIds = lastElemUserIds;

                if (!res || res.result !== 1 || cnt === 0) {
                    $body.append('<tr><td colspan="13" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                function linkCount(uid, text, elemType) {
                    return '<a href="#_" class="link" onclick="openStdntElemPopup(\'' + uid + '\',\'' + elemType + '\');return false;">' + text + '</a>';
                }

                list.forEach(function (r, idx) {
                    var uid  = (r.userId || '');
                    var chkId = 'chkElem_' + idx;
                    var qa   = (r.qaAnsCnt     || 0) + '/' + (r.qaRegCnt    || 0);
                    var asmt = (r.asmtSbmsnCnt || 0) + '/' + (r.asmtTrgtCnt || 0);
                    var quiz = (r.quizSbmsnCnt || 0) + '/' + (r.quizTrgtCnt || 0);
                    var srvy = (r.srvySbmsnCnt || 0) + '/' + (r.srvyTrgtCnt || 0);
                    var dscc = (r.dsccSbmsnCnt || 0) + '/' + (r.dsccTrgtCnt || 0);

                    $body.append(
                        '<tr>'
                        + '<td class="t_center"><span class="custom-input onlychk"><input type="checkbox" id="' + chkId + '" data-user-id="' + uid + '"><label for="' + chkId + '"></label></span></td>'
                        + '<td class="t_center" data-th="번호">' + (idx + 1) + '</td>'
                        + '<td class="t_center" data-th="학과">'  + (r.deptnm  || '') + '</td>'
                        + '<td class="t_center" data-th="학번">'  + (r.stdntNo || '') + '</td>'
                        + '<td class="t_center" data-th="이름"><a href="#_" class="link elemStdntName" data-user-id="' + uid + '">' + (r.usernm || '') + '</a></td>'
                        + '<td class="t_center" data-th="Q&A">'   + linkCount(uid, qa,   'QNA')  + '</td>'
                        + '<td class="t_center" data-th="토론방">' + (r.talkReplyCnt == null ? '0' : r.talkReplyCnt) + '</td>'
                        + '<td class="t_center" data-th="과제">'   + linkCount(uid, asmt, 'ASMT') + '</td>'
                        + '<td class="t_center" data-th="퀴즈">'   + linkCount(uid, quiz, 'QUIZ') + '</td>'
                        + '<td class="t_center" data-th="설문">'   + linkCount(uid, srvy, 'SRVY') + '</td>'
                        + '<td class="t_center" data-th="토론">'   + linkCount(uid, dscc, 'DSCC') + '</td>'
                        + '<td class="t_center" data-th="중간고사">' + (r.midScore   == null ? '-' : r.midScore)   + '</td>'
                        + '<td class="t_center" data-th="기말고사">' + (r.finalScore == null ? '-' : r.finalScore) + '</td>'
                        + '</tr>'
                    );
                });
            },
            error: function () {
                $("#elemStdntBody").html('<tr><td colspan="13" class="t_center"><spring:message code="fail.common.msg"/></td></tr>');
            }
        });
    }

    function moveElemPage(direction) {
        if (direction === 'prev' && elemStdntCurrentPageNo > 1) {
            searchElemStdntList(elemStdntCurrentPageNo - 1);
        } else if (direction === 'next' && elemStdntCurrentPageNo < elemStdntTotalPageCount) {
            searchElemStdntList(elemStdntCurrentPageNo + 1);
        }
    }

    // ★ 화면정의서 기준: 학습요소 탭 이름 클릭 → 학습자 학습현황 팝업 (주차별 탭과 동일)
    $(document).on("click", ".elemStdntName", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        if (!userId) { showMsg("userId가 없습니다.", "warning"); return; }
        UiDialog("stdntWkPop_" + userId, {
            title: "학습자 학습현황",
            width: 1140, height: 820,
            url: CTX + "/cls/selectStdntWkPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo=1"
        });
    });

    function openStdntElemPopup(userId, elemType) {
        UiDialog("stdntElemPop", {
            title: "학습자 참여현황",
            width: 1140, height: 820,
            url: CTX + "/cls/selectStdntElemPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&elemType=" + encodeURIComponent(elemType || "ASMT")
        });
    }

    function openElemSendMsg() {
        var checkedIds = [];
        $("#elemStdntBody input[type=checkbox]:checked").each(function () {
            var uid = $(this).data("userId");
            if (uid) checkedIds.push(uid);
        });
        var targets = checkedIds.length > 0 ? checkedIds : lastElemUserIds;
        if (!targets || targets.length === 0) {
            showMsg("현재 조회된 학습자가 없습니다.", "warning"); return;
        }
        showMsg("학습자 " + targets.length + "명\n(보내기 기능 연결 예정)", "info");
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
        var $form = $('<form name="excelForm" method="post"></form>');
        $form.attr("action", CTX + "/cls/selectClsElemStatsExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',   value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'keyword',   value: $("#elemStdntKeyword").val()}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }
</script>
</body>
</html>