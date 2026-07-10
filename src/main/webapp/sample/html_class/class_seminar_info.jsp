<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="../common/common_inc.jsp" %><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/common_head.jsp">
        <jsp:param name="module" value="editor,fileuploader"/>
        <jsp:param name="module" value="chart"/>
		<jsp:param name="style" value="classroom"/>
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
                <!-- class_sub_top -->
				<jsp:include page="../common/class_sub_top.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="../common/class_info.jsp"/><!-- [../common/] 를 [/WEB-INF/jsp/common_new/] 로 변경하여 적용 -->
                    <!-- //class_info -->

                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">세미나</h2>
                        </div>

                        <div class="listTab">
                            <ul>
                                <li class="select"><a href="#0">세미나 정보 및 평가</a></li>
                            </ul>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">세미나 정보 및 평가</h3>
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
                                                <strong>세미나 제목입니다.</strong>
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
                                                    <th>세미나내용</th>
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly="">세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다. 세미나내용입니다.
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
                                                    <td colspan="3">참여형<small class="note ml10">(세미나 참여 : 100점, 미참여 : 0점 자동배점)</small></td>
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
                                                    <td colspan="3">예<br>학습그룹 : 세미나 학습그룹 002<br>학습그룹별 세미나 설정 : 사용
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

                        <div class="board_top mb0">
                            <h4 class="sub-title">세미나 평가</h4>
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
										<th><label for="bulkFeedback">일괄 피드백</label></th>
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
                                            <button type="button" class="btn type1 mt10">저장</button>
										</td>
									</tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="board_top">
                            <h4 class="sub-title">세미나 현황</h4>
                            <div class="right-area">
                                <button type="button" class="btn basic">ZOOM 참여 로그</button>
                                <button type="button" class="btn basic">일괄 참여 관리</button>
                                <button type="button" class="btn basic">녹화 영상 보기</button>
                                <button type="button" class="btn type2">엑셀로 다운로드</button>
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
                                    <col style="width:6%">
                                    <col style="width:5%">
                                    <col style="width:120px">
                                    <col style="width:120px">
                                    <col style="width:10%">
                                    <col style="width:5%">
                                    <col style="width:150px">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2">
                                            <span class="custom-input onlychk"><input type="checkbox" id="chkall2"><label for="chkall2"></label></span>
                                        </th>
                                        <th rowspan="2">번호</th>
                                        <th rowspan="2">학과</th>
                                        <th rowspan="2">대표아이디</th>
                                        <th rowspan="2">학번</th>
                                        <th rowspan="2">이름</th>
                                        <th rowspan="2">평가점수</th>
                                        <th rowspan="2">피드백</th>
                                        <th colspan="2">참여상태</th>
                                        <th rowspan="2">참여일시</th>
                                        <th rowspan="2">평가여부</th>
                                        <th rowspan="2">관리</th>
                                    </tr>
                                    <tr>
                                        <th>
                                            <button class="btn type5 small">전체 참여</button>
                                        </th>
                                        <th>
                                            <button class="btn type8 small">전체 미참여</button>
                                        </th>
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
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="참여상태">
                                            <div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="attendStatus_1" id="attendY_1" value="Y" checked>
													<label for="attendY_1" class="mr0">참여</label>
												</span>
											</div>                                            
                                        </td>
                                        <td data-th="참여상태">
                                            <div class="form-inline">
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="attendStatus_1" id="attendN_1" value="N">
                                                    <label for="attendN_1" class="mr0">미참여</label>
                                                </span>                                            
                                            </div>
                                        </td>
                                        <td data-th="참여일시">2026.04.12 10:25</td>
                                        <td data-th="평가여부"><span class="fcRed">N</span></td>
                                        <td data-th="관리">
                                            <button class="btn basic small">참여관리/관리이력</button>
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
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="참여상태">
                                            <div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="attendStatus_2" id="attendY_2" value="Y">
													<label for="attendY_2" class="mr0">참여</label>
												</span>
											</div>                                            
                                        </td>
                                        <td data-th="참여상태">
                                            <div class="form-inline">
                                                <span class="custom-input ml5">
                                                    <input type="radio" name="attendStatus_2" id="attendN_2" value="N" checked>
                                                    <label for="attendN_2" class="mr0">미참여</label>
                                                </span>                                            
                                            </div>
                                        </td>
                                        <td data-th="참여일시">2026.04.12 10:25</td>
                                        <td data-th="평가여부">Y</td>
                                        <td data-th="관리">
                                            <button class="btn basic small">참여관리/관리이력</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--//table-type-->
                    </div>

                <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                <div class="modal-btn-box">
                    <button type="button" class="btn modal__btn" id="btn-modal1">참여관리/관리이력</button>
                </div>
                <!--// modal popup 보여주기 버튼(개발시 삭제) -->


                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //classroom-->


        <!-- Modal1 참여관리/관리이력 -->
        <div class="modal-overlay" id="modal1">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="board_top class">
                        <h3 class="board-title">
                            일한 번역연습01 1반
                            <span>세미나 일시 : 2026.09.30 10:00 / 50분 / 출결반영 : 예</span>
                        </h3>
                        <div class="right-area">
                            <div class="feedback-info">
                                <p class="desc">
                                    <span><strong>컴퓨터공학과</strong></span>
                                    <span><strong>9021582</strong></span>
                                    <span><strong>김주미</strong></span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- 참여 관리 -->
                    <div class="board_top">
                        <h5 class="sub-title-sm">참여 관리</h5>
                    </div>

                    <div class="table-wrap">
                        <table class="table-type2">
                            <thead>
                                <tr>
                                    <th>ZOOM 화상회의 진행시간</th>
                                    <th>참여일시</th>
                                    <th>참여시간</th>
                                    <th>참여상태</th>
                                    <th>참여관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="ZOOM 화상회의 진행시간">00:41:35</td>
                                    <td data-th="참여일시">2026.04.12 10:25</td>
                                    <td data-th="참여시간">00:35:25</td>
                                    <td data-th="참여상태">참여</td>
                                    <td data-th="참여관리">
                                        <div class="form-inline">
                                            <span class="custom-input">
                                                <input type="radio" name="attendStatus_3" id="attendY_3" value="Y" checked>
                                                <label for="attendY_3" class="mr0">참여</label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="attendStatus_3" id="attendN_3" value="N">
                                                <label for="attendN_3" class="mr0">미참여</label>
                                            </span>
                                        </div>                                        
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //참여 관리 -->

                    <!-- 참여 관리 이력 -->
                    <div class="board_top">
                        <h5 class="sub-title-sm">참여 관리 이력</h5>
                    </div>

                    <div class="table-wrap overflow-y">
                        <table class="table-type2">
                            <thead>
                                <tr>
                                    <th>디바이스</th>
                                    <th>IP</th>
                                    <th>시작일시</th>
                                    <th>종료일시</th>
                                    <th>참여시간</th>
                                    <th>참여구분</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td data-th="디바이스">PC</td>
                                    <td data-th="IP">210.211.23.245</td>
                                    <td data-th="시작일시">2026.08.12.18:11</td>
                                    <td data-th="종료일시">2026.08.12 19:00</td>
                                    <td data-th="참여시간">35:25</td>
                                    <td data-th="참여구분">참여상태 변경 : 참여</td>
                                </tr>
                                <tr>
                                    <td data-th="디바이스">PC</td>
                                    <td data-th="IP">210.211.23.245</td>
                                    <td data-th="시작일시">2026.08.12.18:11</td>
                                    <td data-th="종료일시">2026.08.12 19:00</td>
                                    <td data-th="참여시간">35:25</td>
                                    <td data-th="참여구분">참여상태 변경 : 참여</td>
                                </tr>
                                <tr>
                                    <td data-th="디바이스">PC</td>
                                    <td data-th="IP">210.211.23.245</td>
                                    <td data-th="시작일시">2026.08.12.18:11</td>
                                    <td data-th="종료일시">2026.08.12 19:00</td>
                                    <td data-th="참여시간">35:25</td>
                                    <td data-th="참여구분">참여상태 변경 : 참여</td>
                                </tr>
                                <tr>
                                    <td data-th="디바이스">PC</td>
                                    <td data-th="IP">210.211.23.245</td>
                                    <td data-th="시작일시">2026.08.12.18:11</td>
                                    <td data-th="종료일시">2026.08.12 19:00</td>
                                    <td data-th="참여시간">35:25</td>
                                    <td data-th="참여구분">참여상태 변경 : 참여</td>
                                </tr>
                                <tr>
                                    <td data-th="디바이스">PC</td>
                                    <td data-th="IP">210.211.23.245</td>
                                    <td data-th="시작일시">2026.08.12.18:11</td>
                                    <td data-th="종료일시">2026.08.12 19:00</td>
                                    <td data-th="참여시간">35:25</td>
                                    <td data-th="참여구분">참여상태 변경 : 참여</td>
                                </tr>
                                <tr>
                                    <td data-th="디바이스">PC</td>
                                    <td data-th="IP">210.211.23.245</td>
                                    <td data-th="시작일시">2026.08.12.18:11</td>
                                    <td data-th="종료일시">2026.08.12 19:00</td>
                                    <td data-th="참여시간">35:25</td>
                                    <td data-th="참여구분">참여상태 변경 : 참여</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //참여 관리 이력 -->

                    <!-- 메모 -->
                    <div class="board_top">
                        <h5 class="sub-title-sm">메모</h5>
                    </div>
                    <div class="form-row">
                        <textarea class="form-control" style="width:100%;height:100px" maxLenCheck="byte,1000,true,false" required="true"></textarea>
                    </div>

                    <!-- //메모 -->


                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //Modal1 참여관리/관리이력 -->

        <script>
            $(function() {
                // 1. 참여관리 / 관리이력
                $('#btn-modal1').on('click', function() {
                    
                    var $content = $('#modal1 .modal-body');

                    UiDialog("dialog1", {
                        title: "참여관리/관리이력",
                        width: 1200,
                        height: 600,
                        html: $content
                    });
                });
            });
        </script>

    </div>

</body>
</html>
