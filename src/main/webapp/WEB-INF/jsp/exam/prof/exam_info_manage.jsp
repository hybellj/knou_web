<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		var asmtEditor = null;
		var quizEditor = null;
        var quizManageEditor = null;

        /* 탭 변경시 텍스트 에디터 호출 로직 */
		function initSbstEditors() {
			if (!asmtEditor) {
				asmtEditor = UiEditor({ targetId: "asmt-cts", uploadPath: "/asmt", height: "250px" });
			}
			if (!quizEditor) {
				quizEditor = UiEditor({ targetId: "quiz-cts", uploadPath: "/quiz", height: "250px" });
			}
            if (!quizManageEditor) {
                quizManageEditor = UiEditor({ targetId: "quiz-manage-cts", uploadPath: "/quiz", height: "250px" });
            }
		}

		$(document).ready(function() {
			/* 탭 전환 */
			$(".tab-type1 a.btn").on("click", function(e) {
				e.preventDefault();
				var target = $(this).attr("href");
				$(".tab-type1 a.btn").removeClass("current");
				$(this).addClass("current");
				$(".tab-content").hide();
				$(target).show();
				if (target === "#exam-evl-sbst") {
					initSbstEditors();
				}
			});

			/* [대체과제] 라디오 버튼 선택에 따라 과제/퀴즈 폼 표시 */
			function toggleAbsntForm() {
				var val = $('input[name="absnt-type-rd"]:checked').val();
				$("#asmt-write").toggle(val === 'Y');
				$("#quiz-write").toggle(val === 'N');
				$("#quiz-mng-btn").toggle(val === 'N');
			}

			$('input[name="absnt-type-rd"]').on("change", toggleAbsntForm);
			toggleAbsntForm(); // 초기 상태 적용
		});
	</script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="class_sub_top">
                    <div class="navi_bar">
                        <ul>
                            <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                            <li>강의실</li>
                            <li><span class="current">시험</span></li>
                        </ul>
                    </div>
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
                        </div>
                    </div>
                </div>

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info"><span>공지</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>Q&A</span><div class="num_txt point">17</div></a>
                                    <a href="#0" class="info"><span>1:1</span><div class="num_txt point">3</div></a>
                                    <a href="#0" class="info"><span>과제</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>토론</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>세미나</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>설문</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>시험</span><div class="num_txt">2</div></a>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point"><span class="tit">중간고사:</span><span>2025.04.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                    <div class="info">
                                        <p class="point"><span class="tit">기말고사:</span><span>2025.07.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">
                            <div class="flex">
                                <div class="item week">
                                    <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                    <div class="item_tit">2025.04.14 ~ 04.20</div>
                                    <div class="item_info"><span class="big">7</span><span class="small">주차</span></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 하단 영역 -->
                    <div class="box span-2 subject">
                        <div class="box_title">
                            <!--tab-type1-->
                            <nav class="tab-type1">
                                <a href="#exam-dtl" class="btn current"><span>시험정보 및 평가</span></a>
                                <a href="#exam-evl-sbst" class="btn"><span>시험 대체</span></a>
                                <a href="#exam-absnce" class="btn"><span>결시 내용 및 현황</span></a>
                                <a href="#exam-dsbl" class="btn"><span>장애인/고령자 지원현황</span></a>
                                <a href="#exam-quiz-manage" class="btn"><span>퀴즈관리</span></a>
                            </nav>
                        </div>

                        <div class="box_content">
                            <div class="segment">
                                <!-- 고정 영역 -->
                                <div class="board_top">
                                    <i class="icon-svg-openbook"></i>
                                    <!-- 탭에 따라서 메인 제목을 바꾸는 로직이 필요하다 -->
                                    <h3 class="board-title">시험정보 및 평가</h3>
                                    <div class="right-area">
                                        <!-- 탭에 따라서 버튼 숨기는 로직이 필요하다 -->
                                        <button type="button" id = "modify-exam-info-btn" class="btn type2">수정</button>
                                        <button type="button" id = "delete-exam-info-btn" class="btn type2">삭제</button>
                                        <button type="button" id = "into-exam-list-btn" class="btn basic">목록</button>
                                    </div>
                                </div>
                                <!-- 등록 영역 -->
                                <div class="course_list">
                                    <ul class="accordion course_week">
                                        <li class="active"><!-- 클릭시 active 추가 -->
                                            <div class="title-wrap">
                                                <a class="title" href="#">
                                                    <i class="arrow xi-angle-down"></i>
                                                    <p class="labels">
                                                        <label class="label s_ing">중간고사</label>
                                                    </p>
                                                    <strong>실시간 중간고사 (하드코딩 됨)</strong>
                                                    <p class="desc">
                                                        <span><strong>실시간 온라인</strong></span>
                                                        <span>시험일시 : <strong>2025.06.02 ~ 2025.06.10</strong></span>
                                                        <span>성적반영 : <strong>예</strong></span>
                                                        <span>성적공개 : <strong>아니오</strong></span>
                                                    </p>
                                                </a>
                                            </div>
                                            <div class = "cont">
                                                <div class = "table-wrap">
                                                    <table class = "table-type5">
                                                        <colgroup>
                                                            <col class="width-15per" />
                                                            <col class="" />
                                                        </colgroup>
                                                            <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                                            <tbody>
                                                            <!-- 시험 구분 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="exam-gubun-label">시험구분</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        <div class="form-inline">
                                                                            중간고사 (현재 하드코딩 됨)
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 시험방식 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="exam-type-label">시험방식</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        <div class="form-inline">
                                                                            실시간 온라인 (현재 하드코딩 됨)
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <th>
                                                                    <label for="contTextarea">시험내용</label>
                                                                </th>
                                                                <td data-th="입력">
                                                                    <li>
                                                                        <dl>
                                                                            <dd>
                                                                                <div class="editor-box">
                                                                                    <label for="examCts" class="hide">Content</label>
                                                                                    <textarea id="examCts" name="examCts" required="true"></textarea>
                                                                                    <script>
                                                                                        // HTML 에디터
                                                                                        let editor = UiEditor({
                                                                                            targetId: "examCts",
                                                                                            uploadPath: "/exam",
                                                                                            height: "500px"
                                                                                        });
                                                                                    </script>
                                                                                </div>
                                                                            </dd>
                                                                        </dl>
                                                                    </li>
                                                                    </section>
                                                                    <!--//섹션 에디터-->
                                                                </td>
                                                            </tr>
                                                            <!-- 시험일시 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="noticeLabel">시험일시</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        2026.09.30 10:00 (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 시험시간 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="timeLabel">시험시간</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        50분 (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 성적반영 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="mkr-rfltyn-label">성적반영</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        예 (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 반영비율 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="mkr-rfltyn-label">성적반영비율</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        35% (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 성적공개 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="mkr-oyn-label">성적공개</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        예 (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 시험지공개 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="examppr-oyn-label">시험지공개</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        아니오 (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 팀 시험 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="exam-team-label">팀 시험</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        아니오 (현재 하드코딩 됨)
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <!-- 시험대체 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="exam-team-label">팀 시험</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        과제 (현재 하드코딩 됨)
                                                                    </div>
                                                                    <button type="button" class = "btn basic">시험 대체</button>
                                                                </td>
                                                            </tr>
                                                            <!-- 결시현황 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="exam-team-label">결시현황</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        5명 (현재 하드코딩 됨)
                                                                    </div>
                                                                    <button type="button" class = "btn basic">결시 내용 및 현황</button>
                                                                </td>
                                                            </tr>
                                                            <!-- 결시현황 -->
                                                            <tr>
                                                                <th>
                                                                    <label for="exam-team-label">장애인/고령자 지원</label>
                                                                </th>
                                                                <td>
                                                                    <div class="form-inline">
                                                                        2명 (현재 하드코딩 됨)
                                                                    </div>
                                                                    <button type="button" class = "btn basic">장애인/고령자 지원</button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>

                                </div>

                                <!-- 시험정보 및 평가 -->
                                <div id="exam-dtl" class="tab-content" style="display: block;">
                                    <!-- 시험정보 및 평가 상단영역 -->
                                    <div class="board_top">
                                        <h3 class="board-title">시험평가</h3>
                                        <div class="right-area">
                                            <button type="button" id="insert-xlsx-score-btn" class="btn type2">엑셀로 점수 등록</button>
                                            <button type="button" id="send-sms-btn" class="btn type2">보내기</button>
                                        </div>
                                    </div>
                                    <!-- 시험정보 및 평가 검색영역 -->
                                    <div class="search-typeB">
                                        <div class = "item" id = "t-1">
                                            <span class = "item_tit">
                                                <label for = "">응시 여부</label>
                                            </span>
                                            <div class = "itemList">
                                                <select class="form-select chosen" id="t-s-1">
                                                    <option value="ALL" selected>전체</option>
                                                    <option value="N">미응시</option>
                                                    <option value="Y">응시완료</option>
                                                </select>
                                            </div>
                                            <span class = "item_tit">
                                                <label for = "">평가 여부</label>
                                            </span>
                                            <div class = "itemList">
                                                <select class="form-select chosen" id="t-s-2">
                                                    <option value="ALL" selected>전체</option>
                                                    <option value="Y">평가</option>
                                                    <option value="N">미평가</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class = "item" id = "t-2">
                                            <span class = "item_tit">
                                                <label for = "">이 름</label>
                                            </span>
                                            <div class = "itemList">
                                                <input class = "form-control" type = "text" id = "t-i-1" placeholder = "이름 입력">
                                            </div>
                                            <span class = "item_tit">
                                                <label for = ""></label>
                                            </span>
                                            <div class = "itemList">
                                            </div>
                                        </div>
                                        <div class="button-area">
                                            <button type = "button" id = "t-b-1" class="btn search">검색</button>
                                            <button type = "button" id = "t-b-2" class="btn search">수강생 전체</button>
                                        </div>
                                    </div>
                                    <div class="board_top">
                                        <div class="right-area">
                                            <button type="button" id="A3" class="btn type2">엑셀로 다운로드</button>
                                            <button type="button" id="A4" class="btn type2">성적분포도</button>
                                        </div>
                                    </div>
                                    시험정보 및 평가 tabulator 위치
                                </div>
                                <!-- 시험 대체 -->
                                <div id="exam-evl-sbst" class="tab-content" style="display: none;">
                                    <!-- 시험 대체 상단영역 -->
                                    <div class="board_top">
                                        <!-- [중간고사] 라고 쓰인 영역 데이터 받도록 해야함. -->
                                        <h3 class="board-title">[중간고사] 시험 대체 설정</h3>
                                        <div class="right-area">
                                            <button type="button" id="save-sbst-btn" class="btn type2">저장</button>
                                            <button type="button" id="quiz-mng-btn" class="btn type2">문항관리</button>
                                        </div>
                                    </div>
                                    <!-- 시험정보 및 평가 검색영역 -->
                                    <div class="search-typeB">
                                        <div class = "item" id = "serch-sbst">
                                            <span class = "item_tit">
                                                <label for = "">시험대체 유형</label>
                                            </span>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="absnt-type-rd" id="absnt-type-amst-rd" value="Y" checked="">
                                                    <label for="absnt-type-amst-rd">과제</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="absnt-type-rd" id="absnt-type-quiz-rd" value="N">
                                                    <label for="absnt-type-quiz-rd">퀴즈</label>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- [과제] 시험 대체 form 영역 -->
                                    <form id = "asmt-write" name = "asmt-write">
                                        <table class = "table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                            <tbody>
                                                <!-- [과제] 과제명 -->
                                                <tr>
                                                    <th>
                                                        <label for="asmt-ttl-label" class ="req">과제명</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input class="form-control width-50per" type="text" name="name" id="asmt-ttl-label" value="" placeholder="과제명 입력" required="true" inputmask="byte" maxlen="30" minlen="3" autocomplete="off">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [과제] 과제내용 -->
                                                <tr>
                                                    <th>
                                                        <label for="contTextarea" class = "req">과제내용</label>
                                                    </th>
                                                    <td data-th="입력">
                                                        <li>
                                                            <dl>
                                                                <dd>
                                                                    <div class="editor-box">
                                                                        <label for="asmt-cts" class="hide">Content</label>
                                                                        <textarea id="asmt-cts" name="asmt-cts" required="true"></textarea>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                        </li>
                                                        </section>
                                                        <!--//섹션 에디터-->
                                                    </td>
                                                </tr>
                                                <!-- [과제] 제출기간 -->
                                                <tr>
                                                    <th>
                                                        <label for="noticeLabel" class = "req">제출기간</label>
                                                    </th>
                                                    <td>
                                                        <div class="date_area">
                                                            <input type="text" placeholder="시작일" id="asmt-sbmsn-sdttm1" class="datepicker" timeId="asmt-sbmsn-sdttm2" required="true">
                                                            <input type="text" placeholder="시작시간" id="asmt-sbmsn-sdttm2" class="timepicker" dateId="asmt-sbmsn-sdttm1" required="true">
                                                            <span class="txt-sort">~</span>
                                                            <input type="text" placeholder="종료일" id="asmt-sbmsn-edttm1" class="datepicker" timeId="asmt-sbmsn-edttm2" required="true">
                                                            <input type="text" placeholder="종료시간" id="asmt-sbmsn-edttm2" class="timepicker" dateId="asmt-sbmsn-edttm1" required="true">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [과제] 성적반영 -->
                                                <tr>
                                                    <th>
                                                        <label for="asmt-mkr-rfltyn-label">성적반영</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-mkr-rfltyn-rd" id="asmt-mkr-rfltyn-y-rd" value="Y" checked="">
                                                                <label for="asmt-mkr-rfltyn-y-rd">예</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="asmt-mkr-rfltyn-rd" id="asmt-mkr-rfltyn-n-rd" value="N">
                                                                <label for="asmt-mkr-rfltyn-n-rd">아니오</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [과제] 성적공개 -->
                                                <tr>
                                                    <th>
                                                        <label for="asmt-mkr-oyn-label">성적공개</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-mkr-oyn-rd" id="asmt-mkr-oyn-y-rd" value="Y" checked="">
                                                                <label for="asmt-mkr-oyn-y-rd">예</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="asmt-mkr-oyn-rd" id="asmt-mkr-oyn-n-rd" value="N">
                                                                <label for="asmt-mkr-oyn-n-rd">아니오</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [과제] 평가방법 -->
                                                <tr>
                                                    <th>
                                                        <label for="asmt-evl-scr-tycd-label">평가방법</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-evl-scr-tycd-rd" id="asmt-evl-scr-tycd-scr-rd" value="SCR" checked="">
                                                                <label for="asmt-evl-scr-tycd-scr-rd">점수형</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="asmt-evl-scr-tycd-rd" id="asmt-evl-scr-tycd-rblc-rd" value="RUBRIC_SCR">
                                                                <label for="asmt-evl-scr-tycd-rblc-rd">루브릭</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [과제] 제출형식 -->
                                                <tr>
                                                    <th>
                                                        <label for="asmt-sbasmt-tycd-label" class = "req">제출형식</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-sbasmt-tycd-rd" id="asmt-sbasmt-tycd-fl-rd" value="FILE" checked="">
                                                                <label for="asmt-sbasmt-tycd-fl-rd">파일</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="asmt-sbasmt-tycd-rd" id="asmt-sbasmt-tycd-inpt-txt-rd" value="INPUT_TEXT">
                                                                <label for="asmt-sbasmt-tycd-inpt-txt-rd">텍스트</label>
                                                            </span>
                                                        </div>
                                                        <div class="form-row">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-sbasmt-fl-mm-tycd-rd" id="asmt-sbasmt-fl-mm-tycd-all-rd" value="ALL" checked="">
                                                                <label for="asmt-sbasmt-fl-mm-tycd-all-rd">모든 파일 가능</label>
                                                            </span>
                                                        </div>
                                                        <div class="form-row">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-sbasmt-fl-mm-tycd-rd" id="asmt-sbasmt-fl-mm-tycd-prv-rd" value="PRVIEW">
                                                                <label for="asmt-sbasmt-fl-mm-tycd-prv-rd">미리 보기 가능</label>
                                                            </span>
                                                            <div class="checkbox_type">
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="img">
                                                                    <label for="img">이미지 (JPG, GIF, PNG)</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="pdf">
                                                                    <label for="pdf">PDF</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="text">
                                                                    <label for="text">TEXT</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="program-source">
                                                                    <label for="program-source">프로그램 소스</label>
                                                                </span>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <span class="custom-input">
                                                                <input type="radio" name="asmt-sbasmt-fl-mm-tycd-rd" id="asmt-sbasmt-fl-mm-tycd-Spcfc-rd" value="SPECIFIC">
                                                                <label for="asmt-sbasmt-fl-mm-tycd-Spcfc-rd">특정 파일 가능</label>
                                                            </span>
                                                            <div class="checkbox_type">
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="HWP">
                                                                    <label for="img">HWP</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="DOC">
                                                                    <label for="pdf">DOC</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="PPT">
                                                                    <label for="text">PPT</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="name" id="XLS">
                                                                    <label for="XLS">XLS</label>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [과제] 파일첨부 -->
                                                <tr>
                                                    <th>
                                                        <label for="asmt-sbmsn-atfl-label">파일첨부</label>
                                                    </th>
                                                    <td>
                                                        <uiex:dextuploader
                                                            id="fileUploader"
                                                            path="/asmt"
                                                            limitCount="5"
                                                            limitSize="100"
                                                            oneLimitSize="100"
                                                            listSize="3"
                                                            fileList=""
                                                            finishFunc="finishUpload()"
                                                            allowedTypes="*"
                                                        />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </form>
                                    <!-- [퀴즈] 시험 대체 form 영역 -->
                                    <form id = "quiz-write" name = "quiz-write">
                                        <table class = "table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                            <tbody>
                                                <!-- [퀴즈] 퀴즈명 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-ttl-label" class ="req">퀴즈명</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input class="form-control width-50per" type="text" name="name" id="quiz-ttl-label" value="" placeholder="퀴즈명 입력" required="true" inputmask="byte" maxlen="30" minlen="3" autocomplete="off">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 퀴즈내용 -->
                                                <tr>
                                                    <th>
                                                        <label for="contTextarea" class = "req">퀴즈내용</label>
                                                    </th>
                                                    <td data-th="입력">
                                                        <li>
                                                            <dl>
                                                                <dd>
                                                                    <div class="editor-box">
                                                                        <label for="quiz-cts" class="hide">Content</label>
                                                                        <textarea id="quiz-cts" name="quiz-cts" required="true"></textarea>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                        </li>
                                                        </section>
                                                        <!--//섹션 에디터-->
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 응시기간 -->
                                                <tr>
                                                    <th>
                                                        <label for="noticeLabel" class = "req">응시기간</label>
                                                    </th>
                                                    <td>
                                                        <div class="date_area">
                                                            <input type="text" placeholder="시작일" id="quiz-sbmsn-sdttm1" class="datepicker" timeId="quiz-sbmsn-sdttm2" required="true">
                                                            <input type="text" placeholder="시작시간" id="quiz-sbmsn-sdttm2" class="timepicker" dateId="quiz-sbmsn-sdttm1" required="true">
                                                            <span class="txt-sort">~</span>
                                                            <input type="text" placeholder="종료일" id="quiz-sbmsn-edttm1" class="datepicker" timeId="quiz-sbmsn-edttm2" required="true">
                                                            <input type="text" placeholder="종료시간" id="quiz-sbmsn-edttm2" class="timepicker" dateId="quiz-sbmsn-edttm1" required="true">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 성적반영 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-mkr-rfltyn-label">성적반영</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-y-rd" value="Y" checked="">
                                                                    <label for="quiz-mkr-rfltyn-y-rd">예</label>
                                                                </span>
                                                            <span class="custom-input ml5">
                                                                    <input type="radio" name="quiz-mkr-rfltyn-rd" id="quiz-mkr-rfltyn-n-rd" value="N">
                                                                    <label for="quiz-mkr-rfltyn-n-rd">아니오</label>
                                                                </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 성적공개 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-mkr-oyn-label">성적공개</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-y-rd" value="Y" checked="">
                                                                    <label for="quiz-mkr-oyn-y-rd">예</label>
                                                                </span>
                                                            <span class="custom-input ml5">
                                                                    <input type="radio" name="quiz-mkr-oyn-rd" id="quiz-mkr-oyn-n-rd" value="N">
                                                                    <label for="quiz-mkr-oyn-n-rd">아니오</label>
                                                                </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 문제표시방식 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-view-type-label">문제표시방식</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-all-rd" value="ALL" checked="">
                                                                    <label for="quiz-view-type-all-rd">전체 문제표시</label>
                                                                </span>
                                                            <span class="custom-input ml5">
                                                                    <input type="radio" name="quiz-view-type-rd" id="quiz-view-type-one-rd" value="ONE">
                                                                    <label for="quiz-view-type-one-rd">1문제씩 표시</label>
                                                                </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 문제 섞기 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-mix-type-label" class = "req">문제섞기</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input type="checkbox" id="quiz-mix-type" class="switch yesno">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 보기 섞기 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-view-mix-type-label" class = "req">보기섞기</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input type="checkbox" id="quiz-view-mix-type" class="switch yesno">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 파일첨부 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-sbmsn-atfl-label">파일첨부</label>
                                                    </th>
                                                    <td>
                                                        <uiex:dextuploader
                                                                id="quizFileUploader"
                                                                path="/quiz"
                                                                limitCount="5"
                                                                limitSize="100"
                                                                oneLimitSize="100"
                                                                listSize="3"
                                                                fileList=""
                                                                finishFunc="finishUpload()"
                                                                allowedTypes="*"
                                                        />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </form>
                                    <!-- 가운데 영역 -->
                                    <div class="board_top">
                                        <div class="right-area">
                                            <button type="button" id="sms-send2-btn" class="btn type2">보내기</button>
                                        </div>
                                    </div>
                                    시험 대체 대상자 tabulator
                                </div>
                                <!-- 결시 내용 및 현황 -->
                                <div id="exam-absnce" class="tab-content" style="display: none;">
                                    <!-- 결시 내용 및 현황 상단영역 -->
                                    <div class="board_top">
                                        <!-- [중간고사] 라고 쓰인 영역 데이터 받도록 해야함. -->
                                        <h3 class="board-title">[중간고사] 결시 내용 및 현황</h3>
                                        <div class="right-area">
                                            <button type="button" id="save-sbst-btn" class="btn type2">보내기</button>
                                        </div>
                                    </div>
                                    <!-- 결시 내용 및 현황 검색영역 -->
                                    <div class="search-typeB">
                                        <div class = "item" id = "t-1">
                                            <span class = "item_tit">
                                                <label for = "">처리상태</label>
                                            </span>
                                            <div class = "itemList">
                                                <select class="form-select chosen" id="t-s-1">
                                                    <option value="ALL" selected>전체</option>
                                                    <option value="1">신청</option>
                                                    <option value="2">승인</option>
                                                    <option value="3">반려</option>
                                                </select>
                                            </div>
                                            <span class = "item_tit">
                                                <label for = "">이 름</label>
                                            </span>
                                            <div class = "itemList">
                                                <input class = "form-control" type = "text" id = "t-i-1" placeholder = "이름 입력">
                                            </div>
                                        </div>
                                        <div class="button-area">
                                            <button type = "button" id = "t-b-1" class="btn search">검색</button>
                                        </div>
                                    </div>
                                    <!-- 결시 내용 및 현황 중단영역 -->
                                    <div class="board_top">
                                        <div class="right-area">
                                            <button type="button" id="download-xlsx-btn" class="btn type2">엑셀로 다운로드</button>
                                        </div>
                                    </div>
                                    결시 내용 및 현황 tabulator
                                </div>
                                <!-- 장애인/고령자 지원현황 -->
                                <div id="exam-dsbl" class="tab-content" style="display: none;">
                                    <!-- 장애인/고령자 지원현황 상단영역 -->
                                    <div class="board_top">
                                        <!-- [중간고사] 라고 쓰인 영역 데이터 받도록 해야함. -->
                                        <h3 class="board-title">[중간고사] 장애인/고령자 지원현황</h3>
                                        <div class="right-area">
                                            <button type="button" id="save-sbst-btn" class="btn type2">보내기</button>
                                        </div>
                                    </div>
                                    <!-- 장애인/고령자 지원현황 검색영역 -->
                                    <div class="search-typeB">
                                        <div class = "item" id = "t-1">
                                            <span class = "item_tit">
                                                <label for = "">처리상태</label>
                                            </span>
                                            <div class = "itemList">
                                                <select class="form-select chosen" id="t-s-1">
                                                    <option value="ALL" selected>전체</option>
                                                    <option value="1">처리대기</option>
                                                    <option value="2">처리완료</option>
                                                </select>
                                            </div>
                                            <span class = "item_tit">
                                                <label for = "">이 름</label>
                                            </span>
                                            <div class = "itemList">
                                                <input class = "form-control" type = "text" id = "t-i-1" placeholder = "이름 입력">
                                            </div>
                                        </div>
                                        <div class="button-area">
                                            <button type = "button" id = "t-b-1" class="btn search">검색</button>
                                        </div>
                                    </div>
                                    <!-- 장애인/고령자 지원현황 중단영역 -->
                                    <div class="board_top">
                                        <div class="right-area">
                                            <button type="button" id="download-xlsx-btn" class="btn type2">엑셀로 다운로드</button>
                                        </div>
                                    </div>
                                    장애인/고령자 지원현황 tabulator
                                </div>
                                <!-- 퀴즈관리 -->
                                <div id="exam-quiz-manage" class="tab-content" style="display: none;">
                                    <!-- 퀴즈관리 상단영역 -->
                                    <div class="board_top">
                                        <!-- [중간고사] 라고 쓰인 영역 데이터 받도록 해야함. -->
                                        <h3 class="board-title">[중간고사] 퀴즈관리</h3>
                                        <div class="right-area">
                                            <button type="button" id="save-quiz-manage-btn" class="btn type2">저장</button>
                                            <button type="button" id="question-quiz-manage-btn" class="btn type2">문항관리</button>
                                        </div>
                                    </div>
                                    <!-- [퀴즈] 시험 대체 form 영역 -->
                                    <form id = "quiz-manage-write" name = "quiz-manage-write">
                                        <table class = "table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <!-- input 입력 폼 (id 전부 db에 맞게 변경해야 함) -->
                                            <tbody>
                                                <!-- [퀴즈] 퀴즈명 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-ttl-label" class ="req">퀴즈명</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input class="form-control width-50per" type="text" name="name" id="quiz-manage-ttl-label" value="" placeholder="퀴즈명 입력" required="true" inputmask="byte" maxlen="30" minlen="3" autocomplete="off">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 퀴즈내용 -->
                                                <tr>
                                                    <th>
                                                        <label for="contTextarea" class = "req">퀴즈내용</label>
                                                    </th>
                                                    <td data-th="입력">
                                                        <li>
                                                            <dl>
                                                                <dd>
                                                                    <div class="editor-box">
                                                                        <label for="quiz-manage-cts" class="hide">Content</label>
                                                                        <textarea id="quiz-manage-cts" name="quiz-manage-cts" required="true"></textarea>
                                                                    </div>
                                                                </dd>
                                                            </dl>
                                                        </li>
                                                        </section>
                                                        <!--//섹션 에디터-->
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 응시기간 -->
                                                <tr>
                                                    <th>
                                                        <label for="noticeLabel" class = "req">응시기간</label>
                                                    </th>
                                                    <td>
                                                        <div class="date_area">
                                                            <input type="text" placeholder="시작일" id="quiz-manage-sbmsn-sdttm1" class="datepicker" timeId="quiz-manage-sbmsn-sdttm2" required="true">
                                                            <input type="text" placeholder="시작시간" id="quiz-manage-sbmsn-sdttm2" class="timepicker" dateId="quiz-manage-sbmsn-sdttm1" required="true">
                                                            <span class="txt-sort">~</span>
                                                            <input type="text" placeholder="종료일" id="quiz-manage-sbmsn-edttm1" class="datepicker" timeId="quiz-manage-sbmsn-edttm2" required="true">
                                                            <input type="text" placeholder="종료시간" id="quiz-manage-sbmsn-edttm2" class="timepicker" dateId="quiz-manage-sbmsn-edttm1" required="true">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 성적반영 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-mkr-rfltyn-label">성적반영</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="quiz-manage-mkr-rfltyn-rd" id="quiz-manage-mkr-rfltyn-y-rd" value="Y" checked="">
                                                                <label for="quiz-manage-mkr-rfltyn-y-rd">예</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="quiz-manage-mkr-rfltyn-rd" id="quiz-manage-mkr-rfltyn-n-rd" value="N">
                                                                <label for="quiz-manage-mkr-rfltyn-n-rd">아니오</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 성적공개 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-mkr-oyn-label">성적공개</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="quiz-manage-mkr-oyn-rd" id="quiz-manage-mkr-oyn-y-rd" value="Y" checked="">
                                                                <label for="quiz-manage-mkr-oyn-y-rd">예</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="quiz-manage-mkr-oyn-rd" id="quiz-manage-mkr-oyn-n-rd" value="N">
                                                                <label for="quiz-manage-mkr-oyn-n-rd">아니오</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 문제표시방식 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-view-type-label">문제표시방식</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-inline">
                                                            <span class="custom-input">
                                                                <input type="radio" name="quiz-manage-view-type-rd" id="quiz-manage-view-type-all-rd" value="ALL" checked="">
                                                                <label for="quiz-manage-view-type-all-rd">전체 문제표시</label>
                                                            </span>
                                                            <span class="custom-input ml5">
                                                                <input type="radio" name="quiz-manage-view-type-rd" id="quiz-manage-view-type-one-rd" value="ONE">
                                                                <label for="quiz-manage-view-type-one-rd">1문제씩 표시</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 문제 섞기 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-mix-type-label" class = "req">문제섞기</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input type="checkbox" id="quiz-manage-mix-type" class="switch yesno">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 보기 섞기 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-view-mix-type-label" class = "req">보기섞기</label>
                                                    </th>
                                                    <td>
                                                        <div class="form-row">
                                                            <input type="checkbox" id="quiz-manage-view-mix-type" class="switch yesno">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <!-- [퀴즈] 파일첨부 -->
                                                <tr>
                                                    <th>
                                                        <label for="quiz-manage-sbmsn-atfl-label">파일첨부</label>
                                                    </th>
                                                    <td>
                                                        <uiex:dextuploader
                                                                id="quizFileUploader2"
                                                                path="/quiz"
                                                                limitCount="5"
                                                                limitSize="100"
                                                                oneLimitSize="100"
                                                                listSize="3"
                                                                fileList=""
                                                                finishFunc="finishUpload()"
                                                                allowedTypes="*"
                                                        />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </form>
                                </div>
                            </div>
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
