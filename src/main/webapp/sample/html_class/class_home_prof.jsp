<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
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
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area prof">
                        <div class="info-left">
                            <div class="class_info">
                                <div class="class_tit">
                                    <p class="labels">
                                        <label class="label uniA">대학원</label>
                                    </p>
                                    <h2>데이터베이스의 이해와 활용 1반</h2>
                                </div>
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
                                    <div class="item_tit">7주차 출석 <strong class="fcBlue">40</strong> / 50</div>
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

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" data-modal-open="modal0">주차 수정</button> 
                        <button type="button" class="btn modal__btn" data-modal-open="modal1">학습진도관리</button> 
                        <button type="button" class="btn modal__btn" data-modal-open="modal2">평가비중</button> 
                        <button type="button" class="btn modal__btn" data-modal-open="modal3">평가방법 : 루브릭</button>  
                        <button type="button" class="btn modal__btn" data-modal-open="modal4">학습자료 수정</button>    
                        <button type="button" class="btn modal__btn" data-modal-open="modal5">결시신청 현황</button>  
                        <button type="button" class="btn modal__btn" data-modal-open="modal6">출결관리</button>              
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->

                </div>               
            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

        <!-- Modal 0 -->
        <div class="modal-overlay" id="modal0" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">1주차 수정</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    
                    <!--table-type5-->
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-20per" />
                                <col class="" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th><label for="noticeLabel" class="req">주차 기간</label></th>
                                    <td>
                                        <div class="form-inline">
                                            
                                            <div class="date_area">
                                                <input type="text" placeholder="시작일" id="datetimepicker1" class="datepicker" toDate="datetimepicker2" required="true">
                                                <span class="txt-sort">~</span>
                                                <input type="text" placeholder="종료일" id="datetimepicker2" class="datepicker" fromDate="datetimepicker1" required="true">
                                            </div>
                                        </div>

                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="noticeLabel" class="req">출석인정기간</label></th>
                                    <td>
                                        <div class="date_area">
                                            <input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
                                            <input type="text" placeholder="시작시간" id="timepicker3" class="timepicker" dateId="datepicker3">
                                            <span class="txt-sort">~</span>
                                            <input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
                                            <input type="text" placeholder="종료시간" id="timepicker4" class="timepicker" dateId="datepicker4">
                                        </div>
                                    </td>
                                </tr>                                
                            </tbody>
                        </table>
                    </div>
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">학습진도관리</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    <div class="msg-box info">
                        <p class="txt">운영과목과 수강생의 학습현황을 조회할 수 있습니다. <strong>학습 부진자 관리</strong>에 활용하시기 바랍니다.</p>
                    </div>
                    <div class="msg-box basic">
                        <ul class="list-dot">
                            <li>출석율은 현재 오픈 차시 중 정상 출석한 차시에 대한 비율로 표기됩니다.</li>
                            <li>매 주차별로 부진자 (출석율 100% 미만)에게 알림 발송 가능합니다.</li>
                            <li>운영과목 수강생의 수에 따라 조회에 다소 시간이 걸릴 수 있습니다</li>
                        </ul>
                    </div>

                    <div class="search-typeA">                        
                        <div class="item">
                            <div class="itemList">
                                <span class="custom-input">
                                    <input type="checkbox" name="name" id="checkType1">
                                    <label for="checkType1">미학습자 전체</label>
                                </span>
                                <div class="percent_area">
                                    <span class="tit">출석률</span>
                                    <div class="input_btn">
                                        <input class="form-control sm" id="percentInput" type="text" maxlength="2"><label>% 이상</label>
                                    </div>
                                    <span class="txt-sort">~</span>
                                    <div class="input_btn">
                                        <input class="form-control sm" id="percentInput" type="text" maxlength="2"><label>% 미만</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search">검색</button>
                        </div>
                    </div>

                    <div class="lecture_status_box full">                            
                        <div class="box_item">
                            <div class="title">운영과목<i class="xi-angle-right-min"></i></div>
                            <div class="item_txt">
                                <p class="desc">
                                    <i class="icon-svg-group" aria-hidden="true"></i>
                                    수강생 수 : <strong>60명</strong>
                                </p>
                                <p class="desc">
                                    <i class="icon-svg-bar-chart" aria-hidden="true"></i>
                                    평균 학습 진도율 : <strong>66%</strong>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">학습진도현황</h3>
                        <div class="right-area">
                            <button type="button" class="btn basic">메시지 보내기</button>
                            <button type="button" class="btn basic">엑셀 다운로드</button>
                            <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                <option value="ALL" selected="selected">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                            </select>
                        </div>
                    </div>

                    <!--table-type2-->
                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:5%">
                                <col style="width:6%">                                                                
                                <col style="width:11%">
                                <col style="">
                                <col style="width:15%">                                                                
                                <col style="width:7%">
                                <col style="width:8%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                    </th>
                                    <th>번호</th>
                                    <th>이름</th>                                  
                                    <th>아이디</th>
                                    <th>학번</th>
                                    <th>학년</th>
                                    <th>수강과목수</th>
                                    <th>오픈차시
                                    <sapn class="c-point01">(A)</sapn>
                                    </th>
                                    <th>학습차시
                                    <sapn class="c-point01">(B)</sapn>
                                    </th>
                                    <th>출석율
                                    <sapn class="c-point01">(B/A)</sapn>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">90</td>
                                    <td data-th="이름">학습자4</td>
                                    <td data-th="아이디">Test01</td>                                                                        
                                    <td data-th="학번">K202612547</td>
                                    <td data-th="학년">2</td>
                                    <td data-th="수강과목수">5</td>
                                    <td data-th="오픈주차(A)">40</td>
                                    <td data-th="학습주차(B)">30</td>
                                    <td data-th="출석율(B/A)">75%</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">90</td>
                                    <td data-th="이름">학습자4</td>
                                    <td data-th="아이디">Test01</td>                                                                        
                                    <td data-th="학번">K202612547</td>
                                    <td data-th="학년">2</td>
                                    <td data-th="수강과목수">5</td>
                                    <td data-th="오픈주차(A)">40</td>
                                    <td data-th="학습주차(B)">30</td>
                                    <td data-th="출석율(B/A)">75%</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">90</td>
                                    <td data-th="이름">학습자4</td>
                                    <td data-th="아이디">Test01</td>                                                                        
                                    <td data-th="학번">K202612547</td>
                                    <td data-th="학년">2</td>
                                    <td data-th="수강과목수">5</td>
                                    <td data-th="오픈주차(A)">40</td>
                                    <td data-th="학습주차(B)">30</td>
                                    <td data-th="출석율(B/A)">75%</td>
                                </tr>
                            </tbody>

                        </table>
                    </div>
                    <!--//table-type2-->

                    <%-- 테이블의 페이징 정보 생성할때 아래 내용 참조하여 작업하고 아래와 같은 HTML 코드를 직접 만들지 않는다.
                        1) UiTable() 함수를 사용하여 테이블 생성할경우는 해당 프로그램에서 페이지 정보 생성하도록 한다.
                        2) Controller에서 페이지정보(PageInfo) 객체를 받아을 경우 <uiex:paging> 태그를 사용하여 생성한다.
                            <uiex:paging pageInfo="${pageInfo}" pageFunc="listPaging"/>
                    --%>
                    <!-- board foot -->
                    <div class="board_foot">
                        <div class="page_info">
                            <span class="total_page">전체 <b>12</b>건</span>
                            <span class="current_page">현재 페이지 <strong>1</strong>/10</span>
                        </div>
                        <div class="board_pager">
                            <span class="inner">
                                <button class="page" type="button" role="button" aria-label="First Page" title="처음 페이지" data-page="1" disabled=""><i class="icon-page-first"></i></button>
                                <button class="page" type="button" role="button" aria-label="Prev Page" title="이전 페이지" data-page="1" disabled=""><i class="icon-page-prev"></i></button>
                                <span class="pages">
                                    <button class="page active" type="button" role="button" aria-label="Page 1" title="1 페이지" data-page="1">1</button>
                                    <button class="page" type="button" role="button" aria-label="Page 2" title="2 페이지" data-page="2">2</button>
                                    <button class="page" type="button" role="button" aria-label="Page 3" title="3 페이지" data-page="3">3</button>
                                </span>
                                <button class="page" type="button" role="button" aria-label="Next Page" title="다음 페이지" data-page="2"><i class="icon-page-next"></i></button>
                                <button class="page" type="button" role="button" aria-label="Last Page" title="마지막 페이지" data-page="3"><i class="icon-page-last"></i></button>
                            </span>
                        </div>
                    </div>

                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">평가비중</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    <div class="board_top">
                        <h3 class="board-title">평가비중 (강의계획서)</h3>                       
                    </div> 
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="">
                                <col style="width:12%">
                                <col style="width:12%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>평가항목</th>
                                    <th>중간고사</th>
                                    <th>기말고사</th>
                                    <th>시험</th>
                                    <th>출석</th>
                                    <th>과제</th>
                                    <th>토론</th>
                                    <th>퀴즈</th>
                                    <th>설문</th>                                    
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th data-th="평가항목">비율</th>
                                    <td data-th="중간고사">25%</td>
                                    <td data-th="기말고사">25%</td>
                                    <td data-th="시험">10%</td>
                                    <td data-th="출석">10%</td>
                                    <td data-th="과제">10%</td>
                                    <td data-th="토론">10%</td>
                                    <td data-th="퀴즈">5%</td>
                                    <td data-th="설문">5%</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board_top">
                        <h4 class="sub-title">성적 반영비율 관리</h4>    
                        <div class="right-area">
                            <!-- Tab btn -->
                            <div class="tab_btn">
                                <a href="#tab01" class="current">과제</a>
                                <a href="#tab02">토론</a>
                                <a href="#tab03">퀴즈</a>
                                <a href="#tab04">설문</a>
                                <a href="#tab05">세미나</a>
                            </div>
                            <button type="button" class="btn basic">성적반영 비율관리</button>
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:4%">
                                <col style="width:10%">
                                <col style="">                                
                                <col style="width:14%">
                                <col style="width:14%">
                                <col style="width:8%">
                                <col style="width:9%">                                    
                                <col style="width:8%">
                                <col style="width:8%">                                                                                                        
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>구분</th>
                                    <th>과제명</th>
                                    <th>제출기간</th> 
                                    <th>연장제출마감</th>  
                                    <th>평가방법</th>                                       
                                    <th>성적반영비율</th>
                                    <th>성적공개</th>
                                    <th>진행상태</th>                                    
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">1</td>
                                    <td data-th="구분">일반과제</td>
                                    <td data-th="과제명" class="t_left">과제과제과제 과제명 입니다.</td>
                                    <td data-th="제출기간">2026.06.13 18:00 ~ 2026.06.17 22:00</td>    
                                    <td data-th="연장제출마감">2026.06.22 22:00</td>    
                                    <td data-th="평가방법">점수형</td>                                 
                                    <td data-th="성적반영비율">25%</td>
                                    <td data-th="성적공개">
                                        <input type="checkbox" value="Y" class="switch small" checked="checked">
                                    </td>
                                    <td data-th="진행상태">진행</td>
                                </tr>   
                                <tr>
                                    <td data-th="번호">2</td>
                                    <td data-th="구분">팀과제</td>
                                    <td data-th="과제명" class="t_left">과제과제과제 과제명 입니다.</td>
                                    <td data-th="제출기간">2026.06.13 18:00 ~ 2026.06.17 22:00</td>    
                                    <td data-th="연장제출마감">2026.06.22 22:00</td>    
                                    <td data-th="평가방법">
                                        <a href="#0" class="title link">루브릭</a>
                                    </td>                                 
                                    <td data-th="성적반영비율">25%</td>
                                    <td data-th="성적공개">
                                        <input type="checkbox" value="N" class="switch small">
                                    </td>
                                    <td data-th="진행상태">대기</td>
                                </tr> 
                                <tr>
                                    <td data-th="번호">3</td>
                                    <td data-th="구분">일반과제</td>
                                    <td data-th="과제명" class="t_left">과제과제과제 과제명 입니다.</td>
                                    <td data-th="제출기간">2026.06.13 18:00 ~ 2026.06.17 22:00</td>    
                                    <td data-th="연장제출마감">2026.06.22 22:00</td>    
                                    <td data-th="평가방법">점수형</td>                                 
                                    <td data-th="성적반영비율">25%</td>
                                    <td data-th="성적공개">
                                        <input type="checkbox" value="Y" class="switch small" checked="checked">
                                    </td>
                                    <td data-th="진행상태">완료</td>
                                </tr>                                                                       
                            </tbody>
                        </table>
                    </div>
                    <!--//table-type-->                          
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 3 -->
        <div class="modal-overlay" id="modal3" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">평가방법 : 루브릭</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    <div class="msg-box warning ">
                        <p class="txt">
                            <i class="xi-error" aria-hidden="true"></i>
                            <strong>평가 진행 혹은 완료된 후</strong>, 평가비중을 수정하면 이미 진행된 평가 내용은 모두 삭제되어 초기화됩니다.
                        </p>
                    </div>
                    <div class="board_top">
                        <h3 class="board-title">루브릭 평가</h3>                       
                    </div> 
                    
                    <div class="rubrics_wrap">
                        <div class="rub_write">
                            <div class="top"><input class="form-control width-100per" type="text" name="name" id="readonly_label" value="과제 루브릭 평가 제목입니다." readonly="" autocomplete="off"></div>
                            <div class="eval_item">
                                <div class="item">
                                    <label class="label_num">1</label>
                                    <input class="form-control wide" type="text" value="창의력" readonly>
                                    <input class="form-control sm" type="text" value="30%" >
                                    <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                </div>
                                <div class="item">
                                    <label class="label_num">2</label>
                                    <input class="form-control wide" type="text" value="문장력" readonly>
                                    <input class="form-control sm" type="text" value="30%" >
                                    <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                </div>
                                <div class="item">
                                    <label class="label_num">3</label>
                                    <input class="form-control wide" type="text" value="구성력" readonly>
                                    <input class="form-control sm" type="text" value="30%" >
                                    <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                </div>
                            </div>
                        </div>
                        <div class="sub-box rub_grade">                        
                            <div class="board_top">
                                <h3 class="board-title">평가 등급</h3>   
                                <div class="form-inline">
                                    <span class="custom-input">
                                        <input type="radio" name="evalType1" id="evalType1" value="5" checked="">
                                        <label for="evalType1">5점 척도</label>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="evalType1" id="evalType2" value="3">
                                        <label for="evalType2">3점 척도</label>
                                    </span>
                                    <span class="custom-input ml5">
                                        <input type="radio" name="evalType1" id="evalType3" value="10">
                                        <label for="evalType3">자유척도</label>
                                    </span>
                                </div>                    
                            </div>
                            <div class="grade_item">
                                <div class="item">
                                    <div class="input_btn">
                                        <input class="form-control sm" id="gradeInput" type="text" value="5" autocomplete="off"><label>점</label>
                                    </div>                                        
                                    <input class="form-control wide" type="text" value="매우 잘 했어요">                                       
                                </div>
                                <div class="item">
                                    <div class="input_btn">
                                        <input class="form-control sm" id="gradeInput" type="text" value="4" autocomplete="off"><label>점</label>
                                    </div>                                        
                                    <input class="form-control wide" type="text" value="잘 했어요">                                       
                                </div>
                                <div class="item">
                                    <div class="input_btn">
                                        <input class="form-control sm" id="gradeInput" type="text" value="3" autocomplete="off"><label>점</label>
                                    </div>                                        
                                    <input class="form-control wide" type="text" value="보통입니다">                                       
                                </div>
                                <div class="item">
                                    <div class="input_btn">
                                        <input class="form-control sm" id="gradeInput" type="text" value="2" autocomplete="off"><label>점</label>
                                    </div>                                        
                                    <input class="form-control wide" type="text" value="노력하세요">                                       
                                </div>
                                <div class="item">
                                    <div class="input_btn">
                                        <input class="form-control sm" id="gradeInput" type="text" value="1" autocomplete="off"><label>점</label>
                                    </div>                                        
                                    <input class="form-control wide" type="text" value="더 노력하세요">                                       
                                </div>
                            </div>                                                            
                        </div>
                    </div>                                       
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 4 -->
        <div class="modal-overlay" id="modal4" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">학습자료 수정</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">                    

                    <div class="board_top">
                        <h3 class="board-title">1주차</h3>
                        <div class="right-area">
                            <span class="total_txt">학습기간 :<b> 2026.03.05 ~ 2026.03.16</b></span>
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per" />
                                <col class="" />
                            </colgroup>
                            <tbody>                                
                                <tr>
                                    <th><label for="select_fullLabel">제목</label></th>
                                    <td>
                                        <div class="form-row">
                                            <input class="form-control width-100per" type="text" name="name" id="name_label" value="" placeholder="제목 입력">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="sendUserCk">출결대상</label></th>
                                    <td>
                                        <span class="custom-input">
                                            <input type="checkbox" name="sendUserCk" id="sendUserCk" checked>
                                            <label for="sendUserCk">출결체크 대상에 포함</label>
                                        </span>		
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="dataLabel">학습자료</label></th>
                                    <td>
                                        <div class="item_btns">
                                            <a href="#0" class="active"><!-- 활성화 active 추가-->
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
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="attchFile">첨부파일</label></th>
                                    <td>
                                        <div id="fileUploader-container" class="dext5-container" style="width:100%;height:180px;"></div>
                                        <div id="fileUploader-btn-area" class="dext5-btn-area" style=""><button type="button" id="fileUploader_btn-add" style="" title="파일선택">파일선택</button><button type="button" id="fileUploader_btn-delete" disabled='true' style="" title="삭제">삭제</button><button type="button" id="fileUploader_btn-reset" style="display:none" title="초기화" onclick="resetDextFiles('fileUploader')"><i class='xi-refresh'></i></button></div>
                                        <script>
                                        UiFileUploader({
                                            id:"fileUploader",
                                            parentId:"fileUploader-container",
                                            btnFile:"fileUploader_btn-add",
                                            btnDelete:"fileUploader_btn-delete",
                                            lang:"ko",
                                            uploadMode:"ORAF",
                                            maxTotalSize:100,
                                            maxFileSize:100,
                                            extensionFilter:"*",
                                            noExtension:"exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py",
                                            finishFunc:"finishUpload()",
                                            uploadUrl:"https://localhost/dext/uploadFileDext.up?type=",
                                            path:"/bbs",
                                            fileCount:5,
                                            oldFiles:[],
                                            useFileBox:false,
                                            style:"list",
                                            uiMode:"normal"
                                        });
                                        </script>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="socialLabel">소셜</label></th>
                                    <td>
                                        <div class="form-tab">
                                            <!-- Tab btn -->
                                            <div class="tab_btn">
                                                <a href="#tab01" class="current">URL 주소</a>
                                                <a href="#tab02">소스코드</a>
                                            </div>
                                            <div id="tab01" class="tab-content">
                                                <small class="note">* Youtube, TED, Vimeo의 동영상 주소를 입력하여 등록할 수 있습니다.</small>
                                                <div class="form-row">
                                                    <input class="form-control width-100per" type="text" name="name" id="url_label" value="" placeholder="소셜미디어 URL 주소를 붙여 넣으세요">
                                                </div>                                                
                                            </div>
                                            <div id="tab02" class="tab-content" style="display:none;">
                                                <small class="note">* Iframe 형식 HTML 코드를 등록합니다.</small>
                                                <div class="form-row">
                                                    <label class="width-100per"><textarea rows="4" class="form-control resize-none">
