<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
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
                                    <li><span class="current">과제</span></li>
                                </ul>
                            </div>                            
                        </div>                        
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        
                        <div class="page-info">
                            <h2 class="page-title">퀴즈</h2>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <form id="form1" name="form1">

                            <table class="table-type5">
                                <colgroup>
                                    <col class="width-15per" />
                                    <col />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><label for="assignmentTitle" class="req">퀴즈명</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" 
                                                    type="text" 
                                                    id="assignmentTitle" 
                                                    name="assignmentTitle"
                                                    placeholder="제목 입력" 
                                                    required>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="assignmentContent" class="req">퀴즈내용</label></th>
                                        <td data-th="입력">
                                            <div class="editor-box">
                                                <label for="assignmentContent" class="hide">Content</label>
                                                <textarea id="assignmentContent" name="assignmentContent" required></textarea>

                                                <script>
                                                    let editor = UiEditor({
                                                        targetId: "assignmentContent",
                                                        uploadPath: "/bbs",
                                                        height: "500px"
                                                    });
                                                </script>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="classSection_all" class="req">분반같이 등록</label></th>
                                        <td>
                                            <div class="checkbox_type">
                                                <span class="custom-input">
                                                    <input type="checkbox" id="classSection_all" name="classSection" value="all">
                                                    <label for="classSection_all">전체</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" id="classSection_1" name="classSection" value="1" checked>
                                                    <label for="classSection_1">1반</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" id="classSection_2" name="classSection" value="2">
                                                    <label for="classSection_2">2반</label>
                                                </span>
                                                <span class="custom-input">
                                                    <input type="checkbox" id="classSection_3" name="classSection" value="3">
                                                    <label for="classSection_3">3반</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="submitStartDate" class="req">응시기간</label></th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" id="submitStartDate" class="datepicker" placeholder="시작일" required>
                                                <input type="text" id="submitStartTime" class="timepicker" placeholder="시작시간" required>
                                                <span class="txt-sort">~</span>
                                                <input type="text" id="submitEndDate" class="datepicker" placeholder="종료일" required>
                                                <input type="text" id="submitEndTime" class="timepicker" placeholder="종료시간" required>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="submitStartDate" class="req">퀴즈시간</label></th>
                                        <td>
                                            <div class="form-row">
												<div class="input_btn">
													<input class="form-control sm" id="timeInput" type="text" maxlength="2" autocomplete="off"><label>분</label>
												</div>
											</div>
                                            <small class="note2">! 퀴즈 시험지의 시간 표시는 남은 시간이 표시됩니다.</small>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="gradeReflect_yes" class="req">성적반영</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="gradeReflect_yes" name="gradeReflect" value="Y" checked>
                                                    <label for="gradeReflect_yes">예</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="gradeReflect_no" name="gradeReflect" value="N">
                                                    <label for="gradeReflect_no">아니오</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="gradeOpen_yes" class="req">성적공개</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="gradeOpen_yes" name="gradeOpen" value="Y" checked>
                                                    <label for="gradeOpen_yes">예</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="gradeOpen_no" name="gradeOpen" value="N">
                                                    <label for="gradeOpen_no">아니오</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req">문제표시방식</label></th>
                                        <td>
                                            <div class="form-inline">                                       
                                                <span class="custom-input">
                                                    <input type="radio" id="extend_yes" name="extendSubmission" value="Y" checked>
                                                    <label for="extend_yes">전체 문제표시</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="extend_no" name="extendSubmission" value="N">
                                                    <label for="extend_no">1문제씩 표시</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label>문제 섞기</label></th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label>보기 섞기</label></th>
                                        <td>
											<div class="form-row">
												<input type="checkbox" id="checkOpenYn" class="switch yesno">
											</div>

                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="attchFile">파일 첨부</label></th>
										<td>
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
										</td>
									</tr>
                                    <tr>
                                        <th><label for="teamDiscussion_no">팀 퀴즈</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="teamDiscussion_no" name="teamDiscussion" value="N">
                                                    <label for="teamDiscussion_no">아니오</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="teamDiscussion_yes" name="teamDiscussion" value="Y" checked>
                                                    <label for="teamDiscussion_yes">예</label>
                                                </span>
                                            </div>

                                            <div class="team_item">
                                                <div class="item">
                                                    <label class="label_num">1반</label>
                                                    <input class="form-control wide" type="text" value="학습그룹퀴즈 팀 구성">
                                                    <button type="button" class="btn basic">학습그룹지정</button>
                                                </div>
                                                <small class="note2">! 구성된 팀이 없는 경우 메뉴 "과목설정 > 학습그룹지정"에서 팀을 생성해 주세요.</small>

                                                <div class="item_setting">
                                                    <div class="checkbox_type">
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="group_set" name="group_set" value="all" checked>
                                                            <label for="group_set">학습그룹별 토론 설정</label>
                                                        </span>
                                                    </div>
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
                                                                <th rowspan="3" class="group-header"><label for="viewOption">1팀</label></th>
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
                                                            <tr>
                                                                <th rowspan="3" class="group-header"><label for="viewOption">2팀</label></th>
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

                                                <div class="item">
                                                    <label class="label_num">2반</label>
                                                    <input class="form-control wide" type="text" placeholder="팀 분류 선택하세요">
                                                    <button type="button" class="btn basic">학습그룹지정</button>
                                                </div>
                                                <div class="item">
                                                    <label class="label_num">3반</label>
                                                    <input class="form-control wide" type="text" placeholder="팀 분류 선택하세요">
                                                    <button type="button" class="btn basic">학습그룹지정</button>
                                                </div>
                                                <div class="item">
                                                    <label class="label_num">4반</label>
                                                    <input class="form-control wide" type="text" placeholder="팀 분류 선택하세요">
                                                    <button type="button" class="btn basic">학습그룹지정</button>
                                                </div>
                                                <div class="item">
                                                    <label class="label_num">5반</label>
                                                    <input class="form-control wide" type="text" placeholder="팀 분류 선택하세요">
                                                    <button type="button" class="btn basic">학습그룹지정</button>
                                                </div>
                                            </div>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            </form>
                        </div>
						<!--//table-type-->

                        
                        <!--option-->
                        <div class="options_wrap">
                            <ul class="accordion">
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">                                      
                                        <a class="title" href="#">                                                                                            
                                            <div class="lecture_tit">                                                   
                                                <strong>옵션</strong>                                                    
                                            </div>                                                                                        
                                            <i class="arrow xi-angle-down"></i>                                           
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <div class="table-wrap">
                                            <table class="table-type5">
                                                <colgroup>
                                                    <col class="width-15per" />
                                                    <col />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>
                                                            <label for="allowAssignmentRead_yes">재응시 사용</label>
                                                        </th>
                                                        <td>
                                                            <div class="form-inline">
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" id="allowAssignmentRead_no" name="allowAssignmentRead" value="N">
                                                                    <label for="allowAssignmentRead_no">아니오</label>
                                                                </span>
                                                                <span class="custom-input">
                                                                    <input type="radio" id="allowAssignmentRead_yes" name="allowAssignmentRead" value="Y" checked>
                                                                    <label for="allowAssignmentRead_yes">예</label>
                                                                </span>
                                                            </div>

                                                            <div class="custom-txt mt10" id="readAllowDateContainer">
                                                                <span class="tit">채응시 기간</span>
                                                                <div class="date_area">
                                                                    <input type="text" placeholder="시작일" id="datepicker3" class="datepicker" toDate="datepicker4" timeId="timepicker3">
                                                                    <input type="text" placeholder="시작시간" id="timepicker3" class="timepicker" dateId="datepicker3">
                                                                    <span class="txt-sort">~</span>
                                                                    <input type="text" placeholder="종료일" id="datepicker4" class="datepicker" fromDate="datepicker3" timeId="timepicker4">
                                                                    <input type="text" placeholder="종료시간" id="timepicker4" class="timepicker" dateId="datepicker4">
                                                                </div>                                                                
                                                            </div>
                                                            

                                                            <div class="custom-txt mt10" id="readAllowDateContainer">
                                                                <span class="tit">채응시 적용률</span>
                                                                <div class="form-row">
                                                                    <div class="input_btn">
                                                                        <input class="form-control sm" id="timeInput" type="text" maxlength="2"><label>%</label>
                                                                    </div>
                                                                </div>
                                                            </div>       
                                                              
                                                            <script>
                                                                const allowYes = document.getElementById('allowAssignmentRead_yes');
                                                                const allowNo = document.getElementById('allowAssignmentRead_no');
                                                                const readAllowDateContainer = document.getElementById('readAllowDateContainer');

                                                                function toggleReadAllowDate() {
                                                                    if (allowYes.checked) {
                                                                        readAllowDateContainer.style.display = 'flex';
                                                                    } else {
                                                                        readAllowDateContainer.style.display = 'none';
                                                                    }
                                                                }

                                                                allowYes.addEventListener('change', toggleReadAllowDate);
                                                                allowNo.addEventListener('change', toggleReadAllowDate);

                                                                // 초기 표시
                                                                toggleReadAllowDate();
                                                            </script>
                                                        </td>
                                                    </tr>

                                                    
                                                </tbody>
                                            </table>
                                        </div>

                                    </div>
                                </li>   
                            </ul>
                        </div>
                        <!--//option-->

						<div class="btns">
                            <button type="button" class="btn type1">저장</button>
                            <button type="button" class="btn type2">이전퀴즈 가져오기</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>
                    </div>


                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" data-modal-open="modal1">학습그룹지정</button>
                        <button type="button" class="btn modal__btn" data-modal-open="modal2">이전퀴즈 가져오기</button>
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->                    

                </div>
            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

        <!-- Modal 1 -->
        <div class="modal-overlay" id="modal1" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-md" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">학습그룹지정</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">

                    <div class="msg-box warning">
                        <p class="txt"><i class="xi-error" aria-hidden="true"></i> 학습그룹 배정이 완료된 학습그룹만 조회됩니다.</p>
                    </div>

                    <div class="board_top">
                        <select class="form-select wide" id="selectGroup">
                            <option value="학습그룹 지정">학습그룹 지정</option>
                        </select>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:10%">
                                <col style="">
                                <col style="width:20%">
                                <col style="width:20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>팀명</th>
                                    <th>팀장</th>
                                    <th>팀원</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">1</td>
                                    <td data-th="팀명">팀1</td>
                                    <td data-th="팀장">홍길동</td>
                                    <td data-th="팀원">10명</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">2</td>
                                    <td data-th="팀명">팀2</td>
                                    <td data-th="팀장">김철수</td>
                                    <td data-th="팀원">10명</td>
                                </tr>
                                <tr>
                                    <td data-th="번호">3</td>
                                    <td data-th="팀명">팀3</td>
                                    <td data-th="팀장">이영희</td>
                                    <td data-th="팀원">10명</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">확인</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Modal 2 -->
        <div class="modal-overlay" id="modal2" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal1Title" >
            <div class="modal-content modal-xl" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">이전퀴즈 가져오기</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">

                    <div class="board_top">
                        <select class="form-select wide" id="selectGroup">
                            <option value="학사년도">학사년도</option>
                        </select>
                        <select class="form-select wide" id="selectGroup">
                            <option value="학기">학기</option>
                        </select>
                        <select class="form-select wide" id="selectGroup">
                            <option value="과목">과목</option>
                        </select>
                        <div class="search-typeC">
                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="퀴즈명 입력">
                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                        </div> 

                    </div>

                    <div class="table-wrap">
                        <table class="table-type1">
                            <colgroup>
                                <col style="width:10%">
                                <col>
                                <col>
                                <col>
                                <col>
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>과목</th>
                                    <th>분반</th>
                                    <th>퀴즈구분</th>
                                    <th>퀴즈</th>
                                    <th>선택</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="번호">5</td>
                                    <td data-th="과목">일한 번영연습01</td>
                                    <td data-th="분반">1반</td>
                                    <td data-th="퀴즈구분">퀴즈</td>
                                    <td data-th="퀴즈">퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈01</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">4</td>
                                    <td data-th="과목">일한 번영연습01</td>
                                    <td data-th="분반">1반</td>
                                    <td data-th="퀴즈구분">퀴즈</td>
                                    <td data-th="퀴즈">퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈01</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">3</td>
                                    <td data-th="과목">일한 번영연습01</td>
                                    <td data-th="분반">1반</td>
                                    <td data-th="퀴즈구분">퀴즈</td>
                                    <td data-th="퀴즈">퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈01</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">2</td>
                                    <td data-th="과목">일한 번영연습01</td>
                                    <td data-th="분반">1반</td>
                                    <td data-th="퀴즈구분">퀴즈</td>
                                    <td data-th="퀴즈">퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈01</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td data-th="번호">1</td>
                                    <td data-th="과목">일한 번영연습01</td>
                                    <td data-th="분반">1반</td>
                                    <td data-th="퀴즈구분">퀴즈</td>
                                    <td data-th="퀴즈">퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈퀴즈01</td>
                                    <td data-th="선택">
                                        <button type="button" class="btn basic">선택</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type1">확인</button>
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>

