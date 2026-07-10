<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>

    <script src="../../webdoc/uilib/chart/chart4.min.js"></script>
    <script src="../../webdoc/uilib/chart/chart-utils.min.js"></script>
    <script src="../../webdoc/uilib/chart/chartjs-plugin-datalabels.min.js"></script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/class_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/class_gnb_prof.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="class_sub_top">
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
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area sub">
                        <div class="class_info">
                            <div class="class_tit">
                                <p class="labels">
                                    <label class="label uniA">대학원</label>
                                </p>
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                            </div>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의실</li>
                                    <li><span class="current">수업일정</span></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->


                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">수업일정</h2>
                        </div>
                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="schedule-calendar week-view">
                            <!-- 캘린더 상단 컨트롤 -->
                            <div class="cal-toolbar">
                                <div class="cal-toolbar-left">
                                    <button type="button" class="btn">오늘</button>
                                </div>
                                <div class="cal-toolbar-center">
                                    <div class="cal-nav">
                                        <button type="button" class="nav-btn prev" aria-label="이전 달"><i class="xi-angle-left" aria-hidden="true"></i></button>
                                        <strong class="cal-period">2026.03</strong>
                                        <button type="button" class="nav-btn next" aria-label="다음 달"><i class="xi-angle-right" aria-hidden="true"></i></button>
                                    </div>
                                </div>
                                <div class="cal-toolbar-right">
                                    <div class="cal-view-toggle" role="tablist" aria-label="보기 전환">
                                        <!-- 버튼 활성화시 type1스타일 -->
                                        <button type="button" class="btn type1" role="tab" aria-selected="true">주별</button>
                                        <button type="button" class="btn" role="tab" aria-selected="false">월별</button>
                                    </div>
                                </div>
                            </div>

                            <!-- 주별 캘린더 본문 -->
                            <div class="cal-week-view">
                                <!-- 좌측 주 선택 사이드바 -->
                                <aside class="cal-week-sidebar" aria-label="주 선택">
                                    <ul class="week-list" role="tablist">
                                        <li role="presentation"><button type="button" class="btn" role="tab" aria-selected="false">1 주</button></li>
                                        <!-- 버튼 활성화시 type1스타일 -->
                                        <li role="presentation"><button type="button" class="btn type1" role="tab" aria-selected="true">2 주</button></li>
                                        <li role="presentation"><button type="button" class="btn" role="tab" aria-selected="false">3 주</button></li>
                                        <li role="presentation"><button type="button" class="btn" role="tab" aria-selected="false">4 주</button></li>
                                        <li role="presentation"><button type="button" class="btn" role="tab" aria-selected="false">5 주</button></li>
                                    </ul>
                                </aside>

                                <div class="cal-week-body table-wrap" role="grid" aria-label="2026년 3월 2주차 일별 일정">
                                    <div class="cal-day-row sun" role="row">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">7</span>
                                            <span class="cal-weekname">(일)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <!-- 일정 없음 -->
                                        </div>
                                    </div>
                                    <div class="cal-day-row" role="row">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">8</span>
                                            <span class="cal-weekname">(월)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <ul class="cal-events">
                                                <li>
                                                    <span class="dot dot-red"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-label">[과제]</span>
                                                        <span class="ev-title">과제명001</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="cal-day-row" role="row">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">9</span>
                                            <span class="cal-weekname">(화)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <ul class="cal-events">
                                                <li>
                                                    <span class="dot dot-red"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-label">[과제]</span>
                                                        <span class="ev-title">과제명001</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <!-- 수요일 (오늘) -->
                                    <div class="cal-day-row today" role="row" aria-current="date">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">10</span>
                                            <span class="cal-weekname">(수)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <ul class="cal-events">
                                                <li>
                                                    <span class="dot dot-red"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-label">[과제]</span>
                                                        <span class="ev-title">과제명001</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="cal-day-row" role="row">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">11</span>
                                            <span class="cal-weekname">(목)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <ul class="cal-events">
                                                <li>
                                                    <span class="dot dot-red"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-label">[과제]</span>
                                                        <span class="ev-title">과제명001</span>
                                                    </a>
                                                </li>
                                                <li>
                                                    <span class="dot dot-gray"></span>
                                                    <a href="#0" class="ev-link" data-modal="modal1">
                                                        <span class="ev-label">[개별]</span>
                                                        <span class="ev-title">과제등록</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="cal-day-row" role="row">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">12</span>
                                            <span class="cal-weekname">(금)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <ul class="cal-events">
                                                <li>
                                                    <span class="dot dot-red"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-label">[과제]</span>
                                                        <span class="ev-title">과제명001</span>
                                                    </a>
                                                </li>
                                                <li>
                                                    <span class="dot dot-orange"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-lavel">[토론]</span>
                                                        <span class="ev-title">토론명001</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="cal-day-row sat" role="row">
                                        <div class="cal-day-label" role="rowheader">
                                            <span class="cal-date">13</span>
                                            <span class="cal-weekname">(토)</span>
                                        </div>
                                        <div class="cal-day-events" role="gridcell">
                                            <ul class="cal-events">
                                                <li>
                                                    <span class="dot dot-red"></span>
                                                    <a href="#0" class="ev-link">
                                                        <span class="ev-label">[과제]</span>
                                                        <span class="ev-title">과제명001</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- //schedule calendar -->

                    </div>

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->
    </div>

</body>
</html>