<iframe width="560" height="315" src="https://www.youtube.com/embed/FJ2d-FPqDGE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                                    </textarea></label>
                                                </div>
                                                <div class="msg-txt mt10">
                                                    <p class="txt">* 소셜 미디어에서 제공하는 공유 코드를 복사하여 붙여 넣습니다.</p>
                                                    <button type="button" class="btn gray1">저장</button>
                                                </div>                                               
                                            </div>
                                        </div>

                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="playerArea">강의보기</label></th>
                                    <td>
                                        <div class="video-container">
                                            <iframe src="https://www.youtube.com/embed/zyAeJbVqYSI?si=pSQ65VLxrJ0NkfaV" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>                                        
                                        </div>                                        
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="contTextarea">학습내용</label></th>
                                    <td>
                                        <label class="width-100per"><textarea rows="4" class="form-control resize-none"></textarea></label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type1">삭제</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 5 -->
        <div class="modal-overlay" id="modal5" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">결시신청 현황</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    <div class="tit_divider">결시신청 신청기간</div>                   

                    <div class="msg-box warning mt20">
                        <div class="txt_group">
                            <p class="txt ct"><strong>중간고사 : </strong>2026.03.03 00:00 ~ 2026.05.10 23:59</p>
                            <p class="txt ct"><strong>기말고사 : </strong>2026.06.02 00:00 ~ 2026.12.10 23:59</p>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">수강생</h3>  
                        <div class="right-area">
                             <span class="total_txt">[ 전체 <b class="fcBlue">3</b>건 ]</span>
                        </div>                          
                    </div>
                    <div class="board_top in_table">
                        <select class="form-select" id="selectDate1">
                            <option value="2026">2026</option>                                
                        </select>
                        <select class="form-select" id="selectDate2">
                            <option value="2학기">2학기</option>
                            <option value="1학기">1학기</option>
                        </select>
                        <select class="form-select" id="selectDate3">
                            <option value="시험구분">시험구분</option>
                            <option value="중간고사">중간고사</option>
                            <option value="기말고사">기말고사</option>
                        </select>
                        <select class="form-select" id="selectDate4">
                            <option value="승인여부">승인여부</option>                                
                        </select>
                        <!-- search small -->
                        <div class="search-typeC">
                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학번/이름 입력">
                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                        </div>
                        <div class="right-area">                            
                            <button type="button" class="btn basic">메시지 보내기</button>   
                            <button type="button" class="btn type2">엑셀 다운로드</button>                             
                        </div>
                    </div>

                    <!--table-type2-->
                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:3%">
                               
                                <col style="width:4%">
                                <col style="width:11%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:7%">
                                <col style="">
                                <col style="width:5%">
                                <col style="width:5%">
                                <col style="width:5%">
                                <col style="width:5%">
                                <col style="width:9%">
                                <col style="width:6%">                                
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                    </th>
                                    <th>번호</th>
                                    <th>학과</th>
                                    <th>아이디</th>
                                    <th>학번</th>
                                    <th>이름</th>                                 
                                    <th>과목명</th>
                                    <th>분반</th>                                                                                                            
                                    <th>시험구분</th>
                                    <th>시험응시</th>
                                    <th>처리상태</th>
                                    <th>처리일시</th>
                                    <th>담당자</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">1</td>
                                    <td data-th="학과">문예창작콘텐츠</td>                                    
                                    <td data-th="아이디">Test01</td>
                                    <td data-th="학번">K202612547</td>
                                    <td data-th="이름"><span class="fcBlue">학습자4</span></td>
                                    <td data-th="과목명">고전문학심화</td>
                                    <td data-th="분반">01</td>                                    
                                    <td data-th="시험구분">중간고사</td>
                                    <td data-th="시험응시">N</td>
                                    <td data-th="처리상태"><span class="fcBlue">반려</span></td>
                                    <td data-th="처리일시">2026.05.10 15:25</td>
                                    <td data-th="담당자">김관리</td>
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">1</td>
                                    <td data-th="학과">문예창작콘텐츠</td>                                    
                                    <td data-th="아이디">Test01</td>
                                    <td data-th="학번">K202612547</td>
                                    <td data-th="이름"><span class="fcBlue">학습자4</span></td>
                                    <td data-th="과목명">고전문학심화</td>
                                    <td data-th="분반">01</td>                                    
                                    <td data-th="시험구분">중간고사</td>
                                    <td data-th="시험응시">N</td>
                                    <td data-th="처리상태"><span class="fcBlue">반려</span></td>
                                    <td data-th="처리일시">2026.05.10 15:25</td>
                                    <td data-th="담당자">김관리</td>
                                </tr>
                            </tbody>

                        </table>
                    </div>
                    <!--//table-type2-->                                       
                                    
                    <div class="modal_btns">                      
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 6 -->
        <div class="modal-overlay" id="modal6" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">출결관리</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                   
                    <div class="course_history">
                        <div class="h_top">
                            <div class="h_left">
                                <strong class="tit">1주차 출결관리</strong>
                            </div>
                            <div class="h_right">
                                <p class="desc">
                                    <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                    <span>출석<strong>35</strong></span>
                                    <span>지각<strong>3</strong></span>
                                    <span>결석<strong>2</strong></span>
                                </p>
                            </div>                            
                        </div>
                        <div class="h_content">
                            <ul class="accordion course_week">
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">                                        
                                        <a class="title" href="#">                                                
                                            <div class="lecture_box type2">
                                                <div class="lecture_tit">                                                  
                                                    <p class="labels">
                                                        <label class="label s_chasi">1차시</label>
                                                        <label class="label s_basic">동영상</label>
                                                    </p>
                                                    <strong>우리 생활 주변의 데이터베이스</strong>
                                                </div>
                                                <div class="btn_right">
                                                    <span>출석율 <strong class="fcBlue">52%</strong></span>                                                   
                                                </div>
                                                <i class="arrow xi-angle-down"></i>
                                            </div>
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <div class="video-wrap">
                                            <video controls playsinline>
                                                <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4" />
                                            </video>
                                        </div>                                       
                                    </div>
                                </li>                               
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">                                            
                                            <div class="lecture_box type2">
                                                <div class="lecture_tit">
                                                    <p class="labels">
                                                        <label class="label s_chasi">2차시</label>
                                                        <label class="label s_basic">동영상</label>
                                                    </p>
                                                    <strong>데이터베이스 관리 시스템</strong>
                                                </div>
                                                <div class="btn_right">
                                                    <span>출석율 <strong class="fcBlue">63%</strong></span>                                                   
                                                </div>
                                                <i class="arrow xi-angle-down"></i>
                                            </div>
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <div class="video-wrap">
                                            <video controls playsinline>
                                                <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4" />
                                            </video>
                                        </div>
                                    </div>
                                </li>
                            </ul>

                        </div>
                    </div>

                    <div class="board_top mt30">
                        <!-- search small -->
                        <div class="search-typeC">
                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름/학번/학과 입력">
                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                        </div>                        
                        <div class="right-area">                            
                            <button type="button" class="btn basic">메시지 보내기</button>
                            <button type="button" class="btn type2">일괄 출석 관리</button>
                            <button type="button" class="btn type2">엑셀 다운로드</button>
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:5%">
                                <col style="width:7%">
                                <col style="">
                                <col style="width:17%">
                                <col style="width:14%">
                                <col style="width:12%">
                                <col style="width:15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                    </th>
                                    <th>번호</th>
                                    <th>학과</th>
                                    <th>학번</th>
                                    <th>이름</th>                                      
                                    <th>출결</th>                                 
                                    <th>상세보기</th>
                                </tr>
                            </thead>
                            <tbody>                                    
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                    </td>
                                    <td data-th="번호">5</td>
                                    <td data-th="학과">국어국문학과</td>
                                    <td data-th="학번">2021215478</td>
                                    <td data-th="이름">학습자</td>
                                    <td data-th="출결">
                                        <span class="state_ok" aria-label="출석">출석</span>                                            
                                    </td>
                                    <td data-th="상세보기">
                                        <button class="btn basic small">출석관리</button>
                                    </td>                                                                              
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                    </td>
                                    <td data-th="번호">5</td>
                                    <td data-th="학과">국어국문학과</td>
                                    <td data-th="학번">2021215478</td>
                                    <td data-th="이름">학습자</td>
                                    <td data-th="출결">
                                        <span class="state_no" aria-label="결석">결석</span>
                                    </td>
                                    <td data-th="상세보기">
                                        <button class="btn basic small">출석관리</button>
                                    </td>                                                                              
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                    </td>
                                    <td data-th="번호">5</td>
                                    <td data-th="학과">국어국문학과</td>
                                    <td data-th="학번">2021215478</td>
                                    <td data-th="이름">학습자</td>
                                    <td data-th="출결">
                                        <span class="state_late" aria-label="지각">지각</span>
                                    </td>
                                    <td data-th="상세보기">
                                        <button class="btn basic small">출석관리</button>
                                    </td>                                                                              
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!--//table-type-->
                                                                                           
                    <div class="modal_btns">                      
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>

