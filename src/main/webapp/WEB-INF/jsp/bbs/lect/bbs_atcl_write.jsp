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
		var BBS_ID 		 = '<c:out value="${bbsAtclVO.bbsId}" />';
		var ATCL_ID      = '<c:out value="${bbsAtclVO.atclId}" />';
		var TEMPLATE_URL = '<c:out value="${templateUrl}" />';
		var MODE         = '<c:out value="${bbsAtclVO.gubun == 'edit' ? 'U' : 'C'}" />';

		$(document).ready(function() {
			if(MODE == 'U') {
                bbsAtclModifyForm();
            }
		});

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
            $("#autoAlimEdttm").val(makeDateTimeStr("autoAlimEndDate", "autoAlimEndTime"));

    		var dx = dx5.get("fileUploader");
    		$("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

    		var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclSave.do";
    		var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclListView.do?encParams=${encParams}";
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
    		document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?encParams=${encParams}";
    	}

    	function bbsAtclModifyForm() {
            var url  = "/bbs/" + TEMPLATE_URL + "/bbsAtclDtlView.do";
            var data = { bbsId : BBS_ID, atclId : ATCL_ID };

            ajaxCall(url, data, function(data) {
                if(data.result > 0 && data.returnVO) {
                    var vo = data.returnVO;

                    // 주요 옵션
                    if(vo.optnCd === 'IMPT') {
						$("#optnCdI").prop("checked", true);
					} else if(vo.optnCd === 'FIX') {
						$("#optnCdF").prop("checked", true);
					} else {
						$("#optnCdN").prop("checked", true);
					}

					// 주요 옵션 일자
                    setSplitDateTime(vo.optnSdttm, 'optnStartDate', 'optnStartTime');
                    setSplitDateTime(vo.optnEdttm, 'optnEndDate', 'optnEndTime');

                    // 제목
                    $("#atclTtl").val(vo.atclTtl);

                    // 내용
                    editor.openHTML(vo.atclCts);

                    if(vo.fileList && vo.fileList.length > 0) {
                        setTimeout(function(){
                            var dx = dx5.get("fileUploader");
                            dx.addCopyFiles(vo.fileList);
                        }, 500);
                    }

					// 분반 일괄등록
					var i = vo.dvclasNo;
					$("#dvclasNo"+i).prop("checked", true);

					// 부가옵션 - 댓글 사용
                    if(vo.cmntPrmyn === "Y") {
						$("#cmntPrmyn").prop("checked", true);
                    }

					// 등록 예약
                    if(vo.rsrvyn === "Y") {
					    $("#rsrvyn").prop("checked", true);
					    $("#sw_rsrvyn").attr("aria-checked", "true").addClass("ui-switcher-on");
					}

					// 등록 예약 일자
                    setSplitDateTime(vo.rsrvSdttm, 'rsrvStartDate', 'rsrvStartTime');
                    setSplitDateTime(vo.rsrvEdttm, 'rsrvEndDate', 'rsrvEndTime');

                    // 공개여부
                    if(vo.oyn === "Y") {
						$("#oyn").prop("checked", true);
						$("#sw_oyn").attr("aria-checked", "true").trigger("change");
					}

                    // 공지사항 구분
                    if(vo.ntcGbncd === "Y") {
						$("#ntcGbncdY").prop("checked", true);
                    } else {
                    	$("#ntcGbncdN").prop("checked", true);
                    }

                    // 자동 알림 예약 등록
                    if(vo.autoAlimyn === "Y") {
						$("#autoAlimyn").prop("checked", true);
						$("#sw_autoAlimyn").attr("aria-checked", "true").trigger("change");
					}

                    // 자동 알림 예약 등록 일자
                    setSplitDateTime(vo.autoAlimSdttm, 'autoAlimStartDate', 'autoAlimStartTime');
                    setSplitDateTime(vo.autoAlimEdttm, 'autoAlimEndDate', 'autoAlimEndTime');
                }
            });
        }

    	function setSplitDateTime(fullStr, dateInputId, timeInputId) {
            if (!fullStr || fullStr.length !== 14) return;
            if (dateInputId) document.getElementById(dateInputId).value = fullStr.substring(0, 8);
            if (timeInputId) document.getElementById(timeInputId).value = fullStr.substring(8, 14);
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

					<!-- 강의실 상단 -->
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
								<input type="hidden" name="bbsTycd"      id="bbsTycd"    value="NTC" /> <!-- 임시 -->
								<input type="hidden" name="encParams"    id="encParams"    value="${encParams}" />
								<input type="hidden" name="gubun"        id="gubun"        value="${bbsAtclVO.gubun}" />
								<input type="hidden" name="uploadFiles"  id="uploadFiles"  value="" />
								<input type="hidden" name="uploadPath"   id="uploadPath"   value="${bbsVO.uploadPath}" />
								<input type="hidden" name="atclId"       id="atclId"       value="${bbsAtclVO.atclId}"/>
								<input type="hidden" name="atclOptnId"   id="atclOptnId"   value="${bbsAtclVO.atclOptnId}">
								<input type="hidden" name="sbjctId"      id="sbjctId"      value="${bbsAtclVO.sbjctId}">
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
            <!-- //content -->
        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>