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
                            <h2 class="page-title"><span>메시지발송</span>메시지템플릿</h2>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">개인 문구</h3>
                            <div class="right-area">
                                <!-- Tab btn -->
                                <div class="tab_btn">
                                    <a href="#tab01" class="current">개인 문구</a>
                                    <a href="#tab02">학과/부서 문구</a>
                                </div>
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="제목/내용 검색">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                                <button type="button" class="btn basic">삭제</button>
                                <button type="button" class="btn basic">전체삭제</button>
                            </div>
                        </div>

                        <div class="message_list">
                            <ul class="message_card">
                                <li>
                                    <a href="#0" class="card_item active"><!-- 클릭시 active 추가 -->
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 과제 제출 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요.
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 중간고사 기간이 시작되었습니다.
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                중간고사 기간이 시작되었습니다. <br>
                                                2026.04.20 09:00 ~ 2026.05.10 23:59 까지 입니다. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 새학기 시작 안내
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                새로운 학기가 시작되었습니다. 변경된 일정 및 안내사항을 확인해 주세요.
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 1주차 강의자료 업로드
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                1주차 강의자료 업로드 되었습니다. 다운로드 받아주세요.
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 과제 제출 안내 메시지
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요.
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 중간고사 기간이 시작되었습니다.
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                중간고사 기간이 시작되었습니다. <br>
                                                2026.04.20 09:00 ~ 2026.05.10 23:59 까지 입니다. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>
                                                자세한 내용은 과목 공지사항을 확인해주세요. <br>
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 새학기 시작 안내
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                새로운 학기가 시작되었습니다. 변경된 일정 및 안내사항을 확인해 주세요.
                                            </p>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#0" class="card_item">
                                        <div class="item_header">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                            <div class="msg_tit">
                                                 1주차 강의자료 업로드
                                            </div>
                                        </div>
                                        <div class="extra">
                                            <p class="desc">
                                                1주차 강의자료 업로드 되었습니다. 다운로드 받아주세요.
                                            </p>
                                        </div>
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <%-- 테이블의 페이징 정보 생성할때 아래 내용 참조하여 작업하고 아래와 같은 HTML 코드를 직접 만들지 않는다.
                        	1) UiTable() 함수를 사용하여 테이블 생성할경우는 해당 프로그램에서 페이지 정보 생성하도록 한다.
                        	2) Controller에서 페이지정보(PageInfo) 객체를 받아을 경우 <uiex:paging> 태그를 사용하여 생성한다.
                        	   <uiex:paging pageInfo="${pageInfo}" pageFunc="listPaging"/>
                        --%>
                        <!-- board foot -->
						<div class="board_foot simple">
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
						</div>

                        <h4 class="sub-title">개인 문구 등록/수정</h4>
                        <!--table-type-->
						<div class="table-wrap">
							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
                                        <th><label for="haksa_label">구분</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="emailRecv" id="emailRecvY" value="Y" checked="">
                                                    <label for="emailRecvY">개인 문구</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="select_fullLabel">제목</label></th>
										<td>
											<div class="form-row">
												<input class="form-control width-100per" type="text" name="name" id="name_label" value="" placeholder="제목 입력">
											</div>
										</td>
									</tr>
                                    <tr>
										<th><label for="contTextarea">내용</label></th>
										<td data-th="입력">
											<label class="width-100per"><textarea rows="4" class="form-control resize-none"></textarea></label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btns">
                            <button type="button" class="btn type1">저장</button>
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

