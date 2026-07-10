<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>
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
                            <h2 class="page-title">강의평가관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과정관리</li>
                                    <li>강의평가</li>
                                    <li><span class="current">강의평가관리</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">등록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">이전 강의평가 가져오기</button>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table class="table-type5">
                                <colgroup>
                                    <col style="width:15%">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row" class="req">기관</th>
                                        <td data-th="기관">
											<div class="form-inline">
												<select class="form-select" id="institution_select" name="institution_select" required="true">
													<option value="">전체</option>
													<option value="대학원">대학원</option>
													<option value="경영대학원">경영대학원</option>
													<option value="프라임칼리지 학위과정">프라임칼리지 학위과정</option>
													<option value="프라임칼리지 평생교육과정">프라임칼리지 평생교육과정</option>
                                                    <option value="종합교육연수원">종합교육연수원</option>
                                                    <option value="허브대학">허브대학</option>
												</select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">년도/학기(기수)</th>
                                        <td data-th="년도/학기(기수)">
											<div class="form-inline">
												<select class="form-select" id="year_select" name="year_select" required="true">
													<option value="">2026년</option>
												</select>
												<select class="form-select" id="term_select" name="term_select" required="true">
													<option value="">1학기</option>
													<option value="">2학기</option>
													<option value="">3학기</option>
													<option value="">4학기</option>
												</select>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">분류</th>
                                        <td data-th="분류">
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="category_type" id="category_all" value="ALL" checked="">
													<label for="category_all">일괄</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="category_type" id="category_dept" value="DEPT">
													<label for="category_dept">학과별</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="category_type" id="category_subject" value="SUBJECT">
													<label for="category_subject">과목별</label>
												</span>
											</div>
                                        </td>
                                    </tr>

                                    <!-- 분류 : 학과별 -->
                                    <tr class="teamView">
                                        <td colspan="2">
                                            <table class="table-type5">
                                                <tbody>
                                                    <tr>
                                                        <th scope="row" class="border-top-1 req">학과</th>
                                                        <td data-th="학과" colspan="7">
                                                            <div class="form-inline">
                                                                <select class="form-select" id="dept_select" name="dept_select" required="true">
                                                                    <option value="">정보과학과</option>
                                                                </select>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th scope="row" class="req" colspan="8">과목선택</th>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div class="table-wrap bd0 overflow-y">
                                                <table class="table-type5">
                                                    <tbody>

                                                        <tr>
                                                            <th class="text-center">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="subject_chkall">
                                                                    <label for="subject_chkall"></label>
                                                                </span>
                                                            </th>
                                                            <th class="text-center border-left-1 cursor-pointer">
                                                                기관<i class="xi-arrows-v icon"></i>
                                                            </th>
                                                            <th class="text-center border-left-1 cursor-pointer">
                                                                학과<i class="xi-arrows-v icon"></i>
                                                            </th>
                                                            <th class="text-center border-left-1">과목코드</th>
                                                            <th class="text-center border-left-1 cursor-pointer">
                                                                과목명<i class="xi-arrows-v icon"></i>
                                                            </th>
                                                            <th class="text-center border-left-1">분반</th>
                                                            <th class="text-center border-left-1 cursor-pointer">
                                                                담당교수<i class="xi-arrows-v icon"></i>
                                                            </th>
                                                            <th class="text-center border-left-1 cursor-pointer">
                                                                담당튜터<i class="xi-arrows-v icon"></i>
                                                            </th>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk1"><label for="chk1"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk2"><label for="chk2"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk3"><label for="chk3"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk4"><label for="chk4"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk5"><label for="chk5"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk6"><label for="chk6"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk7"><label for="chk7"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk8"><label for="chk8"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk9"><label for="chk9"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                        <tr>
                                                            <td data-th="선택">
                                                                <span class="custom-input onlychk">
                                                                    <input type="checkbox" id="chk10"><label for="chk10"></label>
                                                                </span>
                                                            </td>
                                                            <td data-th="기관" class="text-center border-left-1">대학원</td>
                                                            <td data-th="학과" class="text-center border-left-1">정보과학과</td>
                                                            <td data-th="과목코드" class="text-center border-left-1">CU254835</td>
                                                            <td data-th="과목명" class="text-center border-left-1">유비쿼터스컴퓨팅</td>
                                                            <td data-th="분반" class="text-center border-left-1">1</td>
                                                            <td data-th="담당교수" class="text-center border-left-1">홍*수</td>
                                                            <td data-th="담당튜터" class="text-center border-left-1">이*터</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                    </tr><!-- //분류 : 학과별 -->
                                    
                                    <tr>
                                        <th scope="row" class="req">강의평가 제목</th>
                                        <td data-th="강의평가 제목">
											<div class="form-row">
												<input class="form-control width-50per" type="text" name="eval_title" id="eval_title" value="" required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">강의평가 설명</th>
                                        <td data-th="강의평가 설명">
                                            <dl>
                                                <dd>
                                                    <div class="editor-box">
                                                        <label for="eval_desc" class="hide">Content</label>
                                                        <textarea id="eval_desc" name="eval_desc" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
                                                        <script>
                                                            // HTML 에디터
                                                            let editor = UiEditor({
                                                                targetId: "eval_desc",
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
                                                                alert("내용이 비어있습니다.");
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
                                    <tr>
                                        <th scope="row" class="req">강의평가 구분</th>
                                        <td data-th="강의평가 구분">
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="eval_term_type" id="eval_term_mid" value="MID" checked="">
													<label for="eval_term_mid">중간고사</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="eval_term_type" id="eval_term_final" value="FINAL">
													<label for="eval_term_final">기말고사</label>
												</span>
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">강의평가 기간</th>
                                        <td data-th="강의평가 기간">
											<div class="date_area">
												<input type="text" placeholder="시작일" id="eval_start_date" name="eval_start_date" class="datepicker" toDate="eval_end_date" timeId="timepicker3">
												<span class="txt-sort">~</span>
												<input type="text" placeholder="종료일" id="eval_end_date" name="eval_end_date" class="datepicker" fromDate="eval_start_date" timeId="timepicker4">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">관리 구분</th>
                                        <td data-th="관리 구분">
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="manage_type" id="manage_haksa" value="HAKSA" checked="">
													<label for="manage_haksa">학사연동</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="manage_type" id="manage_lms" value="LMS">
													<label for="manage_lms">LMS에서 관리</label>
												</span>
											</div>
                                        </td>
                                    </tr>
                                    <tr id="sync_url_row">
                                        <th scope="row">연동 URL</th>
                                        <td data-th="연동 URL">
											<div class="form-row gap-1">
												<input class="form-control width-50per" type="text" name="name" id="name_label" required="true" inputmask="byte" maxLen="10" minLen="4"
                                                 value="https://erp.knou.ac.kr/com/SsoCtr/initExtPageWork.do?link=ltAppr">
                                                <button type="button" class="btn type2">미리보기</button>
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">강의평가 후 성적조회</th>
                                        <td data-th="강의평가 후 성적조회">
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="post_eval_grade_view_yn" id="post_eval_grade_view_y" value="Y" checked="">
													<label for="post_eval_grade_view_y">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="post_eval_grade_view_yn" id="post_eval_grade_view_n" value="N">
													<label for="post_eval_grade_view_n">아니오</label>
												</span>
											</div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">강의평가 결과조회</th>
                                        <td data-th="강의평가 결과조회">
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="eval_result_view_yn" id="eval_result_view_y" value="Y" checked="">
													<label for="eval_result_view_y">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="eval_result_view_yn" id="eval_result_view_n" value="N">
													<label for="eval_result_view_n">아니오</label>
												</span>
											</div>                                            
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box mt30">
                    <button type="button" class="btn modal__btn" id="btn-modal1">이전 강의평가 가져오기</button>
                    <button type="button" class="btn modal__btn" id="btn-modal2">강의평가 팝업관리</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                    </div>
                </div>
            </div>
            <!-- //content -->


        <!-- Modal1 이전 강의평가 가져오기 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">

                    <div class="board_top in_table">
                        <select class="form-select" id="participationStatus">
                            <option value="">2026년도</option>
                        </select>
                        <select class="form-select" id="evaluationStatus">
                            <option value="">1학기</option>
                        </select>
                        <select class="form-select" id="participationStatus" disabled>
                            <option value="">대학원</option>
                        </select>
                        <select class="form-select" id="evaluationStatus">
                            <option value="">분류</option>
                        </select>
                        <!-- search small -->
                        <div class="search-typeC">
                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="강의평가제목 입력">
                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                        </div>
                    </div>                    
                    <div class="table-wrap overflow-y">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:5%">
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col>
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">기관</th>
                                    <th scope="col">관리구분</th>
                                    <th scope="col">분류</th>
                                    <th scope="col">학과</th>
                                    <th scope="col">강의평가 제목</th>
                                    <th scope="col">강의평가 구분</th>
                                    <th scope="col">선택</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">50</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="관리구분">LMS</td>
                                    <td data-th="분류">과목별</td>
                                    <td data-th="학과">-</td>
                                    <td data-th="강의평가 제목">중간 강의평가001</td>
                                    <td data-th="강의평가 구분">중간고사</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">49</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="관리구분">LMS</td>
                                    <td data-th="분류">학과별</td>
                                    <td data-th="학과">정보과학과</td>
                                    <td data-th="강의평가 제목">기말 강의평가001</td>
                                    <td data-th="강의평가 구분">기말고사</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">48</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="관리구분">LMS</td>
                                    <td data-th="분류">과목별</td>
                                    <td data-th="학과">-</td>
                                    <td data-th="강의평가 제목">중간 강의평가001</td>
                                    <td data-th="강의평가 구분">중간고사</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">47</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="관리구분">LMS</td>
                                    <td data-th="분류">과목별</td>
                                    <td data-th="학과">-</td>
                                    <td data-th="강의평가 제목">중간 강의평가001</td>
                                    <td data-th="강의평가 구분">중간고사</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">46</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="관리구분">LMS</td>
                                    <td data-th="분류">과목별</td>
                                    <td data-th="학과">-</td>
                                    <td data-th="강의평가 제목">중간 강의평가001</td>
                                    <td data-th="강의평가 구분">중간고사</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">45</td>
                                    <td data-th="기관">대학원</td>
                                    <td data-th="관리구분">LMS</td>
                                    <td data-th="분류">과목별</td>
                                    <td data-th="학과">-</td>
                                    <td data-th="강의평가 제목">중간 강의평가001</td>
                                    <td data-th="강의평가 구분">중간고사</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>


                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 이전 강의평가 가져오기 -->



        <!-- Modal2 강의평가 팝업관리 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content">
                <div class="modal-body">
                    
                    <div class="msg-box">
                        <p class="txt"><strong>강의평가 팝업관리 설정할 경우</strong></p>
                        <ul class="list-dot">
                            <li>강의평가 기간 내에 강의평가에 참여하지 않은 학습자의 대시보드에 강의평가 설문 팝업을 띄웁니다.</li>
                            <li>강의평가 미참여시 설정 주차의 수강을 제한 합니다.</li>
                        </ul>
                    </div>

                    <div class="board_top">
                        <h4 class="sub-title">강의평가 제목 : 중간 강의평가001</h4>
                    </div>
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:30%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="col">중간고사 강의평가</th>
                                    <td data-th="중간고사 강의평가">
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_none" value="NONE" checked="">
                                                <label for="mid_popup_none">사용 안 함</label>
                                            </span>
                                        </div>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w1" value="1">
                                                <label for="mid_popup_w1">1주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w2" value="2">
                                                <label for="mid_popup_w2">2주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w3" value="3">
                                                <label for="mid_popup_w3">3주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w4" value="4">
                                                <label for="mid_popup_w4">4주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w5" value="5">
                                                <label for="mid_popup_w5">5주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w6" value="6">
                                                <label for="mid_popup_w6">6주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w7" value="7">
                                                <label for="mid_popup_w7">7주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w8" value="8">
                                                <label for="mid_popup_w8">8주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w9" value="9">
                                                <label for="mid_popup_w9">9주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w10" value="10">
                                                <label for="mid_popup_w10">10주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w11" value="11">
                                                <label for="mid_popup_w11">11주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w12" value="12">
                                                <label for="mid_popup_w12">12주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w13" value="13">
                                                <label for="mid_popup_w13">13주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_w14" value="14">
                                                <label for="mid_popup_w14">14주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="mid_popup_setting" id="mid_popup_grade" value="GRADE">
                                                <label for="mid_popup_grade">성적확인</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="col">기말고사 강의평가</th>
                                    <td data-th="기말고사 강의평가">
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_none" value="NONE" checked="">
                                                <label for="final_popup_none">사용 안 함</label>
                                            </span>
                                        </div>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w1" value="1">
                                                <label for="final_popup_w1">1주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w2" value="2">
                                                <label for="final_popup_w2">2주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w3" value="3">
                                                <label for="final_popup_w3">3주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w4" value="4">
                                                <label for="final_popup_w4">4주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w5" value="5">
                                                <label for="final_popup_w5">5주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w6" value="6">
                                                <label for="final_popup_w6">6주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w7" value="7">
                                                <label for="final_popup_w7">7주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w8" value="8">
                                                <label for="final_popup_w8">8주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w9" value="9">
                                                <label for="final_popup_w9">9주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w10" value="10">
                                                <label for="final_popup_w10">10주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w11" value="11">
                                                <label for="final_popup_w11">11주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w12" value="12">
                                                <label for="final_popup_w12">12주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w13" value="13">
                                                <label for="final_popup_w13">13주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_w14" value="14">
                                                <label for="final_popup_w14">14주차</label>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="final_popup_setting" id="final_popup_grade" value="GRADE">
                                                <label for="final_popup_grade">성적확인</label>
                                            </span>
                                        </div>
                                    </td>
                                </tr>                                
                            </tbody>
                        </table>
                    </div>

                    <div class="btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>

                </div>
            </div>
        </div>


        </main>
        <!-- //admin-->
    </div>




    <script>
        //학사연동 클릭 > 연동URL 보여주기
        $(document).ready(function() {
            function toggleSyncUrlRow() {
                const selectedValue = $('input[name="manage_type"]:checked').val();
                if (selectedValue === 'HAKSA') {
                    $('#sync_url_row').show();
                } else {
                    $('#sync_url_row').hide();
                }
            }

            toggleSyncUrlRow();

            $('input[name="manage_type"]').change(toggleSyncUrlRow);

            //이전 강의평가 가져오기
            $('#btn-modal1').on('click', function() {
                
                var $content = $('#modal1 .modal-body');

                UiDialog("dialog1", {
                    title: "이전 강의평가 가져오기",
                    width: 1200,
                    height: 540,
                    html: $content
                });
            });


            //강의평가 팝업관리
            $('#btn-modal2').on('click', function() {
                
                var $content = $('#modal2 .modal-body');

                UiDialog("dialog1", {
                    title: "강의평가 팝업관리",
                    width: 800,
                    height: 600,
                    html: $content
                });
            });                        
        });
    </script>
</body>
</html>
