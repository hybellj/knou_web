<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="chart"/>
	</jsp:include>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="class_sub_top">
                    <div class="navi_bar">
                        <ul>
                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                            <li>강의실</li>
                            <li><span class="current">내강의실</span></li>
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
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>학습자 매뉴얼</button>
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area stu">
                        <div class="info-left">
                            <div class="class_info">
                                <p class="labels">
                                    <label class="label uniA">대학원</label>
                                </p>
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                            </div>
                            <div class="class_detail">
                                <div class="detail_txt">
                                    <p class="desc">
                                        <span>교수:<strong>홍길동</strong></span>
                                        <span>튜터:<strong>김여름</strong></span>
                                        <span>학점:<strong>3학점</strong></span>
                                    </p>
                                    <p class="desc">
                                        <span>학습기간:<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                    </p>
                                </div>

                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn"><em>강의</em>계획서</a>
                                        <a href="#0" class="btn"><em>평가</em>기준</a>
                                        <a href="#0" class="btn"><em>강의실</em>나가기</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">

                            <div class="flex">
                                <div class="item_list">
                                    <div class="item user">
                                        <div class="item_icon"><i class="icon-svg-group" aria-hidden="true"></i></div>
                                        <div class="item_tit">
                                            <a href="#0" class="btn ">접속현황
                                                <i class="xi-angle-down-min"></i>
                                            </a>
                                            <!-- 접속 현황 레이어 -->
                                            <div class="user-option-wrap">
                                                <div class="option_head">
                                                    <div class="sort_btn">
                                                        <button type="button">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button>
                                                        <button type="button">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button>
                                                    </div>
                                                    <p class="user_num">접속: 37</p>
                                                    <button type="button" class="btn-close" aria-label="접속현황 닫기">
                                                        <i class="icon-svg-close"></i>
                                                    </button>
                                                </div>
                                                <ul class="user_area">
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">나방송</p>
                                                                <p class="subject"><span class="major">[대학원]</span>정보와기술</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button"><i class="xi-info-o"></i></button>
                                                                <button type="button"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">최남단</p>
                                                                <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button"><i class="xi-info-o"></i></button>
                                                                <button type="button"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">나방송</p>
                                                                <p class="subject"><span class="major">[대학원]</span>정보와기술</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button"><i class="xi-info-o"></i></button>
                                                                <button type="button"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">최남단</p>
                                                                <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button"><i class="xi-info-o"></i></button>
                                                                <button type="button"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">최남단</p>
                                                                <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
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
                                            <span class="big">37</span>
                                            <span class="small">250</span>
                                        </div>
                                    </div>

                                    <div class="item week">
                                        <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                        <div class="item_tit">2025.04.14 ~ 04.20</div>
                                        <div class="item_info">
                                            <span class="big">7</span>
                                            <span class="small">주차</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="chart_list">
                                    <div class="chart_my">
                                        <div class="chart_wrap">
                                            <div id="arcMy" class="donut_chart"></div>
                                            <div class="middle_text">
                                                <span class="chart_value_my"></span>
                                                <span><em>나의</em><em>진도율</em></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="chart_average">
                                        <div class="chart_wrap">
                                            <div id="arcAverage" class="donut_chart"></div>
                                            <div class="middle_text">
                                                <span class="chart_value_average"></span>
                                                <span><em>평균</em><em>진도율</em></span>
                                            </div>
                                        </div>

                                    </div>

                                    <script>
                                        $(document).ready(function () {

                                            // 나의 진도율 차트 그리기
                                            function drawChartMy() {
                                                var containerWidth = $('#arcMy').width();
                                                var size = Math.min(containerWidth, 140);
                                                var width = size;
                                                var height = size;
                                                var outerRadius = size / 2 * 0.98; // 90% 크기
                                                var innerRadius = outerRadius * 0.7;

                                                d3.select("#arcMy").selectAll("svg").remove();

                                                function fn_getArc(ammount, total) {
                                                    return d3.arc()
                                                        .innerRadius(innerRadius)
                                                        .outerRadius(outerRadius)
                                                        .startAngle(0)
                                                        .endAngle(fn_getPercent_pie(ammount, total))
                                                        .cornerRadius(100);
                                                }

                                                // pie 각도 함수
                                                function fn_getPercent_pie(ammount, total) {
                                                    var ratio = ammount / total;
                                                    return Math.PI * 2 * ratio;
                                                }

                                                // 데이터
                                                var data = { cnt: 70, all: 100 };

                                                var svg = d3.select("#arcMy")
                                                    .append("svg")
                                                    .attr("width", width)
                                                    .attr("height", height)
                                                    .append("g")
                                                    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

                                                // 그라데이션 정의
                                                var defs = svg.append("defs");

                                                var gradient = defs.append("linearGradient")
                                                    .attr("id", "attendanceGradientMy")
                                                    .attr("x1", "0%").attr("y1", "0%")
                                                    .attr("x2", "100%").attr("y2", "100%");

                                                gradient.append("stop")
                                                    .attr("offset", "0%")
                                                    .attr("stop-color", "#E25DCA");

                                                gradient.append("stop")
                                                    .attr("offset", "100%")
                                                    .attr("stop-color", "#F283DD");

                                                // 배경
                                                svg.append("path")
                                                    .attr("class", "arc")
                                                    .attr("d", fn_getArc(100, 100))
                                                    .attr("fill", "#EBEBEB");

                                                // 실제 데이터
                                                svg.append("path")
                                                    .attr("class", "arcMy")
                                                    .attr("d", fn_getArc(data.cnt, data.all))
                                                    .attr("fill", "url(#attendanceGradientMy)");

                                                // 중앙 텍스트 업데이트
                                                $('.chart_value_my').text(data.cnt + '%');
                                            }

                                            // 평균 진도율 차트 그리기
                                            function drawChartAverage() {
                                                var containerWidth = $('#arcAverage').width();
                                                var size = Math.min(containerWidth, 140);
                                                var width = size;
                                                var height = size;
                                                var outerRadius = size / 2 * 0.98; // 90% 크기
                                                var innerRadius = outerRadius * 0.7;

                                                d3.select("#arcAverage").selectAll("svg").remove();

                                                function fn_getArc(ammount, total) {
                                                    return d3.arc()
                                                        .innerRadius(innerRadius)
                                                        .outerRadius(outerRadius)
                                                        .startAngle(0)
                                                        .endAngle(fn_getPercent_pie(ammount, total))
                                                        .cornerRadius(100);
                                                }

                                                // pie 각도 함수
                                                function fn_getPercent_pie(ammount, total) {
                                                    var ratio = ammount / total;
                                                    return Math.PI * 2 * ratio;
                                                }

                                                // 데이터
                                                var data = { cnt: 60, all: 100 };

                                                var svg = d3.select("#arcAverage")
                                                    .append("svg")
                                                    .attr("width", width)
                                                    .attr("height", height)
                                                    .append("g")
                                                    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

                                                // 그라데이션 정의
                                                var defs = svg.append("defs");

                                                var gradient = defs.append("linearGradient")
                                                    .attr("id", "attendanceGradientAverage")
                                                    .attr("x1", "0%").attr("y1", "0%")
                                                    .attr("x2", "100%").attr("y2", "100%");

                                                gradient.append("stop")
                                                    .attr("offset", "0%")
                                                    .attr("stop-color", "#41A5EC");

                                                gradient.append("stop")
                                                    .attr("offset", "100%")
                                                    .attr("stop-color", "#84C2EE");

                                                // 배경
                                                svg.append("path")
                                                    .attr("class", "arc")
                                                    .attr("d", fn_getArc(100, 100))
                                                    .attr("fill", "#EBEBEB");

                                                // 실제 데이터
                                                svg.append("path")
                                                    .attr("class", "arc")
                                                    .attr("d", fn_getArc(data.cnt, data.all))
                                                    .attr("fill", "url(#attendanceGradientAverage)");

                                                // 중앙 텍스트 업데이트
                                                $('.chart_value_average').text(data.cnt + '%');
                                            }

                                            // 차트 그리기
                                            drawChartMy();
                                            drawChartAverage();

                                            // 창 크기 변경 시 다시 그리기
                                            $(window).resize(function () {
                                                drawChartMy();
                                                drawChartAverage();
                                            });
                                        });
                                    </script>
                                </div>

                            </div>

                        </div>

                    </div>
                    <!-- //강의실 상단 -->

                    <div class="segment-row">

                        <!-- 공지사항 -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-notice"></i>
                                <h3 class="h3">과목 공지사항</h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li class="dot">
                                        <a href="#0" class="item_txt">
                                            <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_no">읽지않음</label>
                                        </div>
                                    </li>
                                    <li class="dot">
                                        <a href="#0" class="item_txt">
                                            <p class="tit">퀴즈가 등록되었습니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_ok">읽음</label>
                                        </div>
                                    </li>
                                    <li class="dot">
                                        <a href="#0" class="item_txt">
                                            <p class="tit">중간고사 기간 안내입니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_ok">읽음</label>
                                        </div>
                                    </li>
                                </ul>
                            </div>

                        </div>

                        <!-- 강의Q&A -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-question"></i>
                                <h3 class="h3">강의 Q&A <small class="msg_num">1</small></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li>
                                        <div class="user">
                                           <span class="user_img"></span>
                                        </div>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">과제 제출 언제까지 인가요?</p>
                                            <p class="desc">
                                                <span class="name">김길동</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_no">미답변</label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="user">
                                           <span class="user_img"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"></span>
                                        </div>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">강의 내용 중에 이해가 안되는 부분이 있습니다.</p>
                                            <p class="desc">
                                                <span class="name">김길동</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_reply">답변</label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="user">
                                           <span class="user_img"></span>
                                        </div>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">과제 제출 언제까지 인가요?</p>
                                            <p class="desc">
                                                <span class="name">김길동</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_reply">답변</label>
                                        </div>
                                    </li>
                                </ul>
							</div>

                        </div>

                        <!-- 자료실 -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-save"></i>
                                <h3 class="h3">자료실</h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li class="dot">
                                        <a href="#0" class="item_txt">
                                            <p class="tit">1주차 강의자료 업로드</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                    <li class="dot">
                                        <a href="#0" class="item_txt">
                                            <p class="tit">실전 NoSQL 데이터베이스 활용 자료입니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                    <li class="dot">
                                        <a href="#0" class="item_txt">
                                            <p class="tit">SQL 성능 튜닝 예제 모음집</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                </ul>
                            </div>

                        </div>

                    </div>

                    <div class="segment">
                        <div class="state-info-label">
                            <p class="pre"><i class="icon-svg-state"></i>학습 미진행</p>
                            <p class="ok"><i class="icon-svg-state"></i>학습완료</p>
                            <p class="ing"><i class="icon-svg-state"></i>학습 진행중</p>
                            <p class="no"><i class="icon-svg-state"></i>학습 미완료</p>
                        </div>
                        <div class="week_area">
                            <div class="info-week">
                                <div class="title">학습현황</div>
                                <div class="week_state_list">
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">1</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">2</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">3</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">4</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">5</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon no" aria-label="학습 미완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">6</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">7</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon test_ok" aria-label="시험 완료"><i class="icon-svg-state"></i></div>
                                        <span class="week">중간</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ing" aria-label="학습 진행중"><i class="icon-svg-state"></i></div>
                                        <span class="week">9</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>
                                        <span class="week">10</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>
                                        <span class="week">11</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>
                                        <span class="week">12</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>
                                        <span class="week">13</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>
                                        <span class="week">14</span>
                                    </div>
                                    <div class="state">
                                        <div class="state_icon test" aria-label="시험 미진행"><i class="icon-svg-state"></i></div>
                                        <span class="week">기말</span>
                                    </div>

                                </div>
                            </div>
                            <div class="info-set">
                                <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                <div class="info">
                                    <p class="point">
                                        <span class="tit">중간고사:</span>
                                        <span>2025.04.26 16:00</span>
                                    </p>
                                    <p class="desc">
                                        <span class="tit">시간:</span>
                                        <span>40분</span>
                                    </p>
                                </div>
                                <div class="info">
                                    <p class="point">
                                        <span class="tit">기말고사:</span>
                                        <span>2025.07.02 16:00</span>
                                    </p>
                                    <p class="desc">
                                        <span class="tit">시간:</span>
                                        <span>40분</span>
                                    </p>
                                </div>
                            </div>
                        </div>


                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">강의목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">주차 접음</button>
                                <select class="form-select">
                                    <option value="전체 주차">전체 주차</option>
                                    <option value="1주차">1주차</option>
                                    <option value="2주차">2주차</option>
                                    <option value="3주차">3주차</option>
                                    <option value="4주차">4주차</option>
                                    <option value="5주차">5주차</option>
                                </select>
                                <a href="#0" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                            </div>
                        </div>

                        <div class="course_list">
                            <ul class="course_week_card">
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">1주차 강의</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>우리 생활 주변의 데이터베이스</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>강의시간<strong>106분</strong><strong>순차학습</strong></span>
                                                <span>진도율<strong class="navy">52%</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">강의보기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">1주차 강의</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>데이터베이스 관리 시스템</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>강의시간<strong>40분</strong><strong>순차학습</strong></span>
                                                <span>진도율<strong class="navy">65%</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">강의보기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">1주차 과제</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>기간<strong>2025.03.06 10:00 ~ 2025.04.12 22:00</strong></span>
                                                <span>성적공개<strong>공개</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">제출하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">1주차 토론</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_debate">토론</label>
                                                </p>
                                                <strong>찬반토론</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>기간<strong>2025.03.06 10:00 ~ 2025.04.12 22:00</strong></span>
                                                <span>성적공개<strong>공개</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">참여하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">1주차 학습자료</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">자료</label>
                                                </p>
                                                <strong>학습자료제목</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>자료형태<strong>PDF</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">다운로드<i class="icon-svg-download" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">1주차 학습자료</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">자료</label>
                                                </p>
                                                <strong>학습자료제목 학습자료제목 2</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>자료형태<strong>웹링크</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">웹링크<i class="icon-svg-link" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">2주차 강의</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>콘텐츠 제목 3</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>강의시간<strong>80분</strong><strong>선택학습</strong></span>
                                                <span>진도율<strong class="navy">36%</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">강의보기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">2주차 강의</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>콘텐츠 제목 4</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>강의시간<strong>80분</strong><strong>선택학습</strong></span>
                                                <span>진도율<strong class="navy">45%</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">강의보기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">2주차 토론</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_debate">토론</label>
                                                </p>
                                                <strong>토론 제목 제목</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>기간<strong>2025.03.06 10:00 ~ 2025.04.12 22:00</strong></span>
                                                <span>성적공개<strong>공개</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">참여하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">3주차 세미나</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_seminar">세미나</label>
                                                </p>
                                                <strong>화상세미나</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>시작일시<strong>2025.03.06 10:00</strong></span>
                                                <span>진행시간<strong>102분</strong></span>
                                                <span><strong>출석인정</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">참여하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">4주차 강의</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>콘텐츠 제목 5</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>강의시간<strong>80분</strong><strong>선택학습</strong></span>
                                                <span>진도율<strong class="navy">- %</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go" disabled>강의보기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">4주차 과제</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>
                                                <strong>관계형 모델로 변환해보기</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>기간<strong>2025.03.06 10:00 ~ 2025.04.12 22:00</strong></span>
                                                <span>성적공개<strong>공개</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go" disabled>제출하기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">4주차 학습자료</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">자료</label>
                                                </p>
                                                <strong>학습자료제목 학습자료제목 3</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>자료형태<strong>웹링크</strong></span>
                                                <span>공개일자<strong>2025.06.20 10:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">웹링크<i class="icon-svg-link" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">15주차 기말고사</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_test">시험</label>
                                                </p>
                                                <strong>실시간시험 기말고사</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>시험일시<strong>2025.03.06 10:00</strong></span>
                                                <span>시험시간<strong>50분</strong></span>
                                                <span><strong>출석인정</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">시험응시<i class="icon-svg-arrow" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="card_item">
                                        <div class="item_header">
                                            <div class="title_area">
                                                <p class="tit">15주차 기말고사</p>
                                            </div>
                                             <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_test">대체과제</label>
                                                </p>
                                                <strong>대체과제명1111111</strong>
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                <span>기간<strong>2025.07.21 10:00 ~ 2025.04.23 22:00</strong></span>
                                                <span>성적공개<strong>공개</strong></span>
                                                <span>공개일자<strong>2026.07.30 22:00</strong></span>
                                            </p>
                                        </div>
                                        <div class="bottom_button">
                                            <button class="go">제출하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>

                    </div>

                </div>

            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

