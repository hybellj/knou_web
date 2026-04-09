<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
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
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->

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
                                                    <span>참여기간 :<strong>2026.09.30 10:00 ~ 2026.10.09 22:00</strong></span>
                                                    <span>성적반영 :<strong>예</strong></span>
                                                    <span>성적공개 :<strong>아니오</strong></span>
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
                                        <th>학과</th>
                                        <th>대표아이디</th>
                                        <th>학번</th>
                                        <th>이름</th>
                                        <th>평가점수</th>
                                        <th>피드백</th>
                                        <th>찬반</th>
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
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="찬반"><span class="fcPro">찬성</span></td>
                                        <td data-th="참여상태"><span class="fcNot">미참여</span></td>
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
                                        <td data-th="피드백"><a href="#0"><i class="xi-comment-o icon" aria-label="피드백"></i></a></td>
                                        <td data-th="찬반"><span class="fcCon">반대</span></td>
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

                    <!-- modal popup 보여주기 버튼(개발시 삭제) -->
                    <div class="modal-btn-box">
                        <button type="button" class="btn modal__btn" data-modal-open="modal1">일반토론: 피드백</button>
                        <button type="button" class="btn modal__btn" data-modal-open="modal2">토론현황 그래프</button>
                        <button type="button" class="btn modal__btn" data-modal-open="modal3">엑셀로 성적등록</button>
                    </div>
                    <!--// modal popup 보여주기 버튼(개발시 삭제) -->

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

