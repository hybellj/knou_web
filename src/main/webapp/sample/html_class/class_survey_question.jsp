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
                            <h2 class="page-title">설문</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li><a href="./class_quiz_info.jsp">설문정보 및 평가</a></li>
                                <li class="select"><a href="#0">문항관리</a></li>
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
                                                    <th>설문내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다.
                                                            </textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>설문기간</th>
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
                                                    <td colspan="3">예</td>
                                                </tr>
                                                <tr>
                                                    <th>평가방법</th>
                                                    <td colspan="3">참여형<small class="note ml10">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small></td>
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
                                                    <th>팀 설문</th>
                                                    <td colspan="3">아니오</td>
                                                </tr>
                                            </tbody>
                                            </form>
                                        </table>
                                        <!-- //ul.table-list > table-type5 으로 변경(2026-04-29) -->



                                        <div class="table_list">
                                            <ul class="list">
                                                <li class="head"><label>설문내용</label></li>
                                                <li>
                                                    <div class="tb_content">
                                                        <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다.
설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다.
설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다. 설문내용입니다.
                                                        </textarea>
                                                    </div>
                                                </li>
                                            </ul>

                                            <ul class="list">
                                                <li class="head"><label>설문기간</label></li>
                                                <li>2026.09.30 10:00 ~ 2026.10.09 22:00</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>성적반영</label></li>
                                                <li>예</li>
                                                <li class="head"><label>성적반영비율</label></li>
                                                <li>25%</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>성적공개</label></li>
                                                <li>예</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>평가방법</label></li>
                                                <li>참여형 <small class="note ml10">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small></li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>파일 첨부</label></li>
                                                <li>
                                                    <div class="add_file_list">
                                                        <ul class="add_file">
                                                            <li>
                                                                <a href="#" class="file_down">
                                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                    <span class="text">첨부파일명마우스오버 시.doc</span>
                                                                    <span class="fileSize">(6KB)</span>
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a href="#" class="file_down">
                                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                    <span class="text">154873973477000.jpg</span>
                                                                    <span class="fileSize">(6KB)</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>팀 설문</label></li>
                                                <li>아니오</li>
                                            </ul>
                                        </div>

                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!--//accordion-->

                        <div class="board_top">
                            <h3 class="board-title">출제 문항 : 0 문제</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">페이지 추가</button>
                                <button type="button" class="btn basic">설문 가져오기</button>
                                <button type="button" class="btn basic type1">엑셀로 문항등록</button>
                            </div>
                        </div>

                        <!-- 출제 문항이 없습니다. -->
                        <div class="course_history mb20">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>문제 1</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small btn_add_question">문항 추가</button>
                                    <button type="button" class="btn basic small btn_add_question">페이지 수정</button>
                                    <button type="button" class="btn basic type2 small">페이지 삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <p class="text-center">출제 문항이 없습니다.</p>
                            </div>
                        </div>                         
                        <!-- //출제 문항이 없습니다. -->

                        

                        <!-- 문제1 -->
                        <div class="course_history mb20">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4><i class="xi-arrows m_handle mr10" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>문제 1</h4>
                                </div>
                                <div class="h_right">
                                    <button type="button" class="btn basic small btn_add_question">문항 추가</button>
                                    <button type="button" class="btn basic small btn_add_question">페이지 수정</button>
                                    <button type="button" class="btn basic type2 small">페이지 삭제</button>
                                </div>
                            </div>
                            <div class="question_area">
                                <div class="question_con">
                                    <div class="q_top bd0">
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
                                </div>

                                <div class="question_con">
                                    <div class="q_top bd0">
                                        <div class="flex-item width-100per">
                                            <div class="q-info-group">
                                                <button type="button" class="btn basic mr10 arrows-v flex-none"><i class="xi-arrows-v icon"></i></button>
                                                <p class="flex-none mr15"><b>1-2</b></p>
                                            </div>
                                            <div class="flex-1 tal q-content">문제입니다 문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다문제입니다ㄴ</div>
                                            <div class="q-ctrl-group">
                                                <p class="flex-none ml15 mr15">서술형</p>
                                                <button type="button" class="btn basic type2 small flex-none">삭제</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                            </div>
                        </div>                         
                        <!-- //문제1 -->


                        <div class="board_top ">
                            <h4 class="sub-title">문제 추가</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic type1">문제 저장</button>
                                <button type="button" class="btn basic type2">취소</button>
                            </div>                        </div>

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
											<div class="checkbox_type mb5" style="display: flex; align-items: center;">
												<span class="custom-input" style="width: 80px; flex-shrink: 0;">
													<label for="checkType1Ans">보기 1</label>
												</span>
                                                <div class="form-inline" style="flex: 1; display: flex; gap: 8px;">
                                                    <input class="form-control width-50per" type="text" name="name" id="checkType1Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
											</div>
											<div class="checkbox_type mb5" style="display: flex; align-items: center;">
												<span class="custom-input" style="width: 80px; flex-shrink: 0;">
													<label for="checkType2Ans">보기 2</label>
												</span>
                                                 <div class="form-inline" style="flex: 1; display: flex; gap: 8px;">
                                                    <input class="form-control width-50per" type="text" name="name" id="checkType2Ans" value="" placeholder="" required="true" inputmask="byte" maxLen="10" minLen="4">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
	   
                                            </div>
											<div class="checkbox_type mb5" style="display: flex; align-items: center;">
												<span class="custom-input" style="width: 80px; flex-shrink: 0;">
													<label>기타</label>
												</span>
                                                 <div class="form-inline" style="flex: 1; display: flex; gap: 8px;">
                                                    <select class="form-select" id="univ_label" name="univ_label" required="true">
                                                        <option value="">다음 페이지로 이동</option>
                                                    </select>
                                                </div>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th>필수선택</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>기타 보기</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>분기 선택</th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
                                            <small class="note2">! 한 페이지에 하나의 문항만 분기 가능합니다.</small>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2">정답 입력</th>
                                        <td>
                                            <div class="ansInputAddList">
                                                <span>정답 1</span>
                                                <div class="ans-input-wrap">
                                                    <label for="ans-input1-1"><input type="text" id="ans-input1-1"></label>
                                                    <label for="ans-input1-2"><input type="text" id="ans-input1-2"></label>
                                                    <label for="ans-input1-3"><input type="text" id="ans-input1-3"></label>
                                                    <label for="ans-input1-4"><input type="text" id="ans-input1-4"></label>
                                                    <label for="ans-input1-5"><input type="text" id="ans-input1-5"></label>
                                                </div>
                                                <div class="addBtn">
                                                    <button class="btn type2"><i class="xi-plus"></i></button>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="ansInputAddList">
                                                <span>정답 2</span>
                                                <div class="ans-input-wrap">
                                                    <label for="ans-input2-1"><input type="text" id="ans-input2-1"></label>
                                                    <label for="ans-input2-2"><input type="text" id="ans-input2-2"></label>
                                                    <label for="ans-input2-3"><input type="text" id="ans-input2-3"></label>
                                                    <label for="ans-input2-4"><input type="text" id="ans-input2-4"></label>
                                                    <label for="ans-input2-5"><input type="text" id="ans-input2-5"></label>
                                                </div>
                                                <div class="addBtn">
                                                    <button class="btn type2"><i class="xi-plus"></i></button>
                                                    <button class="btn type2"><i class="xi-minus"></i></button>
                                                </div>
                                            </div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>정답 입력</th>
                                        <td>
                                            <div class="ox_quiz justify-content-left">
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
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>정답 입력</th>
                                        <td>
                                            <div class="q_cont_ans matching_form">
                                            <ol class="matching_list">
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q1">
                                                            <span class="index">A</span>
                                                            <input type="text" id="match_q1" placeholder="보기 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a1">
                                                            <input type="text" id="match_a1" placeholder="정답 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q2">
                                                            <span class="index">B</span>
                                                            <input type="text" id="match_q2" placeholder="보기 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a2">
                                                            <input type="text" id="match_a2" placeholder="정답 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q3">
                                                            <span class="index">C</span>
                                                            <input type="text" id="match_q3" placeholder="보기 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a3">
                                                            <input type="text" id="match_a3" placeholder="정답 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                                <li class="matching_item">
                                                    <div class="q_box">
                                                        <label for="match_q4">
                                                            <span class="index">D</span>
                                                            <input type="text" id="match_q4" placeholder="보기 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                    <div class="a_box">
                                                        <label for="match_a4">
                                                            <input type="text" id="match_a4" placeholder="정답 입력" autocomplete="off">
                                                        </label>
                                                    </div>
                                                </li>
                                            </ol>
                                        </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th>정답 유형</th>
                                        <td>
                                            <div class="form-row">
                                                <span class="custom-input">
                                                    <input type="radio" name="ansType" id="ansType1" value="" checked>
                                                    <label for="ansType1">순서에 맞게 정답</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="radio" name="ansType" id="ansType2" value="">
                                                    <label for="ansType2">순서에 상관없이 정답</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>난이도</th>
                                        <td>
                                            <select class="form-select">
                                                <option value="상관없음">상관없음</option>
                                                <option value="상">상</option>
                                                <option value="중">중</option>
                                                <option value="하">하</option>
                                            </select>
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

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->
    </div>
</body>
</html>