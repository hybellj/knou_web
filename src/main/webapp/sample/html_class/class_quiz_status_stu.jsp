<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">        
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>

    <script src="../../webdoc/uilib/chart/chart4.min.js"></script>
    <script src="../../webdoc/uilib/chart/chart-utils.min.js"></script>
    <script src="../../webdoc/uilib/chart/chartjs-plugin-datalabels.min.js"></script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
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
                <div class="class_sub_top">                    
                    <div class="btn-wrap">
                        <div class="first">
                            <select class="form-select">
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>
                
                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area sub">
                        <div class="class_info">
                            <div class="class_tit">
                                <p class="labels">
                                    <label class="label uniA">대학원</label>
                                </p>
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                            </div>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의실</li>
                                    <li><span class="current">토론</span></li>
                                </ul>
                            </div>                            
                        </div>                        
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        
                        <div class="page-info">
                            <h2 class="page-title">시험</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li><a href="#">시험정보 및 평가</a></li>
                                <li class="select"><a href="#0">시험 대체</a></li>
                                <li><a href="#0">결시신청 및 결과</a></li>
                                <li><a href="#0">장애인/고령자지원</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">시험대체</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2 big">목록</button>  
                            </div>
                        </div>

                        <!--accordion-->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">                                      
                                        <a class="title" href="#">                                                                                            
                                            <div class="lecture_tit">                                                   
                                                <label class="label s_test mr5">중간고사</label><strong>실시간 중간고사</strong>   
                                                <p class="desc">
                                                    <span><strong class="fcBlack">실시간 온라인</strong></span>
                                                    <span>시험일시 :<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
                                                    <span>성적반영 :<strong>예</strong></span>
                                                    <span>성적공개 :<strong>아니오</strong></span>
                                                </p>                                                 
                                            </div>                                                                                        
                                            <i class="arrow xi-angle-down"></i>                                           
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <!-- ul.table-list > table-type5 으로 변경(2026-04-29) -->
                                        <table class="table-type5">
                                            <form id="form1" name="form1">
                                            <colgroup>
                                                <col width="15%">
                                                <col>
                                                <col width="15%">
                                                <col>
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th>시험구분</th>
                                                    <td colspan="3">중간고사</td>
                                                </tr>
                                                <tr>
                                                    <th>시험방식</th>
                                                    <td>실시간 온라인</td>
                                                    <th>배점</th>
                                                    <td>10점</td>
                                                </tr>
                                                <tr>
                                                    <th>시험내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
                                                            </textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>시험일시</th>
                                                    <td colspan="3">2026.09.30 10:00 ~ 2026.10.09 22:00</td>
                                                </tr>
                                                <tr>
                                                    <th>시험시간</th>
                                                    <td colspan="3">50분</td>
                                                </tr>
                                                <tr>
                                                    <th>성적반영</th>
                                                    <td colspan="3">예</td>
                                                </tr>
                                                <tr>
                                                    <th>성적공개</th>
                                                    <td colspan="3">예</td>
                                                </tr>
                                                <tr>
                                                    <th>시험지 공개</th>
                                                    <td colspan="3">아니오</td>
                                                </tr>
                                                <tr>
                                                    <th>팀 시험</th>
                                                    <td colspan="3">
                                                        아니오
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>시험대체</th>
                                                    <td colspan="3">
                                                        퀴즈
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </form>
                                        </table>
                                        <!-- //ul.table-list > table-type5 으로 변경(2026-04-29) -->
                                    </div>
                                </li>   
                            </ul>
                        </div>
                        <!--//accordion-->
                        
                        <div class="board_top">
                            <h4 class="sub-title">시험 대체 정보</h4>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per">
                                    <col>
                                <tbody>
                                    <tr>
                                        <th>퀴즈명</th>
                                        <td>시험대체 퀴즈002</td>
                                    </tr>
                                    <tr>
                                        <th>퀴즈 내용</th>
                                        <td>
                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.</textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>응시기간</th>
                                        <td>2026.09.30 10:00 ~ 2026.10.09 22:00</td>
                                    </tr>
                                    <tr>
                                        <th>퀴즈시간</th>
                                        <td>20분</td>
                                    </tr>
                                    <tr>
                                        <th>성적반영</th>
                                        <td>예</td>
                                    </tr>
                                    <tr>
                                        <th>성적공개</th>
                                        <td>예</td>
                                    </tr>
                                    <tr>
                                        <th>문제표시방식</th>
                                        <td>전체 문제표시</td>
                                    </tr>
                                    <tr>
                                        <th>문제 섞기</th>
                                        <td>ON</td>
                                    </tr>
                                    <tr>
                                        <th>보기 섞기</th>
                                        <td>ON</td>
                                    </tr>
                                    <tr>
                                        <th>파일 첨부</th>
                                        <td>
                                            <div>
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">첨부파일명마우스오버 시.doc</span>
                                                    <span class="fileSize">(6KB)</span>
                                                </a>
                                            </div>
                                            <div>
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">154873973477000.jpg</span>
                                                    <span class="fileSize">(6KB)</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>팀 퀴즈</th>
                                        <td>아니오</td>
                                    </tr>
                                    <tr>
                                        <th>재응시 사용</th>
                                        <td>아니오</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="board_top">
                            <h4 class="sub-title">퀴즈 응시</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic">피드백 0</button>
                            </div>
                        </div>

                        <div class="msg-box">
                            <p class="txt"><strong>안내 : </strong>퀴즈 응시 전입니다. 퀴즈 응시하시기 바랍니다.</p>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type1">
                                <colgroup>
                                    <col class="width-5per">
                                    <col>
                                    <col>
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>퀴즈 시작</th>
                                        <th>퀴즈 종료</th>
                                        <th>응시 시간</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th data-th="번호">1</th>
                                        <td data-th="퀴즈 시작">2026.03.24 16:00:45</td>
                                        <td data-th="퀴즈 종료">2026.03.24 16:00:45</td>
                                        <td data-th="응시 시간">26분 20초</td>
                                    </tr>
                                    <tr>
                                        <th data-th="번호">2</th>
                                        <td data-th="퀴즈 시작">2026.03.24 16:00:45</td>
                                        <td data-th="퀴즈 종료">2026.03.24 16:00:45</td>
                                        <td data-th="응시 시간">26분 20초</td>
                                    </tr>
                                    <tr>
                                        <th data-th="번호">3</th>
                                        <td data-th="퀴즈 시작">2026.03.24 16:00:45</td>
                                        <td data-th="퀴즈 종료">2026.03.24 16:00:45</td>
                                        <td data-th="응시 시간">26분 20초</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1">응시하기</button>
                        </div>
                    </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" id="btn-quiz-paper">퀴즈 시험지</button>
                    <button type="button" class="btn modal__btn" id="btn-quiz-notice">퀴즈 응시 주의사항</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->


        <!-- Modal1 퀴즈 시험지 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="board_top class">
                        <h3 class="board-title">[ 사회 ] 유럽 문화 탐방(1반)</h3>
                        <div class="right-area">
                            <div class="feedback-info">
                                <p class="desc">
                                    <span><strong>컴퓨터공학과</strong></span>
                                    <span><strong>9021582</strong></span>
                                    <span><strong>김주미</strong></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">상시 퀴즈</h3>
                        <div class="right-area">
                            <div class="btn basic">
                                <i class="xi-alarm-o icon"></i>
                                76:37 분
                            </div>
                        </div>
                    </div>

                    <div class="quiz-layout-wrapper">
                        <!-- 왼쪽 문제 -->
                        <div class="course_history bd0">
                            <div class="question_area pd0">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <p class="flex-none mr15"><b>문제1</b></p>
                                            <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="margin-left-auto">배점 10점</div>
                                        </div>
                                    </div>

                                    <div class="q_cont">
                                        <ol class="q_cont_ans">
                                            <li>
                                                <input type="radio" name="q1_ans" id="q1_ans2">
                                                <label for="q1_ans1"><span class="ansNum">1</span>나무</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q1_ans" id="q2_ans2">
                                                <label for="q1_ans2"><span class="ansNum">2</span>돌</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q1_ans" id="q2_ans3" checked="">
                                                <label for="q1_ans3"><span class="ansNum">3</span>바다</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q1_ans" id="q2_ans4">
                                                <label for="q1_ans4"><span class="ansNum">4</span>산</label>
                                            </li>
                                        </ol>
                                    </div>

                                </div>
                            </div>

                            <div class="question_area pd0">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <p class="flex-none mr15"><b>문제2</b></p>
                                            <div class="flex-1 tal">선긋기222222</div>
                                            <div class="margin-left-auto">배점 10점</div>
                                        </div>
                                    </div>

                                    <div class="q_cont">
                                        <div class="q_cont_ans matching_form">
                                            <ol class="matching_list">
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q1">
                                                            <span class="index">A</span>
                                                            <input type="text" id="match_q1" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q2">
                                                            <span class="index">B</span>
                                                            <input type="text" id="match_q2" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a2">
                                                            <input type="text" id="match_a2" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q3">
                                                            <span class="index">C</span>
                                                            <input type="text" id="match_q3" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a3">
                                                            <input type="text" id="match_a3" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q4">
                                                            <span class="index">D</span>
                                                            <input type="text" id="match_q4" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a4">
                                                            <input type="text" id="match_a4" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                            </ol>

                                            <ol class="matching_list matching_drag">
                                                <li class="matching_item">
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="a_box">
                                                        <i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                            </ol>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="question_area pd0">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <p class="flex-none mr15"><b>문제3</b></p>
                                            <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="margin-left-auto">배점 10점</div>
                                        </div>
                                    </div>

                                    <div class="q_cont">
                                        <ol class="q_cont_ans">
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans1">
                                                <label for="q2_ans1"><span class="ansNum">1</span>강아지</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans2">
                                                <label for="q2_ans2"><span class="ansNum">2</span>고양이</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans3" checked="">
                                                <label for="q2ans3"><span class="ansNum">3</span>토끼</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans4">
                                                <label for="q2_ans4"><span class="ansNum">4</span>사슴</label>
                                            </li>
                                        </ol>
                                    </div>

                                </div>
                            </div>

                        </div>
                        <!-- //왼쪽 문제 -->

                        <!-- 오른쪽 제출 답안 -->
                        <div class="quiz_paper_wrap">
                            <div class="course_history">
                                <div class="h_top">
                                    <b>제출 답안</b>
                                </div>
                                <div class="quiz_paper_list">
                                    <ol>
                                        <li class="active"><span>1</span>2</li>
                                        <li class="active"><span>2</span>곤충류 | 양서류</li>
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
                        </div>
                        <!-- //오른쪽 제출 답안 -->
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">임시저장</button>
                        <button type="button" class="btn type2">제출</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 퀴즈 시험지 -->

        <!-- Modal2 퀴즈 응시 주의사항 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="tit_divider mb30 mt10">2026년도 1학기 데이터베이스의 이해 활용 1반의 퀴즈</div>
                    <div class="msg-box basic mb40">
                        <ul class="list-asterisk">
                            <li>해당 퀴즈의 응시 제한시간은 <b class="blue">10분</b> 입니다.</li>
                            <li>최초 응시 시점부터 응시 시간이 자동으로 흘러가며, 응시 시간이 지나면 재응시가  불가능합니다.</li>
                            <li><b class="blue">퀴즈 응시 중간에 창을 닫을 경우에도 응시 시간이 계속 진행</b> 됩니다.</li>
                        </ul>
                    </div>
                    <div class="text-center mb40">
                        <b class="fcRed">응시 버튼을 클릭하면 응시 시간이 진행</b>됩니다.<br>
                        지금 응시가 어려우시면 취소를 눌러 퀴즈 응시 기간 내에 재 접속하시기 바랍니다.
                    </div>
                    <div class="btns">
                        <button type="button" class="btn type1">응시</button>
                        <button type="button" class="btn type2">취소</button>
                    </div>
                </div>
            </div>
        </div>         
        <!-- //Modal2 퀴즈 응시 주의사항 -->

        <script>
            $(function() {
                // 1. 퀴즈시험지 다이얼로그
                $('#btn-quiz-paper').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "퀴즈 시험지",
                        width: '98%',
                        height: 800,
                        html: $content
                    });
                });

                // 2. 퀴즈 응시 주의사항
                $('#btn-quiz-notice').on('click', function() {
                    
                    var $content = $('#modal2 .modal-body');

                    UiDialog("dialog1", {
                        title: "퀴즈 응시 주의사항",
                        width: 800,
                        height: 450,
                        html: $content
                    });
                });

            });
        </script>

    </div>

</body>
</html>
