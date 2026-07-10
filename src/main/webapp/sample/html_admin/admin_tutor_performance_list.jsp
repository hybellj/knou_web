<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/admin_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/admin_aside.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
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
                        <div class="page-info">
                            <h2 class="page-title">튜터실적관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과정관리</li>
                                    <li><span class="current">튜터실적관리</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDate1" disabled>
                                        <option value="기관 선택">기관 선택</option>
                                        <option value="전체">전체</option>
                                        <option value="경영대학원">경영대학원</option>
                                        <option value="프라임칼리지 학위과정">프라임칼리지 학위과정</option>
                                        <option value="프라임칼리지 평생교육과정">프라임칼리지 평생교육과정</option>
                                        <option value="종합교육연수원">종합교육연수원</option>
                                        <option value="허브대학">허브대학</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">년도/학기(기수)</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectCourse">
                                        <option value="2026년">2026년</option>
                                    </select>
                                    <select class="form-select" id="selectCourse">
                                        <option value="1학기">1학기</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">학과</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="전체">학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">기간</label></span>
                                <div class="itemList">
                                    <input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
                                    <span class="txt-sort">~</span>
                                    <input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">튜터</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="전체">학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>                        


                        <div class="board_top"> 
                            <h3 class="board-title">목록<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>22</b>건 ]</span></h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn type2">엑셀 다운로드</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <div class="table-wrap overflow-y">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:5%">
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col style="width:15%">
                                    <col>
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col" class="cursor-pointer">기관<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">년도<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">학기<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col">학과</th>
                                        <th scope="col">과목</th>
                                        <th scope="col">분반</th>
                                        <th scope="col">대표ID</th>
                                        <th scope="col">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chkall">
                                                <label for="chkall" class="mr5"></label> 튜터
                                            </span>
                                        </th>
                                        <th scope="col">검색기간</th>
                                        <th scope="col">실적인정시간</th>
                                        <th scope="col">상세보기</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">22</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">-</td>
                                        <td data-th="과목">로그인</td>
                                        <td data-th="분반">-</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="튜터" rowspan="7">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk1">
                                                <label for="chk1" class="mr5"></label> 이*터
                                            </span>
                                        </td>
                                        <td data-th="검색기간" rowspan="7">1016.02.01 ~ 2026.02.29</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                        <td data-th="상세보기" rowspan="7">
                                            <button type="button" class="btn basic small">상세보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">21</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2016년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">20</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목">데이터베이스특론</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">19</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">-</td>
                                        <td data-th="과목">로그아웃</td>
                                        <td data-th="분반">-</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">18</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">-</td>
                                        <td data-th="과목">로그인</td>
                                        <td data-th="분반">-</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">17</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목">AI기초</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">16</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">-</td>
                                        <td data-th="과목">로그인</td>
                                        <td data-th="분반">-</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">15</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">실용중국어학과</td>
                                        <td data-th="과목">중한통번역연습</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="튜터" rowspan="3">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk2">
                                                <label for="chk2" class="mr5"></label> 홍*터
                                            </span>
                                        </td>
                                        <td data-th="검색기간" rowspan="3">1016.02.01 ~ 2026.02.29</td>
                                        <td data-th="실적인정시간" rowspan="3">65분 35초</td>
                                        <td data-th="상세보기" rowspan="3">
                                            <button type="button" class="btn basic small">상세보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">14</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">-</td>
                                        <td data-th="과목">로그아웃</td>
                                        <td data-th="분반"></td>
                                        <td data-th="대표ID">testi**01</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">13</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">-</td>
                                        <td data-th="과목">로그아웃</td>
                                        <td data-th="분반"></td>
                                        <td data-th="대표ID">testi**01</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">12</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">행정학과</td>
                                        <td data-th="과목">정책과정론</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="튜터">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk3">
                                                <label for="chk3" class="mr5"></label> 나*터
                                            </span>
                                        </td>
                                        <td data-th="검색기간">1016.02.01 ~ 2026.02.29</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                        <td data-th="상세보기">
                                            <button type="button" class="btn basic small">상세보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">11</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">행정학과</td>
                                        <td data-th="과목">인사해정세미나</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="튜터">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk4">
                                                <label for="chk4" class="mr5"></label> 나*터
                                            </span>
                                        </td>
                                        <td data-th="검색기간">1016.02.01 ~ 2026.02.29</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                        <td data-th="상세보기">
                                            <button type="button" class="btn basic small">상세보기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">11</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">평생교육학과</td>
                                        <td data-th="과목">교수설계특론</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**01</td>
                                        <td data-th="튜터">
                                            <span class="custom-input onlychk">
                                                <input type="checkbox" id="chk5">
                                                <label for="chk5" class="mr5"></label> 박*터
                                            </span>
                                        </td>
                                        <td data-th="검색기간">1016.02.01 ~ 2026.02.29</td>
                                        <td data-th="실적인정시간">5분 00초</td>
                                        <td data-th="상세보기">
                                            <button type="button" class="btn basic small">상세보기</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>


                    </div>
                </div>


                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1">튜터 실적인정 상세보기</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


            </div>
            <!-- //content -->


        <!-- Modal1 사용자 정보 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    
                    <div class="listTab">
                        <ul>
                            <li class="select"><a href="#0">일별</a></li>
                            <li><a href="#">주별</a></li>
                            <li><a href="#">월별</a></li>
                        </ul>
                    </div>

                    <div class="board_top">
                        <div class="course_history bd0 mt0">
                            <p class="desc">
                                <span>검색 기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                <span><strong>정보과학과</strong></span>
                                <span class="mr10">튜터<strong class="fcBlue">이*터</strong></span>
                            </p>
                        </div>
                        <div class="right-area">
                            <button type="button" class="btn small type2">엑셀로 다운로드</button>
                        </div>
                    </div>


                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:7%">
                                <col>
                                <col style="width:3%">
                                <col>
                                <col>
                                <col>
                                <col>
                                <col style="width:7%">
                                <col style="width:7%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">일</th>
                                    <th scope="col">과목</th>
                                    <th scope="col">분반</th>
                                    <th scope="col">메뉴</th>
                                    <th scope="col">액션구분</th>
                                    <th scope="col">액션내용</th>
                                    <th scope="col">접속일시</th>
                                    <th scope="col">접속시간</th>
                                    <th scope="col">합산시간</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="일" rowspan="4">2026.02.01</td>
                                    <td data-th="과목">-</td>
                                    <td data-th="분반">-</td>
                                    <td data-th="메뉴" class="t_left"><span class="fcBlue">로그인</span></td>
                                    <td data-th="액션구분" class="t_left">로그인 버튼 클릭</td>
                                    <td data-th="액션내용" class="t_left">대시보드</td>
                                    <td data-th="접속일시">2026.02.01 13:25:35</td>
                                    <td data-th="접속시간">00:00:00</td>
                                    <td data-th="합산시간" rowspan="4">00:02:00</td>
                                </tr>
                                <tr>
                                    <td data-th="과목">-</td>
                                    <td data-th="분반">-</td>
                                    <td data-th="메뉴" class="t_left">대학원 > 대시보드 > 메시지함</td>
                                    <td data-th="액션구분" class="t_left">메시지함 메뉴 클릭</td>
                                    <td data-th="액션내용" class="t_left">PUSH목록</td>
                                    <td data-th="접속일시">2026.02.01 13:25:35</td>
                                    <td data-th="접속시간">00:00:00</td>
                                </tr>
                                <tr>
                                    <td data-th="과목">-</td>
                                    <td data-th="분반">-</td>
                                    <td data-th="메뉴" class="t_left">대학원 > 대시보드 > 메시지함 > PUSH</td>
                                    <td data-th="액션구분" class="t_left">PUSH 목록 > 제목 클릭</td>
                                    <td data-th="액션내용" class="t_left">PUSH 상세보기</td>
                                    <td data-th="접속일시">2026.02.01 13:25:35</td>
                                    <td data-th="접속시간">00:00:00</td>
                                </tr>
                                <tr>
                                    <td data-th="과목">-</td>
                                    <td data-th="분반">-</td>
                                    <td data-th="메뉴" class="t_left">대학원 > 대시보드</td>
                                    <td data-th="액션구분" class="t_left">운영과목 > 유비쿼터스컴퓨팅 1반 클릭</td>
                                    <td data-th="액션내용" class="t_left">유비쿼터스컴퓨팅 1반 강의실</td>
                                    <td data-th="접속일시">2026.02.01 13:25:35</td>
                                    <td data-th="접속시간">00:00:10</td>
                                </tr>
                                <tr class="total">
                                    <th colspan="8" class="text-right"><strong>실적 총합계</strong></th>
                                    <th><strong>10:54:55</strong></th>
                                </tr>
                            </tbody>
                        </table>
                    </div>


                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 사용자 정보 -->


        </main>
        <!-- //admin-->

    </div>
<script>
    //튜터 실적인정 상세보기
    $('#btn-modal1').on('click', function() {
        
        var $content = $('#modal1 .modal-body');

        UiDialog("dialog1", {
            title: "튜터 실적인정 상세보기",
            width: '90%',
            height: 600,
            html: $content
        });
    });    
</script>
</body>
</html>

