<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<style>
    /* 에디터 박스보다 위에 오도록 설정 */
    .editor-box {
        position: relative;
        z-index: 1; /* 에디터는 낮게 */
    }
</style>

<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="${
			templateUrl eq 'bbsHome' ? 'dashboard'
			: templateUrl eq 'bbsLect' ? 'classroom'
			: templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';
		var TEMPLATE_URL    = '<c:out value="${templateUrl}" />';

    	// 저장 버튼
    	function saveConfirm() {
			// 입력필드 검증
    		UiValidator("atclWriteForm")
    		.then(function(result) {
				if (result) {
					let dx = dx5.get("fileUploader");
					// 첨부파일 있으면 업로드
		    		if (dx.availUpload()) {
		    			dx.startUpload();
		    		}
					// 첨부파일 없으면 저장 호출
		    		else {
		    			atclSave();
		    		}
				}
			});
    	}

    	// 파일 업로드 완료
        function finishUpload() {
        	let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        	let dx = dx5.get("fileUploader");
        	let data = {
        		"uploadFiles" : dx.getUploadFiles(),
        		"uploadPath"  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			$("#uploadFiles").val(dx.getUploadFiles());

        	    	// 게시글 저장 호출
        	    	atclSave();
        		} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        		}
        	},
        	function(xhr, status, error) {
        		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        	});
        }

    	// 게시글 저장
    	function atclSave() {

    		// VO 필드명에 맞춰 가공된 값 세팅
            $("#optnSdttm").val(makeDateTimeStr("optnStartDate", "optnStartTime"));
            $("#optnEdttm").val(makeDateTimeStr("optnEndDate", "optnEndTime"));
            $("#rsrvSdttm").val(makeDateTimeStr("rsrvStartDate", "rsrvStartTime"));
            $("#rsrvEdttm").val(makeDateTimeStr("rsrvEndDate", "rsrvEndTime"));
            $("#autoAlimSdttm").val(makeDateTimeStr("autoAlimStartDate", "autoAlimStartTime"));
            $("#autoAlimEdttm").val(makeDateTimeStr("autoAlimEdttm", "autoAlimEndTime"));

    		var dx = dx5.get("fileUploader");
    		$("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

    		var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclSave.do";
    		var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclListView.do?eparam=${eparam}";
    		var data = $("#atclWriteForm").serialize();

    		bbsCommon.regist(url, returnUrl, data);
    	}

    	// 날짜+시간을 14자리 문자열로 합쳐주는 헬퍼 함수
        function makeDateTimeStr(dateId, timeId) {
            var dateVal = $("#" + dateId).val() || "";
            var timeVal = $("#" + timeId).val() || "";
            if (dateVal !== "") {
                // 숫자만 남기고 뒤에 "00"(초) 추가
                return (dateVal + timeVal).replace(/[^0-9]/g, "") + "00";
            }
            return "";
        }

    	// 목록화면 이동
    	function moveListPage() {
    		document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?eparam=${eparam}";
    	}

	</script>
</head>

<body class="class colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

			<!-- gnb -->
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
			<!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            	<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<div class="class_sub">

					<!-- 강의실 상단 -->
					<div class="segment class-area">

						<!-- info-left -->
						<div class="info-left">
							<div class="class_info">
                                <h2>${subjectVM.subjectVO.sbjctnm}</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="javascript:void(0); onclick=loadLctrPlandocPopView('${subjectVM.subjectVO.sbjctId}');" class="btn">강의 계획서</a>
                                        <a href="javascript:void(0); onclick=loadLessonProgressManage('${subjectVM.subjectVO.sbjctId}');" class="btn" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가 기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                	<c:forEach var="item" items="${subjectVM.subjectLearingActvList}">
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>공지</span><div class="num_txt">${item.ntcCnt}</div></a>
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>Q&A</span><div class="num_txt point">${item.qnaCnt}</div></a>
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>1:1</span><div class="num_txt point">${item.oneononeCnt}</div></a>
	                                    <a href="/asmt2/profAsmtListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>과제</span><div class="num_txt">${item.asmtCnt}</div></a>
	                                    <a href="/forum2/forumLect/profForumListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>토론</span><div class="num_txt">${item.dscsCnt}</div></a>
	                                    <a href="/smnr/profSmnrListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>세미나</span><div class="num_txt">${item.smnrCnt}</div></a>
	                                    <a href="/quiz/profQuizListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>퀴즈</span><div class="num_txt">${item.quizCnt}</div></a>
	                                    <a href="/srvy/profSrvyListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>설문</span><div class="num_txt">${item.srvyCnt}</div></a>
	                                    <a href="/exam/profExamListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>시험</span><div class="num_txt">${item.examCnt}</div></a>
                                    </c:forEach>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point">
                                            <span class="tit">중간고사:</span>
                                            <span><uiex:formatDate value="${subjectVM.middleLastExam.midExamSdttm}" type="date"/></span>
                                        </p>
                                        <p class="desc">
                                            <span class="tit">시간:</span>
                                            <span>${subjectVM.middleLastExam.midExamMnts}분</span>
                                        </p>
                                    </div>
                                    <div class="info">
                                        <p class="point">
                                            <span class="tit">기말고사:</span>
                                            <span><uiex:formatDate value="${subjectVM.middleLastExam.lstExamSdttm}" type="date"/></span>
                                        </p>
                                        <p class="desc">
                                            <span class="tit">시간:</span>
                                            <span>${subjectVM.middleLastExam.lstExamMnts}분</span>
                                        </p>
                                    </div>
                                </div>
                            </div>
						</div>
						<!--//info-left -->

						<!-- info-right-->
						<div class="info-right">

							<!-- flex -->
							<div class="flex">

								<!-- item user-->
								<div class="item user">
                                    <div class="item_icon"><i class="icon-svg-group" aria-hidden="true"></i></div>

                                    <!-- item_tit -->
                                    <div class="item_tit">
	                                    <a href="#0" class="btn ">접속현황<i class="xi-angle-down-min"></i></a><!-- 접속현황 -->

	                                    <!-- 접속현황레이어팝업-->
	                                    <div class="user-option-wrap">
	                                        <div class="option_head">
	                                            <div class="sort_btn">
	                                                <button type="button">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button><!-- 이름(학생명) -->
	                                                <button type="button">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button><!-- 이름(학생명) -->
	                                            </div>
	                                            <p class="user_num">접속: 37</p><!-- 접속 -->
	                                            <button type="button" class="btn-close" aria-label="접속현황 닫기"><!-- 접속현황닫기 -->
	                                                <i class="icon-svg-close"></i>
	                                            </button>
	                                        </div>
                                            <ul class="user_area"><!-- 현재접속자목록 li loop-->
                                                <li>
                                                    <div class="user-info">
                                                        <div class="user-photo">
                                                            <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"> <!-- 사진 -->
                                                        </div>
                                                        <div class="user-desc">
                                                            <p class="name">나방송</p>
                                                            <p class="subject"><span class="major">[대학원]</span>정보와기술</p> <!-- 대학원 --> <!-- 과목명 -->
                                                        </div>
                                                        <div class="btn_wrap">
                                                            <button type="button"><i class="xi-info-o"></i></button><!-- 정보 -->
                                                            <button type="button"><i class="xi-bell-o"></i></button><!-- 알림 -->
                                                        </div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="user-info">
                                                        <div class="user-photo">
                                                            <img src="/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                        </div>
                                                        <div class="user-desc">
                                                            <p class="name">최남단</p>
                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                        </div>
                                                        <div class="btn_wrap">
                                                            <button type="button"><i class="xi-info-o"></i></button>
                                                            <button type="button"><i class="xi-bell-o"></i></button>
                                                        </div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <div class="user-info">
                                                        <div class="user-photo">
                                                            <img src="/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                        </div>
                                                        <div class="user-desc">
                                                            <p class="name">최남단</p>
                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                        </div>
                                                        <div class="btn_wrap">
                                                            <button type="button"><i class="xi-info-o"></i></button>
                                                            <button type="button"><i class="xi-bell-o"></i></button>
                                                        </div>
                                                    </div>
                                                </li>
                                            </ul>

                                        </div>
                                        <!-- //접속현황레이어팝업-->
                                    </div>
                                    <!-- //item_tit -->

                                    <div class="item_info">
                                        <span class="big">37</span><!-- 현재접속자수 -->
                                        <span class="small">250</span><!-- 전체접속자수 -->
                                    </div>
                                </div>
                                <!-- //item user-->

								<div class="item attend">
                                    <div class="item_icon"><i class="icon-svg-pie-chart-01" aria-hidden="true"></i></div>
                                    <div class="item_tit">7주차 출석 40 / 50</div>
                                    <div class="item_info">
                                        <span class="big">80</span>
                                        <span class="small">%</span>
                                    </div>
                                </div>

								<div class="item week">
                                       <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                       <div class="item_tit">2025.04.14 ~ 04.20</div><!-- 주차기간 -->
                                       <div class="item_info">
                                           <span class="big">7</span><!-- 현재주차 -->
                                           <span class="small">주차</span><!-- 주차 -->
                                       </div>
                                </div>
							</div>
							<!-- //flex -->

						</div>
						<!-- info-right-->

					</div>

                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h4 class="sub-title">${bbsVO.bbsNm}</h4>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공통</li>
                                    <li><span class="current">레이아웃</span></li>
                                </ul>
                            </div>
                        </div>

                        <!--table-type-->
						<div class="table-wrap">
							<form id="atclWriteForm" name="atclWriteForm" onsubmit="return false;">
								<input type="hidden" name="eparam"       id="eparam"       value="${eparam}" />
								<input type="hidden" name="gubun"        id="gubun"        value="${bbsAtclVO.gubun}" />
								<input type="hidden" name="uploadFiles"  id="uploadFiles"  value="" />
								<input type="hidden" name="uploadPath"   id="uploadPath"   value="${bbsVO.uploadPath}" />
								<input type="hidden" name="atclId"       id="atclId"       value="${bbsAtclVO.atclId}"/>
								<input type="hidden" name="atclOptnId"   id="atclOptnId"   value="${bbsAtclVO.atclOptnId}">
								<input type="hidden" name="optnUseyn"    id="optnUseyn"    value="Y">
								<input type="hidden" name="delFileIdStr" id="delFileIdStr" value="" />

								<input type="hidden" name="optnSdttm" id="optnSdttm" />
							    <input type="hidden" name="optnEdttm" id="optnEdttm" />
							    <input type="hidden" name="rsrvSdttm" id="rsrvSdttm" />
							    <input type="hidden" name="rsrvEdttm" id="rsrvEdttm" />
							    <input type="hidden" name="autoAlimSdttm" id="autoAlimSdttm" />
							    <input type="hidden" name="autoAlimEdttm" id="autoAlimEdttm" />

							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
                                        <th><label for="haksa_label"><spring:message code="bbs.label.form_main_option"/></label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input"><input type="radio" name="optnCd" id="optnCdN" value="N" checked><label for="optnCdN"><spring:message code="bbs.label.na"/></label></span>
                                                <span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdI" value="I"><label for="optnCdI"><spring:message code="bbs.label.impt"/></label></span>
                                                <span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdF" value="F"><label for="optnCdF"><spring:message code="bbs.label.fix"/></label></span>
                                                <input type="text" placeholder="시작일" id="optnStartDate" name="optnStartDate" class="datepicker">
                                                <input type="text" placeholder="시작시간" id="optnStartTime" name="optnStartTime" class="timepicker">
                                                <span class="txt-sort">~</span>
                                                <input type="text" placeholder="종료일" id="optnEndDate" name="optnEndDate" class="datepicker">
                                                <input type="text" placeholder="종료시간" id="optnEndTime" name="optnEndTime" class="timepicker">
                                            </div>
                                        </td>
                                    </tr>
									<tr>
										<th><label for="atclTitle" class="req"><spring:message code="bbs.label.form_title" /></label><%-- 제목 --%></th>
										<td>
											<div class="form-row">
												<input type="text" id="atclTtl" name="atclTtl" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsAtclVO.atclTtl}" />
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="atclCts" class="req"><spring:message code="bbs.label.form_cts" /></label><%-- 내용 --%></th>
										<td data-th="입력">
											<li>
												<dl>
													<dd>
														<div class="editor-box">
															<label for="atclCts" class="hide">Content</label>
															<textarea id="atclCts" name="atclCts" required="true"><c:out value="${bbsAtclVO.atclCts}"/></textarea>
															<script>
																// HTML 에디터
																let editor = UiEditor({
																	targetId: "atclCts",
																	uploadPath: "${bbsVO.uploadPath}",
																	height: "500px"
																});
															</script>
														</div>
													</dd>
												</dl>
											</li>

										</section>
										<!--//섹션 에디터-->
										</td>
									</tr>
									<tr>
                                        <th><label><spring:message code="bbs.label.form_decls"/></label></th>
                                        <td>
                                            <div class="checkbox_type">
                                                <span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNoA" value="Y" required="true"><label for="dvclasNoA">전체</label></span>
                                                <c:forEach var="i" begin="1" end="4">
                                                    <span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNo${i}" value="${i}" required="true"><label for="dvclasNo${i}">${i}반</label></span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
									<tr>
										<th><label for="attchFile"><spring:message code="bbs.label.form_attach_file" /></label></th>
										<td>
											<uiex:dextuploader
												id="fileUploader"
												path="${bbsVO.uploadPath}"
												limitCount="5"
												limitSize="100"
												oneLimitSize="100"
												listSize="3"
												fileList="${bbsAtclVO.fileList}"
												finishFunc="finishUpload()"
												allowedTypes="*"
											/>
										</td>
									</tr>
									<tr>
                                        <th><label><spring:message code="bbs.label.form_sub_option"/></label></th>
                                        <td><div class="checkbox_type"><span class="custom-input"><input type="checkbox" name="cmntPrmyn" id="cmntPrmyn" value="Y"><label for="cmntPrmyn">댓글 사용</label></span></div></td>
                                    </tr>
                                    <tr>
                                            <th><label><spring:message code="bbs.label.form_write_resv"/></label></th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="checkbox" id="rsrvyn" name="rsrvyn" class="switch yesno" value="Y">
                                                    <input type="text" id="rsrvStartDate" name="rsrvStartDate" class="datepicker">
                                                    <input type="text" id="rsrvStartTime" name="rsrvStartTime" class="timepicker">
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" id="rsrvEndDate" name="rsrvEndDate" class="datepicker">
                                                    <input type="text" id="rsrvEndTime" name="rsrvEndTime" class="timepicker">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_public_yn"/></label></th>
                                            <td><div class="form-row"><input type="checkbox" id="oyn" name="oyn" class="switch yesno" value="Y"></div></td>
                                        </tr>
                                        <tr>
                                            <th><label>공지사항 구분</label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <span class="custom-input"><input type="radio" name="ntcGbncd" id="ntcGbncdY" value="Y" checked><label for="ntcGbncdY">일반 공지</label></span>
                                                    <span class="custom-input ml5"><input type="radio" name="ntcGbncd" id="ntcGbncdN" value="N"><label for="ntcGbncdN">긴급 공지</label></span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><label><spring:message code="bbs.label.form_auto_alim"/></label></th>
                                            <td>
                                                <div class="date_area">
                                                    <input type="checkbox" id="autoAlimyn" name="autoAlimyn" class="switch yesno" value="Y">
                                                    <input type="text" id="autoAlimStartDate" name="autoAlimStartDate" class="datepicker">
                                                    <input type="text" id="autoAlimStartTime" name="autoAlimStartTime" class="timepicker">
                                                    <span class="txt-sort">~</span>
                                                    <input type="text" id="autoAlimEndDate" name="autoAlimEndDate" class="datepicker">
                                                    <input type="text" id="autoAlimEndTime" name="autoAlimEndTime" class="timepicker">
                                                </div>
                                            </td>
                                        </tr>
								</tbody>
							</table>
							</form>
						</div>

						<div class="btns">
                            <button type="button" class="btn type1" onclick="saveConfirm()"><spring:message code="common.button.save" /></button><%-- 저장 --%>
                            <button type="button" class="btn type2" onclick="moveListPage()"><spring:message code="common.button.cancel" /></button><%-- 취소 --%>
                        </div>
                    </div>

                </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>