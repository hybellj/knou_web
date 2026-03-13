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
                            <h2 class="page-title">학사연동관리</h2>
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
                            <h3 class="board-title">기관목록</h3>
                            <div class="right-area">
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
                                    <col style="width:8%">
                                    <col style="width:12%">
                                    <col style="">
                                    <col style="width:12%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>기관 ID</th>
                                        <th>기관 Full Name</th>
                                        <th>기관 Short Name</th>
                                        <th>담당자</th>
                                        <th>담당자 연락처</th>
                                        <th>담당자 이메일</th>
                                        <th>학사연동관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관 ID">KNOUTESTID001</td>
                                        <td data-th="기관 Full Name">대학원</td>
                                        <td data-th="기관 Short Name">대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                        <td data-th="학사연동관리">
                                            <button class="btn basic small">학사연동관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="기관 ID">KNOUTESTID001</td>
                                        <td data-th="기관 Full Name">대학원</td>
                                        <td data-th="기관 Short Name">대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                        <td data-th="학사연동관리">
                                            <button class="btn basic small" disabled>학사연동관리</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

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
                        <!--//table-type-->

                    </div>
                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" data-modal-open="modal1">학사연동관리</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">학사연동관리</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    <div class="msg-box">
                        <p class="txt">LMS 옵션설정에서 학사연동 사용일 경우에 학사연동 관리합니다.</p>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="">
                                <col style="width:20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>항목</th>
                                    <th>학사연동</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="항목" class="t_left">
                                        <div class="haksa_option">
                                            <button class="btn basic small haksa_btn">
                                                학과/부서 정보
                                                <i class="icon-svg-yes" aria-hidden="true" aria-label="YES"></i>
                                            </button>
                                            <span>1. 학과/부서 정보를 연동 합니다.</span>
                                        </div>
                                    </td>
                                    <td data-th="학사연동">Y</td>
                                </tr>
                                <tr>
                                    <td data-th="항목" class="t_left">
                                        <div class="haksa_option">
                                            <button class="btn basic small haksa_btn">
                                                학기/주차 정보
                                                <i class="icon-svg-yes" aria-hidden="true" aria-label="YES"></i>
                                            </button>
                                            <span>2. 학기/주차(학습목차기간) 정보를 연동 합니다.</span>
                                        </div>
                                    </td>
                                    <td data-th="학사연동">Y</td>
                                </tr>
                                <tr>
                                    <td data-th="항목" class="t_left">
                                        <div class="haksa_option">
                                            <button class="btn basic small haksa_btn">
                                                강의계획서 정보
                                                <i class="icon-svg-no" aria-hidden="true" aria-label="NO"></i>
                                            </button>
                                            <span>3. 개설과목의 강의계획서 정보를 연동합니다.</span>
                                        </div>
                                    </td>
                                    <td data-th="학사연동"><span class="fcRed">N</span></td>
                                </tr>
                                <tr>
                                    <td data-th="항목" class="t_left">
                                        <div class="haksa_option">
                                            <button class="btn basic small haksa_btn">
                                                학습목차(저작도구)
                                                <i class="icon-svg-yes" aria-hidden="true" aria-label="YES"></i>
                                            </button>
                                            <span>4. 개설과목의 학습목차(저작도구)를 연동합니다.</span>
                                        </div>
                                    </td>
                                    <td data-th="학사연동">Y</td>
                                </tr>
                            </tbody>

                        </table>
                    </div>
                    <!--//table-type-->

                    <div class="modal_btns">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>


    </div>

</body>
</html>

