<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard">

                    <div class="grid inline">
                        <!-- Today -->
                        <div class="box">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">TODAY</h3>
                            </div>
                            <div class="box_content">
                                <div class="today_stu">
                                    <div class="chart_wrap">
                                        <div id="arc" class="donut_chart"></div>
                                        <div class="middle_text">
                                            <span class="chart_value"></span>
                                            <span><em>강의</em><em>전체출석</em></span>
                                        </div>
                                    </div>
                                    <script>
                                        $(document).ready(function () {

                                        function drawChart() {
                                            // 컨테이너 크기에 맞게 크기 조절 (최대 158px)
                                            var containerWidth = $('#arc').width();
                                            var size = Math.min(containerWidth, 158);
                                            var width = size;
                                            var height = size;

                                            // 반지름 계산 (size 기준 비율로)
                                            var outerRadius = size / 2 * 0.98; // 90% 크기
                                            var innerRadius = outerRadius * 0.7;

                                            // 기존 svg 삭제 (다시 그리기 대비)
                                            d3.select("#arc").selectAll("svg").remove();

                                            // arc 함수 다시 정의 (반지름 반영)
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

                                            var svg = d3.select("#arc")
                                                .append("svg")
                                                .attr("width", width)
                                                .attr("height", height)
                                                .append("g")
                                                .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

                                            // 그라데이션 정의
                                            var defs = svg.append("defs");

                                            var gradient = defs.append("linearGradient")
                                                .attr("id", "attendanceGradient")
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
                                                .attr("fill", "url(#attendanceGradient)");

                                            // 중앙 텍스트 업데이트
                                            $('.chart_value').text(data.cnt + '%');
                                        }

                                        drawChart();

                                        // 창 크기 변경 시 다시 그리기
                                        $(window).resize(function () {
                                            drawChart();
                                        });
                                    });

                                    </script>


                                    <div class="info_wrap">

                                        <ul class="sec_list">
                                            <li>
                                                <span class="tit">Today</span>
                                                <span class="desc">2025.05.20</span>
                                            </li>
                                            <li>
                                                <div class="sec_item_tit">
                                                    <a href="#0" class="btn " >접속
                                                        <i class="xi-angle-down-min"></i>
                                                    </a>
                                                    <!-- 접속 현황 레이어 -->
                                                    <div class="user-option-wrap">
                                                        <div class="option_head">
                                                            <div class="sort_btn">
                                                                <button type="button" aria-label="이름 오름차순 정렬">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button>
                                                                <button type="button" aria-label="이름 내림차순 정렬">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button>
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
                                                                        <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                        <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
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
                                                                        <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                        <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
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
                                                                        <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                        <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
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
                                                                        <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                        <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
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
                                                                        <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                        <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
                                                                    </div>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <span class="desc"><strong>37</strong>250</span>
                                            </li>
                                            <li>
                                                <span class="tit">결시원신청</span>
                                                <span class="desc"><strong>2</strong>10</span>
                                            </li>
                                            <li>
                                                <span class="tit">장애인지원신청</span>
                                                <span class="desc"><strong>5</strong>5</span>
                                            </li>
                                            <li>
                                                <span class="tit help" data-tooltip="이의신청 미처리 건수가 있습니다." data-position="top center">성적이의신청<small class="msg_num"></small></span>
                                                <span class="desc"><strong>3</strong>5</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>


                            </div>
                        </div>


                        <!-- 학사일정 -->
                        <div class="box">
                            <div class="box_title padding-right-0">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3"><em>이달의</em> 학사일정</h3>
                                <div class="btn-wrap">
                                    <div class="schedule-head">
                                        <a class="btn-prev" href="#" aria-label="이전달"><i class="xi-angle-left-min"></i></a>
                                        <div class="this-month">4<small>월</small></div>
                                        <a class="btn-next" href="#" aria-label="다음달"><i class="xi-angle-right-min"></i></a>
                                    </div>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="sche_list">
                                    <li>
                                        <div class="item_box">
                                            <div class="s_date">03.18 ~ 04.01</div>
                                            <div class="s_txt">
                                                <p class="tit">중간고사 시험문제 등록/출제/검수</p>
                                                <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="item_box">
                                            <div class="s_date">04.05 ~ 06.12</div>
                                            <div class="s_txt">
                                                <p class="tit">결시원 승인</p>
                                                <p class="desc">[대학원] 경영수리와 통계1반</p>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="item_box">
                                            <div class="s_date">04.08 ~ 04.11</div>
                                            <div class="s_txt">
                                                <p class="tit">2025학년도 1학기 중간고사</p>
                                                <p class="desc">[대학원] 경영수리와 통계1반</p>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="item_box">
                                            <div class="s_date">04.18 ~ 04.22</div>
                                            <div class="s_txt">
                                                <p class="tit">시험문제 등록/출제/검수</p>
                                                <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
                                            </div>
                                        </div>
                                    </li>

                                </ul>
                            </div>
                        </div>


                        <!-- 공지사항 -->
                        <div class="box notice">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">공지사항</h3>
                                <!--tab-type1-->
                                <nav class="tab-type1">
                                    <a href="#tab21" class="btn current"><span>전체</span></a>
                                    <a href="#tab22" class="btn "><span>전체공지</span></a>
                                    <a href="#tab23" class="btn "><span>과목공지</span></a>
                                </nav>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <div id="tab21" class="tab-content" style="display: block;">
                                    <ul class="dash_item_listA">
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelA">전체</label>
                                            </div>
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
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelB">과목</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
                                                <p class="desc">
                                                    <span class="name">[대학원] 경영수리와 통계1반</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelB">과목</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                                <p class="desc">
                                                    <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </li>
                                    </ul>
                                </div>

                                <div id="tab22" class="tab-content" style="display: none;">
                                    <ul class="dash_item_listA">
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelA">전체</label>
                                            </div>
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
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelA">전체</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                                <p class="desc">
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelA">전체</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">1학기 성적처리 기준 안내입니다.</p>
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

                                <div id="tab23" class="tab-content" style="display: none;">
                                    <ul class="dash_item_listA">
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelB">과목</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                                <p class="desc">
                                                    <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelB">과목</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
                                                <p class="desc">
                                                    <span class="name">[대학원] 경영수리와 통계1반</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="noti_label">
                                                <label class="labelB">과목</label>
                                            </div>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                                <p class="desc">
                                                    <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
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
                        </div>

                    </div>

                    <div class="grid inline">
                        <!-- 알림 -->
                        <div class="box">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">알림</h3>
                                <!--tab-type1-->
                                <nav class="tab-type1 alrim">
                                    <a href="#tab11" class="btn current"><span><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/alrim_icon_push.svg" aria-hidden="true" alt="PUSH"></span><small class="msg_num">9</small></a>
                                    <a href="#tab12" class="btn "><span><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/alrim_icon_sms.svg" aria-hidden="true" alt="SMS"></span><small class="msg_num">3</small></a>
                                    <a href="#tab13" class="btn "><span><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/alrim_icon_msg.svg" aria-hidden="true" alt="쪽지"></span><small class="msg_num">2</small></a>
                                    <a href="#tab14" class="btn "><span><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/alrim_icon_talk.svg" aria-hidden="true" alt="알림톡"></span><small class="msg_num">1</small></a>
                                </nav>

                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <div id="tab11" class="tab-content" style="display: block;"> <!--탭메뉴 클릭 시 style="display: block;" 또는 style="display: none;"-->
                                    <!-- push list -->
                                    <div class="alrim_item_area">
                                        <div class="item_box push">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">경영수리와 통계1반</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_no">읽지않음</label>
                                            </div>
                                        </div>
                                        <div class="item_box push">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">데이터베이스의 이해와 활용</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">토론 등록되었습니다. </p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_no">읽지않음</label>
                                            </div>
                                        </div>
                                        <div class="item_box push">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">경영수리와 통계1반</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">중간고사 7일 전입니다.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div id="tab12" class="tab-content" style="display: none;">
                                    <!-- SMS list -->
                                    <div class="alrim_item_area">
                                        <div class="item_box sms">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">안녕하세요. 서버 점검 안내 드립니다.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                        <div class="item_box sms">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">안녕하세요. 서버 점검 안내 드립니다.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                        <div class="item_box sms">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">안녕하세요. 서버 점검 안내 드립니다.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div id="tab13" class="tab-content" style="display: none;">
                                    <!-- msg list -->
                                    <div class="alrim_item_area">
                                        <div class="item_box msg">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">김학생</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">교수님! 경영통계 수업 듣는 학생입니다.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                        <div class="item_box msg">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">김학생</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">안녕하세요. 교수님~</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div id="tab14" class="tab-content" style="display: none;">
                                    <!-- talk list -->
                                    <div class="alrim_item_area">
                                        <div class="item_box talk">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">AI와 빅데이터 경영입문 2반</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">과제가 등록 되었습니다. 확인해주세요.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                        <div class="item_box talk">
                                            <a href="#0" class="item_txt">
                                                <p class="desc">
                                                    <span class="name">경영수리와 통계1반</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                                <p class="tit">출석 체크가 완료 되었습니다.</p>
                                            </a>
                                            <div class="state">
                                                <label class="label check_ok">읽음</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>


                        <!-- 강의Q&A -->
                        <div class="box">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">강의 Q&A <small class="msg_num">1</small></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
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
                                                <span class="name">[대학원] 경영수리와 통계1반</span>
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
                                                <span class="name">[대학원] 경영수리와 통계1반</span>
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
                                                <span class="name">[평생교육] 광고와 이미지 마케팅</span>
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
                        <div class="box">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">강의자료실</h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">1주차 강의자료 업로드​</p>
                                            <p class="desc">
                                                <span class="name">[대학원] 경영수리와 통계1반</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                    <li>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">실전 NoSQL 데이터베이스 활용 자료입니다.</p>
                                            <p class="desc">
                                                <span class="name">[대학원] 데이터베이스의 이해와 활용</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                    <li>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">New TEPS 공식기출문제집 정리 파일</p>
                                            <p class="desc">
                                                <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
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


                    <div class="grid divided">

                        <div class="col-vertical">

                            <!-- 강의 이어듣기 -->
                            <div class="box">
                                <div class="box_title">
                                    <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                    <h3 class="h3">강의 이어듣기</h3>
                                </div>
                                <div class="box_content">
                                    <ul class="ing_list">
                                        <li>
                                            <div class="item_box">
                                                <div class="s_txt">
                                                    <p class="tit">[대학원] 데이터베이스의 이해와 활용</p>
                                                    <p class="desc"><i class="xi-subdirectory-arrow"></i>우리 생활 주변의 데이터베이스</p>
                                                </div>
                                                <div class="s_btn">
                                                    <a href="#0" aria-label="이어보기" class="btn btn_play">
                                                        <i class="xi-play"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_box">
                                                <div class="s_txt">
                                                    <p class="tit">[평생교육] New TEPS 실전 연습-기본편</p>
                                                    <p class="desc"><i class="xi-subdirectory-arrow"></i>Test 1회 Listening Comprehension</p>
                                                </div>
                                                <div class="s_btn">
                                                    <a href="#0" aria-label="이어보기" class="btn btn_play">
                                                        <i class="xi-play"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_box">
                                                <div class="s_txt">
                                                    <p class="tit">[대학원] 데이터베이스의 이해와 활용</p>
                                                    <p class="desc"><i class="xi-subdirectory-arrow"></i>우리 생활 주변의 데이터베이스</p>
                                                </div>
                                                <div class="s_btn">
                                                    <a href="#0" aria-label="이어보기" class="btn btn_play">
                                                        <i class="xi-play"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                        </div>


                        <!-- 강의과목 -->
                        <div class="box span-2 subject">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">강의과목</h3>
                                <!--tab-type1-->
                                <nav class="tab-type1">
                                    <a href="#tab31" class="btn current"><span>전체</span></a>
                                    <a href="#tab32" class="btn "><span>대학원</span></a>
                                    <a href="#tab33" class="btn "><span>학위과정</span></a>
                                    <a href="#tab34" class="btn "><span>평생교육</span></a>
                                </nav>

                                <div class="btn-wrap">
                                    <select class="form-select">
                                        <option value="2025년 2학기">2025년 2학기</option>
                                        <option value="2025년 1학기">2025년 1학기</option>
                                    </select>
                                    <a href="#0" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                    <a href="#0" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a><!-- 버튼 선택 on 클래스 추가 -->
                                </div>
                            </div>

                            <div class="box_content">
                                <div id="tab31" class="tab-content" style="display: block;">
                                    <!-- 강의목록 -->
                                    <ul class="lecture_list">
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniA">대학원</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="#0">데이터베이스의 이해와 활용</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                        <a href="#0">세미나<span>2</span></a>
                                                        <a href="#0">퀴즈<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniA">대학원</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="#0">데이터베이스의 이해와 활용</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                        <a href="#0">세미나<span>2</span></a>
                                                        <a href="#0">퀴즈<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniB">평생교육</span>
                                                            <span class="info_txt">수강 200명</span>
                                                            <span class="info_txt">튜터 한여름</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="#0">간결하고 힘찬 영어 쓰기 - 품격 있는 영작</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
                                                    <div class="info">
                                                        <p class="point">
                                                            <span class="tit">과제제출:</span>
                                                            <span>2025.04.26 16:00</span>
                                                        </p>

                                                    </div>
                                                    <div class="info">
                                                        <p class="point">
                                                            <span class="tit">기말고사:</span>
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniB">평생교육</span>
                                                            <span class="info_txt">수강 200명</span>
                                                            <span class="info_txt">온라인</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="#0">New TEPS 실전 연습-기본편</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniC">학위과정</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="#0">AI와 빅데이터 경영입문 2반</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                        <a href="#0">세미나<span>2</span></a>
                                                        <a href="#0">퀴즈<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniC">학위과정</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="#0">AI와 빅데이터 경영입문 2반</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>

                                <div id="tab32" class="tab-content" style="display: none;">
                                    <div class="no_content">
                                        <div class="no_text">
                                            <i class="icon-cont-none ico f170"></i>
                                            <span>등록된 강의가 없습니다.</span>
                                        </div>
                                    </div>

                                </div>

                                <div id="tab33" class="tab-content" style="display: none;">
                                    학위과정 강의리스트
                                </div>

                                <div id="tab34" class="tab-content" style="display: none;">
                                    평생교육 강의리스트
                                </div>
                            </div>

                        </div>

                    </div>

                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>
