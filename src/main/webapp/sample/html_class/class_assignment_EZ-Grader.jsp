<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">        
        <jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="class darkmode "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
    </div>

    <!-- EZ-Grader 마크업 템플릿 -->
    <script type="text/template" id="ezGraderMarkup">
        <div class="modal_EzGarder_area" style="width: 100%; height: 100%; border-radius: 0;">
            <h1 class="EzGarder_title">
                EZ-Grader 쉽고 빠르게 평가
                <button type="button" class="btn_close" onclick="closeDialog6()" aria-label="닫기"><i class="xi-close"></i></button>
            </h1>
            <div class="EzCarder_content">
                <div class="left_list">
                    <div class="left_select_box mb10">
                        <select class="form-select">
                            <option value="">정렬선택</option>
                            <option value="학번순">학번순</option>
                            <option value="이름순">이름순</option>
                            <option value="제출자순">제출자순</option>
                        </select>
                        <select class="form-select">
                            <option value="">필터선택</option>
                            <option value="제출">제출</option>
                            <option value="미제출">미제출</option>
                            <option value="연장제출">연장제출</option>
                            <option value="재제출">재제출</option>
                            <option value="미재제출">미재제출</option>
                        </select>        
                    </div>
                    <div class="stu_list_area">
                        <div class="stu_list">
                            <ul>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자1</p>
                                </li>
                                <li class="active">
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자1</p>
                                </li>
                            </ul>
                        </div>
                        <div class="stu_list">
                            <p class="temaTitle">팀 이름1</p>
                            <ul>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                        <span><i class="xi-trophy icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자1</p>
                                </li>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자2</p>
                                </li>
                                <li>
                                    <div class="icon_box">
                                        <span><i class="xi-check icon"></i></span>
                                    </div>
                                    <span>소프트웨어학부</span>
                                    <p>학*자3</p>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="center_com width-100per">
                    <div class="board_top">
                        <h3 class="board-title">이전 제출 과제</h3>
                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col width="100px">
                                    <col>
                                    <col>
                                    <col width="50px">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>제출1</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                        <td><a href="#0"><i class="xi-download icon"></i></a></td>
                                    </tr>
                                    <tr>
                                        <th>제출2</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                        <td><a href="#0"><i class="xi-download icon"></i></a></td>
                                    </tr>
                                    <tr>
                                        <th>제출3</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                        <td><a href="#0"><i class="xi-download icon"></i></a></td>
                                    </tr>
                                    <tr>
                                        <th>제출4</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                        <td><a href="#0"><i class="xi-download icon"></i></a></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <div class="board_top">
                        <h3 class="board-title">과제 제출 이력</h3>
                        <div class="table-wrap">
                            <table class="table-type3">
                                <colgroup>
                                    <col width="100px">
                                    <col>
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>제출 일시</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                    </tr>
                                    <tr>
                                        <th>제출 일시</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                    </tr>
                                    <tr>
                                        <th>제출 일시</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                    </tr>
                                    <tr>
                                        <th>제출 일시</th>
                                        <td>2026-06-01 15:25</td>
                                        <td>첨부파일_202654541.pdf  143.26 KB</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <!-- pdf 뷰어 -->
                    <div class="pdf-viewer">
                        <iframe 
                            src="https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf" 
                            width="100%" 
                            height="800px" 
                            style="border: none;">
                            이 브라우저는 PDF 뷰어를 지원하지 않습니다. 

                            <a href="https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf">파일 다운로드</a>
                        </iframe>
                    </div><!-- //pdf 뷰어 -->

                </div>

                <div class="right_app">
                    <div class="right_top_score">
                        <label for="inputScore"><input type="text" id="inputScore" placeholder="점수"></label>
                        <button type="button" class="btn small type3">저장</button>
                        <button type="button" class="btn small type2">초기화</button>                                
                    </div>
                    <div class="right_memo">
                        <div class="btn type8 width-100per mb10 cursorNone">표절율 10%</div>
                        <button class="btn basic width-100per mb5">이전 제출 과제 보기</button>
                        <button class="btn basic width-100per mb5">과제 제출 이력 숨김</button>
                        <button class="btn type4 width-100per mb5">우수 과제로 선정</button>
                        <div class="memoBox eval-method-item">
                            <p class="title">루브릭 01</p>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col width="60px">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>기준</th>
                                            <td>창의력</td>
                                        </tr>
                                        <tr>
                                            <th>등급</th>
                                            <td>
												<select class="form-select width-100per" id="univ_label" name="univ_label" required="true">
													<option value="">선택</option>
													<option value=""><b>3점</b> 상</option>
													<option value=""><b>2점</b> 중</option>
													<option value=""><b>1점</b> 하</option>
												</select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>점수</th>
                                            <td><b>3점</b></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="table-wrap">
                                <table class="table-type3">
                                    <colgroup>
                                        <col width="60px">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>기준</th>
                                            <td>창의력</td>
                                        </tr>
                                        <tr>
                                            <th>등급</th>
                                            <td>
												<select class="form-select width-100per" id="univ_label" name="univ_label" required="true">
													<option value="">선택</option>
													<option value=""><b>3점</b> 상</option>
													<option value=""><b>2점</b> 중</option>
													<option value=""><b>1점</b> 하</option>
												</select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>점수</th>
                                            <td><b>3점</b></td>
                                        </tr>
                                        <tr class="total">
                                            <th><strong>총점</strong></th>
                                            <td><strong>6 (환산점수 91점)</strong></td>                                                                           
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <button class="btn basic width-100per">3개의 피드백</button>
                        <div class="memoBox">
                            <label for="inputMemo1" class="width-100per"><textarea id="inputMemo1" class="width-100per"></textarea></label>
                            <button type="button" class="btn small type3 width-100per">저장</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </script>

    <script>
        let ezGraderDialog = null;

        function openDialog6() {
            ezGraderDialog = UiDialog("ezGraderDialog", {
                titlebar: false,
                fullscreen: true,
                modal: true,
                html: document.getElementById('ezGraderMarkup').innerHTML
            });
            
            // 다이얼로그 내부 동적 요소 이벤트 초기화
            initEzGraderEvents();
        }

        function closeDialog6() {
            if (ezGraderDialog) {
                ezGraderDialog.close();
            }
        }

        function initEzGraderEvents() {
            // 학생 리스트 클릭 이벤트
            $(document).off('click', '.stu_list ul li').on('click', '.stu_list ul li', function() {
                $(this).toggleClass('active');
            });

            // 댓글 토글 이벤트
            $(document).off('click', '.toggle_commentlist').on('click', '.toggle_commentlist', function() {
                $(this).closest('.item').next('.re_comment_ul').toggle();
            });
        }

        $(document).ready(function() {
            openDialog6();
        });
    </script>
        
    </div>

</body>
</html>
