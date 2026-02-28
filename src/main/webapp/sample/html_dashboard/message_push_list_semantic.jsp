<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
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

                    <div class="page-info">
                        <div class="navi_bar">
                            <nav class="sub_navi">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>메시지함</li>
                                    <li><span class="current">PUSH</span></li>
                                </ul>
                            </nav>
                        </div>
                    </div>

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <h2 class="page-title"><span>메시지함</span>PUSH</h2>

                        <!-- search typeA -->
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
                                        <option value="평생교육">평생교육</option>
                                    </select>
                                    <select class="form-select wide" id="selectSubject">
                                        <option value="">운영과목 선택</option>
                                        <option value="운영과목1">운영과목1</option>
                                        <option value="운영과목2">운영과목2</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">요청 일시</label></span>
                                <div class="itemList">
                                    <!-- 달력 전용 Fomantic UI CSS (페이지 전체에 적용되지 않도록 wrapper 안에 포함) -->
<div id="calendarWrapper">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fomantic-ui@2.9.4/dist/semantic.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fomantic-ui-calendar@2.9.4/dist/calendar.min.css">

  <div class="date_area">
    <!-- 시작일 -->
    <div class="ui calendar" id="startCalendar">
      <div class="ui input left icon">
        <i class="calendar alternate outline icon"></i>
        <input type="text" placeholder="시작일">
      </div>
    </div>

    <!-- 종료일 -->
    <div class="ui calendar" id="endCalendar">
      <div class="ui input left icon">
        <i class="calendar alternate outline icon"></i>
        <input type="text" placeholder="종료일">
      </div>
    </div>
  </div>
</div>


<!-- 달력 JS (페이지 전체에는 영향 없음) -->
<script src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.9.4/dist/semantic.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fomantic-ui-calendar@2.9.4/dist/calendar.min.js"></script>

<style>
/* 기존 페이지 폰트 유지 */
body, input, select, textarea {
  font-size: 14px !important;  /* 기존 페이지 폰트 크기 */
  line-height: normal !important;
}

/* 달력 영역 전용 스타일 */
#calendarWrapper .date_area {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

#calendarWrapper .ui.input input {
  width: 150px;
  font-size: 14px; /* 달력 input 크기 */
}
</style>

<script>
$(function() {

  // 날짜+시간 포맷
  function formatDate(date) {
    if (!date) return "";
    const y = date.getFullYear();
    const m = date.getMonth() + 1;
    const d = date.getDate();
    const h = date.getHours().toString().padStart(2,'0');
    const min = date.getMinutes().toString().padStart(2,'0');
    return `${y}.${m}.${d} ${h}:${min}`;
  }

  // 시작일 달력
  $('#startCalendar').calendar({
    type: 'datetime',
    endCalendar: $('#endCalendar'),
    formatter: { date: formatDate },
    text: {
      months: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
      monthsShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
      days:['일','월','화','수','목','금','토']
    },
    onChange: function(date, text) {
      $('#startCalendar input').val(text);
    }
  });

  // 종료일 달력
  $('#endCalendar').calendar({
    type: 'datetime',
    startCalendar: $('#startCalendar'),
    formatter: { date: formatDate },
    text: {
      months: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
      monthsShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
      days:['일','월','화','수','목','금','토']
    },
    onChange: function(date, text) {
      $('#endCalendar input').val(text);
    }
  });

});
</script>



                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="발신자">발신자</option>
                                        <option value="발신자번호">발신자번호</option>
                                        <option value="제목">제목</option>
                                        <option value="내용">내용</option>
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어를 입력해주세요.">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <!-- listTab  -->
                        <ul class="tabs">
                            <li class="active"><a href="#">수신목록</a></li>
                            <li><a href="#">발신목록</a></li>
                            <div class="right-area">
                                <button type="button" class="btn basic icon"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                            </div>
                        </ul>

                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 목록</h3>
                            <span class="total_num">총 <strong>90</strong>건</span>
                            <div class="right-area">
                                <button type="button" class="btn type2">발신하기</button>
                            </div>
                        </div>

                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:10%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:11%">
                                    <col style="">
                                    <col style="width:11%">
                                    <col style="width:4%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>과정</th>
                                        <th>운영과목</th>
                                        <th>반</th>
                                        <th>발신자</th>
                                        <th>발신자번호</th>
                                        <th>제목</th>
                                        <th>발신일시</th>
                                        <th>읽음</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음">-</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type2-->

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

