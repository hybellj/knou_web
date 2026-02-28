<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub_top">
                    <div class="date_info">
                        <i class="icon-svg-calendar" aria-hidden="true"></i>2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
                    </div>
                </div>
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="row">
                            <div class="box">
                                <div class="listTab">
                                    <ul>
                                        <li class="select"><a href="#">학생 접속현황</a></li>
                                        <li><a href="#">교수/튜터 접속현황</a></li>
                                    </ul>
                                </div>

                                <div class="inner_boxA">
                                    <a href="#0" class="state">
                                        <span class="title">대학원</span>
                                        <span class="data">( 50 / 500 )</span>
                                    </a>
                                    <a href="#0" class="state">
                                        <span class="title">경영대학원</span>
                                        <span class="data">( 50 / 500 )</span>
                                    </a>
                                    <a href="#0" class="state">
                                        <span class="title">학위과정</span>
                                        <span class="data">( 50 / 500 )</span>
                                    </a>
                                    <a href="#0" class="state">
                                        <span class="title">평생교육</span>
                                        <span class="data">( 50 / 500 )</span>
                                    </a>
                                    <a href="#0" class="state">
                                        <span class="title">연수원</span>
                                        <span class="data">( 50 / 500 )</span>
                                    </a>
                                </div>

                                <div class="board_top">
                                    <select class="form-select" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>
                                    </select>
                                    <select class="form-select" id="selectCourse">
                                        <option value="과정(테넌시)">과정(테넌시)</option>
                                        <option value="평생교육">평생교육</option>
                                        <option value="경영대학원">경영대학원</option>
                                    </select>
                                    <select class="form-select wide" id="selectMajor">
                                        <option value="">학과</option>
                                        <option value="운영과목1">국어국문학과</option>
                                        <option value="운영과목2">회계트랙</option>
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">과목</option>
                                        <option value="과목1">과목1</option>
                                        <option value="과목2">과목2</option>
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="이름/과목 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>

                                    <div class="right-area">
                                        <button type="button" class="btn basic">메시지 보내기</button>
                                    </div>
                                </div>

                                <!--table-type-->
                                <div class="table-wrap">
                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width:3%">
                                            <col style="width:55px">
                                            <col style="width:9%">
                                            <col style="width:8%">
                                            <col style="width:11%">
                                            <col style="">
                                            <col style="width:10%">
                                            <col style="width:9%">
                                            <col style="width:80px">
                                            <col style="width:4%">
                                            <col style="width:10%">
                                            <col style="width:10%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                                </th>
                                                <th>번호</th>
                                                <th>학생구분</th>
                                                <th>과정(테넌시)</th>
                                                <th>학과</th>
                                                <th>과목(분반)</th>
                                                <th>아이디</th>
                                                <th>학번</th>
                                                <th>이름</th>
                                                <th>학년</th>
                                                <th>휴대폰</th>
                                                <th>접속일시</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk11"><label for="chk11"></label></span>
                                                </td>
                                                <td data-th="번호">500</td>
                                                <td data-th="학생구분"><span class="fcRed">대학원생</span></td>
                                                <td data-th="과정(테넌시)">대학원</td>
                                                <td data-th="학과">국어국문학과</td>
                                                <td data-th="과목(분반)">국문학일반 (1반)</td>
                                                <td data-th="아이디">testid01</td>
                                                <td data-th="학번">2021215478</td>
                                                <td data-th="이름">홍길동</td>
                                                <td data-th="학년">2</td>
                                                <td data-th="휴대폰">010-1234-4567</td>
                                                <td data-th="접속일시">2025.11.10 14:25</td>
                                            </tr>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk12"><label for="chk12"></label></span>
                                                </td>
                                                <td data-th="번호">500</td>
                                                <td data-th="학생구분"><span class="fcRed">비학위수강생</span></td>
                                                <td data-th="과정(테넌시)">평생교육</td>
                                                <td data-th="학과">인문/교육</td>
                                                <td data-th="과목(분반)">일한번역연습 (1반)</td>
                                                <td data-th="아이디">testid01</td>
                                                <td data-th="학번">2021215478</td>
                                                <td data-th="이름">홍길동</td>
                                                <td data-th="학년">-</td>
                                                <td data-th="휴대폰">010-1234-4567</td>
                                                <td data-th="접속일시">2025.11.10 14:25</td>
                                            </tr>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk13"><label for="chk13"></label></span>
                                                </td>
                                                <td data-th="번호">500</td>
                                                <td data-th="학생구분"><span class="fcRed">학위과정학부생</span></td>
                                                <td data-th="과정(테넌시)">학위과정</td>
                                                <td data-th="학과">회계트랙</td>
                                                <td data-th="과목(분반)">회계원리 (1반)</td>
                                                <td data-th="아이디">testid01</td>
                                                <td data-th="학번">2021215478</td>
                                                <td data-th="이름">홍길동</td>
                                                <td data-th="학년">4</td>
                                                <td data-th="휴대폰">010-1234-4567</td>
                                                <td data-th="접속일시">2025.11.10 14:25</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!--//table-type-->
                            </div>
                        </div>

                        <div class="row">
                            <div class="box">
                                <div class="board_top">
                                    <h3 class="board-title">전체 시스템 오류현황</h3>
                                    <span class="total_num">총 <strong>114</strong>건</span>
                                </div>
                                <div class="board_top">
                                    <select class="form-select" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>
                                    </select>
                                    <select class="form-select" id="selectCourse">
                                        <option value="과정(테넌시)">과정(테넌시)</option>
                                        <option value="평생교육">평생교육</option>
                                    </select>
                                    <div class="date_area">
                                        <label class="datepicker">
                                            <input type="text" placeholder="시작일시" id="datetimepicker3">
                                        </label>
                                        <span class="txt-sort">~</span>
                                        <label class="datepicker">
                                            <input type="text" placeholder="종료일시" id="datetimepicker4">
                                        </label>
                                    </div>
                                    <script>
                                    $.datetimepicker.setLocale('ko');

                                    $('#datetimepicker3').datetimepicker({
                                        format: 'Y-m-d H:i',
                                        step: 10,              // 10분 단위 간격
                                        scrollMonth: false,
                                        scrollTime: true,
                                        scrollInput: false,
                                        theme: '',
                                        onShow: function(ct){
                                            this.setOptions({
                                                maxDate: $('#datetimepicker3').val() ? $('#datetimepicker3').val() : false
                                            });
                                        }
                                    });

                                    $('#datetimepicker4').datetimepicker({
                                        format: 'Y-m-d H:i',
                                        step: 10,
                                        scrollMonth: false,
                                        scrollTime: true,
                                        scrollInput: false,
                                        onShow: function(ct){
                                            this.setOptions({
                                                minDate: $('#datetimepicker4').val() ? $('#datetimepicker4').val() : false
                                            });
                                        }
                                    });

                                    $(document).on('click', '.xdsoft_month, .xdsoft_year', function(e) {
                                    e.stopPropagation();
                                    e.preventDefault();
                                    return false;
                                    });
                                    </script>

                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="이름/과목 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>

                                    <div class="right-area">
                                        <button type="button" class="btn type2">엑셀 다운로드</button>
                                    </div>
                                </div>
                                <!--table-type-->
                                <div class="table-wrap">
                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width:55px">
                                            <col style="width:10%">
                                            <col style="width:11%">
                                            <col style="width:15%">
                                            <col style="width:10%">
                                            <col style="width:10%">
                                            <col style="width:80px">
                                            <col style="">
                                            <col style="width:8%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>번호</th>
                                                <th>과정(테넌시)</th>
                                                <th>학과</th>
                                                <th>과목(분반)</th>
                                                <th>일시</th>
                                                <th>학번/사번</th>
                                                <th>이름</th>
                                                <th>오류페이지</th>
                                                <th>오류내용</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td data-th="번호">500</td>
                                                <td data-th="과정(테넌시)">대학원</td>
                                                <td data-th="학과">국어국문학과</td>
                                                <td data-th="과목(분반)">국문학일반 (1반)</td>
                                                <td data-th="일시">2025.10.21 15:36</td>
                                                <td data-th="학번/사번">2021215478</td>
                                                <td data-th="이름">홍길동</td>
                                                <td data-th="오류페이지">/aaaa/bbbb/ccccc/page01.jsp</td>
                                                <td data-th="오류내용"><button class="btn basic small">상세보기</button></td>
                                            </tr>
                                            <tr>
                                                <td data-th="번호">500</td>
                                                <td data-th="과정(테넌시)">평생교육</td>
                                                <td data-th="학과">인문/교육</td>
                                                <td data-th="과목(분반)">일한번역연습 (1반)</td>
                                                <td data-th="일시">2025.10.21 15:36</td>
                                                <td data-th="학번/사번">2021215478</td>
                                                <td data-th="이름">홍길동</td>
                                                <td data-th="오류페이지">/aaaa/bbbb/ccccc/page01.jsp</td>
                                                <td data-th="오류내용"><button class="btn basic small">상세보기</button></td>
                                            </tr>
                                            <tr>
                                                <td data-th="번호">500</td>
                                                <td data-th="과정(테넌시)">학위과정</td>
                                                <td data-th="학과">회계트랙</td>
                                                <td data-th="과목(분반)">회계원리 (1반)</td>
                                                <td data-th="일시">2025.10.21 15:36</td>
                                                <td data-th="학번/사번">2021215478</td>
                                                <td data-th="이름">홍길동</td>
                                                <td data-th="오류페이지">/aaaa/bbbb/ccccc/page01.jsp</td>
                                                <td data-th="오류내용"><button class="btn basic small">상세보기</button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!--//table-type-->
                            </div>
                        </div>

                        <div class="row-grid">
                            <div class="box">
                                <div class="box_title">
                                    <h3 class="h3">시스템공지</h3>
                                    <div class="btn-wrap">
                                        <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                    </div>
                                </div>
                                <div class="box_content">
                                    <ul class="dash_item_listA">
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">시스템점검 안내입니다.</p>
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">시스템점검 안내입니다.</p>
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">시스템점검 안내입니다.</p>
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">시스템점검 안내입니다.</p>
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit">시스템점검 안내입니다.</p>
                                                <p class="desc">
                                                    <span class="name">관리자</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            <div class="box">
                                <div class="box_title">
                                    <h3 class="h3">전체 공지사항</h3>
                                    <div class="btn-wrap">
                                        <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                    </div>
                                </div>
                                <div class="box_content">
                                    <ul class="dash_item_listA">
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[대학원]</span> 전체 공지사항입니다.</p>
                                                <p class="desc">
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[학위과정]</span> 전체 공지사항입니다.</p>
                                                <p class="desc">
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[경영대학원]</span> 전체 공지사항입니다.</p>
                                                <p class="desc">
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[대학원]</span> 전체 공지사항입니다.</p>
                                                <p class="desc">
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[대학원]</span> 전체 공지사항입니다.</p>
                                                <p class="desc">
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">조회: 60</span>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            <div class="box">
                                <div class="box_title">
                                    <h3 class="h3">전체 설문</h3>
                                    <div class="btn-wrap">
                                        <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                    </div>
                                </div>
                                <div class="box_content">
                                    <ul class="dash_item_listA">
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[대학원]</span> 일반설문입니다.</p>
                                                <p class="desc">
                                                    <span class="name">마감</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">참여: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[평생교육]</span> 일반설문입니다.</p>
                                                <p class="desc">
                                                    <span class="name">마감</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">참여: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[학위과정]</span> 일반설문입니다.</p>
                                                <p class="desc">
                                                    <span class="name">마감</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">참여: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[대학원]</span> 일반설문입니다.</p>
                                                <p class="desc">
                                                    <span class="name">마감</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">참여: 60</span>
                                            </div>
                                        </li>
                                        <li>
                                            <a href="#0" class="item_txt">
                                                <p class="tit"><span>[대학원]</span> 일반설문입니다.</p>
                                                <p class="desc">
                                                    <span class="name">마감</span>
                                                    <span class="date">2025.05.17</span>
                                                </p>
                                            </a>
                                            <div class="state">
                                                <span class="view_num">참여: 60</span>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                        </div>

                        <div class="row">
                            <div class="box">
                                <div class="listTab">
                                    <ul>
                                        <li><a href="#">과목별 학습현황</a></li>
                                        <li class="select"><a href="#">학생별 학습현황</a></li>
                                        <li><a href="#">사용자 검색</a></li>
                                    </ul>
                                </div>

                                <div class="board_top">
                                    <select class="form-select" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>
                                    </select>
                                    <select class="form-select" id="selectCourse">
                                        <option value="과정(테넌시)">과정(테넌시)</option>
                                        <option value="평생교육">평생교육</option>
                                        <option value="경영대학원">경영대학원</option>
                                    </select>
                                    <select class="form-select wide" id="selectMajor">
                                        <option value="">학과</option>
                                        <option value="운영과목1">국어국문학과</option>
                                        <option value="운영과목2">회계트랙</option>
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">과목</option>
                                        <option value="과목1">과목1</option>
                                        <option value="과목2">과목2</option>
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="이름/학번 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>

                                    <div class="right-area">
                                        <button type="button" class="btn basic">메시지 보내기</button>
                                        <button type="button" class="btn type2">엑셀 다운로드</button>
                                    </div>
                                </div>

                                <!--table-type-->
                                <div class="table-wrap">
                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width:35px">
                                            <col style="width:50px">
                                            <col style="width:75px">
                                            <col style="width:6%">
                                            <col style="">
                                            <col style="width:65px">
                                            <col style="width:65px">
                                            <col style="width:100px">
                                            <col style="width:55px">
                                            <col style="width:50px">
                                            <col style="width:250px">
                                            <col style="width:55px">
                                            <col style="width:52px">
                                            <col style="width:55px">
                                            <col style="width:52px">
                                            <col style="width:52px">
                                            <col style="width:52px">
                                            <col style="width:52px">
                                            <col style="width:52px">
                                            <col style="width:52px">
                                            <col style="width:55px">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                                </th>
                                                <th>번호</th>
                                                <th>과정<br>(테넌시)</th>
                                                <th>학과</th>
                                                <th>과목(분반)</th>
                                                <th>교수</th>
                                                <th>튜터</th>
                                                <th>학번</th>
                                                <th>이름</th>
                                                <th>학년</th>
                                                <th class="ingrid">출석현황<br>
                                                    <div class="table_ingrid">
                                                        <p>1</p>
                                                        <p>2</p>
                                                        <p>3</p>
                                                        <p>4</p>
                                                        <p>5</p>
                                                        <p>6</p>
                                                        <p>7</p>
                                                        <p>9</p>
                                                        <p>10</p>
                                                        <p>11</p>
                                                        <p>12</p>
                                                        <p>13</p>
                                                        <p>14</p>
                                                        <p>/</p>
                                                    </div>
                                                </th>
                                                <th>진도율</th>
                                                <th>시험</th>
                                                <th>Q&A</th>
                                                <th>1:1</th>
                                                <th>과제</th>
                                                <th>토론</th>
                                                <th>퀴즈</th>
                                                <th>설문</th>
                                                <th>수시</th>
                                                <th>세미나</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                                </td>
                                                <td data-th="번호">5</td>
                                                <td data-th="과정(테넌시)">대학원</td>
                                                <td data-th="학과">국어국문학과</td>
                                                <td data-th="과목(분반)"><a href="#0" class="link">유럽 문화 탐방 (1반)</a></td>
                                                <td data-th="교수">홍길동</td>
                                                <td data-th="튜터">김튜터</td>
                                                <td data-th="학번">2021215478</td>
                                                <td data-th="이름">학습자</td>
                                                <td data-th="학년">2</td>
                                                <td data-th="출석현황">
                                                    <div class="table_ingrid">
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_late" aria-label="지각">△</span></p>
                                                        <p><span class="state_no" aria-label="결석">X</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_late" aria-label="지각">△</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_late" aria-label="지각">△</span></p>
                                                        <p><span class="state_no" aria-label="결석">X</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p>/</p>
                                                    </div>
                                                </td>
                                                <td data-th="진도율">80%</td>
                                                <td data-th="시험"><span class="fcBlue">1</span>/2</td>
                                                <td data-th="Q&A"><span class="fcBlue">2</span>/5</td>
                                                <td data-th="1:1"><span class="fcBlue">2</span>/5</td>
                                                <td data-th="과제"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="토론"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="퀴즈"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="설문"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="수시"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="세미나"><span class="fcBlue">2</span>/3</td>
                                            </tr>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                                </td>
                                                <td data-th="번호">5</td>
                                                <td data-th="과정(테넌시)">대학원</td>
                                                <td data-th="학과">국어국문학과</td>
                                                <td data-th="과목(분반)"><a href="#0" class="link">유럽 문화 탐방 (1반)</a></td>
                                                <td data-th="교수">홍길동</td>
                                                <td data-th="튜터">김튜터</td>
                                                <td data-th="학번">2021215478</td>
                                                <td data-th="이름">학습자</td>
                                                <td data-th="학년">2</td>
                                                <td data-th="출석현황">
                                                    <div class="table_ingrid">
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_late" aria-label="지각">△</span></p>
                                                        <p><span class="state_no" aria-label="결석">X</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_late" aria-label="지각">△</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_late" aria-label="지각">△</span></p>
                                                        <p><span class="state_no" aria-label="결석">X</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p><span class="state_ok" aria-label="출석">○</span></p>
                                                        <p>/</p>
                                                    </div>
                                                </td>
                                                <td data-th="진도율">80%</td>
                                                <td data-th="시험"><span class="fcBlue">1</span>/2</td>
                                                <td data-th="Q&A"><span class="fcBlue">2</span>/5</td>
                                                <td data-th="1:1"><span class="fcBlue">2</span>/5</td>
                                                <td data-th="과제"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="토론"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="퀴즈"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="설문"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="수시"><span class="fcBlue">2</span>/3</td>
                                                <td data-th="세미나"><span class="fcBlue">2</span>/3</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!--//table-type-->
                            </div>
                        </div>

                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>

