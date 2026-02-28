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
                        <div class="page-info">
                            <h2 class="page-title">기본 정보 관리</h2>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="기관ID / 기관명 / 담당자입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <h3 class="board-title">목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">등록</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="width:12%">
                                    <col style="width:20%">
                                    <col style="width:14%">
                                    <col style="width:13%">
                                    <col style="width:8%">
                                    <col style="width:12%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>기관 ID</th>
                                        <th>기관 Full Name</th>
                                        <th>기관 Short Name</th>
                                        <th>기관 유형</th>
                                        <th>담당자</th>
                                        <th>담당자 연락처</th>
                                        <th>담당자 이메일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관 ID"><a href="#0" class="link">KNOUTESTID001</a></td>
                                        <td data-th="기관 Full Name">대학원</td>
                                        <td data-th="기관 Short Name">대학원</td>
                                        <td data-th="기관 유형">대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관 ID"><a href="#0" class="link">KNOUTESTID002</a></td>
                                        <td data-th="기관 Full Name">경영대학원</td>
                                        <td data-th="기관 Short Name">경영대학원</td>
                                        <td data-th="기관 유형">경영대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관 ID"><a href="#0" class="link">KNOUTESTID003</a></td>
                                        <td data-th="기관 Full Name">프라임칼리지 학위과정</td>
                                        <td data-th="기관 Short Name">학위과정</td>
                                        <td data-th="기관 유형">학사학위과정</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관 ID"><a href="#0" class="link">KNOUTESTID004</a></td>
                                        <td data-th="기관 Full Name">프라임칼리지 평생교육과정</td>
                                        <td data-th="기관 Short Name">평생교육</td>
                                        <td data-th="기관 유형">평생교육과정</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type-->

                        <!-- board foot -->
                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b>12</b>건</span>
                                <span class="current_page">현재 페이지 <strong>1</strong>/10</span>
                            </div>

                            <div class="board_pager">
                                <span class="inner">
                                    <a href="" class="page_first" title="첫페이지"><i class="xi-angle-left-min"></i><span class="sr_only">첫페이지</span></a>
                                    <a href="" class="page_prev" title="이전페이지"><i class="xi-angle-left-min"></i><span class="sr_only">이전페이지</span></a>
                                    <a href="" class="page_now" title="1페이지"><strong>1</strong></a>
                                    <a href="" class="page_none" title="2페이지">2</a>
                                    <a href="" class="page_none" title="3페이지">3</a>
                                    <a href="" class="page_none" title="4페이지">4</a>
                                    <a href="" class="page_none" title="5페이지">5</a>
                                    <a href="" class="page_next" title="다음페이지"><i class="xi-angle-right-min"></i><span class="sr_only">다음페이지</span></a>
                                    <a href="" class="page_last" title="마지막페이지"><i class="xi-angle-right-min"></i><span class="sr_only">마지막페이지</span></a>
                                </span>
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

