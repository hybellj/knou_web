<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/home_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
			<jsp:include page="../common/home_gnb_prof.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <jsp:include page="../common/home_page_tab.jsp"/>
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
                                <span class="item_tit"><label for="selectDate">기관/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select chosen" id="selectDate1">
                                        <option value="전체">전체</option>
                                    </select>
                                    <select class="form-select chosen" id="selectDate2">
                                        <option value="년도/학기">년도/학기</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <div class="itemList">
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

                                    const _scoreColors = window.getChartColors();
                                    const scoreChartInstance = new Chart(document.getElementById('scoreChart'), {
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
                                                    color: _scoreColors.title
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
                                                    color: _scoreColors.text,
                                                    font: { weight: 'bold', size: 11 }
                                                }
                                            },
                                            scales: {
                                                x: {
                                                    beginAtZero: true,
                                                    max: Math.max(...scoreData) * 1.2, // 막대 끝에 라벨 공간 확보
                                                    ticks: { color: _scoreColors.text },
                                                    title: { display: false, text: '인원수' },
                                                    grid: { color: _scoreColors.line }
                                                },
                                                y: {
                                                    reverse: true,
                                                    ticks: { color: _scoreColors.text, font: { size: 11 } },
                                                    title: { display: true, text: '점수 구간', color: _scoreColors.text },
                                                    grid: { color: _scoreColors.line }
                                                }
                                            }
                                        },
                                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화
                                    });
                                    window.chartInstances.push({ chart: scoreChartInstance });
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
                                                    data: [70, 80, 92, 20],
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
                                            const _barColors = window.getChartColors();
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
                                                            color: _barColors.title
                                                        },
                                                        datalabels: {
                                                            anchor: 'end',   // 막대 끝 기준
                                                            align: 'top',
                                                            offset: -2,
                                                            color: _barColors.text,
                                                            font: {
                                                                weight: 'bold',
                                                                size: 11
                                                            },
                                                            formatter: function(value) {
                                                                return value; // 표시할 값
                                                            }
                                                        }
                                                    },
                                                    scales: {
                                                        y: {
                                                            ticks: { color: _barColors.text, font: { size: 12 }, stepSize: 20 },
                                                            title: { display: true, text: '점수', color: _barColors.text },
                                                            grid: { color: _barColors.line }
                                                        },
                                                        x: {
                                                            ticks: { color: _barColors.text, font: { size: 12 } },
                                                            grid: { color: _barColors.line }
                                                        }
                                                    }
                                                },
                                                plugins: [ChartDataLabels] // datalabels 플러그인 활성화
                                            };
                                            const barChartInstance = new Chart(document.getElementById('barChart'), barConfig);
                                            window.chartInstances.push({ chart: barChartInstance });
                                        </script>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" data-modal-open="modal1">성적산출 > 상대평가비중</button> 
                    <button type="button" class="btn modal__btn" data-modal-open="modal2">성적산출 > 절대평가비중</button>  
                    <button type="button" class="btn modal__btn" data-modal-open="modal3">성적산출 > P/F평가비중</button>   
                    <button type="button" class="btn modal__btn" data-modal-open="modal4">분반 성적 비교</button>        
                    <button type="button" class="btn modal__btn" data-modal-open="modal5">성적 상세정보</button>        
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="../common/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">상대평가비중</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    <div class="mScore_gap">
                        <div class="col-7">
                            <div class="board_top">  
                                <h3 class="board-title">상대평가</h3>                              
                                <div class="right-area">
                                    <span class="total_txt">[ 대상인원 <b>50</b>명 ]</span>
                                </div>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:22%">
                                        <col style="width:22%">                                        
                                        <col style="">
                                        <col style="width:20%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>등급</th>
                                            <th>평점</th>
                                            <th>등급분포비율</th>
                                            <th>인원</th>                                   
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A+</strong></th>
                                            <td data-th="평점">4.5</td>
                                            <td data-th="등급분포비율">~ 20%</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A</strong></th>
                                            <td data-th="평점">4.0</td>
                                            <td data-th="등급분포비율">~ 40%</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B+</strong></th>
                                            <td data-th="평점">3.5</td>
                                            <td data-th="등급분포비율">~ 60%</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B</strong></th>
                                            <td data-th="평점">3.0</td>
                                            <td data-th="등급분포비율">~ 80%</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr> 
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C+</strong></th>
                                            <td data-th="평점">2.5</td>
                                            <td rowspan="4" data-th="등급분포비율">잔여 비율
                                            범위 내에서
                                            지정
                                            </td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C</strong></th>
                                            <td data-th="평점">2.5</td>                                            
                                            <td data-th="인원">5</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D+</strong></th>
                                            <td data-th="평점">1.5</td>                                            
                                            <td data-th="인원">10</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D</strong></th>
                                            <td data-th="평점">1</td>                                            
                                            <td data-th="인원">9</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">F</strong></th>
                                            <td data-th="평점">0.0</td> 
                                            <td data-th="등급분포비율">자동 배당</td>                                           
                                            <td data-th="인원">1</td>                                   
                                        </tr> 
                                        <tr class="total">
                                            <th colspan="3" data-th="합계"><strong>합계</strong></th>
                                            <td data-th="인원"><strong>50 명</strong></td>                                                                           
                                        </tr>                                  
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-5">
                            <div class="board_top">
                                <h3 class="board-title">실시간 등급 분포도 비율</h3>                                
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:22%">                                        
                                        <col style="">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>등급</th>
                                            <th>분포도 비율(%)</th>                               
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">10%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 10%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>    
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">7.5%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 7.5%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr> 
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">0%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 0%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr> 
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">0%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 0%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">F</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">2.5%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 2.5%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr> 
                                        <tr class="total">
                                            <th data-th="합계"><strong>합계</strong></th>
                                            <td data-th="분포도 비율(%)"><strong>100%</strong></td>                                                                           
                                        </tr>                            
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div> 
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">성적처리저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">절대평가비중</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    <div class="mScore_gap">
                        <div class="col-7">
                            <div class="board_top">
                                <h3 class="board-title">절대평가</h3>
                                <div class="right-area">
                                    <span class="total_txt">[ 대상인원 <b>50</b>명 ]</span>
                                </div>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:22%">
                                        <col style="width:22%">                                        
                                        <col style="">
                                        <col style="width:20%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>등급</th>
                                            <th>평점</th>
                                            <th>점수</th>
                                            <th>인원</th>                                   
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A+</strong></th>
                                            <td data-th="평점">4.5</td>
                                            <td data-th="점수">95 ~ 100</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A</strong></th>
                                            <td data-th="평점">4.0</td>
                                            <td data-th="점수">90 ~ 94</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B+</strong></th>
                                            <td data-th="평점">3.5</td>
                                            <td data-th="점수">85 ~ 89</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B</strong></th>
                                            <td data-th="평점">3.0</td>
                                            <td data-th="점수">80 ~ 84</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr> 
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C+</strong></th>
                                            <td data-th="평점">2.5</td>
                                            <td data-th="점수">75 ~ 79</td>
                                            <td data-th="인원">5</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C</strong></th>
                                            <td data-th="평점">2.5</td>
                                            <td data-th="점수">70 ~ 74</td>                                            
                                            <td data-th="인원">5</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D+</strong></th>
                                            <td data-th="평점">1.5</td>   
                                            <td data-th="점수">65 ~ 69</td>                                         
                                            <td data-th="인원">10</td>                                   
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D</strong></th>
                                            <td data-th="평점">1</td> 
                                            <td data-th="점수">60 ~ 64</td>                                           
                                            <td data-th="인원">9</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">F</strong></th>
                                            <td data-th="평점">0.0</td> 
                                            <td data-th="점수">60미만</td>                                          
                                            <td data-th="인원">1</td>                                   
                                        </tr>
                                        <tr class="total">
                                            <th colspan="3" data-th="합계"><strong>합계</strong></th>
                                            <td data-th="인원"><strong>50 명</strong></td>                                                                           
                                        </tr>                                    
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-5">
                            <div class="board_top">
                                <h3 class="board-title">실시간 등급 분포도 비율</h3>                                
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:22%">                                        
                                        <col style="">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>등급</th>
                                            <th>분포도 비율(%)</th>                               
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">A</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">B</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">10%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 10%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>    
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">C</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">7.5%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 7.5%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr> 
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D+</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">0%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 0%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr> 
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">D</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">0%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 0%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>  
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">F</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">2.5%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 2.5%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr> 
                                        <tr class="total">
                                            <th data-th="합계"><strong>합계</strong></th>
                                            <td data-th="분포도 비율(%)"><strong>100%</strong></td>                                                                           
                                        </tr>                              
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>     
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">성적처리저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 3 -->
        <div class="modal-overlay" id="modal3" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-md" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">P/F 평가비중</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    <div class="mScore_gap">
                        <div class="col-5">
                            <div class="board_top">
                                <h3 class="board-title">P/F 평가</h3>
                                <div class="right-area">
                                    <span class="total_txt">[ 대상인원 <b>50</b>명 ]</span>
                                </div>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>                                        
                                        <col style="width:50%">                                        
                                        <col style="">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>등급</th>
                                            <th>인원</th>                              
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">P</strong></th>                                           
                                            <td data-th="인원">45</td>                                   
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">F</strong></th>
                                            <td data-th="인원">5</td>                                   
                                        </tr>                                          
                                        <tr class="total">
                                            <th data-th="합계"><strong>합계</strong></th>
                                            <td data-th="인원"><strong>50 명</strong></td>                                                                           
                                        </tr>                                    
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-7">
                            <div class="board_top">
                                <h3 class="board-title">실시간 등급 분포도 비율</h3>                                
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col style="width:22%">                                        
                                        <col style="">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>등급</th>
                                            <th>분포도 비율(%)</th>                               
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">P</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>
                                        <tr>
                                            <th data-th="등급"><strong class="txt_grade">F</strong></th>
                                            <td data-th="분포도 비율(%)">
                                                <div class="prog_rate">
                                                    <span class="meta">20%</span>
                                                    <div class="progress">
                                                        <div class="bar blue_type" style="width: 20%;"></div>
                                                    </div>
                                                </div>
                                            </td>                               
                                        </tr>                                        
                                        <tr class="total">
                                            <th data-th="합계"><strong>합계</strong></th>
                                            <td data-th="분포도 비율(%)"><strong>100%</strong></td>                                                                           
                                        </tr>                              
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>     
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">성적처리저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 4 -->
        <div class="modal-overlay" id="modal4" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">분반 성적 비교</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                    <div class="board_top">
                        <h3 class="board-title">분반 성적 분포</h3>                               
                    </div>                    
                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:10%">
                                <col style="">
                                <col style="width:8%">
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:7%">
                                <col style="width:7%">
                                
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>점수</th>
                                    <th>수강생</th>
                                    <th>산출총점 평균</th>
                                    <th>최종점수 평균</th>
                                    <th>95 ~ 100</th>
                                    <th>90 ~ 94</th>
                                    <th>85 ~ 89</th>
                                    <th>80 ~ 84</th>
                                    <th>75 ~ 79</th>
                                    <th>70 ~ 74</th>
                                    <th>65 ~ 69</th>
                                    <th>60 ~ 64</th>
                                    <th>60미만</th>                                        
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="점수">1반</td>
                                    <td data-th="수강생">50</td>
                                    <td data-th="산출총점 평균">85.25</td>
                                    <td data-th="최종점수 평균">85.25</td>                                        
                                    <td data-th="95 ~ 100">2</td>
                                    <td data-th="90 ~ 94">7</td>
                                    <td data-th="85 ~ 89">9</td>
                                    <td data-th="80 ~ 84">9</td>
                                    <td data-th="75 ~ 79">11</td>
                                    <td data-th="70 ~ 74">5</td>
                                    <td data-th="65 ~ 69">3</td>
                                    <td data-th="60 ~ 64">3</td>
                                    <td data-th="60미만">1</td>                                       
                                </tr>
                                <tr>
                                    <td data-th="점수">2반</td>
                                    <td data-th="수강생">50</td>
                                    <td data-th="산출총점 평균">85.25</td>
                                    <td data-th="최종점수 평균">85.25</td>                                        
                                    <td data-th="95 ~ 100">2</td>
                                    <td data-th="90 ~ 94">7</td>
                                    <td data-th="85 ~ 89">9</td>
                                    <td data-th="80 ~ 84">9</td>
                                    <td data-th="75 ~ 79">11</td>
                                    <td data-th="70 ~ 74">5</td>
                                    <td data-th="65 ~ 69">3</td>
                                    <td data-th="60 ~ 64">3</td>
                                    <td data-th="60미만">1</td>                                       
                                </tr>
                                <tr>
                                    <td data-th="점수">3반</td>
                                    <td data-th="수강생">50</td>
                                    <td data-th="산출총점 평균">85.25</td>
                                    <td data-th="최종점수 평균">85.25</td>                                        
                                    <td data-th="95 ~ 100">2</td>
                                    <td data-th="90 ~ 94">7</td>
                                    <td data-th="85 ~ 89">9</td>
                                    <td data-th="80 ~ 84">9</td>
                                    <td data-th="75 ~ 79">11</td>
                                    <td data-th="70 ~ 74">5</td>
                                    <td data-th="65 ~ 69">3</td>
                                    <td data-th="60 ~ 64">3</td>
                                    <td data-th="60미만">1</td>                                       
                                </tr>
                                <tr>
                                    <td data-th="점수">4반</td>
                                    <td data-th="수강생">50</td>
                                    <td data-th="산출총점 평균">85.25</td>
                                    <td data-th="최종점수 평균">85.25</td>                                        
                                    <td data-th="95 ~ 100">2</td>
                                    <td data-th="90 ~ 94">7</td>
                                    <td data-th="85 ~ 89">9</td>
                                    <td data-th="80 ~ 84">9</td>
                                    <td data-th="75 ~ 79">11</td>
                                    <td data-th="70 ~ 74">5</td>
                                    <td data-th="65 ~ 69">3</td>
                                    <td data-th="60 ~ 64">3</td>
                                    <td data-th="60미만">1</td>                                       
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="chart-container mt30" style="height: 320px;">
                        <canvas id="classScoreChart"></canvas>
                    </div>
                    <script>
                        const labels = [
                            '산출총점평균','최종점수평균',
                            '60미만','60~64','65~69','70~74','75~79',
                            '80~84','85~89','90~94','95~100'
                        ];

                        // 막대 데이터 (인원수)
                        const datasets = [
                            {
                                type: 'bar',
                                label: '1반',
                                data: [3, 8, 1, 3, 3, 5, 11, 9, 9, 7, 2],        
                                backgroundColor: 'rgb(255, 224, 116, 0.8)'
                            },
                            {
                                type: 'bar',
                                label: '2반',
                                data: [3, 9, 1, 4, 2, 4, 12, 8, 10, 8, 2],
                                backgroundColor: 'rgb(93, 193, 171, 0.8)'
                            },
                            {
                                type: 'bar',
                                label: '3반',
                                data: [5, 10, 0, 2, 2, 3, 10, 11, 11, 10, 3],
                                backgroundColor: 'rgb(57, 160, 219, 0.8)'
                                
                            },
                            {
                                type: 'bar',
                                label: '4반',
                                data: [2, 9, 1, 2, 4, 6, 10, 10, 9, 8, 1],
                                backgroundColor: 'rgb(129, 155, 168, 0.8)'
                            }    
                        ];

                        const _classColors = window.getChartColors();
                        const config = {
                            data: {
                                labels: labels,
                                datasets: datasets
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                datasets: {
                                bar: {
                                        barThickness: 10
                                    }
                                },
                                plugins: {
                                    title: {
                                        display: true,
                                        text: '분반별 점수 분포 및 평균',
                                        font: { size: 16 },
                                        color: _classColors.title
                                    },
                                    legend: {
                                        position: 'top',
                                        labels: {
                                            boxWidth: 15,
                                            color: _classColors.text
                                        }
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: { color: _classColors.text },
                                        grid:  { color: _classColors.line }
                                    },
                                    x: {
                                        ticks: { color: _classColors.text },
                                        grid:  { color: _classColors.line }
                                    }
                                }
                            }
                        };
                        const classScoreChartInstance = new Chart(document.getElementById('classScoreChart'), config);
                        window.chartInstances.push({ chart: classScoreChartInstance });
                    </script>
                       
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 5 -->
        <div class="modal-overlay grade-detail-modal" id="modal5" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">성적 상세정보</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 

                    <!-- 수강생 정보 -->
                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">수강생 정보</h3>
                        </div>
                        <div class="user-wrap mb30">
                            <div class="user-img">
                                <div class="user-photo">
                                    <!--프로필 사진-->
                                    <img src="/lms_design_sample/webdoc/assets/img/common/default_prof.png" alt="사진">
                                </div>
                            </div>

                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>과정</label></li>
                                    <li>대학원 / 평생교육원 / 학위과정</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>이름</label></li>
                                    <li>학습자4</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>아이디</label></li>
                                    <li>TESTID04</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>휴대폰번호</label></li>
                                    <li>010-1234-5698</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>사용 이메일</label></li>
                                    <li>k202154774@knou.ac.kr (연계 이메일)</li>
                                </ul>
                            </div>

                        </div>
                    </div><!-- //수강생 정보 -->

                    <!-- 성적 정보 -->
                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">성적 정보</h3>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type3">
                                <thead>
                                    <tr>
                                        <th scope="row">총점</th>
                                        <th scope="row">최종성적</th>
                                        <th scope="row">강의(출석)</th>
                                        <th scope="row">중간고사</th>
                                        <th scope="row">기말고사</th>
                                        <th scope="row">세미나</th>
                                        <th scope="row">과제</th>
                                        <th scope="row">토론</th>
                                        <th scope="row">퀴즈</th>
                                        <th scope="row">기타(가산점)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="총점">88</td>
                                        <td data-th="최종성적">88</td>
                                        <td data-th="강의(출석)">19</td>
                                        <td data-th="중간고사">18</td>
                                        <td data-th="기말고사">18</td>
                                        <td data-th="세미나">-</td>
                                        <td data-th="과제">16 </td>
                                        <td data-th="토론">12</td>
                                        <td data-th="퀴즈">-</td>
                                        <td data-th="기타(가산점)">5</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div><!-- //성적 정보 -->


                    <!-- 성적 현황 -->
                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">성적 현황</h3>
                        </div>
                        <div class="scoreChart_wrap" style="gap:2rem;">
                            <!-- 평균 점수 -->
                            <div class="left_chart">
                                <div class="chart-container" style="height: 340px;">
                                    <canvas id="avgScoreChart"></canvas>
                                </div>
                            </div>
                            <!-- 최종점수 현황 -->
                            <div class="right_chart">
                                <div class="chart-container flex-column" style="height: 300px;">
                                    <canvas id="finalScoreChart"></canvas>
                                    <p class="text-center pt10 pb10">
                                        최종점수는 <strong class="fcRed">0.0점</strong> 입니다.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <script>
                        (function () {
                            const _avgColors = window.getChartColors();
                            // ===== 평균 점수 (가로 막대 차트) =====
                            const avgLabels   = ['온라인', '중간시험', '기말시험', '과제', '토론', '팀활동', '기타'];
                            const avgMyData   = [0, 0, 0, 0, 0, 0, 0];            // 나
                            const avgMeanData = [13.00, 14.00, 0, 0.25, 0, 0, 0]; // 평균

                            const avgScoreChartInstance = new Chart(document.getElementById('avgScoreChart'), {
                                type: 'bar',
                                data: {
                                    labels: avgLabels,
                                    datasets: [
                                        {
                                            label: '나',
                                            data: avgMyData,
                                            backgroundColor: 'rgba(38, 166, 132, 0.9)',
                                            borderColor: 'rgba(38, 166, 132, 1)',
                                            borderWidth: 1,
                                            barThickness: 13
                                        },
                                        {
                                            label: '평균',
                                            data: avgMeanData,
                                            backgroundColor: 'rgba(160, 162, 165, 0.95)',
                                            borderColor: 'rgba(160, 162, 165, 1)',
                                            borderWidth: 1,
                                            barThickness: 13
                                        }
                                    ]
                                },
                                options: {
                                    indexAxis: 'y', // 가로 막대
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: { usePointStyle: true, pointStyle: 'rect', boxWidth: 12, font: { size: 13 }, color: _avgColors.text }
                                        },
                                        title: {
                                            display: true,
                                            text: '평균 점수',
                                            font: { size: 16 },
                                            color: _avgColors.title
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: (ctx) => ctx.dataset.label + ' : ' + Number(ctx.raw).toFixed(2) + '점'
                                            }
                                        },
                                        // 막대 끝 점수 라벨 (색칠된 배경 위 흰색 유지)
                                        datalabels: {
                                            display: (ctx) => Number(ctx.dataset.data[ctx.dataIndex]) > 0,
                                            anchor: 'end',
                                            align: 'right',
                                            backgroundColor: (ctx) => ctx.dataset.backgroundColor,
                                            borderRadius: 2,
                                            padding: { top: 2, bottom: 2, left: 4, right: 4 },
                                            color: '#fff',
                                            font: { weight: 'bold', size: 11 },
                                            formatter: (value) => Number(value).toFixed(2) + '점'
                                        }
                                    },
                                    scales: {
                                        x: {
                                            beginAtZero: true,
                                            max: 100,
                                            ticks: {
                                                stepSize: 20,
                                                color: _avgColors.text,
                                                callback: (value) => value + '점'
                                            },
                                            grid: { color: _avgColors.line }
                                        },
                                        y: {
                                            ticks: { color: _avgColors.text, font: { size: 12 } },
                                            grid: { color: _avgColors.line }
                                        }
                                    }
                                },
                                plugins: [ChartDataLabels] // datalabels 플러그인 활성화
                            });
                            // 막대 위 흰색 라벨은 다크모드에서도 유지
                            window.chartInstances.push({ chart: avgScoreChartInstance, keepDataLabelColor: true });

                            // ===== 최종점수 현황 (도넛 차트) =====
                            const finalLabels = ['91~100 : 0명', '81~90 : 0명', '71~80 : 0명', '61~70 : 0명', '51~60 : 0명', '50점 이하 : 10명'];
                            const finalData   = [0, 0, 0, 0, 0, 10];
                            const finalColors = ['#6435c9', '#2185d0', '#f2711c', '#e03997', '#c4c8cb', '#8c9094'];
                            const _finalColors = window.getChartColors();

                            const finalScoreChartInstance = new Chart(document.getElementById('finalScoreChart'), {
                                type: 'doughnut',
                                data: {
                                    labels: finalLabels,
                                    datasets: [{
                                        data: finalData,
                                        backgroundColor: finalColors,
                                        borderColor: _finalColors.line,
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    cutout: '62%',
                                    plugins: {
                                        legend: {
                                            position: 'bottom',
                                            labels: { usePointStyle: true, pointStyle: 'rect', boxWidth: 12, padding: 12, font: { size: 12 }, color: _finalColors.text }
                                        },
                                        title: {
                                            display: true,
                                            text: '최종점수 현황 (%)',
                                            font: { size: 16 },
                                            color: _finalColors.title
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: (ctx) => {
                                                    const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                                                    const pct = total ? (ctx.raw / total * 100).toFixed(1) : 0;
                                                    return ctx.label + ' (' + pct + '%)';
                                                }
                                            }
                                        },
                                        // 도넛 조각 비율(%) 라벨 (조각 위 흰색 유지)
                                        datalabels: {
                                            display: (ctx) => Number(ctx.dataset.data[ctx.dataIndex]) > 0,
                                            color: '#fff',
                                            font: { weight: 'bold', size: 14 },
                                            formatter: (value, ctx) => {
                                                const total = ctx.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                                                return total ? Math.round(value / total * 100) + '%' : '';
                                            }
                                        }
                                    }
                                },
                                plugins: [ChartDataLabels]
                            });
                            // 도넛 조각 위 흰색 라벨은 다크모드에서도 유지, 조각 사이 구분선만 갱신
                            window.chartInstances.push({
                                chart: finalScoreChartInstance,
                                keepDataLabelColor: true,
                                onUpdate: function(c, chart){
                                    if (chart.data.datasets[0]) chart.data.datasets[0].borderColor = c.line;
                                }
                            });
                        })();
                        </script>
                    </div>
                    <!-- //성적 현황 -->

                    <!-- 성적 산출 -->
                    <div class="sub-box">
                        <div class="course_history pd0 bd0 mt0">
                            <div class="h_top pd0 bd0 mb5">
                                <div class="h_left">
                                    <h3>성적 산출</h3>
                                </div>
                            </div>
                            <div class="h_content pd0">
                                <ul class="course_week">
                                    <!-- 온라인 강의 -->
                                    <li class="active mt0">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_box type2 pr0">
                                                    <div class="lecture_tit">
                                                        <strong>온라인 강의</strong>
                                                    </div>
                                                    <div class="btn_right">
                                                        <span>평가비율 <strong>25%</strong></span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col class="width-5per">
                                                        <col class="width-20per">
                                                        <col class="width-15per">
                                                        <col>
                                                        <col class="width-10per">
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th scope="col" colspan="6">출결 기준 및 진도율 설정</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">구분</th>
                                                            <th scope="col" colspan="2">조건</th>
                                                            <th scope="col">진도율 인정비율</th>
                                                            <th scope="col">출결기준</th>
                                                            <th scope="col">출결표시</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <th data-th="구분" rowspan="3">각 주차</th>
                                                            <td data-th="조건">1</td>
                                                            <td data-th="조건" class="text-left">학습 기간 내 진도율</td>
                                                            <td data-th="진도율 인정비율"><span class="fcBlue">100%</span> 인정</td>
                                                            <td data-th="출결기준" class="text-left">1의 진도율 <span class="fcBlue">75%</span> 이상</td>
                                                            <td data-th="출결표시"><span class="fcBlue">출석</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="조건">2</td>
                                                            <td data-th="조건" class="text-left">지각 인정 일시 내 진도율</td>
                                                            <td data-th="진도율 인정비율"><span class="fcBlue">50%</span> 인정</td>
                                                            <td data-th="출결기준" class="text-left">1의 진도율 <span class="fcBlue">75%</span> 미만 & (1+2)의 진도율 <span class="fcBlue">75%</span> 이상</td>
                                                            <td data-th="출결표시"><span class="fcOrange">지각</span></td>                                            
                                                        </tr>
                                                        <tr>
                                                            <td data-th="조건">3</td>
                                                            <td data-th="조건" class="text-left">그 이외 진도율</td>
                                                            <td data-th="진도율 인정비율"><span class="fcBlue">0%</span> 인정</td>
                                                            <td data-th="출결기준" class="text-left">그 외</td>
                                                            <td data-th="출결표시"><span class="fcRed">결석</span></td>                                            
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                        <col>
                                                    </colgroup>
                                                    <thead>
                                                        <tr>
                                                            <th scope="col" colspan="3">출석점수 기준 비율계산 = { ( 출석 주차의 수 + 지각 주차의 수) / 전체 주차의 수 } * 100 </th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">구분</th>
                                                            <th scope="col">비율 조건</th>
                                                            <th scope="col">출석 점수</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        
                                                        <tr>
                                                            <th rowspan="2">출석점수<br>기준비율</th>
                                                            <td data-th="비율 조건"><span class="fcBlue">100% ~ 75%</span></td>
                                                            <td data-th="출석 점수"><span class="fcBlue">20</span> 점</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="비율 조건"><span class="fcBlue">74% ~ 0%</span></td>
                                                            <td data-th="출석 점수"><span class="fcBlue">0</span> 점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="total">
                                                            <td><strong>산출 점수</strong></td>
                                                            <td><strong class="fcRed">20점</strong></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li><!-- //온라인 강의 -->

                                    <!-- 중간고사 -->
                                    <li class="active">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_box type2 pr0">
                                                    <div class="lecture_tit">
                                                        <strong>중간고사</strong>
                                                    </div>
                                                    <div class="btn_right">
                                                        <span>평가비율 <strong>20%</strong></span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type3">
                                                    <thead>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">
                                                                취득점수<br>
                                                                <small>(실시간시험/대체과제/대체퀴즈 등 받은 점수)</small>
                                                            </th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td data-th="반영 비율">100%</td>
                                                            <td data-th="취득점수">90점</td>
                                                            <td data-th="환산점수">90점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                
                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="total">
                                                            <td><strong>산출 점수</strong></td>
                                                            <td><strong class="fcRed">18점</strong></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li><!-- //중간고사 -->

                                    <!-- 기말고사 -->
                                    <li class="active">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_box type2 pr0">
                                                    <div class="lecture_tit">
                                                        <strong>기말고사</strong>
                                                    </div>
                                                    <div class="btn_right">
                                                        <span>평가비율 <strong>20%</strong></span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type3">
                                                    <thead>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td data-th="반영 비율">100%</td>
                                                            <td data-th="취득점수">90점</td>
                                                            <td data-th="환산점수">90점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="total">
                                                            <td><strong>산출 점수</strong></td>
                                                            <td><strong class="fcRed">18점</strong></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li><!-- //기말고사 -->

                                    <!-- 과제 -->
                                    <li class="active">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_box type2 pr0">
                                                    <div class="lecture_tit">
                                                        <strong>과제</strong>
                                                    </div>
                                                    <div class="btn_right">
                                                        <span>평가비율 <strong>20%</strong></span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">과제과제001</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">25%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">20점</td>
                                                        </tr>
                                                    </tbody>
                                              </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">과제과제002</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">25%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">20점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">과제과제003</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">0%</td>
                                                            <td data-th="취득점수">0점</td>
                                                            <td data-th="환산점수">0점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">과제과제004</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">25%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">20점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">과제과제005</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">25%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">20점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="total">
                                                            <td><strong>산출 점수</strong></td>
                                                            <td><strong class="fcRed">16점</strong></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li><!-- //과제 -->


                                    <!-- 토론 -->
                                    <li class="active">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_box type2 pr0">
                                                    <div class="lecture_tit">
                                                        <strong>토론</strong>
                                                    </div>
                                                    <div class="btn_right">
                                                        <span>평가비율 <strong>15%</strong></span>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">토론토론001</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">100%</td>
                                                            <td data-th="취득점수">90점</td>
                                                            <td data-th="환산점수">90점</td>
                                                        </tr>
                                                    </tbody>
                                              </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">토론토론002</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">100%</td>
                                                            <td data-th="취득점수">90점</td>
                                                            <td data-th="환산점수">90점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3">토론토론003</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">반영 비율</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="반영 비율">100%</td>
                                                            <td data-th="취득점수">90점</td>
                                                            <td data-th="환산점수">90점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="total">
                                                            <td><strong>산출 점수</strong></td>
                                                            <td><strong class="fcRed">12점</strong></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li><!-- //토론 -->

                                    <!-- 기타(가산점) -->
                                    <li class="active">
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <div class="lecture_box type2 pr0">
                                                    <div class="lecture_tit">
                                                        <strong>기타(가산점)</strong>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3" class="fcRed">세미나001</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">가중치</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="가중치">30%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">24점</td>
                                                        </tr>
                                                    </tbody>
                                              </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3" class="fcRed">세미나002</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">가중치</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="가중치">30%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">24점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                
                                                <table class="table-type3">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="col" colspan="3" class="fcRed">세미나003</th>
                                                        </tr>
                                                        <tr>
                                                            <th scope="col">가중치</th>
                                                            <th scope="col">취득점수</th>
                                                            <th scope="col">환산점수</th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="가중치">40%</td>
                                                            <td data-th="취득점수">80점</td>
                                                            <td data-th="환산점수">32점</td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <table class="table-type3">
                                                    <colgroup>
                                                        <col class="width-10per">
                                                        <col>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="total">
                                                            <td><strong>산출 점수</strong></td>
                                                            <td><strong class="fcRed">5점</strong></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li><!-- //기타(가산점) -->

                                </ul>
                            </div>
                        </div>
                     </div>


                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>


        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>
