<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="chart"/>
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

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">성적관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li><span class="current">성적관리</span></li>
                                </ul>
                            </div>
                        </div>

                       
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
                                    </select>
                                    <select class="form-select" id="selectMajor">
                                        <option value="">학과</option>
                                        <option value="운영과목1">국어국문학과</option>
                                        <option value="운영과목2">회계트랙</option>
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">운영과목</option>
                                        <option value="과목1">과목1</option>
                                        <option value="과목2">과목2</option>
                                    </select>
                                </div>
                            </div>                            
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>                       

                        <div class="board_top">
                            <h3 class="board-title">운영과목</h3>                            
                        </div>

                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:5%">
                                    <col style="width:8%">
                                    <col style="width:14%">
                                    <col style="width:8%">
                                    <col style="">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:7%">
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>기관</th>
                                        <th>학과</th>
                                        <th>과목코드</th>
                                        <th>과목명</th>
                                        <th>분반</th>                                        
                                        <th>학점</th>
                                        <th>공동교수</th>
                                        <th>튜터</th>
                                        <th>조교</th>                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="과목코드">CM0005</td>
                                        <td data-th="과목명">고전문학심화</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="학점">3</td>
                                        <td data-th="공동교수">홍길동</td>
                                        <td data-th="튜터">이튜터</td>
                                        <td data-th="조교">김조교</td>                                        
                                    </tr>
                                    <tr>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="과목코드">CM0005</td>
                                        <td data-th="과목명">데이터베이스의 이해 활용</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="학점">3</td>
                                        <td data-th="공동교수">-</td>
                                        <td data-th="튜터">이튜터</td>
                                        <td data-th="조교">김조교</td>                                        
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type2-->

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


                        <div class="msg-box warning mt20">
                            <p class="txt ct"><strong>성적처리기간 : </strong>2026.07.25 09:00 ~ 2026.09.25 23:59</p>
                        </div>

                        <div class="board_top t_line">
                            <h4 class="sub-title">성적처리</h4>    
                            <span class="info_inline"><small class="note2">성적처리 중 10분마다 자동 저장됩니다.</small></span>                     
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>                              
                                <button type="button" class="btn type2">상대평가</button>
                                <button type="button" class="btn type2">분반 성적 비교</button>
                                <button type="button" class="btn type8">평가점수 가져오기</button> 
                                <button type="button" class="btn type2">성적산출</button> 
                                <button type="button" class="btn type2">엑셀 다운로드</button>                             
                            </div>                         
                        </div>
                        <div class="board_top in_table">
                            <!-- search small -->
                            <div class="search-typeC">
                                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                            </div> 
                            <button type="button" class="btn basic"><i class="icon-svg-search"></i>중간 결시신청 [ 제출 : 2명, 승인 : 2명 ]</button>
                            <button type="button" class="btn basic"><i class="icon-svg-search"></i>기말 결시신청 [ 제출 : 2명, 승인 : 3명 ]</button>
                            <button type="button" class="btn basic"><i class="icon-svg-search"></i>미평가 [ 4명 ]</button>   
                            <div class="right-area">
                                <span class="total_txt">[ 대상인원 <b>50</b>명 ]</span>
                            </div>
                        </div>

                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:3%">
                                    <col style="">
                                    <col style="width:7%">
                                    <col style="width:5%">
                                    <col style="width:8%">
                                    <col style="width:8%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">
                                    <col style="width:5%">                                    
                                    <col style="width:4%">
                                    <col style="width:4%">
                                    <col style="width:4%">
                                    <col style="width:6%">
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>학과</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>중간고사<br>(15%)</th>
                                        <th>기말고사<br>(20%)</th>
                                        <th>세미나<br>(10%)</th>                                  
                                        <th>출석/강의<br>(30%)</th>
                                        <th>과제<br>(10%)</th>
                                        <th>토론<br>(5%)</th>
                                        <th>퀴즈<br>(5%)</th>
                                        <th>설문<br>(5%)</th>
                                        <th>산출<br>총점</th>  
                                        <th>가산<br>점수</th>  
                                        <th>기타<br>점수</th> 
                                        <th>최종<br>점수</th> 
                                        <th>상세정보</th>                                       
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="check_yet"><!--미평가항목 있으면 check_yet 추가-->
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">1</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="학번">9012587459</td>
                                        <td data-th="이름">학습자</td>                                      
                                        <td data-th="중간고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">><span class="fcBlue">17.80</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="-">><span class="fcBlue">18.20</span>
                                        </td>
                                        <td data-th="세미나"></td>
                                        <td data-th="출석/강의"></td>
                                        <td data-th="과제"></td>  
                                        <td data-th="토론"></td>                                      
                                        <td data-th="퀴즈"></td>
                                        <td data-th="설문"></td>
                                        <td data-th="산출총점"></td>
                                        <td data-th="가산점수">0</td>
                                        <td data-th="기타점수">0</td>                                      
                                        <td data-th="최종점수">
                                            <input class="t_num5 final" id="scoreInput" type="text" value="94.00">
                                        </td>
                                        <td data-th="상세정보"><button class="btn type3 small">상세</button></td>                                        
                                    </tr>  
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">2</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="학번">9012587459</td>
                                        <td data-th="이름">학습자</td>                                      
                                        <td data-th="중간고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">><span class="fcBlue">17.80</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="91">><span class="fcBlue">18.20</span>
                                        </td>
                                        <td data-th="세미나"></td>
                                        <td data-th="출석/강의"></td>
                                        <td data-th="과제"></td>  
                                        <td data-th="토론"></td>                                      
                                        <td data-th="퀴즈"></td>
                                        <td data-th="설문"></td>
                                        <td data-th="산출총점"></td>
                                        <td data-th="가산점수">0</td>
                                        <td data-th="기타점수">0</td>                                      
                                        <td data-th="최종점수">
                                            <input class="t_num5 final" id="scoreInput" type="text" value="94.00">
                                        </td>
                                        <td data-th="상세정보"><button class="btn type3 small">상세</button></td>                                        
                                    </tr>  
                                    <tr class="check_yet"><!--미평가항목 있으면 check_yet 추가-->
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">3</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="학번">9012587459</td>
                                        <td data-th="이름">학습자</td>                                      
                                        <td data-th="중간고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">><span class="fcBlue">17.80</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="-">><span class="fcBlue">18.20</span>
                                        </td>
                                        <td data-th="세미나"></td>
                                        <td data-th="출석/강의"></td>
                                        <td data-th="과제"></td>  
                                        <td data-th="토론"></td>                                      
                                        <td data-th="퀴즈"></td>
                                        <td data-th="설문"></td>
                                        <td data-th="산출총점"></td>
                                        <td data-th="가산점수">0</td>
                                        <td data-th="기타점수">0</td>                                      
                                        <td data-th="최종점수">
                                            <input class="t_num5 final" id="scoreInput" type="text" value="94.00">
                                        </td>
                                        <td data-th="상세정보"><button class="btn type3 small">상세</button></td>                                        
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">4</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="학번">9012587459</td>
                                        <td data-th="이름">학습자</td>                                      
                                        <td data-th="중간고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">><span class="fcBlue">17.80</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="100">><span class="fcBlue">18.20</span>
                                        </td>
                                        <td data-th="세미나"></td>
                                        <td data-th="출석/강의"></td>
                                        <td data-th="과제"></td>  
                                        <td data-th="토론"></td>                                      
                                        <td data-th="퀴즈"></td>
                                        <td data-th="설문"></td>
                                        <td data-th="산출총점"></td>
                                        <td data-th="가산점수">0</td>
                                        <td data-th="기타점수">0</td>                                      
                                        <td data-th="최종점수">
                                            <input class="t_num5 final" id="scoreInput" type="text" value="94.00">
                                        </td>
                                        <td data-th="상세정보"><button class="btn type3 small">상세</button></td>                                        
                                    </tr>   
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">문예창작콘텐츠학과</td>
                                        <td data-th="학번">9012587459</td>
                                        <td data-th="이름">학습자</td>                                      
                                        <td data-th="중간고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">><span class="fcBlue">17.80</span>
                                        </td>
                                        <td data-th="기말고사">
                                            <input class="t_num3" id="scoreInput" type="text" value="91">><span class="fcBlue">18.20</span>
                                        </td>
                                        <td data-th="세미나"></td>
                                        <td data-th="출석/강의"></td>
                                        <td data-th="과제"></td>  
                                        <td data-th="토론"></td>                                      
                                        <td data-th="퀴즈"></td>
                                        <td data-th="설문"></td>
                                        <td data-th="산출총점"></td>
                                        <td data-th="가산점수">0</td>
                                        <td data-th="기타점수">0</td>                                      
                                        <td data-th="최종점수">
                                            <input class="t_num5 final" id="scoreInput" type="text" value="94.00">
                                        </td>
                                        <td data-th="상세정보"><button class="btn type3 small">상세</button></td>                                        
                                    </tr>  
                                                                     
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type2-->

                        <div class="board_top">
                            <h4 class="sub-title">성적 등급 분포도 : 전체</h4> 
                            <span class="info_inline">
                                <select class="form-select" id="selectDate1">
                                    <option value="전체">전체</option>
                                    <option value="중간고사">중간고사</option>
                                    <option value="기말고사">기말고사</option>
                                    <option value="세미나">세미나</option>
                                </select>
                            </span>
                            <div class="right-area">
                                <span class="total_txt">[ 대상인원 <b>50</b>명 ]</span>
                            </div>
                        </div>
                        <div class="sub-box">
                            <div class="scoreChart_wrap">
                                <div class="left_chart">
                                    <div class="chart-container" style="height: 350px;">
                                        <canvas id="scoreChart"></canvas>
                                    </div>

                                    <script>
                                    // 점수 구간
                                    const scoreLabels = [
                                        "0.00~9.99", "10.00~19.99", "20.00~29.99", "30.00~39.99",
                                        "40.00~49.99", "50.00~59.99", "60.00~69.99", "70.00~79.99",
                                        "80.00~89.99", "90.00~100.00"
                                    ];

                                    // 예시 데이터 (각 구간별 인원 수)
                                    const scoreData = [2, 5, 8, 12, 15, 30, 14, 10, 9, 7];

                                    // 총합 계산
                                    const total = scoreData.reduce((a, b) => a + b, 0);

                                    // 퍼센트 계산
                                    const percentageData = scoreData.map(n => ((n / total) * 100).toFixed(1));

                                    new Chart(document.getElementById('scoreChart'), {
                                        type: 'bar',
                                        data: {
                                            labels: scoreLabels,
                                            datasets: [{
                                                label: '인원수',
                                                data: scoreData,
                                                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                                                borderColor: 'rgba(54, 162, 235, 1)',
                                                borderWidth: 1,
                                                barThickness: 18
                                            }]
                                        },
                                        options: {
                                            indexAxis: 'y', // 가로 막대
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: { display: false },
                                                title: {
                                                    display: true,
                                                    text: '성적분포도비율(%)',
                                                    font: { size: 16 },
                                                    color: '#222'
                                                },
                                                tooltip: {
                                                    callbacks: {
                                                        label: function(context) {
                                                            const count = context.raw;
                                                            const percent = ((count / total) * 100).toFixed(1);
                                                            return count + '명 (' + percent + '%)';
                                                        }
                                                    }
                                                },
                                                // 막대 옆 데이터 라벨 표시
                                                datalabels: {
                                                    display: true,
                                                    anchor: 'end',        // 막대 끝에 붙이기
                                                    align: 'right',       // 오른쪽으로 정렬
                                                    formatter: (value) => {
                                                        const percent = ((value / total) * 100).toFixed(1);
                                                        return value + '명 (' + percent + '%)';
                                                    },
                                                    color: '#333',
                                                    font: { weight: 'bold', size: 12 }
                                                }
                                            },
                                            scales: {
                                                x: {
                                                    beginAtZero: true,
                                                    max: Math.max(...scoreData) * 1.2, // 막대 끝에 라벨 공간 확보
                                                    ticks: { color: '#333' },
                                                    title: { display: false, text: '인원수' },
                                                    grid: { color: '#eee' }
                                                },
                                                y: {
                                                    reverse: true,
                                                    ticks: { color: '#333', font: { size: 12 } },
                                                    title: { display: true, text: '점수 구간' }
                                                }
                                            }
                                        },
                                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
                                    });
                                    </script>                                                                    

                                </div>
                                <div class="right_chart">
                                    <div class="chart_txt">
                                        <div class="table_list">
                                            <ul class="list">
                                                <li class="head"><label>배점</label></li>
                                                <li data-th="배점">100</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>평균</label></li>
                                                <li data-th="평균">35.32</li>                               
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>상위10%평균</label></li>
                                                <li data-th="상위10%평균">69</li>                               
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>최고점</label></li>
                                                <li data-th="최고점">78</li>                               
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>최저점</label></li>
                                                <li data-th="최저점">20</li>                               
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>총응시자수</label></li>
                                                <li data-th="총응시자수">50</li>                               
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="chart_area">                                                   
                                        <div class="chart-container" style="height: 350px;">
                                            <canvas id="barChart"></canvas>
                                        </div>
                                        <script>
                                            const barUtils = ChartUtils.init();
                                            const BAR_COUNT = 4;
                                            const NUMBER_BAR = {
                                                count: BAR_COUNT,
                                                min: 0,
                                                max: 100
                                            };
                                            const BarLabels = ['평균', '상위10%평균', '최고점', '최저점'];
                                            const barData = {
                                                labels: BarLabels,
                                                datasets: [{
                                                    data: [70, 80, 95, 20],
                                                    backgroundColor: [                                               
                                                        'rgba(85, 154, 226, .8)',
                                                        'rgba(85, 154, 226, 1)',
                                                        'rgba(70, 130, 193, 1)',
                                                        'rgba(54, 112, 172, 1)'                                               
                                                    ],
                                                    borderWidth: 1,
                                                    barThickness: 30
                                                }]
                                            };
                                            const barConfig = {
                                                type: 'bar',
                                                data: barData,
                                                options: {
                                                    responsive: true,
                                                    maintainAspectRatio: false,
                                                    plugins: {
                                                        legend: { display: false },
                                                        title: {
                                                            display: true,
                                                            text: '성적분포현황',
                                                            font: { size: 16 },
                                                            color: '#222'
                                                        },
                                                    },
                                                    scales: {
                                                        y: {
                                                            ticks: { color: '#333', font: { size: 12 }, stepSize: 20 },
                                                            title: { display: true, text: '점수' }                                                          
                                                        },
                                                        x: {
                                                            ticks: { color: '#333', font: { size: 12 } },
                                                        }
                                                    }
                                                }
                                            };
                                            new Chart(document.getElementById('barChart'), barConfig);
                                        </script>
                                    </div>
                                </div>
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

