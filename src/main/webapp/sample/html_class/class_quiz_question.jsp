<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
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
                                    <li><span class="current">퀴즈</span></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">퀴즈</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li><a href="./class_quiz_info.jsp">퀴즈정보 및 평가</a></li>
                                <li class="select"><a href="#0">문항관리</a></li>
                                <li><a href="#">재응시 관리</a></li>
                            </ul>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">문항관리</h3>
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
                                                <strong>일반퀴즈</strong>
                                                <p class="desc">
                                                    <span>참여기간 :<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
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
                                                    <th>퀴즈내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다. 퀴즈내용입니다.
                                                            </textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>응시기간</th>
                                                    <td colspan="3">2026.09.30 10:00 ~ 2026.10.09 22:00</td>
                                                </tr>
                                                <tr>
                                                    <th>성적반영</th>
                                                    <td>예</td>
                                                    <th>성적반영비율</th>
                                                    <td>25%</td>
                                                </tr>
                                                <tr>
                                                    <th>성적공개</th>
                                                    <td colspan="3">참여형<small class="note ml10">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small></td>
                                                </tr>
                                                <tr>
                                                    <th>문제표시방식</th>
                                                    <td colspan="3">전체 문제표시</td>
                                                </tr>
                                                <tr>
                                                    <th>문제 섞기</th>
                                                    <td colspan="3">ON</td>
                                                </tr>
                                                <tr>
                                                    <th>보기 섞기</th>
                                                    <td colspan="3">ON</td>
                                                </tr>
                                                <tr>
                                                    <th>파일 첨부</th>
                                                    <td colspan="3">
                                                        <div>
                                                            <a href="#" class="file_down">
                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                <span class="text">첨부파일명마우스오버 시.doc</span>
                                                                <span class="fileSize">(6KB)</span>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>팀 퀴즈</th>
                                                    <td colspan="3">아니오</td>
                                                </tr>
                                                <tr>
                                                    <th>재응시 사용</th>
                                                    <td colspan="3">
                                                        예<br>재응시 기간 : 2026.09.30 10:00 ~ 2026.10.09 22:00<br>재응시 적용율 : 80%
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

                        <div class="listTab">
                            <ul>
                                <li class="select"><a href="#">Team 1</a></li>
                                <li><a href="#">Team 2</a></li>
                                <li><a href="#">Team 3</a></li>
                            </ul>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">출제 문제 : 6 문제</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">문제 가져오기</button>
                                <button type="button" class="btn basic">엑셀로 문제등록</button>
                                <button type="button" class="btn basic type1">자동 배점 처리</button>
                            </div>
                        </div>

                        <!-- 문제1 -->
                        <div class="course_history">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>문제 1</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small btn_add_question">후보 문제 추가</button>
                                    <div class="input_btn">
                                        <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1" value="20">
                                        <label for="bulkScoreValue">점</label>
                                    </div>
                                    <button type="button" class="btn basic type2 small">삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>1-1</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q-ctrl-group">
                                                <p class="flex-none ml15 mr15">단일선택형</p>
                                                <button type="button" class="btn basic type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="q_cont">
                                        <p>설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설</p>
                                        <ol class="q_cont_ans">
                                            <li>
                                                <input type="radio" name="q1_ans" id="q1_ans1">
                                                <label for="q1_ans1"><span class="ansNum">1</span>강아지</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q1_ans" id="q1_ans2">
                                                <label for="q1_ans2"><span class="ansNum">2</span>고양이</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q1_ans" id="q1_ans3">
                                                <label for="q1_ans3"><span class="ansNum">3</span>호랑이</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q1_ans" id="q1_ans4">
                                                <label for="q1_ans4"><span class="ansNum">4</span>토끼</label>
                                            </li>
                                        </ol>
                                    </div>
                                </div>
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>1-2</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q-ctrl-group">
                                                <p class="flex-none ml15 mr15">주관식(단답형)</p>
                                                <button type="button" class="btn basic type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="q_cont">
                                        <p>설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설</p>
                                        <div class="q_cont_ans shortAnswerList">
                                            <label for="shortAnswer1"><input type="text" id="shortAnswer1" placeholder="1번 답" class="form-control"></label>
                                            <label for="shortAnswer2"><input type="text" id="shortAnswer2" placeholder="2번 답" class="form-control"></label>
                                            <label for="shortAnswer3"><input type="text" id="shortAnswer3" placeholder="3번 답" class="form-control"></label>
                                            <label for="shortAnswer4"><input type="text" id="shortAnswer4" placeholder="4번 답" class="form-control"></label>
                                            <label for="shortAnswer5"><input type="text" id="shortAnswer5" placeholder="5번 답" class="form-control"></label>
                                        </div>
                                    </div>
                                </div>

                                <!-- 후보 문제 추가 -->
                                <div class="question_con question_con_add">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <p class="flex-none mr15"><b>후보 문제 추가</b></p>
                                        </div>
                                    </div>
                                    <div class="q_cont">
                                        <div class="q_cont_form">

                                            <div class="table-wrap">
                                                <table class="table-type5">
                                                    <colgroup>
                                                        <col class="width-15per">
                                                        <col class="">
                                                    </colgroup>
                                                    <tbody>
                                                        <tr>
                                                            <th>문제</th>
                                                            <td>
                                                                <div class="form-row gap-2">
                                                                    <input class="form-control width-80per" type="text" name="name" id="name_label" value="" placeholder="6-1 문제" required="true" inputmask="byte" maxLen="10" minLen="4">
                                                                    <select class="form-select width-20per" id="select_fullLabel" name="select_fullLabel">
                                                                        <option value="">문제 유형 선택</option>
                                                                        <option value="객관식(다중)">객관식(다중)</option>
                                                                        <option value="객관식(단일)">객관식(단일)</option>
                                                                        <option value="주관식(단답형)">주관식(단답형)</option>
                                                                        <option value="주관식(서술형)">주관식(서술형)</option>
                                                                        <option value="OX형">OX형</option>
                                                                        <option value="짝짓기형">짝짓기형</option>
                                                                    </select>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>내용</th>
                                                            <td>
                                                                <textarea style="width:100%;height:70px" maxLenCheck="byte,60,true,true"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>보기 개수</th>
                                                            <td>
                                                                <div class="form-inline">
                                                                    <select class="form-select" id="add_univ_label" name="univ_label" required="true">
                                                                        <option value="">개수 선택</option>
                                                                        <option value="2개">2개</option>
                                                                        <option value="3개">3개</option>
                                                                        <option value="4개">4개</option>
                                                                        <option value="5개">5개</option>
                                                                        <option value="6개">6개</option>
                                                                        <option value="7개">7개</option>
                                                                        <option value="8개">8개</option>
                                                                        <option value="9개">9개</option>
                                                                        <option value="10개">10개</option>
                                                                    </select>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>보기 입력</th>
                                                            <td>
                                                                <div class="checkbox_type mb5">
                                                                    <span class="custom-input">
                                                                        <input type="checkbox" name="name" id="checkType1">
                                                                        <label for="checkType1">보기 1</label>
                                                                    </span>
                                                                    <label for="checkType1Ans"><input class="form-control width-50per" type="text" name="name" id="checkType1Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
                                                                </div>
                                                                <div class="checkbox_type mb5">
                                                                    <span class="custom-input">
                                                                        <input type="checkbox" name="name" id="checkType2">
                                                                        <label for="checkType2">보기 2</label>
                                                                    </span>
                                                                    <label for="checkType2Ans"><input class="form-control width-50per" type="text" name="name" id="checkType2Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
                                                                </div>
                                                                <div class="checkbox_type mb5">
                                                                    <span class="custom-input">
                                                                        <input type="checkbox" name="name" id="checkType3">
                                                                        <label for="checkType3">보기 3</label>
                                                                    </span>
                                                                    <label for="checkType3Ans"><input class="form-control width-50per" type="text" name="name" id="checkType3Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
                                                                </div>
                                                                <div class="checkbox_type">
                                                                    <span class="custom-input">
                                                                        <input type="checkbox" name="name" id="checkType4">
                                                                        <label for="checkType4">보기 4</label>
                                                                    </span>
                                                                    <label for="checkType4Ans"><input class="form-control width-50per" type="text" name="name" id="checkType4Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>난이도</th>
                                                            <td>
                                                                <div class="form-inline">
                                                                    <select class="form-select" id="" name="" required="true">
                                                                        <option value="">난이도 선택</option>
                                                                        <option value="상관없음">상관없음</option>
                                                                        <option value="상">상</option>
                                                                        <option value="중">중</option>
                                                                        <option value="하">하</option>
                                                                    </select>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>전체 정답처리</th>
                                                            <td>
                                                                <div class="form-row">
                                                                    <input type="checkbox" id="checkOpenYn" class="switch yesno">
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>

                                        <div class="btns">
                                            <button type="button" class="btn basic type1">문제 저장</button>
                                            <button type="button" class="btn basic type2">취소</button>
                                        </div>

                                    </div>
                                </div>
                                <!-- //후보 문제 추가 -->



                            </div>
                        </div><!-- //문제1 -->

                        <!-- 문제2 -->
                        <div class="course_history">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>문제 2</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small">후보 문제 추가</button>
                                    <div class="input_btn">
                                        <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1" value="20">
                                        <label for="bulkScoreValue">점</label>
                                    </div>
                                    <button type="button" class="btn basic type2 small">삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>2-1</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q-ctrl-group">
                                                <p class="flex-none ml15 mr15">OX형</p>
                                                <button type="button" class="btn basic type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="q_cont">
                                        <p>설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설</p>
                                        <div class="q_cont_ans ox_quiz justify-content-center">
                                            <div class="ox_item">
                                                <input type="radio" name="ox_choice" id="ox_o" class="ox_input">
                                                <label for="ox_o" class="btn basic">
                                                    <i class="xi-radiobox-blank icon"></i>
                                                </label>
                                            </div>

                                            <div class="ox_item">
                                                <input type="radio" name="ox_choice" id="ox_x" class="ox_input">
                                                <label for="ox_x" class="btn basic">
                                                    <i class="xi-close icon"></i>
                                                </label>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>2-2</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q-ctrl-group">
                                                <p class="flex-none ml15 mr15">주관식(서술형)</p>
                                                <button type="button" class="btn basic type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="q_cont">
                                        <p>설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설</p>
                                        <div class="q_cont_ans">
                                            <textarea name="" id="" class="width-100per"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div><!-- //문제2 -->

                        <!-- 문제3 -->
                        <div class="course_history mb20">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>문제 3</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small">후보 문제 추가</button>
                                    <div class="input_btn">
                                        <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1" value="20">
                                        <label for="bulkScoreValue">점</label>
                                    </div>
                                    <button type="button" class="btn basic type2 small">삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>3-1</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q-ctrl-group">
                                                <p class="flex-none ml15 mr15">짝짓기형</p>
                                                <button type="button" class="btn basic type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="q_cont">
                                        <p>설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설</p>
                                        <div class="q_cont_ans matching_form">
                                            <ol class="matching_list">
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q1">
                                                            <span class="index">A</span>
                                                            <input type="text" id="match_q1" placeholder="보기 입력">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="정답 입력">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q2">
                                                            <span class="index">B</span>
                                                            <input type="text" id="match_q2" placeholder="보기 입력">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a2">
                                                            <input type="text" id="match_a2" placeholder="정답 입력">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q3">
                                                            <span class="index">C</span>
                                                            <input type="text" id="match_q3" placeholder="보기 입력">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a3">
                                                            <input type="text" id="match_a3" placeholder="정답 입력">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q4">
                                                            <span class="index">D</span>
                                                            <input type="text" id="match_q4" placeholder="보기 입력">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a4">
                                                            <input type="text" id="match_a4" placeholder="정답 입력">
                                                        </label>
                                                    </div>
                                                </li>
                                            </ol>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div><!-- //문제3 -->

                        <div class="board_top class">
                            <h3 class="board-title">배점 합계 <b class="primary">80</b>점</h3>
                        </div>

                        <div class="board_top ">
                            <h4 class="sub-title">문제 추가</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic type1">문제 저장</button>
                                <button type="button" class="btn basic type2">취소</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
									<col class="width-15per">
									<col class="">
								</colgroup>
                                <tbody>
                                    <tr>
                                        <th>문제</th>
                                        <td>
											<div class="form-row gap-2">
												<input class="form-control width-80per" type="text" name="name" id="name_label" value="" placeholder="6-1 문제" required="true" inputmask="byte" maxLen="10" minLen="4">
												<select class="form-select width-20per" id="select_fullLabel" name="select_fullLabel">
                                                    <option value="">문제 유형 선택</option>
													<option value="객관식(다중)">객관식(다중)</option>
													<option value="객관식(단일)">객관식(단일)</option>
                                                    <option value="주관식(단답형)">주관식(단답형)</option>
                                                    <option value="주관식(서술형)">주관식(서술형)</option>
                                                    <option value="OX형">OX형</option>
                                                    <option value="짝짓기형">짝짓기형</option>
												</select>
											</div>
                                            <small class="note2">! 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다.</small>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>내용</th>
                                        <td>
                                            <textarea style="width:100%;height:70px" maxLenCheck="byte,60,true,true"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>보기 개수</th>
                                        <td>
											<div class="form-inline">
												<select class="form-select" id="univ_label" name="univ_label" required="true">
													<option value="">개수 선택</option>
													<option value="2개">2개</option>
                                                    <option value="3개">3개</option>
                                                    <option value="4개">4개</option>
                                                    <option value="5개">5개</option>
                                                    <option value="6개">6개</option>
                                                    <option value="7개">7개</option>
                                                    <option value="8개">8개</option>
                                                    <option value="9개">9개</option>
                                                    <option value="10개">10개</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>보기 입력</th>
                                        <td>
											<div class="checkbox_type mb5">
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType1">
													<label for="checkType1">보기 1</label>
												</span>
                                                <label for="checkType1Ans"><input class="form-control width-50per" type="text" name="name" id="checkType1Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
											</div>
											<div class="checkbox_type mb5">
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType2">
													<label for="checkType2">보기 2</label>
												</span>
                                                <label for="checkType2Ans"><input class="form-control width-50per" type="text" name="name" id="checkType2Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
											</div>
											<div class="checkbox_type mb5">
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType3">
													<label for="checkType3">보기 3</label>
												</span>
                                                <label for="checkType3Ans"><input class="form-control width-50per" type="text" name="name" id="checkType3Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
											</div>
											<div class="checkbox_type">
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType4">
													<label for="checkType4">보기 4</label>
												</span>
                                                <label for="checkType4Ans"><input class="form-control width-50per" type="text" name="name" id="checkType4Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4"></label>
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>난이도</th>
                                        <td>
											<div class="form-inline">
												<select class="form-select" id="" name="" required="true">
													<option value="">난이도 선택</option>
                                                    <option value="상관없음">상관없음</option>
                                                    <option value="상">상</option>
                                                    <option value="중">중</option>
                                                    <option value="하">하</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전체 정답처리</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>평가 문항</th>
                                        <td>
                                            <div class="rubrics_wrap">
                                                <div class="rub_write">
                                                    <div class="eval_item">
                                                        <div class="item">
                                                            <label class="label_num">1</label>
                                                            <input class="form-control wide" type="text" value="창의력" readonly>
                                                            <input class="form-control sm" type="text" value="30%" >
                                                            <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                                        </div>
                                                        <div class="item">
                                                            <label class="label_num">2</label>
                                                            <input class="form-control wide" type="text" value="문장력" readonly>
                                                            <input class="form-control sm" type="text" value="30%" >
                                                            <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                                        </div>
                                                        <div class="item">
                                                            <label class="label_num">3</label>
                                                            <input class="form-control wide" type="text" value="구성력" readonly>
                                                            <input class="form-control sm" type="text" value="30%" >
                                                            <button type="button" class="btn basic icon"><i class="xi-close"></i></button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="board_top mt10">
                                                <div class="right-area">
                                                    <button type="button" class="btn type1">문항 추가</button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>평가 등급</th>
                                        <td>
                                            <div class="rubrics_wrap">
                                                <div class="sub-box rub_grade pd0 bd0 mt0">
                                                    <div class="board_top">
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="evalType1" id="evalType1" value="5" checked="">
                                                                <label for="evalType1">5점 척도</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="evalType1" id="evalType2" value="3">
                                                                <label for="evalType2">3점 척도</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="evalType1" id="evalType3" value="10">
                                                                <label for="evalType3">자유척도</label>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="grade_item">
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="5" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="매우 잘 했어요">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="4" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="잘 했어요">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="3" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="보통입니다">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="2" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="노력하세요">
                                                        </div>
                                                        <div class="item">
                                                            <div class="input_btn">
                                                                <input class="form-control sm" id="gradeInput" type="text" value="1" autocomplete="off"><label>점</label>
                                                            </div>
                                                            <input class="form-control wide" type="text" value="더 노력하세요">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="board_top mt10">
                                                <div class="right-area">
                                                    <button type="button" class="btn type1">등급 추가</button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="msg-box basic">
                            <ul class="list-dot">
                                <li>출제완료 클릭 전에는 “임시저장” 상태입니다.</li>
                                <li>문항 출제 완료되면 “출제완료” 버튼을 반드시 클릭해 주세요.</li>
                            </ul>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn basic type1">문제 추가</button>
                            <button type="button" class="btn basic type2">출제 완료</button>
                        </div>

                    </div>

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" id="btn-prev-submit">문제 수정 옵션</button>
                    </div>
                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->

        <!-- Modal1 문제 수정 옵션 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="form-row">
                        <span class="custom-input">
                            <input type="radio" id="gradeReflect_yes" name="gradeReflect" value="Y" checked>
                            <label for="gradeReflect_yes">정답을 수정합니다.</label>
                        </span>
                    </div>
                    <div class="form-row">
                        <span class="custom-input">
                            <input type="radio" id="gradeReflect_no" name="gradeReflect" value="N">
                            <label for="gradeReflect_no">모두 정답 처리합니다.</label>
                        </span>
                    </div>
                    <div class="form-row">
                        <span class="custom-input">
                            <input type="radio" id="gradeReflect_no" name="gradeReflect" value="N">
                            <label for="gradeReflect_no">문제, 정답을 모두 수정합니다.</label>
                        </span>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">확인</button>
                        <button type="button" class="btn type2">취소</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 문제 수정 옵션 -->

        <script>
            $(function() {
                // 1. 문제 수정 옵션 다이얼로그
                $('#btn-prev-submit').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "문제 수정 옵션",
                        width: 600,
                        height: 250,
                        html: $content
                    });
                });
            });
        </script>

    </div>
</body>
</html>