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

<body class="class darkmode"><!-- 컬러선택시 클래스변경 -->
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
                            <h2 class="page-title">과제</h2>
                        </div>
                        <div class="board_top">
                            <h3 class="board-title">과제정보 및 과제평가</h3>
                            <div class="right-area">
                                <button type="button" class="btn type1 big">재제출 관리</button>
                                <button type="button" class="btn type1 big">수정</button>
                                <button type="button" class="btn type2 big">삭제</button>
                                <button type="button" class="btn type2 big">목록</button>
                            </div>
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
                                        <th><label for="assignmentContent">과제내용</label></th>
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
                                        <th><label for="classSection_all">제출기간</label></th>
                                        <td>2026.09.30 10:00 ~ 2026.10.09 22:00</td>
                                    </tr>
                                    <tr>
                                        <th><label for="submitStartDate">성적반영</label></th>
                                        <td>예</td>
                                    </tr>
                                    <tr>
                                        <th><label for="submitStartDate">성적반영비율</label></th>
                                        <td>25%</td>
                                    </tr>
                                    <tr>
                                        <th><label for="submitStartDate">성적공개</label></th>
                                        <td>예</td>
                                    </tr>
                                    <tr>
                                        <th><label for="gradeReflect_yes">연장제출</label></th>
                                        <td>2026.10.09 22:00</td>
                                    </tr>
                                    <tr>
                                        <th><label for="gradeOpen_yes">실기과제</label></th>
                                        <td>예</td>
                                    </tr>
                                    <tr>
                                        <th><label for="teamDiscussion_no">팀 과제</label></th>
                                        <td>
                                            <div class="form-inline">학습그룹 : 과제 학습그룹 001</div>

                                            <div class="team_item">
                                                    학습그룹별 과제 설정 : 사용
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
                                                                <th>학습그룹 구성원</th>
                                                                <td>홍팀장1 외 11명</td>
                                                            </tr>
                                                            <tr>
                                                                <th>부주제</th>
                                                                <td>
                                                                    <div class="form-row">
                                                                        부주제 주제01
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <th><label for="contTextarea">내용</label></th>
                                                                <td>
                                                                    <label class="width-100per"><textarea rows="4" class="form-control resize-none">과제내용입니다.</textarea></label>
                                                                </td>
                                                            </tr>                                                            
                                                            <tr>
                                                                <th><label for="attchFile">첨부파일</label></th>
                                                                <td>첨부파일_202654541.pdf</td>
                                                            </tr>
                                                            <tr>
                                                                <th rowspan="4" class="group-header"><label for="viewOption">2팀</label></th>
                                                                <th>학습그룹 구성원</th>
                                                                <td>홍팀장1 외 11명</td>
                                                            </tr>
                                                            <tr>
                                                                <th>부주제</th>
                                                                <td>
                                                                    <div class="form-row">
                                                                        부주제 주제01
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <th><label for="contTextarea">내용</label></th>
                                                                <td>
                                                                    <label class="width-100per"><textarea rows="4" class="form-control resize-none">과제내용입니다.</textarea></label>
                                                                </td>
                                                            </tr>                                                            
                                                            <tr>
                                                                <th><label for="attchFile">첨부파일</label></th>
                                                                <td>첨부파일_202654541.pdf</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <!--//학습그룹별 토론설정 -->
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>개별과제</th>
                                        <td>
                                            예
                                            <div class="team_item">
                                            <ul class="list-divide">
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                                <li>학*자01 (97854214)</li>
                                            </ul>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th>과제읽기</th>
                                        <td>2026.02.15부터 가능</td>
                                    </tr>
                                </tbody>
                            </table>
                            </form>
                        </div>
						<!--//table-type-->


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
                            <button type="button" class="btn search">수강생 전체</button>
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
                                        <th>일괄 피드백</th>
										<td>
											<textarea rows="2" id="bulkFeedback" class="form-control width-100per" maxLenCheck="byte,2000,true,true"></textarea>
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
                            <div class="right-area">
                                <button type="button" class="btn basic">우수과제 취소</button>
                                <button type="button" class="btn basic">제출과제 다운로드</button>
                                <button type="button" class="btn basic">엑셀로 다운로드</button>
                            </div>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:3%">
                                    <col>
                                    <col style="width:100px">
                                    <col>
                                    <col style="width:12%">
                                    <col style="width:10%">
                                    <col style="width:7%">
                                    <col style="width:6%">
                                    <col style="width:5%">
                                    <col style="width:5%">
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
                                        <th>썸네일</th>
                                        <th>학과</th>
                                        <th>대표아이디</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>평가점수</th>
                                        <th>피드백</th>
                                        <th>이전제출</th>
                                        <th>제출상태</th>
                                        <th>제출일시</th>
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
                                        <td data-th="썸네일">
                                            <div class="thumb">
                                                <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                            </div>
                                        </td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50<i class="xi-trophy icon ml5"></i></td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="이전제출"><a href="#0"><i class="xi-file-o icon" aria-label="이전제출"></i></a></td>
                                        <td data-th="제출상태"><span class="fcCon">미제출</span></td>
                                        <td data-th="제출일시">2026.04.12 10:25</td>
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
                                        <td data-th="썸네일">
                                            <div class="thumb">
                                                <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                            </div>
                                        </td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="이전제출"><a href="#0"><i class="xi-file-o icon" aria-label="이전제출"></i></a></td>
                                        <td data-th="제출상태"><span class="fcNot">연장제출</span></td>
                                        <td data-th="제출일시">2026.04.12 10:25</td>
                                        <td data-th="평가여부">Y</td>
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
                                        <td data-th="썸네일">
                                            <div class="thumb">
                                                <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                            </div>
                                        </td>
                                        <td data-th="학과">국어국문학과</td>
                                        <td data-th="대표아이디">testid50</td>
                                        <td data-th="학번">2021215478</td>
                                        <td data-th="이름">학습자</td>
                                        <td data-th="평가점수">
                                            <a href="#0" class="link">90</a>
                                        </td>
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="이전제출"><a href="#0"><i class="xi-file-o icon" aria-label="이전제출"></i></a></td>
                                        <td data-th="제출상태">제출</td>
                                        <td data-th="제출일시">2026.04.12 10:25</td>
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

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" id="btn-feedback">피드백</button>
                        <button type="button" class="btn modal__btn" id="btn-prev-submit">이전 제출</button>
                        <button type="button" class="btn modal__btn" id="btn-resubmit">재제출 관리</button>
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->

        <!-- Modal1 피드백 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
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
        <!-- //Modal1 피드백 -->

        <!-- Modal2 이전 과제 제출목록 -->
        <div class="modal-overlay" id="modal2">
            <div class="modal-content modal-lg" tabindex="-1">
                <div class="modal-header">
                    <h2 id="modal1Title">이전 과제 제출목록</h2>
                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
                </div>
                <div class="modal-body">
                        <!--table-type2-->
                        <div class="table-wrap">
                            <table class="table-type2">
                                <colgroup>
                                    <col style="width:5%">
                                    <col style="width:10%">
                                    <col>
                                    <col>
                                    <col style="width:7%">
                                    <col style="width:15%">
                                    <col style="width:7%">
                                    <col style="width: 10%;">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>번호</th>
                                        <th>과제구분</th>
                                        <th>과제</th>
                                        <th>제출과제</th>
                                        <th>다운로드</th>
                                        <th>제출일</th>
                                        <th>평가점수</th>                                  
                                        <th>점수변경</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td data-th="번호" rowspan="2">6</td>
                                        <td data-th="과제구분" rowspan="2">일반과제</td>
                                        <td data-th="과제" rowspan="2">일반과제 일반과제 일반과제01</td>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>  
                                        <td data-th="점수변경" rowspan="2">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">
                                            <button type="button" class="btn type1 small">저장</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">5</td>
                                        <td data-th="과제구분">팀과제</td>
                                        <td data-th="과제">팀과제 팀과제 팀과제</td>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>  
                                        <td data-th="점수변경">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">
                                            <button type="button" class="btn type1 small">저장</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">4</td>
                                        <td data-th="과제구분">팀과제</td>
                                        <td data-th="과제">팀과제 팀과제 팀과제</td>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>  
                                        <td data-th="점수변경">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">
                                            <button type="button" class="btn type1 small">저장</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">3</td>
                                        <td data-th="과제구분">일반과제</td>
                                        <td data-th="과제">일반과제 일반과제 일반과제</td>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>  
                                        <td data-th="점수변경">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">
                                            <button type="button" class="btn type1 small">저장</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">2</td>
                                        <td data-th="과제구분">개별과제</td>
                                        <td data-th="과제">개별과제 개별과제 개별과제</td>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>  
                                        <td data-th="점수변경">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">
                                            <button type="button" class="btn type1 small">저장</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td data-th="번호">1</td>
                                        <td data-th="과제구분">중간고사</td>
                                        <td data-th="과제">대체과제대체과제대체과제</td>
                                        <td data-th="제출과제"><a href="#0" download>첨부파일_202654541.pdf</a></td>                                      
                                        <td data-th="다운로드"><a href="#0"><i class="xi-download icon"></i></a></td>
                                        <td data-th="제출일">2026.06.23 15:00</td>
                                        <td data-th="평가점수">85점</td>  
                                        <td data-th="점수변경">
                                            <input class="t_num3" id="scoreInput" type="text" value="89">
                                            <button type="button" class="btn type1 small">저장</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type2-->

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal2 이전제출 -->
        
        <!-- Modal3 재제출 관리 -->
        <div class="modal-overlay" id="modal3">
                <div class="modal-body">
                    <div class="table-wrap">
                        <table class="table-type5">
                            <colgroup>
                                <col style="width:15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="req">재제출 기간</th>
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
                                    <th class="req">반영비율</th>
                                    <td>
                                        <div class="form-row">
                                            <div class="input_btn">
                                                <input class="form-control sm" id="timeInput" type="text" maxlength="2"><label>%</label>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="req">재 제출자</th>
                                    <td>
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" id="individualAssignment_no" name="individualAssignment" value="N">
                                                <label for="individualAssignment_no">아니오</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" id="individualAssignment_yes" name="individualAssignment" value="Y" checked>
                                                <label for="individualAssignment_yes">예</label>
                                            </span>
                                        </div>
                                            <div class="individualAssignment_list">
                                                <div class="individualAssignment_list_area">
                                                    <div class="board_top in_table">
                                                        <p>수강생</p>
                                                        <!-- search small -->
                                                        <div class="search-typeC">
                                                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                                        </div> 
                                                    </div>
                                                    <div class="table-height-scroll">
                                                        <table class="table-type2">
                                                            <colgroup>
                                                                <col style="width:8%">
                                                                <col style="width:10%">
                                                                <col style="width:34%">
                                                                <col style="width:24%">
                                                                <col style="width:24%">
                                                            </colgroup>
                                                            <thead>
                                                                <tr>
                                                                    <th>
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                                                    </th>
                                                                    <th>번호</th>
                                                                    <th>학과</th>
                                                                    <th>학번</th>
                                                                    <th>이름</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">01</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">02</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk3"><label for="chk3"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">03</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk4"><label for="chk4"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">04</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                            </tbody>

                                                        </table>
                                                    </div>
                                                </div>

                                                <div class="arrowBtn">
                                                    <button type="button" class="btn basic icon"><i class="xi-angle-left"></i></button>
                                                    <button type="button" class="btn basic icon"><i class="xi-angle-right"></i></button>
                                                </div>
                                                
                                                <div class="individualAssignment_list_area">
                                                    <div class="board_top in_table">
                                                        <p>대상 수강생</p>
                                                        <!-- search small -->
                                                        <div class="search-typeC">
                                                            <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                                            <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                                                        </div> 
                                                    </div>
                                                    <div class="table-height-scroll">
                                                        <table class="table-type2">
                                                            <colgroup>
                                                                <col style="width:8%">
                                                                <col style="width:10%">
                                                                <col style="width:34%">
                                                                <col style="width:24%">
                                                                <col style="width:24%">
                                                            </colgroup>
                                                            <thead>
                                                                <tr>
                                                                    <th>
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chkall"><label for="chkall"></label></span>
                                                                    </th>
                                                                    <th>번호</th>
                                                                    <th>학과</th>
                                                                    <th>학번</th>
                                                                    <th>이름</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk1"><label for="chk1"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">01</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk2"><label for="chk2"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">02</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk3"><label for="chk3"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">03</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                                <tr>
                                                                    <td data-th="선택" class="chkbox">
                                                                        <span class="custom-input onlychk"><input type="checkbox" id="chk4"><label for="chk4"></label></span>
                                                                    </td>
                                                                    <td data-th="번호">04</td>
                                                                    <td data-th="학과">0000학과</td>
                                                                    <td data-th="학번">90125***59</td>
                                                                    <td data-th="발신자">홍*동7</td>
                                                                </tr>
                                                            </tbody>

                                                        </table>

                                                    </div>
                                                </div>
                                            </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal3 재제출 관리 -->

        <script>
            $(function() {
                // 1. 피드백 다이얼로그
                $('#btn-feedback').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "피드백",
                        width: 1200,
                        height: 600,
                        html: $content
                    });
                });

                // 2. 이전 제출 다이얼로그
                $('#btn-prev-submit').on('click', function() {
                                      
                    var $content = $('#modal2 .modal-body');
                    
                    UiDialog("dialog1", {
                        title: "이전 제출 내역",
                        width: 1200,
                        height: 600,
                        html: $content
                    });
                });

                // 3. 재제출 관리 다이얼로그
                $('#btn-resubmit').on('click', function() {
                                       
                    var $content = $('#modal3 .modal-body');
                                        
                    let dialog3 = UiDialog("dialog1", {
                        title: "재제출 관리",
                        width: 1200,
                        height: 650,
                        html: $content
                    });
                });
            });
        </script>
    </div>

</body>
</html>
