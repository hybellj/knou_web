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

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">서브</h2>

                        </div>

                        contents area

                    </div>
                </div>


            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

