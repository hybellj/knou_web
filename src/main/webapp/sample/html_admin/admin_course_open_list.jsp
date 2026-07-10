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
							<h2 class="page-title">과목 개설</h2>
							<div class="navi_bar">
								<ul>
									<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
									<li>수업운영도구</li>
									<li>과정관리</li>
									<li>과목개설관리</li>
									<li><span class="current">과목개설</span></li>
								</ul>
							</div>
						</div>

						<!-- 과목 개설 과정 -->
						<div class="step-process-wrap mb40">
							<div class="board_card_list">
								<div class="card_item active">
									<a href="#">
										<span class="step-num">1</span>
										개설과목 정보등록
									</a>
								</div>
								<div class="card_item">
									<a href="#">
										<span class="step-num">2</span>
										주차 기간 설정
									</a>
								</div>
								<div class="card_item">
									<a href="#">
										<span class="step-num">3</span>
										과목 관리자 등록
									</a>
								</div>
								<div class="card_item">
									<a href="#">
										<span class="step-num">4</span>
										수강생 등록
									</a>
								</div>
							</div>
						</div>
						<!-- //과목 개설 과정 -->


						<!-- 개설 과목 정보 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">개설 과목 정보</h3>
							</div>

							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="sel_institution" class="req">기관</label></th>
											<td>
												<div class="form-row">
													<select class="form-select" id="sel_institution" name="sel_institution">
														<option value="">선택</option>
														<option value="대학원">대학원</option>
														<option value="경영대학원">경영대학원</option>
														<option value="학사학위과정">학사학위과정</option>
														<option value="종합교육연수원">종합교육연수원</option>
													</select>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">학기/기수 명</th>
											<td>
												<div class="form-inline">
													<select class="form-select" id="sel_term_type" name="sel_term_type" title="학기유형 선택">
														<option value="">선택</option>
													</select>
													<select class="form-select" id="sel_year" name="sel_year" title="년도 선택">
														<option value="">년도</option>
													</select>
													<select class="form-select" id="sel_term" name="sel_term" title="학기/기수 선택">
														<option value="">학기/기수</option>
													</select>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">과목 분류</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="subject_category" id="subj_cat_semester" value="semester" checked>
														<label for="subj_cat_semester">학기제</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="subject_category" id="subj_cat_term" value="term">
														<label for="subj_cat_term">기수제</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="subject_category" id="subj_cat_open" value="open">
														<label for="subj_cat_open">공개강좌</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="sel_dept" class="req">학과</label></th>
											<td>
												<div class="form-row">
													<select class="form-select" id="sel_dept" name="sel_dept">
														<option value="">선택</option>
													</select>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="sel_subject" class="req">과목</label></th>
											<td>
												<div class="form-row">
													<select class="form-select" id="sel_subject" name="sel_subject">
														<option value="">선택</option>
													</select>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="subject_nm_ko" class="req">과목명(KO)</label></th>
											<td>
												<div class="form-row">
													<input class="form-control" type="text" name="subject_nm_ko" id="subject_nm_ko" placeholder="과목명(KO) 입력">
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="subject_nm_en">과목명(EN)</label></th>
											<td>
												<div class="form-row">
													<input class="form-control" type="text" name="subject_nm_en" id="subject_nm_en" placeholder="과목명(EN) 입력" />
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="sel_division" class="req">분반</label></th>
											<td>
												<div class="form-row">
													<div class="num_input">
														<select id="sel_division" name="sel_division" class="form-select compact">
															<option value="">선택</option>
															<option value="1">1반</option>
															<option value="2">2반</option>
														</select>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="division_alias" class="req">분반 별칭</label></th>
											<td>
												<div class="form-inline">
													<input class="form-control mr5" type="text" name="division_alias" id="division_alias" placeholder="일반분반">
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">과정 구분</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="course_type" id="course_reg" value="regular" checked>
														<label for="course_reg">정규과정</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="course_type" id="course_nonreg" value="non-regular">
														<label for="course_nonreg">비정규과정</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">강의 형태</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="lecture_type" id="lec_online" value="online" checked>
														<label for="lec_online">온라인</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="lecture_type" id="lec_offline" value="offline">
														<label for="lec_offline">오프라인</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="lecture_type" id="lec_mix" value="mix">
														<label for="lec_mix">혼합</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="subject_desc" class="req">과목설명</label></th>
											<td>
												<textarea name="subject_desc" id="subject_desc" class="width-100per"></textarea>
											</td>
										</tr>
										<tr>
											<th class="req">학점</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="subject_credit" id="credit_1" value="1">
														<label for="credit_1">1점</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="subject_credit" id="credit_2" value="2">
														<label for="credit_2">2점</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="subject_credit" id="credit_3" value="3" checked>
														<label for="credit_3">3점</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="subject_credit" id="credit_4" value="4">
														<label for="credit_4">4점</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">이수 구분</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="completion_type" id="comp_culture_req" value="culture_req" checked>
														<label for="comp_culture_req">교양필수</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="completion_type" id="comp_culture_sel" value="culture_sel">
														<label for="comp_culture_sel">교양선택</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="completion_type" id="comp_base_req" value="base_req">
														<label for="comp_base_req">계열기초</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="completion_type" id="comp_major_req" value="major_req">
														<label for="comp_major_req">전공필수</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="completion_type" id="comp_major_sel" value="major_sel">
														<label for="comp_major_sel">전공선택</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">사용 여부</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="use_yn" id="use_y" value="Y" checked>
														<label for="use_y">사용</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="use_yn" id="use_n" value="N">
														<label for="use_n">사용 안함</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">강의 평가</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="eval_yn" id="eval_y" value="Y" checked>
														<label for="eval_y">사용</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="eval_yn" id="eval_n" value="N">
														<label for="eval_n">사용 안함</label>
													</span>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- //개설 과목 정보 -->

						<!-- 강의 정보 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">강의 정보</h3>
							</div>
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th class="req">평가 방법</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="eval_method" id="eval_abs" value="absolute" checked>
														<label for="eval_abs">절대평가</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="eval_method" id="eval_rel" value="relative">
														<label for="eval_rel">상대평가</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="eval_method" id="eval_pf" value="pf">
														<label for="eval_pf">Pass/Fail</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">강의형식</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="lecture_format" id="fmt_week" value="week" checked>
														<label for="fmt_week">주별</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="lecture_format" id="fmt_topic" value="topic">
														<label for="fmt_topic">토픽</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">학습제어</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="learning_control" id="ctrl_date" value="date" checked>
														<label for="ctrl_date">날짜</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="learning_control" id="ctrl_seq" value="seq">
														<label for="ctrl_seq">순차</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="sel_preview_week" class="req">강의 맛보기</label></th>
											<td>
												<div class="form-row">
													<select class="form-select" id="sel_preview_week" name="sel_preview_week">
														<option value="">주차</option>
													</select>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- //강의 정보 -->

						<!-- 수강 신청 정보 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">수강 신청 정보</h3>
							</div>
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th class="req">신청방법</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="apply_method" id="apply_admin" value="admin" checked>
														<label for="apply_admin">관리자가 등록</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="apply_method" id="apply_user" value="user">
														<label for="apply_user">학습자가 신청</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">인증상태</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="auth_status" id="auth_approve" value="approve" checked>
														<label for="auth_approve">승인</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="auth_status" id="auth_wait" value="wait">
														<label for="auth_wait">대기</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">인원제한</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="limit_yn" id="limit_y" value="Y">
														<label for="limit_y">예</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="limit_yn" id="limit_n" value="N" checked>
														<label for="limit_n">아니오</label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="limit_count" class="req">제한 인원</label></th>
											<td>
												<div class="form-row">
													<div class="input_btn">
														<input class="form-control sm" id="limit_count" name="limit_count" type="text" maxlength="5">
														<label for="limit_count">명</label>
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- //수강 신청 정보 -->


						<!-- 강의 기간 정보 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">강의 기간 정보</h3>
							</div>
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th class="req">수강신청기간</th>
											<td>
												<div class="form-inline">
													<div class="date_area">
														<input type="text" placeholder="시작일" id="apply_start_dt" class="datepicker" toDate="apply_end_dt" required>
														<span class="txt-sort">~</span>
														<input type="text" placeholder="종료일" id="apply_end_dt" class="datepicker" fromDate="apply_start_dt" required>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">강의기간</th>
											<td>
												<div class="date_area">
													<input type="text" placeholder="시작일" id="lec_start_dt" class="datepicker" toDate="lec_end_dt" timeId="lec_start_tm">
													<input type="text" placeholder="시작시간" id="lec_start_tm" class="timepicker" dateId="lec_start_dt">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="lec_end_dt" class="datepicker" fromDate="lec_start_dt" timeId="lec_end_tm">
													<input type="text" placeholder="종료시간" id="lec_end_tm" class="timepicker" dateId="lec_end_dt">
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">지각 인정 일시</th>
											<td>
												<div class="date_area">
													<input type="text" placeholder="종료일" id="late_end_dt" class="datepicker" timeId="late_end_tm">
													<input type="text" placeholder="종료시간" id="late_end_tm" class="timepicker" dateId="late_end_dt">
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">청강 종료 일시</th>
											<td>
												<div class="date_area">
													<input type="text" placeholder="종료일" id="audit_end_dt" class="datepicker" timeId="audit_end_tm">
													<input type="text" placeholder="종료시간" id="audit_end_tm" class="timepicker" dateId="audit_end_dt">
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">성적처리기간</th>
											<td>
												<div class="form-inline">
													<div class="date_area">
														<input type="text" placeholder="시작일" id="grade_start_dt" class="datepicker" toDate="grade_end_dt" required>
														<span class="txt-sort">~</span>
														<input type="text" placeholder="종료일" id="grade_end_dt" class="datepicker" fromDate="grade_start_dt" required>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="req">복습기간</th>
											<td>
												<div class="form-inline">
													<span class="custom-input"> 
														<input type="radio" name="review_period_type" id="review_none" value="none" checked>
														<label for="review_none">불가</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="review_period_type" id="review_perm" value="permanent">
														<label for="review_perm">영구</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="review_period_type" id="review_set" value="set">
														<label for="review_set">기간설정</label>
													</span>
													<div class="date_area">
														<input type="text" placeholder="시작일" id="review_start_dt" class="datepicker" toDate="review_end_dt">
														<span class="txt-sort">~</span>
														<input type="text" placeholder="종료일" id="review_end_dt" class="datepicker" fromDate="review_start_dt">
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- //강의 기간 정보 -->

						<div class="btns">
							<button type="button" class="btn basic">다음</button>
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
