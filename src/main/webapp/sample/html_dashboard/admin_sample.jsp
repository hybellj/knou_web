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
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <!-- <select class="form-select" id="selectSearch1">
                                        <option value="발신자">발신자</option>
                                        <option value="발신자번호">발신자번호</option>
                                        <option value="제목">제목</option>
                                        <option value="내용">내용</option>
                                    </select> -->
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="과정(테넌시)ID / 과정(테넌시)명 / 담당자입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <!-- Tab btn -->
                        <!-- <div class="tabs_top">
                            <div class="tab_btn">
                                <a href="#" class="current">수신목록</a>
                                <a href="#">발신목록</a>
                            </div>
                            <div class="right-area">
                                <button type="button" class="btn basic icon" aria-label="새로고침"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                            </div>
                        </div>  -->

                        <div class="board_top">
                            <h3 class="board-title">과정(테넌시) 목록</h3>
                            <span class="total_num">총 <strong>6</strong>건</span>
                            <div class="right-area">
                                <button type="button" class="btn type2">등록</button>
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
                                    <col style="width:5%">
                                    <col style="width:12%">
                                    <col style="width:16%">
                                    <col style="width:14%">
                                    <col style="width:12%">
                                    <col style="width:8%">
                                    <col style="width:12%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>과정(테넌시) ID</th>
                                        <th>과정(테넌시) Full Name</th>
                                        <th>과정(테넌시) Short Name</th>
                                        <th>과정(테넌시) 유형</th>
                                        <th>담당자</th>
                                        <th>담당자 연락처</th>
                                        <th>담당자 이메일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="과정(테넌시) ID">KNOUTESTID001</td>
                                        <td data-th="과정(테넌시) Full Name">대학원</td>
                                        <td data-th="과정(테넌시) Short Name">대학원</td>
                                        <td data-th="과정(테넌시) 유형">대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-2589-6254</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="과정(테넌시) ID">KNOUTESTID002</td>
                                        <td data-th="과정(테넌시) Full Name">경영대학원</td>
                                        <td data-th="과정(테넌시) Short Name">경영대학원</td>
                                        <td data-th="과정(테넌시) 유형">경영대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-2589-6254</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">4</td>
                                        <td data-th="과정(테넌시) ID">KNOUTESTID003</td>
                                        <td data-th="과정(테넌시) Full Name">프라임칼리지 학위과정</td>
                                        <td data-th="과정(테넌시) Short Name">학위과정</td>
                                        <td data-th="과정(테넌시) 유형">학사학위과정</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-2589-6254</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">3</td>
                                        <td data-th="과정(테넌시) ID">KNOUTESTID004</td>
                                        <td data-th="과정(테넌시) Full Name">프라임칼리지 평생교육과정</td>
                                        <td data-th="과정(테넌시) Short Name">평생교육</td>
                                        <td data-th="과정(테넌시) 유형">평생교육과정</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-2589-6254</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">2</td>
                                        <td data-th="과정(테넌시) ID">KNOUTESTID005</td>
                                        <td data-th="과정(테넌시) Full Name">종합교육연수원</td>
                                        <td data-th="과정(테넌시) Short Name">연수원</td>
                                        <td data-th="과정(테넌시) 유형">종합교육연수원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-2589-6254</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">1</td>
                                        <td data-th="과정(테넌시) ID">KNOUTESTID006</td>
                                        <td data-th="과정(테넌시) Full Name">허브대학</td>
                                        <td data-th="과정(테넌시) Short Name">대학</td>
                                        <td data-th="과정(테넌시) 유형">허브대학</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-2589-6254</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type2-->

                        <div class="board_pager">
                            <span class="inner">
                                <a href="" class="page_first" title="첫페이지"><i class="xi-angle-left-min"></i><span class="sr_only">첫페이지</span></a>
                                <a href="" class="page_prev" title="이전페이지"><i class="xi-angle-left-min"></i><span class="sr_only">이전페이지</span></a>
                                <a href="" class="page_now" title="1페이지"><strong>1</strong></a>
                                <a href="" class="page_none" title="2페이지">2</a>
                                <a href="" class="page_none" title="3페이지">3</a>
                                <a href="" class="page_next" title="다음페이지"><i class="xi-angle-right-min"></i><span class="sr_only">다음페이지</span></a>
                                <a href="" class="page_last" title="마지막페이지"><i class="xi-angle-right-min"></i><span class="sr_only">마지막페이지</span></a>
                            </span>
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

