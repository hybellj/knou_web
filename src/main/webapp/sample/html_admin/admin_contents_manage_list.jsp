<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>
    <link rel="stylesheet" href="/webdoc/assets/css/classroom.css">

</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/admin_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/admin_aside.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
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
                            <h2 class="page-title">사용자 관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과정관리</li>
                                    <li><span class="current">사용자 관리</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDate1" disabled>
                                        <option value="대학원">대학원</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="부서/학과">부서/학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">년도/학기(기수)</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectCourse">
                                        <option value="2026년">2026년</option>
                                    </select>
                                    <select class="form-select" id="selectCourse">
                                        <option value="1학기">1학기</option>
                                    </select>                                    
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">학과</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="전체">학과</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="과목/과목코드 검색">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>                        


                        <div class="board_top"> 
                            <h3 class="board-title">목록<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>90</b>건 ]</span></h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">엑셀로 다운로드</button>
                            </div>
                        </div>

                        <div class="table-wrap overflow-y mb40">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width: 3%;">
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col" class="cursor-pointer">기관<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col" class="cursor-pointer">학사년도<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col">학기</th>
                                        <th scope="col" class="cursor-pointer">학과<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col">과목코드</th>
                                        <th scope="col" class="cursor-pointer">과목<i class="xi-arrows-v icon"></i></th>
                                        <th scope="col">분반</th>
                                        <th scope="col">콘텐츠 등록상태</th>
                                        <th scope="col">관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">영어번역</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태" class="fcRed">임시저장</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">49</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">wjdqhrhkgkrrhk</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">데이터베이스특론</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태" class="fcRed">임시저장</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">48</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">실용중국어학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">중국어코퍼스언어학</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">47</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">실용중국어학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">중한통번역연습</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">46</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">행정학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">정책과정론</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">45</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">행정학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">인사해정세미나</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">44</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">평생교육학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">교수설계특론</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">43</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">평생교육학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">직업진로설계세미나</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">42</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">간호학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">간호이론총론</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">41</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학사년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">간호학과</td>
                                        <td data-th="과목코드">GRAD0638010</td>
                                        <td data-th="과목">상급건강사정</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="콘텐츠 등록상태">등록완료</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic small">콘텐츠 관리</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 강의 목록 -->
                        <div class="class_sub">

                            <div class="segment pd0">
                                <div class="board_top">
                                    <i class="icon-svg-openbook"></i>
                                    <h3>강의목록</h3>
                                </div>

                                <div class="board_top course">
                                    <button type="button" class="btn basic">주차 접음</button>
                                    <select class="form-select">
                                        <option value="전체 주차">전체 주차</option>
                                        <option value="1주차">1주차</option>
                                        <option value="2주차">2주차</option>
                                        <option value="3주차">3주차</option>
                                        <option value="4주차">4주차</option>
                                        <option value="5주차">5주차</option>
                                    </select>
                                    <div class="right-area">
                                        <button type="button" class="btn type2">임시저장</button>
                                        <button type="button" class="btn type2">등록완료</button>
                                        <button type="button" class="btn type2">콘텐츠 연동 가져오기</button>
                                        <button type="button" class="btn type2">전체 이관하기</button>
                                        <button type="button" class="btn basic icon" aria-label="주차 오름차순"><i class="xi-sort-asc"></i></button>
                                        <button type="button" class="btn basic icon" aria-label="주차 내림차순"><i class="xi-sort-desc"></i></button>
                                    </div>
                                </div>

                                <div class="course_list">
                                    <ul class="accordion course_week">
                                        <li class="padding-4 text-center">과목의 콘텐츠 관리 클릭 후 이용 가능합니다.</li>
                                        <li class="active"><!-- 클릭시 active 추가 -->
                                            <div class="title-wrap">
                                                <a class="title" href="#">
                                                    <i class="arrow xi-angle-down"></i>
                                                    <div>
                                                        <strong>[1주차]</strong> 무생물주어의 처리

                                                    </div>
                                                </a>
                                                <div class="meta-action-bar">
                                                    <p class="desc">
                                                        <input type="checkbox" value="Y" class="switch yesno" checked="checked">
                                                        <span>진도 영상<strong>3</strong></span>
                                                        <span>학습시간<strong>01:25:42</strong></span>
                                                        <span>연습문제<strong>10</strong></span>
                                                    </p>
                                                    <div class="btn_right">
                                                        <button class="btn s_type1">미리보기</button>
                                                        <button class="btn s_basic set">주차관리</button>
                                                        <button class="btn type2 small">1주차 전체 이관하기</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="cont">
                                                <div class="lecture_box">
                                                    <div class="lecture_tit">
                                                        <p class="labels">
                                                            <label class="label s_basic">텍스트</label>
                                                        </p>
                                                        <strong>학습개요</strong>
                                                    </div>
                                                    <div class="btn_right mr">
                                                        <button class="btn s_basic set">관리</button>
                                                    </div>
                                                </div>
                                                <div class="lecture_box">
                                                    <div class="lecture_tit">
                                                        <p class="labels">
                                                            <label class="label s_basic">동영상</label>
                                                        </p>
                                                        <strong>오늘의 학습</strong>
                                                    </div>
                                                    <div class="btn_right mr">
                                                        <button class="btn s_basic set">관리</button>
                                                    </div>
                                                </div>
                                                <div class="lecture_box">
                                                    <div class="lecture_tit">
                                                        <p class="labels">
                                                            <label class="label s_basic">동영상</label>
                                                        </p>
                                                        <strong>오늘의 학습</strong>
                                                    </div>
                                                    <div class="btn_right mr">
                                                        <button class="btn s_basic">이관하기 <i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i></button>
                                                    </div>
                                                </div>

                                                <!-- 학습자료 추가 -->
                                                <div class="lecture_add_box flex">
                                                    <div class="box_item">
                                                        <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
                                                        <div class="item_btns">
                                                            <a href="#0">
                                                                <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                                <span>동영상</span>
                                                            </a>
                                                            <a href="#0">
                                                                <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                                <span>PDF</span>
                                                            </a>
                                                            <a href="#0">
                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                <span>파일</span>
                                                            </a>
                                                            <a href="#0">
                                                                <i class="icon-svg-share" aria-hidden="true"></i>
                                                                <span>소셜</span>
                                                            </a>
                                                            <a href="#0">
                                                                <i class="icon-svg-link" aria-hidden="true"></i>
                                                                <span>웹링크</span>
                                                            </a>
                                                            <a href="#0">
                                                                <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                                <span>텍스트</span>
                                                            </a>
                                                            <a href="#0">
                                                                <i class="icon-svg-exercise" aria-hidden="true"></i>
                                                                <span>연습문제</span>
                                                            </a>
                                                        </div>
                                                    </div><!-- //학습자료 추가 -->
                                                </div>

                                            </div>
                                        </li>

                                    </ul>
                                </div>

                            </div>

                        </div>

                    </div>
                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1">콘텐츠 연동 가져오기</button>
                    <button type="button" class="btn modal__btn" id="btn-modal2">미리보기</button>
                    <button type="button" class="btn modal__btn" id="btn-modal3">주차 관리</button>
                    <button type="button" class="btn modal__btn" id="btn-modal4">학습자료 수정</button>
                    <button type="button" class="btn modal__btn" id="btn-modal5">연습문제 추가</button>
                    <button type="button" class="btn modal__btn" id="btn-modal6">연습문제 시험지</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->
            </div>
            <!-- //content -->


            <!-- Modal1 콘텐츠 연동 가져오기 -->
            <div class="modal-overlay" id="modal1">
                <div class="modal-content">
                    <div class="modal-body">
                    
                        <div class="board_top">
                            <h4 class="sub-title">과목정보</h4>
                        </div>

                        <div class="table-wrap mb20">
                            <table class="table-type5">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">학과/과목</th>
                                        <td data-th="학과/과목">영문학과/영어번역</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">과목코드</th>
                                        <td data-th="과목코드">GRAD0638001</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col>
                                <col style="width:20%">
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>대상</th>
									<th>관리</th>
									<th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="대상" class="t_left">
                                        해당 과목의 콘텐츠를 연동합니다.
                                    </td>
    								<td data-th="관리">
										<button class="btn basic small">
											콘텐츠 가져오기
										</button>
									</td>
									<td data-th="상태">
										<i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i>
									</td>
                                </tr>
                                <tr>
                                    <td data-th="대상" class="t_left">
                                        해당 과목의 콘텐츠를 연동합니다.
                                    </td>
    								<td data-th="관리">
										<button class="btn basic small">
											콘텐츠 가져오기
										</button>
									</td>
									<td data-th="상태">
										<i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
									</td>
								</tr>
                            </tbody>
                        </table>						
                    </div>

                    <div class="msg-box basic">
						<ul>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
						</ul>
					</div>
                    <div class="error_txt mt10">
