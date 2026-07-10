<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
		<jsp:param name="style" value="admin"/>
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
                            <h2 class="page-title">평가비중관리</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>수업운영도구</li>
                                    <li>과정관리</li>
                                    <li>수업운영</li>
                                    <li><span class="current">평가비중관리</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">수정</h3>
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
                                        <td data-th="기관" colspan="10">
											<div class="form-inline">
												<select class="form-select" id="institution_select" name="institution_select" required="true" >
													<option value="전체">전체</option>
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
                                        <td data-th="년도/학기(기수)" colspan="10">
											<div class="form-inline">
												<select class="form-select" id="year_select" name="year_select" required="true">
													<option value="">2026년</option>
												</select>
												<select class="form-select" id="term_select" name="term_select" required="true">
													<option value="">1학기</option>
												</select>
											</div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">학과</th>
                                        <td data-th="학과" colspan="10">
											<div class="form-inline">
												<select class="form-select" id="dept_select" name="dept_select" required="true" >
													<option value="">선택</option>
												</select>
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">과목</th>
                                        <td data-th="과목" colspan="10">
											<div class="form-inline">
												<select class="form-select" id="subject_select" name="subject_select" required="true" >
													<option value="">선택</option>
												</select>
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="req">분반같이 등록</th>
                                        <td data-th="분반같이 등록" colspan="10">
											<div class="checkbox_type">
												<span class="custom-input">
													<input type="checkbox" name="class_reg" id="class_reg_all">
													<label for="class_reg_all">전체</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="class_reg" id="class_reg_1">
													<label for="class_reg_1">1반</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="class_reg" id="class_reg_2">
													<label for="class_reg_2">2반</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="class_reg" id="class_reg_3">
													<label for="class_reg_3">3반</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="class_reg" id="class_reg_4">
													<label for="checkType4">4반</label>
												</span>
                                                <span class="fcRed">(과목 선택 시 자동 셋팅)</span>
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="req" colspan="11">평가비중</th>
                                    </tr>
                                    <tr>
                                        <th scope="col" rowspan="2" class="text-center">평가항목</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">중간고사</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">기말고사</th>
                                        <th scope="col" colspan="2" class="text-center border-left-1">출석</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">과제</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">토론</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">퀴즈</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">설문</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">세미나</th>
                                        <th scope="col" rowspan="2" class="text-center border-left-1">시험</th>
                                    </tr>
                                    <tr>
                                        <th scope="col" class="text-center border-left-1">진도</th>
                                        <th scope="col" class="text-center border-left-1">연습문제</th>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="text-center">비중</th>
                                        <td data-th="중간고사" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_mid" id="ratio_mid" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>
                                        </td>
                                        <td data-th="기말고사" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_final" id="ratio_final" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>
                                        </td>
                                        <td data-th="진도" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_attendance_progress" id="ratio_attendance_progress" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>
                                        </td>
                                        <td data-th="연습문제" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_attendance_exercise" id="ratio_attendance_exercise" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                        <td data-th="과제" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_assignment" id="ratio_assignment" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                        <td data-th="토론" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_discussion" id="ratio_discussion" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                        <td data-th="퀴즈" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_quiz" id="ratio_quiz" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                        <td data-th="설문" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_survey" id="ratio_survey" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                        <td data-th="세미나" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_seminar" id="ratio_seminar" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                        <td data-th="시험" class="border-left-1">
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="ratio_exam" id="ratio_exam" value=""  required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row" class="text-center">성적공개여부</th>
                                        <td data-th="중간고사" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_mid" name="open_yn_mid" class="switch yesno" checked>
											</div>
                                        </td>
                                        <td data-th="기말고사" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_final" name="open_yn_final" class="switch yesno" checked>
											</div>
                                        </td>
                                        <td data-th="출석-진도,연습문제" colspan="2" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_attendance" name="open_yn_attendance" class="switch yesno" checked>
											</div>                                            
                                        </td>
                                        <td data-th="과제" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_assignment" name="open_yn_assignment" class="switch yesno">
											</div>
                                        </td>
                                        <td data-th="토론" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_discussion" name="open_yn_discussion" class="switch yesno">
											</div>
                                        </td>
                                        <td data-th="퀴즈" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_quiz" name="open_yn_quiz" class="switch yesno">
											</div>
                                        </td>
                                        <td data-th="설문" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_survey" name="open_yn_survey" class="switch yesno">
											</div>
                                        </td>
                                        <td data-th="세미나" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_seminar" name="open_yn_seminar" class="switch yesno">
											</div>
                                        </td>
                                        <td data-th="시험" class="border-left-1">
											<div class="form-row justify-content-center">
												<input type="checkbox" id="open_yn_exam" name="open_yn_exam" class="switch yesno">
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

                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>
