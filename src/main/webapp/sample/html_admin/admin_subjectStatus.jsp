<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
    <link rel="stylesheet" href="../../webdoc/assets/css/classroom.css">
    <link rel="stylesheet" href="../../webdoc/assets/css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                            <h2 class="page-title">개설과목통계</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과목관리</li>
                                    <li>학습통계분석</li>
                                    <li><span class="current">개설과목통계</span></li>
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
                                        <option value="학과">학과</option>
                                    </select>
                                    <select class="form-select" id="selectSearch1">
                                        <option value="과목">과목</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="과목/과목코드/교수 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">개설 과목 통계</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2 small">엑셀로 다운로드</button>
                            </div>                            
                        </div>

                        <div class="table-wrap overflow-y mb20">
                            <table class="table-type3">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
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
                                        <th scope="col" rowspan="2">기관</th>
                                        <th scope="col" rowspan="2">과목</th>
                                        <th scope="col" rowspan="2">평균진도율</th>
                                        <th scope="col" colspan="7">참여율</th>
                                    </tr>
                                    <tr>
                                        <th scope="col">과제</th>
                                        <th scope="col">퀴즈</th>
                                        <th scope="col">설문</th>
                                        <th scope="col">토론</th>
                                        <th scope="col">세미나</th>
                                        <th scope="col">중간고사</th>
                                        <th scope="col">기말고사</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="10">검색 결과가 없습니다.</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">프라임칼리지 평생교육과정</td>
                                        <th data-th="과목" class="text-left">유비쿼터스컴퓨팅 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">경영대학원</td>
                                        <th data-th="과목" class="text-left">데이터베이스특론 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">프라임칼리지 학위과정</td>
                                        <th data-th="과목" class="text-left">중국어코퍼스언어학 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">대학원</td>
                                        <th data-th="과목" class="text-left">중한통번역연습 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">종합교육연수원</td>
                                        <th data-th="과목" class="text-left">정책과정론 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">대학원</td>
                                        <th data-th="과목" class="text-left">인사해정세미나 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">허브대학</td>
                                        <th data-th="과목" class="text-left">교수설계특론 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">종합교육연수원</td>
                                        <th data-th="과목" class="text-left">직업진로설계세미나 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">대학원</td>
                                        <th data-th="과목" class="text-left">간호이론총론 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                    <tr>                                        
                                        <td data-th="기관" class="text-left">프라임칼리지 평생교육과정</td>
                                        <th data-th="과목" class="text-left">상급건강사정 1반</th>
                                        <td data-th="평균진도율">80%</td>
                                        <td data-th="과제">80%</td>
                                        <td data-th="퀴즈">80%</td>
                                        <td data-th="설문">80%</td>
                                        <td data-th="토론">80%</td>
                                        <td data-th="세미나">80%</td>
                                        <td data-th="중간고사">80%</td>
                                        <td data-th="기말고사">80%</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="box">
                        <!-- <p class="text-center">검색 결과가 없습니다.</p> -->

                    <div class="chart-container" style="height: 320px;">
                        <canvas id="classScoreChart"></canvas>
                    </div>
                    <script>
                        window.chartInstances = window.chartInstances || [];

                        const labels = [
                            '유비쿼터스컴퓨팅 1반','데이터베이스특론 1반',
                            '중국어코퍼스언어학 1반','중한통번역연습 1반','정책과정론 1반','인사해정세미나 1반','교수설계특론 1반',
                            '직업진로설계세미나 1반','간호이론총론 1반','상급건강사정 1반'
                        ];

                        // 막대 데이터
                        const datasets = [
                            {
                                type: 'bar',
                                label: '평균진도율',
                                data: [30, 22, 45, 56, 32, 58, 65, 82, 91, 87],        
                                backgroundColor: 'rgb(255, 224, 116, 0.8)'
                            },
                            {
                                type: 'bar',
                                label: '과제참여율',
                                data: [25, 19, 41, 34, 32, 54, 62, 78, 70, 89],
                                backgroundColor: 'rgb(93, 193, 171, 0.8)'
                            },
                            {
                                type: 'bar',
                                label: '퀴즈참여율',
                                data: [45, 60, 50, 62, 72, 73, 80, 91, 89, 92],
                                backgroundColor: 'rgb(57, 160, 219, 0.8)'
                                
                            },
                            {
                                type: 'bar',
                                label: '설문참여율',
                                data: [42, 49, 41, 42, 44, 46, 40, 40, 49, 48],
                                backgroundColor: 'rgba(244, 142, 142, 0.8)'
                            },
                            {
                                type: 'bar',
                                label: '토론참여율',
                                data: [61, 73, 85, 88, 82, 98, 80, 80, 83, 83],
                                backgroundColor: 'rgba(168, 168, 218, 0.7)'
                            },
                            {
                                type: 'bar',
                                label: '세미나참여율',
                                data: [21, 33, 34, 59, 54, 52, 52, 51, 62, 46],
                                backgroundColor: 'rgba(125, 200, 145, 0.85)'
                            },
                            {
                                type: 'bar',
                                label: '중간고사참여율',
                                data: [89, 95, 98, 93, 92, 99, 92, 92, 95, 93],
                                backgroundColor:'rgba(190, 160, 235, 0.85)',
                            },
                            {
                                type: 'bar',
                                label: '기말고사참여율',
                                data: [92, 99, 91, 92, 94, 96, 90, 90, 99, 98],
                                backgroundColor: 'rgb(129, 155, 168, 0.8)'
                            }
                        ];

                        const _classColors = {
                            title: '#333',
                            text: '#666',
                            line: '#eee'
                        };
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
                                        display: false,
                                        // text: '분반별 점수 분포 및 평균',
                                        // align:'start',
                                        // font: { size: 16 },
                                        // color: _classColors.title
                                    },
                                    legend: {
                                        position: 'top',
                                        labels: {
                                            boxWidth: 12,
                                            color: _classColors.text
                                        }
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        min: 0,
                                        max: 100,
                                        ticks: { 
                                            stepSize: 10,
                                            color: _classColors.text,
                                            callback: function(value) {
                                                return value + '%';
                                            }
                                        },
                                        grid: { color: _classColors.line }
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

                        </div>



                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>


</body>
</html>

