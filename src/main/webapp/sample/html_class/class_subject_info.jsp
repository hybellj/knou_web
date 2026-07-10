<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="classroom"/>
	</jsp:include>

    <script src="../../webdoc/uilib/chart/chart4.min.js"></script>
    <script src="../../webdoc/uilib/chart/chart-utils.min.js"></script>
    <script src="../../webdoc/uilib/chart/chartjs-plugin-datalabels.min.js"></script>
</head>

<body class="class"><!-- 컬러선택시 클래스변경 -->
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
                <!-- class_sub_top -->
				<jsp:include page="../common/class_sub_top.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="../common/class_info.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
                    <!-- //class_info -->

                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">과목정보</h2>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">상세정보</h4>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">기관</th>
                                        <td>대학원</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">년도/학기(기수)</th>
                                        <td>2026학년 / 1학기</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">년도/학기(기수)</th>
                                        <td>2026학년 / 1학기</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">학과</th>
                                        <td>컴퓨터공학과</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">과목명</th>
                                        <td>일한 번역연습01 1반</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">과목 분류</th>
                                        <td>학기제</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">강의형태</th>
                                        <td>온라인</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">사용여부</th>
                                        <td>사용</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">과목설명</th>
                                        <td>
                                            <textarea name="" id="" class="width-100per" value="">과목설명을 입력해주세요.</textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">저화질 콘텐츠</th>
                                        <td>
                                            <div>
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">첨부파일_202254541.mp4</span>
                                                    <span class="fileSize">(143.26 KB)</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">고화질 콘텐츠</th>
                                        <td>
                                            <div>
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">첨부파일_202254541.mp4</span>
                                                    <span class="fileSize">(143.26 KB)</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">재생시간</th>
                                        <td>30분 40초(총 1,840초)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <div class="table-wrap">
                                <table class="table-type2">
                                    <colgroup>
                                        <col class="width-15per">
                                        <col>
                                        <col style="width: 150px">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th colspan="3">돌발퀴즈</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>2426초</td>
                                            <td class="text-left">돌발퀴즈001</td>
                                            <td>
                                                <button type="button" class="btn type2">돌발퀴즈 보기</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>3250초</td>
                                            <td class="text-left">돌발퀴즈002</td>
                                            <td>
                                                <button type="button" class="btn type2">돌발퀴즈 보기</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col class="width-15per">
                                    <col>
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th colspan="3">다국어 자막(스크립트)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td rowspan="2">1</td>
                                        <td>언어</td>
                                        <td>영어</td>
                                    </tr>
                                    <tr>
                                        <td>SRT자막 파일</td>
                                        <td>SRT자막_영어파일001</td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>


                    </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" id="btn-modal1">돌발 퀴즈</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->


        <!-- Modal1 돌발 퀴즈 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="msg-box basic">
                        <h2 class="text-center margin-left-auto margin-right-auto">
                            <span class="fcBlue"><i class="xi-alarm fs-26px"></i>돌발</span> 퀴즈
                        </h2>
                    </div>

                    <div class="course_history bd0 mb10">
                        <div class="question_area pd0">
                            <div class="question_con">
                                <div class="q_top">
                                    <div class="flex-item width-100per">
                                        <p class="flex-none mr15"><b>Q1.</b></p>
                                        <div class="flex-1 tal">다음 중 알고리즘을 표현하는 방법으로 <span class="fcRed">부적절한</span>것은?</div>
                                    </div>
                                </div>
                                <div class="q_cont">
                                    <ol class="q_cont_ans d-block">
                                        <li class="mb15">
                                            <input type="radio" name="q1_ans" id="q1_ans1">
                                            <label for="q1_ans1"><span class="ansNum">1</span>나무</label>
                                        </li>
                                        <li class="mb15">
                                            <input type="radio" name="q1_ans" id="q1_ans2">
                                            <label for="q1_ans2"><span class="ansNum">2</span>돌</label>
                                        </li>
                                        <li class="mb15">
                                            <input type="radio" name="q1_ans" id="q1_ans3" checked="">
                                            <label for="q1_ans3"><span class="ansNum">3</span>바다</label>
                                        </li>
                                        <li>
                                            <input type="radio" name="q1_ans" id="q1_ans4">
                                            <label for="q1_ans4"><span class="ansNum">4</span>산</label>
                                        </li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 정답 안내 영역 -->
                    <!-- <div class="msg-box success d-block">
                        <strong><i class="xi-check-circle-o"></i>정답입니다.</strong>
                        <p class="mt10">정답 : 2</p>
                        <p>알고리즘을 표현하는 방법은 강아지, 토끼, 사슴입니다.</p>
                    </div> -->
                    <!-- //정답 안내 영역 -->


                    <!-- 오답 안내 영역 -->
                    <div class="msg-box warning d-block">
                        <strong><i class="xi-close-circle-o"></i>오답입니다.</strong>
                        <p class="mt10">정답 : 2</p>
                        <p>알고리즘을 표현하는 방법은 강아지, 토끼, 사슴입니다.</p>
                    </div>
                    <!-- //오답 안내 영역 -->                  

                    <div class="modal_btns">
                        <button type="button" class="btn type2">학습 계속하기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 돌발 퀴즈 -->

        <script>
            $(function() {
                // 돌발 퀴즈
                $('#btn-modal1').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "돌발 퀴즈",
                        width: 600,
                        height: 600,
                        html: $content
                    });
                });
            });
        </script>

    </div>

</body>
</html>
