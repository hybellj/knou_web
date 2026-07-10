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
                                    <li><span class="current">과제</span></li>
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
                                <li class="select"><a href="#0">퀴즈정보 및 평가</a></li>
                                <li><a href="#">문항관리</a></li>
                                <li><a href="#">재응시 관리</a></li>
                            </ul>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">퀴즈정보 및 퀴즈평가</h3>
                            <div class="right-area">
                                <button type="button" class="btn type1 big">수정</button>  
                                <button type="button" class="btn type2 big">삭제</button>  
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
                                                    <th>토론내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
                                                            </textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>참여기간</th>
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
                                                    <th>팀토론</th>
                                                    <td colspan="3">예<br>학습그룹 : 토론 학습그룹 002<br>학습그룹별 토론 설정 : 사용
                                                        <div class="table-wrap mt10">
                                                            <table class="table-type5 in_table">
                                                                <colgroup>
                                                                    <col class="width-5per">
                                                                    <col class="width-15per">
                                                                    <col>
                                                                </colgroup>
                                                                <tbody>                                                            
                                                                    <tr>
                                                                        <th rowspan="4" class="group-header"><label for="viewOption">1팀</label></th>
                                                                        <th><label>학습그룹 구성원</label></th>
                                                                        <td>
                                                                            홍팀장1 외 11명
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="sub_topic">부주제</label></th>
                                                                        <td>부주제 제목입니다.</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="contTextarea">내용</label></th>
                                                                        <td>
                                                                            <label class="width-100per"><textarea rows="4" class="form-control resize-none">내용입니다.

                                                                            </textarea></label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            <div class="add_file_list">                              
                                                                                <ul class="add_file">
                                                                                    <li>
                                                                                        <a href="#" class="file_down">
                                                                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                                            <span class="text">154873973477000.jpg</span>
                                                                                            <span class="fileSize">(6KB)</span>
                                                                                        </a>                                        
                                                                                    </li>
                                                                                </ul>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th rowspan="4" class="group-header"><label for="viewOption">2팀</label></th>
                                                                        <th><label>학습그룹 구성원</label></th>
                                                                        <td>
                                                                            홍팀장1 외 11명
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="sub_topic">부주제</label></th>
                                                                        <td>
                                                                            <div class="form-row">
                                                                                <input class="form-control width-100per" type="text" name="name" id="sub_topic" value="" placeholder="주제 입력" autocomplete="off">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="contTextarea">내용</label></th>
                                                                        <td>
                                                                            <label class="width-100per"><textarea rows="4" class="form-control resize-none"></textarea></label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            첨부파일
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>참여글 보기 옵션</th>
                                                    <td colspan="3">사용 안함</td>
                                                </tr>
                                                <tr>
                                                    <th>댓글 답변요청</th>
                                                    <td colspan="3">아니오</td>
                                                </tr>
                                                <tr>
                                                    <th>찬반 토론으로 설정</th>
                                                    <td colspan="3">
                                                        예<br>
                                                        찬반 비율 공개 : 예<br>
                                                        작성자 공개 : 예<br>
                                                        의견 글 복수 등록 : 아니오<br>
                                                        찬반 의견 변경가능 : 아니오
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

                        <div class="board_top mb0">
                            <h4 class="sub-title">토론평가</h4>
                            <div class="right-area">
                                <button type="button" class="btn type2">엑셀로 성적등록</button>
                                <button type="button" class="btn basic">메시지 보내기</button>
                            </div>
                        </div>

                        
                        <div class="board_top in_table">
                            <select class="form-select" id="participationStatus">
                                <option value="참여여부">참여여부</option>
                                <option value="전체">전체</option>
                            </select>
                            <select class="form-select" id="evaluationStatus">
                                <option value="평가여부">평가여부</option>
                                <option value="전체">전체</option>
                            </select>
                            <!-- search small -->
                            <div class="search-typeC">
                                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                            </div>
                            <button type="button" class="btn search">수강생 전체</button>
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
                                        <th><label for="scoreInputMode">일괄 성적처리</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="scoreInputMode" id="scoreInputModeRegister" value="DEPT" checked>
                                                    <label for="scoreInputModeRegister">점수 등록</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="scoreInputMode" id="scoreInputModeAdjust" value="MANAGER">
                                                    <label for="scoreInputModeAdjust">점수 가감</label>
                                                </span>
                                                <div class="custom-txt">
                                                    <span class="tit">점수 :</span>
                                                    <label><i class="xi-plus"></i></label>
                                                    <div class="input_btn">
                                                        <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1">
                                                        <label for="bulkScoreValue">점</label>
                                                    </div>
                                                </div>

                                                <button type="button" class="btn type1">저장</button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        
                        <div class="board_top">
                            <div class="right-area">
                                <button type="button" class="btn basic">시험지 일괄 인쇄</button>
                                <button type="button" class="btn basic">시험지 일괄 엑셀로 다운로드</button>
                                <button type="button" class="btn basic">엑셀로 다운로드</button>
                                <button type="button" class="btn type2">응시현황 그래프</button>
                            </div>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:4%">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col class="width-25per">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>학과</th>
                                        <th>대표아이디</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>퀴즈점수</th>
                                        <th>평가점수</th>
                                        <th>응시상태</th>
                                        <th>응시횟수</th>
                                        <th>평가여부</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">201***78</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="퀴즈점수">
                                            <a href="#0">90</a>
                                        </td>
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="응시상태"><span class="fcPro">미응시</span></td>
                                        <td data-th="응시횟수">0회</td>
                                        <td data-th="평가여부"><span class="fcRed">N</span></td>
                                        <td data-th="관리">
                                            <button class="btn basic small">퀴즈초기화</button>
                                            <button class="btn basic small">시험지보기</button>
                                            <button class="btn basic small">응시기록</button>
                                            <button class="btn basic small">메모</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">201***78</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="퀴즈점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td> 
                                        <td data-th="응시상태"><span class="fcPro">미응시</span></td>
                                        <td data-th="응시횟수">0회</td>
                                        <td data-th="평가여부"><span class="fcRed">N</span></td>
                                        <td data-th="관리">
                                            <button class="btn basic small">퀴즈초기화</button>
                                            <button class="btn basic small">시험지보기</button>
                                            <button class="btn basic small">응시기록</button>
                                            <button class="btn basic small">메모</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" id="btn-prev-submit">시험지 보기</button>
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->                    

                </div>
            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

        <!-- Modal1 시험지 보기 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">



                    <div class="board_top class">
                        <button type="button" class="btn type2"><i class="xi-angle-left-min"></i>이전</button>
                        <button type="button" class="btn type2">다음<i class="xi-angle-right-min"></i></button>
                        <div class="right-area">
                            <div class="feedback-info">
                                <p class="desc">
                                    <span><strong>컴퓨터공학과</strong></span>
                                    <span><strong>9021582</strong></span>
                                    <span><strong>김주미</strong></span>
                                    <span class="score"><strong>65점</strong></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="quiz_paper_wrap">
                        <div class="listTab flex align-items-center">
                            <ul>
                                <li><a href="#0">TEAM 1</a></li>
                                <li class="select"><a href="#0">TEAM 2</a></li>
                                <li><a href="#0">TEAM 3</a></li>
                            </ul>
                            <div class="listPage width-15per text-right">1/2 페이지</div>
                        </div>

                        <div class="board_top">
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

                            <div class="right-area">
                                <button type="button" class="btn basic">시험지 인쇄</button>  
                                <button type="button" class="btn type1">점수 저장</button>  
                                <button type="button" class="btn type2">취소</button>  
                            </div>
                        </div>

                        <div class="course_history bd0">
                            <div class="question_area pd0">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <p class="flex-none mr15"><b>문제1</b></p>
                                            <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q_result correct">
                                                <i class="xi-radiobox-blank icon"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="q_cont">
                                        <ol class="q_cont_ans">
                                            <li>
                                                <input type="radio" name="q2_ans" id="q1_ans2">
                                                <label for="q1_ans1"><span class="ansNum">1</span>나무</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans2">
                                                <label for="q1_ans2"><span class="ansNum">2</span>돌</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans3" checked>
                                                <label for="q1_ans3"><span class="ansNum">3</span>바다</label>
                                            </li>
                                            <li>
                                                <input type="radio" name="q2_ans" id="q2_ans4">
                                                <label for="q1_ans4"><span class="ansNum">4</span>산</label>
                                            </li>
                                        </ol>
                                    </div>

                                    <div class="ans_cont">
                                        <div class="board_top align-items-center">
                                            <ol class="ans_cont_list">
                                                <li>정답<span>3</span></li>
                                                <li>배점<span>20</span></li>
                                                <li>난이도<span>상</span></li>
                                                <li class="ans_list_score">
                                                    점수
                                                    <span>
                                                        <div class="input_btn">
                                                            <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1" value="20">
                                                            <label for="bulkScoreValue">점</label>
                                                        </div>
                                                    </span>
                                                </li>
                                            </ol>
                                            <div class="right-area">
                                                <button type="button" class="btn basic" id="btn-quiz-stats">결과 통계 보기<i class="icon-svg-arrow-down"></i></button>
                                            </div>
                                        </div>
                        <div class="scoreChart_wrap">
                            <div class="flex">
                                <div class="left_chart">
                                    <div class="chart-container" style="height: 250px;">
                                        <canvas id="pieChart"></canvas>
                                    </div>
                                </div>
                                <div class="right_chart">
                                    <div class="chart-container" style="height: 250px;">
                                        <canvas id="barChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

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
                                            <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                            <div class="q_result incorrect">
                                                <i class="xi-close icon"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="q_cont">
                                        <ol class="q_cont_ans">
                                            <li>
                                                <input type="radio" name="q1_ans" id="q1_ans1" checked>
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

                                    <div class="ans_cont">
                                        <div class="board_top align-items-center">
                                            <ol class="ans_cont_list">
                                                <li>정답<span>2</span></li>
                                                <li>배점<span>20</span></li>
                                                <li>난이도<span>상</span></li>
                                                <li class="ans_list_score">
                                                    점수
                                                    <span>
                                                        <div class="input_btn">
                                                            <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1" value="20">
                                                            <label for="bulkScoreValue">점</label>
                                                        </div>
                                                    </span>
                                                </li>
                                            </ol>
                                            <div class="right-area">
                                                <button type="button" class="btn basic" id="btn-quiz-stats">결과 통계 보기<i class="icon-svg-arrow-down"></i></button>
                                            </div>
                                        </div>
                        <div class="scoreChart_wrap">
                            <div class="flex">
                                <div class="left_chart">
                                    <div class="chart-container" style="height: 250px;">
                                        <canvas id="pieChart"></canvas>
                                    </div>
                                </div>
                                <div class="right_chart">
                                    <div class="chart-container" style="height: 250px;">
                                        <canvas id="barChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                                    </div>


                                </div>
                            </div>
                        </div>

                    </div>


                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div>
        <!-- //Modal1 시험지 보기 -->

        <script>
            // 차트 다크모드 색상 헬퍼 (body.darkmode 토글 시 자동 반영)
            (function(){
                if (window._chartDarkmodeReady) return;
                window._chartDarkmodeReady = true;
                window.chartInstances = window.chartInstances || [];
                window.getChartColors = function(){
                    const dark = document.body.classList.contains('darkmode');
                    const styles = getComputedStyle(document.body);
                    return {
                        text:  dark ? (styles.getPropertyValue('--surface-text').trim()  || '#fff')      : '#666',
                        title: dark ? (styles.getPropertyValue('--surface-text').trim()  || '#fff')      : '#333',
                        line:  dark ? (styles.getPropertyValue('--surface-border').trim() || '#e7e7e740') : '#eee'
                    };
                };
                window.refreshChartTheme = function(){
                    const c = window.getChartColors();
                    window.chartInstances.forEach(function(entry){
                        const chart = entry && entry.chart;
                        if (!chart || !chart.options) return;
                        const opts = chart.options;
                        if (opts.plugins && opts.plugins.title) opts.plugins.title.color = c.title;
                        if (opts.plugins && opts.plugins.legend && opts.plugins.legend.labels) opts.plugins.legend.labels.color = c.text;
                        if (opts.plugins && opts.plugins.datalabels && !entry.keepDataLabelColor) opts.plugins.datalabels.color = c.text;
                        ['x','y'].forEach(function(ax){
                            const s = opts.scales && opts.scales[ax];
                            if (!s) return;
                            if (s.ticks) s.ticks.color = c.text;
                            if (s.grid)  s.grid.color  = c.line;
                            if (s.title) s.title.color = c.text;
                        });
                        if (typeof entry.onUpdate === 'function') entry.onUpdate(c, chart);
                        chart.update();
                    });
                };
                new MutationObserver(function(){ window.refreshChartTheme(); })
                    .observe(document.body, { attributes: true, attributeFilter: ['class'] });
            })();

            $(function() {
                const _pieColors = window.getChartColors();
                const pieConfig = {
                    type: 'pie',
                    data: {
                        labels: ['정답', '오답'],
                        datasets: [{
                            data: [35, 15],
                            backgroundColor: ['rgba(54, 162, 235, .8)', 'rgba(255, 99, 132, .8)'],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom', labels: { color: _pieColors.text } },
                            title: { display: true, text: '정답 비율 (%)', font: { size: 16 }, color: _pieColors.title },
                            datalabels: {
                                color: '#fff', // 파이 조각 위 라벨은 흰색 고정
                                font: { weight: 'bold', size: 11 },
                                formatter: (value, context) => {
                                    const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                                    return (value / total * 100).toFixed(1) + '%';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                };

                const _barColors = window.getChartColors();
                const barConfig = {
                    type: 'bar',
                    data: {
                        labels: ['평균점수', '최고점수', '최저점수'],
                        datasets: [{
                            data: [70, 95, 28],
                            backgroundColor: ['rgba(75, 192, 192, .6)', 'rgba(54, 162, 235, .6)', 'rgba(255, 99, 132, .6)'],
                            borderWidth: 1,
                            barThickness: 30
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            title: { display: true, text: '보기 분포 현황(%)', font: { size: 16 }, color: _barColors.title },
                            datalabels: { anchor: 'end', align: 'top', color: _barColors.text, font: { weight: 'bold', size: 11 } }
                        },
                        scales: {
                            y: {
                                ticks: { color: _barColors.text, stepSize: 20 },
                                title: { display: true, text: '점수', color: _barColors.text },
                                grid: { color: _barColors.line },
                                beginAtZero: true, max: 100
                            },
                            x: {
                                ticks: { color: _barColors.text },
                                grid: { color: _barColors.line }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                };

                // 1. 시험지 보기 다이얼로그
                $('#btn-prev-submit').on('click', function() {
                    var $content = $('#modal1 .modal-body');
                    const dialogId = "quizView";
                    const dialog = UiDialog(dialogId, {
                        title: "시험지 보기",
                        width: 1200,
                        height: 850,
                        html: $content
                    });

                    // 다이얼로그 내부 요소 셀렉터 (복제된 DOM 내에서 찾기 위해 dialog context 사용)
                    const $dialogBody = $('#UI_DIALOG_' + dialogId);
                    const $statsBtn = $dialogBody.find('#btn-quiz-stats');
                    const $chartWrap = $dialogBody.find('.scoreChart_wrap');
                    
                    let pieChartInstance = null;
                    let barChartInstance = null;

                    // 결과 통계 보기 토글 이벤트
                    $statsBtn.on('click', function() {
                        const isVisible = $chartWrap.is(':visible');
                        
                        // 클래스 교체 대신 open 클래스 토글로 회전 처리
                        $(this).find('i').toggleClass('open');

                        if (isVisible) {
                            $chartWrap.hide();
                        } else {
                            $chartWrap.show();
                            
                            // 차트가 아직 생성되지 않았을 때만 초기화하여 충돌 방지
                            if (!pieChartInstance) {
                                const pieCtx = $dialogBody.find('#pieChart')[0].getContext('2d');
                                pieChartInstance = new Chart(pieCtx, pieConfig);
                                // 파이 조각 위 라벨은 흰색 유지(keepDataLabelColor)
                                window.chartInstances.push({ chart: pieChartInstance, keepDataLabelColor: true });
                            }
                            if (!barChartInstance) {
                                const barCtx = $dialogBody.find('#barChart')[0].getContext('2d');
                                barChartInstance = new Chart(barCtx, barConfig);
                                window.chartInstances.push({ chart: barChartInstance });
                            }
                            // 다크모드 상태에서 열렸을 경우 현재 테마 즉시 반영
                            window.refreshChartTheme();
                        }
                    });
                });
            });
        </script>
    </div>

</body>
</html>
