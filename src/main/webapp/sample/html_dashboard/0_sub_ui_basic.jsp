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

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>공통</span>요소</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공통</li>
                                    <li><span class="current">현재페이지</span></li>
                                </ul>
                            </div>
                        </div>


                        <h4 class="sub-title">상세페이지</h4>
                        <!-- 상세 -->
                        <div class="table_list">
                            <ul class="list">
                                <li class="head"><label>제목</label></li>
                                <li>쪽지를 확인해주세요.</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>보낸사람</label></li>
                                <li>관리자</li>
                                <li class="head"><label>보낸날짜</label></li>
                                <li>2025.10.28 10:00:00</li>
                            </ul>
                            <ul class="list">
                                <li class="head"><label>내용</label></li>
                                <li>데이터베이스의 이해와 활용 관련하여 안내 드립니다.<br>
                                    현재 강의 진행하고 있는 강의실 변경이 있습니다. <br>
                                    204호에서 201로 변경되오니 확인 후 참석해주세요.<br><br>
                                    변경날짜: 11월 4일(월) ~ 강의 종료까지 <br><br>
                                    감사합니다.
                                </li>
                            </ul>
                        </div>

                        <br><br><br>

                        <h4 class="sub-title ">등록, 상세 _ 하단 중앙 버튼</h4>
						<div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>

                        <br><br><br>

                        <h4 class="sub-title">검색박스</h4>
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
                                <span class="item_tit"><label for="selectDate">요청 일시</label></span>
                                <div class="itemList">
                                    <div class="date_area">
                                        <label class="datepicker">
                                            <input type="text" placeholder="시작일시" id="datetimepicker1">
                                        </label>
                                        <span class="txt-sort">~</span>
                                        <label class="datepicker">
                                            <input type="text" placeholder="종료일시" id="datetimepicker2">
                                        </label>
                                    </div>
                                    <script>
                                    $.datetimepicker.setLocale('ko');

                                    $('#datetimepicker1').datetimepicker({
                                        format: 'Y-m-d H:i',
                                        step: 10,              // 10분 단위 간격
                                        scrollMonth: false,
                                        scrollTime: true,
                                        scrollInput: false,
                                        theme: '',
                                        onShow: function(ct){
                                            this.setOptions({
                                                maxDate: $('#datetimepicker2').val() ? $('#datetimepicker2').val() : false
                                            });
                                        }
                                    });

                                    $('#datetimepicker2').datetimepicker({
                                        format: 'Y-m-d H:i',
                                        step: 10,
                                        scrollMonth: false,
                                        scrollTime: true,
                                        scrollInput: false,
                                        onShow: function(ct){
                                            this.setOptions({
                                                minDate: $('#datetimepicker1').val() ? $('#datetimepicker1').val() : false
                                            });
                                        }
                                    });

                                    $(document).on('click', '.xdsoft_month, .xdsoft_year', function(e) {
                                    e.stopPropagation();
                                    e.preventDefault();
                                    return false;
                                    });
                                    </script>

                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="발신자">발신자</option>
                                        <option value="발신자번호">발신자번호</option>
                                        <option value="제목">제목</option>
                                        <option value="내용">내용</option>
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어를 입력해주세요.">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>


                        <br><br><br>

                        <h4 class="sub-title">탭버튼 + 오른쪽 버튼</h4>
                        <!-- Tab btn -->
                        <div class="tabs_top">
                            <div class="tab_btn">
                                <a href="#tab01" class="current">수신목록</a>
                                <a href="#tab02">발신목록</a>
                            </div>
                            <div class="right-area">
                                <button type="button" class="btn basic icon"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                                <button type="button" class="btn type2">발신하기</button>
                            </div>
                        </div>
                        <div id="tab01" class="tab-content">탭1 내용</div>
                        <div id="tab02" class="tab-content" style="display:none;">탭2 내용</div>

                        <br><br><br>

                        <h4 class="sub-title">타이틀 + 조합</h4>
                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 내용</h3>
                        </div>

                        <br><br><br>

                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">발신하기</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <br><br><br>

                        <div class="board_top">
                            <h3 class="board-title">과정(테넌시) 목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">등록</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <br><br><br>

                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">강의목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">주차 접음</button>
                                <select class="form-select">
                                    <option value="전체 주차">전체 주차</option>
                                    <option value="1주차">1주차</option>
                                    <option value="2주차">2주차</option>
                                    <option value="3주차">3주차</option>
                                    <option value="4주차">4주차</option>
                                    <option value="5주차">5주차</option>
                                </select>
                                <a href="#0" class="btn_list_type on" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                            </div>
                        </div>


                        <br><br><br>

                        <h4 class="sub-title">테이블 스타일 _ 테이블 버튼</h4>
                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:10%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:11%">
                                    <col style="">
                                    <col style="width:11%">
                                    <col style="width:6%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>과정</th>
                                        <th>운영과목</th>
                                        <th>반</th>
                                        <th>발신자</th>
                                        <th>발신자번호</th>
                                        <th>제목</th>
                                        <th>발신일시</th>
                                        <th>읽음</th>
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
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음"><button class="btn basic small">상세</button></td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type-->

                        <br><br><br>

                        <h4 class="sub-title">테이블 스타일 _ 링크</h4>
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
                                        <td data-th="과정(테넌시) ID"><a href="#0" class="link">KNOUTESTID001</a></td>
                                        <td data-th="과정(테넌시) Full Name">대학원</td>
                                        <td data-th="과정(테넌시) Short Name">대학원</td>
                                        <td data-th="과정(테넌시) 유형">대학원</td>
                                        <td data-th="담당자">홍길동</td>
                                        <td data-th="담당자 연락처">010-1234-4567</td>
                                        <td data-th="담당자 이메일">test001@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="과정(테넌시) ID"><a href="#0" class="link">KNOUTESTID002</a></td>
                                        <td data-th="과정(테넌시) Full Name">경영대학원</td>
                                        <td data-th="과정(테넌시) Short Name">경영대학원</td>
                                        <td data-th="과정(테넌시) 유형">경영대학원</td>
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


                        <br><br><br>

                        <h4 class="sub-title">탭메뉴 _ 관리자</h4>
                        <div class="listTab">
                            <ul>
                                <li><a href="#0">수신목록</a></li>
                                <li class="select"><a href="#">발신목록</a></li>
                                <li><a href="#">전체목록</a></li>
                            </ul>
                        </div>

                        <br><br><br>

                        <h4 class="sub-title">검색 _ 관리자</h4>
                        <div class="board_top">
                            <select class="form-select" id="selectDate1">
                                <option value="2025년">2025년</option>
                                <option value="2024년">2024년</option>
                            </select>
                            <select class="form-select" id="selectDate2">
                                <option value="2학기">2학기</option>
                                <option value="1학기">1학기</option>
                            </select>
                            <select class="form-select" id="selectCourse">
                                <option value="과정(테넌시)">과정(테넌시)</option>
                                <option value="평생교육">평생교육</option>
                            </select>
                            <select class="form-select wide" id="selectSubject">
                                <option value="">학과</option>
                                <option value="운영과목1">국어국문학과</option>
                                <option value="운영과목2">회계트랙</option>
                            </select>
                            <select class="form-select wide" id="selectSubject">
                                <option value="">과목</option>
                                <option value="과목1">과목1</option>
                                <option value="과목2">과목2</option>
                            </select>
                            <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="이름/과목 입력">
                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>

                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
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



        <!-- modal popup 보여주기 버튼(개발시 삭제) -->
        <button type="button" class="btn modal__btn" data-modal-open="modal1">모달 1 샘플</button>
        <button type="button" class="btn modal__btn" data-modal-open="modal2">모달 2 샘플</button>

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">모달 1</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    모달 1 내용
                    <div class="modal_btns">
                        <button type="button" class="btn type1">수정</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal2Title" >
            <div class="modal-content" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal2Title">모달 2</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    <p>내용이 길어질 경우 자동으로 스크롤이 생깁니다.</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>
                    <p>스크롤 테스트용 텍스트</p>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">수정</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>

