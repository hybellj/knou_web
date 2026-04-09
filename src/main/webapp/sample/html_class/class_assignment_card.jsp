<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
	</jsp:include>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->

                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">과제</h2>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">목록</h3>
                            <div class="right-area">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="과제명 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" class="btn basic">성적반영비율조정</button>
                                <button type="button" class="btn type2">과제 등록</button>
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
                                                <label class="label s_work">과제</label>
                                            </p>
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                        </div>
                                        <div class="btn_right">
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="과제 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">과제평가</a></div>
                                                    <div class="item"><a href="#0">수정</a></div>
                                                    <div class="item"><a href="#0">삭제</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:20%;">10명</li>
                                            <li class="bar-grey" style="width:80%;">40명</li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">제출기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">연장제출마감</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">성적 반영비율 </label><strong>30%</strong></p>
                                            <p><label class="label-title">제출현황</label><strong>10/50</strong></p>
                                            <p><label class="label-title">평가현황</label><strong>8/50</strong></p>
                                            <p><label class="label-title">성적공개</label>
                                                <input type="checkbox" value="Y" class="switch small" checked="checked">
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_work">과제</label>
                                                <label class="label s_work">팀</label>
                                            </p>
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                        </div>
                                        <div class="btn_right">
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="과제 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">과제평가</a></div>
                                                    <div class="item"><a href="#0">수정</a></div>
                                                    <div class="item"><a href="#0">삭제</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:80%;">38명</li>
                                            <li class="bar-grey" style="width:20%;">12명</li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">제출기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">연장제출마감</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">성적 반영비율 </label>
                                                <span class="input_btn">
                                                    <input class="form-control sm" id="percentInput" type="text" maxlength="2" autocomplete="off" value="30"><label>%</label>
                                                </span>
                                            </p>
                                            <p><label class="label-title">제출현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">평가현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">성적공개</label>
                                                <input type="checkbox" value="N" class="switch small">
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_work">실기과제</label>
                                                <label class="label s_work">팀</label>
                                            </p>
                                            <a href="#0" class="link">게시판 제목입니다.</a>
                                        </div>
                                        <div class="btn_right">
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="과제 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">과제평가</a></div>
                                                    <div class="item"><a href="#0">수정</a></div>
                                                    <div class="item"><a href="#0">삭제</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:80%;">38명</li>
                                            <li class="bar-grey" style="width:20%;">12명</li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">제출기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">연장제출마감</label><strong>2026.06.22 22:00</strong></p>
                                            <p><label class="label-title">성적 반영비율 </label>
                                                <span class="input_btn">
                                                    <input class="form-control sm" id="percentInput" type="text" maxlength="2" autocomplete="off" value="20"><label>%</label>
                                                </span>
                                            </p>
                                            <p><label class="label-title">제출현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">평가현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">성적공개</label>
                                                <input type="checkbox" value="N" class="switch small">
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_work">중간고사 대체</label>
                                            </p>
                                            <a href="#0" class="link">중간고사 대체 과제 제목입니다.</a>
                                        </div>
                                        <div class="btn_right">
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="과제 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">과제평가</a></div>
                                                    <div class="item"><a href="#0">수정</a></div>
                                                    <div class="item"><a href="#0">삭제</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:80%;">38명</li>
                                            <li class="bar-grey" style="width:20%;">12명</li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">제출기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">연장제출마감</label><strong>-</strong></p>
                                            <p><label class="label-title">성적 반영비율 </label><strong class="fcRed">35%</strong></p>
                                            <p><label class="label-title">제출현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">평가현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">성적공개</label>
                                                <strong>-</strong>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="card_item">
                                    <div class="card_header">
                                        <div class="board_tit">
                                            <p class="labels">
                                                <label class="label s_work">기말고사 대체</label>
                                            </p>
                                            <a href="#0" class="link">기말고사 대체 과제 제목입니다.</a>
                                        </div>
                                        <div class="btn_right">
                                            <div class="dropdown">
                                                <button type="button" class="btn basic icon set settingBtn" aria-label="과제 관리">
                                                    <i class="xi-ellipsis-v"></i>
                                                </button>
                                                <div class="optionWrap option-wrap">
                                                    <div class="item"><a href="#0">과제평가</a></div>
                                                    <div class="item"><a href="#0">수정</a></div>
                                                    <div class="item"><a href="#0">삭제</a></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="extra">
                                        <ul class="process-bar">
                                            <li class="bar-blue" style="width:80%;">38명</li>
                                            <li class="bar-grey" style="width:20%;">12명</li>
                                        </ul>
                                        <div class="desc">
                                            <p><label class="label-title">제출기간</label><strong>2026.06.13 18:00 ~ 2026.06.17 22:00</strong></p>
                                            <p><label class="label-title">연장제출마감</label><strong>-</strong></p>
                                            <p><label class="label-title">성적 반영비율 </label><strong class="fcRed">35%</strong></p>
                                            <p><label class="label-title">제출현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">평가현황</label><strong>38/50</strong></p>
                                            <p><label class="label-title">성적공개</label>
                                                <strong>-</strong>
                                            </p>
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


        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

