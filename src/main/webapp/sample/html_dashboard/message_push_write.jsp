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

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title"><span>메시지함</span>PUSH</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>메시지함</li>
                                    <li><span class="current">PUSH</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">PUSH 발신하기</h3>                            
                            <div class="right-area">                               
                                <select class="form-select">
                                    <option value="메시지 불러오기">메시지 불러오기</option>                                    
                                </select> 
                                <select class="form-select">
                                    <option value="템플릿에 저장">템플릿에 저장</option>                                    
                                </select>                                 
                            </div>                         
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
										<th><label for="univ_label" class="req">학사년도/학기</label></th>
										<td>
											<div class="form-inline">
                                                <select class="form-select" id="selectDate1">
                                                    <option value="2025년">2025년</option>
                                                    <option value="2024년">2024년</option>    
                                                </select>
                                                <select class="form-select" id="selectDate2">
                                                    <option value="2학기">2학기</option>
                                                    <option value="1학기">1학기</option>        
                                                </select>												
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="univ_label">운영과목</label></th>
										<td>
											<div class="form-inline">
                                                <select class="form-select" id="selectCourse">
                                                    <option value="대학원">대학원</option> 
                                                    <option value="평생교육">평생교육</option>                                       
                                                </select>
                                                <select class="form-select" id="selectDepartment">
                                                    <option value="학과">학과</option>                                                                    
                                                </select>
                                                <select class="form-select width-50per" id="selectSubject">
                                                    <option value="">운영과목</option>
                                                    <option value="운영과목1">운영과목1</option>
                                                    <option value="운영과목2">운영과목2</option>   
                                                </select>       											
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="name_label" class="req">제목</label></th>
										<td>
                                            <div class="form-row">
												<input class="form-control width-100per" type="text" name="name" id="name_label" value="" required="true">
											</div>											  											
										</td>
									</tr>									
									<tr>
										<th><label for="contTextarea" class="req">내용</label></th>
										<td data-th="입력">
											<textarea rows="4" class="form-control width-100per"  maxLenCheck="byte,2000,true,true"></textarea>                                          
										</td>
									</tr>
                                    <tr>
										<th><label for="sendDateTime" class="req">발신일시</label></th>
										<td>
											<div class="form-inline">												
												<div class="date_area mr10">
													<input id="date1" type="text" name="date1" placeholder="시작일" class="datepicker" value="20260210">
											        <input id="time1" type="text" name="time1" placeholder="시작시간" class="timepicker" value="1030">											
												</div>
                                                <span class="custom-input">
													<input type="checkbox" name="reserveSend" id="reserveSend">
													<label for="reserveSend">예약 발신</label>
												</span>						
											</div>
																			
										</td>
									</tr>	
                                    <tr>
										<th><label for="sendUserName" class="req">발신자</label></th>
										<td>
                                            <div class="form-inline">												
												<input class="form-control mr10" type="text" id="sendUserName" value="홍길동" />
                                                <span class="custom-input">
													<input type="checkbox" name="sendUserCk" id="sendUserCk" checked>
													<label for="sendUserCk">본인 이름 선택</label>
												</span>						
											</div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="senderPhone" class="req">발신자 번호</label></th>
										<td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="senderPhoneType" id="senderDept" value="DEPT" checked>
                                                    <label for="senderDept">학과 대표번호</label>
                                                </span>

                                                <span class="custom-input ml5">
                                                    <input type="radio" name="senderPhoneType" id="senderManager" value="MANAGER">
                                                    <label for="senderManager">담당자 번호</label>
                                                </span>

                                                <input type="text" inputmask="phone" placeholder="전화번호 입력">                                              
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>    

                        <div class="btns">
                            <button type="button" class="btn type1">발신</button>
                            <button type="button" class="btn type2">발신목록</button>
                        </div>
                       
                      
                        <div class="board_top">
                            <h4 class="sub-title">과목 정보</h4>                         
                            <div class="right-area">
                                <button type="button" class="btn basic">엑셀양식 다운로드</button>
                                <button type="button" class="btn basic">엑셀 업로드</button>
                                <button type="button" class="btn type2">추가</button>
                                <button type="button" class="btn type2">삭제</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>                         
                        </div>                                              
                        
                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:5%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:10%">
                                    <col style="width:12%">
                                    <col style="width:14%">
                                    <col style="width:5%">
                                    <col style="">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>수신자</th>
                                        <th>학번</th>
                                        <th>대표 ID</th>
                                        <th>휴대폰번호</th>
                                        <th>이메일</th>
                                        <th>발송</th>	
                                        <th>결과메시지</th>                                       			
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="수신자">홍길동</td>
                                        <td data-th="학번">2412587459</td>
                                        <td data-th="대표 ID">testid001</td>
                                        <td data-th="휴대폰번호">010-2589-6254</td>
                                        <td data-th="이메일">test01@naver.com</td>
                                        <td data-th="발송">N</td>                                    
                                        <td data-th="결과메시지">-</td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                        </td>
                                        <td data-th="번호">90</td>
                                        <td data-th="수신자">홍길동</td>
                                        <td data-th="학번">2412587459</td>
                                        <td data-th="대표 ID">testid001</td>
                                        <td data-th="휴대폰번호">010-2589-6254</td>
                                        <td data-th="이메일">test01@naver.com</td>
                                        <td data-th="발송">N</td>                                    
                                        <td data-th="결과메시지">-</td>
                                    </tr>
                                </tbody>
                            
                            </table>
                        </div>
                        <!--//table-type2-->

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

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" data-modal-open="modal1">예상 발신 비용 금액</button>
                    <button type="button" class="btn modal__btn" data-modal-open="modal2">메시지 불러오기</button>
                    <button type="button" class="btn modal__btn" data-modal-open="modal3">발신 예약 취소</button>
                    <button type="button" class="btn modal__btn" data-modal-open="modal4">받는 사람 추가</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->

            </div>
            <!-- //content -->


            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-md" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">예상 발신 비용 금액</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                   
                    <div class="msg-box">                                
                        <p class="txt"><i class="icon-svg-warning" aria-hidden="true"></i>예상 발신 비용 금액입니다. 참고하세요</p>                                                             
                    </div>                    
                    
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>알림 구분</label></li>
                            <li>PUSH</li>                          
                        </ul>
                        <ul class="list">
                            <li class="head"><label>단가/건</label></li>
                            <li>0원/건</li>                            
                        </ul>                        
                        <ul class="list">
                            <li class="head"><label>발송 건수</label></li>
                            <li>50건</li>                    
                        </ul>
                        <ul class="list">
                            <li class="head"><label>예상발신비용</label></li>
                            <li>0원 * 50건 = 0원</li>                          
                        </ul>  
                        <ul class="list">
                            <li class="head"><label>발신자</label></li>
                            <li>홍길동/prof001</li>                          
                        </ul>                                    
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">발신</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">메시지 불러오기</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                    <div class="board_top">
                        <h3 class="board-title">개인 문구</h3>
                        <div class="right-area">
                            <!-- Tab btn -->
                            <div class="tab_btn">
                                <a href="#tab01" class="current">개인 문구</a>
                                <a href="#tab02">학과/부서 문구</a>                                                                      
                            </div>                                                                            
                        </div>
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
                    <div class="modal_btns mt10">
                        <button type="button" class="btn type1">사용하기</button>
                    </div>                   

                    <div class="board_top">
                        <h4 class="sub-title">문구 목록</h4>  
                        <div class="right-area">
                            <!-- search small -->
                            <div class="search-typeC">
                                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="제목/내용 검색">
                                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                            </div>
                            <button type="button" class="btn basic">전체선택</button>
                            <button type="button" class="btn basic">삭제</button>
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
                               
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 3 -->
        <div class="modal-overlay" id="modal3" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-md" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">발신 예약 취소</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                   
                    <div class="msg-box">                                
                        <p class="txt">
                            <i class="icon-svg-warning" aria-hidden="true"></i>
                            <span>
                                PUSH 발송 예약을 취소하시겠습니까?<br>
                                <strong class="fcRed">※ 취소한 내역은 복구할 수 없습니다.</strong>
                            </span>
                        </p>                                                             
                    </div>                    
                    
                    <div class="table_list">
                        <ul class="list">
                            <li class="head"><label>제목</label></li>
                            <li>알림 내용의 제목입니다.</li>                          
                        </ul>
                        <ul class="list">
                            <li class="head"><label>발신예약일시</label></li>
                            <li>2026.09.01 15:32</li>                            
                        </ul>                        
                        <ul class="list">
                            <li class="head"><label>수신자</label></li>
                            <li>50</li>                    
                        </ul>
                        <ul class="list">
                            <li class="head"><label>예약취소자</label></li>
                            <li>홍교수 (2190000)</li>                          
                        </ul>  
                        <ul class="list">
                            <li class="head"><label>예약취소일시</label></li>
                            <li>2026.08.25 12:50</li>                          
                        </ul>                                    
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">취소하기</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 4 -->
        <div class="modal-overlay" id="modal4" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">받는 사람 추가</h2> 
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body"> 
                   <div class="board_top">
                        <select class="form-select" id="selectDate1">
                            <option value="사용자 구분">사용자 구분</option>
                            <option value="전체">전체</option>
                        </select>
                        <select class="form-select" id="selectDate2">
                            <option value="기관">기관</option>                                        
                        </select>                                   
                        <select class="form-select wide" id="selectMajor">
                            <option value="">학과/부서선택</option>
                            <option value="운영과목1">국어국문학과</option>
                            <option value="운영과목2">회계트랙</option>
                        </select>
                        <select class="form-select wide" id="selectSubject">
                            <option value="">과목선택</option>
                            <option value="과목1">과목1</option>
                            <option value="과목2">과목2</option>
                        </select>
                        <!-- search small -->
                        <div class="search-typeC">
                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름/아이디/사번 입력">
                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                        </div>                          
                    </div>

                    <!--table-type2-->
                    <div class="table-wrap">
                        <table class="table-type2">
                            <colgroup>
                                <col style="width:3%">
                                <col style="width:5%">
                                <col style="width:12%">
                                <col style="width:14%">
                                <col style="width:10%">
                                <col style="width:16%">
                                <col style="width:16%">
                                <col style="">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>
                                        <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                    </th>
                                    <th>번호</th>
                                    <th>사용자구분</th>                                        
                                    <th>학번/사번</th>
                                    <th>이름</th>
                                    <th>학과/부서</th>
                                    <th>연락처</th>
                                    <th>대표이메일</th>                                                        			
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">90</td>
                                    <td data-th="사용자구분">교직원</td>                                        
                                    <td data-th="학번/사번">2412587459</td>
                                    <td data-th="이름">홍길동</td>
                                    <td data-th="학과/부서">정보운영팀</td>                                          
                                    <td data-th="연락처">02-2290-0114</td>
                                    <td data-th="대표이메일">test01@naver.com</td>                                        
                                </tr>
                                <tr>
                                    <td data-th="선택">
                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                    </td>
                                    <td data-th="번호">90</td>
                                    <td data-th="사용자구분">학생</td>                                        
                                    <td data-th="학번/사번">20261024457</td>
                                    <td data-th="이름">홍길동</td>
                                    <td data-th="학과/부서">상담심리학과</td>                                          
                                    <td data-th="연락처">010-2589-6254</td>
                                    <td data-th="대표이메일">20261024457@knou.ac.kr</td>                                        
                                </tr>
                            </tbody>                            
                        </table>
                    </div>
                    <!--//table-type2-->
                               
                                    
                    <div class="modal_btns">
                        <button type="button" class="btn type1">추가하기</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>

