<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
	</jsp:include>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
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
                            <h2 class="page-title">기본 정보 관리</h2>
                        </div>

                        <div class="box">
							<div class="board_top">
								<h3 class="board-title">등록</h3>
							</div>

							<!--table-type-->
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="te_id_label" class="req">기관 ID</label></th>
											<td>
												<div class="form-inline">
												<input class="form-control" type="text" id="te_id_label" placeholder="기관 ID 입력" />
												<button type="button" class="btn gray1">중복확인</button>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="te_full_label" class="req">기관 Full Name</label></th>
											<td>
												<div class="form-row">
												<input class="form-control width-50per" type="text" id="te_full_label" placeholder="기관 Full Name 입력" />
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="te_short_label" class="req">기관 Short Name</label></th>
											<td>
												<div class="form-row">
												<input class="form-control width-50per" type="text" id="te_short_label" placeholder="기관 Short Name 입력" />
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="te_type_label" class="req">기관 유형</label></th>
											<td>
												<div class="form-row">
												<select class="form-select" id="te_type_label" name="te_type_label">
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
											<th><label for="url_label" class="req">홈페이지 URL</label></th>
											<td>
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="name" id="url_label" value="http://" placeholder="">
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="name_label" class="req">담당자명</label></th>
											<td>
												<div class="form-row">
													<input class="form-control" type="text" id="name_label" placeholder="담당자명 입력" />
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="mobileLabel" class="req">담당자 연락처</label></th>
											<td>
												<div class="form-row">
													<div class="num_input">
														<select id="mobileLabel" class="form-select compact">
															<option value="010">010</option>
															<option value="011">011</option>
															<option value="016">016</option>
															<option value="017">017</option>
															<option value="018">018</option>
															<option value="019">019</option>
														</select>
														<span class="txt-sort">-</span>
														<input type="text" maxlength="4" class="form-control compact" />
														<span class="txt-sort">-</span>
														<input type="text" maxlength="4" class="form-control compact" />
													</div>

												</div>
											</td>
										</tr>
										<tr>
											<th><label for="inputEmail1" class="req">담당자 이메일</label></th>
											<td>
												<div class="form-inline">
													<input class="form-control mr5" type="text" name="name" value="" id="inputEmail1">
													<span class="mr5">@</span>
													<input class="form-control mr5" type="text" name="name" id="inputEmail2" value=""  title="이메일 주소 뒷자리" placeholder="">
													<select class="form-select" id="selectEmail2">
														<option value="-">선택</option>
														<option value="-">naver.com</option>
														<option value="-">daum.net</option>
													</select>
													<button type="button" class="btn gray1">직접입력</button>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="telLabel">사무실 전화번호</label></th>
											<td>
												<div class="form-row">
													<div class="num_input">
														<select id="telLabel" class="form-select compact">
															<option value="-">선택</option>
															<option value="-" selected>02</option>
															<option value="-">031</option>
														</select>
														<span class="txt-sort">-</span>
														<input type="text" maxlength="4" class="form-control compact" />
														<span class="txt-sort">-</span>
														<input type="text" maxlength="4" class="form-control compact" />
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="attchFile">기관 로고 PC</label></th>
											<td>

												<!--업로드-->
												<div id="upload">

													<!--파일업로드-->
													<div id="drop">
														파일을 여기에 끌어다 놓거나, 파일 선택 버튼을 클릭하여 업로드하세요.
														<a id="buttonLink" href="javascript:uploderclick('atchuploader');" class="btn type3">파일 선택</a>
														<input type="file" name="atchuploader" id="atchuploader" multiple="" style="display:none">

														<div id="atchprogress" class="progress" style="display: none;">
															<div class="progress-inner"></div>
														</div>
													</div>
													<!--//파일업로드-->

													<!--파일 -->
													<ul id="atchfiles">
														<li id="attachIdx_1">
															<p><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.png" aria-hidden="true" alt="한국방송통신대학교"></p><span aria-label="삭제" href="#_none"></span>
														</li>
													</ul>
													<!--//파일 -->

												</div>
												<!--//업로드-->

											</td>
										</tr>
										<tr>
											<th><label for="attchFile">기관 로고 Mobile</label></th>
											<td>

												<!--업로드-->
												<div id="upload">

													<!--파일업로드-->
													<div id="drop">
														파일을 여기에 끌어다 놓거나, 파일 선택 버튼을 클릭하여 업로드하세요.
														<a id="buttonLink" href="javascript:uploderclick('atchuploader');" class="btn type3">파일 선택</a>
														<input type="file" name="atchuploader" id="atchuploader" multiple="" style="display:none">

														<div id="atchprogress" class="progress" style="display: none;">
															<div class="progress-inner"></div>
														</div>
													</div>
													<!--//파일업로드-->

													<!--파일 -->
													<ul id="atchfiles">
														<li id="attachIdx_1">
															<p><img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_mobile.png" aria-hidden="true" alt="한국방송통신대학교"></p><span aria-label="삭제" href="#_none"></span>
														</li>
													</ul>
													<!--//파일 -->

												</div>
												<!--//업로드-->

											</td>
										</tr>
									</tbody>
								</table>

							</div>
							<!--//table-type-->
						</div>

						<div class="box">
							<div class="board_top">
								<h3 class="board-title">하단 문구</h3>
							</div>

							<!--table-type-->
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="inputAddress1" class="req">주소</label></th>
											<td>
												<div class="form-inline mb10">
													<input class="form-control" type="text" name="name" id="inputAddress1" value="" placeholder="우편번호">
													<button type="button" class="btn gray1">우편번호 찾기</button>
												</div>

												<div class="form-row">
													<input class="form-control width-100per" type="text" name="title" id="inputAddress2" value="" title="주소를 입력하세요" placeholder="주소">
												</div>
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="title" id="inputAddress3" value="" title="나머지 주소를 입력하세요" placeholder="나머지 주소">
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="telLabel2" class="req">대표전화</label></th>
											<td>
												<div class="form-row">
													<div class="num_input">
														<select id="telLabel2" class="form-select compact">
															<option value="-">선택</option>
															<option value="-" selected>02</option>
															<option value="-">031</option>
														</select>
														<span class="txt-sort">-</span>
														<input type="text" maxlength="4" class="form-control compact" />
														<span class="txt-sort">-</span>
														<input type="text" maxlength="4" class="form-control compact" />
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="copy_label" class="req">CopyRight</label></th>
											<td>
												<div class="form-row">
													<input class="form-control width-100per" type="text" name="name" id="copy_label" value="COPYRIGHT ©KOREA NATIONAL OPEN UNIVERSITY. ALL RIGHTS RESERVED" placeholder="">
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
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

