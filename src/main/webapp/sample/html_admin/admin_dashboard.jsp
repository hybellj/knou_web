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
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
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
                                        <li class="select"><a href="#">과목별 학습현황</a></li>
                                        <li><a href="#">학생별 학습현황</a></li>
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
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="과목명/교수명/과목코드 입력">
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
                                            <col style="width:5%">
                                            <col style="">
                                            <col style="width:4%">
                                            <col style="width:8%">
                                            <col style="width:55px">
                                            <col style="width:55px">
                                            <col style="width:5%">
                                            <col style="width:55px">
                                            <col style="width:55px">
                                            <col style="width:59px">
                                            <col style="width:59px">
                                            <col style="width:59px">
                                            <col style="width:59px">
                                            <col style="width:59px">
                                            <col style="width:59px">
                                            <col style="width:10%">
                                            <col style="width:10%">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                                </th>
                                                <th>번호</th>
                                                <th>과정<br>(테넌시)</th>
                                                <th>학과</th>
                                                <th>과목코드</th>
                                                <th>과목(분반)</th>
                                                <th>교수</th>
                                                <th>튜터</th>
                                                <th>수강</th>
                                                <th>청강</th>
                                                <th>강의계획서</th>
                                                <th>강의<br>공지</th>
                                                <th>Q&A</th>
                                                <th>1:1<br>상담</th>
                                                <th>과제<br>평가</th>
                                                <th>토론<br>평가</th>
                                                <th>퀴즈<br>평가</th>
                                                <th>설문<br>평가</th>
                                                <th>수시<br>평가</th>
                                                <th>중간고사</th>
                                                <th>기말고사</th>
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
                                                <td data-th="과목코드">COP1041</td>
                                                <td data-th="과목(분반)"><a href="#0" class="link">유럽 문화 탐방 (1반)</a></td>
                                                <td data-th="교수">홍길동</td>
                                                <td data-th="튜터">
                                                    김튜터<br>
                                                    <span class="sm">02-1254-8759</span>
                                                </td>
                                                <td data-th="수강">50명</td>
                                                <td data-th="청강">2명</td>
                                                <td data-th="강의계획서"><button class="btn basic small">보기</button></td>
                                                <td data-th="강의공지"><span class="fcBlue">2</span></td>
                                                <td data-th="Q&A"><span class="fcBlue">12</span>/15</td>
                                                <td data-th="1:1상담"><span class="fcBlue">12</span>/15</td>
                                                <td data-th="과제평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="토론평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="퀴즈평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="설문평가">-</td>
                                                <td data-th="수시평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="중간고사">
                                                    기타 (과제 : <span class="fcBlue">44</span>/45 )
                                                </td>
                                                <td data-th="기말고사">
                                                    2022.04.16 18:00  30분<br>
                                                    성적공개 / 시험지공개
                                                </td>
                                            </tr>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk22"><label for="chk22"></label></span>
                                                </td>
                                                <td data-th="번호">5</td>
                                                <td data-th="과정(테넌시)">평생교육</td>
                                                <td data-th="학과">국어국문학과</td>
                                                <td data-th="과목코드">COP1041</td>
                                                <td data-th="과목(분반)"><a href="#0" class="link">창의적사고와 글쓰기 (1반)</a></td>
                                                <td data-th="교수">홍길동</td>
                                                <td data-th="튜터">
                                                    김튜터<br>
                                                    <span class="sm">02-1254-8759</span>
                                                </td>
                                                <td data-th="수강">50명</td>
                                                <td data-th="청강">0명</td>
                                                <td data-th="강의계획서"><button class="btn basic small">보기</button></td>
                                                <td data-th="강의공지"><span class="fcBlue">4</span></td>
                                                <td data-th="Q&A"><span class="fcBlue">12</span>/15</td>
                                                <td data-th="1:1상담"><span class="fcBlue">12</span>/15</td>
                                                <td data-th="과제평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="토론평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="퀴즈평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="설문평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="수시평가"><span class="fcBlue">44</span>/45</td>
                                                <td data-th="중간고사">
                                                    2022.04.16 18:00  30분<br>
                                                    성적공개 / 시험지공개
                                                </td>
                                                <td data-th="기말고사">
                                                    2022.04.16 18:00  30분<br>
                                                    성적공개 / 시험지공개
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!--//table-type-->
                            </div>
                        </div>

                    </div>
                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" data-modal-open="modal1">전체 시스템 오류현황 > 상세보기</button>
                    <button type="button" class="btn modal__btn" data-modal-open="modal2">강의계획서</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-md" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">시스템 오류 내용 상세보기</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    <div class="msg-box warning">                                
                        <p class="txt"><strong>오류 위치 : </strong>교수 > 대시보드 > 강의실 > 과제 등록</p>                                                             
                    </div>
                    <div class="error_txt">
