<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
    <script src="../../webdoc/uilib/chart/d3.v4.js"></script><!-- chart d3.js -->
    <script src="../../webdoc/uilib/chart/chart4.min.js"></script><!-- chart4 -->
    <script src="../../webdoc/uilib/chart/chart-utils.min.js"></script><!-- chart util -->
    <script src="../../webdoc/uilib/chart/chartjs-plugin-datalabels.min.js"></script>    
    <link rel="stylesheet" href="../../webdoc/assets/css/classroom.css">
    <link rel="stylesheet" href="../../webdoc/assets/css/dashboard.css">
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
                            <h2 class="page-title">학습자분석자료</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과목관리</li>
                                    <li>학습통계분석</li>
                                    <li><span class="current">학습자분석자료</span></li>
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
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="이름/대표아이디/학번 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">학습자
                                <span class="total_txt fs-16px fw-normal ml5">[ 총 건수 : <b>0</b>건 ]</span>
                            </h3>
                            <div class="right-area">
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>                            
                        </div>

                        <div class="table-wrap overflow-y">
                            <table class="table-type3">
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col" class="cursor-pointer">
                                            기관<i class="xi-arrows-v icon"></i>
                                        </th>
                                        <th scope="col" class="cursor-pointer">
                                            년도<i class="xi-arrows-v icon"></i>
                                        </th>
                                        <th scope="col" class="cursor-pointer">
                                            학기<i class="xi-arrows-v icon"></i>
                                        </th>
                                        <th scope="col">학과</th>
                                        <th scope="col">과목코드</th>
                                        <th scope="col">과목</th>
                                        <th scope="col">분반</th>
                                        <th scope="col">대표ID</th>
                                        <th scope="col">학번</th>
                                        <th scope="col">이름</th>
                                        <th scope="col">분석자료</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="12">검색 결과가 없습니다.</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">48</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">47</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">46</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">45</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">44</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">43</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">42</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">41</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">40</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">39</td>
                                        <td data-th="기관">대학원</td>
                                        <td data-th="년도">2026년</td>
                                        <td data-th="학기">1학기</td>
                                        <td data-th="학과">정보과학과</td>
                                        <td data-th="과목코드">CU254835</td>
                                        <td data-th="과목">유비쿼터스컴퓨팅</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="대표ID">testi**1</td>
                                        <td data-th="학번">20212***78</td>
                                        <td data-th="이름">김*동</td>
                                        <td data-th="분석자료">
                                            <button type="button" class="btn basic small">분석자료</button>
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
          


                    </div>
                </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1" data-target="#modal1">분석자료</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->

            <!-- Modal1 분석자료 -->
            <div class="modal-overlay" id="modal1">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="msg-box warning">
                            <p class="txt"><i class="icon-svg-warning" aria-hidden="true"></i>분석 기준은 바로 직전 주차까지의 분석 자료입니다.  개인 학습 분석 자료입니다. 학습에 참고하세요</p>
                        </div>

                        <!-- 수강현황 -->
                        <div class="board_top">
                            <h4 class="sub-title">수강현황</h4>
                            <div class="right-area">
                                <span class="total_txt fs-16px fw-normal">[ <b>2026년 1학기</b> ]</span>
                            </div>
                        </div>

                        <div class="table-wrap mb20">
                            <table class="table-type3">
                                <colgroup>
                                    <col>
                                    <col style="width:10%">
                                    <col style="width:30%">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col style="width:7%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">수강과목</th>
                                        <th scope="col">분반</th>
                                        <th scope="col">학습 진도율</th>
                                        <th scope="col">학습요소 참여율</th>
                                        <th scope="col">강의Q&A</th>
                                        <th scope="col">1:1상담</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="table-hover">
                                        <td data-th="수강과목" class="t_left">
                                            <a href="#" class="link fcBlue">인터넷의 이해</a>
                                        </td>
                                        <td data-th="분반">01</td>
                                        <td data-th="학습 진도율" class="course_history bd0 mt0">
                                            <div class="flex align-items-center justify-content-between gap-2">
                                                <div class="learning-progress">
                                                    <span>84%</span>
                                                    <div class="bar" style="width: 84%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="학습요소 참여율">75%</td>
                                        <td data-th="강의Q&A"><span class="fcBlue">2</span>/3</td>
                                        <td data-th="1:1상담"><span class="fcBlue">2</span>/2</td>
                                    </tr>
                                    <tr class="table-hover">
                                        <td data-th="수강과목" class="t_left">
                                            <a href="#" class="link fcBlue">유비쿼터스컴퓨팅</a>
                                        </td>
                                        <td data-th="분반">01</td>
                                        <td data-th="학습 진도율" class="course_history bd0 mt0">
                                            <div class="flex align-items-center justify-content-between gap-2">
                                                <div class="learning-progress">
                                                    <span>12%</span>
                                                    <div class="bar" style="width: 12%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="학습요소 참여율">75%</td>
                                        <td data-th="강의Q&A"><span class="fcBlue">2</span>/3</td>
                                        <td data-th="1:1상담"><span class="fcBlue">2</span>/2</td>
                                    </tr>
                                    <tr class="table-hover">
                                        <td data-th="수강과목" class="t_left">
                                            <a href="#" class="link fcBlue">컴퓨터의 모든것</a>
                                        </td>
                                        <td data-th="분반">01</td>
                                        <td data-th="학습 진도율" class="course_history bd0 mt0">
                                            <div class="flex align-items-center justify-content-between gap-2">
                                                <div class="learning-progress">
                                                    <span>45%</span>
                                                    <div class="bar" style="width: 45%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="학습요소 참여율">75%</td>
                                        <td data-th="강의Q&A"><span class="fcBlue">2</span>/3</td>
                                        <td data-th="1:1상담"><span class="fcBlue">2</span>/2</td>
                                    </tr>
                                    <tr class="table-hover">
                                        <td data-th="수강과목" class="t_left">
                                            <a href="#" class="link fcBlue">프로그램 기초</a>
                                        </td>
                                        <td data-th="분반">01</td>
                                        <td data-th="학습 진도율" class="course_history bd0 mt0">
                                            <div class="flex align-items-center justify-content-between gap-2">
                                                <div class="learning-progress">
                                                    <span>72%</span>
                                                    <div class="bar" style="width: 72%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-th="학습요소 참여율">75%</td>
                                        <td data-th="강의Q&A"><span class="fcBlue">2</span>/3</td>
                                        <td data-th="1:1상담"><span class="fcBlue">2</span>/2</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div><!-- //수강현황 -->

                        <div class="admin_sub pd0">
                            <div class="box">

                                <div class="flex gap-5 mb20">
                                    <!-- 출결 현황 -->
                                    <div class="width-30per">
                                        <div class="chart-container" style="height: 350px;">
                                            <canvas id="barChart"></canvas>
                                        </div>
                                        <script>
                                            const barUtils = ChartUtils.init();
                                            const BAR_COUNT = 1;
                                            const NUMBER_BAR = {
                                                count: BAR_COUNT,
                                                min: 0,
                                                max: 10
                                            };

                                            const barData = {
                                                labels: ['출석'],
                                                datasets: [
                                                    {
                                                        label: '출석',
                                                        data: [4],
                                                        backgroundColor: 'rgba(100, 195, 195, 0.8)',
                                                        borderColor:'rgba(100, 195, 195, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    },
                                                    {
                                                        label: '지각',
                                                        data: [1],
                                                        backgroundColor: 'rgba(247, 202, 120, 0.8)',
                                                        borderColor:'rgba(247, 202, 120, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    },
                                                    {
                                                        label: '결석',
                                                        data: [1],
                                                        backgroundColor: 'rgba(244, 142, 142, 0.8)',
                                                        borderColor:'rgba(244, 142, 142, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    },
                                                    {
                                                        label: '주차',
                                                        data: [6],
                                                        backgroundColor: 'rgba(175, 182, 190, 0.8)',
                                                        borderColor:'rgba(175, 182, 190, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    }
                                                ]
                                            };

                                            const barConfig = {
                                                type: 'bar',
                                                data: barData,
                                                options: {
                                                    responsive: true,
                                                    maintainAspectRatio: false,
                                                    plugins: {
                                                        legend: { 
                                                            display: true, 
                                                            position: 'bottom',
                                                            labels: {
                                                                boxWidth: 12, 
                                                                font: { size: 12 },
                                                                color: '#333'
                                                            }
                                                        },
                                                        title: {
                                                            display: true,
                                                            text: '출결 현황',
                                                            font: { size: 16 },
                                                            color: '#333',
                                                            align: 'start',
                                                            padding: { bottom: 20 }
                                                        },
                                                        datalabels: {
                                                            display:false
                                                        }
                                                    },
                                                    scales: {
                                                        y: {
                                                            min:0,
                                                            max:7,
                                                            ticks: { color: '#666', font: { size: 12 }, stepSize: 1 }
                                                        },
                                                        x: {
                                                            ticks: { color: '#666', font: { size: 12 } },
                                                        }
                                                    }
                                                },
                                                plugins: [ChartDataLabels]                                    
                                            };

                                            new Chart(document.getElementById('barChart'), barConfig);
                                        </script>
                                    </div><!-- //출결 현황 -->

                                    <!-- 제출/참여 현황 -->
                                    <div class="width-40per">
                                        <div class="chart-container" style="height: 350px;">
                                            <canvas id="barChart2"></canvas>
                                        </div>
                                        <script>
                                            const barUtils2 = ChartUtils.init();
                                            const BAR_COUNT2 = 1;
                                            const NUMBER_BAR2 = {
                                                count: BAR_COUNT2,
                                                min: 0,
                                                max: 10
                                            };

                                            const barData2 = {
                                                labels: ['과제', '토론', '퀴즈', '설문', '세미나'],
                                                datasets: [
                                                    {
                                                        label: '제출',
                                                        data: [3, 2, 3, 3, 2],
                                                        backgroundColor: 'rgba(236, 125, 129, 0.7)',
                                                        borderColor:'rgba(236, 125, 129, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    },
                                                    {
                                                        label: '개설',
                                                        data: [3, 3, 5 , 4, 2],
                                                        backgroundColor: 'rgba(168, 168, 218, 0.7)',
                                                        borderColor:'rgba(168, 168, 218, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    }
                                                ]
                                            };

                                            const barConfig2 = {
                                                type: 'bar',
                                                data: barData2,
                                                options: {
                                                    responsive: true,
                                                    maintainAspectRatio: false,
                                                    plugins: {
                                                        legend: { 
                                                            display: true, 
                                                            position: 'bottom',
                                                            labels: {
                                                                boxWidth: 12, 
                                                                font: { size: 12 },
                                                                color: '#333'
                                                            }
                                                        },
                                                        title: {
                                                            display: true,
                                                            text: '제출/참여 현황',
                                                            font: { size: 16 },
                                                            color: '#333',
                                                            align: 'start',
                                                            padding: { bottom: 20 }
                                                        },
                                                        datalabels: {
                                                            display:false
                                                        }
                                                    },
                                                    scales: {
                                                        y: {
                                                            min:0,
                                                            max:6,
                                                            ticks: { color: '#666', font: { size: 12 }, stepSize: 1 }
                                                        },
                                                        x: {
                                                            ticks: { color: '#666', font: { size: 12 } },
                                                        }
                                                    }
                                                },
                                                plugins: [ChartDataLabels]                                    
                                            };

                                            new Chart(document.getElementById('barChart2'), barConfig2);
                                        </script>

                                    </div><!-- //제출/참여 현황 -->

                                    <!-- 중간/기말 점수 -->
                                    <div class="width-30per">
                                        <div class="chart-container" style="height: 350px;">
                                            <canvas id="barChart3"></canvas>
                                        </div>
                                        <script>
                                            const barUtils3 = ChartUtils.init();
                                            const BAR_COUNT3 = 10;
                                            const NUMBER_BAR3 = {
                                                count: BAR_COUNT3,
                                                min: 0,
                                                max: 100
                                            };

                                            const barData3 = {
                                                labels: ['중간고사', '기말고사'],
                                                datasets: [
                                                    {
                                                        label: '점수',
                                                        data: [90],
                                                        backgroundColor: 'rgba(125, 200, 145, 0.85)',
                                                        borderColor:'rgba(125, 200, 145, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    },
                                                    {
                                                        label: '평균점수',
                                                        data: [75],
                                                        backgroundColor:'rgba(190, 160, 235, 0.85)',
                                                        borderColor:'rgba(190, 160, 235, 1)',
                                                        borderWidth: 1,
                                                        barThickness: 25
                                                    }
                                                ]
                                            };

                                            const barConfig3 = {
                                                type: 'bar',
                                                data: barData3,
                                                options: {
                                                    responsive: true,
                                                    maintainAspectRatio: false,
                                                    plugins: {
                                                        legend: { 
                                                            display: true, 
                                                            position: 'bottom',
                                                            labels: {
                                                                boxWidth: 12, 
                                                                font: { size: 12 },
                                                                color: '#333'
                                                            }
                                                        },
                                                        title: {
                                                            display: true,
                                                            text: '중간/기말 점수',
                                                            font: { size: 16 },
                                                            color: '#333',
                                                            align: 'start',
                                                            padding: { bottom: 20 }
                                                        },
                                                        datalabels: {
                                                            display:false
                                                        }
                                                    },
                                                    scales: {
                                                        y: {
                                                            min:0,
                                                            max:100,
                                                            ticks: { color: '#666', font: { size: 12 }, stepSize: 10 }
                                                        },
                                                        x: {
                                                            ticks: { color: '#666', font: { size: 12 } },
                                                        }
                                                    }
                                                },
                                                plugins: [ChartDataLabels]                                    
                                            };

                                            new Chart(document.getElementById('barChart3'), barConfig3);
                                        </script>
                                    </div><!-- //중간/기말 점수 -->
                                </div>

                                <div class="board_top">
                                    <h4 class="fs-16px">학습 현황</h4>
                                </div>
                                <div class="table-wrap">
                                    <table class="table-type3">
                                        <thead>
                                            <th scope="col">주차</th>
                                            <th scope="col">1</th>
                                            <th scope="col">2</th>
                                            <th scope="col">3</th>
                                            <th scope="col">4</th>
                                            <th scope="col">5</th>
                                            <th scope="col">6</th>
                                            <th scope="col">7</th>
                                            <th scope="col">8</th>
                                            <th scope="col">9</th>
                                            <th scope="col">10</th>
                                            <th scope="col">11</th>
                                            <th scope="col">12</th>
                                            <th scope="col">13</th>
                                            <th scope="col">14</th>
                                            <th scope="col">15</th>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th data-th="주차">학습</th>
                                                <td data-th="1"><span class="state_ok" aria-label="출석">○</span></td>
                                                <td data-th="2"><span class="state_no" aria-label="결석">X</span></td>
                                                <td data-th="3"><span class="state_late" aria-label="지각">△</span></td>
                                                <td data-th="4"><span class="state_ok" aria-label="출석">○</span></td>
                                                <td data-th="5"><span class="state_ok" aria-label="출석">○</span></td>
                                                <td data-th="6"><span class="state_ok" aria-label="출석">○</span></td>
                                                <td data-th="7">-</td>
                                                <td data-th="8">/</td>
                                                <td data-th="9">-</td>
                                                <td data-th="10">-</td>
                                                <td data-th="11">-</td>
                                                <td data-th="12">-</td>
                                                <td data-th="13">-</td>
                                                <td data-th="14">-</td>
                                                <td data-th="15">/</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>                            
                        </div>

                        <div class="btns mb20">
                            <button type="button" class="btn type2">닫기</button>
                        </div>
                    </div>
                </div>
            </div><!-- //Modal1 분석자료 -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>


<script>
$(document).ready(function() {

    $('.modal__btn').on('click', function() {
        const targetModal = $(this).data('target'); 
        const $content = $(targetModal).find('.modal-body');
        
        const title = $(this).text().trim(); 

        UiDialog("dialog1", {
            title: title,
            width: '90%',
            height: 780,
            html: $content
        });
    });
});
</script>