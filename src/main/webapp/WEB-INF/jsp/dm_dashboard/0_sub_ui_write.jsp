<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../dm_inc/home_common.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/dm_assets/css/dashboard.css" />

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="../dm_inc/home_header.jsp" %>
        <!-- //common header -->
    
        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="../dm_inc/home_gnb_prof.jsp" %>
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
                        
                        <!--table-type2-->
						<div class="table-wrap">
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
												<select class="form-select" id="univ_label" name="univ_label">
													<option value="">과정(테넌시) 선택</option>
													<option value="평생교육">평생교육</option>
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
										<th><label for="name_label" class="req">이름</label></th>
										<td>
											<div class="form-row">
												<input class="form-control width-50per" type="text" name="name" id="name_label" value="" placeholder="이름을 입력하세요">
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
                                               <input type="text" id="id_label" placeholder="아이디를 입력하세요" />
											   <button type="button" class="btn gray1">중복확인</button>
                                            </div>   
										</td>
									</tr>
									<tr>
										<th><label for="pw_label" class="req">비밀번호</label></th>
										<td>
											<div class="form-row">
                                                <input type="password" id="pw_label" placeholder="비밀번호 입력" />
                                            </div> 
											<small class="note">* 비밀번호는 최소 8자리, 특수문자+숫자+영문 조합입니다.</small>       
										</td>
									</tr>
									<tr>
										<th><label for="pw_label2" class="req">비밀번호 변경</label></th>
										<td>
											<div class="form-inline">
                                                <input type="password" id="pw_label2" placeholder="비밀번호 입력" />
												<small class="note2">! 정보변경 비밀번호 확인</small>
                                            </div>       
										</td>
									</tr>
									<tr>
										<th><label for="error_label">에러 input</label></th>
										<td>
											<div class="form-inline">
                                                <input type="text" id="error_label" class="input_error" />
												<small class="note2">! 다시 입력해주세요</small>
                                            </div>       
										</td>
									</tr>
									<tr>
										<th><label for="mobileLabel" class="req">휴대폰 번호</label></th>
										<td>
											<div class="form-row">
                                                <!-- 번호 -->    
												<div class="num_input">                                                           
													<select name="" id="mobileLabel" class="compact">
														<option value="010">010</option>
														<option value="011">011</option>
														<option value="016">016</option>
														<option value="017">017</option>
														<option value="018">018</option>
														<option value="019">019</option>
													</select>                                        
													<span class="txt-sort">-</span>
													<input type="text" maxlength="4" class="compact" />				
													<span class="txt-sort">-</span>											
													<input type="text" maxlength="4" class="compact" />												
												</div>

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
												<label class="datepicker width-10em"><input type="text" placeholder="시작일" id="datepicker1"></label>
												<span class="txt-sort">~</span>
												<label class="datepicker width-10em"><input type="text" placeholder="종료일"  id="datepicker2"></label>						
											</div>
											<script>
												$.datepicker.setDefaults({
													dateFormat: 'yy-mm-dd',
													prevText: '이전 달',
													nextText: '다음 달',
													monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
													monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
													dayNames: ['일', '월', '화', '수', '목', '금', '토'],
													dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
													dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
													showMonthAfterYear: true,
													yearSuffix: '년'
												});
			
												$('#datepicker1').datepicker();
												$('#datepicker2').datepicker();
											</script>

										</td>
									</tr>
									<tr>
										<th><label for="noticeLabel">기간 </label></th>
										<td>
											<div class="form-inline">
												<label class="datepicker width-10em"><input type="text" placeholder="시작일" id="datepicker11"></label>
												<div class="input_btn">
													<input class="form-control sm" type="text" maxlength="2"><label>시</label>
												</div>
												<div class="input_btn">
													<input class="form-control sm" type="text" maxlength="2"><label>분</label>
												</div><span class="ruffle_sign">~</span>
											</div>
											<div class="form-inline">
												<label class="datepicker width-10em"><input type="text" placeholder="종료일"  id="datepicker21"></label>
												<div class="input_btn">
													<input class="form-control sm" type="text" maxlength="2"><label>시</label>
												</div>
												<div class="input_btn">
													<input class="form-control sm" type="text" maxlength="2"><label>분</label>
												</div>
											</div>

											<script>
												$.datepicker.setDefaults({
													dateFormat: 'yy-mm-dd',
													prevText: '이전 달',
													nextText: '다음 달',
													monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
													monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
													dayNames: ['일', '월', '화', '수', '목', '금', '토'],
													dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
													dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
													showMonthAfterYear: true,
													yearSuffix: '년'
												});
			
												$('#datepicker11').datepicker();
												$('#datepicker21').datepicker();
											</script>
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
										<th><label for="toggle_label">공개여부</label></th>
										<td>										
											<div class="form-row">
												<div class="toggle-container">
													<input type="checkbox" id="toggle_label" class="toggle-checkbox">
													<label for="toggle_label" class="toggle-label"></label>
												</div>
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
										<th><label for="select_fullLabel">제목</label></th>
										<td>
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="name" id="name_label" value="" placeholder="input size full">
											</div>   											
										</td>
									</tr>									
									<tr>
										<th><label for="contTextarea">내용</label></th>
										<td data-th="입력">
											<!--일반-->
											<label class="width-100per"><textarea rows="10" class="resize-none"></textarea></label>
											<!--//일반-->

											<!--에디터-->
											<div id="summernote"></div>
											<script src="/webdoc/dm_assets/summernote/lang/summernote-ko-KR.js"></script>
											<script>
												$('#summernote').summernote({
													lang: 'ko-KR',
													placeholder: '입력하세요', 
													height: 300,
													fontNames: ['맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체','Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', 'Verdana','Tahoma','Times New Roamn'],
													toolbar: [
														['fontname', ['fontname']],
														['fontsize', ['fontsize']],
														['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
														['color', ['forecolor','backcolor']],
														['table', ['table']],
														['para', ['ul', 'ol', 'paragraph']],
														['height', ['height']],
														['insert',['picture','link','video']],
														['view', ['codeview','fullscreen']]
													],
												});
											</script>
											<!--//에디터-->
								
										</section>
										<!--//섹션 에디터-->
										</td>
									</tr>
									<tr>
										<th><label for="attchFile">첨부파일</label></th>
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

												<!--추가 가능한지 확인_개발 불가면 태그 삭제-->
												<div class="option-wrap">
													<div>
														<b aria-label="업로드할 파일 개수" class="fcPrimary">2개</b>
														<!--
														<b aria-label="업로드 가능한 전체 파일 개수">/ 5개</b>
														-->
													</div>
													<div class="btn-wrap">
														<button type="button" class="btn"><i class="xi-close"></i>전체 삭제</button>
													</div>
												</div>
												<!--//추가 가능한지 확인_개발 불가면 태그 삭제-->

												<!--파일 목록-->
												<ul id="atchfiles">
													<li id="attachIdx_1">
														<p>2024-1 전체 시간표.pdf<small>20.86 KB</small></p><span aria-label="삭제" href="#_none"></span>
													</li>
													<li id="attachIdx_2">
														<p>login-out-bg1.png<small>2.78 MB</small></p><span aria-label="삭제" href="#_none"></span>
													</li>
												</ul>
												<!--//파일 목록-->

											</div>
											<!--//업로드-->
												

											
										</td>
									</tr>
								</tbody>

							</table>
						</div>
						<!--//table-type2-->

						<div class="btns">
                            <button type="button" class="btn type1">취소</button>
                            <button type="button" class="btn type2">저장</button>
                        </div>
            
                    </div>  
					 

                </div>
            </div>
            <!-- //content -->

            
            <!-- common footer -->
            <%@ include file="../dm_inc/home_footer.jsp" %>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