<pre>2022.10.21(16:37:33)
[E0400] 페이지 오류 
I/O error on POST request for "http://localhost:8384/haksa/sync/crs": Connect to localhost:8384 [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: Connection refused: connect; nested exception is org.apache.http.conn.HttpHostConnectException: Connect to localhost:8384 [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: Connection refused: connect
</pre>                       
                    </div>
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">강의계획서</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">

                    <div class="board_top">
                        <h3 class="board-title">과목 정보</h3>
                    </div>
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>과목번호</label></li>
                            <li>CM0025</li>
                            <li class="head"><label>분반</label></li>
                            <li>01</li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>과목명 (한글)</label></li>
                            <li>데이터베이스의 이해 활용</li>
                            <li class="head"><label>과목명 (영문)</label></li>
                            <li>Data base</li>
                        </ul>
                        <ul class="list">
                            <li class="head"><label>학과</label></li>
                            <li>컴퓨터공학과</li>
                            <li class="head"><label>학점 : 강의/실습</label></li>
                            <li>3 : 3 / 0</li>
                        </ul>
                    </div>

                    <div class="board_top mt30">
                        <h3 class="board-title">교수 정보</h3>
                    </div>
                    <!-- 정보성 테이블 -->
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>교수</th>
                                    <th>소속</th>
                                    <th>연락처</th>
                                    <th>이메일</th>                                   
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="교수">운영교수 : 홍길동</td>
                                    <td data-th="소속">컴퓨터공학과</td>
                                    <td data-th="연락처">02-5214-9853</td>
                                    <td data-th="이메일">test@naver.com</td>                                   
                                </tr>
                                <tr>
                                    <td data-th="교수">공동교수 : 김교수</td>
                                    <td data-th="소속">컴퓨터공학과</td>
                                    <td data-th="연락처">02-5214-9853</td>
                                    <td data-th="이메일">test@naver.com</td>                                   
                                </tr>
                                <tr>
                                    <td data-th="교수">개발교수 : 이교수</td>
                                    <td data-th="소속">컴퓨터공학과</td>
                                    <td data-th="연락처">02-5214-9853</td>
                                    <td data-th="이메일">test@naver.com</td>                                   
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="msg-box basic">                                
                        <ul class="list-asterisk">
                            <li>운영교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>
                            <li>개발교수 : 강의 콘텐츠(학습 동영상)를 제작하는 교수</li>                                    
                        </ul>                                                           
                    </div>
                    
                    <div class="board_top">
                        <h3 class="board-title">튜터 정보</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>튜터</th>
                                    <th>연락처</th>
                                    <th>핸드폰</th>
                                    <th>이메일</th>                                   
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="튜터">이튜터</td>
                                    <td data-th="연락처">02-9574-9874</td>
                                    <td data-th="핸드폰">010-7536-2587</td>
                                    <td data-th="이메일">test@naver.com</td>                                   
                                </tr>                                
                            </tbody>
                        </table>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">조교 정보</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>조교</th>
                                    <th>연락처</th>
                                    <th>핸드폰</th>
                                    <th>이메일</th>                                   
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="조교">홍조교</td>
                                    <td data-th="연락처">02-9574-9874</td>
                                    <td data-th="핸드폰">010-7536-2587</td>
                                    <td data-th="이메일">test@naver.com</td>                                   
                                </tr>                                
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="board_top">
                        <h3 class="board-title">강의 개요</h3>
                    </div>
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>교과목 개요</label></li>
                            <li>본 교과목은 공학 전공에 필요한 화학의 기본 개념 정립을 위해 자연과학의 기초가 되는 물질과 주위의 환경현상에 대한 변화를 이해하고 물질의 에너지, 
                                화학결합과 원자 및 분자구조, 화학열역학과 화학평형, 반응속도론 등 화학 기초 지식 습득을 목표로 한다.
                            </li>                           
                        </ul>
                        <ul class="list">
                            <li class="head"><label>강의 목표</label></li>
                            <li>자연과학의 기초가 되는 물질과 그 변화에 대한 이해, 화학결합과 원자 및 분자구조, 화학열역학과 화학평형, 반응속도론 등의 화학의 기본 개념을 이해하고 정립한다.</li>                           
                        </ul>
                        <ul class="list">
                            <li class="head"><label>운영 방침</label></li>
                            <li>대학의 출석/운영/평가 등 일반 정책 및 방침 준수</li>                           
                        </ul>
                        <ul class="list">
                            <li class="head"><label>운영 계획</label></li>
                            <li>
                                <ul class="list-bullet">
                                    <li>최적 학습 시간 : 주 150분</li>
                                    <li>학습 방법 : 강의 내용과 교재를 학습</li>
                                    <li>학습 규칙 : 학습 순서 준수</li>
                                    <li>학습 절차 : 학습목표 .> 단계별 이론 강의 > 응용 및 문제풀이 > 학습 요약</li>
                                </ul>
                            </li>                           
                        </ul>
                        <ul class="list">
                            <li class="head"><label>관련 과목 내용</label></li>
                            <li>-</li>                           
                        </ul>
                        <ul class="list">
                            <li class="head"><label>참고 사항</label></li>
                            <li>-</li>                           
                        </ul>                       
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">교재</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:7%">
                                <col style="width:10%">
                                <col style="">
                                <col style="width:20%">
                                <col style="width:21%">
                                <col style="width:16%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>구분</th>
                                    <th>교재명</th>
                                    <th>ISBN</th>   
                                    <th>저자</th>
                                    <th>출판사</th>                                
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">1</td>
                                    <td data-th="구분">주교재</td>
                                    <td data-th="교재명">기본 일반화학</td>
                                    <td data-th="ISBN">9788962184822</td>   
                                    <td data-th="저자">Stieven S. Zumdahl</td>     
                                    <td data-th="출판사">CENGAGE</td>                                     
                                </tr>   
                                <tr>
                                    <td data-th="번호">1</td>
                                    <td data-th="구분">부교재</td>
                                    <td data-th="교재명">생활 화학 개론</td>
                                    <td data-th="ISBN">9788962184822</td>   
                                    <td data-th="저자">Stieven S. Zumdahl</td>     
                                    <td data-th="출판사">CENGAGE</td>                                     
                                </tr>                                
                            </tbody>
                        </table>
                    </div>                    
                    <div class="file-wrap">                              
                        <ul class="add_file">
                            <li>
                                <div class="tit_area">
                                    <span class="tit">강의노트 :</span>                
                                    <a href="#" class="file_down">                                       
                                        <span class="text">강의노트.zip</span>
                                        <span class="fileSize">(6KB)</span>
                                    </a>  
                                </div>                  
                                <span class="link">
                                    <button class="btn s_basic down">다운로드</button>                                         
                                </span>
                            </li>
                            <li>
                                <div class="tit_area">
                                    <span class="tit">음성파일 :</span>
                                    <a href="#" class="file_down">                                       
                                        <span class="text">음성파일125.zip</span>
                                        <span class="fileSize">(200KB)</span>
                                    </a>    
                                </div>                                                               
                                <span class="link">
                                    <button class="btn s_basic down">다운로드</button>                                         
                                </span>
                            </li>
                        </ul>
                    </div>
                    <div class="msg-box basic">                                
                        <ul class="list-asterisk">
                            <li>주교재 선정된 경우나 과목 특성에 따라 강의노트가 제공되지 않을 수 있습니다.</li>
                            <li>과목의 특성에 따라 제공여부가 변경/취소 혹은 일부 차시만 제공될 수 있습니다.</li>                                    
                        </ul>                                                           
                    </div>
                    
                    <div class="board_top">
                        <h3 class="board-title">평가방법</h3>
                    </div>
                    <div class="table_list">                       
                        <ul class="list">
                            <li class="head"><label>평가방법</label></li>
                            <li>상대 평가 : 학업성과를 다른 학생과 비교하여 상대적 위치를 평가하는 방식</li>                           
                        </ul>                                             
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">평가비율</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>                            
                                <col style="">
                                <col style="width:10%">
                                <col style="width:10%">
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
                                    <th>출석</th>   
                                    <th>과제</th>
                                    <th>토론</th> 
                                    <th>퀴즈</th>  
                                    <th>설문</th>                                 
                                    <th>세미나</th>  
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th data-th="평가항목">비율 (%)</th>
                                    <td data-th="중간고사">25</td>
                                    <td data-th="기말고사">25</td> 
                                    <td data-th="출석">15</td>   
                                    <td data-th="과제">10</td>                                    
                                    <td data-th="토론">10</td>   
                                    <td data-th="퀴즈">10</td>   
                                    <td data-th="설문">5</td>   
                                    <td data-th="세미나">-</td>   
                                </tr> 
                                <tr>
                                    <th data-th="평가항목">성적공개여부</th>
                                    <td data-th="중간고사">공개</td>
                                    <td data-th="기말고사">공개</td> 
                                    <td data-th="출석">비공개</td>   
                                    <td data-th="과제">공개</td>                                    
                                    <td data-th="토론">공개</td>   
                                    <td data-th="퀴즈">공개</td>   
                                    <td data-th="설문">공개</td>   
                                    <td data-th="세미나">-</td>   
                                </tr>                                                                   
                            </tbody>
                        </table>
                    </div>  
                    <div class="msg-box basic">                                
                        <ul class="list-asterisk">
                            <li>출석 : 출석 마감일까지 중간/기말고사를 제외하고 70%이상 수강해야 하며, 70%미만일 경우 F학점(0점) 처리됩니다.</li>
                            <li>정기시험 (중간/기말)에 모두 미응시 경우 학점(0점) 처리됩니다.</li>                                    
                        </ul>                                                           
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">주차별 강의내용</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>      
                                <col style="width:10%">                      
                                <col style="">                                
                                <col style="width:15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>주차</th>
                                    <th>강의 내용</th>
                                    <th>담당교수</th>                                    
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th data-th="주차">1</th>
                                    <td data-th="강의내용" class="t_left">일반화학 개요</td>
                                    <td data-th="담당교수">홍길동</td> 
                                </tr> 
                                <tr>
                                    <th data-th="주차">2</th>
                                    <td data-th="강의내용" class="t_left">원소, 원자 및 이온</td>
                                    <td data-th="담당교수">홍길동</td> 
                                </tr> 
                                                                                              
                            </tbody>
                        </table>
                    </div> 
                    <div class="msg-box basic">                                
                        <ul class="list-asterisk">
                            <li>강의 내용은 사정에 따라 변경될 수 있습니다.</li>                                                      
                        </ul>                                                           
                    </div> 

                    <div class="board_top">
                        <h3 class="board-title">장애인/고령자 지원</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>                                                          
                                                     
                                <col style="width:20%">
                                <col style="width:20%">
                                <col style="width:20%">
                                <col style="width:20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th colspan="4">콘텐츠 내
                                    학습지원 기능
                                    </th>
                                </tr>
                                <tr>
                                   
                                    <th>플레이어 단축키</th>
                                    <th>스크립트</th>
                                    <th>자막</th>
                                    <th>재생속도 조절</th>                                    
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="플레이어 단축키">제공</td>
                                    <td data-th="스크립트">제공</td> 
                                    <td data-th="자막">제공</td> 
                                    <td data-th="재생속도 조절">제공</td> 
                                </tr>                                                                                                                               
                            </tbody>
                        </table>
                    </div>
                    <div class="msg-box basic">                                
                        <ul class="list-asterisk">
                            <li>개발 방식에 따라 일부 주차 혹은 페이지는 제공되지 않을 수 있습니다.</li> 
                            <li>미디어 플레이어 단축키</li>                                                     
                        </ul> 
                        <ul class="list-bullet">
                            <li>미디어 일시정지/재생 : Space Bar</li> 
                            <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li> 
                            <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li> 
                            <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>    
                            <li>전체 화면 : F</li>                                                 
                        </ul>                                                           
                    </div> 
                    <div class="table_list">                       
                        <ul class="list">
                            <li class="head"><label>시험 지원</label></li>
                            <li>온라인 시험 시간 연장 : 단, 담당교수의 운영방침에 따라 부여되지 않을 수 있습니다.</li>                           
                        </ul>                                             
                    </div>


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

