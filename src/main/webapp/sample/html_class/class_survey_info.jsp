<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
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
                <!-- class_sub_top -->
				<jsp:include page="../common/class_sub_top.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="../common/class_info.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
                    <!-- //class_info -->


                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">설문</h2>
                        </div>

                        <!-- 검색창 -->
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
                        <!-- //검색창 -->


                        <div class="board_top"> 
                            <h3 class="board-title">목록<span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>6</b>건 ]</span></h3>
                            <div class="right-area">
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="토론명 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" class="btn basic">성적반영비율조정</button>
                                <button type="button" class="btn type2">설문 등록</button>
                                <a href="#0" class="btn_list_type on" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col width="5%">
                                    <col width="5%">
                                    <col>
                                    <col width="20%">
                                    <col width="5%">
                                    <col width="5%">
                                    <col width="5%">   
                                    <col width="5%">   
                                    <col width="5%">
                                    <col width="15%">   
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>구분</th>
                                        <th>설문</th>
                                        <th>설문기간</th>
                                        <th>반영비율</th>
                                        <th>참여현황</th>
                                        <th>평가현황</th>
                                        <th>출제상태</th>
                                        <th>성적공개</th>
                                        <th>미리보기</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="구분">설문</td>
                                        <td data-th="설문" class="t_left">
                                            <a href="#" class="link">일반설문</a>
                                        </td>
                                        <td data-th="설문기간">2026.09.07 10:00 ~ 2026.09.23 22:00</td>
                                        <td data-th="반영비율">20%</td>
                                        <td data-th="참여현황">10/50</td>
                                        <td data-th="평가현황">10/50</td>
                                        <td data-th="출제상태">출제완료</td>
                                        <td data-th="성적공개">
                                            <div class="toggle-container">
                                                <input type="checkbox" id="toggle_label1" class="toggle-checkbox" checked>
                                                <label for="toggle_label1" class="toggle-label"></label>
                                            </div>                                            
                                        </td>
                                        <td data-th="미리보기">
                                            <button type="button" class="btn basic">미리보기</button>
                                            <button type="button" class="btn basic">알림보내기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="구분">설문 팀</td>
                                        <td data-th="설문" class="t_left">
                                            <a href="#" class="link">설문 팀 설문 팀 설문 팀</a>
                                        </td>
                                        <td data-th="설문기간">2026.09.07 10:00 ~ 2026.09.23 22:00</td>
                                        <td data-th="반영비율">20%</td>
                                        <td data-th="참여현황">10/50</td>
                                        <td data-th="평가현황">10/50</td>
                                        <td data-th="출제상태" class="fcRed">임시저장</td>
                                        <td data-th="성적공개">
                                            <div class="toggle-container">
                                                <input type="checkbox" id="toggle_label2" class="toggle-checkbox">
                                                <label for="toggle_label2" class="toggle-label"></label>
                                            </div>                                            
                                        </td>
                                        <td data-th="미리보기">
                                            <button type="button" class="btn basic">미리보기</button>
                                            <button type="button" class="btn basic">알림보내기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">4</td>
                                        <td data-th="구분">설문</td>
                                        <td data-th="설문" class="t_left">
                                            <a href="#" class="link">일반설문</a>
                                        </td>
                                        <td data-th="설문기간">2026.09.07 10:00 ~ 2026.09.23 22:00</td>
                                        <td data-th="반영비율">20%</td>
                                        <td data-th="참여현황">10/50</td>
                                        <td data-th="평가현황">10/50</td>
                                        <td data-th="출제상태">출제완료</td>
                                        <td data-th="성적공개">
                                            <div class="toggle-container">
                                                <input type="checkbox" id="toggle_label3" class="toggle-checkbox" checked>
                                                <label for="toggle_label3" class="toggle-label"></label>
                                            </div>                                            
                                        </td>
                                        <td data-th="미리보기">
                                            <button type="button" class="btn basic">미리보기</button>
                                            <button type="button" class="btn basic">알림보내기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">3</td>
                                        <td data-th="구분">설문</td>
                                        <td data-th="설문" class="t_left">
                                            <a href="#" class="link">일반설문</a>
                                        </td>
                                        <td data-th="설문기간">2026.09.07 10:00 ~ 2026.09.23 22:00</td>
                                        <td data-th="반영비율">20%</td>
                                        <td data-th="참여현황">10/50</td>
                                        <td data-th="평가현황">10/50</td>
                                        <td data-th="출제상태">출제완료</td>
                                        <td data-th="성적공개">
                                            <div class="toggle-container">
                                                <input type="checkbox" id="toggle_label" class="toggle-checkbox">
                                                <label for="toggle_label" class="toggle-label"></label>
                                            </div>                                            
                                        </td>
                                        <td data-th="미리보기">
                                            <button type="button" class="btn basic">미리보기</button>
                                            <button type="button" class="btn basic">알림보내기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">2</td>
                                        <td data-th="구분">설문</td>
                                        <td data-th="설문" class="t_left">
                                            <a href="#" class="link">일반설문</a>
                                        </td>
                                        <td data-th="설문기간">2026.09.07 10:00 ~ 2026.09.23 22:00</td>
                                        <td data-th="반영비율">20%</td>
                                        <td data-th="참여현황">10/50</td>
                                        <td data-th="평가현황">10/50</td>
                                        <td data-th="출제상태">출제완료</td>
                                        <td data-th="성적공개">
                                            <div class="toggle-container">
                                                <input type="checkbox" id="toggle_label" class="toggle-checkbox">
                                                <label for="toggle_label" class="toggle-label"></label>
                                            </div>                                            
                                        </td>
                                        <td data-th="미리보기">
                                            <button type="button" class="btn basic">미리보기</button>
                                            <button type="button" class="btn basic">알림보내기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">1</td>
                                        <td data-th="구분">설문</td>
                                        <td data-th="설문" class="t_left">
                                            <a href="#" class="link">일반설문</a>
                                        </td>
                                        <td data-th="설문기간">2026.09.07 10:00 ~ 2026.09.23 22:00</td>
                                        <td data-th="반영비율">20%</td>
                                        <td data-th="참여현황">10/50</td>
                                        <td data-th="평가현황">10/50</td>
                                        <td data-th="출제상태">출제완료</td>
                                        <td data-th="성적공개">
                                            <div class="toggle-container">
                                                <input type="checkbox" id="toggle_label" class="toggle-checkbox">
                                                <label for="toggle_label" class="toggle-label"></label>
                                            </div>                                            
                                        </td>
                                        <td data-th="미리보기">
                                            <button type="button" class="btn basic">미리보기</button>
                                            <button type="button" class="btn basic">알림보내기</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
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


                    </div>

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" id="btn_modal1">설문지 미리보기</button>
                    </div>
                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->


                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->


        <!-- Modal1 설문지 미리보기 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body pb20">
                       <div class="listTab flex align-items-center">
                            <ul>
                                <li><a href="#0">TEAM 1</a></li>
                                <li class="select"><a href="#0">TEAM 2</a></li>
                                <li><a href="#0">TEAM 3</a></li>
                            </ul>
                            <div class="listPage width-15per text-right">1/2 페이지</div>
                        </div>

                    <div class="course_history bd0">
                        <div class="question_area pd0">
                            <div class="question_con">
                                <div class="q_top">
                                    <div class="flex-item width-100per">
                                        <p class="flex-none mr15"><b>1-1</b></p>
                                        <div class="flex-1 tal">설문 문항 1</div>
                                    </div>
                                </div>
                                <div class="ans_cont">
                                    <ol class="ans_cont_survey_list">
                                        <li>
                                            <span class="custom-input">
                                                <input type="radio" name="serVeyRadio" id="serVeyRadio1" value="" checked>
                                                <label for="serVeyRadio1">강아지</label>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="custom-input">
                                                <input type="radio" name="serVeyRadio" id="serVeyRadio2" value="">
                                                <label for="serVeyRadio2">고양이</label>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="custom-input">
                                                <input type="radio" name="serVeyRadio" id="serVeyRadio3" value="">
                                                <label for="serVeyRadio3">토끼</label>
                                            </span>
                                        </li>
                                        <li>
                                            <div>
                                                <span class="custom-input">
                                                    <input type="radio" name="serVeyRadio" id="serVeyRadio4" value="">
                                                    <label for="serVeyRadio4">기타</label>
                                                </span>
                                                <span class="custon-input">
                                                    <label for="serVeyRadioInput">
                                                        <input class="form-control width-50per" type="text" name="name" id="serVeyRadioInput" value="" placeholder="" required="true" inputmask="byte" maxlen="10" minlen="4" autocomplete="off">
                                                    </label>
                                                </span>
                                            </div>
                                        </li>
                                    </ol>

                                </div>
                            </div>
                            
                            <div class="question_con">
                                <div class="q_top">
                                    <div class="flex-item width-100per">
                                        <p class="flex-none mr15"><b>1-2</b></p>
                                        <div class="flex-1 tal">설문 문항 2</div>
                                    </div>
                                </div>
                                <div class="ans_cont">
                                    <ol class="ans_cont_survey_list">
                                        <li>
                                            <span class="custom-input">
                                                <input type="checkbox" id="serVeychk1" value="" checked>
                                                <label for="serVeychk1">강아지</label>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="custom-input">
                                                <input type="checkbox" id="serVeychk2" value="">
                                                <label for="serVeychk2">고양이</label>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="custom-input">
                                                <input type="checkbox" id="serVeychk3" value="">
                                                <label for="serVeychk3">토끼</label>
                                            </span>
                                        </li>
                                        <li>
                                            <div>
                                                <span class="custom-input">
                                                    <input type="checkbox" id="serVeychk4" value="">
                                                    <label for="serVeychk4">기타</label>
                                                </span>
                                                <span class="custon-input">
                                                    <label for="serVeyChknput">
                                                        <input class="form-control width-50per" type="text" name="name" id="serVeyChknput" value="" placeholder="" required="true" inputmask="byte" maxlen="10" minlen="4" autocomplete="off">
                                                    </label>
                                                </span>
                                            </div>
                                        </li>
                                    </ol>
                                </div>
                            </div>

                            <div class="question_con">
                                <div class="q_top">
                                    <div class="flex-item width-100per">
                                        <p class="flex-none mr15"><b>1-3</b></p>
                                        <div class="flex-1 tal">설문 문항 3</div>
                                    </div>
                                </div>
                                <div class="ans_cont">
                                    <div class="table-wrap">
                                        <table class="table-type2">
                                            <colgroup>
                                                <col>
                                                <col style="width: 15%;">
                                                <col style="width: 15%;">
                                                <col style="width: 15%;">
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th>문항</th>
                                                    <th>그렇다</th>
                                                    <th>보통</th>
                                                    <th>아니다</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td data-th="문항" class="t_left">문항1</td>
                                                    <td data-th="그렇다">
                                                        <span class="custom-input">
                                                            <input type="radio" name="survey_q3_1" id="survey_q3_1_1" value="1">
                                                            <label for="survey_q3_1_1"></label>
                                                        </span>
                                                    </td>
                                                    <td data-th="보통">
                                                        <span class="custom-input">
                                                            <input type="radio" name="survey_q3_1" id="survey_q3_1_2" value="2">
                                                            <label for="survey_q3_1_2"></label>
                                                        </span>
                                                    </td>
                                                    <td data-th="아니다">
                                                        <span class="custom-input">
                                                            <input type="radio" name="survey_q3_1" id="survey_q3_1_3" value="3">
                                                            <label for="survey_q3_1_3"></label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td data-th="문항" class="t_left">문항2</td>
                                                    <td data-th="그렇다">
                                                        <span class="custom-input">
                                                            <input type="radio" name="survey_q3_2" id="survey_q3_2_1" value="1">
                                                            <label for="survey_q3_2_1"></label>
                                                        </span>
                                                    </td>
                                                    <td data-th="보통">
                                                        <span class="custom-input">
                                                            <input type="radio" name="survey_q3_2" id="survey_q3_2_2" value="2">
                                                            <label for="survey_q3_2_2"></label>
                                                        </span>
                                                    </td>
                                                    <td data-th="아니다">
                                                        <span class="custom-input">
                                                            <input type="radio" name="survey_q3_2" id="survey_q3_2_3" value="3">
                                                            <label for="survey_q3_2_3"></label>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="question_con">
                                <div class="q_top">
                                    <div class="flex-item width-100per">
                                        <p class="flex-none mr15"><b>1-4</b></p>
                                        <div class="flex-1 tal">설문 문항 4</div>
                                    </div>
                                </div>
                                <div class="ans_cont q_cont">
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
                                        <p class="flex-none mr15"><b>2-2</b></p>
                                        <div class="flex-1 tal">설문 문항 7</div>
                                    </div>
                                </div>
                                <div class="ans_cont">
                                    <div class="ans_cont_img">
                                        <img src="/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교">
                                    </div>

                                    <ol class="ans_cont_survey_list">
                                        <li>
                                            <span class="custom-input">
                                                <input type="radio" name="serVeyRadio2" id="serVeyRadio5" value="" checked>
                                                <label for="serVeyRadio5">강아지</label>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="custom-input">
                                                <input type="radio" name="serVeyRadio2" id="serVeyRadio6" value="">
                                                <label for="serVeyRadio6">고양이</label>
                                            </span>
                                        </li>
                                        <li>
                                            <span class="custom-input">
                                                <input type="radio" name="serVeyRadio2" id="serVeyRadio7" value="">
                                                <label for="serVeyRadio7">토끼</label>
                                            </span>
                                        </li>
                                        <li>
                                            <div>
                                                <span class="custom-input">
                                                    <input type="radio" name="serVeyRadio2" id="serVeyRadio8" value="">
                                                    <label for="serVeyRadio8">기타</label>
                                                </span>
                                                <span class="custon-input">
                                                    <label for="serVeyRadioInput2">
                                                        <input class="form-control width-100per" type="text" name="name" id="serVeyRadioInput2" value="" placeholder="" required="true" inputmask="byte" maxlen="10" minlen="4" autocomplete="off">
                                                    </label>
                                                </span>
                                            </div>
                                        </li>
                                    </ol>

                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">이전</button>
                        <button type="button" class="btn type1">제출하기</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 설문지 미리보기 -->

        <script>
            $(function() {
                $('#btn_modal1').on('click', function() {
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "설문지 미리보기",
                        width: '60%',
                        height: 800,
                        html: $content,
                    });
                });
            });
        </script>


    </div>

</body>
</html>
