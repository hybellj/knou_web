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
								<div class="card_item">
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
								<div class="card_item active">
									<a href="#">
										<span class="step-num">4</span>
										수강생 등록
									</a>
								</div>
							</div>
						</div>
						<!-- //과목 개설 과정 -->


						<!-- 수강생 추가 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">수강생 추가</h3>
							</div>


							<div class="board_top">
								<select class="form-select">
									<option value="대학원">대학원</option>
								</select>
								<div class="search-typeC">
									<input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름 검색">
									<button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
								</div>
								<div class="right-area">
									<button type="button" class="btn basic">엑셀로 추가</button>
									<button type="button" class="btn basic">수강생 추가</button>
								</div>
							</div>


							<div class="table-wrap overflow-y">
								<table class="table-type3">
									<colgroup>
										<col style="width:3%">
										<col style="width:5%">
										<col>
										<col>
										<col>
										<col>
										<col>
										<col>
									</colgroup>
									<thead>
										<tr>
											<th scope="col">
	                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>												
											</th>
											<th scope="col">번호</th>
											<th scope="col">기관</th>
											<th scope="col">학과</th>
											<th scope="col">학번</th>
											<th scope="col">이름</th>
											<th scope="col">연락처</th>
											<th scope="col">이메일</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk13">
													<label for="chk13"></label>
												</span>
											</td>
											<td data-th="번호">13</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk12">
													<label for="chk12"></label>
												</span>
											</td>
											<td data-th="번호">12</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk11">
													<label for="chk11"></label>
												</span>
											</td>
											<td data-th="번호">11</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk10">
													<label for="chk10"></label>
												</span>
											</td>
											<td data-th="번호">10</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk9">
													<label for="chk9"></label>
												</span>
											</td>
											<td data-th="번호">9</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk8">
													<label for="chk8"></label>
												</span>
											</td>
											<td data-th="번호">8</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk7">
													<label for="chk7"></label>
												</span>
											</td>
											<td data-th="번호">7</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk6">
													<label for="chk6"></label>
												</span>
											</td>
											<td data-th="번호">6</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk5">
													<label for="chk5"></label>
												</span>
											</td>
											<td data-th="번호">5</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="선택">
	                                            <span class="custom-input onlychk">
													<input type="checkbox" id="chk4">
													<label for="chk4"></label>
												</span>
											</td>
											<td data-th="번호">4</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- //수강생 추가 -->

						<!-- 수강생 목록 -->
						<div class="box">
							<div class="board_top">
								<h3 class="board-title">수강생 목록</h3>
							</div>


							<div class="board_top">
								<select class="form-select">
									<option value="대학원">대학원</option>
								</select>
								<div class="search-typeC">
									<input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름 검색">
									<button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
								</div>
								<div class="right-area">
									<button type="button" class="btn type2">엑셀 다운로드</button>
								</div>
							</div>


							<div class="table-wrap overflow-y">
								<table class="table-type3">
									<colgroup>
										<col style="width:5%">
										<col>
										<col>
										<col>
										<col>
										<col>
										<col>
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">기관</th>
											<th scope="col">학과</th>
											<th scope="col">학번</th>
											<th scope="col">이름</th>
											<th scope="col">연락처</th>
											<th scope="col">이메일</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td data-th="번호">13</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">12</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">11</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">10</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">9</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">8</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">7</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">6</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">5</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
										<tr>
											<td data-th="번호">4</td>
											<td data-th="기관">대학원</td>
											<td data-th="학과">정보과학과</td>
											<td data-th="학번">1234***74</td>
											<td data-th="이름">홍*동</td>
											<td data-th="연락처">010-1234-56**</td>
											<td data-th="이메일">test**1@knou.ac.kr</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- //수강생 목록 -->						
					</div>
				</div>
			</div>

			<!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>
