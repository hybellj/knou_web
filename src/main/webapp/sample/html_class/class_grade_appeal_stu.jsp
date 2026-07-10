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
                            <h2 class="page-title">성적확인</h2>
                        </div>
                        <div class="listTab">
                            <ul>
                                <li><a href="#">성적확인</a></li>
                                <li class="select"><a href="#0">성적 이의 신청</a></li>
                            </ul>
                        </div>
                        
                        <!-- 성적 이의 신청 기간 -->
                        <div class="msg-box warning">
                            <p class="txt ct"><strong>성적 이의 신청기간 : </strong>2026.07.25 09:00 ~ 2026.09.25 23:59</p>
                        </div><!-- //성적 이의 신청 기간 -->

                        <div class="board_top">
                            <h4 class="sub-title">목록
                                <span class="total_txt fw-normal fs-16px">[ 총 건수 <b class="fcBlue">4</b>건 ]</span>
                            </h4>
                            <div class="right-area">
                                <button type="button" class="btn type2 big">신청</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="10" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col class="width-5per">
                                    <col>
                                    <col>
                                    <col class="width-5per">
                                    <col>
                                    <col>
                                    <col class="width-5per">
                                    <col>
                                    <col>
                                    <col class="width-10per">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col">학과</th>
                                        <th scope="col">과목</th>
                                        <th scope="col">분반</th>
                                        <th scope="col">대표아이디</th>
                                        <th scope="col">학번</th>
                                        <th scope="col">이름</th>
                                        <th scope="col">처리상태</th>
                                        <th scope="col">처리일시</th>
                                        <th scope="col">관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호">4</td>
                                        <td data-th="학과">컴퓨터공학과</td>
                                        <td data-th="과목" class="text-left">데이터베이스의 이해 활용</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="대표아이디">testid2**4</td>
                                        <td data-th="학번">202612***84</td>
                                        <td data-th="이름">학*자</td>
                                        <td data-th="처리상태">신청</td>
                                        <td data-th="처리일시">-</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn basic">수정하기</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">3</td>
                                        <td data-th="학과">컴퓨터공학과</td>
                                        <td data-th="과목" class="text-left">데이터베이스의 이해 활용</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="대표아이디">testid2**4</td>
                                        <td data-th="학번">202612***84</td>
                                        <td data-th="이름">학*자</td>
                                        <td data-th="처리상태">승인(가산점 부여)</td>
                                        <td data-th="처리일시">2026.06.12 15:23</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn type2">처리결과</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">2</td>
                                        <td data-th="학과">컴퓨터공학과</td>
                                        <td data-th="과목" class="text-left">데이터베이스의 이해 활용</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="대표아이디">testid2**4</td>
                                        <td data-th="학번">202612***84</td>
                                        <td data-th="이름">학*자</td>
                                        <td data-th="처리상태">확인(가산점 미부여)</td>
                                        <td data-th="처리일시">2026.06.12 15:23</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn type2">처리결과</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">1</td>
                                        <td data-th="학과">컴퓨터공학과</td>
                                        <td data-th="과목" class="text-left">데이터베이스의 이해 활용</td>
                                        <td data-th="분반">1</td>
                                        <td data-th="대표아이디">testid2**4</td>
                                        <td data-th="학번">202612***84</td>
                                        <td data-th="이름">학*자</td>
                                        <td data-th="처리상태">반려(가산점 미부여)</td>
                                        <td data-th="처리일시">2026.06.12 15:23</td>
                                        <td data-th="관리">
                                            <button type="button" class="btn type2">처리결과</button>
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
                        <button type="button" class="btn modal__btn" id="btn-modal1">성적 이의신청 처리결과</button>
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
                    <div class="board_top">
                        <h3 class="sub-title">성적 이의신청 처리결과</h3>

                        <div class="table-wrap mb10">
                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per">
                                    <col>
                                    <col class="width-15per">
                                    <col>
                               </colgroup>
                               <tbody>
                                    <tr>
                                        <th>학과</th>
                                        <td>컴퓨터공학과</td>
                                        <th>학수번호</th>
                                        <td>CME000</td>
                                    </tr>
                                    <tr>
                                        <th>과목</th>
                                        <td>유럽 문화 탐방</td>
                                        <th>분반</th>
                                        <td>1반</td>                                        
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
                                <colgroup>
                                    <col class="width-15per">
                                    <col>
                                    <col class="width-15per">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>대표아이디</th>
                                        <td>testid2**4</td>
                                        <th>학번</th>
                                        <td>202612***84</td>
                                    </tr>
                                    <tr>
                                        <th>이름</th>
                                        <td>학*자1</td>
                                        <th>연락처</th>
                                        <td>010-2334-99**</td>
                                    </tr>
                                    <tr>
                                        <th class="req">신청 사유</th>
                                        <td colspan="3">태무표를 활성화하면 상드반량이 즉시 반영되지만, 준원은 별도의 설정이 필요하므로 주의해야 한다. 측원은 편글의 핵심 요소로서 표속관업을 효과적으로 관리할 수 있도록 도와주며, 특히 활션과 관련된 작업에서 매우 유용한다. 보간장점을 지원한다. 하지만 흐단준장을 통해 미학을 분석하고 평토건을 개선할 수 있으며, 이는 전반적인 래비 향상으로 이어집니다. 예를 들어 선료룰변이 린간소와 연동되어 작동한다. 게다가 무기트순이 중요한다. 치제는 드기경식과 긴밀하게 연결되어 있어 성고리를 변경할 경우 그색화에도 영향을 미칠 수 있다.</td>
                                    </tr>
                                    <tr>
                                        <th>자료 첨부</th>
                                        <td colspan="3">
                                            <div>
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">154873973477000.jpg</span>
                                                    <span class="fileSize">(6KB)</span>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>


                    <div class="board_top">
                        <h3 class="sub-title">처리결과</h3>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col class="width-15per">
                                <col>
                                <col class="width-15per">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>담당교수</th>
                                    <td>홍*수</td>
                                    <th>등록일</th>
                                    <td>2026.08.16 16:25</td>
                                </tr>
                                <tr>
                                    <th>변경 전 점수</th>
                                    <td>78.2</td>
                                    <th>변경 후 점수</th>
                                    <td><span class="fcRed">85.5</span></td>
                                </tr>

                                <tr>
                                    <th rowspan="2">처리상태 및 결과</th>
                                    <td colspan="3">승인(가산점 부여)</td>
                                </tr>
                                <tr>
                                    <td colspan="3">한 학기 동안 수고 많았습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>


                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 참여관리/관리이력 -->

        <script>
            $(function() {
                // 성적 이의신청 처리결과
                $('#btn-modal1').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "성적 이의신청 처리결과",
                        width: 1200,
                        height: 800,
                        html: $content
                    });
                });
            });
        </script>

    </div>

</body>
</html>
