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
							<h2 class="page-title">학기/주차 관리</h2>
							<div class="navi_bar">
								<ul>
									<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
									<li>수업운영도구</li>
									<li>과정관리</li>
									<li><span class="current">학기/주차 관리</span></li>
								</ul>
							</div>
						</div>

						<!-- 과목 개설 과정 -->
						<div class="step-process-wrap mb40">
							<div class="board_card_list">
								<div class="card_item">
									<a href="#">
										<span class="step-num">1</span>
										학기/기수 정보 등록
									</a>
								</div>
								<div class="card_item active">
									<a href="#">
										<span class="step-num">2</span>
										주차 설정
									</a>
								</div>
							</div>
						</div>
						<!-- //과목 개설 과정 -->


						<!-- 수강생 추가 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">학기/기수 주차 및 출석 인정 기간 설정</h3>
							</div>


							<div class="table-wrap">
								<table class="table-type3">
									<colgroup>
										<col style="width:5%">
										<col>
										<col>
										<col style="width:5%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col" rowspan="2">주차</th>
											<th scope="col" colspan="2"><span class="req">주차명</span></th>
											<th scope="col" rowspan="2">삭제</th>
										</tr>
										<tr>
											<th scope="col"><span class="req">주차 기간</span></th>
											<th scope="col"><span class="req">출석 인정 기간</span></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td data-th="주차" rowspan="2" >1주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_1_name" id="week_1_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_1_period_start_date" class="datepicker" toDate="week_1_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_1_period_end_date" class="datepicker" fromDate="week_1_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_1_attendance_start_date" class="datepicker" toDate="week_1_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_1_attendance_end_date" class="datepicker" fromDate="week_1_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >2주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_2_name" id="week_2_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_2_period_start_date" class="datepicker" toDate="week_2_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_2_period_end_date" class="datepicker" fromDate="week_2_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_2_attendance_start_date" class="datepicker" toDate="week_2_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_2_attendance_end_date" class="datepicker" fromDate="week_2_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >3주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_3_name" id="week_3_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_3_period_start_date" class="datepicker" toDate="week_3_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_3_period_end_date" class="datepicker" fromDate="week_3_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_3_attendance_start_date" class="datepicker" toDate="week_3_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_3_attendance_end_date" class="datepicker" fromDate="week_3_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >4주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_4_name" id="week_4_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_4_period_start_date" class="datepicker" toDate="week_4_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_4_period_end_date" class="datepicker" fromDate="week_4_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_4_attendance_start_date" class="datepicker" toDate="week_4_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_4_attendance_end_date" class="datepicker" fromDate="week_4_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >5주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_5_name" id="week_5_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_5_period_start_date" class="datepicker" toDate="week_5_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_5_period_end_date" class="datepicker" fromDate="week_5_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_5_attendance_start_date" class="datepicker" toDate="week_5_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_5_attendance_end_date" class="datepicker" fromDate="week_5_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >6주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_6_name" id="week_6_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_6_period_start_date" class="datepicker" toDate="week_6_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_6_period_end_date" class="datepicker" fromDate="week_6_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_6_attendance_start_date" class="datepicker" toDate="week_6_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_6_attendance_end_date" class="datepicker" fromDate="week_6_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >7주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_7_name" id="week_7_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_7_period_start_date" class="datepicker" toDate="week_7_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_7_period_end_date" class="datepicker" fromDate="week_7_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_7_attendance_start_date" class="datepicker" toDate="week_7_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_7_attendance_end_date" class="datepicker" fromDate="week_7_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >8주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_8_name" id="week_8_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_8_period_start_date" class="datepicker" toDate="week_8_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_8_period_end_date" class="datepicker" fromDate="week_8_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_8_attendance_start_date" class="datepicker" toDate="week_8_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_8_attendance_end_date" class="datepicker" fromDate="week_8_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >9주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_9_name" id="week_9_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_9_period_start_date" class="datepicker" toDate="week_9_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_9_period_end_date" class="datepicker" fromDate="week_9_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_9_attendance_start_date" class="datepicker" toDate="week_9_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_9_attendance_end_date" class="datepicker" fromDate="week_9_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >10주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_10_name" id="week_10_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_10_period_start_date" class="datepicker" toDate="week_10_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_10_period_end_date" class="datepicker" fromDate="week_10_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_10_attendance_start_date" class="datepicker" toDate="week_10_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_10_attendance_end_date" class="datepicker" fromDate="week_10_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >11주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_11_name" id="week_11_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_11_period_start_date" class="datepicker" toDate="week_11_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_11_period_end_date" class="datepicker" fromDate="week_11_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_11_attendance_start_date" class="datepicker" toDate="week_11_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_11_attendance_end_date" class="datepicker" fromDate="week_11_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >12주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_12_name" id="week_12_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_12_period_start_date" class="datepicker" toDate="week_12_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_12_period_end_date" class="datepicker" fromDate="week_12_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_12_attendance_start_date" class="datepicker" toDate="week_12_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_12_attendance_end_date" class="datepicker" fromDate="week_12_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >13주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_13_name" id="week_13_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_13_period_start_date" class="datepicker" toDate="week_13_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_13_period_end_date" class="datepicker" fromDate="week_13_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_13_attendance_start_date" class="datepicker" toDate="week_13_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_13_attendance_end_date" class="datepicker" fromDate="week_13_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >14주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_14_name" id="week_14_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_14_period_start_date" class="datepicker" toDate="week_14_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_14_period_end_date" class="datepicker" fromDate="week_14_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_14_attendance_start_date" class="datepicker" toDate="week_14_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_14_attendance_end_date" class="datepicker" fromDate="week_14_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >15주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_15_name" id="week_15_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_15_period_start_date" class="datepicker" toDate="week_15_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_15_period_end_date" class="datepicker" fromDate="week_15_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_15_attendance_start_date" class="datepicker" toDate="week_15_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_15_attendance_end_date" class="datepicker" fromDate="week_15_attendance_start_date">
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="주차" rowspan="2" >16주차</td>
											<td data-th="주차명" colspan="2">
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="week_16_name" id="week_16_name_label" value="" placeholder="주차명" required="true">
												</div>
											</td>
											<td data-th="삭제" rowspan="2">
												<button type="button" class="btn basic small">
													<i class="xi-close"></i>
												</button>
											</td>
										</tr>
										<tr>
											<td data-th="주차 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_16_period_start_date" class="datepicker" toDate="week_16_period_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_16_period_end_date" class="datepicker" fromDate="week_16_period_start_date">
												</div>
											</td>
											<td datta-th="출석 인정 기간" class="t_left">
												<div class="date_area">
													<input type="text" placeholder="시작일" id="week_16_attendance_start_date" class="datepicker" toDate="week_16_attendance_end_date">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="week_16_attendance_end_date" class="datepicker" fromDate="week_16_attendance_start_date">
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								
								<!-- 주차 추가 버튼-->
								 <div class="btns">
									 <button type="button" class="btn type2">주차 추가</button>
								 </div><!-- //주차 추가 버튼-->

							</div>
						</div>
						<!-- //수강생 추가 -->
					</div>
				</div>
			</div>

			<!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>
