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
							<h2 class="page-title">학과/부서 관리</h2>
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

						<!-- 목록/등록/수정 -->
						<div class="board_top">
							<h3 class="board-title">목록/등록/수정</h3>
							<div class="right-area">
								<button type="button" class="btn type2">학사연동 가져오기</button>
								<button type="button" class="btn type1">저장</button>
							</div>
						</div>

						<div class="table-wrap">
							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th class="req">기관</th>
										<td data-th="기관">
											<div class="form-inline">
												<select class="form-select" id="univ_label" name="univ_label" required="true" disabled>
													<option value="">대학원</option>
												</select>
											</div>
										</td>
										<th class="req">상위 학과/부서 코드</th>
										<td data-th="상위 학과/부서 코드">
											<div class="form-inline">
												<select class="form-select" id="univ_label" name="univ_label" required="true">
													<option value="">ROOT</option>
												</select>
											</div>
										</td>
									</tr>
									<tr>
										<th class="req">학과/부서 코드</th>
										<td data-th="학과/부서 코드">
											<div class="form-inline">
												<input class="form-control" type="text" id="te_id_label"/>
											</div>
										</td>
										<th class="req">학교/부서명</th>
										<td data-th="학과/부서명">
											<div class="form-inline">
												<input class="form-control" type="text" id="te_id_label"/>
											</div>
										</td>
									</tr>
									<tr>
										<th class="req">학과/부서명(EN)</th>
										<td data-th="학과/부서명(EN)" colspan="3">
											<div class="form-inline">
												<input class="form-control" type="text" id="te_id_label"/>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

                        <div class="board_top in_table">
							<select class="form-select">
								<option value="메시지 불러오기">대학원</option>                                    
							</select> 
							<div class="search-typeC">
								<input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="코드/학과명/부서명 검색">
								<button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
							</div>

							<div class="right-area">
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
							</div>
                        </div>
						<div class="table-wrap">
							<table class="table-type2">
								<colgroup>
									<col width="5%"/>
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col>
									<col>
									<col width="10%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">기관</th>
										<th scope="col">상위 학과/부서 코드</th>
										<th scope="col">학과/부서 코드</th>
										<th scope="col">학과/부서명(KR)</th>
										<th scope="col">학과/부서명(EN)</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td data-th="번호">74</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">73</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">72</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">71</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">70</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">69</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">68</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">67</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">66</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
									<tr>
										<td data-th="번호">65</td>
										<td data-th="기관">대학원</td>
										<td data-th="상위 학과/부서 코드">ROOT</td>
										<td data-th="학과/부서 코드">RT001003</td>
										<td data-th="학과/부서명(KR)">문예창작콘텐츠학과</td>
										<td data-th="학과/부서명(EN)">-</td>
										<td data-th="관리">
											<button class="btn basic small">수정</button>
											<button class="btn basic small">삭제</button>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="board_foot">
							<div class="page_info">
								<span class="total_page">전체 <b>12</b>건</span>
								<span class="current_page">현재 페이지 <strong>1</strong>/10</span>
							</div>
							<div class="board_pager">
								<span class="inner">
									<button class="page" type="button" role="button" aria-label="First Page" title="처음 페이지" data-page="1" disabled=""><i class="icon-page-first"></i></button>
									<button class="page" type="button" role="button" aria-label="Prev Page" title="이전 페이지" data-page="1" disabled=""><i class="icon-page-prev"></i></button>
									<span class="pages">
										<button class="page active" type="button" role="button" aria-label="Page 1" title="1 페이지" data-page="1">1</button>
										<button class="page" type="button" role="button" aria-label="Page 2" title="2 페이지" data-page="2">2</button>
										<button class="page" type="button" role="button" aria-label="Page 3" title="3 페이지" data-page="3">3</button>
									</span>
									<button class="page" type="button" role="button" aria-label="Next Page" title="다음 페이지" data-page="2"><i class="icon-page-next"></i></button>
									<button class="page" type="button" role="button" aria-label="Last Page" title="마지막 페이지" data-page="3"><i class="icon-page-last"></i></button>
								</span>
							</div>
						</div><!-- //목록/등록/수정 -->

					</div>
				</div>

			<!-- modal popup 보여주기 버튼(개발시 삭제) -->
			<div class="modal-btn-box">
				<button type="button" class="btn modal__btn" id="btn-modal1">학사연동 가져오기</button>
			</div><!-- //modal popup 보여주기 버튼(개발시 삭제) -->


			</div><!-- //content -->
        </main><!-- //admin-->



        <!-- Modal1 참여관리/관리이력 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
					
					<div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col>
                                <col style="width:20%">
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>대상</th>
									<th>관리</th>
									<th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="대상" class="t_left">
                                        학과/부서 정보를 연동합니다.
                                    </td>
    								<td data-th="관리">
										<button class="btn basic small">
											학과/부서 정보
										</button>
									</td>
									<td data-th="상태">
										<i class="icon-svg-yes fcBlue" aria-hidden="true" aria-label="YES"></i>
									</td>
                                </tr>
                                <tr>
                                    <td data-th="대상" class="t_left">
                                        학과/부서 정보를 연동합니다.
                                    </td>
    								<td data-th="관리">
										<button class="btn basic small">
											학과/부서 정보
										</button>
									</td>
									<td data-th="상태">
										<i class="icon-svg-no fcRed" aria-hidden="true" aria-label="NO"></i>
									</td>
								</tr>
                            </tbody>
                        </table>						
                    </div>
					<!-- 연동 성공 메시지 -->
					<div class="msg-box basic">
						<ul>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
							<li><b>2026.11.22(15:59:20)</b> 학과/부서 정보를 연동합니다.</li>
						</ul>
					</div>
					<!-- //연동 성공 메시지 -->

					<!-- 연동 실패 메시지 -->
                    <div class="error_txt mt10">
<pre>2026.11.22(16:37:33)
[실패] 연동에 실패하였습니다. 
I/O error on POST request for "http://localhost:8384/haksa/sync/crs": Connect to localhost:8384 [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: Connection refused: connect; nested exception is org.apache.http.conn.HttpHostConnectException: Connect to localhost:8384 [localhost/127.0.0.1, localhost/0:0:0:0:0:0:0:1] failed: Connection refused: connect
</pre>
                    </div>
					<!-- //연동 실패 메시지 -->


                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 참여관리/관리이력 -->

        <script>
            $(function() {
                // 학사연동 가져오기
                $('#btn-modal1').on('click', function() {
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "학사연동 가져오기",
                        width: 800,
                        height: 500,
                        html: $content
                    });
                });
            });
        </script>


    </div>

</body>
</html>
