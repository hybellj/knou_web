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
                                    <select class="form-select chosen" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>
                                    </select>
                                    <select class="form-select chosen" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select chosen" id="selectCourse">
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
                                <a href="#0" class="btn_list_type on" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>

                                <%-- 목록 스케일 선택 --%>
								<uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
                            </div>
                        </div>

                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:7%">
                                    <col style="width:7%">
                                    <col style="width:12%">
                                    <col style="width:4%">
                                    <col style="">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col style="width:6%">
                                    <col style="width:6%">
                                    <col style="width:6%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>과정</th>
                                        <th>과목</th>
                                        <th>반</th>
                                        <th>제목</th>
                                        <th>등록일</th>
                                        <th>등록자</th>
                                        <th>읽음</th>
                                        <th>댓글</th>
                                        <th>첨부</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">
                                            <label class="label s_c01">고정</label>
                                        </td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="과목">일한번역연습</td>
                                        <td data-th="반">1</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">공지사항 제목입니다.<i class="xi-new icon" aria-hidden="true"></i><span class="sr-only">새글</span></a>
                                        </td>
                                        <td data-th="등록일">2025.10.20</td>
                                        <td data-th="등록자">운영자</td>
                                        <td data-th="읽음">45</td>
                                        <td data-th="댓글">5</td>
                                        <td data-th="첨부">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">
                                            <label class="label s_c02">중요</label>
                                        </td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="과목">일한번역연습</td>
                                        <td data-th="반">1</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">공지사항 제목입니다.</a>
                                        </td>
                                        <td data-th="등록일">2025.10.20</td>
                                        <td data-th="등록자">운영자</td>
                                        <td data-th="읽음">45</td>
                                        <td data-th="댓글">5</td>
                                        <td data-th="첨부">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">90</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="과목">일한번역연습</td>
                                        <td data-th="반">1</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title link">공지사항 제목입니다.</a>
                                        </td>
                                        <td data-th="등록일">2025.10.20</td>
                                        <td data-th="등록자">운영자</td>
                                        <td data-th="읽음">45</td>
                                        <td data-th="댓글">5</td>
                                        <td data-th="첨부">
                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                        </td>
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

