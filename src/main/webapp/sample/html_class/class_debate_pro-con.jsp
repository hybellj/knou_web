<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">        
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>

    <script src="../../webdoc/uilib/chart/chart4.min.js"></script>
    <script src="../../webdoc/uilib/chart/chart-utils.min.js"></script>
    <script src="../../webdoc/uilib/chart/chartjs-plugin-datalabels.min.js"></script>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="../common/class_header.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="../common/class_gnb_prof.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="class_sub_top">                    
                    <div class="btn-wrap">
                        <div class="first">
                            <select class="form-select">
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                            <select class="form-select wide">
                                <option value="">강의실 바로가기</option>
                                <option value="2025년 2학기">2025년 2학기</option>
                                <option value="2025년 1학기">2025년 1학기</option>
                            </select>
                        </div>
                        <div class="sec">
                            <button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
                            <button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
                            <button type="button" class="btn type2"><i class="xi-log-out"></i>강의실나가기</button>
                        </div>
                    </div>
                </div>
                
                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <div class="segment class-area sub">
                        <div class="class_info">
                            <div class="class_tit">
                                <p class="labels">
                                    <label class="label uniA">대학원</label>
                                </p>
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                            </div>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>강의실</li>
                                    <li><span class="current">토론</span></li>
                                </ul>
                            </div>                            
                        </div>                        
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        
                        <div class="page-info">
                            <h2 class="page-title">토론</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li><a href="#">토론정보 및 평가</a></li>
                                <li class="select"><a href="#0">토론방</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">토론방</h3>
                            <div class="right-area">
                                <button type="button" class="btn type2 big">목록</button>  
                            </div>
                        </div>

                        <!--accordion-->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">                                      
                                        <a class="title" href="#">                                                                                            
                                            <div class="lecture_tit">                                                   
                                                <strong>토론 제목입니다.</strong>   
                                                <p class="desc">
                                                    <span>참여기간 :<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
                                                    <span>성적반영 :<strong>예</strong></span>
                                                    <span>성적공개 :<strong>아니오</strong></span>
                                                </p>                                                 
                                            </div>                                                                                        
                                            <i class="arrow xi-angle-down"></i>                                           
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <!-- ul.table-list > table-type5 으로 변경(2026-04-29) -->
                                        <table class="table-type5">
                                            <form id="form1" name="form1">
                                            <colgroup>
                                                <col width="15%">
                                                <col>
                                                <col width="15%">
                                                <col>
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th>토론내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
                                                            </textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>참여기간</th>
                                                    <td colspan="3">2026.09.30 10:00 ~ 2026.10.09 22:00</td>
                                                </tr>
                                                <tr>
                                                    <th>성적반영</th>
                                                    <td>예</td>
                                                    <th>성적반영비율</th>
                                                    <td>25%</td>
                                                </tr>
                                                <tr>
                                                    <th>성적공개</th>
                                                    <td colspan="3">참여형<small class="note ml10">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small></td>
                                                </tr>
                                                <tr>
                                                    <th>파일 첨부</th>
                                                    <td colspan="3">
                                                        <div>
                                                            <a href="#" class="file_down">
                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                <span class="text">첨부파일명마우스오버 시.doc</span>
                                                                <span class="fileSize">(6KB)</span>
                                                            </a>
                                                        </div>
                                                        <div>
                                                            <a href="#" class="file_down">
                                                                <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                <span class="text">154873973477000.jpg</span>
                                                                <span class="fileSize">(6KB)</span>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>팀토론</th>
                                                    <td colspan="3">예<br>학습그룹 : 토론 학습그룹 002<br>학습그룹별 토론 설정 : 사용
                                                        <div class="table-wrap mt10">
                                                            <table class="table-type5 in_table">
                                                                <colgroup>
                                                                    <col class="width-5per">
                                                                    <col class="width-15per">
                                                                    <col>
                                                                </colgroup>
                                                                <tbody>                                                            
                                                                    <tr>
                                                                        <th rowspan="4" class="group-header"><label for="viewOption">1팀</label></th>
                                                                        <th><label>학습그룹 구성원</label></th>
                                                                        <td>
                                                                            홍팀장1 외 11명
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="sub_topic">부주제</label></th>
                                                                        <td>부주제 제목입니다.</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="contTextarea">내용</label></th>
                                                                        <td>
                                                                            <label class="width-100per"><textarea rows="4" class="form-control resize-none">내용입니다.

                                                                            </textarea></label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            <div class="add_file_list">                              
                                                                                <ul class="add_file">
                                                                                    <li>
                                                                                        <a href="#" class="file_down">
                                                                                            <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                                                            <span class="text">154873973477000.jpg</span>
                                                                                            <span class="fileSize">(6KB)</span>
                                                                                        </a>                                        
                                                                                    </li>
                                                                                </ul>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th rowspan="4" class="group-header"><label for="viewOption">2팀</label></th>
                                                                        <th><label>학습그룹 구성원</label></th>
                                                                        <td>
                                                                            홍팀장1 외 11명
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="sub_topic">부주제</label></th>
                                                                        <td>
                                                                            <div class="form-row">
                                                                                <input class="form-control width-100per" type="text" name="name" id="sub_topic" value="" placeholder="주제 입력" autocomplete="off">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="contTextarea">내용</label></th>
                                                                        <td>
                                                                            <label class="width-100per"><textarea rows="4" class="form-control resize-none"></textarea></label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th><label for="attchFile">첨부파일</label></th>
                                                                        <td>
                                                                            첨부파일
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>참여글 보기 옵션</th>
                                                    <td colspan="3">사용 안함</td>
                                                </tr>
                                                <tr>
                                                    <th>댓글 답변요청</th>
                                                    <td colspan="3">아니오</td>
                                                </tr>
                                                <tr>
                                                    <th>찬반 토론으로 설정</th>
                                                    <td colspan="3">
                                                        예<br>
                                                        찬반 비율 공개 : 예<br>
                                                        작성자 공개 : 예<br>
                                                        의견 글 복수 등록 : 아니오<br>
                                                        찬반 의견 변경가능 : 아니오
                                                    </td>
                                                </tr>

                                            </tbody>
                                            </form>
                                        </table>
                                        <!-- //ul.table-list > table-type5 으로 변경(2026-04-29) -->
                                    </div>
                                </li>   
                            </ul>
                        </div>
                        <!--//accordion-->


                        <div class="proCon_wrap">
                            <h4 class="sub-title">찬성/반대 현황</h4>


                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-10em" />
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>찬성/반대 의견</th>
                                            <td>
                                                <div class="form-inline mb10">
                                                    <span class="custom-input">
                                                        <input type="radio" name="scoreInputMode" id="scoreInputModeRegister" value="DEPT" checked>
                                                        <label for="scoreInputModeRegister">찬성</label>
                                                    </span>
                                                    <span class="custom-input ml5">
                                                        <input type="radio" name="scoreInputMode" id="scoreInputModeAdjust" value="MANAGER">
                                                        <label for="scoreInputModeAdjust">반대</label>
                                                    </span>
                                                </div>
                                                <div>
											<div class="form-row">
												<textarea class="form-control" style="width:100%;height:100px" maxLenCheck="byte,1000,true,false" required="true"></textarea>
											</div>
                                            <div class="text-align-right">
                                                <button type="button" class="btn type2 mt10">저장</button>
                                            </div>
                                        </div>
                                            </td>
                                        </tr>                                        
                                        <tr>
                                            <th>찬성</th>
                                            <td>
                                                <ul class="process-bar">
                                                    <li class="bar-blue" style="width:80%;">80%</li>
                                                    <li class="bar-grey" style="width:20%;"></li>
                                                </ul>                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>반대</th>
                                            <td>
                                                <ul class="process-bar">
                                                    <li class="bar-red" style="width:20%;">20%</li>
                                                    <li class="bar-grey" style="width:80%;"></li>
                                                </ul>                                                
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="answer">
                                <div class="title_area">
                                    <strong>교수 피드백</strong>
                                </div>
                                <div class="cont">
                                     <label class="width-100per"><textarea rows="5" class="form-control resize-none"></textarea></label>
                                     <div class="bottom_btn">
                                        <div class="right-area">
                                            <button type="button" class="btn type2">저장</button>
                                        </div>
                                     </div>
                                </div>
                            </div>


                            <div class="answer">
                                <div class="title_area">
                                    <strong>교수 피드백</strong>
                                </div>
                                <div class="cont">
                                    이 문제는 다른 문제에 비해서는 많이 어려운 편에 속하는 문제이니, 풀지 못했다고 해도 크게 상심하실 필요가 없습니다. <br>
                                    답변드린 내용 중 더 궁금하신 점 있으시다면 언제든 편하게 질문주세요! 감사합니다.
                                    <div class="bottom_btn">
                                        <div class="right-area">
                                            <button type="button" class="btn basic">수정</button>
                                            <button type="button" class="btn basic">삭제</button>
                                        </div>
                                     </div>
                                </div>
                            </div>

                        </div>
  


                        <!-- 댓글 : 찬성 의견 -->
                        <div class="Comment">
                            <div class="flex align-items-center justify-content-between mb10">
                                <h4 class="sub-title">찬성 의견
                                    <span class="total_txt fw-normal fs-16px">[ 총 <b class="fcBlue">35</b>명 ]</span>
                                </h4>
                                <!-- search small -->
                                <div class="search-typeC justify-content-right">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                            </div>
                            <div class="comment_list">
                                <ul>
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">홍길동</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>                                                
                                            <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>                                        
                                            <span class="btn_right cmtBtnGroup">
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item cmtHid">숨김</div>
                                                        <div class="item cmtUpt">수정</div>
                                                        <div class="item cmtDel">삭제</div>
                                                        <div class="item cmtWri">댓글</div>
                                                    </div>
                                                </div>
                                            </span>
                                            <div class="cmt_detail">
                                                <div>
                                                    <span class="textNum"><i class="xi-paper-o"></i>45</span>
                                                    <span class="comNum"><i class="xi-speech-o"></i>2</span>
                                                    <span class="fileName"><a href="#" download>홍길동 프로필 사진.jpg</a></span>
                                                </div>
                                                <button class="toggle_commentlist mlAuto">2개의 댓글이 있습니다.</button>
                                            </div>

                                        </div>
                                        <div class="recmt_form mt20">
                                            <fieldset>
                                                <legend class="sr_only">댓글등록</legend>
                                                <div class="memo">
                                                    <div class="simple_answer">
                                                        <span>간편 댓글</span>
                                                        <div class="answer_btn">
                                                            <a href="#0" class="current">수고했어요</a><!--간편답변 선택시 클래스추가-->
                                                            <a href="#0">고생하셨어요.</a>
                                                            <a href="#0">감사합니다.</a>
                                                        </div>
                                                    </div>
                                                    <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                                    <div class="bottom_btn">                                                    
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="" id="feedbackLabel">
                                                            <label for="feedbackLabel">답변을 요청합니다.</label>
                                                        </span>                                                   
                                                        <div class="right-area">                                                                      
                                                            <button type="button" class="btn type2">댓글 등록</button>
                                                        </div>
                                                    </div> 
                                                </div>
                                            </fieldset>
                                        </div>
                                        
                                        <ul class="re_comment_ul dpNone">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">나방송</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <span class="btn_right cmtBtnGroup">
                                                        <div class="dropdown">
                                                            <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                                <i class="xi-ellipsis-v"></i>
                                                            </button>
                                                            <div class="optionWrap option-wrap">
                                                                <div class="item cmtHid">숨김</div>
                                                                <div class="item cmtUpt">수정</div>
                                                                <div class="item cmtDel">삭제</div>
                                                                <div class="item cmtWri">댓글</div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>                                                    
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <span class="user_img"></span>
                                                        </div>                                                                                                               
                                                        <div>
                                                            <strong class="name">홍길동</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>                                                        
                                                    <span class="comment">동의합니다.</span>
                                                    <span class="btn_right cmtBtnGroup">
                                                        <div class="dropdown">
                                                            <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                                <i class="xi-ellipsis-v"></i>
                                                            </button>
                                                            <div class="optionWrap option-wrap">
                                                                <div class="item cmtHid">숨김</div>
                                                                <div class="item cmtUpt">수정</div>
                                                                <div class="item cmtDel">삭제</div>
                                                                <div class="item cmtWri">댓글</div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>                                                   
                                            </li>
                                        </ul>                                            
                                    </li>
                
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">나방송</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>
                                            <span class="comment">질문의 효과를 최대화 시키기 위해서는 올바른 질문을 하는 것이 중요 <span class="label s_c02">삭제됨</span></span>
                                            <span class="btn_right cmtBtnGroup">
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item cmtHid">숨김</div>
                                                        <div class="item cmtUpt">수정</div>
                                                        <div class="item cmtDel">삭제</div>
                                                        <div class="item cmtWri">댓글</div>
                                                    </div>
                                                </div>
                                            </span>
                                        </div>
                                    </li>
                                </ul>
                            </div>                            
                        </div>
                        
                        <!-- 댓글 : 반대 의견 -->
                        <div class="Comment">
                            <div class="flex align-items-center justify-content-between mb10">
                                <h4 class="sub-title">반대 의견
                                    <span class="total_txt fw-normal fs-16px">[ 총 <b class="fcBlue">15</b>명 ]</span>
                                </h4>
                                <!-- search small -->
                                <div class="search-typeC justify-content-right">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                            </div>

                            <div class="comment_list">
                                <ul>
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">홍길동</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>                                                
                                            <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>                                        
                                            <span class="btn_right cmtBtnGroup">
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item cmtHid">숨김</div>
                                                        <div class="item cmtUpt">수정</div>
                                                        <div class="item cmtDel">삭제</div>
                                                        <div class="item cmtWri">댓글</div>
                                                    </div>
                                                </div>
                                            </span>
                                            <div class="cmt_detail">
                                                <div>
                                                    <span class="textNum"><i class="xi-paper-o"></i>45</span>
                                                    <span class="comNum"><i class="xi-speech-o"></i>2</span>
                                                    <span class="fileName"><a href="#" download>홍길동 프로필 사진.jpg</a></span>
                                                </div>
                                                <button class="toggle_commentlist mlAuto">2개의 댓글이 있습니다.</button>
                                            </div>

                                        </div>
                                        <div class="recmt_form mt20">
                                            <fieldset>
                                                <legend class="sr_only">댓글등록</legend>
                                                <div class="memo">
                                                    <div class="simple_answer">
                                                        <span>간편 댓글</span>
                                                        <div class="answer_btn">
                                                            <a href="#0" class="current">수고했어요</a><!--간편답변 선택시 클래스추가-->
                                                            <a href="#0">고생하셨어요.</a>
                                                            <a href="#0">감사합니다.</a>
                                                        </div>
                                                    </div>
                                                    <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                                    <div class="bottom_btn">                                                    
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="" id="feedbackLabel">
                                                            <label for="feedbackLabel">답변을 요청합니다.</label>
                                                        </span>                                                   
                                                        <div class="right-area">                                                                      
                                                            <button type="button" class="btn type2">댓글 등록</button>
                                                        </div>
                                                    </div> 
                                                </div>
                                            </fieldset>
                                        </div>
                                        
                                        <ul class="re_comment_ul dpNone">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">나방송</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <span class="btn_right cmtBtnGroup">
                                                        <div class="dropdown">
                                                            <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                                <i class="xi-ellipsis-v"></i>
                                                            </button>
                                                            <div class="optionWrap option-wrap">
                                                                <div class="item cmtHid">숨김</div>
                                                                <div class="item cmtUpt">수정</div>
                                                                <div class="item cmtDel">삭제</div>
                                                                <div class="item cmtWri">댓글</div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>                                                    
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <span class="user_img"></span>
                                                        </div>                                                                                                               
                                                        <div>
                                                            <strong class="name">홍길동</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>                                                        
                                                    <span class="comment">동의합니다.</span>
                                                    <span class="btn_right cmtBtnGroup">
                                                        <div class="dropdown">
                                                            <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                                <i class="xi-ellipsis-v"></i>
                                                            </button>
                                                            <div class="optionWrap option-wrap">
                                                                <div class="item cmtHid">숨김</div>
                                                                <div class="item cmtUpt">수정</div>
                                                                <div class="item cmtDel">삭제</div>
                                                                <div class="item cmtWri">댓글</div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>                                                   
                                            </li>
                                        </ul>                                            
                                    </li>
                
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">나방송</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>
                                            <span class="comment">질문의 효과를 최대화 시키기 위해서는 올바른 질문을 하는 것이 중요 <span class="label s_c02">삭제됨</span></span>
                                            <span class="btn_right cmtBtnGroup">
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item cmtHid">숨김</div>
                                                        <div class="item cmtUpt">수정</div>
                                                        <div class="item cmtDel">삭제</div>
                                                        <div class="item cmtWri">댓글</div>
                                                    </div>
                                                </div>
                                            </span>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            
                        </div>
                        
                        <!-- 댓글 : 피드백 -->
                        <div class="Comment">
                            <div class="flex align-items-center justify-content-between mb10">
                                <h4 class="sub-title">피드백</h4>
                                <!-- search small -->
                                <div class="search-typeC justify-content-right">
                                    <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                    <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                </div>
                            </div>

                            <div class="comment_list">
                                <ul>
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">홍길동</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>                                                
                                            <span class="comment">최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.최근 우리사회의 가장 큰 화두중 하나는 4차 산업혁명과 일자리문제입니다.</span>                                        
                                            <span class="btn_right cmtBtnGroup">
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item cmtHid">숨김</div>
                                                        <div class="item cmtUpt">수정</div>
                                                        <div class="item cmtDel">삭제</div>
                                                        <div class="item cmtWri">댓글</div>
                                                    </div>
                                                </div>
                                            </span>
                                            <div class="cmt_detail">
                                                <div>
                                                    <span class="textNum"><i class="xi-paper-o"></i>45</span>
                                                    <span class="comNum"><i class="xi-speech-o"></i>2</span>
                                                    <span class="fileName"><a href="#" download>홍길동 프로필 사진.jpg</a></span>
                                                </div>
                                                <button class="toggle_commentlist mlAuto">2개의 댓글이 있습니다.</button>
                                            </div>

                                        </div>
                                        <div class="recmt_form mt20">
                                            <fieldset>
                                                <legend class="sr_only">댓글등록</legend>
                                                <div class="memo">
                                                    <div class="simple_answer">
                                                        <span>간편 댓글</span>
                                                        <div class="answer_btn">
                                                            <a href="#0" class="current">수고했어요</a><!--간편답변 선택시 클래스추가-->
                                                            <a href="#0">고생하셨어요.</a>
                                                            <a href="#0">감사합니다.</a>
                                                        </div>
                                                    </div>
                                                    <textarea title="댓글을 등록하세요." class="comment" name="c_comment" rows="3" cols="76" placeholder="댓글을 입력해 주세요"></textarea>
                                                    <div class="bottom_btn">                                                    
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="" id="feedbackLabel">
                                                            <label for="feedbackLabel">답변을 요청합니다.</label>
                                                        </span>                                                   
                                                        <div class="right-area">                                                                      
                                                            <button type="button" class="btn type2">댓글 등록</button>
                                                        </div>
                                                    </div> 
                                                </div>
                                            </fieldset>
                                        </div>
                                        
                                        <ul class="re_comment_ul dpNone">
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <div class="user_img">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <strong class="name">나방송</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>
                                                    <span class="comment">네. 좋은 의견 감사합니다.</span>
                                                    <span class="btn_right cmtBtnGroup">
                                                        <div class="dropdown">
                                                            <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                                <i class="xi-ellipsis-v"></i>
                                                            </button>
                                                            <div class="optionWrap option-wrap">
                                                                <div class="item cmtHid">숨김</div>
                                                                <div class="item cmtUpt">수정</div>
                                                                <div class="item cmtDel">삭제</div>
                                                                <div class="item cmtWri">댓글</div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>                                                    
                                            </li>
                                            <li class="re_comment">
                                                <div class="item">
                                                    <div class="cmt_info">
                                                        <div class="user">
                                                            <span class="user_img"></span>
                                                        </div>                                                                                                               
                                                        <div>
                                                            <strong class="name">홍길동</strong>
                                                            <span class="date">2026.05.02 05:32</span>
                                                        </div>
                                                    </div>                                                        
                                                    <span class="comment">동의합니다.</span>
                                                    <span class="btn_right cmtBtnGroup">
                                                        <div class="dropdown">
                                                            <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                                <i class="xi-ellipsis-v"></i>
                                                            </button>
                                                            <div class="optionWrap option-wrap">
                                                                <div class="item cmtHid">숨김</div>
                                                                <div class="item cmtUpt">수정</div>
                                                                <div class="item cmtDel">삭제</div>
                                                                <div class="item cmtWri">댓글</div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>                                                   
                                            </li>
                                        </ul>                                            
                                    </li>
                
                                    <li>
                                        <div class="item">
                                            <div class="cmt_info">
                                                <div class="user">
                                                    <span class="user_img"></span>
                                                </div>
                                                <div>
                                                    <strong class="name">나방송</strong>
                                                    <span class="date">2026.05.02 05:32</span>
                                                </div>
                                            </div>
                                            <span class="comment">질문의 효과를 최대화 시키기 위해서는 올바른 질문을 하는 것이 중요 <span class="label s_c02">삭제됨</span></span>
                                            <span class="btn_right cmtBtnGroup">
                                                <div class="dropdown">
                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
                                                        <i class="xi-ellipsis-v"></i>
                                                    </button>
                                                    <div class="optionWrap option-wrap">
                                                        <div class="item cmtHid">숨김</div>
                                                        <div class="item cmtUpt">수정</div>
                                                        <div class="item cmtDel">삭제</div>
                                                        <div class="item cmtWri">댓글</div>
                                                    </div>
                                                </div>
                                            </span>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            
                        </div>

                        <script>
                            document.addEventListener('DOMContentLoaded', function () {

                                document.addEventListener('click', function (e) {

                                /* 댓글 목록 토글 */
                                const listBtn = e.target.closest('.toggle_commentlist');
                                if (listBtn) {
                                const comment = listBtn.closest('.Comment');
                                if (!comment) return;

                                const ul = comment.querySelector('.comment_list .re_comment_ul');
                                if (!ul) return;

                                ul.style.display =
                                    ul.style.display === 'none' || !ul.style.display
                                    ? 'block'
                                    : 'none';

                                return;
                                }

                                /* 상단 댓글 작성 폼 토글 */
                                const writeBtn = e.target.closest('.toggle_commentwrite');
                                if (writeBtn) {
                                const comment = writeBtn.closest('.Comment');
                                if (!comment) return;

                                const form = comment.querySelector('.comment_list > .recmt_form');
                                if (!form) return;

                                form.style.display =
                                    form.style.display === 'none' || !form.style.display
                                    ? 'block'
                                    : 'none';

                                if (form.style.display === 'block') {
                                    form.querySelector('textarea')?.focus();
                                }

                                return;
                                }

                                /* 댓글 목록 안 대댓글 폼 토글 */
                                const replyBtn = e.target.closest('.cmtWri');
                                if (replyBtn) {
                                const li = replyBtn.closest('li');
                                if (!li) return;

                                const comment = replyBtn.closest('.Comment');
                                const replyForm = li.querySelector('.recmt_form');
                                if (!replyForm) return;

                                // 같은 Comment 안의 다른 대댓글 폼 닫기
                                comment
                                    .querySelectorAll('.comment_list ul li .recmt_form')
                                    .forEach(function (form) {
                                    if (form !== replyForm) {
                                        form.style.display = 'none';
                                    }
                                    });

                                replyForm.style.display =
                                    replyForm.style.display === 'none' || !replyForm.style.display
                                    ? 'block'
                                    : 'none';

                                if (replyForm.style.display === 'block') {
                                    replyForm.querySelector('textarea')?.focus();
                                }
                                }

                                });

                            });
                        </script>



                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->


        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">피드백</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">  
                    <div class="board_top class">
                        <h3 class="board-title">일한 번역연습01 1반</h3>
                        <div class="right-area">
                            <button type="button" class="btn type2">피드백 취소</button>
                            <div class="feedback-info">
                                <p class="desc">
                                    <span><strong>컴퓨터공학과</strong></span>
                                    <span><strong>9021582</strong></span>
                                    <span><strong>김주미</strong></span>
                                    <span class="score"><strong>65점</strong></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!--등록-->
                    <div class="table-wrap mt10">
                        <table class="table-type5 in_table">
                            <colgroup>
                                <col class="width-20per" />
                                <col class="" />
                            </colgroup>
                            <tbody>                                                                                                      																                                                                
                                <tr>
                                    <th><label for="bulkFeedback">피드백</label></th>
                                    <td>
                                        <textarea rows="2" id="bulkFeedback" class="form-control width-100per" maxLenCheck="byte,2000,true,true" placeholder="피드백 입력"></textarea>                                          
                                    
                                        <div class="upload-file">
                                            <div class="file-btn">
                                                <button type="button" class="btn basic"><i class="xi-upload"></i> 파일첨부</button>
                                            </div>	
                                            <div class="file-info">                                                   
                                                <p>
                                                    <a href="#"><i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    첨부파일_202654541.pdf<small>20.86 KB</small></a>
                                                </p>
                                             <span aria-label="삭제" href="#_none"></span>
                                            </div>
                                            <button type="button" class="btn type1">저장</button>														
                                        </div>                                            
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>  

                    <div class="board_top">
                        <h5 class="sub-title-sm"><i class="xi-comment-o icon" aria-label="피드백"></i>2026.05.11 18:42 </h5>    
                        <div class="right-area">
                            <button type="button" class="btn basic">저장</button>
                            <button type="button" class="btn basic">삭제</button>
                        </div>                
                    </div>
                    <!--수정-->
                    <div class="table_list">                          
                        <ul class="list">
                            <li class="head"><label>피드백</label></li>
                            <li>
                                <div class="tb_content">
                                    <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">최근 IT산업을 중심으로 많은 B2C 기업들이 B2B로 사업을 확장하기 위해 노력하고 있다. 그러나 B2B 고객은 B2C와는 전혀 다르며, 사업 방식 또한 달라야 한다. 새로운 기업이 진입하기에는 진입장벽 또한 만만치 않다.
                                    </textarea>

                                    <div class="upload-file mt10">
                                        <div class="file-btn">
                                            <button type="button" class="btn basic"><i class="xi-upload"></i> 파일첨부</button>
                                        </div>	
                                        <div class="file-info">                                                   
                                            <p>
                                                <a href="#"><i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                첨부파일_202654541.pdf<small>20.86 KB</small></a>
                                            </p>
                                            <span aria-label="삭제" href="#_none"></span>
                                        </div>														
                                    </div>                                        
                                </div>
                            </li>
                        </ul>                                                   
                    </div>

                    <div class="board_top">
                        <h5 class="sub-title-sm"><i class="xi-comment-o icon" aria-label="피드백"></i>2026.05.06 13:35 </h5>    
                        <div class="right-area">
                            <button type="button" class="btn basic">수정</button>
                            <button type="button" class="btn basic">삭제</button>
                        </div>                
                    </div>
                    <!--보기-->
                    <div class="table_list">                          
                        <ul class="list">
                            <li class="head"><label>피드백</label></li>
                            <li>
                                <div class="tb_content">
                                    최근 IT산업을 중심으로 많은 B2C 기업들이 B2B로 사업을 확장하기 위해 노력하고 있다. 그러나 B2B 고객은 B2C와는 전혀 다르며, 사업 방식 또한 달라야 한다. 새로운 기업이 진입하기에는 진입장벽 또한 만만치 않다.
                                                                         
                                    <div class="add_file_list mt10">                              
                                        <ul class="add_file">
                                            <li>                    
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">첨부파일명마우스오버 시.doc</span>
                                                    <span class="fileSize">(6KB)</span>
                                                </a>                                                            
                                            </li>
                                            <li>
                                                <a href="#" class="file_down">
                                                    <i class="icon-svg-paperclip" aria-hidden="true"></i>
                                                    <span class="text">154873973477000.jpg</span>
                                                    <span class="fileSize">(6KB)</span>
                                                </a>                                        
                                            </li>
                                        </ul>
                                    </div>                            													                                                                            
                                </div>
                            </li>
                        </ul>                                                   
                    </div>
                    
                    
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal2Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal2Title">토론현황 그래프</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">  
                    <div class="board_top">
                        <h3 class="board-title">토론 참여 현황</h3>                        
                    </div>
                    <div class="sub-box">
                        <div class="scoreChart_wrap">
                            <div class="left_chart">
                                <div class="chart-container" style="height: 250px;">
                                    <canvas id="pieChart"></canvas>
                                </div>
                                <script>
                                    // PIE CHART용 데이터
                                    const pieData = {
                                        labels: ['제출', '미제출'],
                                        datasets: [{
                                            data: [36, 8],
                                            backgroundColor: [
                                                'rgba(54, 162, 235, .8)',
                                                'rgba(255, 99, 132, .8)'
                                            ],
                                            borderWidth: 1
                                        }]
                                    };

                                    // PIE CHART 설정
                                    const pieConfig = {
                                        type: 'pie',
                                        data: pieData,
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: {
                                                    position: 'bottom',
                                                    labels: {
                                                        formatter: function(value, ctx) {
                                                            const index = ctx.dataIndex;
                                                            const dataset = ctx.dataset;
                                                            return `${ctx.label} : ${dataset.data[index]}명`;
                                                        }
                                                    }
                                                },
                                                title: {
                                                    display: true,
                                                    text: '최종 보고서 제출 현황 (%)',
                                                    font: { size: 16 },
                                                    color: '#333'
                                                },
                                                datalabels: {
                                                    color: '#fff',
                                                    font: {
                                                        weight: 'bold',
                                                        size: 11
                                                    },
                                                    formatter: function(value, context) {
                                                        const data = context.chart.data.datasets[0].data;
                                                        const total = data.reduce((a, b) => a + b, 0);
                                                        const percent = (value / total * 100).toFixed(1);
                                                        return percent + '%';
                                                    }
                                                }
                                            }
                                        },
                                        plugins: [ChartDataLabels]
                                    };

                                    // 생성
                                    new Chart(document.getElementById('pieChart'), pieConfig);
                                </script>                                                      
                            </div>
                            <div class="right_chart">                                                                                                                 
                                <div class="chart-container" style="height: 250px;">
                                    <canvas id="barChart"></canvas>
                                </div>
                                <script>
                                    const barUtils = ChartUtils.init();
                                    const BAR_COUNT = 3;
                                    const NUMBER_BAR = {
                                        count: BAR_COUNT,
                                        min: 0,
                                        max: 100
                                    };
                                    const BarLabels = ['평균점수', '최고점수', '최저점수'];
                                    const barData = {
                                        labels: BarLabels,
                                        datasets: [{
                                            data: [70, 95, 28],
                                            backgroundColor: [                                               
                                                'rgba(75, 192, 192, .6)',
                                                'rgba(54, 162, 235, .6)',
                                                'rgba(255, 99, 132, .6)'                                      
                                            ],
                                            borderWidth: 1,
                                            barThickness: 30
                                        }]
                                    };
                                    const barConfig = {
                                        type: 'bar',
                                        data: barData,
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: { display: false },
                                                title: {
                                                    display: true,
                                                    text: '성적분포현황',
                                                    font: { size: 16 },
                                                    color: '#333'
                                                },
                                                datalabels: {
                                                    anchor: 'end',   // 막대 끝 기준
                                                    align: 'top',   
                                                    offset: -2,
                                                    color: '#666',
                                                    font: {
                                                        weight: 'bold',
                                                        size: 11
                                                    },
                                                    formatter: function(value) {
                                                        return value; // 표시할 값
                                                    }
                                                }
                                            },
                                            scales: {
                                                y: {
                                                    ticks: { color: '#666', font: { size: 12 }, stepSize: 20 },
                                                    title: { display: true, text: '점수' }                                                          
                                                },
                                                x: {
                                                    ticks: { color: '#666', font: { size: 12 } },
                                                }
                                            }
                                        },
                                        plugins: [ChartDataLabels] // datalabels 플러그인 활성화                                                                   
                                    };
                                    new Chart(document.getElementById('barChart'), barConfig);
                                </script>                                
                            </div>
                        </div>
                    </div>
                                        
                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal 3 -->
        <div class="modal-overlay" id="modal3" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal3Title" >
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal3Title">엑셀로 성적등록</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">  
                    <div class="msg-box">
                        <p class="txt"><strong>주의사항</strong></p>
                        <ul class="list-dot">
                            <li>엑셀 파일만 업로드 해야 하며, 지정된 형식을 맞춰야 합니다. 지정된 형식은 샘플 다운로드 받으시면 자세히 보실 수 있습니다.</li>
                            <li>잘못된 형식으로 파일을 등록하면, 정보가 제대로 적용되지 않을 수 있습니다.</li>
                            <li>샘플 파일의 명시사항을 절대 수정하지 마시고, 입력란에 데이터를 입력, 저장 후 등록해 주세요.</li>
                            <li>자료를 작성하실 때 항목은 빈 란으로 두지 마세요.</li>
                        </ul>
                    </div>
                    <div class="board_top">
                        <button type="button" class="btn basic">엑셀 샘플 다운로드 </button>                 
                    </div>
                                                                                
                    <div class="modal_btns">
                        <button type="button" class="btn type1">등록</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

        
    </div>

</body>
</html>

