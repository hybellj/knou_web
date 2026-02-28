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
        <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/home_gnb_prof.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <%@ include file="/WEB-INF/jsp/common_new/home_page_tab.jsp" %>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>메시지함</span>PUSH</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>메시지함</li>
                                    <li><span class="current">메시지템플릿</span></li>
                                </ul>
                            </div>
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


            <!-- common footer -->
            <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>

