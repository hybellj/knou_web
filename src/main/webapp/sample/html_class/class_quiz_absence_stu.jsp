<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
<%-- <jsp:param name="module" value="editor,fileuploader"/> --%>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
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
                            <h2 class="page-title">시험</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li><a href="#">시험정보 및 평가</a></li>
                                <li><a href="#0">시험 대체</a></li>
                                <li class="select"><a href="#0">결시신청 및 결과</a></li>
                                <li><a href="#0">장애인/고령자지원</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">결시신청 및 결과
                                <span class="total_txt fw-normal fs-16px">[ 총 건수 <b class="fcBlue">6</b>건 ]</span>
                            </h4>
                            <div class="right-area">
                                <button type="button" class="btn type2 big">결시 신청</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col class="width-5per">
                                    <col>
                                    <col class="width-5per">
                                    <col class="width-10per">
                                    <col>
                                    <col>
                                    <col class="width-5per">
                                    <col class="width-5per">
                                    <col>
                                    <col class="width-15per">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>과목</th>
                                        <th>분반</th>
                                        <th>구분</th>
                                        <th>방식</th>
                                        <th>신청일시</th>
                                        <th>시험응시</th>
                                        <th>처리상태</th>
                                        <th>처리일시</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">6</td>
                                        <td data-th="과목">데이터베이스의 이해활용</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="구분">중간고사</td>
                                        <td data-th="방식">실시간 온라인</td>
                                        <td data-th="신청일시">2026.09.07 10:00</td>
                                        <td data-th="시험응시">N</td>
                                        <td data-th="처리상태">승인</td>
                                        <td data-th="처리일시">2026.09.07 10:00</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic">처리내역</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="과목">데이터베이스의 이해활용</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="구분">기말고사 팀</td>
                                        <td data-th="방식">실시간 온라인</td>
                                        <td data-th="신청일시">2026.09.07 10:00</td>
                                        <td data-th="시험응시">N</td>
                                        <td data-th="처리상태">재신청</td>
                                        <td data-th="처리일시">2026.09.07 10:00</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic">처리내역</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">4</td>
                                        <td data-th="과목">데이터베이스의 이해활용</td>
                                        <td data-th="분반">1반</td>
                                        <td data-th="구분">기말고사 팀</td>
                                        <td data-th="방식">실시간 온라인</td>
                                        <td data-th="신청일시">2026.09.07 10:00</td>
                                        <td data-th="시험응시">N</td>
                                        <td data-th="처리상태" class="fcBlue">반려</td>
                                        <td data-th="처리일시">2026.09.07 10:00</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic">처리내역</button>
                                            <button type="button" class="btn basic">재신청</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

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
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" id="btn_Modal1">결시 신청</button>
                    <button type="button" class="btn modal__btn" id="btn_Modal2">처리내역</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->

        <!-- Modal2 처리내역 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content">
                <div class="modal-body">

                        <div class="board_top">
                            <h4 class="sub-title">처리내역</h4>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type5">
                                <tbody>
                                    <tr>
                                        <th>처리상태</th>
                                        <td>승인</td>
                                        <th>처리일시</th>
                                        <td>2026.05.06 16:35</td>
                                    </tr>
                                    <tr>
                                        <th>과목</th>
                                        <td>유럽 문화 탐방</td>
                                        <th>분반</th>
                                        <td>1반</td>
                                    </tr>
                                    <tr>
                                        <th>처리내용</th>
                                        <td colspan="3">기말고사 성적의 80%를 중간고사 성적으로 인정해 주겠습니다.<br>기말고사까지 결시하게 되면 사유불문 F처리되니 기말고사를 꼭 응시하세요</td>  
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">결시원 신청내역</h4>
                            <div class="right-area">
                                <span class="total_txt fcBlue">[ 신청이력 : 중간고사(O), 기말고사(X) ]</span>
                           </div>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type5">
                                <tbody>
                                    <tr>
                                        <th>학과</th>
                                        <td>컴퓨터공학과</td>
                                        <th>학수번호</th>
                                        <td>CME000</td>
                                    </tr>
                                    <tr>
                                        <th>교과</th>
                                        <td>유럽 문화 탐방</td>
                                        <th>분반</th>
                                        <td>1반</td>
                                    </tr>
                                    <tr>
                                        <th>시험구분</th>
                                        <td>중간고사</td>
                                        <th>시험일시</th>
                                        <td>2026.05.15</td>
                                    </tr>
                                    <tr>
                                        <th>교수</th>
                                        <td>홍*수</td>
                                        <th>튜터</th>
                                        <td>김*교</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="table-wrap">
                            <table class="table-type5">
                                <tbody>
                                    <tr>
                                        <th>대표아이디</th>
                                        <td>testid**3</td>
                                        <th>학번</th>
                                        <td>90125***59</td>
                                    </tr>
                                    <tr>
                                        <th>이름</th>
                                        <td>학*자1</td>
                                        <th>연락처</th>
                                        <td>010-2548-98**</td>
                                    </tr>
                                    <tr>
                                        <th>결시사유</th>
                                        <td>예비군 동원 훈련</td>
                                        <th>적용비율</th>
                                        <td>80 %</td>
                                    </tr>
                                    <tr>
                                        <th>결시 사유 설명</th>
                                        <td colspan="3">외석은 기본값입니다. 의비도가 포함됩니다. 싱감관본은 장수의 중요한 부분을 담당합니다. 특히 접손직차는 고가와 함께 사용할 때 효과적입니다. 예를 들어 선로를 선택하면 과차 옵션이 나타납니다. 전토장 설정이 완료되었습니다. 책위체는 의크티의 품질을 결정하는 요소입니다. 신조는 과글과 함께 사용할 때 효과적입니다. 경태도를 설정하면 량안력연이 자동으로 업</td>
                                    </tr>
                                    <tr>
                                        <th>증빙자료</th>
                                        <td colspan="3">
                                            <a href="#" class="file_down">
                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                <span class="text">첨부파일_202254541.mp4</span>
                                                <span class="fileSize">(143.26 KB)</span>
                                            </a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    <div class="btns">
                        <button type="button" class="btn type1">닫기</button>
                    </div>
                </div>
            </div>
        </div>         
        <!-- //Modal2 처리내역 -->


        <script>
        	//var dialog1 = null;
            $(function() {
                // 1. 결시 신청
                $('#btn_Modal1').on('click', function() {

                    dialog1 = UiDialog("dialog1", {
                        title: "결시 신청",
                        width: 1200,
                        height: 800,
                        url: "./class_quiz_absence_stu_write.jsp"
                    });
                });

                // 2. 처리내역
                $('#btn_Modal2').on('click', function() {
                    
                    var $content = $('#modal2 .modal-body');

                    UiDialog("dialog1", {
                        title: "처리내역",
                        width: 800,
                        height: 450,
                        html: $content
                    });
                });

            });
        </script>

    </div>

</body>
</html>
