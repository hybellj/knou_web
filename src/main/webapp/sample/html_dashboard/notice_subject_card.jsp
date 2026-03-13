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
                            <h2 class="page-title"><span>공지사항</span>과목공지</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공지사항</li>
                                    <li><span class="current">과목공지</span></li>
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
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="작성자/제목 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">과목공지</h3>
                            <div class="right-area">
                                <div class="tab_btn">
                                    <a href="#tab03" class="current">과목공지</a>
                                    <a href="#tab04">전체공지</a>
                                </div>
                                <button type="button" class="btn type2">글쓰기</button>
                                <a href="#0" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <!-- board-type-card -->
                        <div class="table-wrap card">

                            <div class="board_card_list">

                                <div class="card_item">
                                    <div class="card_header">
                                        <label class="label s_c01">고정</label>
                                        <div class="board_tit">
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                            <p><label class="label-title">과정 :</label><strong>대학원</strong></p>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <div class="desc">
                                            <p><label class="label-title">과목</label><strong>데이터베이스 활용</strong></p>
                                            <p><label class="label-title">등록일</label><strong>2025.10.20</strong></p>
                                            <p><label class="label-title">등록자</label><strong>운영자</strong></p>
                                        </div>
                                        <div class="etc">
                                            <p><label class="label-title">읽음</label><strong>45</strong></p>
                                            <p><label class="label-title">댓글</label><strong>45</strong></p>
                                            <p><label class="label-title">첨부</label><strong><i class="icon-svg-paperclip" aria-hidden="true"></i><span class="sr_only">첨부파일 있음</span></strong></p>
                                        </div>
                                    </div>
                                    <div class="bottom_button"><!-- 버튼이 있을 경우 -->
                                        <button class="btn basic small">상세</button>
                                        <button class="btn basic small">수정</button>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <label class="label s_c02">중요</label>
                                        <div class="board_tit">
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                            <p><label class="label-title">과정 :</label><strong>평생교육</strong></p>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <div class="desc">
                                            <p><label class="label-title">과목</label><strong>일한번역연습</strong></p>
                                            <p><label class="label-title">등록일</label><strong>2025.10.20</strong></p>
                                            <p><label class="label-title">등록자</label><strong>운영자</strong></p>
                                        </div>
                                        <div class="etc">
                                            <p><label class="label-title">읽음</label><strong>45</strong></p>
                                            <p><label class="label-title">댓글</label><strong>45</strong></p>
                                            <p><label class="label-title">첨부</label><strong><i class="icon-svg-paperclip" aria-hidden="true"></i><span class="sr_only">첨부파일 있음</span></strong></p>
                                        </div>
                                    </div>
                                    <div class="bottom_button"><!-- 버튼이 있을 경우 -->
                                        <button class="btn basic small">상세</button>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <label class="label s_basic">90</label>
                                        <div class="board_tit">
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                            <p><label class="label-title">과정 :</label><strong>학위과정</strong></p>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <div class="desc">
                                            <p><label class="label-title">과목</label><strong>일한번역연습</strong></p>
                                            <p><label class="label-title">등록일</label><strong>2025.10.20</strong></p>
                                            <p><label class="label-title">등록자</label><strong>운영자</strong></p>
                                        </div>
                                        <div class="etc">
                                            <p><label class="label-title">읽음</label><strong>45</strong></p>
                                            <p><label class="label-title">댓글</label><strong>45</strong></p>
                                            <p><label class="label-title">첨부</label><strong><i class="icon-svg-paperclip" aria-hidden="true"></i><span class="sr_only">첨부파일 있음</span></strong></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <label class="label s_basic">89</label>
                                        <div class="board_tit">
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                            <p><label class="label-title">과정 :</label><strong>대학원</strong></p>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <div class="desc">
                                            <p><label class="label-title">과목</label><strong>일한번역연습</strong></p>
                                            <p><label class="label-title">등록일</label><strong>2025.10.20</strong></p>
                                            <p><label class="label-title">등록자</label><strong>운영자</strong></p>
                                        </div>
                                        <div class="etc">
                                            <p><label class="label-title">읽음</label><strong>45</strong></p>
                                            <p><label class="label-title">댓글</label><strong>45</strong></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <label class="label s_basic">88</label>
                                        <div class="board_tit">
                                            <a href="#0" class="link">게시판 제목입니다. 게시판 제목입니다. 게시판 제목입니다.</a>
                                            <p><label class="label-title">과정 :</label><strong>대학원</strong></p>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <div class="desc">
                                            <p><label class="label-title">과목</label><strong>일한번역연습</strong></p>
                                            <p><label class="label-title">등록일</label><strong>2025.06.02 ~ 2025.06.10</strong></p>
                                            <p><label class="label-title">등록자</label><strong>운영자</strong></p>
                                        </div>
                                        <div class="etc">
                                            <p><label class="label-title">읽음</label><strong>45</strong></p>
                                            <p><label class="label-title">댓글</label><strong>45</strong></p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <label class="label s_basic">87</label>
                                        <div class="board_tit">
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                            <p><label class="label-title">과정 :</label><strong>대학원</strong></p>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <div class="desc">
                                            <p><label class="label-title">과목</label><strong>일한번역연습</strong></p>
                                            <p><label class="label-title">등록일</label><strong>2025.10.20</strong></p>
                                            <p><label class="label-title">등록자</label><strong>운영자</strong></p>
                                        </div>
                                        <div class="etc">
                                            <p><label class="label-title">읽음</label><strong>45</strong></p>
                                            <p><label class="label-title">댓글</label><strong>45</strong></p>
                                        </div>
                                    </div>
                                </div>

                            </div>

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
                        <!--// board-type-card -->



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

