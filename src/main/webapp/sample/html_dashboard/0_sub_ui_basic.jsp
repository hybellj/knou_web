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
                            <h2 class="page-title"><span>공통</span>컴포넌트</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공통</li>
                                    <li><span class="current">현재페이지</span></li>
                                </ul>
                            </div>
                        </div>


                        <h4 class="sub-title">검색박스</h4>
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

                        <h4 class="sub-title">메시지 스타일 _ 기본(부가정보)</h4>
                        <div class="msg-box basic">
                            <ul class="list-asterisk">
                                <li>운영교수 : 해당학기 시험, 과제 등의 실제 수업을 담당하는 교수</li>
                                <li>개발교수 : 강의 콘텐츠(학습 동영상)를 제작하는 교수</li>
                            </ul>
                        </div>

                        <div class="msg-box basic">
                            <ul class="list-bullet">
                                <li>미디어 일시정지/재생 : Space Bar</li>
                                <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li>
                                <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li>
                                <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>
                                <li>전체 화면 : F</li>
                            </ul>
                        </div>

                        <div class="msg-box basic">
                            <ul class="list-dot">
                                <li>미디어 일시정지/재생 : Space Bar</li>
                                <li>재생 속도 : Z (1배속), X (느리게), C (빠르게)</li>
                                <li>볼륨 : 위쪽 방향키 (크게), 아래쪽 방향키 (작게)</li>
                                <li>이동 : 왼쪽 방향키 (10초 전), 오른쪽 방향키 (10초 후)</li>
                                <li>전체 화면 : F</li>
                            </ul>
                        </div>

                        <h4 class="sub-title">메시지 스타일 _ 안내</h4>
                        <div class="msg-box">
                            <p class="txt"><strong>안내 : </strong>메시지 안내 스타일입니다.</p>
                        </div>

                        <h4 class="sub-title">메시지 스타일 _ 정보</h4>
                        <div class="msg-box info">
                            <p class="txt"><strong>안내 : </strong>메시지 정보 스타일입니다.</p>
                        </div>

                        <h4 class="sub-title">메시지 스타일 _ 승인</h4>
                        <div class="msg-box success">
                            <p class="txt"><strong>성공 : </strong>메시지 내용입니다.</p>
                        </div>

                        <h4 class="sub-title">메시지 스타일 _ 경고</h4>
                        <div class="msg-box warning">
                            <p class="txt"><strong>오류 위치 : </strong>교수 > 대시보드 > 강의실 > 과제 등록</p>
                        </div>

                        <div class="msg-box">
                            <p class="txt"><i class="xi-error" aria-hidden="true"></i>예상 발신 비용 금액입니다. 참고하세요</p>
                        </div>
                        <div class="msg-box">
                            <p class="txt"><i class="icon-svg-warning" aria-hidden="true"></i>예상 발신 비용 금액입니다. 참고하세요</p>
                        </div>

                        <br><br><br>

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

                        <h4 class="sub-title">테이블 스타일 _ 정보성(1)</h4>
                        <!-- 정보성 테이블 -->
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="width:22%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>교수</th>
                                        <th>소속</th>
                                        <th>연락처</th>
                                        <th>이메일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="교수">운영교수 : 홍길동</td>
                                        <td data-th="소속">컴퓨터공학과</td>
                                        <td data-th="연락처">02-5214-9853</td>
                                        <td data-th="이메일">test@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="교수">공동교수 : 김교수</td>
                                        <td data-th="소속">컴퓨터공학과</td>
                                        <td data-th="연락처">02-5214-9853</td>
                                        <td data-th="이메일">test@naver.com</td>
                                    </tr>
                                    <tr>
                                        <td data-th="교수">개발교수 : 이교수</td>
                                        <td data-th="소속">컴퓨터공학과</td>
                                        <td data-th="연락처">02-5214-9853</td>
                                        <td data-th="이메일">test@naver.com</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <br><br><br>

                         <h4 class="sub-title">테이블 스타일 _ 정보성(2)</h4>
                        <!-- 정보성 테이블 -->
                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col style="width:10%">
                                    <col style="">
                                    <col style="width:15%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>주차</th>
                                        <th>강의 내용</th>
                                        <th>담당교수</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="주차">1</th>
                                        <td data-th="강의내용" class="t_left">일반화학 개요</td>
                                        <td data-th="담당교수">홍길동</td>
                                    </tr>
                                    <tr>
                                        <th data-th="주차">2</th>
                                        <td data-th="강의내용" class="t_left">원소, 원자 및 이온</td>
                                        <td data-th="담당교수">홍길동</td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>

                        <br><br><br>

                        <h4 class="sub-title">리스트 스타일 _ 테이블 버튼</h4>
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

                        <h4 class="sub-title">리스트 스타일 _ 링크</h4>
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

                        <br><br><br>

                        <h4 class="sub-title">탭메뉴 _ 관리자</h4>
                        <div class="listTab">
                            <ul>
                                <li><a href="#0">수신목록</a></li>
                                <li class="select"><a href="#0">발신목록</a></li>
                                <li><a href="#0">전체목록</a></li>
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

    </div>

</body>
</html>

