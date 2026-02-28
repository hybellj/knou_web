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
                                        <li><a href="#">과목별 학습현황</a></li>
                                        <li><a href="#">학생별 학습현황</a></li>
                                        <li class="select"><a href="#">사용자 검색</a></li>
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
                                        <option value="기관">기관</option>
                                        <option value="평생교육">평생교육</option>
                                        <option value="경영대학원">경영대학원</option>
                                    </select>
                                    <select class="form-select wide" id="selectMajor">
                                        <option value="">학과/부서</option>
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
                                            <col style="width:70px">
                                            <col style="width:150px"> 
                                            <col style="width:200px">
                                            <col style="width:150px">
                                            <col style="width:120px">
                                            <col style="width:150px">
                                            <col style="width:120px">
                                            <col style="width:150px">                                                                                                                             
                                            <col style="">
                                            <col style="width:100px">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                                </th>
                                                <th>번호</th>
                                                <th>기관</th>
                                                <th>학과/부서</th>
                                                <th>구분</th>
                                                <th>대표ID</th>
                                                <th>학번/사번</th>
                                                <th>이름</th>
                                                <th>핸드폰</th>                                               
                                                <th>이메일</th>
                                                <th>로그인</th>                                             
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td data-th="선택">
                                                    <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                                </td>
                                                <td data-th="번호">5</td>
                                                <td data-th="기관">대학원</td>
                                                <td data-th="학과/부서">국어국문학과</td>
                                                <td data-th="구분">대학원생</td>
                                                <td data-th="대표ID">TESTID01</td>
                                                <td data-th="학번/사번">2021215478</td>
                                                <td data-th="이름"><a href="#0" class="link">학습자1</a></td>
                                                <td data-th="핸드폰">010-1234-5698</td>
                                                <td data-th="이메일">k202154774@knou.ac.kr</td>                                                
                                                <td data-th="로그인"><button class="btn basic small">로그인</button></td>                                                
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
                    <button type="button" class="btn modal__btn" data-modal-open="modal1">사용자 정보</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">사용자 정보</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">                   
                    <div class="user-wrap">
                        <div class="user-img">
                            <div class="user-photo">
                                <!--프로필 사진-->
                                <img src="/lms_design_sample/webdoc/assets/img/common/photo_user_sample.png" alt="사진">
                            </div>
                        </div>
                                             
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>기관</label></li>
                                <li>대학원 / 평생교육원 / 학위과정</li>                                
                            </ul>
                            <ul class="list">
                                <li class="head"><label>이름</label></li>
                                <li>학습자4</li>                             
                            </ul>
                            <ul class="list">
                                <li class="head"><label>학번</label></li>
                                <li>2021215478</li>                                
                            </ul>
                            <ul class="list">
                                <li class="head"><label>아이디</label></li>
                                <li>TESTID04</li>                                
                            </ul>
                            <ul class="list">
                                <li class="head"><label>휴대폰번호</label></li>
                                <li>010-1234-5698</li>                                
                            </ul>
                            <ul class="list">
                                <li class="head"><label>사용 이메일</label></li>
                                <li>k202154774@knou.ac.kr (연계 이메일)</li>                                
                            </ul>                          
                        </div>
                       
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

