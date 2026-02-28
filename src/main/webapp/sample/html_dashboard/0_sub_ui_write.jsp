<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
    	<!-- common header -->
    	<jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
						<div class="page-info">
                            <h2 class="page-title"><span>게시물</span>등록, 수정</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>게시물</li>
                                    <li><span class="current">현재페이지</span></li>
                                </ul>
                            </div>
                        </div>

                        <!--table-type-->
						<div class="table-wrap">
							<form id="form1" name="form1">

							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label for="haksa_label">학사연동</label></th>
										<td>
											<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="emailRecv" id="emailRecvY" value="Y" checked="">
													<label for="emailRecvY">YES</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="emailRecv" id="emailRecvN" value="N">
													<label for="emailRecvN">NO</label>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="univ_label" class="req">과정(테넌시)</label></th>
										<td>
											<div class="form-inline">
												<select class="form-select" id="univ_label" name="univ_label" required="true">
													<option value="">과정(테넌시) 선택</option>
													<option value="평생교육">평생교육</option>
													<option value="프라임칼리지">프라임칼리지</option>
													<option value="대학원">대학원</option>
												</select>
												<button type="button" class="btn gray1">추가</button>
												<ul class="label_list">
													<li class="addedLabel">
														<label>대학원</label><span class="labelRemove"><i class="xi-close-min"></i></span>
													</li>
													<li class="addedLabel">
														<label>평생교육</label><span class="labelRemove"><i class="xi-close-min"></i></span>
													</li>
													<li class="addedLabel">
														<label>학위과정</label><span class="labelRemove"><i class="xi-close-min"></i></span>
													</li>
												</ul>												
												<script>
													document.addEventListener("DOMContentLoaded", function() {
														const removeButtons = document.querySelectorAll(".labelRemove");

														removeButtons.forEach(function(button) {
															button.addEventListener("click", function() {
																// 클릭된 <span>의 부모인 <li>를 찾고 삭제
																const labelItem = button.closest("li");
																labelItem.remove();
															});
														});
													});
												</script>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="univ_select2" class="req">과정선택(멀티)</label></th>
										<td>
											<div class="form-inline">
												<select class="form-select" id="univ_select2" name="univ_select2" multiple="multiple" data-placeholder="과정을 선택하세요." title="과정선택" style="width:500px" required="true" >
													<!-- <option value="">과정 선택</option> -->
													<option value="평생교육">평생교육</option>
													<option value="프라임칼리지">프라임칼리지</option>
													<option value="대학원">대학원</option>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="id_label">과정(테넌시) ID</label></th>
										<td>
											<div class="form-inline">
                                               <input class="form-control" type="text" id="te_id_label" placeholder="과정(테넌시) ID 입력"/>
											   <button type="button" class="btn gray1">중복확인</button>
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="name_label" class="req">이름</label></th>
										<td>
											<div class="form-row">
												<input class="form-control width-50per" type="text" name="name" id="name_label" value="" placeholder="이름을 입력하세요" required="true" inputmask="byte" maxLen="10" minLen="4">
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="id_label" class="req">아이디</label></th>
										<td>
											<div class="form-inline">
                                                 hongs1234
                                        		<small class="note2">! 수정불가</small>
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="id_label" class="req">아이디</label></th>
										<td>
											<div class="form-inline">
                                               <input class="form-control" type="text" id="id_label" placeholder="아이디를 입력하세요" required="true"/>
											   <button type="button" class="btn gray1">중복확인</button>
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="pw_label" class="req">비밀번호</label></th>
										<td>
											<div class="form-row">
                                                <input class="form-control" type="password" id="pw_label" placeholder="비밀번호 입력" required="true"/>
                                            </div>
											<small class="note">* 비밀번호는 최소 8자리, 특수문자+숫자+영문 조합입니다.</small>
										</td>
									</tr>
									<tr>
										<th><label for="pw_label2">비밀번호 변경</label></th>
										<td>
											<div class="form-inline">
                                                <input class="form-control" type="password" id="pw_label2" placeholder="비밀번호 입력"/>
												<small class="note2">! 정보변경 비밀번호 확인</small>
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="mobileLabel">휴대폰 번호</label></th>
										<td>
											<div class="form-row">
												<input type="text" style="width:150px" inputmask="phone">
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="timeLabel">학습시간</label></th>
										<td>
											<div class="form-row">
												<div class="input_btn">
													<input class="form-control sm" id="timeInput" type="text" maxlength="2"><label>분</label>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="disabled_label">input disabled</label></th>
										<td>
											<div class="form-row">
                                                <input class="form-control width-50per" type="text" name="name" id="disabled_label" value="disabled 일 때" disabled>
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="readonly_label">input readonly</label></th>
										<td>
											<div class="form-row">
                                                <input class="form-control width-50per" type="text" name="name" id="readonly_label" value="readonly 일 때" readonly>
                                            </div>
										</td>
									</tr>
									<tr>
										<th><label for="inputEmail1">이메일주소</label></th>
										<td>
											<div class="form-inline">
												<input class="form-control mr5" type="text" name="name" value="" id="inputEmail1">
												<span class="mr5">@</span>
												<input class="form-control mr5" type="text" name="name" id="inputEmail2" value=""  title="이메일 주소 뒷자리" placeholder="">
												<select class="form-select" id="selectEmail2">
													<option value="-">직접입력</option>
													<option value="-">naver.com</option>
													<option value="-">daum.net</option>
												</select>
												<button type="button" class="btn gray1">중복확인</button>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="noticeLabel">공지글</label></th>
										<td>
											<div class="form-inline">
												<span class="custom-input">
													<input type="checkbox" name="noticeLabel" id="noticeLabel">
													<label for="noticeLabel">공지글</label>
												</span>
												<div class="date_area">
													<input type="text" placeholder="시작일" id="datetimepicker1" class="datepicker" toDate="datetimepicker2" required="true">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="datetimepicker2" class="datepicker" fromDate="datetimepicker1" required="true">
												</div>
											</div>

										</td>
									</tr>
									<tr>
										<th><label for="noticeLabel">기간 </label></th>
										<td>
											<div class="date_area">
												<input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
												<input type="text" placeholder="시작시간" id="timepicker3" class="timepicker" dateId="datepicker3">
												<span class="txt-sort">~</span>
												<input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
												<input type="text" placeholder="종료시간" id="timepicker4" class="timepicker" dateId="datepicker4">
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="select_fullLabel">구분</label></th>
										<td>
											<div class="form-row">
												<select class="form-select width-100per" id="select_fullLabel" name="select_fullLabel">
													<option value="select size full">select size full</option>
													<option value="select option">select option</option>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="checkOpenYn">공개여부</label></th>
										<td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="checkType">옵션</label></th>
										<td>
											<div class="checkbox_type">
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType1">
													<label for="checkType1">옵션A</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType2">
													<label for="checkType2">옵션B</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType3">
													<label for="checkType3">옵션C</label>
												</span>
												<span class="custom-input">
													<input type="checkbox" name="name" id="checkType4">
													<label for="checkType4">옵션D</label>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="inputAddress1">주소</label></th>
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
										<th><label for="select_fullLabel" class="req">제목</label></th>
										<td>
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="name" id="name_label" value="" placeholder="input size full" required="true">
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="contTextarea" class="req">내용</label></th>
										<td data-th="입력">
											<li>
												<dl>
													<dd>
														<div class="editor-box">
															<label for="atclCts" class="hide">Content</label>
															<textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
															<script>
																// HTML 에디터
																let editor = UiEditor({
																	targetId: "atclCts",
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
																	alert("비어있다....");
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
											</li>

										</section>
										<!--//섹션 에디터-->
										</td>
									</tr>
									<tr>
										<th><label for="attchFile">첨부파일</label></th>
										<td>
											<uiex:dextuploader
												id="fileUploader"
												path="/bbs"
												limitCount="5"
												limitSize="100"
												oneLimitSize="100"
												listSize="3"
												fileList=""
												finishFunc="finishUpload()"
												allowedTypes="*"
											/>
										</td>
									</tr>
									<tr>
										<th><label for="select_fullLabel" class="req">텍스트 내용</label></th>
										<td>
											<div class="form-row">
												<textarea class="form-control" style="width:100%;height:100px" maxLenCheck="byte,1000,true,false" required="true"></textarea>
											</div>
										</td>
									</tr>
								</tbody>

							</table>
							</form>
						</div>
						<!--//table-type-->

						<div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>

						<a href="#_" onclick="checkValidation();return false;">[입력필드 Validation]</a>
						<script>
							function checkValidation() {
								let validator = UiValidator("form1");
								validator.then(function(result) {
									if (result) {
										alert("Validate 성공");
										// 여기에 Submit 처리
									}
									else {
										console.log("Validate 실패");
										return false;
									}
								});
							}

						</script>
                    </div>


                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"></jsp:include>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

