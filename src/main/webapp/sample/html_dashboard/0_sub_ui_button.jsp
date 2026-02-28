<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
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
                            <h2 class="page-title">버튼모음</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>게시물</li>
                                    <li><span class="current">현재페이지</span></li>
                                </ul>
                            </div>
                        </div>

                        <h4 class="sub-title">등록페이지 _ 버튼 모음</h4>
                        <!--table-type-->
						<div class="table-wrap">
							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
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
										<th><label for="id_label" class="req">과정(테넌시) ID</label></th>
										<td>
											<div class="form-inline">
                                               <input class="form-control" type="text" id="te_id_label" placeholder="과정(테넌시) ID 입력" />
											   <button type="button" class="btn gray1">중복확인</button>
                                            </div>
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
						<!--//table-type-->

                        <br><br><br>

                        <h4 class="sub-title ">등록, 상세페이지 _ 하단 중앙 버튼</h4>
						<div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>

                        <br><br><br>

                        <h4 class="sub-title ">검색박스 _ 검색 버튼</h4>
                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectDate1">
                                        <option value="2025년">2025년</option>
                                        <option value="2024년">2024년</option>
                                    </select>
                                    <select class="form-select" id="selectDate2">
                                        <option value="2학기">2학기</option>
                                        <option value="1학기">1학기</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색 조건</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="selectSearch1">
                                        <option value="발신자">발신자</option>
                                        <option value="발신자번호">발신자번호</option>
                                        <option value="제목">제목</option>
                                        <option value="내용">내용</option>
                                    </select>
                                    <input class="form-control wide" type="text" name="" id="inputSearch1" value="" placeholder="검색어를 입력해주세요.">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search">검색</button>
                            </div>
                        </div>

                        <br><br><br>
                        <h4 class="sub-title">타이틀 + 오른쪽 버튼 (기본유형)</h4>

                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2">발신하기</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        <br><br><br>
                        <h4 class="sub-title">타이틀 + 오른쪽 탭버튼 + 버튼모음</h4>
                        
                        <div class="board_top">
                            <h3 class="board-title">PUSH 수신 목록</h3>
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab01" class="current">수신목록</a>
                                    <a href="#tab02">발신목록</a>
                                </div>
                                <button type="button" class="btn basic icon"><i class="xi-refresh"></i></button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                                <button type="button" class="btn type2">발신하기</button>
                            </div>
                        </div>
                        <div id="tab01" class="tab-content">탭1 내용</div>
                        <div id="tab02" class="tab-content" style="display:none;">탭2 내용</div>

                        <br><br><br>
                        <h4 class="sub-title">타이틀 + 오른쪽 탭버튼 + 정렬모음</h4>

                        <div class="board_top">
                            <h3 class="board-title">과목공지</h3>
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab03" class="current">과목공지</a>
                                    <a href="#tab04">전체공지</a>
                                </div>
                                <button type="button" class="btn type2">글쓰기</button>
                                <a href="#0" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>
                        </div>

                        

                        <br><br><br>

                        <h4 class="sub-title">아이콘 타이틀 + 셀렉트 + 리스트 타입 버튼</h4>
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">강의목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">주차 접음</button>
                                <select class="form-select">
                                    <option value="전체 주차">전체 주차</option>
                                    <option value="1주차">1주차</option>
                                    <option value="2주차">2주차</option>
                                    <option value="3주차">3주차</option>
                                    <option value="4주차">4주차</option>
                                    <option value="5주차">5주차</option>
                                </select>
                                <a href="#0" class="btn_list_type on" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a> <!-- 버튼 선택시 on 클래스 추가 -->
                                <a href="#0" class="btn_list_type" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                            </div>
                        </div>

                        <br><br><br>

                        <h4 class="sub-title">테이블 안에 작은 버튼</h4>
                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:7%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:10%">
                                    <col style="width:4%">
                                    <col style="width:7%">
                                    <col style="width:11%">
                                    <col style="">
                                    <col style="width:11%">
                                    <col style="width:6%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>년도</th>
                                        <th>학기</th>
                                        <th>과정</th>
                                        <th>운영과목</th>
                                        <th>반</th>
                                        <th>발신자</th>
                                        <th>발신자번호</th>
                                        <th>제목</th>
                                        <th>발신일시</th>
                                        <th>읽음</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="년도">2025년</td>
                                        <td data-th="학기">2</td>
                                        <td data-th="과정">대학원</td>
                                        <td data-th="운영과목">일본어</td>
                                        <td data-th="반">1</td>
                                        <td data-th="발신자">홍길동</td>
                                        <td data-th="발신자번호">010-2589-6254</td>
                                        <td data-th="제목" class="t_left">
                                            <a href="#0" class="title text-truncate">알림 제목입니다.</a>
                                        </td>
                                        <td data-th="발신일시">2025.08.04 15:32</td>
                                        <td data-th="읽음"><button class="btn basic small">상세</button></td>
                                    </tr>
                                </tbody>

                            </table>
                        </div>
                        <!--//table-type-->

                        <!-- board foot -->
                        <div class="board_foot">
                            <div class="page_info">
                                <span class="total_page">전체 <b>12</b>건</span>
                                <span class="current_page">현재 페이지 <strong>1</strong>/10</span>
                            </div>

                            <div class="board_pager">
                                <span class="inner">
                                    <a href="" class="page_first" title="첫페이지"><i class="icon-svg-arrow01"></i><span class="sr_only">첫페이지</span></a>
                                    <a href="" class="page_prev" title="이전페이지"><i class="icon-svg-arrow02"></i><span class="sr_only">이전페이지</span></a>
                                    <a href="" class="page_now" title="1페이지"><strong>1</strong></a>
                                    <a href="" class="page_none" title="2페이지">2</a>
                                    <a href="" class="page_none" title="3페이지">3</a>
                                    <a href="" class="page_none" title="4페이지">4</a>
                                    <a href="" class="page_none" title="5페이지">5</a>
                                    <a href="" class="page_next" title="다음페이지"><i class="icon-svg-arrow03"></i><span class="sr_only">다음페이지</span></a>
                                    <a href="" class="page_last" title="마지막페이지"><i class="icon-svg-arrow04"></i><span class="sr_only">마지막페이지</span></a>
                                </span>
                            </div>
                        </div>


                    </div>


                </div>
            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

