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
							<h2 class="page-title">출석점수 기준관리</h2>
							<div class="navi_bar">
								<ul>
									<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
									<li>수업운영도구</li>
									<li>과정관리</li>
									<li>수업운영</li>
									<li><span class="current">출석점수 기준관리</span></li>
								</ul>
							</div>
						</div>


						<!-- 등록 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">등록</h3>
							</div>


						<div class="table-wrap">
							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th class="req">기관</th>
										<td data-th="기관">
											<div class="form-inline">
												<select class="form-select" id="org_select" name="org_select" required="true" disabled>
													<option value="">대학원</option>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th class="req">년도/학기(기수)</th>
										<td data-th="년도/학기(기수)">
											<div class="form-inline">
												<select class="form-select" id="year_select" name="year_select" required="true">
													<option value="2026년">2026년</option>
												</select>
												<select class="form-select" id="semester_select" name="semester_select" required="true">
													<option value="1학기">1학기</option>
												</select>
											</div>
											<button type="button" class="btn type2">이전학기 기준 가져오기</button>
										</td>										
									</tr>
								</tbody>
							</table>
						</div>

						<table class="table-type3">
							<colgroup>
								<col style="width:8%">
								<col style="width:3%">
								<col>
								<col style="width:15%">
								<col>
								<col style="width:5%">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" colspan="6">출결기준 및 진도율 설정</th>
								</tr>
								<tr>
									<th scope="col">구분</th>
									<th scope="col" colspan="2">조건</th>
									<th scope="col">진도율 인정비율</th>
									<th scope="col">출결기준</th>
									<th scope="col">출결표시</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th data-th="출결기준 및 진도율 설정">배속 인정</th>
									<td data-th="출결기준 및 진도율 설정" colspan="5" class="t_left">
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="radiobtn" id="radiobtnY" value="Y" checked="">
													<label for="radiobtnY">예</label>
												</span>
												<span class="custom-input">
													<input type="radio" name="radiobtn" id="radiobtnN" value="N">
													<label for="radiobtnN">아니오</label>
												</span>
											</div>
									</td>
								</tr>
								<tr>
									<th data-th="구분" rowspan="3">각 주차</th>
									<td data-th="조건">1</td>
									<td data-th="조건" class="t_left">학습 기간 내 진도율</td>
									<td data-th="진도율 인정비율" class="t_left">
										<div class="form-row align-items-center gap-1">
											<div class="input_btn">
												<input class="form-control sm" id="progress_rate_1" name="progress_rate_1" type="text" maxlength="2" value="100">
												<label>%</label>
											</div>
											<div>인정</div>
										</div>
									</td>
									<td data-th="출결기준" class="t_left">
										<div class="form-row align-items-center gap-1">
											<div>1의 진도율이 </div>
											<div class="input_btn">
												<input class="form-control sm" id="attendance_threshold_1" name="attendance_threshold_1" type="text" maxlength="2" value="75">
												<label>%</label>
											</div>
											<div>이상</div>
										</div>
									</td>
									<td data-th="출결표시">
										<span class="fcBlue">출석</span>
									</td>
								</tr>
								<tr>
									<td data-th="조건">2</td>
									<td data-th="조건" class="t_left">학습 기간 외 진도율</td>
									<td data-th="진도율 인정비율" class="t_left">
										<div class="form-row align-items-center gap-1">
											<div class="input_btn">
												<input class="form-control sm" id="progress_rate_2" name="progress_rate_2" type="text" maxlength="2" value="50">
												<label>%</label>
											</div>
											<div>인정</div>
										</div>
									</td>
									<td data-th="출결기준" class="t_left">
										<div class="form-row align-items-center gap-1">
											<div>1의 진도율 + 2의 진도율이 </div>
											<div class="input_btn">
												<input class="form-control sm" id="timeInput" type="text" maxlength="2" value="75">
												<label>%</label>
											</div>
											<div>이상</div>
										</div>
									</td>
									<td data-th="출결표시">
										<span class="fcNot">지각</span>
									</td>
								</tr>

								<tr>
									<td data-th="조건">3</td>
									<td data-th="조건" class="t_left">그 이외 진도율</td>
									<td data-th="진도율 인정비율" class="t_left">
										<div class="form-row align-items-center gap-1">
											<div class="input_btn">
												<input class="form-control sm" id="progress_rate_3" name="progress_rate_3" type="text" maxlength="2" value="0">
												<label>%</label>
											</div>
											<div>인정</div>
										</div>
									</td>
									<td data-th="출결기준" class="t_left">
										그 외
									</td>
									<td data-th="출결표시">
										<span class="fcRed">결석</span>
									</td>
								</tr>
							</tbody>
						</table>

						<table class="table-type3">
							<colgroup>
								<col style="width:8%">
								<col>
								<col>
								<col style="width:10%">
							</colgroup>
							<thead>
								<tr>
									<th scope="col" colspan="4">출석점수 기준 비율계산 = { ( 출석 주차의 수 + 지각 주차의 수) / 전체 주차의 수 } * 100</th>
								</tr>
								<tr>
									<th scope="col">구분</th>
									<th scope="col">비율 조건</th>
									<th scope="col">출석점수</th>
									<th scope="col">관리</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th data-th="구분" rowspan="3">
										출석점수<br>기준비율
									</th>
									<td class="t_left fcBlue">출석</td>
									<td class="t_left">
										<div class="input_btn">
											<input class="form-control sm" id="attendance_score_1" name="attendance_score_1" type="text" maxlength="2" value="20">
											<label>점</label>
										</div>
									</td>
									<td></td>
								</tr>
								<tr>
									<td class="t_left fcNot">지각</td>
									<td class="t_left">
										<div class="input_btn">
											<input class="form-control sm" id="attendance_score_2" name="attendance_score_2" type="text" maxlength="2" value="10">
											<label>점</label>
										</div>
									</td>
									<td></td>
								</tr>
								<tr>
									<td class="t_left fcRed">결석</td>
									<td class="t_left">
										<div class="input_btn">
											<input class="form-control sm" id="attendance_score_2" name="attendance_score_2" type="text" maxlength="2" value="0">
											<label>점</label>
										</div>
									</td>
									<td></td>
								</tr>
							</tbody>
						</table>

							<div class="btns">
								<button type="button" class="btn type1">저장</button>
								<button type="button" class="btn type2">목록</button>
							</div>
						</div>
						<!-- //등록 -->
					</div>
				</div>
			</div>

			<!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>