<pre>2026.11.22(16:37:33)
[실패] 연동에 실패하였습니다. 
I/O error on POST request for "http://localhost:8384/haksa/sync/crs": Connect to localhost:8384 [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: Connection refused: connect; nested exception is org.apache.http.conn.HttpHostConnectException: Connect to localhost:8384 [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: Connection refused: connect
</pre>
                    </div>

                        <div class="modal_btns">
                            <button type="button" class="btn type2">닫기</button>
                        </div>

                    </div>
                </div>
            </div>
            <!-- //Modal1 콘텐츠 연동 가져오기 -->

            
            <!-- Modal2 강의 미리보기 -->
            <div class="modal-overlay" id="modal2">
                <div class="modal-content">                    
                    <div class="modal-body">
                        <div class="course_history mt0">
                            <div class="h_top">
                                <div class="h_left">
                                    <strong class="tit">[1주차] 2강. 무생물주어의 처리</strong>
                                    <p class="desc">
                                        <span>학습기간<strong>2026.03.01 09:00 ~ 2026.03.15 22:00</strong></span>
                                        <span><strong>30분</strong></span>
                                        <span><strong>출결대상</strong></span>
                                    </p>
                                </div>
                                <div class="h_right">
                                    <button class="btn s_type2 noAfter">학습종료</button>
                                </div>
                            </div>

                            <div class="padding-4">
                                <!-- 학습개요 -->
                                <h3 class="board-title mb10">학습개요</h3>
                                <div class="board_top class mb40">
                                    한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.한국어와 다른 영어의 구문상 가장 큰 특징 중의 하는 무생물주어를 많이 쓴다는 점이다.
                                </div>

                                <!-- 오늘의 학습 -->
                                <h3 class="board-title mb10">오늘의 학습</h3>
                                <div class="flex align-center justify-content-between mb10 gap-2">
                                    <p class="flex-shrink-0">학습진행</p>
                                    <div class="learning-progress">
                                        <span>100% (30분 00초)</span>
                                        <div class="bar" style="width: 40%;"></div>
                                    </div>
                                </div>
                                <div class="video-wrap">
                                    <video controls="" playsinline="">
                                        <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4">
                                    </video>
                                </div>
                                <div class="likeBtn">
                                    <button type="button" class="btn"><i class="xi-heart-o"></i>좋아요<span>2,026</span></button>
                                </div>

                                <!-- 연습문제 ① -->
                                <div class="board_top">
                                    <h3 class="board-title mb10">연습문제 ①</h3>
                                    <div class="right-area" style="position: relative; display: inline-block;">
                                        <div class="ansBox" id="ansBox1">
                                            <table class="table-type3">
                                                <caption>연습문제 1 정답 정보</caption>
                                                <thead>
                                                    <tr>
                                                        <th scope="col">문제</th>
                                                        <th scope="col">정답</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <th data-th="문제">1</th>
                                                        <td data-th="정답">2</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">2</th>
                                                        <td data-th="정답">-</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">3</th>
                                                        <td data-th="정답">2</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">4</th>
                                                        <td data-th="정답">1</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">5</th>
                                                        <td data-th="정답">4</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">6</th>
                                                        <td data-th="정답">2</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">7</th>
                                                        <td data-th="정답">1</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">8</th>
                                                        <td data-th="정답">4</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">9</th>
                                                        <td data-th="정답">학교</td>
                                                    </tr>
                                                    <tr>
                                                        <th data-th="문제">10</th>
                                                        <td data-th="정답">-</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <div class="quiz_paper_wrap">
                                    <div class="quiz_paper_list">
                                        <ol>
                                            <li class="active"><span>1</span></li>
                                            <li class="active"><span>2</span></li>
                                            <li><span>3</span></li>
                                            <li><span>4</span></li>
                                            <li><span>5</span></li>
                                            <li><span>6</span></li>
                                            <li><span>7</span></li>
                                            <li><span>8</span></li>
                                            <li><span>9</span></li>
                                            <li><span>10</span></li>
                                        </ol>
                                    </div>
                                </div>

                                <div class="course_history bd0">
                                    <div class="question_area pd0">
                                        <div class="question_con">
                                            <div class="q_top">
                                                <div class="flex-item width-100per">
                                                    <p class="flex-none mr15"><b>문제1</b></p>
                                                    <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                                </div>
                                            </div>
                                            <div class="q_cont">
                                                <ol class="q_cont_ans">
                                                    <li>
                                                        <input type="radio" name="q2_ans" id="q1_ans1">
                                                        <label for="q1_ans1"><span class="ansNum">1</span>나무</label>
                                                    </li>
                                                    <li>
                                                        <input type="radio" name="q2_ans" id="q1_ans2">
                                                        <label for="q1_ans2"><span class="ansNum">2</span>돌</label>
                                                    </li>
                                                    <li>
                                                        <input type="radio" name="q2_ans" id="q1_ans3" checked="">
                                                        <label for="q1_ans3"><span class="ansNum">3</span>바다</label>
                                                    </li>
                                                    <li>
                                                        <input type="radio" name="q2_ans" id="q1_ans4">
                                                        <label for="q1_ans4"><span class="ansNum">4</span>산</label>
                                                    </li>
                                                </ol>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="course_history bd0">
                                    <div class="question_area pd0">
                                        <div class="question_con">
                                            <div class="q_top">
                                                <div class="flex-item width-100per">
                                                    <p class="flex-none mr15"><b>문제2</b></p>
                                                    <div class="flex-1 tal">다음 문장을 한국어로 번역하세요. 연습문제를 푼 후 구글 클래스룸의 복습하기를 작성하시면 됩니다.<br>
                                                        The innovative engine design makes this automobile quieter and more fuel efficient</div>
                                                </div>
                                            </div>
                                            <div class="q_cont">
                                                <div class="q_cont_ans">
                                                <textarea name="" id="" placeholder="서술형 주관식 입력란" class="width-100per"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="h_content pd0">
                                    <ul class="accordion course_week">
                                        <li><!-- 클릭시 active 추가 -->
                                            <div class="title-wrap">                                      
                                                <a class="title" href="#">                                                
                                                    <div class="lecture_box work">
                                                        <div class="lecture_tit">
                                                            <p class="labels">
                                                                <label class="label s_online">강의</label>
                                                            </p>
                                                            <strong>콘텐츠 제목 1</strong>                                                    
                                                        </div>
                                                        <p class="desc">
                                                            <span>학습기간<strong>2026.03.10 10:00 ~ 2026.03.16 22:00</strong></span>                                    
                                                        </p>
                                                        <i class="arrow xi-angle-down"></i>
                                                    </div>
                                                </a>
                                            </div>
                                            <div class="cont">
                                                <div class="flex align-center justify-content-between mb10 gap-2">
                                                    <p class="flex-shrink-0">학습진행</p>
                                                    <div class="learning-progress">
                                                        <span>100% (30분 00초)</span>
                                                        <div class="bar" style="width: 40%;"></div>
                                                    </div>
                                                </div>
                                                <div class="video-wrap">
                                                    <video controls="" playsinline="">
                                                        <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4">
                                                    </video>
                                                </div>
                                                <div class="likeBtn mb0">
                                                    <button type="button" class="btn"><i class="xi-heart-o"></i>좋아요<span>2,026</span></button>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>

                                </div>

                            </div>
                        </div>

                        <div class="modal_btns">
                            <button type="button" class="btn type2">학습종료</button>
                        </div>                    
                    </div>                    
                </div>
            </div>
            <!-- //Modal2 강의 미리보기 -->

            <!-- Modal3 주차 관리 -->
            <div class="modal-overlay" id="modal3">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th class="req">주차명</th>
                                        <td>
											<div class="form-row">
												<input class="form-control width-50per" type="text" name="name" id="name_label" value="" required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req">주차 기간</th>
                                        <td>
											<div class="date_area">
												<input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
												<span class="txt-sort">~</span>
												<input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
											</div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req">출석인정기간</th>
                                        <td>
											<div class="date_area">
												<input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
												<span class="txt-sort">~</span>
												<input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
											</div>                  
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //Modal3 주차 관리 -->

            <!-- Modal4 강의 미리보기 -->
            <div class="modal-overlay" id="modal4">
                <div class="modal-content">
                <div class="modal-body">

                    <div class="board_top">
                        <h3 class="board-title">1주차</h3>
                        <div class="right-area">
                            <span class="total_txt">학습기간 :<b> 2026.03.05 ~ 2026.03.16</b></span>
                        </div>
                    </div>

                    <!--table-type-->
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per" />
                                <col class="" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th><label for="select_fullLabel">제목</label></th>
                                    <td>
                                        <div class="form-row">
                                            <input class="form-control width-100per" type="text" name="name" id="name_label" value="" placeholder="제목 입력">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="sendUserCk">출결대상</label></th>
                                    <td>
                                        <span class="custom-input">
                                            <input type="checkbox" name="sendUserCk" id="sendUserCk" checked>
                                            <label for="sendUserCk">출결체크 대상에 포함</label>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="dataLabel">학습자료</label></th>
                                    <td>
                                        <div class="item_btns">
                                            <a href="#0" class="active"><!-- 활성화 active 추가-->
                                                <i class="icon-svg-play-circle" aria-hidden="true"></i>
                                                <span>동영상</span>
                                            </a>
                                            <a href="#0">
                                                <i class="icon-svg-layout-alt" aria-hidden="true"></i>
                                                <span>PDF</span>
                                            </a>
                                            <a href="#0">
                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                <span>파일</span>
                                            </a>
                                            <a href="#0">
                                                <i class="icon-svg-share" aria-hidden="true"></i>
                                                <span>소셜</span>
                                            </a>
                                            <a href="#0">
                                                <i class="icon-svg-link" aria-hidden="true"></i>
                                                <span>웹링크</span>
                                            </a>
                                            <a href="#0">
                                                <i class="icon-svg-type-square" aria-hidden="true"></i>
                                                <span>텍스트</span>
                                            </a>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th><label for="socialLabel">소셜</label></th>
                                    <td>
                                        <div class="form-tab">
                                            <!-- Tab btn -->
                                            <div class="tab_btn">
                                                <a href="#tab01" class="current">URL 주소</a>
                                                <a href="#tab02">소스코드</a>
                                            </div>
                                            <div id="tab01" class="tab-content">
                                                <small class="note">* Youtube, TED, Vimeo의 동영상 주소를 입력하여 등록할 수 있습니다.</small>
                                                <div class="form-row">
                                                    <input class="form-control width-100per" type="text" name="name" id="url_label" value="" placeholder="소셜미디어 URL 주소를 붙여 넣으세요">
                                                </div>
                                            </div>
                                            <div id="tab02" class="tab-content" style="display:none;">
                                                <small class="note">* Iframe 형식 HTML 코드를 등록합니다.</small>
                                                <div class="form-row">
                                                    <label class="width-100per"><textarea rows="4" class="form-control resize-none">
<iframe width="560" height="315" src="https://www.youtube.com/embed/FJ2d-FPqDGE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                                    </textarea></label>
                                                </div>
                                                <div class="msg-txt mt10">
                                                    <p class="txt">* 소셜 미디어에서 제공하는 공유 코드를 복사하여 붙여 넣습니다.</p>
                                                    <button type="button" class="btn gray1">저장</button>
                                                </div>
                                            </div>
                                        </div>

                                    </td>
                                </tr>                                
                                <tr>
                                    <th><label for="attchFile">저화질 업로드</label></th>
                                    <td>
                                        <div id="fileUploader-container" class="dext5-container" style="width:100%;height:180px;"></div>
                                        <div id="fileUploader-btn-area" class="dext5-btn-area" style=""><button type="button" id="fileUploader_btn-add" style="" title="파일선택">파일선택</button><button type="button" id="fileUploader_btn-delete" disabled='true' style="" title="삭제">삭제</button><button type="button" id="fileUploader_btn-reset" style="display:none" title="초기화" onclick="resetDextFiles('fileUploader')"><i class='xi-refresh'></i></button></div>
                                        <script>
                                        UiFileUploader({
                                            id:"fileUploader",
                                            parentId:"fileUploader-container",
                                            btnFile:"fileUploader_btn-add",
                                            btnDelete:"fileUploader_btn-delete",
                                            lang:"ko",
                                            uploadMode:"ORAF",
                                            maxTotalSize:100,
                                            maxFileSize:100,
                                            extensionFilter:"*",
                                            noExtension:"exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py",
                                            finishFunc:"finishUpload()",
                                            uploadUrl:"https://localhost/dext/uploadFileDext.up?type=",
                                            path:"/bbs",
                                            fileCount:5,
                                            oldFiles:[],
                                            useFileBox:false,
                                            style:"list",
                                            uiMode:"normal"
                                        });
                                        </script>
                                    </td>
                                </tr>
                                <tr>
                                    <th><label for="attchFile">고화질 업로드</label></th>
                                    <td>
                                        <div id="fileUploader-container" class="dext5-container" style="width:100%;height:180px;"></div>
                                        <div id="fileUploader-btn-area" class="dext5-btn-area" style=""><button type="button" id="fileUploader_btn-add" style="" title="파일선택">파일선택</button><button type="button" id="fileUploader_btn-delete" disabled='true' style="" title="삭제">삭제</button><button type="button" id="fileUploader_btn-reset" style="display:none" title="초기화" onclick="resetDextFiles('fileUploader')"><i class='xi-refresh'></i></button></div>
                                        <script>
                                        UiFileUploader({
                                            id:"fileUploader",
                                            parentId:"fileUploader-container",
                                            btnFile:"fileUploader_btn-add",
                                            btnDelete:"fileUploader_btn-delete",
                                            lang:"ko",
                                            uploadMode:"ORAF",
                                            maxTotalSize:100,
                                            maxFileSize:100,
                                            extensionFilter:"*",
                                            noExtension:"exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py",
                                            finishFunc:"finishUpload()",
                                            uploadUrl:"https://localhost/dext/uploadFileDext.up?type=",
                                            path:"/bbs",
                                            fileCount:5,
                                            oldFiles:[],
                                            useFileBox:false,
                                            style:"list",
                                            uiMode:"normal"
                                        });
                                        </script>
                                    </td>
                                </tr>
                                <tr>
                                    <th>학습내용</th>
                                    <td>
                                        <dl>
                                            <dd>
                                                <div class="editor-box">
                                                    <label for="atclCts" class="hide">Content</label>
                                                    <textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
                                                    <script>
                                                        // HTML 에디터
                                                        let editor = UiEditor({
                                                            targetId: "atclCts",
                                                            uploadPath: "/bbs",
                                                            height: "500px"
                                                        });
                                                    </script>
                                                </div>

                                                <a href="#_" onclick="checkEditorContens();return false;">[입력내용확인]</a> &nbsp;
                                                <a href="#_" onclick="insertEditorContens1();return false;">[내용추가(text)]</a> &nbsp;
                                                <a href="#_" onclick="insertEditorContens2();return false;">[내용바꾸기(html)]</a>
                                                <script>
                                                    function checkEditorContens() {
                                                        if (editor.isEmpty()) {
                                                            alert("비어있다....");
                                                        }
                                                        else {
                                                            let text = $("#atclCts").val(); // editor.editor.getPublishingHtml()
                                                            alert(text);
                                                        }
                                                    }

                                                    function insertEditorContens1() {
                                                        //editor.execCommand('selectAll');
                                                        //editor.execCommand('deleteLeft');
                                                        editor.execCommand('insertText', "<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                    }

                                                    function insertEditorContens2() {
                                                        editor.openHTML("<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                    }
                                                </script>
                                            </dd>
                                        </dl>
                                    </td>
                                </tr>
                                <tr>
                                    <th>재생시간</th>
                                    <td>
                                        <div class="input_btn">
                                            <input class="form-control sm" id="timeInput1" type="text" maxlength="2"><label for="timeInput1">분</label>
                                        </div>
                                        <div class="input_btn mr15">
                                            <input class="form-control sm" id="timeInput2" type="text" maxlength="2"><label for="timeInput2">초</label>
                                        </div>

                                        <div class="input_btn">
                                            <span class="mr10">(총 :</span>
                                            <input class="form-control sm" id="timeInput3" type="text"><label for="timeInput3">초</label>
                                            <span class="ml10">)</span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>정렬순서</th>
                                    <td>
                                        <input class="form-control" type="text" id="num_label" required="true" class="width-3per"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>최종수정</th>
                                    <td>2026.02.08 10:24:15 (홍담당)</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 돌발퀴즈 -->
                    <div class="board_top">
                        <h4 class="sub-title">돌발퀴즈</h4>
                        <div class="right-area">
                            <button type="button" class="btn type1">추가</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                                <col style="width:15%">
                                <col>
                                <col style="width:7%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>퀴즈시간</th>
                                    <td class="t_left">
                                        <div class="input_btn">
                                            <input class="form-control m" id="timeInput1" type="text" maxlength="2" value="2416" style="width:5em"><label for="timeInput1">초</label>
                                        </div>
                                    </td>
                                    <th>시험지 선택</th>
                                    <td class="t_left">
                                        <div class="search-typeC">
                                            <input class="form-control sm" type="text" name="" id="inputSearch1" value="" placeholder="돌발퀴즈 시험지 선택" autocomplete="off">
                                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                        </div>
                                    </td>
                                    <td>
                                        <button type="button" class="btn basic small">삭제</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div><!-- //돌발퀴즈 -->

                    <!-- 다국어 자막(스크립트) -->
                    <div class="board_top">
                        <h4 class="sub-title">다국어 자막(스크립트)</h4>
                        <div class="right-area">
                            <button type="button" class="btn type1">추가</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                                <col style="width:15%">
                                <col>
                                <col style="width:7%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>언어코드</th>
                                    <td class="t_left">
                                        <select class="form-select" id="selectEmail2">
                                            <option value="">영어</option>
                                        </select>
                                    </td>
                                    <th>SRT자막 첨부파일</th>
                                    <td class="t_left">
                                        <div class="search-typeC">
                                            <input class="form-control sm" type="text" name="" id="inputSearch1" value="" autocomplete="off">
                                            <button type="button" class="btn basic icon search" aria-label="찾아보기"><i class="icon-svg-search"></i></button>
                                        </div>
                                    </td>
                                    <td>
                                        <button type="button" class="btn basic small">삭제</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div><!-- //다국어 자막(스크립트) -->

                    <div class="modal_btns mb20">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">삭제</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>

                </div>
            </div><!-- //Modal4 강의 미리보기 -->

            <!-- Modal5 연습문제 추가 -->
             <div class="modal-overlay" id="modal5">
                <div class="modal-content">
                    <div class="modal-body">

                    <div class="board_top">
                        <h3 class="board-title">1주차</h3>
                        <div class="right-area">
                            <span class="total_txt">학습기간 :<b> 2026.03.05 ~ 2026.03.16</b></span>
                        </div>
                    </div>

                    <div class="board_top">
                        <h4 class="sub-title">강의보기 > 학습목차</h4>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type3">
                            <colgroup>
                                <col style="width:5%">
                                <col style="width:20%">
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">정렬 순번</th>
                                    <th scope="col">구분</th>
                                    <th scope="col">타이틀</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="정렬 순번">1</td>
                                    <td data-th="구분">텍스트</td>
                                    <td data-th="타이틀" class="t_left">학습개요</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">2</td>
                                    <td data-th="구분">동영상</td>
                                    <td data-th="타이틀" class="t_left">오늘의 학습</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">3</td>
                                    <td data-th="구분">텍스트</td>
                                    <td data-th="타이틀" class="t_left">구글 클래스룸 사용법</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">4</td>
                                    <td data-th="구분">동영상</td>
                                    <td data-th="타이틀" class="t_left">학습하기 ① - make를 활용한 무생물주어</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">5</td>
                                    <td data-th="구분">시험지</td>
                                    <td data-th="타이틀" class="t_left fcBlue">연습문제①</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">6</td>
                                    <td data-th="구분">LTI</td>
                                    <td data-th="타이틀" class="t_left">복습하기 – 구글 클래스룸 ①</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">7</td>
                                    <td data-th="구분">동영상</td>
                                    <td data-th="타이틀" class="t_left">학습하기 ② - 소유격이 포함된 무생물주어</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">8</td>
                                    <td data-th="구분">시험지</td>
                                    <td data-th="타이틀" class="t_left fcBlue">연습문제 ②</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">9</td>
                                    <td data-th="구분">LTI</td>
                                    <td data-th="타이틀" class="t_left">복습하기 – 구글 클래스룸 ②</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">10</td>
                                    <td data-th="구분">동영상</td>
                                    <td data-th="타이틀" class="t_left">학습하기 ③ - 시간을 나타내는 무생물주어</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">11</td>
                                    <td data-th="구분">시험지</td>
                                    <td data-th="타이틀" class="t_left fcBlue">연습문제 ③</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">12</td>
                                    <td data-th="구분">LTI</td>
                                    <td data-th="타이틀" class="t_left">복습하기 – 구글 클래스룸 ③</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">13</td>
                                    <td data-th="구분">동영상</td>
                                    <td data-th="타이틀" class="t_left">학습하기 ④ - 감정 변화를 나타내는 동사 구문</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">14</td>
                                    <td data-th="구분">시험지</td>
                                    <td data-th="타이틀" class="t_left fcBlue">연습문제 ④</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">15</td>
                                    <td data-th="구분">LTI</td>
                                    <td data-th="타이틀" class="t_left">복습하기 – 구글 클래스룸 ④</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">16</td>
                                    <td data-th="구분">동영상</td>
                                    <td data-th="타이틀" class="t_left">학습하기 ⑤ - 기타 무생물주어 구문</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">17</td>
                                    <td data-th="구분">시험지</td>
                                    <td data-th="타이틀" class="t_left fcBlue">연습문제 ⑤</td>
                                </tr>
                                <tr>
                                    <td data-th="정렬 순번">18</td>
                                    <td data-th="구분">LTI</td>
                                    <td data-th="타이틀" class="t_left">복습하기 – 구글 클래스룸 ⑤</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board_top">
                        <h4 class="sub-title">연습문제 추가</h4>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">구분</th>
                                    <td data-th="구분">시험지</td>
                                </tr>
                                <tr>
                                    <th scope="row" class="req">타이틀</th>
                                    <td data-th="타이틀">
                                        <input class="form-control width-50per" type="text" name="name" id="name_label" value="" placeholder="타이틀을 입력하세요" required="true" inputmask="byte" maxLen="10" minLen="4">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" class="req">분반같이 등록</th>
                                    <td data-th="분반같이 등록">
                                        <div class="checkbox_type">
                                            <span class="custom-input">
                                                <input type="checkbox" name="name" id="checkType1">
                                                <label for="checkType1">전체</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="name" id="checkType2">
                                                <label for="checkType2">1반</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="name" id="checkType3">
                                                <label for="checkType3">2반</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="checkbox" name="name" id="checkType4">
                                                <label for="checkType4">3반</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">출결대상</th>
                                    <td data-th="출결대상">
                                        <span class="custom-input">
                                            <input type="checkbox" name="noticeLabel" id="noticeLabel">
                                            <label for="noticeLabel">출결체크 대상에 포함</label>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">정렬 순서</th>
                                    <td data-th="정렬 순서">
                                        <input class="form-control" type="text" id="id_label" value="5" required="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" class="req">연습문제 시험지</th>
                                    <td data-th="연습문제 시험지">
                                        <div class="search-typeC">
                                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="연습문제 시험지 선택" autocomplete="off" style="width:30em">
                                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">최종수정</th>
                                    <td data-th="최종수정">
                                        2026.02.08 10:24:15 (홍담당)
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="btns mb20">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                    </div>
                </div>
             </div>
            <!-- //Modal5 연습문제 추가 -->

            <!-- Modal6 연습문제 시험지 -->
             <div class="modal-overlay" id="modal6">
                <div class="modal-content">
                    <div class="modal-body">
                        
                        <div class="board_top in_table">
                            <!-- search small -->
                            <select class="form-select" id="selectDate1">
                                <option value="2025년">2025년</option>
                                <option value="2024년">2024년</option>
                            </select>
                            <select class="form-select" id="selectDate2">
                                <option value="2학기">2학기</option>
                                <option value="1학기">1학기</option>
                            </select>
                            <select class="form-select wide" id="selectSubject">
                                <option value="">일한 번역연습01 1반</option>
                            </select>
                            <div class="search-typeC">
                                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="연습문제 시험지 제목">
                                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                            </div>
                        </div>

                        <div class="table-wrap overflow-y">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col>
                                    <col style="width:7%">
                                    <col>
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col">년도</th>
                                        <th scope="col">학기</th>
                                        <th scope="col">과목명</th>
                                        <th scope="col">분반</th>
                                        <th scope="col">연습문제 시험지 제목</th>
                                        <th scope="col">선택</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">50</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과목명" class="t_left">일한 반역연습01</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="연습문제시험지 제목" class="t_left">연습문제001</td>
                                        <td data-th="선택">
                                            <button type="button" class="btn basic small">선택</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>                          
                        </div>
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
                        
                        <div class="btns">
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div>
                </div>
             </div>
            <!-- //Modal6 연습문제 시험지 -->


    </main><!-- //admin-->

    </div>

</body>
</html>

<script>
    //콘텐츠 연동 가져오기
    $('#btn-modal1').on('click', function() {
        
        var $content = $('#modal1 .modal-body');

        UiDialog("dialog1", {
            title: "콘텐츠 연동 가져오기",
            width: 800,
            height: 480,
            html: $content
        });
    });

    //미리보기
    $('#btn-modal2').on('click', function() {
        
        var $content = $('#modal2 .modal-body');

        UiDialog("dialog1", {
            title: "미리보기",
            width: 840,
            height: 870,
            html: $content
        });
    });

    //주차 관리
    $('#btn-modal3').on('click', function() {
        
        var $content = $('#modal3 .modal-body');

        UiDialog("dialog1", {
            title: "주차 관리",
            width: 1200,
            height: 340,
            html: $content
        });
    });

    //학습자료 수정
    $('#btn-modal4').on('click', function() {
        
        var $content = $('#modal4 .modal-body');

        UiDialog("dialog1", {
            title: "학습자료 수정",
            width: 1200,
            height: 860,
            html: $content
        });
    });    

    //연습문제 추가
    $('#btn-modal5').on('click', function() {
        
        var $content = $('#modal5 .modal-body');

        UiDialog("dialog1", {
            title: "연습문제 추가",
            width: 1200,
            height: 860,
            html: $content
        });
    });    

    //연습문제 시험지
    $('#btn-modal6').on('click', function() {
        
        var $content = $('#modal6 .modal-body');

        UiDialog("dialog1", {
            title: "연습문제 시험지",
            width: 1200,
            height: 600,
            html: $content
        });
    });    
</script>