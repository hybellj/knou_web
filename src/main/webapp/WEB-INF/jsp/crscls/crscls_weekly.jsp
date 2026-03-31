<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="initTab" value="${empty param.tab ? 'weekly' : param.tab}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <link rel="stylesheet" type="text/css" href="/webdoc/assets/css/classroom.css" />
</head>

<body class="class colorA ${bodyClass}">
<div id="wrap" class="main">

    <%-- 공통 헤더 --%>
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

    <main class="common">

        <%-- GNB --%>
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>

        <%-- 콘텐츠 영역 --%>
        <div id="content" class="content-wrap common">

            <%-- 상단 네비/버튼 바 --%>
            <div class="class_sub_top">
                <div class="navi_bar">
                    <ul>
                        <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                        <li>강의실</li>
                        <li><span class="current" id="topCrumbTitle">학습/출결현황</span></li>
                    </ul>
                </div>
                <div class="btn-wrap">
                    <div class="first">
                        <select class="form-select">
                            <option value="2025년 2학기">2025년 2학기</option>
                            <option value="2025년 1학기">2025년 1학기</option>
                        </select>
                        <select class="form-select wide">
                            <option value="">강의실 바로가기</option>
                            <option value="2025년 2학기">2025년 2학기</option>
                            <option value="2025년 1학기">2025년 1학기</option>
                        </select>
                    </div>
                    <div class="sec">
                        <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                        <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                    </div>
                </div>
            </div>

            <div class="class_sub">

                <%-- 기준 파일의 class-area 블록 적용 --%>
                <div class="segment class-area">

                    <%-- info-left --%>
                    <div class="info-left">
                        <div class="class_info">
                            <h2>
                                <span id="hdrSbjctNmTop">과목명</span>
                                <b id="hdrDvclasNoTop"></b>
                            </h2>
                            <div class="classSection">
                                <div class="cls_btn">
                                    <div class="tab_btn" id="crsclsTab">
                                        <a href="#tabWeekly" class="current" data-tab="weekly">주차별 수업현황</a>
                                        <a href="#tabElement" data-tab="element">학습요소 참여현황</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="info-cnt">
                            <div class="info_iconSet">
                                <a href="#0" class="info"><span>공지</span><div class="num_txt">-</div></a>
                                <a href="#0" class="info"><span>Q&amp;A</span><div class="num_txt point">-</div></a>
                                <a href="#0" class="info"><span>1:1</span><div class="num_txt point">-</div></a>
                                <a href="#0" class="info"><span>과제</span><div class="num_txt">-</div></a>
                                <a href="#0" class="info"><span>토론</span><div class="num_txt">-</div></a>
                                <a href="#0" class="info"><span>세미나</span><div class="num_txt">-</div></a>
                                <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">-</div></a>
                                <a href="#0" class="info"><span>설문</span><div class="num_txt">-</div></a>
                                <a href="#0" class="info"><span>시험</span><div class="num_txt">-</div></a>
                            </div>
                            <div class="info-set">
                                <div class="info">
                                    <p class="point">
                                        <span class="tit">중간고사:</span>
                                        <span id="midExamInfo">-</span>
                                    </p>
                                    <p class="desc">
                                        <span class="tit">시간:</span>
                                        <span id="midExamTime">-</span>
                                    </p>
                                </div>
                                <div class="info">
                                    <p class="point">
                                        <span class="tit">기말고사:</span>
                                        <span id="finalExamInfo">-</span>
                                    </p>
                                    <p class="desc">
                                        <span class="tit">시간:</span>
                                        <span id="finalExamTime">-</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%-- //info-left --%>

                    <%-- info-right --%>
                    <div class="info-right">

                        <div class="flex">

                            <%-- item user --%>
                            <div class="item user">
                                <div class="item_icon"><i class="icon-svg-group" aria-hidden="true"></i></div>

                                <div class="item_tit">
                                    <a href="#0" class="btn">접속현황<i class="xi-angle-down-min"></i></a>

                                    <div class="user-option-wrap">
                                        <div class="option_head">
                                            <div class="sort_btn">
                                                <button type="button">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button>
                                                <button type="button">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button>
                                            </div>
                                            <p class="user_num">접속: -</p>
                                            <button type="button" class="btn-close" aria-label="접속현황 닫기">
                                                <i class="icon-svg-close"></i>
                                            </button>
                                        </div>
                                        <ul class="user_area">
                                            <li>
                                                <div class="user-info">
                                                    <div class="user-photo">
                                                        <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                    </div>
                                                    <div class="user-desc">
                                                        <p class="name">-</p>
                                                        <p class="subject"><span class="major">[-]</span>-</p>
                                                    </div>
                                                    <div class="btn_wrap">
                                                        <button type="button"><i class="xi-info-o"></i></button>
                                                        <button type="button"><i class="xi-bell-o"></i></button>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <div class="item_info">
                                    <span class="big" id="stdntTotalCntTop">0</span>
                                    <span class="small">명</span>
                                </div>
                            </div>
                            <%-- //item user --%>

                            <div class="item attend">
                                <div class="item_icon"><i class="icon-svg-pie-chart-01" aria-hidden="true"></i></div>
                                <div class="item_tit">출석 현황</div>
                                <div class="item_info">
                                    <span class="big">-</span>
                                    <span class="small">%</span>
                                </div>
                            </div>

                            <div class="item week">
                                <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                <div class="item_tit">전체 주차</div>
                                <div class="item_info">
                                    <span class="big">${wkCnt}</span>
                                    <span class="small">주차</span>
                                </div>
                            </div>
                        </div>

                    </div>
                    <%-- //info-right --%>

                </div>
                <%-- //기준 파일의 class-area 블록 적용 --%>

                <div class="dashboard_sub">
                    <div class="sub-content">

                        <%-- ========================= --%>
                        <%-- TAB1: 주차별 수업현황     --%>
                        <%-- ========================= --%>
                        <div id="tabWeekly" class="tab-content">

                            <%-- 주차별 미학습자 비율 --%>
                            <div class="board_top">
                                <h4 class="sub-title">주차별 미학습자 비율</h4>
                            </div>

                            <div class="table-wrap">
                                <table class="table-type1">
                                    <colgroup>
                                        <col style="width:7%">
                                        <c:forEach begin="1" end="${wkCnt}"><col></c:forEach>
                                        <col style="width:7%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>구분</th>
                                        <c:forEach begin="1" end="${wkCnt}" var="w"><th>${w}</th></c:forEach>
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

                            <%-- 학습자 학습현황 헤더 --%>
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

                                    <%-- 검색 --%>
                                    <div class="search-typeC">
                                        <input class="form-control" type="text" id="srchKeyword2"
                                               placeholder="이름/학번/학과 입력">
                                        <button type="button" class="btn basic icon search"
                                                onclick="searchStdntList(1)">
                                            <i class="icon-svg-search"></i>
                                        </button>
                                    </div>

                                    <%-- 메시지 보내기 --%>
                                    <button type="button" class="btn basic" onclick="openSendMsg()">
                                        메시지 보내기
                                    </button>

                                    <%-- 엑셀 다운로드 --%>
                                    <button type="button" class="btn type2" onclick="downloadExcel()">
                                        <spring:message code="button.download.excel"/>
                                    </button>
                                </div>
                            </div>

                            <%-- 학습자 목록 테이블 --%>
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
                                        <c:forEach begin="1" end="${wkCnt}"><col></c:forEach>
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
                                        <c:forEach begin="1" end="${wkCnt}" var="w"><th>${w}</th></c:forEach>
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

                            <%-- 페이징 --%>
                            <div class="board_foot">
                                <div class="page_info">
                                    <span class="total_page">전체 <b id="stdntTotalCnt2">0</b>건</span>
                                    <span class="current_page">현재 페이지 <strong id="stdntCurPage">1</strong>/<span id="stdntTotalPage">1</span></span>
                                </div>
                                <div class="board_pager">
                                    <span class="inner">
                                        <button class="page" type="button" title="처음 페이지" onclick="searchStdntList(1)"><i class="icon-page-first"></i></button>
                                        <button class="page" type="button" title="이전 페이지" onclick="moveStdntPage('prev')"><i class="icon-page-prev"></i></button>
                                        <span class="pages" id="stdntPagerPages"></span>
                                        <button class="page" type="button" title="다음 페이지" onclick="moveStdntPage('next')"><i class="icon-page-next"></i></button>
                                        <button class="page" type="button" title="마지막 페이지" onclick="searchStdntList(stdntTotalPageCount)"><i class="icon-page-last"></i></button>
                                    </span>
                                </div>
                            </div>

                            <div style="height:120px;"></div>
                        </div>
                        <%-- //TAB1 --%>

                        <%-- ========================= --%>
                        <%-- TAB2: 학습요소 참여현황   --%>
                        <%-- ========================= --%>
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
                                        메시지 보내기
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

                            <%-- 페이징 --%>
                            <div class="board_foot">
                                <div class="page_info">
                                    <span class="total_page">전체 <b id="elemStdntTotalCnt2">0</b>명</span>
                                    <span class="current_page">현재 페이지 <strong id="elemStdntCurPage">1</strong>/<span id="elemStdntTotalPage">1</span></span>
                                </div>
                                <div class="board_pager">
                                    <span class="inner">
                                        <button class="page" type="button" title="처음 페이지" onclick="searchElemStdntList(1)"><i class="icon-page-first"></i></button>
                                        <button class="page" type="button" title="이전 페이지" onclick="moveElemPage('prev')"><i class="icon-page-prev"></i></button>
                                        <span class="pages" id="elemPagerPages"></span>
                                        <button class="page" type="button" title="다음 페이지" onclick="moveElemPage('next')"><i class="icon-page-next"></i></button>
                                        <button class="page" type="button" title="마지막 페이지" onclick="searchElemStdntList(elemStdntTotalPageCount)"><i class="icon-page-last"></i></button>
                                    </span>
                                </div>
                            </div>

                            <div style="height:120px;"></div>
                        </div>
                        <%-- //TAB2 --%>

                    </div>
                </div>
            </div>

        </div>
        <%-- //content --%>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>

    </main>
