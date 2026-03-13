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

		$(document).ready(function() {

			/* 팀 시험 라디오 초기 상태 (team-n-rd 기본 체크 → 폼 숨김) */
			$("#select-team-form").hide();

			/* 팀 시험 라디오 change 이벤트 */
			$("#team-y-rd").on("change", function() {
				if ($(this).is(":checked")) {
					$("#select-team-form").show();
				}
			});
			$("#team-n-rd").on("change", function() {
				if ($(this).is(":checked")) {
					$("#select-team-form").hide();
				}
			});

			/* 저장 버튼 */
			$("#examWriteSave").on("click", function() {
				var validator = UiValidator("exam-write1");
				validator.then(function(result) {
					if (result) {
                        UiComm.showMessage("저장되었습니다.\n(현재 하드코딩으로 작성 추후 로직 구현)", "success")
						// TODO: AJAX 저장
						var formData = {
							examGbncd:      $('input[name="exam-gubun-rd"]:checked').val(),
							tkexamMthdCd:   $('input[name="exam-type-rd"]:checked').val(),
							examTtl:        $('#exam-ttl').val(),
							examCts:        $('#examCts').val(),
							examPsblSdttm1: $('#examPsblSdttm1').val(),
							examPsblSdttm2: $('#examPsblSdttm2').val(),
							examMnts:       $('#examMnts').val(),
							mrkRfltyn:      $('input[name="mkr-rfltyn-rd"]:checked').val(),
							mrkOyn:         $('input[name="mkr-oyn-rd"]:checked').val(),
							exampprOyn:     $('input[name="examppr-oyn-rd"]:checked').val(),
							teamYn:         $('#team-y-rd').is(':checked') ? 'Y' : 'N',
							teamGroup:      $('#team-select').val()
						};
						console.log('[examWriteSave] 입력값:', formData);
					}
				});
			});

			/* 목록 버튼 */
			$("#examWriteCancle").on("click", function() {
				UiComm.showMessage("목록으로 돌아가시겠습니까?", "confirm")
					.then(function(result) {
						if (result) {
							location.href = "/exam/profExamListView.do";
						}
					});
			});
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
                    <!-- //강의실 상단 -->

                    <div class="segment">
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">시험등록</h3>
                            <div class="right-area">
                                <button type="button" id = "examWriteSave" class="btn type2">저장</button>
                                <button type="button" id = "examWriteCancle" class="btn basic">목록</button>
                            </div>
                        </div>

                        <!-- 등록 영역 -->
                        <div class = "table-wrap">
                            <form id = "exam-write1" name = "exam-write1">
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
                                                    <span class="custom-input">
                                                        <input type="radio" name="exam-gubun-rd" id="middle-rd" value="EXAM_MID" checked="">
                                                        <label for="middle-rd">중간고사</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="final-rd" value="EXAM_LST">
                                                        <label for="final-rd">기말고사</label>
                                                    </span>
                                                    <!-- 설계서엔 시험으로 되어 있음 -->
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-gubun-rd" id="exam-rd" value="EXAM">
                                                        <label for="exam-rd">시험</label>
                                                    </span>
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
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-type-rd" id="real-time-rd" value="RLTM">
                                                        <label for="real-time-rd">실시간 시험</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="exam-type-rd" id="quiz-rd" value="QUIZ">
                                                        <label for="quiz-rd">퀴즈</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험명 -->
                                        <tr>
                                            <th>
                                                <label for="exam-ttl-label" class = "req">시험명</label>
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <input class="form-control width-50per" 
                                                        type="text" name="name" id="exam-ttl" value="" 
                                                        placeholder="시험명을 입력하세요." required="true" inputmask="byte" 
                                                        maxlen="10" minlen="4" autocomplete="off">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <label for="contTextarea" class = "req">시험내용</label>
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
                                                <label for="noticeLabel" class = "req">시험일시</label>
                                            </th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="text" placeholder="시작일" id="examPsblSdttm1" class="datepicker" timeId="examPsblSdttm2" required="true">
                                                    <input type="text" placeholder="시작시간" id="examPsblSdttm2" class="timepicker" dateId="examPsblSdttm1" required="true">
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 시험시간 -->
                                        <tr>
                                            <th>
                                                <label for="timeLabel" class = "req">시험시간</label>
                                            </th>
                                            <td>
                                                <div class="form-row">
                                                    <div class="input_btn">
                                                        <input class="form-control sm" id="examMnts" type="text" inputmask="numeric" maxlength="3" required="true"><label>분</label>
                                                    </div>
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
                                                    <span class="custom-input">
                                                        <input type="radio" name="mkr-rfltyn-rd" id="mkr-rfltyn-y-rd" value="Y" checked="">
                                                        <label for="mkr-rfltyn-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="mkr-rfltyn-rd" id="mkr-rfltyn-n-rd" value="N">
                                                        <label for="mkr-rfltyn-n-rd">아니오</label>
                                                    </span>
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
                                                    <span class="custom-input">
                                                        <input type="radio" name="mkr-oyn-rd" id="mkr-oyn-y-rd" value="Y" checked="">
                                                        <label for="mkr-oyn-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="mkr-oyn-rd" id="mkr-oyn-n-rd" value="N">
                                                        <label for="mkr-oyn-n-rd">아니오</label>
                                                    </span>
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
                                                    <span class="custom-input">
                                                        <input type="radio" name="examppr-oyn-rd" id="examppr-oyn-y-rd" value="Y">
                                                        <label for="examppr-oyn-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="examppr-oyn-rd" id="examppr-oyn-n-rd" value="N" checked="">
                                                        <label for="examppr-oyn-n-rd">아니오</label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팀 시험 -->
                                        <tr>
                                            <th>
                                                <label for="exam-team-label">팀 시험</label>
                                            </th>
                                            <td>
                                                <div class="form-inline mb10">
                                                    <span class="custom-input">
                                                        <input type="radio" name="team-rd" id="team-y-rd" value="Y">
                                                        <label for="team-y-rd">예</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="team-rd" id="team-n-rd" value="N" checked="">
                                                        <label for="team-n-rd">아니오</label>
                                                    </span>
                                                </div>
                                                <div class="form-row" id = "select-team-form">
                                                    <input class="form-control" type="text" id="team-select" placeholder="팀 그룹 선택" autocomplete="off" readonly>
                                                    <button type="button" id = "team-open-popup" class="btn gray1">학습 그룹 지정</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
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
