<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="chart"/>
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
                            <h2 class="page-title">전체수업현황1</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current">전체수업현황</span></li>
                                </ul>
                            </div>
                        </div>


                        <div class="board_top class">
                            <h3 class="board-title">데이터베이스의 이해 활용 1반 </h3>
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab01" class="current">주차별 학습현황</a>
                                    <a href="#tab02">학습요소 참여현황</a>
                                </div>
                                <button type="button" class="btn type2">목록</button>
                            </div>
                        </div>

                        <h4 class="sub-title">주차별 미학습자 비율</h4>
                        <!-- 정보성 테이블 -->
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:7%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="width:5.5%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>1</th>
                                        <th>2</th>
                                        <th>3</th>
                                        <th>4</th>
                                        <th>5</th>
                                        <th>6</th>
                                        <th>7</th>
                                        <th>8</th>
                                        <th>9</th>
                                        <th>10</th>
                                        <th>11</th>
                                        <th>12</th>
                                        <th>13</th>
                                        <th>14</th>
                                        <th>15</th>
                                        <th>평균</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="구분">비율</td>
                                        <td data-th="1주차"><a href="#0" class="link">13.02</a></td>
                                        <td data-th="2주차"><a href="#0" class="link">9.00</a></td>
                                        <td data-th="3주차"><a href="#0" class="link">14.12</a></td>
                                        <td data-th="4주차"><a href="#0" class="link">8.06</a></td>
                                        <td data-th="5주차"><a href="#0" class="link">5.10</a></td>
                                        <td data-th="6주차">-</td>
                                        <td data-th="7주차">-</td>
                                        <td data-th="8주차">-</td>
                                        <td data-th="9주차">-</td>
                                        <td data-th="10주차">-</td>
                                        <td data-th="11주차">-</td>
                                        <td data-th="12주차">-</td>
                                        <td data-th="13주차">-</td>
                                        <td data-th="14주차">-</td>
                                        <td data-th="15주차">-</td>
                                        <td data-th="평균"><a href="#0" class="link">11.21</a></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>


                        <div class="board_top">
                            <h4 class="sub-title">학습자 학습현황</h4>
                            <span class="total_num">총 <strong>50</strong>명</span>
                            <div class="state-txt-label">
                                <p><span class="state_ok" aria-label="출석">○</span> 출석</p>
                                <p><span class="state_late" aria-label="지각">△</span> 지각</p>
                                <p><span class="state_no" aria-label="결석">X</span> 결석</p>
                            </div>

                            <div class="right-area">
                                <select class="form-select" id="selectDate1">
                                    <option value="결석주차">결석주차</option>
                                </select>
                                <span class="txt-sort">~</span>
                                <select class="form-select" id="selectDate2">
                                    <option value="결석주차">결석주차</option>
                                </select>
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름/학번/학과 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn type2">엑셀 다운로드</button>

                            </div>
                        </div>


                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:4%">
                                    <col style="">
                                    <col style="width:8%">
                                    <col style="width:8%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="width:10%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>학과</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>입학년도</th>
                                        <th>학년</th>
                                        <th>1</th>
                                        <th>2</th>
                                        <th>3</th>
                                        <th>4</th>
                                        <th>5</th>
                                        <th>6</th>
                                        <th>7</th>
                                        <th><span class="fcRed">8</span></th>
                                        <th>9</th>
                                        <th>10</th>
                                        <th>11</th>
                                        <th>12</th>
                                        <th>13</th>
                                        <th>14</th>
                                        <th><span class="fcRed">15</span></th>
                                        <th>출석/지각/결석</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">
                                            <a href="#0" class="link">학습자</a>
                                        </td>
                                        <td data-th="입학년도">2025</td>
                                        <td data-th="학년">2</td>
                                        <td data-th="1주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="2주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="3주차">
                                            <span class="state_no" aria-label="결석">X</span>
                                        </td>
                                        <td data-th="4주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="5주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="6주차">
                                            <span class="state_late" aria-label="지각">△</span>
                                        </td>
                                        <td data-th="7주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="8주차">
                                            -
                                        </td>
                                        <td data-th="9주차">
                                            -
                                        </td>
                                        <td data-th="10주차">
                                            -
                                        </td>
                                        <td data-th="11주차">
                                            -
                                        </td>
                                        <td data-th="12주차">
                                            -
                                        </td>
                                        <td data-th="13주차">
                                            -
                                        </td>
                                        <td data-th="14주차">
                                            -
                                        </td>
                                        <td data-th="15주차">
                                            -
                                        </td>
                                        <td data-th="출석/지각/결석">
                                            <span class="state_ok total_label" aria-label="출석">5</span>
                                            <span class="state_late total_label" aria-label="지각">1</span>
                                            <span class="state_no total_label" aria-label="결석">1</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">
                                            <a href="#0" class="link">학습자</a>
                                        </td>
                                        <td data-th="입학년도">2025</td>
                                        <td data-th="학년">2</td>
                                        <td data-th="1주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="2주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="3주차">
                                            <span class="state_no" aria-label="결석">X</span>
                                        </td>
                                        <td data-th="4주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="5주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="6주차">
                                            <span class="state_late" aria-label="지각">△</span>
                                        </td>
                                        <td data-th="7주차">
                                            <span class="state_ok" aria-label="출석">○</span>
                                        </td>
                                        <td data-th="8주차">
                                            -
                                        </td>
                                        <td data-th="9주차">
                                            -
                                        </td>
                                        <td data-th="10주차">
                                            -
                                        </td>
                                        <td data-th="11주차">
                                            -
                                        </td>
                                        <td data-th="12주차">
                                            -
                                        </td>
                                        <td data-th="13주차">
                                            -
                                        </td>
                                        <td data-th="14주차">
                                            -
                                        </td>
                                        <td data-th="15주차">
                                            -
                                        </td>
                                        <td data-th="출석/지각/결석">
                                            <span class="state_ok total_label" aria-label="출석">13</span>
                                            <span class="state_late total_label" aria-label="지각">1</span>
                                            <span class="state_no total_label" aria-label="결석">1</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type-->


                    </div>

                </div>


                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" data-modal-open="modal1">학습자 학습현황</button>
                    <!-- <button type="button" class="btn modal__btn" data-modal-open="modal2">메시지 불러오기</button>
                    <button type="button" class="btn modal__btn" data-modal-open="modal3">발신 예약 취소</button>
                    <button type="button" class="btn modal__btn" data-modal-open="modal4">받는 사람 추가</button> -->
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">학습자 학습현황</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">

                    <div class="board_top class">
                        <h3 class="board-title">데이터베이스의 이해 활용 1반 </h3>
                        <div class="right-area">
                            <button type="button" class="btn type2"><i class="xi-angle-left-min"></i>이전</button>
                            <button type="button" class="btn type2">다음<i class="xi-angle-right-min"></i></button>
                        </div>
                    </div>

                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">수강생 정보</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                            </div>
                        </div>
                        <div class="user-wrap mb30">
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
                    </div>

                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">학습 현황</h3>
                            <div class="right-area">
                                <div class="state-txt-label">
                                    <p><span class="state_ok" aria-label="출석">○</span> 출석</p>
                                    <p><span class="state_late" aria-label="지각">△</span> 지각</p>
                                    <p><span class="state_no" aria-label="결석">X</span> 결석</p>
                                </div>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:8%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="width:5.2%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>1</th>
                                        <th>2</th>
                                        <th>3</th>
                                        <th>4</th>
                                        <th>5</th>
                                        <th>6</th>
                                        <th>7</th>
                                        <th>8</th>
                                        <th>9</th>
                                        <th>10</th>
                                        <th>11</th>
                                        <th>12</th>
                                        <th>13</th>
                                        <th>14</th>
                                        <th>15</th>
                                        <th>출석/지각/결석</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="구분">주차</th>
                                        <td data-th="1주차"><span class="state_ok" aria-label="출석">○</span></td>
                                        <td data-th="2주차"><span class="state_ok" aria-label="출석">○</span></td>
                                        <td data-th="3주차"><span class="state_no" aria-label="결석">X</span></td>
                                        <td data-th="4주차"><span class="state_ok" aria-label="출석">○</span></td>
                                        <td data-th="5주차"><span class="state_ok" aria-label="출석">○</span></td>
                                        <td data-th="6주차"><span class="state_late" aria-label="지각">△</span></td>
                                        <td data-th="7주차">-</td>
                                        <td data-th="8주차">-</td>
                                        <td data-th="9주차">-</td>
                                        <td data-th="10주차">-</td>
                                        <td data-th="11주차">-</td>
                                        <td data-th="12주차">-</td>
                                        <td data-th="13주차">-</td>
                                        <td data-th="14주차">-</td>
                                        <td data-th="15주차">-</td>
                                        <td data-th="출석/지각/결석">
                                            <span class="state_ok total_label" aria-label="출석">13</span>
                                            <span class="state_late total_label" aria-label="지각">1</span>
                                            <span class="state_no total_label" aria-label="결석">1</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>Q&A
                                            <span class="fs-sm">(답변/등록)</span>
                                        </th>
                                        <th>토론방
                                            <span class="fs-sm">(댓글수)</span>
                                        </th>
                                        <th>과제
                                            <span class="fs-sm">(제출/전체)</span>
                                        </th>
                                        <th>퀴즈
                                            <span class="fs-sm">(제출/전체)</span>
                                        </th>
                                        <th>설문
                                            <span class="fs-sm">(제출/전체)</span>
                                        </th>
                                        <th>토론
                                            <span class="fs-sm">(제출/전체)</span>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="구분">학습요소</th>
                                        <td data-th="Q&A(답변/등록)">2/2</td>
                                        <td data-th="토론방(댓글수)">15</td>
                                        <td data-th="과제(제출/전체)">2/2</td>
                                        <td data-th="퀴즈(제출/전체)">2/2</td>
                                        <td data-th="설문(제출/전체)">2/2</td>
                                        <td data-th="토론(제출/전체)">2/2</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                    <col style="width:15%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>구분</th>
                                        <th>중간고사
                                            <span class="fs-sm">(실시간)</span>
                                        </th>
                                        <th>중간고사
                                            <span class="fs-sm">(대체)</span>
                                        </th>
                                        <th>중간고사
                                            <span class="fs-sm">(기타)</span>
                                        </th>
                                        <th>기말고사
                                            <span class="fs-sm">(실시간)</span>
                                        </th>
                                        <th>기말고사
                                            <span class="fs-sm">(대체)</span>
                                        </th>
                                        <th>기말고사
                                            <span class="fs-sm">(기타)</span>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="구분">중간/기말</th>
                                        <td data-th="중간고사(대체)">42</td>
                                        <td data-th="중간고사(댓글수)">-</td>
                                        <td data-th="중간고사(기타)">-</td>
                                        <td data-th="기말고사(실시간)">-</td>
                                        <td data-th="기말고사(대체)">-</td>
                                        <td data-th="기말고사(기타)">-</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">강의실 접속 현황</h3>
                            <span class="total_num">2026.06.01 ~ 2026.06.22</span>
                        </div>

                        <!-- 차트 -->
                        <div class="chart-container" style=" height: 300px;">
                            <canvas id="lineChartUser"></canvas>
                        </div>
                        <!-- chartjs -->
                        <script src="<%=request.getContextPath()%>/webdoc/assets/js/chart4.min.js"></script>
                        <script src="<%=request.getContextPath()%>/webdoc/assets/js/chart-utils.min.js"></script>

                        <script>
                            const Utils = ChartUtils.init();
                            const DATA_COUNT = 12;
                            const NUMBER_CFG = {
                                count: DATA_COUNT,
                                min: 0,
                                max: 100
                            };
                            const lineLabels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31' ];
                            const lineData = {
                                labels: lineLabels,
                                datasets: [{
                                        label: "지난달",
                                        fill: false,
                                        lineTension: 0,
                                        backgroundColor: "rgba(172, 172, 172,0.4)",
                                        borderColor: "rgba(172, 172, 172,1)",
                                        borderCapStyle: 'butt',
                                        borderDash: [],
                                        borderDashOffset: 0.0,
                                        borderJoinStyle: 'miter',
                                        pointBorderColor: "rgba(172, 172, 172,1)",
                                        pointBackgroundColor: "#fff",
                                        pointBorderWidth: 1,
                                        pointHoverRadius: 5,
                                        pointHoverBackgroundColor: "rgba(172, 172, 172,1)",
                                        pointHoverBorderColor: "rgba(0,0,0,0.4)",
                                        pointHoverBorderWidth: 2,
                                        pointRadius: 2,
                                        pointHitRadius: 10,
                                        data: [15, 19, 17, 21, 26, 49, 57, 41, 36, 39, 37, 31, 26, 29, 37, 31, 46, 59, 57, 61, 56, 59, 57, 41, 46, 59, 57, 61, 66, 49, 37],
                                        spanGaps: false,
                                        borderWidth: 1
                                    },
                                    {
                                        label: '학습자',
                                        fill: false,
                                        lineTension: 0,
                                        backgroundColor: 'rgba(246,92,158,0.4)',
                                        borderColor: 'rgba(246,92,158,1)',
                                        borderCapStyle: 'butt',
                                        borderDash: [],
                                        borderDashOffset: 0.0,
                                        borderJoinStyle: 'miter',
                                        pointBorderColor: 'rgba(246,92,158,1)',
                                        pointBackgroundColor: '#fff',
                                        pointBorderWidth: 1,
                                        pointHoverRadius: 5,
                                        pointHoverBackgroundColor: 'rgba(246,92,158,1)',
                                        pointHoverBorderColor: 'rgba(0,0,0,0.4)',
                                        pointHoverBorderWidth: 2,
                                        pointRadius: 2,
                                        pointHitRadius: 10,
                                        data: [45, 49, 57, 61, 66, 59, 57, 61, 66, 49, 57, 51, 76, 79, 87, 81, 86, 79, 77, 61, 66, 59, 57, 61, 76, 79, 87, 81, 76, 69, 57],
                                        spanGaps: false,
                                        borderWidth: 1
                                    },
                                    {
                                        label: '평균',
                                        fill: false,
                                        lineTension: 0,
                                        backgroundColor: 'rgba(85, 154, 226, .6)',
                                        borderColor: 'rgba(54, 162, 235,1)',
                                        borderCapStyle: 'butt',
                                        borderDash: [],
                                        borderDashOffset: 0.0,
                                        borderJoinStyle: 'miter',
                                        pointBorderColor: 'rgba(54, 162, 235,1)',
                                        pointBackgroundColor: '#fff',
                                        pointBorderWidth: 1,
                                        pointHoverRadius: 5,
                                        pointHoverBackgroundColor: 'rgba(54, 162, 235,1)',
                                        pointHoverBorderColor: 'rgba(0,0,0,0.4)',
                                        pointHoverBorderWidth: 2,
                                        pointRadius: 2,
                                        pointHitRadius: 10,
                                        data: [49, 42, 47, 53, 69, 69, 48, 69, 76, 79, 57, 57, 52, 70, 80, 58, 59, 62, 67, 67, 82, 80, 77, 71, 78, 85, 67, 81, 66, 59, 47],
                                        spanGaps: false,
                                        borderWidth: 1
                                    }
                                ]
                            };
                            const lineConfig = {
                                type: 'line',
                                data: lineData,
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: {
                                                boxWidth: 15
                                            }
                                        }
                                    },
                                    scales: {
                                        y: {
                                            fontColor: '#333',
                                            fontSize: 12,
                                            display: true,
                                            ticks: {
                                                callback: function(value) {
                                                    return value + "%"
                                                }
                                            },
                                        },
                                    }
                                },
                            };
                            new Chart(document.getElementById('lineChartUser'), lineConfig);
                        </script>
                    </div>


                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">강의실 활동기록</h3>
                            <div class="right-area">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름/학번/학과 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
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
                                    <col style="width:10%">
                                    <col style="width:22%">
                                    <col style="width:16%">
                                    <col style="width:20%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>일시</th>
                                        <th>활동 내용</th>
                                        <th>접근 장비</th>
                                        <th>IP</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="일시">2026.02.18 15:23</td>
                                        <td data-th="활동 내용">강의실 입장</td>
                                        <td data-th="접근 장비">PC </td>
                                        <td data-th="IP">210.122.125.254</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="일시">2026.02.18 15:23</td>
                                        <td data-th="활동 내용">과제 제출</td>
                                        <td data-th="접근 장비">PC </td>
                                        <td data-th="IP">210.122.125.254</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="일시">2026.02.18 15:23</td>
                                        <td data-th="활동 내용">토론 참여</td>
                                        <td data-th="접근 장비">PC </td>
                                        <td data-th="IP">210.122.125.254</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="일시">2026.02.18 15:23</td>
                                        <td data-th="활동 내용">강의실 입장</td>
                                        <td data-th="접근 장비">PC </td>
                                        <td data-th="IP">210.122.125.254</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type2-->

                        <!-- board foot -->
                        <%-- 테이블의 페이징 정보 생성할때 아래 내용 참조하여 작업하고 아래와 같은 HTML 코드를 직접 만들지 않는다.
                        	1) UiTable() 함수를 사용하여 테이블 생성할경우는 해당 프로그램에서 페이지 정보 생성하도록 한다.
                        	2) Controller에서 페이지정보(PageInfo) 객체를 받아을 경우 <uiex:paging> 태그를 사용하여 생성한다.
                        	   <uiex:paging pageInfo="${pageInfo}" pageFunc="listPaging"/>
                        --%>
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