</div>

<%-- 메시지 보내기 공통 폼 (팝업에서 window.parent.alarmForm 으로 접근) --%>
<form name="alarmForm" method="POST" target="msgWindow">
    <input type="hidden" name="alarmType" value="S"/>
    <input type="hidden" name="sysCd" value="LMS"/>
    <input type="hidden" name="orgId" value="${orgId}"/>
    <input type="hidden" name="bussGbn" value="LMS"/>
    <input type="hidden" name="smsSndType" value="P"/>
    <input type="hidden" name="rcvUserInfoStr" value=""/>
</form>

<script>
    var CTX      = "<%=request.getContextPath()%>";
    var sbjctId  = "${sbjctId}";
    var dvclasNo = "${dvclasNo}";
    var initTab  = "${initTab}";

    // 주차 수
    var MAX_WK = Number("${wkCnt}");

    // TAB1 페이징
    var stdntCurrentPageNo  = 1;
    var stdntTotalPageCount = 1;

    // TAB2 페이징
    var elemStdntCurrentPageNo  = 1;
    var elemStdntTotalPageCount = 1;

    // 메시지 보내기용 사용자 목록
    var lastStdntUsers = [];
    var lastElemUsers  = [];

    $(function () {

        /* ===========================
           탭 전환
           =========================== */
        $("#crsclsTab a").on("click", function (e) {
            e.preventDefault();
            $("#crsclsTab a").removeClass("current");
            $(this).addClass("current");

            var target = $(this).attr("href");
            $(".tab-content").hide();
            $(target).show();

            var tabKey = $(this).data("tab");
            var title  = tabKey === "element" ? "학습요소 참여현황" : "주차별 수업현황";
            $("#topCrumbTitle").text(title);

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

        // 검색어 엔터
        $("#srchKeyword2").on("keydown", function (e) {
            if (e.keyCode === 13) { e.preventDefault(); searchStdntList(1); }
        });
        $("#elemStdntKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) { e.preventDefault(); searchElemStdntList(1); }
        });

        // 초기 탭 설정
        if (initTab === "element") {
            $('#crsclsTab a[href="#tabElement"]').trigger("click");
        } else {
            $('#crsclsTab a[href="#tabWeekly"]').trigger("click");
        }
    });

    /* ===========================
       과목명 헤더 로드
       =========================== */
    function loadHeader() {
        var params   = new URLSearchParams(location.search);
        var sbjctnm  = "<c:out value='${sbjctnm}'/>" || params.get("sbjctnm") || "";
        var dvclsNo  = params.get("dvclasNo") || "";
        $("#hdrSbjctNmTop").text(sbjctnm || "과목명");
        if (dvclsNo) $("#hdrDvclasNoTop").text(dvclsNo);
    }

    /* ===========================
       주차별 미학습자 비율
       =========================== */
    function loadWklyStats() {
        $.ajax({
            url: CTX + "/crscls/selectCrsClsWklyStats.do",
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
                        rates[wk - 1] = r.notLrnnRt == null ? null : Number(r.notLrnnRt);
                    }
                });

                var sumNotLrnnCnt = 0, sumTotalCnt = 0;
                res.returnList.forEach(function (r) {
                    sumNotLrnnCnt += Number(r.notLrnnCnt || 0);
                    sumTotalCnt   += Number(r.totalCnt   || 0);
                });
                var avg = sumTotalCnt > 0 ? (sumNotLrnnCnt / sumTotalCnt * 100) : null;

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
            url: CTX + "/crscls/selectCrsNotLrnnPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
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
            url: CTX + "/crscls/selectCrsClsStdntListPaging.do",
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
                $("#stdntTotalCntTop").text(cnt);
                $("#stdntTotalCnt2").text(cnt);
                $("#stdntCurPage").text(page);
                $("#stdntTotalPage").text(stdntTotalPageCount);
                renderStdntPager(page, stdntTotalPageCount);

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    lastStdntUsers = [];
                    window._lastStdntUserIds = [];
                    $body.append('<tr><td colspan="' + (MAX_WK + 8) + '" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                var list    = res.returnList || [];
                var perPage = (res.pageInfo && res.pageInfo.recordCountPerPage) ? res.pageInfo.recordCountPerPage : 20;

                lastStdntUsers = list.map(function (x) {
                    return { userId: x.userId || "", usernm: x.usernm || "", mobileNo: x.mobileNo || "", email: x.email || "" };
                }).filter(function (x) { return !!x.userId; });

                window._lastStdntUserIds = lastStdntUsers.map(function (x) { return x.userId; });

                function sts(v) {
                    if (v === 'ATND')  return '<span class="state_ok" aria-label="출석">○</span>';
                    if (v === 'LATE')  return '<span class="state_late" aria-label="지각">△</span>';
                    if (v === 'ABSNT') return '<span class="state_no" aria-label="결석">X</span>';
                    return '-';
                }

                function wkCell(uid, wkNo, v) {
                    return '<td class="t_center" data-th="' + wkNo + '주차">'
                        + (v ? '<a href="#_" class="wkCell" data-user-id="' + uid + '" data-wk-no="' + wkNo + '">' + sts(v) + '</a>' : '-')
                        + '</td>';
                }

                list.forEach(function (item, idx) {
                    var no    = ((stdntCurrentPageNo - 1) * perPage) + idx + 1;
                    var uid   = (item.userId || '');
                    var chkId = 'chkStdnt_' + idx;

                    var wkMap = {};
                    (item.wkStsList || []).forEach(function (x) { wkMap[x.wkNo] = x.atndSts; });

                    var row = '<tr>'
                        + '<td class="t_center"><span class="custom-input onlychk">'
                        + '<input type="checkbox" id="' + chkId + '"'
                        + ' data-user-id="'  + uid + '"'
                        + ' data-user-nm="'  + (item.usernm   || '') + '"'
                        + ' data-mobile="'   + (item.mobileNo || '') + '"'
                        + ' data-email="'    + (item.email    || '') + '"'
                        + '><label for="' + chkId + '"></label></span></td>'
                        + '<td class="t_center" data-th="번호">'    + no + '</td>'
                        + '<td class="t_center" data-th="학과">'    + (item.deptnm  || '-') + '</td>'
                        + '<td class="t_center" data-th="학번">'    + (item.stdntNo || '-') + '</td>'
                        + '<td class="t_center" data-th="이름"><a href="#_" class="link stdntName" data-user-id="' + uid + '">' + (item.usernm || '-') + '</a></td>'
                        + '<td class="t_center" data-th="입학년도">' + (item.entyR  || '-') + '</td>'
                        + '<td class="t_center" data-th="학년">'    + (item.scyr   || '-') + '</td>';

                    for (var w = 1; w <= MAX_WK; w++) { row += wkCell(uid, w, wkMap[w]); }

                    row += '<td class="t_center" data-th="출석/지각/결석">'
                        + '<span class="state_ok total_label" aria-label="출석">' + (item.atndCnt || 0) + '</span>'
                        + '<span class="state_late total_label" aria-label="지각">' + (item.lateCnt || 0) + '</span>'
                        + '<span class="state_no total_label" aria-label="결석">' + (item.absnCnt || 0) + '</span>'
                        + '</td></tr>';

                    $body.append(row);
                });
            }
        });
    }

    /* ===========================
       주차별 페이저 렌더링
       =========================== */
    function renderStdntPager(cur, total) {
        var html = '', pageSize = 5;
        var startPage = Math.floor((cur - 1) / pageSize) * pageSize + 1;
        var endPage   = Math.min(startPage + pageSize - 1, total);
        for (var p = startPage; p <= endPage; p++) {
            html += '<button class="page' + (p === cur ? ' active' : '') + '" type="button"'
                + ' onclick="searchStdntList(' + p + ')">' + p + '</button>';
        }
        $("#stdntPagerPages").html(html);
    }

    function moveStdntPage(direction) {
        if (direction === 'prev' && stdntCurrentPageNo > 1) searchStdntList(stdntCurrentPageNo - 1);
        else if (direction === 'next' && stdntCurrentPageNo < stdntTotalPageCount) searchStdntList(stdntCurrentPageNo + 1);
    }

    /* ===========================
       이름 클릭 → 학습자 학습현황 팝업
       =========================== */
    $(document).on("click", ".stdntName", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        if (!userId) { UiComm.showMessage("userId가 없습니다.", "warning"); return; }
        UiDialog("stdntLrnPop", {
            title: "학습자 학습현황",
            width: 1140, height: 820,
            url: CTX + "/crscls/selectCrsStdntWkPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo=1"
        });
    });

    /* ===========================
       주차 셀 클릭 → 주차별 학습기록 팝업
       =========================== */
    $(document).on("click", ".wkCell", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        var wkNo   = $(this).data("wkNo");
        if (!userId) { UiComm.showMessage("userId가 없습니다.", "warning"); return; }
        UiDialog("stdntWeekLrnPop_" + userId + "_" + wkNo, {
            title: "학습자 주차별 학습현황",
            width: 1140, height: 820,
            url: CTX + "/crscls/selectCrsStdntWkDetailPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo="     + wkNo
        });
    });

    /* ===========================
       주차별 탭 메시지 보내기
       =========================== */
    function openSendMsg() {
        var checkedUsers = [];
        $("#stdntBody input[type=checkbox]:checked").each(function () {
            var userId = $(this).data("userId");
            if (!userId) return;
            checkedUsers.push({ userId: userId, usernm: $(this).data("userNm") || "", mobileNo: $(this).data("mobile") || "", email: $(this).data("email") || "" });
        });

        var targets = checkedUsers.length > 0 ? checkedUsers : lastStdntUsers;
        if (!targets || targets.length === 0) { UiComm.showMessage("선택된 사용자가 없습니다.", "warning"); return; }

        var rcvUserInfoStr = targets.map(function (u) { return [u.userId, u.usernm, u.mobileNo, u.email].join(";"); }).join("|");
        var form = document.alarmForm;
        if (!form) { UiComm.showMessage("메시지 발송 폼을 찾을 수 없습니다.", "warning"); return; }
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value      = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    /* ===========================
       주차별 탭 엑셀 다운로드
       =========================== */
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
        $form.attr("action", CTX + "/crscls/selectCrsClsStdntListExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',      value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'srchKeyword',  value: $("#srchKeyword2").val()}));
        $form.append($('<input/>', {type:'hidden', name:'absnWknoFrom', value: parseInt($("#absnWknoFrom").val()) || 0}));
        $form.append($('<input/>', {type:'hidden', name:'absnWknoTo',   value: parseInt($("#absnWknoTo").val())   || 0}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid',    value: JSON.stringify({colModel: colModel})}));
        $form.appendTo("body").submit();
    }

    /* ===========================
       학습요소 참여현황 목록 조회
       =========================== */
    function searchElemStdntList(page) {
        elemStdntCurrentPageNo = page;
        $.ajax({
            url: CTX + "/crscls/selectCrsClsElemStats.do",
            type: "GET", dataType: "json",
            data: {
                sbjctId:   sbjctId,
                keyword:   $("#elemStdntKeyword").val(),
                pageIndex: page,
                listScale: 20
            },
            success: function (res) {
                var $body = $("#elemStdntBody").empty();
                var cnt   = res && res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                elemStdntTotalPageCount = res && res.pageInfo ? res.pageInfo.totalPageCount : 1;

                $("#elemStdntTotalCnt").text(cnt);
                $("#elemStdntTotalCnt2").text(cnt);
                $("#elemStdntCurPage").text(page);
                $("#elemStdntTotalPage").text(elemStdntTotalPageCount);
                renderElemPager(page, elemStdntTotalPageCount);

                var list = (res && res.returnList) ? res.returnList : [];

                lastElemUsers = list.map(function (x) {
                    return { userId: x.userId || "", usernm: x.usernm || "", mobileNo: x.mobileNo || "", email: x.email || "" };
                }).filter(function (x) { return !!x.userId; });

                window._lastElemUserIds = lastElemUsers.map(function (x) { return x.userId; });

                if (!res || res.result !== 1 || list.length === 0) {
                    $body.append('<tr><td colspan="13" class="t_center"><spring:message code="common.no.data.result"/></td></tr>');
                    return;
                }

                function linkCount(uid, text, elemType) {
                    return '<a href="#_" class="link" onclick="openStdntElemPopup(\'' + uid + '\',\'' + elemType + '\');return false;">' + text + '</a>';
                }

                list.forEach(function (r, idx) {
                    var uid   = (r.userId || '');
                    var chkId = 'chkElem_' + idx;
                    var qa    = (r.qaAnsCnt     || 0) + '/' + (r.qaRegCnt    || 0);
                    var asmt  = (r.asmtSbmsnCnt || 0) + '/' + (r.asmtTrgtCnt || 0);
                    var quiz  = (r.quizSbmsnCnt || 0) + '/' + (r.quizTrgtCnt || 0);
                    var srvy  = (r.srvySbmsnCnt || 0) + '/' + (r.srvyTrgtCnt || 0);
                    var dscc  = (r.dsccSbmsnCnt || 0) + '/' + (r.dsccTrgtCnt || 0);

                    $body.append(
                        '<tr>'
                        + '<td class="t_center"><span class="custom-input onlychk">'
                        + '<input type="checkbox" id="' + chkId + '"'
                        + ' data-user-id="'  + uid + '"'
                        + ' data-user-nm="'  + (r.usernm   || '') + '"'
                        + ' data-mobile="'   + (r.mobileNo || '') + '"'
                        + ' data-email="'    + (r.email    || '') + '"'
                        + '><label for="' + chkId + '"></label></span></td>'
                        + '<td class="t_center">' + (r.lineNo || idx + 1) + '</td>'
                        + '<td class="t_center">' + (r.deptnm  || '') + '</td>'
                        + '<td class="t_center">' + (r.stdntNo || '') + '</td>'
                        + '<td class="t_center"><a href="#_" class="link elemStdntName" data-user-id="' + uid + '">' + (r.usernm || '') + '</a></td>'
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
                $("#elemStdntBody").html('<tr><td colspan="13" class="t_center"><spring:message code="fail.common.msg"/></td></tr>');
            }
        });
    }

    /* ===========================
       학습요소 페이저 렌더링
       =========================== */
    function renderElemPager(cur, total) {
        var html = '', pageSize = 5;
        var startPage = Math.floor((cur - 1) / pageSize) * pageSize + 1;
        var endPage   = Math.min(startPage + pageSize - 1, total);
        for (var p = startPage; p <= endPage; p++) {
            html += '<button class="page' + (p === cur ? ' active' : '') + '" type="button"'
                + ' onclick="searchElemStdntList(' + p + ')">' + p + '</button>';
        }
        $("#elemPagerPages").html(html);
    }

    function moveElemPage(direction) {
        if (direction === 'prev' && elemStdntCurrentPageNo > 1) searchElemStdntList(elemStdntCurrentPageNo - 1);
        else if (direction === 'next' && elemStdntCurrentPageNo < elemStdntTotalPageCount) searchElemStdntList(elemStdntCurrentPageNo + 1);
    }

    /* ===========================
       학습요소 탭 이름 클릭 → 학습자 학습현황 팝업
       =========================== */
    $(document).on("click", ".elemStdntName", function (e) {
        e.preventDefault();
        var userId = $(this).data("userId");
        if (!userId) { UiComm.showMessage("userId가 없습니다.", "warning"); return; }
        UiDialog("stdntLrnPop_" + userId, {
            title: "학습자 학습현황",
            width: 1140, height: 820,
            url: CTX + "/crscls/selectCrsStdntWkPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&wkNo=1"
        });
    });

    /* ===========================
       학습요소 셀 클릭 → 학습요소 참여현황 팝업
       =========================== */
    function openStdntElemPopup(userId, elemType) {
        UiDialog("stdntElemPop", {
            title: "학습자 참여현황",
            width: 1140, height: 820,
            url: CTX + "/crscls/selectCrsStdntElemPopupView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId="   + encodeURIComponent(userId)
                + "&elemType=" + encodeURIComponent(elemType || "ASMT")
        });
    }

    /* ===========================
       학습요소 탭 메시지 보내기
       =========================== */
    function openElemSendMsg() {
        var checkedUsers = [];
        $("#elemStdntBody input[type=checkbox]:checked").each(function () {
            var userId = $(this).data("userId");
            if (!userId) return;
            checkedUsers.push({ userId: userId, usernm: $(this).data("userNm") || "", mobileNo: $(this).data("mobile") || "", email: $(this).data("email") || "" });
        });

        var targets = checkedUsers.length > 0 ? checkedUsers : lastElemUsers;
        if (!targets || targets.length === 0) { UiComm.showMessage("선택한 사용자가 없습니다.", "warning"); return; }

        var rcvUserInfoStr = targets.map(function (u) { return [u.userId, u.usernm, u.mobileNo, u.email].join(";"); }).join("|");
        var form = document.alarmForm;
        if (!form) { UiComm.showMessage("메시지 발송 폼을 찾을 수 없습니다.", "warning"); return; }
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value      = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    /* ===========================
       학습요소 탭 엑셀 다운로드
       =========================== */
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
        $form.attr("action", CTX + "/crscls/selectCrsClsElemStatsExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',   value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'keyword',   value: $("#elemStdntKeyword").val()}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    /* ===========================
       출석처리/취소 콜백
       =========================== */
    function saveForcedAttendCallBack() {
        searchStdntList(stdntCurrentPageNo || 1);
        loadWklyStats();
    }

    function cancelForcedAttendCallBack() {
        searchStdntList(stdntCurrentPageNo || 1);
        loadWklyStats();
    }
</script>

</body>
</html>
