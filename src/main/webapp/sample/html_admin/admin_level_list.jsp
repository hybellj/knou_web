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
                            <h2 class="page-title">관리자 권한관리</h2>
                        </div>

                        <!-- search typeB -->
                        <div class="search-typeB">
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">관리자 구분</label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="selectDate1">
                                        <option value="전체">전체</option>
                                        <option value="전체 시스템관리자">전체 시스템관리자</option>
                                        <option value="기관 관리자">기관 관리자</option>
                                        <option value="기관 운영관리자">기관 운영관리자</option>
                                        <option value="기관 콘텐츠관리자">기관 콘텐츠관리자</option>
                                        <option value="과목 관리자">과목 관리자</option>
                                    </select>
                                </div>
                                <span class="item_tit"><label for="selectSearch">학과/부서</label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="selectDate2">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">과정(테넌시)</label></span>
                                <div class="itemList">
                                    <select class="form-select wide" id="selectDate3">
                                        <option value="전체">전체</option>
                                    </select>
                                </div>
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="이름/연락처 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">관리자 목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn type2">엑셀 다운로드</button>
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
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:12%">
                                    <col style="width:7%">
                                    <col style="width:7%">
                                    <col style="width:11%">
                                    <col style="">
                                    <col style="width:10%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>관리자 구분</th>
                                        <th>과정(테넌시)</th>
                                        <th>학과/부서</th>
                                        <th>사용자유형</th>
                                        <th>이름</th>
                                        <th>연락처</th>
                                        <th>이메일</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">9</td>
                                        <td data-th="관리자 구분">전체 시스템관리자</td>
                                        <td data-th="과정(테넌시)">대학원</td>
                                        <td data-th="학과/부서">교육정보화본부</td>
                                        <td data-th="사용자유형">직원</td>
                                        <td data-th="이름">홍길동</td>
                                        <td data-th="연락처">010-1234-5678</td>
                                        <td data-th="이메일">knou001@knou.ac.kr</td>
                                        <td data-th="관리">
                                            <button class="btn basic small">수정</button>
                                            <button class="btn basic small">삭제</button>
                                        </td>
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

