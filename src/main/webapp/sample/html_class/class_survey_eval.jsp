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
                            <h2 class="page-title">설문</h2>
                        </div>
                        
                        <div class="listTab">
                            <ul>
                                <li class="select"><a href="#0">설문정보 및 평가</a></li>
                                <li><a href="#">문항관리</a></li>
                            </ul>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">설문정보 및 설문평가</h3>
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
                            <h4 class="sub-title">설문평가</h4>
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
                                    <col style="width:8%">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="">
                                    <col style="width: 12%;">
                                    <col style="">
                                    <col class="width-15per">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>팀명</th>
                                        <th>학과</th>
                                        <th>대표아이디</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>역할</th>
                                        <th>평가점수</th>
                                        <th>참여상태</th>
                                        <th>참여일시</th>
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
                                        <td data-th="팀명">TEAM1</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">201***78</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="역할">팀장</td>
                                        <td data-th="평가점수">-</td>
                                        <td data-th="참여상태"><span class="fcRed">미참여</span></td>
                                        <td data-th="참여일시">-</td>
                                        <td data-th="평가여부"><span class="fcRed">N</span></td>
                                        <td data-th="관리">
                                            <button class="btn basic small">설문지보기</button>
                                            <button class="btn basic small">메모</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">4</td>
                                        <td data-th="팀명">TEAM1</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">201***78</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="역할">팀장</td>
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="참여상태"><span>참여완료</span></td>
                                        <td data-th="참여일시">2026.08.12.25 16:45</td>
                                        <td data-th="평가여부"><span>Y</span></td>
                                        <td data-th="관리">
                                            <button class="btn basic small">설문지보기</button>
                                            <button class="btn basic small">메모</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" id="btn-prev-submit">참여현황 그래프</button>
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->                    

                </div>
            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

        <!-- Modal1 참여현황 그래프 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">

                    <div class="quiz_paper_wrap">

                        <div class="course_history">
                            <div class="question_area">
                                <div class="scoreChart_wrap">

                                    <!-- chart.js -->
                                    <div class="left_chart">
                                        <div class="chart-container" style="height: 250px; position: relative; width: 100%;">
                                            <canvas id="pieChartSummary"></canvas>
                                        </div>
                                    </div>
                                    <div class="right_chart">
                                        <div class="chart-container" style="height: 250px; position: relative; width: 100%;">
                                            <canvas id="barChartSummary"></canvas>
                                        </div>
                                    </div>
                                    <!-- //chart.js -->
                                </div>

                            </div>
                        </div>

                        

                        <div class="course_history">
                            <div class="h_top">
                                <div class="h_left">
                                    <h4>1/2 페이지명 01</h4>
                                </div>
                            </div>

                            <div class="question_area ">
                                <div class="question_con">
                                    <div class="q_top">
                                        <div class="flex-item width-100per">
                                            <p class="flex-none mr15"><b>문제1-1</b></p>
                                            <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                        </div>
                                    </div>

                                    <div class="q_cont padding-top-5 padding-bottom-5">
                                        <div class="scoreChart_wrap align-items-center">
                                            <div class="left_chart">
                                                <ol class="list_rect">
                                                    <li><span class="bcYellow"></span>강아지</li>
                                                    <li><span class="bcOlive"></span>고양이</li>
                                                    <li><span class="bcTeal"></span>토끼</li>
                                                    <li><span class="bcViolet"></span>기타</li>
                                                </ol>
                                            </div>

                                            <!-- chart.js -->
                                             <div class="right_chart">
                                                <div class="chart-container" style="height: 250px; position: relative;">
                                                    <canvas id="doughnutSummary"></canvas>
                                                </div>
                                             </div>
                                            <!-- //chart.js -->

                                        </div>
                                    </div>
                                </div>
                                <div class="question_con">
                                    <div class="q_top">
                                             <div class="width-100per tar">
                                            <p class="flex-none mr15"><b>문제1-1</b></p>
                                            <div class="flex-1 tal">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</div>
                                        </div>
                                    </div>

                                    <div class="q_cont padding-top-5 padding-bottom-5">
                                        <div class="scoreChart_wrap align-items-center">
                                            <div class="left_chart">
                                                <ol class="list_rect">
                                                    <li><span class="bcYellow"></span>강아지</li>
                                                    <li><span class="bcOlive"></span>고양이</li>
                                                    <li><span class="bcTeal"></span>토끼</li>
                                                    <li><span class="bcViolet"></span>기타</li>
                                                </ol>
                                            </div>

                                            <!-- chart.js -->
                                             <div class="right_chart">
                                                <div class="chart-container" style="height: 250px; position: relative;">
                                                    <canvas id="doughnutSummary2"></canvas>
                                                </div>
                                             </div>
                                            <!-- //chart.js -->

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
        <!-- //Modal1 참여현황 그래프 -->


        <script>
            $(function() {
                // 참여현황 차트 설정
                const pieConfig = {
                    type: 'pie',
                    data: {
                        labels: ['응답자', '미응답자'],
                        datasets: [{
                            data: [45, 5],
                            backgroundColor: ['rgba(54, 162, 235, .8)', 'rgba(255, 99, 132, .8)'],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' },
                            title: { display: true, text: '참여현황 (%)', font: { size: 16 }, color: '#333' },
                            datalabels: {
                                color: '#fff',
                                font: { weight: 'bold', size: 14 },
                                formatter: (value, context) => {
                                    const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                                    return (value / total * 100).toFixed(1) + '%';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                };

                // 접속환경 차트 설정
                const pieConfig2 = {
                    type: 'pie',
                    data: {
                        labels: ['PC', 'Mobile'],
                        datasets: [{
                            data: [30, 20],
                            backgroundColor: ['rgba(54, 162, 235, .8)', 'rgba(255, 99, 132, .8)'],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' },
                            title: { display: true, text: '접속환경 (%)', font: { size: 16 }, color: '#333' },
                            datalabels: {
                                color: '#fff',
                                font: { weight: 'bold', size: 14 },
                                formatter: (value, context) => {
                                    const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                                    return (value / total * 100).toFixed(1) + '%';
                                }
                            }
                        }
                    },
                    plugins: [ChartDataLabels]
                };

                // 문제영역(도넛) 차트 설정
                const getColorsFromMarkup = () => {
                    const legendSpans = document.querySelectorAll('.list_rect li span');
                    return Array.from(legendSpans).map(span => {
                        return window.getComputedStyle(span).backgroundColor;
                    });
                };

                const extractedColors = getColorsFromMarkup();

                const doughnutConfig = {
                    type: 'doughnut',
                    data: {
                        labels: ['40명', '30명', '20명', '10명'],
                        datasets: [{
                            data: [40, 30, 20, 10],
                            backgroundColor:extractedColors,
                            borderWidth: 1
                        }]
                    },
        options: {
            responsive: true,
            maintainAspectRatio: false,

            plugins: {
                legend: { 
                    position:'bottom',
                    labels: {
                        usePointStyle: true,
                        pointStyle: 'rect',

                    font: {
                            size: 16,
                        },                
                    },
                },
                title: { 
                    display: false, 
                },
                datalabels: {
                    color: '#fff',
                    font: { weight: 'bold', size: 14 },
                    formatter: (value, context) => {
                        const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                        return (value / total * 100).toFixed(1) + '%';
                    }
                }
            }
        },
                    plugins: [ChartDataLabels]
                };


                // 문제영역(도넛) 차트 설정
                const doughnutConfig2 = {
                    type: 'doughnut',
                    data: {
                        labels: ['10명', '20명', '30명', '40명'],
                        datasets: [{
                            data: [10, 20, 30, 40],
                            backgroundColor:extractedColors,
                            borderWidth: 1
                        }]
                    },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { 
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        pointStyle: 'rect',
                    font: {
                            size: 16,
                        },                
                    },
                },
                title: { 
                    display: false, 
                },
                datalabels: {
                    color: '#fff',
                    font: { weight: 'bold', size: 14 },
                    formatter: (value, context) => {
                        const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                        return (value / total * 100).toFixed(1) + '%';
                    }
                }
            }
        },
                    plugins: [ChartDataLabels]
                };


                // 다이얼로그 이벤트
                $('#btn-prev-submit').on('click', function() {
                    var $content = $('#modal1 .modal-body');
                    const dialogId = "quizView";
                    const dialog = UiDialog(dialogId, {
                        title: "참여현황 그래프",
                        width: '60%',
                        height: 850,
                        html: $content
                    });

                    const $dialogBody = $('#UI_DIALOG_' + dialogId);
                    
                    // 다이얼로그 렌더링 후 차트 초기화
                    setTimeout(function() {
                        const $pieSummary = $dialogBody.find('#pieChartSummary');
                        const $barSummary = $dialogBody.find('#barChartSummary');
                        const $doughnutSummary = $dialogBody.find('#doughnutSummary');
                        const $doughnutSummary2 = $dialogBody.find('#doughnutSummary2');

                        // 참여현황 차트
                        if ($pieSummary.length && !Chart.getChart($pieSummary[0])) {
                            new Chart($pieSummary[0].getContext('2d'), pieConfig);
                        }
                        
                        // 접속환경 차트
                        if ($barSummary.length && !Chart.getChart($barSummary[0])) {
                            new Chart($barSummary[0].getContext('2d'), pieConfig2);
                        }
                        
                        // 문제영역(도넛) 차트
                        if ($doughnutSummary.length && !Chart.getChart($doughnutSummary[0])) {
                            new Chart($doughnutSummary[0].getContext('2d'), doughnutConfig);
                        }
                        // 문제영역(도넛) 차트
                        if ($doughnutSummary2.length && !Chart.getChart($doughnutSummary2[0])) {
                            new Chart($doughnutSummary2[0].getContext('2d'), doughnutConfig2);
                        }
                    }, 300);
                });
            });
        </script>

    </div>

</body>
</html>
