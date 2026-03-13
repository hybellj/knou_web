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
                            <h2 class="page-title">학습진도관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current">학습진도관리</span></li>
                                </ul>
                            </div>
                        </div>

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
                                        <option value="기관">기관</option>
                                    </select>
                                    <select class="form-select" id="selectMajor">
                                        <option value="">학과</option>
                                        <option value="운영과목1">국어국문학과</option>
                                        <option value="운영과목2">회계트랙</option>
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">과목</option>
                                        <option value="과목1">과목1</option>
                                        <option value="과목2">과목2</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <span class="custom-input">
                                        <input type="checkbox" name="name" id="checkType1">
                                        <label for="checkType1">미학습자 전체</label>
                                    </span>
                                    <div class="percent_area">
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


                        <div class="lecture_status_box">
                            <div class="box_item">
                                <div class="title">전체<i class="xi-angle-right-min"></i></div>
                                <div class="item_txt">
                                    <p class="desc">
                                        <i class="icon-svg-group" aria-hidden="true"></i>
                                        수강생 수 : <strong>80명</strong>
                                    </p>
                                    <p class="desc">
                                        <i class="icon-svg-bar-chart" aria-hidden="true"></i>
                                        평균 학습 진도율 : <strong>70%</strong>
                                    </p>
                                </div>
                            </div>
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
                                <button type="button" class="btn basic">학과별 전체통계</button>
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
                                    <col style="width:3%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:3%">
                                    <col style="width:8%">
                                    <col style="width:12%">
                                    <col style="">
                                    <col style="width:5%">
                                    <col style="width:10%">
                                    <col style="width:8%">
                                    <col style="width:6%">
                                    <col style="width:4%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>기관</th>
                                        <th>학과</th>
                                        <th>과목명</th>
                                        <th>분반</th>
                                        <th>아이디</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>학년</th>
                                        <th>오픈주차
                                        <sapn class="c-point01">(A)</sapn>
                                        </th>
                                        <th>학습주차
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
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="과목명">고전문학심화</td>
                                        <td data-th="분반">01</td>
                                        <td data-th="아이디">Test01</td>
                                        <td data-th="학번">K202612547</td>
                                        <td data-th="이름">학습자4</td>
                                        <td data-th="학년">2</td>
                                        <td data-th="오픈주차(A)">40</td>
                                        <td data-th="학습주차(B)">30</td>
                                        <td data-th="출석율(B/A)">75%</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="기관">학위과정</td>
                                        <td data-th="학과">첨단공학부</td>
                                        <td data-th="과목명">산업공학전공</td>
                                        <td data-th="분반">01</td>
                                        <td data-th="아이디">Test01</td>
                                        <td data-th="학번">K202612547</td>
                                        <td data-th="이름">학습자4</td>
                                        <td data-th="학년">2</td>
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

