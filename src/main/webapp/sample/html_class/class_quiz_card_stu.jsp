<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
	</jsp:include>
</head>

<body class="class"><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/class_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/class_gnb_prof.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <!-- class_sub_top -->
				<jsp:include page="../common/class_sub_top.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="../common/class_info.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
                    <!-- //class_info -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">퀴즈</h2>
                        </div>

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


                        <div class="board_top">
                            <h3 class="board-title">목록
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>6</b>건 ]</span>
                            </h3>
                            <div class="right-area">
                                <a href="#0" class="btn_list_type on" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <!-- board-type-card -->
                        <div class="table-wrap card">

                            <div class="board_card_list class">
                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_debate">퀴즈</label>
                                            </p>
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:100%;">진행중 / <span>응시</span></li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">응시기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">재응시기간</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">퀴즈시간</label><strong>10분</strong></p>
                                            <p><label class="label-title">성적반영</label><strong>Y</strong></p>
                                            <p><label class="label-title">평가점수</label><strong>-점</strong></p>
                                        </div>
                                        <button type="button" class="btn basic small" disabled>응시완료</button>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_debate">퀴즈</label>
                                                <label class="label s_debate">팀</label>
                                            </p>
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:100%;">진행중 / <span class="fcRed">미응시</span></li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">응시기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">재응시기간</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">퀴즈시간</label><strong>10분</strong></p>
                                            <p><label class="label-title">성적반영</label><strong>Y</strong></p>
                                            <p><label class="label-title">평가점수</label><strong>-점</strong></p>
                                        </div>
                                        <button type="button" class="btn type2 small">퀴즈응시</button>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_debate">중간고사퀴즈</label>
                                            </p>
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:100%;">진행 중 / <span class="fcRed">재미응시</span></li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">응시기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">재응시기간</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">퀴즈시간</label><strong>10분</strong></p>
                                            <p><label class="label-title">성적반영</label><strong>Y</strong></p>
                                            <p><label class="label-title">평가점수</label><strong>-점</strong></p>
                                        </div>
                                        <button type="button" class="btn basic small" disabled>응시완료</button>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_debate">중간고사 대체</label>
                                            </p>
                                            <a href="#0" class="link">중간고사 대체 과제 제목입니다.</a>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-grey" style="width:100%;">마감 / <span>응시</span></li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">응시기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">재응시기간</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">퀴즈시간</label><strong>10분</strong></p>
                                            <p><label class="label-title">성적반영</label><strong>Y</strong></p>
                                            <p><label class="label-title">평가점수</label><strong>0점</strong></p>
                                        </div>
                                        <button type="button" class="btn type2 small">평가시험지</button>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_debate">기말고사 대체</label>
                                            </p>
                                            <a href="#0" class="link">기말고사 대체 과제 제목입니다.</a>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-grey" style="width:100%;">마감 / <span class="fcRed">미응시</span></li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">응시기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">재응시기간</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">퀴즈시간</label><strong>10분</strong></p>
                                            <p><label class="label-title">성적반영</label><strong>Y</strong></p>
                                            <p><label class="label-title">평가점수</label><strong>0점</strong></p>
                                        </div>
                                        <button type="button" class="btn type2 small">평가시험지</button>
                                    </div>
                                </div>


                            </div>

                        </div>
                        <!--// board-type-card -->




                    </div>
                </div>


            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

