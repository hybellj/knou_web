<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
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
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
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
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info">
                                        <span>공지</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>Q&A</span>
                                        <div class="num_txt point">17</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>1:1</span>
                                        <div class="num_txt point">3</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>과제</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>토론</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>세미나</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>퀴즈</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>설문</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                    <a href="#0" class="info">
                                        <span>시험</span>
                                        <div class="num_txt">2</div>
                                    </a>
                                </div>
                                <div class="info-set">
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
                                            <span>2025.07.26 16:00</span>
                                        </p>
                                        <p class="desc">
                                            <span class="tit">시간:</span>
                                            <span>40분</span>
                                        </p>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="info-right">

                            <div class="flex">
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

                                <div class="item attend">
                                    <div class="item_icon"><i class="icon-svg-pie-chart-01" aria-hidden="true"></i></div>
                                    <div class="item_tit">7주차 출석 40 / 50</div>
                                    <div class="item_info">
                                        <span class="big">80</span>
                                        <span class="small">%</span>
                                    </div>
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

                        <!-- 1:1 상담 -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-message"></i>
                                <h3 class="h3">1:1 상담 <small class="msg_num">2</small></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li>
                                        <div class="user">
                                           <span class="user_img"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진"></span>
                                        </div>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">교수님~ 평가항목에 대해 궁금한게 있어요​</p>
                                            <p class="desc">
                                                <span class="name">나방송</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_no">미답변</label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="user">
                                           <span class="user_img"></span>
                                        </div>
                                        <a href="#0" class="item_txt">
                                            <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
                                            <p class="desc">
                                                <span class="name">나방송</span>
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
                                            <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
                                            <p class="desc">
                                                <span class="name">나방송</span>
                                                <span class="date">2025.05.17</span>
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_no">미답변</label>
                                        </div>
                                    </li>
                                </ul>
							</div>

                        </div>

                    </div>

                    <div class="segment">
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">강의목록</h3>
                        </div>

                        <div class="week_attend_list">
                            <div class="state">
                                <span class="week">1</span>
                                <span class="percent">100%</span>
                            </div>
                            <div class="state">
                                <span class="week">2</span>
                                <span class="percent">100%</span>
                            </div>
                            <div class="state">
                                <span class="week">3</span>
                                <span class="percent">100%</span>
                            </div>
                            <div class="state">
                                <span class="week">4</span>
                                <span class="percent">100%</span>
                            </div>
                            <div class="state">
                                <span class="week">5</span>
                                <span class="percent">100%</span>
                            </div>
                            <div class="state">
                                <span class="week">6</span>
                                <span class="percent">100%</span>
                            </div>
                            <div class="state current">
                                <span class="week">7</span>
                                <span class="percent">15%</span>
                            </div>
                            <div class="state">
                                <span class="week">중간</span>
                                <span class="percent">-</span>
                            </div>
                            <div class="state">
                                <span class="week">9</span>
                                <span class="percent">/</span>
                            </div>
                            <div class="state">
                                <span class="week">10</span>
                                <span class="percent">/</span>
                            </div>
                            <div class="state">
                                <span class="week">11</span>
                                <span class="percent">/</span>
                            </div>
                            <div class="state">
                                <span class="week">12</span>
                                <span class="percent">/</span>
                            </div>
                            <div class="state">
                                <span class="week">13</span>
                                <span class="percent">/</span>
                            </div>
                            <div class="state">
                                <span class="week">14</span>
                                <span class="percent">/</span>
                            </div>
                            <div class="state">
                                <span class="week">기말</span>
                                <span class="percent">-</span>
                            </div>
                        </div>

                        <div class="board_top course">
                            <button type="button" class="btn basic">주차 접음</button>
                            <select class="form-select">
                                <option value="전체 주차">전체 주차</option>
                                <option value="1주차">1주차</option>
                                <option value="2주차">2주차</option>
                                <option value="3주차">3주차</option>
                                <option value="4주차">4주차</option>
                                <option value="5주차">5주차</option>
                            </select>
                            <div class="right-area">
                                <button type="button" class="btn basic icon" aria-label="주차 오름차순"><i class="xi-sort-asc"></i></button>
                                <button type="button" class="btn basic icon" aria-label="주차 내림차순"><i class="xi-sort-desc"></i></button>
                            </div>
                        </div>

                        <div class="course_list">
                            <ul class="accordion course_week">
                                <li class="active"><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i>
                                            <strong>1주차</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                                <label class="label s_finish">마감</label>
                                            </p>
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>출석<strong>35</strong></span>
                                                <span>지각<strong>3</strong></span>
                                                <span>결석<strong>2</strong></span>
                                            </p>
                                        </a>
                                        <div class="btn_right">
                                            <button class="btn s_basic down">음성</button>
                                            <button class="btn s_basic down">강의노트</button>
                                            <button class="btn s_type1">출결관리</button>
                                            <button class="btn s_type2">강의보기</button>
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="주차 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">주차 수정</a></div>
                                                    <div class="item"><a href="#0">주차 추가</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="cont">
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_chasi">1차시</label>
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>우리 생활 주변의 데이터베이스</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>출석율<strong class="navy">52%</strong></span>
                                                </div>
                                                <button class="btn s_basic play">강의보기</button>
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item"><a href="#0">차시 수정</a></div>
                                                        <div class="item"><a href="#0">차시 삭제</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_chasi">2차시</label>
                                                    <label class="label s_basic">PDF</label>
                                                </p>
                                                <strong>데이터베이스 관리 시스템</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>출석율<strong class="navy">52%</strong></span>
                                                </div>
                                                <button class="btn s_basic play">강의보기</button>
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item"><a href="#0">차시 수정</a></div>
                                                        <div class="item"><a href="#0">차시 삭제</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <div class="desc_info">
                                                    <span>제출<strong>20</strong></span>
                                                    <span>지각<strong>12</strong></span>
                                                    <span>미제출<strong>2</strong></span>
                                                </div>
                                                <button class="btn s_basic set">과제관리</button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_debate">토론</label>
                                                </p>
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <div class="desc_info">
                                                    <span>참여<strong>18</strong></span>
                                                    <span>미참여<strong>2</strong></span>
                                                </div>
                                                <button class="btn s_basic set">토론관리</button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">자료</label>
                                                </p>
                                                <strong>PDF : 학습자료제목</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <button class="btn s_basic set">학습자료</button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">자료</label>
                                                </p>
                                                <strong>웹링크 : 학습자료제목 학습자료제목 2</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <button class="btn s_basic set">학습자료</button>
                                            </div>
                                        </div>

                                        <div class="lecture_add_box">
                                            <div class="box_item">
                                                <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                        <span>동영상</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                        <span>PDF</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                        <span>파일</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-share" aria-hidden="true"></i>
                                                        <span>소셜</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-link" aria-hidden="true"></i>
                                                        <span>웹링크</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                        <span>텍스트</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="box_item">
                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-edit" aria-hidden="true"></i>
                                                        <span>과제</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-quiz" aria-hidden="true"></i>
                                                        <span>퀴즈</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                                        <span>시험</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-message-chat" aria-hidden="true"></i>
                                                        <span>토론</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-check-done" aria-hidden="true"></i>
                                                        <span>설문</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-presentation" aria-hidden="true"></i>
                                                        <span>세미나</span>
                                                    </a>
                                                </div>
                                            </div>

                                        </div>

                                    </div>
                                </li>

                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i>
                                            <strong>2주차</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                                <label class="label s_ing">공개</label>
                                            </p>
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>출석<strong>35</strong></span>
                                                <span>지각<strong>3</strong></span>
                                                <span>결석<strong>2</strong></span>
                                            </p>
                                        </a>
                                        <div class="btn_right">
                                            <button class="btn s_basic down">강의노트</button>
                                            <button class="btn s_type1">출결관리</button>
                                            <button class="btn s_type2">강의보기</button>
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="주차 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">주차 수정</a></div>
                                                    <div class="item"><a href="#0">주차 추가</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="cont">
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_chasi">1차시</label>
                                                    <label class="label s_basic">동영상</label>
                                                </p>
                                                <strong>우리 생활 주변의 데이터베이스</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>출석율<strong class="navy">52%</strong></span>
                                                </div>
                                                <button class="btn s_basic play">강의보기</button>
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item"><a href="#0">차시 수정</a></div>
                                                        <div class="item"><a href="#0">차시 삭제</a></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="lecture_add_box">
                                            <div class="box_item">
                                                <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                        <span>동영상</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                        <span>PDF</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                        <span>파일</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-share" aria-hidden="true"></i>
                                                        <span>소셜</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-link" aria-hidden="true"></i>
                                                        <span>웹링크</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                        <span>텍스트</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="box_item">
                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-edit" aria-hidden="true"></i>
                                                        <span>과제</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-quiz" aria-hidden="true"></i>
                                                        <span>퀴즈</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                                        <span>시험</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-message-chat" aria-hidden="true"></i>
                                                        <span>토론</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-check-done" aria-hidden="true"></i>
                                                        <span>설문</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-presentation" aria-hidden="true"></i>
                                                        <span>세미나</span>
                                                    </a>
                                                </div>
                                            </div>

                                        </div>

                                    </div>
                                </li>

                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i>
                                            <strong>3주차</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>출석<strong>35</strong></span>
                                                <span>지각<strong>3</strong></span>
                                                <span>결석<strong>2</strong></span>
                                            </p>
                                        </a>
                                        <div class="btn_right">
                                            <button class="btn s_type1">세미나 출결관리</button>
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="주차 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">주차 수정</a></div>
                                                    <div class="item"><a href="#0">주차 추가</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="cont">
                                        <div class="lecture_box seminar">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_seminar">세미나</label>
                                                </p>
                                                <strong>화상세미나</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <div class="desc_info">
                                                    <span>출석<strong>20</strong></span>
                                                    <span>지각<strong>3</strong></span>
                                                    <span>결석<strong>1</strong></span>
                                                </div>
                                                <button class="btn s_basic set">세미나관리</button>
                                            </div>

                                            <div class="seminar_detail">
                                                <div class="row">
                                                    <button class="btn go_seminar">화상 세미나 참여하기</button>
                                                    <div class="desc_info">
                                                        <span>시작일시 :<strong>2025.06.02 16:00</strong></span>
                                                        <span>진행시간 :<strong>1시간 20분</strong></span>
                                                    </div>
                                                </div>
                                                <div class="row message red">
                                                    [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요.<br>
                                                    <span class="caution">Zoom 프로그램이 아닌 브라우저 상의 "브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다.</span>
                                                </div>
                                                <div class="row message">
                                                    <div class="list-tit">참가에 실패하는 경우</div>
                                                    <ul class="list-bullet">
                                                        <li>화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다.</li>
                                                        <li>참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다.</li>
                                                    </ul>

                                                    <div class="list-tit-bg">이메일 직접 등록하여 참가</div>
                                                    <ul class="list-bullet">
                                                        <li>참가 등록시 입력할 이메일 주소 : <strong class="fcRed">아이디@knou.ac.kr</strong></li>
                                                    </ul>

                                                </div>

                                            </div>

                                        </div>

                                        <div class="lecture_add_box">
                                            <div class="box_item">
                                                <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                        <span>동영상</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                        <span>PDF</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                        <span>파일</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-share" aria-hidden="true"></i>
                                                        <span>소셜</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-link" aria-hidden="true"></i>
                                                        <span>웹링크</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                        <span>텍스트</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="box_item">
                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-edit" aria-hidden="true"></i>
                                                        <span>과제</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-quiz" aria-hidden="true"></i>
                                                        <span>퀴즈</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                                        <span>시험</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-message-chat" aria-hidden="true"></i>
                                                        <span>토론</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-check-done" aria-hidden="true"></i>
                                                        <span>설문</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-presentation" aria-hidden="true"></i>
                                                        <span>세미나</span>
                                                    </a>
                                                </div>
                                            </div>

                                        </div>

                                    </div>
                                </li>

                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i>
                                            <strong>4주차</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>출석<strong>-</strong></span>
                                                <span>지각<strong>-</strong></span>
                                                <span>결석<strong>-</strong></span>
                                            </p>
                                        </a>
                                        <div class="btn_right">
                                            <button class="btn s_type1">출결관리</button>
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="주차 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">주차 수정</a></div>
                                                    <div class="item"><a href="#0">주차 추가</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="cont">
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">자료</label>
                                                </p>
                                                <strong>PDF : 학습자료제목</strong>
                                            </div>
                                            <div class="btn_right">
                                                <button class="btn s_basic set">학습자료</button>
                                            </div>
                                        </div>

                                        <div class="lecture_add_box">
                                            <div class="box_item">
                                                <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                        <span>동영상</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                        <span>PDF</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                        <span>파일</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-share" aria-hidden="true"></i>
                                                        <span>소셜</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-link" aria-hidden="true"></i>
                                                        <span>웹링크</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                        <span>텍스트</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="box_item">
                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-edit" aria-hidden="true"></i>
                                                        <span>과제</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-quiz" aria-hidden="true"></i>
                                                        <span>퀴즈</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                                        <span>시험</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-message-chat" aria-hidden="true"></i>
                                                        <span>토론</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-check-done" aria-hidden="true"></i>
                                                        <span>설문</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-presentation" aria-hidden="true"></i>
                                                        <span>세미나</span>
                                                    </a>
                                                </div>
                                            </div>

                                        </div>

                                    </div>
                                </li>

                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i>
                                            <strong>15주차</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                <span>출석<strong>-</strong></span>
                                                <span>지각<strong>-</strong></span>
                                                <span>결석<strong>-</strong></span>
                                            </p>
                                        </a>
                                        <div class="btn_right">
                                            <button class="btn s_type1">결시원 현황</button>
                                            <button class="btn s_type1">장애인/고령자 지원현황</button>
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="주차 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">주차 수정</a></div>
                                                    <div class="item"><a href="#0">주차 추가</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="cont">
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_test">시험</label>
                                                </p>
                                                <strong>실시간시험 기말고사</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>응시<strong>20</strong></span>
                                                    <span>미응시<strong>2</strong></span>
                                                </div>
                                                <button class="btn s_basic set">시험관리</button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_test">대체과제</label>
                                                </p>
                                                <strong>대체과제명</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>제출<strong>20</strong></span>
                                                    <span>지각<strong>2</strong></span>
                                                    <span>미제출<strong>2</strong></span>
                                                </div>
                                                <button class="btn s_basic set">과제관리</button>
                                            </div>
                                        </div>

                                        <div class="lecture_add_box">
                                            <div class="box_item">
                                                <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                        <span>동영상</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                        <span>PDF</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                        <span>파일</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-share" aria-hidden="true"></i>
                                                        <span>소셜</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-link" aria-hidden="true"></i>
                                                        <span>웹링크</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                        <span>텍스트</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="box_item">
                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
                                                <div class="item_btns">
                                                    <a href="#0">
                                                        <i class="icon-svg-edit" aria-hidden="true"></i>
                                                        <span>과제</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-quiz" aria-hidden="true"></i>
                                                        <span>퀴즈</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                                        <span>시험</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-message-chat" aria-hidden="true"></i>
                                                        <span>토론</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-check-done" aria-hidden="true"></i>
                                                        <span>설문</span>
                                                    </a>
                                                    <a href="#0">
                                                        <i class="icon-svg-presentation" aria-hidden="true"></i>
                                                        <span>세미나</span>
                                                    </a>
                                                </div>
                                            </div>

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

