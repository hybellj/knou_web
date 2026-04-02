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

                        <div class="board_top">
                            <h3 class="board-title">등록</h3>                           
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
                                        <th><label for="discussionTitle" class="req">토론명</label></th>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" type="text" id="discussionTitle" name="discussionTitle"
                                                    placeholder="제목 입력" required="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="contTextarea" class="req">토론내용</label></th>
										<td data-th="입력">
											<li>
												<dl>
													<dd>
														<div class="editor-box">
															<label for="atclCts" class="hide">Content</label>
															<textarea id="atclCts" name="atclCts" required="true"><%-- <c:out value="${bbsAtclVO.atclCts}" /> --%></textarea>
															<script>
																// HTML 에디터
																let editor = UiEditor({
																	targetId: "atclCts",
																	uploadPath: "/bbs",
																	height: "500px"
																});
															</script>
														</div>

														<a href="#_" onclick="checkEditorContens();return false;">[입력내용확인]</a> &nbsp;
														<a href="#_" onclick="insertEditorContens1();return false;">[내용추가(text)]</a> &nbsp;
														<a href="#_" onclick="insertEditorContens2();return false;">[내용바꾸기(html)]</a>
														<script>
															function checkEditorContens() {
																if (editor.isEmpty()) {
																	alert("비어있다....");
																}
																else {
																	let text = $("#atclCts").val(); // editor.editor.getPublishingHtml()
																	alert(text);
																}
															}

															function insertEditorContens1() {
																//editor.execCommand('selectAll');
																//editor.execCommand('deleteLeft');
																editor.execCommand('insertText', "<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
															}

															function insertEditorContens2() {
																editor.openHTML("<span style='color:red'>텍스트 넣기 테스트입니다.</span>");
															}
														</script>
													</dd>
												</dl>
											</li>

										</section>
										<!--//섹션 에디터-->
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
                                        <th><label for="startDate" class="req">참여기간</label></th>
                                        <td>
                                            <div class="date_area">
                                                <input type="text" id="startDate" class="datepicker" placeholder="시작일" required="true">
                                                <input type="text" id="startTime" class="timepicker" placeholder="시작시간" required="true">
                                                <span class="txt-sort">~</span>
                                                <input type="text" id="endDate" class="datepicker" placeholder="종료일" required="true">
                                                <input type="text" id="endTime" class="timepicker" placeholder="종료시간" required="true">
                                            </div>
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
                                        <th><label for="eval_score" class="req">평가방법</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="eval_score" name="evaluationMethod" value="score" checked>
                                                    <label for="eval_score">점수형</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="eval_part" name="evaluationMethod" value="participation">
                                                    <label for="eval_part">참여형</label>
                                                    <small class="note">(토론 참여 : 100점, 미참여 : 0점 자동배점)</small>      
                                                </span>
                                                                                        
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="attchFile">첨부파일</label></th>
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
                                        <th><label for="teamDiscussion_no">팀 토론</label></th>
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
                                                <small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요.</small>
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
                                                        <th><label for="viewOption">참여글 보기 옵션</label></th>
                                                        <td>
                                                            <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="checkbox" id="viewOption" name="viewOption" value="Y">
                                                                    <label for="viewOption">본인의 토론글 등록 후 다른 참여글 보기 가능</label>
                                                                </span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label for="replyUse_no">댓글 답변 요청</label></th>
                                                        <td>
                                                            <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="radio" id="replyUse_no" name="replyUse" value="N" checked>
                                                                    <label for="replyUse_no">아니오</label>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" id="replyUse_yes" name="replyUse" value="Y">
                                                                    <label for="replyUse_yes">예</label>
                                                                </span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th><label for="debateUse_no">찬반 토론으로 설정</label></th>
                                                        <td>
                                                            <div class="form-inline mb10">
                                                                <span class="custom-input">
                                                                    <input type="radio" id="debateUse_no" name="debateUse" value="N" checked>
                                                                    <label for="debateUse_no">아니오</label>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" id="debateUse_yes" name="debateUse" value="Y">
                                                                    <label for="debateUse_yes">예</label>
                                                                </span>
                                                            </div>

                                                            <!-- 찬반 옵션 -->
                                                            <div class="form-row option_list">
                                                                <div class="form-inline">
                                                                    <label for="ratioOpen">찬반 비율 공개</label>
                                                                    <input type="checkbox" value="Y" id="ratioOpen" class="switch small" checked="checked">
                                                                </div>

                                                                <div class="form-inline">
                                                                    <label for="writerOpen">작성자 공개</label>
                                                                    <input type="checkbox" value="Y" id="writerOpen" class="switch small" checked="checked">
                                                                </div>

                                                                <div class="form-inline">
                                                                    <label for="multiOpinion">의견 글 복수 등록</label>
                                                                    <input type="checkbox" value="N" id="multiOpinion" class="switch small">
                                                                </div>

                                                                <div class="form-inline">
                                                                    <label for="opinionChange">찬반 의견 변경가능</label>
                                                                    <input type="checkbox" value="N" id="opinionChange" class="switch small">
                                                                </div>
                                                            </div>
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
                            <button type="button" class="btn type2">이전토론 가져오기</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>                        

                    </div>


                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" data-modal-open="modal1">학습그룹지정</button>          
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

        <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

    </div>

</body>
</html>

