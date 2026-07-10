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
                            <h2 class="page-title">수업일정</h2>
                        </div>
                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <div class="schedule-calendar">
                            <!-- 캘린더 상단 컨트롤 -->
                            <div class="cal-toolbar">
                                <div class="cal-toolbar-left">
                                    <button type="button" class="btn">오늘</button>
                                </div>
                                <dic class="cal-toolbar-center">
                                    <div class="cal-nav">
                                        <button type="button" class="prev" aria-label="이전 달"><i class="xi-angle-left" aria-hidden="true"></i></button>
                                        <strong class="cal-period">2026.03</strong>
                                        <button type="button" aria-label="다음 달"><i class="xi-angle-right" aria-hidden="true"></i></button>
                                    </div>
                                </dic>
                                <div class="cal-toolbar-right">
                                    <div class="cal-view-toggle" role="tablist" aria-label="보기 전환">
                                        <button type="button" class="btn" role="tab" aria-selected="true">주별</button>
                                        <!-- 버튼 활성화시 type1스타일 -->
                                        <button type="button" class="btn type1 " role="tab" aria-selected="true">월별</button>
                                    </div>
                                    <button type="button" class="btn type1 btnPlus"><i class="xi-plus"></i></button>
                                </div>
                            </div>

                            <!-- 월별 캘린더 -->
                            <div class="table-wrap" role="grid" aria-label="2026년 3월 수업일정">
                                <!-- 요일 헤더 -->
                                <div class="cal-weekdays" role="row">
                                    <div class="cal-weekday sun" role="columnheader">일</div>
                                    <div class="cal-weekday" role="columnheader">월</div>
                                    <div class="cal-weekday" role="columnheader">화</div>
                                    <div class="cal-weekday" role="columnheader">수</div>
                                    <div class="cal-weekday" role="columnheader">목</div>
                                    <div class="cal-weekday" role="columnheader">금</div>
                                    <div class="cal-weekday sat" role="columnheader">토</div>
                                </div>

                                <!-- 1주 -->
                                <div class="cal-week" role="row">
                                    <div class="cal-day other-month sun" role="gridcell">
                                        <span class="cal-date">31</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">1</span>
                                    </div>
                                    <div class="cal-day today" role="gridcell" aria-current="date">
                                        <span class="cal-date">2</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">3</span>
                                        <ul class="cal-events">
                                            <li>
                                                <span class="dot dot-gray"></span>
                                                <a href="#0" class="ev-link">
                                                    <span class="ev-label">[개별]</span>
                                                    <span class="ev-title">강의시작</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">4</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">5</span>
                                    </div>
                                    <div class="cal-day sat" role="gridcell">
                                        <span class="cal-date">6</span>
                                    </div>
                                </div>

                                <!-- 2주 -->
                                <div class="cal-week has-bar" role="row">
                                    <div class="cal-day sun" role="gridcell">
                                        <span class="cal-date">7</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">8</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">9</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">10</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">11</span>
                                        <ul class="cal-events">
                                            <li>
                                                <span class="dot dot-gray"></span>
                                                <a href="#0" class="ev-link">
                                                    <span class="ev-label">[개별]</span>
                                                    <span class="ev-title">과제등록</span>
                                                </a>
                                            </li>
                                            <li>
                                                <span class="dot dot-orange"></span>
                                                <a href="#0" class="ev-link">
                                                    <span class="ev-lavel">[토론]</span>
                                                    <span class="ev-title">토론명001</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">12</span>
                                    </div>
                                    <div class="cal-day sat" role="gridcell">
                                        <span class="cal-date">13</span>
                                    </div>
                                    <!-- 8~20일까지의 다음주로 이어지는 일정 -->
                                    <a href="#0" class="cal-event-bar bar-red continues-right" style="left: calc(100% / 7 * 1 + 4px); width: calc(100% / 7 * 6 - 4px);" title="[과제] 과제명001 (3/8~3/20)">
                                        <span class="ev-label">[과제]</span>
                                        <span class="ev-title">과제명001</span>
                                    </a>
                                </div>

                                <!-- 3주 -->
                                <div class="cal-week has-bar" role="row">
                                    <div class="cal-day sun" role="gridcell">
                                        <span class="cal-date">14</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">15</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">16</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">17</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">18</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">19</span>
                                    </div>
                                    <div class="cal-day sat" role="gridcell">
                                        <span class="cal-date">20</span>
                                    </div>
                                    <!-- 8~20일까지의 일정 종료 -->
                                    <a href="#0" class="cal-event-bar bar-red continues-left" style="left: 0; width: calc(100% - 4px);" title="[과제] 과제명001 (3/8~3/20)">
                                    </a>
                                </div>

                                <!-- 4주 -->
                                <div class="cal-week has-bar" role="row">
                                    <div class="cal-day sun" role="gridcell">
                                        <span class="cal-date">21</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">22</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">23</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">24</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">25</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">26</span>
                                    </div>
                                    <div class="cal-day sat" role="gridcell">
                                        <span class="cal-date">27</span>
                                    </div>
                                    <!-- 22~24일까지의 일정 -->
                                    <a href="#0" class="cal-event-bar bar-orange" style="left: calc(100% / 7 * 1 + 4px); width: calc(100% / 7 * 3 - 8px);" title="[토론] 토론명001 (3/22~3/24)">
                                        <span class="ev-label">[토론]</span>
                                        <span class="ev-title">토론명001</span>
                                    </a>
                                </div>

                                <!-- 5주 -->
                                <div class="cal-week" role="row">
                                    <div class="cal-day sun" role="gridcell">
                                        <span class="cal-date">28</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">29</span>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">30</span>
                                        <ul class="cal-events">
                                            <li>
                                                <span class="dot dot-orange"></span>
                                                <a href="#0" class="ev-link">
                                                    <span class="ev-label">[토론]</span>
                                                    <span class="ev-title">토론명002</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="cal-day" role="gridcell">
                                        <span class="cal-date">31</span>
                                        <ul class="cal-events">
                                            <li>
                                                <span class="dot dot-red"></span>
                                                <a href="#0" class="ev-link">
                                                    <span class="ev-label">[과제]</span>
                                                    <span class="ev-title">과제명002</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="cal-day other-month" role="gridcell">
                                        <span class="cal-date">1</span>
                                    </div>
                                    <div class="cal-day other-month" role="gridcell">
                                        <span class="cal-date">2</span>
                                    </div>
                                    <div class="cal-day other-month sat" role="gridcell">
                                        <span class="cal-date">3</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- //schedule calendar -->

                    </div>

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" id="btn-modal1">수업일정 보기</button>
                        <button type="button" class="btn modal__btn" id="btn-modal2">개별일정 수정</button>
                    </div>
                    <!-- //modal popup 보여주기 버튼(개발시 삭제) -->

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->


        <!-- Modal1 참여관리/관리이력 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="search-typeA mb10">
                        <div class="item">
                            <strong>기간</strong> 2026.03.22 09:00 ~ 2026.03.28 19:00
                        </div>
                    </div>
                    <div class="lecture_box">
                        본 수업 일정은 학사 운영 사정에 따라 일부 변경될 수 있습니다.<br>과제 제출 기한과 토론 참여 기간을 반드시 준수하여 학습에 차질이 없으시길 바랍니다.<br>
                        상세 안내 사항은 강의실 공지사항을 통해 수시로 확인하시기 바라며, 추가 문의 사항은 교수자 정보의 연락처나 Q&A 게시판을 이용해 주시기 바랍니다.
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 참여관리/관리이력 -->


        <!-- Modal2 개별일정 수정 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>

                            <tbody>
                                <tr>
                                    <th scope="col">기관/학기</th>
                                    <td data-th="기관">대학원 / 2026년 1학기</td>
                                </tr>
                                <tr>
                                    <th scope="col">과목</th>
                                    <td data-th="과목">일한 번역연습</td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">제목</th>
                                    <td data-th="제목">
                                        <div class="form-row">
                                            <input class="form-control width-50per" type="text" name="name" id="name_label" value="" placeholder="제목을 입력하세요" required="true" inputmask="byte" maxLen="10" minLen="4">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col" class="req">기간</th>
                                    <td data-th="기간">
                                        <div class="date_area">
                                            <input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
                                            <input type="text" placeholder="시작시간" id="timepicker3" class="timepicker" dateId="datepicker3">
                                            <span class="txt-sort">~</span>
                                            <input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
                                            <input type="text" placeholder="종료시간" id="timepicker4" class="timepicker" dateId="datepicker4">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="col">설명</th>
                                    <td data-th="설명">
                                        <dl>
                                            <dd>
                                                <div class="editor-box">
                                                    <label for="atclCts" class="hide">Content</label>
                                                    <textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
                                                    <script>
                                                        // HTML 에디터
                                                        let editor = UiEditor({
                                                            targetId: "atclCts",
                                                            uploadPath: "/bbs",
                                                            height: "500px"
                                                        });
                                                    </script>
                                                </div>

                                                <a href="#_" onclick="checkEditorContens();return false;">[입력내용확인]</a> &nbsp;
                                                <a href="#_" onclick="insertEditorContens1();return false;">[내용추가(text)]</a> &nbsp;
                                                <a href="#_" onclick="insertEditorContens2();return false;">[내용바꾸기(html)]</a>
                                                <script>
                                                    function checkEditorContens() {
                                                        if (editor.isEmpty()) {
                                                            alert("비어있다....");
                                                        }
                                                        else {
                                                            let text = $("#atclCts").val(); // editor.editor.getPublishingHtml()
                                                            alert(text);
                                                        }
                                                    }

                                                    function insertEditorContens1() {
                                                        //editor.execCommand('selectAll');
                                                        //editor.execCommand('deleteLeft');
                                                        editor.execCommand('insertText', "<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                    }

                                                    function insertEditorContens2() {
                                                        editor.openHTML("<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
                                                    }
                                                </script>
                                            </dd>
                                        </dl>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">저장</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal2 개별일정 수정 -->


        <script>
            $(function() {
                // 수업일정 보기
                $('#btn-modal1').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "수업일정 003",
                        width: 640,
                        height: 350,
                        html: $content
                    });
                });
                $('#btn-modal2').on('click', function() {
                    
                    var $content = $('#modal2 .modal-body');

                    UiDialog("dialog1", {
                        title: "개별일정 수정",
                        width: 1200,
                        height: 600,
                        html: $content
                    });
                });
            });
        </script>

    </div>

</body>
</html>
