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
                <!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->

                    <div class="sub-content">

                        <div class="page-info">
                            <h2 class="page-title">과제</h2>
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
                                        <th><label for="assignmentTitle" class="req">과제명</label></th>
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
                                        <th><label for="assignmentContent" class="req">과제내용</label></th>
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
                                        <th><label for="submitStartDate" class="req">제출기간</label></th>
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
                                        <th><label for="gradeOpen_yes">성적공개</label></th>
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
                                        <th><label>연장제출</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="extend_yes" name="extendSubmission" value="Y" checked>
                                                    <label for="extend_yes">예</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="extend_no" name="extendSubmission" value="N">
                                                    <label for="extend_no">아니오</label>
                                                </span>
                                            </div>

                                            <!-- 연장제출 날짜 선택 -->
                                            <div id="extendDateArea" class="mt10" style="display:block;">
                                                <div class="custom-txt">
                                                    <span class="tit">제출 마감일시 :</span>
                                                    <input type="text" id="extendEndDate" class="datepicker" placeholder="연장 종료일">
                                                    <input type="text" id="extendEndTime" class="timepicker" placeholder="종료시간">
                                                </div>
                                            </div>
                                        </td>

                                        <script>
                                            // 연장제출 라디오 버튼 이벤트
                                            const extendYes = document.getElementById('extend_yes');
                                            const extendNo = document.getElementById('extend_no');
                                            const extendDateArea = document.getElementById('extendDateArea');

                                            function toggleExtendDateArea() {
                                                extendDateArea.style.display = extendYes.checked ? 'block' : 'none';
                                            }

                                            extendYes.addEventListener('change', toggleExtendDateArea);
                                            extendNo.addEventListener('change', toggleExtendDateArea);

                                            // 페이지 로드 시 초기 표시
                                            toggleExtendDateArea();
                                        </script>
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
                                                    <input type="radio" id="eval_rubric" name="evaluationMethod" value="rubric">
                                                    <label for="eval_rubric">루브릭</label>
                                                    <small class="note">(루브릭 선택시 루브릭 설정 팝업)</small>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="submissionType_file">제출형식</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="submissionType_file" name="submissionType" value="file" checked>
                                                    <label for="submissionType_file">파일</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="submissionType_text" name="submissionType" value="text">
                                                    <label for="submissionType_text">텍스트</label>
                                                </span>
                                            </div>

                                            <div class="sub_item" id="fileOptionArea">
                                                <div class="item">
                                                    <span class="custom-input">
                                                        <input type="radio" id="fileOption_all" name="fileOption" value="all" checked>
                                                        <label for="fileOption_all">모든 파일 가능</label>
                                                    </span>
                                                </div>

                                                <div class="item">
                                                    <span class="custom-input">
                                                        <input type="radio" id="fileOption_preview" name="fileOption" value="preview">
                                                        <label for="fileOption_preview">미리 보기 가능</label>
                                                    </span>
                                                    <div class="item-list" id="previewFileTypes" style="display:none;">
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="preview_image" name="previewTypes" value="image">
                                                            <label for="preview_image">이미지 (JPG, GIF, PNG)</label>
                                                        </span> &nbsp;
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="preview_pdf" name="previewTypes" value="pdf">
                                                            <label for="preview_pdf">PDF</label>
                                                        </span> &nbsp;
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="preview_text" name="previewTypes" value="text">
                                                            <label for="preview_text">TEXT</label>
                                                        </span> &nbsp;
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="preview_source" name="previewTypes" value="source">
                                                            <label for="preview_source">프로그램 소스</label>
                                                        </span>
                                                    </div>
                                                </div>

                                                <div class="item">
                                                    <span class="custom-input">
                                                        <input type="radio" id="fileOption_specific" name="fileOption" value="specific">
                                                        <label for="fileOption_specific">특정 파일 가능</label>
                                                    </span>
                                                    <div class="item-list" id="specificFileTypes" style="display:none;">
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="specific_hwp" name="specificTypes" value="hwp">
                                                            <label for="specific_hwp">HWP</label>
                                                        </span> &nbsp;
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="specific_doc" name="specificTypes" value="doc">
                                                            <label for="specific_doc">DOC</label>
                                                        </span> &nbsp;
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="specific_ppt" name="specificTypes" value="ppt">
                                                            <label for="specific_ppt">PPT</label>
                                                        </span> &nbsp;
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="specific_xls" name="specificTypes" value="xls">
                                                            <label for="specific_xls">XLS</label>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <script>
                                                const submissionFile = document.getElementById('submissionType_file');
                                                const submissionText = document.getElementById('submissionType_text');
                                                const fileOptionArea = document.getElementById('fileOptionArea');

                                                const fileOptionAll = document.getElementById('fileOption_all');
                                                const fileOptionPreview = document.getElementById('fileOption_preview');
                                                const fileOptionSpecific = document.getElementById('fileOption_specific');

                                                const previewFileTypes = document.getElementById('previewFileTypes');
                                                const specificFileTypes = document.getElementById('specificFileTypes');

                                                function toggleFileOptionArea() {
                                                    fileOptionArea.style.display = submissionFile.checked ? 'block' : 'none';
                                                    toggleFileSubOptions();
                                                }

                                                function toggleFileSubOptions() {
                                                    previewFileTypes.style.display = fileOptionPreview.checked ? 'block' : 'none';
                                                    specificFileTypes.style.display = fileOptionSpecific.checked ? 'block' : 'none';
                                                }

                                                submissionFile.addEventListener('change', toggleFileOptionArea);
                                                submissionText.addEventListener('change', toggleFileOptionArea);

                                                fileOptionAll.addEventListener('change', toggleFileSubOptions);
                                                fileOptionPreview.addEventListener('change', toggleFileSubOptions);
                                                fileOptionSpecific.addEventListener('change', toggleFileSubOptions);

                                                toggleFileOptionArea();
                                            </script>
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
                                        <th><label for="practicalAssignment_no">실기 과제</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="practicalAssignment_no" name="practicalAssignment" value="N" checked>
                                                    <label for="practicalAssignment_no">아니오</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="practicalAssignment_yes" name="practicalAssignment" value="Y">
                                                    <label for="practicalAssignment_yes">예</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="teamAssignment_no">팀 과제</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="teamAssignment_no" name="teamAssignment" value="N" checked>
                                                    <label for="teamAssignment_no">아니오</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="teamAssignment_yes" name="teamAssignment" value="Y">
                                                    <label for="teamAssignment_yes">예</label>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="individualAssignment_no">개별 과제</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input">
                                                    <input type="radio" id="individualAssignment_no" name="individualAssignment" value="N" checked>
                                                    <label for="individualAssignment_no">아니오</label>
                                                </span>
                                                <span class="custom-input ml5">
                                                    <input type="radio" id="individualAssignment_yes" name="individualAssignment" value="Y">
                                                    <label for="individualAssignment_yes">예</label>
                                                </span>
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
                                                            <label for="allowAssignmentRead_yes">과제 읽기 허용</label>
                                                        </th>
                                                        <td>
                                                            <div class="form-inline">
                                                                <span class="custom-input">
                                                                    <input type="radio" id="allowAssignmentRead_yes" name="allowAssignmentRead" value="Y" checked>
                                                                    <label for="allowAssignmentRead_yes">예</label>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" id="allowAssignmentRead_no" name="allowAssignmentRead" value="N">
                                                                    <label for="allowAssignmentRead_no">아니오</label>
                                                                </span>
                                                            </div>

                                                            <div class="custom-txt mt10" id="readAllowDateContainer">
                                                                <span class="tit">읽기 허용일 :</span>
                                                                <input type="text" id="readAllowDate" class="datepicker" placeholder="종료일">
                                                                <small class="note3">! 제출된 과제를 학습자 간에 읽을 수 있도록 설정 함 </small>
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
                            <button type="button" class="btn type2">이전과제 가져오기</button>
                            <button type="button" class="btn type2">목록</button>
                        </div>



                    </div>
                </div>


            </div>
            <!-- //content -->


        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

