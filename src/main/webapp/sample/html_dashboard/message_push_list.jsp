<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
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
			<jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>메시지함</span>PUSH</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>메시지함</li>
                                    <li><span class="current">PUSH</span></li>
                                </ul>
                            </div>
                        </div>


                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectCourse">
                                        <option value="대학원">대학원</option>
                                        <option value="평생교육">평생교육</option>
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">운영과목 선택</option>
                                        <option value="운영과목1">운영과목1</option>
                                        <option value="운영과목2">운영과목2</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">요청 일시</label></span>
                                <div class="itemList">
                                    <div class="date_area">
                                        <input type="text" placeholder="시작일" id="datetimepicker1" class="datepicker" toDate="datetimepicker2">
                                        <span class="txt-sort">~</span>
                                        <input type="text" placeholder="종료일" id="datetimepicker2" class="datepicker" fromDate="datetimepicker1">
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="발신자">발신자</option>
                                        <option value="발신자번호">발신자번호</option>
                                        <option value="제목">제목</option>
                                        <option value="내용">내용</option>
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어를 입력해주세요.">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 목록</h3>
                            <div class="right-area">
                                <div class="tab_btn">
                                    <a href="#0" class="current">수신목록</a>
                                    <a href="#0">발신목록</a>
                                </div>
                                <button type="button" class="btn basic icon" aria-label="새로고침"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                                <button type="button" class="btn type2">발신하기</button>
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
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:10%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:11%">
                                    <col style="">
                                    <col style="width:11%">
                                    <col style="width:4%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>과정</th>
                                        <th>운영과목</th>
                                        <th>반</th>
                                        <th>발신자</th>
                                        <th>발신자번호</th>
                                        <th>제목</th>
                                        <th>발신일시</th>
                                        <th>읽음</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type2-->

                        <!-- board foot -->
                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b>12</b>건</span>
                                <span class="current_page">현재 페이지 <strong>1</strong>/10</span>
                            </div>

                            <div class="board_pager">
                                <span class="inner">
                                    <a href="" class="page_first" title="첫페이지"><i class="icon-svg-arrow01"></i><span class="sr_only">첫페이지</span></a>
                                    <a href="" class="page_prev" title="이전페이지"><i class="icon-svg-arrow02"></i><span class="sr_only">이전페이지</span></a>
                                    <a href="" class="page_now" title="1페이지"><strong>1</strong></a>
                                    <a href="" class="page_none" title="2페이지">2</a>
                                    <a href="" class="page_none" title="3페이지">3</a>
                                    <a href="" class="page_none" title="4페이지">4</a>
                                    <a href="" class="page_none" title="5페이지">5</a>
                                    <a href="" class="page_next" title="다음페이지"><i class="icon-svg-arrow03"></i><span class="sr_only">다음페이지</span></a>
                                    <a href="" class="page_last" title="마지막페이지"><i class="icon-svg-arrow04"></i><span class="sr_only">마지막페이지</span></a>
                                </span>
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

