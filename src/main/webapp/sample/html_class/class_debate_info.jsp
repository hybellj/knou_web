<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="classroom"/>
	</jsp:include>
</head>

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
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
                                <li class="select"><a href="#0">토론정보 및 평가</a></li>
                                <li><a href="#">토론방</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">토론정보 및 토론평가</h3>
                            <div class="right-area">                                                        
                                <button type="button" class="btn type1 big">수정</button>                                
                                <button type="button" class="btn type2 big">삭제</button>    
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
                                                    <span>참여기간<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
                                                    <span>성적반영<strong>예</strong></span>
                                                    <span>성적공개<strong>아니오</strong></span>
                                                </p>                                                 
                                            </div>                                                                                        
                                            <i class="arrow xi-angle-down"></i>                                           
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <div class="table_list">                                          
                                            <ul class="list">
                                                <li class="head"><label>토론내용</label></li>
                                                <li>
                                                    <div class="tb_content">
                                                        <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다. 토론내용입니다.
                                                        </textarea>                                                       
                                                    </div>
                                                </li>
                                            </ul>
                                        
                                            <ul class="list">
                                                <li class="head"><label>참여기간</label></li>
                                                <li>2026.09.30 10:00 ~ 2026.10.09 22:00</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>성적반영</label></li>
                                                <li>예</li>
                                                <li class="head"><label>성적반영비율</label></li>
                                                <li>25%</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>성적공개</label></li>
                                                <li>예</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>평가방법</label></li>
                                                <li>참여형 <small class="note ml10">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small></li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>파일 첨부</label></li>
                                                <li>
                                                    <div class="add_file_list">                              
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
                                                </li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>팀 토론</label></li>
                                                <li class="in_table">
                                                    <div class="view_con">
                                                        예<br>
                                                        학습그룹 : 토론 학습그룹 002<br>                                                        
                                                        학습그룹별 토론 설정 : 사용                                                       
                                                    </div> 
                                                    
                                                    <!-- 학습그룹별 토론설정 -->
                                                    <div class="table-wrap mb30">
                                                        <table class="table-type5 in_table">
                                                            <colgroup>
                                                                <col class="width-5per" />
                                                                <col class="width-15per" />
                                                                <col />
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
                                                                            <input class="form-control width-100per" type="text" name="name" id="sub_topic" value="" placeholder="주제 입력">
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
                                                    <!--//학습그룹별 토론설정 -->


                                                </li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>참여글 보기 옵션</label></li>
                                                <li>사용 안함</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>댓글 답변요청</label></li>
                                                <li>아니오</li>
                                            </ul>
                                            <ul class="list">
                                                <li class="head"><label>찬반 토론으로 설정</label></li>
                                                <li>예 <br>
                                                    찬반 비율 공개 : 예 <br>
                                                    작성자 공개 : 예 <br>
                                                    의견 글 복수 등록 : 아니오 <br>
                                                    찬반 의견 변경가능 : 아니오
                                                </li>
                                            </ul>
                                        </div>

                                    </div>
                                </li>   
                            </ul>
                        </div>
                        <!--//accordion-->
                                              
                        <div class="board_top mb0">
                            <h4 class="sub-title">토론평가</h4>                         
                            <div class="right-area">                                                        
                                <button type="button" class="btn type2">EZ-Grader</button>                                
                                <button type="button" class="btn type2">엑셀로 성적등록</button>    
                                <button type="button" class="btn basic">메시지 보내기</button>  
                            </div>                         
                        </div>  
                        <div class="board_top in_table">
                            <select class="form-select" id="participationStatus">
                                <option value="참여여부">참여여부</option> 
                                <option value="전체">전체</option>                                       
                            </select>
                            <select class="form-select" id="evaluationStatus">
                                <option value="평가여부">평가여부</option> 
                                <option value="전체">전체</option>                                       
                            </select>
                            <!-- search small -->
                            <div class="search-typeC">
                                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                            </div> 
                            <button type="button" class="btn type2">수강생 전체</button>    
                           
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
                                        <th><label for="scoreInputMode">일괄 성적처리</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" name="scoreInputMode" id="scoreInputModeRegister" value="DEPT" checked>
                                                    <label for="scoreInputModeRegister">점수 등록</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="scoreInputMode" id="scoreInputModeAdjust" value="MANAGER">
                                                    <label for="scoreInputModeAdjust">점수 가감</label>
                                                </span>
                                                <div class="custom-txt">
                                                    <span class="tit">점수 :</span>
                                                    <label><i class="xi-plus"></i></label> 
                                                    <div class="input_btn">
                                                        <input id="bulkScoreValue" class="form-control sm" type="number" min="0" max="100" step="1">
                                                        <label for="bulkScoreValue">점</label>
                                                    </div>    
                                                </div>

                                                <button type="button" class="btn type1">저장</button>	                                            
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="textLengthCondition">글자수로 성적처리</label></th>
                                        <td>
                                            <div class="form-inline">	
                                                <div class="input_btn">
                                                    <input id="textLengthCondition" class="form-control sm" type="text" maxlength="2" autocomplete="off" value="10">
                                                    <label for="textLengthCondition">이상</label>
                                                </div>												
                                                <span class="custom-input">
                                                    <input type="checkbox" name="includeComment" id="includeComment" checked>
                                                    <label for="includeComment">댓글 포함</label>
                                                </span>		
                                                <div class="custom-txt">                                                  
                                                    <div class="input_btn">
                                                        <input id="textScoreValue" class="form-control sm" type="number" min="0" max="100" step="1">
                                                        <label for="textScoreValue">점</label>
                                                    </div>    
                                                </div>	

                                                <button type="button" class="btn type1">저장</button>		
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="participationEval">참여형 일괄평가</label></th>
										<td>
											<button type="button" class="btn type1" id="participationEval">참여형 일괄평가</button>                                      
										</td>
									</tr>
                                    <tr>
										<th><label for="bulkFeedback">일괄 피드백</label></th>
										<td>
											<textarea rows="2" id="bulkFeedback" class="form-control width-100per"  maxLenCheck="byte,2000,true,true"></textarea>                                          
										
											<div id="fileUploader-container" class="dext5-container" style="width:100%;height:180px;"></div>
											<div id="fileUploader-btn-area" class="dext5-btn-area" style=""><button type="button" id="fileUploader_btn-add" style="" title="파일선택">파일선택</button><button type="button" id="fileUploader_btn-delete" disabled='true' style="" title="삭제">삭제</button><button type="button" id="fileUploader_btn-reset" style="display:none" title="초기화" onclick="resetDextFiles('fileUploader')"><i class='xi-refresh'></i></button></div>
											<script>
											UiFileUploader({
												id:"fileUploader",
												parentId:"fileUploader-container",
												btnFile:"fileUploader_btn-add",
												btnDelete:"fileUploader_btn-delete",
												lang:"ko",
												uploadMode:"ORAF",
												maxTotalSize:100,
												maxFileSize:100,
												extensionFilter:"*",
												noExtension:"exe,com,bat,cmd,jsp,msi,html,htm,js,scr,asp,aspx,php,php3,php4,ocx,jar,war,py",
												finishFunc:"finishUpload()",
												uploadUrl:"https://localhost/dext/uploadFileDext.up?type=",
												path:"/bbs",
												fileCount:5,
												oldFiles:[],
												useFileBox:false,
												style:"list",
												uiMode:"normal"
											});
											</script>

                                            <button type="button" class="btn type1 mt10">저장</button>	
										</td>
									</tr>
                                </tbody>
                            </table>
                        </div>  
                      
                        <div class="board_top">
                            <h4 class="sub-title">토론 현황</h4>                         
                            <div class="right-area">
                                <button type="button" class="btn basic">엑셀로 다운로드</button>                              
                                <button type="button" class="btn type2">토론현황 그래프</button>
                                <select class="form-select type-num" id="select" title="페이지당 리스트수를 선택하세요.">
                                    <option value="ALL" selected="selected">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                </select>
                            </div>                         
                        </div>    

                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col style="width:4%">
                                    <col style="">
                                    <col style="width:12%">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col style="width:7%">
                                    <col style="width:6%">
                                    <col style="width:6%">
                                    <col style="width:10%">
                                    <col style="width:6%">
                                    <col style="width:14%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                        </th>
                                        <th>번호</th>
                                        <th>학과</th>
                                        <th>대표아이디</th>
                                        <th>학번</th>
                                        <th>이름</th>                                        
                                        <th>평가점수</th>
                                        <th>피드백</th>
                                        <th>참여상태</th>
                                        <th>참여일시</th>
                                        <th>평가여부</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">학습자</td>                                        
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="피드백"><i class="xi-comment-o icon" aria-label="피드백"></i></td>
                                        <td data-th="참여상태"><span class="fcRed">미참여</span></td>
                                        <td data-th="참여일시">2026.04.12 10:25</td>
                                        <td data-th="평가여부"><span class="fcRed">N</span></td>
                                        <td data-th="관리">
                                            <button class="btn basic small">참여글보기</button>
                                            <button class="btn basic small">메모</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="선택">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chk21"><label for="chk21"></label></span>
                                        </td>
                                        <td data-th="번호">5</td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">학습자</td>                                        
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="피드백"><i class="xi-comment-o icon" aria-label="피드백"></i></td>
                                        <td data-th="참여상태">참여완료</td>
                                        <td data-th="참여일시">2026.04.12 10:25</td>
                                        <td data-th="평가여부">Y</td>
                                        <td data-th="관리">
                                            <button class="btn basic small">참여글보기</button>
                                            <button class="btn basic small">메모</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type-->

                    </div>

                </div>
            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->
        
    </div>

</body>
</html>

